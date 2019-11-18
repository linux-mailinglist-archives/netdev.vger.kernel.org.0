Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D27BAFFD47
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 04:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfKRDQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 22:16:44 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6691 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726201AbfKRDQn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Nov 2019 22:16:43 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E712EBB0D7EC82ADD967;
        Mon, 18 Nov 2019 11:16:40 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.12) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Mon, 18 Nov 2019
 11:16:32 +0800
Subject: Re: [PATCH] vrf: Fix possible NULL pointer oops when delete nic
To:     David Ahern <dsahern@gmail.com>, <dsahern@kernel.org>,
        <shrijeet@gmail.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hujunwei4@huawei.com>, <xuhanbing@huawei.com>
References: <60e827cb-2bba-2b7e-55dc-651103e9905f@huawei.com>
 <7fe948a8-debd-e336-9584-e66153e90701@gmail.com>
From:   "wangxiaogang (F)" <wangxiaogang3@huawei.com>
Message-ID: <bead86fd-ae33-219f-0601-d80b57695d3c@huawei.com>
Date:   Mon, 18 Nov 2019 11:16:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <7fe948a8-debd-e336-9584-e66153e90701@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.12]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/11/16 0:59, David Ahern wrote:
> On 11/14/19 11:22 PM, wangxiaogang (F) wrote:
>> diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
>> index b8228f5..86c4b8c 100644
>> --- a/drivers/net/vrf.c
>> +++ b/drivers/net/vrf.c
>> @@ -1427,6 +1427,9 @@ static int vrf_device_event(struct notifier_block *unused,
>>  			goto out;
>>
>>  		vrf_dev = netdev_master_upper_dev_get(dev);
>> +		if (!vrf_dev)
>> +			goto out;
>> +
>>  		vrf_del_slave(vrf_dev, dev);
>>  	}
>>  out:
> 
> BTW, I believe this is the wrong fix. A device can not be a VRF slave
> AND not have an upper device. Something is fundamentally wrong.
> 
> 

this problem occurs when our testers deleted the NIC and vrf in parallel.
I will try to recurring this problem later.

