Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56693ADE36
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 13:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhFTLuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 07:50:17 -0400
Received: from mail-ua1-f44.google.com ([209.85.222.44]:42998 "EHLO
        mail-ua1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhFTLuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 07:50:15 -0400
Received: by mail-ua1-f44.google.com with SMTP id e20so5260999ual.9;
        Sun, 20 Jun 2021 04:48:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Im8HK5D4Dd8ayHHB8TPoataAcp6a597GIb4OP9tjGxg=;
        b=kKV1VL7oDhWWVV7f2xQk59HWbzMYah5iuynykDJMi+EVGlfQy/ECD3NvOCRmd5dios
         E0FBO987IrNMomZrr0Ergyr0AZ5QmXXETlsYSyUO1PJ22mk9utIxTV0luovkkTx7EFkp
         KxH5krNiokpyq8RAM3S8q4gF24LYiUX5XbhXgIeFtO52a0SnwMYSraOd957Jf6xes84x
         ARc33uyx91i6cF7nrLRp5hLjf7fSCBhQH6qFmrRYBvzJg+lhhkofWDKMvTbR0Mp1+/Xo
         O3p+KtPEdfi4rJN031KpYObCluoBQUcfd/AArzGwKUcrT1whaF25A+wtgMvQg9RXKUyE
         Hvhg==
X-Gm-Message-State: AOAM530m1wv5s9yxDApHMayY6aqvw5a9bI90yiB/1RBR13f6+976h7Xi
        KRDgyGSgkpIZfQOLlnt2xENu+YhCo4aFSC3xlag=
X-Google-Smtp-Source: ABdhPJzfseuiTuNvP/PNS2Gpb7u3ed5CK3BmqOhGwWipfE1M/+rzB9LgG+5x+92e9+/0KHoW/kpAn4i0qPDlVSEbJzU=
X-Received: by 2002:ab0:70b3:: with SMTP id q19mr18249159ual.2.1624189682908;
 Sun, 20 Jun 2021 04:48:02 -0700 (PDT)
MIME-Version: 1.0
References: <1624062891-22762-1-git-send-email-schmitzmic@gmail.com>
 <1624062891-22762-3-git-send-email-schmitzmic@gmail.com> <CAMuHMdUSGWGMs6_wqy-CkfuKsdk=EBpEVBf3UugxCuo3qZQCKg@mail.gmail.com>
 <5e753883-d8c1-8e2a-9cd8-e6c315862fa2@gmail.com>
In-Reply-To: <5e753883-d8c1-8e2a-9cd8-e6c315862fa2@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sun, 20 Jun 2021 13:47:51 +0200
Message-ID: <CAMuHMdXPY6w3_rg9nKkiZc1d-bEW84G8xzD0kYEqRiwj6hLWhA@mail.gmail.com>
Subject: Re: [PATCH net-next v5 2/2] net/8390: apne.c - add 100 Mbit support
 to apne.c driver
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     "Linux/m68k" <linux-m68k@vger.kernel.org>,
        ALeX Kazik <alex@kazik.de>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Sat, Jun 19, 2021 at 9:31 PM Michael Schmitz <schmitzmic@gmail.com> wrote:
> Am 19.06.2021 um 21:08 schrieb Geert Uytterhoeven:
> > On Sat, Jun 19, 2021 at 2:35 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> >> Add Kconfig option, module parameter and PCMCIA reset code
> >> required to support 100 Mbit PCMCIA ethernet cards on Amiga.
> >>
> >> 10 Mbit and 100 Mbit mode are supported by the same module.
> >> A module parameter switches Amiga ISA IO accessors to word
> >> access by changing isa_type at runtime. Additional code to
> >> reset the PCMCIA hardware is also added to the driver probe.
> >>
> >> Patch modified after patch "[PATCH RFC net-next] Amiga PCMCIA
> >> 100 MBit card support" submitted to netdev 2018/09/16 by Alex
> >> Kazik <alex@kazik.de>.
> >>
> >> CC: netdev@vger.kernel.org
> >> Link: https://lore.kernel.org/r/1622958877-2026-1-git-send-email-schmitzmic@gmail.com
> >> Tested-by: Alex Kazik <alex@kazik.de>
> >> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
> >
> > Thanks for your patch!
> >
> > Note that this patch has a hard dependency on "[PATCH v5 1/2] m68k:
> > io_mm.h - add APNE 100 MBit support" in the series, so it must not
> > be applied to the netdev tree yet.
>
> Hmm - so we ought to protect the new code by
>
> #ifdef ARCH_HAVE_16BIT_PCMCIA
>
> and set that in the m68k machine Kconfig in the first patch?
>
> (It's almost, but not quite like a config option :-)

No, we just manage dependencies, so either:
  1. Patch 2 cannot go in until patch 1 is upstream,
  2. One subsystem maintainer gives an Acked-by for one patch,so
    the other subsystem maintainer can apply both patches.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
