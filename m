Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570CA2DFFCE
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 19:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgLUSbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 13:31:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgLUSbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 13:31:44 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C025DC0613D3;
        Mon, 21 Dec 2020 10:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9CiXd0/pAJb0DPjU2ORyZNELkaVxf9W0I1HIOQ7yQ0E=; b=m31G+EGCWlJHCdtb2nPHKPehg
        gvFBlvZ9Tau2h0he4K+QNTpd3hzNuXx2k+uzUkntWa1iDsNRR58vqW53eQ6uO/WJJpzq6/o2YLK91
        p8xeMINv3nOCOnERzs1QodR3lnrgy9pcEbHenQ6HO6Ymlm8aaxe9jza9KmOoM7G+M9Rg8x9ia/r3h
        A0sBu5KdV9bkPG8lEfldPzZONXfKu5XufEa5GZjcsRHL2sqyhC2IVY6TjVgnyExm9hciZ1jbt6zy3
        sKBDxkebQ1wE/4TdiubzPxc5Ropw8HU0FNqwgug3Kp4bSVv9rWzpQpVH+jKXlDYEPFJTblYAWMOxm
        h2YwPkLqg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44408)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1krPx6-00007G-1B; Mon, 21 Dec 2020 18:30:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1krPx2-0002PL-H4; Mon, 21 Dec 2020 18:30:32 +0000
Date:   Mon, 21 Dec 2020 18:30:32 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marcin Wojtas <mw@semihalf.com>, Sasha Levin <sashal@kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Gabor Samu <samu_gabor@yahoo.ca>,
        Jon Nettleton <jon@solid-run.com>,
        Andrew Elwell <andrew.elwell@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port()
 helper
Message-ID: <20201221183032.GA1551@shell.armlinux.org.uk>
References: <CAPv3WKdJKAEwCoj5z6NzP2xRFfT1HG+2o0wigt=Czi4bG7EQcg@mail.gmail.com>
 <CAPv3WKfEN22cKbM8=+qDANefQE67KQ1zwURrCqAsrbo1+gBCDA@mail.gmail.com>
 <20201102180326.GA2416734@kroah.com>
 <CAPv3WKf0fNOOovq9UzoxoAXwGLMe_MHdfCZ6U9sjgKxarUKA+Q@mail.gmail.com>
 <20201208133532.GH643756@sasha-vm>
 <CAPv3WKed9zhe0q2noGKiKdzd=jBNLtN6vRW0fnQddJhhiD=rkg@mail.gmail.com>
 <X9CuTjdgD3tDKWwo@kroah.com>
 <CAPv3WKdKOnd+iBkfcVkoOZkHj16jOpBprY3A01ERJeq6ZQCkVQ@mail.gmail.com>
 <CAPv3WKfCfECmwjtXLAMbNe-vuGkws_icoQ+MrgJhZJqFcgGDyw@mail.gmail.com>
 <20201221102539.6bdb9f5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201221102539.6bdb9f5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 10:25:39AM -0800, Jakub Kicinski wrote:
> We need to work with stable maintainers on this, let's see..
> 
> Greg asked for a clear description of what happens, from your 
> previous response it sounds like a null-deref in mvpp2_mac_config(). 
> Is the netdev -> config -> netdev linking not ready by the time
> mvpp2_mac_config() is called?

We are going round in circles, so nothing is going to happen.

I stated in detail in one of my emails on the 10th December why the
problem occurs. So, Greg has the description already. There is no
need to repeat it.

Can we please move forward with this?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
