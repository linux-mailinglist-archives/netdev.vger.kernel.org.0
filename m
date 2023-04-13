Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244236E1037
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjDMOn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjDMOnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:43:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DBFB76E;
        Thu, 13 Apr 2023 07:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=J5w0b8Fobg2W9RujUD13uGJH7vRMN8dHc0B4sOAwikM=; b=5TjbN28trjt5HISvTlm95p0A9G
        D9M1FUwIBttbFB3gbsuaO9mbk3vXv4+yRqyZZ19apAILewifcs3qVozNt1PG9U/NozW0WFJ5NF4Mn
        26Hx/eLWptWB7cbOupRNhwJelVtjvJ+RY33Xa4ZQEc6x6adDxZx3Gjac/K9aKr2J/KXA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmyAb-00ACJL-AV; Thu, 13 Apr 2023 16:43:29 +0200
Date:   Thu, 13 Apr 2023 16:43:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v6 06/16] net: phy: phy_device: Call into the
 PHY driver to set LED brightness
Message-ID: <60d5bad7-e7c1-4ffe-be6c-5d92e482b1ba@lunn.ch>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-7-ansuelsmth@gmail.com>
 <202ae4b9-8995-474a-1282-876078e15e47@gmail.com>
 <64380b46.7b0a0220.978a.1eb4@mx.google.com>
 <7ea465d9-95eb-d158-632a-a2aa892fd2bf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ea465d9-95eb-d158-632a-a2aa892fd2bf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Humm just thought of something else, is it OK for led_brightness_set and
> led_blink_set to call into functions that might require sleeping (MDIO, I2C,
> SPI, etc.)?

Hi Florian

That is fine. The LED class is similar to GPIOs. There is a can sleep
version, and an atomic version. For phylib we are using the can sleep
version. The LED core then hides the differences from the users.

    Andrew
