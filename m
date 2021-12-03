Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C656B4677AD
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 13:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380962AbhLCMzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 07:55:20 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:43900 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380953AbhLCMzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 07:55:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638535915; x=1670071915;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CP8QkF8Nt5uAisuFHRBm1cB5KgqvWY88VFRVhqdtK68=;
  b=KZPICrj4lEKXapsJuwt8jKzqld9SeGsDioTlaqyfyULTlOKAEWjhJ/5g
   PThnvewjtBvaJfNcJGl1WLzxsiNupsF4DhtR7DQ0X377FzbxZrTHAxphQ
   +A7iHfITlPMYVOXjXUHQQD0EYLBr6MW7n18nMM1vNZIKd+N6a8uXH1DKs
   kJengTbOQLlQrpOx6j19KicHz91JJ2WITKa6UWPy/9Fhg2RGgGSPcV6Sw
   tS21UlxaKpn1lP68HN4m/V588FoLD3i3Nk4I6jp+CebAmgHIAKQ27Uv2N
   iknGCuridQiS6E6Q2C8K1mGlXY89rSwUSILrLLi1TEC4zsHs31aWbuUKh
   g==;
IronPort-SDR: +yDfN3WX2A1aW2PAXQt8uTxj95YlHsI4szy1Vx9wT68DJiBrqkJoFpUFyPiU2NrDdPiITDnz7c
 Yo00hZry5UWIpVDkYZ4ViMEkJIcc191MSHqJ4fhjEJa9+bLLgzZS5xAaqRR3RBvxgUos2UteqR
 JQCvRb9LVrqECURwUfpongJRvL9ERrxCXlGgKv54ctgAuDmD07gk7fkFb7hPSkUA2kHHrbb014
 A0rhXW6qrccIKsQqjiJ/fhO41fnb/3IrbLiGKWQBjiDtRGsrucbbECvpttS0adHTTiF2S/ctCY
 TG73d/LC7rG+94PDuvkyaRrk
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="138573328"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Dec 2021 05:51:55 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 3 Dec 2021 05:51:55 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Fri, 3 Dec 2021 05:51:54 -0700
Date:   Fri, 3 Dec 2021 13:53:50 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net-next] net: lan966x: fix a IS_ERR() vs NULL check in
 lan966x_create_targets()
Message-ID: <20211203125350.nvghzibkbl6gdewp@soft-dev3-1.localhost>
References: <20211203095531.GB2480@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211203095531.GB2480@kili>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/03/2021 12:55, Dan Carpenter wrote:
> 
> The devm_ioremap() function does not return error pointers.  It returns
> NULL.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> Fixes: db8bcaad5393 ("net: lan966x: add the basic lan966x driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> index e9e4dca6542d..00930d81521a 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> @@ -83,10 +83,10 @@ static int lan966x_create_targets(struct platform_device *pdev,
>                 begin[idx] = devm_ioremap(&pdev->dev,
>                                           iores[idx]->start,
>                                           resource_size(iores[idx]));
> -               if (IS_ERR(begin[idx])) {
> +               if (!begin[idx]) {
>                         dev_err(&pdev->dev, "Unable to get registers: %s\n",
>                                 iores[idx]->name);
> -                       return PTR_ERR(begin[idx]);
> +                       return -ENOMEM;
>                 }
>         }
> 
> --
> 2.20.1
> 

-- 
/Horatiu
