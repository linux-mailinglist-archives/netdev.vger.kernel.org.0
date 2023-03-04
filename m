Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E0E6AAB0B
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 17:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjCDQQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 11:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjCDQQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 11:16:51 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC2F12843;
        Sat,  4 Mar 2023 08:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xplF4RgVqCgG9n4366j4n690Q9EbKHhkNofY33Y7nZU=; b=q1yHqmFUic9Le/0j+EfJwHb0Je
        L+DZFGlaje6I2nrnmNEKAizh5i8VH3TGweEO2xDhgkNToizM04T4ZzYeG0P0ay8f6Q9rNynzdaOde
        iy750VbQckM32GX8yFrnLYTXbKY3IyRosEJUBPwVnhARSmzID6VWjXuE9Q6MjbBhZ4ATsU4bMKooI
        0lxmh3wxvQmPG0mEG04q484qNZ8EaTrPnVl7CgSgbtOQox7jfL6wyoJqGJoN8rlkekJ23WmVG4qhj
        izm0lURK+V8nD2E+MgYj97UwIytBJes3k9DkWSD+FwVoNoyBEoRgYktlAoZRfugEf7GuMmoXha+r4
        BBsGr+iA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48232)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pYUYp-0002oO-Cc; Sat, 04 Mar 2023 16:16:39 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pYUYh-00071n-Vv; Sat, 04 Mar 2023 16:16:31 +0000
Date:   Sat, 4 Mar 2023 16:16:31 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Richard Cochran <richardcochran@gmail.com>,
        thomas.petazzoni@bootlin.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wang Yufen <wangyufen@huawei.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH v2 3/4] net: Let the active time stamping layer be
 selectable.
Message-ID: <ZANu37JHCKwsiCTT@shell.armlinux.org.uk>
References: <20230303164248.499286-1-kory.maincent@bootlin.com>
 <20230303164248.499286-4-kory.maincent@bootlin.com>
 <011d63c3-e3ff-4b67-8ab7-d39f541c7b31@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <011d63c3-e3ff-4b67-8ab7-d39f541c7b31@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 04, 2023 at 04:43:47PM +0100, Andrew Lunn wrote:
> On Fri, Mar 03, 2023 at 05:42:40PM +0100, Köry Maincent wrote:
> > From: Richard Cochran <richardcochran@gmail.com>
> > 
> > Make the sysfs knob writable, and add checks in the ioctl and time
> > stamping paths to respect the currently selected time stamping layer.
> 
> Although it probably works, i think the ioctl code is ugly.
> 
> I think it would be better to pull the IOCTL code into the PTP object
> interface. Add an ioctl member to struct ptp_clock_info. The PTP core
> can then directly call into the PTP object.

Putting it into ptp_clock_info makes little sense to me, because this
is for the PHC, which is exposed via /dev/ptp*, and that's what the
various methods in that structure are for

The timestamping part is via the netdev, which is a separate entity,
and its that entity which is responsible for identifying which PHC it
is connected to (normally by filling in the phc_index field of
ethtool_ts_info.)

Think of is as:

  netdev ---- timestamping ---- PHC

since we can have:

  netdev1 ---- timestamping \
  netdev2 ---- timestamping -*--- PHC
  netdev3 ---- timestamping /

Since the ioctl is to do with requesting what we want the timestamping
layer to be doing with packets, putting it in ptp_clock_info makes
very little sense.

> You now have a rather odd semantic that calling the .ndo_eth_ioctl
> means operate on the MAC PTP. If you look at net_device_ops, i don't
> think any of the other members have this semantic. They all look at
> the netdev as a whole, and ask the netdev to do something, without
> caring what level it operates at. So a PTP ioctl should operate on
> 'the' PTP of the netdev, whichever that might be, MAC or PHY.

Well, what we have today is:

int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
{
...
        if (phy_has_tsinfo(phydev))
                return phy_ts_info(phydev, info);
        if (ops->get_ts_info)
                return ops->get_ts_info(dev, info);
}

So, one can argue that we already have this "odd" semantic, in that
calling get_ts_info() means to operate on the MAC PTP implementation.
Making the ioctl also do that merely brings it into line with this
existing code!

If we want in general for the netdev to always be called, then we need
to remove the above, but then we need to go through all the networking
drivers working out which need to provide a get_ts_info() and forward
that to phylib. Maybe that's a good thing in the longer run though?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
