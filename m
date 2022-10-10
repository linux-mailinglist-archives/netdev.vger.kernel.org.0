Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D855F9E35
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 13:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbiJJL7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 07:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbiJJL6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 07:58:37 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20084.outbound.protection.outlook.com [40.107.2.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4355AC5A;
        Mon, 10 Oct 2022 04:58:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LHw6jF91/Q7+0DMIoq2yy85cs3W3aLDfHnJpk82s6NaNego8gowOgTi6MlRYo5shoVPG3ZMGCRnoCvtFm8rAeOT9vbRf1PSfp8rdLpNe4y0p5JqqF9RFhe/MPBg197NOgV4qY9UrBloY3ul/gk82EKF6SP3Rk+vxPKw3agcEAgJ/bY27msEgU0V9IDlWHz9HN39JOLPCZm+bBByvURpJH1+SsqHQWKwA0bhX1PBRvIXxlbfYfOnY4siK6tHmyuMNOnUpRo8a23Y+UZdd7Ce8P2wECnctSWcmTwTRpIOq3+wA1tjrz1CIy5NRzb13SE7HEbqaDY8HM3Olu3xj9QMPOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7HJYoJ6DlLsOx2UmgUuuFSX/ddvUBlZikLjjOUJA/ck=;
 b=hbVOBY8OZ+Vg1HYl4o32jKK7RR8ciaQzzsz/A0FWlEqyLjqXnO2y77JqjPszxQvsIa81kLGBxmH1Bv5yUsJpdJSNGBN1M/NIB9JrK7hZLrMGLua3RRWl7aGakLsn0HqZ86MaTQKoFPN10TM1vRp7SUYK2xYViiCrEYRtm1nrJQjO53mtumT+s6ZII1Ybmwv/8fScmDKU+Kbdpn7AYiUdK+E9yPTifQ3ZyMVYONEusG98E35PRYz3axtCcb9uP76Hyl/ra6NygdoW64SJbFoeRmFhlvNK3Vzm/1hmbWK1j1AdC3wA4IGS5AzSqpZjVJVjzOiNeP9EsGqOq/WgUHMIjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HJYoJ6DlLsOx2UmgUuuFSX/ddvUBlZikLjjOUJA/ck=;
 b=NKx09lhj1eER4kVGG2YP+0E9MjTQrOLJ9diitU7rm8W1rGLmglHqBMd90/6dhrdRQltMalzb7j9Pmuc9TZTOrIxvza5R/l7lLh5QrjHncR3cqNjiVAmRQdzy/MYxszq9YP1DxCHj/QmGtHw3kV/s3IPHQpNzmC1HWnwea19GtKs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7300.eurprd04.prod.outlook.com (2603:10a6:20b:1c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Mon, 10 Oct
 2022 11:58:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 11:58:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.19 11/73] net: mscc: ocelot: adjust forwarding
 domain for CPU ports in a LAG
Thread-Topic: [PATCH AUTOSEL 5.19 11/73] net: mscc: ocelot: adjust forwarding
 domain for CPU ports in a LAG
Thread-Index: AQHY3CyvLWgyVLbzqEOQ0EB91iAP6K4HhuMA
Date:   Mon, 10 Oct 2022 11:58:32 +0000
Message-ID: <20221010115832.bbprccaoenozmi2h@skbuf>
References: <20221009221453.1216158-1-sashal@kernel.org>
 <20221009221453.1216158-11-sashal@kernel.org>
In-Reply-To: <20221009221453.1216158-11-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AM8PR04MB7300:EE_
x-ms-office365-filtering-correlation-id: 4feba108-5493-4f26-db07-08daaab6c14c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pDcvJT5QgKvVmSirgTdvhpXQ6D+WQbVJWCgHMeMA/ynxPZj+xzP/BdwrEv3DLPu7EkN8t0kZOMMjP8qFH6UMam8Y2g7Pq4cla0E3sUPuHncAMzgYlxJk8sbBR4xG2K3rCclfaqa0ux53gUSP7CXzZML1dGwxSZFcn6T8y/6mG4BiZZc0VxeH9wmhr7KLFfDHknkmom7fRfJVObEr39oUFnUr+xyuCGk0jfE/9BwNsQBXw9QoEnQUKQDTL2Heei26MIbDcDqMQW0lilHQ73+jRBl//6a7Ixls4evhu0DACjm+etG+KEqIFYADVSzPSKpRSxgSUwdxHkp0U3PmNiiPfvwqk83Kuj0YF/xtiF5a3ySwykPbPhYY/R2v7yN4rF1XNiu4wSv4o9NheFOsFBNsssVoe2NXwKX19ELlRao5exbKX/QbdBLhT+iEBymIJ4DmFrSbivuT2hA+HKuUoHROJ6Ykx2MiKEnQ9MPTagm96xbs/+i8KjY2nECYMWxb2IWFU9QLOt33KoD3x66vOpQ7ij6i43MBGfZrfFdTMsPqVOKIyEDS2pjsLaOrp022WGuDYJhqF67HZiuoC97gH1qvcp5Pvo4udgL7uqJ2U/vBNikQouYqWGB6BkdcmK9a0OZaqwSOYDOkeDb+xizv33k25a4ovgI8qyqpk0Hibl/GeTxHZmSh5AU7btZH/4R99K275MUR95N2sMc1XcSp3XxVA4aOCh2KyCMLfuCCutGRKy4tXKTO0OyHJbcYMPOvE6/8bvFObwOo0I3eJSuNhjIx9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199015)(26005)(38100700002)(41300700001)(6512007)(9686003)(2906002)(478600001)(186003)(71200400001)(122000001)(1076003)(7416002)(44832011)(8936002)(316002)(33716001)(38070700005)(66476007)(6916009)(6506007)(86362001)(76116006)(66946007)(64756008)(54906003)(66446008)(66556008)(5660300002)(8676002)(4326008)(83380400001)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cLmp9+hfa3GAAFS5tcyzGrc+JPbhoCHa9fYvQOHwvP2b1hU8VZKPxc2tLeQ8?=
 =?us-ascii?Q?JThBnJh3YTX+DqvTH4juoAz3zvtcIA6ihQvUkDsp+XNRuWr3XnDE+i+HDYFT?=
 =?us-ascii?Q?nXDVKi6YyEoULikNqT71Mkgw+8lcEsviRHol2KG2/alAZOcIj4W6ctlK7Rmo?=
 =?us-ascii?Q?4MWN+zkLcj08bcJu1Jwnq43ger8lIbDeWxLwVbDoSOD9pUq7W4FSUr3snjuh?=
 =?us-ascii?Q?LNx5QfGRxv18lLbgqFrZP2pnkg6GcazBKkEUgTbb8f39WrpnJ6JXfo2BwTTq?=
 =?us-ascii?Q?CSHRiLiuUTevJSsXVCWX3ZrdMShkpVrdg0XEaqkNCrkrcbalxs3HDZDAfJW9?=
 =?us-ascii?Q?npQvEeQqwkTMf2P8Sc8bzvR2nYzUlTZCwEKZm6l2fFi+gbK5QpzaAqw32Lon?=
 =?us-ascii?Q?USzjOqpNE7/u+bwp0o90gAkZFpneAwIn9m9zYOe7YPUZMPcLEqn/9FzYYywF?=
 =?us-ascii?Q?2TO93/fdN/MDdy7ZWb5pBDcS6HbcyFGF2d/pz5sWONcm+aTPuXTQ/ETY7PB1?=
 =?us-ascii?Q?b1MxTScxKUFckJtjt9krJAjJGfj+c/XJGi06O6DhYFiKILGOXYodtiXxIbF1?=
 =?us-ascii?Q?03QjNbC5CiI7+SYQfAYJush951zi30vQVoWrgRYb6Y5ZMvGNzZi1p/SlmMI6?=
 =?us-ascii?Q?IBmWQ9IeneFr9S+hz0n3WfZeJv6bvHxmpDNc1EqZFDSTSxJXb7vuJISuc0L8?=
 =?us-ascii?Q?AbkrO/sSlMMda04mhivQWQwueiU/oKo5+XKkfQhSLQOq+svHO2beut9py84i?=
 =?us-ascii?Q?un9Fpa/51cPHcWYFMVYECKZ6lWDk1dRUvMYYg18D9L7iqRL7lznVvoa2I47C?=
 =?us-ascii?Q?gv7oRqqO1zbdGtEgJhDDar4Wb8CVnAOIT7vpfTmzy/S2d7Xzl7GIdh/uvSZl?=
 =?us-ascii?Q?w7JO3Xvwo2DJsUCrajZ+7w9vAER9S0PEgeL1hBzom9rLOtJouPECK1jzSrCa?=
 =?us-ascii?Q?XBkWGO1YFRVqjwEgPnzCsKJ8g4tMxcM5FHLSu2EYD5e98NJ3Ksqp8wo3PrcI?=
 =?us-ascii?Q?sbE06OmtwDcjinjgSCaw5efSMFVDevXpyJA4uvtRPUwS0g27MqN66m+9EfYr?=
 =?us-ascii?Q?NQGwIsvh8pGuaEG/BPhx2FsbYpYpql1NViJJJnbREz+lWjpdE4tjcBO4VUhk?=
 =?us-ascii?Q?btgg/bZcsvKSTHp1yoNtr1EjFUtkzYAcPpNXzqXUo2YrN3jpk0Q7God7C1vn?=
 =?us-ascii?Q?RDxTgpX9MXxWHTV91r/CTHv1hXItrYmjXy2OtV0UGXSgpXM3SH7fzvl5lY49?=
 =?us-ascii?Q?xNZ2s6criQh5QUaTNNUeX56ObG6VKAsgh21sWzEY4Jb2VgW6KxTAFTdRT0eV?=
 =?us-ascii?Q?ztm0MkOSr5UNee5CZYxEBqcQ8GGQRtR9MmJ8AbPll4Qh761p7tLmwkN5h5nY?=
 =?us-ascii?Q?CNMYLpI9oUS/8AJNFj3bsh5dFgw9Pn3gXhceYowZDUu90n+Xbejl0FKvFg1k?=
 =?us-ascii?Q?njpGiGYLHrzdmB7pB+pODl72mQSjODOk8MmskVs8FDAUYVerplsA5eDW2y9/?=
 =?us-ascii?Q?bMrdKPVjhmIkVS2jTBKh81Jz9z83hEeyjlVuTxb8qsLsqZuDxAmeEx28oDmI?=
 =?us-ascii?Q?OgaXxYtlH8dl3WlHoapdVZMexPnpI7fJunw3dv3zjiMLiSkJapOlg8wIi8sH?=
 =?us-ascii?Q?ww=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DC97CAD1A81A9445B9A551EF989CE866@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4feba108-5493-4f26-db07-08daaab6c14c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2022 11:58:32.9999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PdEHwPSIgVLSzYKwQKvX8FrV6Ffjw50xxTKgnWuoA+yErpVqmA7YM191rzokYBy2pZEimt8F0C2cLgAmE6SNZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7300
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 06:13:49PM -0400, Sasha Levin wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> [ Upstream commit 291ac1517af58670740528466ccebe3caefb9093 ]
>=20
> Currently when we have 2 CPU ports configured for DSA tag_8021q mode and
> we put them in a LAG, a PGID dump looks like this:
>=20
> PGID_SRC[0] =3D ports 4,
> PGID_SRC[1] =3D ports 4,
> PGID_SRC[2] =3D ports 4,
> PGID_SRC[3] =3D ports 4,
> PGID_SRC[4] =3D ports 0, 1, 2, 3, 4, 5,
> PGID_SRC[5] =3D no ports
>=20
> (ports 0-3 are user ports, ports 4 and 5 are CPU ports)
>=20
> There are 2 problems with the configuration above:
>=20
> - user ports should enable forwarding towards both CPU ports, not just 4,
>   and the aggregation PGIDs should prune one CPU port or the other from
>   the destination port mask, based on a hash computed from packet headers=
.
>=20
> - CPU ports should not be allowed to forward towards themselves and also
>   not towards other ports in the same LAG as themselves
>=20
> The first problem requires fixing up the PGID_SRC of user ports, when
> ocelot_port_assigned_dsa_8021q_cpu_mask() is called. We need to say that
> when a user port is assigned to a tag_8021q CPU port and that port is in
> a LAG, it should forward towards all ports in that LAG.
>=20
> The second problem requires fixing up the PGID_SRC of port 4, to remove
> ports 4 and 5 (in a LAG) from the allowed destinations.
>=20
> After this change, the PGID source masks look as follows:
>=20
> PGID_SRC[0] =3D ports 4, 5,
> PGID_SRC[1] =3D ports 4, 5,
> PGID_SRC[2] =3D ports 4, 5,
> PGID_SRC[3] =3D ports 4, 5,
> PGID_SRC[4] =3D ports 0, 1, 2, 3,
> PGID_SRC[5] =3D no ports
>=20
> Note that PGID_SRC[5] still looks weird (it should say "0, 1, 2, 3" just
> like PGID_SRC[4] does), but I've tested forwarding through this CPU port
> and it doesn't seem like anything is affected (it appears that PGID_SRC[4=
]
> is being looked up on forwarding from the CPU, since both ports 4 and 5
> have logical port ID 4). The reason why it looks weird is because
> we've never called ocelot_port_assign_dsa_8021q_cpu() for any user port
> towards port 5 (all user ports are assigned to port 4 which is in a LAG
> with 5).
>=20
> Since things aren't broken, I'm willing to leave it like that for now
> and just document the oddity.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Not needed for stable kernels, please drop, thanks.=
