Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5965770C4
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbiGPSi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbiGPSi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:38:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDF91BE92;
        Sat, 16 Jul 2022 11:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=onfoaPsdX3RFZ3bYkRBbMxnProfuyX/n3YmA+bW3vc0=; b=sHyuiH4CYPfNXOrMR3SW6ghS9e
        tG+cyqtBOuvCksgfC3gvVvHO7WrSmNDxSi+2J+3EAVomEVbn0ZO+Rp+AZO5G3KJ3RDSeo65jw0uif
        TZH8NbZjP5TR6yJvqvgeZay9tJVORDS6a6TpzH9aMpMbVAuAq6wtIUsCQYgLlzZrg+xA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oCmgA-00AZAp-2A; Sat, 16 Jul 2022 20:38:14 +0200
Date:   Sat, 16 Jul 2022 20:38:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 14/47] net: phy: aquantia: Add support for
 rate adaptation
Message-ID: <YtMFljr/I7UtSr+y@lunn.ch>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-15-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715215954.1449214-15-sean.anderson@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#define VEND1_GLOBAL_CFG_10M			0x0310
> +#define VEND1_GLOBAL_CFG_100M			0x031b
> +#define VEND1_GLOBAL_CFG_1G			0x031c
> +#define VEND1_GLOBAL_CFG_2_5G			0x031d
> +#define VEND1_GLOBAL_CFG_5G			0x031e
> +#define VEND1_GLOBAL_CFG_10G			0x031f

I completely read this wrong the first time... The common meaning of
#defines line this is

VEND1_GLOBAL_CFG_ is the register and what follows indicates some bits
in the register.

However, this is not true here, these are all registers. Maybe add
_REG to the end? It makes them different to other defines for
registers, but if i parsed it wrong, probably other will as well?

>  static int aqr107_read_rate(struct phy_device *phydev)
>  {
>  	int val;
> +	u32 config_reg;

Revere Christmass tree. config_reg should be first.

       Andrew
