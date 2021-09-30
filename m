Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A2C41D1CC
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 05:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347871AbhI3DQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 23:16:55 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13857 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346735AbhI3DQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 23:16:54 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKdXm3qnSz8yxN;
        Thu, 30 Sep 2021 11:10:32 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 11:15:06 +0800
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 30 Sep
 2021 11:15:06 +0800
Subject: Re: [RFCv2 net-next 000/167] net: extend the netdev_features_t
To:     Edward Cree <ecree.xilinx@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <andrew@lunn.ch>, <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20210929155334.12454-1-shenjian15@huawei.com>
 <ca0ffcae-a82b-f81f-7702-410650e4677c@gmail.com>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <24f4fcfa-6c62-7784-0b25-aa60044c9f4d@huawei.com>
Date:   Thu, 30 Sep 2021 11:15:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <ca0ffcae-a82b-f81f-7702-410650e4677c@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, edward


在 2021/9/30 8:55, Edward Cree 写道:
> On 29/09/2021 16:50, Jian Shen wrote:
>> This patchset try to solve it by change the prototype of
>> netdev_features_t from u64 to bitmap. With this change,
>> it's necessary to introduce a set of bitmap operation helpers
>> for netdev features. Meanwhile, the functions which use
>> netdev_features_t as return value are also need to be changed,
>> return the result as an output parameter.
> This might be a terrible idea, but could you not do something like
>      typedef struct {
>          DECLARE_BITMAP(bits, NETDEV_FEATURE_COUNT);
>      } netdev_features_t;
>   thereby allowing functions to carry on returning it directly?
> The compiler would still likely turn it into an output parameter
>   at an ABI level (at least once NETDEV_FEATURE_COUNT goes above
>   64), but the amount of code churn might be significantly reduced.
> Another advantage is that, whereas bitwise ops (&, |, ^) on a
>   pointer (such as unsigned long *) are legal (meaning something
>   like "if (features & NETIF_F_GSO_MASK)" may still compile, at
>   best with a warning, despite having nonsensical semantics), they
>   aren't possible on a struct; so there's less risk of unpatched
>   code (perhaps merged in from another subsystem, or in out-of-tree
>   modules) silently breaking — instead, any mix of new and old code
>   will be caught at build time.
>
> WDYT?
> -ed
> .
Thanks for your advice.  It looks good to me.

The risk of misusing bitwise ops, and not be reported by  compiler is 
truely
exist in my patchset.  I will consider the way of using structure.

shenjian


