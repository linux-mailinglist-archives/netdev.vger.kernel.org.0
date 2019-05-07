Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E18216C1A
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 22:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfEGUTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 16:19:03 -0400
Received: from mail-eopbgr150085.outbound.protection.outlook.com ([40.107.15.85]:22597
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726371AbfEGUTD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 16:19:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tt5GizVHAWE1wdD3qtqBy2WWNQl/XmF8gHqSZLHu5Oo=;
 b=a01RCY1oIUKFO4Cny/w29CHEpxeFN4FWE19oaW9isHRrmXCwdKuxRD1M3xldXIXpdV3MhOmGx2x5Uc/n/10haxhZpLk0klXEL+Da9SxVYJ/as9fPgfoBr4ie8ssj970T2gyBuwuWl+gmM9KRokE5u+JBJmDw4H1L7uyStWy09nI=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.105.143) by
 VI1PR0302MB2672.eurprd03.prod.outlook.com (10.171.104.145) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Tue, 7 May 2019 20:18:58 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::a096:fef7:568:7358]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::a096:fef7:568:7358%7]) with mapi id 15.20.1856.012; Tue, 7 May 2019
 20:18:58 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     David Miller <davem@davemloft.net>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>
Subject: Re: [net-next v3] net: sched: Introduce act_ctinfo action
Thread-Topic: [net-next v3] net: sched: Introduce act_ctinfo action
Thread-Index: AQHVA0VFBCng6RnNCEC0SahM/hixhqZgErwAgAAK7IA=
Date:   Tue, 7 May 2019 20:18:58 +0000
Message-ID: <72A692BD-993C-4E88-9E95-9B1D4BFD3320@darbyshire-bryant.me.uk>
References: <20190505101523.48425-1-ldir@darbyshire-bryant.me.uk>
 <20190505131736.50496-1-ldir@darbyshire-bryant.me.uk>
 <20190507.123952.2046042425594195721.davem@davemloft.net>
In-Reply-To: <20190507.123952.2046042425594195721.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1268:6500::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89557cab-4bae-4a68-79c6-08d6d3293cc2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR0302MB2672;
x-ms-traffictypediagnostic: VI1PR0302MB2672:
x-microsoft-antispam-prvs: <VI1PR0302MB2672C3EE5F7E82BC610EB3B8C9310@VI1PR0302MB2672.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0030839EEE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39830400003)(376002)(346002)(366004)(136003)(199004)(189003)(73956011)(71200400001)(81156014)(6436002)(66556008)(66476007)(66946007)(66446008)(6116002)(64756008)(305945005)(99286004)(76116006)(6486002)(91956017)(86362001)(53936002)(76176011)(4326008)(68736007)(25786009)(5660300002)(102836004)(6512007)(2906002)(82746002)(229853002)(6246003)(6506007)(53546011)(8936002)(6916009)(508600001)(71190400001)(11346002)(2616005)(8676002)(476003)(36756003)(46003)(81166006)(446003)(54906003)(256004)(14454004)(486006)(14444005)(74482002)(33656002)(186003)(316002)(83716004)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB2672;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kT4deSxOp5mhwQjH0yfOq53nMQwBGtq03jFLtWebsaXPbzlQ6Y7NeSznGcbwpOtji6LNNrcTpWjaq7pSFNjVRRwr0m/0lAuSZbqw6wIWjYKIT4BgD+Cz4s87WY2oGvv1CEgtp8e1lNDL7tJqw1Sn2aVXnAYX5tFNpJ+nBgrTgFX7mwyZ/vvBx2UyOzd5k80mpN7ZCtfksAJrEJDADmI3NB2etFeUeP4egUVkkC+G/3CwShNm/jfbpRhSZ4SeK2h+0oVRnmDylPPhsuZ0gL4ONmF/ryrdwMSURlsGcsP98npJDJkhBiBBLa5hE9ciunU0q2OwM1Y7wJBReuw2gSBmb3Qa808K3Yzq/0Guxq/dXccD76ViQe/HlyK3JicVXzXVhaViXmjpso+krDhwOSiGUWKkXbPXrb4vjBV8yyTWuIo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E80843239A2CA44ABAAE6F2718729F8D@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: 89557cab-4bae-4a68-79c6-08d6d3293cc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2019 20:18:58.5011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2672
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gNyBNYXkgMjAxOSwgYXQgMjA6MzksIERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldD4gd3JvdGU6DQo+IA0KPiBGcm9tOiBLZXZpbiAnbGRpcicgRGFyYnlzaGlyZS1Ccnlh
bnQgPGxkaXJAZGFyYnlzaGlyZS1icnlhbnQubWUudWs+DQo+IERhdGU6IFN1biwgNSBNYXkgMjAx
OSAxMzoyMDoxMyArMDAwMA0KPiANCj4+IGN0aW5mbyBpcyBhIG5ldyB0YyBmaWx0ZXIgYWN0aW9u
IG1vZHVsZS4gIEl0IGlzIGRlc2lnbmVkIHRvIHJlc3RvcmUNCj4+IGluZm9ybWF0aW9uIGNvbnRh
aW5lZCBpbiBjb25udHJhY2sgbWFya3MgdG8gb3RoZXIgcGxhY2VzLiAgQXQgcHJlc2VudCBpdA0K
Pj4gY2FuIHJlc3RvcmUgRFNDUCB2YWx1ZXMgdG8gSVB2NC82IGRpZmZzZXJ2IGZpZWxkcyBhbmQg
YWxzbyBjb3B5DQo+PiBjb25udHJhY2sgbWFya3MgdG8gc2tiIG1hcmtzLiAgQXMgc3VjaCB0aGUg
Mm5kIGZ1bmN0aW9uIGVmZmVjdGl2ZWx5DQo+PiByZXBsYWNlcyB0aGUgZXhpc3RpbmcgYWN0X2Nv
bm5tYXJrIG1vZHVsZQ0KDQpIaSBEYXZpZCwNCg0KPiANCj4gVGhpcyBuZWVkcyBtb3JlIHRpbWUg
Zm9yIHJldmlldyBhbmQgdGhlcmVmb3JlIEknbSBkZWZlcnJpbmcgdGhpcyB0byB0aGUNCj4gbmV4
dCBtZXJnZSB3aW5kb3cuDQoNClRoYW5rIHlvdS4NCg0KPiANCj4+ICtzdGF0aWMgaW5saW5lIGlu
dCB0Y2ZfY3RpbmZvX2R1bXAoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IHRjX2FjdGlvbiAq
YSwNCj4+ICsJCQkJICBpbnQgYmluZCwgaW50IHJlZikNCj4+ICt7DQo+PiArCXVuc2lnbmVkIGNo
YXIgKmIgPSBza2JfdGFpbF9wb2ludGVyKHNrYik7DQo+PiArCXN0cnVjdCB0Y2ZfY3RpbmZvICpj
aSA9IHRvX2N0aW5mbyhhKTsNCj4+ICsJc3RydWN0IHRjZl9jdGluZm9fcGFyYW1zICpjcDsNCj4+
ICsJc3RydWN0IHRjX2N0aW5mbyBvcHQgPSB7DQo+PiArCQkuaW5kZXggICA9IGNpLT50Y2ZfaW5k
ZXgsDQo+PiArCQkucmVmY250ICA9IHJlZmNvdW50X3JlYWQoJmNpLT50Y2ZfcmVmY250KSAtIHJl
ZiwNCj4+ICsJCS5iaW5kY250ID0gYXRvbWljX3JlYWQoJmNpLT50Y2ZfYmluZGNudCkgLSBiaW5k
LA0KPj4gKwl9Ow0KPj4gKwlzdHJ1Y3QgdGNmX3QgdDsNCj4+ICsJc3RydWN0IHRjX2N0aW5mb19k
c2NwIGRzY3BwYXJtOw0KPj4gKwlzdHJ1Y3QgdGNfY3RpbmZvX3N0YXRzX2RzY3AgZHNjcHN0YXRz
Ow0KPiANCg0KQWxsIGRvbmUsIEnigJl2ZSBwdXQgc3RydWN0IHRjZl9jdGluZm8gKmNpID0gdG9f
Y3RpbmZvKGEpOyBhdCB0aGUgdG9wIHRob3VnaA0KYXMgb3RoZXIgdmFyaWFibGVzIG5lZWQgdGhh
dCBpbml0aWFsaXNlZCwgaG9wZSB0aGF04oCZcyBvaywgZWxzZSBwbGVhc2UgZXhwbGFpbg0Kd2hh
dCBJIHNob3VsZCBoYXZlIGRvbmUuDQoNCj4gTGlrZXdpc2UuDQo+IA0KPiBBbHNvLCBuZXZlciB1
c2UgdGhlIGlubGluZSBrZXl3b3JkIGluIGZvby5jIGZpbGVzLCBhbHdheXMgbGV0IHRoZSBjb21w
aWxlcg0KPiBkZWNpZGUuDQoNClRoZSBwZXJpbHMgb2YgdXNpbmcgZXhpc3RpbmcgY29kZSwgc2hv
dWxkIGhhdmUgc3BvdHRlZCB0aGF0IHRob3VnaHQsIGRpZG7igJl0DQppbmxpbmUgYW55dGhpbmcg
ZWxzZSDigJhjb3MgaW4gdGhlb3J5IEkga25vdyBiZXR0ZXIuICBPaCB3ZWxsLg0KDQpTaGFtZSBj
aGVja3BhdGNoIGRpZG7igJl0IHdhcm4gbWUgYWJvdXQgY2hyaXN0bWFzIHRyZWVzIG9yIGlubGlu
ZSBvdGhlcndpc2UgaXQNCndvdWxkbuKAmXQgaGF2ZSBnb3QgdGhpcyBmYXIuDQoNClRoYW5rcyBm
b3IgeW91ciB0aW1lIGFuZCBwYXRpZW5jZS4NCg0KQ2hlZXJzLA0KDQpLZXZpbiBELUINCg0KZ3Bn
OiAwMTJDIEFDQjIgMjhDNiBDNTNFIDk3NzUgIDkxMjMgQjNBMiAzODlCIDlERTIgMzM0QQ0KDQo=
