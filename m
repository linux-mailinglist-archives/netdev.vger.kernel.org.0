Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E354683A4
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 10:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384489AbhLDJlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 04:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384475AbhLDJlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 04:41:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC06C061751;
        Sat,  4 Dec 2021 01:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=L1bvNvE2g1RQrwBMZn/64WsOyAibC0OL2ROJdX7WFd0=; b=x9bTLLXHv/RoNPYO9OQuMfzDs4
        p8VD+HILM6Dp0s+mke0k/VpopeUyzmZM8aayYWq0lNGTjGW5N9JpAMpo5YnWE76V7U70rrLmKIuvf
        1xZXFBr2I8eqyiletBIetbMJdbtIYmxIiIiu76hbxgSaCvLg21T3jc4J3uVJAkD75DKHUwXw1QYhd
        qnv+vpoKJtdAO+Cg3OSBS5GX6umPL9p3CeTIEiHnM0V1rq1RXVGf15JKeHy/7PC2twmwMuMqLHTs/
        OWEAREv7iGmrm0QftM5fVhH98dZxr/fbutkIQAE4gvSnz5AiAAwIkcPjbCLwnorgztyL57/yvcdFd
        0+2gcmag==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56044)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mtRUc-0003Bc-1N; Sat, 04 Dec 2021 09:38:06 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mtRUZ-0002II-CB; Sat, 04 Dec 2021 09:38:03 +0000
Date:   Sat, 4 Dec 2021 09:38:03 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     zhuyinbo <zhuyinbo@loongson.cn>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v3 1/2] modpost: file2alias: make mdio alias configure
 match mdio uevent
Message-ID: <Yas2+yq3h5/Bfvy9@shell.armlinux.org.uk>
References: <1638260517-13634-1-git-send-email-zhuyinbo@loongson.cn>
 <YaXrP1AyZ3AWaQzt@shell.armlinux.org.uk>
 <ea3f6904-c610-0ee6-fbab-913ba6ae36c5@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea3f6904-c610-0ee6-fbab-913ba6ae36c5@loongson.cn>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 04, 2021 at 05:02:51PM +0800, zhuyinbo wrote:
> 
> 在 2021/11/30 下午5:13, Russell King (Oracle) 写道:
> > On Tue, Nov 30, 2021 at 04:21:56PM +0800, Yinbo Zhu wrote:
> > > The do_mdio_entry was responsible for generating a phy alias configure
> > > that according to the phy driver's mdio_device_id, before apply this
> > > patch, which alias configure is like "alias mdio:000000010100000100001
> > > 1011101????", it doesn't match the phy_id of mdio_uevent, because of
> > > the phy_id was a hexadecimal digit and the mido uevent is consisit of
> > > phy_id with the char 'p', the uevent string is different from alias.
> > > Add this patch that mdio alias configure will can match mdio uevent.
> > This is getting rediculous. You don't appear to be listening to the
> > technical feedback on your patches, and are just reposting the same
> > patches. I don't see any point in giving the same feedback, so I'll
> > keep this brief for both patches:
> > 
> > NAK.
> 
> Hi Russell King ,
> 
> 
> I had given you  feedback lots of times, but it may be mail list server
> issue, you don't accept my mail,

I get your email. What I don't see is any change in the resulting code
as a result of my feedback.

I have told you several times to separate out the change to the name
used in bus_type. You have completely ignored that. I will quite simply
NAK that patch every time you post it as long as you have not made that
change.

I have told you that your patch will cause regressions. You continue
to repost it. I will NAK your patch as long as it contains a known
regression because causing a regression is totally _unacceptable_.

> have a comment in v2, but i dont' accept your mail. and I give you explain
> as follows:
> 
> 
> > No. I think we've been over the reasons already. It _will_ break
> > existing module loading.
> 
> > If I look at the PHY IDs on my Clearfog board:
> 
> > /sys/bus/mdio_bus/devices/f1072004.mdio-mii:00/phy_id:0x01410dd1
> > /sys/bus/mdio_bus/devices/mv88e6xxx-0:00/phy_id:0x01410eb1
> > /sys/bus/mdio_bus/devices/mv88e6xxx-0:01/phy_id:0x01410eb1
> > /sys/bus/mdio_bus/devices/mv88e6xxx-0:02/phy_id:0x01410eb1
> > /sys/bus/mdio_bus/devices/mv88e6xxx-0:03/phy_id:0x01410eb1
> > /sys/bus/mdio_bus/devices/mv88e6xxx-0:04/phy_id:0x01410eb1
> > /sys/bus/mdio_bus/devices/mv88e6xxx-0:0f/phy_id:0x01410ea1
> 
> > and then look at the PHY IDs that the kernel uses in the drivers, and
> > thus will be used in the module's alias tables.
> 
> > #define MARVELL_PHY_ID_88E1510          0x01410dd0
> > #define MARVELL_PHY_ID_88E1540          0x01410eb0
> > #define MARVELL_PHY_ID_88E1545          0x01410ea0
> 
> > These numbers are different. This is not just one board. The last nibble
> > of the PHY ID is generally the PHY revision, but that is not universal.
> > See Atheros PHYs, where we match the entire ID except bit 4.
> 
> > You can not "simplify" the "ugly" matching like this. It's the way it is
> > for good reason. Using the whole ID will _not_ cause a match, and your
> > change will cause a regression.
> 
> On my platform, I can find following, stmmac-xx that is is mac name, it represent this platform has two mac
> controller, it isn't phy, but it's sub dir has phy id it is phy silicon id, and devices name is set by mdio bus,
> then, you said that "where we match the entire ID except bit 4." I think marvell it is special, and you can have

This shows that there's a problem with understanding right here, and
I'm quite sure Qualcomm would be very disappointed to hear you think
that their PHYs are made by their competitor, Marvell.

Marvell PHY driver entries use a mask of 0xfffffff0.
Atheros PHY driver entries use a mask of 0xffffffef.

The point I was making is that different PHYs can have different masks,
and this information needs to be encoded in the PHYs alias in the driver
module. We do this by forcing bits that are zero in the mask to be
encoded with a wildcard "?". Bits that are set in the mask are "0" or
"1" depending on their bit value in the driver's ID.

So:
Marvell 88E1510 has an ID of: mdio:0000000101000001000011011101????
Atheros AR8035 has an ID of:  mdio:000000000100110111010000011?0010

The wildcard "?" is in a different position because the mask is
different.

> look other phy,e.g. motorcomm phy, that phy mask is 0x00000fff or 0x0000ffff or ther, for different phy silicon,

... which is exactly my point.  The PHY mask depends on the PHY, and
this is known to the PHY driver.

> that phy maskit is not same, and that phy mask it isn't device property, you dont't get it from register, and mdio
>  bus for phy register a device then mdiobus_scan will get phy id that phy id it is include all value, and don't has
> mask operation.

The mask never comes from the PHY. It only _ever_ comes from the driver.
The operation for matching a PHY driver to a PHY device is:

  phy_id - read from device
  phydrv->phy_id - from the driver
  phydrv->phy_mask - from the driver

  match = (phy_id & phydrv->phy_mask) == (phydrv->phy_id & phydrv->phy_mask);

This is exactly the same operation that we use when matching a PHY
driver module to the PHY ID that the kernel has. The "phy_id" comes
from the uevent. The two phydrv fields come from the alias string
encoded with its wildcards in the module. Matching using these
wildcards achieves the above matching operation.

> then phy uevent must use phy_id that from phy register and that uevent doesn't include phy mask, if
> uevent add phy mask, then you need  define a phy mask. if you have mature consideration, you will find that definition
> phy mask it isn't appropriate, if you define it in mac driver, because  mac can select different phy, if you define it
>  in dts, then phy driver is "of" type, mdio_uevent will doesn't be called. if you ask phy_id & phy_mask as a phy uevent,
>  I think it is no make sense, e.g. 88e1512 and 88e1510 that has different "phy revision" so that phy silicon has difference,
> and uevent should be unique. If you have no other opinion on the above view, Back to this patch, that phy id of uevent
> need match phy alias configure, so alis configure must use phy id all value.

I think you have a fundamental misunderstanding of how this matching
works - and it does work. The uevent modalias string will be the
full ID read from the PHY hardware - there is no mask at this stage.

The mask is encoded in the module using "?" as a wildcard.

> In addition, Even if you hadn't  consided what I said above, you need to know one thing, uevent match alias that must be full
>  matching. not Partial matching. I said it a long time ago.  why you think Binary digit and "?" can match dev uevent,
> according my code analysis and test analysis that  any platform and any mdio phy device is all fail that be matched if that
>  phy driver module and phy dev was use uevent-alias mechanism

This is where you appear to be incorrect. It is _not_ full matching,
it never has been. Other schemes use other _patterns_ to match, and
by that I mean character groups (inside [] brackets).

> [root@localhost ~]# cat /sys/bus/mdio/devices/stmmac-19\:00/phy_id
> 0x01410dd1

So now we finally know you have a revision of the Marvell 88E1510 PHY,
after we've asked you many times for that information.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
