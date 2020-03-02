Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB3B11762D5
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 19:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgCBSiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 13:38:46 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50702 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbgCBSiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 13:38:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lVcyyTFuJENvuP0uQIH1ZeSDEBU3IVUA3B+UI7O/d/A=; b=DeW9eZ17BNQbXcuFS1vS+l9k8
        D6o1PsNBvhemf+7EJyLKyiHQJ+ZHpZJge7tgZGA9P8Z/OdRiq7gG1eMgt3z65NrRA1sM3AWxLsPz5
        3+g58xDGJQIiYWIkUY1AtEKDe0//SJSinP2q49M4+e3LoapjgDym2bw0cuzhHt6WNqR7cEBgQc/m3
        qJxxpHXt9eesbRKskv/MMcILNqqjK2HgHH76KiVcUlhXrh/0AwJLycBu5rIuRVp5TqpgU+twVn/Xg
        zkCnbwDpngV2KhEhiGErwwgIarEqaxvCnUTsspkNl3iiB+WH7Cju81fmn/cCOScCdjD7or12BmM0F
        5Gz0MHQXA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59484)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j8pxa-0003AP-Lj; Mon, 02 Mar 2020 18:38:39 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j8pxZ-00057R-HZ; Mon, 02 Mar 2020 18:38:33 +0000
Date:   Mon, 2 Mar 2020 18:38:33 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Dajun Jin <adajunjin@gmail.com>, hkallweit1@gmail.com,
        robh+dt@kernel.org, frowand.list@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] drivers/of/of_mdio.c:fix of_mdiobus_register()
Message-ID: <20200302183833.GJ25745@shell.armlinux.org.uk>
References: <20200301165018.GN6305@lunn.ch>
 <20200302172919.31425-1-adajunjin@gmail.com>
 <20200302175759.GD24912@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302175759.GD24912@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 02, 2020 at 06:57:59PM +0100, Andrew Lunn wrote:
> Hi Dajun
> 
> > This is my test in Xilinx zcu106 board.
> > 
> > dts is liks this:
> > ethernet@ff0e0000 {
> >     compatible = "cdns,zynqmp-gem", "cdns,gem";
> >     status = "okay";
> >     ...
> >     
> >     phy@0 {
> >         ti,rx-internal-delay = <0x8>;
> >         ti,tx-internal-delay = <0xa>;
> >         ti,fifo-depth = <0x1>;
> >         ti,rxctrl-strap-worka;
> >         linux,phandle = <0x12>;
> >         phandle = <0x12>;

Isn't dtc going to complain about this?  The node name has an address,
but there's no reg property.  If there's no reg property, shouldn't it
be just "phy" ?

The above doesn't look like the original .dts file itself either, but
a .dtb translated back to a .dts - note the numeric phandle properties
and presence of "linux,phandle".

ethernet-phy.yaml also says:

required:
  - reg

so arguably the above doesn't conform to what we expect?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
