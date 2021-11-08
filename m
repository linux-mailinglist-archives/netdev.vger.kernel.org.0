Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1163844993E
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 17:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237877AbhKHQPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 11:15:19 -0500
Received: from mail-ua1-f42.google.com ([209.85.222.42]:36511 "EHLO
        mail-ua1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbhKHQPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 11:15:15 -0500
Received: by mail-ua1-f42.google.com with SMTP id e10so32564015uab.3;
        Mon, 08 Nov 2021 08:12:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hEQQmRj7LTpJogPgt2xRVOX7N+txus6iMmGepIZghfU=;
        b=6Syoq3UJc9F69Br0sBFpk6RXHRMeuYXTvKjf4/mPkGe4FYwxl6tGFzpgg5Ffeef7QH
         jXnjEmKBI2Gr5+Xow1AQTwKFMBiHN52GceJ07J01c2xOO96O7RaMIpW2fPxqhM4ltjX0
         ADkJrllkqdxhszF3ASqri5CNVzXw3FMsIq+DaP0Vh8dtlWwMIslFznFFE5up3PlEAbQz
         M0ROOfLDGYH+D8tEQSi7tUMGNbEGm8eYCUR+bDFaEc8LuiEdgQf2F+iDlQvXjNcEVaGL
         THVDJhBiJ59Om9S9/FXuY0GNsdQGvF35U3YlJvq+qkSuRahZ+Wvx2/50KDXS2Ieqpxco
         Qzfg==
X-Gm-Message-State: AOAM530E2jUS0t/A6z8puiwBo7zU97dFnqpAITI+Qi9jpLPxnz9GACEv
        EyrNPGOZNcZS4LazJnF/jQXArVVGU+Kix41X
X-Google-Smtp-Source: ABdhPJxb7f8vOf1U8hfBptjO9dfxwRBRUSwReN0xMc/29Wjx93em3eNYCiggGS5kLSVRuKyq/aAMqQ==
X-Received: by 2002:a05:6102:3ed4:: with SMTP id n20mr114208vsv.57.1636387948517;
        Mon, 08 Nov 2021 08:12:28 -0800 (PST)
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com. [209.85.221.180])
        by smtp.gmail.com with ESMTPSA id t76sm2751741vkt.0.2021.11.08.08.12.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 08:12:27 -0800 (PST)
Received: by mail-vk1-f180.google.com with SMTP id t127so8459709vke.13;
        Mon, 08 Nov 2021 08:12:27 -0800 (PST)
X-Received: by 2002:a1f:f24f:: with SMTP id q76mr347755vkh.11.1636387947335;
 Mon, 08 Nov 2021 08:12:27 -0800 (PST)
MIME-Version: 1.0
References: <20211108101157.15189-1-bp@alien8.de> <20211108101157.15189-43-bp@alien8.de>
 <CAMuHMdWH+txiSP_d7Jc4f_bU8Lf9iWpT4E3o5o7BJr-YdA6-VA@mail.gmail.com>
 <YYkyUEqcsOwQMb1S@zn.tnic> <CAMuHMdXiBEQyEXJagSfpH44hxVA2t0sDH7B7YubLGHrb2MJLLA@mail.gmail.com>
 <YYlJQYLiIrhjwOmT@zn.tnic>
In-Reply-To: <YYlJQYLiIrhjwOmT@zn.tnic>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 8 Nov 2021 17:12:16 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXHikGrmUzuq0WG5JRHUUE=5zsaVCTF+e4TiHpM5tc5kA@mail.gmail.com>
Message-ID: <CAMuHMdXHikGrmUzuq0WG5JRHUUE=5zsaVCTF+e4TiHpM5tc5kA@mail.gmail.com>
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

On Mon, Nov 8, 2021 at 4:59 PM Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Nov 08, 2021 at 04:25:47PM +0100, Geert Uytterhoeven wrote:
> > I'm not against returning proper errors codes.  I'm against forcing
> > callers to check things that cannot fail and to add individual error
> > printing to each and every caller.
>
> If you're against checking things at the callers, then the registration
> function should be void. IOW, those APIs are not optimally designed atm.

Returning void is the other extreme ;-)

There are 3 levels (ignoring BUG_ON()/panic () inside the callee):
  1. Return void: no one can check success or failure,
  2. Return an error code: up to the caller to decide,
  3. Return a __must_check error code: every caller must check.

I'm in favor of 2, as there are several places where it cannot fail.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
