Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3477483F81
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 10:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiADJ5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 04:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiADJ5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 04:57:45 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48A2C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 01:57:45 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id m19so88971890ybf.9
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 01:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XKy8L31UcszDEpoCFUwJwb0FhViUoFv1RKRkXFgLrvQ=;
        b=EGozT5oPx9r74hFlVkfyqb+Xp3CrbqIr2axP55IDW8kYVPcODUzLtQvceHhplPFiDz
         41JS190G6V9ulevfwiUkhSfhzucOVJSGbS21+O5+OxMa1vyK91IHhnnToA4fYRwe0QkR
         9yCqL81+8L+DwZPLSs5HH8C2UuxoVU6R1y2FIL98evu0cien2+Iz/SKJTiDuMfqXjjIg
         V1lIku63wuOxrPGso2Rsji6H6r/7nLbdOuXHVgzdy4s5AvljgbjZ3GTMn0rwj2dtyXVe
         frAvrCB24WkNDF20EAcTgVJl6OwoaKqOwh72COkZI9Ce2L93cKEsN++MtFo55niJYbJq
         CTEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XKy8L31UcszDEpoCFUwJwb0FhViUoFv1RKRkXFgLrvQ=;
        b=MP320t/9+/FdezmkCuywpVJB5sQ+xgWmUe2szZG2TvfWZfPJGkVn+ZiHB9cm9+Bgy0
         kRyu+M2Vgi4MzEGo0m7gY6luZsn5Oj4Eozzjvwt3peluu53c/ldugRjnTbxYnrlihrI4
         89gI+1+fKq3wz4SZqCAobg2WV+HeAenBSzVRzqGsmXP4GdUhmbCYQQLksLWKp/Hp0Vpq
         ngm7TQoqMx/Mj0PClgTHfhkOUFYK+Fp1s9WYRPSUM1g103iJb0fbllR/GHaicwhOhcjW
         CCwbRQplgiQIJ13ZztCO73kL0dVDDu3AZw3gaDdrv2pgS+p2XkETRG7ThKdHomyEAqlY
         fq7g==
X-Gm-Message-State: AOAM530VO3FnnKvg2RlHd00iAyIF2PxY4uHmLf6EUkvdSb0FsawsOxCI
        +SozByNWGTEn2q/R1T5EeN2j3TyBbUsT0mLf6J700f+m7XM=
X-Google-Smtp-Source: ABdhPJzY5dhgjMPnKML5jNqji9FbozYQC5Pp1smyjFQjijuEENoJIVwwm15RvGQkg70UyoSpvIg1juzf8ze8OQ1abgM=
X-Received: by 2002:a25:b108:: with SMTP id g8mr9300474ybj.277.1641290264405;
 Tue, 04 Jan 2022 01:57:44 -0800 (PST)
MIME-Version: 1.0
References: <ec7ee6bfa737e3f87774555feac13923@yourcmc.ru> <20220103100012.7507e0e1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220103100012.7507e0e1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Jan 2022 01:57:33 -0800
Message-ID: <CANn89i+vsi3PpZz+tccsDn76k9oq3XNpDKEQWRhamm-t9EAZrA@mail.gmail.com>
Subject: Re: How to test TCP zero-copy receive with real NICs?
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     vitalif@yourcmc.ru, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 3, 2022 at 10:00 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 01 Jan 2022 20:49:49 +0000 vitalif@yourcmc.ru wrote:
> > Hi!
> >
> > Happy new year netdev mailing list :-)
> >
> > I have questions about your Linux TCP zero-copy support which is
> > described in these articles https://lwn.net/Articles/752046/ and
> > presentation:
> > https://legacy.netdevconf.info/0x14/pub/slides/62/Implementing%20TCP%20RX%20zero%20copy.pdf
> >
> > First of all, how to test it with real NICs?
> >
> > The presentation says it requires "collaboration" from the NIC and it
> > also mentions some NICs you used at Google. Which are these NICs? Was
> > the standard driver used or did it require custom patches to the
> > drivers?..
> >
> > I tried to test zerocopy with Mellanox ConnectX-4 and also with Intel
> > X520-DA2 (82599) and had no luck. I tried to find something like
> > "header-data split" or "packet split" in the drivers code, and as far
> > as I understood the support for header-data split in ixgbe was there
> > until 2012, but was removed in commit
> > f800326dca7bc158f4c886aa92f222de37993c80 ("ixgbe: Replace standard
> > receive path with a page based receive"). For Mellanox (again, as I
> > understand) it's not present at all...
>
> Try a Broadcom NIC that uses the bnxt driver. It seems to work pretty
> well, just need to enable GRO-HW or MTU > 4k and you'll get header-data
> split automatically. Doesn't even have to be a very recent NIC,
> I believe it's supported for a number of generations now.
>
> > The second question is more about my attempts to test it on loopback
> > - test tcp_mmap program (tools/testing/selftests/net/tcp_mmap.c from
> > the kernel source) works fine on loopback, but my examples with
> > TCP_NODELAY enabled are very brittle and only manage to sometimes use
> > zero-copy successfully (i.e. get something non-zero from getsockopt
> > TCP_ZEROCOPY_RECEIVE) with tcp_rmem=16384 16384 16384 AND 4 kb packet
> > size. And even in that case it only performs zerocopy on 30-50% of
> > packets. But that's at least something... And if I try to send larger
> > portions of data it breaks... And if I try to change buffers to
> > default it also breaks... And if I send 128 byte packets before 4096+
> > byte packets it also breaks... I tried to dump traffic and everything
> > looks good there, all packets are 40 bytes + payload(4096 or more), I
> > set MSS manually to 4096 and so on. Even tcp window sizes look good -
> > if I shift them by wscale they are always page-aligned.
> >
> > tcp_mmap, at the same time, works fine and I don't see any serious
> > difference between it and my test examples except TCP_NODELAY.
> >
> > So the second question is - how to make it stable with TCP_NODELAY,
> > even on loopback?)
> >
>

A mlx4 patch is doable, if you know the size of expected headers, and
if you do not use XDP.

We use IPv6 + TCP with TS options, total 86 bytes of headers.

I do not have time to cook a mlx4 patch based on current upstream
tree, maybe later this month.
