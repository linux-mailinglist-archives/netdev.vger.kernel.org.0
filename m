Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 648711438DC
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 09:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgAUIyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 03:54:24 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10120 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725789AbgAUIyY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 03:54:24 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B3EED2456AB469B047EA;
        Tue, 21 Jan 2020 16:54:21 +0800 (CST)
Received: from [127.0.0.1] (10.177.131.64) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Tue, 21 Jan 2020
 16:54:16 +0800
Subject: Re: [PATCH -next] drivers: net: declance: fix comparing pointer to 0
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <davem@davemloft.net>, <mhabets@solarflare.com>, <kuba@kernel.org>
References: <20200121013553.15252-1-chenzhou10@huawei.com>
 <40eb3815-f677-c2fd-3e67-4b39bb332f48@cogentembedded.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Chen Zhou <chenzhou10@huawei.com>
Message-ID: <86f4d4a0-627d-84aa-c785-4dac426b7cc6@huawei.com>
Date:   Tue, 21 Jan 2020 16:54:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <40eb3815-f677-c2fd-3e67-4b39bb332f48@cogentembedded.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.131.64]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergei,

On 2020/1/21 16:39, Sergei Shtylyov wrote:
> Hello!
> 
> On 21.01.2020 4:35, Chen Zhou wrote:
> 
>> Fixes coccicheck warning:
>>
>> ./drivers/net/ethernet/amd/declance.c:611:14-15:
>>     WARNING comparing pointer to 0
>>
>> Compare pointer-typed values to NULL rather than 0.
> 
>    I don't see NULL in the patch -- you used ! instead.

Yeah, i used ! here.

Thanks,
Chen Zhou

> 
>> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
>> ---
>>   drivers/net/ethernet/amd/declance.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/amd/declance.c b/drivers/net/ethernet/amd/declance.c
>> index 6592a2d..7282ce5 100644
>> --- a/drivers/net/ethernet/amd/declance.c
>> +++ b/drivers/net/ethernet/amd/declance.c
>> @@ -608,7 +608,7 @@ static int lance_rx(struct net_device *dev)
>>               len = (*rds_ptr(rd, mblength, lp->type) & 0xfff) - 4;
>>               skb = netdev_alloc_skb(dev, len + 2);
>>   -            if (skb == 0) {
>> +            if (!skb) {
>>                   dev->stats.rx_dropped++;
>>                   *rds_ptr(rd, mblength, lp->type) = 0;
>>                   *rds_ptr(rd, rmd1, lp->type) =
> 
> MBR, Sergei
> 
> 

