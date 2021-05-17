Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE1E3826D0
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbhEQIYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:24:34 -0400
Received: from mail-eopbgr1320094.outbound.protection.outlook.com ([40.107.132.94]:7850
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235493AbhEQIYZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 04:24:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3SUb1D+ytx1+SZzBkXQfmz6HWjqZD4Lq4Dt1FkyZspJtlt+pzRL68gPNOwqklNbTw/OObcn9IrYqSv4lyq09qV4RAeU1qMHCsf2BEvMVmKhEdWxenBhF5C8ma/QIBVUjgLcr/LWjG1ClwZVtpaXLdGQFIuBKmJl+oFcWKDTYHk8FXUcfzhw5UInn74yRlsxpzWqA5lMzwuJ32NItNtn5llf3e0xlvn5AdBNgz/xEn2jjGWcKdcwdOUnToMhdL53QAFVPf4AwSxc6fI2GWB7kVbKbbRqhMpv0EhhQKsORQQSAsObLtngi8H4q2wHAfnlnk78Lbom1STtn2lhPFNjdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IwuWCDqtTqQy9cOPYGGPnAOJMiXTnj0ugksqNutVXtM=;
 b=iLDPaBZccDl/SVeVsmM2eMiACpq+o8aylt+TENDa2LK1vHXbeBvWQUZYqxuKPPjUUcg7T9+rIQSmf7ijrQDhK3dt9HN+rMGdrg8jY/BUOwSx7sf4eoYDEsDhEyNY+RoifJWmqiYBypQABE1fhxOhBkxXD9pbGSD8M5dxxe2WytMQTgzLxNF98dhter4XC5/4PVJIPdhTNUNwD5xwglOJASSNQN8NOkgs1uiMm+X3KXNTqPVPQRrMpHQMp/p0TQwXP0zMlKG1f8PTSbeU2O7CQa176nfIDL4bx/fIDubmpnzeXi3tpx9Dg5GNUJMcU5ErJcuBfUoQxB3wm+HgYGz27g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IwuWCDqtTqQy9cOPYGGPnAOJMiXTnj0ugksqNutVXtM=;
 b=LbMNwW3cZpblXp4hbTo6kVhhzAyo5cOOp9tcWkzkrXD0IZdisk82zjMLSBr2Af3EzImK+G47OBL4lYuAWkg5R7GbYbmTcFz4Ghcb7BoUON4JTTm85qlTzn3Ys+popF+i8o5Ff0j6lKz8X71ypq1Q3u0XvfriOipQJl4PYUMMSUo=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TY2PR01MB4028.jpnprd01.prod.outlook.com (2603:1096:404:d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Mon, 17 May
 2021 08:23:07 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::e413:c5f8:a40a:a349]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::e413:c5f8:a40a:a349%4]) with mapi id 15.20.4129.031; Mon, 17 May 2021
 08:23:07 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH] net: renesas: ravb: Fix a stuck issue when a lot of
 frames are received
Thread-Topic: [PATCH] net: renesas: ravb: Fix a stuck issue when a lot of
 frames are received
Thread-Index: AQHXNmo4snkvFkzf+kiCjGV8r1I+Z6raKfAAgADjaICAAZGPAIAK31KA
Date:   Mon, 17 May 2021 08:23:07 +0000
Message-ID: <TY2PR01MB3692C8684B5AC4EAC10A1785D82D9@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <20210421045246.215779-1-yoshihiro.shimoda.uh@renesas.com>
 <68291557-0af5-de1e-4f4f-b104bb65c6b3@gmail.com>
 <04c93015-5fe2-8471-3da5-ee85585d9e6c@gmail.com>
 <TY2PR01MB369211466F9F6DB5EDC41183D8549@TY2PR01MB3692.jpnprd01.prod.outlook.com>
In-Reply-To: <TY2PR01MB369211466F9F6DB5EDC41183D8549@TY2PR01MB3692.jpnprd01.prod.outlook.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [240f:60:5f3e:1:417b:540e:2b1a:7472]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d52adf99-8df0-4c18-1b80-08d9190d001f
x-ms-traffictypediagnostic: TY2PR01MB4028:
x-microsoft-antispam-prvs: <TY2PR01MB402821CDA54A13B6FCC03776D82D9@TY2PR01MB4028.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eBjEd2erhW+Ykwek5zoFrL5Hb/MwYjahCm5/yPovoNLbMUjnD+lMjSNlVFx4JoGDT/nOr10gynHtW59ZY6dZpD/TLPiCJXArpH7C7XfkwQTrvb4cizwf66rxZAx0z6ulKgFoxB9rOQXgilBeUlzMNpDpjxXN/3x751TYJ+pZX/TRI2ww5v3sWfvQqOybCOGfRUjmypCfuFS89QBZpsUeyOpdwjmv+x1EaVTekD+dqsrImUizyQHj2tBy+Yg7bYvi/K0YGlFKkeXGP/s8KUDA0oe6eXVQh5s/AM8KzhMoW8Stub2/vXKDzYFGgYK9HCgviKHxUZ8OP7oemXWzUSM9syfHI5jk7gcu7Hz7Eg6CRcIp/wtAu4IolA6KQOi736BxKIl5ex8mJTW1r4m1Cawx4E3yWlcLmhQv4P3vabHvRQKQESl2oc+5Uqdt+5mq+zsMLAlY4laOZMCLfjXoO3PMLUaZPtcFa3E9tMrYftOlLy/wvZYoLN+QZNt8rWDTzEY3NEzFEuMTAz3f5lZYL99S5FMsHgrSi3q8gTl7jRUjpL/r2BA1KhBZxklIAx9Luvr8XszrOCYD50V37hL77KXKdy5TCu0Xxs8zt2bolbmLHxIgf0Jo3RsedINaawfCP8G6ipIodphCM2vc+qqbefPFKXCfTirfyAlxY5jNtLxenhJQREpgEOuZz2Dp5hMwvKC1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(6916009)(122000001)(4326008)(38100700002)(9686003)(53546011)(66476007)(2906002)(7696005)(86362001)(71200400001)(76116006)(52536014)(966005)(83380400001)(64756008)(66446008)(66556008)(8936002)(54906003)(316002)(8676002)(55016002)(5660300002)(33656002)(478600001)(66946007)(186003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VDh4amZxdXdOSEROSFJ0RGZzK0xZd1hGTGt4VVM0MUNUOTI0ZW8vdFY1ZzA4?=
 =?utf-8?B?aWxRYkI3VnpBZkhTQllSOWgrR2wwR2pjbEFSN2tmOVJURUU2R1NPaHVzRjdo?=
 =?utf-8?B?OHJUVzB5RUU2NzNVeDAyaHBXa0M0dGwyYWpFOW9DUVIxRFc0UEdZdlppWHpq?=
 =?utf-8?B?eEVONlZ6dkZMRlg3NGtUMStvc1V5ZHJhZGR4WlFHbE9Vak5taDFxdkp5Y2hO?=
 =?utf-8?B?QVQ2cHR3ZmtvNUk1ejRCVUkyQUQxc2VrM3E0MzV6V0lwTU1TczZFVElJM2h6?=
 =?utf-8?B?MGgrc1ZoMk83MXlaNVppNHRsVW9LQ2FZcVJMVG5Pd09BaW9OUUd1OGNHRXBO?=
 =?utf-8?B?NjdIb0NWQ2loZHdFZmVoQ1BlR3dmazRhc1NGUmRqZDhwTkhQaHYvSVRHamxK?=
 =?utf-8?B?ZjlUVGxOVHVmQzVDbmxhQmZzcjZWMXphazU2Mk5PVHFQZlpSY2MvYVBXVzNN?=
 =?utf-8?B?S3VqM1ZJbkczcFRIcmNjSEozOEdFb1RtK1B6Y3NDeGdNYjhzNFZiNXhRUVdT?=
 =?utf-8?B?RTZZdmNJV2VtU05wdmFMZUlTYXEvZWowVHRQY01FY3Q1Mk9lNFF6eENOMVB5?=
 =?utf-8?B?bDNHUVB3OWUxaHBvZUkxdUo0Uko4K1BBSnBMNE9JUE5VVWF2eUJ6ckUxR0NJ?=
 =?utf-8?B?V0Yva0hETmhpWERQMkxrTWNPcXZrK2xSZlFsYjJsMGluWStCN0FxclQzUjRQ?=
 =?utf-8?B?Zyt3bExOTnlZVTdoNU50dXBoN28vVnd1d2ZRYjlLWVJrTlk0bUp1UnZoZ0lS?=
 =?utf-8?B?K01jb1c5MFM0UENzUGVVVUhiQXRtSmIyQUF2b0krSGcyY1FleTFUVWxaUGZQ?=
 =?utf-8?B?R2wyZzJTd25uTHJXU0dFNFdXd0xqWnl1dFRFbW0rYUZYR2Y3eFlGbENZY3ds?=
 =?utf-8?B?TUNFR1RvVlhiTWlVc0I2MHQ1VEFqTys3UUswZmRETjRER2FmMDFneTl3a0w4?=
 =?utf-8?B?UnhaZmRmSkF4bTRDZmxiNmNDck14dUkzQXdIV2VzWnFHb0Y1dkNlZ0NFT21V?=
 =?utf-8?B?WmdaOWlXU1NySk14OE02bk5uUngvbHg3Ymg4MUdtbDBYeHRKcG41Nk5TekJq?=
 =?utf-8?B?Ym5LQTl5eVo1dEg0WFIzUHd5NTlNck5IN2c1VGxLNHJrcUJib3MrNTN3SUdh?=
 =?utf-8?B?VG5lTHNabE9xWFJwcEM2bkFROUZ2Rm9LaVI2UGMyS3VoUXJkQ1BjWjVKa2Ix?=
 =?utf-8?B?dVJua2ljazlDK2VwcU0zS3IyNWE5b0VxaW51cjZQN1hIb2tZV3NBcDNLa1l3?=
 =?utf-8?B?UnBQbnZSQ3FHN25ra0xQNW1xNlpZQms3K1Bxd3pBSXRHWVBFR1cxeDFMZDNp?=
 =?utf-8?B?WGc2UkdhVEh1cEdNdU1KKy8xQXR2K3NkcFZ6SzBEYzkvdmFGazhsb3ZEVXFl?=
 =?utf-8?B?MkJWcWRNdFdiZHNjSU15RjNqQjJYQml1cXVubGM2dTNiK0dzTmVKVVhaVDdw?=
 =?utf-8?B?SjdKS0VWQjBQa3hVUjFISThwM2VaQk9TZHZtei9tckpqL09WZHphbjVRVWV1?=
 =?utf-8?B?dFpRaDBER2I1QnVldmI0QUlId2M4cXNsYk54NExnZnAySFdKWFdNdGdUQ2E2?=
 =?utf-8?B?UXFrRWtCNWJhbk9vWVlrellDY1ZTQ0E5dlZUQXN6aFRsbkpleXQwU3F3OEZy?=
 =?utf-8?B?YzRGZTVENHI1cU5sYWZwV0VacFU4K01PeHNtRW5Ca0Y0d01UdXFQUlp0bHVq?=
 =?utf-8?B?TmsvaWhHdUh4L0tTOUptQThjdlZhbWx2UTlYNGVxTytBbTE2VURwMXRzTXpJ?=
 =?utf-8?B?L0d4cTNQRW5XMFplSzZMS3VqQnZVaE1mSW1sLzYwK21ISysxejdxaENGTjVX?=
 =?utf-8?Q?vgH0tiWw5t6GrLcsH9Vx9StUgW0AMHEip/ZSI=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d52adf99-8df0-4c18-1b80-08d9190d001f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2021 08:23:07.5504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kre1UTBXHfB6oL/763PXnEeDLVqs75ZPDuJdytCGtsAh683ykSnqkBzydS5blDP6yJ6cySXy6yGyl1PRuSJwNnrcWEm0jQf8eXPqOA43gI75A31bKST6SJYPONqhSxVV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB4028
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgYWdhaW4sDQoNCj4gRnJvbTogWW9zaGloaXJvIFNoaW1vZGEsIFNlbnQ6IE1vbmRheSwgTWF5
IDEwLCAyMDIxIDc6MzAgUE0NCj4gDQo+ID4gRnJvbTogU2VyZ2VpIFNodHlseW92LCBTZW50OiBT
dW5kYXksIE1heSA5LCAyMDIxIDc6MjIgUE0NCj4gPg0KPiA+IE9uIDA4LjA1LjIwMjEgMjM6NDcs
IFNlcmdlaSBTaHR5bHlvdiB3cm90ZToNCj4gPg0KPiA+ID4gICAgIFBvc3RpbmcgYSByZXZpZXcg
b2YgdGhlIGFscmVhZHkgY29tbWl0ZWQgKG92ZXIgbXkgaGVhZCkgcGF0Y2guIEl0IHdvdWxkIGhh
dmUNCj4gPiA+IGJlZW4gYXBwcm9wcmlhdGUgaWYgdGhlIHBhdGNoIGxvb2tlZCBPSyBidXQgaXQn
cyBub3QuIDotLw0KPiA+ID4NCj4gPiA+PiBXaGVuIGEgbG90IG9mIGZyYW1lcyB3ZXJlIHJlY2Vp
dmVkIGluIHRoZSBzaG9ydCB0ZXJtLCB0aGUgZHJpdmVyDQo+ID4gPj4gY2F1c2VkIGEgc3R1Y2sg
b2YgcmVjZWl2aW5nIHVudGlsIGEgbmV3IGZyYW1lIHdhcyByZWNlaXZlZC4gRm9yIGV4YW1wbGUs
DQo+ID4gPj4gdGhlIGZvbGxvd2luZyBjb21tYW5kIGZyb20gb3RoZXIgZGV2aWNlIGNvdWxkIGNh
dXNlIHRoaXMgaXNzdWUuDQo+ID4gPj4NCj4gPiA+PiAgICAgICQgc3VkbyBwaW5nIC1mIC1sIDEw
MDAgLWMgMTAwMCA8dGhpcyBkcml2ZXIncyBpcGFkZHJlc3M+DQo+ID4gPg0KPiA+ID4gICAgIC1s
IGlzIGVzc2VudGlhbCBoZXJlLCByaWdodD8NCj4gDQo+IFllcy4NCj4gDQo+ID4gPiAgICAgSGF2
ZSB5b3UgdHJpZWQgdGVzdGluZyBzaF9ldGggc3JpdmVyIGxpa2UgdGhhdCwgQlRXPw0KPiA+DQo+
ID4gICAgIEl0J3MgZHJpdmVyISA6LSkNCj4gDQo+IEkgaGF2ZSBub3QgdHJpZWQgdGVzdGluZyBz
aF9ldGggZHJpdmVyIHlldC4gSSdsbCB0ZXN0IGl0IGFmdGVyIEkgZ290IGFuIGFjdHVhbCBib2Fy
ZC4NCg0KSSBjb3VsZCByZXByb2R1Y2UgYSBzaW1pbGFyIGlzc3VlIG9uIFItQ2FyIEdlbjIgd2l0
aCBzaF9ldGggZHJpdmVyIGlmIHRoZSBSWCByaW5nIHNpemUgaXMgMTAyNCBsaWtlDQp0aGUgcmF2
YiBkcml2ZXIuIEFsc28sIEkgY29uZmlybWVkIGEgc2ltaWxhciBwYXRjaCBmb3Igc2hfZXRoIGRy
aXZlciBjb3VsZCBmaXggdGhlIGlzc3VlLg0KU28sIEknbGwgc2VuZCBhIHBhdGNoIGxhdGVyLg0K
DQpCZXN0IHJlZ2FyZHMsDQpZb3NoaWhpcm8gU2hpbW9kYQ0KDQo+ID4gPj4gVGhlIHByZXZpb3Vz
IGNvZGUgYWx3YXlzIGNsZWFyZWQgdGhlIGludGVycnVwdCBmbGFnIG9mIFJYIGJ1dCBjaGVja3MN
Cj4gPiA+PiB0aGUgaW50ZXJydXB0IGZsYWdzIGluIHJhdmJfcG9sbCgpLiBTbywgcmF2Yl9wb2xs
KCkgY291bGQgbm90IGNhbGwNCj4gPiA+PiByYXZiX3J4KCkgaW4gdGhlIG5leHQgdGltZSB1bnRp
bCBhIG5ldyBSWCBmcmFtZSB3YXMgcmVjZWl2ZWQgaWYNCj4gPiA+PiByYXZiX3J4KCkgcmV0dXJu
ZWQgdHJ1ZS4gVG8gZml4IHRoZSBpc3N1ZSwgYWx3YXlzIGNhbGxzIHJhdmJfcngoKQ0KPiA+ID4+
IHJlZ2FyZGxlc3MgdGhlIGludGVycnVwdCBmbGFncyBjb25kaXRpb24uDQo+ID4gPg0KPiA+ID4g
ICAgIFRoYXQgYmFjaWFsbHkgZGVmZWF0cyB0aGUgcHVycG9zZSBvZiBJSVVDLi4uDQo+ID4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF4gTkFQSSwNCj4gPg0KPiA+
ICAgICBJIHdhcyBzdXJlIEkgdHlwZWQgTkFQSSBoZXJlLCB5ZXQgaXQgZ290IGxvc3QgaW4gdGhl
IGVkaXRzLiA6LSkNCj4gDQo+IEkgY291bGQgbm90IHVuZGVyc3RhbmQgInRoYXQiIChjYWxsaW5n
IHJhdmJfcngoKSByZWdhcmRsZXNzIHRoZSBpbnRlcnJ1cHQNCj4gZmxhZ3MgY29uZGl0aW9uKSBk
ZWZlYXRzIHRoZSBwdXJwb3NlIG9mIE5BUEkuIEFjY29yZGluZyB0byBhbiBhcnRpY2xlIG9uDQo+
IHRoZSBMaW51eCBGb3VuZGF0aW9uIHdpa2kgWzFdLCBvbmUgb2YgdGhlIHB1cnBvc2Ugb2YgTkFQ
SSBpcyAiSW50ZXJydXB0IG1pdGlnYXRpb24iLg0KPiBJbiBwb2xsKCksIHRoZSBpbnRlcnJ1cHRz
IGFyZSBhbHJlYWR5IGRpc2FibGVkLCBhbmQgcmF2Yl9yeCgpIHdpbGwgY2hlY2sgdGhlDQo+IGRl
c2NyaXB0b3IncyBzdGF0dXMuIFNvLCB0aGlzIHBhdGNoIGtlZXBzIHRoZSAiSW50ZXJydXB0IG1p
dGlnYXRpb24iIElJVUMuDQo+IA0KPiBbMV0NCj4gaHR0cHM6Ly93aWtpLmxpbnV4Zm91bmRhdGlv
bi5vcmcvbmV0d29ya2luZy9uYXBpDQo+IA0KPiBCZXN0IHJlZ2FyZHMsDQo+IFlvc2hpaGlybyBT
aGltb2RhDQoNCg==
