Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 443191684D6
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgBURXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:23:38 -0500
Received: from mail-eopbgr70058.outbound.protection.outlook.com ([40.107.7.58]:42227
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726408AbgBURXh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 12:23:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sb769dG77zyx18e5F15aDeElnDc8ytf3zOd8kSJJlUpmQZjte2eecV0MfNyrTkgt1jUKcqLiCZ5RXsuY7D2u7k9coJ1q9iF4u07Fr33a0NNvbKyFJj3yvPwV0cNxzxeOMAW1I7ynnEgZW1ofNiFyvQnyQno/g9gXQLEgUPHnuJFkJlRFU/FhLprlcrT+ClgJX2FmWsifWUC2FxnmIWefmDzqZtv8ixGs2CDDrxm0NUvv6LqxCKVYpVYy4LKARhCfAJZzwFnGUlgJDzoO1AcqFBUNpdZU7hfiZ/hqs9hkObO6TNXAsiA2C46i1oHZQLeRuib8ue1TjbB1MSDNcf9/yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49csXU6o7GNwYAIFj0qFGbfMOaQ02RIj+OkL+6G1Vzw=;
 b=AyZXB+1F+6VXdTW6rEbxID5Bw8hV4pfoeWjMb+VI5EgD9JbmM4zFTrBcRxCCtd2Np7WukmHHSjdb1gaIHO+OJ1nx8JcxkJbr4fxWNmSNmE4+nGXdyCzXgjrhAkto+lZuBkhPFWK/k2dQyo8MAmiePMcVzvFw1KNsqBikP38H+R3z30KqF38//eLC5GIw9lwwvm4lfmQiX89w08ep/4yuO39CJKuEJt86JLyfR+gsU1sUEloO9vduQpg/1vFAIL/OY2zNonffOUpKegYIcyCpM/6RQ6jd7sAel+YkwO4oMWqDBtQ90vvcD7tvsyQ56DQnc8d+fu5yzFy+Wopylsm8nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49csXU6o7GNwYAIFj0qFGbfMOaQ02RIj+OkL+6G1Vzw=;
 b=gqYU0WX8SVrCxmnuthQ/K9O2xIdpsLu2Q+6DmBd3Z9N2hpSe+H5+twyYpKtkLwWpYAMYYDxckj92OKJ5SpLc9Uf/OB5R21a+1Hl5xqBtX4KRIngbw/dgoaLpFNUlH3MgZh/fTIWNlDgpqpTZ0xl0DCxd/iKRzRjWft7S1PYP2Qg=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4115.eurprd05.prod.outlook.com (52.134.90.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Fri, 21 Feb 2020 17:23:32 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2750.016; Fri, 21 Feb 2020
 17:23:32 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>
Subject: Re: [RFC PATCH v4 10/25] RDMA/irdma: Add driver framework definitions
Thread-Topic: [RFC PATCH v4 10/25] RDMA/irdma: Add driver framework
 definitions
Thread-Index: AQHV4di3RHBiR8SSKUiBqR+gfJba6qgbREEAgAYwCYCAA0AoAIABOPaAgAAGLIA=
Date:   Fri, 21 Feb 2020 17:23:31 +0000
Message-ID: <b8263bea-fd0f-345e-b497-d5531dc63554@mellanox.com>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-11-jeffrey.t.kirsher@intel.com>
 <6f01d517-3196-1183-112e-8151b821bd72@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7C60C94AF@fmsmsx124.amr.corp.intel.com>
 <AM0PR05MB4866395BD477FAD269BCAE07D1130@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <9DD61F30A802C4429A01CA4200E302A7C60CE4C4@fmsmsx124.amr.corp.intel.com>
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7C60CE4C4@fmsmsx124.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 819e9ef8-19f1-4e8b-4f53-08d7b6f2c63b
x-ms-traffictypediagnostic: AM0PR05MB4115:
x-microsoft-antispam-prvs: <AM0PR05MB411588E2BA1DB705749B6FF6D1120@AM0PR05MB4115.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(39850400004)(346002)(366004)(189003)(199004)(6506007)(2906002)(186003)(26005)(66946007)(7416002)(478600001)(71200400001)(2616005)(8936002)(53546011)(6486002)(54906003)(110136005)(86362001)(5660300002)(8676002)(31686004)(316002)(4326008)(66446008)(91956017)(81156014)(31696002)(66556008)(66476007)(81166006)(36756003)(76116006)(64756008)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4115;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +gm7Pi/XjcB+8LjHnokRfIbVTjUjB0b4Cg5w0+5VT9rUAc2l+O/etWlcMONxIaSJCOBw/nVM8P+O7UG5eMw4ERAWu86ZRdPleAxDNsKEPvy6H3378rHinaoow6HCLLC9aBaJzDjF8nX6z1yCbAqajExEw+/kAaGUHgcxUq6qXiAuHUq2GUxVXrPzDlmerUnHmMjJpk9WZ9cu1Z9FElOjsx0MJ0yGdvfZzkEiN6hTraQGKiFzAcwoBl1yuW9L/rQU3fID5pTilG1XgZpecA/6LScHAjOZN5AnFuWPlKI33MW30lnB6klFQXwAo9YWmqQkxv1NI8/8L3duh+P+XK3skftpERW/4AJTNjhCXhey5KuxEyWblYnKqUOS0jND50lMnCr1o5lnQecC1biM8CYgpysvXt1aO8aHtOVBeH9WyN2YpGscArROKF+cEXFzUOX5
x-ms-exchange-antispam-messagedata: y52//yZbI0UIyOT7TGmKZ1iIzViTDCAXGv0J8maFgtiVmoqT02NXPrSgimJcygWAuedj9GFD8Swem067f+5TUBYN9KKtOibFtaQQw8HnAFlE9dvLfpCkh7VWql15Ie+85LBTiOImN5+4Q2RHK+nYbg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <380F8A42F351E64882FEEB6ECAD6A56D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 819e9ef8-19f1-4e8b-4f53-08d7b6f2c63b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 17:23:31.9151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TxEe+BHSpFSSGMdd3tUksqJqHaRocdyFGhH/2ZiIwQtye6RiXjJ523vjFMw+kDMWAS6KrcGz1gNUOuNRsCa14A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4115
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMi8yMS8yMDIwIDExOjAxIEFNLCBTYWxlZW0sIFNoaXJheiB3cm90ZToNCj4+IFN1YmplY3Q6
IFJFOiBbUkZDIFBBVENIIHY0IDEwLzI1XSBSRE1BL2lyZG1hOiBBZGQgZHJpdmVyIGZyYW1ld29y
aw0KPj4gZGVmaW5pdGlvbnMNCj4+DQo+IA0KPiBbLi4uLl0NCj4gDQo+Pj4+PiArc3RhdGljIGlu
dCBpcmRtYV9kZXZsaW5rX3JlbG9hZF91cChzdHJ1Y3QgZGV2bGluayAqZGV2bGluaywNCj4+Pj4+
ICsJCQkJICAgc3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrKSB7DQo+Pj4+PiArCXN0cnVj
dCBpcmRtYV9kbF9wcml2ICpwcml2ID0gZGV2bGlua19wcml2KGRldmxpbmspOw0KPj4+Pj4gKwl1
bmlvbiBkZXZsaW5rX3BhcmFtX3ZhbHVlIHNhdmVkX3ZhbHVlOw0KPj4+Pj4gKwljb25zdCBzdHJ1
Y3QgdmlydGJ1c19kZXZfaWQgKmlkID0gcHJpdi0+dmRldi0+bWF0Y2hlZF9lbGVtZW50Ow0KPj4+
Pg0KPj4+PiBMaWtlIGlyZG1hX3Byb2JlKCksIHN0cnVjdCBpaWRjX3ZpcnRidXNfb2JqZWN0ICp2
byBpcyBhY2Nlc2libGUgZm9yDQo+Pj4+IHRoZSBnaXZlbg0KPj4+IHByaXYuDQo+Pj4+IFBsZWFz
ZSB1c2Ugc3RydWN0IGlpZGNfdmlydGJ1c19vYmplY3QgZm9yIGFueSBzaGFyaW5nIGJldHdlZW4g
dHdvIGRyaXZlcnMuDQo+Pj4+IG1hdGNoZWRfZWxlbWVudCBtb2RpZmljYXRpb24gaW5zaWRlIHRo
ZSB2aXJ0YnVzIG1hdGNoKCkgZnVuY3Rpb24gYW5kDQo+Pj4+IGFjY2Vzc2luZyBwb2ludGVyIHRv
IHNvbWUgZHJpdmVyIGRhdGEgYmV0d2VlbiB0d28gZHJpdmVyIHRocm91Z2gNCj4+Pj4gdGhpcyBt
YXRjaGVkX2VsZW1lbnQgaXMgbm90IGFwcHJvcHJpYXRlLg0KPj4+DQo+Pj4gV2UgY2FuIHBvc3Np
Ymx5IGF2b2lkIG1hdGNoZWRfZWxlbWVudCBhbmQgZHJpdmVyIGRhdGEgbG9vayB1cCBoZXJlLg0K
Pj4+IEJ1dCBmdW5kYW1lbnRhbGx5LCBhdCBwcm9iZSB0aW1lIChzZWUgaXJkbWFfZ2VuX3Byb2Jl
KSB0aGUgaXJkbWENCj4+PiBkcml2ZXIgbmVlZHMgdG8ga25vdyB3aGljaCBnZW5lcmF0aW9uIHR5
cGUgb2YgdmRldiB3ZSBib3VuZCB0by4gaS5lLiBpNDBlIG9yIGljZQ0KPj4gPw0KPj4+IHNpbmNl
IHdlIHN1cHBvcnQgYm90aC4NCj4+PiBBbmQgYmFzZWQgb24gaXQsIGV4dHJhY3QgdGhlIGRyaXZl
ciBzcGVjaWZpYyB2aXJ0YnVzIGRldmljZSBvYmplY3QsDQo+Pj4gaS5lIGk0MGVfdmlydGJ1c19k
ZXZpY2UgdnMgaWlkY192aXJ0YnVzX29iamVjdCBhbmQgaW5pdCB0aGF0IGRldmljZS4NCj4+Pg0K
Pj4+IEFjY2Vzc2luZyBkcml2ZXJfZGF0YSBvZmYgdGhlIHZkZXYgbWF0Y2hlZCBlbnRyeSBpbg0K
Pj4+IGlyZG1hX3ZpcnRidXNfaWRfdGFibGUgaXMgaG93IHdlIGtub3cgdGhpcyBnZW5lcmF0aW9u
IGluZm8gYW5kIG1ha2UgdGhlDQo+PiBkZWNpc2lvbi4NCj4+Pg0KPj4gSWYgdGhlcmUgaXMgc2lu
Z2xlIGlyZG1hIGRyaXZlciBmb3IgdHdvIGRpZmZlcmVudCB2aXJ0YnVzIGRldmljZSB0eXBlcywg
aXQgaXMgYmV0dGVyIHRvDQo+PiBoYXZlIHR3byBpbnN0YW5jZXMgb2YgdmlydGJ1c19yZWdpc3Rl
cl9kcml2ZXIoKSB3aXRoIGRpZmZlcmVudCBtYXRjaGluZyBzdHJpbmcvaWQuDQo+PiBTbyBiYXNl
ZCBvbiB0aGUgcHJvYmUoKSwgaXQgd2lsbCBiZSBjbGVhciB3aXRoIHZpcnRidXMgZGV2aWNlIG9m
IGludGVyZXN0IGdvdCBhZGRlZC4NCj4+IFRoaXMgd2F5LCBjb2RlIHdpbGwgaGF2ZSBjbGVhciBz
ZXBhcmF0aW9uIGJldHdlZW4gdHdvIGRldmljZSB0eXBlcy4NCj4gDQo+IFRoYW5rcyBmb3IgdGhl
IGZlZWRiYWNrIQ0KPiBJcyBpdCBjb21tb24gcGxhY2UgdG8gaGF2ZSBtdWx0aXBsZSBkcml2ZXJf
cmVnaXN0ZXIgaW5zdGFuY2VzIG9mIHNhbWUgYnVzIHR5cGUNCj4gaW4gYSBkcml2ZXIgdG8gc3Vw
cG9ydCBkaWZmZXJlbnQgZGV2aWNlcz8gU2VlbXMgb2RkLg0KPiBUeXBpY2FsbHkgYSBzaW5nbGUg
ZHJpdmVyIHRoYXQgc3VwcG9ydHMgbXVsdGlwbGUgZGV2aWNlIHR5cGVzIGZvciBhIHNwZWNpZmlj
IGJ1cy10eXBlDQo+IHdvdWxkIGRvIGEgc2luZ2xlIGJ1cy1zcGVjaWZpYyBkcml2ZXJfcmVnaXN0
ZXIgYW5kIHBhc3MgaW4gYW4gYXJyYXkgb2YgYnVzLXNwZWNpZmljDQo+IGRldmljZSBJRHMgYW5k
IGxldCB0aGUgYnVzIGRvIHRoZSBtYXRjaCB1cCBmb3IgeW91IHJpZ2h0PyBBbmQgaW4gdGhlIHBy
b2JlKCksIGEgZHJpdmVyIGNvdWxkIGRvIGRldmljZQ0KPiBzcGVjaWZpYyBxdWlya3MgZm9yIHRo
ZSBkZXZpY2UgdHlwZXMuIElzbnQgdGhhdCBwdXJwb3NlIG9mIGRldmljZSBJRCB0YWJsZXMgZm9y
IHBjaSwgcGxhdGZvcm0sIHVzYiBldGM/DQo+IFdoeSBhcmUgd2UgdHJ5aW5nIHRvIGhhbmRsZSBt
dWx0aXBsZSB2aXJ0YnVzIGRldmljZSB0eXBlcyBmcm9tIGEgZHJpdmVyIGFueSBkaWZmZXJlbnRs
eT8NCj4gDQoNCklmIGRpZmZlcmVuY2VzIGluIHRyZWF0aW5nIHRoZSB0d28gZGV2aWNlcyBpcyBu
b3QgYSBsb3QsIGlmIHlvdSBoYXZlIGxvdA0Kb2YgY29tbW9uIGNvZGUsIGl0IG1ha2Ugc2Vuc2Ug
dG8gZG8gc2luZ2xlIHZpcnRidXNfcmVnaXN0ZXJfZHJpdmVyKCkNCndpdGggdHdvIGRpZmZlcmVu
dCBpZHMuDQpJbiB0aGF0IGNhc2UsIHN0cnVjdCB2aXJ0YnVzX2RldmljZV9pZCBzaG91bGQgaGF2
ZSBzb21lIGRldmljZSBzcGVjaWZpYw0KZmllbGQgbGlrZSBob3cgcGNpIGhhcyBkcml2ZXJfZGF0
YS4NCg0KSXQgc2hvdWxkIG5vdCBiZSBzZXQgYnkgdGhlIG1hdGNoKCkgZnVuY3Rpb24gYnkgdmly
dGJ1cyBjb3JlLg0KVGhpcyBmaWVsZCBzaG91bGQgYmUgc2V0dXAgaW4gdGhlIGlkIHRhYmxlIGJ5
IHRoZSBodyBkcml2ZXIgd2hpY2gNCmludm9rZXMgdmlydGJ1c19yZWdpc3Rlcl9kZXZpY2UoKS4N
Cg==
