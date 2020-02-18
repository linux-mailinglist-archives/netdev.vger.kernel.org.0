Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F09BC163774
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 00:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgBRXsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 18:48:18 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33238 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbgBRXsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 18:48:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sYBK+hjxHOSyJ0cblfH2VNIbIJzTu4XFcpaB69wTeWk=; b=MYwJWGczxQd4fFetHU1cgxSuX
        kqFCTwhwAz55L5vJPt+ntJBh4iSk0yaI5iZZpD0q68AbR8dBgIXOxFWoxNe0jieOSOezGgxC/y3Q1
        tJ6F/bv9WAmkOXfwbTPRCKmDvJf1SdpndlbXI+sunYl1HiFNUMNyjN9U5jp8I/hNUVfCl55tR+brx
        zQBr4JrcoKyzVfvm8pcvClKYHzPfT98TeExww4WMj4SPFXdJF0vHqwhe0MKAJOYRqQfkVjSgR0gL3
        166igm0HVCrOS8T4Wrc2tGUQWrVe19ik9fZqCCDQSeqxuq6MgPyYehzbgA8cQM42uUoXJ2U8om3It
        3iQyx3nGw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53832)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j4Cb4-0001v7-DF; Tue, 18 Feb 2020 23:48:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j4Cb1-0000qa-05; Tue, 18 Feb 2020 23:48:07 +0000
Date:   Tue, 18 Feb 2020 23:48:06 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: fix vlan setup
Message-ID: <20200218234806.GN25745@shell.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <E1j41KW-0002v5-2S@rmk-PC.armlinux.org.uk>
 <20200218140907.GB15095@t480s.localdomain>
 <3bfda6cc-5108-427f-e225-beba0f809d73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bfda6cc-5108-427f-e225-beba0f809d73@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 11:34:38AM -0800, Florian Fainelli wrote:
> Russell, in your tests/examples, did the tagged traffic of $VN continue
> to work after you toggled vlan_filtering on? If so, that must be because
> on a bridge with VLAN filtering disabled, we still ended up calling down
> to the lan1..6 ndo_vlan_rx_add_vid() and so we do have VLAN entries
> programmed for $VN.

From what I remember, _all_ traffic was blocked because the VTU
was completely empty when vlan filtering is turned on.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
