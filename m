Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50883B9E8C
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 11:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhGBJ5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 05:57:18 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:10239 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbhGBJ5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 05:57:17 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GGVfT2vjGz1BTT2;
        Fri,  2 Jul 2021 17:49:21 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 2 Jul 2021 17:54:42 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 2 Jul 2021
 17:54:42 +0800
Subject: Re: [PATCH net-next v3 1/3] selftests/ptr_ring: add benchmark
 application for ptr_ring
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <brouer@redhat.com>,
        <paulmck@kernel.org>, <peterz@infradead.org>, <will@kernel.org>,
        <shuah@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linuxarm@openeuler.org>
References: <1625142402-64945-1-git-send-email-linyunsheng@huawei.com>
 <1625142402-64945-2-git-send-email-linyunsheng@huawei.com>
 <e1ec4577-a48f-ff56-b766-1445c2501b9f@redhat.com>
 <91bcade8-f034-4bc7-f329-d5e1849867e7@huawei.com>
 <20210702042838-mutt-send-email-mst@kernel.org>
 <661a84bc-e7c5-bc21-25ac-75a68efa79ca@huawei.com>
 <1fed53f1-f882-ca67-8876-ca6702dcd9cd@redhat.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <06f0dc67-d614-30d3-6dcc-f2446cb6030b@huawei.com>
Date:   Fri, 2 Jul 2021 17:54:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1fed53f1-f882-ca67-8876-ca6702dcd9cd@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/2 17:04, Jason Wang wrote:
> 

[...]

> 
> 
>> I understand that you guys like to see a working testcase of virtio.
>> I would love to do that if I have the time and knowledge of virtio,
>> But I do not think I have the time and I am familiar enough with
>> virtio to fix that now.
> 
> 
> So ringtest is used for bench-marking the ring performance for different format. Virtio is only one of the supported ring format, ptr ring is another. Wrappers were used to reuse the same test logic.
> 
> Though you may see host/guest in the test, it's in fact done via two processes.
> 
> We need figure out:
> 
> 1) why the current ringtest.c does not fit for your requirement (it has SPSC test)

There is MPSC case used by pfifo_fast, it make more sense to use a separate selftest
for ptr_ring as ptr_ring has been used by various subsystems.


> 2) why can't we tweak the ptr_ring.c to be used by both ring_test and your benchmark

Actually that is what I do in this patch, move the specific part related to ptr_ring
to ptr_ring_test.h. When the virtio testing is refactored to work, it can reuse the
abstract layer in ptr_ring_test.h too.

> 
> If neither of the above work, we can invent new ptr_ring infrastructure under tests/
> 
> Thanks
> 
> 
>>
>>
> 
> .
> 
