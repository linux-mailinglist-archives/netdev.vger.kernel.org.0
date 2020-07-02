Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7237E211ADE
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 06:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgGBESV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 00:18:21 -0400
Received: from mail-vi1eur05on2083.outbound.protection.outlook.com ([40.107.21.83]:6229
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725805AbgGBESU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 00:18:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRNyifR4lfwmngKto0PexM7aOuZdIsjs4ZM1ng7pGuO3/4M9A6NAxqzhJDQzz9a2su08JsDw/JzNhBzDzJXDX7YHz8LMGf7zXjMNRrRcDq8UoEAmQYpZFWnWz2VnWIoqqxp9wNGTQfUh2p0dXqKzS+t6NNKFpNP4JGoZaR45RzcK5VDvMy74RLra2gNNf8kmrkUuZZkKoq5KB/XT3d3wCN4sJmxtfDs3tq93aW4pE6EXK/JnwJpkbge7Qy8vR0Aa4EZDwqxrcbVvakV9fY1QQ/hkUKSmnFrZPoFI7zzW4BesyocdbiF5T2eOvz1pb7vveOcONqDs1JFYAjRjLnDpKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A2ZPRD43mRa4mRPGMP7DPVpa3vbVCQi0jWkOUxy7IZQ=;
 b=hbSzjrBbNr0c0P+wmi3JZ9orE2jZ4Zff5rd2hxaqq2jj94Wk1KbY5BRlMLTjoqVQukDEgnYoqIkEzy02ThrxI0yBucsLe8lU+0l+MnbGb6ifQqVmFub1O300mKmLPU7T+3pnNM0weqCAS2S7fDpY2aB2yB9i+XHK/9WOaw1ta+4XcUP1hZw2MMJoqwpLGriG0UJ37vd9bmrjgZr1tkCaXcS5tSsiDOpDbcKIrVg7rV2JaRh1hP5SXiHbMztWYOmtpwcrw3SMxIfR/zXreDKMmcfygEDes7mMms4U9LWp7zy8Hb1RXcT/1VBwGGIyMZLD3A1olCqhAG9nIaYHGCY5Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A2ZPRD43mRa4mRPGMP7DPVpa3vbVCQi0jWkOUxy7IZQ=;
 b=bX5UenssF1DPn+hHndSOq4wBz5XL222n0+qlq3Y/BwtQ3t8g4zwB1SSh/FkCF98DlQjJlFvifUTPfIHkwREG/721uxAlqrd0wf6eQ6yWKo7Zz8ojOELHYQf6C4DfVgfof32FqOmekFB9ygD5TPoYUzWsQEgI+4fxhkGlvbSDaNU=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR04MB6214.eurprd04.prod.outlook.com
 (2603:10a6:20b:b7::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Thu, 2 Jul
 2020 04:18:16 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3131.033; Thu, 2 Jul 2020
 04:18:16 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Kegl Rohit <keglrohit@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] net: ethernet: freescale: fec: copybreak handling
 throughput, dma_sync_* optimisations allowed?
Thread-Topic: [EXT] net: ethernet: freescale: fec: copybreak handling
 throughput, dma_sync_* optimisations allowed?
Thread-Index: AQHWT9e4kn3p3ha4AEO+27pzlMnbc6jzmCHw
Date:   Thu, 2 Jul 2020 04:18:16 +0000
Message-ID: <AM6PR0402MB3607E9BD414FF850D577F76EFF6D0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <CAMeyCbjiVXFkzA5ZyJ5b3N4fotWkzKHVp3J=nT1yWs1v8dmRXA@mail.gmail.com>
In-Reply-To: <CAMeyCbjiVXFkzA5ZyJ5b3N4fotWkzKHVp3J=nT1yWs1v8dmRXA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 75c84dd4-7161-4dca-9287-08d81e3ef1d5
x-ms-traffictypediagnostic: AM6PR04MB6214:
x-microsoft-antispam-prvs: <AM6PR04MB621445F91F128446307DF602FF6D0@AM6PR04MB6214.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0452022BE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DVKSKIsL5fB+bvrxnm8BkgpFzhar5DrWv9zwaZG1BjzHUeetR3iO9NyAS3xEYixNHrB0e+P6S0wZVR7490CTEeBICsav30b2WlIaTA/ymAHDknlVd7/HmrHL4H3ij4U+6qE8tuvF3YsWgeJrojoe5TZR1YJTqJBrNRSRcd8uKDFd/1KZuyB7j65pdBDL8GedWUvPy7Zzw8Oe+v0xUiGWxb3W4AR3Vm94SQq/fe/HyCxQemAZqKPTCpb0WuLe6ZwfGBNMUtrp2rf2IhPtofkRYhu7Wt3lqWCeM8KXQYhkcczJ1AP77DGxZp/QfMy8BGv0FIaQW8g06hduQrJUJTZZQOmEiV76LPjRnVFfK3it6pu2mb8VL/0fgdK4mwiPyhXKg9XfjoOLV3+Ept22zd1uFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(71200400001)(45080400002)(5660300002)(55016002)(8676002)(83380400001)(9686003)(966005)(2906002)(33656002)(83080400001)(6506007)(7696005)(110136005)(52536014)(76116006)(66446008)(26005)(66556008)(64756008)(66946007)(8936002)(316002)(66476007)(86362001)(186003)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: PVyAG+lOOmKSGgTEPIskMdkFBnOpdtVib9yfnG6LoVOhFKMORnHGX6EcnTN8Gi5up4J4q6Qnj5FhLigSxW9IUzUa14FSl3WCTWomkAS6x2Xyk02Rn/gBNo45fLHaIXHOxWxe0YgHzDQ3BGOMjG6GnPksdVkqKAkhpaRiOyL/tReUA2izmcjvkr+Pcn3MlgXCMP+WacpbeP6SRd6Z0ILKEiWv0BfR0kjABq62f0+73gm1MtXhUvh4ckyprdUwma3VlZgjCUHgzixNmDdC/1slORR1tMpD8TSaWfNEY1svvUbdhStfYG4mchs951hzDKX8gI6sdTY/ybSIwMbdv9dMhudyxSqL7ziItduKiYaT6RXICzreqhT6VhEvfFQpvbJdl/aDZZv53ccrpVObieU74MFNLEdx6l8GO+o9W3RbrTSmRqwaA1R+JhIbMBR/BgEw+UGNAKh+QxWPVz4fns6BCXuNeZsn+0PNRnVGuy0TFtzD6QJSwB8Yyr3rBOGz4YSn
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75c84dd4-7161-4dca-9287-08d81e3ef1d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2020 04:18:16.6442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n1tDLfw0KDqOXtO5gE9I8ytUkWoPt/bv/qgHijJefPDUTGjBu8pDIZMYAZh5D3y2Y4mtZPO8XFS+Q+NvT3p/Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6214
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogS2VnbCBSb2hpdCA8a2VnbHJvaGl0QGdtYWlsLmNvbT4gU2VudDogVGh1cnNkYXksIEp1
bHkgMiwgMjAyMCAyOjQ1IEFNDQo+IGZlY19lbmV0X2NvcHlicmVhayh1MzIgbGVuZ3RoLCAuLi4p
IHVzZXMNCj4gDQo+IGRtYV9zeW5jX3NpbmdsZV9mb3JfY3B1KCZmZXAtPnBkZXYtPmRldiwNCj4g
ZmVjMzJfdG9fY3B1KGJkcC0+Y2JkX2J1ZmFkZHIpLCBGRUNfRU5FVF9SWF9GUlNJWkUgLSBmZXAt
PnJ4X2FsaWduLA0KPiBETUFfRlJPTV9ERVZJQ0UpOyBpZiAoIXN3YXApDQo+ICAgIG1lbWNweShu
ZXdfc2tiLT5kYXRhLCAoKnNrYiktPmRhdGEsIGxlbmd0aCk7DQo+IA0KPiB0byBzeW5jIHRoZSBk
ZXNjcmlwdG9yIGRhdGEgYnVmZmVyIGFuZCBtZW1jcHkgdGhlIGRhdGEgdG8gdGhlIG5ldyBza2IN
Cj4gd2l0aG91dCBjYWxsaW5nIGRtYV91bm1hcCgpLg0KZG1hX3N5bmNfKiBpcyBlbm91Z2gsIG5v
IG5lZWQgdG8gY2FsbCBkbWFfdW5tYXAgYW5kIGRtYV9tYXBfKiB0aGF0DQp3aWxsIGhlYXZ5IGxv
YWQuDQoNCj4gTGF0ZXIgaW4gZmVjX2VuZXRfcnhfcXVldWUoKSB0aGUgZG1hIGRlc2NyaXB0b3Ig
YnVmZmVyIGlzIHN5bmNlZCBhZ2FpbiBpbiB0aGUNCj4gb3Bwb3NpdGUgZGlyZWN0aW9uLg0KPiAN
Cj4gaWYgKGlzX2NvcHlicmVhaykgew0KPiAgIGRtYV9zeW5jX3NpbmdsZV9mb3JfZGV2aWNlKCZm
ZXAtPnBkZXYtPmRldiwNCj4gZmVjMzJfdG9fY3B1KGJkcC0+Y2JkX2J1ZmFkZHIpLCAgRkVDX0VO
RVRfUlhfRlJTSVpFIC0gZmVwLT5yeF9hbGlnbiwNCj4gRE1BX0ZST01fREVWSUNFKTsgfQ0KPiAN
CmRtYV9zeW5jX3NpbmdsZV9mb3JfY3B1KERNQV9GUk9NX0RFVklDRSkNCglfX2RtYV9pbnZfYXJl
YSAgI2ludmFsaWRhdGUgdGhlIGFyZWENCg0KZG1hX3N5bmNfc2luZ2xlX2Zvcl9kZXZpY2UoRE1B
X0ZST01fREVWSUNFKQ0KCV9fZG1hX2ludl9hcmVhICAjaW52YWxpZGF0ZSB0aGUgYXJlYQ0KCV9f
ZG1hX2NsZWFuX2FyZWEgI2NsZWFuIHRoZSBhcmVhDQoNCmRtYV9zeW5jX3NpbmdsZV9mb3JfY3B1
KCkgYW5kIGRtYV9zeW5jX3NpbmdsZV9mb3JfZGV2aWNlKCkgYXJlIHVzZWQgaW4gcGFpcnMsDQp0
aGVyZSBoYXZlIG5vIHByb2JsZW0gZm9yIHVzYWdlLg0KDQo+IE5vdyB0aGUgdHdvIG1haW4gcXVl
c3Rpb25zOg0KPiAxLiBJcyBpdCBuZWNlc3NhcnkgdG8gY2FsbCBkbWFfc3luY19zaW5nbGVfZm9y
X2NwdSBmb3IgdGhlIHdob2xlIGJ1ZmZlciBzaXplDQo+IChGRUNfRU5FVF9SWF9GUlNJWkUgLSBm
ZXAtPnJ4X2FsaWduKSwgd291bGRuJ3Qgc3luY2luZyB0aGUgcmVhbCBwYWNrZXQNCj4gbGVuZ3Ro
IHdoaWNoIGlzIGFjY2Vzc2VkIGJ5IG1lbWNweSBiZSBlbm91Z2g/DQo+IExpa2Ugc286IGRtYV9z
eW5jX3NpbmdsZV9mb3JfY3B1KCZmZXAtPnBkZXYtPmRldiwNCj4gZmVjMzJfdG9fY3B1KGJkcC0+
Y2JkX2J1ZmFkZHIpLCAodTMyKSBsZW5ndGgsIERNQV9GUk9NX0RFVklDRSk7DQoNCkluIGdlbmVy
YWwgdXNhZ2UsIHlvdSBkb24ndCBrbm93IHRoZSBuZXh0IGZyYW1lIHNpemUsIGFuZCBjYW5ub3Qg
ZW5zdXJlDQp0aGUgYnVmZmVyIGlzIGRpcnR5IG9yIG5vdCwgc28gaW52YWxpZGF0ZSB0aGUgd2hv
bGUgYXJlYSBmb3IgbmV4dCBmcmFtZS4NCg0KT24gc29tZSBhcm02NCBBNTMsIHRoZSBkY2FjaGUg
aW52YWxpZGF0ZSBvbiBBNTMgaXMgZmx1c2ggKyBpbnZhbGlkYXRlLCANCmFuZCBwcmVmZXRjaCBt
YXkgZmV0Y2ggdGhlIGFyZWEsIHRoYXQgbWF5IGNhdXNlcyBkaXJ0eSBkYXRhIGZsdXNoZWQgYmFj
aw0KdG8gdGhlIGRtYSBtZW1vcnkgaWYgdGhlIGFyZWEgaGFzIGRpcnR5IGRhdGEuDQoNCj4gDQo+
IDIuIElzIGRtYV9zeW5jX3NpbmdsZV9mb3JfZGV2aWNlIGV2ZW4gbmVjZXNzYXJ5PyBUaGVyZSBp
cyBubyBkYXRhIHBhc3NlZA0KPiBiYWNrIHRvIHRoZSBkZXZpY2UgYmVjYXVzZSB0aGUgc2tiIGRl
c2NyaXB0b3IgYnVmZmVyIGlzIG5vdCBtb2RpZmllZCBhbmQgdGhlDQo+IGZlYyBwZXJpcGhlcmFs
IGRvZXMgbm90IG5lZWQgYW55IHZhbGlkIGRhdGEuDQo+IFRoZSBleGFtcGxlIGluDQo+IGh0dHBz
Oi8vZXVyMDEuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUy
RiUyRnd3dy4NCj4ga2VybmVsLm9yZyUyRmRvYyUyRkRvY3VtZW50YXRpb24lMkZETUEtQVBJLUhP
V1RPLnR4dCZhbXA7ZGF0YT0wDQo+IDIlN0MwMSU3Q2Z1Z2FuZy5kdWFuJTQwbnhwLmNvbSU3Qzdm
YjU2Nzc4MTUzYTQxMzkyMTQ4MDhkODFkZWVkDQo+IGE2ZCU3QzY4NmVhMWQzYmMyYjRjNmZhOTJj
ZDk5YzVjMzAxNjM1JTdDMCU3QzElN0M2MzcyOTIyNTg5OTINCj4gMzEzNjM3JmFtcDtzZGF0YT00
TnY0SjdBUHptTlR2N0R2Mzl0bXdwSmhGZVo4Yk5ZMWVhb0FRbng0RmRNDQo+ICUzRCZhbXA7cmVz
ZXJ2ZWQ9MA0KPiBzdGF0ZXM6DQo+ICAvKiBDUFUgc2hvdWxkIG5vdCB3cml0ZSB0bw0KPiAgICog
RE1BX0ZST01fREVWSUNFLW1hcHBlZCBhcmVhLA0KPiAgICogc28gZG1hX3N5bmNfc2luZ2xlX2Zv
cl9kZXZpY2UoKSBpcw0KPiAgICogbm90IG5lZWRlZCBoZXJlLiBJdCB3b3VsZCBiZSByZXF1aXJl
ZA0KPiAgICogZm9yIERNQV9CSURJUkVDVElPTkFMIG1hcHBpbmcgaWYNCj4gICAqIHRoZSBtZW1v
cnkgd2FzIG1vZGlmaWVkLg0KPiAgKi8NClRoYXQgc2hvdWxkIGVuc3VyZSB0aGUgd2hvbGUgYXJl
YSBpcyBub3QgZGlydHkuDQoNCj4gSSBhbSBuZXcgdG8gdGhlIERNQSBBUEkgb24gQVJNLiBBcmUg
dGhlc2UgY2hhbmdlcyByZWdhcmRpbmcgY2FjaGUNCj4gZmx1c2hpbmcsLi4uIGFsbG93ZWQ/IFRo
ZXNlIHdvdWxkIGluY3JlYXNlIHRoZSBjb3B5YnJlYWsgdGhyb3VnaHB1dCBieQ0KPiByZWR1Y2lu
ZyBDUFUgbG9hZC4NCg0KVG8gYXZvaWQgRklGTyBvdmVycnVuLCBpdCByZXF1aXJlcyB0byBlbnN1
cmUgUEhZIHBhdXNlIGZyYW1lIGlzIGVuYWJsZWQuDQo=
