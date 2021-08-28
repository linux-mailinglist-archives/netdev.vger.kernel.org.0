Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E693FA4C3
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 11:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbhH1J3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 05:29:44 -0400
Received: from mail-eopbgr1400137.outbound.protection.outlook.com ([40.107.140.137]:38070
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233610AbhH1J3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Aug 2021 05:29:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mwbI/ffG3tMqx09og390pE1byoPFQgvwhaepvzdp9xD8czF8FSzx/8tbsW6aM/wgE7g9feeDTHBc0EgAg9O6hGEDabZxhrLRvWLPuodyCbg3ZSN+zFHxJZP0CgJl5ReGkRohCDn0hG8Sb/F5j4KtYbSN4lDhOgie5O/W48lZE0gelyA8D0sArCf6zlMCko5QkB5RsibhdIU2IaLATifa8Sojp9iYpWvY9KY79/ZLDbcqR25oPSKRno7mh1wWx18KmbnmrRYg2cr00Vu/1eQc511UwdhgnbmvI4c4Z2pRB4pyznV/20JG/pXV2robsbJyea4vQc4Ab3LYWpNIkitajA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+80bUS5B23nFoAyFsmA5xA0FZdFvAtTNQ6zt/56wOQ0=;
 b=UQsc0kKSZODAgxzigbir/RcUAdrFd2g46ecxodkJDE4qLjD8yha6cKGtlAVB+qPjXrNyYYY+UrOHOtdPzss+VToAY/JvwrokmXJ6cwMqhtCHcRstCF7VStqESu8cyvGOh7I7lPkfA0AqVBwQBhJH2uSNv9lRCcc6t5fJov3itImpVyRGog3RoDKe2PMgdwwCvEtmoBpIFRcPnf7xgk9y5qZOeXobqpXePCxJSg12k6+YZO7u18Wi1FyF+q30fYw8yPgGo15zzvoeb0FhSHKbgUlNKd1nwoY8VYI4VsmkOpLd4A5M0W0STjYbBFvJj23Q52zzNC7wps8RxFdSrqvsNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+80bUS5B23nFoAyFsmA5xA0FZdFvAtTNQ6zt/56wOQ0=;
 b=KwVpGXBwGv97gCDmB/uMNwZdcv9fQtUUUFs+6ojkg1Y8zLxWtWhVUxuL8b5g5Cfl1+Xo057/PnXNfj97lzJ5qJMsbCC9LmjHC/HXhIb4dz9kgPFl6P8Krgzm9nSeUbscgWBOKkSaIEKQZRrMuI0CazO5KSBRCVBkiE8vvG5v1/M=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB4181.jpnprd01.prod.outlook.com (2603:1096:604:4d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.21; Sat, 28 Aug
 2021 09:28:51 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98%4]) with mapi id 15.20.4457.023; Sat, 28 Aug 2021
 09:28:51 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH net-next 11/13] ravb: Factorise ravb_dmac_init function
Thread-Topic: [PATCH net-next 11/13] ravb: Factorise ravb_dmac_init function
Thread-Index: AQHXmX8ziVcMUnkerkajOrIvR7yWW6uHwogAgADmhsA=
Date:   Sat, 28 Aug 2021 09:28:50 +0000
Message-ID: <OS0PR01MB5922C9765F849F1A3F8055B986C99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-12-biju.das.jz@bp.renesas.com>
 <f78fbc9c-be17-5854-3c94-7e6ef75f2b36@omp.ru>
In-Reply-To: <f78fbc9c-be17-5854-3c94-7e6ef75f2b36@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f63f1725-ad82-44f5-8887-08d96a063f27
x-ms-traffictypediagnostic: OSBPR01MB4181:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB418195921B70744DA17C84FB86C99@OSBPR01MB4181.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 811gBTTWY9hEsXVuLG9UCKzGXbuQUe6dMJePBUG6ThSCOB+lucPzUM3uB6H3+KHkHi7TFBtjXQbLucalkE48ryi5MRu0vm5v7DKcAsdzUwGnSZr08NfpgGVg6mOAlOpd1O0AmqEt1qTnKc6rgNefwESJf2dEwCzJgjTDHl2REWmERkxb6fLW5tZiCVH3ZheojbFuIg63gtQA8fxY41JnihIqtAXowZ7NH2EKvRRjxUyqhXt5u5ShRpKNxbDWhx5qjiIDmir/4WmblKDoS8bE3J6Gu41hrCpcVKArP8OR5D4HQvC/4U2yyiGk9+oRmApjy3SKufpCy6IXpkrKYosT1TRgVHjCjJriI42IkEvRipXKhXO+uJcKIl0tmljBYVI8EY2p4JWIb09NAKP3G3KXCb7Ri0Ta3lOVJHpXeRGOvqejKOf/ka3MrG7nWucX69bCfuT+e1cjfO8B/tIWbQUPp3tgo+wS7Cn0ynq6B79xXufkfhInfhQLUCtSonxr0d9SollSpsfXLBqOCbhdv5sisIJS1ASZm0NpGOsxkj0oNlYRUvGzIzJdCJkP1JGfFN64k9nMogRI7XhxA5CWZ/ovkmFtlRHxUi0YKZGnAJxX7DOTmqj7Z54sMhHswi+yIp32xlaglEIA+eMprTLUN15GWD45Homy1sMXlcvGXxgDREYo+6QWQifFhLSWpYRVKrCE24vHWcdLCxw4BpV84+iu/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(366004)(39860400002)(55016002)(4326008)(66556008)(76116006)(52536014)(5660300002)(71200400001)(2906002)(107886003)(38100700002)(7696005)(66446008)(66476007)(33656002)(66946007)(26005)(64756008)(8676002)(9686003)(8936002)(110136005)(54906003)(316002)(6506007)(53546011)(478600001)(122000001)(38070700005)(186003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXZmeEFkbjZwMGt4YWR2WURZQzdFVUVIWlVYRVYvc1RjV2cvN3JvVnQwbS9X?=
 =?utf-8?B?VTdSSkg3dWRKa3R1d1M1djRZc3AycU5uUXVLL3pYS0EvYi9PRi9PTzNvN3pi?=
 =?utf-8?B?cVE0Rmg0V3VUQW5OeE9pcUVqNXYzZllFa01HdWxOdVNBUlBvcG5tT1F5T0xV?=
 =?utf-8?B?TlRDSTAzWG9tQ2s1cE02Z1RVMUx4TlVnQlR1YU1QNlJtaVdYTk1yMmNXYzhy?=
 =?utf-8?B?OE1QTEM4cUZBcDB0eFowc2t1djhNSmdSZUwrSmEvMktiMU9SeHloaDFjMitD?=
 =?utf-8?B?V252bVUvQXRmSGF5VU0yNVkrM3NsZWM3LzVCaTJrclFaVTJuVlNyYUw2UG5n?=
 =?utf-8?B?WHhBRXFqOENRQzBVcUVnRnVFTEtGRnA0QTd3blh6NCtoVjE3RmVuTktjYlBn?=
 =?utf-8?B?R0QvRTNIVFM0Uk5MbWpoZEsxdjNlWk82Z2pXamhweE00K3doUTk5WlhzNUlr?=
 =?utf-8?B?OGM3cDhYZmNpcnNETlBtZ0RlYStVZWxVdEQwOFFwVlhJQXFTUzMwR3N5VG5j?=
 =?utf-8?B?aWEzMVc3TFVTRSttY1o3SjRBTmQwTEQ2SFNzdnFvQ3FPS2cxOStGVGtpc0Jy?=
 =?utf-8?B?N25MSk9jWEhVZWFCM2lzK0N3enNNZEcwWUdQajhKcWNzQ25tNVN6WTJPNjVH?=
 =?utf-8?B?SklwQ1BxdUU4d3A3eVJ2SU5LOUJqL09WUU1oRHhDZEFGR1Ywd1F0WjU4NTAy?=
 =?utf-8?B?Mk03WkRiTWJSQitoSEtOR0ZyWXIxWkw0Q1VuUS90ZkNuYlpJUHd3MnBDN3V3?=
 =?utf-8?B?d2dlZ2lGWUxuTTZ6UStMTGI5MlRsT25tOGRHV1RVcU90YUlMd0xlZmRBbXEr?=
 =?utf-8?B?a2lFSXhpVFR5WFJ2eVdZWEkwcFR0bVI3OWtBT3dka3lGQlExNmZ3dnoxbGVJ?=
 =?utf-8?B?R1ZEN29ORnI3dkxiNkpLajNTcitkNFV6eWdRWlJMUWNramltTzhjUEZQYUFq?=
 =?utf-8?B?ck5YVW9SZFBtMUtmYU1sa0FsRko3dnNGeGpkWUs4VlFIclVCK2JacDY5dG9C?=
 =?utf-8?B?V08xcUZsWmlmWVdEaTFoalczbWM3a0NUVVVBUXRMRU1STHZFUnJlcm5HTGs5?=
 =?utf-8?B?NnQweWhjRDZNNVBiUXlrWUFDc09IaE8rVkhiUVlrQy9UcnRyQ08vZks0Y3hS?=
 =?utf-8?B?clliY1J4Q1RqejRsb25NbS9Qb3d0clc3eTNXM3FiSzl0WXg0azMwcWNWcG9K?=
 =?utf-8?B?Z3hJTkkvVCszLzA1dHVxdG1aWmE4S1UveXZrUjZNSTk3QmtRTDlxcmFpVy8z?=
 =?utf-8?B?azl5SWFIUUZXbEZZVjE3Nzl3UjNpWmRIbUtZanVuczRkY2RPU1JGN1dha3Vj?=
 =?utf-8?B?czBVNmxWRDBsQzhNbEtIRzdkNzFhM2xyc3dQYzN6eE9lWis5S3V5Y3Rmek9a?=
 =?utf-8?B?cFJ5ajdjanNZRUt3MCtpa1gvRU8wWG1HdzIyamlrWnloa1RsRjJiOWhhVThY?=
 =?utf-8?B?L2NINVFDdHVUeHUzZEx1VlVsRjBJbVFLMnNTY1p6YUZkb2l5ZzhPdHJrT0Jr?=
 =?utf-8?B?R2I1aEx1V2kycmxOWXV4eDlMOHQ2NVY1QmE5UXJVYVJPZFlIZUdJZ0pHUmpx?=
 =?utf-8?B?K1RHUEZNUXNkTmJqT1JDVWZuTWVaTmdocTZOSGpQMllya0lnNFIyYW9XaG90?=
 =?utf-8?B?dkQvTVBYZUpneUVXMHA2dzJxQlJxUkcvN2x0clNOQUJDQzAxSlFPTk44YlN5?=
 =?utf-8?B?cGwzQ2wrREN5WEZtdEJTUzVrcDF1eHVxeVoycEhFWkRYQWZ1RnVYb2kzWmxs?=
 =?utf-8?Q?cpRQrluGGzi+d99YAI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f63f1725-ad82-44f5-8887-08d96a063f27
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2021 09:28:50.9787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U8bsOZq5i3NKORPdXXWl1AcKJfL2Q4veTYJ/7KmhRSJkO0rA5HWkT7pD6Ik8UIiBgdHv9z8xj1K13UcPIBlMWXdPBBByZkYvBSPxwVarXUo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB4181
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IDExLzEzXSByYXZiOiBGYWN0b3Jpc2UgcmF2Yl9kbWFjX2luaXQNCj4g
ZnVuY3Rpb24NCj4gDQo+IE9uIDgvMjUvMjEgMTA6MDEgQU0sIEJpanUgRGFzIHdyb3RlOg0KPiAN
Cj4gPiBUaGUgRE1BQyBJUCBvbiB0aGUgUi1DYXIgQVZCIG1vZHVsZSBoYXMgZGlmZmVyZW50IGlu
aXRpYWxpemF0aW9uDQo+ID4gcGFyYW1ldGVycyBmb3IgUkNSLCBUR0MsIFRDQ1IsIFJJQzAsIFJJ
QzIsIGFuZCBUSUMgY29tcGFyZWQgdG8gRE1BQyBJUA0KPiA+IG9uIHRoZSBSWi9HMkwgR2lnYWJp
dCBFdGhlcm5ldCBtb2R1bGUuIEZhY3RvcmlzZSB0aGUgcmF2Yl9kbWFjX2luaXQNCj4gPiBmdW5j
dGlvbiB0byBzdXBwb3J0IHRoZSBsYXRlciBTb0MuDQo+IA0KPiAgICBDb3VsZG4ndCB3ZSByZXNv
bHZlIHRoZXNlIGRpZmZlcmVuY2llcyBsaWtlIHRoZSBzaF9ldGggZHJpdmVyIGRvZXMsIGJ5DQo+
IGFkZGluZyB0aGUgcmVnaXN0ZXIgdmFsdWVzIGludG8gdGhlICpzdHJ1Y3QqIHJhdmJfaHdfaW5m
bz8NCg0KSSB3aWxsIGV2YWx1YXRlIHlvdXIgcHJvcG9zYWwgaW4gdGVybXMgb2YgY29kZSBzaXpl
IGFuZCBkYXRhIHNpemUNCkFuZCB3aXRoIHRoZSBjdXJyZW50IGNvZGUgYW5kIHNoYXJlIHRoZSBk
ZXRhaWxzIGluIG5leHQgUkZDIHBhdGNoc2V0DQpmb3Igc3VwcG9ydGluZyBSWi9HMkwgd2l0aCBk
bWFjX2luaXQgZnVuY3Rpb24uDQpCYXNlZCBvbiB0aGUgUkZDIGRpc2N1c3Npb24sIHdlIGNhbiBj
b25jbHVkZSBpdC4NCg0KQ3VycmVudGx5IGJ5IGxvb2tpbmcgYXQgeW91ciBwcm9wb3NhbCwgSSBh
bSBzZWVpbmcgZHVwbGljYXRpb24gb2YNCkRhdGEgaW4gUi1DYXIgR2VuMyBhbmQgUi1DYXIgR2Vu
Mi4NCg0KSWYgc3RhdGVtZW50IGZvciBhZGRpbmcgUklDMyByZWdpc3RlciBmb3IgUlovRzJMLCB3
aGljaCBpbnZvbHZlcw0KRXhwb3NpbmcgYW5vdGhlciBod2luZm8gYml0Lg0KDQpSZWdhcmRzLA0K
QmlqdQ0KDQo+IA0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUuZGFzLmp6
QGJwLnJlbmVzYXMuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBMYWQgUHJhYmhha2FyIDxwcmFiaGFr
YXIubWFoYWRldi1sYWQucmpAYnAucmVuZXNhcy5jb20+DQo+IFsuLi5dDQo+IA0KPiBNQlIsIFNl
cmdleQ0K
