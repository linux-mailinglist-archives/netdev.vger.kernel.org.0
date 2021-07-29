Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3D23D9CF8
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 06:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhG2E7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 00:59:45 -0400
Received: from mail-eopbgr1400095.outbound.protection.outlook.com ([40.107.140.95]:6323
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233900AbhG2E7l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 00:59:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXxspxa7r/fn/wgDMtsrJ98Fpy2QHwSZT5fhzDgXzALgUeI8Wal4QlDi6cA0ES2cENUmUyvS4tQ4vR8HbV+LrDT1CblKMpmot1ifltoDZ3DNvP25MrFqhzrHJizyJpkmc/OydhCWqZin5ZP5rm23p/8IHvAcmln3fluIvbp5oKKBKdpp94RoNIfzZBMPT1OTa7w2HEBFMm7DRSncBtqdY9Kp9T0Ak/Gb+xhp/JtwXQpm/PJKg5mnA1zvZ9dhJydg+0PKuYVZM9IpAF1h8gwPn7rxFznI58CO2DxLlXDqhIIumAD0RRZ2k85FD+s3dJK5wX/OUqFn56zsJute88OlTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ap2hWVqbl9+vemqHvohb+hGMMm3y0BhjPcMj6lIwmN0=;
 b=G11Dy7r9d4q0Ie0O9XdwhEUDWDP3WCTgAcOcoB78yCz/PvNDbHi5POOpBYaU5kDXCkEitxdUXrPdLPw44QBUJMG+m3ZDryJxKzgM/5zJq0zlpFOeMsJwyYpX8Zpkr1VgnuumTqJjwB0AVJ5SfHs1YCXUyPQGYtpFZFeKbwqoF/gx+VS9nzQ75mzxmWqJxewV2TA1/ktlgozhaAY0LCfHUUCaoW2KpLNljsFvkyq7Zgc9sDWq2Kn2mSfgSKLAGwyIeuqhcbklB4npT0ROHRVY08VRLqOR9AeSJhO4zosvyk4wwnKmIKp6CAFleNJKWkWVZtcQvfEgqLRPoe961ed54g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ap2hWVqbl9+vemqHvohb+hGMMm3y0BhjPcMj6lIwmN0=;
 b=bESstjhASgZXOnBiUCpU8G2hL1BRJxwDsm6XopntpCHLDFt466ZZMf0KCnjBTYdZS5kJR3VtHHu6zaCmheIhXRzt5DlVYgNIoTywc68fiI8P4sK6AjrTmUWU8eAylKqFOAGXspNOTZItsdF+yUhHi1vI44GEEYugpDuqTEO/oEE=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TYYPR01MB6778.jpnprd01.prod.outlook.com (2603:1096:400:cd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Thu, 29 Jul
 2021 04:59:38 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::7db6:310f:a5ed:82f6]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::7db6:310f:a5ed:82f6%3]) with mapi id 15.20.4352.033; Thu, 29 Jul 2021
 04:59:37 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     "sergei.shtylyov@gmail.com" <sergei.shtylyov@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 0/2] ravb and sh_eth: Fix descriptor counters' conditions
Thread-Topic: [PATCH 0/2] ravb and sh_eth: Fix descriptor counters' conditions
Thread-Index: AQHXgsB5q+zR5LvdjkC8e4BVJ5YfVKtZZEWA
Date:   Thu, 29 Jul 2021 04:59:37 +0000
Message-ID: <TY2PR01MB36925FE05E8E3A53970EE2C1D8EB9@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <20210727082147.270734-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20210727082147.270734-1-yoshihiro.shimoda.uh@renesas.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60404a59-b117-4e56-a7f9-08d9524daab4
x-ms-traffictypediagnostic: TYYPR01MB6778:
x-microsoft-antispam-prvs: <TYYPR01MB6778FDB8C8DE264915FE569AD8EB9@TYYPR01MB6778.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jr2pMFMB1zJ2IA7uAPQsXLwxsb/fLhA43F3os9dqSlThzpnPoogMuI1zSO/mFaZ4+q0Bmyi3SL3aisDcY80pZKTNdQSutWhQqkIpn2925h8ldDLg5O2DeWk7sy+oMOq3u7RPwdGi6AIk78Kb6Nm3liZgaX6VkT/A2+jEo52PMDGXXqZTAxeMFeyNETjaoypV8z+/ZrQyFOJGyHby5j7RYKDXazsMp5yDsD9zy/WBhojLOzdVQDk/k66v4ZnJ4OXdtFDUySvWWZ8HRJsN0Gipcv5P1DBCX0lQ2V8dYbul999MryRw/+hX8KeGG4p29gTSBU2Q31JPMIdDibWceVb+S04DPQJKJGtc/MhyAGRMLUeKgYZ9yyXbITIYEWSFZ0P2PSdgNmc8s+Osjgx0oGUZ5YJi6YmiWoRCXBS3zLao11VHrifbo9xdTZdTkZoK7W56sA8IEhV+oCQPPLzEkpzIXWJVx4yaLjIrV0RwAR3geikGkWSa7HlnwON9A5wSz+DiZK27g39WQJp1f2+mucY8lGj40ilbScIgUzaIP9zD7mfuVttGzYZBwwbGQcVq4iBeH/hJVs8ET8BCtiRvtptflUn9A9a7+fy2fVeUgXC9RoPNdr6WF5KR/igceiA2X+XaQqtsEmOqy36lM9W0QhP7GNEuPcc9mcSMicB6KjMenq2PqcsT5zg7LEMsphuEMQbP+VxqGZ4A+9sTizxB6oPnjQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(316002)(52536014)(33656002)(86362001)(6506007)(478600001)(38100700002)(64756008)(66476007)(110136005)(66946007)(54906003)(66446008)(76116006)(38070700005)(2906002)(71200400001)(5660300002)(8936002)(66556008)(4326008)(8676002)(7696005)(55236004)(55016002)(122000001)(26005)(9686003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5k7SahHJqTuwDWtU1+lGPZcDRVFMEFkn2+lgZP+FQvXXJkvxc3VyI16EV0yC?=
 =?us-ascii?Q?8sZZ2YumMEcMvYzTwe5TaPu/nH4/jCXt9ahDvCRYJjUqJdWPT09oJvm+DNil?=
 =?us-ascii?Q?Otq8wblLE8BePojQsoh+ZUiZmXCJO4c4Cfa13eb6FPPhKN2X6vZqfPvt8ZC6?=
 =?us-ascii?Q?Vh46h86j279tv+bwdsa2A2ooNrZzmsFm136Zsv95zTvTBPddCrx5PO4XRNRW?=
 =?us-ascii?Q?T2zBau0XOPcHdZrAoyXlUAebvqbv6V2znhZQE8GVQ1hKH6V/Pt33Cx6b7dU0?=
 =?us-ascii?Q?N4oduzf2twCI/d9tEGuVuFBOjKA6eQYMYM+5azykImSPdGXl07X2MeaGVoni?=
 =?us-ascii?Q?apCQN+HUeaDaWF2NPKfJUjdgJOUyjCCjQrdO/82cmw3ykwvmBAHbzttheDOH?=
 =?us-ascii?Q?ZR3mGJmzz780aft2s02enwsNNiLn4FjYSgqZXMtSDK4aTYZrKXV7rOLKuQLj?=
 =?us-ascii?Q?eYJIsgphL+6vOSjrZIhRJ4s3iFbXDzqVqte+6L7ipr/TOoIQ6vxiJnY/HgtG?=
 =?us-ascii?Q?PvSVxelGaDUU+XAsk3Sslxz8ZcVm0p6Nl99L3q2l7YmPUwYki8dReH3j8g1L?=
 =?us-ascii?Q?1SsDNk0SRJlL8EC8oUQx5iTegmw45TEcBLD5OPNOwcC9/TDUsw4tF9aHy8sl?=
 =?us-ascii?Q?kckpZoclaveBCrzKcL2+bwlgPNZTuP1T8ec6r5Vs9X9Yur8B/q0JBSMMy4Qw?=
 =?us-ascii?Q?QW6zPg5eKTzpqkVRymYgLLacaIXPyVC5RKgQuCaSwtWs0DKtTXbd14qfMTdI?=
 =?us-ascii?Q?zFbixikLwaLZKP6unX8F6UKQFQj76FH+/JacxHFT6wRrM0TSx8qDGdmGtdeC?=
 =?us-ascii?Q?c2bzSnzQJvGx2LuuOCLI1k9d6N8YEkziSosP64aSFpz8zxsLAXqK9AlsyJdI?=
 =?us-ascii?Q?8d2oFz2QOAYb/bq7bcloDnqiwKZcWnhesz73FH5dvqaHKW6rOcssLHZFaQa2?=
 =?us-ascii?Q?B0nd5WKELIJdfRAPxWO0qkiLAg6vU/GrT0AznaU8f5TGphhc1moIK1hQoyRr?=
 =?us-ascii?Q?C5ktwO/OxZ0r8Qzn7QFKjFj0AJ2tN90AC2RHrtB0dlG+V4qAmObOjOWUy5FC?=
 =?us-ascii?Q?ssK2RzEh28ZLDn8f/Ym1++kCOPoQf4yALDdS252D1wFtOv/M2fmFkhXsTOzQ?=
 =?us-ascii?Q?fzXHckUWQoziQbBHuxIdXHfI3g8IwPxKW0Qujry0VTUz2jZV3BsYJEOCmcjx?=
 =?us-ascii?Q?0d0u0+KKOXD9Xdb0afvaceUA9ty3ddShgH+AbQB6uCO1xFXZ0jDqeUFp6g8I?=
 =?us-ascii?Q?OgfSNKqcQrlI5TrA0sxTaMhKGtVsv0JMMUmhDzV+TleEfriMfZuNAttpKrWe?=
 =?us-ascii?Q?Hz8D4JpLJt0aMrVY0sP8gsf8?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60404a59-b117-4e56-a7f9-08d9524daab4
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2021 04:59:37.7902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vBDwa8F93gkb5T6yySm74FWQVpisyO/RT1fVPQZLE44dQzu3vLnHZmtxDhCc/PNv/AT8XjERxwc+LyOWEYlF05cilLWeU+9XlVeqG84S6dNeKYWi8aLZBGscOolx8Svd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB6778
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

> From: Yoshihiro Shimoda, Sent: Tuesday, July 27, 2021 5:22 PM
>=20
> When we change the type of {cur,dirty}_tx from u32 to u8, we can
> reproduce this issue easily.

I'm afraid but I would like to recall this patch series because
the original code didn't have any issue around these counters
so that the patch series should not be applied.

For just a record, I tried to write why I misunderstood these counters are =
incorrect below:
- I got a report locally about an issue happen when the system sends/receiv=
es data in long time transfer
- So, I doubted these counters' overflow.
- To reproduce the issue quickly, I changed the type from u32 to u8.
- And then, the following condition will not work correctly (as I mentioned=
 on the patch).

       for (; priv->cur_tx[q] - priv->dirty_tx[q] > 0; priv->dirty_tx[q]++)=
 { --- [1]

- Also, I found if we used "> 0U" instead of "0", the issue disappeared.

       for (; priv->cur_tx[q] - priv->dirty_tx[q] > 0U; priv->dirty_tx[q]++=
) { --- [2]
                                                   ~~
- However, today I got a report from our team member locally. The object co=
de of
  the get_num_desc() is just "from - subtract".

- If we use u32 as the original code, I realized the object codes between [=
1] and [2]
  are the same.
- Also, I realized just priv->cur_tx[q] - priv->dirty_tx[q] is no problem.
- So, I would like to recall this patch series.

Best regards,
Yoshihiro Shimoda

