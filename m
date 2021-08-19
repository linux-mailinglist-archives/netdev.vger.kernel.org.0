Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9773F169F
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 11:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237736AbhHSJud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 05:50:33 -0400
Received: from mail-eopbgr80057.outbound.protection.outlook.com ([40.107.8.57]:39749
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229745AbhHSJuc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 05:50:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNyJyuw4SrBMulpUYmpLwjbh8Yer8ny0fR5R4V6DWkCrKNv6ru20WwZu1UUT+7Sqsg9o+FX7ONQMFqGHHb6GR6jt3m8mILZOvjEDqI9x00C3Q3DI/Ma1rCjBuczZAL9eItGFoj87yejyutqfDNy3Ku66q60I/S2M+Ls6GIwntgu+b5yaC9o+jfvSanQQxr4KMisQ2AdWqGvMb/zbk2iMmEapK+5qNYW2mEg2oBFvbyL2cd6ljEnklzJ2ytNz257yGaeBUQkRXMp4t71H2X+x8I+/fyLTu32GfYSENv5bvqDs8Mnh2Ub8fYADNG1f1P/6a49i7hDTfVvjbR/p/yaArQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+mT13lEApaUJiI/j2nyneevZKhk4M5zFm4XiRmY/qE=;
 b=krsMVlV4ZxzOkX7AywLgxq3hVdTaWtooD1aKpuqy7YJjHYqoZVQCg6LQIjbtlpfZaSglOAjuBQD2vP5VjZcDAgLvbLoWbJlUevXIwK0ny3+B/CoaOh47eq/JUf+hGk6mi2Zu+nh7FwelY0iYIvVluUdIUsl2mcKG2xnuVwUK+PG7u7KW4kYxZGLJ4VAvpLfS5Ea6QJQ9VVCCR0S4Z0dwZuCAIdZ1AUBBH8KBUTEBWezyP4lpN8t/eM2vAas0XZ4cKTiO3E0kkXNxwJ9UB3wnIR+8RKV0JZj/sZ6LkzyC9u4ZZDXWE051oab0p4Oc9FI1Jl4ihu9iIGHEGjHpUb5Oxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+mT13lEApaUJiI/j2nyneevZKhk4M5zFm4XiRmY/qE=;
 b=HPHH1qhIWB344Ptz9l8NpFIFNb9Phmk7HStVO5+WBDmxRNJZQSumUC7eVoJsL/C3Ttfj6WfUN65kCBGApCisMdXTJu2HAsfw7yjxPooqAjcwSz9hkITp9fGswY4yp9xO+zFSWhxTaZP5VmdrkEreb4HbYLp39cD3aidUKXYaHGE=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB6PR0402MB2726.eurprd04.prod.outlook.com (2603:10a6:4:94::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Thu, 19 Aug
 2021 09:49:54 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::20d3:3fd5:a3e5:3f46]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::20d3:3fd5:a3e5:3f46%3]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 09:49:54 +0000
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
Subject: RE: [RFC v2 net-next 3/8] net: mscc: ocelot: set vcap IS2 chain to
 goto PSFP chain
Thread-Topic: [RFC v2 net-next 3/8] net: mscc: ocelot: set vcap IS2 chain to
 goto PSFP chain
Thread-Index: AQHXk/d8zZOvA4oEl0WuxDM4SkoD+6t5WfyAgAE7AFA=
Date:   Thu, 19 Aug 2021 09:49:54 +0000
Message-ID: <DB8PR04MB5785C58BDBD502C78ABCDB89F0C09@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20210818061922.12625-1-xiaoliang.yang_1@nxp.com>
 <20210818061922.12625-4-xiaoliang.yang_1@nxp.com>
 <20210818145435.bsbxuq7bbjr4fkel@skbuf>
In-Reply-To: <20210818145435.bsbxuq7bbjr4fkel@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b5e83c6-fc18-49b9-f12e-08d962f6b28e
x-ms-traffictypediagnostic: DB6PR0402MB2726:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB27264EA967CE14E4328D1D5EF0C09@DB6PR0402MB2726.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HjbamUq25DK6FipGIgibAgB0zSirAJ1VWlZyDUkV4/oLmJkjqsBMqRxjzZilACgXX4+3adwP5Vpnq8koQ2pi/whf5qbuDiufqA4kq+nyJdDQFiQA9K+Mr6wNB2Fsuy9NcKcjqSxN+4ZFOEbdV+xFEd5EdZAvzvuF6BW/1Rt9FVBDx9ehzwpZBvxeLByqJnL9wEQiwJLsYHcPIvIyRuPmKa2TolP+dbCJN4xuiAtIU6G2vu0YgjekBh5W4pHskW4DNXkSZI83a3XsLczytBouh/UNwZbTHoIOioMgkzx3xtc1d6N8F2rS03KAyKn61gk3d8hxCWnLgsbiLQuGBRmeBrzILGmzbciiTxZxIvaYUzWmxqf0vm0NwtrSW2KA1LvIlpqmKFsCbSXy3IZ1jUQz9hhdkz0PjPv1nLiOxpZgvpnVjVRvzBiVdJiW3wsN4M8qeqM6uuT2ahfrDoc5cQLjpTT2G5UHAaL08eqIh9euP4MeJ4MCivEbDWM6m5gVLzh+g+ug4PivJw9sG+jEZre4GAvrshDuknAyFJ68bpYuIJx+b+iIy4Qt3R5C/xOo2nTvkOoBkua8z57NAwI/62u5bEwGw7RaD/f2dgAcB6vmKYvk8M96RT37/HwZHxzRLsTVA2/rogPFyAZ3Zgq7agLSTBUY24v8mOXLqG15KnyiubCLVVJyJTo0zho4ZB44+nwKFUfpPfC821AngYXmPL8zSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(39850400004)(346002)(38100700002)(9686003)(316002)(5660300002)(64756008)(55016002)(52536014)(6506007)(66946007)(33656002)(54906003)(83380400001)(66476007)(4744005)(122000001)(71200400001)(66446008)(2906002)(6862004)(76116006)(38070700005)(478600001)(8676002)(8936002)(66556008)(7416002)(86362001)(7696005)(26005)(6636002)(186003)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Uu38ozAeFTExAiUmzZ48ndmkiEhJgVGm7zToo9GRaf2A230BCxRj/YA58uJZ?=
 =?us-ascii?Q?BfhBxuwEuqqr9hUwitnLIcbdjM7lEgptPDiB9HtzmH6zs/L0J5EbbEF+oLrM?=
 =?us-ascii?Q?b8bCXzzf8H5Re5+tB6zlO31f1Tio/I/GAEnoolSNb3jF09MH0IAtO+1IC3F3?=
 =?us-ascii?Q?usroeazR07Rw3omvXL+lC1M4ZpeCSmN1I+CNJHiZ+2BV/5wfvkKd5lRyNBLG?=
 =?us-ascii?Q?I5oUniKa1X81EV7ew49tG+LuDp0YD33ZJLVeteYuX0Y0XiRGJj3FKvNeliLU?=
 =?us-ascii?Q?SshL3Quvvm045Z/XQ5yrs2xSjC6JYickgEQWU5GDnFpFV+c/cDKEgobMoqZb?=
 =?us-ascii?Q?VvwA57KmkN6u3ONMN73sKoGGWzCljT37VgO9FssXbzl/XKJZaesZsEfe72h6?=
 =?us-ascii?Q?qpGYFmoX2jRfNX10onFtiU0JogaGUgImALvgiSPy+FaTfKB1SndIegXkZVqu?=
 =?us-ascii?Q?+VQwQfu6jQpAsruta7e1ItYL4jIqf6drpgsnmzekaadm0c15IJjcY0lZYg4/?=
 =?us-ascii?Q?aMVYfbJLNjLGp2W4YjlYG4S1KnkVxNqzg4YzBSM0Wwv9ikfyNC9Uz3SJMtON?=
 =?us-ascii?Q?7Q4ge/rK+zezQDNpxUjepAt4J7gclHHZ39ZZIjSVTe4K20OxN09aFXAZbLYa?=
 =?us-ascii?Q?XijEtPl/v0kuXRWxSjrKVu384mOBihqNSfS+9jewL/RVI+0v4STNX6mEq46W?=
 =?us-ascii?Q?ehpGfhkXwpa7P3MZB1urGpvBP9jV99mdEUscvZD95ApnkhJsQIKXGa3n7m/f?=
 =?us-ascii?Q?CxXZnBK//cLqrcdXJDnEqcLGNVeTSjocYeaLBaDZFDBEMArYAg7lBquvoHWs?=
 =?us-ascii?Q?Xj6Tyi1uIW1t/qVww9/yMHnK4Zm0BDn6qU03JnUqUNzWot4KQQ+3EkKdcABY?=
 =?us-ascii?Q?WyPwJudBIm9g998yrKIM1n6yK4UJrgrGFpWa6wNqadrTDZy/Eki63b6tmgFC?=
 =?us-ascii?Q?yEFlxpgZb+MuxWdJp1kqjY5cYIWctxTd0Yud0AK8T/CJr5YBFjNTcfAx3Yl8?=
 =?us-ascii?Q?+mnnhFQMMI8xMRAK9HKvGQNNWKkwVCLAnWKd/feSVs4JvE+X0yEkyDVHrDWh?=
 =?us-ascii?Q?fn4MEtJ7wQENwS18FZMbtk/CsholV44rCJujxma4/dcGejEMD7THsJheDWG/?=
 =?us-ascii?Q?g7j+8Q+Gwl7L6+fNQ87gOF633XjyXT1lF4I1QEQmX1jHLa+/8uzjJnVyNBDq?=
 =?us-ascii?Q?wF/Z6HdlYgzvjn7RXew6yKJpqTx1ImDlZUdsxWYXP0UhLWww6mHtRSX+LqBm?=
 =?us-ascii?Q?zkeM3TpwZ74YLb5tK0mIWhKuC4cvT+8kbxS5TihYsPQQH+aUb+8NTiS0Dr3c?=
 =?us-ascii?Q?0M+hZ/En/v5NaK8dr9q+BX3c?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b5e83c6-fc18-49b9-f12e-08d962f6b28e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 09:49:54.4076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KV8eA8uikDUvAL6qTZbtbgiOdFG8OdiqMj8WLC/7OhtzdJ02sC6NARSdm+pLR+PTqlTXiwO/N9axkOAqg3hfsWqAQWQZUu6hzsNeVgYKduc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2726
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Wed, Aug 18, 2021 at 22:55:23PM +0800, Vladimir Oltean wrote:
> > @@ -353,7 +364,7 @@ static int ocelot_flower_parse_action(struct
> > ocelot *ocelot, int port,
> >
> >  	if (filter->goto_target =3D=3D -1) {
> >  		if ((filter->block_id =3D=3D VCAP_IS2 && filter->lookup =3D=3D 1) ||
> > -		    chain =3D=3D 0) {
> > +		    chain =3D=3D 0 || filter->block_id =3D=3D PSFP_BLOCK_ID) {
> >  			allow_missing_goto_target =3D true;
>=20
> I would like to not allow missing "goto" targets for new filter chains.
>=20
> Due to legacy support we must keep support for VCAP IS2 on chain 0, but e=
ver
> since we added the ability to offload multiple chains corresponding to mu=
ltiple
> hardware blocks, we should really use that precise chain ID, and chain 0 =
should
> just goto the first used chain in the pipeline.
>=20
> Makes sense?
>=20
Because the PSFP chain is the last chain now, I allow missing "goto" target=
s. Once we add a new chain like FRER, I will delete this allow missing "got=
o" for PSFP block chain.

Thanks,
Xiaoliang
