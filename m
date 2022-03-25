Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE15B4E7DA4
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiCYTnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 15:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbiCYTnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 15:43:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F063EAD18;
        Fri, 25 Mar 2022 12:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=v7v9I64jtbh4TvILDFhQKVP7yzYLEAb3hBx5zd1jBgk=; b=qJ
        Nki9/HJ6HtCe6zXtg8ayKilPjuF58wc8vBEXSdpC9DDWIluWBvaeLgp/sF41TQryIwHkd0cLOwlGZ
        r9et8GZE9gvEN9IF5bcZLOrpU5T4KNnKbjWFan2hr3J8d5J/Lu87wcgN1Dt0I6ATxcuazCpAG2NrJ
        18/FfBvFM3gLd/M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nXojt-00CfzC-FU; Fri, 25 Mar 2022 19:32:45 +0100
Date:   Fri, 25 Mar 2022 19:32:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next 2/5] net: mdio: of: use fwnode_mdiobus_* functions
Message-ID: <Yj4KzQPeVUxZEn0k@lunn.ch>
References: <20220325172234.1259667-1-clement.leger@bootlin.com>
 <20220325172234.1259667-3-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220325172234.1259667-3-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 06:22:31PM +0100, Clément Léger wrote:
> Now that fwnode support has been added and implements the same behavior
> expected by device-tree parsing

The problem is, we cannot actually see that. There is no side by side
comparison which makes it clear it has the same behaviour.

Please see if something like this will work:

1/4: copy drivers/net/mdio/of_mdio.c to drivers/net/mdio/fwnode_mdio.c
2/4: Delete from fwnode_mdio.c the bits you don't need, like the whitelist
3/4: modify what is left of fwnode_mdio.c to actually use fwnode.
4/4: Rework of_mdio.c to use the code in fwnode_mdio.c

The 3/4 should make it clear it has the same behaviour, because we can
see what you have actually changed.

FYI: net-next is closed at the moment, so you need to post RFC
patches.

    Andrew
