Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73BB4481A6
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 15:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239406AbhKHO1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 09:27:33 -0500
Received: from mail.skyhub.de ([5.9.137.197]:50114 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236155AbhKHO13 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 09:27:29 -0500
Received: from zn.tnic (p200300ec2f33110093973d8dfcf40fd9.dip0.t-ipconnect.de [IPv6:2003:ec:2f33:1100:9397:3d8d:fcf4:fd9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D54F61EC04EE;
        Mon,  8 Nov 2021 15:24:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1636381481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=oQBbYlaqexu4t08cRZdDH3XaT2khXLTGUfDdhXY+o6w=;
        b=BzFVBEJotdv+x1wk5r7BVthkB7IfDjFkcs3Qa23VnQgw6n7GoUvAnfTwnsI1XwsFUQ2pfc
        wTEtmUg2zpiIKZgiV8GtlPXLXcMCnwwX7vbzvuM7Jd46qSvtVDp/eqlUHv6UrUSSdUIxSB
        fTiz2Hj9eXxtQyoPpRyOqBuxOD7Awrk=
Date:   Mon, 8 Nov 2021 15:24:39 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        alsa-devel@alsa-project.org, bcm-kernel-feedback-list@broadcom.com,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-remoteproc@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, netdev@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net, rcu@vger.kernel.org,
        sparclinux@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH v0 00/42] notifiers: Return an error when callback is
 already registered
Message-ID: <YYkzJ3+faVga2Tl3@zn.tnic>
References: <20211108101157.15189-1-bp@alien8.de>
 <20211108101924.15759-1-bp@alien8.de>
 <20211108141703.GB1666297@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211108141703.GB1666297@rowland.harvard.edu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 09:17:03AM -0500, Alan Stern wrote:
> What reason is there for moving the check into the callers?  It seems 
> like pointless churn.  Why not add the error return code, change the 
> WARN to pr_warn, and leave the callers as they are?  Wouldn't that end 
> up having exactly the same effect?
> 
> For that matter, what sort of remedial action can a caller take if the 
> return code is -EEXIST?  Is there any point in forcing callers to check 
> the return code if they can't do anything about it?

See my reply to Geert from just now:

https://lore.kernel.org/r/YYkyUEqcsOwQMb1S@zn.tnic

I guess I can add another indirection to notifier_chain_register() and
avoid touching all the call sites.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
