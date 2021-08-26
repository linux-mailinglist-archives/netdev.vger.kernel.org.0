Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A72D3F82CA
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 08:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239760AbhHZG4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 02:56:23 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:14323 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbhHZG4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 02:56:22 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GwDBF5m5Vz87rV;
        Thu, 26 Aug 2021 14:55:17 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 26 Aug 2021 14:55:33 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 26
 Aug 2021 14:55:33 +0800
Subject: Re: [PATCH net-next 1/5] ethtool: add support to set/get tx spare buf
 size
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <mkubecek@suse.cz>, <andrew@lunn.ch>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <danieller@nvidia.com>,
        <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
References: <1629873655-51539-1-git-send-email-huangguangbin2@huawei.com>
 <1629873655-51539-2-git-send-email-huangguangbin2@huawei.com>
 <20210825075656.4db0890a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <d0f36012-5cd7-e629-eebc-2b262f843702@huawei.com>
Date:   Thu, 26 Aug 2021 14:55:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210825075656.4db0890a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/8/25 22:56, Jakub Kicinski wrote:
> On Wed, 25 Aug 2021 14:40:51 +0800 Guangbin Huang wrote:
>> From: Hao Chen <chenhao288@hisilicon.com>
>>
>> Add support for ethtool to set/get tx spare buf size.
>>
>> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>> ---
>>   include/uapi/linux/ethtool.h | 1 +
>>   net/ethtool/ioctl.c          | 1 +
>>   2 files changed, 2 insertions(+)
>>
>> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
>> index b6db6590baf0..266e95e4fb33 100644
>> --- a/include/uapi/linux/ethtool.h
>> +++ b/include/uapi/linux/ethtool.h
>> @@ -231,6 +231,7 @@ enum tunable_id {
>>   	ETHTOOL_RX_COPYBREAK,
>>   	ETHTOOL_TX_COPYBREAK,
>>   	ETHTOOL_PFC_PREVENTION_TOUT, /* timeout in msecs */
>> +	ETHTOOL_TX_COPYBREAK_BUF_SIZE,
> 
> We need good documentation for the new tunable.
Ok.

> 
>>   	/*
>>   	 * Add your fresh new tunable attribute above and remember to update
>>   	 * tunable_strings[] in net/ethtool/common.c
>> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
>> index f2abc3152888..9fc801298fde 100644
>> --- a/net/ethtool/ioctl.c
>> +++ b/net/ethtool/ioctl.c
>> @@ -2377,6 +2377,7 @@ static int ethtool_tunable_valid(const struct ethtool_tunable *tuna)
>>   	switch (tuna->id) {
>>   	case ETHTOOL_RX_COPYBREAK:
>>   	case ETHTOOL_TX_COPYBREAK:
>> +	case ETHTOOL_TX_COPYBREAK_BUF_SIZE:
>>   		if (tuna->len != sizeof(u32) ||
>>   		    tuna->type_id != ETHTOOL_TUNABLE_U32)
>>   			return -EINVAL;
> 
> .
> 
