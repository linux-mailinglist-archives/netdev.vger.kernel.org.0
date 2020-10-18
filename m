Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C6C291738
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 13:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgJRL52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 07:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgJRL52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 07:57:28 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B23AC061755;
        Sun, 18 Oct 2020 04:57:27 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id ce10so9988910ejc.5;
        Sun, 18 Oct 2020 04:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z87sRqqnW7QMSh1fs0b2+fOu+Njr1H+oeTk7BEFwWH8=;
        b=PsvSeTTcPknEGLz/8A4ZfLryoLDYdopT3zpW3P05bFyfEH/uyRuNr7Ugrx73J3/qt2
         yIL10LArhWLQ0PSOLC6z793OwKaywmN1TNfu0npBpnPTwc22xxByDICIH2wXef/82z/g
         /RsOowUi0i04GBiIT7I8nRZGJKL2es+deXJAJt8dHekWGEemJ5orsMDzy90UEskuDHbD
         LpPZpl1V/FVZNAl5RoNarhssOzqGJNUZmUbq+SgfFvnJfHdIiBcuNHuZHMH+7QIHQSHc
         iHzMiEP08OCTbi7hNfZdQnxtuZyJYCFc9kfAScUYJiS3maRYaIivjDyAKrjwHFuoer8/
         tVsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z87sRqqnW7QMSh1fs0b2+fOu+Njr1H+oeTk7BEFwWH8=;
        b=kRBiXiFlag3wRTgbGFR8jcayaJ4+E9YJyrqmCGrliNofnLMGXm0otcjXWr8/o/UeMR
         Qcu24U9TNL8V2qX9erymxIHp4kcp+4rdI4qwkxdjV4ValhiXMyiRqEXLOsrspcUGKNVg
         f1z7f8dv7UV9taGpIQTJAvs9g0mqQRU/2UTsbJm0ONOiQCWtdasBJY6tr7NlFS2w2hzQ
         NvWB1b6R1+NTUTlQtgKwDSa9g//Sd/7DUX7RpR4c8qD77u3bi5YX1SDtb6bn71knf3YE
         iOT3/78E6wnfNYPFrDDIkzydzgO6a7VBIyeUjOVMILpLB4HtSRNcB+Ql6gS0opD7l2gk
         KWBw==
X-Gm-Message-State: AOAM5317nXoAlLoX4gx2Gxfm93h4yhgk556lRqMa82ClmzyXSXV8S3zg
        TSe3vIOPKzD1rPu9rM9Nv3v9H0k5ZxY=
X-Google-Smtp-Source: ABdhPJyM45PFo9WhgfsVLisTNKnmFsNzZoRcKVA0Buh9vF7pOuyz1fl1klfl60QMSl5xuiwW4ZjTjw==
X-Received: by 2002:a17:906:453:: with SMTP id e19mr12936569eja.391.1603022245289;
        Sun, 18 Oct 2020 04:57:25 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:8821:97f2:24b4:2f18? (p200300ea8f232800882197f224b42f18.dip0.t-ipconnect.de. [2003:ea:8f23:2800:8821:97f2:24b4:2f18])
        by smtp.googlemail.com with ESMTPSA id b25sm7089924eds.66.2020.10.18.04.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2020 04:57:24 -0700 (PDT)
Subject: Re: Remove __napi_schedule_irqoff?
To:     Thomas Gleixner <tglx@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <01af7f4f-bd05-b93e-57ad-c2e9b8726e90@gmail.com>
 <20201017162949.0a6dd37a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <878sc3j1tb.fsf@nanos.tec.linutronix.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <3360b93e-4097-de43-0c4d-edda85d2ac72@gmail.com>
Date:   Sun, 18 Oct 2020 13:57:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <878sc3j1tb.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.10.2020 11:55, Thomas Gleixner wrote:
> Jakub,
> 
> On Sat, Oct 17 2020 at 16:29, Jakub Kicinski wrote:
>> On Sat, 17 Oct 2020 15:45:57 +0200 Heiner Kallweit wrote:
>>> It turned out that this most of the time isn't safe in certain
>>> configurations:
>>> - if CONFIG_PREEMPT_RT is set
>>> - if command line parameter threadirqs is set
>>>
>>> Having said that drivers are being switched back to __napi_schedule(),
>>> see e.g. patch in [0] and related discussion. I thought about a
>>> __napi_schedule version checking dynamically whether interrupts are
>>> disabled. But checking e.g. variable force_irqthreads also comes at
>>> a cost, so that we may not see a benefit compared to calling
>>> local_irq_save/local_irq_restore.
> 
> This does not have to be a variable check. It's trivial enough to make
> it a static key.
> 
Pretty cool. I have to admit that I wasn't aware of the jump label
mechanism.

>>> If more or less all users have to switch back, then the question is
>>> whether we should remove __napi_schedule_irqoff.
>>> Instead of touching all users we could make  __napi_schedule_irqoff
>>> an alias for __napi_schedule for now.
>>>
>>> [0] https://lkml.org/lkml/2020/10/8/706
>>
>> We're effectively calling raise_softirq_irqoff() from IRQ handlers,
>> with force_irqthreads == true that's no longer legal.
> 
> Hrmpf, indeed. When force threading was introduced that did not exist.
> 
> The forced threaded handler is always invoked with bottom halfs disabled
> and bottom half processing either happens when the handler returns and
> the thread wrapper invokes local_bh_enable() or from ksoftirq. As
> everything runs in thread context CPU local serialization through
> local_bh_disable() is sufficient.
> 
>> Thomas - is the expectation that IRQ handlers never assume they have 
>> IRQs disabled going forward? We don't have any performance numbers 
>> but if I'm reading Agner's tables right POPF is 18 cycles on Broadwell.
>> Is PUSHF/POPF too cheap to bother?
> 
> It's not only PUSHF/POPF it's PUSHF,CLI -> POPF, but yeah it's pretty
> cheap nowadays. But doing the static key change might still be a good
> thing. Completely untested patch below.
> 
> Quoting Eric:
> 
>> I have to say I do not understand why we want to defer to a thread the
>> hard IRQ that we use in NAPI model.
>>
>> Whole point of NAPI was to keep hard irq handler very short.
> 
> Right. In case the interrupt handler is doing not much more than
> scheduling NAPI then you can request it with IRQF_NO_THREAD, which will
> prevent it from being threaded even on RT.
> 
>> We should focus on transferring the NAPI work (potentially disrupting
>> ) to a thread context, instead of the very minor hard irq trigger.
> 
> Read about that. I only looked briefly at the patches and wondered why
> this has it's own threading mechanism and is not using the irq thread
> mechanics. I'll have a closer look in the next days.
> 
> Thanks,
> 
>         tglx
> ---
> --- a/drivers/ide/ide-iops.c
> +++ b/drivers/ide/ide-iops.c
> @@ -109,7 +109,6 @@ int __ide_wait_stat(ide_drive_t *drive,
>  	ide_hwif_t *hwif = drive->hwif;
>  	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
>  	unsigned long flags;
> -	bool irqs_threaded = force_irqthreads;
>  	int i;
>  	u8 stat;
>  
> @@ -117,7 +116,7 @@ int __ide_wait_stat(ide_drive_t *drive,
>  	stat = tp_ops->read_status(hwif);
>  
>  	if (stat & ATA_BUSY) {
> -		if (!irqs_threaded) {
> +		if (!force_irqthreads_active()) {
>  			local_save_flags(flags);
>  			local_irq_enable_in_hardirq();
>  		}
> @@ -133,13 +132,13 @@ int __ide_wait_stat(ide_drive_t *drive,
>  				if ((stat & ATA_BUSY) == 0)
>  					break;
>  
> -				if (!irqs_threaded)
> +				if (!force_irqthreads_active())
>  					local_irq_restore(flags);
>  				*rstat = stat;
>  				return -EBUSY;
>  			}
>  		}
> -		if (!irqs_threaded)
> +		if (!force_irqthreads_active())
>  			local_irq_restore(flags);
>  	}
>  	/*
> --- a/drivers/ide/ide-taskfile.c
> +++ b/drivers/ide/ide-taskfile.c
> @@ -406,7 +406,8 @@ static ide_startstop_t pre_task_out_intr
>  		return startstop;
>  	}
>  
> -	if (!force_irqthreads && (drive->dev_flags & IDE_DFLAG_UNMASK) == 0)
> +	if (!force_irqthreads_active() &&
> +	    (drive->dev_flags & IDE_DFLAG_UNMASK) == 0)
>  		local_irq_disable();
>  
>  	ide_set_handler(drive, &task_pio_intr, WAIT_WORSTCASE);
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -489,12 +489,16 @@ extern int irq_set_irqchip_state(unsigne
>  
>  #ifdef CONFIG_IRQ_FORCED_THREADING
>  # ifdef CONFIG_PREEMPT_RT
> -#  define force_irqthreads	(true)
> +static inline bool force_irqthreads_active(void) { return true; }
>  # else
> -extern bool force_irqthreads;
> +extern struct static_key_false force_irqthreads_key;
> +static inline bool force_irqthreads_active(void)
> +{
> +	return static_branch_unlikely(&force_irqthreads_key);
> +}
>  # endif
>  #else
> -#define force_irqthreads	(0)
> +static inline bool force_irqthreads_active(void) { return false; }
>  #endif
>  
>  #ifndef local_softirq_pending
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -25,12 +25,14 @@
>  #include "internals.h"
>  
>  #if defined(CONFIG_IRQ_FORCED_THREADING) && !defined(CONFIG_PREEMPT_RT)
> -__read_mostly bool force_irqthreads;
> -EXPORT_SYMBOL_GPL(force_irqthreads);
> +DEFINE_STATIC_KEY_FALSE(force_irqthreads_key);
> +#ifdef CONFIG_IDE
> +EXPORT_SYMBOL_GPL(force_irqthreads_key);
> +#endif
>  
>  static int __init setup_forced_irqthreads(char *arg)
>  {
> -	force_irqthreads = true;
> +	static_branch_enable(&force_irqthreads_key);
>  	return 0;
>  }
>  early_param("threadirqs", setup_forced_irqthreads);
> @@ -1155,8 +1157,8 @@ static int irq_thread(void *data)
>  	irqreturn_t (*handler_fn)(struct irq_desc *desc,
>  			struct irqaction *action);
>  
> -	if (force_irqthreads && test_bit(IRQTF_FORCED_THREAD,
> -					&action->thread_flags))
> +	if (force_irqthreads_active() && test_bit(IRQTF_FORCED_THREAD,
> +						  &action->thread_flags))
>  		handler_fn = irq_forced_thread_fn;
>  	else
>  		handler_fn = irq_thread_fn;
> @@ -1217,7 +1219,7 @@ EXPORT_SYMBOL_GPL(irq_wake_thread);
>  
>  static int irq_setup_forced_threading(struct irqaction *new)
>  {
> -	if (!force_irqthreads)
> +	if (!force_irqthreads_active())
>  		return 0;
>  	if (new->flags & (IRQF_NO_THREAD | IRQF_PERCPU | IRQF_ONESHOT))
>  		return 0;
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -376,7 +376,7 @@ static inline void invoke_softirq(void)
>  	if (ksoftirqd_running(local_softirq_pending()))
>  		return;
>  
> -	if (!force_irqthreads) {
> +	if (!force_irqthreads_active()) {
>  #ifdef CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK
>  		/*
>  		 * We can safely execute softirq on the current stack if
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6282,9 +6282,11 @@ void __napi_schedule(struct napi_struct
>  {
>  	unsigned long flags;
>  
> -	local_irq_save(flags);
> +	if (force_irqthreads_active())
> +		local_irq_save(flags);
>  	____napi_schedule(this_cpu_ptr(&softnet_data), n);
> -	local_irq_restore(flags);
> +	if (force_irqthreads_active())
> +		local_irq_restore(flags);

Question would be whether we want to modify __napi_schedule() or
__napi_schedule_irqoff(). This may depend on whether we have calls to
__napi_schedule() that require local_irq_save() even if
force_irqthreads_active() is false. Not sure about that. At a first
glance it should be better to modify __napi_schedule_irqoff().
Only drawback I see is that the name of the function then is a little
bit inconsistent.

>  }
>  EXPORT_SYMBOL(__napi_schedule);
>  
> 

