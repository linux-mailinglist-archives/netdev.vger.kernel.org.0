Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05EC204A0A
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 08:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730936AbgFWGkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 02:40:31 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2528 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730669AbgFWGkb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 02:40:31 -0400
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 7295683C5B8EFC013719;
        Tue, 23 Jun 2020 14:40:29 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 23 Jun 2020 14:40:29 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 23 Jun 2020 14:40:28 +0800
Subject: Re: [PATCH net-next v1 2/5] hinic: add support to set and get irq
 coalesce
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
References: <20200620094258.13181-1-luobin9@huawei.com>
 <20200620094258.13181-3-luobin9@huawei.com>
 <20200622150756.3624dab2@kicinski-fedora-PC1C0HJN>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <ee54d69c-2c94-7c40-4a92-761a73445e14@huawei.com>
Date:   Tue, 23 Jun 2020 14:40:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200622150756.3624dab2@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme709-chm.china.huawei.com (10.1.199.105) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/6/23 6:07, Jakub Kicinski wrote:
> On Sat, 20 Jun 2020 17:42:55 +0800 Luo bin wrote:
>> @@ -1144,8 +1190,16 @@ static int nic_dev_init(struct pci_dev *pdev)
>>  		goto err_reg_netdev;
>>  	}
>>  
>> +	err = hinic_init_intr_coalesce(nic_dev);
>> +	if (err) {
>> +		netif_err(nic_dev, drv, netdev, "Failed to init_intr_coalesce\n");
>> +		goto err_init_intr;
>> +	}
>> +
>>  	return 0;
>>  
>> +err_init_intr:
>> +	unregister_netdev(netdev);
>>  err_reg_netdev:
>>  err_set_features:
>>  	hinic_hwdev_cb_unregister(nic_dev->hwdev,
> 
> A little suspicious - you should finish all init before device is
> registered, once registered the interface can be immediately brought
> up.
> .
> 
Will fix. Thanks for your review.
