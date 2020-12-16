Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8DD2DC70D
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388263AbgLPTZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:25:04 -0500
Received: from mail-eopbgr150053.outbound.protection.outlook.com ([40.107.15.53]:54689
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388256AbgLPTZE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:25:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHBwDx17o3uJhTqsSdgU+Rupe6MF/szgGEqUvCmB10zRyf1vLzABeElHaZ1QZemf4qo76D6ESym22QKuc8myE0sivoMALr8ObkAmp9bQy2tl3M80RiP7oPCSRJuZ4+jyQ4YXnPeT/ZwgPy2Sf77+V214ZWNjVWslOuKVfxYzmxRWMlbegvZCfyxClqer617V5NMaQueLM57kegn/0XeOiyINpiPeWfVcT8WKGIkZ+L64T1QjLvTPqCwu+THwgPTt2Rt8eFPThO6tqXrmh9cCpLem+iPSdHzYGwr/f2mRttfvzcwX9WeT27SOe4M2pGtMo53PJHE/35kkWiMvd80aLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cUP3DrZhBahVM/FZFsAWYJEX1HxIz8fxv7OEaI/V6jU=;
 b=bdMZnuzKVsF8vpXh4g9UUQkBqQtFaG0SGMh7cIC9gIUwEgaYwTA9OP8rqVEig3wvODSgOt0h1FoBQuUcxKDRisaMXEoPlV7ktfoj4iTPODhjGgaDLwlW90sVOchO4A6zmp+eiQxZ5btq5xhiRXzAT8Wh9jKU4yCWTw3rIMDYqX0x/mWcByirXSbGlrgzZUi7DVcRoPcZpSOP4zNt9S6sXquIABPg5JptOIqfCfeaYKdIAVWWeoqT1rw2pEXMzw3s/UUvU4+/g72C2VRwyRUHZBm56D2d3eVs2vvbSzPdkaKHc1MnLEw/My57jMJA4QMD6Or6eiimRRMGF0FtHp8uLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cUP3DrZhBahVM/FZFsAWYJEX1HxIz8fxv7OEaI/V6jU=;
 b=QEvCGWyXV2NPlxg5784PgUJIZhfgitrfgzSq/u+zxNEUTiLNYZ4PGvMiJGOs4lZFJl83QBMtQxjWxVop/+QuFeen4OioZRB6AwLc/qqat3uItW4LwT25E0AM2xATJmd1sT3JkFT35U/6RffCSpiyGBNSND828/DJdDJTd/YfIGw=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 16 Dec
 2020 19:24:30 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 19:24:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
Subject: Re: [PATCH net-next 3/4] enetc: drop MDIO_DATA() macro
Thread-Topic: [PATCH net-next 3/4] enetc: drop MDIO_DATA() macro
Thread-Index: AQHW0yhcfXCVFqFSBkOjDaWUaL1Ar6n6G9SA
Date:   Wed, 16 Dec 2020 19:24:29 +0000
Message-ID: <20201216192429.y2mlwlwankmd4wu4@skbuf>
References: <20201215212200.30915-1-michael@walle.cc>
 <20201215212200.30915-4-michael@walle.cc>
In-Reply-To: <20201215212200.30915-4-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 80321b6f-6224-4099-53fd-08d8a1f835ef
x-ms-traffictypediagnostic: VE1PR04MB6637:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB66373118CA6869987BAA54F2E0C50@VE1PR04MB6637.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:741;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f9wQk/KwPs0Gd/do/G7tdURW8WYtd3exniFF9TQgUrlMrtZ/hqoVD6YHt0FHh/iTnR9VLuqcBiX8TbCuoyXLc4HxOFRwqvMmrwCBrFv5CIC32ec9XmtuqMauBbYIWr6FzmCGAyWvNiDsfnx0XcVot87m853JTYnmjM5/XF5p4235NQ55Rrr3FbT8lN6vXHzM5tg80yjYMBGWM8y9ZdvdAjUqoYGNJ07A7O69MxKoEry/huNliwV7S59Q1fWPsIOt2V24RjL2UUfs+7nQMqtUVQODiheJ0dUgB5jsxPU1A+WWqzZF2nJ5sT+Kxy3rWm+T
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(376002)(346002)(39860400002)(136003)(366004)(91956017)(86362001)(1076003)(76116006)(558084003)(478600001)(54906003)(2906002)(186003)(71200400001)(26005)(4326008)(5660300002)(6506007)(6486002)(33716001)(6916009)(316002)(44832011)(6512007)(8936002)(9686003)(66476007)(64756008)(66446008)(66946007)(66556008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Pm28MgcVwdiI+1GBXURST/UbPNWi23nQp0tlQSBDcRZd7p2vrRJ3kABltzYC?=
 =?us-ascii?Q?bXlVGzEiygVp+dpj5sZIYL/Ob1906Itaz8HTpzzB6ckF5B/Ogu/OO7ch4QKe?=
 =?us-ascii?Q?U2vrTQEzWbJWvAiDck5G2tE5SFN8Q3wYBJKIUchiMQZ3FnP2eC2Eg5sjOq3u?=
 =?us-ascii?Q?PvaY+0M/TgPGVESB3qIHX8xDjQJ+ojSuOdI7PW6D3OOsBKIF1ie434Tbo8Jh?=
 =?us-ascii?Q?D1PJU1kqOjiLP+mxwGJ10e65rq04Ggu2bx7hdG0hdnbtnly7pVnCCSOG37ee?=
 =?us-ascii?Q?3WRzJIrmqHKqPrkbD933LSapArMigdXexGYcELW+rcr6tzY9Vjbsag/ru9YA?=
 =?us-ascii?Q?0HcA4r1YcXAiLCNoejb4FO7gx7IYb7NVmoAPMcCw+RXXa08NBOtxHc4K16tv?=
 =?us-ascii?Q?0oad43Jypb30IemyleEhYNR//RYofGW0VqFRCG22F9HLBeGyfcsPWSgf1iD/?=
 =?us-ascii?Q?BKy8Qzzj9vv7wp2Tn5OG13Dkf+xjypey2ld141na7rg+i9A97p0WmO45bRXl?=
 =?us-ascii?Q?rYAtGQQrRL9tYPs1GTfQF2nwRH41/rJ9gaadzvyToQd+JGyxwkTHUYmQuiE7?=
 =?us-ascii?Q?KUlrEZuCdvH6TIQ6s2TXOEuy4V4RfEO5B4CGrxTKZfygy5o4ynys5WARB1Hn?=
 =?us-ascii?Q?XuChfgWu5CK+rz0rH4Wt/5Ow9XeRApk5FYP4rk9OyBmSONZvOYxSXDxQeSdU?=
 =?us-ascii?Q?tEpFs+eNmnuiZaRIp5TM3NNyxxUoLlKTd4l7YZNkHiHa3W9LQHaxBNjRCgUb?=
 =?us-ascii?Q?QnhpGrO9o3EUqx+m97a9W3GNVeZmwkFWGnSiPdlXHXGhgxZHAb7yI9uYAcHx?=
 =?us-ascii?Q?FmlhzsFvY8uGppxuAG6ChQ+OoAUvySOkFCPwkvPQagV71el48ZuE9N9wjfNM?=
 =?us-ascii?Q?XcDa48j7nm6dA0oXjnWrMUJ7B0kVTfIZJCW+i/M9DvDPpaCulbnMA/RbwJlO?=
 =?us-ascii?Q?yltsEADwanxI2U0cBNu/0ES0Zkn9zqdPx8O1qYnzTwzqNylOzRHMW3yIMvbB?=
 =?us-ascii?Q?I3Kh?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <01ABDBD5845578468157DB32436C584E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80321b6f-6224-4099-53fd-08d8a1f835ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 19:24:30.0574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MnRQWFMCYhMHxjXTpDQh70RISiEN4jBCuYyiYfXt1s1+5wG6njLKWjEn1tkxCRXHf6Cd6D2UTYQVAx2LZxrFTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 10:21:59PM +0100, Michael Walle wrote:
> value is u16, masking with 0xffff is a nop. Drop it.
>=20
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
