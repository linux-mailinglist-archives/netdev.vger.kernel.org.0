Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A8245E3D6
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 02:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239050AbhKZBDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 20:03:41 -0500
Received: from mail-db8eur05on2046.outbound.protection.outlook.com ([40.107.20.46]:15745
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238359AbhKZBBl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 20:01:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l9e22Lidih3CWeMwZojWB5rV/5XU9jjKjNKAsUNLJ/ObE2sDyKgeVYhI//xe3SOtzE1xArAGmuv8PaaPoNTU8duva8sGHWy+OmO/Bd8UGmrc79sqWGsjfclS5lLfJRf8ztrWLSMndmc5E+8xlBXBWJV0L9cbP8xcuNJ/Vg2/PIWqOQfueWGT0/4Hho5EIhvGSjv2JjNwb32NaoXR4kFDqzP9+exH5YHnQ3UGEeD/Cds7Vd1c4ebXSs2hfsM3KFjWMBR9baALCMATzodXBKdQwrgEneO8jSrMeAr5d+q3Aw51EtBtGwzfjcUEPg/SOJwZD+dQ/Fnu6JLTAyfqFRXxjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rl9z9fMT+J/nskr0X/74ThS/Ysi10XQvPiAH6A7sOD8=;
 b=TlJbO5tPlHJt98gqT5fzsJXvy+muZ7LtWlgmjCNwH4kRSq/VgDClz0+9ELUaR2q2Jom4pu1na2SoEEIxcxL149XUEXH3MIffWZikroCGvzhu5R5tNo3RInZmkUOCRKr/ev8zzqH3HH6LspQ34JkUnloZhpv5k9Eao/sngUAxfW4Wlh64zUu62CI84+LIfEAA7WWbRjpDHH/RZ1S0X8WwrSzRWi8en8AjlXm/5tg4n9s34PO+GCO60HK1uivkMGg5KDKCWT+pgVEJ9Md0wKbla/31xvctj3UAZzgZCoe1xWLx3wZryZkmAJOBKU0/75FFHr5CmEbQAhM5oN8AaFb3Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rl9z9fMT+J/nskr0X/74ThS/Ysi10XQvPiAH6A7sOD8=;
 b=CQ9p7J4JiOxVL8EDyW8JcYSgwQwX+7HYE2iK1qnIGpvCR8skVs2KKqZFx3MbqLJIvkP9ZJEesLPwtXlm5WpckS4aZfOgcweLklY0bi2VRLDilZm82b8uNgF4Dm2lNvqVm6re+zEezmvgoV1pebQAfiDDWyMRyMG/O9A/mpYfois=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB4481.eurprd04.prod.outlook.com (2603:10a6:208:70::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Fri, 26 Nov
 2021 00:58:25 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208%6]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 00:58:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 net-next 3/3] net: dsa: ocelot: felix: utilize shared
 mscc-miim driver for indirect MDIO access
Thread-Topic: [PATCH v2 net-next 3/3] net: dsa: ocelot: felix: utilize shared
 mscc-miim driver for indirect MDIO access
Thread-Index: AQHX4jjkQZBGgXEJxkWfdqMtJqFeg6wU/PsA
Date:   Fri, 26 Nov 2021 00:58:25 +0000
Message-ID: <20211126005824.cu4oz64hlxgogr4q@skbuf>
References: <20211125201301.3748513-1-colin.foster@in-advantage.com>
 <20211125201301.3748513-4-colin.foster@in-advantage.com>
In-Reply-To: <20211125201301.3748513-4-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6356aae-1d5b-4dcc-7da0-08d9b077da0f
x-ms-traffictypediagnostic: AM0PR04MB4481:
x-microsoft-antispam-prvs: <AM0PR04MB4481E9832DABBC602C47F96CE0639@AM0PR04MB4481.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DhGgDOSWYACjZVxgq0PzCLbzcUkueG6Au2ZiG2PYAEoqaxFVPrVQHOwXqGes8lY8kKqEXLqC8Wv9tMNeYHs2/mtbeWu5mMMSMcaPfCsSgapXHvexvryTRqKI9QPZmCOeIktT0/5LU3xQeSF8Jgt4/Ir0pfsRRXU6IF9WKc5SChHmXmjulJfEB5VuIKuRkAVgNdn17vAjjKzxqbwY3Cl0WssunxxjqLeWusjqi8pNqGhB3feH75l5p8uend0B2njqEGk/yLApHF2Ekf+DKoiL4sd0X6LM4vPFjBfTcevjjJiJ+wbCiwR7FT4JlDnQjQqy6TUlXPChPwATLZxW4s0FD6mnwZP7cbL0D3Z5sIIpngkoTc/C5suUUx+j6f9DKRRFAWgLbWKkTVmcRbK5wpeYqSZ78NSudRrL6T5abPIYKRuCBo/mpU0UJHvTrspR984W3bSSmiK61sqFYdxiRhsFHGZj3ZyiduG/vlXMvUriISkHU4z0Y5DRbJEtMdu7ZxmkG0t6SlleZMsH4xtxQ8lU90CUf0gXNC8dIDmkRhK8YDLmm678en9kX0nww4TWNwUT39ezuMLUDhRliV0pURCQ+BJJG1iQ4o/uHEuBd3SJZFwWzivHDc6O5+xiE0TA/kBcpGDFSMIcNSUhb+kBswbgjCtoANzj0k69ny4+9iFyk1SopMz8QsJb8J9GYYWdXkEkf0k93J/CpGe1QTkFimL3kA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(33716001)(186003)(508600001)(83380400001)(66556008)(44832011)(66476007)(64756008)(6916009)(71200400001)(66946007)(66446008)(8676002)(7416002)(8936002)(76116006)(26005)(91956017)(54906003)(86362001)(316002)(122000001)(38070700005)(9686003)(6512007)(6506007)(4326008)(1076003)(6486002)(30864003)(5660300002)(38100700002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AXX1Bya3VA95yoztqRQ3aYfZ13sKOsNGKAp0ozDK7R2GnGmBcSwkpMIL1AXT?=
 =?us-ascii?Q?PLD3mqnNyRiWtoqJIpEKDgzukwH1+12yG2HfKE0PefJ/boYUh58XxG1no2Sf?=
 =?us-ascii?Q?OZsXDsNPM0ght7zK0b7ItWWTX5feRPA7rfvm09zZrvmDLzwQCkxi//WeFwzy?=
 =?us-ascii?Q?781xFSMoJrge/vAUxc915hycWB3/Wl8e8IaI05NCLyajHPWXvufOnXGbYf2g?=
 =?us-ascii?Q?3S3Ulx+22Pa4aUrsgoT/KP/C3GAEKwzs9Qa85rH9lSdtk33lJpwcYlVUnWGB?=
 =?us-ascii?Q?jyeUHcp/tXy0MiMt9swYpsOaadbzOlqyQ2KXLlkP/66zVrBIQrk1awhhnqCb?=
 =?us-ascii?Q?JmL4PEw8oQOk61hDFifZyP8iwK1fWGjLFSOQAZ+GWfyo+eeNmGBrI+IiCgL/?=
 =?us-ascii?Q?VxqIK1HfXFPsq/gKm1ZIozXmoEkyhQ04sLE40qSinxEIwi2hYLb1c2Rcxja5?=
 =?us-ascii?Q?dzda3Uo2Hw0Z+HSrvTBprsJNoSC4ocpRHtCoxHXYIZjp5B2FYfRib27Y2ZTe?=
 =?us-ascii?Q?Hcjln3UKJK0aePnL0AKq4af5xCbbSwaHF9RAluDnl1iOC1147Op9xLwIWHay?=
 =?us-ascii?Q?e5Ou/ShfR7nkc4sBSXDVdol2tQ7lq1D/5USTlZJooTumNjckZ31LnJmgv13j?=
 =?us-ascii?Q?61JeoYuImIFDmpfY4VVZNnAXNk0YqycDzP4LfNziTosSAZGYzIatIMXSmL5f?=
 =?us-ascii?Q?dLzc9eYFSQ+PeeKOvzc3oy3EmzcvC8KCk1b4nUZKvi9dIWgGQtZskey/DRt2?=
 =?us-ascii?Q?vaoFNVdNBrOfJ0VMxiP1ABKmepwB1dd7L9PJ3LBXC+8EHSq0gAHW0DOsANPQ?=
 =?us-ascii?Q?R29TCnOE2ZDoDqw9OdxG+DTqfU9McXRPYGzN2A05RKR8dxfmLZM/j25yncSD?=
 =?us-ascii?Q?x6eg6W5NLWOz3dyA0wNfWHQXuEZ5x8Wv0L+lSqqHiPa4ryjSKlZAAm0VzheE?=
 =?us-ascii?Q?fp0cmh0aNxcdVcw8QMwvPSI7+pSppbw/kqlVdBcn+SDhZUsURC4pZ+5fEWMO?=
 =?us-ascii?Q?lZnjDwFX6B+9sJs4rFKulf3pH2gQJN5dQEaj2jLi7mMoe1Ab4uOXH7JxNd8D?=
 =?us-ascii?Q?ClnPS3k98b1v69IYA1GpLUHkBRjKfstUgUpOhnu2HqyBUC14JMzuEgCeY7fI?=
 =?us-ascii?Q?L8aRR/Z8vZjPFGkjmUeKG2VQDu7yxjwTIAzj568S/k+4n9gjVxagq/PBHwse?=
 =?us-ascii?Q?jfhsBDI5kZ+tRiA0jANM2DCEb0Tjv0UE+QAcv96I6EA8XvvDvqLNdslyLXhV?=
 =?us-ascii?Q?vdpbTProGrXSJ5zuMXcmS7G9vnkDrHuFsceUCBXhRwe1/9V7B+63XvCms9zS?=
 =?us-ascii?Q?50WnUToybUR8SA2zUZVdOr0oRo76G4MZTLPYv/gvKRxKc3osN33zGvluCJ4Z?=
 =?us-ascii?Q?DVyZVcGApBV8gRnAh8i/Yj0oLZtuzpY4b3RxwCo2Hm6zo+EdBoXUKp2VINq2?=
 =?us-ascii?Q?U5/8OwyliG9VA9c0LOlx2pW9/4hHfmLQku7xAuf1FkPi8/AWt4DUwi6IZVTc?=
 =?us-ascii?Q?FYVFbpKagSHRbx70JfhDjJ+ugsQxGyHdeaNsPq9RGeUWsMHl68fH7KVMXdma?=
 =?us-ascii?Q?ATpW2E8bVE4KVs0mwQCVpvHNSNSMsx0XVxLQFp3EocQVV8AE51m7qNM+7/U/?=
 =?us-ascii?Q?Q04PyQb6nDp49js4jfxFyFA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A3082BB182EAB64393D9C303ADCABED4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6356aae-1d5b-4dcc-7da0-08d9b077da0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 00:58:25.4451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eYIUSkCG8juSDSzrXNL2Qp0dNzjmr3QW3hIUF//ca/4V3UXg48mmGpTc236qvfzIsS61cLgbC7k0PLTMsjFDBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4481
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 12:13:01PM -0800, Colin Foster wrote:
> Switch to a shared MDIO access implementation by way of the mdio-mscc-mii=
m
> driver.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

I'm sorry, I still wasn't able to boot the T1040RDB to test these, it
looks like it's bricked or something. I'll try to do more debugging
tomorrow.

>  drivers/net/dsa/ocelot/Kconfig           |   1 +
>  drivers/net/dsa/ocelot/seville_vsc9953.c | 103 +++--------------------
>  drivers/net/mdio/mdio-mscc-miim.c        |  40 ++++++---
>  include/linux/mdio/mdio-mscc-miim.h      |  20 +++++
>  include/soc/mscc/ocelot.h                |   1 +
>  5 files changed, 61 insertions(+), 104 deletions(-)
>  create mode 100644 include/linux/mdio/mdio-mscc-miim.h
>=20
> diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kcon=
fig
> index 9948544ba1c4..220b0b027b55 100644
> --- a/drivers/net/dsa/ocelot/Kconfig
> +++ b/drivers/net/dsa/ocelot/Kconfig
> @@ -21,6 +21,7 @@ config NET_DSA_MSCC_SEVILLE
>  	depends on NET_VENDOR_MICROSEMI
>  	depends on HAS_IOMEM
>  	depends on PTP_1588_CLOCK_OPTIONAL
> +	select MDIO_MSCC_MIIM
>  	select MSCC_OCELOT_SWITCH_LIB
>  	select NET_DSA_TAG_OCELOT_8021Q
>  	select NET_DSA_TAG_OCELOT
> diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/o=
celot/seville_vsc9953.c
> index db124922c374..41ec60a1fc96 100644
> --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> @@ -6,19 +6,14 @@
>  #include <soc/mscc/ocelot_vcap.h>
>  #include <soc/mscc/ocelot_sys.h>
>  #include <soc/mscc/ocelot.h>
> +#include <linux/mdio/mdio-mscc-miim.h>
> +#include <linux/of_mdio.h>
>  #include <linux/of_platform.h>
>  #include <linux/pcs-lynx.h>
>  #include <linux/dsa/ocelot.h>
>  #include <linux/iopoll.h>
> -#include <linux/of_mdio.h>
>  #include "felix.h"
> =20
> -#define MSCC_MIIM_CMD_OPR_WRITE			BIT(1)
> -#define MSCC_MIIM_CMD_OPR_READ			BIT(2)
> -#define MSCC_MIIM_CMD_WRDATA_SHIFT		4
> -#define MSCC_MIIM_CMD_REGAD_SHIFT		20
> -#define MSCC_MIIM_CMD_PHYAD_SHIFT		25
> -#define MSCC_MIIM_CMD_VLD			BIT(31)
>  #define VSC9953_VCAP_POLICER_BASE		11
>  #define VSC9953_VCAP_POLICER_MAX		31
>  #define VSC9953_VCAP_POLICER_BASE2		120
> @@ -862,7 +857,6 @@ static struct vcap_props vsc9953_vcap_props[] =3D {
>  #define VSC9953_INIT_TIMEOUT			50000
>  #define VSC9953_GCB_RST_SLEEP			100
>  #define VSC9953_SYS_RAMINIT_SLEEP		80
> -#define VCS9953_MII_TIMEOUT			10000
> =20
>  static int vsc9953_gcb_soft_rst_status(struct ocelot *ocelot)
>  {
> @@ -882,82 +876,6 @@ static int vsc9953_sys_ram_init_status(struct ocelot=
 *ocelot)
>  	return val;
>  }
> =20
> -static int vsc9953_gcb_miim_pending_status(struct ocelot *ocelot)
> -{
> -	int val;
> -
> -	ocelot_field_read(ocelot, GCB_MIIM_MII_STATUS_PENDING, &val);
> -
> -	return val;
> -}
> -
> -static int vsc9953_gcb_miim_busy_status(struct ocelot *ocelot)
> -{
> -	int val;
> -
> -	ocelot_field_read(ocelot, GCB_MIIM_MII_STATUS_BUSY, &val);
> -
> -	return val;
> -}
> -
> -static int vsc9953_mdio_write(struct mii_bus *bus, int phy_id, int regnu=
m,
> -			      u16 value)
> -{
> -	struct ocelot *ocelot =3D bus->priv;
> -	int err, cmd, val;
> -
> -	/* Wait while MIIM controller becomes idle */
> -	err =3D readx_poll_timeout(vsc9953_gcb_miim_pending_status, ocelot,
> -				 val, !val, 10, VCS9953_MII_TIMEOUT);
> -	if (err) {
> -		dev_err(ocelot->dev, "MDIO write: pending timeout\n");
> -		goto out;
> -	}
> -
> -	cmd =3D MSCC_MIIM_CMD_VLD | (phy_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> -	      (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> -	      (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
> -	      MSCC_MIIM_CMD_OPR_WRITE;
> -
> -	ocelot_write(ocelot, cmd, GCB_MIIM_MII_CMD);
> -
> -out:
> -	return err;
> -}
> -
> -static int vsc9953_mdio_read(struct mii_bus *bus, int phy_id, int regnum=
)
> -{
> -	struct ocelot *ocelot =3D bus->priv;
> -	int err, cmd, val;
> -
> -	/* Wait until MIIM controller becomes idle */
> -	err =3D readx_poll_timeout(vsc9953_gcb_miim_pending_status, ocelot,
> -				 val, !val, 10, VCS9953_MII_TIMEOUT);
> -	if (err) {
> -		dev_err(ocelot->dev, "MDIO read: pending timeout\n");
> -		goto out;
> -	}
> -
> -	/* Write the MIIM COMMAND register */
> -	cmd =3D MSCC_MIIM_CMD_VLD | (phy_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> -	      (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) | MSCC_MIIM_CMD_OPR_READ;
> -
> -	ocelot_write(ocelot, cmd, GCB_MIIM_MII_CMD);
> -
> -	/* Wait while read operation via the MIIM controller is in progress */
> -	err =3D readx_poll_timeout(vsc9953_gcb_miim_busy_status, ocelot,
> -				 val, !val, 10, VCS9953_MII_TIMEOUT);
> -	if (err) {
> -		dev_err(ocelot->dev, "MDIO read: busy timeout\n");
> -		goto out;
> -	}
> -
> -	val =3D ocelot_read(ocelot, GCB_MIIM_MII_DATA);
> -
> -	err =3D val & 0xFFFF;
> -out:
> -	return err;
> -}
> =20
>  /* CORE_ENA is in SYS:SYSTEM:RESET_CFG
>   * MEM_INIT is in SYS:SYSTEM:RESET_CFG
> @@ -1101,16 +1019,15 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *=
ocelot)
>  		return -ENOMEM;
>  	}
> =20
> -	bus =3D devm_mdiobus_alloc(dev);
> -	if (!bus)
> -		return -ENOMEM;
> +	rc =3D mscc_miim_setup(dev, &bus, "VSC9953 internal MDIO bus",
> +			     ocelot->targets[GCB],
> +			     ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK],
> +			     NULL, 0);
> =20
> -	bus->name =3D "VSC9953 internal MDIO bus";
> -	bus->read =3D vsc9953_mdio_read;
> -	bus->write =3D vsc9953_mdio_write;
> -	bus->parent =3D dev;
> -	bus->priv =3D ocelot;
> -	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
> +	if (rc) {
> +		dev_err(dev, "failed to setup MDIO bus\n");
> +		return rc;
> +	}
> =20
>  	/* Needed in order to initialize the bus mutex lock */
>  	rc =3D of_mdiobus_register(bus, NULL);
> diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-ms=
cc-miim.c
> index 5a9c0b311bdb..9eed6b597f21 100644
> --- a/drivers/net/mdio/mdio-mscc-miim.c
> +++ b/drivers/net/mdio/mdio-mscc-miim.c
> @@ -10,6 +10,7 @@
>  #include <linux/io.h>
>  #include <linux/iopoll.h>
>  #include <linux/kernel.h>
> +#include <linux/mdio/mdio-mscc-miim.h>
>  #include <linux/module.h>
>  #include <linux/of_mdio.h>
>  #include <linux/phy.h>
> @@ -37,7 +38,9 @@
> =20
>  struct mscc_miim_dev {
>  	struct regmap *regs;
> +	int mii_status_offset;
>  	struct regmap *phy_regs;
> +	int phy_reset_offset;
>  };
> =20
>  /* When high resolution timers aren't built-in: we can't use usleep_rang=
e() as
> @@ -56,7 +59,8 @@ static int mscc_miim_status(struct mii_bus *bus)
>  	struct mscc_miim_dev *miim =3D bus->priv;
>  	int val, ret;
> =20
> -	ret =3D regmap_read(miim->regs, MSCC_MIIM_REG_STATUS, &val);
> +	ret =3D regmap_read(miim->regs,
> +			  MSCC_MIIM_REG_STATUS + miim->mii_status_offset, &val);
>  	if (ret < 0) {
>  		WARN_ONCE(1, "mscc miim status read error %d\n", ret);
>  		return ret;
> @@ -93,7 +97,9 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_=
id, int regnum)
>  	if (ret)
>  		goto out;
> =20
> -	ret =3D regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
> +	ret =3D regmap_write(miim->regs,
> +			   MSCC_MIIM_REG_CMD + miim->mii_status_offset,
> +			   MSCC_MIIM_CMD_VLD |
>  			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
>  			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
>  			   MSCC_MIIM_CMD_OPR_READ);
> @@ -107,8 +113,8 @@ static int mscc_miim_read(struct mii_bus *bus, int mi=
i_id, int regnum)
>  	if (ret)
>  		goto out;
> =20
> -	ret =3D regmap_read(miim->regs, MSCC_MIIM_REG_DATA, &val);
> -
> +	ret =3D regmap_read(miim->regs,
> +			  MSCC_MIIM_REG_DATA + miim->mii_status_offset, &val);

I'd be tempted to create one separate regmap for DEVCPU_MIIM which
starts precisely at 0x8700AC, and therefore does not need adjustment
with an offset here. What do you think?

>  	if (ret < 0) {
>  		WARN_ONCE(1, "mscc miim read data reg error %d\n", ret);
>  		goto out;
> @@ -134,7 +140,9 @@ static int mscc_miim_write(struct mii_bus *bus, int m=
ii_id,
>  	if (ret < 0)
>  		goto out;
> =20
> -	ret =3D regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_VLD |
> +	ret =3D regmap_write(miim->regs,
> +			   MSCC_MIIM_REG_CMD + miim->mii_status_offset,
> +			   MSCC_MIIM_CMD_VLD |
>  			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
>  			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
>  			   (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
> @@ -149,16 +157,19 @@ static int mscc_miim_write(struct mii_bus *bus, int=
 mii_id,
>  static int mscc_miim_reset(struct mii_bus *bus)
>  {
>  	struct mscc_miim_dev *miim =3D bus->priv;
> +	int offset =3D miim->phy_reset_offset;
>  	int ret;
> =20
>  	if (miim->phy_regs) {
> -		ret =3D regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0);
> +		ret =3D regmap_write(miim->phy_regs,
> +				   MSCC_PHY_REG_PHY_CFG + offset, 0);
>  		if (ret < 0) {
>  			WARN_ONCE(1, "mscc reset set error %d\n", ret);
>  			return ret;
>  		}
> =20
> -		ret =3D regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0x1ff);
> +		ret =3D regmap_write(miim->phy_regs,
> +				   MSCC_PHY_REG_PHY_CFG + offset, 0x1ff);
>  		if (ret < 0) {
>  			WARN_ONCE(1, "mscc reset clear error %d\n", ret);
>  			return ret;
> @@ -176,8 +187,9 @@ static const struct regmap_config mscc_miim_regmap_co=
nfig =3D {
>  	.reg_stride	=3D 4,
>  };
> =20
> -static int mscc_miim_setup(struct device *dev, struct mii_bus **pbus,
> -			   struct regmap *mii_regmap, struct regmap *phy_regmap)
> +int mscc_miim_setup(struct device *dev, struct mii_bus **pbus, const cha=
r *name,
> +		    struct regmap *mii_regmap, int status_offset,
> +		    struct regmap *phy_regmap, int reset_offset)
>  {
>  	struct mscc_miim_dev *miim;
>  	struct mii_bus *bus;
> @@ -186,7 +198,7 @@ static int mscc_miim_setup(struct device *dev, struct=
 mii_bus **pbus,
>  	if (!bus)
>  		return -ENOMEM;
> =20
> -	bus->name =3D "mscc_miim";
> +	bus->name =3D name;
>  	bus->read =3D mscc_miim_read;
>  	bus->write =3D mscc_miim_write;
>  	bus->reset =3D mscc_miim_reset;
> @@ -198,10 +210,15 @@ static int mscc_miim_setup(struct device *dev, stru=
ct mii_bus **pbus,
>  	*pbus =3D bus;
> =20
>  	miim->regs =3D mii_regmap;
> +	miim->mii_status_offset =3D status_offset;
>  	miim->phy_regs =3D phy_regmap;
> +	miim->phy_reset_offset =3D reset_offset;

The reset_offset is unused. Will vsc7514_spi need it?

> +
> +	*pbus =3D bus;
> =20
>  	return 0;
>  }
> +EXPORT_SYMBOL(mscc_miim_setup);
> =20
>  static int mscc_miim_probe(struct platform_device *pdev)
>  {
> @@ -238,7 +255,8 @@ static int mscc_miim_probe(struct platform_device *pd=
ev)
>  		return PTR_ERR(dev->phy_regs);
>  	}
> =20
> -	ret =3D mscc_miim_setup(&pdev->dev, &bus, mii_regmap, phy_regmap);
> +	ret =3D mscc_miim_setup(&pdev->dev, &bus, "mscc_miim", mii_regmap, 0,
> +			      phy_regmap, 0);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "Unable to setup the MDIO bus\n");
>  		return ret;
> diff --git a/include/linux/mdio/mdio-mscc-miim.h b/include/linux/mdio/mdi=
o-mscc-miim.h
> new file mode 100644
> index 000000000000..69a023cf8991
> --- /dev/null
> +++ b/include/linux/mdio/mdio-mscc-miim.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
> +/*
> + * Driver for the MDIO interface of Microsemi network switches.
> + *
> + * Author: Colin Foster <colin.foster@in-advantage.com>
> + * Copyright (C) 2021 Innovative Advantage
> + */
> +#ifndef MDIO_MSCC_MIIM_H
> +#define MDIO_MSCC_MIIM_H
> +
> +#include <linux/device.h>
> +#include <linux/phy.h>
> +#include <linux/regmap.h>
> +
> +int mscc_miim_setup(struct device *device, struct mii_bus **bus,
> +		    const char *name, struct regmap *mii_regmap,
> +		    int status_offset, struct regmap *phy_regmap,
> +		    int reset_offset);
> +
> +#endif
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 89d17629efe5..9d6fe8ce9dd1 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -398,6 +398,7 @@ enum ocelot_reg {
>  	GCB_MIIM_MII_STATUS,
>  	GCB_MIIM_MII_CMD,
>  	GCB_MIIM_MII_DATA,
> +	GCB_PHY_PHY_CFG,

This appears extraneous, you are still using MSCC_PHY_REG_PHY_CFG.

>  	DEV_CLOCK_CFG =3D DEV_GMII << TARGET_OFFSET,
>  	DEV_PORT_MISC,
>  	DEV_EVENTS,
> --=20
> 2.25.1
>=
