Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A80C2D7627
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 14:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405977AbgLKM6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:58:46 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:34750 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406014AbgLKM6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:58:33 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607691469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JI1elAtJ+5DtZ6K623jhzzi7pTI2yY5tK5xHv6JaNRg=;
        b=IsUihC8x41gfVuZ56mJpZCBvWH6AGSSnlAtCqFu+Y6vHBUWXmKQx9YvU5B8lrG6utDrQMP
        8canZDEEsNDVhNNdoKfnFOQzTFOpz9W+psXaARAvFsUFtyOebsqoT9kLX8kBnNz5EacFR5
        rK53uTCJCAI+CQzV9BLaBuU/gNEQZy9UASonSM4NSF0ZsDg2qgrh9flw6frSO8WIrRyHsw
        fF1cIAuhmb0wJbfH0peqshua47BZpnwfG0pDc4EWPJORiwGLQuagVjgVxqHnf+tQ9+0hUT
        H0SNNDNOI9Tui6mw4dUpmVwGgPTgPo14TX1s4jNlbb7LIWdUurk9RmWQuaaNkw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607691469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JI1elAtJ+5DtZ6K623jhzzi7pTI2yY5tK5xHv6JaNRg=;
        b=9Ep94KYblAfQy2iSeDDH/NSIpD2gqoyh3N3s+6g4ZgyvdTP4pfDpIIp6ve3zDE8y9b1XGh
        NoOqscBMvs3mS3Bw==
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        linux-parisc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Wambui Karuga <wambui.karugax@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>, linux-ntb@googlegroups.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-pci@vger.kernel.org,
        Karthikeyan Mitran <m.karthikeyan@mobiveil.co.in>,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org
Subject: Re: [patch 14/30] drm/i915/pmu: Replace open coded kstat_irqs() copy
In-Reply-To: <ad05af1a-5463-2a80-0887-7629721d6863@linux.intel.com>
References: <20201210192536.118432146@linutronix.de> <20201210194043.957046529@linutronix.de> <ad05af1a-5463-2a80-0887-7629721d6863@linux.intel.com>
Date:   Fri, 11 Dec 2020 13:57:49 +0100
Message-ID: <87y2i4h54i.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11 2020 at 10:13, Tvrtko Ursulin wrote:
> On 10/12/2020 19:25, Thomas Gleixner wrote:

>> 
>> Aside of that the count is per interrupt line and therefore takes
>> interrupts from other devices into account which share the interrupt line
>> and are not handled by the graphics driver.
>> 
>> Replace it with a pmu private count which only counts interrupts which
>> originate from the graphics card.
>> 
>> To avoid atomics or heuristics of some sort make the counter field
>> 'unsigned long'. That limits the count to 4e9 on 32bit which is a lot and
>> postprocessing can easily deal with the occasional wraparound.
>
> After my failed hasty sketch from last night I had a different one which 
> was kind of heuristics based (re-reading the upper dword and retrying if 
> it changed on 32-bit).

The problem is that there will be two seperate modifications for the low
and high word. Several ways how the compiler can translate this, but the
problem is the same for all of them:

CPU 0                           CPU 1
        load low
        load high
        add  low, 1
        addc high, 0            
        store low               load high
--> NMI                         load low
                                load high and compare
        store high

You can't catch that. If this really becomes an issue you need a
sequence counter around it.
      

> But you are right - it is okay to at least start 
> like this today and if later there is a need we can either do that or 
> deal with wrap at PMU read time.

Right.

>> +/*
>> + * Interrupt statistic for PMU. Increments the counter only if the
>> + * interrupt originated from the the GPU so interrupts from a device which
>> + * shares the interrupt line are not accounted.
>> + */
>> +static inline void pmu_irq_stats(struct drm_i915_private *priv,
>
> We never use priv as a local name, it should be either i915 or
> dev_priv.

Sure, will fix.

>> +	/*
>> +	 * A clever compiler translates that into INC. A not so clever one
>> +	 * should at least prevent store tearing.
>> +	 */
>> +	WRITE_ONCE(priv->pmu.irq_count, priv->pmu.irq_count + 1);
>
> Curious, probably more educational for me - given x86_32 and x86_64, and 
> the context of it getting called, what is the difference from just doing 
> irq_count++?

Several reasons:

    1) The compiler can pretty much do what it wants with cnt++
       including tearing and whatever. https://lwn.net/Articles/816850/
       for the full set of insanities.

       Not really a problem here, but

    2) It's annotating the reader and the writer side and documenting
       that this is subject to concurrency

    3) It will prevent KCSAN to complain about the data race,
       i.e. concurrent modification while reading.

Thanks,

        tglx

>> --- a/drivers/gpu/drm/i915/i915_pmu.c
>> +++ b/drivers/gpu/drm/i915/i915_pmu.c
>> @@ -423,22 +423,6 @@ static enum hrtimer_restart i915_sample(
>>   	return HRTIMER_RESTART;
>>   }
>
> In this file you can also drop the #include <linux/irq.h> line.

Indeed.

Thanks,

        tglx
