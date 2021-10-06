Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CF5423E75
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 15:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238648AbhJFNPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 09:15:01 -0400
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:41123
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230008AbhJFNO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 09:14:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LIPdYYTBcyEEcNzdeKkhwfnhY0uLJfj2NdzsU9EPi1pCWbcwLpE/96PQ3udU6kPXETVIZCfZKHKXDPV5Hh1vcIJDgW0TAOFhE/RPfnNHIu6RpGJgF2TLuR4+2TkikBrHeQepp1iTjCYfdSxJ3vi1Zoeds5cxU5sgCr0n7PH7f/UbR+4xC/X397rrP7xPq7DYjHFFA9R/tX0Uczvjv4Hq8g0u5IYeUYDECLbohZpq+MJqM2QkSNliWyD/XOFU1s5gZOGq7eFlA5CsfCSB5j+LC6EdFSkL8agXsrRt8n1H3DekfX88sBZglu6XAguShcIBW2wbzENHLRffyfpWjGljDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDVSox7N3n3b6tpOItR0x+glSGISZkJnArq6ChihzLY=;
 b=P0qrBuqJxQGa0HsF3KxJatT4suiicaQ64FcxrE6UNa2stPk6GzaEzS4XW4a1soLE1n5/AAUb+dp/MkF9pmUc+ZTjapgQnYtV4GjxyC5FAH3jx05ygdIvnmwQbaitYazqKhCbhYT8Knvz/4n75eDUgSy8gZNEpreWbPkh6G/pfVx9GlM1xYJPOKFaFQqFdf32vLLSasdUo0o35vqb+ve5Es61h8ibCpfDbdAVbspop4+K8vKGYxBDhLcF7cfJRZl9lWw2+DWENoyr5Qx2SjgbTG01pEvXqM6xttlAAvTtNrJ++pVgH1o2hXQkNHYxUbVik1JO76xgdZf4rkHtCj5sqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDVSox7N3n3b6tpOItR0x+glSGISZkJnArq6ChihzLY=;
 b=D+yjtsSuSImDFEPYmPi7wwEy2rA4yzGX3HSMXYd/zYw1I4wi+VsTjihAyS1JqiIlCAFcWAjUUeVIdgD3y6ScTg1lj67TsqAroFrRnPdSpE0T2utv54U6y01x1JC6YbHxJJIyzXxa/jCmgxssZ9095rrBQ7JOw3KzQUIhNiDo/6w=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7216.eurprd04.prod.outlook.com (2603:10a6:800:1b0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 6 Oct
 2021 13:13:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Wed, 6 Oct 2021
 13:13:03 +0000
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
Subject: Re: [PATCH v6 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Topic: [PATCH v6 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Index: AQHXtc/T8KvbJpSRhEGt0VSW27tAp6vF/CeA
Date:   Wed, 6 Oct 2021 13:13:02 +0000
Message-ID: <20211006131301.tx42h4kcoacat2jm@skbuf>
References: <20210930075948.36981-1-xiaoliang.yang_1@nxp.com>
 <20210930075948.36981-6-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20210930075948.36981-6-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b1edc8c-af71-42b2-5da1-08d988cb073a
x-ms-traffictypediagnostic: VE1PR04MB7216:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB7216512C4C28A2500201B00EE0B09@VE1PR04MB7216.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ShZdbItvDTCLp8BWvzjAHjZRPwV1ULiIuCVB1Kmz+tfJ257YcjOE1NfG9PgQwb/pT/33NHqOpVnyvdcElms15baAnJ6v3TD83SlK8y228WzNB6VHhoo5Majh9d+nAwJvXS6O78iOuliI+DG+dMxIDu4VVeVB36zJAYeUXi+3Sv4xefLcllXL+NjUGHu1LEGe5RsLPCbaEYcajv1Ai5f2cww8+D/M56ps1eFpq3v6rPKUtV2VfVb143f7j9f/3HoTqeKYFW/zzV5Geo/1Ch4FkBLKY0m13aZCjZMRt+MsfreCNNE7iAORMbOOtbwhl2RtAkhkv6/rfwB8YqwLYEKjMTAuSPTZY6jm9+pR3z8vThjS+ShVPQo1y5zNhjYmv9SObhuD80NxPJT61pESr1hLju0hxoZQi5MJhUQ1KEmvTYEjVeNkhkHa1Zq6PykNt2X38yE+R8CKhgdJ1x4mxVQ+yAfVpYXiX+7sBSToEa1w7pq+JWoCpYtPddoYYmyHJnXkuXn/LlBLxZ1EqBQpJlqITFItAo8hXxGCpEaEIAn5IW3w8vj3LGTEdqr5Jvkv4F4RTE1jvcwdFo0D8IuCy4OG5YafMOSL7juQFFgfsCwV3oazpcWnuofxpl5XRMcZVl9mxl4KURm13kean0wEpZxTM1E2+a0gzgC5acmIe5Ui+DlP/++pj/j29yDLbgRio+JiF/eQ2o9WFYs04ph48PYbmQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(6512007)(9686003)(66556008)(64756008)(71200400001)(6506007)(76116006)(91956017)(66446008)(66946007)(66476007)(26005)(38070700005)(5660300002)(6486002)(186003)(54906003)(1076003)(6636002)(316002)(86362001)(6862004)(508600001)(122000001)(33716001)(38100700002)(4326008)(7416002)(44832011)(8676002)(83380400001)(2906002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0HEM0B6VMzGA33eqPLwzLlaiFgfdwUq9p/MEd/aHUQgwfX4zl+Wfu13Dpm7L?=
 =?us-ascii?Q?uDZGQDDehwsHOFcar1tFRlFdhoI5bTzOoBDYk8hgEjSYyU+QgPAoUl081KQ6?=
 =?us-ascii?Q?+bCbjY/3AdQVjSi1q+lh6IGLzExYDb9ocqafOGQK/K2wwB7tEgSP7zDzYnnW?=
 =?us-ascii?Q?KsDuPwy+crInmjR/eRpysHzx3VCiOldFHN0IYQOiTUcqA9xizwZbQWzj2eUE?=
 =?us-ascii?Q?l5ghoKangE/kQP1zcyZ+JRv2QAi7ldk/IYH2oNmEPugaTH1LZHaTpNs4v25S?=
 =?us-ascii?Q?ljTTRtmJwH5wIjHZlnQd8DiaeQcG32W7GuqccxcWlaDBIONmUlg8GR/stpMq?=
 =?us-ascii?Q?QVcdYUKevvkK4/Q2BWtGn4AfI/ggAf6nzCWJjI/9+AVU5pUPeNcuSAbAp9U0?=
 =?us-ascii?Q?phKkoVOTV0Wl8/PjYEO9hrPhsDTq7be3/61age21iYJtku6NKyLQGOA8F3P7?=
 =?us-ascii?Q?vtuFZVIMD9QiaUymZF4uc2yJJPD/jyiG5SqXxzFs1/vteN2IP9eD3uAXqFOq?=
 =?us-ascii?Q?LjIengpjLBe8kxKZI+KeIlLZCMxEk96LD6FbxTXeVUXlBZ3w18O23bOCiUpw?=
 =?us-ascii?Q?lJPDLn8zDPheXGYN8i1HRxpx87jQMTE2ImyW4GLpZ2sF59ApADVJBHI2fl9S?=
 =?us-ascii?Q?0nM/vT8gBLN8ZpY2nRfS14JRmUgC7u4sY2j+4/L0r2LB5v3Ci6tZPWCs0xrG?=
 =?us-ascii?Q?oqopgGcKR4ozPSre7oJOebDIVRJdZB4BTNlHJczaeX3jsou38WdFqX7V0WTv?=
 =?us-ascii?Q?VBXNBlvfJij5p9IVLuTDuTnFnu+agC2rZRg2kz0j7ttdrpLnXh9s7bN54KqJ?=
 =?us-ascii?Q?TwCdbvqL3ggF1iXhBlm2lmh3y1rbremJ1/tvPPIBc55uKax0Y1Fh0Ll/1PlV?=
 =?us-ascii?Q?ZVczCaI+rX3IWF2xiCU544/1R+mXRyLg31i5rp7l4MGhYC36F25ZRwuXaPOR?=
 =?us-ascii?Q?jKs6K9HzSDy10n/e1R2Bkc+RkX6yF2xicAyXCq4n3vns84tDF5xc3Wo590ZU?=
 =?us-ascii?Q?YxZDMgN82PaaC8ZZst+8F1n7DzgujVglrbn7QOpBSLv3lM7n8TtNT8l1UJF/?=
 =?us-ascii?Q?XigQpmTKI2wAxSzTxFiYKjqHFf5eHkcvGyH7JaLDXA+QBxPl0TH8KFRqOQ+7?=
 =?us-ascii?Q?ZnMwgQjuH69dQraUcMBl3nBhpJa+NirtDqChPizQZ0Y/CRSI3ovsa0JrbYUS?=
 =?us-ascii?Q?CzU6FalxaItje0a47VUXffP3uBVqsbxa9iR7O4o5nLIMAyUVy6aPGrjxW32Q?=
 =?us-ascii?Q?DUhwrdkxoUddR3DH0ZRgod4ilPj73yNEkVl2t6EbSO1neUOzrdDpPKcVWpvP?=
 =?us-ascii?Q?0vHs08b8yB8PdKCl4XiglBKw?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <082EAC2275402049AE2D9404905410BD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1edc8c-af71-42b2-5da1-08d988cb073a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2021 13:13:02.8391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iXJ2IduJhsJke+qL04VqVlTgBQpIdyotv1KqTdMk6HG8gwh/ik844kDpuJ0z8ftui2YWbERjczCcxZkDxvFVFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7216
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 03:59:45PM +0800, Xiaoliang Yang wrote:
> +static int vsc9959_psfp_filter_add(struct ocelot *ocelot,
> +				   struct flow_cls_offload *f)
> +{

Neither the vsc9959_psfp_filter_add nor vsc9959_psfp_filter_del
implementations take an "int port" as argument. Therefore, when the SFID
is programmed in the MAC table, it matches on any ingress port that is
in the same bridging domain as the port pointed towards by the MAC table
(and the MAC table selects the _destination_ port).

Otherwise said, in this setup:

                     br0
                   /  |  \
                  /   |   \
                 /    |    \
              swp0   swp1   swp2

bridge vlan add dev swp0 vid 100
bridge vlan add dev swp1 vid 100
bridge vlan add dev swp2 vid 100
bridge fdb add dev swp2 00:01:02:03:04:05 vlan 100 static master
tc filter add dev swp0 ingress chain 0 pref 49152 flower \
	skip_sw action goto chain 30000
tc filter add dev swp0 ingress chain 30000 pref 1 \
	protocol 802.1Q flower skip_sw \
	dst_mac 00:01:02:03:04:05 vlan_id 100 \
	action gate base-time 0.000000000 \
	sched-entry OPEN  5000000 -1 -1 \
	sched-entry CLOSE 5000000 -1 -1

The "filter" above will match not only on swp0, but also on packets
ingressed from swp1.

The hardware provides IGR_SRCPORT_MATCH_ENA and IGR_PORT_MASK bits in
the Stream Filter RAM (ANA:ANA_TABLES:SFID_MASK). Maybe you could
program a SFID to match only on the ports on which the user intended?

> +	struct netlink_ext_ack *extack =3D f->common.extack;
> +	struct felix_stream_filter sfi =3D {0};
> +	const struct flow_action_entry *a;
> +	struct felix_stream *stream_entry;
> +	struct felix_stream stream =3D {0};
> +	struct ocelot_psfp_list *psfp;
> +	int ret, i;
> +
> +	psfp =3D &ocelot->psfp;
> +
> +	ret =3D vsc9959_stream_identify(f, &stream);
> +	if (ret) {
> +		NL_SET_ERR_MSG_MOD(extack, "Only can match on VID, PCP, and dest MAC")=
;
> +		return ret;
> +	}
> +
> +	flow_action_for_each(i, a, &f->rule->action) {
> +		switch (a->id) {
> +		case FLOW_ACTION_GATE:
> +		case FLOW_ACTION_POLICE:
> +		default:
> +			return -EOPNOTSUPP;
> +		}
> +	}
> +
> +	/* Check if stream is set. */
> +	stream_entry =3D vsc9959_stream_table_lookup(&psfp->stream_list, &strea=
m);
> +	if (stream_entry) {
> +		NL_SET_ERR_MSG_MOD(extack, "This stream is already added");
> +		return -EEXIST;
> +	}
> +
> +	sfi.prio_valid =3D (stream.prio < 0 ? 0 : 1);
> +	sfi.prio =3D (sfi.prio_valid ? stream.prio : 0);
> +	sfi.enable =3D 1;
> +
> +	ret =3D vsc9959_psfp_sfi_table_add(ocelot, &sfi);
> +	if (ret)
> +		return ret;
> +
> +	stream.sfid =3D sfi.index;
> +	stream.sfid_valid =3D 1;
> +	ret =3D vsc9959_stream_table_add(ocelot, &psfp->stream_list,
> +				       &stream, extack);
> +	if (ret)
> +		vsc9959_psfp_sfi_table_del(ocelot, stream.sfid);
> +
> +	return ret;
> +}=
