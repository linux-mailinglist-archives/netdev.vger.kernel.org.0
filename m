Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810D42AF762
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 18:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgKKR3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 12:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgKKR3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 12:29:02 -0500
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD55C0613D4
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 09:29:02 -0800 (PST)
Received: by mail-vk1-xa43.google.com with SMTP id w67so652654vke.10
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 09:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qb778JtBBre4THwiC7AFi5cBHs6XpQkr216/S4N/Bdg=;
        b=o3BGAQ7AB4acOXOGTtGt4biBH/BIOd6tdT301QMU1CbRTr7BaYBqODN+wRs/jUsK7Z
         F5LikMeBMEInQp0rW5/RUU0WYGhUhf7va9nkS+5lCsjPI5MvWUfZcsuTAUdymXplJ2tY
         sIrtZWt12LbCfqMYrSNfj2XwXyY/Zerv+9jpza1v3V4Pt+TPrhCNVuvJfR30xOzkEiIJ
         NHjUIp9j3I1HoRICQZ9uYSIrhySu2Suanp9TspDU8FDVHmCjThak/CKPSdGG2OHKiMmY
         JzSiBnvxXdwJf0LbMnaHWYfHs1kMub6RpMPErXaMF9FXKg8770Cww7eeUhUBIYFt6gSq
         ignA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qb778JtBBre4THwiC7AFi5cBHs6XpQkr216/S4N/Bdg=;
        b=ZHF5UmfREGk9w56U6IrIU2TycCkbqriEn4N7FJMQqXY6r0qNzU8oIhMpbiRrDvTJOY
         iqagRHXupDidbzwUlOFlk4Mgr9Q2hMmzSYhIJeEMByVTzP5euF0q/x/b8ydn02NgPCPn
         a+HNFhoRCrkIBhokneSLmND12WkyWidcSMb6xuFubBiWPJTlEdR+5Zt25cnzZBCMog76
         Rvw7oP1rPYil62cqg2JhfVjRpqXHzwRxPkAIPCjwerXzY3OcP2wgxh1n+DIa6b7b+35q
         bzoI1tMNWkjukiSnOG129kyMm+oAUQGoNrJXB51DEGV150t1NPjEfxuj1M+3eGVXRumY
         W8GA==
X-Gm-Message-State: AOAM530ipLH+JJhXos77D61QcQleUhlm2OAzWSapdN7NwG0WCF4YmZsm
        VrRv/lGf13S453WZ8SYdlfjjVZNt1c4=
X-Google-Smtp-Source: ABdhPJwCSMcjtGS4CBs+DNYb9lrDeDfJgvPxWqFo7+i5AGya/vxAeiseXo11EExAyzn82BSBgQtfZw==
X-Received: by 2002:ac5:cd58:: with SMTP id n24mr12261976vkm.17.1605115740601;
        Wed, 11 Nov 2020 09:29:00 -0800 (PST)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com. [209.85.217.41])
        by smtp.gmail.com with ESMTPSA id j82sm316093vke.34.2020.11.11.09.28.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 09:28:59 -0800 (PST)
Received: by mail-vs1-f41.google.com with SMTP id y78so1600777vsy.6
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 09:28:59 -0800 (PST)
X-Received: by 2002:a67:7704:: with SMTP id s4mr15557777vsc.51.1605115738887;
 Wed, 11 Nov 2020 09:28:58 -0800 (PST)
MIME-Version: 1.0
References: <bEm19mEHLokLGc5HrEiEKEUgpZfmDYPoFtoLAAEnIUE@cp3-web-033.plabs.ch>
 <CA+FuTScriNKLu=q+xmBGjtBB06SbErZK26M+FPiJBRN-c8gVLw@mail.gmail.com>
 <zlsylwLJr9o9nP9fcmUnMBxSNs5tLc6rw2181IgE@cp7-web-041.plabs.ch> <20201111082658.4cd3bb1d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111082658.4cd3bb1d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 11 Nov 2020 12:28:21 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfnRJF4_SoMtJz+B7Y5hePoA1OzA797zkmzJ0cYQ99iVw@mail.gmail.com>
Message-ID: <CA+FuTSfnRJF4_SoMtJz+B7Y5hePoA1OzA797zkmzJ0cYQ99iVw@mail.gmail.com>
Subject: Re: [PATCH v4 net] net: udp: fix Fast/frag0 UDP GRO
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 11:27 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 11 Nov 2020 11:29:06 +0000 Alexander Lobakin wrote:
> > >>> +     sk = static_branch_unlikely(&udp_encap_needed_key) ?
> > >>> +          udp4_gro_lookup_skb(skb, uh->source, uh->dest) :
> > >>> +          NULL;
> > >
> > > Does this indentation pass checkpatch?
> >
> > Sure, I always check my changes with checkpatch --strict.
> >
> > > Else, the line limit is no longer strict,a and this only shortens the
> > > line, so a single line is fine.
> >
> > These single lines is about 120 chars, don't find them eye-pleasant.
> > But, as with "u32" above, they're pure cosmetics and can be changed.
>
> let me chime in on the perhaps least important aspect of the patch :)
>
> Is there are reason to use a ternary operator here at all?
> Isn't this cleaner when written with an if statement?
>
>         sk = NULL;
>         if (static_branch_unlikely(&udp_encap_needed_key))
>                 sk = udp4_gro_lookup_skb(skb, uh->source, uh->dest);

Ah indeed :)

One other thing I missed before. The socket lookup is actually an
independent issue, introduced on commit a6024562ffd7 ("udp: Add GRO
functions to UDP socket"). Should be a separate Fixes tag, perhaps
even a separate patch.
