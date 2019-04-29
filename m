Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B7BE7C7
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 18:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbfD2Qap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 12:30:45 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:16648
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728518AbfD2Qap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 12:30:45 -0400
X-IronPort-AV: E=Sophos;i="5.60,410,1549926000"; 
   d="scan'208";a="304358659"
Received: from 50-250-39-241-static.hfc.comcastbusiness.net (HELO hadrien) ([50.250.39.241])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 18:30:23 +0200
Date:   Mon, 29 Apr 2019 12:30:21 -0400 (EDT)
From:   Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To:     YueHaibing <yuehaibing@huawei.com>
cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: ethernet: ti: cpsw: Fix inconsistent
 IS_ERR and PTR_ERR in cpsw_probe()
In-Reply-To: <20190429143157.79035-1-yuehaibing@huawei.com>
Message-ID: <alpine.DEB.2.21.1904291228000.2444@hadrien>
References: <20190429135650.72794-1-yuehaibing@huawei.com> <20190429143157.79035-1-yuehaibing@huawei.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Mon, 29 Apr 2019, YueHaibing wrote:

> Change the call to PTR_ERR to access the value just tested by IS_ERR.

I assume you didn't find the problem just looking through the code by
hand.  If you used a tool, it would be really good to acknowledge the tool
that was used.  The tools don't come for free, and you don't pay for them.
The only payment that you can offer is to acknowledge that the tool was
used, which helps justify that the tool is useful and what it is useful
for.

julia

>
> Fixes: 83a8471ba255 ("net: ethernet: ti: cpsw: refactor probe to group common hw initialization")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
> v2: add Fixes tag
> ---
>  drivers/net/ethernet/ti/cpsw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> index c3cba46fac9d..e37680654a13 100644
> --- a/drivers/net/ethernet/ti/cpsw.c
> +++ b/drivers/net/ethernet/ti/cpsw.c
> @@ -2381,7 +2381,7 @@ static int cpsw_probe(struct platform_device *pdev)
>
>  	clk = devm_clk_get(dev, "fck");
>  	if (IS_ERR(clk)) {
> -		ret = PTR_ERR(mode);
> +		ret = PTR_ERR(clk);
>  		dev_err(dev, "fck is not found %d\n", ret);
>  		return ret;
>  	}
>
>
>
>
