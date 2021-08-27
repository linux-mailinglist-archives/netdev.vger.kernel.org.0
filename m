Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3AB3FA078
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 22:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhH0USH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 16:18:07 -0400
Received: from mxout01.lancloud.ru ([45.84.86.81]:58790 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhH0USH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 16:18:07 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru D7CD320D394B
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next 13/13] ravb: Add reset support
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-14-biju.das.jz@bp.renesas.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <3114f468-f454-4289-bc1f-befdadac9994@omp.ru>
Date:   Fri, 27 Aug 2021 23:17:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210825070154.14336-14-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/21 10:01 AM, Biju Das wrote:

> Reset support is present on R-Car. Let's support it, if it is
> available.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 7a144b45e41d..0f85f2d97b18 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]

> @@ -2349,6 +2358,7 @@ static int ravb_probe(struct platform_device *pdev)
>  
>  	pm_runtime_put(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
> +	reset_control_assert(rstc);
>  	return error;
>  }
>  
> @@ -2374,6 +2384,7 @@ static int ravb_remove(struct platform_device *pdev)
>  	netif_napi_del(&priv->napi[RAVB_BE]);
>  	ravb_mdio_release(priv);
>  	pm_runtime_disable(&pdev->dev);
> +	reset_control_assert(priv->rstc);
>  	free_netdev(ndev);
>  	platform_set_drvdata(pdev, NULL);
>  

   Is it possible to get into/out of reset in open()/close() methods?
   Otherwise, looks good (I'm not much into reset h/w)

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

MBR, Sergey
