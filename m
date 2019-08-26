Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642919CA50
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 09:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730016AbfHZH1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 03:27:20 -0400
Received: from mx2.mailbox.org ([80.241.60.215]:9956 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729955AbfHZH1U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 03:27:20 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id 56E3EA123B;
        Mon, 26 Aug 2019 09:27:17 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id R5uA447_3WZi; Mon, 26 Aug 2019 09:27:11 +0200 (CEST)
Subject: Re: [PATCH v2 -next] net: mediatek: remove set but not used variable
 'status'
To:     =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Mao Wenan <maowenan@huawei.com>
Cc:     nbd@openwrt.org, john@phrozen.org, sean.wang@mediatek.com,
        nelson.chang@mediatek.com, davem@davemloft.net,
        matthias.bgg@gmail.com, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20190824.142158.1506174328495468705.davem@davemloft.net>
 <20190826013118.22720-1-maowenan@huawei.com>
 <20190826071048.Horde.gwS9nzceYYiYGJLnJ6-x2hz@www.vdorst.com>
From:   Stefan Roese <sr@denx.de>
Message-ID: <ce9fd217-f838-1e04-eacd-7fe9f07dc745@denx.de>
Date:   Mon, 26 Aug 2019 09:27:08 +0200
MIME-Version: 1.0
In-Reply-To: <20190826071048.Horde.gwS9nzceYYiYGJLnJ6-x2hz@www.vdorst.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On 26.08.19 09:10, René van Dorst wrote:
> Let's add Stefan to the conversation.
> He is the author of this commit.

Thanks Rene.
  
> Quoting Mao Wenan <maowenan@huawei.com>:
> 
>> Fixes gcc '-Wunused-but-set-variable' warning:
>> drivers/net/ethernet/mediatek/mtk_eth_soc.c: In function mtk_handle_irq:
>> drivers/net/ethernet/mediatek/mtk_eth_soc.c:1951:6: warning:
>> variable status set but not used [-Wunused-but-set-variable]
>>
>> Fixes: 296c9120752b ("net: ethernet: mediatek: Add MT7628/88 SoC support")
>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
>> ---
>>   v2: change format of 'Fixes' tag.
>>   drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
>> b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
>> index 8ddbb8d..bb7d623 100644
>> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
>> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
>> @@ -1948,9 +1948,7 @@ static irqreturn_t mtk_handle_irq_tx(int irq,
>> void *_eth)
>>   static irqreturn_t mtk_handle_irq(int irq, void *_eth)
>>   {
>>   	struct mtk_eth *eth = _eth;
>> -	u32 status;
>>
>> -	status = mtk_r32(eth, MTK_PDMA_INT_STATUS);
> 
> Hi Stefan,
> 
> You added an extra MTK_PDMA_INT_STATUS read in mtk_handle_irq()
> Is that read necessary to work properly?

No, its not needed. This read must have "slipped in" from some earlier
patch versions and I forgot to remove it later. Thanks for catching it.

Reviewed-by: Stefan Roese <sr@denx.de>

Thanks,
Stefan
