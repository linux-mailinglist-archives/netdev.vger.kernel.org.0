Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B4B362EAD
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 11:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235910AbhDQJAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 05:00:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17009 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbhDQJAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 05:00:18 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FMn516YzyzPqwM;
        Sat, 17 Apr 2021 16:56:53 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Sat, 17 Apr 2021 16:59:42 +0800
Subject: Re: [PATCH v19 6/7] KVM: arm64: Add support for the KVM PTP service
To:     Marc Zyngier <maz@kernel.org>
CC:     <netdev@vger.kernel.org>, <yangbo.lu@nxp.com>,
        <john.stultz@linaro.org>, <tglx@linutronix.de>,
        <pbonzini@redhat.com>, <seanjc@google.com>,
        <richardcochran@gmail.com>, <Mark.Rutland@arm.com>,
        <will@kernel.org>, <suzuki.poulose@arm.com>,
        <Andre.Przywara@arm.com>, <steven.price@arm.com>,
        <lorenzo.pieralisi@arm.com>, <sudeep.holla@arm.com>,
        <justin.he@arm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@android.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
References: <20210330145430.996981-1-maz@kernel.org>
 <20210330145430.996981-7-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5aadf0b4-b9e5-8521-db60-52a0f319cf28@huawei.com>
Date:   Sat, 17 Apr 2021 16:59:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210330145430.996981-7-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/30 22:54, Marc Zyngier wrote:
> +PTP_KVM support for arm/arm64
> +=============================
> +
> +PTP_KVM is used for high precision time sync between host and guests.
> +It relies on transferring the wall clock and counter value from the
> +host to the guest using a KVM-specific hypercall.
> +
> +* ARM_SMCCC_HYP_KVM_PTP_FUNC_ID: 0x86000001

Per include/linux/arm-smccc.h, this should be
ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID.

> +
> +This hypercall uses the SMC32/HVC32 calling convention:
> +
> +ARM_SMCCC_HYP_KVM_PTP_FUNC_ID

ditto

> +    =============    ==========    ==========
> +    Function ID:     (uint32)      0x86000001
> +    Arguments:       (uint32)      KVM_PTP_VIRT_COUNTER(0)
> +                                   KVM_PTP_PHYS_COUNTER(1)
