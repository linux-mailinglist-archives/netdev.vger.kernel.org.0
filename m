Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF91223E562
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 02:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgHGA5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 20:57:18 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3006 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726011AbgHGA5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 20:57:18 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 14D85D52B7E0A3E95817;
        Fri,  7 Aug 2020 08:57:16 +0800 (CST)
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 7 Aug 2020 08:57:15 +0800
Subject: Re: [PATCH net-next] hinic: fix strncpy output truncated compile
 warnings
To:     David Miller <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
References: <20200806074830.1375-1-luobin9@huawei.com>
 <20200806.120103.1200684111953914586.davem@davemloft.net>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <7f9e241e-3ad6-b250-11b1-a16d1dc2df68@huawei.com>
Date:   Fri, 7 Aug 2020 08:57:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200806.120103.1200684111953914586.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/8/7 3:01, David Miller wrote:
> From: Luo bin <luobin9@huawei.com>
> Date: Thu, 6 Aug 2020 15:48:30 +0800
> 
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>> index c6adc776f3c8..1dc948c07b94 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>> @@ -342,9 +342,9 @@ static int chip_fault_show(struct devlink_fmsg *fmsg,
>>  
>>  	level = event->event.chip.err_level;
>>  	if (level < FAULT_LEVEL_MAX)
>> -		strncpy(level_str, fault_level[level], strlen(fault_level[level]));
>> +		strncpy(level_str, fault_level[level], strlen(fault_level[level]) + 1);
>>  	else
>> -		strncpy(level_str, "Unknown", strlen("Unknown"));
>> +		strncpy(level_str, "Unknown", sizeof(level_str));
>>  
>>  	if (level == FAULT_LEVEL_SERIOUS_FLR) {
> 
> Please fix these cases consistently, either use the strlen()+1 pattern
> or the "sizeof(destination)" one.
> 
> Probably sizeof(destination) is best.
> .
> 
Will fix. Thanks. Level_str array is initialized to zero, so can't use the strlen()+1 pattern, I'll
use strlen()+1 consistently.
