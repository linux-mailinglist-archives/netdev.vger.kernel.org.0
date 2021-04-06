Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5876354B06
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 04:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243478AbhDFCqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 22:46:55 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3069 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233030AbhDFCqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 22:46:54 -0400
Received: from dggeml406-hub.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FDsK14nkfzWTlg;
        Tue,  6 Apr 2021 10:43:17 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml406-hub.china.huawei.com (10.3.17.50) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 6 Apr 2021 10:46:30 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Tue, 6 Apr 2021
 10:46:30 +0800
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Kosina <jikos@kernel.org>
CC:     Hillf Danton <hdanton@sina.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Jike Song <albcamus@gmail.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        "David Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "Michal Kubecek" <mkubecek@suse.cz>,
        Netdev <netdev@vger.kernel.org>, Josh Hunt <johunt@akamai.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200825162329.11292-1-hdanton@sina.com>
 <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
 <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com>
 <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
 <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AB7fd2vUOQ@mail.gmail.com>
 <20200827125747.5816-1-hdanton@sina.com>
 <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
 <CAM_iQpXZMeAGkq_=rG6KEabFNykszpRU_Hnv65Qk7yesvbRDrw@mail.gmail.com>
 <5f51cbad3cc2_3eceb208fc@john-XPS-13-9370.notmuch>
 <nycvar.YFH.7.76.2104022120050.12405@cbobk.fhfr.pm>
 <20210403003537.2032-1-hdanton@sina.com>
 <nycvar.YFH.7.76.2104031420470.12405@cbobk.fhfr.pm>
 <CAM_iQpU+YD9AcX_77kqmQkqKMuOtnRh5xoGcz9dRRJTe1OnpBQ@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <2b99fce1-c235-6083-bd39-cece1f4a0343@huawei.com>
Date:   Tue, 6 Apr 2021 10:46:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpU+YD9AcX_77kqmQkqKMuOtnRh5xoGcz9dRRJTe1OnpBQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/6 9:49, Cong Wang wrote:
> On Sat, Apr 3, 2021 at 5:23 AM Jiri Kosina <jikos@kernel.org> wrote:
>>
>> I am still planning to have Yunsheng Lin's (CCing) fix [1] tested in the
>> coming days. If it works, then we can consider proceeding with it,
>> otherwise I am all for reverting the whole NOLOCK stuff.
>>
>> [1] https://lore.kernel.org/linux-can/1616641991-14847-1-git-send-email-linyunsheng@huawei.com/T/#u
> 
> I personally prefer to just revert that bit, as it brings more troubles
> than gains. Even with Yunsheng's patch, there are still some issues.
> Essentially, I think the core qdisc scheduling code is not ready for
> lockless, just look at those NOLOCK checks in sch_generic.c. :-/

I am also awared of the NOLOCK checks too:), and I am willing to
take care of it if that is possible.

As the number of cores in a system is increasing, it is the trend
to become lockless, right? Even there is only one cpu involved, the
spinlock taking and releasing takes about 30ns on our arm64 system
when CONFIG_PREEMPT_VOLUNTARY is enable(ip forwarding testing).

Currently I has three ideas to optimize the lockless qdisc:
1. implement the qdisc bypass for lockless qdisc too, see [1].

2. implement lockless enqueuing for lockless qdisc using the idea
   from Jason and Toke. And it has a noticable proformance increase with
   1-4 threads running using the below prototype based on ptr_ring.

static inline int __ptr_ring_multi_produce(struct ptr_ring *r, void *ptr)
{

        int producer, next_producer;


        do {
                producer = READ_ONCE(r->producer);
                if (unlikely(!r->size) || r->queue[producer])
                        return -ENOSPC;
                next_producer = producer + 1;
                if (unlikely(next_producer >= r->size))
                        next_producer = 0;
        } while(cmpxchg_relaxed(&r->producer, producer, next_producer) != producer);

        /* Make sure the pointer we are storing points to a valid data. */
        /* Pairs with the dependency ordering in __ptr_ring_consume. */
        smp_wmb();

        WRITE_ONCE(r->queue[producer], ptr);
        return 0;
}

3. Maybe it is possible to remove the netif_tx_lock for lockless qdisc
   too, because dev_hard_start_xmit is also in the protection of
   qdisc_run_begin()/qdisc_run_end()(if there is only one qdisc using
   a netdev queue, which is true for pfifo_fast, I believe).


[1]. https://patchwork.kernel.org/project/netdevbpf/patch/1616404156-11772-1-git-send-email-linyunsheng@huawei.com/

> 
> Thanks.
> 
> .
> 

