Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE404F2393
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 08:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiDEGs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 02:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiDEGsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 02:48:19 -0400
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D9A57175;
        Mon,  4 Apr 2022 23:46:20 -0700 (PDT)
Received: by mail-qt1-f181.google.com with SMTP id v2so9708009qtc.5;
        Mon, 04 Apr 2022 23:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UuWjfy1DmKGBwxecHn9QW28Mp8RGeP8Fe6idp3HhRGs=;
        b=XM48JdQlRjpvDo6pAnEfInZQ02JydMyJSRb+hGGXieNxNU8mZ3kXD/gEu0mZV++O2k
         BqS6NEIoz2gsS8qU754qXmlGGdecWLhxBKTy8nQHlXUP7/An4b0tCe6BQQkN8HUGP3mg
         CZ/Aro8sSU0utf0rAYn2baDlmL3oNG88I8GpFzbPK/CacovKR6jKzxmPjLaSSRenV6Ph
         BvXPV8XItBJUMXSpzEcjVzhTBf3m5fL8OHSPHARPfMlGu7keGZVa8qfRRKOu3BXJNv2O
         2xdRgdMmflZWYsTNNuF3/AlnRJKOjBKcZ+veIgQodE67F/b2u0SX2U4pATdnsUqAv6g5
         WrqA==
X-Gm-Message-State: AOAM532nBU/gi9XQjDN33cMYjxk2EBLOmHtK3YNCKQilvc6FC+iT8SSA
        ZP4ihtDGGD79/PMkzdXb+luSSoATM5GxDA==
X-Google-Smtp-Source: ABdhPJwkZT+cT8EcW9YAwiSyF8z2cWBBKHK+j5v06cUcI/z3ZQE/vjvuRTuaahHCBiEU5I/o9Rlyjg==
X-Received: by 2002:ac8:5c84:0:b0:2e1:eede:8b1b with SMTP id r4-20020ac85c84000000b002e1eede8b1bmr1709809qta.228.1649141179007;
        Mon, 04 Apr 2022 23:46:19 -0700 (PDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id q8-20020a05622a04c800b002e06d7c1eabsm10360081qtx.16.2022.04.04.23.46.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Apr 2022 23:46:18 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id g9so21718806ybf.1;
        Mon, 04 Apr 2022 23:46:18 -0700 (PDT)
X-Received: by 2002:a25:45:0:b0:633:96e2:2179 with SMTP id 66-20020a250045000000b0063396e22179mr1490905yba.393.1649141178137;
 Mon, 04 Apr 2022 23:46:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wg6FWL1xjVyHx7DdjD2dHZETA5_=FqqW17Z19X-WTfWSg@mail.gmail.com>
 <20220404074734.1092959-1-geert@linux-m68k.org> <alpine.DEB.2.22.394.2204041006230.1941618@ramsan.of.borg>
 <874k38u20c.fsf@tynnyri.adurom.net>
In-Reply-To: <874k38u20c.fsf@tynnyri.adurom.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 5 Apr 2022 08:46:06 +0200
X-Gmail-Original-Message-ID: <CAMuHMdV_-3TOHYehUsHeqwHjQtzN1Ot886K7vwPr4P-4u8eehw@mail.gmail.com>
Message-ID: <CAMuHMdV_-3TOHYehUsHeqwHjQtzN1Ot886K7vwPr4P-4u8eehw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v5.18-rc1
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-um <linux-um@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        scsi <linux-scsi@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-xfs@vger.kernel.org,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle,

On Mon, Apr 4, 2022 at 8:39 PM Kalle Valo <kvalo@kernel.org> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
> >> /kisskb/src/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c:
> >> error: case label does not reduce to an integer constant: => 3798:2,
> >> 3809:2
> >
> > arm64-gcc5.4/arm64-allmodconfig
> > powerpc-gcc5/powerpc-allmodconfig
> > powerpc-gcc5/ppc64_book3e_allmodconfig
>
> After v5.17 there were two commits to brcmfmac/sdio.c:
>
> $ git log --oneline v5.17.. drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> ed26edf7bfd9 brcmfmac: Add BCM43454/6 support
> 6d766d8cb505 brcmfmac: pcie: Declare missing firmware files in pcie.c
>
> I can't see how either of them could cause this warning. Could something
> else cause this or am I missing something?

Doh, I should not have reduced the CC list in the xfs subthread...

The builds above are all gcc-5 builds, so they are affected by the same
issue as XFS: unsigned constants that don't fit in int are lacking a
"U" suffix.

I assume Arnd's patch for
drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
fixes this?
https://lore.kernel.org/all/CAK8P3a0wRiS03imdXk2WbGONkSSczEGdE-ue5ubF6UyyDE9dQg@mail.gmail.com

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
