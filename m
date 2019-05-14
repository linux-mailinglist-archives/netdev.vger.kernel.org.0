Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA971C83C
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 14:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbfENMLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 08:11:22 -0400
Received: from mail-eopbgr790083.outbound.protection.outlook.com ([40.107.79.83]:52512
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbfENMLW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 08:11:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-aquantia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90NXkAlMLecbScZQRgyU22Rr2MR1nJ9WA4yO/jB/4jY=;
 b=dLV4SI6ClIyCNKzlrLNXwZs8QRafZlwNAXsSBtTX5+rno8WkvZdDZScLZaO6bpa4UgpS2kbv4SKDt0hk2jhuD3uW0db1JbchhMhZenH0ib2iO8+eWwnXn+a+X4lPu33YoJ/eglbdeVd1GYhKA9sbMRN7CmAMbFv+Oos6qFZdItQ=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3834.namprd11.prod.outlook.com (20.179.17.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.22; Tue, 14 May 2019 12:11:18 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::60da:b876:40f2:6a19]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::60da:b876:40f2:6a19%3]) with mapi id 15.20.1878.024; Tue, 14 May 2019
 12:11:18 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Oliver Neukum <oneukum@suse.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/3] aqc111: fix writing to the phy on BE
Thread-Topic: [PATCH 2/3] aqc111: fix writing to the phy on BE
Thread-Index: AQHVCk4goKWxhGgVDkycPKGnEFaexQ==
Date:   Tue, 14 May 2019 12:11:18 +0000
Message-ID: <cd6754c6-8384-a65c-1c0e-0e3d2eaaa66b@aquantia.com>
References: <20190509090818.9257-1-oneukum@suse.com>
 <20190509090818.9257-2-oneukum@suse.com>
In-Reply-To: <20190509090818.9257-2-oneukum@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR21CA0007.namprd21.prod.outlook.com
 (2603:10b6:a03:114::17) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ea64ee7-0505-43c1-cf26-08d6d8654531
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB3834;
x-ms-traffictypediagnostic: DM6PR11MB3834:
x-microsoft-antispam-prvs: <DM6PR11MB3834E212EA62ED6DA2C17E7B98080@DM6PR11MB3834.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0037FD6480
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39850400004)(346002)(136003)(376002)(396003)(199004)(189003)(102836004)(8936002)(229853002)(53546011)(36756003)(386003)(6506007)(6116002)(31686004)(6512007)(6486002)(3846002)(66066001)(6436002)(2906002)(99286004)(71200400001)(81166006)(71190400001)(31696002)(316002)(86362001)(110136005)(81156014)(26005)(186003)(68736007)(8676002)(66946007)(66556008)(66476007)(76176011)(64756008)(66446008)(446003)(476003)(478600001)(305945005)(72206003)(44832011)(2616005)(14454004)(73956011)(486006)(7736002)(2501003)(11346002)(6246003)(256004)(5660300002)(25786009)(14444005)(52116002)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3834;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zWqmEoWIjrBTdRZXqrIaJRh26bjp/tjaPyp7h4TclPyl1PZ6RRzgvayFH0tHjPedFMpu+SMFhqvfLGcvJDIBqHzcki35jdGiuecSbFn5qXGMj33uX1sbBsnib9aqgw85wKZpbKYa/tR20vNkGCqDDMVA+vIObXWLRIKqRvOTW0VF4+Y6Xp/C42DHBKrlKhfWvyf1YyiFc6plZrl0zUodZDYSpNq3YIVNysdgU9MFgejTMgirgNAajmkcMC0ZCoqlK6qoCNhLCMI+liGflPA3GM+thGQwzzvinCGe3FGPsOw7nkexdXxYGKZ99y399N5q9SO6u43NXEs8p2VOb13JltvJKw+1LgcP3655E3Oem9MZ6hf5ywDJ3f5VTAwi2mo9HvHAefK8WxavL5nskXSJJqjowwXR6L3g9XCTJODBwjw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9987D605CCBA8F49A8EE12A8E35AE8DF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ea64ee7-0505-43c1-cf26-08d6d8654531
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2019 12:11:18.8015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3834
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAwOS4wNS4yMDE5IDEyOjA4LCBPbGl2ZXIgTmV1a3VtIHdyb3RlOg0KPiBXaGVuIHdyaXRp
bmcgdG8gdGhlIHBoeSBvbiBCRSBhcmNoaXRlY3R1cmVzIGFuIGludGVybmFsIGRhdGEgc3RydWN0
dXJlDQo+IHdhcyBkaXJlY3RseSBnaXZlbiwgbGVhZGluZyB0byBpdCBiZWluZyBieXRlIHN3YXBw
ZWQgaW4gdGhlIHdyb25nDQo+IHdheSBmb3IgdGhlIENQVSBpbiA1MCUgb2YgYWxsIGNhc2VzLiBB
IHRlbXBvcmFyeSBidWZmZXIgbXVzdCBiZSB1c2VkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogT2xp
dmVyIE5ldWt1bSA8b25ldWt1bUBzdXNlLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC91c2Iv
YXFjMTExLmMgfCAyMyArKysrKysrKysrKysrKysrKy0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQs
IDE3IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvdXNiL2FxYzExMS5jIGIvZHJpdmVycy9uZXQvdXNiL2FxYzExMS5jDQo+IGluZGV4
IDQwOGRmMmQzMzVlMy4uNTk5ZDU2MGE4NDUwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC91
c2IvYXFjMTExLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvdXNiL2FxYzExMS5jDQo+IEBAIC0zMjAs
NiArMzIwLDcgQEAgc3RhdGljIGludCBhcWMxMTFfZ2V0X2xpbmtfa3NldHRpbmdzKHN0cnVjdCBu
ZXRfZGV2aWNlICpuZXQsDQo+ICBzdGF0aWMgdm9pZCBhcWMxMTFfc2V0X3BoeV9zcGVlZChzdHJ1
Y3QgdXNibmV0ICpkZXYsIHU4IGF1dG9uZWcsIHUxNiBzcGVlZCkNCj4gIHsNCj4gIAlzdHJ1Y3Qg
YXFjMTExX2RhdGEgKmFxYzExMV9kYXRhID0gZGV2LT5kcml2ZXJfcHJpdjsNCj4gKwl1MzIgcGh5
X29uX3RoZV93aXJlOw0KPiAgDQo+ICAJYXFjMTExX2RhdGEtPnBoeV9jZmcgJj0gfkFRX0FEVl9N
QVNLOw0KPiAgCWFxYzExMV9kYXRhLT5waHlfY2ZnIHw9IEFRX1BBVVNFOw0KPiBAQCAtMzYxLDcg
KzM2Miw4IEBAIHN0YXRpYyB2b2lkIGFxYzExMV9zZXRfcGh5X3NwZWVkKHN0cnVjdCB1c2JuZXQg
KmRldiwgdTggYXV0b25lZywgdTE2IHNwZWVkKQ0KPiAgCQl9DQo+ICAJfQ0KPiAgDQo+IC0JYXFj
MTExX3dyaXRlMzJfY21kKGRldiwgQVFfUEhZX09QUywgMCwgMCwgJmFxYzExMV9kYXRhLT5waHlf
Y2ZnKTsNCj4gKwlwaHlfb25fdGhlX3dpcmUgPSBhcWMxMTFfZGF0YS0+cGh5X2NmZzsNCj4gKwlh
cWMxMTFfd3JpdGUzMl9jbWQoZGV2LCBBUV9QSFlfT1BTLCAwLCAwLCAmcGh5X29uX3RoZV93aXJl
KTsNCg0KSGkgT2xpdmVyLA0KDQpJIHNlZSBhbGwgd3JpdGUzMl9jbWQgYW5kIHdyaXRlMTZfY21k
IGFyZSB1c2luZyBhIHRlbXBvcmFyeSB2YXJpYWJsZSB0byBkbyBhbg0KaW50ZXJuYWwgY3B1X3Rv
X2xlMzIuIFdoeSB0aGlzIGV4dHJhIHRlbXBvcmFyeSBzdG9yYWdlIGlzIG5lZWRlZD8NCg0KVGhl
IHF1ZXN0aW9uIGlzIGFjdHVhbGx5IGZvciBib3RoIDJuZCBhbmQgdGhpcmQgcGF0Y2guDQpJbiBh
bGwgdGhlIGNhc2VzIEJFIG1hY2hpbmUgd2lsbCBzdG9yZSB0ZW1wb3JhcnkgYnN3YXAgY29udmVy
c2lvbiBpbiB0bXANCnZhcmlhYmxlIGFuZCB3aWxsIG5vdCBhY3R1YWxseSB0b3VjaCBhY3R1YWwg
ZmllbGQuDQoNClJlZ2FyZHMsDQogIElnb3INCg0KUFMgU29ycnkgZm9yIHNlbmRpbmcgdGhpcyBs
YXRlbHksIGhhZCBhIGxvbmcgaG9saWRheSB3ZWVrZW5kLg0K
