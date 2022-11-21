Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C9D631D5D
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiKUJw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiKUJwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:52:21 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2112.outbound.protection.outlook.com [40.107.114.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942B822C;
        Mon, 21 Nov 2022 01:52:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VYa0tiedC3SSs4AVsCs1OyAiDhtB+Rc8vdX2xP0PzDL9HUzSC+bE8zAF5oQAxl3Eg+QzRH98J7XlrtThJ4Zgu6WFeZoKSo+9bPixY+nCEZYpmaXd/HA1i4KAyj1dNU5fN2tmvJBNOLbKrvzJAmksStx/r2Ud4HssmYOPcupk1yJwkKEuioDWbx+HVPRcSZnkELnoEEmGrPeaXFU/Gv8ALZb/vxqm2o9uA5+MD0KjnuqLiznD0tUgilGTbDaqKv0DbsFUGcAOn9c5L8c4L3l5h0hv3yL4wKrSZLRQxTE+p4cpaj7zE0GCMjOogTChfbNqPvPt7QUJ7qUnMZ7HAQGD9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BGs23Y0vYvvcLdii01nNyjH+1D5aEIV8HPH4Gksktr0=;
 b=nQlc6c8ONNvywg33mCs3DICQJJhsDEHu5jmfLqSCQZQNTmzrWfn9AmSLAGlA1akekL2JLgTO40XHNRQcAmfQDzjbZPz9Xoer2vqLVA5J+mydUolr7jnL/6cLxZG1llr8v0IqXU4WE/30FVrHe4Ptcd7bsVT9GRAHACUNHHPLXh476ja0iP55MGwJzRL/CPVl8I4eVqpgL739iYyIDWevM5QicrQDc3GODOgwJVb8zwUaKIrRJoGi54HvD9WSPV82uzjYIDc8/lBJyS7G9osI0rFTisITafNX6ajnITpxLPR+wBJU+7tmOvTepz1h+iUiicqXtSGsX0LFU+QCr2JD7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGs23Y0vYvvcLdii01nNyjH+1D5aEIV8HPH4Gksktr0=;
 b=QY8mV3wzGYg61IBy8r9Lwh+MLKOrD1/Sq9V7j+WBunsAHo8pImtA4pbSP+DIDWy3IOb68tqwfS9nEIGGi5Qe9wR5zyXKmOTOSx4GfV+O/nJYZC0hOgjQfCmzEOGaItFXww2lFg+FXXlxmSWGBZxuvAbH/nO6oSxyWvbY9eZnru4=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYBPR01MB5520.jpnprd01.prod.outlook.com
 (2603:1096:404:802f::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 09:52:11 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::cd89:4a4b:161e:b78d]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::cd89:4a4b:161e:b78d%9]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 09:52:11 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "s.shtylyov@omp.ru" <s.shtylyov@omp.ru>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: ethernet: renesas: Add missing slash in
 rswitch_init
Thread-Topic: [PATCH net-next] net: ethernet: renesas: Add missing slash in
 rswitch_init
Thread-Index: AQHY/Y136Cd9+4jStEezP8zGERtt/a5JIjYg
Date:   Mon, 21 Nov 2022 09:52:11 +0000
Message-ID: <TYBPR01MB5341EAF9DD4CD59411B6C6A9D80A9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20221121094138.21028-1-yuehaibing@huawei.com>
In-Reply-To: <20221121094138.21028-1-yuehaibing@huawei.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYBPR01MB5520:EE_
x-ms-office365-filtering-correlation-id: dbd8beb0-7329-4236-fad6-08dacba60fdb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rsh39541IG63r8y0wyjQXpD6oh9WfYVL4ze5acjkqMDwgqYIjDrbe7VH0dp5Vbrh7Ntiei7U0/CEg5WubXx6fOHdUvGxnKAIKrtiyEAGdFg+GN3IEkvyKkoZ8HQLf4hWGoIz/FBNjGcCtPkbyx63PD1aZkeelrS5bEvAn158WpMXUwPNPBtl/d7q8mC6mdJxI9z5ejgiurOAiSxOfNgyFGfqrwr9L64xvU3hMwFKpNsMqDeZPRskEwFHh1de67JaO2ZR957NBAbzcFA8Q/AvFjNQq8EmUbnAINDW/EmX8hyg2ScAABPMp3hYNNZY6gyAlAtu+5ktq6ssiMefD71+IDrXF9wtG9kFhn+i3bOKS2mxu9V5zEiJBFX3tD9lURoFReXd7Fxonrdbffgcijh0XHIvQDQ7l4Jd+HpGn++3XnIS8ShxJ+ilGwGliWkptZ++ZDey0pD/mbo/+CJjQX04mqshY3I9LPv8dWQ4CqxsXJhNkqNelqXjYzpTEN7Ormabqmom0tjlwSxV6EG1pn9s2eZECDgQ3glNYtFlPYeSa04vZ3I2ivlkXEvK1DCKMpCTUO5gQzDi4Coht4vwaFvrJQL+9W7IYV0kHZEWl7eDDLWjVZcGofQ2BGYJuT0SvsBD2yYYpX4dPCQ6nFjVTVCBk51ygVpz+DNWiNBKyuy1azp5Jn8g37gkCLIL4VmqF2hWChlNQVIaiHK1BgQsq2/UsuE5Oia/1xvmiRJ9ooBHNN4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199015)(966005)(71200400001)(478600001)(9686003)(7696005)(76116006)(64756008)(4326008)(8676002)(66446008)(6506007)(66946007)(110136005)(66476007)(66556008)(41300700001)(316002)(122000001)(38100700002)(54906003)(186003)(83380400001)(55016003)(4744005)(8936002)(52536014)(2906002)(5660300002)(33656002)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eIXeJsHOPIK3XDeBWnTCuLtBB2ElNeIFZKBjpB8RBiIbMVnkB/DgpM2IPYlo?=
 =?us-ascii?Q?XT8YrmiozvWIXUpMiM/3x/ZVScL+y9b/YtzXNvdcVCT29Qhqrc8izuwr4U99?=
 =?us-ascii?Q?JPe6/FybktK4EzKJ8JahQ2QLix9EVuADah0Ei7BLSmeSnjytc4dMh/nlzjz/?=
 =?us-ascii?Q?JXuElKggO6jmLewijoge9KfoxwWKpEel89xHsu6eESYxaEKH2FrIqp+A79im?=
 =?us-ascii?Q?Frr4Y8vLu58ZS6BcYuOZlvlmmL2k5Ldi9iAq5f/JmngKB59mEu2NHqEOI+eX?=
 =?us-ascii?Q?awKgaToDcDgx4E9gsjb+Vyr5CIYALccOKd4zp3x24lqs9EFfJhwCbck6bSlD?=
 =?us-ascii?Q?qcdgZaCdyui58Ch4WjmHF9kSj9xktNEmHXq94tNONUAPcTqLSpTtL8Z3zm/6?=
 =?us-ascii?Q?ZY7doeDYESzPzPMgxkgrzNsThpi9N1lHRN1T17pEm4qyzbgLRyC2O4o+EGRB?=
 =?us-ascii?Q?66jSuGkZEdbl+PN0XG+4InezdDJf1ZyLQxJzwYxW2T3MyO+NI9kgbnYclMkL?=
 =?us-ascii?Q?QjxLQz1bDTVcU7dNmUZ8g2uqhqQ1bSQRQxnfgmjtiXM6DnrClk3tpoBoU/RU?=
 =?us-ascii?Q?Gr3Ck9KAWsHPLxPI+u+5GcRfKGCoRkLrxU2/HM6kjSXvEBerzxG+ZZi1waQf?=
 =?us-ascii?Q?jblOcOMuC83pEzf7UCh8y8poq+S0iFWzzKDAL6VXQATvXT6QfDJKzx6WG26p?=
 =?us-ascii?Q?gKWjOMfqa4fUEerY1X0rE6tLx/YqXkShWJJVp3uyvShLiINzDvsuIYWFqdGm?=
 =?us-ascii?Q?xtyWz4uZ1m/DgRkjdLft2j+zZWTmXaAWQTOa2IPhP6t7qnHIqRSAtq7Ioy51?=
 =?us-ascii?Q?cOBwZbzHPpsnAxix+UpYp6T7LZCxGH06AgXt4hc3dGp2a6VKDgMHrKCD82Wj?=
 =?us-ascii?Q?IJgIFQcR5suhhab5KPm7cK5hMchSsye8pOoMuEFvqs9+ykiBTXQGGxerzpOL?=
 =?us-ascii?Q?A87aC17kTaiU135gP/qnLjhlKqa7tMuaGMOzQvk+JLZjEzXbilLgJ23YTJO7?=
 =?us-ascii?Q?TtDDEfaw2MzcqjFwtHTczi1DgyLYopy6pOGoo8BOLPj1KMZHCKgKJ5whBe+k?=
 =?us-ascii?Q?iv98KuZPAgUAM23V7Qv0/aPRmWoAJDHc0+YDvU+ZD/s2q+IihhoZMhHuDBSP?=
 =?us-ascii?Q?/FGFJe4WI2xz7bNwqSpEWO2ZVIe6c+HbWP4wrR1ps5w8pbSH0q3M5jLOntZy?=
 =?us-ascii?Q?ZW9sGfOkeOGIHyC1/slO1bv3C1GhjAiH27wS4axdQWa5aRN/HU55G/AXrl1Z?=
 =?us-ascii?Q?Wzkbj6CaZmwS6xxda38JEP1l1E4uWCZFsvvgO8Q5zzr7cbWZJWXXZB1pXS/5?=
 =?us-ascii?Q?V5TMWRg70Vuc3pEa7sFn3GMrPrj9u5u4bHKjaUbu/UHEFpMs4qD73RsFzf6h?=
 =?us-ascii?Q?SRyzAkGs/vxryx0TagmHsTMg1Vn4ExBcR2cd5Aa4GzJzViaij73BT7oo7px+?=
 =?us-ascii?Q?aAL3r2/FjM/PRHAFjBnpCvu7VdFI/7uEwrSX9UKQ1nraNph0Dl3WcxKrcIcQ?=
 =?us-ascii?Q?+RNFv0dxYjH4yz0CKq+TT/j1GoN5Y7oCJPU9DPU3n/oSnqxf9EmsuuP2+U0I?=
 =?us-ascii?Q?xW+qWHqEIlYRozhFWwQgwtzrIbsuPDbka+KggGxdEyVvrZnEd17f+DaGdi9+?=
 =?us-ascii?Q?HoZ+QcsbSfqY7/CHjBgKmT/p3YVmkjjK6IW1y5HLE/W0SIQadNX5DK/wAgTK?=
 =?us-ascii?Q?w7+R6g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbd8beb0-7329-4236-fad6-08dacba60fdb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2022 09:52:11.7118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vm4zj8W1VlM2ZFQ6lc2sN8uipI9zpMSje47c5Jrgw4nMd0FvoGXjuf/AQZUOR3OoT+SV0OsZ1ViaMfTZpXNFlaDEE+QQ5jk6ti0ofHVcKt2yQTYY6o8Uh+7iKlLzQFtP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYBPR01MB5520
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> From: YueHaibing, Sent: Monday, November 21, 2022 6:42 PM
>=20
> Fix smatch warning:
>=20
> drivers/net/ethernet/renesas/rswitch.c:1717
>  rswitch_init() warn: '%pM' cannot be followed by 'n'

Thank you for the patch!
However, I have submitted such a patch as following:
https://lore.kernel.org/all/20221118002724.996108-1-yoshihiro.shimoda.uh@re=
nesas.com/

Best regards,
Yoshihiro Shimoda

