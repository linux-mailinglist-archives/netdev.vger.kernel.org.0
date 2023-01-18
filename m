Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD24671163
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 03:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjARC4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 21:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjARC4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 21:56:45 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F684FC30;
        Tue, 17 Jan 2023 18:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=25llEiYeDS/QkPpInqQXQmxNNvjZJPqsVG0/iQjVy2c=; b=sFON5SBnkYjGqFHr3tGGBRHRrT
        o7Q3m3i9vijRANE8wAKTsMZ5jBcGKPPhpBILFKq0tRkjK1pEfNd20NLBG79ARJztRjlV8Cfc6RAfv
        YFm6zf6kZx0inmW2pb9Auwp28JuVG88YOrmGMDgJAICg7gWy/bdEPqBfPegqlYUYGJiI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pHycq-002ODH-Bb; Wed, 18 Jan 2023 03:56:32 +0100
Date:   Wed, 18 Jan 2023 03:56:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Jerome Brunet <jbrunet@baylibre.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: mdio: add amlogic gxl mdio mux support
Message-ID: <Y8df4LRfPN34lvP8@lunn.ch>
References: <20230116091637.272923-1-jbrunet@baylibre.com>
 <20230116091637.272923-3-jbrunet@baylibre.com>
 <Y8U+1ta6bmt86htm@corigine.com>
 <1jk01mhaeg.fsf@starbuckisacylon.baylibre.com>
 <Y8VWWP53ZysENI7/@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8VWWP53ZysENI7/@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> > >> +	if (!priv)
> > >> +		return -ENOMEM;
> > >
> > > nit: may be it is nicer to use dev_err_probe() here for consistency.
> > 
> > That was on purpose. I only use the `dev_err_probe()` when the probe may
> > defer, which I don't expect here.
> > 
> > I don't mind changing if you prefer it this way.
> 
> I have no strong opinion on this :)

dev_err_probe() does not apply here, because devm_kzalloc does not
return an error code. Hence it cannot be EPROBE_DEFFER, which is what
dev_err_probe() is looking for.

       Andrew
