Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2A2138FE2
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 12:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbgAMLQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 06:16:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:39780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgAMLQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 06:16:28 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E34BD207E0;
        Mon, 13 Jan 2020 11:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578914188;
        bh=oQgIRZE3Ca1zvjHWdut6CuVqEaxiZSV5sbQvWLbrvag=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e3TcvGj31AwlkiLT/c2UDThap+MfQ1EwwdLbheey2cC7to/q4SOcYLDkg406rEFf0
         LXe9K5ORlRbmcMY05oDtY9CrSsLFr2i4qGS1k3/8tFudNQUDC1T087p4NcCBMYiguz
         L0ETEtO7VrTs+z8DDuIoxk2Czw4BqJLM9CJopX2A=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1iqxhq-0002vN-8G; Mon, 13 Jan 2020 11:16:26 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 13 Jan 2020 11:16:26 +0000
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
In-Reply-To: <HE1PR0801MB167693BFB769ACEEA8A6B007F4350@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191210034026.45229-1-jianyong.wu@arm.com>
 <20191210034026.45229-7-jianyong.wu@arm.com>
 <7383dc06897bba253f174cd21a19b5c0@kernel.org>
 <HE1PR0801MB1676AB738138AB24E2158AD4F4390@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <099a26ffef5d554b88a5e33d7f2a6e3a@kernel.org>
 <HE1PR0801MB16765B507D9B5A1A7827078BF4380@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ca80d88f5e00937fca7ee80be8f5c962@kernel.org>
 <HE1PR0801MB167693BFB769ACEEA8A6B007F4350@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Message-ID: <22ba1283a7b82f018c1fdf85414e5bfe@kernel.org>
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

Hi Jianyong,

On 2020-01-13 10:30, Jianyong Wu wrote:
> Hi Marc,
> 
>> -----Original Message-----
>> From: Marc Zyngier <maz@kernel.org>
>> Sent: Friday, January 10, 2020 6:56 PM
>> NV breaks that assumtion, because the guest hypervisor is using the 
>> physical
>> counter. Also, let's not forget that the hypercall isn't Linux 
>> specific.
>> I can write my own non-Linux guest and still use this hypercall. 
>> Nothing in
>> there says that I can't use the physical counter if I want to.
>> 
>> So somehow, you need to convey the the hypervisor the notion of 
>> *which*
>> counter the guest uses.
>> 
>> Does it make sense? Or am I missing something?
>> 
> I know what you say. Let me try to solve this problem.
> 	Step 0, summary out all the conditions we should process, which will
> sever as branch condition.(now only normal virt and nested virt, I
> think)

No. You shouldn't think of the various use cases, but of which time
references a guest can use. You don't need nested virt to use the 
physical
counter, for example.

> 	Step 1, figure out the set of reference counter value used by guest
> in all condition.

That should be for the guest to tell you when it calls into the PV 
service.

> 	Step 2, determine which reference counter value will be used by guest
> in a certain condition in hypercall.
> In step 1, can we give the set only 2 elements that one is physical
> counter the other is virtual counter?

I don't think returning the two values is useful. Just return what the
guest asks for.

> For step 2, I have no idea for that now. can you give me some hint 
> about it?

Just expand your SMC call to take a parameter indicating the reference
counter, and return the sampled (or computed) value corresponding to
that counter.

         M.
-- 
Jazz is not dead. It just smells funny...
