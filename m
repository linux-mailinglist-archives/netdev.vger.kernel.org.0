Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5DC47A263
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 22:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236666AbhLSVna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 16:43:30 -0500
Received: from mail-vi1eur05on2135.outbound.protection.outlook.com ([40.107.21.135]:42047
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231821AbhLSVn3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Dec 2021 16:43:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IhADqymrBQ3wpFCT+l1uCt57g9GXWzOuAUTnip99LPbnzsUkLPCvU5txiOyttU1I/PcnFxIPQhrvNo2T8ILNxOS2RU+JUmh5v16YejA49hcaE3fM7nBb47+Dtbt+yIiTNTlNry5SKRvsZZkC3vhPqNWkCsAtjwK7AIFGMs5pXTC4yRqRMHUKWxe1LDP12gX1A3NmITHf35V4xAoE+vFduYo59Bh3OZ0IV52sxgeCccX6zHr+5eXb5/r4eITH3bfMO6ARNVZfenC8SO+rPzhb7l4KPGV2ll0p4cF9NWxEoE/5tlpJdWY6MjZgmIB4CO8K/qUELB+FwhXjJqpjflqfhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNpM13gpybaItbagtwyk5/H0I65MP/DsKnk8YPZPSMI=;
 b=kqLpvrevmI/kf7HyO/XfUgDbCwgGQvV4/QXnAOpLioFp67wPFun+rmAgw4/rbDXUHWbOiHqP5wVFH2KBtisyIMBHbt5zT26P4FtLdrNC+nQsFBySJ0CL1TDiWVxuxjJv9q//WU+0JRlDNeYXUj7rl8LOArOhwr1aME+gN4WOF5sPydB7gnY9x8m+GYXq/lohYpts71PCA+Na9dw+6XjjVmABfJpWD36/rd6zYHMM29ImQfIrewBj/+2Gs1NWDWToT9f25fIAMJi5h1zlCfrXqd1JCFunQ3At0sVxRffvj206aVGpxeHcjULCQSN49zem/zkn3NtXyd4Xtse6TqUKTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNpM13gpybaItbagtwyk5/H0I65MP/DsKnk8YPZPSMI=;
 b=PKS+tYX1m7PMmXWinB1rC3QvP+MwyqPw2FyrxAyNpPa8dW7u1Tt9lEEcQEZS4HJksSSMqu7pKAjkV0hn733lDM60ybEo50jRhbcrj9nRrenAxf8MaujnCOJdx0UNqakt1J21wL47veXIwYWPFf/UUFpm8GeDICbRTXEedZ3G0OQ=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB5992.eurprd03.prod.outlook.com (2603:10a6:20b:e2::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Sun, 19 Dec
 2021 21:43:26 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f%5]) with mapi id 15.20.4801.020; Sun, 19 Dec 2021
 21:43:26 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v2 02/13] net: dsa: realtek-smi: move to
 subdirectory
Thread-Topic: [PATCH net-next v2 02/13] net: dsa: realtek-smi: move to
 subdirectory
Thread-Index: AQHX8+dckTwnmQ3CTU+xcpYJ91IMt6w6WxiA
Date:   Sun, 19 Dec 2021 21:43:26 +0000
Message-ID: <a6511f9f-3b74-25a1-05d2-108cf9af12cf@bang-olufsen.dk>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-3-luizluca@gmail.com>
In-Reply-To: <20211218081425.18722-3-luizluca@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 352bcee7-0528-4de4-228f-08d9c33896f3
x-ms-traffictypediagnostic: AM6PR03MB5992:EE_
x-microsoft-antispam-prvs: <AM6PR03MB5992E35A54B632B5F5DFFECF837A9@AM6PR03MB5992.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4dTgrE9RemQOAM9mTSo/aqmB26j+FoHHvjR9SXwHx3uUJRoOhaGovb7RjlrDPphxUyI7Xqf3wHHQZtYYkTzz6MgmrkgmtL9d3QrZbKOb/IYumMIEgjAJltsplM1XW2B9RjfPjvv52VLMewIaX1r6tnfR2AUH0t2/gBOcoDgbaMeMIBrf+fFI6SyCPkQpZZKD9qQPUgWd/g6elc47E9Aa63nimZKja9xYxDo0xB5YB3nGsltqjQcOMmDUNRTDNxbhV1m/WOlaRpUTQS46JtrXeetPSlb/jCYncIz698x3ZMG7bUQAaGfNLtfpMHRe8mRKTYc/hGxfpIqjk6HTA71g5fT+mp6iKICGtHINahEDF7/irMOcGcJqRYO0CRSzyvzyrY3smvp0XRfk/6kRVQO/fSoomqcgK+kgfAnOkNnUPcN9nqZvDpPZk/UcnSz0Ty2zcZ8gJqCknWOBptex+Qt/mYrWymKpHugFUN4op0Aaufv2XBWIoJHv7LoXlymsI/CY4zB35eoTUtC875wjxp0L2X0pfyhoAGmQzFwJm4/O8v08F/j1HPZBvaO1kXnD2MquYNpwrnwpNK7rY0p0RZiBWK930Zb5NbcsF5OqAQUUaIFabUGyrABjU2HFvQBZ+cxrdo0xvElJv+phXC8rWD8M/g2xc8NCLdYKtmDryEM7FQPKyvHQkzRBX7fJEwHZHvf2vuJwQxSQspdbY7z04Bg4XpPDq6XANDgddtA04M+pARo7vsBqhHx8uV0Xx5XMAW38Wnpumdfdsf3FDrHZlmuPfw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(26005)(36756003)(5660300002)(6486002)(66476007)(66556008)(83380400001)(66446008)(64756008)(2616005)(53546011)(8976002)(4744005)(8936002)(6506007)(8676002)(110136005)(66574015)(85182001)(54906003)(316002)(38100700002)(122000001)(31696002)(2906002)(71200400001)(38070700005)(4326008)(508600001)(31686004)(85202003)(76116006)(66946007)(91956017)(86362001)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ejFtQ0VSanFoeUtBb3d0MG5aOHVuRUsvWklqa3JwOWhsVXZyeElwUkFKRFl3?=
 =?utf-8?B?TWZTUWRKTHIrZ0lJR3g2WmVEeVFOUFovSWM4VUxZWmE0d0FhSi9hZWxZazdC?=
 =?utf-8?B?c0xDWmQ3MC8rWHdTdnZ3NW9MTWZyZHl2YmJDWGo2TU8vclg4bE05TFN4SlZX?=
 =?utf-8?B?SUtwaHBQRGhLZjdFWVJJdXd4ZjM4SzcrazE1cGpveWlDc2FpQ2RUZ0p2TU9m?=
 =?utf-8?B?a1J1b0xTZFRuMUtXdDRsaURPcjlxY1M4S1RaZ0tVRkpKWmlJYlVWNlNaRFNG?=
 =?utf-8?B?N1ZLOWRlN3hoRjhXY01OSHhLK0p1THg0aDFYRmM4cHQvME9WNzR6RTVEblVO?=
 =?utf-8?B?dmhDZEdUcTM2eE15VFpBVUprM2JhTEc2TU5BN2N4aGlDaVc0bEtwLzlTRWdh?=
 =?utf-8?B?bGVnYVpIVlhwbnFidEY5c1pkZm0vVDB6eUJkVlRnUVMwaHpnT25Sb3BHeFNB?=
 =?utf-8?B?RHUxM2Nmejdvc2JhNmR0ZkFTN1B4YnUxbkZjYW1YeERVUjJ1bmhMcVhsT1lB?=
 =?utf-8?B?UTRlUnArd0xkWHVUbGsrLy9HdjA5NlpsWi9qbldvTkdHdVFMZHZOWWc2N0xv?=
 =?utf-8?B?Zk05RDJwWVgzWTN1S0dYdnc4a0s1QmN3V0dST1dncmJqUGRmSjJDNkZSYXNq?=
 =?utf-8?B?dTJSTzZzRklYRXhwU0J1YnJCYkdKRUNYVko1VFh5dU5RLy95RDg0RlhNOHdu?=
 =?utf-8?B?My9GbGl3aWJxTy8rd0J4U1FWa0kzb0VKek9aM1NPUmI5UTdwUm1UOXcvTjVC?=
 =?utf-8?B?cmR0S3RyaGl5enpnL0tETVAxQUZ3MHkvaG5nMU9XV2U2am1jWjdoQTNmTW5M?=
 =?utf-8?B?QXEzKzRqZFlkcG4vamduV1hHQzAzdXdIV0p4WWViRlJXVE5KejBJNmllNW9I?=
 =?utf-8?B?ZGlUZ1BaanV6Mk9jWWhTYmVCNktOVUZ3c2s0VlduZGh2MXdNLytiZ0locldt?=
 =?utf-8?B?YVJoelFnZnJ2SjZCR1AxNDh5eUNyemtrNWpnMlliMGJsejQ5cTZQOEtOTUhS?=
 =?utf-8?B?SXoyQ09vTml2a1F0SDJ2SlZNU0JMeFQwZzlrVFRkMCtndGV4Q3hhZlloZjIw?=
 =?utf-8?B?Y0lyNVhqSDhuRlNSeElma3cwNDA0bTNTaHZZdVdodGtUUmtsTGJjZ0JlMC9w?=
 =?utf-8?B?akxzcFFCemwxa3FnUDlLVWVkQUQ3Qytad3lTcm5IMnpQQUx4d2Z6TTloUUxy?=
 =?utf-8?B?Wk85ekRlYldiVUlWb3ZGSEdsUVRPS3BwUXlqSW0zRTJaK3Q5Y0hEVjNDWWdy?=
 =?utf-8?B?SjdJdlNValRwNDRBQ29LMnBoNTF2SEh2ZU9DdkpuVERRYS9lWkdUdjduWUJl?=
 =?utf-8?B?ZGU2QjgwMmV2azE4TjQvcWx1VE5xUWNTSXloSHpFR2lweENWRVJCSW1GajFt?=
 =?utf-8?B?SU5BWXhsODVwT04vR3JmUC9kUDgzY0ExSlhsWDRSL3RyL0VKSElQSEd2c29p?=
 =?utf-8?B?TnVsUWpwaGhWTlA4eVAxc2NGRmR5QlRxSVJYVWxSYTBKejB2S2FibjA3RWpG?=
 =?utf-8?B?eWg2cFNNOHFEWU1XemJiOFVVbUVwcmcxMTJZQ3hGR2NNcjE5OTFqTm85eXVV?=
 =?utf-8?B?MDhUTkx1VHFiQVF3b0ZZdFc3UTZiUjlSNFFRL2lwQjRuUXlTMkI1eGJ1SWcx?=
 =?utf-8?B?ZnFuUHp6QTVqdUhOZGY2SVN3WW9lV2xFUCs0VnJyUnZScXFncEVOTzFjRkpk?=
 =?utf-8?B?UGtLQWFjdHA0M3VzUTA3aFpjRzRkbzd6VWlrTEg1VDI1WTNNTitWOU1Cdlpz?=
 =?utf-8?B?ZWVmYkFvRnZ4cGhzY2ZrWU1yS3JrTlViejh6NzYzbW9ZTlZKVlJwTjBtOFMv?=
 =?utf-8?B?TVRmZmgwMkw4YkFUSHN6dzJ6YWlpL1hTOWRRTCtkYk5BRzdVOTZHNkd1dDZY?=
 =?utf-8?B?MXdzeXRVOEZjK1NDcG1FcDZIZHQ4dnZhbVAxdEZmaHJnWmplUkorVGkraEJD?=
 =?utf-8?B?RGhkemlzS2Qwck1YYk1oQXpXM1BGTkVNaTdhNk55Sytqc2NaTW1aQ2NxU2ZP?=
 =?utf-8?B?U25paWlya3d2ZCtUcUxJUlQ4QnFpcjBQRlhWOXBCRFYrblNhTU1xRnUrYW5N?=
 =?utf-8?B?WVNoVXI4SGdYakJQSTlBejM3WUYrWTZVSGlNUXF1c2Y3N3dLeHdma0w5QUM4?=
 =?utf-8?B?T2ZudTE3elozamJneEliR01QdlRPZ2l2b0JaczNGRkI5VFg1WmFoTVJvV0Iw?=
 =?utf-8?Q?MWlwngpB39/Uovkk6j1RqVRQ5HqqLGYkwX6XhDPpcEuS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2DB303FDC9162C4491039E258A6CE721@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 352bcee7-0528-4de4-228f-08d9c33896f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2021 21:43:26.6643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PWiY83TAKeAPpx2qFXE+964qDI6rYwyLhbe4n18I7LN7K31ew24SEFKHgZoohO8LdQjH+NGF3fKoJpvO7DCHrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5992
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTgvMjEgMDk6MTQsIEx1aXogQW5nZWxvIERhcm9zIGRlIEx1Y2Egd3JvdGU6DQo+IFJl
dmlld2VkLWJ5OiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZzZW4uZGs+DQo+IFJldmll
d2VkLWJ5OiBMaW51cyBXYWxsZWlqIDxsaW51cy53YWxsZWlqQGxpbmFyby5vcmc+DQoNCkl0J3Mg
Y3VzdG9tYXJ5IHRvIGFwcGVuZCB0aGVzZSB0YWdzIGluIGNocm9ub2xvZ2ljYWwgb3JkZXIsIGku
ZS4gYWZ0ZXIgDQp5b3VyIFNpZ25lZC1vZmYtYnkuIE5vdCBhIGJpZyBkZWFsIGJ5IGFueSBtZWFu
cyBidXQgeW91IGNhbiBmaXggaXQgaWYgDQp5b3Ugc2VuZCBhIG5ldyBzZXJpZXMuDQoNCj4gVGVz
dGVkLWJ5OiBBcsSxbsOnIMOcTkFMIDxhcmluYy51bmFsQGFyaW5jOS5jb20+DQo+IFNpZ25lZC1v
ZmYtYnk6IEx1aXogQW5nZWxvIERhcm9zIGRlIEx1Y2EgPGx1aXpsdWNhQGdtYWlsLmNvbT4NCj4g
LS0t
