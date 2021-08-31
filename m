Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E473FC46E
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 11:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240388AbhHaImd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 04:42:33 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:20400
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240335AbhHaImc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 04:42:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ue/HL4A0LTiicxecAYwTcoG7pXohl5MtFBqgb9XhzRBUFYlxK0Bo42wZnCwpSKu1PphVOagcqT4pLFw7AQ8FuUnIMqLGbFT2uBFy3BPBROifrBek6/gOJK3N5iW7qIBeO+H8KubLBPiR+ANx8rHlMBnIoGXOdupqIHfcyO9UemnHlhWtQKRmJQcjeoYZ63res/nQrpSPGJLHu3/7ePcyQC6sDiN/YATVNMfMQvlmxlipopUuWPBeR64IfcoUQF52KlmRq1CoxYHDJKcD6gAFvtoU+uSLMzGY9Ls6b4aROunkQObes14x33X93MiX6VQR5htWnRTa4PijiYyBtokLig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nv3pk55351jWKZXzKOOyw6qYjz29EcUZrhtB5HiSVMc=;
 b=VJeVvZMJc+GTGhR8Wq9dvlb8cRJ0naBNGojSsh6aq5RP/Y94xxbCC+qfrrt7t8eNIgWq1chyz0O0xApmbThCWHUzRKkRkXYfiXFKGqHnNfcBxQjbz41WXAzhKiOPiog78m3elALhGQcdehgaWccPFW8W8P3te329TP3YD0HoyJoBq1lFXsntSkdYdURfPEwIlrW72Tj06FU3AZL6D0OWp2Z2JSDPpHt1ExDKZywDshtejl8+sVmZK6mAuqHb86ColWQQNcnvDEbBHODmoS8mngjYnIe0pr8n7MBcH31VU4j0D9pJFvZPdfwF2eXD/1CL3Lih5+dfxe2X69pK4HkUYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nv3pk55351jWKZXzKOOyw6qYjz29EcUZrhtB5HiSVMc=;
 b=C4O8X5tuXiDz4FVnrGWu77LE9D+fftI0b0K+2um3TCoLGtbCesvIm2E3iaFOhrUF3WBl7eX7iKXguDV4Jcm+gDjaf+kNKMM3WF3cBei07lxdzUDuG3LzQciDXjLfM7jm5E9V4Y/zxdZuXFSZqYMKd1dTEcwD4AWLLT7Iem0ng/o=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB8PR04MB7084.eurprd04.prod.outlook.com (2603:10a6:10:12e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Tue, 31 Aug
 2021 08:41:36 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::7c1f:f1c4:3d81:13fc]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::7c1f:f1c4:3d81:13fc%7]) with mapi id 15.20.4478.017; Tue, 31 Aug 2021
 08:41:36 +0000
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
        Leo Li <leoyang.li@nxp.com>
Subject: RE: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Topic: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Index: AQHXnhk3XLn1mK+aKEKIkxNIly6FZauNPsGAgAADucA=
Date:   Tue, 31 Aug 2021 08:41:36 +0000
Message-ID: <DB8PR04MB5785D9E678164B7CFE2A38CCF0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20210831034536.17497-1-xiaoliang.yang_1@nxp.com>
 <20210831034536.17497-6-xiaoliang.yang_1@nxp.com>
 <20210831075450.u7smg5bibz3vvw4q@skbuf>
In-Reply-To: <20210831075450.u7smg5bibz3vvw4q@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5fa32bd2-9e9a-47c9-7b11-08d96c5b24a3
x-ms-traffictypediagnostic: DB8PR04MB7084:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB708433D3ABD3BBC83AE70229F0CC9@DB8PR04MB7084.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QxSzgWCZQNrOw8SXOCjD7jr3OfO/InEsebk1yBdS7gNgwyAwfZvJVycCvG6C6yWBWTaaGtolsPAP/rToffPDWwZKzQZq03gFfXhqueRTmj357CRQqNbEP4M05joHU4btfElWFPkKGFRdh3/w7sRaiDtnASsAIhwcCODD7ZIKKV4/iiRLToVLBysd0DFNmUAKGyzAYuqdnYRLrZTN7MBrBynQZKbr/ah1UcG+rK5GS/c4Rswaeo9M0mYvZiw4YLjiamtJREjWtPZ6bJSKwl1yN5xGc2RVHgaa7qMPy+607Fi6GWUhEstwMZD1MWuWh5pvQQD6Sh4V+5I7GOwEKG1uUBY//Fj5Y/j7H7+cnxINZroJ+Fv7qaDCqbss+4i6hEIs6Q7zY4pqNm4vgiTlEntwPd5IfBaQQFmSZ32Hb/1Rf3QSY/lUzmh/TscQcpfEioksq+KO+BxVPtpkEOSO9DXNfiECqyBpZ4fvPFevgW/XizEICOq6zYU9Z4z2/maeD6HSfLBKlVpx5OFPIsEF7nxH4F6Lzfq8VSx153MKOphCPf0wAzORFsYWtwT2Dzn9CMnLFa0U+XN3HrsWtsAtw30tIeTSbiE4p0ErHqY7r/4KeVrhP0JDZ7v51depu8f3VFSzzHhnsYvXk9A/++hT97Z3wi2y5FqCHJqQDEDjeLRW7pfSDxAtTzkievWjnMjzJIUed/upBPICS3MRAkTghjL12A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(83380400001)(64756008)(4326008)(66446008)(478600001)(55016002)(2906002)(38100700002)(6636002)(66946007)(6506007)(66556008)(38070700005)(122000001)(66476007)(33656002)(76116006)(7696005)(6862004)(316002)(8936002)(86362001)(7416002)(9686003)(5660300002)(52536014)(54906003)(8676002)(186003)(26005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ukC/Y5xpsEryBh0/eWV6OPA7mBlhNdDrvKOND/PGHIaeajPx4UBUvZnpmAaS?=
 =?us-ascii?Q?fEAxTwcaONilT2r+XzcWkW4oev7AhUFsYSsX8GT0b1g6G+i/0JsDfET3DQmR?=
 =?us-ascii?Q?w4W72akDyLbiB8LXUFLCQ+untLxjSVTyiqtFMqTNaD9vDmDasw6vjtNGrzIB?=
 =?us-ascii?Q?i/P4sKDSdrjhY/TD0ywcGer2VXV+s/Ao4uZg2jyTy+PpAB6Mu/xLkWd7Dk9v?=
 =?us-ascii?Q?ezC4jHuPeN5BgFU0FzJtUxUYkpQiafy/tm7YwPJ+SYz7i+WCFc3UGldv2FyG?=
 =?us-ascii?Q?329YiRBcSotcmmuJR8ztvmw0zz2XFlTQMAj748jpHkLex1Rk7orCWC2vcM0I?=
 =?us-ascii?Q?ZtwxT++nGpKMFtwNHeXNEaJT1LRdqNZaDjP1P3WQxHCZNl+TW+BsSuAJx4Cv?=
 =?us-ascii?Q?/+hJ2m1VpzwDRaVwQn6gk8lFZtngfzCjnDJ8ioePvKCjLwoLt5YIjKkqJuKy?=
 =?us-ascii?Q?PfNeCUI0owSDV2BS454z0SZWFCy76dE8CsUlrgDAv2J67EO5neaADneRDJ/8?=
 =?us-ascii?Q?Tt0S2IJNXzr5qlZnTZkn4eKaLAT7AkUDrWzM3unoOluEt053z88b/a2jTkfS?=
 =?us-ascii?Q?TTOt6CWEzUTf9WPtq8t1Ut0aAX2eURnnckrAHzZAoDuntApeue8hmfqFpC0E?=
 =?us-ascii?Q?TGeS4iXx1LnGfeLpLBnpaQLzRwjNJzLJ+mePzFH+H5KxeXOh+9Az5UDhCaa7?=
 =?us-ascii?Q?1JTvJoJVErrWt50YY2u8QP/+d5CbBpZkO+uEXjI3+nbpl0DmQmNNYjozuKC+?=
 =?us-ascii?Q?A72rtrbTayC2DWOtXUG/xagKZ4y6WmUxE9aO5/mk+0Sv3G3oUTdX9/XWOPrl?=
 =?us-ascii?Q?VLze1rWCXJlN599rt9SiTP0aZZuz9yQHS++daN06wiWIPhk/pN5LVRLEklpu?=
 =?us-ascii?Q?hPQlk1DxHmtliWJX2+Nh4L5DzXqKp5Owz9VIPGdezbas5JGKMe4v+YtJtLIJ?=
 =?us-ascii?Q?jrZMHGJJHciUqylxnNqPSpTe/ra9fTLnpE5JATVclequfD+EmG8/nPqTGrWZ?=
 =?us-ascii?Q?GmXvAqQOk25/rnS/ax1vXj/kioqM5J0an/juWsJ8XLkWkYmOuezTHz7oqNg9?=
 =?us-ascii?Q?l69PQQHOIHr4wjaXpe05uRT0e3G7UXCvZUiTof+/GL2FE0PRNjYtkDe3E+Rp?=
 =?us-ascii?Q?egRvpmYzwM+fSMDFT60ZhOnDkmNjZGTBF8oUp9OtAxnmPoyUlM+48EQmQ04p?=
 =?us-ascii?Q?EyHpF/bwI0w1pGDlFSepm7U+iMyA6IY5ngwVb2vecSZdPBhtCWTEfrssfRcC?=
 =?us-ascii?Q?Cd7eum4v28q8Mk+gHG3b2pXHFZ3HjsYzl17JpHwLYkDx68QbXgFRqFhb9Zo/?=
 =?us-ascii?Q?/sxw0eGpXbrwyCLQKgc0+JC3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fa32bd2-9e9a-47c9-7b11-08d96c5b24a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 08:41:36.0973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /R15Ilgpk4hZiY7SUUqlXRx2ItXJ775lQ5ZJNasTqpzC/i7XGviNAliVPU4qOYLAMTBgpZq56kZrAx2a/ce8JrfHHn8mYwgBt2QJ+VKWp4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7084
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Tue, Aug 31, 2021 at 15:55:26AM +0800, Vladimir Oltean wrote:
> > +static int vsc9959_mact_stream_set(struct ocelot *ocelot,
> > +				   struct felix_stream *stream,
> > +				   struct netlink_ext_ack *extack) {
> > +	struct ocelot_mact_entry entry;
> > +	u32 row, col, reg, dst_idx;
> > +	int ret;
> > +
> > +	/* Stream identification desn't support to add a stream with non
> > +	 * existent MAC (The MAC entry has not been learned in MAC table).
> > +	 */
>=20
> Who will add the MAC entry to the MAC table in this design? The user?

Yes, The MAC entry is always learned by hardware, user also can add it by u=
sing "bridge fdb add".

>=20
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
> > +	reg =3D ocelot_read(ocelot, ANA_TABLES_STREAMDATA);
> > +	reg &=3D (ANA_TABLES_STREAMDATA_SFID_VALID |
> ANA_TABLES_STREAMDATA_SSID_VALID);
> > +	entry.type =3D (reg ? ENTRYTYPE_LOCKED : ENTRYTYPE_NORMAL);
>=20
> So if the STREAMDATA entry for this SFID was valid, you mark the MAC tabl=
e
> entry as static, otherwise you mark it as ageable? Why?

If the MAC entry is learned by hardware, it's marked as ageable. When setti=
ng the PSFP filter on this stream, it needs to be set to static. For exampl=
e, if the MAC table entry is not set to static, when link is down for a per=
iod of time, the MAC entry will be forgotten, and SFID information will be =
lost.
After disable PSFP filter on the stream, there is no need to keep the MAC e=
ntry static, setting the type back to ageable can cope with network topolog=
y changes.=20

