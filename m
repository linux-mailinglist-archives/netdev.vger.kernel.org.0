Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32A7C1435BA
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 03:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbgAUCkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 21:40:22 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9224 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727829AbgAUCkV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 21:40:21 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A1E57BFC39A7165EE507;
        Tue, 21 Jan 2020 10:40:19 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Tue, 21 Jan 2020
 10:40:12 +0800
Subject: Re: [PATCH] net: optimize cmpxchg in ip_idents_reserve
To:     Eric Dumazet <edumazet@google.com>
References: <1579058620-26684-1-git-send-email-zhangshaokun@hisilicon.com>
 <20200116.042722.153124126288244814.davem@davemloft.net>
 <930faaff-4d18-452d-2e44-ef05b65dc858@gmail.com>
 <1b3aaddf-22f5-1846-90f1-42e68583c1e4@gmail.com>
 <430496fc-9f26-8cb4-91d8-505fda9af230@hisilicon.com>
 <20200117123253.GC14879@hirez.programming.kicks-ass.net>
 <5fd55696-e46c-4269-c106-79782efb0dd8@hisilicon.com>
 <CANn89iJ02iFxGibdqO+YWVYX4q4J=W9vv7HOpMVqNK-qZvHcQw@mail.gmail.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <jinyuqi@huawei.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        <guoyang2@huawei.com>, Will Deacon <will@kernel.org>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <5377f988-9855-8322-a459-26376f50ee34@hisilicon.com>
Date:   Tue, 21 Jan 2020 10:40:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <CANn89iJ02iFxGibdqO+YWVYX4q4J=W9vv7HOpMVqNK-qZvHcQw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On 2020/1/19 12:12, Eric Dumazet wrote:
> On Sat, Jan 18, 2020 at 7:47 PM Shaokun Zhang
> <zhangshaokun@hisilicon.com> wrote:
>>
> 
>> We have used the atomic_add_return[1], but it makes the UBSAN unhappy followed
>> by the comment.
>> It seems that Eric also agreed to do it if some comments are added. I will do
>> it later.
>>
>> Thanks,
>> Shaokun
>>
>> [1] https://lkml.org/lkml/2019/7/26/217
>>
> 
> In case you have missed it, we needed a proper analysis.
> My feedback was quite simple :
> 
> <quote>
> Have you first checked that current UBSAN versions will not complain anymore ?
> </quote>
> 
> You never did this work, never replied to my question, and months

Yeah, I'm not sure how to deal with the UBSAN issue and you said that some of
you would work this.

> later you come back
> with a convoluted patch while we simply can proceed with a revert now

After several months, we thought that we can do it like refcount_add_not_zero,
so we submit this patch.

> we are sure that linux kernels are compiled with the proper option.
> 
> As mentioned yesterday, no need for a comment.
> Instead the changelog should be explaining why the revert is now safe.
> 

Ok, it is really needed to consider this.

Thanks,
Shaokun

> .
> 

