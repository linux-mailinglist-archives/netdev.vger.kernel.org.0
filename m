Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7AAA62B0A4
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 02:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiKPBki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 20:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiKPBkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 20:40:37 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC331EC7A;
        Tue, 15 Nov 2022 17:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yFmAK950q45cj8aoIbkBUEry3On2mPcjgESz/yzDyYE=; b=tB/JO8Oqb+80yOuMZjJ1ej2CRs
        NNR2Jj7ECGDSJrFQFkZvokN8l6AqhTZVabEQhevH9BeH8Y1kqK3UDJlfmxH858OjGc5yces0BZw9A
        V40XbF0ZOeX41t+/BWNNZvhNBu5++7hA6ioMsxEKzSGV03/y9yCWkl45bdDJb2dQGcbU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ov7OG-002W6v-Mj; Wed, 16 Nov 2022 02:39:00 +0100
Date:   Wed, 16 Nov 2022 02:39:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     broonie@kernel.org, calvin.johnson@oss.nxp.com,
        davem@davemloft.net, edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, lgirdwood@gmail.com, linux@armlinux.org.uk,
        pabeni@redhat.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, netdev@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v4 0/3] arm64: add ethernet to orange pi 3
Message-ID: <Y3Q/NL4ikhxt1YJI@lunn.ch>
References: <20221115073603.3425396-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115073603.3425396-1-clabbe@baylibre.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> But this way could have some problem, a netdev driver could handle
> already its PHY (like dwmac-sun8i already do) and so both phy-core and
> the netdev will use both.
> It is why phy-supply was renamed in ephy-supply in patch #3.

A MAC driver will put its DT properties in the MAC node. A PHY will
put its DT properties in the PHY node of the MDIO bus. Since they are
in different locations, they can use the same name. So please keep
with phy-supply.

Please also update
Documentation/devicetree/bindings/net/ethernet-phy.yaml with these new
properties.

	Andrew
