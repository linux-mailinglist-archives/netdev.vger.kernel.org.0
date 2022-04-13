Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594214FF2B1
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbiDMIxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234403AbiDMIxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:53:40 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416CD37A09
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 01:51:18 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id o16so1347784ljp.3
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 01:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=F5SJAe2UiUjFV9fYjeVsnnxEIaa42rdLYEILkbvUZeQ=;
        b=bJiSnl0C+kDQnzduB0+4ZBVeclsximk3wH3kFDKEsVhwKyuKKH445EoyYcMUmyh2Dr
         1NV/hG8UvJGNGY3LV6o3tq0RoownLEylU/HY+5lTz+58lugJdWeexD/81HFJQs+kHHcb
         ZO09jiQGlj9gDe6RkBLCzoIhGxvdVHSjRZntGFwjjdFuNSBNM4Kk6LXR+a1HhrBcIosz
         HBJsl76m8E/tVZZhVp5We8zkX7RSJpOnLcURwNUW3hyXbK78UR/DD1uyiRIk4xlDNcb2
         tLlvgFFAyCYfGozmxn6w4hu1aK8ncXWds3i40PxGEwNuYYVSIER/18Qeiz4oqnLNmESp
         SJRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=F5SJAe2UiUjFV9fYjeVsnnxEIaa42rdLYEILkbvUZeQ=;
        b=tn6eLiALoOHErQDf1l3QEmk3txEELAGq/bDL5jrQ/nDwq99S2/orL2b9Q3lRr3kv6j
         1jD+XkV9KaFOX3NhXYT12Rd9tc+cV1kmHs6gUmHhI9wLSnbRmHFo3MLNFa4V+264X1jL
         HvG3AjnGWoVPr/pV+hspQL9P1xyNJgCF0DsRplfXQfAm2oVPTpzdBQlLGU7PbLckncZO
         IihQz6HffV7YgRW+nJGZd5fJrqcKd5JZQtnRnXFGHuStpt6TPgm5MOB4UCYzfMDnSoCs
         gEuTetmEMx6XHrFSbaH1e9mHU9GyIAFoVzNhqN2iQb6n6awJbs0naKYZV6KDa35pMnWy
         6LFg==
X-Gm-Message-State: AOAM532ZkJvbvbmpbnO97ytGjLF09c8nvHo11/MQhFPKfFx2TZsYsnWb
        rqNuUI6moNjAVRhsE6J1UQvMHkdv0RRWJQ==
X-Google-Smtp-Source: ABdhPJy6t4E3aGHbZiUfduz3hnannFgK4e9u3WUCJ2jrbrIgJu6U+yz2vdB7OMj+AGYgI74MJf9nXQ==
X-Received: by 2002:a2e:bd13:0:b0:246:1ff8:6da1 with SMTP id n19-20020a2ebd13000000b002461ff86da1mr25758425ljq.219.1649839876327;
        Wed, 13 Apr 2022 01:51:16 -0700 (PDT)
Received: from wbg (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id x40-20020a056512132800b004489691436esm4046927lfu.146.2022.04.13.01.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 01:51:15 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RFC net-next 08/13] net: bridge: avoid classifying unknown multicast as mrouters_only
In-Reply-To: <5d597756-2fe1-e7cc-9ef3-c0323e2274f2@blackwall.org>
References: <20220411133837.318876-1-troglobit@gmail.com> <20220411133837.318876-9-troglobit@gmail.com> <ebd182a2-20bc-471c-e649-a2689ea5a5d1@blackwall.org> <87v8ve9ppr.fsf@gmail.com> <5d597756-2fe1-e7cc-9ef3-c0323e2274f2@blackwall.org>
Date:   Wed, 13 Apr 2022 10:51:14 +0200
Message-ID: <87pmll9xj1.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 20:37, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> On 12/04/2022 20:27, Joachim Wiberg wrote:
>> [snip]
>> From this I'd like to argue that our current behavior in the bridge is
>> wrong.  To me it's clear that, since we have a confiugration option, we
>> should forward unknown IP multicast to all MCAST_FLOOD ports (as well as
>> the router ports).
> Definitely not wrong. In fact:
> "Switches that do not forward unregistered packets to all ports must
>  include a configuration option to force the flooding of unregistered
>  packets on specified ports. [..]"
> is already implemented because the admin can mark any port as a router and
> enable flooding to it.

Hmm, I understand your point (here and below), and won't drive this
point further.  Instead I'll pick up on what you said in your first
reply ... (below, last)

Btw, thank you for taking the time to reply and explain your standpoint,
really helps my understanding of how we can develop the bridge further,
without breaking userspace! :)

>> [1]: https://www.rfc-editor.org/rfc/rfc4541.html#section-2.1.2
> RFC4541 is only recommending, it's not a mandatory behaviour. This
> default has been placed for a very long time and a lot of users and
> tests take it into consideration.

Noted.

> We cannot break such assumptions and start suddenly flooding packets,
> but we can leave it up to the admin or distribution/network software
> to configure it as default.

So, if I add a bridge flag, default off as you mentioned out earlier,
which changes the default behavior of MCAST_FLOOD, then you'd be OK with
that?  Something cheeky like this perhaps:

    if (!ipv4_is_local_multicast(ip_hdr(skb)->daddr))
       	BR_INPUT_SKB_CB(skb)->mrouters_only = !br_opt_get(br, BROPT_MCAST_FLOOD_RFC4541);


Best regards
 /Joachim
