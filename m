Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9880B414995
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 14:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbhIVMth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 08:49:37 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:15430
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236137AbhIVMtc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 08:49:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qq/PrJPD4QzqKYPScdVKXMkLjB7mZ+XAtTqLTRUeihKZx0bkA6epdJoonZAp93jp2M6ctvKH4zh5urE3NOFg3bh4h4NVGJcIZ88xe+I4ZEKIsTltuSiLM9Jb1RVKNR+L070OM6GrAs/1SLdraNln9CP1jGD8TnTb6CTRblH+B/ShakeIk6awQ8iptM4XV2aLsdTPvCdiBM4vzqnPlOj0hBeiG14QclF3mV7/fvbKTs/5ja5x7eRkeNXUbUf3bJgwQRKpR03XnDXkiyrhilYy1lJPCInklcOL7utVMGxYhl76pPNsSJUyWCyqjidBKojwnG4Ji17m0PGnOxQJHnKtyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=1yZNsYiQS92e63La/zDVyVa7t0dyUMuCanfkGV0c5wo=;
 b=EXevKur9tEwaCP9SQQNYmXXslxGsRccYb11yQduWPISNw8l3n1OCr91kDMArpWIKFSIZMxvTn/KZ3liTWwSRvS8+pjVQYOyZEI2V81bbi/oKgJ0IIiUT4v4vVc1gfwOKlK9zoxqKy9BnsemDdSIQskyZDUWS4Tug/b0M+MLkDWgoBgTGDeQbhp0WkLaofk3EYSBX2w58SuUbKdFZQxIihjTGh1qdzd0L1kgm/D6kf8VUuGpbuQok004zEKiq0A22xTODXKajXKAC260Hvx5xlQCy3ptVTfMfhf6Uw2vOfux7Aq6MpJyGbKYPpws6Kj+Od6Tzz3CGXQTbIquRE3Fgpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1yZNsYiQS92e63La/zDVyVa7t0dyUMuCanfkGV0c5wo=;
 b=GekG+JEeg8I8gSRBNcCoi+5eggqvGFgZQp03NXTT9cJ78ip9QWjEKp73HKM65bKuMAUWAS6DGnWiirBDpHf4LhYyH1N7rCYCbYhh9Iq2hgElTOqkbmzAbWtI4wx6TOOFBvzQek2ipx+abp2ZwJ/zcWJKTI9L0+pD36R6/IIT6Ec=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2511.eurprd04.prod.outlook.com (2603:10a6:800:50::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Wed, 22 Sep
 2021 12:48:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 12:47:59 +0000
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
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v4 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Topic: [PATCH v4 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Index: AQHXr56GWZAJ2atrv0ecdycHDF0T3KuwAOYA
Date:   Wed, 22 Sep 2021 12:47:59 +0000
Message-ID: <20210922124758.3n2yrjgb6ijrq6ls@skbuf>
References: <20210922105202.12134-1-xiaoliang.yang_1@nxp.com>
 <20210922105202.12134-6-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20210922105202.12134-6-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d35bcd6f-e738-47e6-b259-08d97dc7351a
x-ms-traffictypediagnostic: VI1PR0401MB2511:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB251118E13850A36B98063E70E0A29@VI1PR0401MB2511.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IwljJXKxokZsVCCNNzD2h+Oe9OtnqnZ/o17QplQlfAEGJ+0Kq0R/USY7UbSLSxV4AW4WvQNgZuSA4IBFwGUty/4lqGFKPPSCVpkoynYBsZ8h9nEnJVzqECWDg2A4Iope7/EBJ6Hin2wdKoXCHi8bxFedh3mP1gmFEqzR7jsbN2fSqGbRgN0BeT10+nZKEMq6s0UZxLI6/d+xs3qPlnzRwWYyhE+4UymTp7pKwvx0gDIJeyQRzvYYrTDiXOrGIn0xfwxQrcHMVuEECpQdb4RpojoqCBI80d7dS2ZZ6DJxFsvxp2zqCIfBOuTRNmKTaK+cDHieWBukkZrs8+JaHqIxipAyHzicGBWx1+KThCCwNnokhEfriQtx81p3K/EG9f8+zufqTwaPVpz5UPBVXVy4LZUDy8uN+ssjciUL9jGk+hSpPU+NQfnZeBx8kBQ5Bxpp+qMgWQ0X78Uo9vZg/Jh01A8iBUyKPTzLk66kqt2ai1bQmHzAUFA3OAciwnnvV3bKMci+JuWwdioGOt1S4vSijktav9ZWUDXscMlglb4Q5n/lRih5iVt1TYQRg7jw3LLG09o2bOx1WAdd73zf1ADFe5O4vT+sLeUBPBPYpgaErP/52yWVZLT5ObBY6MbECovWGA23rcRrlYyICHPZzpOXQlz9ES9EDRIkkDV9/FYh9FumHeuqc6fDMS9JdQ1uHa0jkHvWqDIQkPVJFhnyTpdS1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(6512007)(76116006)(7416002)(91956017)(26005)(38100700002)(66446008)(6862004)(316002)(66556008)(6506007)(9686003)(4326008)(64756008)(83380400001)(122000001)(71200400001)(2906002)(38070700005)(5660300002)(86362001)(508600001)(33716001)(44832011)(1076003)(66946007)(6486002)(6636002)(66476007)(8936002)(54906003)(186003)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+X0rSUWwHe/OV8MWVrVAGj8hy13c0TVynehrIqsL+2SGIWxui07IDosSbQDz?=
 =?us-ascii?Q?MLZ46MfO7OGQ224bTvq3t7xpK3L77Izw2ERVbwLjBGM4Cyu9OtZiJORz4t9r?=
 =?us-ascii?Q?pLvbAC3Ynlc0+KG/yJ4Y3/LP/zS7BWomiJV8DH004Jsy7fROKT3hLTsMLP8n?=
 =?us-ascii?Q?F877uDAl46RCB4DprtW2dBUbKtXKs27h3rjfWRmU5rHHpaglMB1CZZ9cLAR8?=
 =?us-ascii?Q?MIw1PigdqbflNvFLcQce07jgUTI0LbcrAQIC1gP60i0zx193jW/HTkdINQah?=
 =?us-ascii?Q?jzAlfOL3zhBv3U3VzlyTvIWQYLOKTZmT/KRNYssUrvRudHR6Gh/VEqIM9DqB?=
 =?us-ascii?Q?Zj1adqkN6Ml+5TbAtIe3uGEr2TPcc1CetEWvhl69jD2NHhSd0b4VhmVhbz1p?=
 =?us-ascii?Q?XhiLsb+aeVKC89NOgUa/dMATtU9J4ejk0MdeYyYLt0UR746dU+G9tJ9K7hYG?=
 =?us-ascii?Q?PdquUBNFcCer1gf67OSC3bskjzE5KmkfC2uM2O7HV8XqOtt9PHfl38QS/4+c?=
 =?us-ascii?Q?Nd47XCt2UgIECh/VPr/MCBdVDDsd4jN0mNfp6GAtrUku3L1HEbS4KyUudSsL?=
 =?us-ascii?Q?MbJR0xEF6WzTZnUd61PWtEIod7SYRlWhimpijp/2HihP9/sSVWrG1EYYUVN8?=
 =?us-ascii?Q?GZUlCAaZxUjahm1W55M3ZNu/T4yOvHsbJa/d+cZ7eyTNY7+LHploFcQMNet2?=
 =?us-ascii?Q?t0nfNsfIkhzTwHWgVq5QQAuAefENFsdisRVqOVM3+DM1t2MVrDlcspxiOCSg?=
 =?us-ascii?Q?BI++OgKAw1NspZfFXURB3QKR+o0ACs/qbn4v7sZ5EVrUFkNUGAo81wXMCSeH?=
 =?us-ascii?Q?JjSsCg5X7uv1xJrY0xM02QE4abssYnpmJnaxaXc69KM+NbkWzaGoRcZDQcSo?=
 =?us-ascii?Q?voMsTPScYK87iGdp/RH+cv+k9M+Em4/nsgaYWOAyfy5m6vzz461fo5MkMjxc?=
 =?us-ascii?Q?IM4qZZVibOBosmvc1h8occaT3miPhXivcAe/4MglWBa5t+h2nL4FlZ43yrdj?=
 =?us-ascii?Q?FgfHR8cOMVC9WY1i7dI9ODUhoGgf0t5YzWN8vWrKbVmubrC9zDFwKcp/5nUh?=
 =?us-ascii?Q?lvCL5nmYjR2zxx/iNfAMsmkDtPv+WC3qHrC1hRo7ZgXfOkXPoVg/3RIsfcCo?=
 =?us-ascii?Q?Ny/o9OzKmW8cxEvbXPRNrffw8vBbPACxs5uJX2b8IlQ4SMlEpWnov0OKIIWX?=
 =?us-ascii?Q?qan5rE/sNiV0/G1BFmzJq1r6XlkaAODTgsIYom6c6bdibdfvP+F9cqpTBT9B?=
 =?us-ascii?Q?y6PNm8LsXLd4cpLa/49s7AZvuNc6FRKBbDAlat/GvcFRv8ohc1vMKyZsJ8O9?=
 =?us-ascii?Q?kf5oPqt8x85Pgc9R+z4J9j5P?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DEE9DBB16D187849A06B020837AA3E2B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d35bcd6f-e738-47e6-b259-08d97dc7351a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 12:47:59.1832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8JvzJnmxSa4kc+Gj5YiF8VlklDKUw/hdFxQ/BLc/45JZTsTwvNWPMre148znQwU9rJ1zeqnS9xZ80eLh4eZjfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Xiaoliang,

On Wed, Sep 22, 2021 at 06:51:59PM +0800, Xiaoliang Yang wrote:
> +static int vsc9959_mact_stream_set(struct ocelot *ocelot,
> +				   struct felix_stream *stream,
> +				   struct netlink_ext_ack *extack)
> +{
> +	struct ocelot_mact_entry entry;
> +	u32 row, col, reg, dst_idx;
> +	u8 type;
> +	int ret;
> +
> +	/* Stream identification desn't support to add a stream with non
> +	 * existent MAC (The MAC entry has not been learned in MAC table).
> +	 */
> +	ret =3D ocelot_mact_lookup(ocelot, stream->dmac, stream->vid, &row, &co=
l);
> +	if (ret) {
> +		if (extack)
> +			NL_SET_ERR_MSG_MOD(extack, "Stream is not learned in MAC table");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	ocelot_rmw(ocelot,
> +		   (stream->sfid_valid ? ANA_TABLES_STREAMDATA_SFID_VALID : 0) |
> +		   ANA_TABLES_STREAMDATA_SFID(stream->sfid),
> +		   ANA_TABLES_STREAMDATA_SFID_VALID |
> +		   ANA_TABLES_STREAMDATA_SFID_M,
> +		   ANA_TABLES_STREAMDATA);
> +
> +	reg =3D ocelot_read(ocelot, ANA_TABLES_MACACCESS);
> +	dst_idx =3D (reg & ANA_TABLES_MACACCESS_DEST_IDX_M) >> 3;
> +	type =3D ANA_TABLES_MACACCESS_ENTRYTYPE_X(reg);
> +
> +	reg =3D ocelot_read(ocelot, ANA_TABLES_STREAMDATA);
> +	if ((ANA_TABLES_STREAMDATA_SFID_VALID |
> +	     ANA_TABLES_STREAMDATA_SSID_VALID) & reg) {
> +		entry.type =3D (type ? type : ENTRYTYPE_LOCKED);
> +		stream->rsv_type =3D type;
> +	} else {
> +		entry.type =3D stream->rsv_type;
> +	}
> +
> +	ether_addr_copy(entry.mac, stream->dmac);
> +	entry.vid =3D stream->vid;
> +
> +	ocelot_mact_write(ocelot, dst_idx, &entry, row, col);
> +
> +	return 0;
> +}

> +static int vsc9959_stream_table_add(struct ocelot *ocelot,
> +				    struct list_head *stream_list,
> +				    struct felix_stream *stream,
> +				    struct netlink_ext_ack *extack)
> +{
> +	struct felix_stream *stream_entry;
> +	int ret;
> +
> +	stream_entry =3D kzalloc(sizeof(*stream_entry), GFP_KERNEL);
> +	if (!stream_entry)
> +		return -ENOMEM;
> +
> +	memcpy(stream_entry, stream, sizeof(*stream_entry));
> +
> +	ret =3D vsc9959_mact_stream_set(ocelot, stream_entry, extack);
> +	if (ret) {
> +		kfree(stream_entry);
> +		return ret;
> +	}
> +
> +	list_add_tail(&stream_entry->list, stream_list);
> +
> +	return 0;
> +}

Remember this discussion we had a while ago?

| Let's take the function below.
|=20
| static void ocelot_prove_mac_table_entries_can_move(struct ocelot *ocelot=
)
| {
| 	unsigned char mac1[ETH_ALEN] =3D {0x00, 0x04, 0x9f, 0x63, 0x35, 0xea};
| 	unsigned char mac2[ETH_ALEN] =3D {0x00, 0x04, 0x9f, 0x63, 0x35, 0xeb};
| 	int row, bucket, arbitrary_pgid =3D 4;
| 	int vid1 =3D 102;
| 	int vid2 =3D 103;
| 	int err;
|=20
| 	err =3D ocelot_mact_learn(ocelot, arbitrary_pgid, mac1, vid1,
| 				ENTRYTYPE_LOCKED);
| 	if (err)
| 		return;
|=20
| 	err =3D ocelot_mact_lookup(ocelot, mac1, vid1, &row, &bucket);
| 	if (err)
| 		return;
|=20
| 	dev_info(ocelot->dev,
| 		 "Address 1 (mac %pM vid %d) is in MAC table row %d bucket %d\n",
| 		 mac1, vid1, row, bucket);
|=20
| 	err =3D ocelot_mact_learn(ocelot, arbitrary_pgid, mac2, vid2,
| 				ENTRYTYPE_LOCKED);
| 	if (err)
| 		return;
|=20
| 	err =3D ocelot_mact_lookup(ocelot, mac2, vid2, &row, &bucket);
| 	if (err)
| 		return;
|=20
| 	dev_info(ocelot->dev,
| 		 "Address 2 (mac %pM vid %d) is in MAC table row %d bucket %d\n",
| 		 mac2, vid2, row, bucket);
|=20
| 	err =3D ocelot_mact_lookup(ocelot, mac1, vid1, &row, &bucket);
| 	if (err)
| 		return;
|=20
| 	dev_info(ocelot->dev,
| 		 "Address 1 (mac %pM vid %d) is in MAC table row %d bucket %d\n",
| 		 mac1, vid1, row, bucket);
| }
|=20
| What will it print?
|=20
| Address 1 (mac 00:04:9f:63:35:ea vid 102) is in MAC table row 917 bucket =
0
| Address 2 (mac 00:04:9f:63:35:eb vid 103) is in MAC table row 917 bucket =
0
| Address 1 (mac 00:04:9f:63:35:ea vid 102) is in MAC table row 917 bucket =
1
|=20
| What does this mean?
|=20
| The ROW portion of a FDB entry's position within the MAC table is
| statically determined using an 11-bit hash derived from the {DMAC, VID}
| key. Within a row, there can be up to 4 buckets, each bucket holding 1
| MAC table entry.
|=20
| But when the hashes of 2 addresses collide and they end up in the same
| row (as in the above example, with address 1 =3D "mac 00:04:9f:63:35:ea
| vid 102" and address 2 =3D "mac 00:04:9f:63:35:eb vid 103"), things don't
| happen quite as you might expect. Namely, the second address appears to
| be installed by the switch at the same row and bucket as the first
| address. So is the first address overwritten? No, it has been moved by
| the switch, automatically, to bucket 1.

So if the autonomous and concurrent learning of one MAC address might
move existing MAC table entries from a row to the right, then who
guarantees exactly that the {row, col} for which you are setting up the
SFID is the {row, col} that belongs to the {stream->dmac, stream->vid}
you have searched for?

Microchip people, do we need to temporarily disable hardware address
learning on all ports, and take a lock with the FDB add and delete
operations to ensure they are serialized?=
