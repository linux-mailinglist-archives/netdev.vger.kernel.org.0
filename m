Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2DA5A399B
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 20:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiH0Ssy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 14:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiH0Ssx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 14:48:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CAD32EE1;
        Sat, 27 Aug 2022 11:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=E6+R4CiREVdZZGp49m1jDKnyxojCvYVQuhqq6nJ2T3I=; b=DQ6Bdp3hBlMe2ZhcWxMBoL/OQr
        bO33CIq9rWj7LKxUuhrYU262yJ3Z0Pichm5lTAKGRBtbzdwMeB2mF6dpYbkJTqVjMQGAanJYUrKll
        ztSN3xepAMyzLgGZ0kC1Iu4ad08ydC+A+xY8fX13BODJCoFOpl3N6MoqCne+CXxwXxcs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oS0rP-00EnSF-Uy; Sat, 27 Aug 2022 20:48:47 +0200
Date:   Sat, 27 Aug 2022 20:48:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v3 2/5] net: dsa: add out-of-band tagging
 protocol
Message-ID: <YwpnDwkcM/RaURv2@lunn.ch>
References: <20220826154650.615582-1-maxime.chevallier@bootlin.com>
 <20220826154650.615582-3-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826154650.615582-3-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index 3eef72ce99a4..3e095041dcca 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -57,6 +57,13 @@ config NET_DSA_TAG_HELLCREEK
>  	  Say Y or M if you want to enable support for tagging frames
>  	  for the Hirschmann Hellcreek TSN switches.
>  
> +config NET_DSA_TAG_OOB
> +	tristate "Tag driver for Out-of-band tagging drivers"
> +	help
> +	  Say Y or M if you want to enable support for tagging out-of-band. In
> +	  that case, the MAC driver becomes responsible for sending the tag to
> +	  the switch, outside the inband data.
> +

This file is sorted by the tristate text. So this new entry should
come after NET_DSA_TAG_OCELOT_8021Q

> @@ -9,6 +9,7 @@ obj-$(CONFIG_NET_DSA_TAG_BRCM_COMMON) += tag_brcm.o
>  obj-$(CONFIG_NET_DSA_TAG_DSA_COMMON) += tag_dsa.o
>  obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
>  obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) += tag_hellcreek.o
> +obj-$(CONFIG_NET_DSA_TAG_OOB) += tag_oob.o
>  obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
>  obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
>  obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o

And this should also be after NET_DSA_TAG_OCELOT_8021Q.

    Andrew
