Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E715456B31
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 09:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbhKSICX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 03:02:23 -0500
Received: from mail-ua1-f46.google.com ([209.85.222.46]:46866 "EHLO
        mail-ua1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhKSICW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 03:02:22 -0500
Received: by mail-ua1-f46.google.com with SMTP id az37so19487660uab.13;
        Thu, 18 Nov 2021 23:59:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dk9UaVjo0josmA+fa27Jy3PA9oFlYy1IXirwFM9nOQM=;
        b=BN0jAoULTqA1aiWIa8IznKxDbgyfc/pxxIstkOYRmkq0XKXc7oPah0bFbf1rOy7gfe
         6OY/RW/c8eTtHyPmUsjHiYbiKEqAvgtA5tJKEJKXmHhSKM5KS5XM5oUhWqlDnbrBbnrn
         7U9mpiQNnaOF2ihBWu/xBNjHD50wIuST2yQ6ZRbau6Vqwslyr5DNIQYskoZpDAyNt1GR
         fAbORx9IBuhZ4Py0Lz6pzJaaVzZP1MPHFWV38MpWttXHdfGv3GH6dVt8Q0eiVBj37D17
         WKrssgoXAcE5kej+Cu/pV+qN/Lc9GGqpF9SQ9mD35nnODB5fDXQlWdcva4VtIpc4pAeL
         hbuw==
X-Gm-Message-State: AOAM530yS/Vp0quydMFSgXVqzmCKSME221HThTtQo6tBwlpFK2GUpwbk
        Ysx5oCmFo0OrY3YJLyp3Lm1kHh9rs4i9hA==
X-Google-Smtp-Source: ABdhPJzEaa21FkfXthJvLqDVde7Mjk7u5K1iqGs8B+PdiwTI+MPhSJZbQri7MTo7bdQnojdC3to9+A==
X-Received: by 2002:a05:6102:389:: with SMTP id m9mr90837446vsq.43.1637308760719;
        Thu, 18 Nov 2021 23:59:20 -0800 (PST)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id p3sm1371224vsr.3.2021.11.18.23.59.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 23:59:20 -0800 (PST)
Received: by mail-ua1-f46.google.com with SMTP id p2so19488508uad.11;
        Thu, 18 Nov 2021 23:59:20 -0800 (PST)
X-Received: by 2002:a9f:2431:: with SMTP id 46mr46173690uaq.114.1637308760064;
 Thu, 18 Nov 2021 23:59:20 -0800 (PST)
MIME-Version: 1.0
References: <20211119060632.8583-1-schmitzmic@gmail.com> <20211119060632.8583-4-schmitzmic@gmail.com>
In-Reply-To: <20211119060632.8583-4-schmitzmic@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 19 Nov 2021 08:59:08 +0100
X-Gmail-Original-Message-ID: <CAMuHMdU2fOe9E=H7k=Wt32Sg+0B1f7+2nU+dgv2eaW26aLqo=g@mail.gmail.com>
Message-ID: <CAMuHMdU2fOe9E=H7k=Wt32Sg+0B1f7+2nU+dgv2eaW26aLqo=g@mail.gmail.com>
Subject: Re: [PATCH net v12 3/3] net/8390: apne.c - add 100 Mbit support to
 apne.c driver
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     "Linux/m68k" <linux-m68k@vger.kernel.org>,
        ALeX Kazik <alex@kazik.de>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Fri, Nov 19, 2021 at 7:06 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> Add module parameter, IO mode autoprobe and PCMCIA reset code
> required to support 100 Mbit PCMCIA ethernet cards on Amiga.
>
> 10 Mbit and 100 Mbit mode are supported by the same module.
> Use the core PCMCIA cftable parser to detect 16 bit cards,
> and automatically enable 16 bit ISA IO access for those cards
> by changing isa_type at runtime. The user must select PCCARD
> and PCMCIA in the kernel config to make the necessary support
> modules available.
>
> Code to reset the PCMCIA hardware required for 16 bit cards is
> also added to the driver probe.
>
> An optional module parameter switches Amiga ISA IO accessors
> to 8 or 16 bit access in case autoprobe fails.
>
> Patch modified after patch "[PATCH RFC net-next] Amiga PCMCIA
> 100 MBit card support" submitted to netdev 2018/09/16 by Alex
> Kazik <alex@kazik.de>.
>
> CC: netdev@vger.kernel.org
> Link: https://lore.kernel.org/r/1622958877-2026-1-git-send-email-schmitzmic@gmail.com
> Tested-by: Alex Kazik <alex@kazik.de>
> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
>
> --
>
> Changes from v11:
>
> Geert Uytterhoeven:
> - use IS_REACHABLE() for PCMCIA dependent code
> - use container_of() instead of cast in pcmcia_parse_tuple()
>   call
> - set isa_type and apne_100_mbit correctly if autoprobe fails
> - reset isa_type and apne_100_mbit on module exit
>
> Joe Perches:
> - use pr_debug and co. to avoid #ifdef DEBUG

Thanks for the update!

> --- a/drivers/net/ethernet/8390/Kconfig
> +++ b/drivers/net/ethernet/8390/Kconfig
> @@ -144,6 +144,14 @@ config APNE
>           To compile this driver as a module, choose M here: the module
>           will be called apne.
>
> +         The driver also supports 10/100Mbit cards (e.g. Netgear FA411,
> +         CNet Singlepoint). To activate 100 Mbit support, use the kernel
> +         option apne.100mbit=1 (builtin) at boot time, or the apne.100mbit
> +         module parameter. The driver will attempt to autoprobe 100 Mbit
> +         mode if the PCCARD and PCMCIA kernel configuration options are
> +         selected, so this option may not be necessary. Use apne.100mbit=0
> +         should autoprobe mis-detect a 100 Mbit card.

10 Mbit?

Sorry for reporting it only now. I had noticed in v11, but forgot to
mention it during my review.

For the code:
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
