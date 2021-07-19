Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794163CCBED
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 03:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbhGSBYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 21:24:38 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:15037 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbhGSBYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 21:24:37 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GSkVv3jxxzZqmj;
        Mon, 19 Jul 2021 09:18:15 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 19 Jul 2021 09:21:29 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 19
 Jul 2021 09:21:29 +0800
Subject: Re: [PATCH V2 net-next 1/9] devlink: add documentation for hns3
 driver
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
References: <1626335110-50769-1-git-send-email-huangguangbin2@huawei.com>
 <1626335110-50769-2-git-send-email-huangguangbin2@huawei.com>
 <20210716080013.652969bf@cakuba>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <01c7a657-8454-4b2d-ded9-9212875e5e82@huawei.com>
Date:   Mon, 19 Jul 2021 09:21:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210716080013.652969bf@cakuba>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/7/16 14:00, Jakub Kicinski wrote:
> On Thu, 15 Jul 2021 15:45:02 +0800, Guangbin Huang wrote:
>> From: Hao Chen <chenhao288@hisilicon.com>
>>
>> Add a file to document devlink support for hns3 driver.
>>
>> Now support devlink param and devlink info.
>>
>> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> 
>> +This document describes the devlink features implemented by the ``hns3``
>> +device driver.
>> +
>> +Parameters
>> +==========
>> +
>> +The ``hns3`` driver implements the following driver-specific
>> +parameters.
>> +
>> +.. list-table:: Driver-specific parameters implemented
>> +   :widths: 10 10 10 70
>> +
>> +   * - Name
>> +     - Type
>> +     - Mode
>> +     - Description
>> +   * - ``rx_buf_len``
>> +     - U32
>> +     - driverinit
>> +     - Set rx BD buffer size, now only support setting 2048 and 4096.
>> +
>> +       * The feature is used to change the buffer size of each BD of Rx ring
>> +         between 2KB and 4KB, then do devlink reload operation to take effect.
> 
> Does the reload required here differ from the reload performed when the
> ring size is changed? You can extend the ethtool API, devlink params
> should be used for very vendor specific configuration. Which page
> fragment size very much is not.
>Ok, we will try to extend the ethtool API to implement this feature.
Thanks.

>> +   * - ``tx_buf_size``
>> +     - U32
>> +     - driverinit
>> +     - Set tx bounce buf size.
>> +
>> +       * The size is setted for tx bounce feature. Tx bounce buffer feature is
>> +         used for small size packet or frag. It adds a queue based tx shared
>> +         bounce buffer to memcpy the small packet when the len of xmitted skb is
>> +         below tx_copybreak(value to distinguish small size and normal size),
>> +         and reduce the overhead of dma map and unmap when IOMMU is on.
> 
> IMHO setting the tx_copybreak should be configured thru the same API as
> the size of the buffer it uses. Hence, again, ethtool.
> .
> 
Ok.
