Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B719825F5BD
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 10:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgIGIzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 04:55:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726978AbgIGIzB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 04:55:01 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82AF720757;
        Mon,  7 Sep 2020 08:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599468899;
        bh=h0dzECAlJcaUj2DyOGtmStzWmm1Oimzbwx2te+tHEwU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=erArDS/k5tl0YdDvN8AQKEBXad+mxvHAMDPO1ZzBi4LTztrqdD8bEVz+C8WT+Nc5l
         avyVnLlnU+sU2hSd0kICBhZxf+eAkQAaKhZ5ZKqt6lJEFg5crYUfmmXPAXdqVxI2B+
         S+zXVCN1qryM2oFOI5PrvKTLWQ4OmTTYl4RooQXM=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kFCvR-009iBY-K7; Mon, 07 Sep 2020 09:54:57 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 07 Sep 2020 09:54:57 +0100
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
        Justin He <Justin.He@arm.com>, nd <nd@arm.com>
Subject: Re: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
In-Reply-To: <HE1PR0802MB2555CC56351616836A95FB19F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200904092744.167655-1-jianyong.wu@arm.com>
 <20200904092744.167655-9-jianyong.wu@arm.com> <874kocmqqx.wl-maz@kernel.org>
 <HE1PR0802MB2555CC56351616836A95FB19F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <366387fa507f9c5d5044549cea958ce1@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: Jianyong.Wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, Suzuki.Poulose@arm.com, Steven.Price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, Justin.He@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-07 09:40, Jianyong Wu wrote:
> Hi Marc,
> 
>> -----Original Message-----
>> From: Marc Zyngier <maz@kernel.org>
>> Sent: Saturday, September 5, 2020 7:02 PM
>> To: Jianyong Wu <Jianyong.Wu@arm.com>
>> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
>> tglx@linutronix.de; pbonzini@redhat.com; 
>> sean.j.christopherson@intel.com;
>> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
>> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
>> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
>> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
>> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Justin He
>> <Justin.He@arm.com>; nd <nd@arm.com>
>> Subject: Re: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
>> 
>> On Fri, 04 Sep 2020 10:27:42 +0100,
>> Jianyong Wu <jianyong.wu@arm.com> wrote:
>> >
>> > Currently, there is no mechanism to keep time sync between guest and
>> > host in arm64 virtualization environment. Time in guest will drift
>> > compared with host after boot up as they may both use third party time
>> > sources to correct their time respectively. The time deviation will be
>> > in order of milliseconds. But in some scenarios,like in cloud
>> > envirenment, we ask for higher time precision.
>> >
>> > kvm ptp clock, which choose the host clock source as a reference clock
>> > to sync time between guest and host, has been adopted by x86 which
>> > makes the time sync order from milliseconds to nanoseconds.
>> >
>> > This patch enables kvm ptp clock for arm64 and improve clock sync
>> > precison significantly.
>> >
>> > Test result comparisons between with kvm ptp clock and without it in
>> > arm64 are as follows. This test derived from the result of command
>> > 'chronyc sources'. we should take more care of the last sample column
>> > which shows the offset between the local clock and the source at the last
>> measurement.
>> >
>> > no kvm ptp in guest:
>> > MS Name/IP address   Stratum Poll Reach LastRx Last sample
>> >
>> ==========================================================
>> ==============
>> > ^* dns1.synet.edu.cn      2   6   377    13  +1040us[+1581us] +/-   21ms
>> > ^* dns1.synet.edu.cn      2   6   377    21  +1040us[+1581us] +/-   21ms
>> > ^* dns1.synet.edu.cn      2   6   377    29  +1040us[+1581us] +/-   21ms
>> > ^* dns1.synet.edu.cn      2   6   377    37  +1040us[+1581us] +/-   21ms
>> > ^* dns1.synet.edu.cn      2   6   377    45  +1040us[+1581us] +/-   21ms
>> > ^* dns1.synet.edu.cn      2   6   377    53  +1040us[+1581us] +/-   21ms
>> > ^* dns1.synet.edu.cn      2   6   377    61  +1040us[+1581us] +/-   21ms
>> > ^* dns1.synet.edu.cn      2   6   377     4   -130us[ +796us] +/-   21ms
>> > ^* dns1.synet.edu.cn      2   6   377    12   -130us[ +796us] +/-   21ms
>> > ^* dns1.synet.edu.cn      2   6   377    20   -130us[ +796us] +/-   21ms
>> >
>> > in host:
>> > MS Name/IP address   Stratum Poll Reach LastRx Last sample
>> >
>> ==========================================================
>> ==============
>> > ^* 120.25.115.20          2   7   377    72   -470us[ -603us] +/-   18ms
>> > ^* 120.25.115.20          2   7   377    92   -470us[ -603us] +/-   18ms
>> > ^* 120.25.115.20          2   7   377   112   -470us[ -603us] +/-   18ms
>> > ^* 120.25.115.20          2   7   377     2   +872ns[-6808ns] +/-   17ms
>> > ^* 120.25.115.20          2   7   377    22   +872ns[-6808ns] +/-   17ms
>> > ^* 120.25.115.20          2   7   377    43   +872ns[-6808ns] +/-   17ms
>> > ^* 120.25.115.20          2   7   377    63   +872ns[-6808ns] +/-   17ms
>> > ^* 120.25.115.20          2   7   377    83   +872ns[-6808ns] +/-   17ms
>> > ^* 120.25.115.20          2   7   377   103   +872ns[-6808ns] +/-   17ms
>> > ^* 120.25.115.20          2   7   377   123   +872ns[-6808ns] +/-   17ms
>> >
>> > The dns1.synet.edu.cn is the network reference clock for guest and
>> > 120.25.115.20 is the network reference clock for host. we can't get
>> > the clock error between guest and host directly, but a roughly
>> > estimated value will be in order of hundreds of us to ms.
>> >
>> > with kvm ptp in guest:
>> > chrony has been disabled in host to remove the disturb by network clock.
>> >
>> > MS Name/IP address         Stratum Poll Reach LastRx Last sample
>> >
>> ==========================================================
>> ==============
>> > * PHC0                    0   3   377     8     -7ns[   +1ns] +/-    3ns
>> > * PHC0                    0   3   377     8     +1ns[  +16ns] +/-    3ns
>> > * PHC0                    0   3   377     6     -4ns[   -0ns] +/-    6ns
>> > * PHC0                    0   3   377     6     -8ns[  -12ns] +/-    5ns
>> > * PHC0                    0   3   377     5     +2ns[   +4ns] +/-    4ns
>> > * PHC0                    0   3   377    13     +2ns[   +4ns] +/-    4ns
>> > * PHC0                    0   3   377    12     -4ns[   -6ns] +/-    4ns
>> > * PHC0                    0   3   377    11     -8ns[  -11ns] +/-    6ns
>> > * PHC0                    0   3   377    10    -14ns[  -20ns] +/-    4ns
>> > * PHC0                    0   3   377     8     +4ns[   +5ns] +/-    4ns
>> >
>> > The PHC0 is the ptp clock which choose the host clock as its source
>> > clock. So we can see that the clock difference between host and guest
>> > is in order of ns.
>> >
>> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
>> > ---
>> >  drivers/clocksource/arm_arch_timer.c | 24 +++++++++++++
>> >  drivers/ptp/Kconfig                  |  2 +-
>> >  drivers/ptp/ptp_kvm_arm64.c          | 53
>> ++++++++++++++++++++++++++++
>> >  3 files changed, 78 insertions(+), 1 deletion(-)  create mode 100644
>> > drivers/ptp/ptp_kvm_arm64.c
>> >
>> > diff --git a/drivers/clocksource/arm_arch_timer.c
>> > b/drivers/clocksource/arm_arch_timer.c
>> > index d55acffb0b90..aaf286e90092 100644
>> > --- a/drivers/clocksource/arm_arch_timer.c
>> > +++ b/drivers/clocksource/arm_arch_timer.c
>> > @@ -1650,3 +1650,27 @@ static int __init arch_timer_acpi_init(struct
>> > acpi_table_header *table)  }  TIMER_ACPI_DECLARE(arch_timer,
>> > ACPI_SIG_GTDT, arch_timer_acpi_init);  #endif
>> > +
>> > +#if IS_ENABLED(CONFIG_PTP_1588_CLOCK_KVM)
>> > +#include <linux/arm-smccc.h>
>> > +int kvm_arch_ptp_get_crosststamp(unsigned long *cycle, struct
>> timespec64 *ts,
>> > +			      struct clocksource **cs)
>> > +{
>> > +	struct arm_smccc_res hvc_res;
>> > +	ktime_t ktime;
>> > +
>> > +	/* Currently, linux guest will always use the virtual counter */
>> > +
>> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FU
>> NC_ID,
>> > +			     ARM_PTP_VIRT_COUNTER, &hvc_res);
>> > +	if ((long long)(hvc_res.a0) < 0)
>> > +		return -EOPNOTSUPP;
>> > +
>> > +	ktime = (long long)hvc_res.a0;
>> > +	*ts = ktime_to_timespec64(ktime);
>> > +	*cycle = (long long)hvc_res.a1;
>> > +	*cs = &clocksource_counter;
>> > +
>> > +	return 0;
>> > +}
>> > +EXPORT_SYMBOL_GPL(kvm_arch_ptp_get_crosststamp);
>> > +#endif
>> > diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig index
>> > 942f72d8151d..127e96f14f89 100644
>> > --- a/drivers/ptp/Kconfig
>> > +++ b/drivers/ptp/Kconfig
>> > @@ -106,7 +106,7 @@ config PTP_1588_CLOCK_PCH  config
>> > PTP_1588_CLOCK_KVM
>> >  	tristate "KVM virtual PTP clock"
>> >  	depends on PTP_1588_CLOCK
>> > -	depends on KVM_GUEST && X86
>> > +	depends on KVM_GUEST && X86 || ARM64 && ARM_ARCH_TIMER
>> &&
>> > +ARM_PSCI_FW
>> >  	default y
>> >  	help
>> >  	  This driver adds support for using kvm infrastructure as a PTP
>> > diff --git a/drivers/ptp/ptp_kvm_arm64.c b/drivers/ptp/ptp_kvm_arm64.c
>> > new file mode 100644 index 000000000000..961abed93dfd
>> > --- /dev/null
>> > +++ b/drivers/ptp/ptp_kvm_arm64.c
>> > @@ -0,0 +1,53 @@
>> > +// SPDX-License-Identifier: GPL-2.0-only
>> > +/*
>> > + *  Virtual PTP 1588 clock for use with KVM guests
>> > + *  Copyright (C) 2019 ARM Ltd.
>> > + *  All Rights Reserved
>> > + */
>> > +
>> > +#include <linux/kernel.h>
>> > +#include <linux/err.h>
>> > +#include <asm/hypervisor.h>
>> > +#include <linux/module.h>
>> > +#include <linux/psci.h>
>> > +#include <linux/arm-smccc.h>
>> > +#include <linux/timecounter.h>
>> > +#include <linux/sched/clock.h>
>> > +#include <asm/arch_timer.h>
>> > +
>> > +int kvm_arch_ptp_init(void)
>> > +{
>> > +	struct arm_smccc_res hvc_res;
>> > +
>> > +
>> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_FEATUR
>> ES_FUNC_ID,
>> > +			     &hvc_res);
>> > +	if (!(hvc_res.a0 | BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP)))
>> > +		return -EOPNOTSUPP;
>> > +
>> > +	return 0;
>> 
>> What happens if the
>> ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID function isn't
>> implemented (on an old kernel or a non-KVM hypervisor)? The expected
>> behaviour is that a0 will contain SMCCC_RET_NOT_SUPPORTED, which is 
>> -1.
>> The result is that this function always returns "supported". Not an 
>> acceptable
>> behaviour.
>> 
> Oh!  it's really a stupid mistake, should be "&" not "|".

But even then. (-1 & whatever) is always true.

         M.
-- 
Jazz is not dead. It just smells funny...
