Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2EC652A3FF
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 15:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348214AbiEQN5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 09:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiEQN5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 09:57:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94673C4A1;
        Tue, 17 May 2022 06:57:35 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5FD4E1F8CA;
        Tue, 17 May 2022 13:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652795854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F/28g65NUYRrE0kqo9hb+aIMt4lDnxj7qFXJPB2SFKQ=;
        b=La0hw1fimyOXZWGy7NhUralYCHdeUAgxZ7Jx2l4teL3ZObgxCoYN3MJlutKivdf7Tw8ScF
        Jcou2BEeZy+SMDvZr2KkytW34i2oUnUQq/Rvj3HIt6rmBgE0M6mmkljwufeUEZWWTXnkMR
        l7FZzEHlQDvQ7gIrbLVQoj/qRxAknBE=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 47D802C141;
        Tue, 17 May 2022 13:57:32 +0000 (UTC)
Date:   Tue, 17 May 2022 15:57:29 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     David Gow <davidgow@google.com>, Evan Green <evgreen@chromium.org>,
        Julius Werner <jwerner@chromium.org>,
        Scott Branden <scott.branden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        akpm@linux-foundation.org, bhe@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-um@lists.infradead.org,
        linux-xtensa@linux-xtensa.org, netdev@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net, rcu@vger.kernel.org,
        sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
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
        zhenwei pi <pizhenwei@bytedance.com>
Subject: Re: [PATCH 19/30] panic: Add the panic hypervisor notifier list
Message-ID: <YoOpyW1+q+Z5as78@alley>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-20-gpiccoli@igalia.com>
 <YoJZVZl/MH0KiE/J@alley>
 <ad082ce7-db50-13bb-3dbb-9b595dfa78be@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad082ce7-db50-13bb-3dbb-9b595dfa78be@igalia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 2022-05-16 12:06:17, Guilherme G. Piccoli wrote:
> Thanks for the review!
> 
> I agree with the blinking stuff, I can rework and add all LED/blinking
> stuff into the loop list, it does make sense. I'll comment a bit in the
> others below...
> 
> On 16/05/2022 11:01, Petr Mladek wrote:
> >> --- a/drivers/firmware/google/gsmi.c
> >> +++ b/drivers/firmware/google/gsmi.c
> >> @@ -1034,7 +1034,7 @@ static __init int gsmi_init(void)
> >>  
> >>  	register_reboot_notifier(&gsmi_reboot_notifier);
> >>  	register_die_notifier(&gsmi_die_notifier);
> >> -	atomic_notifier_chain_register(&panic_notifier_list,
> >> +	atomic_notifier_chain_register(&panic_hypervisor_list,
> >>  				       &gsmi_panic_notifier);
> > 
> > I am not sure about this one. It looks like some logging or
> > pre_reboot stuff.
> > 
> 
> Disagree here. I'm looping Google maintainers, so they can comment.
> (CCed Evan, David, Julius)
> 
> This notifier is clearly a hypervisor notification mechanism. I've fixed
> a locking stuff there (in previous patch), I feel it's low-risk but even
> if it's mid-risk, the class of such callback remains a perfect fit with
> the hypervisor list IMHO.

It is similar to drivers/soc/bcm/brcmstb/pm/pm-arm.c.
See below for another idea.

> >> --- a/drivers/misc/bcm-vk/bcm_vk_dev.c
> >> +++ b/drivers/misc/bcm-vk/bcm_vk_dev.c
> >> @@ -1446,7 +1446,7 @@ static int bcm_vk_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >>  
> >>  	/* register for panic notifier */
> >>  	vk->panic_nb.notifier_call = bcm_vk_on_panic;
> >> -	err = atomic_notifier_chain_register(&panic_notifier_list,
> >> +	err = atomic_notifier_chain_register(&panic_hypervisor_list,
> >>  					     &vk->panic_nb);
> > 
> > It seems to reset some hardware or so. IMHO, it should go into the
> > pre-reboot list.
> 
> Mixed feelings here, I'm looping Broadcom maintainers to comment.
> (CC Scott and Broadcom list)
> 
> I'm afraid it breaks kdump if this device is not reset beforehand - it's
> a doorbell write, so not high risk I think...
> 
> But in case the not-reset device can be probed normally in kdump kernel,
> then I'm fine in moving this to the reboot list! I don't have the HW to
> test myself.

Good question. Well, it if has to be called before kdump then
even "hypervisor" list is a wrong place because is not always
called before kdump.


> >> --- a/drivers/power/reset/ltc2952-poweroff.c
> >> +++ b/drivers/power/reset/ltc2952-poweroff.c
> >> @@ -279,7 +279,7 @@ static int ltc2952_poweroff_probe(struct platform_device *pdev)
> >>  	pm_power_off = ltc2952_poweroff_kill;
> >>  
> >>  	data->panic_notifier.notifier_call = ltc2952_poweroff_notify_panic;
> >> -	atomic_notifier_chain_register(&panic_notifier_list,
> >> +	atomic_notifier_chain_register(&panic_hypervisor_list,
> >>  				       &data->panic_notifier);
> > 
> > I looks like this somehow triggers the reboot. IMHO, it should go
> > into the pre_reboot list.
> 
> Mixed feeling again here - CCing the maintainers for comments (Sebastian
> / PM folks).
> 
> This is setting a variable only, and once it's set (data->kernel_panic
> is the bool's name), it just bails out the IRQ handler and a timer
> setting - this timer seems kinda tricky, so bailing out ASAP makes sense
> IMHO.

IMHO, the timer informs the hardware that the system is still alive
in the middle of panic(). If the timer is not working then the
hardware (chip) will think that the system frozen in panic()
and will power off the system. See the comments in
drivers/power/reset/ltc2952-poweroff.c:

 * The following GPIOs are used:
 * - trigger (input)
 *     A level change indicates the shut-down trigger. If it's state reverts
 *     within the time-out defined by trigger_delay, the shut down is not
 *     executed. If no pin is assigned to this input, the driver will start the
 *     watchdog toggle immediately. The chip will only power off the system if
 *     it is requested to do so through the kill line.
 *
 * - watchdog (output)
 *     Once a shut down is triggered, the driver will toggle this signal,
 *     with an internal (wde_interval) to stall the hardware shut down.

IMHO, we really have to keep it alive until we reach the reboot stage.

Another question is how it actually works when the interrupts are
disabled during panic() and the timer callbacks are not handled.


> > [...]
> >> --- a/drivers/soc/bcm/brcmstb/pm/pm-arm.c
> >> +++ b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
> >> @@ -814,7 +814,7 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
> >>  		goto out;
> >>  	}
> >>  
> >> -	atomic_notifier_chain_register(&panic_notifier_list,
> >> +	atomic_notifier_chain_register(&panic_hypervisor_list,
> >>  				       &brcmstb_pm_panic_nb);
> > 
> > I am not sure about this one. It instruct some HW to preserve DRAM.
> > IMHO, it better fits into pre_reboot category but I do not have
> > strong opinion.
> 
> Disagree here, I'm CCing Florian for information.
> 
> This notifier preserves RAM so it's *very interesting* if we have
> kmsg_dump() for example, but maybe might be also relevant in case kdump
> kernel is configured to store something in a persistent RAM (then,
> without this notifier, after kdump reboots the system data would be lost).

I see. It is actually similar problem as with
drivers/firmware/google/gsmi.c.

I does similar things like kmsg_dump() so it should be called in
the same location (after info notifier list and before kdump).

A solution might be to put it at these notifiers at the very
end of the "info" list or make extra "dump" notifier list.

Best Regards,
Petr
