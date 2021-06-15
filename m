Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4383A7F1D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhFONYy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Jun 2021 09:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhFONYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:24:53 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959DEC061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 06:22:49 -0700 (PDT)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1lt91e-0008I0-IR; Tue, 15 Jun 2021 15:22:42 +0200
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1lt91b-00014w-Rg; Tue, 15 Jun 2021 15:22:39 +0200
Message-ID: <2800a872ff4260fc7a942f2f2ea1c9e3603b13d7.camel@pengutronix.de>
Subject: Re: [PATCH net-next v4 02/10] net: sparx5: add the basic sparx5
 driver
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steen Hegelund <steen.hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Simon Horman <simon.horman@netronome.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Tue, 15 Jun 2021 15:22:39 +0200
In-Reply-To: <20210615085034.1262457-3-steen.hegelund@microchip.com>
References: <20210615085034.1262457-1-steen.hegelund@microchip.com>
         <20210615085034.1262457-3-steen.hegelund@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steen,

On Tue, 2021-06-15 at 10:50 +0200, Steen Hegelund wrote:
> This adds the Sparx5 basic SwitchDev driver framework with IO range
> mapping, switch device detection and core clock configuration.
> 
> Support for ports, phylink, netdev, mactable etc. are in the following
> patches.
> 
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
[...]
> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
> new file mode 100644
> index 000000000000..892bbbaacbd6
> --- /dev/null
> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
> @@ -0,0 +1,743 @@
[...]
> +static int mchp_sparx5_probe(struct platform_device *pdev)
> +{
[...]
> +	/* Do switch core reset if available */
> +	reset = devm_reset_control_get_optional_shared(&pdev->dev, "switch");

Please don't ignore errors here. For example:

	if (IS_ERR(reset))
		return dev_err_probe(&pdev->dev, PTR_ERR(reset),
				     "Failed to get reset.\n");

> 	reset_control_reset(reset);

regards
Philipp
