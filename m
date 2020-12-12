Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D090A2D8714
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 15:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439157AbgLLO1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 09:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgLLO1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 09:27:07 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C000FC0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 06:26:26 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id ga15so16338922ejb.4
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 06:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zkg5d2FM4DVK47gyLvuf++k/Q1InesIH8WY8IADpoH4=;
        b=R+BPxYZsVLQ+Bo6mi9qh6AU1FqQUQgF80VWHie17C2cZyHcoCm3DCwJ/2pGqW8TAXo
         RAB7yEYBO0LjJPeRGqcpZJki+GNoSho4YU50bEOY4I78OleNotqqXf4+d+vuECbkABmj
         qjzksRH/WhtVuENwc7NUCRUZ+vmkXbQEzhDjk23yCzoJ1RMReoKRv1UJqq55UFXCoBM7
         wkp3k5RulJ31RDF1A3Mq3xipWjbtRmIOZC5OrRsvfKzCSIrOqeIPxu/aT8zjIQYFQ+9+
         yVKhRnaqyL0uk7JunhIqw5/nBwEcuAoriOeAMVq2gDjWvK4xUb++GxAGVVBTwo5U/yrR
         zHjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zkg5d2FM4DVK47gyLvuf++k/Q1InesIH8WY8IADpoH4=;
        b=clgIYA+UrwMdb5djuTp3uuGSLYSllQI27wO9WyAEH5D3AhOqK4NdAJOLQsZ4cpn6Wu
         KSA/0Ujmw1475BnmOyREWhmNzCNUgbO8xV+aUJSjlYFXBv5qmiXBuzTWmsmH1MB1YwG4
         QavGuGindLBdIaEVg2DxoAZX91HTkgdaXZTZkKGgLFIZOcPo01E2VhHuXv4Gh5NFizJv
         vSs8Tx6+cEDlK0yibKVk38iOxAYbFbKLUADDkNRbHz5aoSRq+2uC3nBYUovP6XTs2TaQ
         JydiY0J+KokTF/t4UPlz41KOj/AHbL/I6IvEn9KOXlhbFKJ1f6f5ROFeCvlliSxXTCEr
         s+1Q==
X-Gm-Message-State: AOAM533am+7tsLEntxKeqiOwlohrvc4/IKNOez/sxIOnhw8MF3B0F5XM
        e/v6Nc6K4Cl3P5DMOcGF78s=
X-Google-Smtp-Source: ABdhPJwMkO8I0YTcHFb4baojLrsuQ2nvZxvvNYVgOmpe+qErng8haMoqYsMJAVFN6AeW7gNVPqLIFA==
X-Received: by 2002:a17:906:2707:: with SMTP id z7mr15547844ejc.418.1607783185299;
        Sat, 12 Dec 2020 06:26:25 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id n7sm10474198edb.34.2020.12.12.06.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Dec 2020 06:26:24 -0800 (PST)
Date:   Sat, 12 Dec 2020 16:26:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201212142622.diijil65gjkxde4n@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201208112350.kuvlaxqto37igczk@skbuf>
 <87a6uk5apb.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a6uk5apb.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 09:50:24PM +0100, Tobias Waldekranz wrote:
> On Tue, Dec 08, 2020 at 13:23, Vladimir Oltean <olteanv@gmail.com> wrote:
> > Sorry it took so long. I wanted to understand:
> > (a) where are the challenged for drivers to uniformly support software
> >     bridging when they already have code for bridge offloading. I found
> >     the following issues:
> >     - We have taggers that unconditionally set skb->offload_fwd_mark = 1,
> >       which kind of prevents software bridging. I'm not sure what the
> >       fix for these should be.
>
> I took a closer look at the software fallback mode for LAGs and I've
> found three issues that prevent this from working in a bridged setup,
> two of which are easy to fix. This is the setup (team0 is _not_
> offloaded):
>
> (A)  br0
>      /
>   team0
>    / \
> swp0 swp1
>
>
> 1. DSA tries to offload port attributes for standalone ports. So in this
>    setup, if vlan filtering is enabled on br0, we will enable it in
>    hardware which on mv88e6xxx causes swp0/1 to drop all packets on
>    ingress due to a VTU violation. This is a very easy fix, I will
>    include it in v4.

Makes sense, I did not enable VLAN filtering when I tried it.

> 2. The issue Vladimir mentioned above. This is also a straight forward
>    fix, I have patch for tag_dsa, making sure that offload_fwd_mark is
>    never set for ports in standalone mode.
>
>    I am not sure if I should solve it like that or if we should just
>    clear the mark in dsa_switch_rcv if the dp does not have a
>    bridge_dev. I know both Vladimir and I were leaning towards each
>    tagger solving it internally. But looking at the code, I get the
>    feeling that all taggers will end up copying the same block of code
>    anyway. What do you think?

I am not sure what constitutes a good separation between DSA and taggers
here. We have many taggers that just set skb->offload_fwd_mark = 1. We
could have this as an opportunity to even let DSA take the decision
altogether. What do you say if we stop setting skb->offload_fwd_mark
from taggers, just add this:

+#define DSA_SKB_TRAPPED	BIT(0)
+
 struct dsa_skb_cb {
 	struct sk_buff *clone;
+	unsigned long flags;
 };

and basically just reverse the logic. Make taggers just assign this flag
for packets which are known to have reached software via data or control
traps. Don't make the taggers set skb->offload_fwd_mark = 1 if they
don't need to. Let DSA take that decision upon a more complex thought
process, which looks at DSA_SKB_CB(skb)->flags & DSA_SKB_TRAPPED too,
among other things.

> With these two patches in place, setup (A) works as expected. But if you
> extend it to (team0 still not offloaded):
>
> (B)   br0
>      /   \
>   team0   \
>    / \     \
> swp0 swp1  swp2
>
> You instantly run into:
>
> 3. Only traffic which does _not_ have offload_fwd_mark set is allowed to
>    pass from swp2 to team0. This is because the bridge uses
>    dev_get_port_parent_id to figure out which ports belong to the same
>    switch. This will recurse down through all lowers and find swp0/1
>    which will answer with the same ID as swp2.
>
>    In the case where team0 is offloaded, this is exactly what we want,
>    but in a setup like (B) they do not have the same "logical" parent in
>    the sense that br0 is led to believe. I.e. the hardware will never
>    forward packets between swp0/1 and swp2.
>
>    I do not see an obvious solution to this. Refusing to divulge the
>    parent just because you are a part of a software LAG seems fraught
>    with danger as there are other users of those APIs. Adding yet
>    another ndo would theoretically be possible, but not
>    desirable. Ideas?
>
> As for this series, my intention is to make sure that (A) works as
> intended, leaving (B) for another day. Does that seem reasonable?
>
> NOTE: In the offloaded case, (B) will of course also be supported.

Yeah, ok, one can already tell that the way I've tested this setup was
by commenting out skb->offload_fwd_mark = 1 altogether. It seems ok to
postpone this a bit.

For what it's worth, in the giant "RX filtering for DSA switches" fiasco
https://patchwork.ozlabs.org/project/netdev/patch/20200521211036.668624-11-olteanv@gmail.com/
we seemed to reach the conclusion that it would be ok to add a new NDO
answering the question "can this interface do forwarding in hardware
towards this other interface". We can probably start with the question
being asked for L2 forwarding only.

Maybe you are just the kick I need to come back to that series and
simplify it.
