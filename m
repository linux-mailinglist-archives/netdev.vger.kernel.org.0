Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728AA6BA4D4
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 02:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCOBsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 21:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCOBsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 21:48:33 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07634212B5;
        Tue, 14 Mar 2023 18:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tDRfS6LV8lFTElXAbbYTqrrTqto+xsHz+GLxd3oMoUI=; b=NMH8/jbWZ7bQYE+yPYnaAH+Zql
        W4xWnvIWE73cmxN5q9/8fDHcTbZ+ckbCQey85yPoaWHmxhjEdcYZP/9uxvA8SEK7VVqvYJY/fsA/E
        SkKFmhD2FXGAZ7okg+J9JpgHjB2XZdOZPNRWfEwoGFz1/kxrCvCpBnyd76v79HuNeTzk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pcGFQ-007LjD-Tz; Wed, 15 Mar 2023 02:48:12 +0100
Date:   Wed, 15 Mar 2023 02:48:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v3 06/14] net: phy: marvell: Add software
 control of the LEDs
Message-ID: <c493a204-045a-4ca1-8630-f05f8a289ed0@lunn.ch>
References: <20230314101516.20427-1-ansuelsmth@gmail.com>
 <20230314101516.20427-1-ansuelsmth@gmail.com>
 <20230314101516.20427-7-ansuelsmth@gmail.com>
 <20230314101516.20427-7-ansuelsmth@gmail.com>
 <20230315004453.sxzqccyozvsfp374@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315004453.sxzqccyozvsfp374@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +	u16 reg;
> > +
> > +	reg = phy_read_paged(phydev, MII_MARVELL_LED_PAGE,
> > +			     MII_88E1318S_PHY_LED_FUNC);
> > +	if (reg < 0)
> > +		return reg;
> 
> "reg" is declared as unsigned, so it's surely positive.

Gerr. That is one of the most common errors in phylib. I should know
better :-(

Thanks
	Andrew
