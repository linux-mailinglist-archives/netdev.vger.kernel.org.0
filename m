Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890D93B3125
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhFXOU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:20:26 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5424 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhFXOUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:20:25 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G9hwR2GpQz73tq;
        Thu, 24 Jun 2021 22:14:47 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 24 Jun 2021 22:18:03 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 24
 Jun 2021 22:18:02 +0800
Subject: Re: [PATCH net-next 1/3] arm64: barrier: add DGH macros to control
 memory accesses merging
To:     Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <catalin.marinas@arm.com>, <maz@kernel.org>, <dbrazdil@google.com>,
        <qperret@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <lipeng321@huawei.com>,
        <peterz@infradead.org>
References: <1624360271-17525-1-git-send-email-huangguangbin2@huawei.com>
 <1624360271-17525-2-git-send-email-huangguangbin2@huawei.com>
 <20210622121630.GC30757@willie-the-truck>
 <20210622123221.GA71782@C02TD0UTHF1T.local>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <7561019b-f8e6-2191-5aba-3464f06be537@huawei.com>
Date:   Thu, 24 Jun 2021 22:18:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210622123221.GA71782@C02TD0UTHF1T.local>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/6/22 20:32, Mark Rutland wrote:
> On Tue, Jun 22, 2021 at 01:16:31PM +0100, Will Deacon wrote:
>> On Tue, Jun 22, 2021 at 07:11:09PM +0800, Guangbin Huang wrote:
>>> From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
>>>
>>> DGH prohibits merging memory accesses with Normal-NC or Device-GRE
>>> attributes before the hint instruction with any memory accesses
>>> appearing after the hint instruction. Provide macros to expose it to the
>>> arch code.
>>
>> Hmm.
>>
>> The architecture states:
>>
>>    | DGH is a hint instruction. A DGH instruction is not expected to be
>>    | performance optimal to merge memory accesses with Normal Non-cacheable
>>    | or Device-GRE attributes appearing in program order before the hint
>>    | instruction with any memory accesses appearing after the hint instruction
>>    | into a single memory transaction on an interconnect.
>>
>> which doesn't make a whole lot of sense to me, in all honesty.
> 
> I think there are some missing words, and this was supposed to say
> something like:
> 
> | DGH is a hint instruction. A DGH instruction *indicates that it* is
> | not expected to be performance optimal to merge memory accesses with
> | Normal Non-cacheable or Device-GRE attributes appearing in program
> | order before the hint instruction with any memory accesses appearing
> | after the hint instruction into a single memory transaction on an
> | interconnect.
> 
> ... i.e. it's a hint to the CPU to avoid merging accesses which are
> either side of the DGH, so that the prior accesses don't get
> indefinitely delayed waiting to be merged.
> 
> I'll try to get the documentation fixed, since as-is the wording does
> not make sense.
> 
> Thanks,
> Mark.
> .
> 
Thanks very much, we will fix the documentation.

Thanks,
Guangbin,
.

