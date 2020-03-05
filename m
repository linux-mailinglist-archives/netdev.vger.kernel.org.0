Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A354717A0E1
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 09:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgCEIOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 03:14:38 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:10116
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725816AbgCEIOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 03:14:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CzYfXhqj2YrRLtfXjsqRU360K8RBjROGJ3nkzZ+de5H8DNMOdTNhRWWGTZWrY8jYOU2Dp0PfPmVNfiqZAqBPjZHDopnLN56P4mumXnzAeO4z2LPr/vLHuax4kClVCBS/HAakvr+xitz19tJaElO0pP0v+eIxpDA4673ANyfLsDaeTh+rmuD6WVSDZTrOON1HM1aZhjg1d7UOph0VKMjaoOhXOMXlplGM7ylaoF+5DP51+SOZ/cbqBwueUAn6ZoL7kYUvZPMew6irIaLyp6NJ6BhrKkXLuNdoSHscWkJ7lompQtim5W53fJ9jmv57mMlS5L+JZHPDto6c6D6HRFcLsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAd3j0mHqyVhZZA/8D/u7gB+X20tlnrAE/f3HzaWf3s=;
 b=FyWNYvZrwXGjZPEZ8HXQRrV1FDvCwgQm5z7RDv71zoXCnU5IZTl9C9DSy37PSoZQ4Z1vgs2qmhgg5eIovpvD0AmbyMN6ciG8XqYGS+Z1uMMv6p+80ZlLjKcqocLwzZw4P//SqRjOv0VDXFJhYtGgK1qH2Nm0yCpKwXzbx0tfXLMsMFV+GL6xnoD9+7zKSzfXuPnc83ZTuzKU8I2Z5rgApgmUMyRnADDpNkKgmECqtHLZCdMMd1fdQu5sgOUO3ySlBkhWhm9e/O1On9Rgx9ltOJ6NAr3YmqFuqlymEiJkM6EKL3kubt4TqxSYPnWrnZu0X3PPLlDydkFtESnxKjf7rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MAd3j0mHqyVhZZA/8D/u7gB+X20tlnrAE/f3HzaWf3s=;
 b=qvpD5fvhhVCl36SD48Oah18e72lYJKDsEU/7nSxL6Jyto2fQeGvEnJTgN86B/JSXLo3sYAHggEQJvqRcBLE5NdOWsRFs9Ns7uwSLRRayURPK1hngZcqBes7w6Dz0jxW1ksvAwdWzcM7FtId3Kz8pk5rotEFga6eFl7xF4CkjtlQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6752.eurprd05.prod.outlook.com (10.186.160.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Thu, 5 Mar 2020 08:14:33 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 08:14:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "benve@cisco.com" <benve@cisco.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "_govind@gmx.com" <_govind@gmx.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next v3 10/12] mlx5: reject unsupported coalescing
 params
Thread-Topic: [PATCH net-next v3 10/12] mlx5: reject unsupported coalescing
 params
Thread-Index: AQHV8q1DHYGOFWqEakatGdWN6NIEu6g5ptUA
Date:   Thu, 5 Mar 2020 08:14:33 +0000
Message-ID: <6a7501ebf1adc48e7a02b03a8abc72235201ce35.camel@mellanox.com>
References: <20200305051542.991898-1-kuba@kernel.org>
         <20200305051542.991898-11-kuba@kernel.org>
In-Reply-To: <20200305051542.991898-11-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 90e9853f-6592-47b7-9fc4-08d7c0dd3c91
x-ms-traffictypediagnostic: VI1PR05MB6752:
x-microsoft-antispam-prvs: <VI1PR05MB67528BD1B898B862EC677590BEE20@VI1PR05MB6752.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 03333C607F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(189003)(199004)(91956017)(478600001)(4326008)(110136005)(6506007)(2906002)(54906003)(7416002)(86362001)(316002)(36756003)(76116006)(186003)(2616005)(71200400001)(5660300002)(26005)(66476007)(8676002)(66556008)(66946007)(81156014)(6512007)(8936002)(66446008)(6486002)(64756008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6752;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4d9UEqFDBbpAa44+ALUp6Cx52hAfTV4zfvbClIGYwfzTXQsJ9ZpfMh0j0KgltT7VyPh5sDah0oHzgkR05ZZf8u4IXYQLHsGBGKZDEiBDZYMMjeDV3OLcOpihgx2tfULDt0GZWVUfSrv+q7mKHiTfIb8pXifJa7kEyHZ3KU1pXrO7d5EngbHAhUj+4luEUCZDLHIcFreI8SD2QXF5LoPW0yB+E1KF//W98AetNMUFm7rMbslaWeFSRTYkAQpLDRzI4QjCywTi7RBS6qyMPnFlRz6r4NPAAFVYHKGnyycNYA+CxTM5az5YvQtXaFHxx4FZO4mTgO4DNecSgDR3rn8feMU2CBuhQ7QsSuAOll7NggNmIrnu/mhmjgo0P7bM1UsU7cPzGEoaxpBcJ6SyH59pwHSMWwHNIrw/Wm+Q4KgrMMAqzZ2SItao71t+FUPbIy4S
x-ms-exchange-antispam-messagedata: T/b7YuOBw7NTJ9j8cO7ZfP7r+sfMcfimSy/1iV8F9h71w9awXV2to8uhoEkY9jWgmydSh70sNOjzx5FelOHjlufpgBAMMYn16RrYfDHL8CD+w2T+nyEc/zCLrUf9W9F7+DrQXSh+JyoZ0dVk4GSC1g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <84AF470C3F90FD47BD4A2CB88A96AE02@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e9853f-6592-47b7-9fc4-08d7c0dd3c91
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2020 08:14:33.1837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DbUZNpTultIALZXMeyMGWoYfZoJ1nBgIheHjklY1VMIqC6xzrFRlRwkL1/Byhu03Ef3MGSZB42c9rM8RgGVs2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6752
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTAzLTA0IGF0IDIxOjE1IC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gU2V0IGV0aHRvb2xfb3BzLT5zdXBwb3J0ZWRfY29hbGVzY2VfcGFyYW1zIHRvIGxldA0KPiB0
aGUgY29yZSByZWplY3QgdW5zdXBwb3J0ZWQgY29hbGVzY2luZyBwYXJhbWV0ZXJzLg0KPiANCj4g
VGhpcyBkcml2ZXIgZGlkIG5vdCBwcmV2aW91c2x5IHJlamVjdCB1bnN1cHBvcnRlZCBwYXJhbWV0
ZXJzLg0KPiANCj4gdjM6IGFkanVzdCBjb21taXQgbWVzc2FnZSBmb3IgbmV3IG1lbWJlciBuYW1l
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0K
PiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9ldGh0
b29sLmMgICAgfCAzICsrKw0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuX3JlcC5jICAgICAgICB8IDYgKysrKysrDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvaXBvaWIvZXRodG9vbC5jIHwgMyArKysNCj4gIDMgZmlsZXMgY2hh
bmdlZCwgMTIgaW5zZXJ0aW9ucygrKQ0KPiANCg0KdGhlIG9ubHkgbWlub3IgdGhpbmcgaXMgdGhl
IGR1cGxpY2F0aW9uIG9mIHRoZSBzYW1lIGZsYWdzIGluIGFsbCB0eXBlcw0Kb2YgbWx4NSBuZXRk
ZXZzLCBhbGwgbWx4NSBuZXRkZXZzIHVzZSB0aGUgc2FtZSBpbmZyYXN0cnVjdHVyZSBvZiByeC90
eA0KcmluZyBtYW5hZ2VtZW50LCBzbyB0aGV5IHdpbGwgYWx3YXlzIHNoYXJlIHRoZSBzYW1lIGZs
YWdzLiANCg0KQW55d2F5IGkgY2FuIGZvbGxvdyB1cCB3aXRoIGEgcGF0Y2ggdG8gZmFjdG9yIG91
dCB0aGUgZHVwbGljYXRpb24uDQoNCkFja2VkLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1l
bGxhbm94LmNvbT4NCg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2VuX2V0aHRvb2wuYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbl9ldGh0b29sLmMNCj4gaW5kZXggMDZmNmYwOGZmNWViLi4wMTUzOWI4
NzRiNWUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbl9ldGh0b29sLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2VuX2V0aHRvb2wuYw0KPiBAQCAtMTk2NSw2ICsxOTY1LDkgQEAgc3RhdGljIGlu
dCBtbHg1ZV9zZXRfcnhuZmMoc3RydWN0IG5ldF9kZXZpY2UNCj4gKmRldiwgc3RydWN0IGV0aHRv
b2xfcnhuZmMgKmNtZCkNCj4gIH0NCj4gIA0KPiAgY29uc3Qgc3RydWN0IGV0aHRvb2xfb3BzIG1s
eDVlX2V0aHRvb2xfb3BzID0gew0KPiArCS5zdXBwb3J0ZWRfY29hbGVzY2VfcGFyYW1zID0gRVRI
VE9PTF9DT0FMRVNDRV9VU0VDUyB8DQo+ICsJCQkJICAgICBFVEhUT09MX0NPQUxFU0NFX01BWF9G
UkFNRVMgfA0KPiArCQkJCSAgICAgRVRIVE9PTF9DT0FMRVNDRV9VU0VfQURBUFRJVkUsDQo+ICAJ
LmdldF9kcnZpbmZvICAgICAgID0gbWx4NWVfZ2V0X2RydmluZm8sDQo+ICAJLmdldF9saW5rICAg
ICAgICAgID0gZXRodG9vbF9vcF9nZXRfbGluaywNCj4gIAkuZ2V0X3N0cmluZ3MgICAgICAgPSBt
bHg1ZV9nZXRfc3RyaW5ncywNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbl9yZXAuYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9lbl9yZXAuYw0KPiBpbmRleCAxYTg4OTdmODA1NDcuLmM1MDYxNDNjODU1
OSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2VuX3JlcC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl9yZXAuYw0KPiBAQCAtMzc2LDYgKzM3Niw5IEBAIHN0YXRpYyBpbnQNCj4gbWx4NWVfdXBs
aW5rX3JlcF9zZXRfbGlua19rc2V0dGluZ3Moc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldiwNCj4g
IH0NCj4gIA0KPiAgc3RhdGljIGNvbnN0IHN0cnVjdCBldGh0b29sX29wcyBtbHg1ZV9yZXBfZXRo
dG9vbF9vcHMgPSB7DQo+ICsJLnN1cHBvcnRlZF9jb2FsZXNjZV9wYXJhbXMgPSBFVEhUT09MX0NP
QUxFU0NFX1VTRUNTIHwNCj4gKwkJCQkgICAgIEVUSFRPT0xfQ09BTEVTQ0VfTUFYX0ZSQU1FUyB8
DQo+ICsJCQkJICAgICBFVEhUT09MX0NPQUxFU0NFX1VTRV9BREFQVElWRSwNCj4gIAkuZ2V0X2Ry
dmluZm8JICAgPSBtbHg1ZV9yZXBfZ2V0X2RydmluZm8sDQo+ICAJLmdldF9saW5rCSAgID0gZXRo
dG9vbF9vcF9nZXRfbGluaywNCj4gIAkuZ2V0X3N0cmluZ3MgICAgICAgPSBtbHg1ZV9yZXBfZ2V0
X3N0cmluZ3MsDQo+IEBAIC0zOTIsNiArMzk1LDkgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBldGh0
b29sX29wcw0KPiBtbHg1ZV9yZXBfZXRodG9vbF9vcHMgPSB7DQo+ICB9Ow0KPiAgDQo+ICBzdGF0
aWMgY29uc3Qgc3RydWN0IGV0aHRvb2xfb3BzIG1seDVlX3VwbGlua19yZXBfZXRodG9vbF9vcHMg
PSB7DQo+ICsJLnN1cHBvcnRlZF9jb2FsZXNjZV9wYXJhbXMgPSBFVEhUT09MX0NPQUxFU0NFX1VT
RUNTIHwNCj4gKwkJCQkgICAgIEVUSFRPT0xfQ09BTEVTQ0VfTUFYX0ZSQU1FUyB8DQo+ICsJCQkJ
ICAgICBFVEhUT09MX0NPQUxFU0NFX1VTRV9BREFQVElWRSwNCj4gIAkuZ2V0X2RydmluZm8JICAg
PSBtbHg1ZV91cGxpbmtfcmVwX2dldF9kcnZpbmZvLA0KPiAgCS5nZXRfbGluawkgICA9IGV0aHRv
b2xfb3BfZ2V0X2xpbmssDQo+ICAJLmdldF9zdHJpbmdzICAgICAgID0gbWx4NWVfcmVwX2dldF9z
dHJpbmdzLA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2lwb2liL2V0aHRvb2wuYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9pcG9pYi9ldGh0b29sLmMNCj4gaW5kZXggOTBjYjUwZmUxN2ZkLi4xZWVmNjZl
ZTg0OWUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9pcG9pYi9ldGh0b29sLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2lwb2liL2V0aHRvb2wuYw0KPiBAQCAtMjM1LDYgKzIzNSw5IEBAIHN0YXRp
YyBpbnQgbWx4NWlfZ2V0X2xpbmtfa3NldHRpbmdzKHN0cnVjdA0KPiBuZXRfZGV2aWNlICpuZXRk
ZXYsDQo+ICB9DQo+ICANCj4gIGNvbnN0IHN0cnVjdCBldGh0b29sX29wcyBtbHg1aV9ldGh0b29s
X29wcyA9IHsNCj4gKwkuc3VwcG9ydGVkX2NvYWxlc2NlX3BhcmFtcyA9IEVUSFRPT0xfQ09BTEVT
Q0VfVVNFQ1MgfA0KPiArCQkJCSAgICAgRVRIVE9PTF9DT0FMRVNDRV9NQVhfRlJBTUVTIHwNCj4g
KwkJCQkgICAgIEVUSFRPT0xfQ09BTEVTQ0VfVVNFX0FEQVBUSVZFLA0KPiAgCS5nZXRfZHJ2aW5m
byAgICAgICAgPSBtbHg1aV9nZXRfZHJ2aW5mbywNCj4gIAkuZ2V0X3N0cmluZ3MgICAgICAgID0g
bWx4NWlfZ2V0X3N0cmluZ3MsDQo+ICAJLmdldF9zc2V0X2NvdW50ICAgICA9IG1seDVpX2dldF9z
c2V0X2NvdW50LA0K
