Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536CD571B19
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 15:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiGLNYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 09:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiGLNYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 09:24:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2124161B07;
        Tue, 12 Jul 2022 06:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=k7j5/4LH1uxSAoyJKqSGeIzJp+14qU8heufrbtbEFus=; b=CY6DHndYMpX154FZn7uRO3BKzL
        f1o6IfzDXQpIrYvrfDh3EocKoGzzJGLcGuK/VGP+OWvGxl5JylzLcnMS9JyXLIDk2G3MFkmLxC1x3
        jYiTnJ5bDjuozjBzTCAjUiQ6tOblbq5YQpi/h34EeYrVOdKC7j7W/u5whh0PddnYzNyE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oBFsR-00A3Jn-BL; Tue, 12 Jul 2022 15:24:35 +0200
Date:   Tue, 12 Jul 2022 15:24:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: phy: mxl-gpy: cache PHY firmware
 version
Message-ID: <Ys12E0mVdc3rd7it@lunn.ch>
References: <20220712131554.2737792-1-michael@walle.cc>
 <20220712131554.2737792-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712131554.2737792-3-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	priv->fw_type = FIELD_GET(PHY_FWV_TYPE_MASK, fw_version);
> +	priv->fw_minor = FIELD_GET(PHY_FWV_MINOR_MASK, fw_version);
>  
>  	ret = gpy_hwmon_register(phydev);
>  	if (ret)
>  		return ret;
>  
> +	/* Show GPY PHY FW version in dmesg */
>  	phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", fw_version,
>  		    (fw_version & PHY_FWV_REL_MASK) ? "release" : "test");

Maybe use fw_type and fw_minor. It makes the patch a bit bigger, but
makes the code more consistent.

      Andrew
