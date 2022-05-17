Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E34652A35A
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 15:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347715AbiEQN2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 09:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346419AbiEQN22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 09:28:28 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0519434B4;
        Tue, 17 May 2022 06:28:24 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4DBA821CC7;
        Tue, 17 May 2022 13:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652794103; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m8eH28qbE+2Xy0DKW3X9feLJxxFiFeYxt7IWdkwBacU=;
        b=D3nbGBAQ9bCKnB1WwjJRY0SPMWZeGE7s6okektsDFoMjSCg4MWkDlGu0CaIrnv72L2dSjB
        TH4hbCd7WNPBQBo5APMhOgzqiXxMfJKdv72h+T8GhDipQ36bscz5ULSJq0aGA9QxAaz7ZE
        2DHOtfp4NZ3vqG8gLdmAnQza/SAFmg4=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id DE9622C141;
        Tue, 17 May 2022 13:28:20 +0000 (UTC)
Date:   Tue, 17 May 2022 15:28:20 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Evan Green <evgreen@chromium.org>
Cc:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        David Gow <davidgow@google.com>,
        Julius Werner <jwerner@chromium.org>,
        Scott Branden <scott.branden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Sebastian Reichel <sre@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, bhe@redhat.com,
        kexec@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, kernel@gpiccoli.net, halves@canonical.com,
        fabiomirmar@gmail.com, alejandro.j.jimenez@oracle.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Jonathan Corbet <corbet@lwn.net>, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de,
        Kees Cook <keescook@chromium.org>, luto@kernel.org,
        mhiramat@kernel.org, mingo@redhat.com, paulmck@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, Alan Stern <stern@rowland.harvard.edu>,
        Thomas Gleixner <tglx@linutronix.de>, vgoyal@redhat.com,
        vkuznets@redhat.com, Will Deacon <will@kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Doug Berger <opendmb@gmail.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Justin Chen <justinpopo6@gmail.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lee Jones <lee.jones@linaro.org>,
        Markus Mayer <mmayer@broadcom.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Wei Liu <wei.liu@kernel.org>,
        zhenwei pi <pizhenwei@bytedance.com>,
        Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH 19/30] panic: Add the panic hypervisor notifier list
Message-ID: <YoOi9PFK/JnNwH+D@alley>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-20-gpiccoli@igalia.com>
 <YoJZVZl/MH0KiE/J@alley>
 <ad082ce7-db50-13bb-3dbb-9b595dfa78be@igalia.com>
 <CAE=gft7ds+dHfEkRz8rnSH1EbTpGTpKbi5Wxj9DW0Jr5mX_j4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE=gft7ds+dHfEkRz8rnSH1EbTpGTpKbi5Wxj9DW0Jr5mX_j4w@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 2022-05-16 09:02:10, Evan Green wrote:
> On Mon, May 16, 2022 at 8:07 AM Guilherme G. Piccoli
> <gpiccoli@igalia.com> wrote:
> >
> > Thanks for the review!
> >
> > I agree with the blinking stuff, I can rework and add all LED/blinking
> > stuff into the loop list, it does make sense. I'll comment a bit in the
> > others below...
> >
> > On 16/05/2022 11:01, Petr Mladek wrote:
> > > [...]
> > >> --- a/arch/mips/sgi-ip22/ip22-reset.c
> > >> +++ b/arch/mips/sgi-ip22/ip22-reset.c
> > >> @@ -195,7 +195,7 @@ static int __init reboot_setup(void)
> > >>      }
> > >>
> > >>      timer_setup(&blink_timer, blink_timeout, 0);
> > >> -    atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
> > >> +    atomic_notifier_chain_register(&panic_hypervisor_list, &panic_block);
> > >
> > > This notifier enables blinking. It is not much safe. It calls
> > > mod_timer() that takes a lock internally.
> > >
> > > This kind of functionality should go into the last list called
> > > before panic() enters the infinite loop. IMHO, all the blinking
> > > stuff should go there.
> > > [...]
> > >> --- a/arch/mips/sgi-ip32/ip32-reset.c
> > >> +++ b/arch/mips/sgi-ip32/ip32-reset.c
> > >> @@ -145,7 +144,7 @@ static __init int ip32_reboot_setup(void)
> > >>      pm_power_off = ip32_machine_halt;
> > >>
> > >>      timer_setup(&blink_timer, blink_timeout, 0);
> > >> -    atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
> > >> +    atomic_notifier_chain_register(&panic_hypervisor_list, &panic_block);
> > >
> > > Same here. Should be done only before the "loop".
> > > [...]
> >
> > Ack.
> >
> >
> > >> --- a/drivers/firmware/google/gsmi.c
> > >> +++ b/drivers/firmware/google/gsmi.c
> > >> @@ -1034,7 +1034,7 @@ static __init int gsmi_init(void)
> > >>
> > >>      register_reboot_notifier(&gsmi_reboot_notifier);
> > >>      register_die_notifier(&gsmi_die_notifier);
> > >> -    atomic_notifier_chain_register(&panic_notifier_list,
> > >> +    atomic_notifier_chain_register(&panic_hypervisor_list,
> > >>                                     &gsmi_panic_notifier);
> > >
> > > I am not sure about this one. It looks like some logging or
> > > pre_reboot stuff.
> > >
> >
> > Disagree here. I'm looping Google maintainers, so they can comment.
> > (CCed Evan, David, Julius)
> >
> > This notifier is clearly a hypervisor notification mechanism. I've fixed
> > a locking stuff there (in previous patch), I feel it's low-risk but even
> > if it's mid-risk, the class of such callback remains a perfect fit with
> > the hypervisor list IMHO.
>
> This logs a panic to our "eventlog", a tiny logging area in SPI flash
> for critical and power-related events. In some cases this ends up
> being the only clue we get in a Chromebook feedback report that a
> panic occurred, so from my perspective moving it to the front of the
> line seems like a good idea.

IMHO, this would really better fit into the pre-reboot notifier list:

   + the callback stores the log so it is similar to kmsg_dump()
     or console_flush_on_panic()

   + the callback should be proceed after "info" notifiers
     that might add some other useful information.

Honestly, I am not sure what exactly hypervisor callbacks do. But I
think that they do not try to extract the kernel log because they
would need to handle the internal format.

Best Regards,
Petr
