Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 728ED88B4F
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 14:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbfHJMTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 08:19:41 -0400
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:41696
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725862AbfHJMTk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 08:19:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QevZvSyQUaRjQ9CCVYvs1zsX2G6t+/Jf8lGDkjRDnqkmbjFISlmJZGcelutz6fV82gBXfsr8GTSdaCzGfMyOY2iNcAeYOs5xqY5giUKZBUvqjQirCC7lqBb/oJ/309yw9pZwuwg0JsDl5wTwVRinXQoMc7YwVwpeP1z+vtC3kOEWOEkLCsGdvYLBUXYlG1Q5bRm6CQbRTrqabBVXFMi1uaQi/vUbmHdOQEl4yX1gNRr9FFpDbvH/++RLGLGvRDjXN11omiS99ePWqwgsbfUykDiYWTKtWMBbBgRJQZpi8sSnJd6Ua/MMr9tw7lTivhHcqzYF8wh3px3aFb1c5nUuaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NrqUq2hA2iavuzbEZyIn9Ths0MJwHaE9VfP1Pjika6Y=;
 b=LFZqSY3DQ2LwSMNxolroJcYbulEjtE3aM3wsEnBB0dpyQLdBxt5iQB5kXK8jE7dO66k5c8UqH87uHYIwTscBHdOxwHvSzzFq6SdZ9Cpt/ouluyFqrG21HB+IiautTG1EKycc7iT4o8nosb1+YODRr9Bquvt/KPwvedNs0vfxgPCdao8RD5VMZS79TtdSpX1d+heLW24ofiVfatGsOeVg8VCLbTwVBvbtx8YtHBK0CnmCYE86/6ZjuJvVbGmfby4d+xg/XhF0jZ1glIS8zzu6z+jGjKA7dGxqp+0ngaE5exN8CnJei47N41Zo6DMzmzvD50A6U4sCGascXIXx1L1O3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=aquantia.com;dmarc=pass action=none
 header.from=aquantia.com;dkim=pass header.d=aquantia.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NrqUq2hA2iavuzbEZyIn9Ths0MJwHaE9VfP1Pjika6Y=;
 b=kxQ5hKIiV2xyk9fxcIsd1CE5+e7S2DhuthpqymJBiIMokK0SNZiSjpL50DNF9RGa7yIcoLAE34AgPA2lp/RVG0eZZa8Ocwf6eICAavXcVsDZuHWDrnyZoB3hLrITx6YkjVP7OC/jDPsTofHn9KTgHgoPISuXrzj1xPg2hDsU5t4=
Received: from BYAPR11MB2902.namprd11.prod.outlook.com (20.177.225.222) by
 BYAPR11MB3495.namprd11.prod.outlook.com (20.177.226.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Sat, 10 Aug 2019 12:19:36 +0000
Received: from BYAPR11MB2902.namprd11.prod.outlook.com
 ([fe80::456b:e2ae:2452:5e4]) by BYAPR11MB2902.namprd11.prod.outlook.com
 ([fe80::456b:e2ae:2452:5e4%7]) with mapi id 15.20.2157.020; Sat, 10 Aug 2019
 12:19:36 +0000
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
Subject: Re: [PATCH net-next v2 2/9] net: macsec: move some definitions in a
 dedicated header
Thread-Topic: [PATCH net-next v2 2/9] net: macsec: move some definitions in a
 dedicated header
Thread-Index: AQHVT3XZFGqYdsGcdk29olv9OVfArw==
Date:   Sat, 10 Aug 2019 12:19:36 +0000
Message-ID: <9f65de8e-bf62-f9b0-5aba-69c0f92df1ca@aquantia.com>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-3-antoine.tenart@bootlin.com>
In-Reply-To: <20190808140600.21477-3-antoine.tenart@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0101CA0019.eurprd01.prod.exchangelabs.com
 (2603:10a6:3:77::29) To BYAPR11MB2902.namprd11.prod.outlook.com
 (2603:10b6:a03:89::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56b18b83-486a-4743-01f2-08d71d8d0210
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR11MB3495;
x-ms-traffictypediagnostic: BYAPR11MB3495:
x-microsoft-antispam-prvs: <BYAPR11MB34955AE092F32EF86BB55E5798D10@BYAPR11MB3495.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 012570D5A0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39840400004)(376002)(346002)(366004)(396003)(189003)(199004)(229853002)(7736002)(7416002)(3846002)(305945005)(6486002)(2501003)(14454004)(5660300002)(31686004)(66066001)(6116002)(66446008)(2201001)(66476007)(66556008)(66946007)(64756008)(44832011)(476003)(486006)(102836004)(81166006)(81156014)(11346002)(2616005)(53936002)(446003)(6246003)(107886003)(8676002)(52116002)(4326008)(25786009)(76176011)(6436002)(99286004)(478600001)(8936002)(186003)(26005)(6512007)(6506007)(86362001)(386003)(316002)(36756003)(31696002)(110136005)(14444005)(4744005)(256004)(54906003)(71200400001)(2906002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3495;H:BYAPR11MB2902.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: A9mqcZs9tCiRicgP9QJDw0WBEXunUSZ3lDG3GVIc3qhH3bWDMD0lOaPnVh/LfhzoCeDsclanQQ5ffBvcebicJHjF4yPwMWFrJtScGiEzOpJkZAjfJhkadmFEyBGJ2jjO5z3TL+gHHYZoqkXCfcfn+kNRgr0zohUOD+V2tzsTROBDfQtUSROIfQJG7Wi9uWxokOIy1bdwwjmzdSLIOnjZH3VGDsqaey9rh6ll1Fy06f6hKciIQJ4KHvT3XTfdxd2WZ5bvygc97la1tkVqFg5vOgzBNguhjjbb5Up38APzi6mrk712wB+QgKFWrknCXeaQnDPSct8AC5a/AZPLx5Cy0ospIrqZdkKZqjGyAaRYSTzMlT7+O5E6EtQdEFQ95GE2Hqpin+tQPwQyEkYX8OffB8g1gkMoaGxWBn1p2uPpq/8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <012AFB20D7964A418A07DAE3483531A6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b18b83-486a-4743-01f2-08d71d8d0210
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2019 12:19:36.1210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FJ3Sm2TvXSndZZqEUokTOCx94VO1FbGMBphOnWkjb8m+EbzEMn5Qf8fKcFDgbmTD7+fz4DnyUIUJ1X6KWl5cNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3495
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBBbnRvaW5lLA0KDQpPdmVyYWxsIGdvb2QgbG9va2luZyBwYXRjaHNldCwgZ3JlYXQhDQoN
Cj4gKy8qKg0KPiArICogc3RydWN0IG1hY3NlY190eF9zYSAtIHRyYW5zbWl0IHNlY3VyZSBhc3Nv
Y2lhdGlvbg0KPiArICogQGFjdGl2ZToNCj4gKyAqIEBuZXh0X3BuOiBwYWNrZXQgbnVtYmVyIHRv
IHVzZSBmb3IgdGhlIG5leHQgcGFja2V0DQo+ICsgKiBAbG9jazogcHJvdGVjdHMgbmV4dF9wbiBt
YW5pcHVsYXRpb25zDQo+ICsgKiBAa2V5OiBrZXkgc3RydWN0dXJlDQo+ICsgKiBAc3RhdHM6IHBl
ci1TQSBzdGF0cw0KPiArICovDQo+ICtzdHJ1Y3QgbWFjc2VjX3R4X3NhIHsNCj4gKwlzdHJ1Y3Qg
bWFjc2VjX2tleSBrZXk7DQo+ICsJc3BpbmxvY2tfdCBsb2NrOw0KPiArCXUzMiBuZXh0X3BuOw0K
PiArCXJlZmNvdW50X3QgcmVmY250Ow0KPiArCWJvb2wgYWN0aXZlOw0KPiArCWJvb2wgb2ZmbG9h
ZGVkOw0KDQpJIGRvbid0IHNlZSB0aGlzIGBvZmZsb2FkZWRgIGZpZWxkIGJlaW5nIHVzZWQgYW55
d2hlcmUuIElzIHRoaXMgbmVlZGVkPw0KDQpSZWdhcmRzLA0KICBJZ29yDQo=
