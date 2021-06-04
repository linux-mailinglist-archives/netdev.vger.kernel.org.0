Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DD839B84D
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 13:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhFDLxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 07:53:45 -0400
Received: from mail-db8eur05on2056.outbound.protection.outlook.com ([40.107.20.56]:26145
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229682AbhFDLxo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 07:53:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PkfXpKLeomiQetrRFaMFaREpa0QsYclAvAFerVpj+52DYUjew/PzxPmWn6BX+6M6qw7Px4lALeW1a6QNBm/jtZn5Xpw2jqFbHeRJzuMII/Gz93JoQykRQE6uNkefVzZj/kqHbwTRlmpSITAiCpe9782JoUr4RIr6MMDAvpi6/Ua9fcr496UH79Kv0l87Ji664SmxqviK9Eb4yiL3UmgJ171oG3o0Ng2VEh4gFjH7FtfEpHGvQP84dBx/ghu+wZ+4IraaaVcqw2d/651gHJiVhc6Ojfk49BXHZA04asXMEUHMUFbYDh8pFhu5ZhtAxXHRIED5InkWdFlXePBAbbi4Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nid/gSTZBxwkOdl1/i1A4EpZCnR+dHqf2c7hiVbfaEg=;
 b=ZlMCapKt7RKhUcNhRqbpDf8OxONG2yYECrkDdqzoxUFB6eEc/F+7L2efd/iWFl2gkjRZfodshvxDrdvraN0Xr4mO6ljNa7LbVnuwsFQbPVs1RibdYKSmTjOXVb3kzLrzL1uvS4xNC5R3lFBzJlHOiEB96b9s2haePPeOFcKa2pJ/XEwMOqLYi9cpS1W1nDO7GRsnCznh+IvjlDja650ygPt6qONh5iqkYATyuVZoIPu1f/6Y6XcwyHknCF7A5ZOX0YZiyaD7OXS0zTFXawlHTInrSy4Dr7+e8aipVzjTkfWes6Dpko79lruqqkuvFplsasr6+HaiLZoOQozfHB9JTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nid/gSTZBxwkOdl1/i1A4EpZCnR+dHqf2c7hiVbfaEg=;
 b=kBApStJXgHXDlUt4S6nOOoe6sG9aRVyb9yNxJ8zOstg7M4x/6z+dL7UXy3551DSRkDKJKmkeKItRgUulPhsG0QcKw/dHODGJ+6XkvyKlPP+Rq543eEf+n7bdauREk/+v37r0YR3TzOpvTl4ZpZhh038OY6qtYbvmk90rckU3e58=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2798.eurprd04.prod.outlook.com (2603:10a6:800:ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Fri, 4 Jun
 2021 11:51:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 11:51:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
CC:     "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "weifeng.voon@intel.com" <weifeng.voon@intel.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "tee.min.tan@intel.com" <tee.min.tan@intel.com>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "vee.khee.wong@intel.com" <vee.khee.wong@intel.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH net-next v5 1/3] net: stmmac: split xPCS setup from
 mdio register
Thread-Topic: [RESEND PATCH net-next v5 1/3] net: stmmac: split xPCS setup
 from mdio register
Thread-Index: AQHXWTENJC5Z8so33US6hBvpd1LPX6sDvaOA
Date:   Fri, 4 Jun 2021 11:51:54 +0000
Message-ID: <20210604115153.pux7qbrybs4ckg4j@skbuf>
References: <20210604105733.31092-1-michael.wei.hong.sit@intel.com>
 <20210604105733.31092-2-michael.wei.hong.sit@intel.com>
In-Reply-To: <20210604105733.31092-2-michael.wei.hong.sit@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.52.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ce3843e-57f6-4f96-0640-08d9274f2664
x-ms-traffictypediagnostic: VI1PR0402MB2798:
x-microsoft-antispam-prvs: <VI1PR0402MB2798974EFE662ED80EE86C49E03B9@VI1PR0402MB2798.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LhkHOnMfc9XG4AfI47kr1jKtLivY17nA82tOlk5veybC66GzG5wMxEBTM3luty3KbDc0ijlw953QRxc+uXVxbyuY2rC30IhfFeqzM1z5JUk+3C+4hMJmSVjjHOkvPFhEHilIHFRuR0tx1b7PpyZ0Og3nFyMeFIkmgQ9CW6+E5VGG/Aw9VK5NXyiammMvSNeewcRJn7TciRsTbSIyM6aBXijhUHbD2/M8rQFOhZ7UqCLOI9xbfR3XKv9SMROKbKtK8J0vQcq3L4Amdk9OUq/kKApuGZPWF9OIdpwJTAzfUPmBpox6qR3DUkfwDK0uDK1NNj+vXeenOL+ZfpFYyGOOeM8DQ+dQSVvGlJdesXGwqRB/iUU4l0yX2jYQJ58b7QTTOzIyt7+RBnKE2TuGjdrGs5l73B5KIOu/PoH/znLnVODEQlloPhfpFI91fMLPmeuTvhzagB4qdnIAMGSl/Rl7on68TX7AKfmGjsK/M64fvF9VJIJDPspH6wTPyFZk+lS9j+TlY/wxmrGpBFIrntVspwnlY2/YWz2nvsB1OrJpIctEOR7wvrn2ejtkiVALvZGA4hVYUQLnkzq+qRGgPiQOWwPFchAk179n0hCtOJZKLMs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(38100700002)(122000001)(4326008)(6512007)(9686003)(7416002)(26005)(478600001)(186003)(44832011)(8936002)(2906002)(316002)(83380400001)(91956017)(71200400001)(6506007)(54906003)(86362001)(64756008)(66446008)(66476007)(66556008)(66946007)(8676002)(6916009)(6486002)(33716001)(76116006)(5660300002)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?1+KLBPmYOQdWDMqvJDfqgFDeDdK5AcagKMun3oF5P5H5xe632iHqGGLDe21M?=
 =?us-ascii?Q?o61h2R5PfYnK8/MJ96fbxhQimR7bIqmmU4cEzKmfSLWbmDzJQWavdcLXwWnp?=
 =?us-ascii?Q?1W8joQi6PI7K/4ZzP7Vw/atJ6Ra9gLeVV/bAL6MunrBLNKJbgc0MddQDLCme?=
 =?us-ascii?Q?1POcGXQ4OEhfOHiWjJJhuclssMXvRyQbKsq+BbtQ12RrqANa2TcQk++x85ne?=
 =?us-ascii?Q?AL6Phf3ks/VcwuKdNZEgiIKysLyDKu82cka3S058t0IYQbOnTksXHjpiTE5j?=
 =?us-ascii?Q?TH74MhFadVQRnt6zFWgGxLPt7mUREpUVj7r5lmnXDPoyMBa0oJKRCdpqLBA6?=
 =?us-ascii?Q?JMtRl8MjDvOwXdVaGTmpPgGsHmvh9y5p3NRzuMOPDRChPlo7rldmji4s86QN?=
 =?us-ascii?Q?oT5oftpSfeVdbhTlss/BSqprVE8Nj6EmQwW10R9eulrKU0RFvfRciko4iNCS?=
 =?us-ascii?Q?HPFR+M7uaBQda9XvHaYDgrvcJicJnvKQmP8j8ETUDqEvGrINVd5Usq1PU7N6?=
 =?us-ascii?Q?1jEL3UarPAsabf5VkTzM8rZeJB7iJuh1XmuI1wtsMr4xistQ6/O9m8ZJ6ybw?=
 =?us-ascii?Q?pVS40bHkjt5GJ/yndb2WhONALw0e3Zow3zSbGaL92YgeKw6hUAdUA/COJBfN?=
 =?us-ascii?Q?jHmF63rYC/whsr0F1R+Eeu/o9R+/2ryHytdSTk/P2RFgxlP9cz+xHllWTIvj?=
 =?us-ascii?Q?k8ZSU7f48W6Wgaq+Fcb3N1Db99sN+CKIe8vOeZPHOFQTKWQN+8R6qbvErLoX?=
 =?us-ascii?Q?lv2xaNY33NpEdcKFrUvJywDAezfnqIemf8l66YzYIZIhbHPsGa7lQJUYM5nB?=
 =?us-ascii?Q?TvST/M0Z8OO6GYJXebGde7Jq9Hqo97YQsaFURF3Bn/YxcnScVe2zfoJ2gnis?=
 =?us-ascii?Q?dZuSxqpSYN5xzuJK0iMKQcS84R7Rp09sjBJ1oSaq3KMC75povRLj2oxWi3wA?=
 =?us-ascii?Q?THnUcFeeK1GEc6ZBpWHmBSqtFbUuvw7tm5Lebc4tuKljcaFBI8cjXGCBzIPI?=
 =?us-ascii?Q?8dL7b0+RiOlWbiGWkCQ3mfOYqE4MVabYM4chA1stkvuULJjL9tZakWS+xwwi?=
 =?us-ascii?Q?6HMXvftPfbgMFk2z/ix4lVPPI0pGDtgXD4SmkLtNaQUAsQAJ0WoQBLz428JH?=
 =?us-ascii?Q?++6bINy0iAvp/HjaI54CFuoQ6vxVHamB2w9IPMV77hSYuGf7JSKIFl2zL09b?=
 =?us-ascii?Q?nwUIOVwMbFidzaMlpEiCYn01t1RdQhyIsn9lWj7nmQMVBz59Ffgp0Ne6zv5g?=
 =?us-ascii?Q?Jlhay4sB1liCFj13haDf7Ne0UeLpBeFqQFwn8mQ+7EuTFivC780IBo1tdxg/?=
 =?us-ascii?Q?VMk+uphBaXLvuxclSxuzVP/c?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <214EC5EA82E94F4EB763362AE59AC680@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ce3843e-57f6-4f96-0640-08d9274f2664
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 11:51:54.8735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7bw812ORGrLxsd0FyYmf1GHYeNT9Unzrn5MG5omGcZUjImDDF0yy4Q0OpkRUclsSyDDxSfzcig6dyS9XiHcwiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2798
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 06:57:31PM +0800, Michael Sit Wei Hong wrote:
> From: Voon Weifeng <weifeng.voon@intel.com>
>=20
> This patch is a preparation patch for the enabling of Intel mGbE 2.5Gbps
> link speed. The Intel mGbR link speed configuration (1G/2.5G) is depends =
on
> a mdio ADHOC register which can be configured in the bios menu.
> As PHY interface might be different for 1G and 2.5G, the mdio bus need be
> ready to check the link speed and select the PHY interface before probing
> the xPCS.
>=20
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 +
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  7 ++
>  .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 64 ++++++++++---------
>  3 files changed, 43 insertions(+), 29 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/e=
thernet/stmicro/stmmac/stmmac.h
> index b6cd43eda7ac..fd7212afc543 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> @@ -311,6 +311,7 @@ enum stmmac_state {
>  int stmmac_mdio_unregister(struct net_device *ndev);
>  int stmmac_mdio_register(struct net_device *ndev);
>  int stmmac_mdio_reset(struct mii_bus *mii);
> +int stmmac_xpcs_setup(struct mii_bus *mii);
>  void stmmac_set_ethtool_ops(struct net_device *netdev);
> =20
>  void stmmac_ptp_register(struct stmmac_priv *priv);
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/=
net/ethernet/stmicro/stmmac/stmmac_main.c
> index 6d41dd6f9f7a..c1331c07623d 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -6991,6 +6991,12 @@ int stmmac_dvr_probe(struct device *device,
>  		}
>  	}
> =20
> +	if (priv->plat->mdio_bus_data->has_xpcs) {

stmmac_mdio_register has:

	if (!mdio_bus_data)
		return 0;

which suggests that some platforms might not populate priv->plat->mdio_bus_=
data.

Are you sure it is safe to go straight to dereferencing mdio_bus_data->has_=
xpcs
in the common driver probe function?

> +		ret =3D stmmac_xpcs_setup(priv->mii);
> +		if (ret)
> +			goto error_xpcs_setup;
> +	}
> +
>  	ret =3D stmmac_phy_setup(priv);
>  	if (ret) {
>  		netdev_err(ndev, "failed to setup phy (%d)\n", ret);
> @@ -7027,6 +7033,7 @@ int stmmac_dvr_probe(struct device *device,
>  	unregister_netdev(ndev);
>  error_netdev_register:
>  	phylink_destroy(priv->phylink);
> +error_xpcs_setup:
>  error_phy_setup:
>  	if (priv->hw->pcs !=3D STMMAC_PCS_TBI &&
>  	    priv->hw->pcs !=3D STMMAC_PCS_RTBI)
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/=
net/ethernet/stmicro/stmmac/stmmac_mdio.c
> index 6312a152c8ad..bc900e240da2 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> @@ -397,6 +397,41 @@ int stmmac_mdio_reset(struct mii_bus *bus)
>  	return 0;
>  }
> =20
> +int stmmac_xpcs_setup(struct mii_bus *bus)
> +{
> +	int mode, addr;

Can you please sort the variables in decreasing order of line length?
Also, "mode" can be of the phy_interface_t type.

> +	struct net_device *ndev =3D bus->priv;
> +	struct mdio_xpcs_args *xpcs;
> +	struct stmmac_priv *priv;
> +	struct mdio_device *mdiodev;
> +
> +	priv =3D netdev_priv(ndev);
> +	mode =3D priv->plat->phy_interface;
> +
> +	/* Try to probe the XPCS by scanning all addresses. */
> +	for (addr =3D 0; addr < PHY_MAX_ADDR; addr++) {
> +		mdiodev =3D mdio_device_create(bus, addr);
> +		if (IS_ERR(mdiodev))
> +			continue;
> +
> +		xpcs =3D xpcs_create(mdiodev, mode);
> +		if (IS_ERR_OR_NULL(xpcs)) {
> +			mdio_device_free(mdiodev);
> +			continue;
> +		}
> +
> +		priv->hw->xpcs =3D xpcs;
> +		break;
> +	}
> +
> +	if (!priv->hw->xpcs) {
> +		dev_warn(priv->device, "No xPCS found\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
>  /**
>   * stmmac_mdio_register
>   * @ndev: net device structure
> @@ -501,40 +536,11 @@ int stmmac_mdio_register(struct net_device *ndev)
>  		goto no_phy_found;
>  	}
> =20
> -	/* Try to probe the XPCS by scanning all addresses. */
> -	if (mdio_bus_data->has_xpcs) {
> -		int mode =3D priv->plat->phy_interface;
> -		struct mdio_device *mdiodev;
> -		struct mdio_xpcs_args *xpcs;
> -
> -		for (addr =3D 0; addr < PHY_MAX_ADDR; addr++) {
> -			mdiodev =3D mdio_device_create(new_bus, addr);
> -			if (IS_ERR(mdiodev))
> -				continue;
> -
> -			xpcs =3D xpcs_create(mdiodev, mode);
> -			if (IS_ERR_OR_NULL(xpcs)) {
> -				mdio_device_free(mdiodev);
> -				continue;
> -			}
> -
> -			priv->hw->xpcs =3D xpcs;
> -			break;
> -		}
> -
> -		if (!priv->hw->xpcs) {
> -			dev_warn(dev, "No XPCS found\n");
> -			err =3D -ENODEV;
> -			goto no_xpcs_found;
> -		}
> -	}
> -
>  bus_register_done:
>  	priv->mii =3D new_bus;
> =20
>  	return 0;
> =20
> -no_xpcs_found:
>  no_phy_found:
>  	mdiobus_unregister(new_bus);
>  bus_register_fail:
> --=20
> 2.17.1
> =
