Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B10F3163EB
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 11:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhBJKdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 05:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbhBJKbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 05:31:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE706C061756;
        Wed, 10 Feb 2021 02:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uIOldDOA1Qh5xWliGCJX3sNgD2W7tpUEtTyYPM97uJg=; b=cpV7aIO5erhcj4WGpltHtKVZ3
        Hv+0cbdV86vf72x8ZjvDj19bhcSTokhDlNZUNw1e3yDcT7gwxMJNf3ipH19Gy+bvwFhQz5wfMS/Az
        3CP4dWzNIPCy1j/o8hqZ20eOKzJHzznBouV9ygnIMaaxG7W/B+5ele35g/qWbSPYryIOlMsTEEo4D
        Lcl6kkwQj8rwap4oCuIf0Cgm8vWvJre+gvBAiXOr5ZsJvZkOpvLaUTQ9l0isBGUvf8GJD/XVCPpNn
        oHoamHJRzLZxc4k04xvaEvOCD8YkMwrVfdkpil49cQTUmWp4DDlEfuhCYZn7K3WWVTUzE50fMce1Q
        VWwCT95+Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41556)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l9mlw-0004We-H6; Wed, 10 Feb 2021 10:31:00 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l9mlv-0004yt-6o; Wed, 10 Feb 2021 10:30:59 +0000
Date:   Wed, 10 Feb 2021 10:30:59 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 7/9] net: phy: icplus: select page before
 writing control register
Message-ID: <20210210103059.GR1463@shell.armlinux.org.uk>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-8-michael@walle.cc>
 <d5672062-c619-02a4-3bbe-dad44371331d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5672062-c619-02a4-3bbe-dad44371331d@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 08:03:07AM +0100, Heiner Kallweit wrote:
> On 09.02.2021 17:40, Michael Walle wrote:
> > +out:
> > +	return phy_restore_page(phydev, oldpage, err);
> 
> If a random page was set before entering config_init, do we actually want
> to restore it? Or wouldn't it be better to set the default page as part
> of initialization?

I think you've missed asking one key question: does the paging on this
PHY affect the standardised registers at 0..15 inclusive, or does it
only affect registers 16..31?

If it doesn't affect the standardised registers, then the genphy_*
functions don't care which page is selected.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
