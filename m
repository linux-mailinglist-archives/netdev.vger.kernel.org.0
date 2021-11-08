Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853DC4498ED
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 17:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241127AbhKHQB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 11:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236850AbhKHQBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 11:01:54 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA6DC061570;
        Mon,  8 Nov 2021 07:59:09 -0800 (PST)
Received: from zn.tnic (p200300ec2f331100b486bab6e60d7aaf.dip0.t-ipconnect.de [IPv6:2003:ec:2f33:1100:b486:bab6:e60d:7aaf])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 341131EC04DE;
        Mon,  8 Nov 2021 16:59:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1636387148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=JALJsenIQCt4BletZS/B+Zq0YBxBp6L9Ch45cvOw8XQ=;
        b=LCBDSZEhct23FIVquhfAlhIS3MpLXm84rotG+ppp99dGMPWi9iJHGgKkfiFg0DoLQ+NSWf
        ixY2Bl+WafqAknd6kFkKb4q9SvLPR/pI4iyCTMD6S/zki4CWzqH6/1ZBq8awazUNWt4Xi0
        idSLz3mdlao9wfI9n1SzGKhLH2sR0dI=
Date:   Mon, 8 Nov 2021 16:58:57 +0100
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
Message-ID: <YYlJQYLiIrhjwOmT@zn.tnic>
References: <20211108101157.15189-1-bp@alien8.de>
 <20211108101157.15189-43-bp@alien8.de>
 <CAMuHMdWH+txiSP_d7Jc4f_bU8Lf9iWpT4E3o5o7BJr-YdA6-VA@mail.gmail.com>
 <YYkyUEqcsOwQMb1S@zn.tnic>
 <CAMuHMdXiBEQyEXJagSfpH44hxVA2t0sDH7B7YubLGHrb2MJLLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdXiBEQyEXJagSfpH44hxVA2t0sDH7B7YubLGHrb2MJLLA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 04:25:47PM +0100, Geert Uytterhoeven wrote:
> I'm not against returning proper errors codes.  I'm against forcing
> callers to check things that cannot fail and to add individual error
> printing to each and every caller.

If you're against checking things at the callers, then the registration
function should be void. IOW, those APIs are not optimally designed atm.

> Note that in other areas, we are moving in the other direction,
> to a centralized printing of error messages, cfr. e.g. commit
> 7723f4c5ecdb8d83 ("driver core: platform: Add an error message to
> platform_get_irq*()").

Yes, thus my other idea to add a lower level __notifier_chain_register()
to do the checking.

I'll see if I can convert those notifier registration functions to
return void, in the process. But let's see what the others think first.

Thanks for taking the time.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
