Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FF42297C0
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 13:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732141AbgGVLwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 07:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgGVLwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 07:52:14 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182F6C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 04:52:14 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id n26so1919266ejx.0
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 04:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gAL7RWhVmiUVHS+7dj9XvdPudZpgIRCs2Gh+z/VT5iE=;
        b=J8ymBpDXozna5eK7lbeZ9xYyNGJHUcGn8rtMpTqZ2Pvb6O0GDPC7nkrWHf2fKwzl1q
         aPvV6uh5d7uZqNYK4DYjkgmWCsNT382XmlWc0PU8wsW/yOON7RrUoKZTWsESzG//rGFE
         fmJasoDY2+4d/sRPhOCBonrs6h/+JcM4jWhuZrjJzdxxNwkAysdEv2Q2XmDG7d7pQWh1
         jvqnp/Mik6h9dA9r24b8UJeIIw1xPTUop3CTJ3vTxnpJnbjpHm78ftvoldWOuFsYh1ku
         8uSu/S3IxJhfWvC94cc8DbeMRcbawqEKUpq3/vwm6cZmvfjAAUcIReR4r3OQEOegisyy
         zcYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gAL7RWhVmiUVHS+7dj9XvdPudZpgIRCs2Gh+z/VT5iE=;
        b=eXejlicD6PvjUpp2E40YIn7/ed7lglMztOiXay1kqUf60uYYDG8U1J1S2j29aP7+m9
         riQjASZ+hN+yzPsL31D1rvCpwbHnT3F51jZJmDeomBpEAxv2XVB9nWxm57EcmS3HSVCZ
         2Q7IW8TLg5r/L3KCCoJQv7RPimk8R4YOMyCCu+iy3y9FjbcLiLkRxxw3SrfHRgUzDYR5
         fnId62/cSXg2tS0+ExJ8oCnkMpD5DubhNvtVNHsCJWJaZK7LIXgg2Yq0FYwdEk+aSn3U
         xNFVkG55IPgb8/HcIPXZ/NRxkkEft9EP3G16f8uZWbYByqj9eC+tri9/i8ObeLMcpi94
         aNhQ==
X-Gm-Message-State: AOAM530gLqg+kKF7EWejyVLMvLvK7Zq1/AWBV/sIgaRfVnKPQKiGxS+o
        DAAt4J6L6lV9t6PWl1xQbPM=
X-Google-Smtp-Source: ABdhPJxaomw2jL5gRYagO2lne4qRouKkoB+loYXOm1dU96TtA8ZcnzWbKGknNROty9VQY1ouighz4Q==
X-Received: by 2002:a17:906:958f:: with SMTP id r15mr728433ejx.77.1595418732767;
        Wed, 22 Jul 2020 04:52:12 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id y7sm18988216edq.25.2020.07.22.04.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 04:52:11 -0700 (PDT)
Date:   Wed, 22 Jul 2020 14:52:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, ioana.ciornei@nxp.com,
        michael@walle.cc, colin.king@canonical.com
Subject: Re: [PATCH net-next] net: phy: fix check in get_phy_c45_ids
Message-ID: <20200722115209.7dpr5wlqxvhwju2y@skbuf>
References: <20200720172654.1193241-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720172654.1193241-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 08:26:54PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> After the patch below, the iteration through the available MMDs is
> completely short-circuited, and devs_in_pkg remains set to the initial
> value of zero.
> 
> Due to devs_in_pkg being zero, the rest of get_phy_c45_ids() is
> short-circuited too: the following loop never reaches below this point
> either (it executes "continue" for every device in package, failing to
> retrieve PHY ID for any of them):
> 
> 	/* Now probe Device Identifiers for each device present. */
> 	for (i = 1; i < num_ids; i++) {
> 		if (!(devs_in_pkg & (1 << i)))
> 			continue;
> 
> So c45_ids->device_ids remains populated with zeroes. This causes an
> Aquantia AQR412 PHY (same as any C45 PHY would, in fact) to be probed by
> the Generic PHY driver.
> 
> The issue seems to be a case of submitting partially committed work (and
> therefore testing something other than was submitted).
> 
> The intention of the patch was to delay exiting the loop until one more
> condition is reached (the devs_in_pkg read from hardware is either 0, OR
> mostly f's). So fix the patch to reflect that.
> 
> Tested with traffic on a LS1028A-QDS, the PHY is now probed correctly
> using the Aquantia driver. The devs_in_pkg bit field is set to
> 0xe000009a, and the MMDs that are present have the following IDs:
> 
> [    5.600772] libphy: get_phy_c45_ids: device_ids[1]=0x3a1b662
> [    5.618781] libphy: get_phy_c45_ids: device_ids[3]=0x3a1b662
> [    5.630797] libphy: get_phy_c45_ids: device_ids[4]=0x3a1b662
> [    5.654535] libphy: get_phy_c45_ids: device_ids[7]=0x3a1b662
> [    5.791723] libphy: get_phy_c45_ids: device_ids[29]=0x3a1b662
> [    5.804050] libphy: get_phy_c45_ids: device_ids[30]=0x3a1b662
> [    5.816375] libphy: get_phy_c45_ids: device_ids[31]=0x0
> 
> [    7.690237] mscc_felix 0000:00:00.5: PHY [0.5:00] driver [Aquantia AQR412] (irq=POLL)
> [    7.704739] mscc_felix 0000:00:00.5: PHY [0.5:01] driver [Aquantia AQR412] (irq=POLL)
> [    7.718918] mscc_felix 0000:00:00.5: PHY [0.5:02] driver [Aquantia AQR412] (irq=POLL)
> [    7.733044] mscc_felix 0000:00:00.5: PHY [0.5:03] driver [Aquantia AQR412] (irq=POLL)
> 
> Fixes: bba238ed037c ("net: phy: continue searching for C45 MMDs even if first returned ffff:ffff")
> Reported-by: Colin King <colin.king@canonical.com>
> Reported-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

This patch is repairing some pretty significant breakage. Could we
please get some review before there start appearing user reports?

[ sorry for the breakage ]

>  drivers/net/phy/phy_device.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 49e98a092b96..1b9523595839 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -734,8 +734,8 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
>  	/* Find first non-zero Devices In package. Device zero is reserved
>  	 * for 802.3 c45 complied PHYs, so don't probe it at first.
>  	 */
> -	for (i = 1; i < MDIO_MMD_NUM && devs_in_pkg == 0 &&
> -	     (devs_in_pkg & 0x1fffffff) == 0x1fffffff; i++) {
> +	for (i = 1; i < MDIO_MMD_NUM && (devs_in_pkg == 0 ||
> +	     (devs_in_pkg & 0x1fffffff) == 0x1fffffff); i++) {
>  		if (i == MDIO_MMD_VEND1 || i == MDIO_MMD_VEND2) {
>  			/* Check that there is a device present at this
>  			 * address before reading the devices-in-package
> -- 
> 2.25.1
> 

Thanks,
-Vladimir
