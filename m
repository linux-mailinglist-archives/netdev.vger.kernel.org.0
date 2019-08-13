Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78DEF8BE12
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 18:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbfHMQSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 12:18:45 -0400
Received: from mail-eopbgr710075.outbound.protection.outlook.com ([40.107.71.75]:46720
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727332AbfHMQSp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 12:18:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7gID9bDrxnv7Yv2OIZmanbxGi55hDJhPXwSnaRpVHzgeXGxxkXb4t5xLzkWS7JzXLgIfjiuZ3Nz7xm1qU56BfhqmIXpr54jWeEePO5zfZ2Hv1e6bzXqJZSPrQgYckv08hagUjVwCbF15aNylCNF1HoGWTO3dK0pWjMtZB+rgGZqWzQJYK88fhERZHqPmkmZnXVXzcuYogGRTw7FktK4Za7PNMOOVGsAuM8DN829ZPVpGiFkAlEebfO9Uqk6fHcWAHEpzZvoEBaIzAKc/nkP3C9NwLb1kAhbROJf8o0WUlQQCmsCd2MA22ooGh50C9P4YBHgqinAbjnd/37v674GOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkhT2mdmXmdkdW1x3MUkQXzWdYpMXmmHMPZFYwoBQKI=;
 b=QGZz6N9vnAPWcfm0UyWW+SnaX+Y81Q9vwLTjuZRsqCzGMOU4+dlrv3wnxqHGauqgdupGkg5dgZZBeuWvtFtUM9eXiz17FdT0xddjaq8wbBOYWYgB1eRokhfagU7mrLcdYik/JZNS0BMIx+T4gFzK/LmBhbnBs7LYb6FuxmnIgeI5EmJ8qgTREKbH+JNYOjnHlSmjxa5nKREJnXCg8+oq9AImcrUg9jpxwqOEMKDVNOPV5TMXi9TxBsa+BTgIYd1NFKP517HXzrjfEr11ilPrd/wQTGfMgnE995jZX3f7LDEyKZ0qDd9bZgaM6xt8e7ptkqKwfk/OiF1hyruxFMoGsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkhT2mdmXmdkdW1x3MUkQXzWdYpMXmmHMPZFYwoBQKI=;
 b=H9HsH28uDMvgh1yz0UkosShTGSgf339RzHgDcMhGMJcEvpcmc8Di+16poUXss/fuHEllMrOV34jva7FUh+GCAdifpMhIKyfet8ovQFfKGPt9WLZwC0LzkiAdhkcZhF/a0Z497R90VcOex6eJk/h4/Hd5xQr8YsSefIxPmmZs3kQ=
Received: from BL0PR11MB2899.namprd11.prod.outlook.com (20.177.206.27) by
 BL0PR11MB2916.namprd11.prod.outlook.com (20.177.146.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Tue, 13 Aug 2019 16:18:40 +0000
Received: from BL0PR11MB2899.namprd11.prod.outlook.com
 ([fe80::ad4a:3191:10f1:bd6d]) by BL0PR11MB2899.namprd11.prod.outlook.com
 ([fe80::ad4a:3191:10f1:bd6d%6]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 16:18:40 +0000
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
        Simon Edelhaus <Simon.Edelhaus@aquantia.com>,
        Pavel Belous <Pavel.Belous@aquantia.com>
Subject: Re: [PATCH net-next v2 6/9] net: macsec: hardware offloading
 infrastructure
Thread-Topic: [PATCH net-next v2 6/9] net: macsec: hardware offloading
 infrastructure
Thread-Index: AQHVT35ck9O2Ca3OL0uT1Xyfcpu+cw==
Date:   Tue, 13 Aug 2019 16:18:40 +0000
Message-ID: <2e3c2307-d414-a531-26cb-064e05fa01fc@aquantia.com>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190808140600.21477-7-antoine.tenart@bootlin.com>
 <e96fa4ae-1f2c-c1be-b2d8-060217d8e151@aquantia.com>
 <20190813085817.GA3200@kwain> <20190813131706.GE15047@lunn.ch>
In-Reply-To: <20190813131706.GE15047@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0144.eurprd05.prod.outlook.com
 (2603:10a6:7:28::31) To BL0PR11MB2899.namprd11.prod.outlook.com
 (2603:10b6:208:30::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34fd5b3a-c8c7-4f41-91b3-08d72009e763
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BL0PR11MB2916;
x-ms-traffictypediagnostic: BL0PR11MB2916:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR11MB291696C0FBDCA0EC9B4BEED298D20@BL0PR11MB2916.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39840400004)(396003)(366004)(346002)(136003)(376002)(189003)(199004)(54906003)(110136005)(6486002)(66946007)(305945005)(66446008)(64756008)(66556008)(66476007)(5660300002)(7736002)(316002)(11346002)(6436002)(229853002)(486006)(25786009)(476003)(31686004)(86362001)(446003)(66066001)(2616005)(6116002)(71190400001)(71200400001)(3846002)(386003)(2906002)(36756003)(6512007)(99286004)(76176011)(102836004)(7416002)(31696002)(6506007)(53546011)(52116002)(256004)(81166006)(81156014)(26005)(186003)(44832011)(14454004)(4326008)(53936002)(6246003)(8936002)(478600001)(107886003)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR11MB2916;H:BL0PR11MB2899.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JDJMq8fqOBeSGg6Q/GDfpE1rZ4aFdziyrZyDBV7Wv2ELiPJ0F3m6Kn+qIydIA4aoN/8Ew/ILDLU/HPlvZJy6wz35+dqXJ+fQMk7w8Jhm332YBl38rWmdD6J9veBMcyB6EFInYKDnb8QkrJnxitLvehyGXzjzE6x46Sb9ZXs00vc5pOwTWvTuSeLrB+kFqQHHhMuQ6gp74ccKgLHg+mBQ2Fglchj4LuB7+6hOIAl70d4v83h5CJwKOR6VX4v135UcX2AeukIonn3rAz6PBtoWDIK2l+PqpVxcVQx93nPQgVglWetXNEaSe5Ny+RqnDCfHdywMhR7nTRTiEZDSQA+VbModMECLC1U0Hfr6kUZt/YiBzpD0ykMgdInqDF/znyAm1VCw+bgIw3YCRlabvVQs3XWEdeVUZbpGjZ+HnKFt5Xs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05D35883C79C9643929E4EC077BB2A7B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34fd5b3a-c8c7-4f41-91b3-08d72009e763
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 16:18:40.6340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h22sLwiyJs0Os2BP6ep55/UNC5dGVEUFvhlWyPLQRipOO9czaZAxrtg2glmo/Q9FuQlvX+eeodVrdqn4sucP3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB2916
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEzLjA4LjIwMTkgMTY6MTcsIEFuZHJldyBMdW5uIHdyb3RlOg0KPiBPbiBUdWUsIEF1
ZyAxMywgMjAxOSBhdCAxMDo1ODoxN0FNICswMjAwLCBBbnRvaW5lIFRlbmFydCB3cm90ZToNCj4+
IEkgdGhpbmsgdGhpcyBxdWVzdGlvbiBpcyBsaW5rZWQgdG8gdGhlIHVzZSBvZiBhIE1BQ3NlYyB2
aXJ0dWFsIGludGVyZmFjZQ0KPj4gd2hlbiB1c2luZyBoL3cgb2ZmbG9hZGluZy4gVGhlIHN0YXJ0
aW5nIHBvaW50IGZvciBtZSB3YXMgdGhhdCBJIHdhbnRlZA0KPj4gdG8gcmV1c2UgdGhlIGRhdGEg
c3RydWN0dXJlcyBhbmQgdGhlIEFQSSBleHBvc2VkIHRvIHRoZSB1c2Vyc3BhY2UgYnkgdGhlDQo+
PiBzL3cgaW1wbGVtZW50YXRpb24gb2YgTUFDc2VjLiBJIHRoZW4gaGFkIHR3byBjaG9pY2VzOiBr
ZWVwaW5nIHRoZSBleGFjdA0KPj4gc2FtZSBpbnRlcmZhY2UgZm9yIHRoZSB1c2VyIChoYXZpbmcg
YSB2aXJ0dWFsIE1BQ3NlYyBpbnRlcmZhY2UpLCBvcg0KPj4gcmVnaXN0ZXJpbmcgdGhlIE1BQ3Nl
YyBnZW5sIG9wcyBvbnRvIHRoZSByZWFsIG5ldCBkZXZpY2VzIChhbmQgbWFraW5nDQo+PiB0aGUg
cy93IGltcGxlbWVudGF0aW9uIGEgdmlydHVhbCBuZXQgZGV2IGFuZCBhIHByb3ZpZGVyIG9mIHRo
ZSBNQUNzZWMNCj4+ICJvZmZsb2FkaW5nIiBvcHMpLg0KPj4NCj4+IFRoZSBhZHZhbnRhZ2VzIG9m
IHRoZSBmaXJzdCBvcHRpb24gd2VyZSB0aGF0IG5lYXJseSBhbGwgdGhlIGxvZ2ljIG9mIHRoZQ0K
Pj4gcy93IGltcGxlbWVudGF0aW9uIGNvdWxkIGJlIGtlcHQgYW5kIGVzcGVjaWFsbHkgdGhhdCBp
dCB3b3VsZCBiZQ0KPj4gdHJhbnNwYXJlbnQgZm9yIHRoZSB1c2VyIHRvIHVzZSBib3RoIGltcGxl
bWVudGF0aW9ucyBvZiBNQUNzZWMuDQo+IA0KPiBIaSBBbnRvaW5lDQo+IA0KPiBXZSBoYXZlIGFs
d2F5cyB0YWxrZWQgYWJvdXQgb2ZmbG9hZGluZyBvcGVyYXRpb25zIHRvIHRoZSBoYXJkd2FyZSwN
Cj4gYWNjZWxlcmF0aW5nIHdoYXQgdGhlIGxpbnV4IHN0YWNrIGNhbiBkbyBieSBtYWtpbmcgdXNl
IG9mIGhhcmR3YXJlDQo+IGFjY2VsZXJhdG9ycy4gVGhlIGJhc2ljIHVzZXIgQVBJIHNob3VsZCBu
b3QgY2hhbmdlIGJlY2F1c2Ugb2YNCj4gYWNjZWxlcmF0aW9uLiBUaG9zZSBhcmUgdGhlIGdlbmVy
YWwgZ3VpZGVsaW5lcy4NCj4gDQo+IEl0IHdvdWxkIGhvd2V2ZXIgYmUgaW50ZXJlc3RpbmcgdG8g
Z2V0IGNvbW1lbnRzIGZyb20gdGhvc2Ugd2hvIGRpZCB0aGUNCj4gc29mdHdhcmUgaW1wbGVtZW50
YXRpb24gYW5kIHdoYXQgdGhleSB0aGluayBvZiB0aGlzIGFyY2hpdGVjdHVyZS4gSSd2ZQ0KPiBu
byBwZXJzb25hbCBleHBlcmllbmNlIHdpdGggTUFDU2VjLCBzbyBpdCBpcyBoYXJkIGZvciBtZSB0
byBzYXkgaWYgdGhlDQo+IGN1cnJlbnQgYXJjaGl0ZWN0dXJlIG1ha2VzIHNlbnNlIHdoZW4gdXNp
bmcgYWNjZWxlcmF0b3JzLg0KDQpJbiB0ZXJtcyBvZiBvdmVyYWxsIGNvbmNlcHRzLCBJJ2QgYWRk
IHRoZSBmb2xsb3dpbmc6DQoNCjEpIFdpdGggY3VycmVudCBpbXBsZW1lbnRhdGlvbiBpdCdzIGlt
cG9zc2libGUgdG8gaW5zdGFsbCBTVyBtYWNzZWMgZW5naW5lIG9udG8NCnRoZSBkZXZpY2Ugd2hp
Y2ggc3VwcG9ydHMgSFcgb2ZmbG9hZC4gVGhhdCBjb3VsZCBiZSBhIHN0cm9uZyBsaW1pdGF0aW9u
IGluDQpjYXNlcyB3aGVuIHVzZXIgc2VlcyBIVyBtYWNzZWMgb2ZmbG9hZCBpcyBicm9rZW4gb3Ig
d29yayBkaWZmZXJlbnRseSwgYW5kIGhlL3NoZQ0Kd2FudHMgdG8gcmVwbGFjZSBpdCB3aXRoIFNX
IG9uZS4NCk1BQ1NlYyBpcyBhIGNvbXBsZXggZmVhdHVyZSwgYW5kIGl0IG1heSBoYXBwZW4gc29t
ZXRoaW5nIGlzIG1pc3NpbmcgaW4gSFcuDQpUcml2aWFsIGV4YW1wbGUgaXMgMjU2Yml0IGVuY3J5
cHRpb24sIHdoaWNoIGlzIG5vdCBhbHdheXMgYSBtdXN0aGF2ZSBpbiBIVw0KaW1wbGVtZW50YXRp
b25zLg0KDQoyKSBJIHRoaW5rLCBBbnRvaW5lLCBpdHMgbm90IHRvdGFsbHkgdHJ1ZSB0aGF0IG90
aGVyd2lzZSB0aGUgdXNlciBtYWNzZWMgQVBJDQp3aWxsIGJlIGJyb2tlbi9jaGFuZ2VkLiBuZXRs
aW5rIGFwaSBpcyB0aGUgc2FtZSwgdGhlIG9ubHkgdGhpbmcgd2UgbWF5IHdhbnQgdG8NCmFkZCBp
cyBhbiBvcHRpb25hbCBwYXJhbWV0ZXIgdG8gZm9yY2Ugc2VsZWN0aW9uIG9mIFNXIG1hY3NlYyBl
bmdpbmUuDQoNCkknbSBhbHNvIGVhZ2VyIHRvIGhlYXIgZnJvbSBzdyBtYWNzZWMgdXNlcnMvZGV2
cyBvbiB3aGF0cyBiZXR0ZXIgaGVyZS4NCg0KDQpSZWdhcmRzLA0KICBJZ29yDQoNCg==
