Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E93E6A7A
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 02:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbfJ1B1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 21:27:25 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34400 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727787AbfJ1B1Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 21:27:25 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 15F36FE7E36149B42143;
        Mon, 28 Oct 2019 09:27:23 +0800 (CST)
Received: from [127.0.0.1] (10.67.103.228) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Mon, 28 Oct 2019
 09:27:13 +0800
Subject: Re: [PATCH] net: hisilicon: Fix ping latency when deal with high
 throughput
To:     David Miller <davem@davemloft.net>
References: <1572079779-76449-1-git-send-email-xiaojiangfeng@huawei.com>
 <20191026.112235.711416398803098524.davem@davemloft.net>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <leeyou.li@huawei.com>, <zhanghan23@huawei.com>,
        <nixiaoming@huawei.com>, <zhangqiang.cn@hisilicon.com>,
        <dingjingcheng@hisilicon.com>
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Message-ID: <ac37d6f4-1cde-5d00-095c-43362cb4a097@huawei.com>
Date:   Mon, 28 Oct 2019 09:27:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20191026.112235.711416398803098524.davem@davemloft.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.228]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/10/27 2:22, David Miller wrote:
> From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
> Date: Sat, 26 Oct 2019 16:49:39 +0800
> 
>> diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
>> index ad6d912..78f338a 100644
>> --- a/drivers/net/ethernet/hisilicon/hip04_eth.c
>> +++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
>> @@ -575,7 +575,7 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
>>  	struct hip04_priv *priv = container_of(napi, struct hip04_priv, napi);
>>  	struct net_device *ndev = priv->ndev;
>>  	struct net_device_stats *stats = &ndev->stats;
>> -	unsigned int cnt = hip04_recv_cnt(priv);
>> +	static unsigned int cnt_remaining;
> 
> There is no way a piece of software state should be system wide, this is
> a per device instance value.
> 
> .
> 
Thank you for your guidance, I will fix it in v2.

