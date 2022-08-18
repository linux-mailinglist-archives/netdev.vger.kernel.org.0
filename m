Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE8F597AFC
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 03:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242539AbiHRBUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 21:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbiHRBUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 21:20:21 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3069F9C2D4;
        Wed, 17 Aug 2022 18:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1wjNnEeWUlQ11d/DDSaV1am9RVfAubnHe8nnYNJpOAw=; b=miOb4XZuseYEdMTWbsL+Kt8p38
        lSKwWOMnNOj26DexFexCKZY/z4OQTmdQmoqUX80Y98C6xn3zfRspyUoA7NMduLU9P0rr4AsftzTrZ
        1QXm7X2wI2/rDn2VhMVNApabtaq39PMeeb629xgLdEJycITLY62uhEcK8ZuI7zkM+a70=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOUCY-00DgZC-7A; Thu, 18 Aug 2022 03:20:02 +0200
Date:   Thu, 18 Aug 2022 03:20:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 1/2] dt: ar803x: Document disable-hibernation property
Message-ID: <Yv2TwkThceuU+m5l@lunn.ch>
References: <20220812145009.1229094-1-wei.fang@nxp.com>
 <20220812145009.1229094-2-wei.fang@nxp.com>
 <YvZggGkdlAUuQ1NG@lunn.ch>
 <DB9PR04MB8106F2BFD8150A1C76669F9C88689@DB9PR04MB8106.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB9PR04MB8106F2BFD8150A1C76669F9C88689@DB9PR04MB8106.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> 
> 	Your suggestion is indeed an effective solution, but I checked both the datasheet
> and the driver of AR803x PHYs and found that the qca,clk-out-frequency and the
> qca,keep-pll-enabled properties are associated with the CLK_25M pin of AR803x PHYs.
> But there is a case that CLK_25M pin is not used on some platforms.
> Taking our i.MX8DXL platform as an example, the stmmac and AR8031 PHY are applied
> on this platform, but the CLK_25M pin of AR8031 is not used. So when I used the method
> you mentioned above, it did not work as expected. In this case, we can only disable the
> hibernation mode of AR803x PHYs and keep the RX_CLK always outputting a valid clock
> so that the stmmac can complete the software reset operation.

What happens to the RX_CLK when you unplug the cable? It is no longer
receiving anything, so i would expect the RX_CLK to stop ticking. Does
that cause problems for the MAC?

     Andrew
