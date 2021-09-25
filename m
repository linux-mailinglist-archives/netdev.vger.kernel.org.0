Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D73D41841D
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 21:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhIYTVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 15:21:24 -0400
Received: from mail-eopbgr80049.outbound.protection.outlook.com ([40.107.8.49]:56547
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229711AbhIYTVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 15:21:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=URlykwdO6xkVxV6tD6csZ5dophzAEj/vdR83lrtld3ASXQWpldt7pPwQzZOq2z7INO9LXnz6Pr1lmjO66eX/Ou/yd1zVeXDczkn3rOOPW+Icm3v0lKyNBTS2zeHV8iWycKM4CtwOu0/OWrj4BKnbdEf9AuDu3r6IY1DYHHmXwYv4ui996Km+anG/U78cGzN6UVPIs0pPxpRslR3bIbyTuwhcTMYcQ8MVYUrq+TI1yizlKNOP58MxbTfxmHxLYu79+DFT/UU0mhnqTqlNN758y+rT5X65sI643QdjYibtpQwB9XasdplaA0NvuUBgD6uHdkkKhNr9HFkvhSje5YQTMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zpNIBMUzL55PsPrg28NUadDPENpi3kkehZEPZN3VS3A=;
 b=Hv6QJ/qLtK4W0za89EBSb39QkI3hpXuUny7pYaHANzHsZY3e1UTB1aYxkdJf6ZwGtDQY6SwcvcGH2FIE4UH6i9019asryLYp/5CgEWh2BHxVWKxWme5eF0MEcL9IEzEPyyGQdzWoPOO0FzCQ8LE502gCo2QFz+wxYSUHjBpDHl0z/TnGx592hGeODNjCX++nH7EwIgCgHSEvcVrKFwehOyp0yVGtdinzxbDDVOpZytSvBRcLQtwBWv8zVpplTAQ9sJ8ejireluW8z3PUzyzdfM5qGY6og1mO8+IYGx0kF8hZY2lOnI55X2eOsnsDRcxIoE72cxNpL9zTG5xv67LZ0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpNIBMUzL55PsPrg28NUadDPENpi3kkehZEPZN3VS3A=;
 b=Z394On/3BqCLDWQoQlpmi8K7qwEnUUIBPVciYElIF2EOnO1H8IjxN0cijVSfxRGBHW4VepjIdpYjNp6YzddAGw4Zs2hLvvRZ7QGGRHRP4TZQ0LVbMRIwZdo+adtJ7BvDGKnkxWWjCDwA10G4eNlEeaZSTkueTvL/gY0oS/qtn84=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4685.eurprd04.prod.outlook.com (2603:10a6:803:70::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Sat, 25 Sep
 2021 19:19:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.020; Sat, 25 Sep 2021
 19:19:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH v5 net-next 2/9] net: mscc: ocelot: export struct
 ocelot_mact_entry
Thread-Topic: [PATCH v5 net-next 2/9] net: mscc: ocelot: export struct
 ocelot_mact_entry
Thread-Index: AQHXsSiI4fkHFW2crUKhjuf/UEcWf6u1IkeA
Date:   Sat, 25 Sep 2021 19:19:46 +0000
Message-ID: <20210925191945.vivi35k2uxbsdeyf@skbuf>
References: <20210924095226.38079-1-xiaoliang.yang_1@nxp.com>
 <20210924095226.38079-3-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20210924095226.38079-3-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a16b1c44-c5fe-46c3-c003-08d980596fa8
x-ms-traffictypediagnostic: VI1PR04MB4685:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB46859AD269A3CDEBAA0525C8E0A59@VI1PR04MB4685.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 76hzvFet22qcE/6UsZ+21DW1ddK9laFWWa9iK/+S3bCvQZpInAuq9rMjebn3xtAov7nDkotzE5cdnJLGYUh+MULShMtScz1AvnkKHHZ2CV4H+/tjMwQX9vN/+5UzoaL48C29Ft/+M7ptgiMM/1G0M3PmfYsGvikE1sKs1W1GN0vY97o9YG2WFymDaSWuZ82dH2Cwt4ws0UbeGJ1bjo44NGCVO/P6up/XR3y9gD8NkyGx0HnElPzDRSGptXMUKtUwB5GTDw5WBle5deRXbUT6GH8JsdPt0qmXupi6KRJgQ2Qafm+7L2UaYKUH+QUwiXFjiCeqAjE1npnN0WjTNxYmQDNXsohZrSly9stswlVRhzX1dRKyoi2L31GVAd0lsitY5i+nxl7Ur8QiQMV8m1b5jrASBqmg7+pp0TBmYMKWrk8Xf5pb4F0tvqLqKjhrLr5t1gmYZ6cHtC8jdAbCVxE/spCFGGTzf83EsdF/H7HAWsLJ8nqlgDzXSmHiN934HninapVVEWCLF2r35YC11aS99zVNFntIH2P42Bik8JX9uvHWU94uCDvIgcgcvY6p8nySSiqNX2qZu/bnXlyG9evAwC3O+GJj8u/tjCh96TdbP0MqVClRPn5MotbFqiQ/dSeS2GCp24ZZehcFt7LwJCENyFi53glzK5VNXKEUk6E3bqI5Z5/30d8Pr8JtEcvgERyP2oNTNm4jHJLtU4IPt30T/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(6512007)(9686003)(83380400001)(316002)(5660300002)(122000001)(38070700005)(38100700002)(71200400001)(2906002)(6506007)(54906003)(7416002)(26005)(6486002)(6862004)(6636002)(186003)(4326008)(86362001)(8936002)(44832011)(66946007)(76116006)(91956017)(66446008)(64756008)(66556008)(66476007)(508600001)(33716001)(1076003)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UjmJHhT7UZ/1Mg+wytI6Y6oAU47PhHOSeEm+GTp0zxO6qMQQkPSBFsEpfBk0?=
 =?us-ascii?Q?t0QMu+OpH9CXoh3rNZknwdmb2Ty/fJgYV3KnbO1B+Jbhg+rFMrz29+nWZKdT?=
 =?us-ascii?Q?/09QcM8pkFh0s1K9ruKrxLu0OvJZyx58P2BIGTdThNCpg53CSFpr5Bs4/Dlj?=
 =?us-ascii?Q?LgMDB/ZFZizCXy468OvPJtQyqP4jJCqyUphJWJkuVxhm5wbCRpte2M+u3vTT?=
 =?us-ascii?Q?+6u4XJaqjrazPb+E5S8d4Co3kTR9ivLZMXUjPTZxFkMvmwVOWzx3wIW5Hcse?=
 =?us-ascii?Q?fMfeOd5dYQeKW5wEN848TLUlRIuszw3XqB1HZ3IC9UXJIpUsgN77Zlv/8BMN?=
 =?us-ascii?Q?695h4R1SZ2dHqy09PgvRm6wlqjSuH8TiSavzA5k77X7h92CctBdU8gPVDijR?=
 =?us-ascii?Q?sG33HokITALvqJ4OxyDFUrF/sE2tSrS0O+0g/HFUMsMD/kBLa+DlLUZcoidw?=
 =?us-ascii?Q?BnxmU2wAGZWIwxBtW7fuRSq0CLQyOjuLJhZyCrPQ7sy+zyj77FY5c1z3XpGh?=
 =?us-ascii?Q?JRkx6yMLktvg1L9rGLXomQzjA2MWfeMP0tdmVHfmEZjuzIgCmF4gyiL/hZYv?=
 =?us-ascii?Q?8kpaJKbk5n6UemJkSbkuLPlAoYND7DNQsnUz1MMnCyh326LgQG9vINpQmIDn?=
 =?us-ascii?Q?0PyY6JbbKV2pLmAA/3S1OvTwwqK1y12M6v6WjbxcoaEMaqvpH1hsPwOIezlc?=
 =?us-ascii?Q?aaRuiZAKOsMGDnSRloYiUS/w0Ksx51XVPhkC6DX3be4YuVRybqrb8nhVcYQq?=
 =?us-ascii?Q?vj4hQXigoPMbtk0IjvaVACFLN5XxFh4KPAMyyfy/EUlmxrhazsnCSI6Dn/WB?=
 =?us-ascii?Q?4IRVLSso/8RtfRDz8HWWgI56hYJN5pcT7vWRhtFkwd+RlucgDkzM65S65cte?=
 =?us-ascii?Q?R0EkZs76x7VIAD73Tw1sg5TJWF5lxhPEvzOnpkJUIeiNDYJrRCO4KkpMJEBS?=
 =?us-ascii?Q?6ZXLXWN+k7epZOfux6lu1W4iedk6RXH4ueQyJloI0PTcgIyXl30Od94BxpKZ?=
 =?us-ascii?Q?6WgOAxAVKwb26jftEhlwkTmGmC2dpqrBfCKvKaJRrrdMac4Eep3qJbbamMEZ?=
 =?us-ascii?Q?QnP3kITE+TuogFMjGDh9ZgKqHppRwLTatBwlxkkgHAzkGXE5mky7VPhqDjoq?=
 =?us-ascii?Q?a1JMska96M/vyH0AQxzwlfqHypQ+T958yAvVFs4sysbV/z//MBX6Gt++s0Eo?=
 =?us-ascii?Q?nzAsoKheozmigfwVfRoIwXJF4ZEoepLBTu1uDs06iQN5ZUEDD5bt7EjC7tT+?=
 =?us-ascii?Q?qTkQsWc2osWfOvMC3KvG+C9/GCBAsArljlLwLBtMJlbIfYaYNUS3g9F5lN6m?=
 =?us-ascii?Q?HlN6CZDnD0yDXjMrCp9uVDcA?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3370C30DDAB9574298E75A793F5C3737@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a16b1c44-c5fe-46c3-c003-08d980596fa8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2021 19:19:46.2661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LXB+KzmKxOn3vjapEjEY2q8Mv+09mmbGdpBxNS15seqjWk797yNsLNbEdjhgX/6tVSr4Afk88WnN7AAb0BP3og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 05:52:19PM +0800, Xiaoliang Yang wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> Felix DSA needs to use this struct to export MAC table write and lookup
> operations as well, for its stream identification functions, so export
> them in preparation of that.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---

I don't think this patch is my doing, is it? Can you please drop me from
the author and the sign-off? Thanks.

>  drivers/net/ethernet/mscc/ocelot.c |  6 ------
>  drivers/net/ethernet/mscc/ocelot.h | 13 -------------
>  include/soc/mscc/ocelot.h          | 19 +++++++++++++++++++
>  3 files changed, 19 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/ms=
cc/ocelot.c
> index 9f481cf19931..35006b0fb963 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -14,12 +14,6 @@
>  #define TABLE_UPDATE_SLEEP_US 10
>  #define TABLE_UPDATE_TIMEOUT_US 100000
> =20
> -struct ocelot_mact_entry {
> -	u8 mac[ETH_ALEN];
> -	u16 vid;
> -	enum macaccess_entry_type type;
> -};
> -
>  /* Must be called with &ocelot->mact_lock held */
>  static inline u32 ocelot_mact_read_macaccess(struct ocelot *ocelot)
>  {
> diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/ms=
cc/ocelot.h
> index 1952d6a1b98a..a77050b13d18 100644
> --- a/drivers/net/ethernet/mscc/ocelot.h
> +++ b/drivers/net/ethernet/mscc/ocelot.h
> @@ -54,19 +54,6 @@ struct ocelot_dump_ctx {
>  	int idx;
>  };
> =20
> -/* MAC table entry types.
> - * ENTRYTYPE_NORMAL is subject to aging.
> - * ENTRYTYPE_LOCKED is not subject to aging.
> - * ENTRYTYPE_MACv4 is not subject to aging. For IPv4 multicast.
> - * ENTRYTYPE_MACv6 is not subject to aging. For IPv6 multicast.
> - */
> -enum macaccess_entry_type {
> -	ENTRYTYPE_NORMAL =3D 0,
> -	ENTRYTYPE_LOCKED,
> -	ENTRYTYPE_MACv4,
> -	ENTRYTYPE_MACv6,
> -};
> -
>  /* A (PGID) port mask structure, encoding the 2^ocelot->num_phys_ports
>   * possibilities of egress port masks for L2 multicast traffic.
>   * For a switch with 9 user ports, there are 512 possible port masks, bu=
t the
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 682cd058096c..e6773f4d09ce 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -701,6 +701,25 @@ struct ocelot_skb_cb {
>  	u8 ts_id;
>  };
> =20
> +/* MAC table entry types.
> + * ENTRYTYPE_NORMAL is subject to aging.
> + * ENTRYTYPE_LOCKED is not subject to aging.
> + * ENTRYTYPE_MACv4 is not subject to aging. For IPv4 multicast.
> + * ENTRYTYPE_MACv6 is not subject to aging. For IPv6 multicast.
> + */
> +enum macaccess_entry_type {
> +	ENTRYTYPE_NORMAL =3D 0,
> +	ENTRYTYPE_LOCKED,
> +	ENTRYTYPE_MACv4,
> +	ENTRYTYPE_MACv6,
> +};
> +
> +struct ocelot_mact_entry {
> +	u8 mac[ETH_ALEN];
> +	u16 vid;
> +	enum macaccess_entry_type type;
> +};
> +

Also, I am not sure that ocelot_mact_entry needs to be exported. More
details in the next patch.

>  #define OCELOT_SKB_CB(skb) \
>  	((struct ocelot_skb_cb *)((skb)->cb))
> =20
> --=20
> 2.17.1
> =
