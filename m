Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5129D5F9E26
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 13:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiJJL5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 07:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbiJJL5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 07:57:37 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2063.outbound.protection.outlook.com [40.107.105.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDE631ED7;
        Mon, 10 Oct 2022 04:57:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8LybEwv9rglr9CAF/2gtbX8qdU8az0iYJz6mp2KETDb+/kSrmBpkp7MG91qMyrvh1SnnCgPToAY7nLBzHjpDzf3EX53SSDmcikiokaxcMAE4iLlqT1cdo3vQWIiutk1NDfmHd4swHR9x1oRRG+O2JOeLEg9NrXjLZ1pSUtR+K7zB3OG6DQkfv32XqOowpQh9oaQ54Xqit432Hyh31xE5ge0/X2Sn3oQYh6+PSE8zierwLC4c0WoIK7NBAJYUNHaPzgTfrqnAuLme8s+5P/WiG7LnNtuHtRA9CJz+AIeKKpGAC2xGW23zLeHWrpUnZ5Z6axDMdYZwVwVQF3m8BzHMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=toiT6qBVp9/8w+jegw3rFJoXTIt/TP+PnxUxG2yKhd0=;
 b=TIkffE9yCAjQPykW6xlbJTcjxKmw1Yo03pNa2t2Bjl9okQWVEHt8O9R4vp94KmkpJBL2NaxB3Xw8in4eY5PYTh7ZJ8f9MqNxQnJuAoIQ5xIuZazLA765VmWCK5d1yeAVSaSa9slj00fccVboI2qBomzH8Gfs+EHzygVRXkwdHdMYYL9cCh+zirHb1mNlmUGnPVMRwe8sgpjAM0O+vRdSZBcs32KsBjpakgskSOq0BECicp4vvte3kfwABGT/S6T45f9TARRRomlnr/mTcy0wzy1u2XOxK8ogKFh1vmDwLVBkFsNphNNyJX5JGO3h44tdPz0tR4oNJZg7ImYn1H0TNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toiT6qBVp9/8w+jegw3rFJoXTIt/TP+PnxUxG2yKhd0=;
 b=gCrBOK4i+R57re92w6HwP5OLlSGwbFIE6nS9YY8mRyMsdg6Eh0upmF1cc0ra38GlvJhlG4ji7zegiLZexOhn/+GiQzHXG6Y7oJZ6CPOx+aVCOltqzARAgSuEXdQS1pxfa9qSfgRxHFsDG+wAtq4X70olna43cs1WSqozpS3NB3Q=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8282.eurprd04.prod.outlook.com (2603:10a6:10:24a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Mon, 10 Oct
 2022 11:57:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 11:57:31 +0000
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
Subject: Re: [PATCH AUTOSEL 6.0 12/77] net: mscc: ocelot: adjust forwarding
 domain for CPU ports in a LAG
Thread-Topic: [PATCH AUTOSEL 6.0 12/77] net: mscc: ocelot: adjust forwarding
 domain for CPU ports in a LAG
Thread-Index: AQHY3CurwLBO2xP21UOnbEjE4uvfrq4HhpyA
Date:   Mon, 10 Oct 2022 11:57:31 +0000
Message-ID: <20221010115731.qjji7bgt53rusvzf@skbuf>
References: <20221009220754.1214186-1-sashal@kernel.org>
 <20221009220754.1214186-12-sashal@kernel.org>
In-Reply-To: <20221009220754.1214186-12-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DB9PR04MB8282:EE_
x-ms-office365-filtering-correlation-id: 0ff102db-4c44-43e9-0b87-08daaab69cd5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UDDyB/lWoEKTqh1ZkYoSmiLugNEbUNqjj3j2mQ3XRAofSE27XR0LlqOPn5WIwvFdjdUI80NcTfC/VMCZm1z5b/+6iwao4sxXucBPUYynD8Bmq1Zl+Ny/14jLme4IYBZjLnHWNNSSWtlUCTq/bwRPnpYUHujyDsFGegLQQ2GTVeyr1QTdYPC2Qtm2prJ7b87yJF8LrNyjd6I3QGANtrra/EcTYKeZ2+umXP9LfScECcjAVzFcJHxmNqGZwDZ+rlolRP051J/HnnafznAVUHFzn+LGw1s0Rsf0HUmdUqeNgpY9OecZWG7cS78+mEsAABuZavX+CxNOM5qksZ2UWkxXiX1USTfFdm4ZOIMqCELg+ci24xdtp2bYyI4HIcEAmfyDAcB5lP2YMDWzKEt8PMARlwizXuo/gDQx5EkF+ZXs8yNmRT8y2gnPbGE5n8UYNSbz26Tk2168fq3aw60VeSZprIZk0OLM8iR5eO5ZZY8s3fGK6fbFVs5Yyk7r61KS6tXXUo8YY5Gfj0gPHN7EXSu8ti+TPzYdeXAdH4eDxdtxyLBdSei1Zz34LHhr3Q/3wwDVtfGtMWY3a2ge71DApT1bMZlYNEDc0zN/xIDIOeLBcNoNYbwzAqGCiGuq0lcfnEYdcAOxyO7EQ4VkXGQJb9T8gs/HbBuDkIWeHgbneDC+QsND2QHjr6GDZfpc9eO0Mixq8ryrBq9fGaHX8DQuunBxEp5xkLCO5BbhhAWdEc0dVdritxNGsHdAFKKALBbUWPQK1T3WmKva4GVCJyilUD99sQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199015)(76116006)(66476007)(316002)(66946007)(64756008)(86362001)(66556008)(66446008)(44832011)(33716001)(6916009)(54906003)(7416002)(2906002)(8936002)(4326008)(5660300002)(41300700001)(1076003)(186003)(38100700002)(6506007)(83380400001)(478600001)(122000001)(6512007)(71200400001)(8676002)(6486002)(9686003)(38070700005)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sJtFLbuhz8utcbaYeekRHInoNvXgF2G8R+xfmtoOdx5RVRqqOxz1tXIVEfAr?=
 =?us-ascii?Q?8qkgteaNDGd+GqEHejgh33w7WQlMq8zsLQxZDDH3EXekINROwkc3JlROTcZo?=
 =?us-ascii?Q?65qLZLrz7YvBlLQKUE2eLqrTmzVG4nUVwJ/GYnJL90pt2fySxw6xNgZer7B6?=
 =?us-ascii?Q?bLBsGBsKFes58tdENrcl5Y/pe7htlqd1XAcktFvgWZfxJapYfCuLt6xF+wwT?=
 =?us-ascii?Q?RJTzZZUPAYbJNHc3zooHBTESqqNMXq8L7ETteQTIYKQJZ2n9H+ULEXf6n/o1?=
 =?us-ascii?Q?CtgVCjJRZfk/zVfeuj4XC16DJsBxtS6bQx9AIs/Wq15D0PAXCjLShqcHxzg7?=
 =?us-ascii?Q?NEJKWJ998hc9oiq/I1GcWz2nbgBlak/Qs98qXomIvg2vrVpXfx2kYshNeEgy?=
 =?us-ascii?Q?dFqF4ZXe24e/2Jpt24ibU8/KHlJFReQqKOfFYJKO7GMkQRRWEkISu3MJgysA?=
 =?us-ascii?Q?omiRDSTjYWTRoNXkbqf8aHPj4Izrnz/PK/0K/O/KWhb3vKH8Z88vvx092I2s?=
 =?us-ascii?Q?E7afA3TwzBF5larnQJDFCppDZAg/4LS7npV77Lxq3sPObqGdhzwYkGD9YOTD?=
 =?us-ascii?Q?BVBNGri56BfdB1sXPkvfmGU/Jtm3VHc1Gm4EsPVppRtFD80HbzYElSIcOMCZ?=
 =?us-ascii?Q?Si/GFuq6iW0N6tgi0oCFGPzuAamgHfS5SDQgpRUSMQdiyoETWWnrN3B332O4?=
 =?us-ascii?Q?ATxctDONiQpkbqNGQr7FBfLmo2FqEFh+VU7tX77LRL1aVOYX7cj2+bGS1OuG?=
 =?us-ascii?Q?ZYKsxX9cSl42eVK632/erBjQraB5bY2psuEv3JCRJaj01pfUFFuxFxZjP3Nu?=
 =?us-ascii?Q?X75snWBxaqOY4DpJWxDQUDtUXnK6zvm/fo4cnQvK25H7Kpjndwln5iO251zK?=
 =?us-ascii?Q?eV7v6oXsgZM2mrHrfNq6Xl3wilTuuZKYoST337TSSL3QckWU99pqHJHg4UkV?=
 =?us-ascii?Q?ggf8t/HloYr7xf2isIizT2DkfBC1ll1YauvNlixom2zyic2AMxlDtPaQJ4YA?=
 =?us-ascii?Q?I5t2z7t6jePgnphYrRJgB0ID7PKC5tfor9ubVOGdycWseRlNnFGulu5j4JmF?=
 =?us-ascii?Q?qiqeZPLY+4SMpm/gIIrhfbxGrdRBw/xW8vusycUaPV4ndKVR7PpClz/3TpoK?=
 =?us-ascii?Q?JUscVtY8hhnOxUiEHANu8d/70YwfFOYKYO1EnkZkp6SzVQFw+T/ijtbG9cy0?=
 =?us-ascii?Q?9HnLSg8jdoKGLF5pn/vZrKixz0TjjhfHPXnG1z2BCCOk7la5yvnNERmpjkgE?=
 =?us-ascii?Q?GR2HpFTNi4fcJlfXV/sBA+h7NApP8tU40StSUYhBwDHJrBVldg7z8BFR9TTr?=
 =?us-ascii?Q?PixY3o8fLIt5EF4oG1ORkcfJXmfVXKbc6CWpF+LCX6DjBG5drbnuClvQPtxc?=
 =?us-ascii?Q?sE9cATB3uQou93J5+AUN/A4b7cTIRF7zR8D3eEwIgpjR9KkeVTbIUGvXHOaB?=
 =?us-ascii?Q?aLi2lZWb8AVmq6c+PBiHOWJXqxKrsnD/Hn/ts2QGl70zbwaFnsgUgG/jNhJR?=
 =?us-ascii?Q?DclRcPzsCVdCJThazsqlRCbORBfjowD83pvmNhuhLrCIKjntSdZcZvdZbZpV?=
 =?us-ascii?Q?yiiS9N4l0V14FSsjvQPGSEmWNRaRBKM1f3aUeadVLSGFL7MN0UrPylmXdKE5?=
 =?us-ascii?Q?0g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D75DB26536C17D4A9D517947415A71C0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff102db-4c44-43e9-0b87-08daaab69cd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2022 11:57:31.8167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bC+0ttXE78BEtGW/hLKXDCjgaVIq4KPq7q+YuEr/NOCjfJYHpUnP02GYUpywyu7ZsrI2xFtiaU1TkG8jTdhXwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8282
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 06:06:49PM -0400, Sasha Levin wrote:
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
