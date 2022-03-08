Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7101E4D24C3
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 00:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiCHXUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 18:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiCHXUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 18:20:00 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30939E54E
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 15:18:58 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2dc28791ecbso4942447b3.4
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 15:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eendtF7O1jT4ZpjoFlzKIyJ4YNYGYwK/GXLvyJ/A4B0=;
        b=rWZalxpbNZkyKJTe0k9BvpqyDA6xyuUWEczrB/MzwuKjD1dqeAAJkFpYG7Rd9qHBVI
         9egVQB3Iqk6Yv8xdg7MOdOWlKJf8Bl///qOS2RrGkcf7tuQqO7GKtNtRpFai3hWY6CIj
         PdsqqLhM+fW9R/dQKoJLgJmXGkkJ6vdgjFgwjIVieW3QjrE0/bx8WpSD1cI9vPSNATBc
         eTaJ+V/aflZrW3st1K5SLYbO8UU5nTaSksOPkX+FZE/jl1cK6PSF2tDtkwdxvvuaFSsf
         KcE5YGkbsORk7mrWPkeM/Q63MD6UHFU/ztOn42tOJhBr/m/VyQfnHJfzyJXX29ubQMRk
         7BNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eendtF7O1jT4ZpjoFlzKIyJ4YNYGYwK/GXLvyJ/A4B0=;
        b=wT4W+bzpF2oywOi/Q4vyNM1b8W/PrI2noETJuW+kB/zsesX1PTjpqBXBL7fOBK7mNm
         gQbfq8585iSU211YBJb/XNGRNLW7BPFX7orLAZuqbrp+EaW2rQyCo2dtgznWT0nq7d6B
         8rn1GFRPCWl3DtHMIvujaMOiInczcdUAAwKZ6JvIXpqn1bilGTVw7q2h5Ae+BqkVjTfz
         ZEGS8wLOyBQT1Gh7+HMtGGxEElW1A5xztsnxmVNcEytqqy8+q51Ecds/uQps1lBzYpaU
         OXvoT6DGdLZISTO3FRZ+YxioVv5mYRC3W1ZWfuhOKO0vWJuLE9Ammu74uYt80ttbBBPe
         FsZw==
X-Gm-Message-State: AOAM53213WKNJJyUF6k88zkh+AkrmSspX1vLrUg00Gp4dViYU5WR1105
        GyoQ90/XYwpXwkU6VV9HOxr30lB0bmW0EwHSJBJ/YQ==
X-Google-Smtp-Source: ABdhPJyxNvJB5rMyTyEHv+H72i/rock+GNdS99gSt/QH7EFnMLXaTPsW8vasGCJ6GKScN3VQe205u1vwaNdV7any5Mw=
X-Received: by 2002:a81:1043:0:b0:2dc:289f:9533 with SMTP id
 64-20020a811043000000b002dc289f9533mr14625066ywq.467.1646781516920; Tue, 08
 Mar 2022 15:18:36 -0800 (PST)
MIME-Version: 1.0
References: <20220308212531.752215-1-jeffreyjilinux@gmail.com> <d1b25466-6f83-591e-39a6-8fdbd56846fb@kernel.org>
In-Reply-To: <d1b25466-6f83-591e-39a6-8fdbd56846fb@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 8 Mar 2022 15:18:25 -0800
Message-ID: <CANn89iKvP-8VpOrf_ppVVgsd4kQtAEFWkBVxKW4BP+rtu_Egrw@mail.gmail.com>
Subject: Re: [PATCH v3 net-next] net-core: add rx_otherhost_dropped counter
To:     David Ahern <dsahern@kernel.org>
Cc:     Jeffrey Ji <jeffreyjilinux@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Brian Vazquez <brianvv@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Antoine Tenart <atenart@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        jeffreyji <jeffreyji@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 8, 2022 at 2:51 PM David Ahern <dsahern@kernel.org> wrote:
>
> On 3/8/22 2:25 PM, Jeffrey Ji wrote:
> > diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> > index 95f7bb052784..8b87ea99904b 100644
> > --- a/net/ipv4/ip_input.c
> > +++ b/net/ipv4/ip_input.c
> > @@ -451,6 +451,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
> >        * that it receives, do not try to analyse it.
> >        */
> >       if (skb->pkt_type == PACKET_OTHERHOST) {
> > +             atomic_long_inc(&skb->dev->rx_otherhost_dropped);
> >               drop_reason = SKB_DROP_REASON_OTHERHOST;
> >               goto drop;
> >       }
> > diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> > index 5b5ea35635f9..5624c937f87f 100644
> > --- a/net/ipv6/ip6_input.c
> > +++ b/net/ipv6/ip6_input.c
> > @@ -150,6 +150,7 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
> >       struct inet6_dev *idev;
> >
> >       if (skb->pkt_type == PACKET_OTHERHOST) {
> > +             atomic_long_inc(&skb->dev->rx_otherhost_dropped);
> >               kfree_skb(skb);
> >               return NULL;
> >       }
>
> that's an expensive packet counter for a common path (e.g., hosting
> environments).

This was the reason for the initial patch, using SNMP stat, being per cpu.

Adding per-device per-cpu data for this counter will increase cost of
netdevice dismantle phase,
and increase time for ndo_get_stats64(), especially on hosts with 256
or 512 cpus.
