Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D945277A0
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 10:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfEWIGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 04:06:50 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:59656 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbfEWIGu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 04:06:50 -0400
Received: from sapphire.tkos.co.il (unknown [192.168.100.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id BA3C1440360;
        Thu, 23 May 2019 11:06:47 +0300 (IDT)
Date:   Thu, 23 May 2019 11:06:46 +0300
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH net,stable 1/1] net: fec: fix the clk mismatch in
 failed_reset path
Message-ID: <20190523080646.6ty67zmck5xhfdcm@sapphire.tkos.co.il>
References: <1558576444-25080-1-git-send-email-fugang.duan@nxp.com>
 <1558576444-25080-2-git-send-email-fugang.duan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558576444-25080-2-git-send-email-fugang.duan@nxp.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Thu, May 23, 2019 at 01:55:28AM +0000, Andy Duan wrote:
> Fix the clk mismatch in the error path "failed_reset" because
> below error path will disable clk_ahb and clk_ipg directly, it
> should use pm_runtime_put_noidle() instead of pm_runtime_put()
> to avoid to call runtime resume callback.
> 
> Reported-by: Baruch Siach <baruch@tkos.co.il>
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>

Tested-by: Baruch Siach <baruch@tkos.co.il>

Tested on SolidRun Hummingboard Pulse.

Thanks.

But please avoid sending patched in base64 encoded emails. Plaintext is much 
easier when dealing with 'git am'.

baruch

> ---
>  drivers/net/ethernet/freescale/fec_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index f63eb2b..848defa 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -3555,7 +3555,7 @@ fec_probe(struct platform_device *pdev)
>  	if (fep->reg_phy)
>  		regulator_disable(fep->reg_phy);
>  failed_reset:
> -	pm_runtime_put(&pdev->dev);
> +	pm_runtime_put_noidle(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
>  failed_regulator:
>  	clk_disable_unprepare(fep->clk_ahb);

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
