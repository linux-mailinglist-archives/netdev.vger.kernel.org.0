Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B142945490E
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 15:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhKQOqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 09:46:50 -0500
Received: from mail-vk1-f179.google.com ([209.85.221.179]:38600 "EHLO
        mail-vk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbhKQOqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 09:46:49 -0500
Received: by mail-vk1-f179.google.com with SMTP id s17so1778992vka.5;
        Wed, 17 Nov 2021 06:43:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n+jSP4TidGIB/0F/358A0X7Zhigt9lXvtd0eIhA7wFo=;
        b=L5PyxUhlvFjTBZbA4Y0DVWQUEmRV4qkeAGwOxg1AqW9RB6yIBGWglRNxqYQnB3GUll
         bByR2ce6/OG8xmHxLJ2LZnrVJqgyUIogbmHaOsKCWGOkew1hWzTPWUp3/1i6+MzoY6zT
         szINp3x387lCFi4nZHsCWUKlCEB+FfBiz8RjtpIEr6ZQY+z7AYby17rKddhkwbUhJq3C
         t7raks7wYJzJysYEd0ymJzz1nTc1aNO/yWYLxBmHTMrS605mbiDuUi3T3XjUHeBwB8dE
         6ulUep2tvF/2DP99ZYskiZRLFTdyD5DA9j8HaNqwYVgArt6kcRGMfH1yjO7GL8bFBmBh
         7AuQ==
X-Gm-Message-State: AOAM530Pn7ZpwuVIcNjUQQHPM9KJ3OmBrdXO41hLKrmpoo8nHJeZS98+
        j/H7xGlVeX0G9vI5tHhcyCIrdg/9hGEjyg==
X-Google-Smtp-Source: ABdhPJy4p2m/31sWIoGJUYkFsxComPDocHp/NPu+Rlzu+yPVlPoFCSDirnxgmqV14V6edMtDUAys7g==
X-Received: by 2002:a05:6122:8c8:: with SMTP id 8mr90201286vkg.5.1637160230222;
        Wed, 17 Nov 2021 06:43:50 -0800 (PST)
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com. [209.85.221.179])
        by smtp.gmail.com with ESMTPSA id h10sm3187vsl.34.2021.11.17.06.43.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 06:43:49 -0800 (PST)
Received: by mail-vk1-f179.google.com with SMTP id b125so1769023vkb.9;
        Wed, 17 Nov 2021 06:43:49 -0800 (PST)
X-Received: by 2002:a05:6122:50e:: with SMTP id x14mr89717047vko.7.1637160228914;
 Wed, 17 Nov 2021 06:43:48 -0800 (PST)
MIME-Version: 1.0
References: <20211114234005.335-1-schmitzmic@gmail.com> <20211114234005.335-4-schmitzmic@gmail.com>
In-Reply-To: <20211114234005.335-4-schmitzmic@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 17 Nov 2021 15:42:57 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXj4-D9R_QAgj+vr1j79pPYmoU3uokKHBZFUv5J5jvpaA@mail.gmail.com>
Message-ID: <CAMuHMdXj4-D9R_QAgj+vr1j79pPYmoU3uokKHBZFUv5J5jvpaA@mail.gmail.com>
Subject: Re: [PATCH net v11 3/3] net/8390: apne.c - add 100 Mbit support to
 apne.c driver
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     "Linux/m68k" <linux-m68k@vger.kernel.org>,
        ALeX Kazik <alex@kazik.de>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Mon, Nov 15, 2021 at 12:40 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> Add module parameter, IO mode autoprobe and PCMCIA reset code
> required to support 100 Mbit PCMCIA ethernet cards on Amiga.
>
> 10 Mbit and 100 Mbit mode are supported by the same module.
> Use the core PCMCIA cftable parser to detect 16 bit cards,
> and automatically enable 16 bit ISA IO access for those cards
> by changing isa_type at runtime. The user must select PCCARD
> and PCMCIA in the kernel config to make the necessary support
> modules available
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

Thanks for your patch!

> --- a/drivers/net/ethernet/8390/apne.c
> +++ b/drivers/net/ethernet/8390/apne.c
> @@ -119,6 +119,48 @@ static u32 apne_msg_enable;
>  module_param_named(msg_enable, apne_msg_enable, uint, 0444);
>  MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
>
> +static int apne_100_mbit = -1;
> +module_param_named(100_mbit, apne_100_mbit, int, 0444);
> +MODULE_PARM_DESC(100_mbit, "Enable 100 Mbit support");
> +
> +#if IS_ENABLED(CONFIG_PCMCIA)

What if CONFIG_PCMIA=m, and CONFIG_APNE=y?

> +static int pcmcia_is_16bit(void)
> +{
> +       u_char cftuple[258];
> +       int cftuple_len;
> +       tuple_t cftable_tuple;
> +       cistpl_cftable_entry_t cftable_entry;
> +
> +       cftuple_len = pcmcia_copy_tuple(CISTPL_CFTABLE_ENTRY, cftuple, 256);
> +       if (cftuple_len < 3)
> +               return 0;
> +#ifdef DEBUG
> +       else
> +               print_hex_dump(KERN_WARNING, "cftable: ", DUMP_PREFIX_NONE, 8,
> +                              sizeof(char), cftuple, cftuple_len, false);
> +#endif
> +
> +       /* build tuple_t struct and call pcmcia_parse_tuple */
> +       cftable_tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
> +       cftable_tuple.TupleCode = CISTPL_CFTABLE_ENTRY;
> +       cftable_tuple.TupleData = &cftuple[2];
> +       cftable_tuple.TupleDataLen = cftuple_len - 2;
> +       cftable_tuple.TupleDataMax = cftuple_len - 2;
> +
> +       if (pcmcia_parse_tuple(&cftable_tuple, (cisparse_t *)&cftable_entry))

Can't you avoid the cast, by changing the type of cftable_entry?
Perhaps you don't want to do that, to avoid abusing it below, but
perhaps you can use container_of() instead of the cast?

> +               return 0;
> +
> +#ifdef DEBUG
> +       pr_info("IO flags: %x\n", cftable_entry.io.flags);
> +#endif
> +
> +       if (cftable_entry.io.flags & CISTPL_IO_16BIT)
> +               return 1;
> +
> +       return 0;
> +}
> +#endif
> +
>  static struct net_device * __init apne_probe(void)
>  {
>         struct net_device *dev;
> @@ -140,6 +182,13 @@ static struct net_device * __init apne_probe(void)
>
>         pr_info("Looking for PCMCIA ethernet card : ");
>
> +       if (apne_100_mbit == 1)
> +               isa_type = ISA_TYPE_AG16;
> +       else if (apne_100_mbit == 0)
> +               isa_type = ISA_TYPE_AG;
> +       else
> +               pr_cont(" (autoprobing 16 bit mode) ");
> +
>         /* check if a card is inserted */
>         if (!(PCMCIA_INSERTED)) {
>                 pr_cont("NO PCMCIA card inserted\n");
> @@ -167,6 +216,14 @@ static struct net_device * __init apne_probe(void)
>
>         pr_cont("ethernet PCMCIA card inserted\n");
>
> +#if IS_ENABLED(CONFIG_PCMCIA)
> +       if (apne_100_mbit < 0 && pcmcia_is_16bit()) {
> +               pr_info("16-bit PCMCIA card detected!\n");
> +               isa_type = ISA_TYPE_AG16;
> +               apne_100_mbit = 1;
> +       }

I think you should reset apne_100_mbit to zero if apne_100_mbit < 0
&& !pcmcia_is_16bit(), so rmmod + switching card + modprobe
has a chance to work.

> +#endif
> +
>         if (!init_pcmcia()) {
>                 /* XXX: shouldn't we re-enable irq here? */
>                 free_netdev(dev);


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
