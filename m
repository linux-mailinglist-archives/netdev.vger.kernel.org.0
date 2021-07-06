Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAC53BC49A
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 03:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhGFBiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 21:38:01 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:10267 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbhGFBiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 21:38:00 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GJlNJ4znSz1CFVt;
        Tue,  6 Jul 2021 09:29:52 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 6 Jul 2021 09:35:19 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Tue, 6 Jul 2021
 09:35:19 +0800
Subject: Re: [PATCH net-next 0/2] refactor the ringtest testing for ptr_ring
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>, <ndesaulniers@gooogle.com>,
        Joe Perches <joe@perches.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
References: <1625457455-4667-1-git-send-email-linyunsheng@huawei.com>
 <YOLXTB6VxtLBmsuC@smile.fi.intel.com>
 <c6844e2b-530f-14b2-0ec3-d47574135571@huawei.com>
 <20210705142555-mutt-send-email-mst@kernel.org>
 <YONRKnDzCzSAXptx@smile.fi.intel.com>
 <20210705143952-mutt-send-email-mst@kernel.org>
 <CAHp75VcsUxOqu48E1+RNqn=RhJqfd7XG8e3AKRHyMb3ywzSPrg@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <b292ff2b-b21c-203e-dcae-70d9c39aed02@huawei.com>
Date:   Tue, 6 Jul 2021 09:35:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAHp75VcsUxOqu48E1+RNqn=RhJqfd7XG8e3AKRHyMb3ywzSPrg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/6 3:05, Andy Shevchenko wrote:
> On Mon, Jul 5, 2021 at 9:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>
>> On Mon, Jul 05, 2021 at 09:36:26PM +0300, Andy Shevchenko wrote:
>>> On Mon, Jul 05, 2021 at 02:26:32PM -0400, Michael S. Tsirkin wrote:
>>>> On Mon, Jul 05, 2021 at 08:06:50PM +0800, Yunsheng Lin wrote:
>>>>> On 2021/7/5 17:56, Andy Shevchenko wrote:
>>>>>> On Mon, Jul 05, 2021 at 11:57:33AM +0800, Yunsheng Lin wrote:
>>>>>>> tools/include/* have a lot of abstract layer for building
>>>>>>> kernel code from userspace, so reuse or add the abstract
>>>>>>> layer in tools/include/ to build the ptr_ring for ringtest
>>>>>>> testing.
>>>>>>
>>>>>> ...
>>>>>>
>>>>>>>  create mode 100644 tools/include/asm/cache.h
>>>>>>>  create mode 100644 tools/include/asm/processor.h
>>>>>>>  create mode 100644 tools/include/generated/autoconf.h
>>>>>>>  create mode 100644 tools/include/linux/align.h
>>>>>>>  create mode 100644 tools/include/linux/cache.h
>>>>>>>  create mode 100644 tools/include/linux/slab.h
>>>>>>
>>>>>> Maybe somebody can change this to be able to include in-tree headers directly?
>>>>>
>>>>> If the above works, maybe the files in tools/include/* is not
>>>>> necessary any more, just use the in-tree headers to compile
>>>>> the user space app?
>>>>>
>>>>> Or I missed something here?
>>>>
>>>> why would it work? kernel headers outside of uapi are not
>>>> intended to be consumed by userspace.
>>>
>>> The problem here, that we are almost getting two copies of the headers, and
>>> tools are not in a good maintenance, so it's often desynchronized from the
>>> actual Linux headers. This will become more and more diverse if we keep same
>>> way of operation. So, I would rather NAK any new copies of the headers from
>>> include/ to tools/include.
>>
>> We already have the copies
>> yes they are not maintained well ... what's the plan then?
>> NAK won't help us improve the situation.
> 
> I understand and the proposal is to leave only the files which are not
> the same (can we do kinda wrappers or so in tools/include rather than
> copying everything?).

I am not sure the proposal is the right direction.
As mentioned by Michael, kernel headers outside of uapi are not
intended to be consumed by userspace, so those header might be
changed without considering of the code using them in tools/,
using the wrappers might cause more breaking of tools/.
And grepping through the tools/include does not seems to be
a lot of wrapper(only some low level asm include file like
tools/include/asm/barrier.h has the wrapper, which is supposed
not to be changed very often?)
so using wrappers does not seem to be the best choice here.

> 
>> I would say copies are kind of okay just make sure they are
>> built with kconfig. Then any breakage will be
>> detected.
>>
>>>>>> Besides above, had you tested this with `make O=...`?
>>>>>
>>>>> You are right, the generated/autoconf.h is in another directory
>>>>> with `make O=...`.
>>>>>
>>>>> Any nice idea to fix the above problem?
> 
> 
