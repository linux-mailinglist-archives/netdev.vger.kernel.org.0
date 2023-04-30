Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BE36F2A5B
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 20:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjD3StG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 14:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjD3StF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 14:49:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794881BD5;
        Sun, 30 Apr 2023 11:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1+r4sj5Wdu1YqQif08HC/Zm726AJ0OzaSQ6z+naTJaY=; b=expERG4bmIxY87IpV8nRXZhvdR
        vufaEvswXY9oMHSRXHPhPyXLQo+w9iAi01USwoZ9h9lZpnpHbnyReCRIvibzmh3tKDwjHxfsknAyc
        wb9UALy4ac1X4Xr36VP7JDI7TyFF6bNkNBRCL/mKFxTfLqQyzbuNZ83rEEfEimvV1/vY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ptC69-00BZ9O-7M; Sun, 30 Apr 2023 20:48:37 +0200
Date:   Sun, 30 Apr 2023 20:48:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     David Bauer <mail@david-bauer.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: mediatek,mt7530: document
 MDIO-bus
Message-ID: <207753d6-cffd-4a23-be16-658d7c9ceb4a@lunn.ch>
References: <20230430112834.11520-1-mail@david-bauer.net>
 <20230430112834.11520-2-mail@david-bauer.net>
 <e4feeac2-636b-8b75-53a5-7603325fb411@arinc9.com>
 <396fad42-89d0-114d-c02e-ac483c1dd1ed@arinc9.com>
 <04cc2904-6d61-416e-bfbe-c24d96fe261b@lunn.ch>
 <a6c6fe83-fbb5-f289-2210-6f1db6585636@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6c6fe83-fbb5-f289-2210-6f1db6585636@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Try setting ds->slave_mii_bus to the MDIO bus you register via
> > of_mdiobus_register().
> 
> That seems to be the case already, under mt7530_setup_mdio():
> 
> 	bus = devm_mdiobus_alloc(dev);
> 	if (!bus)
> 		return -ENOMEM;
> 
> 	ds->slave_mii_bus = bus;
> 
> The bus is registered with devm_of_mdiobus_register(), if that matters. (My
> current knowledge about OF or OF helpers for MDIO is next to nothing.)
> 
> The same behaviour is there.

Maybe take a look at what is going on in dsa_slave_phy_setup() and
dsa_slave_phy_connect().

The way i understand it, is it first looks in DT to see if there is a
phy-handle, and if there is, it uses it. If not, it assumes there is a
1:1 mapping between port number and PHY address, and looks to see if a
PHY has been found on ds->slave_mii_bus at that address, and uses it.

So i don't think you need to list the PHY, the fallback should be
used.

	Andrew
