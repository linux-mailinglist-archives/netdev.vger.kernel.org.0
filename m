Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC7B169878
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 16:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgBWPml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 10:42:41 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33366 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgBWPmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 10:42:40 -0500
Received: by mail-wm1-f66.google.com with SMTP id m10so8927365wmc.0;
        Sun, 23 Feb 2020 07:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:thread-index
         :content-language;
        bh=1FoLbj63nB1eaYBJsT/ByMdE8sypO52SHZF5hkdeFrY=;
        b=ZRtMT8Q7Mo3YTUIidM8c9lCxOyjqyRpGlsRU/dnqek3OMtMP325obcgqvFp9r9/9R5
         rgwBBm55GJc1ulUus5qEHJ14n1OzKcp1Yzs0peRI30VwEXB+8GYQKC5MTU+QxtovQ0mk
         0J4EXZy77dQh30sJHa2bGWBgB0Zz79D4gdeju5ER1lX/RwhoIJ2WlAxRhoD4Mxn/Mv0j
         rkUIBTwLVcUhwbpf1JOnQl1nCcsU1LgmE9CCxwfq7CT0EFZaxQgyQGMAxDQR01xXG/LD
         0MTyvuSrJfD3gniZwPFzGKARbN+HKtce4R7rRJ48eFT9OIMfheJjuPAdAPftpkpMC6sI
         U9lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:in-reply-to:subject:date
         :message-id:mime-version:content-transfer-encoding:thread-index
         :content-language;
        bh=1FoLbj63nB1eaYBJsT/ByMdE8sypO52SHZF5hkdeFrY=;
        b=XG+aV324QQuIMPqJ117/rRL2ngVBc1b9qK+lpW7i903kNTmyWdX3TF4CrjSFyyCAgQ
         MN3sT7U2/f0BbGD45U3DJWjEf8PBx76+MPXGZkm3YswGw5p9wdEKWPsAKYgjlLWx6cCa
         63ny1928HOU487miz9F3OEx6836SocSxpV0mPKxpxoxt32fVyTcyL125XEQxJeIvZ4/V
         Wv+yxaLsRVm/cYBN2m/Ll6nfeUkGwW6sGnRG9V9bYpH5zVwyx/v1bqS2PkN3unrRdSsh
         PrYix0b+DXgiXS0LvMrsHIsYHUnn48R19dOJHwDTHdy92C1rtSVVNMinRFozExOJkGBS
         XtBA==
X-Gm-Message-State: APjAAAWApcGPp6ghnlQb64EZw/g/A3hWJcp/8kcsGx8RB1t0MIB8n0h5
        dDWb8+jfc0idpAb0mUvs5cY=
X-Google-Smtp-Source: APXvYqwWk9IGpIliyaU3i88FGQmNUpthLG25ueVCWldDwrDsHOvFXdbPb4DOfF1QuxFa3znuBxp7rQ==
X-Received: by 2002:a7b:c119:: with SMTP id w25mr17198325wmi.116.1582472556695;
        Sun, 23 Feb 2020 07:42:36 -0800 (PST)
Received: from AnsuelXPS (host110-18-dynamic.45-213-r.retail.telecomitalia.it. [213.45.18.110])
        by smtp.gmail.com with ESMTPSA id z10sm13283985wmk.31.2020.02.23.07.42.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Feb 2020 07:42:36 -0800 (PST)
From:   <ansuelsmth@gmail.com>
To:     "'Christian Lamparter'" <chunkeey@gmail.com>
Cc:     "'Andy Gross'" <agross@kernel.org>,
        "'Bjorn Andersson'" <bjorn.andersson@linaro.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Andrew Lunn'" <andrew@lunn.ch>,
        "'Florian Fainelli'" <f.fainelli@gmail.com>,
        "'Heiner Kallweit'" <hkallweit1@gmail.com>,
        "'Russell King'" <linux@armlinux.org.uk>,
        <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200222161629.1862-1-ansuelsmth@gmail.com> <4475595.vek7CkyBFf@debian64>
In-Reply-To: <4475595.vek7CkyBFf@debian64>
Subject: R: [PATCH v6 1/2] net: mdio: add ipq8064 mdio driver
Date:   Sun, 23 Feb 2020 16:42:33 +0100
Message-ID: <014b01d5ea5f$de7f6020$9b7e2060$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQE4eToOjurUGVz9NufAi0s1OH1bPQGk7GTlqVah7CA=
Content-Language: it
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> Hi,
>=20
> On Saturday, 22 February 2020 17:16:26 CET Mr. Smith wrote:
> > Currently ipq806x soc use generic bitbang driver to
> > comunicate with the gmac ethernet interface.
> > Add a dedicated driver created by chunkeey to fix this.
>=20
> Ok, I'm officially a bit "out-of-the-loop" here (was looking for
> a changelog, but I guess I missed that mail). So please excuse me,
> if I say something that was already stated. Instead kindly reply
> with a text extract (preferably with the link to the mail as I'm not
> a regular linux-net subscriber) to that discussion.
>=20
> > Co-developed-by: Christian Lamparter <chunkeey@gmail.com>
> Ahh, I see that
> "docs: Clarify the usage and sign-off requirements for =
Co-developed-by"
> did away with the "original author" wording in the submitting-patches =
doc.
> So keeping the original "From:" doesn't matter as such anymore.
>=20
> Still, for reference (historical digs or if someone wants to take a =
peek):
> Most of this patch comes from a patch named:
> 700-net-mdio-add-ipq8064-mdio-driver.patch
>=20
> which is part of a bigger "ipq8064: ipq8064-mdio + dsa test" commit.
> This is currently in a staging tree hosted on <git.openwrt.org>.
> Here's a direct link: [0] (sadly, this is not self-updating).
>=20
> Background: This driver was mainly written to make and test the qca8k
> patches I posted to the linux-net ML last year. The Idea was that I
> didn't have to deal with the odd random timing issues on the slow =
debug
> kernels, when I was perfing/hammering the device.
> (The IPQ8064 has/had various scaling problems so, this might be =
already
> fixed by some of Mr. Smith's other work for the abandoned IPQ8064).
>=20
> From what I know, this patch mostly helps/fixes a problem with the
> out-of-tree OpenWrt swconfig-based ar8216/ar8236 driver for the
> used QCA8337 switch.
> This driver really needs the faster, more efficient reads due to =
having
> a statistics worker which is just gobbing cycles because of all the
> exclusive-access bit-banging taking place.
> (Remember, the worker could read all the phy-counters for each of the =
7
> ports over gpio-mdio (there have been attempts to make it less hoggy
> in the mean time though). While the IPQ8064 SoC has a beefy dual-core
> Cortex-A15 with up to 1.4GHz*, this bitbanging will result in a
> considerable load on at least one of the cores.)
>=20
> Mr. Smith knows more about this though, as he has the hardware and
> is the upcoming IPQ8064 expert on this.
>=20
> From my POV, I never anticipated this hack was up to standards of =
linux-
> net.
> As there is this ugly dependency on having the "master" MAC (handled =
by
> the
> sttmac/dwmac-ipq806x.c) part up and operational all the time (that's =
why
> the "master" property is needed for some devices at least).
>=20
> I had hopes to do this properly and integrate it into
> dwmac-ipq806x.c, but this requires much more work and ultimately
> "virtual-mdio" was "just good enough=E2=84=A2=EF=B8=8F" for standard, =
production kernels.
> From what I remember the Qualcomm devs themselves never bothered in
> their
> abandoned posts with the DeviceTree for the qcom-ipq8064.dts to =
include a
> standalone mdio driver. Instead the dev went straight to =
"virtual-mdio".
> (but this was too long ago to really remember the details and it's =
getting
> late)
>=20
> But Ok, if linux-net is content with the standalone mdio-ipq8064 =
approach,
> then: Sure!
>=20
Thx a lot for the clarification, I tested your driver for a long time =
and now I'm
trying to post some of the patch on Openwrt upstream.=20
There is no changelog as the changes is mainly the use of the api =
instead of
the for loop (for the busy wait) and some define rename.=20
> > diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> > index 9dabe03a668c..ec2a5493a7e8 100644
> > --- a/drivers/net/phy/Kconfig
> > +++ b/drivers/net/phy/Kconfig
> > @@ -157,6 +157,14 @@ config MDIO_I2C
> >
> >  	  This is library mode.
> >
> > +config MDIO_IPQ8064
> > +	tristate "Qualcomm IPQ8064 MDIO interface support"
> > +	depends on HAS_IOMEM && OF_MDIO
> > +	depends on MFD_SYSCON
> > +	help
> > +	  This driver supports the MDIO interface found in the network
> > +	  interface units of the IPQ8064 SoC
> > +
> >  config MDIO_MOXART
> >  	tristate "MOXA ART MDIO interface support"
> >  	depends on ARCH_MOXART || COMPILE_TEST
> > diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> > index fe5badf13b65..8f02bd2089f3 100644
> > --- a/drivers/net/phy/Makefile
> > +++ b/drivers/net/phy/Makefile
> > @@ -36,6 +36,7 @@ obj-$(CONFIG_MDIO_CAVIUM)	+=3D mdio-
> cavium.o
> >  obj-$(CONFIG_MDIO_GPIO)		+=3D mdio-gpio.o
> >  obj-$(CONFIG_MDIO_HISI_FEMAC)	+=3D mdio-hisi-femac.o
> >  obj-$(CONFIG_MDIO_I2C)		+=3D mdio-i2c.o
> > +obj-$(CONFIG_MDIO_IPQ8064)	+=3D mdio-ipq8064.o
> >  obj-$(CONFIG_MDIO_MOXART)	+=3D mdio-moxart.o
> >  obj-$(CONFIG_MDIO_MSCC_MIIM)	+=3D mdio-mscc-miim.o
> >  obj-$(CONFIG_MDIO_OCTEON)	+=3D mdio-octeon.o
> > diff --git a/drivers/net/phy/mdio-ipq8064.c b/drivers/net/phy/mdio-
> ipq8064.c
> > new file mode 100644
> > index 000000000000..74d6b92a6f48
> > --- /dev/null
> > +++ b/drivers/net/phy/mdio-ipq8064.c
> > @@ -0,0 +1,166 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +//
> > +// Qualcomm IPQ8064 MDIO interface driver
> > +//
> > +// Copyright (C) 2019 Christian Lamparter <chunkeey@gmail.com>
> > +
> > +#include <linux/delay.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/regmap.h>
> > +#include <linux/of_mdio.h>
> > +#include <linux/phy.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/mfd/syscon.h>
> > +
> > +/* MII address register definitions */
> > +#define MII_ADDR_REG_ADDR                       0x10
> > +#define MII_BUSY                                BIT(0)
> > +#define MII_WRITE                               BIT(1)
> > +#define MII_CLKRANGE_60_100M                    (0 << 2)
> > +#define MII_CLKRANGE_100_150M                   (1 << 2)
> > +#define MII_CLKRANGE_20_35M                     (2 << 2)
> > +#define MII_CLKRANGE_35_60M                     (3 << 2)
> > +#define MII_CLKRANGE_150_250M                   (4 << 2)
> > +#define MII_CLKRANGE_250_300M                   (5 << 2)
> > +#define MII_CLKRANGE_MASK			GENMASK(4, 2)
> > +#define MII_REG_SHIFT				6
> > +#define MII_REG_MASK				GENMASK(10, 6)
> > +#define MII_ADDR_SHIFT				11
> > +#define MII_ADDR_MASK				GENMASK(15, 11)
> Is it just me, or is something weird going on with tabs vs. spaces =
here
> (and below in ipq8064_mdio_wait_busy() )?
>=20
> > +
> > +#define MII_DATA_REG_ADDR                       0x14
> > +
> > +#define MII_MDIO_DELAY_USEC                     (1000)
> > +#define MII_MDIO_RETRY_MSEC                     (10)
> > +
> > +struct ipq8064_mdio {
> > +	struct regmap *base; /* NSS_GMAC0_BASE */
> > +};
> > +
> > +static int
> > +ipq8064_mdio_wait_busy(struct ipq8064_mdio *priv)
> > +{
> > +	u32 busy;
> > +
> > +	return regmap_read_poll_timeout(priv->base,
> MII_ADDR_REG_ADDR, busy,
> > +					!(busy & MII_BUSY),
> MII_MDIO_DELAY_USEC,
> > +					MII_MDIO_RETRY_MSEC *
> USEC_PER_MSEC);
> Didn't know this macro existed. This look much nicer.
>=20
>=20
> > +}
> > +
> > +static int
> > +ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int =
reg_offset)
> > +{
> > +	struct ipq8064_mdio *priv =3D bus->priv;
> > +	u32 miiaddr =3D MII_BUSY | MII_CLKRANGE_250_300M;
> > +	u32 ret_val;
> > +	int err;
> > +
> > +	/* Reject clause 45 */
> > +	if (reg_offset & MII_ADDR_C45)
> > +		return -EOPNOTSUPP;
> Heh, C45 on IPQ806X? Ok, anyone know the hardware or is this some =
fancy
> forward-thinking future-proofing?
> (So it this will not break in the future. Not that the SoC of the
> ipq8064 could more than 1GBit/s per port from what I know.)
>=20
Yes in v1 it was asked to add explicit reject for 45 Clause
> > +
> > +	miiaddr |=3D ((phy_addr << MII_ADDR_SHIFT) & MII_ADDR_MASK) |
> > +		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
> > +
> > +	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
> > +	usleep_range(10, 20);
> Yeeah, this looks a bit different. I did measure with a for-loop how =
many
> udelay(1); a operation took. I can't remember the exact values (I =
think it
> was "8", so the "
> 	SLEEPING FOR "A FEW" USECS ( < ~10us? ):
> 		* Use udelay" from the timers-howto.txt applies, right?
>=20
> But I know that "8" (again, 8 is the stand-in value) would seemed
> too bike-sheddy... And looks like it was since this got changed.
>=20
Will check this with more test but shouldn't cause any problem right?
> > +
> > +	err =3D ipq8064_mdio_wait_busy(priv);
> > +	if (err)
> > +		return err;
> > +
> > +	regmap_read(priv->base, MII_DATA_REG_ADDR, &ret_val);
> > +	return (int)ret_val;
> > +}
> > +
> > +static int
> > +ipq8064_mdio_write(struct mii_bus *bus, int phy_addr, int =
reg_offset,
> u16 data)
> > +{
> > +	struct ipq8064_mdio *priv =3D bus->priv;
> > +	u32 miiaddr =3D MII_WRITE | MII_BUSY | MII_CLKRANGE_250_300M;
> > +
> > +	/* Reject clause 45 */
> > +	if (reg_offset & MII_ADDR_C45)
> > +		return -EOPNOTSUPP;
> > +
> > +	regmap_write(priv->base, MII_DATA_REG_ADDR, data);
> > +
> > +	miiaddr |=3D ((phy_addr << MII_ADDR_SHIFT) & MII_ADDR_MASK) |
> > +		   ((reg_offset << MII_REG_SHIFT) & MII_REG_MASK);
> > +
> > +	regmap_write(priv->base, MII_ADDR_REG_ADDR, miiaddr);
> > +	usleep_range(10, 20);
> > +
> > +	return ipq8064_mdio_wait_busy(priv);
> > +}
> > +
> > +static int
> > +ipq8064_mdio_probe(struct platform_device *pdev)
> > +{
> > +	struct device_node *np =3D pdev->dev.of_node;
> > +	struct ipq8064_mdio *priv;
> > +	struct mii_bus *bus;
> > +	int ret;
> > +
> > +	bus =3D devm_mdiobus_alloc_size(&pdev->dev, sizeof(*priv));
> > +	if (!bus)
> > +		return -ENOMEM;
> > +
> > +	bus->name =3D "ipq8064_mdio_bus";
> > +	bus->read =3D ipq8064_mdio_read;
> > +	bus->write =3D ipq8064_mdio_write;
> > +	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(&pdev-
> >dev));
> > +	bus->parent =3D &pdev->dev;
> > +
> > +	priv =3D bus->priv;
> > +	priv->base =3D syscon_node_to_regmap(np);
> > +	if (IS_ERR(priv->base) && priv->base !=3D ERR_PTR(-EPROBE_DEFER))
> > +		priv->base =3D syscon_regmap_lookup_by_phandle(np,
> "master");
> > +
> > +	if (priv->base =3D=3D ERR_PTR(-EPROBE_DEFER)) {
> > +		return -EPROBE_DEFER;
> > +	} else if (IS_ERR(priv->base)) {
> > +		dev_err(&pdev->dev, "error getting syscon regmap,
> error=3D%pe\n",
> > +			priv->base);
> > +		return PTR_ERR(priv->base);
> > +	}
> > +
> > +	ret =3D of_mdiobus_register(bus, np);
> > +	if (ret)
> > +		return ret;
> > +
> > +	platform_set_drvdata(pdev, bus);
> > +	return 0;
> > +}
> > +
> > +static int
> > +ipq8064_mdio_remove(struct platform_device *pdev)
> > +{
> > +	struct mii_bus *bus =3D platform_get_drvdata(pdev);
> > +
> > +	mdiobus_unregister(bus);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct of_device_id ipq8064_mdio_dt_ids[] =3D {
> > +	{ .compatible =3D "qcom,ipq8064-mdio" },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(of, ipq8064_mdio_dt_ids);
> > +
> > +static struct platform_driver ipq8064_mdio_driver =3D {
> > +	.probe =3D ipq8064_mdio_probe,
> > +	.remove =3D ipq8064_mdio_remove,
> > +	.driver =3D {
> > +		.name =3D "ipq8064-mdio",
> > +		.of_match_table =3D ipq8064_mdio_dt_ids,
> > +	},
> > +};
> > +
> > +module_platform_driver(ipq8064_mdio_driver);
> > +
> > +MODULE_DESCRIPTION("Qualcomm IPQ8064 MDIO interface driver");
> > +MODULE_AUTHOR("Christian Lamparter <chunkeey@gmail.com>");
> @Mr. Smith: Don't you want to add yourself there (and in the =
boilerplate)
> as well then?
>=20
Since you mainly write the driver I thought it wasn't good to take =
credits for it.
If you are find with it, I will add also mine.
> > +MODULE_LICENSE("GPL");
> >
>=20
> Cheers and good night,
> Christian
>=20
> ---
> [0]
> =
<https://git.openwrt.org/?p=3Dopenwrt/staging/chunkeey.git;a=3Dblob;f=3Dt=
arge
> t/linux/ipq806x/patches-4.19/700-net-mdio-add-ipq8064-mdio-
> driver.patch;h=3D6f25b895cacb34b7fcf3e275c15ab26e25252fa8;hb=3D103474
> 1b8735608b022d55b08df34d4cff423b46>
>=20
>=20
>=20


