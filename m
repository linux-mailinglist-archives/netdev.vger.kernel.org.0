Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61AC3FC48F
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 11:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240524AbhHaJAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 05:00:55 -0400
Received: from mail-eopbgr60048.outbound.protection.outlook.com ([40.107.6.48]:57523
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240405AbhHaJAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 05:00:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDBaDdryANPsP9ps9xyD8oZMwm+u4ClHM51eBQQ8xWPQQ09DLfdCUTTAuWLaVXbixfiPsiCwXcjg9k9vcG0Nou4Ax8zW7irsVfe43GupHO4obyc6RdBdSIgS5JIbYuqVLfnIfQoZMHpmGbAXZGNiimsdY54Qb2BHSCjYaWpvbOpOkufVg+KNHcrgEvFdoFa/GGuatAViW1A9ab7FePRwACQaLQymK836JesbVH9CtBXWGwbof3Wcj7QTNFtBWsaV5djNBD/W2plO6yRkO/we0Qjvvm2Ptv89ikX5ItYohmTqrDdwK2x9CnO/s+FdU0AaKesG/sC3igMLax35ysqUeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7uLyLVKP/G+Ob8OqD7LSwTqd1+QgbJGdGllZd0ayBU=;
 b=LcHnWQ3fbGaSn9XaWzY8BW0A0aWyRmZ//FJngzJEt+/HqNVReqVbHrv1TIgwkpyMZmYU/+B2BSO2d9OcJGgV92qNDaBeeItWXTv1iD+2n7VFJbWqFm4tidHeZmNNMWQGCS4vHsKaiG1iXVe6MwtBRDpLH6x5yY/g+BeqAi+/Xn1cyhcWy8KZZfXsXYvdtcvffWvA56S4BYqGWTvBvQJuJ1yJftQIKQEtWPREL6705ze8y9nm6ZsEyGKKlJ0f3TPixbcW13alFlrPE7ScyUvmGhwLeK3tObpY0omze5qFd3gwgm9Rq+yBP9BvXp8400zSEeDviPAfRMZ67xATkIhHOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7uLyLVKP/G+Ob8OqD7LSwTqd1+QgbJGdGllZd0ayBU=;
 b=Sf/c192Wp9/k3Ucv83PnF/FPJ7MoQucIDnC/0ltxJbLDJaFaZzJak+VpVLarwiYWGvySHRMVpTbhFyUbNJohnFHurygUfEJyfIPFrGfDka5m4ig4VwPKVC4t8iVYEMAExpZvWApbR/YFBSfFFU1evIPyP0T5OAI4hCyGBeyKF6Y=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DBBPR04MB7994.eurprd04.prod.outlook.com (2603:10a6:10:1ea::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Tue, 31 Aug
 2021 08:59:57 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::7c1f:f1c4:3d81:13fc]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::7c1f:f1c4:3d81:13fc%7]) with mapi id 15.20.4478.017; Tue, 31 Aug 2021
 08:59:57 +0000
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
Thread-Index: AQHXnhk3XLn1mK+aKEKIkxNIly6FZauNPsGAgAADucCAAAqfgIAAAG6g
Date:   Tue, 31 Aug 2021 08:59:57 +0000
Message-ID: <DB8PR04MB5785E37A5054FC94E4D6E7B5F0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20210831034536.17497-1-xiaoliang.yang_1@nxp.com>
 <20210831034536.17497-6-xiaoliang.yang_1@nxp.com>
 <20210831075450.u7smg5bibz3vvw4q@skbuf>
 <DB8PR04MB5785D9E678164B7CFE2A38CCF0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210831084610.gadyyrkm4fwzf6hp@skbuf>
In-Reply-To: <20210831084610.gadyyrkm4fwzf6hp@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e94c379f-b26a-4974-0ea8-08d96c5db52c
x-ms-traffictypediagnostic: DBBPR04MB7994:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB7994D0C6D04B95EED3A8C4B0F0CC9@DBBPR04MB7994.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6zwKC+GorGQfHkETdUR2I9CVutcfnCa/2LVxcxo77EVFtDiHVjKMvR1p1Jd+uLKVLrImniQ+ICK7cjNHMkheoZqrLkmQDgy31zEu5WJ+Ww5ujJD1OXujQsTOzLjFIUaRO0kiUNynW7q3blCkPfBkkrGb1jt4lJfqgB5pPnLaeGDZ1kAk0aBdX0ERRFHiFw6TCq/bVVP4Tvt/UuiDcsH9Cw29tqRO9cs66mfh7tiCRnjNGRoVpD5MVdtUtSZBU9jKp2+niiZ8h5vkVy9DN2ac0Vr3NnYUbZY5K31lTf/uQIpxASuDwsOysCLSPUpO2S+GySMlCt++Omokq83x4nZs0AuJZgnhpHI4ZL+JrxBN5ciwLy7CrkqHp7DiFBCa1YJ3xPPHQfgMzJQo3M2TSiQHstnDkh174q+dGPdFxjVj3CzuLG4Flkx6edhyrgYJxcjyFoOUPHyvmAcs5w0KdZeGOU4oYpUm3WC3J4DftgPI5ymEiO1JrlLSsz+fZhIwFSZymIe6DvSRSPr6dm3Xf0qBxqwOWTSuBCqFVMrV3GT0FOCSVY0wFm0rHfBkEjFIwb6Um/TpW/LNdAGvAnR3hYUddF+EQqxIgXBVbmycP7qISGxFyLA/Nx73Bxf3HvApIFqEQQpieNsQxYtjgKrQicUp8lujcCgs5CKyKF8O+x1GhQM/08LJgB9i3U9keTxWwsM+D9je5WtsEVIZsv3FTb5gAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(478600001)(71200400001)(122000001)(33656002)(6636002)(52536014)(66476007)(38100700002)(6862004)(7416002)(5660300002)(4326008)(26005)(186003)(7696005)(8676002)(8936002)(55016002)(9686003)(316002)(66446008)(86362001)(38070700005)(2906002)(66946007)(6506007)(76116006)(54906003)(64756008)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mmWdxFS2ve2GxTbwZoWxAmPVQkEHnEqHkUZVPY2+8p+BOZiHwUTGBirtUcPa?=
 =?us-ascii?Q?OgE4/RgmQqFeWA5VcVhn6d66A7oqYr2h7gzHYE1tz5lfyMa65wk5iq5ofqbP?=
 =?us-ascii?Q?yqeOm6Zm71Qqz2aMhkR6FRxHELYJ4UVPnzJQF79l4zZjwDeIigAnii0qnjhr?=
 =?us-ascii?Q?n8mj+td7QAlj9g4QZV0eFc5AiImee4NC59PxRT6frVyTNgIvlGIhDA3hxYEu?=
 =?us-ascii?Q?uAyryH5P2+es/+XqxunszRkMuhLOLub9wpbHmUzL4R4UW8YmQksAlQBV/yKL?=
 =?us-ascii?Q?8GdyQ4eT70In2gtMXlp9cFGRH4z1qj5iHkYTDqynSRjgqxU89nAA7bjsFfW5?=
 =?us-ascii?Q?cgUOd0b/4nrC4RkQAQIkECfqmN4ZbAJUeP+aJ05CkJKFRd3CP1366S1bdvUM?=
 =?us-ascii?Q?mFpUrRBbdbS/lKyje80GOcIumvwtaW9CmGiigu24qkaGYPGh0sA3cRRVMiZG?=
 =?us-ascii?Q?AFG7kb2drHa/Y/qjWaB0YskIdieDPg9etM0R7KgEQ/i4txrAWlLgNKacDaS1?=
 =?us-ascii?Q?wRvl+a/jnlJbctD17rvDqBW1y/aRi+apfwFFFxDUq8E9R1hrYvxPVgkR0vZV?=
 =?us-ascii?Q?jaPVBYAkGuyUOFtf8gfbr11I893FeK+8SsAzDBO1pfpOLufFIIw64aeBPHln?=
 =?us-ascii?Q?93Ko17iLAiAFw3D0kKbodsuNMvlT9tdP/7WE9oyeJVQ5eV0/4r4notTwy5zG?=
 =?us-ascii?Q?A45MLXpKm70xy1j3gkx2XPP+kezv9CgM4gblaGONi0Q4tYgHr61B9BkUlkGO?=
 =?us-ascii?Q?VlcbbxrEYPaX3EmyZv1PWLspb+ZTCNGIGjEzFfeBfDNYAjJ5gP1ywvEXApwJ?=
 =?us-ascii?Q?dgSMZ9uf160fRoyg0IzHRi0Yh72qGKEv33LVBDJc5JJROHTDTIyyzCeC6xDe?=
 =?us-ascii?Q?ozKmqTqzC4ioCZMbCgOY8nGKnQ1TvMlGaC/8nDNfMnNb4TwWwc8jbO9j30bI?=
 =?us-ascii?Q?kvb6f+qHiwSOSONbleGzwehshBhP+KBeViUnkqqb3UC//FCEDHL8dzB+hSiJ?=
 =?us-ascii?Q?oPDh4bOCZ/GGWWe/bS3OrNrXXTXstREayYzq5XrMKFV3+FcxQD+FC4cpFyL5?=
 =?us-ascii?Q?sgRMWgeuA3yHpDMJyoQ97cmAmZN90KCkE4Pkb05rnVGg+1ZRthIZO0+wMjFG?=
 =?us-ascii?Q?LNwpQ80TXrUxWk9Be7RfUfAs9bw9a2dCOMKKCGswJEkXD/N8HuuDMDZAM67f?=
 =?us-ascii?Q?hy9ZzwpRcuU5flkFn0O0XRhhCV2syB1///jWkKa35FHk2QX7Qdo6+NnAX7tP?=
 =?us-ascii?Q?WxkPBJfbxdYOvimctjbTyQpNb8umcCdYJj+P3LH60if76wJY8l6ggd5hO+w3?=
 =?us-ascii?Q?HyL9PANqN2Bn59CwaLHYG0og?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e94c379f-b26a-4974-0ea8-08d96c5db52c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 08:59:57.5808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6aJy56fRGDhm8wz0s6bXZG1v1QkmpL9Wdh4aY0S85QKpDBWqlaGTXhke4jIFTTcmCyWzz0DVYvWFTvr1Bl5MLsKcrQBYY59A0l4rM0ZtWhI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7994
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 16:46:13AM +0800, Vladimir Oltean wrote:
> > > > +static int vsc9959_mact_stream_set(struct ocelot *ocelot,
> > > > +				   struct felix_stream *stream,
> > > > +				   struct netlink_ext_ack *extack) {
> > > > +	struct ocelot_mact_entry entry;
> > > > +	u32 row, col, reg, dst_idx;
> > > > +	int ret;
> > > > +
> > > > +	/* Stream identification desn't support to add a stream with non
> > > > +	 * existent MAC (The MAC entry has not been learned in MAC table)=
.
> > > > +	 */
> > >
> > > Who will add the MAC entry to the MAC table in this design? The user?
> >
> > Yes, The MAC entry is always learned by hardware, user also can add it
> > by using "bridge fdb add".
> >
> > > So if the STREAMDATA entry for this SFID was valid, you mark the MAC
> > > table entry as static, otherwise you mark it as ageable? Why?
> >
> > If the MAC entry is learned by hardware, it's marked as ageable. When
> > setting the PSFP filter on this stream, it needs to be set to static.
> > For example, if the MAC table entry is not set to static, when link is
> > down for a period of time, the MAC entry will be forgotten, and SFID
> > information will be lost.
> > After disable PSFP filter on the stream, there is no need to keep the
> > MAC entry static, setting the type back to ageable can cope with
> > network topology changes.
> >
>=20
> So if the MAC table entry is ageable, will the TSN stream disappear from
> hardware even though it is still present in tc?

Yes, PSFP filter information on the stream will be lost in hardware.

>=20
> I think in previous versions you were automatically installing a static M=
AC table
> entry when one was not present (either it was absent, or the entry was
> dynamically learned). Why did that change?

The PSFP gate and police action are set on ingress port, and " tc-filter" h=
as no parameter to set the forward port for the filtered stream. And I also=
 think that adding a FDB mac entry in tc-filter command is not good.

