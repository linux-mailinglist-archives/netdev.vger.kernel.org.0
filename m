Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3EA01F39E
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 14:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbfEOMQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 08:16:14 -0400
Received: from foss.arm.com ([217.140.101.70]:40858 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728001AbfEOLCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 07:02:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21FA480D;
        Wed, 15 May 2019 04:02:46 -0700 (PDT)
Received: from [10.1.196.75] (e110467-lin.cambridge.arm.com [10.1.196.75])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BD9043F703;
        Wed, 15 May 2019 04:02:44 -0700 (PDT)
Subject: Re: [PATCH] arm64: do_csum: implement accelerated scalar version
To:     Will Deacon <will.deacon@arm.com>
Cc:     Zhangshaokun <zhangshaokun@hisilicon.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org,
        "huanglingyan (A)" <huanglingyan2@huawei.com>, steve.capper@arm.com
References: <20190218230842.11448-1-ard.biesheuvel@linaro.org>
 <d7a16ebd-073f-f50e-9651-68606d10b01c@hisilicon.com>
 <20190412095243.GA27193@fuggles.cambridge.arm.com>
 <41b30c72-c1c5-14b2-b2e1-3507d552830d@arm.com>
 <20190515094704.GC24357@fuggles.cambridge.arm.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <67c2f851-9a4d-e18d-4664-c07287e72ebf@arm.com>
Date:   Wed, 15 May 2019 12:02:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515094704.GC24357@fuggles.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/05/2019 10:47, Will Deacon wrote:
> On Mon, Apr 15, 2019 at 07:18:22PM +0100, Robin Murphy wrote:
>> On 12/04/2019 10:52, Will Deacon wrote:
>>> I'm waiting for Robin to come back with numbers for a C implementation.
>>>
>>> Robin -- did you get anywhere with that?
>>
>> Still not what I would call finished, but where I've got so far (besides an
>> increasingly elaborate test rig) is as below - it still wants some unrolling
>> in the middle to really fly (and actual testing on BE), but the worst-case
>> performance already equals or just beats this asm version on Cortex-A53 with
>> GCC 7 (by virtue of being alignment-insensitive and branchless except for
>> the loop). Unfortunately, the advantage of C code being instrumentable does
>> also come around to bite me...
> 
> Is there any interest from anybody in spinning a proper patch out of this?
> Shaokun?

FWIW I've learned how to fix the KASAN thing now, so I'll try giving 
this some more love while I've got other outstanding optimisation stuff 
to look at anyway.

Robin.
