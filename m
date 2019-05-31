Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7B9315EC
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 22:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfEaUL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 16:11:59 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36914 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727316AbfEaUL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 16:11:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=t/iqflpkZXdkMZ8C1n41aXIKDIKKclovO0x0IOf9Bwo=; b=00MXHuzbYnarrynnib+DtbcVN
        YuMxDYzFnbNdx2TX1Fp4TLMQCwPa8TFOL6n20ompNSFEPis46e7cxnXVvUVfFUslKoBOaSl2vHdjD
        91eBcrZwOeMYVv5X8JOBkthKGgOE5jd2ld9050ZWKSzRtv2kJB8sIHR+Kp6evK/+XjwPLtY3w6DvO
        P2mKizjQZLHbpjFZW2sTbydIExYnANkRw4ItgSvMGmEwjnab7pepxiyJF6u6EEO5eUPh4NUdUjvGP
        Ve0T2wCD1lPoyb6Y4YtF2i+JcKpH9Oqft5uq6masRZ5GFNanNRCvKuLK1XJFpm5SG8+XJ9uwP35Ko
        UQVaH9SPw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38426)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hWnsZ-0002sZ-NK; Fri, 31 May 2019 21:11:55 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hWnsZ-0006cV-2H; Fri, 31 May 2019 21:11:55 +0100
Date:   Fri, 31 May 2019 21:11:54 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: sfp: Set 1000BaseX support flag for
 1000BaseT modules
Message-ID: <20190531201154.7fqmxmkncj35jzyz@shell.armlinux.org.uk>
References: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, didn't see this.

On Fri, May 31, 2019 at 01:18:01PM -0600, Robert Hancock wrote:
> Modules which support 1000BaseT should also have 1000BaseX support. Set
> this support flag to allow drivers supporting only 1000BaseX to work.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
> ---
>  drivers/net/phy/sfp-bus.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
> index e9c1879..96cdf85 100644
> --- a/drivers/net/phy/sfp-bus.c
> +++ b/drivers/net/phy/sfp-bus.c
> @@ -158,6 +158,7 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
>  	if (id->base.e1000_base_t) {
>  		phylink_set(modes, 1000baseT_Half);
>  		phylink_set(modes, 1000baseT_Full);
> +		phylink_set(modes, 1000baseX_Full);

None of my RJ45 modules have 1000base-X support, in fact they use SGMII
on the host side and don't offer 1000base-X (fiber) on the connector
side.

Please explain the logic here.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
