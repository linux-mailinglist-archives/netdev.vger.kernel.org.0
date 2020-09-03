Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B1025C207
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 15:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgICN4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 09:56:33 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10808 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728897AbgICMjQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 08:39:16 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 56A098AEC195BED7EB6D;
        Thu,  3 Sep 2020 20:38:53 +0800 (CST)
Received: from [10.57.101.250] (10.57.101.250) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Thu, 3 Sep 2020 20:38:45 +0800
Subject: Re: [PATCH] net/mlx5e: kTLS, Fix GFP_KERNEL in spinlock context
To:     <netdev@vger.kernel.org>
References: <1599133539-175203-1-git-send-email-xuwei5@hisilicon.com>
CC:     <davem@davemloft.net>, <saeedm@mellanox.com>, <leon@kernel.org>,
        <linuxarm@huawei.com>, <shameerali.kolothum.thodi@huawei.com>,
        <jonathan.cameron@huawei.com>, <john.garry@huawei.com>,
        <salil.mehta@huawei.com>, <shiju.jose@huawei.com>,
        <jinying@hisilicon.com>, <zhangyi.ac@huawei.com>,
        <liguozhu@hisilicon.com>, <tangkunshan@huawei.com>,
        <huangdaode@hisilicon.com>, Boris Pismenny <borisp@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Wei Xu <xuwei5@hisilicon.com>
Message-ID: <5F50E3D5.8090302@hisilicon.com>
Date:   Thu, 3 Sep 2020 20:38:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.2.0
MIME-Version: 1.0
In-Reply-To: <1599133539-175203-1-git-send-email-xuwei5@hisilicon.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.101.250]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

Sorry for the noise and please ignore it!
I found a nearly same patch has been sent out 2 days before.

Best Regards,
Wei

On 2020/9/3 19:45, Wei Xu wrote:
> Replace GFP_KERNEL with GFP_ATOMIC while resync_post_get_progress_params
> is invoked in a spinlock context.
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
> index acf6d80..1a32435 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
> @@ -247,7 +247,7 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
>  	int err;
>  	u16 pi;
>  
> -	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
> +	buf = kzalloc(sizeof(*buf), GFP_ATOMIC);
>  	if (unlikely(!buf)) {
>  		err = -ENOMEM;
>  		goto err_out;
> 
