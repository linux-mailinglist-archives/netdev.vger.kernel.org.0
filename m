Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F8C4DC4F9
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 12:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbiCQLoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 07:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiCQLoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 07:44:15 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EECF21829
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 04:42:59 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id g20so6202428edw.6
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 04:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=elpriMCxab4LNrA0h+PxZhhIIh97faPvGKIznTIKsBA=;
        b=n5xChnWC6F0PUKPQrpHuFKPz6WJz64iwh1XinpmD4M4dYvXUiVgX9eV/FbXeH0+suc
         8mGDZueqHdoxcO33Eyf1U4qUz9sc8t8uEX1ZxKhsWkbWI0q2kGX9wROL+LQC/xHMg+5I
         iVv9aWlRwhMr1fIkIwM5v0IGqa5Nny3RAnSpIF9Nh5XhBTPy3RxyE9L3v2v5D77I8xrX
         dmM+jBEgdLjvQFiMyD8FvAWDP8An0HDTrFJWrrMUMEQF0d8kCP3YgSRvyZzjucAuzX1S
         ghrq/2jJixankWurkyBtPAyo6arcxKqb+O+ocpStPXbjGqe1nQH1RHbB5qFGqsrGibcC
         scPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=elpriMCxab4LNrA0h+PxZhhIIh97faPvGKIznTIKsBA=;
        b=tz6KulXoiE8Rk/r+r7ERrgPaFG81AZ7MPZetBOvoLu5JyIIHK0Ej4KUSy8m7iPPi46
         Jex34S/ewHJcmypDs4qFZvpyVHgWJZ7+8qiaD2+vJYMeyB4ll+DIccd8wkdEhG528iTm
         ZjALGFvckMlLTPeuFscpAnOO44IgbuUboxynzVwHyVsZNH56UE5YxBmV+krJMlCGvrIU
         8QWbBL4FK0EvsBSxS5wpLhrNE5QkNFeTL1HH0laOJIElF8tX0lKviGfP79pqwHv1embG
         FU6iNscB2ykADbSHshUBnAdONincMAoVKz8JMd7wmmLO5Pq2HdaKPAHNGkjpCq5ukN6D
         HfYw==
X-Gm-Message-State: AOAM532ZZHdE4Lu80NQ46A9XGV2o7hykCyurHyk5+L1arDRcTJQAzhfe
        1B9kVwoC0EZDqHCErYKb5ot4Lg==
X-Google-Smtp-Source: ABdhPJyrXyvSZmVGHVXUsdba+NtTaz2H2YfTy3PdI6CtNABm4mgT/M/xM2JCluPjecxl0AEUk1sjmg==
X-Received: by 2002:a05:6402:50cf:b0:418:ee57:ed9 with SMTP id h15-20020a05640250cf00b00418ee570ed9mr3926533edb.37.1647517377437;
        Thu, 17 Mar 2022 04:42:57 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id z22-20020a17090655d600b006d229436793sm2247161ejp.223.2022.03.17.04.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 04:42:57 -0700 (PDT)
Message-ID: <cf7af730-1f98-f845-038b-43104fa060cd@blackwall.org>
Date:   Thu, 17 Mar 2022 13:42:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/5] net: bridge: Implement bridge flood flag
Content-Language: en-US
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
 <20220317065031.3830481-3-mattias.forsblad@gmail.com>
 <87r1717xrz.fsf@gmail.com> <50f4e8b0-4eea-d202-383b-bf2c2824322d@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <50f4e8b0-4eea-d202-383b-bf2c2824322d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/03/2022 13:39, Mattias Forsblad wrote:
> On 2022-03-17 10:07, Joachim Wiberg wrote:
>> On Thu, Mar 17, 2022 at 07:50, Mattias Forsblad <mattias.forsblad@gmail.com> wrote:
>>> This patch implements the bridge flood flags. There are three different
>>> flags matching unicast, multicast and broadcast. When the corresponding
>>> flag is cleared packets received on bridge ports will not be flooded
>>> towards the bridge.
>>
>> If I've not completely misunderstood things, I believe the flood and
>> mcast_flood flags operate on unknown unicast and multicast.  With that
>> in mind I think the hot path in br_input.c needs a bit more eyes.  I'll
>> add my own comments below.
>>
>> Happy incident I saw this patch set, I have a very similar one for these
>> flags to the bridge itself, with the intent to improve handling of all
>> classes of multicast to/from the bridge itself.
>>
>>> [snip]
>>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
>>> index e0c13fcc50ed..fcb0757bfdcc 100644
>>> --- a/net/bridge/br_input.c
>>> +++ b/net/bridge/br_input.c
>>> @@ -109,11 +109,12 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>>>  		/* by definition the broadcast is also a multicast address */
>>>  		if (is_broadcast_ether_addr(eth_hdr(skb)->h_dest)) {
>>>  			pkt_type = BR_PKT_BROADCAST;
>>> -			local_rcv = true;
>>> +			local_rcv = true && br_opt_get(br, BROPT_BCAST_FLOOD);
>>
>> Minor comment, I believe the preferred style is more like this:
>>
>> 	if (br_opt_get(br, BROPT_BCAST_FLOOD))
>>         	local_rcv = true;
>>
>>>  		} else {
>>>  			pkt_type = BR_PKT_MULTICAST;
>>> -			if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
>>> -				goto drop;
>>> +			if (br_opt_get(br, BROPT_MCAST_FLOOD))
>>> +				if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
>>> +					goto drop;
>>
>> Since the BROPT_MCAST_FLOOD flag should only control uknown multicast,
>> we cannot bypass the call to br_multicast_rcv(), which helps with the
>> classifcation.  E.g., we want IGMP/MLD reports to be forwarded to all
>> router ports, while the mdb lookup (below) is what an tell us if we
>> have uknown multicast and there we can check the BROPT_MCAST_FLOOD
>> flag for the bridge itself.
> 
> The original flag was name was local_receive to separate it from being
> mistaken for the flood unknown flags. However the comment I've got was
> to align it with the existing (port) flags. These flags have nothing to do with
> the port flood unknown flags. Imagine the setup below:
> 
>            vlan1
>              |
>             br0             br1
>            /   \           /   \
>          swp1 swp2       swp3 swp4
> 
> We want to have swp1/2 as member of a normal vlan filtering bridge br0 /w learning on. 
> On br1 we want to just forward packets between swp3/4 and disable learning. 
> Additional we don't want this traffic to impact the CPU. 
> If we disable learning on swp3/4 all traffic will be unknown and if we also 
> have flood unknown on the CPU-port because of requirements for br0 it will
> impact the traffic to br1. Thus we want to restrict traffic between swp3/4<->CPU port
> with the help of the PVT.
> 
> /Mattias

The feedback was correct and we all assumed unknown traffic control.
If you don't want any local receive then use filtering rules. Don't add unnecessary flags.
