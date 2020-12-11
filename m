Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE512D8039
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 21:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391336AbgLKUv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 15:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389467AbgLKUvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 15:51:09 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24F5C0613CF
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 12:50:28 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id y22so12408942ljn.9
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 12:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=bWKBY6eCdqYVsy1mT+KxGITPCRlfrMFiYcmnvTBSqGk=;
        b=f27HFGtLwAHrJEEESNqcbGzsbMMYfsrRysKGbxTFZaDxuoOIiF+VQmc8vKCPs4NMZ7
         IPUR3xcSbbRvxUWWXVoADJVVYKiID4HBs90ADZc8zdL2j+x4dnZdKx/MM3fdUfHr9xk4
         BqXI1Dcr/MqhZD2fCv2D0IfgZwAnK9Zf3iFlyDEarjTHxzWv9SRX4DelkTZGCuP+qWew
         QBe3BLniWiZyz6QxQ/16YlPs4plCm8tMKFiI/07tJONXvJpdFOMxwBykXPxEXy6gmgZF
         G46z3H3OM7pMVDB4nr2Gl7l93thpuVjsKvJd/mL4sUBFBjclcRkzZoEOsZsJt1rlN7sg
         hEyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=bWKBY6eCdqYVsy1mT+KxGITPCRlfrMFiYcmnvTBSqGk=;
        b=VwCFciJtnYSO7A5iMgGv56agC2VPr6kw7LIfIbfROq2J8pHuHcE4GTJ0KPaKvWCMBJ
         YixRBUhYPLkl8DhS2tzbeIjeDof1MQ+FGpYkFcD0QOhDwYQgePdwJYs2KA27uiXXPNqm
         USZkCJKUn+GiFo8sbaj+DaV5OIyP5ORJmYqqpjgPwhCGzWr9uz9FRA2ADfUvIiY96EcL
         zrzyBE/mmMBi4fyOwL/2ECR0FqE60+HlWfsltL9NdGOUfwe3mVRGe2dYKSlz4e3x2b80
         zmC/uGf1XFyB3PMIAixKUXfN0zOQLpoe/40vZwjw+8HpsqpPiH1nobDH/EHjbYcHgtCa
         96aA==
X-Gm-Message-State: AOAM530v/G//DMThOHzRaW8tQ/UtJfpJIcD22m2hBqAUaCGkuWfjOtqa
        /ljoabLt7pIO0dVT1EKibxWjryVvGBx3GAy2
X-Google-Smtp-Source: ABdhPJzgQ4UZ2G4tSDQra2klKlwrb1Ab9JyINfdwEMN0qar2sahkSbN9Y/Q5RjFt0wV1M31XqQ3X+Q==
X-Received: by 2002:a2e:8346:: with SMTP id l6mr5840901ljh.132.1607719826809;
        Fri, 11 Dec 2020 12:50:26 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id w204sm1003263lff.241.2020.12.11.12.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 12:50:25 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201208112350.kuvlaxqto37igczk@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201208112350.kuvlaxqto37igczk@skbuf>
Date:   Fri, 11 Dec 2020 21:50:24 +0100
Message-ID: <87a6uk5apb.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 13:23, Vladimir Oltean <olteanv@gmail.com> wrote:
> Sorry it took so long. I wanted to understand:
> (a) where are the challenged for drivers to uniformly support software
>     bridging when they already have code for bridge offloading. I found
>     the following issues:
>     - We have taggers that unconditionally set skb->offload_fwd_mark = 1,
>       which kind of prevents software bridging. I'm not sure what the
>       fix for these should be.

I took a closer look at the software fallback mode for LAGs and I've
found three issues that prevent this from working in a bridged setup,
two of which are easy to fix. This is the setup (team0 is _not_
offloaded):

(A)  br0
     /
  team0
   / \
swp0 swp1


1. DSA tries to offload port attributes for standalone ports. So in this
   setup, if vlan filtering is enabled on br0, we will enable it in
   hardware which on mv88e6xxx causes swp0/1 to drop all packets on
   ingress due to a VTU violation. This is a very easy fix, I will
   include it in v4.

2. The issue Vladimir mentioned above. This is also a straight forward
   fix, I have patch for tag_dsa, making sure that offload_fwd_mark is
   never set for ports in standalone mode.

   I am not sure if I should solve it like that or if we should just
   clear the mark in dsa_switch_rcv if the dp does not have a
   bridge_dev. I know both Vladimir and I were leaning towards each
   tagger solving it internally. But looking at the code, I get the
   feeling that all taggers will end up copying the same block of code
   anyway. What do you think?

With these two patches in place, setup (A) works as expected. But if you
extend it to (team0 still not offloaded):

(B)   br0
     /   \
  team0   \
   / \     \
swp0 swp1  swp2

You instantly run into:

3. Only traffic which does _not_ have offload_fwd_mark set is allowed to
   pass from swp2 to team0. This is because the bridge uses
   dev_get_port_parent_id to figure out which ports belong to the same
   switch. This will recurse down through all lowers and find swp0/1
   which will answer with the same ID as swp2.

   In the case where team0 is offloaded, this is exactly what we want,
   but in a setup like (B) they do not have the same "logical" parent in
   the sense that br0 is led to believe. I.e. the hardware will never
   forward packets between swp0/1 and swp2.

   I do not see an obvious solution to this. Refusing to divulge the
   parent just because you are a part of a software LAG seems fraught
   with danger as there are other users of those APIs. Adding yet
   another ndo would theoretically be possible, but not
   desirable. Ideas?

As for this series, my intention is to make sure that (A) works as
intended, leaving (B) for another day. Does that seem reasonable?

NOTE: In the offloaded case, (B) will of course also be supported.
