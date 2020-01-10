Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D11D136B7A
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 11:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbgAJK43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 05:56:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727582AbgAJK42 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 05:56:28 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8C6A2082E;
        Fri, 10 Jan 2020 10:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578653787;
        bh=g0NGsgvtWDcQEwVAn4jBHCPYsY/MFSFg1Hq2ESPb2i0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gd9YLLjDwQH55ZByg8BPeOnN0T8pWoE/KMlkAklE5GVagFD/dBEvbncrgx9izcbXn
         83GgfSArCppaYma/XT3TLp7vROLiuIEJa5nsrniJli4P29feXubWrETQpWVO4H5Rqa
         P1SZ7EG3hojV6ZG2FnYgc/T6hw+8tbT1aGY1ZuVA=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1iprxp-0007Zo-5s; Fri, 10 Jan 2020 10:56:25 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 10 Jan 2020 10:56:25 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Jianyong Wu <Jianyong.Wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, richardcochran@gmail.com,
        Mark Rutland <Mark.Rutland@arm.com>, will@kernel.org,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve Capper <Steve.Capper@arm.com>,
        Kaly Xin <Kaly.Xin@arm.com>, Justin He <Justin.He@arm.com>,
        nd <nd@arm.com>
Subject: Re: [RFC PATCH v9 6/8] psci: Add hvc call service for ptp_kvm.
In-Reply-To: <HE1PR0801MB16765B507D9B5A1A7827078BF4380@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191210034026.45229-1-jianyong.wu@arm.com>
 <20191210034026.45229-7-jianyong.wu@arm.com>
 <7383dc06897bba253f174cd21a19b5c0@kernel.org>
 <HE1PR0801MB1676AB738138AB24E2158AD4F4390@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <099a26ffef5d554b88a5e33d7f2a6e3a@kernel.org>
 <HE1PR0801MB16765B507D9B5A1A7827078BF4380@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Message-ID: <ca80d88f5e00937fca7ee80be8f5c962@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: Jianyong.Wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, Suzuki.Poulose@arm.com, Steven.Price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, Kaly.Xin@arm.com, Justin.He@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-10 09:51, Jianyong Wu wrote:
> Hi Marc,
> 
>> -----Original Message-----
>> From: Marc Zyngier <maz@kernel.org>
>> Sent: Thursday, January 9, 2020 5:16 PM
>> To: Jianyong Wu <Jianyong.Wu@arm.com>
>> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
>> tglx@linutronix.de; pbonzini@redhat.com; 
>> sean.j.christopherson@intel.com;
>> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
>> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
>> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
>> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
>> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Kaly Xin
>> <Kaly.Xin@arm.com>; Justin He <Justin.He@arm.com>; nd <nd@arm.com>
>> Subject: Re: [RFC PATCH v9 6/8] psci: Add hvc call service for 
>> ptp_kvm.
>> 
>> On 2020-01-09 05:45, Jianyong Wu wrote:
>> > Hi Marc,
>> >
>> >> -----Original Message-----
>> >> From: Marc Zyngier <maz@kernel.org>
>> >> Sent: Tuesday, January 7, 2020 5:16 PM
>> >> To: Jianyong Wu <Jianyong.Wu@arm.com>
>> >> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com;
>> >> john.stultz@linaro.org; tglx@linutronix.de; pbonzini@redhat.com;
>> >> sean.j.christopherson@intel.com; richardcochran@gmail.com; Mark
>> >> Rutland <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
>> >> <Suzuki.Poulose@arm.com>; Steven Price <Steven.Price@arm.com>;
>> >> linux-kernel@vger.kernel.org; linux-arm- kernel@lists.infradead.org;
>> >> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
>> >> <Steve.Capper@arm.com>; Kaly Xin <Kaly.Xin@arm.com>; Justin He
>> >> <Justin.He@arm.com>; nd <nd@arm.com>
>> >> Subject: Re: [RFC PATCH v9 6/8] psci: Add hvc call service for
>> >> ptp_kvm.
>> >>
>> >> On 2019-12-10 03:40, Jianyong Wu wrote:
>> >> > ptp_kvm modules will call hvc to get this service.
>> >> > The service offers real time and counter cycle of host for guest.
>> >> >
>> >> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
>> >> > ---
>> >> >  include/linux/arm-smccc.h | 12 ++++++++++++
>> >> >  virt/kvm/arm/psci.c       | 22 ++++++++++++++++++++++
>> >> >  2 files changed, 34 insertions(+)
>> >> >
>> >> > diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
>> >> > index 6f82c87308ed..aafb6bac167d 100644
>> >> > --- a/include/linux/arm-smccc.h
>> >> > +++ b/include/linux/arm-smccc.h
>> >> > @@ -94,6 +94,7 @@
>> >> >
>> >> >  /* KVM "vendor specific" services */
>> >> >  #define ARM_SMCCC_KVM_FUNC_FEATURES		0
>> >> > +#define ARM_SMCCC_KVM_PTP			1
>> >> >  #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
>> >> >  #define ARM_SMCCC_KVM_NUM_FUNCS			128
>> >> >
>> >> > @@ -103,6 +104,17 @@
>> >> >  			   ARM_SMCCC_OWNER_VENDOR_HYP,
>> >> 		\
>> >> >  			   ARM_SMCCC_KVM_FUNC_FEATURES)
>> >> >
>> >> > +/*
>> >> > + * This ID used for virtual ptp kvm clock and it will pass second
>> >> > value
>> >> > + * and nanosecond value of host real time and system counter by
>> >> > +vcpu
>> >> > + * register to guest.
>> >> > + */
>> >> > +#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID
>> >> 		\
>> >> > +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
>> >> 		\
>> >> > +			   ARM_SMCCC_SMC_32,
>> >> 	\
>> >> > +			   ARM_SMCCC_OWNER_VENDOR_HYP,
>> >> 		\
>> >> > +			   ARM_SMCCC_KVM_PTP)
>> >> > +
>> >>
>> >> All of this depends on patches that have never need posted to any ML,
>> >> and just linger in Will's tree. You need to pick them up and post
>> >> them as part of this series so that they can at least be reviewed.
>> >>
>> > Ok, I will add them next version.
>> >
>> >> >  #ifndef __ASSEMBLY__
>> >> >
>> >> >  #include <linux/linkage.h>
>> >> > diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c index
>> >> > 0debf49bf259..682d892d6717 100644
>> >> > --- a/virt/kvm/arm/psci.c
>> >> > +++ b/virt/kvm/arm/psci.c
>> >> > @@ -9,6 +9,7 @@
>> >> >  #include <linux/kvm_host.h>
>> >> >  #include <linux/uaccess.h>
>> >> >  #include <linux/wait.h>
>> >> > +#include <linux/clocksource_ids.h>
>> >> >
>> >> >  #include <asm/cputype.h>
>> >> >  #include <asm/kvm_emulate.h>
>> >> > @@ -389,6 +390,8 @@ static int kvm_psci_call(struct kvm_vcpu *vcpu)
>> >> >
>> >> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)  {
>> >> > +	struct system_time_snapshot systime_snapshot;
>> >> > +	u64 cycles;
>> >> >  	u32 func_id = smccc_get_function(vcpu);
>> >> >  	u32 val[4] = {};
>> >> >  	u32 option;
>> >> > @@ -431,6 +434,25 @@ int kvm_hvc_call_handler(struct kvm_vcpu
>> *vcpu)
>> >> >  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
>> >> >  		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
>> >> >  		break;
>> >> > +	/*
>> >> > +	 * This will used for virtual ptp kvm clock. three
>> >> > +	 * values will be passed back.
>> >> > +	 * reg0 stores high 32-bit host ktime;
>> >> > +	 * reg1 stores low 32-bit host ktime;
>> >> > +	 * reg2 stores high 32-bit difference of host cycles and cntvoff;
>> >> > +	 * reg3 stores low 32-bit difference of host cycles and cntvoff.
>> >>
>> >> That's either two or four values, and not three as you claim above.
>> >>
>> > Sorry, I'm not sure what do you mean "three", the registers here is 4
>> > from reg0 to reg3.
>> 
>> Please read the comment you have written above...
> 
> oh, I see it.
> 
>> 
>> >> Also, I fail to understand the meaning of the host cycle vs cntvoff
>> >> comparison.
>> >> This is something that guest can perform on its own (it has access to
>> >> both physical and virtual timers, and can compute cntvoff without
>> >> intervention of the hypervisor).
>> >>
>> > To keep consistency and precision, clock time and counter cycle must
>> > captured at the same time. It will perform at ktime_get_snapshot.
>> 
>> Fair enough. It would vertainly help if you documented it. It would 
>> also help if
>> you explained why it is so much worse to read the counter in the guest
>> before *and* after the call, and assume that the clock time read 
>> happened
>> right in the middle?
>> 
> ok, I will give explain in comments.
> 
>> That aside, what you are returning is something that *looks* like the 
>> virtual
>> counter. What if the guest is using the physical counter, which is 
>> likely to be
>> the case with nested virt? Do you expect the guest to always use the 
>> virtual
>> counter? This isn't going to fly.
> 
> To be honest, I have little knowledge of nested virtualization for arm
> and I'm confused with that guest'guest will use physical counter.

Not the guest's guest (L2), but L1. Just look at what counter the
KVM host uses: that's the physical counter. Now imagine you run that
host as a guest, no other change.

> IMO, ptp_kvm will call hvc to trap to its hypervisor adjacent to it.
> So guest'guest will trap to hypervisor in guest and will
> get guest's counter cycle then calculate guest'guest's counter cycle
> by something like offset to sync time with it. So only if the
> guest's hypervisor can calculate the guest'guest's counter value, can
> ptp_kvm works.

Sure, but that's not the problem we're trying to solve. The issue is 
that
of the reference counter value you're including in the hypercall 
response.
It needs to be a value that makes sense to the guest, and so far you're
assuming virtual.

NV breaks that assumtion, because the guest hypervisor is using the 
physical
counter. Also, let's not forget that the hypercall isn't Linux specific.
I can write my own non-Linux guest and still use this hypercall. Nothing
in there says that I can't use the physical counter if I want to.

So somehow, you need to convey the the hypervisor the notion of *which*
counter the guest uses.

Does it make sense? Or am I missing something?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
