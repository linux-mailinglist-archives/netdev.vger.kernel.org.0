Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD1E8119136
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfLJT4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:56:54 -0500
Received: from mail-eopbgr30067.outbound.protection.outlook.com ([40.107.3.67]:18403
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725999AbfLJT4y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 14:56:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZqsZ1RpcBimA/q9nBXImSWP7wauNYTb4aKVEfqWHPeZNAee9onUuDbinnlNtmP42zhtT+STHgCvwAzL2jTaPDI5v5HhfbXNVwZv8oJbMK0B7mYb6we85rINtNvQhytma68fs0cqCDdUZc8y/TMhZnzF7Sbk1rsqAyyQ+//mzXIoC5xvRHkzvKuwWJvs82iEji8NlSpT9OMU/idSf2nYHSkBTJ0R/XfhN6msNN9JsaHXO7l3e/nQtE9R5CZTFeIgXPgibABdzTFJMrurVBIOe02DrhrZTcS2Wny+SwdqUmny/fPKHSrCxkftoib2PLJna2R2YRXPJg3BGO+iTXhKdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57dx31H+qUeINIgeLCrWJBy7YMzvtnQy7ZYKu2HncyU=;
 b=lrzVTYKSqZN33QarOqTwMXvA3fGfeHb/2bwg0JoCq3asOrT+ItN+Hl0kjp+lZYucMRyeCz1zUGuJV1TBH4f0lwte8HzVhssI8nbJrsrXIul1IdnBQks5zi1qvxqJpDE+X+regoDpEwEafB0lcqWxhJi9s6ducmLauyVxOPfv4B1jMXJhXgiLNPUMwTZkrGHOazrhI4MIAfZQNUgCyjNcHgxjaMVVYJzYKE4ljn2NkBA0osfJTeNZ9iYqQPoVh7ivOq54NQSTw6bjgbZujpxG0Po1qmKUnuhMcfB2q5BkmSBNrV3yzXhD1WlqiTpNOsBxbhLfERWukK2ess3cTn/ufw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57dx31H+qUeINIgeLCrWJBy7YMzvtnQy7ZYKu2HncyU=;
 b=jKAIwZSDmUcfMGWR9SgULc7G4G4ULPAN1Whiu6S0OiV5NSs3IHQ/YGMV/+4JcvTrqaf5XC4krwh8l/RvcU0ZZeTlusyfOGCzr6peDqjcM9xJkLtcbg42j+TRzXrKrsG2cf27IqnmtKF3V3r5WCG7KxAfr6j+MJQCyBmsBCpiMdU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5263.eurprd05.prod.outlook.com (20.178.12.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Tue, 10 Dec 2019 19:56:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 19:56:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        Li Rongqing <lirongqing@baidu.com>,
        "brouer@redhat.com" <brouer@redhat.com>
CC:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: =?utf-8?B?UmU6IOetlOWkjTogW1BBVENIXVt2Ml0gcGFnZV9wb29sOiBoYW5kbGUgcGFn?=
 =?utf-8?B?ZSByZWN5Y2xlIGZvciBOVU1BX05PX05PREUgY29uZGl0aW9u?=
Thread-Topic: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3YyXSBwYWdlX3Bvb2w6IGhhbmRsZSBwYWdlIHJl?=
 =?utf-8?B?Y3ljbGUgZm9yIE5VTUFfTk9fTk9ERSBjb25kaXRpb24=?=
Thread-Index: AQHVrBgioGDhH/MP9UuNcNvu7zNf3aeuC1gAgAOw0QCAAL3ugIAAIMwAgACISgCAAKyLgA==
Date:   Tue, 10 Dec 2019 19:56:50 +0000
Message-ID: <ad3736af529f60772176d23f3aad6edf5d0096de.camel@mellanox.com>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
         <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
         <20191209131416.238d4ae4@carbon>
         <816bc34a7d25881f35e0c3e21dc2283ffeffb093.camel@mellanox.com>
         <e9855bd9-dddd-e12c-c889-b872702f80d1@huawei.com>
         <bb3c3846334744d7bbe83b1a29eaa762@baidu.com>
In-Reply-To: <bb3c3846334744d7bbe83b1a29eaa762@baidu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5d5b328e-08ed-40a6-d011-08d77dab18d9
x-ms-traffictypediagnostic: VI1PR05MB5263:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-microsoft-antispam-prvs: <VI1PR05MB526339E8DDEA2A51289FFC9BBE5B0@VI1PR05MB5263.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(199004)(189003)(5660300002)(81156014)(91956017)(76116006)(186003)(86362001)(4326008)(66946007)(66446008)(66556008)(66476007)(64756008)(71200400001)(6486002)(2906002)(2616005)(36756003)(6506007)(110136005)(8936002)(54906003)(4001150100001)(81166006)(316002)(26005)(478600001)(224303003)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5263;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EgihlswjTtyitrn36HRCYh7j+6wsczScx0/0qcgcXXGhXk7Rh2dEWBUqiARsnCaXdGICkvQtrLOvZjhbDr/0en9C1kXmOvmj2yb5zkxqDsWUiVp/9hcZLQEKSHPRVUnBT5qkHmEWhBYjlzcCnEk/3CaxspfpVPj5JcAMUa2hP2iqFBwRsjYpySc9Bss9INSnuJ1ORB0ycJ6zdjxR8Z1p+YPoi9RKKekz10e4VPBp76FcCCHbzVuWphDXoHZq21OdREATs+XvUjSvn7HLmgXWzdlruhTs94eJRxo5ztDogfMtx/g+FSTuSKBjzl+YjVqK+J2c4kU/G2cPqvAsV/IYOLyLhqItnNQfaUcamKEC2sNgXv3v2UQw8d+Aj1Idpd6okHgYjG2VHc5Ox502YkdW4io4aw7b2GDNM1WED4+WUzL3WBZQTL1r3LSEytEd/8ze
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <29D657153DC5DA41803114C9E4C6B4C4@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d5b328e-08ed-40a6-d011-08d77dab18d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 19:56:50.4948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UlgJr0G0Xy8m5roJg7xPKRbv/+poX/AFhyTOPENFGujp7w8ZqidO9DSn0dN9rTAq+5cprUvOuZJCVwivoKdmcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5263
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTEyLTEwIGF0IDA5OjM5ICswMDAwLCBMaSxSb25ncWluZyB3cm90ZToNCj4g
PiBzdGF0aWMgaW50IG12bmV0YV9jcmVhdGVfcGFnZV9wb29sKHN0cnVjdCBtdm5ldGFfcG9ydCAq
cHAsDQo+ID4gCQkJCSAgIHN0cnVjdCBtdm5ldGFfcnhfcXVldWUgKnJ4cSwgaW50DQo+ID4gc2l6
ZSkgew0KPiA+IAlzdHJ1Y3QgYnBmX3Byb2cgKnhkcF9wcm9nID0gUkVBRF9PTkNFKHBwLT54ZHBf
cHJvZyk7DQo+ID4gCXN0cnVjdCBwYWdlX3Bvb2xfcGFyYW1zIHBwX3BhcmFtcyA9IHsNCj4gPiAJ
CS5vcmRlciA9IDAsDQo+ID4gCQkuZmxhZ3MgPSBQUF9GTEFHX0RNQV9NQVAgfCBQUF9GTEFHX0RN
QV9TWU5DX0RFViwNCj4gPiAJCS5wb29sX3NpemUgPSBzaXplLA0KPiA+IAkJLm5pZCA9IGNwdV90
b19ub2RlKDApLA0KPiANCj4gVGhpcyBraW5kIG9mIGRldmljZSBzaG91bGQgb25seSBiZSBpbnN0
YWxsZWQgdG8gdmVuZG9yJ3MgcGxhdGZvcm0NCj4gd2hpY2ggZGlkIG5vdCBzdXBwb3J0IG51bWEN
Cj4gDQo+IEJ1dCBhcyB5b3Ugc2F5ICwgU2FlZWQgYWR2aWNlIG1heWJlIGNhdXNlIHRoYXQgcmVj
eWNsZSBhbHdheXMgZmFpbCwNCj4gaWYgbmlkIGlzIGNvbmZpZ3VyZWQgbGlrZSB1cHBlciwgYW5k
IGRpZmZlcmVudCBmcm9tIHJ1bm5pbmcgTkFQSSBub2RlDQo+IGlkDQo+IA0KDQpJIGRvbid0IHNl
ZSBhbiBpc3N1ZSBoZXJlLCBCeSBkZWZpbml0aW9uIHJlY3ljbGluZyBtdXN0IGZhaWwgaW4gc3Vj
aA0KY2FzZSA6KS4NCg0KPiBBbmQgbWF5YmUgd2UgY2FuIGNhdGNoIHRoaXMgY2FzZSBieSB0aGUg
YmVsb3cNCj4gDQo+IGRpZmYgLS1naXQgYS9uZXQvY29yZS9wYWdlX3Bvb2wuYyBiL25ldC9jb3Jl
L3BhZ2VfcG9vbC5jDQo+IGluZGV4IDNjOGI1MWNjZDFjMS4uOTczMjM1YzA5NDg3IDEwMDY0NA0K
PiAtLS0gYS9uZXQvY29yZS9wYWdlX3Bvb2wuYw0KPiArKysgYi9uZXQvY29yZS9wYWdlX3Bvb2wu
Yw0KPiBAQCAtMzI4LDYgKzMyOCwxMSBAQCBzdGF0aWMgYm9vbCBwb29sX3BhZ2VfcmV1c2FibGUo
c3RydWN0IHBhZ2VfcG9vbA0KPiAqcG9vbCwgc3RydWN0IHBhZ2UgKnBhZ2UpDQo+ICB2b2lkIF9f
cGFnZV9wb29sX3B1dF9wYWdlKHN0cnVjdCBwYWdlX3Bvb2wgKnBvb2wsIHN0cnVjdCBwYWdlICpw
YWdlLA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGludCBkbWFfc3luY19z
aXplLCBib29sDQo+IGFsbG93X2RpcmVjdCkNCj4gIHsNCj4gKyAgICAgICBhbGxvd19kaXJlY3Qg
PSBhbGxvd19kaXJlY3QgJiYgaW5fc2VydmluZ19zb2Z0aXJxKCk7DQo+ICsNCj4gKyAgICAgICBp
ZiAoYWxsb3dfZGlyZWN0KQ0KPiArICAgICAgICAgICAgICAgV0FSTl9PTl9PTkNFKChwb29sLT5w
Lm5pZCAhPSBOVU1BX05PX05PREUpICYmDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAocG9vbC0+cC5uaWQgIT0gbnVtYV9tZW1faWQoKSkpOw0KPiAgICAgICAgIC8qIFRo
aXMgYWxsb2NhdG9yIGlzIG9wdGltaXplZCBmb3IgdGhlIFhEUCBtb2RlIHRoYXQgdXNlcw0KPiAg
ICAgICAgICAqIG9uZS1mcmFtZS1wZXItcGFnZSwgYnV0IGhhdmUgZmFsbGJhY2tzIHRoYXQgYWN0
IGxpa2UgdGhlDQo+ICAgICAgICAgICogcmVndWxhciBwYWdlIGFsbG9jYXRvciBBUElzLg0KPiBA
QCAtMzQyLDcgKzM0Nyw3IEBAIHZvaWQgX19wYWdlX3Bvb2xfcHV0X3BhZ2Uoc3RydWN0IHBhZ2Vf
cG9vbCAqcG9vbCwNCj4gc3RydWN0IHBhZ2UgKnBhZ2UsDQo+ICAgICAgICAgICAgICAgICAgICAg
ICAgIHBhZ2VfcG9vbF9kbWFfc3luY19mb3JfZGV2aWNlKHBvb2wsIHBhZ2UsDQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRtYV9zeW5jX3Np
emUpOw0KPiAgDQo+IC0gICAgICAgICAgICAgICBpZiAoYWxsb3dfZGlyZWN0ICYmIGluX3NlcnZp
bmdfc29mdGlycSgpKQ0KPiArICAgICAgICAgICAgICAgaWYgKGFsbG93X2RpcmVjdCkNCj4gICAg
ICAgICAgICAgICAgICAgICAgICAgaWYgKF9fcGFnZV9wb29sX3JlY3ljbGVfZGlyZWN0KHBhZ2Us
IHBvb2wpKQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybjsNCj4gDQo+
IA0KDQp0b28gbXVjaCBkYXRhIHBhdGggY29tcGxpY2F0aW9ucyBmb3IgbXkgdGFzdGUsIHdlIG5l
ZWQgdG8gZXN0YWJsaXNoDQpzb21lIGFzc3VtcHRpb25zLg0KMSkgdXNlciBrbm93IHdoYXQgaGUg
aXMgZG9pbmcsIE1TSVgvTkFQSSBhZmZpbml0eSBzaG91bGQgYmUgYXMgaGludGVkDQpieSBkcml2
ZXIsIHBvb2wgbmlkIHNob3VsZCBjb3JyZXNwb25kIHRvIHRoZSBhZmZpbml0eSBoaW50Lg0KMikg
aWYgbmVjZXNzYXJ5IG1pdGlnYXRlIE5BUEkgbnVtYSBtaWdyYXRpb24gdmlhIHBhZ2VfcG9vbF91
cGRhdGVfbmlkKCkNCg0K
