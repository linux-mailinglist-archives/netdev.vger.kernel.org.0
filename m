Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28AE9441BB2
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 14:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhKANaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 09:30:23 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:25334 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbhKANaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 09:30:23 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HjYcm3DGszbhPq;
        Mon,  1 Nov 2021 21:23:04 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 1 Nov 2021 21:27:47 +0800
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Mon, 1 Nov
 2021 21:27:47 +0800
Subject: Re: [RFCv3 PATCH net-next] net: extend netdev_features_t
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>
References: <20211101010535.32575-1-shenjian15@huawei.com>
 <YX9RCqTOAHtiGD3n@lunn.ch> <0c45431b-ad76-87c6-c498-f19584ae6840@huawei.com>
 <YX/eScgmGwDyalhA@lunn.ch>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <92219840-581d-0afa-6ad0-5648c3b23b34@huawei.com>
Date:   Mon, 1 Nov 2021 21:27:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <YX/eScgmGwDyalhA@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/11/1 20:32, Andrew Lunn 写道:
>>>>    static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
>>>> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
>>>> index 16f778887e14..9b3ab11e19c8 100644
>>>> --- a/include/linux/netdev_features.h
>>>> +++ b/include/linux/netdev_features.h
>>>> @@ -101,12 +101,12 @@ enum {
>>>>    typedef struct {
>>>>    	DECLARE_BITMAP(bits, NETDEV_FEATURE_COUNT);
>>>> -} netdev_features_t;
>>>> +} netdev_features_t;
>>> That hunk looks odd.
>> Yes, but it can be return directly, so we don't have to change
>> the prototype of functions which return netdev_features_t,
>> like  ndo_features_check.
>>
>>>> -static inline void netdev_feature_zero(netdev_features_t *dst)
>>>> +static inline void netdev_features_zero(netdev_features_t *dst)
>>>>    {
>>>>    	bitmap_zero(dst->bits, NETDEV_FEATURE_COUNT);
>>>>    }
>>>> -static inline void netdev_feature_fill(netdev_features_t *dst)
>>>> +static inline void netdev_features_fill(netdev_features_t *dst)
>>>>    {
>>>>    	bitmap_fill(dst->bits, NETDEV_FEATURE_COUNT);
>>>>    }
>>> I'm wondering that the value here is? What do we gain by added the s.
>>> These changes cause a lot of churn in the users of these functions.
>> This function is used to expression like below:
>>
>> "lowerdev_features &= (features | ~NETIF_F_LRO);"  in drivers/net/macvlan.c
> O.K, now i know what is confusing me. This is not a patch on top of
> clean net-next/master. It does not have netdev_features_t as a bitmap,
> it does not have netdev_feature_fill().
>
> You already have some other changes applied to your tree, and this
> patch is on top of that?
Sorry for this mistake, I will be more careful next time.


>
> I think we generally agree about the direction you are going. What we
> probably want to see is a patchset against net-next/master which
> converts the core and one driver to this new API. That allows us to
> review the new API, which is the important thing here.
OK . Thanks again !

             Jian

>>   I prefered to rename the netdev field active_features .
> O.K.
>
> 	Andrew
> .
>

