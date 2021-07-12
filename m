Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7A13C4149
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 04:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbhGLCqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 22:46:02 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:10354 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhGLCqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 22:46:01 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GNSd22gLTz78Ps;
        Mon, 12 Jul 2021 10:38:46 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 12 Jul 2021 10:43:04 +0800
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 12 Jul
 2021 10:43:04 +0800
Subject: Re: [RFC net-next] net: extend netdev features
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>,
        "shenjian15@huawei.com" <shenjian15@huawei.com>
References: <1625910047-56840-1-git-send-email-shenjian15@huawei.com>
 <20210710081120.5570fb87@hermes.local>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <f6bc28f6-55b6-856b-949f-7715574eb869@huawei.com>
Date:   Mon, 12 Jul 2021 10:43:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20210710081120.5570fb87@hermes.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/7/10 23:11, Stephen Hemminger 写道:
> On Sat, 10 Jul 2021 17:40:47 +0800
> Jian Shen <shenjian15@huawei.com> wrote:
>
>> For the prototype of netdev_features_t is u64, and the number
>> of netdevice feature bits is 64 now. So there is no space to
>> introduce new feature bit.
>>
>> I did a small change for this. Keep the prototype of
>> netdev_feature_t, and extend the feature members in struct
>> net_device to an array of netdev_features_t. So more features
>> bits can be used.
>>
>> As this change, some functions which use netdev_features_t as
>> parameter or returen value will be affected.
>> I did below changes:
>> a. parameter: "netdev_features_t" to "netdev_features_t *"
>> b. return value: "netdev_feature_t" to "void", and add
>> "netdev_feature_t *" as output parameter.
>>
>> I kept some functions no change, which are surely useing the
>> first 64 bit of net device features now, such as function
>> nedev_add_tso_features(). In order to minimize to changes.
>>
>> For the features are array now, so it's unable to do logical
>> operation directly. I introduce a inline function set for
>> them, including "netdev_features_and/andnot/or/xor/equal/empty".
>>
>> For NETDEV_FEATURE_COUNT may be more than 64, so the shift
>> operation for NETDEV_FEATURE_COUNT is illegal. I changed some
>> macroes and functions, which does shift opertion with it.
>>
>> I haven't finished all the changes, for it affected all the
>> drivers which use the feature, need more time and test. I
>> sent this RFC patch, want to know whether this change is
>> acceptable, and how to improve it.
>>
>> Any comments will be helpful.
>>
>> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> Infrastructure changes must be done as part of the patch that
> needs the new feature bit. It might be that your feature bit is
> not accepted as part of the review cycle, or a better alternative
> is proposed.
> .
OK, I will send it with patch including my new feature bit next time.

I haven't finish the whole changes, and I sent this one, wanting to know 
whether
the change is acceptable or whether need use more reasonable shceme.

Thanks!


Jian Shen




