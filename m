Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF99E14CD72
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 16:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgA2Pd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 10:33:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58106 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbgA2Pdz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 10:33:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sh29NOViedSJKeae0NTwxenCnu47xcqJdkHNCJZRTu0=; b=dAseRJoXqqrWpwQ2Kv05C5jlem
        tKiCr7cYBNANTA47TkFQONVhfIGu7k3IzpXuHa+qsMHYDW6+HnAJ3eHu+Ab53f62/Xp3whcAwzEHe
        X4ujwM3GJJ77yby4Xx7SauYfmkNJ+j39NgstZYMQSuebqfM91RFuQcBZBEtcULKzv6Sw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iwpLh-0006v7-6z; Wed, 29 Jan 2020 16:33:49 +0100
Date:   Wed, 29 Jan 2020 16:33:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ykaukab@suse.de" <ykaukab@suse.de>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
 indication
Message-ID: <20200129153349.GB25384@lunn.ch>
References: <1579701573-6609-2-git-send-email-madalin.bucur@oss.nxp.com>
 <68921c8a-06b6-d5c0-e857-14e7bc2c0a94@gmail.com>
 <DB8PR04MB6985606F38572D8512E8D27EEC0F0@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <77e3ddcb-bddb-32d8-9c87-48ba9a7f2773@gmail.com>
 <CA+h21hq7U_EtetuLZN5rjXcq+cRUoD0y_76LxuHpoC53J70CEQ@mail.gmail.com>
 <DB8PR04MB6985139D4ABED85B701445A9EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <CA+h21hpSpgQsQ0kRmSaC2qfmFj=0KadDjwEK2Bvkz72g+iGxBQ@mail.gmail.com>
 <DB8PR04MB6985B0A712634DCFCD5390A4EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200129134447.GA25384@lunn.ch>
 <DB8PR04MB698588200EE839607F055B24EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB698588200EE839607F055B24EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Nor do I need to know, my approach here is "non nocere", if there is a
> chance for the PHY to link with the partner at a different speed than the
> one supported on the system interface, do not prevent it by deleting those
> modes, as the dpaa_eth driver does now. Whether that link will be successful
> or not depends upon many variables and only some are related to rate adaptation.

We need to make it clear then that this bit being true just indicates
that the device might perform rate adaptation, no guarantees, it might
depend on firmware your board does not have, phase of the moon, etc.

I don't like this. Your board not working is your problem, you know
the risks. But when somebody else starts using this bit, and it does
not work, that is not so nice.

Either:

We have documentary evidence that all Aquantia PHYs support this all
the time.

We add code to read registers to determine if the feature is enabled.

We add code to enable the feature.

You limit the scope of this to just your MAC driver. It can try to
detect if an Aquantia phy is being used, phdev->drv can be used to
detect this, and then you enable the extra link modes. Or add a device
tree property, etc.

Thanks
	Andrew


