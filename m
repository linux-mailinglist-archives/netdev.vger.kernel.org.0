Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37725528645
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 16:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244241AbiEPOCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 10:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235347AbiEPOCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 10:02:03 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290271A389;
        Mon, 16 May 2022 07:02:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2362F21F5C;
        Mon, 16 May 2022 14:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652709720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6xX/Xo1YcyoxhDGVtD+3aF7M9NKMVvtDcsL11SFSAQU=;
        b=UAEfoymfYf+QAbCzE3oYFS/LnW9rFBs924Unv93LKXY9GoxfXpJbDSZbNYQc1AwPujLxjA
        jmh7TvIJcQUwFXF0iE9L66PiKtfkKtU88t+hUCpM3m0czPO3TM37NQr+8KouKC5lf5Okex
        k2McswvfGUIvb+tozWKmApBRPL9ucl0=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D43112C141;
        Mon, 16 May 2022 14:01:57 +0000 (UTC)
Date:   Mon, 16 May 2022 16:01:57 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, kernel@gpiccoli.net, halves@canonical.com,
        fabiomirmar@gmail.com, alejandro.j.jimenez@oracle.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bp@alien8.de,
        corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
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
        David Gow <davidgow@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Doug Berger <opendmb@gmail.com>,
        Evan Green <evgreen@chromium.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Julius Werner <jwerner@chromium.org>,
        Justin Chen <justinpopo6@gmail.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lee Jones <lee.jones@linaro.org>,
        Markus Mayer <mmayer@broadcom.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
        Scott Branden <scott.branden@broadcom.com>,
        Sebastian Reichel <sre@kernel.org>,
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
Message-ID: <YoJZVZl/MH0KiE/J@alley>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-20-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427224924.592546-20-gpiccoli@igalia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 2022-04-27 19:49:13, Guilherme G. Piccoli wrote:
> The goal of this new panic notifier is to allow its users to register
> callbacks to run very early in the panic path. This aims hypervisor/FW
> notification mechanisms as well as simple LED functions, and any other
> simple and safe mechanism that should run early in the panic path; more
> dangerous callbacks should execute later.
> 
> For now, the patch is almost a no-op (although it changes a bit the
> ordering in which some panic notifiers are executed). In a subsequent
> patch, the panic path will be refactored, then the panic hypervisor
> notifiers will effectively run very early in the panic path.
> 
> We also defer documenting it all properly in the subsequent refactor
> patch. While at it, we removed some useless header inclusions and
> fixed some notifiers return too (by using the standard NOTIFY_DONE).

> --- a/arch/mips/sgi-ip22/ip22-reset.c
> +++ b/arch/mips/sgi-ip22/ip22-reset.c
> @@ -195,7 +195,7 @@ static int __init reboot_setup(void)
>  	}
>  
>  	timer_setup(&blink_timer, blink_timeout, 0);
> -	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
> +	atomic_notifier_chain_register(&panic_hypervisor_list, &panic_block);

This notifier enables blinking. It is not much safe. It calls
mod_timer() that takes a lock internally.

This kind of functionality should go into the last list called
before panic() enters the infinite loop. IMHO, all the blinking
stuff should go there.

>  
>  	return 0;
>  }
> diff --git a/arch/mips/sgi-ip32/ip32-reset.c b/arch/mips/sgi-ip32/ip32-reset.c
> index 18d1c115cd53..9ee1302c9d13 100644
> --- a/arch/mips/sgi-ip32/ip32-reset.c
> +++ b/arch/mips/sgi-ip32/ip32-reset.c
> @@ -145,7 +144,7 @@ static __init int ip32_reboot_setup(void)
>  	pm_power_off = ip32_machine_halt;
>  
>  	timer_setup(&blink_timer, blink_timeout, 0);
> -	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
> +	atomic_notifier_chain_register(&panic_hypervisor_list, &panic_block);

Same here. Should be done only before the "loop".

>  
>  	return 0;
>  }
> --- a/drivers/firmware/google/gsmi.c
> +++ b/drivers/firmware/google/gsmi.c
> @@ -1034,7 +1034,7 @@ static __init int gsmi_init(void)
>  
>  	register_reboot_notifier(&gsmi_reboot_notifier);
>  	register_die_notifier(&gsmi_die_notifier);
> -	atomic_notifier_chain_register(&panic_notifier_list,
> +	atomic_notifier_chain_register(&panic_hypervisor_list,
>  				       &gsmi_panic_notifier);

I am not sure about this one. It looks like some logging or
pre_reboot stuff.


>  
>  	printk(KERN_INFO "gsmi version " DRIVER_VERSION " loaded\n");
> --- a/drivers/leds/trigger/ledtrig-activity.c
> +++ b/drivers/leds/trigger/ledtrig-activity.c
> @@ -247,7 +247,7 @@ static int __init activity_init(void)
>  	int rc = led_trigger_register(&activity_led_trigger);
>  
>  	if (!rc) {
> -		atomic_notifier_chain_register(&panic_notifier_list,
> +		atomic_notifier_chain_register(&panic_hypervisor_list,
>  					       &activity_panic_nb);

The notifier is trivial. It just sets a variable.

But still, it is about blinking and should be done
in the last "loop" list.


>  		register_reboot_notifier(&activity_reboot_nb);
>  	}
> --- a/drivers/leds/trigger/ledtrig-heartbeat.c
> +++ b/drivers/leds/trigger/ledtrig-heartbeat.c
> @@ -190,7 +190,7 @@ static int __init heartbeat_trig_init(void)
>  	int rc = led_trigger_register(&heartbeat_led_trigger);
>  
>  	if (!rc) {
> -		atomic_notifier_chain_register(&panic_notifier_list,
> +		atomic_notifier_chain_register(&panic_hypervisor_list,
>  					       &heartbeat_panic_nb);

Same here. Blinking => loop list.

>  		register_reboot_notifier(&heartbeat_reboot_nb);
>  	}
> diff --git a/drivers/misc/bcm-vk/bcm_vk_dev.c b/drivers/misc/bcm-vk/bcm_vk_dev.c
> index a16b99bdaa13..d9d5199cdb2b 100644
> --- a/drivers/misc/bcm-vk/bcm_vk_dev.c
> +++ b/drivers/misc/bcm-vk/bcm_vk_dev.c
> @@ -1446,7 +1446,7 @@ static int bcm_vk_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  
>  	/* register for panic notifier */
>  	vk->panic_nb.notifier_call = bcm_vk_on_panic;
> -	err = atomic_notifier_chain_register(&panic_notifier_list,
> +	err = atomic_notifier_chain_register(&panic_hypervisor_list,
>  					     &vk->panic_nb);

It seems to reset some hardware or so. IMHO, it should go into the
pre-reboot list.


>  	if (err) {
>  		dev_err(dev, "Fail to register panic notifier\n");
> --- a/drivers/power/reset/ltc2952-poweroff.c
> +++ b/drivers/power/reset/ltc2952-poweroff.c
> @@ -279,7 +279,7 @@ static int ltc2952_poweroff_probe(struct platform_device *pdev)
>  	pm_power_off = ltc2952_poweroff_kill;
>  
>  	data->panic_notifier.notifier_call = ltc2952_poweroff_notify_panic;
> -	atomic_notifier_chain_register(&panic_notifier_list,
> +	atomic_notifier_chain_register(&panic_hypervisor_list,
>  				       &data->panic_notifier);

I looks like this somehow triggers the reboot. IMHO, it should go
into the pre_reboot list.

>  	dev_info(&pdev->dev, "probe successful\n");
>  
> --- a/drivers/soc/bcm/brcmstb/pm/pm-arm.c
> +++ b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
> @@ -814,7 +814,7 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
>  		goto out;
>  	}
>  
> -	atomic_notifier_chain_register(&panic_notifier_list,
> +	atomic_notifier_chain_register(&panic_hypervisor_list,
>  				       &brcmstb_pm_panic_nb);

I am not sure about this one. It instruct some HW to preserve DRAM.
IMHO, it better fits into pre_reboot category but I do not have
strong opinion.

>  
>  	pm_power_off = brcmstb_pm_poweroff;

Best Regards,
Petr
