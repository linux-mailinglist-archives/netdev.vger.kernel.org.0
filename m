Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF28C3CCC04
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 03:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhGSBnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 21:43:52 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:11339 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbhGSBnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 21:43:52 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GSkvh6RjXz7vZh;
        Mon, 19 Jul 2021 09:36:16 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 19 Jul 2021 09:40:40 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 19 Jul
 2021 09:40:40 +0800
Subject: Re: [PATCH net-next 1/2] tools: add missing infrastructure for
 building ptr_ring.h
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jasowang@redhat.com>,
        <nickhu@andestech.com>, <green.hu@gmail.com>,
        <deanbo422@gmail.com>, <akpm@linux-foundation.org>,
        <yury.norov@gmail.com>, <andriy.shevchenko@linux.intel.com>,
        <ojeda@kernel.org>, <ndesaulniers@gooogle.com>, <joe@perches.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>,
        =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
References: <1625457455-4667-1-git-send-email-linyunsheng@huawei.com>
 <1625457455-4667-2-git-send-email-linyunsheng@huawei.com>
 <20210705143144-mutt-send-email-mst@kernel.org>
 <cbc4053e-7eda-4c46-5b98-558c741e45b6@huawei.com>
 <20210717220239-mutt-send-email-mst@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <5d320b37-18f3-e853-ceb7-21af7ca12763@huawei.com>
Date:   Mon, 19 Jul 2021 09:40:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210717220239-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme706-chm.china.huawei.com (10.1.199.102) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/18 10:09, Michael S. Tsirkin wrote:
> On Tue, Jul 06, 2021 at 10:04:02AM +0800, Yunsheng Lin wrote:
>> On 2021/7/6 2:39, Michael S. Tsirkin wrote:
>>> On Mon, Jul 05, 2021 at 11:57:34AM +0800, Yunsheng Lin wrote:

[..]

>>>> diff --git a/tools/include/asm/processor.h b/tools/include/asm/processor.h
>>>> new file mode 100644
>>>> index 0000000..3198ad6
>>>> --- /dev/null
>>>> +++ b/tools/include/asm/processor.h
>>>> @@ -0,0 +1,36 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>>> +
>>>> +#ifndef __TOOLS_LINUX_ASM_PROCESSOR_H
>>>> +#define __TOOLS_LINUX_ASM_PROCESSOR_H
>>>> +
>>>> +#include <pthread.h>
>>>> +
>>>> +#if defined(__i386__) || defined(__x86_64__)
>>>> +#include "../../arch/x86/include/asm/vdso/processor.h"
>>>> +#elif defined(__arm__)
>>>> +#include "../../arch/arm/include/asm/vdso/processor.h"
>>>> +#elif defined(__aarch64__)
>>>> +#include "../../arch/arm64/include/asm/vdso/processor.h"
>>>> +#elif defined(__powerpc__)
>>>> +#include "../../arch/powerpc/include/vdso/processor.h"
>>>> +#elif defined(__s390__)
>>>> +#include "../../arch/s390/include/vdso/processor.h"
>>>> +#elif defined(__sh__)
>>>> +#include "../../arch/sh/include/asm/processor.h"
>>>> +#elif defined(__sparc__)
>>>> +#include "../../arch/sparc/include/asm/processor.h"
>>>> +#elif defined(__alpha__)
>>>> +#include "../../arch/alpha/include/asm/processor.h"
>>>> +#elif defined(__mips__)
>>>> +#include "../../arch/mips/include/asm/vdso/processor.h"
>>>> +#elif defined(__ia64__)
>>>> +#include "../../arch/ia64/include/asm/processor.h"
>>>> +#elif defined(__xtensa__)
>>>> +#include "../../arch/xtensa/include/asm/processor.h"
>>>> +#elif defined(__nds32__)
>>>> +#include "../../arch/nds32/include/asm/processor.h"
>>>> +#else
>>>> +#define cpu_relax()	sched_yield()
>>>
>>> Does this have a chance to work outside of kernel?
>>
>> I am not sure I understand what you meant here.
>> sched_yield() is a pthread API, so it should work in the
>> user space.
>> And it allow the rigntest to compile when it is built on
>> the arch which is not handled as above.
> 
> It might compile but is likely too heavy to behave
> reasonably.
> 
> Also, given you did not actually test it I don't
> think you should add such arch code.
> Note you broke at least s390 here:
> ../../arch/s390/include/vdso/processor.h
> does not actually exist. Where these headers
> do exit they tend to include lots of code which won't
> build out of kernel.

You are right, it should be in:
../../arch/s390/include/asm/vdso/processor.h

> 
> All this is just for cpu_relax - open coding that seems way easier.

Sure.

As Eugenio has posted a patchset to fix the compilation, which does
not seems to be merged yet and may have some merging conflicts with
this patchset, so either wait for the Eugenio' patchset to be merged
before proceeding with this patchset, or explicitly note the dependency
of Eugenio' patchset when sending the new version of patchset. I am not
familiar with the merging flow of virtio to say which way is better, any
suggestion how to proceed with this patchset?

1. https://lkml.org/lkml/2021/7/6/1132

> 
> 
>>>
>>>> +#endif
>>>
>>> did you actually test or even test build all these arches?
>>> Not sure we need to bother with hacks like these.
>>
>> Only x86_64 and arm64 arches have been built and tested.
> 
> In that case I think you should not add code that you
> have not even built let alone tested.

Ok.

> 
> 
>> This is added referring the tools/include/asm/barrier.h.
>>
>>>
>>>
>>>> +
> 
> .
> 
