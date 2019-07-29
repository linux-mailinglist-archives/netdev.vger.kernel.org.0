Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9337830B
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 03:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfG2BVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 21:21:53 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55140 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726216AbfG2BVx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jul 2019 21:21:53 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5901D44ADD6DF24B9F6B;
        Mon, 29 Jul 2019 09:21:50 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Mon, 29 Jul 2019
 09:21:41 +0800
Subject: Re: [PATCH V3 net-next 06/10] net: hns3: add debug messages to
 identify eth down cause
To:     David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <saeedm@mellanox.com>,
        <liuyonglong@huawei.com>, <lipeng321@huawei.com>
References: <1564206372-42467-1-git-send-email-tanhuazhong@huawei.com>
 <1564206372-42467-7-git-send-email-tanhuazhong@huawei.com>
 <20190727.190333.249806415176311786.davem@davemloft.net>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <df2dbffd-8493-025d-f861-9c5024559933@huawei.com>
Date:   Mon, 29 Jul 2019 09:21:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20190727.190333.249806415176311786.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/28 10:03, David Miller wrote:
> From: Huazhong Tan <tanhuazhong@huawei.com>
> Date: Sat, 27 Jul 2019 13:46:08 +0800
> 
>> From: Yonglong Liu <liuyonglong@huawei.com>
>>
>> Some times just see the eth interface have been down/up via
>> dmesg, but can not know why the eth down. So adds some debug
>> messages to identify the cause for this.
>>
>> Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
>> Signed-off-by: Peng Li <lipeng321@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
>> ---
>>   drivers/net/ethernet/hisilicon/hns3/hns3_enet.c       | 18 ++++++++++++++++++
>>   drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c    | 19 +++++++++++++++++++
>>   .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c    | 11 +++++++++++
>>   3 files changed, 48 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> index 4d58c53..973c57b 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> @@ -459,6 +459,9 @@ static int hns3_nic_net_open(struct net_device *netdev)
>>   		h->ae_algo->ops->set_timer_task(priv->ae_handle, true);
>>   
>>   	hns3_config_xps(priv);
>> +
>> +	netif_info(h, drv, netdev, "net open\n");
> 
> These will pollute everyone's kernel logs for normal operations.
> 
> This is not reasonable at all, sorry.
> 
> Furthermore, even if it was appropriate, "netif_info()" is not "debug".
> 

Will replace it with netif_dbg.
thanks.

> 
> .
> 

