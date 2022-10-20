Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0773E605EF4
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 13:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiJTLfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 07:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiJTLfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 07:35:18 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC848836C8;
        Thu, 20 Oct 2022 04:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1666265715; x=1697801715;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tbxr2V7JYwCA3mhaiBgOpd4JKYyc01i3DlNbArOXhME=;
  b=T2UI2wkWdP1H/ATuWaPTZKM6OEgLHnit2rWMnMnkclD+FDgG+RBF6ym4
   isC2RYMhJNscqI2CHHePPE0iJYqTpN57hLsQKlXcItrNDdX0BPP6+LtPE
   cVUNX91+bbQoVxY4+idQiSWBHNhaOtzeGvY0KzoIsIRydZHex5JpjY6Gu
   5DvV1pdScAuGLLGDSDML7N8Yv0Tn4PA/KNNAGNpeEmV5UkKl2mnH4nSME
   hiuGoQS2gm98PDqDR9nz2wCcOj21Ts3U7Z2LH6E6g6QveweMkJTl11ANc
   pDz2ufmIXuAz+zKDxhZKfX61ZqbwaeDYlk86lSvm0VGutPt3qAPe5t8Lt
   w==;
X-IronPort-AV: E=Sophos;i="5.95,198,1661810400"; 
   d="scan'208";a="26872140"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 20 Oct 2022 13:35:10 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Thu, 20 Oct 2022 13:35:10 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Thu, 20 Oct 2022 13:35:10 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1666265710; x=1697801710;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tbxr2V7JYwCA3mhaiBgOpd4JKYyc01i3DlNbArOXhME=;
  b=mxBQNx/8xNFuofsGzY8dvPEvKDmyC0HHJhybQtBWIRfE8FRhUtVkLy+J
   YBXBIjDgENTksqwh5qs+vM0uWBZ9SI1JNurX23ec1qGgRVRha4OH9t+GE
   izB7zXRHIIvIO2a6+HrvCgRsuEZKEOLyplyyIGb8OLNE0I60xi5QSzdN4
   giRB4TEIz10llmH5KDFxcVp1dV9Dg/RfDt9mqklp6Y0FGirKv8S70aRLM
   QT4zSiNMPXOSlGKxvpMdX4D6HO8ClhNpz44KfOLvL/tr8P9INOXvFu4mt
   MFy7L2rrWmHIleBLcCXywpFuf8vS8nOyqX2FVxl9tmTskAWaYi64xsxws
   g==;
X-IronPort-AV: E=Sophos;i="5.95,198,1661810400"; 
   d="scan'208";a="26872139"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 20 Oct 2022 13:35:10 +0200
Received: from steina-w.localnet (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 4EB6B280072;
        Thu, 20 Oct 2022 13:35:10 +0200 (CEST)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: Re: [PATCH net-next 1/2] net:xilinx_axi: set mdio frequency according to DT
Date:   Thu, 20 Oct 2022 13:35:06 +0200
Message-ID: <5953785.aeNJFYEL58@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <20221020094106.559266-2-andy.chiu@sifive.com>
References: <20221020094106.559266-1-andy.chiu@sifive.com> <20221020094106.559266-2-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am Donnerstag, 20. Oktober 2022, 11:41:05 CEST schrieb Andy Chiu:
> Some FPGA platforms has 80KHz MDIO bus frequency constraint when
> conecting Ethernet to its on-board external Marvell PHY. Thus, we may
> have to set MDIO clock according to the DT. Otherwise, use the default
> 2.5 MHz, as specified by 802.3, if the entry is not present.
> 
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> ---
>  .../net/ethernet/xilinx/xilinx_axienet_mdio.c | 25 ++++++++++++++++---
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c index
> 0b3b6935c558..d07c39d3bcf0 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
> @@ -18,6 +18,7 @@
>  #include "xilinx_axienet.h"
> 
>  #define MAX_MDIO_FREQ		2500000 /* 2.5 MHz */
> +#define MDIO_CLK_DIV_MASK	0x3f /* bits[5:0] */
>  #define DEFAULT_HOST_CLOCK	150000000 /* 150 MHz */
> 
>  /* Wait till MDIO interface is ready to accept a new transaction.*/
> @@ -155,7 +156,9 @@ static int axienet_mdio_write(struct mii_bus *bus, int
> phy_id, int reg, **/
>  int axienet_mdio_enable(struct axienet_local *lp)
>  {
> +	u32 clk_div;
>  	u32 host_clock;
> +	u32 mdio_freq;
> 
>  	lp->mii_clk_div = 0;
> 
> @@ -184,6 +187,13 @@ int axienet_mdio_enable(struct axienet_local *lp)
>  			    host_clock);
>  	}
> 
> +	if (of_property_read_u32(lp->dev->of_node, "xlnx,mdio-freq",
> +				 &mdio_freq)) {
> +		mdio_freq = MAX_MDIO_FREQ;
> +		netdev_info(lp->ndev, "Setting default mdio clock to 
%u\n",
> +			    mdio_freq);

I would opt to print this message only if using non-default frequency.

Best regards,
Alexander

> +	}
> +
>  	/* clk_div can be calculated by deriving it from the equation:
>  	 * fMDIO = fHOST / ((1 + clk_div) * 2)
>  	 *
> @@ -209,13 +219,20 @@ int axienet_mdio_enable(struct axienet_local *lp)
>  	 * "clock-frequency" from the CPU
>  	 */
> 
> -	lp->mii_clk_div = (host_clock / (MAX_MDIO_FREQ * 2)) - 1;
> +	clk_div = (host_clock / (mdio_freq * 2)) - 1;
>  	/* If there is any remainder from the division of
> -	 * fHOST / (MAX_MDIO_FREQ * 2), then we need to add
> +	 * fHOST / (mdio_freq * 2), then we need to add
>  	 * 1 to the clock divisor or we will surely be above 2.5 MHz
>  	 */
> -	if (host_clock % (MAX_MDIO_FREQ * 2))
> -		lp->mii_clk_div++;
> +	if (host_clock % (mdio_freq * 2))
> +		clk_div++;
> +
> +	/* Check for overflow of mii_clk_div */
> +	if (clk_div & ~MDIO_CLK_DIV_MASK) {
> +		netdev_dbg(lp->ndev, "MDIO clock divisor overflow, 
setting to maximum
> value\n"); +		clk_div = MDIO_CLK_DIV_MASK;
> +	}
> +	lp->mii_clk_div = (u8)clk_div;
> 
>  	netdev_dbg(lp->ndev,
>  		   "Setting MDIO clock divisor to %u/%u Hz host clock.
\n",




