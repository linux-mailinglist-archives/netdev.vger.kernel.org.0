Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9F9227FE6
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 14:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgGUMZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 08:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgGUMZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 08:25:46 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D363EC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 05:25:45 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id i3so15900473qtq.13
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 05:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=onxal2wVPPs5ELkDZCSBPyXdRelUh9gaurdOykXY8P0=;
        b=bal7RLq+ZsCCeV2T4hrrR29yMTohjOQmWx9yE8e24h6W+KFNnDN/avF4QwLxfvSAtz
         RNMg9NbRu5xO3osfnFd/cTY24Hxqz1zIzn8u2y+G3f/VemJG06qilbTYATUcpq0hLpjF
         Z3XKLzZr1sroGgJPCZcPyYb/xShwYoclVorMEkDycHCoZnJVc4VZQAfJydVziHesaL94
         BgFEtxPrU8BuUBVKJuxqr42arAfX/RlQ0UJX6cylche8KY6G+5rVjtw92fl83Ik8QXUv
         IoYp3VI0mgBcACTkeX8t+0knE060mChEJ50GL/NLGkRzdmmFe7lnORGxwI1WznwYzPge
         5Dkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=onxal2wVPPs5ELkDZCSBPyXdRelUh9gaurdOykXY8P0=;
        b=S8sK2MD3v8l4g1dPhV8kTWKfqYekY1ObXzA8pk96599LA2Ri0tG4oblMqpDjm5TzTZ
         KrD+X7KXbdum8YAjVyhpOprC8xmq70jbfVx3SNC5X9cSe526TefbZj+lkqBSk5WxAS92
         8uLsBENg57JUElq22Vh6/G6j3ESkpm7DquC3STv0r3uxHI9cuSXVqbHAXDZZAydWGFoh
         kGKMof6KStpci3hJ2GVDxQYM81XuuLj2KAiQCa8y8K9oZnBYiZLR3cKjiyv0+jrNzZlT
         oURhnehw7qnH2r8CCDYpB2CpL/vFza7YAe6Smi1NMRdTcz3De4ia9WW0drocRUdCAGYl
         VI6g==
X-Gm-Message-State: AOAM532O1gdgw21Ktq1rGo18LZIPzoIckKKijQjCrHFHkEQwtWznbOFN
        XGL0VxBhCNTVl6nBkiGJ9e9A1WI8
X-Google-Smtp-Source: ABdhPJy/ulrvm3XygRPVKRq2xMI1t8gcrkut3aOwIXGSt83dMaWqHpLwHa8WG0CV7PV+SVLVisyczw==
X-Received: by 2002:ac8:2a3d:: with SMTP id k58mr28347180qtk.265.1595334344292;
        Tue, 21 Jul 2020 05:25:44 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id l67sm2229541qkd.7.2020.07.21.05.25.42
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2020 05:25:43 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id 134so9965537ybd.6
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 05:25:42 -0700 (PDT)
X-Received: by 2002:a25:81cf:: with SMTP id n15mr42849489ybm.213.1595334341817;
 Tue, 21 Jul 2020 05:25:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200721061531.94236-1-kuniyu@amazon.co.jp> <20200721061531.94236-2-kuniyu@amazon.co.jp>
In-Reply-To: <20200721061531.94236-2-kuniyu@amazon.co.jp>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 21 Jul 2020 08:25:04 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeWNarNvhPeg4Z-97Xsz_7H1WvW6NshC7VLnVwECxLqfw@mail.gmail.com>
Message-ID: <CA+FuTSeWNarNvhPeg4Z-97Xsz_7H1WvW6NshC7VLnVwECxLqfw@mail.gmail.com>
Subject: Re: [PATCH net 1/2] udp: Copy has_conns in reuseport_grow().
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Craig Gallek <kraig@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        osa-contribution-log@amazon.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 2:16 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> If an unconnected socket in a UDP reuseport group connect()s, has_conns is
> set to 1. Then, when a packet is received, udp[46]_lib_lookup2() scans all
> sockets in udp_hslot looking for the connected socket with the highest
> score.
>
> However, when the number of sockets bound to the port exceeds max_socks,
> reuseport_grow() resets has_conns to 0. It can cause udp[46]_lib_lookup2()
> to return without scanning all sockets, resulting in that packets sent to
> connected sockets may be distributed to unconnected sockets.
>
> Therefore, reuseport_grow() should copy has_conns.
>
> Fixes: acdcecc61285 ("udp: correct reuseport selection with connected sockets")
> CC: Willem de Bruijn <willemb@google.com>
> Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks. Yes, I missed this resize operation when adding the field.
