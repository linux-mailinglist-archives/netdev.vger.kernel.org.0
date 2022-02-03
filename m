Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCBE4A8C5E
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 20:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238053AbiBCTUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 14:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234576AbiBCTUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 14:20:51 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A417C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 11:20:51 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id k31so12050060ybj.4
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 11:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3OU6KVSAhXQAFXmy79ANm2khMB/3mzB3/6p5n0GixIo=;
        b=R56PvrcZMuTuKL6V46FcYOGyAkbxmKIPlujbRTXCx5jrgPpyoqRKAQo2YvY7m0kyfm
         xy6LWZzxN0vy4rTY6Tl5uA/r+G9GgXwFE0FkCkaDd5aE/tVZrlA77j1DVFo8Z2rJuxfN
         ok1nS3QO+sFsk+Guwzz3X+GnsMIa+M2ly8s92HZadHs+kxvqiQh72MBu5HkkieDdCI3J
         LNPZA4toUjieW94FR4cHF3PgrgL1Dvq1sOCGtJSJDI+/5U2nWTXhBSjB2i4Sbb74Phbm
         JdkAoLGwTZ9nZMgJeUzi5jkXm8F021iHagemFFz++59uq1oyj5Du+IOz6pfpFQtTzYeZ
         yUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3OU6KVSAhXQAFXmy79ANm2khMB/3mzB3/6p5n0GixIo=;
        b=fazfaq0EyMZXrQiVOKoIQxa6o98P6q/LAywjKIzYKE4ruOilFwfMlJeDYgfAwna8Fi
         63k9p/jpUhd4pV+H6r3dzutsN4bYnzYS7ikm0vh9NC09QAeY8m310cv8pWnw3LQUyZ0x
         iskrwy5Joah9rxs8ZKwWsTxxzhbOuO0sVmFOGctIJ9h7+Ie712B3oFN0HK3snAj4Mo9L
         6mARl5j22ILskMUvV52Zya5BoNOJErf7eEdDyVb48lxeQ8zrAdInWEebBKq2EmzpEShW
         oVdDAQbb1Mx2DI3WKKuaUsAocEbhfZA1CNTGnx/OTgpvnp3x9HJMP5ESM83jjp1vhBhA
         cgBA==
X-Gm-Message-State: AOAM5320ct3fjrDuuWEcOIv0WUGsgCU49KaPgaUkIbOnhl8CxhIjk3ku
        OR6u2ec+yYcOSkm+zziGXzwN6xaCyndDah3xZBYziQ==
X-Google-Smtp-Source: ABdhPJwogoR8IVOb+GM+lTjf7FwM1kLrIfE0UjuEVm6+jT+3AWhgiBvR6DWpb44SZcxlmJeULdsKDihwa/si7LL1Wi8=
X-Received: by 2002:a25:8885:: with SMTP id d5mr27947456ybl.383.1643916050220;
 Thu, 03 Feb 2022 11:20:50 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-10-eric.dumazet@gmail.com> <ee1fedeb33cd989379b72faac0fd6a366966f032.camel@gmail.com>
 <CANn89iKxGvbXQqoRZZ5j22-5YkpiCLS13EGoQ1OYe3EHjEss6A@mail.gmail.com>
 <CAKgT0UeTvj_6DWUskxxaRiQQxcwg6j0u+UHDaougJSMdkogKWA@mail.gmail.com> <20220203111802.1575416e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220203111802.1575416e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 11:20:39 -0800
Message-ID: <CANn89iL3_6Vkj6Gq8vuMmC=pbAS+Zbe4hFaXgSEpyKhzfgh+dQ@mail.gmail.com>
Subject: Re: [PATCH net-next 09/15] net: increase MAX_SKB_FRAGS
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 11:18 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 3 Feb 2022 09:56:42 -0800 Alexander Duyck wrote:
> > > I could make  MAX_SKB_FRAGS a config option, and default to 17, until
> > > all drivers have been fixed.
> > >
> > > Alternative is that I remove this patch from the series and we apply
> > > it to Google production kernels,
> > > as we did before.
> >
> > A config option would probably be preferred. The big issue as I see it
> > is that changing MAX_SKB_FRAGS is going to have ripples throughout the
> > ecosystem as the shared info size will be increasing and the queueing
> > behavior for most drivers will be modified as a result.
>
> I'd vote for making the change and dealing with the fall out. Unlikely
> many people would turn this knob otherwise and it's a major difference.
> Better not to fork the characteristics of the stack, IMHO.

Another issue with CONFIG_ options is that they are integer.

Trying the following did not work

#define MAX_SKB_FRAGS  ((unsigned long)CONFIG_MAX_SKB_FRAGS)

Because in some places we have

#if    (   MAX_SKB_FRAGS > ...)

(MAX_SKB_FRAGS is UL currently, making it an integer might cause some
signed/unsigned operations buggy)
