Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8EE92E7AF2
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 17:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgL3QLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 11:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgL3QLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 11:11:24 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E3FC061799;
        Wed, 30 Dec 2020 08:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=iovC8r4bnQk0np2B6m8BqWWmAyM+9fqR5oThYphK294=; b=YNqW+iWGVeDNOkwHR5OS0ZNTn
        MtpsyTqDi2hI5Gl/BmqFrcwyZ4b2oucdId/fWmM5Afp/7X6QWB4o0IN5S97jnvQstJLXAhVPF1AGp
        XJknmguDAvn/8NOY6xhoUYlxJdRJtBEpF+l37p3w3IhH63g5cQQ/AY65IXKYE8EzgO9xRaFxOTgaS
        BlebZLqRYLNEiSLpXUxbcgqjECySZddH7CSJTiWZfNxMiYCbHKKQJ/znLnUFQONJg4VBdFA3wZaE3
        KVqV5mV8uXZEh6KmYgjP5+cIYOfqYM+1hpxx3R8EvU0W7P+jUo/BlUA/NhW79AocQxu5OQY6+8a9j
        3cXzEv4Wg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44912)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kue3a-0005oN-AK; Wed, 30 Dec 2020 16:10:38 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kue3Z-0002KG-5T; Wed, 30 Dec 2020 16:10:37 +0000
Date:   Wed, 30 Dec 2020 16:10:37 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20201230161036.GR1551@shell.armlinux.org.uk>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-2-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201230154755.14746-2-pali@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 04:47:52PM +0100, Pali Rohár wrote:
> Workaround for GPON SFP modules based on VSOL V2801F brand was added in
> commit 0d035bed2a4a ("net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490
> v2.0 workaround"). But it works only for ids explicitly added to the list.
> As there are more rebraded VSOL V2801F modules and OEM vendors are putting
> into vendor name random strings we cannot build workaround based on ids.
> 
> Moreover issue which that commit tried to workaround is generic not only to
> VSOL based modules, but rather to all GPON modules based on Realtek RTL8672
> and RTL9601C chips.
> 
> They can be found for example in following GPON modules:
> * V-SOL V2801F
> * C-Data FD511GX-RM0
> * OPTON GP801R
> * BAUDCOM BD-1234-SFM
> * CPGOS03-0490 v2.0
> * Ubiquiti U-Fiber Instant
> * EXOT EGS1
> 
> Those Realtek chips have broken EEPROM emulator which for N-byte read
> operation returns just one byte of EEPROM data followed by N-1 zeros.
> 
> So introduce a new function sfp_id_needs_byte_io() which detects SFP
> modules with these Realtek chips which have broken EEPROM emulator based on
> N-1 zeros and switch to 1 byte EEPROM reading operation which workaround
> this issue.
> 
> This patch fixes reading EEPROM content from SFP modules based on Realtek
> RTL8672 and RTL9601C chips.
> 
> Fixes: 0d035bed2a4a ("net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490 v2.0 workaround")
> Co-developed-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Pali Rohár <pali@kernel.org>
> ---
>  drivers/net/phy/sfp.c | 78 ++++++++++++++++++++++++-------------------
>  1 file changed, 44 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 91d74c1a920a..490e78a72dd6 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -336,19 +336,11 @@ static int sfp_i2c_read(struct sfp *sfp, bool a2, u8 dev_addr, void *buf,
>  			size_t len)
>  {
>  	struct i2c_msg msgs[2];
> -	size_t block_size;
> +	u8 bus_addr = a2 ? 0x51 : 0x50;
> +	size_t block_size = sfp->i2c_block_size;
>  	size_t this_len;
> -	u8 bus_addr;
>  	int ret;
>  
> -	if (a2) {
> -		block_size = 16;
> -		bus_addr = 0x51;
> -	} else {
> -		block_size = sfp->i2c_block_size;
> -		bus_addr = 0x50;
> -	}
> -

NAK. You are undoing something that is definitely needed. The
diagnostics must be read with sequential reads to be able to properly
read the 16-bit values.

The rest of the patch is fine; it's a shame the entire thing has
been spoilt by this extra addition that was not in the patch we had
been discussing off-list.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
