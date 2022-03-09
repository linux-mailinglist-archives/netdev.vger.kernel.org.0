Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6594D2FF2
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbiCINdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbiCINdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:33:15 -0500
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E952417AEE1;
        Wed,  9 Mar 2022 05:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1646832735; x=1678368735;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vN5DDg7/3wiRuC55qlq4KwFqud6G5ptFDEtxvS2pXyQ=;
  b=NOM1DwSCjneJDhOIWedYzmRu87s7PcGBOEP9x9se6c3pC7xtfdaPVHBx
   9rQ9iEz4sDpckU12Bkr/V+GpJFzVSF//C1CoVqBDCM7YBf04NrigcpL/G
   pM6tC8vv76E6pc8+91Md/bfh7O3zjiflHOvJAm6sx72nH0df7A0112djZ
   n1CjtCUiPrM9THGtkgex9OvCYitY+AyK1+s4w7j4FhHRQz6/wHHfKUEov
   VPgCqwZoKMNNeFyN7iZSo/E6C85j3gZ/B8y813c/dnnpwl7VtYuLGDMYJ
   ckfatmW22BmTixsiwspgJsNo9Gb5dvvNkWJ1mtioDdiuH7/YLTz/1aX/o
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,167,1643670000"; 
   d="scan'208";a="22556713"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 09 Mar 2022 14:32:13 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Wed, 09 Mar 2022 14:32:13 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Wed, 09 Mar 2022 14:32:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1646832733; x=1678368733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vN5DDg7/3wiRuC55qlq4KwFqud6G5ptFDEtxvS2pXyQ=;
  b=AyNvqtF0Kk6BrQylanfZPocvm/1RQXBkQcNSHJVxrWr2mssTjda9uB82
   llVvzQLabeUCHf43lEzIL0LQD2/u+7KrGItnOPwGhdFhFyLnbag3TecVk
   bdLu8d3JhmPCyi7QQDoXwsyhoT8NZIAprNKP+7IfGCsXXm0JO+ksSqw/e
   T62U3XpbMYs6dxcmdAvBtylDML1kQuKb6qCX8asjMPXBivhgs1Y4Mjva4
   S5BCGQhFMCVnMhpxWguEBfdcfAhIj1Vx8Z7AfkHWPfGat6kZ0ye+2/bXd
   PObgSJdCj+yg2cWvwy7EGZPzXerglqueekeYr1VCuAG/nhicC8WTqHrNb
   A==;
X-IronPort-AV: E=Sophos;i="5.90,167,1643670000"; 
   d="scan'208";a="22556712"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 09 Mar 2022 14:32:13 +0100
Received: from steina-w.localnet (unknown [10.123.49.12])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id C0644280065;
        Wed,  9 Mar 2022 14:32:12 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, steve.glendinning@shawell.net,
        UNGLinuxDriver@microchip.com, fntoth@gmail.com,
        martyn.welch@collabora.com, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, marex@denx.de,
        Fabio Estevam <festevam@denx.de>
Subject: Re: (EXT) [PATCH v2 net] smsc95xx: Ignore -ENODEV errors when device is unplugged
Date:   Wed, 09 Mar 2022 14:32:10 +0100
Message-ID: <2253388.ElGaqSPkdT@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <20220305204720.2978554-1-festevam@gmail.com>
References: <20220305204720.2978554-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Fabio,

Am Samstag, 5. M=E4rz 2022, 21:47:20 CET schrieb Fabio Estevam:
> From: Fabio Estevam <festevam@denx.de>
>=20
> According to Documentation/driver-api/usb/URB.rst when a device
> is unplugged usb_submit_urb() returns -ENODEV.
>=20
> This error code propagates all the way up to usbnet_read_cmd() and
> usbnet_write_cmd() calls inside the smsc95xx.c driver during
> Ethernet cable unplug, unbind or reboot.
>=20
> This causes the following errors to be shown on reboot, for example:
>=20
> ci_hdrc ci_hdrc.1: remove, state 1
> usb usb2: USB disconnect, device number 1
> usb 2-1: USB disconnect, device number 2
> usb 2-1.1: USB disconnect, device number 3
> smsc95xx 2-1.1:1.0 eth1: unregister 'smsc95xx' usb-ci_hdrc.1-1.1, smsc95xx
> USB 2.0 Ethernet smsc95xx 2-1.1:1.0 eth1: Failed to read reg index
> 0x00000114: -19
> smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
> smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
> smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
> smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
> smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
> smsc95xx 2-1.1:1.0 eth1: hardware isn't capable of remote wakeup
> usb 2-1.4: USB disconnect, device number 4
> ci_hdrc ci_hdrc.1: USB bus 2 deregistered
> ci_hdrc ci_hdrc.0: remove, state 4
> usb usb1: USB disconnect, device number 1
> ci_hdrc ci_hdrc.0: USB bus 1 deregistered
> imx2-wdt 30280000.watchdog: Device shutdown: Expect reboot!
> reboot: Restarting system
>=20
> Ignore the -ENODEV errors inside __smsc95xx_mdio_read() and
> __smsc95xx_phy_wait_not_busy() and do not print error messages
> when -ENODEV is returned.

Just FYI, this even fixed a suspend problem on a 5.10 imx downstream kernel=
=20
which had similar symptoms. Thanks a lot.

Regards
Alexander

> Fixes: a049a30fc27c ("net: usb: Correct PHY handling of smsc95xx")
> Signed-off-by: Fabio Estevam <festevam@denx.de>
> ---
> Changes since v1:
> - Added 'net' annotation - Andrew
> - Added Fixes tag - Andrew
> - Avoided undefined 'buf' behaviour in __smsc95xx_read_reg() - Andrew
>=20
>  drivers/net/usb/smsc95xx.c | 28 ++++++++++++++++++++--------
>  1 file changed, 20 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
> index b17bff6a1015..e5b744851146 100644
> --- a/drivers/net/usb/smsc95xx.c
> +++ b/drivers/net/usb/smsc95xx.c
> @@ -84,9 +84,10 @@ static int __must_check __smsc95xx_read_reg(struct usb=
net
> *dev, u32 index, ret =3D fn(dev, USB_VENDOR_REQUEST_READ_REGISTER, USB_DI=
R_IN
>=20
>  		 | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>=20
>  		 0, index, &buf, 4);
> -	if (unlikely(ret < 0)) {
> -		netdev_warn(dev->net, "Failed to read reg index 0x%08x:=20
%d\n",
> -			    index, ret);
> +	if (ret < 0) {
> +		if (ret !=3D -ENODEV)
> +			netdev_warn(dev->net, "Failed to read reg=20
index 0x%08x: %d\n",
> +				    index, ret);
>  		return ret;
>  	}
>=20
> @@ -116,7 +117,7 @@ static int __must_check __smsc95xx_write_reg(struct
> usbnet *dev, u32 index, ret =3D fn(dev, USB_VENDOR_REQUEST_WRITE_REGISTER,
> USB_DIR_OUT
>=20
>  		 | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>=20
>  		 0, index, &buf, 4);
> -	if (unlikely(ret < 0))
> +	if (ret < 0 && ret !=3D -ENODEV)
>  		netdev_warn(dev->net, "Failed to write reg index 0x%08x:=20
%d\n",
>  			    index, ret);
>=20
> @@ -159,6 +160,9 @@ static int __must_check
> __smsc95xx_phy_wait_not_busy(struct usbnet *dev, do {
>  		ret =3D __smsc95xx_read_reg(dev, MII_ADDR, &val, in_pm);
>  		if (ret < 0) {
> +			/* Ignore -ENODEV error during disconnect()=20
*/
> +			if (ret =3D=3D -ENODEV)
> +				return 0;
>  			netdev_warn(dev->net, "Error reading=20
MII_ACCESS\n");
>  			return ret;
>  		}
> @@ -194,7 +198,8 @@ static int __smsc95xx_mdio_read(struct usbnet *dev, i=
nt
> phy_id, int idx, addr =3D mii_address_cmd(phy_id, idx, MII_READ_ |
> MII_BUSY_);
>  	ret =3D __smsc95xx_write_reg(dev, MII_ADDR, addr, in_pm);
>  	if (ret < 0) {
> -		netdev_warn(dev->net, "Error writing MII_ADDR\n");
> +		if (ret !=3D -ENODEV)
> +			netdev_warn(dev->net, "Error writing=20
MII_ADDR\n");
>  		goto done;
>  	}
>=20
> @@ -206,7 +211,8 @@ static int __smsc95xx_mdio_read(struct usbnet *dev, i=
nt
> phy_id, int idx,
>=20
>  	ret =3D __smsc95xx_read_reg(dev, MII_DATA, &val, in_pm);
>  	if (ret < 0) {
> -		netdev_warn(dev->net, "Error reading MII_DATA\n");
> +		if (ret !=3D -ENODEV)
> +			netdev_warn(dev->net, "Error reading=20
MII_DATA\n");
>  		goto done;
>  	}
>=20
> @@ -214,6 +220,10 @@ static int __smsc95xx_mdio_read(struct usbnet *dev, =
int
> phy_id, int idx,
>=20
>  done:
>  	mutex_unlock(&dev->phy_mutex);
> +
> +	/* Ignore -ENODEV error during disconnect() */
> +	if (ret =3D=3D -ENODEV)
> +		return 0;
>  	return ret;
>  }
>=20
> @@ -235,7 +245,8 @@ static void __smsc95xx_mdio_write(struct usbnet *dev,
> int phy_id, val =3D regval;
>  	ret =3D __smsc95xx_write_reg(dev, MII_DATA, val, in_pm);
>  	if (ret < 0) {
> -		netdev_warn(dev->net, "Error writing MII_DATA\n");
> +		if (ret !=3D -ENODEV)
> +			netdev_warn(dev->net, "Error writing=20
MII_DATA\n");
>  		goto done;
>  	}
>=20
> @@ -243,7 +254,8 @@ static void __smsc95xx_mdio_write(struct usbnet *dev,
> int phy_id, addr =3D mii_address_cmd(phy_id, idx, MII_WRITE_ | MII_BUSY_);
>  	ret =3D __smsc95xx_write_reg(dev, MII_ADDR, addr, in_pm);
>  	if (ret < 0) {
> -		netdev_warn(dev->net, "Error writing MII_ADDR\n");
> +		if (ret !=3D -ENODEV)
> +			netdev_warn(dev->net, "Error writing=20
MII_ADDR\n");
>  		goto done;
>  	}




