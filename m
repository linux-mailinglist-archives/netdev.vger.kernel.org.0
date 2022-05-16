Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A024152880D
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 17:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244961AbiEPPHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 11:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238196AbiEPPHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 11:07:30 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1863B3DA;
        Mon, 16 May 2022 08:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=x8rylV2fo2RhFyw7lXZ7iRi1TUSl/qSAgQ1QFQa6Swk=; b=feXctn9xVfAtMOxpqtYyQ3CA85
        BjdcLwwe8TiMsRw2fUykvtPuvzY6hmKnTuAYE+A0XsmmVYSLQ/kcthiUMBKg0mNjJ1yc4l+lLSsmf
        USmCbBkmQnOZm2iGOSrx6Rl0cCpZ73ILK767ZxXmwm6a3QHv/+OS7mfra0PYCo9fNU1O9VQyfm4pw
        6HrCZSPKvKswSfp/Eu6sagLk3Urn9HpvONKk/wFmV32LKFF9WaILoOgpFS5qfU8S7XCa8c/aUXIoQ
        86eaCmPOCcjnQf8OfgMGzWfOoSFt/jwGca1nP55u94yjF/tPVCKn3Ik3vagLqYanseWDcV4ZXGkRO
        T9pShFkw==;
Received: from [177.183.162.244] (helo=[192.168.0.5])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nqcJI-006nIW-Cg; Mon, 16 May 2022 17:07:00 +0200
Message-ID: <ad082ce7-db50-13bb-3dbb-9b595dfa78be@igalia.com>
Date:   Mon, 16 May 2022 12:06:17 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 19/30] panic: Add the panic hypervisor notifier list
Content-Language: en-US
To:     Petr Mladek <pmladek@suse.com>, David Gow <davidgow@google.com>,
        Evan Green <evgreen@chromium.org>,
        Julius Werner <jwerner@chromium.org>,
        Scott Branden <scott.branden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com,
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
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-20-gpiccoli@igalia.com> <YoJZVZl/MH0KiE/J@alley>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <YoJZVZl/MH0KiE/J@alley>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review!

I agree with the blinking stuff, I can rework and add all LED/blinking
stuff into the loop list, it does make sense. I'll comment a bit in the
others below...

On 16/05/2022 11:01, Petr Mladek wrote:
> [...]
>> --- a/arch/mips/sgi-ip22/ip22-reset.c
>> +++ b/arch/mips/sgi-ip22/ip22-reset.c
>> @@ -195,7 +195,7 @@ static int __init reboot_setup(void)
>>  	}
>>  
>>  	timer_setup(&blink_timer, blink_timeout, 0);
>> -	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
>> +	atomic_notifier_chain_register(&panic_hypervisor_list, &panic_block);
> 
> This notifier enables blinking. It is not much safe. It calls
> mod_timer() that takes a lock internally.
> 
> This kind of functionality should go into the last list called
> before panic() enters the infinite loop. IMHO, all the blinking
> stuff should go there.
> [...] 
>> --- a/arch/mips/sgi-ip32/ip32-reset.c
>> +++ b/arch/mips/sgi-ip32/ip32-reset.c
>> @@ -145,7 +144,7 @@ static __init int ip32_reboot_setup(void)
>>  	pm_power_off = ip32_machine_halt;
>>  
>>  	timer_setup(&blink_timer, blink_timeout, 0);
>> -	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
>> +	atomic_notifier_chain_register(&panic_hypervisor_list, &panic_block);
> 
> Same here. Should be done only before the "loop".
> [...] 

Ack.


>> --- a/drivers/firmware/google/gsmi.c
>> +++ b/drivers/firmware/google/gsmi.c
>> @@ -1034,7 +1034,7 @@ static __init int gsmi_init(void)
>>  
>>  	register_reboot_notifier(&gsmi_reboot_notifier);
>>  	register_die_notifier(&gsmi_die_notifier);
>> -	atomic_notifier_chain_register(&panic_notifier_list,
>> +	atomic_notifier_chain_register(&panic_hypervisor_list,
>>  				       &gsmi_panic_notifier);
> 
> I am not sure about this one. It looks like some logging or
> pre_reboot stuff.
> 

Disagree here. I'm looping Google maintainers, so they can comment.
(CCed Evan, David, Julius)

This notifier is clearly a hypervisor notification mechanism. I've fixed
a locking stuff there (in previous patch), I feel it's low-risk but even
if it's mid-risk, the class of such callback remains a perfect fit with
the hypervisor list IMHO.


> [...] 
>> --- a/drivers/leds/trigger/ledtrig-activity.c
>> +++ b/drivers/leds/trigger/ledtrig-activity.c
>> @@ -247,7 +247,7 @@ static int __init activity_init(void)
>>  	int rc = led_trigger_register(&activity_led_trigger);
>>  
>>  	if (!rc) {
>> -		atomic_notifier_chain_register(&panic_notifier_list,
>> +		atomic_notifier_chain_register(&panic_hypervisor_list,
>>  					       &activity_panic_nb);
> 
> The notifier is trivial. It just sets a variable.
> 
> But still, it is about blinking and should be done
> in the last "loop" list.
> 
> 
>>  		register_reboot_notifier(&activity_reboot_nb);
>>  	}
>> --- a/drivers/leds/trigger/ledtrig-heartbeat.c
>> +++ b/drivers/leds/trigger/ledtrig-heartbeat.c
>> @@ -190,7 +190,7 @@ static int __init heartbeat_trig_init(void)
>>  	int rc = led_trigger_register(&heartbeat_led_trigger);
>>  
>>  	if (!rc) {
>> -		atomic_notifier_chain_register(&panic_notifier_list,
>> +		atomic_notifier_chain_register(&panic_hypervisor_list,
>>  					       &heartbeat_panic_nb);
> 
> Same here. Blinking => loop list.

Ack.


>> [...]
>> diff --git a/drivers/misc/bcm-vk/bcm_vk_dev.c b/drivers/misc/bcm-vk/bcm_vk_dev.c
>> index a16b99bdaa13..d9d5199cdb2b 100644
>> --- a/drivers/misc/bcm-vk/bcm_vk_dev.c
>> +++ b/drivers/misc/bcm-vk/bcm_vk_dev.c
>> @@ -1446,7 +1446,7 @@ static int bcm_vk_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>  
>>  	/* register for panic notifier */
>>  	vk->panic_nb.notifier_call = bcm_vk_on_panic;
>> -	err = atomic_notifier_chain_register(&panic_notifier_list,
>> +	err = atomic_notifier_chain_register(&panic_hypervisor_list,
>>  					     &vk->panic_nb);
> 
> It seems to reset some hardware or so. IMHO, it should go into the
> pre-reboot list.

Mixed feelings here, I'm looping Broadcom maintainers to comment.
(CC Scott and Broadcom list)

I'm afraid it breaks kdump if this device is not reset beforehand - it's
a doorbell write, so not high risk I think...

But in case the not-reset device can be probed normally in kdump kernel,
then I'm fine in moving this to the reboot list! I don't have the HW to
test myself.


> [...]
>> --- a/drivers/power/reset/ltc2952-poweroff.c
>> +++ b/drivers/power/reset/ltc2952-poweroff.c
>> @@ -279,7 +279,7 @@ static int ltc2952_poweroff_probe(struct platform_device *pdev)
>>  	pm_power_off = ltc2952_poweroff_kill;
>>  
>>  	data->panic_notifier.notifier_call = ltc2952_poweroff_notify_panic;
>> -	atomic_notifier_chain_register(&panic_notifier_list,
>> +	atomic_notifier_chain_register(&panic_hypervisor_list,
>>  				       &data->panic_notifier);
> 
> I looks like this somehow triggers the reboot. IMHO, it should go
> into the pre_reboot list.

Mixed feeling again here - CCing the maintainers for comments (Sebastian
/ PM folks).

This is setting a variable only, and once it's set (data->kernel_panic
is the bool's name), it just bails out the IRQ handler and a timer
setting - this timer seems kinda tricky, so bailing out ASAP makes sense
IMHO.

But my mixed feeling comes from the fact this notifier really is not a
fit to any list - it's just a "watchdog"/device quiesce in some form.
Since it's very low-risk (IIUC), I've put it here.


> [...]
>> --- a/drivers/soc/bcm/brcmstb/pm/pm-arm.c
>> +++ b/drivers/soc/bcm/brcmstb/pm/pm-arm.c
>> @@ -814,7 +814,7 @@ static int brcmstb_pm_probe(struct platform_device *pdev)
>>  		goto out;
>>  	}
>>  
>> -	atomic_notifier_chain_register(&panic_notifier_list,
>> +	atomic_notifier_chain_register(&panic_hypervisor_list,
>>  				       &brcmstb_pm_panic_nb);
> 
> I am not sure about this one. It instruct some HW to preserve DRAM.
> IMHO, it better fits into pre_reboot category but I do not have
> strong opinion.

Disagree here, I'm CCing Florian for information.

This notifier preserves RAM so it's *very interesting* if we have
kmsg_dump() for example, but maybe might be also relevant in case kdump
kernel is configured to store something in a persistent RAM (then,
without this notifier, after kdump reboots the system data would be lost).

Cheers,


Guilherme
