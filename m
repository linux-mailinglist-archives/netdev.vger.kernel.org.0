Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6C744999B
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 17:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241256AbhKHQ0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 11:26:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:59728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237287AbhKHQ0D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 11:26:03 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E868D61284;
        Mon,  8 Nov 2021 16:23:14 +0000 (UTC)
Date:   Mon, 8 Nov 2021 11:23:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rohit Maheshwari <rohitm@chelsio.com>,
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
Message-ID: <20211108112313.73d0727e@gandalf.local.home>
In-Reply-To: <YYk1xi3eJdMJdjHC@zn.tnic>
References: <20211108101157.15189-1-bp@alien8.de>
        <20211108101924.15759-1-bp@alien8.de>
        <20211108141703.GB1666297@rowland.harvard.edu>
        <YYkzJ3+faVga2Tl3@zn.tnic>
        <YYk1xi3eJdMJdjHC@zn.tnic>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Nov 2021 15:35:50 +0100
Borislav Petkov <bp@alien8.de> wrote:

> On Mon, Nov 08, 2021 at 03:24:39PM +0100, Borislav Petkov wrote:
> > I guess I can add another indirection to notifier_chain_register() and
> > avoid touching all the call sites.  
> 
> IOW, something like this below.
> 
> This way I won't have to touch all the callsites and the registration
> routines would still return a proper value instead of returning 0
> unconditionally.

I prefer this method.

Question, how often does this warning trigger? Is it common to see in
development?

-- Steve
