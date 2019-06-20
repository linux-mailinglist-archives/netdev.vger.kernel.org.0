Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D544C8A1
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 09:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfFTHqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 03:46:51 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48688 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfFTHqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 03:46:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=W24eAUA7DcyA1a5RfqnZ2ZD5kvrAnVHlR34KvhddraM=; b=FSisBsYVYyaTgcBTUo0febIUX
        DDFenl4N3DxDz9HDvkuBZMqWEWt9zs0UkfZmsD2jG6fmyx2xQpWABxUa9pjrcsbg4Iq69M57mzOUj
        sWPOB7nt4lQmrwKlJIFSZwbVT/LR27Rat8De9JlTlxlDceBpFIa1A8mBxEhjB5w/xlfA8aoN2H/xf
        NM2SUSB6Rtl5EB12kUU86hEUVKu3MrWHFEX7oWiS11zpIVz2huPnzaErMF3mqmwh+vJRymZD1FbQX
        zxRJA8+7DCOxjjrEv479Xgmu2JwAs/4fkJB+atb/1i7aA3/R1CL2qeQjI0+Cwma8BqT30oOKJumVD
        wJ/OQBvtQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:58928)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hdrmL-0005hs-Fj; Thu, 20 Jun 2019 08:46:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hdrmH-0002Cl-Bf; Thu, 20 Jun 2019 08:46:37 +0100
Date:   Thu, 20 Jun 2019 08:46:37 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Raju Thombare <pthombar@cadence.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: Re: [PATCH v2 2/5] net: macb: add support for sgmii MAC-PHY interface
Message-ID: <20190620074637.3nxe33czqdm34lgp@shell.armlinux.org.uk>
References: <1560933600-27626-1-git-send-email-pthombar@cadence.com>
 <1560933646-29852-1-git-send-email-pthombar@cadence.com>
 <20190619093146.yajbeht7mizm4hmr@shell.armlinux.org.uk>
 <CO2PR07MB24695C706292A16D71322DB5C1E50@CO2PR07MB2469.namprd07.prod.outlook.com>
 <20190619123206.zvc7gzt4ewxby2y2@shell.armlinux.org.uk>
 <CO2PR07MB24693905766BD027DB972761C1E40@CO2PR07MB2469.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO2PR07MB24693905766BD027DB972761C1E40@CO2PR07MB2469.namprd07.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 05:56:32AM +0000, Parshuram Raju Thombare wrote:
> For in band mode, I see two places to config MAC speed
> and duplex mode, 1. mac_link_state 2. mac_link_up. In mac_link_up, though state
> read from mac_link_state is passed, it is only used for printing log and updating
> pl->cur_interface, so if configuring MAC speed/duplex mode in mac_link_up is correct, 
> these parameters will need to read again from HW.

That is incorrect.  Again, please read the phylink documentation.
There is even an article on how to convert drivers.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
