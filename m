Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC465A1195
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242230AbiHYNLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242221AbiHYNLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:11:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B83A61DD;
        Thu, 25 Aug 2022 06:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZHG8CY3fj3ld9Xu/N06D7FkFaHONnV50jGcbJ2cn+68=; b=d1Vpiz04/wZLki2twLVlHTZBel
        4Bwtp5X4NDXJWmo3dgNleudVgky4qPRS2u3fXopj+ljC54/df7XS6zXM49X7qkdJXOV8k3J2nid1W
        8Km7i2zcuyxYYa86QE94/E1a6EaiqNFRmQVtw+nyso1h4iLOm813OhPJwwGLBfZpMzLr2FMvVAV7x
        B/cEJOikBgS7HV8A/YkNR8pZhyLZIxtmlJbEN7dgu0V4XctxbY7h6O4r7f84ZtsGqmyMWtxmGOecs
        GbOLGWBLZVu1YiGtcZEEGVZ4EjA7nhKBwhZGF9LWAK724wzhagIj0R7VmG3O3loEYg+m/ULZy6vTm
        Kf52G2ng==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33932)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oRCdq-0005C3-QW; Thu, 25 Aug 2022 14:11:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oRCdm-000591-Ub; Thu, 25 Aug 2022 14:11:22 +0100
Date:   Thu, 25 Aug 2022 14:11:22 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 5/7] net: mdiobus: search for PSE nodes by
 parsing PHY nodes.
Message-ID: <Ywd0+ncka6qYR4rW@shell.armlinux.org.uk>
References: <20220825130211.3730461-1-o.rempel@pengutronix.de>
 <20220825130211.3730461-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825130211.3730461-6-o.rempel@pengutronix.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 03:02:09PM +0200, Oleksij Rempel wrote:
> +static struct pse_control *
> +fwnode_find_pse_control(struct fwnode_handle *fwnode)
> +{
> +	struct pse_control *psec;
> +	struct device_node *np;
> +
> +	if (is_acpi_node(fwnode))
> +		return NULL;
> +
> +	np = to_of_node(fwnode);
> +	if (!np)
> +		return NULL;

Doesn't to_of_node() confirm that the fwnode is a DT node? In other
words, isn't the "is_acpi_node()" entirely redundant?

> +
> +	psec = of_pse_control_get(np);
> +	if (IS_ERR_OR_NULL(psec))
> +		return NULL;
> +
> +	return psec;
> +}

So fwnode_find_pse_control() returns NULL on error.

> +	psec = fwnode_find_pse_control(child);
> +	if (IS_ERR(psec))
> +		return PTR_ERR(psec);

This usage expects it to return an error-pointer.

Clearly, there is some disagreement about what fwnode_find_pse_control()
returns on error.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
