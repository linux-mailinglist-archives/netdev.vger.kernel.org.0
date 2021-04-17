Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFF9362E95
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 10:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbhDQInR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 04:43:17 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:17368 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhDQInQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 04:43:16 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FMmkb0bKTzlYKg;
        Sat, 17 Apr 2021 16:40:55 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Sat, 17 Apr 2021 16:42:39 +0800
Subject: Re: [PATCH v19 7/7] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
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
 <20210330145430.996981-8-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <d85fc46b-2076-ee0b-ac73-f7a3f393d87f@huawei.com>
Date:   Sat, 17 Apr 2021 16:42:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210330145430.996981-8-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/30 22:54, Marc Zyngier wrote:
> +int kvm_arch_ptp_init(void)
> +{
> +	int ret;
> +
> +	ret = kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_PTP);
> +	if (ret <= 0)

kvm_arm_hyp_service_available() returns boolean. Maybe write as ?

	bool ret;

	ret = kvm_arm_hyp_service_available();
	if (!ret)
		return -ENODEV;

> +		return -EOPNOTSUPP;
> +
> +	return 0;
> +}
