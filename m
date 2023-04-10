Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A1F6DC672
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 13:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjDJL7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 07:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDJL7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 07:59:15 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B5F30D6
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 04:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OwLcN5pUr7YoUhPdHvCoSQRapl6sp434NeHiRAWgI7o=; b=H2B8v0ooLcg8paNEomGRI1Pau2
        4UbpwHBZ6SO1PBi/Jec/b4XkUPtlmOBMHYUhR2xqsSMZi3to+vCXzPN7pwPsKclJyDA86fP/BKpE8
        NbDvsX79YcLSzKD61EwQc56hjFwdYNOkP948sa8MSPXXIBkqGpzGII7QegAldVdo+Ikc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1plqAs-009ugl-Lt; Mon, 10 Apr 2023 13:59:06 +0200
Date:   Mon, 10 Apr 2023 13:59:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>, shawnguo@kernel.org,
        s.hauer@pengutronix.de, arm-soc <arm@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] ARM: dts: imx51: ZII: Add missing phy-mode
Message-ID: <7bbf5d36-fd04-4638-84cd-5b126818eccb@lunn.ch>
References: <20230407152503.2320741-1-andrew@lunn.ch>
 <20230407152503.2320741-2-andrew@lunn.ch>
 <20230407154159.upribliycphlol5u@skbuf>
 <b5e96d31-6290-44e5-b829-737e40f0ef35@lunn.ch>
 <20230410100012.esudvvyik3ck7urr@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410100012.esudvvyik3ck7urr@skbuf>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Actually, looking at mv88e6xxx_translate_cmode() right now, I guess it's
> not exactly true that the value is going to be ignored, whatever it is.
> A CMODE of MV88E6XXX_PORT_STS_CMODE_MII_PHY is not going to be translated
> into "rev-mii", but into "mii", same as MV88E6XXX_PORT_STS_CMODE_MII.
> Same for MV88E6XXX_PORT_STS_CMODE_RMII_PHY ("rmii" and not "rev-rmii").
> So, when given "rev-mii" or "rev-rmii" as phy modes in the device tree,
> the generic phylink validation procedure should reject them for being
> unsupported.

Ah. I did not actually test this version on hardware. I was expecting
it to be ignored, since the cmode cannot be changed. I did not think
about phylink performing validation.

I will boot of one these DT files on hardware to see what happens.

	Andrew
