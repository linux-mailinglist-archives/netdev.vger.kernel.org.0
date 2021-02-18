Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C839B31E440
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 03:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhBRCPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 21:15:39 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12550 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhBRCPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 21:15:37 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Dgysl2lZHzMY49;
        Thu, 18 Feb 2021 10:12:59 +0800 (CST)
Received: from [10.67.100.138] (10.67.100.138) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Thu, 18 Feb 2021 10:14:43 +0800
Subject: Re: [PATCH][next] net: hns3: Fix uninitialized return from function
To:     Colin King <colin.king@canonical.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>, <netdev@vger.kernel.org>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210210152644.137770-1-colin.king@canonical.com>
From:   "lipeng (Y)" <lipeng321@huawei.com>
Message-ID: <9e7cba23-14af-9359-a00e-7b08d7f5c748@huawei.com>
Date:   Thu, 18 Feb 2021 10:14:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20210210152644.137770-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.100.138]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/2/10 23:26, Colin King 写道:
> From: Colin Ian King <colin.king@canonical.com>
>
> Currently function hns3_reset_notify_uninit_enet is returning
> the contents of the uninitialized variable ret.  Fix this by
> removing ret (since it is no longer used) and replace it with
> a return of the literal value 0.


you can not remove "ret"  this way.

try to change  "int hns3_uninit_all_ring"  to "void 
hns3_uninit_all_ring" and fix related code is better.


>
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: 64749c9c38a9 ("net: hns3: remove redundant return value of hns3_uninit_all_ring()")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> index 9565b7999426..bf4302a5cf95 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> @@ -4640,7 +4640,6 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
>   {
>   	struct net_device *netdev = handle->kinfo.netdev;
>   	struct hns3_nic_priv *priv = netdev_priv(netdev);
> -	int ret;
>   
>   	if (!test_and_clear_bit(HNS3_NIC_STATE_INITED, &priv->state)) {
>   		netdev_warn(netdev, "already uninitialized\n");
> @@ -4662,7 +4661,7 @@ static int hns3_reset_notify_uninit_enet(struct hnae3_handle *handle)
>   
>   	hns3_put_ring_config(priv);
>   
> -	return ret;
> +	return 0;
>   }
>   
>   static int hns3_reset_notify(struct hnae3_handle *handle,
