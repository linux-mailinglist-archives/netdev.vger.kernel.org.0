Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B13137076
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 15:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgAJO7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 09:59:08 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42890 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727892AbgAJO7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 09:59:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KcB+0FZvEwMSZ71K+kCoZ9X5u6DRQpvD2AQdpGnKqKU=; b=VSQn0TttzYKM/CdTWxnCb9SAK
        98MKbpP1VXCI0Wb/ur9FQV6efmKh98+5V8KPBvOrOfxB7IrgR05Ta3vlsVkBS618/wkR/PkF8y4f3
        9rX0rXKOOIac1MIFCacPThgaz4YTylyoGIYqIOzwsN7VjtDB57lpecTA+jJoaRUPUpmBVqjLnuepN
        yP+TmIC7pPvUW5xAl5K7439M3ROyOI9TB3VDgrofXb84No5s41VboEGKCVgNbHnOSADnNtsrbQ4TV
        CHjv74Fj6rjhDsWFYY47kXdsbHAN3nkCSjgGVFDIUhyo8I+KhX8UEtmC0LtaI/D1YDzXTd8TXOgSC
        tbRk2znsQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:53122)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ipvkU-0003i1-OE; Fri, 10 Jan 2020 14:58:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ipvkP-0001aZ-ER; Fri, 10 Jan 2020 14:58:49 +0000
Date:   Fri, 10 Jan 2020 14:58:49 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/14] net: axienet: Fix SGMII support
Message-ID: <20200110145849.GC25745@shell.armlinux.org.uk>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-8-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110115415.75683-8-andre.przywara@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 11:54:08AM +0000, Andre Przywara wrote:
> With SGMII, the MAC and the PHY can negotiate the link speed between
> themselves, without the host needing to mediate between them.
> Linux recognises this, and will call phylink's mac_config with the speed
> member set to SPEED_UNKNOWN (-1).

I wonder whether you have read the documentation for the phylink
mac_config() method (if not, please read it, it contains some very
important information about what mac_config() should do.)  When
operating in SGMII in-band mode, state->speed and state->duplex are
not actually valid.

You'll probably want to submit a better patch after reading the
documentation.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
