Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 875959D9B9
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 01:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfHZXCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 19:02:21 -0400
Received: from mail-eopbgr20075.outbound.protection.outlook.com ([40.107.2.75]:64263
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726020AbfHZXCV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 19:02:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjUVT34zh8ToARbJsCx9+8EpXamwJCRvEs24UyiQSxDJ+NXTPdM5hjTyp2VfJZumvey1y73H1ykKeezYtpJ/Xf9b/BLE/1HWi096EzkSwM6Lez/vNEmMi9NLYXEiWrpIpOtahtIgapsqH+dl/kMRjB3aeYB6RJRJzglNaCsctiDV8oEddkDev+01cozra7Mocos4YWKNVGnOvxJwTblerzK2ofcHrDS7h68xfdEKaIhoq18aBgf2XheCOWQya1ePvZrMbBPtLWq1X9MIEgrKU+P5cKfXUu6KYh3XneGCNTh6XUvDqTB+hB3KmDyN7Pfq9YyxX2I1fxcDZh22i5bZzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nC3HrdtOQs5mK6UlJkek/hVpCqNaxlr5l9Z6f/aOms=;
 b=mojUF7iFPFBkyDJi5i5iEJdK+kXdvwbNQLiug0orcQy5JNcRTKbkOx/xWmSgoW73J6asKSg8o4sG3AOf0UI1CRBN6IJ75b3WuDnC/jQKu3E81wHbY6hbEZrgUxgTTIDi3x8c6l6tQd6+QvowajYauNWASaBv9SOXJcbVsfm99CsG8tshckCg9nX5gub4i27bOFbgtr+eCqdmExg2/5mf8gQ4Mtb4yJ3rSqWoTnTjiPFtEE5OM5Yr0LLA7DKxExdo5tJhcBgZ3RfR0d1OfwS9pKCpt33RTq6IHkUS3AvCV5uuErRUUmeaJ6GndkIoe68h8DDtBK0ET+uSsb/539KM8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3nC3HrdtOQs5mK6UlJkek/hVpCqNaxlr5l9Z6f/aOms=;
 b=r5VgMcc7u1CP6GSkaaIzPcT5rAOhlwkCa4inEa41WK7A1XhagPPnL+/VV/cMI2JLfIeVWjyHwVmo19gmksP9nnz9ohk8Guqj9F3I7UL1iTbHBYEGgKx3UQ8bK/+akvr5J0Kt5wPZ5dmX9OaRqYhFpog7KeNsqd5q7m0kVQ/LTuY=
Received: from VI1PR05MB3342.eurprd05.prod.outlook.com (10.170.238.143) by
 VI1PR05MB5118.eurprd05.prod.outlook.com (20.178.10.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Mon, 26 Aug 2019 23:02:15 +0000
Received: from VI1PR05MB3342.eurprd05.prod.outlook.com
 ([fe80::4499:7719:a52f:a63a]) by VI1PR05MB3342.eurprd05.prod.outlook.com
 ([fe80::4499:7719:a52f:a63a%5]) with mapi id 15.20.2199.021; Mon, 26 Aug 2019
 23:02:15 +0000
From:   Mark Bloch <markb@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
Thread-Topic: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
Thread-Index: AQHVXE7B4INmwXGa50S5QC7yiBQtm6cOC/IA
Date:   Mon, 26 Aug 2019 23:02:15 +0000
Message-ID: <6601940a-4832-08d2-e0f6-f9ac24758cdc@mellanox.com>
References: <20190826204119.54386-1-parav@mellanox.com>
 <20190826204119.54386-3-parav@mellanox.com>
In-Reply-To: <20190826204119.54386-3-parav@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1401CA0020.namprd14.prod.outlook.com
 (2603:10b6:301:4b::30) To VI1PR05MB3342.eurprd05.prod.outlook.com
 (2603:10a6:802:1d::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=markb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [208.186.24.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b9841c29-dfb2-41eb-8352-08d72a796fbd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5118;
x-ms-traffictypediagnostic: VI1PR05MB5118:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB51183D00C6F5A75A1ED48B8CD2A10@VI1PR05MB5118.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(136003)(376002)(199004)(189003)(31686004)(36756003)(446003)(52116002)(66066001)(71200400001)(256004)(2616005)(476003)(486006)(6116002)(4744005)(3846002)(11346002)(14444005)(6436002)(76176011)(81156014)(81166006)(8936002)(8676002)(25786009)(2501003)(53546011)(6506007)(386003)(2201001)(229853002)(5660300002)(66946007)(316002)(31696002)(305945005)(7736002)(99286004)(2906002)(6512007)(4326008)(26005)(86362001)(55236004)(6486002)(102836004)(14454004)(478600001)(66476007)(186003)(66446008)(53936002)(64756008)(66556008)(6246003)(110136005)(54906003)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5118;H:VI1PR05MB3342.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: K3hrn5OnYy1L4NN36dOP8nSiRtiO6tSk1/Ek/n20zEgYi8BhjZ6GkHPymIJjXOTZ6cX2L/q8OxigUb7YrOsmHWRRW6nDYoXrcvZKJLEjcbG0hD+b2GUQT8JZ2/gso3I1uoyKrlV4sfS8QH0KkK1HmUXxf11gLQ0VTnniNmRMSRsdJt9wG27AfhCtvhaUmG8gJUm7zjAgZeu86XqziKmTyatUOwTMQHsI04njAwjxzH6xLLxQ6+xC4APibmoNSyJxcEfMdL2jdWskhNf+X1Wzj4eT+/C+UAOD7r/AaPLWSAYHAUXSl3fv7pwln4WsNFRa+SzBMscLWOo2+nERDxlO/8N4X3A3sPu02h5bIZOEqmJ6PCvCOKyP7RfPAcWj+qPU4hMIh8ko+Ky9+E4zc9hVEKi4DueA8YrbDcSNrBgKI/Y=
Content-Type: text/plain; charset="utf-8"
Content-ID: <451034353FBE984B8B8D0F9081EAE8E8@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9841c29-dfb2-41eb-8352-08d72a796fbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 23:02:15.2493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 64d/qH5O6ITwC3QTLJXvpF48fH5YRuCledCPi52u803l4hS8PTkDo90Vd6sw1D/zXwx8OXzv/U88s47tX1q00w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5118
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMjYvMTkgMTo0MSBQTSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiBNZGV2IGFsaWFz
IHNob3VsZCBiZSB1bmlxdWUgYW1vbmcgYWxsIHRoZSBtZGV2cywgc28gdGhhdCB3aGVuIHN1Y2gg
YWxpYXMNCj4gaXMgdXNlZCBieSB0aGUgbWRldiB1c2VycyB0byBkZXJpdmUgb3RoZXIgb2JqZWN0
cywgdGhlcmUgaXMgbm8NCj4gY29sbGlzaW9uIGluIGEgZ2l2ZW4gc3lzdGVtLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQo+IC0tLQ0KPiAg
ZHJpdmVycy92ZmlvL21kZXYvbWRldl9jb3JlLmMgfCA1ICsrKysrDQo+ICAxIGZpbGUgY2hhbmdl
ZCwgNSBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL21kZXYv
bWRldl9jb3JlLmMgYi9kcml2ZXJzL3ZmaW8vbWRldi9tZGV2X2NvcmUuYw0KPiBpbmRleCBlODI1
ZmYzOGIwMzcuLjZlYjM3ZjBjNjM2OSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy92ZmlvL21kZXYv
bWRldl9jb3JlLmMNCj4gKysrIGIvZHJpdmVycy92ZmlvL21kZXYvbWRldl9jb3JlLmMNCj4gQEAg
LTM3NSw2ICszNzUsMTEgQEAgaW50IG1kZXZfZGV2aWNlX2NyZWF0ZShzdHJ1Y3Qga29iamVjdCAq
a29iaiwgc3RydWN0IGRldmljZSAqZGV2LA0KPiAgCQkJcmV0ID0gLUVFWElTVDsNCj4gIAkJCWdv
dG8gbWRldl9mYWlsOw0KPiAgCQl9DQo+ICsJCWlmICh0bXAtPmFsaWFzICYmIHN0cmNtcCh0bXAt
PmFsaWFzLCBhbGlhcykgPT0gMCkgew0KDQphbGlhcyBjYW4gYmUgTlVMTCBoZXJlIG5vPw0KDQo+
ICsJCQltdXRleF91bmxvY2soJm1kZXZfbGlzdF9sb2NrKTsNCj4gKwkJCXJldCA9IC1FRVhJU1Q7
DQo+ICsJCQlnb3RvIG1kZXZfZmFpbDsNCj4gKwkJfQ0KPiAgCX0NCj4gIA0KPiAgCW1kZXYgPSBr
emFsbG9jKHNpemVvZigqbWRldiksIEdGUF9LRVJORUwpOw0KPiANCg0KTWFyaw0K
