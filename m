Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B580288B8A
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 15:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbfHJNUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 09:20:38 -0400
Received: from mail-eopbgr770050.outbound.protection.outlook.com ([40.107.77.50]:54341
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbfHJNUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 09:20:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BfbyvD6wcEO/gNFPdWMSvoV35wtvadTUbcoSk+TwgTq2SQQgTQWfcCxtFbG2F9Iui1CZIwOZ7Ma3G2Ho9Pr0wI3QROw+qL32Ij7TIe1b+UCU9k62vhabqEPGIZeUIGYjJ8y9odWCIIuo6A1osoJhqxltfAKF10gJkkufip553oBqZbhbE7UFI6znd+t68OVZx6bhx7rYHm/dS7vJR55CSDWGRbBt2wjF1DLQvsCIQ1HRkZNKITNlp4EYfh4ipFVNt2Z9cZ3F14c4WIXps8a74LrFgyGW1WMU4rju9y+PHOEVWNo3NisP4nLlDY3v8524Bpqre3pjfn9g8C8V2kRirA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHAMpVNKHa3MgxmAtPbD/jQ5gNH8piAdrjmipEgCtUM=;
 b=QFG4AP5MFigJWt0tVOKAMcRPhrp812397pdTg5IeiZZEk9TZDxBH/jJosFBfF5hf9yUQfeQA4uEnHmu6pClrMHji06Gl27A12zTqZX2HhPOHdrUZ8cUyMmSIot9IQXMB2Xh4AizJG5lvnNP3hB1CrrOKzSQBaQLUTfj/sYv5z2bOIlUkB1InqkBzBlPeSrOJCuwZduSIlEyKTlw3iqrt8fZfc5SFPtshHXmTOnkttqRHTmpsohixmDOljEbU9Tjbm+LH9fHGMiMeDeggDxVuoFI3IXl+YQ5PcW7VTv1xTqtMj8E1ORSmOmZJs8gu7J80O/Oqo1ITvmCNEmzeNguEdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHAMpVNKHa3MgxmAtPbD/jQ5gNH8piAdrjmipEgCtUM=;
 b=Vqcm3QSH89RVY/ANI0uYCKY4AsUqscCeghelJ91+aKazIjlnogVf+AyTKz3LyVGeqmGqmVWv1Mxn1sQdehvCXkCjhduPr6cUD6gCTJD464mi908vOcZyaUbArY5eFcV2/qaydsoBs1ALcFH6Bho+7ZTMBJCjJCmfw/5QT0/j/g8=
Received: from BYAPR11MB2902.namprd11.prod.outlook.com (20.177.225.222) by
 BYAPR11MB2680.namprd11.prod.outlook.com (52.135.227.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Sat, 10 Aug 2019 13:20:32 +0000
Received: from BYAPR11MB2902.namprd11.prod.outlook.com
 ([fe80::456b:e2ae:2452:5e4]) by BYAPR11MB2902.namprd11.prod.outlook.com
 ([fe80::456b:e2ae:2452:5e4%7]) with mapi id 15.20.2157.020; Sat, 10 Aug 2019
 13:20:32 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "camelia.groza@nxp.com" <camelia.groza@nxp.com>,
        Simon Edelhaus <Simon.Edelhaus@aquantia.com>,
        Pavel Belous <Pavel.Belous@aquantia.com>
Subject: Re: [PATCH net-next v2 6/9] net: macsec: hardware offloading
 infrastructure
Thread-Topic: [PATCH net-next v2 6/9] net: macsec: hardware offloading
 infrastructure
Thread-Index: AQHVT35ck9O2Ca3OL0uT1Xyfcpu+cw==
Date:   Sat, 10 Aug 2019 13:20:32 +0000
Message-ID: <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
In-Reply-To: <20190808140600.21477-7-antoine.tenart@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P190CA0060.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:52::49)
 To BYAPR11MB2902.namprd11.prod.outlook.com (2603:10b6:a03:89::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62153f95-8f55-4c3d-73d4-08d71d958558
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR11MB2680;
x-ms-traffictypediagnostic: BYAPR11MB2680:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB26801B6707EAB266CEBAC89B98D10@BYAPR11MB2680.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 012570D5A0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(199004)(189003)(53936002)(7736002)(3846002)(7416002)(14444005)(6116002)(305945005)(31686004)(6512007)(107886003)(6486002)(86362001)(2201001)(6246003)(66946007)(2906002)(8676002)(66556008)(66476007)(229853002)(66446008)(64756008)(5660300002)(6436002)(81166006)(81156014)(8936002)(31696002)(99286004)(2501003)(186003)(44832011)(26005)(446003)(2616005)(11346002)(476003)(36756003)(486006)(54906003)(110136005)(14454004)(25786009)(71200400001)(76176011)(478600001)(71190400001)(66066001)(52116002)(102836004)(53546011)(256004)(316002)(386003)(4326008)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2680;H:BYAPR11MB2902.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UkAMWkDpcpG/iC+zyKryTfaL9KKgQ4XGCMUxQC3kUcKl3fQ99x+D2s4Pos08iVa/0OyW3GvtRWTIStL2oZR1iBHkah37sRyLdCASu1uIcKRAd1+p8CUEJzTpGLHTIJzgeyf47PnbobRqLXEgucmfp/FAEHPieBa1ZUiY53NrrCJtISwTM5MBn30OUr/uMESbk3Gj01x6Sds3pkTl/qsKku0WClgfn+nQWoNf3JmsL417z+t8DwQblBqS722LeIFYJHj4XFJOobd8TDenMg/yRNguR151F9tQ8NxNUda4wyvjB2wn24cD70zam450WxJ2sh11mpCB6wIyy/srDSXkUK0/NN8jbp4YRBN1Za10Qw43ZWxvSxFk7DdzGDuJIJOcHFB2A9omIglGrBijDYbQ9ikdRXVnDpSB2ZaMKgQMUOM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <30BA2D6BB36BEC40A184F6628937F13B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62153f95-8f55-4c3d-73d4-08d71d958558
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2019 13:20:32.4511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: stLOgbkh5r02LU4tVRvEg0c9ebgM2H22Ah9/W4cECziqHb2NZcw5JkKKzFdbBII7NsOaWaejjImWPUXGdCfBrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2680
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDguMDguMjAxOSAxNzowNSwgQW50b2luZSBUZW5hcnQgd3JvdGU6DQoNCj4gVGhlIFJ4IGFu
ZCBUWCBoYW5kbGVycyBhcmUgbW9kaWZpZWQgdG8gdGFrZSBpbiBhY2NvdW50IHRoZSBzcGVjaWFs
IGNhc2UNCj4gd2VyZSB0aGUgTUFDc2VjIHRyYW5zZm9ybWF0aW9uIGhhcHBlbnMgaW4gdGhlIGhh
cmR3YXJlLCB3aGV0aGVyIGluIGEgUEhZDQo+IG9yIGluIGEgTUFDLCBhcyB0aGUgcGFja2V0cyBz
ZWVuIGJ5IHRoZSBuZXR3b3JraW5nIHN0YWNrIG9uIGJvdGggdGhlDQoNCkRvbid0IHlvdSB0aGlu
ayB3ZSBtYXkgZXZlbnR1YWxseSBtYXkgbmVlZCB4bWl0IC8gaGFuZGxlX2ZyYW1lIG9wcyB0byBi
ZQ0KYSBwYXJ0IG9mIG1hY3NlY19vcHM/DQoNClRoYXQgd2F5IHNvZnR3YXJlIG1hY3NlYyBjb3Vs
ZCBiZSBleHRyYWN0IHRvIGp1c3QgYW5vdGhlciB0eXBlIG9mIG9mZmxvYWQuDQpUaGUgZHJhd2Jh
Y2sgb2YgY3VycmVudCBjb2RlIGlzIGl0IGRvZXNuJ3Qgc2hvdyBleHBsaWNpdGx5IHRoZSBwYXRo
IG9mDQpvZmZsb2FkZWQgcGFja2V0cy4gSXQgaXMgaGlkZGVuIGluIGBoYW5kbGVfbm90X21hY3Nl
Y2AgYW5kIGluDQpgbWFjc2VjX3N0YXJ0X3htaXRgIGJyYW5jaC4gVGhpcyBtYWtlcyBpbmNvcnJl
Y3QgY291bnRlcnMgdG8gdGljayAoc2VlIG15IGJlbG93DQpjb21tZW50KQ0KDQpBbm90aGVyIHRo
aW5nIGlzIHRoYXQgYm90aCB4bWl0IC8gbWFjc2VjX2hhbmRsZV9mcmFtZSBjYW4ndCBub3cgYmUg
Y3VzdG9taXplZA0KYnkgZGV2aWNlIGRyaXZlci4gQnV0IHRoaXMgbWF5IGJlIHJlcXVpcmVkLg0K
V2UgZm9yIGV4YW1wbGUgaGF2ZSB1c2VjYXNlcyBhbmQgSFcgZmVhdHVyZXMgdG8gYWxsb3cgc3Bl
Y2lmaWMgZmxvd3MgdG8gYnlwYXNzDQptYWNzZWMgZW5jcnlwdGlvbi4gVGhpcyBpcyBub3JtYWxs
eSB1c2VkIGZvciBtYWNzZWMga2V5IGNvbnRyb2wgcHJvdG9jb2xzLA0KaWRlbnRpZmllZCBieSBl
dGhlcnR5cGUuIFlvdXIgcGh5IGlzIGFsc28gY2FwYWJsZSBvbiB0aGF0IGFzIEkgc2VlLg0KDQoN
Cj4gQEAgLTI1NDYsMTEgKzI4MTQsMTUgQEAgc3RhdGljIG5ldGRldl90eF90IG1hY3NlY19zdGFy
dF94bWl0KHN0cnVjdCBza19idWZmICpza2IsDQo+ICB7DQo+ICAJc3RydWN0IG1hY3NlY19kZXYg
Km1hY3NlYyA9IG5ldGRldl9wcml2KGRldik7DQo+ICAJc3RydWN0IG1hY3NlY19zZWN5ICpzZWN5
ID0gJm1hY3NlYy0+c2VjeTsNCj4gKwlzdHJ1Y3QgbWFjc2VjX3R4X3NjICp0eF9zYyA9ICZzZWN5
LT50eF9zYzsNCj4gIAlzdHJ1Y3QgcGNwdV9zZWN5X3N0YXRzICpzZWN5X3N0YXRzOw0KPiArCXN0
cnVjdCBtYWNzZWNfdHhfc2EgKnR4X3NhOw0KPiAgCWludCByZXQsIGxlbjsNCj4gIA0KPiArCXR4
X3NhID0gbWFjc2VjX3R4c2FfZ2V0KHR4X3NjLT5zYVt0eF9zYy0+ZW5jb2Rpbmdfc2FdKTsNCg0K
RGVjbGFyZWQsIGJ1dCBub3QgdXNlZD8NCg0KPiAgCS8qIDEwLjUgKi8NCj4gLQlpZiAoIXNlY3kt
PnByb3RlY3RfZnJhbWVzKSB7DQo+ICsJaWYgKCFzZWN5LT5wcm90ZWN0X2ZyYW1lcyB8fCBtYWNz
ZWNfZ2V0X29wcyhuZXRkZXZfcHJpdihkZXYpLCBOVUxMKSkgew0KPiAgCQlzZWN5X3N0YXRzID0g
dGhpc19jcHVfcHRyKG1hY3NlYy0+c3RhdHMpOw0KPiAgCQl1NjRfc3RhdHNfdXBkYXRlX2JlZ2lu
KCZzZWN5X3N0YXRzLT5zeW5jcCk7DQo+ICAJCXNlY3lfc3RhdHMtPnN0YXRzLk91dFBrdHNVbnRh
Z2dlZCsrOw0KDQpIZXJlIHlvdSB1c2Ugc2FtZSBgaWZgIGZvciBzdyBhbmQgaHcgZmxvd3MsIHRo
aXMgbWFraW5nIGBPdXRQa3RzVW50YWdnZWRgDQpjb3VudGVyIGludmFsaWQuDQoNCj4gIAlzdHJ1
Y3QgbWFjc2VjX2RldiAqbWFjc2VjID0gbWFjc2VjX3ByaXYoZGV2KTsNCj4gLQlzdHJ1Y3QgbmV0
X2RldmljZSAqcmVhbF9kZXY7DQo+ICsJc3RydWN0IG5ldF9kZXZpY2UgKnJlYWxfZGV2LCAqbG9v
cF9kZXY7DQo+ICsJc3RydWN0IG1hY3NlY19jb250ZXh0IGN0eDsNCj4gKwljb25zdCBzdHJ1Y3Qg
bWFjc2VjX29wcyAqb3BzOw0KPiArCXN0cnVjdCBuZXQgKmxvb3BfbmV0Ow0KDQpSZXZlcnNlIENo
cmlzdG1hcyB0cmVlIGlzIG5vcm1hbGx5IGEgZm9ybWF0dGluZyByZXF1aXJlbWVudCB3aGVyZSBw
b3NzaWJsZS4NCg0KPiArCWZvcl9lYWNoX25ldChsb29wX25ldCkgew0KPiArCQlmb3JfZWFjaF9u
ZXRkZXYobG9vcF9uZXQsIGxvb3BfZGV2KSB7DQo+ICsJCQlzdHJ1Y3QgbWFjc2VjX2RldiAqcHJp
djsNCj4gKw0KPiArCQkJaWYgKCFuZXRpZl9pc19tYWNzZWMobG9vcF9kZXYpKQ0KPiArCQkJCWNv
bnRpbnVlOw0KPiArDQo+ICsJCQlwcml2ID0gbWFjc2VjX3ByaXYobG9vcF9kZXYpOw0KPiArDQo+
ICsJCQkvKiBBIGxpbWl0YXRpb24gb2YgdGhlIE1BQ3NlYyBoL3cgb2ZmbG9hZGluZyBpcyBvbmx5
IGENCj4gKwkJCSAqIHNpbmdsZSBNQUNzZWMgaW50ZXJmYWNlIGNhbiBiZSBjcmVhdGVkIGZvciBh
IGdpdmVuDQo+ICsJCQkgKiByZWFsIGludGVyZmFjZS4NCj4gKwkJCSAqLw0KPiArCQkJaWYgKG1h
Y3NlY19nZXRfb3BzKG5ldGRldl9wcml2KGRldiksIE5VTEwpICYmDQo+ICsJCQkgICAgcHJpdi0+
cmVhbF9kZXYgPT0gcmVhbF9kZXYpDQo+ICsJCQkJcmV0dXJuIC1FQlVTWTsNCj4gKwkJfQ0KPiAr
CX0NCj4gKw0KDQpUaGVyZSBpcyBubyBuZWVkIHRvIGRvIHRoaXMgc2VhcmNoIGxvb3AgaWYgYG1h
Y3NlY19nZXRfb3BzKC4uKSA9PSBOVUxMYCA/DQpTbyB5b3UgY2FuIGV4dHJhY3QgdGhpcyBjaGVj
ayBiZWZvcmUgYGZvcl9lYWNoX25ldGAgZm9yIFNXIG1hY3NlYy4uLg0KDQpSZWdhcmRzLA0KICBJ
Z29yDQo=
