Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551A420A6BB
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391035AbgFYUYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:24:17 -0400
Received: from mail-vi1eur05on2080.outbound.protection.outlook.com ([40.107.21.80]:10405
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389406AbgFYUYQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 16:24:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZ04AYB6Qxz0QSKMj0ILG/pKOucg29cTOfY9Z7+URRpgVuv1TJY+h9+fazLcG6qSN3v5mE9f4O6uu1f/2hGCQmtqhWzo8aEjPKcnmc8qN1LX40cM2ficn0KPeCD50sSTphjU9Y6Ky8T7dZQHCeGRnaBj7viGOCsnEEcq5wiW0E3Akvq5rbFxB7bHLIV0LBnLY0gazjSSqR8jqXCGeDJbgY9o0rEl6hSE9C7NjDMZ3bHv0OzsgMnInkcl9/2S/jkSOrk9VF/Q3j0f8M4OIllv1NPGz0ec86+jwZBeCGWcuLtz55l5XYGuSqq/KnmQgdlKsGxsqaZk/5QqPWBxJIdWBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tVdbaSWBCamFSbll48JOtpmVXVIWJddtOcoaP2QQpeo=;
 b=aOLZSWsk8yi2CPA/IqvoMkkOt4DPHbW/DcFGTemUWaqD/0Ae4yl/0ScE+hD4sd1pEKwbv0LlHykia9HyopyK5ps8DT8PITzKBSJgX3zSWQJvPMao6qhfN7d3G8xFgmu4zZ9kcj6rwgMAhGFXE2fltes4KZnp80ZM8t8JGIAqkjkB3OcVA5Iyz61msLMT/jDRjthSLRE892+3mV/bzrBrAsgJEY8VgA5NvgLSZSdvDfwWGb2NduzagXr/ej1WNlEyX+QbhA4XiUfADrW9XEJiMK2LOADZCms/9ITXKdXd7rYNQLD8GFhFp+t0bWVibt9ClepeqWOrInNh1fc7XSf6eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tVdbaSWBCamFSbll48JOtpmVXVIWJddtOcoaP2QQpeo=;
 b=lsHRB/czLyrKMLAuTKMuo4pxWwC/2YMpw7hcZCWEYO5A468c7nDq8jPJxlrmN0guXg1TjSb8BPAm7CWz3rktofLFHg5YBRKNCX+8VJ5keDbHf9QHKftM/hn5kuIse7c1l9bHj75R/1a7kMv1ZpzQEQ56Ek4c1cPyJtHLN/9knZA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2255.eurprd05.prod.outlook.com (2603:10a6:800:2c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Thu, 25 Jun
 2020 20:24:12 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Thu, 25 Jun 2020
 20:24:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Meir Lichtinger <meirl@mellanox.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     Aya Levin <ayal@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] ethtool: Add support for 100Gbps per lane
 link modes
Thread-Topic: [PATCH net-next 1/2] ethtool: Add support for 100Gbps per lane
 link modes
Thread-Index: AQHWH0jd6Z5x4OzPx06qTeECK0UAV6iU6KKAgD6+ywCAFncqgA==
Date:   Thu, 25 Jun 2020 20:24:12 +0000
Message-ID: <df18c2c0a9b160bfabe0e4ba7f251e789a9d7d7c.camel@mellanox.com>
References: <20200430234106.52732-1-saeedm@mellanox.com>
         <20200430234106.52732-2-saeedm@mellanox.com>
         <20200502150857.GC142589@lunn.ch>
         <e3b31d58-fc00-4387-56a0-d787e33e77ae@mellanox.com>
In-Reply-To: <e3b31d58-fc00-4387-56a0-d787e33e77ae@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: df7ed34b-8be4-430a-c940-08d81945b953
x-ms-traffictypediagnostic: VI1PR0501MB2255:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB22553F87B3B7904CA2BD2DA8BE920@VI1PR0501MB2255.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0445A82F82
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: satFg9g5f6MMjJwSno2BVQ4hew3RiSGYhLjrE4NKEIRPvWruyBjYiewR/r6AnBEAa3OcBiOnxcxuPhbcn7kdS/6V5WW81FH0iVeUR/dpNiOf/AVzUuYEY1pjkZhsMaKVO0qMu2tH3XaqOV4aXodAzsUo5PYgj6Aift005UuJGDA6XVMqRqGNQrhC6ZfwfhXHn9vPU3w2UfgZSINdl198kestjo2NLBdrO79swktfsW4klJgpNHayzjsuVcbVb9fBrTfkU75DHdnX3bhJhquSJPb2AGHDjgEusUWNGkEnGvG6oMpNaXXdQeSZeZVbg2hrjhtZs3/Cszk5Ybi62KUFCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(86362001)(6512007)(64756008)(8676002)(66946007)(2616005)(66476007)(66446008)(76116006)(66556008)(8936002)(5660300002)(91956017)(71200400001)(110136005)(54906003)(26005)(53546011)(6506007)(316002)(6486002)(186003)(83380400001)(2906002)(478600001)(4326008)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: TZRgP/2n0kJo2NrzOu5mgKEui4th2rpZ6clP3UCWBW+AZbka/KoLeLPy0zZQNYcv7DICGOezX9iXUu62wksXDiA7845M6Oc3Q4IqtRS+LLHCZbD05vrANxj00qHsRfX2sKSJO18LGp53scsYsEUWG9hiXVJ1Ss2OjRIrx1q0IrEO1hwsJNFvU19gcUpK4b+CZ2jGQ4Y4cZUM/KA5LUPdRmUtUbg/53THebmgYpHjW2NbAIIyyWKQU5L2CgI0DQwFldeHd49d5Jsx98ZHp+iH0jUm2S+l//ocajD5dKSH+M/QcbUHNxy1CQRCIR3/H2irdjUV4NdEyOZhCyrH/kOla0GAnBVwSFFzXUTyIj1cxtZW+iUYV4pK+rb5WeZFcxkSLDBFFnTUZUcgkMLVPi9wFoFhTzKQ8zakPrUz0aG76gpeHiJgC98m/aJvG/XWWQBwwMs94HWd6Z7+4xFKPcE0z33vx4UKX4rTQIYiKOi4X1o=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E256F36E617914FB5F6F0382C5CB824@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df7ed34b-8be4-430a-c940-08d81945b953
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2020 20:24:12.4849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vgLT0K4K7gTJYNORspK/dLMII2bep+Si/82NAbW49x9O7Gahiu4cKY9CnbE67OGzAJxT7ApPT/pPdBMZtY24/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2255
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA2LTExIGF0IDE2OjE5ICswMzAwLCBNZWlyIExpY2h0aW5nZXIgd3JvdGU6
DQo+IE9uIDAyLU1heS0yMCAxODowOCwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+ID4gT24gVGh1LCBB
cHIgMzAsIDIwMjAgYXQgMDQ6NDE6MDVQTSAtMDcwMCwgU2FlZWQgTWFoYW1lZWQgd3JvdGU6DQo+
ID4gPiBGcm9tOiBNZWlyIExpY2h0aW5nZXIgPG1laXJsQG1lbGxhbm94LmNvbT4NCj4gPiA+IA0K
PiA+ID4gRGVmaW5lIDEwMEcsIDIwMEcgYW5kIDQwMEcgbGluayBtb2RlcyB1c2luZyAxMDBHYnBz
IHBlciBsYW5lDQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IE1laXIgTGljaHRpbmdlciA8
bWVpcmxAbWVsbGFub3guY29tPg0KPiA+ID4gQ0M6IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5j
aD4NCj4gPiA+IFJldmlld2VkLWJ5OiBBeWEgTGV2aW4gPGF5YWxAbWVsbGFub3guY29tPg0KPiA+
ID4gU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+
ID4gPiAtLS0NCj4gPiA+ICAgZHJpdmVycy9uZXQvcGh5L3BoeS1jb3JlLmMgICB8IDE3ICsrKysr
KysrKysrKysrKystDQo+ID4gPiAgIGluY2x1ZGUvdWFwaS9saW51eC9ldGh0b29sLmggfCAxNSAr
KysrKysrKysrKysrKysNCj4gPiA+ICAgbmV0L2V0aHRvb2wvY29tbW9uLmMgICAgICAgICB8IDE1
ICsrKysrKysrKysrKysrKw0KPiA+ID4gICBuZXQvZXRodG9vbC9saW5rbW9kZXMuYyAgICAgIHwg
MTYgKysrKysrKysrKysrKysrKw0KPiA+ID4gICA0IGZpbGVzIGNoYW5nZWQsIDYyIGluc2VydGlv
bnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiA+IA0KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L3BoeS9waHktY29yZS5jIGIvZHJpdmVycy9uZXQvcGh5L3BoeS0NCj4gPiA+IGNvcmUuYw0K
PiA+ID4gaW5kZXggNjZiOGM2MWNhNzRjLi5hNzFmYzhiMTg5NzMgMTAwNjQ0DQo+ID4gPiAtLS0g
YS9kcml2ZXJzL25ldC9waHkvcGh5LWNvcmUuYw0KPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvcGh5
L3BoeS1jb3JlLmMNCj4gPiA+IEBAIC04LDcgKzgsNyBAQA0KPiA+ID4gICANCj4gPiA+ICAgY29u
c3QgY2hhciAqcGh5X3NwZWVkX3RvX3N0cihpbnQgc3BlZWQpDQo+ID4gPiAgIHsNCj4gPiA+IC0J
QlVJTERfQlVHX09OX01TRyhfX0VUSFRPT0xfTElOS19NT0RFX01BU0tfTkJJVFMgIT0gNzUsDQo+
ID4gPiArCUJVSUxEX0JVR19PTl9NU0coX19FVEhUT09MX0xJTktfTU9ERV9NQVNLX05CSVRTICE9
IDkwLA0KPiA+ID4gICAJCSJFbnVtIGV0aHRvb2xfbGlua19tb2RlX2JpdF9pbmRpY2VzIGFuZCBw
aHlsaWINCj4gPiA+IGFyZSBvdXQgb2Ygc3luYy4gIg0KPiA+ID4gICAJCSJJZiBhIHNwZWVkIG9y
IG1vZGUgaGFzIGJlZW4gYWRkZWQgcGxlYXNlDQo+ID4gPiB1cGRhdGUgcGh5X3NwZWVkX3RvX3N0
ciAiDQo+ID4gPiAgIAkJImFuZCB0aGUgUEhZIHNldHRpbmdzIGFycmF5LlxuIik7DQo+ID4gPiBA
QCAtNzgsMTIgKzc4LDIyIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcGh5X3NldHRpbmcgc2V0dGlu
Z3NbXSA9DQo+ID4gPiB7DQo+ID4gPiAgIAlQSFlfU0VUVElORyggNDAwMDAwLCBGVUxMLCA0MDAw
MDBiYXNlTFI4X0VSOF9GUjhfRnVsbAkpDQo+ID4gPiAsDQo+ID4gPiAgIAlQSFlfU0VUVElORygg
NDAwMDAwLCBGVUxMLCA0MDAwMDBiYXNlRFI4X0Z1bGwJCSkNCj4gPiA+ICwNCj4gPiA+ICAgCVBI
WV9TRVRUSU5HKCA0MDAwMDAsIEZVTEwsIDQwMDAwMGJhc2VTUjhfRnVsbAkJKQ0KPiA+ID4gLA0K
PiA+ID4gKwlQSFlfU0VUVElORyggNDAwMDAwLCBGVUxMLCA0MDAwMDBiYXNlQ1I0X0Z1bGwJCSks
DQo+ID4gPiArCVBIWV9TRVRUSU5HKCA0MDAwMDAsIEZVTEwsIDQwMDAwMGJhc2VLUjRfRnVsbAkJ
KSwNCj4gPiA+ICsJUEhZX1NFVFRJTkcoIDQwMDAwMCwgRlVMTCwgNDAwMDAwYmFzZUxSNF9FUjRf
RlI0X0Z1bGwJKSwNCj4gPiBIaSBNaWVyLCBTYWVlZC4NCj4gPiANCj4gPiBDb3VsZCB5b3UgZXhw
bGFpbiB0aGlzIGxhc3Qgb25lPyBTZWVtcyB1bmxpa2VseSB0aGlzIGlzIGEgMTIgcGFpcg0KPiA+
IGxpbmsNCj4gPiBtb2RlLiBTbyBpIGFzc3VtZSBpdCBpcyBmb3VyIHBhaXIgd2hpY2ggY2FuIGRv
IExSNCwgRVI0IG9yIEZSND8NCj4gQ29ycmVjdA0KPiA+IENhbg0KPiA+IHlvdSBjb25uZWN0IGEg
NDAwMDAwYmFzZUxSNCB0byBhIDQwMDAwMGJhc2VFUjQgd2l0aCBhIDEwS20gY2FibGUNCj4gPiBh
bmQNCj4gPiBpdCB3b3JrPw0KPiANCj4gTFIsIEVSICYgRlIgYXJlIHVzaW5nIHNhbWUgdGVjaG5v
bG9neSDigJMgc2luZ2xlIG1vZGUgZmliZXIsIHcvV0RNIOKAkw0KPiANCj4gYW5kIGJ5IGRlc2ln
biBhcmUgZnVsbHkgaW50ZXJvcGVyYWJsZSBidXQgaGF2ZW7igJl0IHRlc3RlZCBhbGwNCj4gY29t
YmluYXRpb25zLg0KPiANCj4gPiBIb3cgZG8geW91IGtub3cgeW91IGhhdmUgY29ubmVjdGVkIGEg
NDAwMDAwYmFzZUxSNCB0byBhDQo+ID4gNDAwMDAwYmFzZUVSNCB3aXRoIGEgNDBLbSBhbmQgaXQg
aXMgbm90IGV4cGVjdGVkIHRvIHdvcmssIHdoZW4NCj4gPiBsb29raW5nDQo+ID4gYXQgZXRodG9v
bD8gSSBhc3N1bWUgdGhlIEVFUFJPTSBjb250ZW50cyB0ZWxsIHlvdSBpZiB0aGUgbW9kdWxlIGlz
DQo+ID4gTFI0LCBFUjQsIG9yIEZSND8NCj4gPiANCj4gPiAgICAgICBBbmRyZXcNCj4gQ29ycmVj
dC4NCj4gDQo+IEluIGFkZGl0aW9uLCB0aGlzIGlzIHRoZSB0ZXJtaW5vbG9neSBleHBvc2VkIGlu
IDUwIEdicHMgYW5kIHdlDQo+IGZvbGxvd2VkIGl0Lg0KPiANCg0KSGkgQW5kcmV3LA0KDQp3ZSBh
cmUgZ29pbmcgdG8gdXBkYXRlIHRoZSBjb21taXQgbWVzc2FnZSB3aXRoOg0KDQogICAgTFIsIEVS
IGFuZCBGUiBhcmUgZGVmaW5lZCBhcyBhIHNpbmdsZSBsaW5rIG1vZGUgYmVjYXVzZSB0aGV5IGFy
ZQ0KICAgIHVzaW5nIHNhbWUgdGVjaG5vbG9neSBhbmQgYnkgZGVzaWduIGFyZSBmdWxseSBpbnRl
cm9wZXJhYmxlLg0KICAgIEVFUFJPTSBjb250ZW50IGluZGljYXRlcyBpZiB0aGUgbW9kdWxlIGlz
IExSLCBFUiwgb3IgRlIsIGFuZCB0aGUNCiAgICB1c2VyIHNwYWNlIGV0aHRvb2wgZGVjb2RlciBp
cyBwbGFubmVkIHRvIHN1cHBvcnQgZGVjb2RpbmcgdGhlc2UgICAgDQogICAgbW9kZXMgaW4gdGhl
IEVFUFJPTS4NCg0KUGxlYXNlIGxldCBtZSBrbm93IGl0IHRoaXMgYW5zd2VyIHlvdXIgcXVlc3Rp
b25zLCBzbyB3ZSBjYW4gcmUtc3Bpbg0KdGhpcyBwYXRjaC4NCg0KVGhhbmtzLA0KU2FlZWQuDQoN
Cg==
