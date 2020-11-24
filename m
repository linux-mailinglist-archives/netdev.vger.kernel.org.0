Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F024F2C20E2
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731088AbgKXJHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:07:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:33000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730956AbgKXJHJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 04:07:09 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FB8A2075A;
        Tue, 24 Nov 2020 09:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606208828;
        bh=YKBAEa1S7x5XyrSw9i58+TYmKcHvXHjT1wTkrq7seHc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1TYjrVTNfjqRUqQ/Iq86CER/48R56RG15mANFIvrlo9mW1LXuq4cPU6J1UPtrskq+
         Y/4ztGT3YKOQUxjApd/8IVwhnC1II+KQXMqYOUxLDqarudt1tbzm7u4Jx2fQvqEsLC
         Dsp1C5/QeN917gO0flLsoG/WxZDDD3SzTT8JrL3c=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1khUHy-00DCBp-50; Tue, 24 Nov 2020 09:07:06 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 24 Nov 2020 09:07:06 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Jianyong Wu <Jianyong.Wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, richardcochran@gmail.com,
        Mark Rutland <Mark.Rutland@arm.com>, will@kernel.org,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve Capper <Steve.Capper@arm.com>,
        Justin He <Justin.He@arm.com>, nd <nd@arm.com>
Subject: Re: [PATCH v15 6/9] arm64/kvm: Add hypercall service for kvm ptp.
In-Reply-To: <HE1PR0802MB255534CF7A04FB5A6CE99A67F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
 <20201111062211.33144-7-jianyong.wu@arm.com>
 <d409aa1cb7cfcbf4351e6c5fc34d9c7e@kernel.org>
 <HE1PR0802MB255534CF7A04FB5A6CE99A67F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <9133f26699c5fc08d0ea72acfa9aca3b@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: Jianyong.Wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, Suzuki.Poulose@arm.com, Andre.Przywara@arm.com, Steven.Price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, Justin.He@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-24 05:20, Jianyong Wu wrote:
> Hi Marc,

[...]

>> > +/* ptp_kvm counter type ID */
>> > +#define ARM_PTP_VIRT_COUNTER			0
>> > +#define ARM_PTP_PHY_COUNTER			1
>> > +#define ARM_PTP_NONE_COUNTER			2
>> 
>> The architecture definitely doesn't have this last counter.
> 
> Yeah, this is just represent no counter data needed from guest.
> Some annotation should be added here.

I'd rather you remove it entirely, or explain why you really cannot
do without a fake counter.

         M.
-- 
Jazz is not dead. It just smells funny...
