Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D081415571
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 04:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238909AbhIWCb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 22:31:56 -0400
Received: from mail-eopbgr50058.outbound.protection.outlook.com ([40.107.5.58]:54110
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238859AbhIWCbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 22:31:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNPgzDUUai3/h0Cjdkqx2vdKQCP94pb2zTmJr/fe429P2wTCyishb2Q5iAK9ObO7uXrCvcXPqT9uC97aLmnnsO3gdlIVq3lztWMQLr1/M/nzCsyUinykhZk6T1SM+4Ceukzu2H3h0wE5+sed4+NHF8i0sJCegruaOsYd9dpfzonU56bo9rWYMZ0BCdO4e459XQHLscaVRvl5noImF3T1fQb89t2HjSfzBf0X2KVbV722/WH+WP/QoABmtzfySf4krdRatNUGeff0PGtlQjFkubqSkJqcYBG2QVYpDfGCAa2rntJoEIChsXaAI+xmv1J2gtCgI8w9VvM/fGKShysFwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=tDeLsSX2Ewc3NdrvaAAZ1tB4vEa8WFAkZQMLsI4GqmA=;
 b=kp4/QpDngB1CGise2ahYi6DXntVVqqhqnpA9GwdGtqhEbTNRCREAsyrNUVIwacMm7pKAhlSoeB76sA8uHyRvdPumwtMz1hf6Za9HCl/qugdgLYLUlwhLmLYMpqr7alfXwtAcyqjsQUUs88TS0lEiKldZvvEs0yol8CID0K6ExFYOW0fltmhFlbt+M2Q/xlx0pPfFfJiyYbgpTTTYsJIXAwlkFYKnI7HQxT5vKha455tE196nChX707c1t0w40yEKSKhEn+ES5cG7Q45FlWWmgIzYXpYg2Nz6rLvtDd8oFVZuivZawG6gITj/rvbP52/N4KD8piNGcTdRSU6tRmHABg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDeLsSX2Ewc3NdrvaAAZ1tB4vEa8WFAkZQMLsI4GqmA=;
 b=J4iECSz6igQWZTXokqGHD5ecXFKgYej0gCTkYbRCQKoxScOfo4uZ3vRuwlkuDHIvAoVrwerecZ2C/mQ1JnPCot9ShnzxFiH7EgiCqcf039hgvCSK9Anlb2AtcwV+/p6r4CLwcyIbvDPNae7+USLLzv9sJ73UhbPJr4xt9K9nfG8=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DBAPR04MB7333.eurprd04.prod.outlook.com (2603:10a6:10:1b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Thu, 23 Sep
 2021 02:30:22 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::7c1f:f1c4:3d81:13fc]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::7c1f:f1c4:3d81:13fc%7]) with mapi id 15.20.4544.014; Thu, 23 Sep 2021
 02:30:16 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
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
Subject: RE: [PATCH v4 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Topic: [PATCH v4 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Index: AQHXr56G+7I3t59N40au/ymUR0+Ct6uwAOeAgADj42A=
Date:   Thu, 23 Sep 2021 02:30:16 +0000
Message-ID: <DB8PR04MB578547CBED62C7EEA9F8F534F0A39@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20210922105202.12134-1-xiaoliang.yang_1@nxp.com>
 <20210922105202.12134-6-xiaoliang.yang_1@nxp.com>
 <20210922124758.3n2yrjgb6ijrq6ls@skbuf>
In-Reply-To: <20210922124758.3n2yrjgb6ijrq6ls@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f40b2c2-cb89-456f-455c-08d97e3a1436
x-ms-traffictypediagnostic: DBAPR04MB7333:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB733326990B2E318BA9CCB932F0A39@DBAPR04MB7333.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5OrzVAFqHc2ra+44wNKHLSlCyzX2dhP3BfQ+FPdOBCxAkp1+l/5xPrsqiXkR+giAmHyDztVXQE3gvKd8xaYNrVwg1VafyyUxfCBrq2asMGrdJ7g2Y0Isc+e1OgaAJ8foV0QNyuE7Py3kh3K1xUybBLmDHKg2cxcN4hJVkGYW45Q4s7uP0QwtrI4A8PRddXO6ppmNyn4izpv9Em+mma6CgyeThODmdh9lAwaoR2QItJZiiQtiv3PvZsXnKdTpJb114vJecLLeEjAawjrMWYKWlQvetttRmeb/DhLxchMrNoE6krF/FIA7DHUNCAh8MlfzKtFRP+A4AJK5FjurE5x02aIL3Nw07Vct3lS+bIxn7dDXu/kMgAIxL+3pFwIar+vmWrxsIg7p/fvicJacDsprzfBgSP/WuzFdutsaQCFh9L0I4lZYzA8IhW84YqwhMeKMPbIqvXFdNnpoVbWBJAFFyM9TJii2PAPVLVVOqBhm3suHCBY/fTDuwo3eEYruKBx/5Q9AL4f8lpxYfc6q22hHv00ggQqB0SSFeilXfgiVRyGF4T0tg6+cs512+Ihiu4kqHbK9osBx0q8ASlrNYqAcEYiXGZiy6iI8THcY+MSTe9neWcHJ7RtDD460dveOEjtj0ETyXKYNIdulFkOY2qQ9d4LjJq1xrjf1JunkS3Pg+waSdkZUHuaqm2qLl9/6XmxhGq5pQEcgH7svg5dzl+0vXw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(76116006)(86362001)(53546011)(52536014)(55016002)(71200400001)(8676002)(26005)(33656002)(122000001)(66476007)(66556008)(4326008)(54906003)(7416002)(2906002)(38070700005)(38100700002)(316002)(6636002)(66446008)(66946007)(9686003)(186003)(8936002)(508600001)(6506007)(5660300002)(64756008)(83380400001)(6862004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xaEDWrGfKYgRjppbrY+YXhUTpFxv6YIAxkBHLMYmIw2YnaZnVNpY5zRC9Zlx?=
 =?us-ascii?Q?dyybhuRE8V1WTrUnbfRXdta9tQf03fk3Y6GRDACH0JsXq+W95fWxM7hOIYcs?=
 =?us-ascii?Q?+JnNR1Bs3H3waPth3+m0td4VSYX6SpPVUMXMSFqx3QYFXxeEjATv8RV8Fu15?=
 =?us-ascii?Q?QfKHsXUL6M9p7eSkja39YW8mz4n7DZV0on+LEeAHUW5NOB2JpwpkPUrVMkOB?=
 =?us-ascii?Q?uor9dH4o5rV4/JYp2VqO6BUMs/5xf73y88mkM1NJeoxSrCzURgGPmFO9S2S5?=
 =?us-ascii?Q?UxQDe2DcqDK5YlMZ8gdm4h26lKF+JuLmUPWDUZyHNZufgrA293oAZ9JIf8/z?=
 =?us-ascii?Q?woICU2+5fL3mIzvc6EnIC7FsF1m2WK5v/Ax7kwhXl++ktOJQk3xgF4UVA4pA?=
 =?us-ascii?Q?0htHsGObgF1j+1ezTmK0KJ1pgUdV16G+sfmvgQIvp69ytg9S+NcybNqYYbjt?=
 =?us-ascii?Q?KTFaPvUJf+OmEHnl5qW+OMYhn9lmqp/o5TQkvi1A/xWjS2xGMyzi9jAWl0wN?=
 =?us-ascii?Q?7wEcO4837Uz0MYd+iHep+d6mIoR3BCYEXpSz7AiqhK1oRhxxehggEUnh0aT9?=
 =?us-ascii?Q?9TVsHa3fm9yj9dy54zjIaQZVVr+VZiUWNnNSApRFRQ+4iQuec/L2O/6A+Hjb?=
 =?us-ascii?Q?pDcjAfwQB3Yu/OfgtHqmqWXVmcHPqVOQ6Py/hTa77iMHKV09c/tq/OioV7BK?=
 =?us-ascii?Q?OR/T5QaHGZ4ObEfyZLh+KapsxjQPezToLDLXsU7abTWJ2y7wr5d6uBo3OZps?=
 =?us-ascii?Q?4rLVvLrCii+1SnlP0+ewrPKA976sEBWyw5WSOt59DDQXHgqLO28vYeYOj9qr?=
 =?us-ascii?Q?zojnKDPjPX0CUbgs2A4vWw51WBK4m3ukQycc8UccBk/wZ+KGMPA46er7dnmC?=
 =?us-ascii?Q?GzxpK/S0q/nYj+IqnpTxoJYrHqyBVlFQKQJ5p8x8OcgpZrm48ZRv+Yn8XGaw?=
 =?us-ascii?Q?r8dfLnzJd7R3LIJtQz64LHIZqr/WbyLmDiPX/rVM/nMJ3TqFdmpWkFnvsxAw?=
 =?us-ascii?Q?u9ADh/xvbdFJvKGbq8SlCA7qUdhHdkI+0fipV+XhAbAGptt6k7DTpZHJE+Og?=
 =?us-ascii?Q?+yxE6bdLcqIDfnBHYDiREvonsr2rwFkdWtmuFKG/DnBUIdmBf+H+9uBqKJiQ?=
 =?us-ascii?Q?R4Zza11mS5Ik3o8aaHl/5Qyl5esjjYnIuB8QohsCO+fnlTRmaYTLhd65E6jz?=
 =?us-ascii?Q?K96XmBNDty65pYeoG1O2HfZ3sQ5cNa4GjvTeNZ97flanKIrFHpneKYOeSRAu?=
 =?us-ascii?Q?Mlm2hrqQlk2303fE3TnZUEQvxW0BL99nyLee501XJUVjzZ1B5YDC4ZDy2sXK?=
 =?us-ascii?Q?LDeWVLiW4NWu/7zxa2Fld+HJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f40b2c2-cb89-456f-455c-08d97e3a1436
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 02:30:16.0910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgxCp+pk2oOuVhhV9tx2weU5Y5Z3XKZhY/OILPbef2Mg/dlGBdu+jhK2hA0ZnIHHSIaQN9D6//koj1weoquQ6SBbKauXkyJsxmTi/T9BtwA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Wed, Sep 22, 2021 at 12:47:59 +0000, Vladimir Oltean wrote:
> > +static int vsc9959_mact_stream_set(struct ocelot *ocelot,
> > +				   struct felix_stream *stream,
> > +				   struct netlink_ext_ack *extack) {
> > +	struct ocelot_mact_entry entry;
> > +	u32 row, col, reg, dst_idx;
> > +	u8 type;
> > +	int ret;
> > +
> > +	/* Stream identification desn't support to add a stream with non
> > +	 * existent MAC (The MAC entry has not been learned in MAC table).
> > +	 */
> > +	ret =3D ocelot_mact_lookup(ocelot, stream->dmac, stream->vid, &row,
> &col);
> > +	if (ret) {
> > +		if (extack)
> > +			NL_SET_ERR_MSG_MOD(extack, "Stream is not learned in MAC
> table");
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	ocelot_rmw(ocelot,
> > +		   (stream->sfid_valid ? ANA_TABLES_STREAMDATA_SFID_VALID : 0)
> |
> > +		   ANA_TABLES_STREAMDATA_SFID(stream->sfid),
> > +		   ANA_TABLES_STREAMDATA_SFID_VALID |
> > +		   ANA_TABLES_STREAMDATA_SFID_M,
> > +		   ANA_TABLES_STREAMDATA);
> > +
> > +	reg =3D ocelot_read(ocelot, ANA_TABLES_MACACCESS);
> > +	dst_idx =3D (reg & ANA_TABLES_MACACCESS_DEST_IDX_M) >> 3;
> > +	type =3D ANA_TABLES_MACACCESS_ENTRYTYPE_X(reg);
> > +
> > +	reg =3D ocelot_read(ocelot, ANA_TABLES_STREAMDATA);
> > +	if ((ANA_TABLES_STREAMDATA_SFID_VALID |
> > +	     ANA_TABLES_STREAMDATA_SSID_VALID) & reg) {
> > +		entry.type =3D (type ? type : ENTRYTYPE_LOCKED);
> > +		stream->rsv_type =3D type;
> > +	} else {
> > +		entry.type =3D stream->rsv_type;
> > +	}
> > +
> > +	ether_addr_copy(entry.mac, stream->dmac);
> > +	entry.vid =3D stream->vid;
> > +
> > +	ocelot_mact_write(ocelot, dst_idx, &entry, row, col);
> > +
> > +	return 0;
> > +}
>=20
> > +static int vsc9959_stream_table_add(struct ocelot *ocelot,
> > +				    struct list_head *stream_list,
> > +				    struct felix_stream *stream,
> > +				    struct netlink_ext_ack *extack) {
> > +	struct felix_stream *stream_entry;
> > +	int ret;
> > +
> > +	stream_entry =3D kzalloc(sizeof(*stream_entry), GFP_KERNEL);
> > +	if (!stream_entry)
> > +		return -ENOMEM;
> > +
> > +	memcpy(stream_entry, stream, sizeof(*stream_entry));
> > +
> > +	ret =3D vsc9959_mact_stream_set(ocelot, stream_entry, extack);
> > +	if (ret) {
> > +		kfree(stream_entry);
> > +		return ret;
> > +	}
> > +
> > +	list_add_tail(&stream_entry->list, stream_list);
> > +
> > +	return 0;
> > +}
>=20
> Remember this discussion we had a while ago?
>=20
> | Let's take the function below.
> |
> | static void ocelot_prove_mac_table_entries_can_move(struct ocelot
> | *ocelot) {
> | 	unsigned char mac1[ETH_ALEN] =3D {0x00, 0x04, 0x9f, 0x63, 0x35, 0xea};
> | 	unsigned char mac2[ETH_ALEN] =3D {0x00, 0x04, 0x9f, 0x63, 0x35, 0xeb};
> | 	int row, bucket, arbitrary_pgid =3D 4;
> | 	int vid1 =3D 102;
> | 	int vid2 =3D 103;
> | 	int err;
> |
> | 	err =3D ocelot_mact_learn(ocelot, arbitrary_pgid, mac1, vid1,
> | 				ENTRYTYPE_LOCKED);
> | 	if (err)
> | 		return;
> |
> | 	err =3D ocelot_mact_lookup(ocelot, mac1, vid1, &row, &bucket);
> | 	if (err)
> | 		return;
> |
> | 	dev_info(ocelot->dev,
> | 		 "Address 1 (mac %pM vid %d) is in MAC table row %d
> bucket %d\n",
> | 		 mac1, vid1, row, bucket);
> |
> | 	err =3D ocelot_mact_learn(ocelot, arbitrary_pgid, mac2, vid2,
> | 				ENTRYTYPE_LOCKED);
> | 	if (err)
> | 		return;
> |
> | 	err =3D ocelot_mact_lookup(ocelot, mac2, vid2, &row, &bucket);
> | 	if (err)
> | 		return;
> |
> | 	dev_info(ocelot->dev,
> | 		 "Address 2 (mac %pM vid %d) is in MAC table row %d
> bucket %d\n",
> | 		 mac2, vid2, row, bucket);
> |
> | 	err =3D ocelot_mact_lookup(ocelot, mac1, vid1, &row, &bucket);
> | 	if (err)
> | 		return;
> |
> | 	dev_info(ocelot->dev,
> | 		 "Address 1 (mac %pM vid %d) is in MAC table row %d
> bucket %d\n",
> | 		 mac1, vid1, row, bucket);
> | }
> |
> | What will it print?
> |
> | Address 1 (mac 00:04:9f:63:35:ea vid 102) is in MAC table row 917
> | bucket 0 Address 2 (mac 00:04:9f:63:35:eb vid 103) is in MAC table row
> | 917 bucket 0 Address 1 (mac 00:04:9f:63:35:ea vid 102) is in MAC table
> | row 917 bucket 1
> |
> | What does this mean?
> |
> | The ROW portion of a FDB entry's position within the MAC table is
> | statically determined using an 11-bit hash derived from the {DMAC,
> | VID} key. Within a row, there can be up to 4 buckets, each bucket
> | holding 1 MAC table entry.
> |
> | But when the hashes of 2 addresses collide and they end up in the same
> | row (as in the above example, with address 1 =3D "mac 00:04:9f:63:35:ea
> | vid 102" and address 2 =3D "mac 00:04:9f:63:35:eb vid 103"), things
> | don't happen quite as you might expect. Namely, the second address
> | appears to be installed by the switch at the same row and bucket as
> | the first address. So is the first address overwritten? No, it has
> | been moved by the switch, automatically, to bucket 1.
>=20
> So if the autonomous and concurrent learning of one MAC address might
> move existing MAC table entries from a row to the right, then who guarant=
ees
> exactly that the {row, col} for which you are setting up the SFID is the =
{row, col}
> that belongs to the {stream->dmac, stream->vid} you have searched for?
>=20
> Microchip people, do we need to temporarily disable hardware address
> learning on all ports, and take a lock with the FDB add and delete operat=
ions
> to ensure they are serialized?

Maybe we need to use ocelot_mact_learn() instead of ocelot_mact_write() aft=
er setting SFID in StreamData. I think this can avoid writing a wrong entry=
.

Regards,
Xiaoliang
