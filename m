Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC0E0975EC
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 11:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfHUJUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 05:20:11 -0400
Received: from mail-eopbgr800084.outbound.protection.outlook.com ([40.107.80.84]:10855
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726463AbfHUJUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 05:20:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQoJDhaaUr1dD2vWtRyi1CctAgB1vmK4fFMI0HXjYj94IrEnmUs6I7nW9S0P9zcVZp/HFT0FP5XKQKSmEI0/6rWu78nEqMyZgRjlXfooONV6nEnYC9ikqyQaVP/8vPOKkyxrKZCmUHV7ZSds4f7QW4dtO7yeDRMAABWr4q3MdZU25SUFSo9Q5u8d1vCY0mpzuVLSNaU4YmemC9hBy/IXBpPmIBwhPFdIjMAGQ6P85F0kG5uuglsqw6PCLRcNDZbFxjvuqNWQk8UhN01wp3kxbPvQFymK2wTTpkxQwOr2lLXhPGu3xOcP/LfH0w7YhV01EW0gxQLWzSPErR4djbRHOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pG+wx42gEn3RgnksMTOkUsmRfSysBCg4r8qTzD4lXxc=;
 b=Tv558NB/730E8FsY9oj+RjewMlyNmwibdNtk5UIi7eW8/Dd3jsOUqVrJ6l4BDZ2dicx6PqpRh2LnQHYz2Kir5kVe6gGuhInq/s5ZyIS9dqVsec4mA5A+pEJqcbGVDWh7DRb6vLnQqVckMQEZmbbm8wVAaI3ubQiVGA2DR/2/rOICfbQgWt9rIuPa6Al0DCkVighSdgLXRTrHIERPnn8vj4V8CgjpVEqazsoPgxAnSe9APuOJ7bkml2yn0ZiO78eDhPktWqTQsNEvCY4xTH8IPvhj55Sr5WIPuPtgjz7zOJIhLcOebmXdVRh+fqffpCerTYEr6R9ScCFOBPDX50JnOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pG+wx42gEn3RgnksMTOkUsmRfSysBCg4r8qTzD4lXxc=;
 b=L3ShqL6lkTgfpCRyiufNhhBiACwFIjyc+jtLvG6wqmHNZeQHOv9Qwc7tk6/I2Ybemvtuer/KpbDWQukwXzqZ89lAdtm6nFHwfFnCrar/H0eciEKZjOtEspvpfhEariCE8RYwXb8cQPwzdRWD/bAf8qPvp4gLtyOUqQaj2jf8Nyc=
Received: from BN6PR11MB4081.namprd11.prod.outlook.com (10.255.128.166) by
 BN6PR11MB1267.namprd11.prod.outlook.com (10.173.26.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Wed, 21 Aug 2019 09:20:05 +0000
Received: from BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::8438:d0c6:4446:68af]) by BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::8438:d0c6:4446:68af%6]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 09:20:05 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
Thread-Index: AQHVT35ck9O2Ca3OL0uT1Xyfcpu+c6b9zmmAgAYPIACAAE4igIABOIaA
Date:   Wed, 21 Aug 2019 09:20:05 +0000
Message-ID: <81ec0497-58cd-1f4c-faa3-c057693cd50e@aquantia.com>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
 <20190813085817.GA3200@kwain> <20190813131706.GE15047@lunn.ch>
 <2e3c2307-d414-a531-26cb-064e05fa01fc@aquantia.com>
 <20190816132959.GC8697@bistromath.localdomain> <20190820100140.GA3292@kwain>
 <20190820144119.GA28714@bistromath.localdomain>
In-Reply-To: <20190820144119.GA28714@bistromath.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR1001CA0013.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:3:f7::23) To BN6PR11MB4081.namprd11.prod.outlook.com
 (2603:10b6:405:78::38)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efcbecdd-c50d-4fe5-f3a1-08d72618c09d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN6PR11MB1267;
x-ms-traffictypediagnostic: BN6PR11MB1267:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB126725CF4C640A433AAD8E9F98AA0@BN6PR11MB1267.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(366004)(136003)(39850400004)(189003)(199004)(52116002)(44832011)(11346002)(446003)(486006)(476003)(2616005)(31696002)(71190400001)(305945005)(7736002)(71200400001)(186003)(66066001)(86362001)(5660300002)(386003)(6506007)(102836004)(26005)(31686004)(6246003)(6486002)(110136005)(36756003)(66946007)(6436002)(107886003)(229853002)(76176011)(478600001)(99286004)(2906002)(54906003)(8936002)(4326008)(3846002)(53936002)(25786009)(6116002)(81156014)(81166006)(8676002)(66476007)(6512007)(64756008)(66556008)(14444005)(316002)(66446008)(256004)(7416002)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1267;H:BN6PR11MB4081.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: H6Qlk8cD59fKtnLfdqICyWYp120BvCR6y2CTsoAfiXvbTWRJLJVhS9i2GjAs7O21oiKnmAPcP6bN7/7Gp+IefisjyaiqXYNE3JhcUtKz8dZPuNPVD7rTs4bR8pFT8DiiD+5SoXdv9qQZ1bD534MvFLBLsdYy2+NwkYVCbjbCgK5LdFK03nmRq/nvNZl7tdYFgRCi8DmKD907chn5xNRd+m5C/U2nxFHJdq18MPrz/E4mFgK3ANG+qllzGeU/d+YS3TjpXdKClFdKWAGsPQ2xeTs9V+purw7Pb5cdYw5fzxGetCEcURsNvnDEvMORvpTMm/qu6dPlVh0l0eeLHbqR0k9J2UzBIPB6fSiNmORo93b5Qdm+7zOcdrhf0kTHPJclu44nvybyE958nYsdUxJ19GQ62aRZFGQI2U+9Co5b3vU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9AD6B3AAB827434B9241AE50CDDA861C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efcbecdd-c50d-4fe5-f3a1-08d72618c09d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 09:20:05.0451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yy7Kdn8J4PUYzLGCWStR4BKziYMLDak0z8gNBxRQUYfM3t8PL1y7USlTndggorOlscut0t/GdldSIrnAE5ig8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1267
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IA0KPiBUYWxraW5nIGFib3V0IHBhY2tldCBudW1iZXJzLCBjYW4geW91IGRlc2NyaWJlIGhv
dyBQTiBleGhhdXN0aW9uIGlzDQo+IGhhbmRsZWQ/ICBJIGNvdWxkbid0IGZpbmQgbXVjaCBhYm91
dCBwYWNrZXQgbnVtYmVycyBhdCBhbGwgaW4gdGhlDQo+IGRyaXZlciBwYXRjaGVzIChJIGhvcGUg
dGhlIGh3IGRvZXNuJ3Qgd3JhcCBhcm91bmQgZnJvbSAyXjMyLTEgdG8gMCBvbg0KPiB0aGUgc2Ft
ZSBTQSkuICBBdCBzb21lIHBvaW50IHVzZXJzcGFjZSBuZWVkcyB0byBrbm93IHRoYXQgd2UncmUN
Cj4gZ2V0dGluZyBjbG9zZSB0byAyXjMyIGFuZCB0aGF0IGl0J3MgdGltZSB0byByZS1rZXkuICBT
aW5jZSB0aGUgd2hvbGUNCj4gVFggcGF0aCBvZiB0aGUgc29mdHdhcmUgaW1wbGVtZW50YXRpb24g
aXMgYnlwYXNzZWQsIGl0IGxvb2tzIGxpa2UgdGhlDQo+IFBOIChhcyBmYXIgYXMgZHJpdmVycy9u
ZXQvbWFjc2VjLmMgaXMgY29uY2VybmVkKSBuZXZlciBpbmNyZWFzZXMsIHNvDQo+IHVzZXJzcGFj
ZSBjYW4ndCBrbm93IHdoZW4gdG8gbmVnb3RpYXRlIGEgbmV3IFNBLg0KDQpJIHRoaW5rIHRoZXJl
IHNob3VsZCBiZSBkcml2ZXIgc3BlY2lmaWMgaW1wbGVtZW50YXRpb24gb2YgdGhpcyBmdW5jdGlv
bmFsaXR5Lg0KQXMgYW4gZXhhbXBsZSwgb3VyIG1hY3NlYyBIVyBpc3N1ZXMgYW4gaW50ZXJydXB0
IHRvd2FyZHMgdGhlIGhvc3QgdG8gaW5kaWNhdGUNClBOIHRocmVzaG9sZCBoYXMgcmVhY2hlZCBh
bmQgaXQncyB0aW1lIGZvciB1c2Vyc3BhY2UgdG8gY2hhbmdlIHRoZSBrZXlzLg0KDQpJbiBjb250
cmFzdCwgY3VycmVudCBTVyBtYWNzZWMgaW1wbGVtZW50YXRpb24ganVzdCBzdG9wcyB0aGlzIFNB
L3NlY3kuDQoNCj4gSSBkb24ndCBzZWUgaG93IHRoaXMgaW1wbGVtZW50YXRpb24gaGFuZGxlcyBu
b24tbWFjc2VjIHRyYWZmaWMgKG9uIFRYLA0KPiB0aGF0IHdvdWxkIGJlIHBhY2tldHMgc2VudCBk
aXJlY3RseSB0aHJvdWdoIHRoZSByZWFsIGludGVyZmFjZSwgZm9yDQo+IGV4YW1wbGUgYnkgd3Bh
X3N1cHBsaWNhbnQgLSBvbiBSWCwgaW5jb21pbmcgTUtBIHRyYWZmaWMgZm9yDQo+IHdwYV9zdXBw
bGljYW50KS4gVW5sZXNzIEkgbWlzc2VkIHNvbWV0aGluZywgaW5jb21pbmcgTUtBIHRyYWZmaWMg
d2lsbA0KPiBlbmQgdXAgb24gdGhlIG1hY3NlYyBpbnRlcmZhY2UgYXMgd2VsbCBhcyB0aGUgbG93
ZXIgaW50ZXJmYWNlIChub3QNCj4gZW50aXJlbHkgY3JpdGljYWwsIGFzIGxvbmcgYXMgd3BhX3N1
cHBsaWNhbnQgY2FuIGdyYWIgaXQgb24gdGhlIGxvd2VyDQo+IGRldmljZSwgYnV0IG5vdCBjb25z
aXN0ZW50IHdpdGggdGhlIHNvZnR3YXJlIGltcGxlbWVudGF0aW9uKS4gSG93IGRvZXMNCj4gdGhl
IGRyaXZlciBkaXN0aW5ndWlzaCB0cmFmZmljIHRoYXQgc2hvdWxkIHBhc3MgdGhyb3VnaCB1bm1v
ZGlmaWVkDQo+IGZyb20gdHJhZmZpYyB0aGF0IHRoZSBIVyBuZWVkcyB0byBlbmNhcHN1bGF0ZSBh
bmQgZW5jcnlwdD8NCg0KSSBjYW4gY29tbWVudCBvbiBvdXIgSFcgZW5naW5lIC0gd2hlcmUgaXQg
aGFzIHNwZWNpYWwgYnlwYXNzIHJ1bGVzDQpmb3IgY29uZmlndXJlZCBldGhlcnR5cGVzLiBUaGlz
IHdheSBtYWNzZWMgZW5naW5lIHNraXBzIGVuY3J5cHRpb24gb24gVFggYW5kDQpwYXNzZXMgaW4g
UlggdW5lbmNyeXB0ZWQgZm9yIHRoZSBzZWxlY3RlZCBjb250cm9sIHBhY2tldHMuDQoNCkJ1dCB0
aGF0cyB0cnVlLCByZWFsZGV2IGRyaXZlciBpcyBoYXJkIHRvIGRpc3Rpbmd1aXNoIGVuY3J5cHRl
ZC91bmVuY3J5cHRlZA0KcGFja2V0cy4gSW4gY2FzZSByZWFsZGV2IHNob3VsZCBtYWtlIGEgZGVj
aXNpb24gd2hlcmUgdG8gcHV0IFJYIHBhY2tldCwNCml0IG9ubHkgbWF5IGRvIHNvbWUgaGV1cmlz
dGljIChzaW5jZSBhZnRlciBtYWNzZWMgZGVjcmlwdGlvbiBhbGwgdGhlDQptYWNzZWMgcmVsYXRl
ZCBpbmZvIGlzIGRyb3BwZWQuIFRoYXRzIHRydWUgYXQgbGVhc3QgZm9yIG91ciBIVyBpbXBsZW1l
bnRhdGlvbikuDQoNCj4gSWYgeW91IGxvb2sgYXQgSVBzZWMgb2ZmbG9hZGluZywgdGhlIG5ldHdv
cmtpbmcgc3RhY2sgYnVpbGRzIHVwIHRoZQ0KPiBFU1AgaGVhZGVyLCBhbmQgcGFzc2VzIHRoZSB1
bmVuY3J5cHRlZCBkYXRhIGRvd24gdG8gdGhlIGRyaXZlci4gSSdtDQo+IHdvbmRlcmluZyBpZiB0
aGUgc2FtZSB3b3VsZCBiZSBwb3NzaWJsZSB3aXRoIE1BQ3NlYyBvZmZsb2FkaW5nOiB0aGUNCj4g
bWFjc2VjIHZpcnR1YWwgaW50ZXJmYWNlIGFkZHMgdGhlIGhlYWRlciAoYW5kIG1heWJlIGEgZHVt
bXkgSUNWKSwgYW5kDQo+IHRoZW4gdGhlIEhXIGRvZXMgdGhlIGVuY3J5cHRpb24uIEluIGNhc2Ug
b2YgSFcgdGhhdCBuZWVkcyB0byBhZGQgdGhlDQo+IHNlY3RhZyBpdHNlbGYsIHRoZSBkcml2ZXIg
d291bGQgZmlyc3Qgc3RyaXAgdGhlIGhlYWRlcnMgdGhhdCB0aGUgc3RhY2sNCj4gY3JlYXRlZC4g
T24gcmVjZWl2ZSwgdGhlIGRyaXZlciB3b3VsZCByZWNyZWF0ZSBhIHNlY3RhZyBhbmQgdGhlIG1h
Y3NlYw0KPiBpbnRlcmZhY2Ugd291bGQganVzdCBza2lwIGFsbCB2ZXJpZmljYXRpb24gKGRlY3J5
cHQsIFBOKS4NCg0KSSBkb24ndCB0aGluayB0aGlzIHdheSBpcyBnb29kLCBhcyBkcml2ZXIgaGF2
ZSB0byBkbyBwZXIgcGFja2V0IGhlYWRlciBtYW5nbGluZy4NClRoYXQnbGwgaGFybSBsaW5lcmF0
ZSBwZXJmb3JtYW5jZSBoZWF2aWx5Lg0KDQpSZWdhcmRzLA0KICAgSWdvcg0K
