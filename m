Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6033BB4F9
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 03:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhGEBqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 21:46:25 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:10247 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhGEBqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 21:46:24 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GJ7cY09tlz1CFLb;
        Mon,  5 Jul 2021 09:38:21 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 09:43:46 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 5 Jul 2021
 09:43:46 +0800
Subject: Re: Re: [PATCH net-next v3 1/3] selftests/ptr_ring: add benchmark
 application for ptr_ring
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <brouer@redhat.com>, <paulmck@kernel.org>,
        <peterz@infradead.org>, <will@kernel.org>, <shuah@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linuxarm@openeuler.org>
References: <1625142402-64945-1-git-send-email-linyunsheng@huawei.com>
 <1625142402-64945-2-git-send-email-linyunsheng@huawei.com>
 <e1ec4577-a48f-ff56-b766-1445c2501b9f@redhat.com>
 <91bcade8-f034-4bc7-f329-d5e1849867e7@huawei.com>
 <20210702042838-mutt-send-email-mst@kernel.org>
 <661a84bc-e7c5-bc21-25ac-75a68efa79ca@huawei.com>
 <1fed53f1-f882-ca67-8876-ca6702dcd9cd@redhat.com>
 <06f0dc67-d614-30d3-6dcc-f2446cb6030b@huawei.com>
 <20210702101730-mutt-send-email-mst@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <6e070501-204b-dc3e-60fb-4134ebdab206@huawei.com>
Date:   Mon, 5 Jul 2021 09:43:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210702101730-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme709-chm.china.huawei.com (10.1.199.105) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/2 22:18, Michael S. Tsirkin wrote:
> On Fri, Jul 02, 2021 at 05:54:42PM +0800, Yunsheng Lin wrote:
>> On 2021/7/2 17:04, Jason Wang wrote:
>>>
>>
>> [...]
>>
>>>
>>>
>>>> I understand that you guys like to see a working testcase of virtio.
>>>> I would love to do that if I have the time and knowledge of virtio,
>>>> But I do not think I have the time and I am familiar enough with
>>>> virtio to fix that now.
>>>
>>>
>>> So ringtest is used for bench-marking the ring performance for different format. Virtio is only one of the supported ring format, ptr ring is another. Wrappers were used to reuse the same test logic.
>>>
>>> Though you may see host/guest in the test, it's in fact done via two processes.
>>>
>>> We need figure out:
>>>
>>> 1) why the current ringtest.c does not fit for your requirement (it has SPSC test)
>>
>> There is MPSC case used by pfifo_fast, it make more sense to use a separate selftest
>> for ptr_ring as ptr_ring has been used by various subsystems.
>>
>>
>>> 2) why can't we tweak the ptr_ring.c to be used by both ring_test and your benchmark
>>
>> Actually that is what I do in this patch, move the specific part related to ptr_ring
>> to ptr_ring_test.h. When the virtio testing is refactored to work, it can reuse the
>> abstract layer in ptr_ring_test.h too.
> 
> Sounds good. But that refactoring will be up to you as a contributor.

It seems that tools/include/* have a lot of portability infrastructure for building
kernel code from userspace, will try to refactor the ptr_ring.h to use the portability
infrastructure in tools/include/* when building ptr_ring.h from userspace.

>
