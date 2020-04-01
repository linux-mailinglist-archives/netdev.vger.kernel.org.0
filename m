Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF01219A999
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 12:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbgDAKau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 06:30:50 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:40099
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728087AbgDAKau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 06:30:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/knvA48DeBN2n/4IFhC3XKN6zNIfkvAz+6nque9kg+u064xmtqjC1A9api6wdkTCAmkpeL2ACi608i6GKTO+SnUjBVlM1F9dSbiPIHDJwKDkg5GN0eKKsx4wKZkDWnTxI6HC6RN0sN+KtSv3udLSyqDrzoaeYT6IU7kli37PouHuJneUynUsGksCEIf7cdRIyU8iSgDA14uMJVPCz168rD49PUk565NYZ0tovgTDujLiEnvrvq9knrjizU1F+1RntXEAw1dTMrgD79dLSAeq93y/ZVMt43TBDHEzHnGSbxLqmI+EFPaWe2Ewid+BPiQUdJhhWLwQeuOHrkgZ4SqYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Prvms0shENhSG2DQpYtaR8BnnyxSoTZMViHOEB9g3jo=;
 b=dByHQSTuDm0KeOSFhp4oNrX/BeBUCWFx25ZyEUTUF2MooIFzLn3Rgzt1aCd587RfzD6TLQs38wNt3X1r7K9+7kbCeg7c3QW7VRI9oe8eSoAUdAXQpOKQBhRrAfLsEbW6FWlaZPPeaXC4CE79u5YKfVWhX7Rc/Xi0RglirOkEVNyn4pWbbXGgb58qNPLAegc4LKzNg4T+voiR+XWbYxpX4CvfetZA99dthLKeTZD9BnMztduElS5cJhyqHFvs2dsRmQNY8Drc6PGOUT0r05YFyiCbfv25vpIHwlbRQLS+id1WbwvmC7qhenHbl28s3q1/uETaVqKp66ZaAQQYuJ/nfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Prvms0shENhSG2DQpYtaR8BnnyxSoTZMViHOEB9g3jo=;
 b=AIZSdzUrZsv/p5vdm04K9x6SBZUgt2LaEexQ5SGzvAAVUhtNDlrKksVE3lQFpTbUQwT/1il+oMlUJRwT0fo+z1QFrtiRf7o1A9R5qKsy5Kik15YpFwoGSuakRA3mrXS+b/rLBYr1A0IT6Pntt8kLr/Uwy7C71MQa0cxVoTw8FCA=
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com (52.133.240.149) by
 DB8PR04MB6684.eurprd04.prod.outlook.com (20.179.249.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Wed, 1 Apr 2020 10:30:45 +0000
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::e44e:f867:d67:e901]) by DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::e44e:f867:d67:e901%2]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 10:30:45 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Baruch Siach <baruch@tkos.co.il>,
        Russell King <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Shmuel Hazan <sh@tkos.co.il>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: [PATCH] net: phy: marvell10g: add firmware load support
Thread-Topic: [PATCH] net: phy: marvell10g: add firmware load support
Thread-Index: AQHWB4WZmiAHbtx9oEaZfhbuYbUB0ahkCkwA
Date:   Wed, 1 Apr 2020 10:30:45 +0000
Message-ID: <DB8PR04MB6828927ED67036524362F369E0C90@DB8PR04MB6828.eurprd04.prod.outlook.com>
References: <16e4a15e359012fc485d22c7e413a129029fbd0f.1585676858.git.baruch@tkos.co.il>
In-Reply-To: <16e4a15e359012fc485d22c7e413a129029fbd0f.1585676858.git.baruch@tkos.co.il>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [5.12.96.237]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 64d7000c-8b4c-4422-cd65-08d7d627bccc
x-ms-traffictypediagnostic: DB8PR04MB6684:
x-microsoft-antispam-prvs: <DB8PR04MB66846F4A2C1860E9E85C0E79E0C90@DB8PR04MB6684.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03607C04F0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6828.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(6506007)(66556008)(66446008)(66946007)(9686003)(55016002)(33656002)(186003)(7696005)(64756008)(26005)(44832011)(2906002)(52536014)(478600001)(81156014)(8936002)(66476007)(76116006)(110136005)(54906003)(71200400001)(8676002)(86362001)(4326008)(81166006)(5660300002)(316002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JAXfvBQcDr8CX+YYz5EhWvSwEJTHILDnhEbUc3/UIrBQTyyPSWHpEqqAnASpHZTUtNUZ9wL+auMiJW6VPavTPg++Dx85gyAEanSwXCcs0z5HCz7y9F7PcHBSLn46AKtFLfXdWGDPNpEKD+F3QMlgPgSBlM8xy1/JkzSoTvXXRR/zC32EdIRYI+LSA9rTyNwf0t8wnkHxRDcZwhcTbdZ0yfby9GXrP2Icl+tR0s5AHB3xWUAuHp9UCp3hvcdCmIv+w09OTj3kWVIo1PLoxgM3lMDmhBhJkfCHSllU6r+8JxDi0x39t8asyhDoVhEFnvZkiPmMmbJPTPERookSuUgr6daud2/ubD0BN7nb/5YYqqeqA4biVeb68xiT7szaWRQpBI13LFVcdaKsdr8o7U7To2ch/QDn6cwIsaYTWto9nOsIEGAu01DTil0wmHQxj/De
x-ms-exchange-antispam-messagedata: WX4Vc2jxXEd2d2n0yjMldj2rgJr8JkhrXxiCa2w6EcX6uKHNHP6zyB3a50ZoSmfZQxBwjC+cHQ3b0Gs2uNdq56LJhU2nqFm5LBByHi9cE1wHCAMZa5OpclaU4h/EQyBDlhTbVQNv6OhHHNnJtUqmGg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64d7000c-8b4c-4422-cd65-08d7d627bccc
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2020 10:30:45.5055
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /3sdQe+XQqDyAojGqtbHYFM+gSVCA8a1MX7CBwbTWkAmZCQ2NTJNzMb/eRJX+X4ieXKZiQxXAbZZ1IgUy8Jztw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6684
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH] net: phy: marvell10g: add firmware load support
>=20
> When Marvell 88X3310 and 88E2110 hardware configuration SPI_CONFIG strap
> bit is pulled up, the host must load firmware to the PHY after reset.
> Add support for loading firmware.
>=20
> Firmware files are available from Marvell under NDA.
>=20
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  drivers/net/phy/marvell10g.c | 114 +++++++++++++++++++++++++++++++++++
>  1 file changed, 114 insertions(+)
>=20
> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c =
index
> 64c9f3bba2cd..9572426ba1c6 100644
> --- a/drivers/net/phy/marvell10g.c
> +++ b/drivers/net/phy/marvell10g.c
> @@ -27,13 +27,28 @@
>  #include <linux/marvell_phy.h>
>  #include <linux/phy.h>
>  #include <linux/sfp.h>
> +#include <linux/firmware.h>
> +#include <linux/delay.h>
>=20

[snip]

> +
> +static void mv3310_report_firmware_rev(struct phy_device *phydev) {
> +	int rev1, rev2;
> +
> +	rev1 =3D phy_read_mmd(phydev, MDIO_MMD_PMAPMD,
> MV_PMA_FW_REV1);
> +	rev2 =3D phy_read_mmd(phydev, MDIO_MMD_PMAPMD,
> MV_PMA_FW_REV2);
> +	if (rev1 < 0 || rev2 < 0)
> +		return;
> +
> +	dev_info(&phydev->mdio.dev, "Loaded firmware revision
> %d.%d.%d.%d",
> +			(rev1 & 0xff00) >> 8, rev1 & 0x00ff,
> +			(rev2 & 0xff00) >> 8, rev2 & 0x00ff); }
> +
> +static int mv3310_load_firmware(struct phy_device *phydev) {
> +	const struct firmware *fw_entry;
> +	char *fw_file;
> +	int ret;
> +
> +	switch (phydev->drv->phy_id) {
> +	case MARVELL_PHY_ID_88X3310:
> +		fw_file =3D "mrvl/x3310fw.hdr";
> +		break;
> +	case MARVELL_PHY_ID_88E2110:
> +		fw_file =3D "mrvl/e21x0fw.hdr";
> +		break;

Couldn't the static selection of the firmware be replaced by a new generic=
=20
property in the PHY's device node? This would help to just have a solution
in place that works even if the firmware version sees any upgrades or
new filenames are added.

Also, from a generic standpoint, having a 'firmware-name' property in the
device node would also be of help in a situation when the exact same PHY
is integrated twice on the same board but with different MII side link
modes thus different firmware images.
This is typically the case for Aquantia PHYs.

Ioana

> +	default:
> +		dev_warn(&phydev->mdio.dev, "unknown firmware file for %s
> PHY",
> +				phydev->drv->name);
> +		return -EINVAL;
> +	}
> +
> +	ret =3D request_firmware(&fw_entry, fw_file, &phydev->mdio.dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Firmware size must be larger than header, and even */
> +	if (fw_entry->size <=3D MV_FIRMWARE_HEADER_SIZE ||
> +			(fw_entry->size % 2) !=3D 0) {
> +		dev_err(&phydev->mdio.dev, "firmware file invalid");
> +		return -EINVAL;
> +	}
> +
> +	/* Clear checksum register */
> +	phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_RAM_CHECKSUM);
> +
> +	/* Set firmware load address */
> +	phy_write_mmd(phydev, MDIO_MMD_PCS, MV_PCS_FW_LOW_WORD,
> 0);
> +	phy_write_mmd(phydev, MDIO_MMD_PCS, MV_PCS_FW_HIGH_WORD,
> 0x0010);
> +
> +	ret =3D mv3310_write_firmware(phydev,
> +			fw_entry->data + MV_FIRMWARE_HEADER_SIZE,
> +			fw_entry->size - MV_FIRMWARE_HEADER_SIZE);
> +	if (ret < 0)
> +		return ret;
> +
> +	phy_modify_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_BOOT,
> +			MV_PMA_BOOT_FW_LOADED,
> MV_PMA_BOOT_FW_LOADED);
> +
> +	release_firmware(fw_entry);
> +
> +	msleep(100);
> +	mv3310_report_firmware_rev(phydev);
> +
> +	return 0;
> +}
> +
>  static const struct sfp_upstream_ops mv3310_sfp_ops =3D {
>  	.attach =3D phy_sfp_attach,
>  	.detach =3D phy_sfp_detach,
> @@ -249,6 +357,12 @@ static int mv3310_probe(struct phy_device *phydev)
>  		return -ENODEV;
>  	}
>=20
> +	if ((ret & MV_PMA_BOOT_PROGRESS_MASK) =3D=3D
> MV_PMA_BOOT_WAITING) {
> +		ret =3D mv3310_load_firmware(phydev);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
>  	priv =3D devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
>  	if (!priv)
>  		return -ENOMEM;
> --
> 2.25.1

