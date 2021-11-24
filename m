Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1DE45CBE4
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 19:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243629AbhKXSPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 13:15:11 -0500
Received: from mail-eopbgr10073.outbound.protection.outlook.com ([40.107.1.73]:38022
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243151AbhKXSPK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 13:15:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sas7AIFplko922PqAokCRySu3tYXoreQbqRCH5/EKEGkm2cVGlngwtoEV4JcaS83S1SWVhfwlbh8OQIJyryL75ix5RjGiV9EgzfANGCaQpSIzREQE8vEUEjo5MQ8KBzvXPPYyxNBkZ6K7rYxdsWSFFQP72seqCM6yjFLswQNV20OQlcNoD5LwrLgCIU+rVmR42IYErVH3otA8ddCzQUMfu34otQp/nDDgk7BMI/oLJ1q9o8Tr62w8XmDb0JP2dpMCUDCDu/gcvJO/NnckfVjZKx7Xx1ZEoZTffbUF4H62Z3U8lctNa3aqFYViM8AA3tGiMHA61MHoNGwF+pLhS50fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JfRl3btnDULSNzswoTgJRW6YRQhZcUU0XMJyI0+isZM=;
 b=ND9Gii/PEOWPUF4RPKyuntAlD4XKugFR9SU24mTCg+6a2UqhpTOQjZ7xxpNwVnJ27urmHUjbF9xz6mwzO8CPFOf43kDbHaJ4ih+H/SpGCx165kpiujjRylk9kyNGmuJ5iCA1r4vl2Ctl/fJFytwmqelnxNUadIzcRo4Soz51D1GUrGw3Zwq/HNRCgEuXZkqbiiL6vUiLPiVEjuZxEXfSFRAhb1tf+ceY6BWmH6FP0zpBIu/aASUKrN3B+wcVEaxSkwdDKfaX5pFqykoICvZTx3NKLEh5Am429Way5/ulnOpCl5529VH4J0MQtR5p4kk7Fo1POjS1ogrh2BAyM9hYKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfRl3btnDULSNzswoTgJRW6YRQhZcUU0XMJyI0+isZM=;
 b=e5cnJ6cjHjknBAkCTJdMsHP96cVV1BRWtZUPfxJ4bAf8a/7BfZsmHzlTgjAs9FcjSSeCnPZxr3cX57VbPO1N0oU3eF2vYB3v5NDrimkLeWe65DE/tfQCCRLzZN1ncY4/MTgRyMKbi+ebrxd3UxlrmWZFngK2/LvDcNSKlM3QwJc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3551.eurprd04.prod.outlook.com (2603:10a6:803:a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Wed, 24 Nov
 2021 18:11:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 18:11:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH RFC net-next 01/12] net: dsa: consolidate phylink creation
Thread-Topic: [PATCH RFC net-next 01/12] net: dsa: consolidate phylink
 creation
Thread-Index: AQHX4VwQBurk2I2xyEmbFSWzUlWHCKwS+s8A
Date:   Wed, 24 Nov 2021 18:11:57 +0000
Message-ID: <20211124181156.5g3z2inlaai5lcvd@skbuf>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRY-00D8Kw-6S@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mpwRY-00D8Kw-6S@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7887b6d-cd46-40fb-97c9-08d9af75e764
x-ms-traffictypediagnostic: VI1PR0402MB3551:
x-microsoft-antispam-prvs: <VI1PR0402MB3551074789B9410D4A3240A3E0619@VI1PR0402MB3551.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4EliiSOPTMYU/VK0Ux/QNv5Z/n/y3y1sFZX3NCk6vODXTX++VXseLCV3SVi1bZkfyvPPVzzx2gfUd0XwbFVtgM3Ldezjp+CQ/Lw/HAOa/jjFoa+Qvpi+zDolmZl7BeM1YAQnl8/naZWX6P4vpl8IkygWnrPLCRBE2fE5MbUgwDHa9PmQhLiNNFGmTo7+GgoOnw0Mry1VwKburf03HKpM1JG9bZKdLAK7kB28KNY7r1ywsF5S8xEdNWr0ONtYDdv8lAmM8fPJM4DXm2pdiRGRreDYlpPGAenOVkMGlDdkJPeaMAin/2F5QpRvmiD00i40c098vjdkxSzi6FAVRJcZpYy73cVjSGLsrssbWoqg1R/7GiSeIo9Md7uHumVkjrmOXw9zv/HCFZyRPlqsM2xcewvnu6HV9PFyKgioDAGQ0748nO+y8tfRmGM7wHCEHjt3oeHY7zkFL8qiND/bvyZA5AWTTKS37vMWrTMg5HkX4SnUd/v3JneBwYVtbPPfRGP4QIziNLRH+AbtGuApphY38jjL//Y+5byfyxcTdgtbJJ2rvXIe+WW8ZJZqqSod8NORlGgwCl3GzcpPJjDL1VvbkeFWMA2PBM6ZH9gft3MYVuM1LU8UNRXJio+a9c2wxLPm6MdNTNO8wEN7anb8NhoLBvG1FpVWYRDCzaiU8fcGSLc11A+xR0hdbLL73iafqFytz4G0t2IOLuKq71jw5kfXOw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(9686003)(44832011)(6512007)(8676002)(2906002)(4326008)(66946007)(66556008)(64756008)(6506007)(8936002)(54906003)(38100700002)(33716001)(66476007)(66446008)(7416002)(316002)(86362001)(71200400001)(122000001)(186003)(83380400001)(91956017)(26005)(5660300002)(76116006)(6486002)(38070700005)(508600001)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?m+/ww7j1otJgUfc7ADnd6CxN7F2t89z45+sAuMKxD1bUT3BtOnjMHk5l1ltf?=
 =?us-ascii?Q?r78wkWgqfaQU4jObykTifaYctheVQBxRSJK7gWOK8vVqIffq6usbQvce07Bh?=
 =?us-ascii?Q?ea9n0ms7EJbpEro/Yv9USFZ2NXs1cUbxVWbU8piqSCyO1dm0ly8VymeXH6Vi?=
 =?us-ascii?Q?M0X5N0RatmiNvCXOMYt1sL2sxtzARjH5bxkqDEpXDJqboHEdYXSQdRXpf1Zu?=
 =?us-ascii?Q?IDXeWEyuzCAWHpEqhAde7gU863MEfyjwGEwaZKVHLIBYTAY4LgxLGlK+5TvX?=
 =?us-ascii?Q?Y+ZFVDoVxfaR9KCzlambWLLHeDzfaV0HKGB/4NE/BuxsB0YXc7Y6noEprRnP?=
 =?us-ascii?Q?1FDKocXijYylL+YzA1YLQdvSdqj4su3qcM/YJXMlrzWVkQKIsOoXD+GO0z7J?=
 =?us-ascii?Q?OPEDWZa6nsRMTFXcTZ/PRcrlCNC3QlKi7Mh5EZUAKLyeRLUylDT9hi/BQzEo?=
 =?us-ascii?Q?8Mhy+NOIVqn08qWmQ3Qu8gyKuZ7OxnOgrMNwBCYZgyNtcCfzybXMPQVeZRvX?=
 =?us-ascii?Q?RtkY282/2Pf6tREooJXHI+hC4xOiAFDFUWDiClaih/bQaY6TWdtPCp1Tw0t/?=
 =?us-ascii?Q?NEclFGlsgXK7pNu/dBaGO9J89ruDN/6HLq3/vZzgsQO19Ls6rLOniH+Myv6P?=
 =?us-ascii?Q?pIDq4TGgb6y0MZn/G2ngMKQAxJeKxvX/qOSmdTb6MJ21Iptfy8XGSA/z/ZN2?=
 =?us-ascii?Q?85IURGY5XfdNJr5QqpN9coqFaftWr+05CAtpHxdraES/ViXwkCCVby2xplml?=
 =?us-ascii?Q?8aB5O5zIUfGzmgdqHuAKbUZuj/dh4L2Vnm6uxeFFypfj246DuahRAueVrSBh?=
 =?us-ascii?Q?AEO47zIckuxtKm5m5FCqvKuGrNva2eGNRgVuFgsnOd6OdbsAaJF7Z/IrvAvb?=
 =?us-ascii?Q?EoN4dtEUfXr3zfCquCkRKZMCBdQd5U0sOJuq3DVLyTu1arK+WOXxa/JhGHmA?=
 =?us-ascii?Q?evpp3CvA9l0MxNjeIHnUJ7VpB3CiKwHSgUevKp1Gs9b+pRVLE6Hv0nm20pkJ?=
 =?us-ascii?Q?IezbE8C2NgDWTeZEJ1CeUy2+f3mDNng8WQIg4x3e1yNxRFYRFNY5Z0BkAyI5?=
 =?us-ascii?Q?ybP9OZ4jk5nQexjKent5IP29/oMKtiyq2tox1MpEs94gwA4g/rvfcM43KVzz?=
 =?us-ascii?Q?JViT+8IElBWmIKuWo5BmwjmymkGY/z2+2JR96t5ASYxeP8W2bkrb01XRuMLR?=
 =?us-ascii?Q?/d+XY2eOJ9HF81LjsPBtPSwIim75ifHvZJ35YOII4AaSdjJpic3xG8bhBZn5?=
 =?us-ascii?Q?F21RD3QxelXVULzUCqFTYM8OckyDdeX/Z8qNunwUWDcIUR/Ijk6Q8z30Jm+3?=
 =?us-ascii?Q?NN6JcIbi3Q+SP/5644gYu+Kzt81qzbkoTYuhLtu0nVp4p2gsZQVBEPas55yJ?=
 =?us-ascii?Q?dITXrKIv9xatmoa7pyCAKxvthJbsz9krEpRBLK3qlkDrkzlb8jwXatZbAHcM?=
 =?us-ascii?Q?z/gJJD2ZPvlWwZqLr5Ze/FfmJVZ2yahnS8hi5hhbEF/maKA39t3I8XMGWfxf?=
 =?us-ascii?Q?oXuUAgdFFjE9w+SIvkYyFG6mDFzU1G53gOoQnEA9LxYuB00wev1aZo7HCimz?=
 =?us-ascii?Q?GSbWqIC6VmpgtIDz+eoiIkeivJ+9rWprfnAXxqsymFWn/dTRmqmPemuCdOim?=
 =?us-ascii?Q?SZBMgE6o5hEfD589El6g8QY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AE01AA3BC9E23C48895B35BF35190210@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7887b6d-cd46-40fb-97c9-08d9af75e764
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 18:11:57.6260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z28WzN1ZReK7MMJlEBxywTAiyROoSHR5BgfB+O8rXVkMMGtaVMjC0NFqbS46fkjMYGu4nV3IwwX5ugiEtjBzUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3551
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 05:52:28PM +0000, Russell King (Oracle) wrote:
> The code in port.c and slave.c creating the phylink instance is very
> similar - let's consolidate this into a single function.
>=20
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  net/dsa/dsa_priv.h |  2 +-
>  net/dsa/port.c     | 44 ++++++++++++++++++++++++++++----------------
>  net/dsa/slave.c    | 19 +++----------------
>  3 files changed, 32 insertions(+), 33 deletions(-)
>=20
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index a5c9bc7b66c6..3fb2c37c9b88 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -258,13 +258,13 @@ int dsa_port_mrp_add_ring_role(const struct dsa_por=
t *dp,
>  			       const struct switchdev_obj_ring_role_mrp *mrp);
>  int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
>  			       const struct switchdev_obj_ring_role_mrp *mrp);
> +int dsa_port_phylink_create(struct dsa_port *dp);
>  int dsa_port_link_register_of(struct dsa_port *dp);
>  void dsa_port_link_unregister_of(struct dsa_port *dp);
>  int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
>  void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
>  int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broad=
cast);
>  void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid, bool broa=
dcast);
> -extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
> =20
>  static inline bool dsa_port_offloads_bridge_port(struct dsa_port *dp,
>  						 const struct net_device *dev)
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index f6f12ad2b525..eaa66114924b 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -1072,7 +1072,7 @@ static void dsa_port_phylink_mac_link_up(struct phy=
link_config *config,
>  				     speed, duplex, tx_pause, rx_pause);
>  }
> =20
> -const struct phylink_mac_ops dsa_port_phylink_mac_ops =3D {
> +static const struct phylink_mac_ops dsa_port_phylink_mac_ops =3D {
>  	.validate =3D dsa_port_phylink_validate,
>  	.mac_pcs_get_state =3D dsa_port_phylink_mac_pcs_get_state,
>  	.mac_config =3D dsa_port_phylink_mac_config,
> @@ -1081,6 +1081,30 @@ const struct phylink_mac_ops dsa_port_phylink_mac_=
ops =3D {
>  	.mac_link_up =3D dsa_port_phylink_mac_link_up,
>  };
> =20
> +int dsa_port_phylink_create(struct dsa_port *dp)
> +{
> +	struct dsa_switch *ds =3D dp->ds;
> +	phy_interface_t mode;
> +	int err;
> +
> +	err =3D of_get_phy_mode(dp->dn, &mode);
> +	if (err)
> +		mode =3D PHY_INTERFACE_MODE_NA;
> +
> +	if (ds->ops->phylink_get_interfaces)
> +		ds->ops->phylink_get_interfaces(ds, dp->index,
> +					dp->pl_config.supported_interfaces);

Can you please save dp->pl_config to a struct phylink_config *config
temporary variable, and pass that here and to phylink_create() while
preserving the alignment of that argument to the open brace? Thanks.

> +
> +	dp->pl =3D phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
> +				mode, &dsa_port_phylink_mac_ops);
> +	if (IS_ERR(dp->pl)) {
> +		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(dp->pl));
> +		return PTR_ERR(dp->pl);
> +	}
> +
> +	return 0;
> +}
> +
>  static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
>  {
>  	struct dsa_switch *ds =3D dp->ds;
> @@ -1157,27 +1181,15 @@ static int dsa_port_phylink_register(struct dsa_p=
ort *dp)
>  {
>  	struct dsa_switch *ds =3D dp->ds;
>  	struct device_node *port_dn =3D dp->dn;
> -	phy_interface_t mode;
>  	int err;
> =20
> -	err =3D of_get_phy_mode(port_dn, &mode);
> -	if (err)
> -		mode =3D PHY_INTERFACE_MODE_NA;
> -
>  	dp->pl_config.dev =3D ds->dev;
>  	dp->pl_config.type =3D PHYLINK_DEV;
>  	dp->pl_config.pcs_poll =3D ds->pcs_poll;
> =20
> -	if (ds->ops->phylink_get_interfaces)
> -		ds->ops->phylink_get_interfaces(ds, dp->index,
> -					dp->pl_config.supported_interfaces);
> -
> -	dp->pl =3D phylink_create(&dp->pl_config, of_fwnode_handle(port_dn),
> -				mode, &dsa_port_phylink_mac_ops);
> -	if (IS_ERR(dp->pl)) {
> -		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(dp->pl));
> -		return PTR_ERR(dp->pl);
> -	}
> +	err =3D dsa_port_phylink_create(dp);
> +	if (err)
> +		return err;
> =20
>  	err =3D phylink_of_phy_connect(dp->pl, port_dn, 0);
>  	if (err && err !=3D -ENODEV) {
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index ad61f6bc8886..33b54eadc641 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1851,14 +1851,9 @@ static int dsa_slave_phy_setup(struct net_device *=
slave_dev)
>  	struct dsa_port *dp =3D dsa_slave_to_port(slave_dev);
>  	struct device_node *port_dn =3D dp->dn;
>  	struct dsa_switch *ds =3D dp->ds;
> -	phy_interface_t mode;
>  	u32 phy_flags =3D 0;
>  	int ret;
> =20
> -	ret =3D of_get_phy_mode(port_dn, &mode);
> -	if (ret)
> -		mode =3D PHY_INTERFACE_MODE_NA;
> -
>  	dp->pl_config.dev =3D &slave_dev->dev;
>  	dp->pl_config.type =3D PHYLINK_NETDEV;
> =20
> @@ -1871,17 +1866,9 @@ static int dsa_slave_phy_setup(struct net_device *=
slave_dev)
>  		dp->pl_config.poll_fixed_state =3D true;
>  	}
> =20
> -	if (ds->ops->phylink_get_interfaces)
> -		ds->ops->phylink_get_interfaces(ds, dp->index,
> -					dp->pl_config.supported_interfaces);
> -
> -	dp->pl =3D phylink_create(&dp->pl_config, of_fwnode_handle(port_dn), mo=
de,
> -				&dsa_port_phylink_mac_ops);
> -	if (IS_ERR(dp->pl)) {
> -		netdev_err(slave_dev,
> -			   "error creating PHYLINK: %ld\n", PTR_ERR(dp->pl));
> -		return PTR_ERR(dp->pl);
> -	}
> +	ret =3D dsa_port_phylink_create(dp);
> +	if (ret)
> +		return ret;
> =20
>  	if (ds->ops->get_phy_flags)
>  		phy_flags =3D ds->ops->get_phy_flags(ds, dp->index);
> --=20
> 2.30.2
>=
