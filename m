Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D623417CE
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 09:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhCSI5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 04:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhCSI4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 04:56:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9CAC06174A;
        Fri, 19 Mar 2021 01:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zqIRbM6Nn7HfU4zrksxtqJsFnb/7Sey+P8FGdDKOD2w=; b=hHdi9qLjM0GZCrcxueZ8JkcKL
        dYf0692iB94dwWZlwGi+Y/XqrqZDTk58UxIdtFFMB10DI00g+GcZMgawTeS7BCMo6Z/vWeF7s1K5i
        69dCrpoocj0X3P3PCa2KCoIgscedY53T5Ir+3TVNGIUaW5A9996paSiU0pUssZS6MsDDQ7lrCqxyi
        zFwQ9nCbjHgUNXhgKYPP+4aLWeK/MG090BmAzLOXz3jOqMf63ouB6IW+KQbXeQ+CYJdiEVaIGosmy
        cKStTjYNcAQhyPETLSU/7bRAY4VJeLZ8R7q2m7cHZ22AZ9z5xNaSnhTGKn9D3dIHkSUJxxFrzp+Bj
        BpLtJ4T5Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51472)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lNAvn-0004Cw-E7; Fri, 19 Mar 2021 08:56:31 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lNAvk-0000Ro-I9; Fri, 19 Mar 2021 08:56:28 +0000
Date:   Fri, 19 Mar 2021 08:56:28 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Wong Vee Khee <vee.khee.wong@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH net V2 1/1] net: phy: fix invalid phy id when probe using
 C22
Message-ID: <20210319085628.GT1463@shell.armlinux.org.uk>
References: <20210318090937.26465-1-vee.khee.wong@intel.com>
 <3f7f68d0-6bbd-baa0-5de8-1e8a0a50a04d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f7f68d0-6bbd-baa0-5de8-1e8a0a50a04d@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 08:40:45AM +0100, Heiner Kallweit wrote:
> Is there a specific reason why c22 is probed first? Reversing the order
> would solve the issue we speak about here.
> c45-probing of c22-only PHY's shouldn't return false positives
> (at least at a first glance).

That would likely cause problems for the I2f MDIO driver, since a
C45 read is indistinguishable from a C22 write on the I2C bus.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
