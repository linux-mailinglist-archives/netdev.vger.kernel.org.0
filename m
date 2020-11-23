Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58702C03BF
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 12:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgKWK6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 05:58:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbgKWK6P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 05:58:15 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5037920781;
        Mon, 23 Nov 2020 10:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606129094;
        bh=/peUmxWwoiuoRZHOUT3CLjXhVSf0z9ZqsFQuW9bn+lU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ggZdStaRDcuClrAZIfESIxlWj27QHDRXUH+C/KbP+gjBJzkGUQ8cNmRBUUeSjPG6F
         K0qxnr2bzC3wS96VFks2K8I9SDy/jjGygPJY1Sjq0CYXMD8ayNzkFsFPaxMX6wUYaT
         oae+rHW3jiJs5Cclmn17vL0aVsm3Yjijau6Kl0KA=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kh9Xw-00CtAH-3h; Mon, 23 Nov 2020 10:58:12 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 23 Nov 2020 10:58:07 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Jianyong Wu <jianyong.wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, richardcochran@gmail.com,
        Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com,
        Andre.Przywara@arm.com, steven.price@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, justin.he@arm.com, nd@arm.com
Subject: Re: [PATCH v15 8/9] doc: add ptp_kvm introduction for arm64 support
In-Reply-To: <20201111062211.33144-9-jianyong.wu@arm.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
 <20201111062211.33144-9-jianyong.wu@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <38fad448a3a465e4c35994ce61f4d8dd@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jianyong.wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com, steven.price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-11 06:22, Jianyong Wu wrote:
> PTP_KVM implementation depends on hypercall using SMCCC. So we
> introduce a new SMCCC service ID. This doc explains how does the
> ID define and how does PTP_KVM works on arm/arm64.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  Documentation/virt/kvm/api.rst         |  9 +++++++
>  Documentation/virt/kvm/arm/index.rst   |  1 +
>  Documentation/virt/kvm/arm/ptp_kvm.rst | 29 +++++++++++++++++++++
>  Documentation/virt/kvm/timekeeping.rst | 35 ++++++++++++++++++++++++++
>  4 files changed, 74 insertions(+)
>  create mode 100644 Documentation/virt/kvm/arm/ptp_kvm.rst
> 
> diff --git a/Documentation/virt/kvm/api.rst 
> b/Documentation/virt/kvm/api.rst
> index 36d5f1f3c6dd..9843dbcbf770 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6391,3 +6391,12 @@ When enabled, KVM will disable paravirtual
> features provided to the
>  guest according to the bits in the KVM_CPUID_FEATURES CPUID leaf
>  (0x40000001). Otherwise, a guest may use the paravirtual features
>  regardless of what has actually been exposed through the CPUID leaf.
> +
> +8.27 KVM_CAP_PTP_KVM
> +--------------------
> +
> +:Architectures: arm64
> +
> +This capability indicates that KVM virtual PTP service is supported in 
> host.
> +It must company with the implementation of KVM virtual PTP service in 
> host
> +so VMM can probe if there is the service in host by checking this 
> capability.
> diff --git a/Documentation/virt/kvm/arm/index.rst
> b/Documentation/virt/kvm/arm/index.rst
> index 3e2b2aba90fc..78a9b670aafe 100644
> --- a/Documentation/virt/kvm/arm/index.rst
> +++ b/Documentation/virt/kvm/arm/index.rst
> @@ -10,3 +10,4 @@ ARM
>     hyp-abi
>     psci
>     pvtime
> +   ptp_kvm
> diff --git a/Documentation/virt/kvm/arm/ptp_kvm.rst
> b/Documentation/virt/kvm/arm/ptp_kvm.rst
> new file mode 100644
> index 000000000000..bb1e6cfefe44
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/ptp_kvm.rst
> @@ -0,0 +1,29 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +PTP_KVM support for arm/arm64
> +=============================
> +
> +PTP_KVM is used for time sync between guest and host in a high 
> precision.
> +It needs to get the wall time and counter value from the host and
> transfer these
> +to guest via hypercall service. So one more hypercall service has been 
> added.
> +
> +This new SMCCC hypercall is defined as:
> +
> +* ARM_SMCCC_HYP_KVM_PTP_FUNC_ID: 0x86000001
> +
> +As both 32 and 64-bits ptp_kvm client should be supported, we choose
> SMC32/HVC32
> +calling convention.
> +
> +ARM_SMCCC_HYP_KVM_PTP_FUNC_ID:
> +
> +    =============    ==========    ==========
> +    Function ID:     (uint32)      0x86000001
> +    Arguments:	     (uint32)      ARM_PTP_PHY_COUNTER(1) or
> ARM_PTP_VIRT_COUNTER(0)
> +                                   which indicate acquiring physical 
> counter or
> +                                   virtual counter respectively.
> +    return value:    (uint32)      NOT_SUPPORTED(-1) or val0 and val1 
> represent
> +                                   wall clock time and val2 and val3 
> represent
> +                                   counter cycle.

This needs a lot more description:

- Which word contains what part of the data (upper/lower part of the 
64bit data)
- The endianness of the data returned

         M.
-- 
Jazz is not dead. It just smells funny...
