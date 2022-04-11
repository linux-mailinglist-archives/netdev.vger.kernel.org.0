Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E12D4FB0FC
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 02:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbiDKAWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 20:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244222AbiDKAWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 20:22:36 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14233A5D4;
        Sun, 10 Apr 2022 17:20:23 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 507FD5C0180;
        Sun, 10 Apr 2022 20:20:23 -0400 (EDT)
Received: from imap49 ([10.202.2.99])
  by compute3.internal (MEProxy); Sun, 10 Apr 2022 20:20:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aj.id.au; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=qZq0gNozEb4QrHvwme8MdLyW+ZDyKjljjkYtVI
        LbzYY=; b=TXTAFZvPkSC+uaGwgCbkfdkWk/H6QZZnfTj07ii961i5ZfUK9DvbMf
        h5gdadloFdTahiWff6+CIWhcEf3CeY137wtzI6kjVrCFCUb7uqR2DvOFByKacgU0
        IxYQs4JLj277Y1C+hLTcnTQyLAakkMDGwO2I3l1DJEjI14aTFnK33HsylJlu8K8f
        TL/bHZwLxj+1JHWRLaBcXRUO9nhriGYeFg6vbPoUlSTxUL31TH46kB5yBjKigjDU
        2dYYF4+erXHYEKfAg+Qu1dYvLy0vm8aeevELl4+DvW4rmXDth5RuQdhWHxSKYNBl
        4b8/x4wzkO/pj/aVlZITZhq2dsRAS8Ew==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=qZq0gNozEb4QrHvwm
        e8MdLyW+ZDyKjljjkYtVILbzYY=; b=LBq14acoXgbNIt+4oszinyhrpjvty+QSe
        2hSQ+X3AKWzhpg4oUMLL2MMGA6IICMN64cpzCGxLQMRcB3Wd7Z1DpMD76IVR0OmH
        7Em1ue6SlJ1QOZKKut4F44fsBnRJs77gw+rt/9EyKKMXyTBDwDxp3tx2H+Da+JUg
        NNgLq8YQIipNjqcU/0Mj5Hfg0VGhJxi/WnTLVxKTcA+vuR/35cX0lqdzyqFEK+mb
        KFugQ3Y1+OLKBZnPwb4trme2reV+zoi0ill8d6ozqw2js9dmemcdDwKRLSzgtIDN
        nGGsIhn/+22KNImw3Y4oiJB4BOmH29NK2ffgcfL5c0JFjGNdOpKLA==
X-ME-Sender: <xms:R3RTYqu2dH5R8WugTJVEd0Kx2hrRiIrC47L7-1jZlUT_z_Tm8yv8Vw>
    <xme:R3RTYveEaavTdVNxjWu8PLoVtvF100p6Ta3EBH9TYM_S3Of6f6q9uB3V02jjx5cfd
    fcHhMJYxcfwZJRuIQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekhedgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdetnhgu
    rhgvficulfgvfhhfvghrhidfuceorghnughrvgifsegrjhdrihgurdgruheqnecuggftrf
    grthhtvghrnhephefhfeekgfekudevheffheeihedujeefjeevjeefudfgfeeutdeuvdeh
    hfevueffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnughrvgifsegrjhdrihgurdgruh
X-ME-Proxy: <xmx:R3RTYlzfd4Z9exPNRVGSKcvSO0CfBU480PqlxmrbxLtC3luVOTWiiw>
    <xmx:R3RTYlMuaunSzprNALVHSN9ZfYHQxWWCzu9QQCJPYSCTNLJVwgjWEw>
    <xmx:R3RTYq8PnLL5nKW3aCEc8uXivSYXb49oTIdH828VmfNl6pIM0PDGyw>
    <xmx:R3RTYsdGAN20XaVrpx87TCE2wWEvssxYhu-aEYfunFczyW-FOIeftA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 08A5B15A005F; Sun, 10 Apr 2022 20:20:23 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-386-g4174665229-fm-20220406.001-g41746652
Mime-Version: 1.0
Message-Id: <667280e7-526d-4002-9dff-389f6b35ac2f@www.fastmail.com>
In-Reply-To: <20220407075734.19644-3-dylan_hung@aspeedtech.com>
References: <20220407075734.19644-1-dylan_hung@aspeedtech.com>
 <20220407075734.19644-3-dylan_hung@aspeedtech.com>
Date:   Mon, 11 Apr 2022 09:50:02 +0930
From:   "Andrew Jeffery" <andrew@aj.id.au>
To:     "Dylan Hung" <dylan_hung@aspeedtech.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Joel Stanley" <joel@jms.id.au>, "Andrew Lunn" <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "Russell King" <linux@armlinux.org.uk>,
        "David Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, pabeni@redhat.com,
        "Philipp Zabel" <p.zabel@pengutronix.de>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Cc:     BMC-SW@aspeedtech.com
Subject: Re: [PATCH RESEND v3 2/3] net: mdio: add reset control for Aspeed MDIO
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Thu, 7 Apr 2022, at 17:27, Dylan Hung wrote:
> Add reset assertion/deassertion for Aspeed MDIO.  There are 4 MDIO
> controllers embedded in Aspeed AST2600 SOC and share one reset control
> register SCU50[3].  To work with old DT blobs which don't have the reset
> property, devm_reset_control_get_optional_shared is used in this change.
>
> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/net/mdio/mdio-aspeed.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
> index e2273588c75b..1afb58ccc524 100644
> --- a/drivers/net/mdio/mdio-aspeed.c
> +++ b/drivers/net/mdio/mdio-aspeed.c
> @@ -3,6 +3,7 @@
> 
>  #include <linux/bitfield.h>
>  #include <linux/delay.h>
> +#include <linux/reset.h>
>  #include <linux/iopoll.h>
>  #include <linux/mdio.h>
>  #include <linux/module.h>
> @@ -37,6 +38,7 @@
> 
>  struct aspeed_mdio {
>  	void __iomem *base;
> +	struct reset_control *reset;
>  };
> 
>  static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
> @@ -120,6 +122,12 @@ static int aspeed_mdio_probe(struct platform_device *pdev)
>  	if (IS_ERR(ctx->base))
>  		return PTR_ERR(ctx->base);
> 
> +	ctx->reset = devm_reset_control_get_optional_shared(&pdev->dev, NULL);
> +	if (IS_ERR(ctx->reset))
> +		return PTR_ERR(ctx->reset);
> +
> +	reset_control_deassert(ctx->reset);
> +
>  	bus->name = DRV_NAME;
>  	snprintf(bus->id, MII_BUS_ID_SIZE, "%s%d", pdev->name, pdev->id);
>  	bus->parent = &pdev->dev;
> @@ -129,6 +137,7 @@ static int aspeed_mdio_probe(struct platform_device *pdev)
>  	rc = of_mdiobus_register(bus, pdev->dev.of_node);
>  	if (rc) {
>  		dev_err(&pdev->dev, "Cannot register MDIO bus!\n");
> +		reset_control_assert(ctx->reset);
>  		return rc;
>  	}
> 
> @@ -139,7 +148,11 @@ static int aspeed_mdio_probe(struct platform_device *pdev)
> 
>  static int aspeed_mdio_remove(struct platform_device *pdev)
>  {
> -	mdiobus_unregister(platform_get_drvdata(pdev));
> +	struct mii_bus *bus = (struct mii_bus *)platform_get_drvdata(pdev);
> +	struct aspeed_mdio *ctx = bus->priv;
> +
> +	reset_control_assert(ctx->reset);

Isn't this unnecessary because you've used the devm_ variant to acquire 
the reset?

Andrew
