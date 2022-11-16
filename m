Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E132162B0E7
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 02:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiKPB67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 20:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiKPB66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 20:58:58 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762B211821;
        Tue, 15 Nov 2022 17:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gDPOfgCfsDpi156C3e6FefCsf6pqUQQ8FpNTQBrsuqU=; b=1pWmLNiV2HEPMd/seMrvyU9Oyy
        rX/HE2DM+RqCT73cBUybTRcZnPaHO4j1QXB1yPd+IPFy7/fW5Qv3aStSr6ugUTqSIqSC5ZES42jNw
        ynjhN/u4twv7TpTZzjyPC2EhzLfcC9DUTdRTaG0shKEp0xqbhDxjmJulcHThQpcsSPWE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ov7gw-002WDH-FG; Wed, 16 Nov 2022 02:58:18 +0100
Date:   Wed, 16 Nov 2022 02:58:18 +0100
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
Subject: Re: [PATCH v4 2/3] phy: handle optional regulator for PHY
Message-ID: <Y3RDumClNkEW6L4F@lunn.ch>
References: <20221115073603.3425396-1-clabbe@baylibre.com>
 <20221115073603.3425396-3-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115073603.3425396-3-clabbe@baylibre.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +		reg_cnt = of_regulator_bulk_get_all(&bus->dev, nchild, &consumers);

This allocates memory for consumers?

I don't see it being freed. I think you need to add to
phy_remove. Plus the error patch should also free it.

	    Andrew
