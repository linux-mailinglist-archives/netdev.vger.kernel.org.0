Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 690B9E6A76
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 02:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbfJ1BZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 21:25:09 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4772 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729241AbfJ1BZJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 21:25:09 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C616894E157386EA662A;
        Mon, 28 Oct 2019 09:25:05 +0800 (CST)
Received: from [127.0.0.1] (10.67.103.228) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Mon, 28 Oct 2019
 09:24:55 +0800
Subject: Re: [PATCH] net: hisilicon: Fix ping latency when deal with high
 throughput
To:     Joe Perches <joe@perches.com>, <davem@davemloft.net>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>
References: <1572079779-76449-1-git-send-email-xiaojiangfeng@huawei.com>
 <cfde329c7ee3c9bb5610bd9b040f95214cc4d9e8.camel@perches.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <leeyou.li@huawei.com>, <zhanghan23@huawei.com>,
        <nixiaoming@huawei.com>, <zhangqiang.cn@hisilicon.com>,
        <dingjingcheng@hisilicon.com>
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Message-ID: <260be568-cbda-5e27-ac06-d6ee6194a0c2@huawei.com>
Date:   Mon, 28 Oct 2019 09:24:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <cfde329c7ee3c9bb5610bd9b040f95214cc4d9e8.camel@perches.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.228]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/10/26 23:44, Joe Perches wrote:
> On Sat, 2019-10-26 at 16:49 +0800, Jiangfeng Xiao wrote:
>> This is due to error in over budget processing.
>> When dealing with high throughput, the used buffers
>> that exceeds the budget is not cleaned up. In addition,
>> it takes a lot of cycles to clean up the used buffer,
>> and then the buffer where the valid data is located can take effect.
> []
>> diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
> []
>> @@ -575,7 +575,7 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
>>  	struct hip04_priv *priv = container_of(napi, struct hip04_priv, napi);
>>  	struct net_device *ndev = priv->ndev;
>>  	struct net_device_stats *stats = &ndev->stats;
>> -	unsigned int cnt = hip04_recv_cnt(priv);
>> +	static unsigned int cnt_remaining;
> 
> static doesn't seem a great idea here as it's for just a single
> driver instance.  Maybe make this part of struct hip04_priv?
> 
Thank you for your review. Your suggestion is very good.

