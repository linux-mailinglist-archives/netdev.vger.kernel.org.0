Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73BA24B4D83
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349089AbiBNKpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 05:45:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239754AbiBNKo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 05:44:56 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80043.outbound.protection.outlook.com [40.107.8.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9AFBC97
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 02:07:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nEmCCNLj6KwczjD6WK51JQfOhqG5Vf1TV5fhUw2jTDYMxUUNqbx1agtjA7PLjrV9KPg0Abxd3h1fVqE/p0rG9IZJsbVTbZyfcf6bHz016ZtAsN2f+tQG35Dwqj2sYpkBvJTUQ7VQ4fOjotyUNyGvaRPpmsZ60nDkDlq3Ow0ocefkCCx2ES2kTMBXZwCKVLvmn42CEmZzni1CBtAOlm/I7t4ol40Tdqk1W6K8pbgJdmpPxjIr6szVqzRWXmuFPudxwWgj/sCDLccZRgG2wjIitJ118kLIJvcfu7t5YzptJWkkOdHcGlxpVWRYsIWYmzWJ16eUOAfgYS+WObk7d2f5ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s6ZGcTvYJtQI16gE1NiOCJ4g6PsjmI44vObKxFwizpk=;
 b=YczxqXlZYeyVwh8CjMmxB1y3ngPfRULC/FQgSirFclMJwXsi8fBc4WjlmRkR9a/yXTtveKZjNbGpWmsiO6+CvresaGZ2IVflpEjuCs5bK20ffShpPgLJxkPBgQJo8KymWOa/MwlkXpD23LuZz0m4CFTpbZvOunsS45arSpPN3Zo30aM9Pzq1BJD50xs2yv5WiJZ7I53ukCxf0o4JcnZAX21/1UEitUmEKRbI9uLmKzaftgNBzoE7u7ApNwshy+UpAG1P/ajGmZtHNruiBxVwr+bJ/4Gs4VxFv3bOMWMoT0KnFic6WtuZjIkO6yyr7sY1focgiQvzPpkjkllTCG9bVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6ZGcTvYJtQI16gE1NiOCJ4g6PsjmI44vObKxFwizpk=;
 b=QveiNStvgQviphNzy/dkYS/MNYgMjWGa/9IhWqOg9BShFAsG72DXDxN5EWT9095NID5isbwwDt/0pSLuhN1NnFVlNyy3uZr+bWtVfPS0h5o8bxGrbJ/ku4kwnKxrc/5rmfaREguVWspDWDmAbCeRNoqwouzhLe5zItF2B9kO7pE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7721.eurprd04.prod.outlook.com (2603:10a6:10:1f6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Mon, 14 Feb
 2022 10:07:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 14 Feb 2022
 10:07:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [RFC PATCH net-next 0/5] Replay and offload host VLAN entries in
 DSA
Thread-Topic: [RFC PATCH net-next 0/5] Replay and offload host VLAN entries in
 DSA
Thread-Index: AQHYHfxXQePXs1M3lEOTgYyrlnmZbayR2mIAgAATBoCAANrDAIAADtgAgAACXYA=
Date:   Mon, 14 Feb 2022 10:07:30 +0000
Message-ID: <20220214100729.hmnsvwkmp4kmpqwt@skbuf>
References: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
 <7b3c0c29-428b-061d-8a30-6817f0caa8da@nvidia.com>
 <20220213200255.3iplletgf4daey54@skbuf>
 <ac47ea65-d61d-ea60-287a-bdeb97495ade@nvidia.com> <Ygon5v7r0nerBxG7@shredder>
In-Reply-To: <Ygon5v7r0nerBxG7@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 64bbe294-3102-4a49-bc47-08d9efa1cfa9
x-ms-traffictypediagnostic: DBBPR04MB7721:EE_
x-microsoft-antispam-prvs: <DBBPR04MB7721DBC2256B38FAE79C4ED2E0339@DBBPR04MB7721.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BYFjSsZ7J7Q6biSh5UnwB1fB/F83z/ZIaEoh1OZ1+m4I0YEQHdvitMyc1jpwZOteqLyUVHs9V4qHd9yYqqNiX4pMDvY1XU4VEIEAPRsudBE4edmh9ssc9hbrIGMJZl7KGu9LLcipxNJcOJcbwNXKMxJR6kZTiX5BW+jwtoKGSGLw5p2VIq8K+mNzGCXA4i3nrbFy4JndUsBauDNvtYspdEyUnX7YxMELYOkwKCBLYb7z0MvOYoKOlNXNZgYroQTmuPqzyLWK3RPZnWyUbfVrbuaqqo0edIttvJZgb6W1rm+NNPnIw0ACOV25R8X7BUAac2oAfr/hK8rMu+OspU4aX0VJIF6Jl3VT0g8dAIW5GJRiNMKZDLeKlA9wWuhYQaf4NX3GP7mz+TQeWznoGjl500SymtcGIEm0G21+B+32X0QBnoy1KgBjw64Sfa6f9g4lt4192mZqvNPa3uZyF0lpFnfNIIGF/PYvIJIcTxtCaBeRlyvehg/N2zYGqVyfWwY7nfotwegD+kD6PDIlzqJN+KGPmWxOJKmP7oMgDovtimENK6O0AUSAFgvYAeBYDIiU5asVjtqVBiDWpE4W7cXV5bBjog0njBbud3sBpU8p+9XoqCHeqeCa9Hij1aMFyH5hZdUeGh7S0LCvBWSZuJrgxssOgoQ213NQrQGcsUQ5g9q98RdiPlvPoIsKsDHZdVOYdBqBIn1R3XMyqdYu6VVQsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(508600001)(6916009)(86362001)(6486002)(316002)(83380400001)(33716001)(54906003)(6512007)(44832011)(76116006)(26005)(9686003)(6506007)(38070700005)(4744005)(186003)(1076003)(71200400001)(122000001)(91956017)(4326008)(66556008)(66476007)(64756008)(2906002)(66446008)(8676002)(8936002)(38100700002)(5660300002)(66946007)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zZv/qKZJEGVyqld8BXf0f4g5DZ6TkLRZ9AN91ViyU8xUUu97MNmffSaZmjri?=
 =?us-ascii?Q?D0IrJ+yK2N7t5lbUTL2mWyFvyEpoanc6jhJmW5tCkK0WtWXomsTN3/VUsgJN?=
 =?us-ascii?Q?EXrg24awdLtE0zOyaPC0Q8jwuGiVuuzLcssbPqVDttDlynN6vYve6UZFldgB?=
 =?us-ascii?Q?t3ECvWIhi7Dd/9xElnW2htjkacL8VPPbkT1pOgovuQ1DtSS05CqhFWubGD8/?=
 =?us-ascii?Q?AvbcLnOzbCHxtsQNtO+liomM4iwxj6OMmKkLORy0WW5wWSuKaJE8Bk+0D0V4?=
 =?us-ascii?Q?t/Bgv0Ir61RNhLC9+DSle7DyPmKiQiEnoytSaYVo85YmEQX04S1FTV3NzaVG?=
 =?us-ascii?Q?6SP25SjU30DTRUgsDv3g4M6qiXISn+0vTFKbgBAPQtmxIqz0x1Tq1fgGN9tZ?=
 =?us-ascii?Q?kd6a20BeeyBx26iY/AnGRsZ3mBN1i74lw7nHMLsUcr5ZEQ17JuzcquObti7w?=
 =?us-ascii?Q?AMrm1CKqQpDPjlFK/Tlf3dKkIMZkOCnxiAjOdhy98LbSe97npRxJecLLTFf8?=
 =?us-ascii?Q?5AKNNxwEgPAjN6uh4KBSfqUJfnsSD5vt3SSmB7PdX7Fpi3DAOHN1fwykbB0h?=
 =?us-ascii?Q?KCDxgZeMSG3HD1INoCjChHVVZzqnjtP+N5srO16wp05nNwiQ/k5blgldrlYy?=
 =?us-ascii?Q?pvBqL31sHL7EOXn+rSsNF4/y28PtmqBzDbUOs/JFFqI2TAOCERLmNTRtC+vW?=
 =?us-ascii?Q?iRF1VL2+FDLJdjtlA+07I2uoLeRQyEpPm481y29ji2qbJg7xE6LQg4gVPEGE?=
 =?us-ascii?Q?A1cRLDjow7567orylaAqLt+0qbypP8cr20s6gR9BZDq1B0sg2vQvkOvaBlQj?=
 =?us-ascii?Q?CcG2jj3HGzsWLpl885Y7HqoFJSNf0m5CH5pVHDISTL5LGS54fkp7g86otI6h?=
 =?us-ascii?Q?Gkyg9XQMA5Mq9Rbkl8sCMjBeuem0rNl9bJ+dJLgZgVkpPHEqGQE/QR3ST0t7?=
 =?us-ascii?Q?w0yvAEk749KAvA0bhR78WvIaWmDSAsiFEZzCwJuUXr2HKg0SGrJFXWSqf8EV?=
 =?us-ascii?Q?d04AJJRP+KRx71Yp2J0OX/geyK5B7uTs9PX9ETuBGy1LsNK+XRVR0hs+5U+0?=
 =?us-ascii?Q?CChcHXzHOPmsOPoIokW/IgLtP6giLD0uJ4x30IC9Dm4bhTUsM/UKZZgCqOI6?=
 =?us-ascii?Q?sHZyGpC8Zw9Nhtibfat25UA7kZYGso8ifm5CTSbcs+kYC5a6amAz7amlTBT8?=
 =?us-ascii?Q?Ce9BO/Ki3rDUoACXI87EFbGglOCZbA/avELNNk5M0ao0KSihErMLgkhsbCil?=
 =?us-ascii?Q?05N2gK2P5MJjPjce43uaNKs9aHfeBM+l9ola9wAJHYaZUjzScVN8A1DNSpSM?=
 =?us-ascii?Q?Uy4p+MKp58K1hXi2vSWw3Hw/9+in0kV3QAn8U4oXZrWOhiPZa0np1hVWC1wD?=
 =?us-ascii?Q?qzemZDIIPZLhKbs3Jh67ydGTQvgAcvysH4xCh+S66OpFBelcTpQJiG9LDiv7?=
 =?us-ascii?Q?wClvHovVs37pHVu0SpwMXTa1QI9nKXQz3sjSGcMDVYBmFMyuqfhDwrh2Qh4J?=
 =?us-ascii?Q?fPI6r/G9abKydENuGbwhkMx30ZwhmBI9yBcIlXw5ZYrSXUdDDGiXTz8mf9Hi?=
 =?us-ascii?Q?xGqIp70Ndt2OO+UdlK1c3RsVIN/RPLgfBMxdV661Xq2Bv1poziXY4C7DdylK?=
 =?us-ascii?Q?YGw4pzLT2BpUGSAPiZaT5B4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <95A9339C4E0FF84E83D952E29D4C8094@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64bbe294-3102-4a49-bc47-08d9efa1cfa9
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 10:07:30.0854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YQTF1WpiXbrGba7xgeHz4azCFEHbLW5UXaUc1VMgqPrHSk4KduPISNe3woEi2sPQtaK/WEbQqmGhH9Mwb0e/Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7721
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 11:59:02AM +0200, Ido Schimmel wrote:
> Sounds good to me as well. I assume it means patches #1 and #2 will be
> changed to make use of this flag and patch #3 will be dropped?

Not quite. Patches 1 and 2 will be kept as-is, since fundamentally,
their goal is to eliminate a useless SWITCHDEV_PORT_OBJ_ADD event when
really nothing has changed (flags =3D=3D old_flags, no brentry was created)=
.

Patch 3 will be replaced with another patch that extends
br_switchdev_port_vlan_add() and struct switchdev_obj_port_vlan with a
"bool changed" meaning that "this notification signifies a change of
flags for an existing VLAN", and the callers of br_switchdev_port_vlan_add(=
)
will populate it with false, or *changed, or *flags_changed, as appropriate=
.=
