Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B583345CBEB
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 19:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350227AbhKXSSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 13:18:24 -0500
Received: from mail-vi1eur05on2073.outbound.protection.outlook.com ([40.107.21.73]:39744
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244018AbhKXSSU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 13:18:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aO4+8LpAz7c5I2D24TOUy2hF4Sv3TPW4KR6jgja2VMRTIYmF6nDzSZFG4wSKVkWhJTAcIXMOErQOGmPPB7OKN5i2F0ly18aWChRYbCRmP5aMamUJ1AgW6CLh0Q2qUdJ96ifGpeuepPLT8cYvW23JBFr+bs0+K0BOOa8zIg2eiAb5mers/83LEVmOOU7mBqdZWVwwM0ERiO+MlgoE5PahPFSNVADzzrhzIAki5eDjkiTCLWgx7ys3SnZF18FGaxHJoOUm7SwiqAHoxIRUCYl+aw8Nf+CbX4zX5WM39IYcVHOknSce7tdQUj8oKJq5ZOWr21gDkcp5Q6jcf/lRcrFwbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pFyfv+7kbD6wnY/QBUDhY8ZOH+ZKRqO9pagwiv3FBPE=;
 b=ZfF1eNWzo9lB8Q4iMLBgcOTZ0tGu6XVbb4CZj9CmBUOR1YcgOr4Wsh+5YdDvv/Cr7FhEnFg6wRbvaLkVY0cdnp4lJQZdCB7L/emQumk0BN094yVX83XmDg6F454x953yaXQJZTgIIcw2UduD4ZGVn3MBf5YDGuFGyVGehvvsAKR16LGBYxMpL7vB7xtjWO6TaeXpVL5FFgd5O+kexLKlfbmnnvUpPzTnbgBEAN93bkckp7+i2c3L3SNY3Wo7Ovu2hFbaJ+qbypcaZLXizv6Tjq+C1wLOznMd+l5ZgsAvr4KeUPcKvTfTLO2ogiHjiLAcYfhicfHI2EAZh6MJhVqyWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pFyfv+7kbD6wnY/QBUDhY8ZOH+ZKRqO9pagwiv3FBPE=;
 b=TTT0kajTd6vdMB4d8/KZ5sPPx033DiMEbRiBN5vOMUkZYhq1Ul0WNMRMrLgcCbl5xs11q8Qq+Cl4M7qJw4fzINA/y6YN2SIj7APadjqKfAzHEa0vt4xVfc/KLH86MVK3Ws+oNb/oiLJ3TwwSKx2fVSfoJQRUdeq09DvJVFIO2y8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6270.eurprd04.prod.outlook.com (2603:10a6:803:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Wed, 24 Nov
 2021 18:15:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 18:15:08 +0000
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
Subject: Re: [PATCH RFC net-next 03/12] net: dsa: replace
 phylink_get_interfaces() with phylink_get_caps()
Thread-Topic: [PATCH RFC net-next 03/12] net: dsa: replace
 phylink_get_interfaces() with phylink_get_caps()
Thread-Index: AQHX4VwWzy+SKKYDLUOcXyfX9IFpdawS+7OA
Date:   Wed, 24 Nov 2021 18:15:08 +0000
Message-ID: <20211124181507.cqlvv3bp46grpunz@skbuf>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRi-00D8L8-F1@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mpwRi-00D8L8-F1@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34675a2d-8948-4709-1e91-08d9af76590c
x-ms-traffictypediagnostic: VI1PR04MB6270:
x-microsoft-antispam-prvs: <VI1PR04MB6270A7DD098CF2B6FF9221B5E0619@VI1PR04MB6270.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mbnrXPQAaDzG/BTSMEqpB5mghFfq8N3MORjox2lmWuAP2J680e/ujA5pHz4MzN5xEmx0ewEOFz1w2/58xYzSEbDzfsOuX6qXFgDHdZ/nDlPPzPnsl/RsubzLJ+Th8QeJkD22fYS9YhnDXSj6bqV5Q+qlXLNT9F4BVxjr2YMcJl25CnprGe+3CoNPPvXlXjVa1Wyn3KZuh640Xbfh8mgacTrVQeam+pAxNIwjSZ3taB4rwQUpq3pinwJ+qjT2EhpAzz321HERn/eh2zCMUsZB4SYg87bRHkcN2b6irAi0g7BZi7hO4/1x2YrpXtOGjQhqK8cxZASItUokkhgMt5uKX4j4n1EDw9aF/zQAqs7io1FuyyqezdZ6VhIxuVau6xAxDItlaCZYz36XGG+8zoa4GfkGlfoSchd4bEscuFpn4PQkpIZJSLg4ABO4kmTah93zj98V01wp/cFUVj2F+yQ519Q3bTlVGfTzgD7wcUepfAuvz7EpuEWQ50pp/EPT05/NfdGsSCZltQ9HtrV+A8IGWO7NNp35nh/1TNfpQ/3QWl+YQyjbfBy2TVZ+1f1+MAyqp5RBmce7tzP2aXLy26inOKkr6ueJBzb2EtNvFGGqjez3s3YrRmCvp9ipEcplSFEa0MAeNkhMnTZbMGc25hIZcVZIwhLsmI/C+veuKXG0bcXO3Re7QI+J0ESdQfo8pS0R/MjvqDol8Q8WnT500C5fkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(33716001)(54906003)(316002)(8936002)(508600001)(44832011)(38100700002)(6506007)(4326008)(86362001)(38070700005)(5660300002)(83380400001)(2906002)(66476007)(71200400001)(9686003)(7416002)(186003)(64756008)(8676002)(66556008)(66446008)(1076003)(122000001)(6486002)(91956017)(6512007)(66946007)(26005)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AnRK/HH4bl+fsZfDZkNYlniP5OazwbPNuCnrPI79TpChFe/1xfdKq+y03ofq?=
 =?us-ascii?Q?bL4I+9yVUZaqsRVFM0G8cnAkRypgv9eS51rTbpe1n7v3FAtkd7EkeK6Qiqf3?=
 =?us-ascii?Q?B+YpS0mVvntmemY3wgBCx6ktvmXkIvHNw5Mw4VFWyTBqJT6o99RQ+aRnGjuv?=
 =?us-ascii?Q?Z2+McfqG89Qmt02JyKw5XXITsVrFlyE5Y0NqOgE05VcRhC1axMBndMnIEOJk?=
 =?us-ascii?Q?Ow92XLZI8+3WIfEypyGZh5f28mTzZSidYYyL+tv6bIm0QujGEsWR5mQQs2Ia?=
 =?us-ascii?Q?xlRipjXZqrR0VcItmLeOeZt8kJGFcTtKBqeRwYr6bACnBdKOw6OQF74bmaJJ?=
 =?us-ascii?Q?PmEE2c4WV2FqXJ25i698pOltyKmonjbpXpyC9pbqncAPJfriDHzJHogd4Rr9?=
 =?us-ascii?Q?2qJ3id6vjB/EK7TjqXQ1lBjSpv+lakbtgfzWa7HP/HLw+MEPRrfaZyZ9i3Hd?=
 =?us-ascii?Q?QRa4xGkGAtIHNlZORCA54YhuhIpdXQ5rlrTD8cO/8eb3J3cr04QEILmkJvmy?=
 =?us-ascii?Q?LI0locGSXJc3/Xxrpg940DD/Koda2cqnx6O1qyTIw7QPaV+pmIHLtQltR4Ti?=
 =?us-ascii?Q?WO67lQnhK8CtHhVSwmFr149EwOWusL3ZfYO/PvQTiGZCAZRqLkj3kokbmsPH?=
 =?us-ascii?Q?8rRXPV3zPfRfDJkQWBO20tMc2/s27SlGNL9tEfT/qq0xh7RgEdfIuFAl8ExY?=
 =?us-ascii?Q?vtM8vGOrqyTDqDv72SLj9a4gocSzN64mBxGd5CzEB+aiu+e3WjxNlBJego7+?=
 =?us-ascii?Q?57XaXIfCyEnyYs7fcEpS+hRzY9vqggGeIqdGpeqndO8x9eYLBUkyAWZa+0bl?=
 =?us-ascii?Q?OmN4bZDlEoA3sqc6mzXRcLxfp9w0j4f3eQ8astYK4kqrmNzWCaudo0KrHlDd?=
 =?us-ascii?Q?990HY3VrkUigBn6uJfrBDiPn5zY1M5Fq/uGxyGPKUxBKFNpdoZeMdSgC82qp?=
 =?us-ascii?Q?ae6vgBAj+kMisnaqlOJU7CmaRuslQLxM2LOO16jP+fjXp9FIl+XWKq0Z+87C?=
 =?us-ascii?Q?A6Uwm1055TZN4L1B86bLeQPmGkklMIVtc/nt0lfQGJB0mm7v2RBlW+J2d4yu?=
 =?us-ascii?Q?h/KtufZPUaePLBsZuk6+gvdRr/nwXycKdhVgIF9dtqMKPkUYZkm08lebWltj?=
 =?us-ascii?Q?S3GHAPceYB2NNYh/caO1tZo6/6swO3Er6af2C0zHBUMywPSV9hbk6Pi1Lpl0?=
 =?us-ascii?Q?3BVdkYaralyPgiLaJsTj1+vawEiLL4DUM3FAzc8xB6UyYEovVehl7im7/ZxK?=
 =?us-ascii?Q?Mn+e9sQC38QbRpw0XlYQWidH+z4NjWcgfz/TN0gWaCHRpSl4YcY0LHf67BlX?=
 =?us-ascii?Q?GdJQw9uZ5BtImpaHsF87BMHS+WrBZ9auLKzLEgoeQiOdgB8s60QM6BnSqfGX?=
 =?us-ascii?Q?E7eUMGEh+ztwgvTek31qlBp0pJPjqUW7vnMrag0Q2A+zHGGh4opgEXYmNB56?=
 =?us-ascii?Q?+VzpLYHUvej7GbW6buVfBrgcLodw1v/6XZle0hCU7QdAICnjSuAEDk/lEnoZ?=
 =?us-ascii?Q?Mn87dPj9iwWYe7wKw6chUjSgtLFuJvHS1K5ZAHrFF1+bgS5Rx4gjBa+sCKEO?=
 =?us-ascii?Q?v7ZRS6oagC8Zznb6LJlhBLM9mW0yz2k9Xw+cVFv48xmbQVFiYWn2KRWJwgRI?=
 =?us-ascii?Q?VqElOVf3h7MpdKf3fmGM5CZX+TDNeQK57j44rz9+uNE2?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <49089081557A804FA5CA0ED9D91835D8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34675a2d-8948-4709-1e91-08d9af76590c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 18:15:08.3014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QG8AVCZzfO2LL7W/Wfssh4nrjbe4qwAYFfxmyEKRdeH1fDTBffZxP7y2ALl2UJHSyqYqcSihZLp9SdNA/bZ0pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6270
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 05:52:38PM +0000, Russell King (Oracle) wrote:
> Phylink needs slightly more information than phylink_get_interfaces()
> allows us to get from the DSA drivers - we need the MAC capabilities.
> Replace the phylink_get_interfaces() method with phylink_get_caps() to
> allow DSA drivers to fill in the phylink_config MAC capabilities field
> as well.
>=20
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

The effects of submitting new API without any user :)

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  include/net/dsa.h | 4 ++--
>  net/dsa/port.c    | 5 ++---
>  2 files changed, 4 insertions(+), 5 deletions(-)
>=20
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index eff5c44ba377..8ca9d50cbbc2 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -645,8 +645,8 @@ struct dsa_switch_ops {
>  	/*
>  	 * PHYLINK integration
>  	 */
> -	void	(*phylink_get_interfaces)(struct dsa_switch *ds, int port,
> -					  unsigned long *supported_interfaces);
> +	void	(*phylink_get_caps)(struct dsa_switch *ds, int port,
> +				    struct phylink_config *config);
>  	void	(*phylink_validate)(struct dsa_switch *ds, int port,
>  				    unsigned long *supported,
>  				    struct phylink_link_state *state);
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index d928be884f01..6d5ebe61280b 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -1094,9 +1094,8 @@ int dsa_port_phylink_create(struct dsa_port *dp)
>  	if (err)
>  		mode =3D PHY_INTERFACE_MODE_NA;
> =20
> -	if (ds->ops->phylink_get_interfaces)
> -		ds->ops->phylink_get_interfaces(ds, dp->index,
> -					dp->pl_config.supported_interfaces);
> +	if (ds->ops->phylink_get_caps)
> +		ds->ops->phylink_get_caps(ds, dp->index, &dp->pl_config);
> =20
>  	dp->pl =3D phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
>  				mode, &dsa_port_phylink_mac_ops);
> --=20
> 2.30.2
>=
