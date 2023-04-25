Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395936EE502
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 17:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbjDYPvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 11:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234577AbjDYPvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 11:51:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31357146EA
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 08:51:51 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <pza@pengutronix.de>)
        id 1prKxD-0008Ej-9G; Tue, 25 Apr 2023 17:51:43 +0200
Received: from pza by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <pza@pengutronix.de>)
        id 1prKx7-0005jY-5n; Tue, 25 Apr 2023 17:51:37 +0200
Date:   Tue, 25 Apr 2023 17:51:37 +0200
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?B?QXLEsW7DpyDDnG5hbA==?= <arinc.unal@arinc9.com>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next v2 13/14] net: dsa: mt7530: introduce driver for
 MT7988 built-in switch
Message-ID: <20230425155137.GA19130@pengutronix.de>
References: <cover.1680483895.git.daniel@makrotopia.org>
 <a426afba905ed4eb9878fbdc42b9f98e98c54e5f.1680483896.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a426afba905ed4eb9878fbdc42b9f98e98c54e5f.1680483896.git.daniel@makrotopia.org>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: pza@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Mon, Apr 03, 2023 at 02:19:40AM +0100, Daniel Golle wrote:
> Add driver for the built-in Gigabit Ethernet switch which can be found
> in the MediaTek MT7988 SoC.
> 
> The switch shares most of its design with MT7530 and MT7531, but has
> it's registers mapped into the SoCs register space rather than being
> connected externally or internally via MDIO.
> 
> Introduce a new platform driver to support that.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  MAINTAINERS                   |   2 +
>  drivers/net/dsa/Kconfig       |  12 +++
>  drivers/net/dsa/Makefile      |   1 +
>  drivers/net/dsa/mt7530-mmio.c | 101 +++++++++++++++++++++++++
[...]
> diff --git a/drivers/net/dsa/mt7530-mmio.c b/drivers/net/dsa/mt7530-mmio.c
> new file mode 100644
> index 0000000000000..1a3d4b692f349
> --- /dev/null
> +++ b/drivers/net/dsa/mt7530-mmio.c
> @@ -0,0 +1,101 @@
[...]
> +	priv->rstc = devm_reset_control_get(&pdev->dev, NULL);

Please use devm_reset_control_get_exclusive() directly.

> +	if (IS_ERR(priv->rstc)) {
> +		dev_err(&pdev->dev, "Couldn't get our reset line\n");
> +		return PTR_ERR(priv->rstc);

Not sure if this can actually happen, but there is no need to warn on
-EPROBE_DEFER. You could use return dev_err_probe(...) here.

regards
Philipp
