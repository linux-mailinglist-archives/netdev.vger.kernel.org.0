Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80C14E68EE
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 19:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348536AbiCXS5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 14:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343982AbiCXS5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 14:57:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1974CB8212;
        Thu, 24 Mar 2022 11:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kxcZ3Ts1vMvwQxmsVPjGSMWCuWeLygWepKF7aZQMkHk=; b=VgM7ZiWYzagzYCgF7dXOdhh1CH
        aIkc+G0jgqhGa3WXSNldiJKThj55WKpvpswddC1mjsCbIdda07uJ03UKnYxZsr9YeIO/DwoDvFcMZ
        x64FI1te8hz2yA8qvV5pPKQE6GTQ+YMe/VNdodvl5N7gJqxX8b6eqR4LZznNZO0P6+lM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nXScK-00CUdM-U2; Thu, 24 Mar 2022 19:55:28 +0100
Date:   Thu, 24 Mar 2022 19:55:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 4/5] net: phy: introduce is_c45_over_c22 flag
Message-ID: <Yjy+oCLdnu3FrNp+@lunn.ch>
References: <20220323183419.2278676-1-michael@walle.cc>
 <20220323183419.2278676-5-michael@walle.cc>
 <Yjt99k57mM5PQ8bT@lunn.ch>
 <8304fb3578ee38525a158af768691e75@walle.cc>
 <Yju+SGuZ9aB52ARi@lunn.ch>
 <30012bd8256be3be9977bd15d1486c84@walle.cc>
 <YjybB/fseibDU4dT@lunn.ch>
 <0d4a2654acd2cc56f7b17981bf14474e@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d4a2654acd2cc56f7b17981bf14474e@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The
> > only valid case i can think of is for a very oddball PHY which has C45
> > register space, but cannot actually do C45 transfers, and so C45 over
> > C22 is the only option.
> 
> And how would you know that the PHY has the needed registers in c22
> space? Or do we assume that every C45 PHY has these registers?

I think it is a reasonable assumption at the moment. We have around
170 MDIO bus masters in Linux. All but one can do C22. There are
around 15 which can do both C22 and C45, and only one that i know of
which is C45 only. So anybody making a C45 transfer only PHY is making
their device hard to sell.

I suppose a PHY integrated with the MAC could by C45 only, and not
support C22, but i've not seen such a device yet. My guess such a
device would be an Ethernet switch, or a USB device, or maybe an
automotive device with a T1 PHY.

       Andrew
