Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D4A13560B
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 10:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbgAIJqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 04:46:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:32852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728791AbgAIJqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 04:46:17 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ED0920678;
        Thu,  9 Jan 2020 09:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578563176;
        bh=NHHel1PVO2HlRqINTAayeLOlQXHvdSb0MKXB6GwG2Xo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lv9mjO62CPa1so1ZNZc7FENfSViFFVsdY2DTNxbyY0LlNLpor7G78cti04LiXbtAQ
         i1UplCiDuC04AomjvqZIGN5V5p177tJ+wuJY8hHksssGF7ld7YsHQULYsaCu+Rzqoe
         SJjCc7PRPQRTg+7rJf13faQFdPYCd31nGKHrR8L8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1ipUOM-0002fn-Nv; Thu, 09 Jan 2020 09:46:14 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 09 Jan 2020 09:46:14 +0000
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
        nd <nd@arm.com>, kvm-owner@vger.kernel.org
Subject: Re: [RFC PATCH v9 7/8] ptp: arm64: Enable ptp_kvm for arm64
In-Reply-To: <ee801dacbf4143e8d41807d5bfad1409@kernel.org>
References: <20191210034026.45229-1-jianyong.wu@arm.com>
 <20191210034026.45229-8-jianyong.wu@arm.com>
 <ca162efb3a0de530e119f5237c006515@kernel.org>
 <HE1PR0801MB1676EE12CF0DB7C5BB8CC62DF4390@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ee801dacbf4143e8d41807d5bfad1409@kernel.org>
Message-ID: <a5f5fc5bf913c9a22923d1a556f511e6@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: Jianyong.Wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, Suzuki.Poulose@arm.com, Steven.Price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, Kaly.Xin@arm.com, Justin.He@arm.com, nd@arm.com, kvm-owner@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-09 09:24, Marc Zyngier wrote:
> On 2020-01-09 05:59, Jianyong Wu wrote:

[...]

>> So we focus it on arm64. Also I have never tested it on arm32 machine
>> ( we lack of arm32 machine)
> 
> I'm sure your employer can provide you with such a box. I can probably
> even tell you which cupboard they are stored in... ;-)
> 
>> Do you think it's necessary to enable ptp_kvm on arm32? If so, I can 
>> do that.
> 
> I can't see why we wouldn't, given that it should be a zero effort task
> (none of the code here is arch specific).

To be clear, what I'm after is support for 32bit *guests*. I don't 
expect any
issue with a 32bit host (it's all common code), but you should be able 
to test
32bit guests pretty easily (most ARMv8.0 CPUs support 32bit EL1).

         M.
-- 
Jazz is not dead. It just smells funny...
