Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 263D5978B7
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 14:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfHUMBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 08:01:06 -0400
Received: from mail-eopbgr810049.outbound.protection.outlook.com ([40.107.81.49]:16736
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726227AbfHUMBG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 08:01:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gz8StTeQU7TojONewXDNI42X7xAGgjbv5LkDYd4oh7PB3QpOV7QFcU/25CBYNisSOR4aHEptjb5rsCQ/pYIzk8KUAZbuO/ssxud0vgN//gJ6A7wU+v8GUuZju07kBEwhpUHp/vBR9ye7Q+pi10Dq+3yaJ0bs916KYhXUtuvrAXwbG+1f1nDpsDHkjwo1XoPCjVpieFwvvOrljLIdBKdXuBtY/x2JHL1EkQbMjmkHgi+JrOK6Qkyj56jQrCiFl92HILcRYsP/yWkKzaPBBqYTw96fTzp4gR7xGb0VOI3OkuSG50AgYlhKY9zDaqgYoPGbzVfxMUuxWz/PBrXCSP/JlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9YYzUq6r20rFisbCM57qD4G28xn1uZYQ+5AaKlpWe8=;
 b=jlzM63y7vcfFO33OeynliH4L54lRj0FgT490G5meUabrwOhvFKfJiWjTqUjPITYfepd0Chgm9Hex2zGJjgj+ZkZn33XH4HlKjoBasSWCbNmZ16QUNXr17axjFiYstqD9E2hy2yYyTUsAg7Epge0BENsPUQxidsZ3YGoMVsRnP+dOXVWVxO4JR5soNAPfu18PItFFsxAvR1CRBu+3GADcQSwXpV0R40lMSKN+Gyv7P/dy4TFrJ6ELRTdwETDc3haUix9OhxgzzZ9R+02rxWuJ1RQHZizrzIImSYUzzG48ID5Yk3Ppz/Kc/oy+VKKGR4Tzgue2GA5Vg00r2BLfqfJrFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9YYzUq6r20rFisbCM57qD4G28xn1uZYQ+5AaKlpWe8=;
 b=DeGWpknXxKyMJ/FtE/dI8ZIvKu9NbAEOfSRa2ObCkvWH3kyp2bCL9mQgeMkBzsMrqjWnOS1sIIX1yRiw5CpztkAkhv9UDw1WWCJtnhdAycXh8vBxDXOjhhjLG2terK69aXRR5cV+Cpo57t0V9ZAE7G5IE7LBYeteCLF+2R7SUI4=
Received: from BN6PR11MB4081.namprd11.prod.outlook.com (10.255.128.166) by
 BN6PR11MB3858.namprd11.prod.outlook.com (10.255.130.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Wed, 21 Aug 2019 12:01:02 +0000
Received: from BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::8438:d0c6:4446:68af]) by BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::8438:d0c6:4446:68af%6]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 12:01:02 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Sabrina Dubroca <sd@queasysnail.net>
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
Thread-Index: AQHVT35ck9O2Ca3OL0uT1Xyfcpu+c6cFb779gAAhbIA=
Date:   Wed, 21 Aug 2019 12:01:02 +0000
Message-ID: <a406fefc-867c-aec3-dc87-4a8a24f3c5dc@aquantia.com>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
 <20190813085817.GA3200@kwain> <20190813131706.GE15047@lunn.ch>
 <2e3c2307-d414-a531-26cb-064e05fa01fc@aquantia.com>
 <20190816132959.GC8697@bistromath.localdomain> <20190820100140.GA3292@kwain>
 <20190820144119.GA28714@bistromath.localdomain> <20190821100106.GA3006@kwain>
In-Reply-To: <20190821100106.GA3006@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0235.eurprd05.prod.outlook.com
 (2603:10a6:3:fb::11) To BN6PR11MB4081.namprd11.prod.outlook.com
 (2603:10b6:405:78::38)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f3fdcf9-d304-43ce-4f26-08d7262f3cc6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB3858;
x-ms-traffictypediagnostic: BN6PR11MB3858:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB3858FE70BAF1FF2AEB46F93F98AA0@BN6PR11MB3858.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(366004)(396003)(376002)(39850400004)(199004)(189003)(186003)(229853002)(6512007)(36756003)(53936002)(2906002)(99286004)(5660300002)(110136005)(6486002)(31686004)(6506007)(386003)(71200400001)(4744005)(71190400001)(8676002)(26005)(7416002)(54906003)(6116002)(3846002)(102836004)(8936002)(81166006)(81156014)(25786009)(31696002)(6436002)(486006)(66066001)(446003)(76176011)(2616005)(256004)(86362001)(476003)(107886003)(6246003)(44832011)(66446008)(66476007)(66556008)(64756008)(316002)(66946007)(11346002)(7736002)(52116002)(14454004)(305945005)(4326008)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB3858;H:BN6PR11MB4081.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wvUp7wbY1WkAX1Hp7OMr7XTa/bTTz+Q7ZmWYiBm+nDdLpYC8MBW3m3S8HBFVsd7XOWiwvmrRJTBENBhIPvjx/9Mj/jiYZvYbeidynqmiyGZaWIukAbD02jRGxuO+4ksgJpoODX8108Br/7ptN0sgx+AaQD23BwR6cNGmF/cwqUVbmrcch2oIu3V7Y/W4KycaMVVWGjPpmi/IOHR2Ohywr2gfRvRwtek0REGzfG5J7NBG8U2znH6P71n7jPSurClnr3PF05/gl1qUdrkYYB1Ivh0HE2pBrKq3c8NgS5unQfwviW0oTOPSce7iM5d8MFE7g++DrGbcfl7tw0/2R1aKwuMuynUdel1e4rHnaShTwwPCWUq/nhF9ejgL8lOqFVwy4NExrwgVHsuLzztKfkJEpw17HblqrayyFvXe4Ujr5xI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E952A0BE59EE7B409A0DD4CB5EE0878C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f3fdcf9-d304-43ce-4f26-08d7262f3cc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 12:01:02.3640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MHytujwfspZ1Rr2K5zEZWRK0CWrWuqR3objF9KGBRpjw2aX+o494MeFPZurre7AGuntoS6lL1Ih2CSaqWJXNwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3858
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IFJpZ2h0LiBJIGRpZCBub3Qgc2VlIGhvdyAqbm90KiB0byBzdHJpcCB0aGUgc2VjdGFnIGlu
IHRoZSBoL3cgYmFjayB0aGVuLA0KPiBJJ2xsIGhhdmUgYW5vdGhlciBsb29rIGJlY2F1c2UgdGhh
dCB3b3VsZCBpbXByb3ZlIHRoaW5ncyBhIGxvdC4NCj4gDQo+IEBhbGw6IGRvIG90aGVyIE1BQ3Nl
YyBvZmZsb2FkaW5nIGhhcmR3YXJlIGFsbG93IG5vdCB0byBzdGlwIHRoZSBzZWN0YWc/DQoNCkkn
dmUganVzdCBjaGVja2VkIHRoaXMsIGFuZCBzZWUgYW4gYWN0aW9uIG9wdGlvbiBpbiBvdXIgSFcg
Y2xhc3NpZmllciB0byBrZWVwDQptYWNzZWMgaGVhZGVyIHdpdGggb3B0aW9uYWwgZXJyb3IgaW5m
b3JtYXRpb24gYWRkZWQuIEJ1dCB3ZSd2ZSBuZXZlcg0KZXhwZXJpbWVudGVkIGNvbmZpZ3VyaW5n
IHRoaXMgaG9uZXN0bHksIEkgZG9uJ3QgdGhpbmsgd2Ugc2hvdWxkIHJlbHkgaW4gZ2VuZXJhbA0K
ZGVzaWduIHRoYXQgc3VjaCBhIGZlYXR1cmUgaXMgd2lkZWx5IGF2YWlsYWJsZSBpbiBIVy4NCg0K
UmVnYXJkcywNCiAgSWdvcg0K
