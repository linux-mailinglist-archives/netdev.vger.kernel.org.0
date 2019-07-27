Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80A02775F7
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 04:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfG0C2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 22:28:15 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:41650 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726757AbfG0C2O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 22:28:14 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id E80CA11412AE0515F340;
        Sat, 27 Jul 2019 10:28:12 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 27 Jul 2019 10:28:12 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Sat, 27
 Jul 2019 10:28:12 +0800
Subject: Re: [PATCH V2 net-next 07/11] net: hns3: adds debug messages to
 identify eth down cause
To:     Joe Perches <joe@perches.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1564111502-15504-1-git-send-email-tanhuazhong@huawei.com>
 <1564111502-15504-8-git-send-email-tanhuazhong@huawei.com>
 <a32ca755bfd69046cf89aeacbf67fd16313de768.camel@mellanox.com>
 <05602c954c689ffcd796e9468c52bca6fa4efe3f.camel@perches.com>
From:   liuyonglong <liuyonglong@huawei.com>
Message-ID: <f517dc69-6356-98fe-fb7a-0427728814bb@huawei.com>
Date:   Sat, 27 Jul 2019 10:28:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <05602c954c689ffcd796e9468c52bca6fa4efe3f.camel@perches.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme713-chm.china.huawei.com (10.1.199.109) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/27 6:18, Joe Perches wrote:
> On Fri, 2019-07-26 at 22:00 +0000, Saeed Mahameed wrote:
>> On Fri, 2019-07-26 at 11:24 +0800, Huazhong Tan wrote:
>>> From: Yonglong Liu <liuyonglong@huawei.com>
>>>
>>> Some times just see the eth interface have been down/up via
>>> dmesg, but can not know why the eth down. So adds some debug
>>> messages to identify the cause for this.
> []
>>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> []
>>> @@ -459,6 +459,10 @@ static int hns3_nic_net_open(struct net_device
>>> *netdev)
>>>  		h->ae_algo->ops->set_timer_task(priv->ae_handle, true);
>>>  
>>>  	hns3_config_xps(priv);
>>> +
>>> +	if (netif_msg_drv(h))
>>> +		netdev_info(netdev, "net open\n");
>>> +
>>
>> to make sure this is only intended for debug, and to avoid repetition.
>> #define hns3_dbg(__dev, format, args...)			\
>> ({								\
>> 	if (netif_msg_drv(h))					\
>> 		netdev_info(h->netdev, format, ##args);         \
>> })
> 
> 	netif_dbg(h, drv, h->netdev, "net open\n")
> 

Hi, Saeed && Joe:
For our cases, maybe netif_info() can be use for HNS3 drivers?
netif_dbg need to open dynamic debug options additional.

