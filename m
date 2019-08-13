Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2CB8B771
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 13:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfHMLq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 07:46:57 -0400
Received: from mail-eopbgr690081.outbound.protection.outlook.com ([40.107.69.81]:9105
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726600AbfHMLq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 07:46:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXgnFMJ4OEcflYRlfvL1viFVGXeMGamjdSZeaqpIga3a5G4qZtdt8fV4rsy8x0XzD55bB84BFvwr8CBOlErI2SdS7Z/cXytpM+JNksw31iyCbAAztKlKr5azoCIhd4c+Rxow6qjFaovCVxJo6miS0SXu11mfAwnQXhdhuhizG5IvCf7yt68+YJddDG7EcrHDzTK5emMIuxTIJ7hG1BI++ZQwvNSzQ14O/ti4k6G3gW/KT5KfZrGI9/v0rtGOPPRxNWkiWKDm7yAh/Z0XCd4nErQd5zMIkebsaLmwkl6G+FKmUyLAB3cYSacVENDJrHqymy3SNKR8e0h3gnW3ZnIowQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prGn0lXo4wrdG8JFkSfg5HQWfYdUM//wr5fnfefu6jA=;
 b=aL1oVA4Ye5ZfLwQk6hEso/JbAiT6cnWzUzstI123f34QwN7nhVOKJPH6cEQKpmq55yNzUXCrkDJxu1vppaKIrFmNG8gKs0lscsFW+oIpeaGfVqDjnlt4np85yZ4YWCgsysVvR+arOLpRNH9SHtCNOtyhB8p+PwgaXeepL0vM1zswI+pEPSVCLSDCeAXHkRSgdxyiowVL6qtdY62zh8ttYf7FK3faUWFzhaTQUlMMismoa4eyyJ2b0+wneBDCge8jgdkHDw3e7k2c2Cli/P3U8VM2JAMLx+Hy1DPTLXRC0Pb3ygQXQGPUhKTvc+/9AA/qEfXhn1ZKNW03iXVskVMhBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prGn0lXo4wrdG8JFkSfg5HQWfYdUM//wr5fnfefu6jA=;
 b=ZTHlDgel8E8nfMjda6BHFZyGwIJG/jAWt9Z/MdLqiAJQ8FNp5tVxAwEMlqnwG8aQeFdQjRMNO+ceT81VAIJAaxDny1Nwtd4d1XkaH8fKGDHu47XxXaK3cgZWHOQLAJQLQduNQVzcIqgh2rn7JFiKmk2i/DyLFydaY3ZbihjlKDY=
Received: from BL0PR11MB2899.namprd11.prod.outlook.com (20.177.206.27) by
 BL0PR11MB3153.namprd11.prod.outlook.com (10.167.235.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.23; Tue, 13 Aug 2019 11:46:40 +0000
Received: from BL0PR11MB2899.namprd11.prod.outlook.com
 ([fe80::ad4a:3191:10f1:bd6d]) by BL0PR11MB2899.namprd11.prod.outlook.com
 ([fe80::ad4a:3191:10f1:bd6d%6]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 11:46:40 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Antoine Tenart <antoine.tenart@bootlin.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "camelia.groza@nxp.com" <camelia.groza@nxp.com>,
        Simon Edelhaus <Simon.Edelhaus@aquantia.com>
Subject: Re: [PATCH net-next v2 6/9] net: macsec: hardware offloading
 infrastructure
Thread-Topic: [PATCH net-next v2 6/9] net: macsec: hardware offloading
 infrastructure
Thread-Index: AQHVUczAk9O2Ca3OL0uT1Xyfcpu+cw==
Date:   Tue, 13 Aug 2019 11:46:40 +0000
Message-ID: <44663b69-6f37-ea38-0347-9408984cf3f8@aquantia.com>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <20190810163423.GA30120@lunn.ch>
In-Reply-To: <20190810163423.GA30120@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P189CA0034.EURP189.PROD.OUTLOOK.COM (2603:10a6:7:53::47)
 To BL0PR11MB2899.namprd11.prod.outlook.com (2603:10b6:208:30::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c46b054e-2b97-47fe-2151-08d71fe3e785
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BL0PR11MB3153;
x-ms-traffictypediagnostic: BL0PR11MB3153:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR11MB315386BF67D323576336EC4598D20@BL0PR11MB3153.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(39850400004)(396003)(366004)(376002)(199004)(189003)(81166006)(6436002)(6512007)(6486002)(229853002)(305945005)(8676002)(81156014)(6116002)(7736002)(25786009)(4326008)(2906002)(7416002)(5660300002)(14454004)(6246003)(107886003)(53936002)(71190400001)(256004)(31686004)(44832011)(71200400001)(99286004)(11346002)(486006)(476003)(2616005)(446003)(386003)(54906003)(53546011)(76176011)(110136005)(316002)(478600001)(66946007)(3846002)(66476007)(66446008)(64756008)(36756003)(66556008)(86362001)(66066001)(31696002)(102836004)(186003)(52116002)(8936002)(6506007)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR11MB3153;H:BL0PR11MB2899.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mkixBMjcu8DszuBDmQDbYQ7uSNrPEObSYnOtCdFds+g0ueNx6Nf++iqAZss4ZIQFvFDUvqgszx7TnRothgCvE2dq6GFrP/mNhzrd5ZyKhWX6vafeYkRFZFc/l/dViu9/4WFJx0R1cbUzt7SqX/dO+EvmJMYbkyfR3Uludm/armse6FFQM3cWxrn73JdmjCyG8ziR8YHLf1W34BVF4dWlt5t0b6/wywnFFMEKtNbM3L8WmrzO+y1/0rAZxXAbx0mOfhbc8pJ2q3cRIvGCRacbgWX7iquCmPaWhUCv/Qf0FEyN+LTwPyW+0TgXiLMxIxa4+W1W7TBrx7vAk4blgGlj0NwIkqAkZAEeT+zjjnRzgzL/mp5Iq2QzVXiQMXJqFH+3R/BWwVXaDrZBNhAWf53GUcvHecTGZpJF3h8Y6aWiuCE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <83E55DCDCA73F64B84C850F644888B9D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c46b054e-2b97-47fe-2151-08d71fe3e785
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 11:46:40.0772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iIPWTwpu308yrvGE5qAMau6mEjgeORlHQf37BnyBjSqChG6q9H0YBzfo3cCvTpzFruyeUKk47XsA2/fgtIG/LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLjA4LjIwMTkgMTk6MzQsIEFuZHJldyBMdW5uIHdyb3RlOg0KPiBPbiBUaHUsIEF1
ZyAwOCwgMjAxOSBhdCAwNDowNTo1N1BNICswMjAwLCBBbnRvaW5lIFRlbmFydCB3cm90ZToNCg0K
Pj4gVGhlIE1BQ3NlYyBjb25maWd1cmF0aW9uIGlzIHBhc3NlZCB0byBkZXZpY2UgZHJpdmVycyBz
dXBwb3J0aW5nIGl0DQo+PiB0aHJvdWdoIG1hY3NlY19od19vZmZsb2FkKCkgd2hpY2ggaXMgY2Fs
bGVkIGZyb20gdGhlIE1BQ3NlYyBnZW5sDQo+PiBoZWxwZXJzLiBUaGlzIGZ1bmN0aW9uIGNhbGxz
IHRoZSBtYWNzZWMgb3BzIG9mIFBIWSBhbmQgRXRoZXJuZXQNCj4+IGRyaXZlcnMgaW4gdHdvIHN0
ZXBzDQo+IA0KPiBIaSBBbnRvaW5lLCBJZ29yDQo+IA0KPiBJdCBpcyBncmVhdCB0aGF0IHlvdSBh
cmUgdGhpbmtpbmcgaG93IGEgTUFDIGRyaXZlciB3b3VsZCBtYWtlIHVzZSBvZg0KPiB0aGlzLiBC
dXQgb24gdGhlIGZsaXAgc2lkZSwgd2UgZG9uJ3QgdXN1YWwgYWRkIGFuIEFQSSB1bmxlc3MgdGhl
cmUgaXMNCj4gYSB1c2VyLiBBbmQgYXMgZmFyIGFzIGkgc2VlLCB5b3Ugb25seSBhZGQgYSBQSFkg
bGV2ZWwgaW1wbGVtZW50YXRpb24sDQo+IG5vdCBhIE1BQyBsZXZlbC4NCj4gDQo+IElnb3IsIHdo
YXQgaXMgeW91ciBpbnRlcmVzdCBoZXJlPyBJIGtub3cgdGhlIEFxdWFudGlhIFBIWSBjYW4gZG8N
Cj4gTUFDc2VjLCBidXQgaSBndWVzcyB5b3UgYXJlIG1vcmUgaW50ZXJlc3RlZCBpbiB0aGUgYXRs
YW50aWMgYW5kIEFRQzExMQ0KPiBNQUMgZHJpdmVycyB3aGljaCBoaWRlIHRoZSBQSFkgYmVoaW5k
IGZpcm13YXJlIHJhdGhlciB0aGFuIG1ha2UgdXNlIG9mDQo+IHRoZSBMaW51eCBhcXVhbnRpYSBQ
SFkgZHJpdmVyLiBBcmUgeW91IGxpa2VseSB0byBiZSBjb250cmlidXRpbmcgYSBNQUMNCj4gZHJp
dmVyIGxldmVsIGltcGxlbWVudGF0aW9uIG9mIE1BQ3NlYyBzb29uPw0KDQpIaSBBbmRyZXcsDQoN
Clllcywgd2UgYXJlIGludGVyZXN0ZWQgaW4gTUFDIGxldmVsIE1BQ1NlYyBvZmZsb2FkIGltcGxl
bWVudGF0aW9uLg0KQWx0aG91Z2ggaW4gb3VyIHNvbHV0aW9uIG1hY3NlYyBlbmdpbmUgaXRzZWxm
IGlzIGluIFBoeSwgd2UgZG8NCmFjdGl2ZWx5IHVzZSBmaXJtd2FyZSBzdXBwb3J0IGluIGFyZWFz
IG9mIGNvbmZpZ3VyYXRpb24sIGludGVycnVwdCBtYW5hZ2VtZW50Lg0KDQpTbyBmcm9tIFNXIHBl
cnNwZWN0aXZlIHRoYXQnbGwgYmUgTUFDIGRyaXZlciBsZXZlbCBtYWNzZWMuDQoNClJlZ2FyZHMs
DQogIElnb3INCg==
