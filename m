Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20BD4424F4F
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 10:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240570AbhJGIfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 04:35:04 -0400
Received: from mail-am6eur05on2082.outbound.protection.outlook.com ([40.107.22.82]:21665
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233489AbhJGIfE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 04:35:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZ9wjgXJzpnoxnxKF207kQLtwr9JdMGWLi+wPKljW4YoLKBTUCnUa7kxtf61o4k/2BxIhK7vXWpWNzMdRJVY3/BCqoTGrH1TLlrT6zqZrR1639cV6ALAJ8LUmMDx49OgjH45z9J1jFk9QWfuFbXYbgm6TZKwaBWXxxEwILzS1orJSxpHGqpVcqRVGePrQIqTp/37gm0+vN6Duk4Onf9lWlj3dQxITW7fmCWmFnI7OaiQHk5SqGzczb34Y9jNduFTKt/qZDeXzN8RagDMkhOonMNwyARPUs5loI30BMBiMjNEr0k4nYQzOSRC6y0Weifl929RjN2GhMXps8/UyRm0Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FwjzmzS1lOGp2ZNr7s6zuodpr6lFHkSVzr8HEfuRxMk=;
 b=PNqrK0MWXCiqXDfRvLv7dZw40OJIJUc9b1SKmuuWGzFIoYyI48x9sc6w4vByEEnCMufkpu2TMB/Qzhom5NBYwZgVh0R4+u4am/htBHPWdUwlZWCFggM71wWwfJhK6NS+GH0DnSBgbKhqI1X16YSEcq7wrRmFewz79dfibVPll4UsYjuk+oSVIlcfty/fxNc6lcAM/FVNBKbsg0Gzg30Us117bLt0PZwvUr5v256WUfaaHAAl1wIwGz8kLM5gp/mpMQT5PL2HtGzt1EWUUW4BCr1y1xFSADg/13Re/FkWPwGTLF4mgMFeGa12pa6qFJuJjhBHXlnvwXRiz9BOsQ2hTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FwjzmzS1lOGp2ZNr7s6zuodpr6lFHkSVzr8HEfuRxMk=;
 b=bjcSFIb+ISyZIeKxjwuoyB1jqjn6Modg5Kt6lqPFQzazZsv37Nj9/rNnhdaP60ywqER/sOBOe4qHGUG7my408gwRRemzAS7chLdZYmssTsDVXEFw+GNhmjlJSrOIdV+e4zUaRz44DBwGDxrp5aDLdLkUx0LpfIlxDySESPZeI9U=
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB5331.eurprd04.prod.outlook.com
 (2603:10a6:208:65::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Thu, 7 Oct
 2021 08:33:08 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 08:33:08 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 2/2] net: enetc: add support for software TSO
Thread-Topic: [PATCH net-next 2/2] net: enetc: add support for software TSO
Thread-Index: AQHXuu664Nbids09pUWK+2m6R9okf6vHLKCAgAAJaoA=
Date:   Thu, 7 Oct 2021 08:33:08 +0000
Message-ID: <20211007083307.6alnxej5qx5ys62k@skbuf>
References: <20211006201308.2492890-1-ioana.ciornei@nxp.com>
 <20211006201308.2492890-3-ioana.ciornei@nxp.com>
 <AM9PR04MB83979C1C47471719E6688B0F96B19@AM9PR04MB8397.eurprd04.prod.outlook.com>
In-Reply-To: <AM9PR04MB83979C1C47471719E6688B0F96B19@AM9PR04MB8397.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e2e6819-7abd-4573-0fa4-08d9896d1772
x-ms-traffictypediagnostic: AM0PR04MB5331:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB533164469760CEF5A9414AE6E0B19@AM0PR04MB5331.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 17YP20jFB4ByJpGQueAoScCh4sjKlkGTC8io3PmEfwjaGemuy9m448YuhOk5Duckb/AyBxDDcAsWr755C1Bff4IjCvxpkIDi88UGOUcVbtIQ/aAY48zdhvHhMqKHqrIDNOAt58lqIOLLXS5FkSteOUEPZdndZKGd6sx6HzYKPops0jgNSNkjCirGHekZOAE3lvG3+fB3OsEtbQ5pY9mLV29Zh4b0pKjubVq/LbRE/GhRFe8cIP1hiNuLW4nYtdKJswFpXEV0Kj15Fshl70zArk7PVIcM+XxifvhvHBspkvGsOhQ/1xAzGCRfoa2B8gBK4NN036Nru8BppLGfIkMBtVXMfSSfhFTPOsWTmwAPuvY9CV+AtcMjtmpECwTK2radVNUYZrZYyBXrJPyO5Ti5FJpO9TUHUQ+5WwhI/eLAHd2L0qRwlfwUVakO2gHo+zJI32YMlRQP/bkRKYw4TodveVoZni3afJOcwtaLiaH//O3ywbuajAqewwUub740zx1HFqPcQ/y/hB2MqcJGKtKc4+9tCypEPiYEPwc3mdQ24G2VMrVU6apc12BJneDGfFzDkCjnhi4AV3VkZgamGq23oOo32Hj4ivr6I2PGk7dIRspgozllacItMyjvsy7SUATV+AfKzyMs6yFWT+Y8kWV194JpTEEFxxIiQgiJ7BW6ZXKyPaE2RmXrhRfAFqhili6s3E4kilhcaaUa+itiSvpWug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(2906002)(6506007)(44832011)(66556008)(1076003)(4326008)(38070700005)(83380400001)(26005)(33716001)(508600001)(186003)(71200400001)(6862004)(54906003)(66446008)(8936002)(91956017)(76116006)(8676002)(9686003)(316002)(6512007)(86362001)(122000001)(6486002)(38100700002)(5660300002)(6636002)(64756008)(66476007)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MloYj6wsAbnlDJgNLK/d7AHGQk7eD9X9a68BlAVXovc8563lvd76KgKqATWK?=
 =?us-ascii?Q?SHcLGvSQrBbYd90X9mki3qbTvjuWwSPMWzrGVIoWxjhwaOt31fPW9GDAQDDg?=
 =?us-ascii?Q?E6iw3+GC+V4tAxxVehJakwSndmrj9df5elnA1SMK6GLDIfvgxsWPlcOjR0hG?=
 =?us-ascii?Q?xyfO65U2yHEAFMgQeevWrHSf9iQpTpGzucB8NRQDCGpHgr05E2Zxj3fmykHU?=
 =?us-ascii?Q?KfhbL0NBILmJHBGTCrGxoHvr9CYeaWufHCxAcsG/Z4ujtPe1g2K3wLtCDfwa?=
 =?us-ascii?Q?6yt/S9Dhm+Os5ltrNKIO3/csUf7om8M//TtgWx1D0dRD3PVJS6y8mq7b0VP5?=
 =?us-ascii?Q?NSEwoJ/DK93L5/F3874yiIQKVCObk2WBhkrRpaJG5oJNWlZEdFBHTDmqGto1?=
 =?us-ascii?Q?xTumCI+evY6G+2+mPQuF5ihbnFNmTBu5p6LXIzSBvUWskv+vROo1L3pGksj1?=
 =?us-ascii?Q?tL4uTiko0ILn5AGNnRxbZ1WndcbTIcDe8kSyIHspaGMVOWg2f5h4XJm4Wtn9?=
 =?us-ascii?Q?fmX5rFZHfx0fc/JgKWtKgnUgxwnvVFTAoEJ7g8WNRn7XE6hZilFtq04Ypz0X?=
 =?us-ascii?Q?mUe+iCP9+Hlhwr1F7daw1VZt8culdvI3sTOxf12mEhj2po9JZWUztsxTfs4a?=
 =?us-ascii?Q?1oyu5mEX9oYyDv8kVv0g/GbzN91KqgWJ90rgESYsGFan9/L3Tx6qRx7TWug3?=
 =?us-ascii?Q?CoedPJkTR0r+QQH5LNQBDWO7bfevf94M8PSCqRreExkDi2FPlqTxYNHoZKxG?=
 =?us-ascii?Q?7JPe9b4zubG/DrhkjrvEUxhXzG9RKodRQobX+EulIP+SEduWf9gwnYAeQ7Ew?=
 =?us-ascii?Q?Q7avm7u+hhkV795C6ohgUwVNDTUmLD4LjVb37MhYMJ6BrFronuiIcjsNKf8+?=
 =?us-ascii?Q?8Zj6vA8gu8LBH10AqpVyOIcQVFGgPS1449gWyAXXkjYXOuUVXhzJImymEDWj?=
 =?us-ascii?Q?IZZ0FV/SKR3p65obSY/sVh/lPkkbzce+A6QwgWZJBLOrgra9tF05hYCt9EhH?=
 =?us-ascii?Q?LZPabyrbYm9PLHvE2SyU8TC3RSiaYXJtpYQmmlBz7uSYZauaxOIrMiuvhTQE?=
 =?us-ascii?Q?VKwq8CNx9aOQM7SM6swFC9a3rR9GRqklkA0msP4Y/eqvR/LNhzp4Ur0yWRDq?=
 =?us-ascii?Q?5IdTvAqZecNXmwkZ8T8UpkYXe5ULOI3cVyhAJ+Gp3yu18O7NsLFLJwqgdOKS?=
 =?us-ascii?Q?Z3ssngqpqiF31bghWEU+sxeC9lfKxnQDvYA6pSnLLtaq/LLHHeQbLSX5+r19?=
 =?us-ascii?Q?VhW8S2h3pvxB7PfOBbJi4nsJ2pKlOuBZRcUGY0+mnSTj5fhRNjm+uLY5aJn2?=
 =?us-ascii?Q?EwHI+BliVN+tu5DedCTDXN+A?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4734055219BD4342871CDA49E8E39451@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e2e6819-7abd-4573-0fa4-08d9896d1772
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 08:33:08.6377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KWhxI8KjZmAMUeLuj+J2rkmamBIhsxG3toWcGvOXlatArHcz7VOa4mhbB7Tns1pgdXUli6jl03IbwzbchdsnLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5331
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 07:59:25AM +0000, Claudiu Manoil wrote:
> > -----Original Message-----
> > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > Sent: Wednesday, October 6, 2021 11:13 PM
> [...]
> > +static int enetc_map_tx_tso_buffs(struct enetc_bdr *tx_ring, struct
> > sk_buff *skb)
> > +{
> > +	int hdr_len, total_len, data_len;
> > +	struct enetc_tx_swbd *tx_swbd;
> > +	union enetc_tx_bd *txbd;
> > +	struct tso_t tso;
> > +	__wsum csum, csum2;
> > +	int count =3D 0, pos;
> > +	int err, i;
> > +
> > +	/* Check that we have enough BDs for this skb */
> > +	if (enetc_bd_unused(tx_ring) < tso_count_descs(skb)) {
> > +		if (net_ratelimit())
> > +			netdev_err(tx_ring->ndev, "Not enough BDs for TSO!\n");
> > +		return 0;
> > +	}
> > +
>=20
> On this path, in case the interface is congested, you will drop the packe=
t in the driver,
> and the stack will think transmission was successful and will continue to=
 deliver skbs
> to the driver. Is this the right thing to do?
>=20

Good point. I should have mimicked the non-GSO code path when congestion
occurs and stop the subqueue.

For symmetry I'll also move this check outside of the
enetc_map_tx_tso_buffs() to get the code looking somewhat like this:


	if (skb_is_gso(skb)) {
		if (enetc_bd_unused(tx_ring) < tso_count_descs(skb)) {
			netif_stop_subqueue(ndev, tx_ring->index);
			return NETDEV_TX_BUSY;
		}

		enetc_lock_mdio();
		count =3D enetc_map_tx_tso_buffs(tx_ring, skb);
		enetc_unlock_mdio();
	} else {
		if (unlikely(skb_shinfo(skb)->nr_frags > ENETC_MAX_SKB_FRAGS))
			if (unlikely(skb_linearize(skb)))
				goto drop_packet_err;

		count =3D skb_shinfo(skb)->nr_frags + 1; /* fragments + head */
		if (enetc_bd_unused(tx_ring) < ENETC_TXBDS_NEEDED(count)) {
			netif_stop_subqueue(ndev, tx_ring->index);
			return NETDEV_TX_BUSY;
		}

		if (skb->ip_summed =3D=3D CHECKSUM_PARTIAL) {
			err =3D skb_csum_hwoffload_help(skb, 0);
			if (err)
				goto drop_packet_err;
		}
		enetc_lock_mdio();
		count =3D enetc_map_tx_buffs(tx_ring, skb);
		enetc_unlock_mdio();
	}


Ioana=
