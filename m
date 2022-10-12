Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16805FCD48
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 23:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiJLVai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 17:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiJLV36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 17:29:58 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F58E21E15;
        Wed, 12 Oct 2022 14:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=rG4R+wqzRRZPy/iFUqxWu1RUJMeR5k+eB1P0dMbq/Qk=; b=v8VCLffVX+c4mNBh1I6bTUb7Mx
        1fMdXAVVMdJhgtvLe/qfMY6KuKjn9OizoGn1f1wpe8UBQl23v+Fx/Wq3M9QD9uhiOajryN7AzyV6n
        XbG9GWswWCZA5/aLGs9WgP0eToBuDOx3Oc+lVxGKyDxqqz5a3EEHXtEjD5/E36NKvHZk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oijI8-001psu-Va; Wed, 12 Oct 2022 23:29:28 +0200
Date:   Wed, 12 Oct 2022 23:29:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Clark Wang <xiaoning.wang@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, festevam@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, kernel@pengutronix.de,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH 1/3] net: stmmac: add imx93 platform support
Message-ID: <Y0cxuKz7rTpxHjMz@lunn.ch>
References: <20221012105129.3706062-1-xiaoning.wang@nxp.com>
 <20221012105129.3706062-2-xiaoning.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221012105129.3706062-2-xiaoning.wang@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int imx93_set_intf_mode(struct plat_stmmacenet_data *plat_dat)
> +{
> +	struct imx_priv_data *dwmac = plat_dat->bsp_priv;
> +	int val;
> +
> +	switch (plat_dat->interface) {
> +	case PHY_INTERFACE_MODE_MII:
> +		val = MX93_GPR_ENET_QOS_INTF_SEL_MII;
> +		break;
> +	case PHY_INTERFACE_MODE_RMII:
> +		val = MX93_GPR_ENET_QOS_INTF_SEL_RMII;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +		val = MX93_GPR_ENET_QOS_INTF_SEL_RGMII;
> +		break;
> +	default:
> +		pr_debug("imx dwmac doesn't support %d interface\n",
> +			 plat_dat->interface);

netdev_debug(), or dev_debug(), so there is some clue which of the 42
dwmac instances has a bad value in DT.

