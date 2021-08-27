Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5149B3FA0FC
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 23:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbhH0VLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 17:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbhH0VLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 17:11:47 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3283C0613D9;
        Fri, 27 Aug 2021 14:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=B04VA3ebYV41oXsvZWYgfVt4MtdWqlQMYtCEpPXnEN0=; b=my5E3FKOHcAhTmIywwAYQ6HiO
        CPM9UbbBRO8QztETw9Hb7bkmOxDj7r7c1YSl3c2uXOkrT/0KX/EM4uw2LBSkIjGStsTDs8XSOL7bv
        p1Cz07n+barJ8d7NOPFWl/mv6LDnBN3k1htqRVRT+Em6XypZLWuJ+FOJJycGtLaP1L/E9tTOuZp48
        oK2UaaenBGl1dF8Ae0Tw2YdaRBLpewEGkIBL1x9klgUAAHonr+CUCO5C1UIzdxBas0dH6yq9Zmv2S
        R0rb0BN1LIIJ+Psp5M+GdJmN+Yvdcgd+jhhGN3lD/IlzhB0aF+m3xLCA7SM8v8+eC/6s6YttvIncK
        C7oPleX3g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47764)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mJj7k-0001dB-6j; Fri, 27 Aug 2021 22:10:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mJj7j-00027g-L3; Fri, 27 Aug 2021 22:10:51 +0100
Date:   Fri, 27 Aug 2021 22:10:51 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh@kernel.org>, linux-phy@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] phy: marvell: phy-mvebu-a3700-comphy: Remove
 unsupported modes
Message-ID: <20210827211051.GW22278@shell.armlinux.org.uk>
References: <20210827092753.2359-1-pali@kernel.org>
 <20210827092753.2359-3-pali@kernel.org>
 <20210827132713.61ef86f0@thinkpad>
 <20210827182502.vdapjcqimq4ulkg2@pali>
 <20210827183355.GV22278@shell.armlinux.org.uk>
 <20210827190234.72eakdvbgojscpkm@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210827190234.72eakdvbgojscpkm@pali>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 09:02:34PM +0200, Pali Rohár wrote:
> I think that whatever is used (firmware code, kernel code, ...), DT
> should always contains full HW description with all nodes, and not only
> some "subset". DT should be independent of current driver / firmware
> implementation.

A "full" description of the hardware settings for the comphy on Armada
8040 would be very big if we included every single setting. There are
about a thousand settings - and that is likely an under-estimate. I
know, I've a shell script that decodes around a thousand settings from
the registers for a _single_ lane, and that's incomplete.

With many of the settings not very well documented in the manual, we
would struggle to describe it sufficiently well to get it past the DT
maintainers.

So, "full hardware description" is impractical. Sorry.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
