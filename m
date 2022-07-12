Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0069572905
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 00:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbiGLWJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 18:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiGLWJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 18:09:04 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130059.outbound.protection.outlook.com [40.107.13.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E799BBD33;
        Tue, 12 Jul 2022 15:09:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yys7P/tXFD7+lMj1gHplQyTXJduthLVnPkMkqL5VEMrwIVG0MPOZSlxSqX7ruJOwnQSegfre5xqceYuRGuWA48l0CCjBtJ76OfG9GwZzuaJgzTmD8rB3Lgl/jwXqFhI8t28klcUZqxmcnS9U7MpJx2Nv/4ZZDl8jLilHzm/eQ/58DGyBhsffmQCdbfyRN3lh7x+4BFFc1TnKgaymjakm7BQtqhNQjCdMqIw7PuAj5jesb053e7NuGuZ+rY2l/ilIVrpPOE7Swo+cQMSOAZ7UBG+NW1DDdJV2I+DBMnIPSr/C5N6WYpZr5Umdc5IML3lLD3usbfIwpqmWEXb84H0YuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9u8dw+wzcwX5jJXkJBnzEh4D+Y5iRWE32T/yElsmkFo=;
 b=fjpuvvXsFE/smBeHFA5KM4Lj2VgPl3leXQ7LQXQ8jFD0rNDLv3J1noSQ3+I4nIfk2dIF/RRA4T8FHnBnDvCJqS4DR1XG0sUuFUjLU1nIIiy0y2hj9y4XyD16fL8b4ae/9OINyc7zExx4Ujdjqoi/cQWe9aqpDGfTK3LZ0RK2824858QAGhU88xeopioiB222fI7Pn4+WYENmQ62UziVreLjE6x8lhKgUWqOZi9GlWp6Jc18UfvdMoDlGHR6utCkFi3ePfM5EXBU7xySDcMqhWPe3HOcZST0EXnEc1GAcZfxF0m4ZVTX2D11yqNjZ00lFsHOVKpKr8rY2IbqLh2lAAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9u8dw+wzcwX5jJXkJBnzEh4D+Y5iRWE32T/yElsmkFo=;
 b=QgDkkQTli1KX2aeRyHhgAF3JlmiOBh/Uev9ke4jilAQSIvyQE1Ji7BzjxGmzBeyizgGTd0BGt4NX2kAK94JW5zNwndaTaaowPX1m58VAFRo3TthF+NuHTtParEnZf9Q/XCCftDkzAE6a9kgTo8OCZBsv2ARnmGTLX51pVvc5JKc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8629.eurprd04.prod.outlook.com (2603:10a6:10:2dc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Tue, 12 Jul
 2022 22:08:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 22:08:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [PATCH v13 net-next 0/9] add support for VSC7512 control over SPI
Thread-Topic: [PATCH v13 net-next 0/9] add support for VSC7512 control over
 SPI
Thread-Index: AQHYkLCLyofP+TS1aEGqPHLXYAU1tK11YSwAgANziICAAK/vAIAAgzAAgAFOwQA=
Date:   Tue, 12 Jul 2022 22:08:57 +0000
Message-ID: <20220712220856.qbfyhll5o7ygloka@skbuf>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
 <20220708200918.131c0950@kernel.org> <YsvWh8YJGeJNbQFB@google.com>
 <20220711112116.2f931390@kernel.org>
 <YszYKLxNyuLdH35Q@COLIN-DESKTOP1.localdomain>
In-Reply-To: <YszYKLxNyuLdH35Q@COLIN-DESKTOP1.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c8ebc7ff-ae13-439e-2bc8-08da64531e5c
x-ms-traffictypediagnostic: DU2PR04MB8629:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cybDPdo+LbqbfNrh+gj67L6p/sGsHPLYbbZrfS9H7/JTW79AJqrmbRfPl6A1Y0YEj3zch8pykeb/XlkuqZaM/TbZgePKSHwWFHnZ05oq3LKTB+LNl5ulXPSnFD1N5/S7DwXErQOB8ND15SR3ORZSHnPho7gGh4M308q9wQZlT0xesXcYlDvz01nme1fjBmlV2IDBzewHz1cgXkmFyTgD6/80MUMu/bNtkFXrTOV+eqRN8OLYuv1ayDVoh3gIuEbOBg17u9poy/9XDenkOhYZBBlKrHJH2O+vU5N8blYOpDjXzJAXKZSpfD0+d/DwEi9WeuG3UYKAU/rl4mHKhZyMktJ+yxpPBmA3ioIH7yxlII72vJ326hmQO4qky7+9X6YQ5WMw6IC9mnH9B4HQCsrxf6PQUGnb+EJ46JbudAZ8tmK9c7xugSbp/wcXt/e3X7sb/KoOyzrPqxgrxyx37ac4BSfLZghApJ/UPAklDsrozFz5bnlYH7t+/7GhoT+w7Asu4qN5P4tbQRSB5NhkgGwJD827frl6nyAjscJPl5joSkQs7Rrsy3JYu/bVhHMhDYSo5NGVBM1JMcZU+GHOYNwxvnQLA7fIgB+/6x1++Rt4x/hndalsAhRruV+eExgK12+dkLj6xZKM/vOxgBJUzcZAJG2QkISMTp5JMkGV6YUsoRIKigDaVHoUeMjiwO2IJZV0HkGT2/7wklUzSrnlrSJLO8v+elBJXdagQ4JPS41rPe+3dmZqWpojpaaCWGSuV+XLMJ6RJ1XPUo4LOtB/HVVF1T184S82lD8FbFG68tE41mrI01Q4lqqBODoWdocCPSmh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(136003)(396003)(346002)(39860400002)(366004)(6506007)(41300700001)(9686003)(6512007)(26005)(122000001)(478600001)(5660300002)(38070700005)(8936002)(38100700002)(44832011)(7416002)(71200400001)(91956017)(66556008)(83380400001)(66446008)(64756008)(8676002)(4326008)(66946007)(76116006)(316002)(6916009)(54906003)(186003)(66476007)(1076003)(6486002)(2906002)(33716001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uD8Xp6HVajgIjQgVZEYtRkB7MbUUpnUTbx0ORBPEVaPTjYknKwLDqmAH5wsD?=
 =?us-ascii?Q?ElL7osX9znUl+eJtD6c4+kzR/ywdBXSCDo52WNVk58WLoOEkVOK4RqqN+BtD?=
 =?us-ascii?Q?7Msk55dyzoMpA9eZl8q1KliUq/RDzjbOlpb6VvRlFpnkPMwNXgjR/4ii4xYy?=
 =?us-ascii?Q?qj8DYsS0yb7I8VGgXmyTyFLLKbkB9BeY18y19G5tAWIUkkafCs8Xav9fRTCu?=
 =?us-ascii?Q?3JAj4E9pWyrqB75WN7H7CJoDC2uhdEg+HzpoLXrJ+jd0hE92Kx5J8O10jbuv?=
 =?us-ascii?Q?yaKnRngv+WuQnrWneiGXipl/KPpi/rTbpw2YHxLwrRxeiqGLRwd3/sm3XiwJ?=
 =?us-ascii?Q?qEB1I2ih7CdWGw0WImIPg/9OqTh7nSOtlMiIR0akaA7ZlXz80rEMRlKjFzYX?=
 =?us-ascii?Q?zd/dx5hHxuxISJN2HdGe7Hp+fZgWJTU5ge6+Bt0kPquZfVLJoI+bPYAJITX8?=
 =?us-ascii?Q?dHDMeAuo5M6TacyZUs5xaNy2lJDXUKC9UVfqzqn3DFzHvGkRug9qCfHTfIg5?=
 =?us-ascii?Q?jG5BO8pnaPOS2F/3n5EdnJgF4125lVs/Pk+8A9OZwIKRayR7CLhy3PnkIIgb?=
 =?us-ascii?Q?FGG/Oe6YJsIwUDgoRtCWM6HMO8X7ykAqex6u9xOeusOFg+uxRgrI/0yo1/I7?=
 =?us-ascii?Q?OzXZhUjgTbRvfuCHB/lA3BNk9g7g0y/S1lR9dY4MGdsiXxt3RE0FBMO4zHIK?=
 =?us-ascii?Q?2jTHxnoItuMgJmus+/oKYLmQ63ovA4+AhZ5zRTQdwfoG6t64Ftc5DpVouQr4?=
 =?us-ascii?Q?p4kk2hnC+lKtaH8gRHGNNYCfLOWFiHfQnOkiIylJ5xN6D2UquRVca532/PIi?=
 =?us-ascii?Q?KhYcThRYIRqAfKAlD4XI9jZ+LVfC8o0gpjIM/fXUbxp98f9KML4JGVFZAdFd?=
 =?us-ascii?Q?zTD5BBhGd+p5Suj2mHLIpEy8rIawkUsWiBJDjKvHU1hAubdUNuf99NKT0s1i?=
 =?us-ascii?Q?N9rLwLlk0Yy34xw8sy4N+1fcb+TF90oUI4VWy5SMu5HoK0Dq7xnF1Z3de7se?=
 =?us-ascii?Q?tNzFbP+EBT9MF7AoVd4lDTXYey8a1ENn5NG+r3nA4EFelzwR6DB4ExbX3q17?=
 =?us-ascii?Q?1YNqO9LOHTvf/KG4ajO7Roio4WnAnmK5XPt00/D0OZA/pN0KmIAEuP22ZleN?=
 =?us-ascii?Q?ZMg6pywO6YmQmnAKO5g7bAvsGotR1bvwokW1anVGx7TWBuPCMUKHu5HDVfT4?=
 =?us-ascii?Q?VVJa0sZomm4KEcj2QieDtU/fwTssgJxI2tQOr5UrCZ0sei5EK+w04kwhcF7u?=
 =?us-ascii?Q?R+QehFhnI9KAsgYKCqltA4OnWVap4Um9QSUC6aUUisW6BjP7LIIFhKhDwe3F?=
 =?us-ascii?Q?P9ByZ20F6XXvN3p1TiSC1kADR181AtGF+XbOLh3TVZHbCLpfNgn7aTAMY4Qp?=
 =?us-ascii?Q?yEx4UQtoX9UnGRtPP5hyMSGUJYAY+RgidaJ6Nt46dLMxIjhrE2L8SBkrRNQm?=
 =?us-ascii?Q?CDkHgefA3DyywpeoELS2u/qu8p9pb0Z0JXyd2ZO92+WQnimOjd77h4ZqdnbP?=
 =?us-ascii?Q?67AzN4Udg4U0bNL1J0WGmIMdJzswZRAKXem91bkiS87FFcN84aFwoEzgMuMq?=
 =?us-ascii?Q?HVLEAKRTctfZyUjcAquWyRP9TapNpQnffgabMjKB9mllp5e9d6Awx2oekd1R?=
 =?us-ascii?Q?xQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <54ECAA134C15A24FAFAB4BC253CF7DBE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8ebc7ff-ae13-439e-2bc8-08da64531e5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 22:08:58.0610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e9HawY8kp3C/p8aFjDwf9T1UmMdaeAemZQFIMsjGNpm/S06MQIXiMYVeS29SK+llRWSKwQxwvNiyZA9Zhj7JtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8629
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 07:10:48PM -0700, Colin Foster wrote:
> On Mon, Jul 11, 2022 at 11:21:16AM -0700, Jakub Kicinski wrote:
> > On Mon, 11 Jul 2022 08:51:35 +0100 Lee Jones wrote:
> > > > Can this go into net-next if there are no more complains over the
> > > > weekend? Anyone still planning to review? =20
> > >=20
> > > As the subsystem with the fewest changes, I'm not sure why it would.
> >=20
> > Yeah, just going by the tag in the subject. I have no preference,
> > looks like it applies cleanly to Linus'.
> >=20
> > > I'd planed to route this in via MFD and send out a pull-request for
> > > other sub-system maintainers to pull from.
> > >=20
> > > If you would like to co-ordinate it instead, you'd be welcome to.
> > > However, I (and probably Linus) would need a succinct immutable branc=
h
> > > to pull from.
> >=20
> > Oh, that'd be perfect, sorry, I didn't realize there was already a plan=
.
> > If you're willing to carry on as intended, please do.
> >=20
> > Colin if there is another version please make a note of the above
> > merging plan in the cover letter and drop the net-next tag.=20
> > Just in  case my goldfish brain forgets.
>=20
> I wasn't sure of the plan, but this makes sense to bring it through MFD.
> Fortunately there's enough work for me on the DSA front that there's no
> way that'll land before this merge window - so I have no objection to it
> going any non-net-next path.
>=20
> I'll look to Lee as to whether there should be a v14 with the header
> guard addition per Vladimir's review, or whether that should be in a
> future patch set. I'm happy to go either way.

From my side, the changes to this patch set can be incremental, I'd be
happy if Lee would take them as is.=
