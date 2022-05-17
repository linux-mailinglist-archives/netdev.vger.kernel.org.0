Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6ED52A46F
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 16:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348524AbiEQOMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 10:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348525AbiEQOLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 10:11:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FB9EAE;
        Tue, 17 May 2022 07:11:06 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 67D211F8CA;
        Tue, 17 May 2022 14:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652796665; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UazRNADyyJz2HI+RS6R0a4/dm7+XkEeyBn9yGoLISk0=;
        b=BKp7+FEVfq6NcVwdI04E/j1IXhL8fav2W9wQb6/2V+MLS4zVCpGBL04+5kiZPUHpPEWWSJ
        UCuw6cy5UFA5oDKAHRw0jxrGspZnMX7jbttS2tX8QWMEWQryA8mHzjbrpe5MfzzbeKkAE+
        HL6pRS/de3kEkB9TyLHSW9ZDBKYUAwA=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 10D772C141;
        Tue, 17 May 2022 14:11:04 +0000 (UTC)
Date:   Tue, 17 May 2022 16:11:00 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
        <openipmi-developer@lists.sourceforge.net>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kernel-dev@igalia.com" <kernel-dev@igalia.com>,
        "kernel@gpiccoli.net" <kernel@gpiccoli.net>,
        "halves@canonical.com" <halves@canonical.com>,
        "fabiomirmar@gmail.com" <fabiomirmar@gmail.com>,
        "alejandro.j.jimenez@oracle.com" <alejandro.j.jimenez@oracle.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "bp@alien8.de" <bp@alien8.de>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        "Tang, Feng" <feng.tang@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mikelley@microsoft.com" <mikelley@microsoft.com>,
        "hidehiro.kawai.ez@hitachi.com" <hidehiro.kawai.ez@hitachi.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "john.ogness@linutronix.de" <john.ogness@linutronix.de>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "will@kernel.org" <will@kernel.org>, Alex Elder <elder@kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Chris Zankel <chris@zankel.net>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Corey Minyard <minyard@acm.org>,
        Dexuan Cui <decui@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Helge Deller <deller@gmx.de>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        James Morse <james.morse@arm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Matt Turner <mattst88@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
        Richard Weinberger <richard@nod.at>,
        Robert Richter <rric@kernel.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH 21/30] panic: Introduce the panic pre-reboot notifier list
Message-ID: <YoOs9GJ5Ovq63u5Q@alley>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-22-gpiccoli@igalia.com>
 <YoJgcC8c6LaKADZV@alley>
 <63a74b56-89ef-8d1f-d487-cdb986aab798@igalia.com>
 <bed66b9467254a5a8bafc1983dad643a@intel.com>
 <e895ce94-e6b9-caf6-e5d3-06bf0149445c@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e895ce94-e6b9-caf6-e5d3-06bf0149445c@igalia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 2022-05-16 13:33:51, Guilherme G. Piccoli wrote:
> On 16/05/2022 13:18, Luck, Tony wrote:
> >> [...]
> > Would it be possible to have some global "kdump is configured + enabled" flag?
> > 
> > Then notifiers could make an informed choice on whether to deep dive to
> > get all the possible details (when there is no kdump) or just skim the high
> > level stuff (to maximize chance of getting a successful kdump).
> > 
> > -Tony
> 
> Good idea Tony! What if I wire a kexec_crash_loaded() in the notifier?

I like this idea.

One small problem is that kexec_crash_loaded() has valid result
only under kexec_mutex. On the other hand, it should stay true
once loaded so that the small race window should be innocent.

> With that, are you/Petr/Dinh OK in moving it for the info list?

Sounds good to me.

Best Regards,
Petr
