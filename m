Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422032CBBCA
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 12:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgLBLpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 06:45:43 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:63050 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgLBLpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 06:45:42 -0500
Received: from localhost (junagarh.blr.asicdesigners.com [10.193.185.238])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0B2BiQQE017714;
        Wed, 2 Dec 2020 03:44:28 -0800
Date:   Wed, 2 Dec 2020 17:14:26 +0530
From:   Raju Rangoju <rajur@chelsio.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, divy@chelsio.com,
        jgarzik@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] cxgb3: fix error return code in t3_sge_alloc_qset()
Message-ID: <20201202114424.GA13909@chelsio.com>
References: <1606902965-1646-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606902965-1646-1-git-send-email-zhangchangzhong@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, December 12/02/20, 2020 at 17:56:05 +0800, Zhang Changzhong wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: b1fb1f280d09 ("cxgb3 - Fix dma mapping error path")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---

Acked-by: Raju Rangoju <rajur@chelsio.com>

>  drivers/net/ethernet/chelsio/cxgb3/sge.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
> index e18e9ce..1cc3c51 100644
> --- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
> +++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
> @@ -3175,6 +3175,7 @@ int t3_sge_alloc_qset(struct adapter *adapter, unsigned int id, int nports,
>  			  GFP_KERNEL | __GFP_COMP);
>  	if (!avail) {
>  		CH_ALERT(adapter, "free list queue 0 initialization failed\n");
> +		ret = -ENOMEM;
>  		goto err;
>  	}
>  	if (avail < q->fl[0].size)
> -- 
> 2.9.5
> 
