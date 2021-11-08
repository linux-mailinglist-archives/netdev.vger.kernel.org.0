Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03043449878
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 16:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240931AbhKHPgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 10:36:08 -0500
Received: from mail-qt1-f172.google.com ([209.85.160.172]:43861 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240901AbhKHPgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 10:36:04 -0500
Received: by mail-qt1-f172.google.com with SMTP id 8so13954457qty.10;
        Mon, 08 Nov 2021 07:33:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x4ykPITI22sSh/L6reU4seHVLFfVjdO/v+W3/SN8DUg=;
        b=AK5+ymHpBJW394fq5QAJLtdTA/ZOqD4CMNR9HBtKgBlKaocEikykm9zWu2Qq3FsTDL
         IBKgKBLjeGow4SxpkJ3x2oRGNnBBM0NSZ7leYaUE+sCbLlU8e+JdCCmHwGdf11yTS7jj
         INUpSYd8YTGwyay9k1OcwzYpdYcV9EphK2OvOUVV9gSZxXZxi4QIiBYrsZTyoOgrppre
         0wprgxHXRXz//JJtuaBp7hB+dbvc/y85rRMUeNSC0zaCdkGtvZcR3mZvLtetjRGhVxNU
         Kq48BbcYt3WMF9YTaLnfqSufIaTCw2FbfsTbHiFPM419cNwj86653TvYIoMnsf+J4fK+
         gBYw==
X-Gm-Message-State: AOAM533eiMtrTJQK05ouqSS0wCB8B6mKp/DGcpb7z8dQ92ZCTvl80eY0
        jARg/oG42UJJhg0c3f7dAUMoRa5LWBurk5lZ
X-Google-Smtp-Source: ABdhPJykPOH3YWmh1bWslDbzGH3og2HDnOT28nOQQhf2wbjOhuI4A+4quz4f35G+kzZC3Oinm8VRnw==
X-Received: by 2002:ac8:5a4b:: with SMTP id o11mr304870qta.321.1636385597559;
        Mon, 08 Nov 2021 07:33:17 -0800 (PST)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id i14sm11098927qti.25.2021.11.08.07.33.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 07:33:17 -0800 (PST)
Received: by mail-yb1-f174.google.com with SMTP id v7so44765592ybq.0;
        Mon, 08 Nov 2021 07:33:17 -0800 (PST)
X-Received: by 2002:a9f:2c98:: with SMTP id w24mr725068uaj.89.1636385158322;
 Mon, 08 Nov 2021 07:25:58 -0800 (PST)
MIME-Version: 1.0
References: <20211108101157.15189-1-bp@alien8.de> <20211108101157.15189-43-bp@alien8.de>
 <CAMuHMdWH+txiSP_d7Jc4f_bU8Lf9iWpT4E3o5o7BJr-YdA6-VA@mail.gmail.com> <YYkyUEqcsOwQMb1S@zn.tnic>
In-Reply-To: <YYkyUEqcsOwQMb1S@zn.tnic>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 8 Nov 2021 16:25:47 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXiBEQyEXJagSfpH44hxVA2t0sDH7B7YubLGHrb2MJLLA@mail.gmail.com>
Message-ID: <CAMuHMdXiBEQyEXJagSfpH44hxVA2t0sDH7B7YubLGHrb2MJLLA@mail.gmail.com>
Subject: Re: [PATCH v0 42/42] notifier: Return an error when callback is
 already registered
To:     Borislav Petkov <bp@alien8.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        intel-gvt-dev@lists.freedesktop.org,
        alpha <linux-alpha@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-edac@vger.kernel.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-leds <linux-leds@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "open list:REMOTE PROCESSOR (REMOTEPROC) SUBSYSTEM" 
        <linux-remoteproc@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        scsi <linux-scsi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        linux-staging@lists.linux.dev,
        linux-tegra <linux-tegra@vger.kernel.org>,
        linux-um <linux-um@lists.infradead.org>,
        USB list <linux-usb@vger.kernel.org>,
        "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>, netdev <netdev@vger.kernel.org>,
        openipmi-developer@lists.sourceforge.net, rcu@vger.kernel.org,
        sparclinux <sparclinux@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Borislav,

On Mon, Nov 8, 2021 at 3:21 PM Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Nov 08, 2021 at 03:07:03PM +0100, Geert Uytterhoeven wrote:
> > I think the addition of __must_check is overkill, leading to the
> > addition of useless error checks and message printing.
>
> See the WARN in notifier_chain_register() - it will already do "message
> printing".

I mean the addition of useless error checks and message printing _to
the callers_.

> > Many callers call this where it cannot fail, and where nothing can
> > be done in the very unlikely event that the call would ever start to
> > fail.
>
> This is an attempt to remove this WARN() hack in
> notifier_chain_register() and have the function return a proper error
> value instead of this "Currently always returns zero." which is bad
> design.
>
> Some of the registration functions around the tree check that retval and
> some don't. So if "it cannot fail" those registration either should not
> return a value or callers should check that return value - what we have
> now doesn't make a whole lot of sense.

With __must_check callers are required to check, even if they know
it cannot fail.

> Oh, and then fixing this should avoid stuff like:
>
> +       if (notifier_registered == false) {
> +               mce_register_decode_chain(&amdgpu_bad_page_nb);
> +               notifier_registered = true;
> +       }
>
> from propagating in the code.

That's unrelated to the addition of __must_check.

I'm not against returning proper errors codes.  I'm against forcing
callers to check things that cannot fail and to add individual error
printing to each and every caller.

Note that in other areas, we are moving in the other
direction, to a centralized printing of error messages,
cfr. e.g. commit 7723f4c5ecdb8d83 ("driver core: platform: Add an
error message to platform_get_irq*()").

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
