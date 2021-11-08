Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37B544817E
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 15:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240485AbhKHOYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 09:24:11 -0500
Received: from mail.skyhub.de ([5.9.137.197]:49490 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240432AbhKHOX6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 09:23:58 -0500
Received: from zn.tnic (p200300ec2f33110093973d8dfcf40fd9.dip0.t-ipconnect.de [IPv6:2003:ec:2f33:1100:9397:3d8d:fcf4:fd9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D08561EC04E4;
        Mon,  8 Nov 2021 15:21:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1636381269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=oWsCJGhsvF17zUFafKKKz1XGvPrCUoTgLb0x72qzY0w=;
        b=DvalVyPWlBMIVGIell7SDhnTX9Q86iHxoTdmXzPxorrW7sqlHpzQzwtFgZEI1KmHXq30Gs
        yOE/y0FWs3djKZaj7cQDtIyWYYD5AKtdhjFE5l3EWLo8DNcP+YE1HL9C5d3kHwZrzRPHP8
        xiS/nYCk2AFbtbv/wLq5RqiIdGlMN38=
Date:   Mon, 8 Nov 2021 15:21:04 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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
        the arch/x86 maintainers <x86@kernel.org>,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH v0 42/42] notifier: Return an error when callback is
 already registered
Message-ID: <YYkyUEqcsOwQMb1S@zn.tnic>
References: <20211108101157.15189-1-bp@alien8.de>
 <20211108101157.15189-43-bp@alien8.de>
 <CAMuHMdWH+txiSP_d7Jc4f_bU8Lf9iWpT4E3o5o7BJr-YdA6-VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdWH+txiSP_d7Jc4f_bU8Lf9iWpT4E3o5o7BJr-YdA6-VA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 03:07:03PM +0100, Geert Uytterhoeven wrote:
> I think the addition of __must_check is overkill, leading to the
> addition of useless error checks and message printing.

See the WARN in notifier_chain_register() - it will already do "message
printing".

> Many callers call this where it cannot fail, and where nothing can
> be done in the very unlikely event that the call would ever start to
> fail.

This is an attempt to remove this WARN() hack in
notifier_chain_register() and have the function return a proper error
value instead of this "Currently always returns zero." which is bad
design.

Some of the registration functions around the tree check that retval and
some don't. So if "it cannot fail" those registration either should not
return a value or callers should check that return value - what we have
now doesn't make a whole lot of sense.

Oh, and then fixing this should avoid stuff like:

+	if (notifier_registered == false) {
+		mce_register_decode_chain(&amdgpu_bad_page_nb);
+		notifier_registered = true;
+	}

from propagating in the code.

The other idea I have is to add another indirection in
notifier_chain_register() which will check the *proper* return value of
a lower level __notifier_chain_register() and then issue that warning.
That would definitely avoid touch so many call sites.

Bottom line is: what we have now needs cleaning up.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
