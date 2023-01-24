Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65F6967A487
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 22:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjAXVD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 16:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjAXVD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 16:03:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18BE2685;
        Tue, 24 Jan 2023 13:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ph/B8CA5XEjvPhXzOrcnAHQMPGq8rPd6A2i264YU/7g=; b=Kuro7FXNmc40mV3DPu/8jZt3Sf
        mu0L+F+vhjZYc5XULMBMysSHEBuTjO6J8c5ZvYKTnNboBboXezYcGBlqLPwMGEPd0g4mbaEsfNDBM
        Hl7cahF+dEXdG7EoEt5IIB//bUIPp5epnCWEUYH3VuCCZxHLbFD+oyr0Z/Ae8qGKLS8U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pKQRg-0033JP-3G; Tue, 24 Jan 2023 22:03:08 +0100
Date:   Tue, 24 Jan 2023 22:03:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] net: phy: C45-over-C22 access
Message-ID: <Y9BHjEUSvIRI2Mrz@lunn.ch>
References: <20230120224011.796097-1-michael@walle.cc>
 <Y87L5r8uzINALLw4@lunn.ch>
 <Y87WR/T395hKmgKm@shell.armlinux.org.uk>
 <dcea8c36e626dc31ee1ddd8c867eb999@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcea8c36e626dc31ee1ddd8c867eb999@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Btw. for the DT case, it seems we need yet another property
> to indicate broken MDIO busses.

I would prefer to avoid that. I would suggest you do what i did for
the none DT case. First probe using C22 for all devices known in DT.
Then call mdiobus_prevent_c45_scan() which will determine if any of
the found devices are FUBAR and will break C45. Then do a second probe
using C45 and/or C45 over C22 for those devices in DT with the c45
compatible.

	Andrew
