Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853AC57CB71
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbiGUNJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233823AbiGUNIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:08:43 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60074.outbound.protection.outlook.com [40.107.6.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4DC8049D;
        Thu, 21 Jul 2022 06:08:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DjEkxVwTJwm/y3SoH6lWQEutu7ktCNyL4K8V4VP/PqS4H6qXm4LnPbJur5itK2A0/HFFl3b18Ua+aI0jX7kVgY+O55/rbi41L/Eu8//dlKBd04d2GZ5sSAuYrCj8cy/Y+QCYW0zK09F+QE69akAet/RpImIfJVbT66ogUSgISJS8DbDGdMEbxnQGSphsNn/3nLF1daMdQL4h7ierDUsawU1cNTkuGOhj0iDGikYmi5Ap1hTwCL032WI2H6GRQQ4Rk9uxUDd1VjNYM1F7SHqQSULq6/X5kXLyT8EdPBZ99pqroSqfx/GtIyYU4BkMYHT4sOjwFKwMuKDp1Cf4LMtCnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6RF6tq8PPk2D9kzeP+DShPv6b0tT43jpJHTED1dRru0=;
 b=oAT7aXMC+XY8i3GJkeD3/XTZLK5GRC6lQoMwMM9YdHph0G1MAqD8h6Ydiq1d6OhesQwg3Gx8A7zANPeqXA+fQfzbdwisqD5E1EdVJw2cpTOB1vYYszv+o8ml4EQjn8N4yOceCAsih7nNL1pW6YK7wLC53nMML3P+ZIEiXmBfhvV/HyU5z+WIP1tbYxV11KA6cbcm75KJPBqCo6FpG94JG4kqzFtmVoXQV9xwZU0xi6TBY5hSj8atvtvO9tubfzmgpIfC8St7Rwwnd5F1V7CeB9HIw7wzI2ed3tpnFCa2lrpX42FbZffIH7Dyei9UokvP5Ky7ujTwR0YYLCsyV5p72A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RF6tq8PPk2D9kzeP+DShPv6b0tT43jpJHTED1dRru0=;
 b=PosFs568V7n5mz6ihe7weeFrN0aBQwE76TyzW8IJQ8fx6TXHqZ0gc6roP1r1GFUh/ArzOd5i36LKwIiE5laRqaPicCzy4mF+IPWBUu3kBFU01bdUeH+sy8VAQPgNSdBLfE1mTTze61YiExmXfUYJiRy0tbHOMAqTCQDK8ZocAWE=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB6191.eurprd04.prod.outlook.com (2603:10a6:803:f8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 13:08:05 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 13:08:05 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: RE: [PATCH net-next v3 34/47] net: fman: Change return type of
 disable to void
Thread-Topic: [PATCH net-next v3 34/47] net: fman: Change return type of
 disable to void
Thread-Index: AQHYmJcN6BtHOZ1iLEuxpJ2LhXjKIa2I1FYA
Date:   Thu, 21 Jul 2022 13:08:05 +0000
Message-ID: <VI1PR04MB580747913CCE5E9BD5539253F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-35-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-35-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d466139-4a07-461a-08fd-08da6b1a0cd7
x-ms-traffictypediagnostic: VI1PR04MB6191:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hCXIlzMKsOUmx31MgBoGXOCKDDvTVC0KH5YrYquL8FxK6xdIdqdaiXbX/LteFpLI4flAbRPSpNe2hcrD3pLayhqWt9GHhH2DkkbiiMQf0AokC9YG1TS4MErfNqCjg7lxcweKleFrlEZ/x5cY1bh1JZkQ5s/hncMki7wuIC6i1a8UUKIk58WOjimgqKB3RTObbq/Cuq3e7axkNCqgeGol8TgXAoR8PPx6iKV0k8SODT/b2csDd/SUc7TC8QzfRpl4Xpo83Tj+zcProFoWFYsu2WGeo7u+9G+vv+m6yVBwNc5hkHLUUWefEngkyTA+eydaBAjHhCuaR4Ufd1PjMmZSYU+kUnxcJPZn5sswSOHQIYhB7SW5VRFdDEemagSP1qCvVj5LQoZgtzZMFQ6yL4EVvDrx9PnMpJiyvoHKVhBB1I0DA8mCDKObM3tykmgNS7DOE+GjrIIaNGZCWy98tr/m/cR+sSUhdrRfOmxz00VGlU5/kGQBgl862jsIHLwiuv/AVBV2MIXAQCjTqMmf5UGRRvVIE/c4yoIUEm9sitn4CICMEtThZaZyDmDcv5IAwFvnHhy9VaIKyAMzRJ9yXTnpQxC43phpuMzrHJAW8UtxolZC7ssm8GiYf9+J8W22HrB3eMVnvIIbUOeG2GyMhDwsA+736oFe/nTd4rK1YTOMe2gUuT26W3+ckakHygRkeuJEvSR/wcH3Gn4YwAj5AOx0rBfP/iwVnMYlHQMBRqxHs2u1nexdy4N8LBv/KCzCzzyLu+X3wQNlOuWIWuShX+0jAE10vVkUGFKRSfcmSJA5ROwotXOAJ4gzFptJhX7Wz7vE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(186003)(76116006)(38100700002)(55016003)(66476007)(86362001)(316002)(8676002)(54906003)(122000001)(71200400001)(66446008)(110136005)(66556008)(38070700005)(64756008)(66946007)(4326008)(52536014)(33656002)(53546011)(55236004)(4744005)(7696005)(6506007)(8936002)(26005)(83380400001)(41300700001)(2906002)(9686003)(478600001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4Cyn7hpvZYe+aVx88b8Gh263q1PTgihXZbegAFVv7YiWF4alOQwesG4j8AX9?=
 =?us-ascii?Q?zW7DcY2mjVeYM+g8U9ltWHe0zZ1M0HjtQr0WpyAEBI7La7jFBNl5RGbv/KJu?=
 =?us-ascii?Q?bzs8dA1V61Ksf2nZcyPxNjC3+XmZta/PKuaPRp/A+jOypNuGoZCujhYDq3jd?=
 =?us-ascii?Q?coFmDjVShucbCGfzbkqUYMxBKUcnyJtTZW69NG18zCWYTXDUvUNQHOQ8l2wH?=
 =?us-ascii?Q?5AeXgPzHvldCytnvID1QwpgpI60X0yJXvdjfF2RqAp+9kZi6eKczHq82rVip?=
 =?us-ascii?Q?lP/jC359b6eWWx4DgV7UJzvi1HJBc6rxLTaWbrGczTFtI8hH0aV0GPnGNMD8?=
 =?us-ascii?Q?kFSMBlMqEHP4p8dsFsDd1hvM+B2alPUiEfbZ3ecD4Xb2wsfx4fg8CWby3JoY?=
 =?us-ascii?Q?4360m9w6S+7mJ6SpP6FjzVcRQRXjly6upX7s3VT4p1EtOOLu64KAoudV8IMI?=
 =?us-ascii?Q?CStUfxvb52Pguhje6RK0KVDPfiOjZIvh/wa0ucE2z1V0q0/vqSRjY26Kzjgg?=
 =?us-ascii?Q?yx1jeyYMdbWTBhJvQffYC9N6biFmPvT4h5kK0GlTWLnMmtZdV7xBYNOub8Qn?=
 =?us-ascii?Q?S4sSckJvsB4t+LZKWuO7ttY6VkbcT5qFpqgA6Kj0mg8Vkr4+SLuUEB0bSRju?=
 =?us-ascii?Q?AXnIJbQTAfCCIyI4wDw7RBUrkyMHNKvvxxysozn3UlrMxR6FO3aTQKMYWv/L?=
 =?us-ascii?Q?UbjB3jkLQ0uYQlCcp3MMa/JvZ4sw4lNndG3A+oYXtBQxaD95bDGNImOHoT0l?=
 =?us-ascii?Q?tsBnIfxFvEYsbSIPytQV2gTMsbc7t9M2COrcMtuTS7smywHZl4pE8Qtjnzwa?=
 =?us-ascii?Q?ceYT0ftErN0z4yesVkDUsyAoQHUAKg7mFTDa6R1MRgupLYP6ZjqfCJyIUJBQ?=
 =?us-ascii?Q?ABBb7ssOCHUwzl8kKiPJuYk0jo4EcvLlGxe2OOdpXq61qNjG3JaaVFNWwP7H?=
 =?us-ascii?Q?kbD/tIvk9u4T29KSUxlHnJLn2jCpZGmKC/XotmOrcqIlXNXp6UoMztU9jGJ5?=
 =?us-ascii?Q?41A83u9mXEyYDBrp/+q2UVDnWtLZo5HMsp6ENA38yM1CfSexQH7unmQGngG2?=
 =?us-ascii?Q?C2mYLa+INkTcAVhrs+faHUpblM+vcpjLy17WmbVN9ZSdVeQui4S9JvdAYtqS?=
 =?us-ascii?Q?Buvlv90ArG3OA/hg0JIbA+VnKhJgIpX9YL8STQJo1CMAsfqQNZ/WaIUykuBx?=
 =?us-ascii?Q?5wd7Wl/4lhdDc3CUgUDY37xf0LSgbos4382go2J3X7/M5TOY+tx0o9cuO4iO?=
 =?us-ascii?Q?PCZo+SIlDEeibAoOvUCixcTm6Z9PvO0tqrlRtlLAZSeoE2nrXN5g1dPN6q4b?=
 =?us-ascii?Q?pzYcTgYvD5ykAH23FQ7qi4YUY12XsLF8x/sIHX8CWAfcu6Xb5X9S3Yzfaa47?=
 =?us-ascii?Q?airCKeqmzQyWzC7lulcl1cT6oKZ1gxWWPJq/b7HH1sSoMuLA1fvQRYZxdMaJ?=
 =?us-ascii?Q?ZLowT2DHAHy7vr/yWKGVvK4MOmjx4mo/WNenBqht9qtzsxibszVhCVmQTr1b?=
 =?us-ascii?Q?XWnW1hyP2PLpcyEvyWTMeG/6M4FwC2ggngsccO5fD9Z6hAyWoU9JHpKHNUfI?=
 =?us-ascii?Q?YafuLFnkNocxiP62mqDVCjYgr1sA1IerbC4p6Os3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d466139-4a07-461a-08fd-08da6b1a0cd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 13:08:05.4462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: npB6FqOLQCsD9SidCkuzJ+8zTZYgJtMKijqJBaAlIBNzupoDsJJkhkkMdN1oXg0wQNrbnUxQgRC8Ak5FmBrvCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6191
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: Saturday, July 16, 2022 1:00
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
> netdev@vger.kernel.org
> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
> <sean.anderson@seco.com>
> Subject: [PATCH net-next v3 34/47] net: fman: Change return type of disab=
le
> to void
>=20
> When disabling, there is nothing we can do about errors. In fact, the
> only error which can occur is misuse of the API. Just warn in the mac
> driver instead.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>

