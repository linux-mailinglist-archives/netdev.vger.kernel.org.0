Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53DD4FE74D
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358482AbiDLRk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358498AbiDLRkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:40:22 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C61A62BE5
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:38:02 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id t25so10575331edt.9
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SuC5RiFfkwX9myE0wNWiGRa7nHKCHfIZUYphgXOL2/g=;
        b=AjS47ErAH5JvMOawIWhBHjxgn6AKW18TcQ/WbkEe8po7PMMHNFvGVMHyNZYDnNpg7J
         jSPaY07X50r5gQlrUl9XaoFZGXggC3TMJfzg5oGGsYKemxNe3SXKgXfgdmHcEbcwmvRi
         38VNYzUN3AulcCeuAdpaStsyEQrONSJiU8lwoHZMpl9u2VwVYqaaLJeH9J+nmu1eg9Pw
         kcUDpYpeEvYds73PEVrhKV7kD8Pn5NM7WilM8O49HZWr87V0LaYljixdVfD64DbCDG3/
         F6KXKWUcx4aKcATCLTf2dC29XdP5fWZiWkUzzL3I26vdAaU1U3f4eQdG6CKzs5KSVn/s
         LZ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SuC5RiFfkwX9myE0wNWiGRa7nHKCHfIZUYphgXOL2/g=;
        b=X9MQ4FbU7V8pMCt+cvxCRDSvzJtCjlMVGc1/k2YUQM8h6hE5nzvs8ZBA7K+DfkzJqg
         sDRkVSVcurqz4PMN7Z3cbC/Gyhl4WJfpbhEthkYttUnuAurdGBQkpRXtZ/HFYB2zjmSU
         5Mj/0PYuGMPY6zORrlnqYg4dSjB9ygwrYbpoqL879w/xZ6a2pFCZdhULWQLAIw9R7rTs
         GnQCxQqsxJaK4a1BLBhwnUj0LnyeFkxrNBjKVi3yd7yxB3W82B1I60NfO7ZDfD7z/uBn
         sYbOyFnmgzNlFItgYaE8llnE7B7k2yoDGKFbYZY0H6F1ZgKi833HTSz3dewqVH6hIoxX
         YT7A==
X-Gm-Message-State: AOAM53277AoNjKYohS2YVN2lW+K0xNo25W/5nezi2k36m4nbgIsXaWkw
        oy474dAIouHBJ2KAskpj8Gttg8kJEjAP7dkc
X-Google-Smtp-Source: ABdhPJyjNPPcXZgxcqKmVczz/pa5CBQ/QIhRILKTwqZSMuKFi4QYdx3urMwvdRjECANV+ewpt1gy+g==
X-Received: by 2002:a05:6402:5186:b0:419:651e:5137 with SMTP id q6-20020a056402518600b00419651e5137mr40464594edd.335.1649785080396;
        Tue, 12 Apr 2022 10:38:00 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id lx17-20020a170906af1100b006e873dd9228sm4095506ejb.52.2022.04.12.10.37.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 10:38:00 -0700 (PDT)
Message-ID: <5d597756-2fe1-e7cc-9ef3-c0323e2274f2@blackwall.org>
Date:   Tue, 12 Apr 2022 20:37:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RFC net-next 08/13] net: bridge: avoid classifying unknown
 multicast as mrouters_only
Content-Language: en-US
To:     Joachim Wiberg <troglobit@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220411133837.318876-1-troglobit@gmail.com>
 <20220411133837.318876-9-troglobit@gmail.com>
 <ebd182a2-20bc-471c-e649-a2689ea5a5d1@blackwall.org>
 <87v8ve9ppr.fsf@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <87v8ve9ppr.fsf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/04/2022 20:27, Joachim Wiberg wrote:
> 
> Hi Nik,
> 
> and thank you for taking the time to respond!
> 
> On Tue, Apr 12, 2022 at 16:59, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>> On 11/04/2022 16:38, Joachim Wiberg wrote:
>>> Unknown multicast, MAC/IPv4/IPv6, should always be flooded according to
>>> the per-port mcast_flood setting, as well as to detected and configured
>>> mcast_router ports.
> 
> I realize I should've included a reference to RFC4541 here.  Will add
> that in the non-RFC patch.
> 
>>> This patch drops the mrouters_only classifier of unknown IP multicast
>>> and moves the flow handling from br_multicast_flood() to br_flood().
>>> This in turn means br_flood() must know about multicast router ports.
>> If you'd like to flood unknown mcast traffic when a router is present please add
>> a new option which defaults to the current state (disabled).
> 
> I don't think we have to add another option, because according to the
> snooping RFC[1], section 2.1.2 Data Forwarding Rules:
> 
>  "3) [..] If a switch receives an unregistered packet, it must forward
>   that packet on all ports to which an IGMP[2] router is attached.  A
>   switch may default to forwarding unregistered packets on all ports.
>   Switches that do not forward unregistered packets to all ports must
>   include a configuration option to force the flooding of unregistered
>   packets on specified ports. [..]"
> 
> From this I'd like to argue that our current behavior in the bridge is
> wrong.  To me it's clear that, since we have a confiugration option, we
> should forward unknown IP multicast to all MCAST_FLOOD ports (as well as
> the router ports).

Definitely not wrong. In fact:
"Switches that do not forward unregistered packets to all ports must
 include a configuration option to force the flooding of unregistered
 packets on specified ports. [..]"

is already implemented because the admin can mark any port as a router and
enable flooding to it.

> 
> Also, and more critically, the current behavior of offloaded switches do
> forwarding like this already.  So there is a discrepancy currently
> between how the bridge forwards unknown multicast and how any underlying
> switchcore does it.
> 
> Sure, we'll break bridge behavior slightly by forwarding to more ports
> than previous (until the group becomes known/registered), but we'd be
> standards compliant, and the behavior can still be controlled per-port.
> 
> [1]: https://www.rfc-editor.org/rfc/rfc4541.html#section-2.1.2
> [2]: Section 3 goes on to explain how this is similar also for MLD
> 

RFC4541 is only recommending, it's not a mandatory behaviour. This default has been placed
for a very long time and a lot of users and tests take it into consideration.
We cannot break such assumptions and start suddenly flooding packets, but we can
leave it up to the admin or distribution/network software to configure it as default.

>>> diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
>>> index 02bb620d3b8d..ab5b97a8c12e 100644
>>> --- a/net/bridge/br_forward.c
>>> +++ b/net/bridge/br_forward.c
>>> @@ -199,9 +199,15 @@ static struct net_bridge_port *maybe_deliver(
>>>  void br_flood(struct net_bridge *br, struct sk_buff *skb,
>>>  	      enum br_pkt_type pkt_type, bool local_rcv, bool local_orig)
>>>  {
>>> +	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
>> Note this breaks per-vlan mcast. You have to use the inferred mctx.
> 
> Thank you, this was one of the things I was really unsure about since
> the introduction of per-VLAN support.  I'll extend the prototype and
> include the brmctx from br_handle_frame_finish().  Thanks!
> 
> Best regards
>  /Joachim

