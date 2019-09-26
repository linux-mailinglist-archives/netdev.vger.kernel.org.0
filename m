Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE63BEBF4
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 08:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390250AbfIZG2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 02:28:34 -0400
Received: from mx.socionext.com ([202.248.49.38]:23233 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388934AbfIZG2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 02:28:34 -0400
Received: from unknown (HELO kinkan-ex.css.socionext.com) ([172.31.9.52])
  by mx.socionext.com with ESMTP; 26 Sep 2019 15:28:33 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by kinkan-ex.css.socionext.com (Postfix) with ESMTP id 5C50B18020B;
        Thu, 26 Sep 2019 15:28:33 +0900 (JST)
Received: from 172.31.9.53 (172.31.9.53) by m-FILTER with ESMTP; Thu, 26 Sep 2019 15:28:33 +0900
Received: from yuzu.css.socionext.com (yuzu [172.31.8.45])
        by iyokan.css.socionext.com (Postfix) with ESMTP id E87914035C;
        Thu, 26 Sep 2019 15:28:32 +0900 (JST)
Received: from [127.0.0.1] (unknown [10.213.132.48])
        by yuzu.css.socionext.com (Postfix) with ESMTP id CF4841204B3;
        Thu, 26 Sep 2019 15:28:32 +0900 (JST)
Date:   Thu, 26 Sep 2019 15:28:32 +0900
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH net] net: socionext: Fix a signedness bug in ave_probe()
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
In-Reply-To: <20190925105750.GG3264@mwanda>
References: <20190925105750.GG3264@mwanda>
Message-Id: <20190926152831.DDD6.4A936039@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.70 [ja]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

Thank you for pointing out.
I've confirmed that this error handling works well with your patch.

Reviewed-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

Thank you,

On Wed, 25 Sep 2019 13:57:50 +0300 <dan.carpenter@oracle.com> wrote:

> The "phy_mode" variable is an enum and in this context GCC treats it as
> an unsigned int so the error handling is never triggered.
> 
> Fixes: 4c270b55a5af ("net: ethernet: socionext: add AVE ethernet driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/socionext/sni_ave.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
> index 10d0c3e478ab..d047a53f34f2 100644
> --- a/drivers/net/ethernet/socionext/sni_ave.c
> +++ b/drivers/net/ethernet/socionext/sni_ave.c
> @@ -1566,7 +1566,7 @@ static int ave_probe(struct platform_device *pdev)
>  
>  	np = dev->of_node;
>  	phy_mode = of_get_phy_mode(np);
> -	if (phy_mode < 0) {
> +	if ((int)phy_mode < 0) {
>  		dev_err(dev, "phy-mode not found\n");
>  		return -EINVAL;
>  	}
> -- 
> 2.20.1

---
Best Regards,
Kunihiko Hayashi


