Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA9D56A3FF
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 15:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235447AbiGGNpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 09:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235245AbiGGNph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 09:45:37 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150077.outbound.protection.outlook.com [40.107.15.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB66013E29
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 06:45:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gn4kW14nOuAqLX3++pDoxrrHXq7NLudLyRD8hpp1iYI5VbyEGbtYwO0i1yhzfXV+ZkCPNc6MovmPjC/u3O8IPGyw5+IwB/lU54tkY0IIgnbNMLNjupVROVsyuHf9V0wE7mTnaG15MXUyWmnP+I++xrS6K7nvS04evMR3Q3n23ht9xgSZCoF7pmVoD8VdWfodmMrt3DYhxmqAQFO4YfhhhLoq/JJP8sDgyzkelKUCM00CR+j52E0j9JsmrVl38o8W2fqfhhe0yCA7fUbLCbSUsmShO4TnsXaLDkA8Dv2Ha+bcz6V67AhEnQgo7BVfbsAx27ZUhStQ/WmAmhdt79kTyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jt94E9w8XS4f2s/AOl5PG0xWRsvkCnkLkP8kZXdf1vY=;
 b=be/kFNJghw3/7DaxqULMPPmJs3xt8B2cPAbtEqR4YRVB0s0GNCxyAWjBN2msd7wCMHr1+K7zrDq4BEQCgtF5EVExezNf1nu/9WhhSUKfKEgeRZ6Ls1a/HHdf3zGKoiu/9EezlqckRrCULdDf0FUP6nLZdMl90cwVyQhCnu25NTaGhLqldBZ+n2njt6TklKDmXpx8bbEQZWGWJQfNpCDBO5V6zZ7OAQCg3K7qXS5hygfvgJV0FIx69BZPEVRVqikbXtWZTaHcHgCNklv3x1QzZSWvvNSbLPINTW+SeXHweIRR2AWUrNSl0vSh1hYUweYJwdRmdeC7HjO7PMmccWBU+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jt94E9w8XS4f2s/AOl5PG0xWRsvkCnkLkP8kZXdf1vY=;
 b=ZDiOlB1b8akWtNFAnJNmmsK7Ku/EeL4s9A2GDUP5jpoIH5Mu67XbTztPA3oMp6I1/PvWPXGgo41HqURxMziuiu/Eb/XK75JZVb53SrT5pHj9wEpCnkJX3BvOlPFf8PMqq/55uZWT/QEiFdP51OrSCcFFV+s8RcE64Yb5IFgAz4k=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB9189.eurprd04.prod.outlook.com (2603:10a6:20b:44c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 7 Jul
 2022 13:45:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.021; Thu, 7 Jul 2022
 13:45:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [RFC PATCH net-next 1/3] selftests: forwarding: add a
 vlan_deletion test to bridge_vlan_unaware
Thread-Topic: [RFC PATCH net-next 1/3] selftests: forwarding: add a
 vlan_deletion test to bridge_vlan_unaware
Thread-Index: AQHYkJUkjyvnbd1ouUiGz6fcWTd3ta1y60yAgAADMoA=
Date:   Thu, 7 Jul 2022 13:45:34 +0000
Message-ID: <20220707134533.3abgag7tvf6fdgtz@skbuf>
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
 <20220705173114.2004386-2-vladimir.oltean@nxp.com>
 <CAFBinCCqDRNzeAM2sU2QjJS6WxzCoUi6pwtktE4Th1NTXXNdKg@mail.gmail.com>
In-Reply-To: <CAFBinCCqDRNzeAM2sU2QjJS6WxzCoUi6pwtktE4Th1NTXXNdKg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a686d773-1cdb-4faf-b0a8-08da601ef77b
x-ms-traffictypediagnostic: AS8PR04MB9189:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PJQwFtEWY2Odb9Bx05k2KcHGF1V5eB33ovMqYTSwIO0tJg67bqwn1b86N4rmNxGH1OrRTL1iguYPBXk7lfzj0EsKfqUR6WuhZCY9PFLGIUVx+rUH96LSDx0j8ztkUaDXZuTBmAAnfMn8xANa5Pl1It7xEQZVny6fWqbqQbo+eaysbPxJFk016/nKlH7ZHIChFfPIi3RVuZRBtkNZdMDwX+DkDcp1xZJyOmnLMKfGEhI9qbIx1WQ0e8eyHAGssDQEtxMp/8Z3JMIFtNeKv8Czrrgqj2afmSXhlyl27N7vjAcZQENFcDwJODDTfjiPP+L3dedHS+zJwvS1JaEhR1YxaltxcRSpKRKDQBWQj+05y6mKc52NRo2pdF3s8QQeICm1XlxQ1iLNQiKnBvn6w1q36XjOD42IirfzwW/09nYkcFO17UFNYXqpyDcNgbqO1Dg6Gblu6cllYX8fBFmjzfeo1fh4CrK2myMxPELhU7nTmY2NlZoBSumqx2AFr3OshRQ8Vm4f+Kr2zePWhyvd6QuVpTUeGHzt7Gwc5lZFBVatrMYP6G294qYyAD7TOLa8OfMfqZxm3wXUmh1f2bqg5H3Am222AlvyE7as5NKp2mPHg7LMoPFblVVpGfwchh2rOER++imjQ9GeH6C9yREVf18X4HbJzQWxz4FQ47PHUVH9WEActbJ8tElAbuT14ab/bKzBqDOsvKFaxgC073TZWCQUO/RLoXYYeWmGMTVWUZ6QBQyEnmJAMfapvuIG3VaUplon5vSlNoAnGCC4cmjzyfy0VjkMBHavrB2KwXx7KkX5v9WZgpYEGI+MYe7RcosWYNsM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(4744005)(44832011)(478600001)(53546011)(6486002)(86362001)(6506007)(7416002)(2906002)(41300700001)(6512007)(8936002)(5660300002)(26005)(9686003)(33716001)(54906003)(83380400001)(38070700005)(186003)(64756008)(66556008)(66446008)(122000001)(76116006)(4326008)(66476007)(316002)(71200400001)(6916009)(91956017)(66946007)(38100700002)(8676002)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PrmiO0SU3HAFeQ70i+nQRaCoOBspFoMo+Ncw/6RbBAXriFlWqF7P7zuscUFP?=
 =?us-ascii?Q?QXj2YJV1X4Chc+slPlVLbz90vKkCUrH6uM7RwzznwnHCIW+G0lxMKbb8BXuY?=
 =?us-ascii?Q?nQ9OnD/3wREodypyh8OvTz+Lczku2OeZcNzBnG3XqJy0/uIJLUGTAcR1hKhq?=
 =?us-ascii?Q?uQsVw5cZcjzcEAzmFFRe2DIELWOtnEU25ks0xCuhqu3b4x/mr4oLT/3Dy9g1?=
 =?us-ascii?Q?ibMQTtY5RasgtW0TqDktN59JQhWHlbjQk+7U4qzV5I5O35AD0pJlUjQPdinq?=
 =?us-ascii?Q?iM5VMOTzdil2RyZATbfhEC6yJhLoDRAYlWUxhz0mDLCV2I/Dzt14Y/DGLdkg?=
 =?us-ascii?Q?UahSWuEwyr29FOpAgqwS6Pu+INEfgeczF6NxR1clCBzMIHJCiGcpm+aD/8vc?=
 =?us-ascii?Q?zl+ripNLnWfR5lz/w6AaJslWYUKGS8nx67VNfFHoU1cqQUz9Y8xF8DQgjp5o?=
 =?us-ascii?Q?zjB6co1VCA+Y3Mr7OEZbs8GxHdSHDEfInfpml8kEBSFpVfDVMvD8bsaCScwo?=
 =?us-ascii?Q?9IoyoIxMJoc/+TIYF1cmAvKqvvxX7CMVRdbQ9OOylALFA2RkyloKwbtxFTC8?=
 =?us-ascii?Q?5WkXkL/hmtwxKUA/sT+CnoG9fhzQwfdxybjU2C1jeGiA0Ij8hCGY1nCSuTPO?=
 =?us-ascii?Q?P3+PM4q9uUsIrQ21X4hTA8qAvnHJU1H21ttZjKsrVQkOLdRIZxEFVdGM23Uf?=
 =?us-ascii?Q?oMEXUvJ1JUBGQ87nBujUHplo4BT3tlfRL9zkASGYeY1SlQTl0fTwRBo4AlTx?=
 =?us-ascii?Q?Bq14OMLExQKdgtUIWRcbDmTNx/ysRJdVA0N82C/TVzvC5/s3IwMPDJuTSURJ?=
 =?us-ascii?Q?W2mu6OIR8ejIGYW+iGSQfX10JBxbzVBsvZw9cr73lNEPhJac8WhJTxjfUYBN?=
 =?us-ascii?Q?mIkENTXIK79VGu5zNrtbUaGWzSM7598M2KoCpkM7yNdriKV0aaOT50bWnwjv?=
 =?us-ascii?Q?bFaNq9vqkYbdfb1m/1n0Kr17YygS9+Z4X7KENS73gbLVEauFzFOF+DAjbOh1?=
 =?us-ascii?Q?XkwDJs6W6z9UZt3ZFLetkwZ9BuFlYTuISz3SNlSGcmEjAXTijRkuGzOCD5to?=
 =?us-ascii?Q?KwgYHNix/5iwFAIUy+sRb/bEwDdORM3ut3qiY8TaNa365/A/nw192U9I5C56?=
 =?us-ascii?Q?ROJbEt1nMaA1FvrFkGIGZAbQZYAG1zfx1BD8zwIcmE3NAp+BrCRRso6eNQZD?=
 =?us-ascii?Q?y8Y/WZwe5U4c3/70o7UnW6isBsuRzjws88QReKoc7T3Fitm3VYvDxxhMquKJ?=
 =?us-ascii?Q?qyso6TVVXSIeoE/PUh9Tga7JmvcNb18TiAd2B6CM/F13rclAmrt2vbOO82Kz?=
 =?us-ascii?Q?a+mhB7BJXAwMTtd/m3oG6MHaiuChPevzg1ds1M28MZGNZ/LM7YYSbCGFjQP1?=
 =?us-ascii?Q?rnoikdYYIJK9oBukm7B7hbLGB4WQqb8jOwyS60OhW6xsb4dWPFoFeq+MQ32D?=
 =?us-ascii?Q?3MQAAbWMcn+cCCoGtgopGXEeZDLlWO4DrqdY/MximmZzdoQVsx+vl3VZcjFx?=
 =?us-ascii?Q?BpxKSA5ry1Yn2NhEukrUXpmouYbz+GQIAioDak3raSDl8bqdUMF8S6kR2jQh?=
 =?us-ascii?Q?/6FF/ZpNi/yubp8Wvu28PfL5XCuXNwaFcAsYmUe39nE0kmGLLVYtBIOI41Dw?=
 =?us-ascii?Q?ZA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7D90FA975EB875468312E2959A674DE4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a686d773-1cdb-4faf-b0a8-08da601ef77b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 13:45:34.3554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sx4kmK9NnXrotmLG6+dd94d9iuxn9rGYZTGDkCq/1lxCI+lQosyAfjVCNBQO1GASDZG68GnwSIHSCAGX6wX7Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9189
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 03:34:07PM +0200, Martin Blumenstingl wrote:
> Hi Vladimir,
>=20
> On Tue, Jul 5, 2022 at 7:32 PM Vladimir Oltean <vladimir.oltean@nxp.com> =
wrote:
> [...]
> >  .../net/forwarding/bridge_vlan_unaware.sh     | 25 ++++++++++++++++---
> >  1 file changed, 22 insertions(+), 3 deletions(-)
> While working on an OpenWrt package for these selftests I found that
> this should be added to the Makefile (in the same directory as the
> test).
> That way it can be installed by a distribution using:
>   make -C tools/testing/selftests/net/forwarding/ \
>       INSTALL_PATH=3D"some/install/path" \
>       install
>=20
> If you agree then I can also send patches for adding no_forwarding.sh
> and local_termination.sh to that Makefile (which are the only two
> files which are missing currently).

Yes, please do that. I noticed that was the correct way of doing things,
but rsync was enough for my caveman testing so far...
Thanks again for doing this, I haven't forgotten about your other email
and will respond to it later today.=
