Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBC1B9C02A
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 22:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfHXUiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 16:38:52 -0400
Received: from mail-eopbgr80121.outbound.protection.outlook.com ([40.107.8.121]:44099
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727094AbfHXUiw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 16:38:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hH/aHobA6Sf4M/7coNLbrpReTqME1ovnifPKeNbWlwHKZRP1ALj0kkxKVDg+X0BtFNREW4vmbilJv0ZIzclGyRcNpEvAg6UCZLLNCrN79ad2cPnbabqMQBGpyPMm/bEY3WGnxWyW+tNor39iT0qGmdCVGbOOKB9aMvgRpm7Bmp6hIBbRXUW4VGzjFk4HLknBHUBvSpQuI/2qOw1DCC2cXwvG/FNxqRXUVtBY8j6YduLmZv5zpjGQicGEAWu/vWUdCw+FOP5U7zIzvqrNVvIG7ZkkqPrd+Dr/+vGZ8rsTTb1YEYtmy6CTcsiRaE7GgM7AgNS/nFqjzk19zz/3OyRCjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDLT4K0b4CX5GV/n4TjPiCUf+It8LnuSSJRX5fSuVEg=;
 b=LEWzL3PIWr2tQRQ5w9W/b8KtGA7CUg0+Ml/H5ssEpXwpIYh0DfWvO7MoH4k+WyE17cuvJ0RsGueWdagtcW3dks0G/HbHUOk6W045Wk9swbpuLUnbK6MqqmYCWyuvbf5Z9ej3pYk5uvEuYil7QeFx8t/AyHQz8xRZS+6Yqn3IlL2yDKsBEGSzhHpZZmXErcXpbS3HXMGJNExQH2wFagQ/XuOhx6DXw7d/oXlBFvmANESO5ivVRHu9nVwcvqdxoMd2pr/OalWFtbAU+9c4Ovi+uEBqbF/vJbTjrDTO9oDr+9GNsW86xn/XbPXQde1ZMdo1Hr8Goe00Mg2PXesDzd5SGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDLT4K0b4CX5GV/n4TjPiCUf+It8LnuSSJRX5fSuVEg=;
 b=bc7dnF5vDayNMDlvmN/bueF8je/Iw8TjK17ZsoZcbX6D1Ubfns8MvSGeT7xfP5vOIpzoHlVV21A88qFqUwaMnlOWnOfAMBsoUVa6RsMpYaUyaOr1cYZXuh6E40CpYuA0nf1NogY6/NQA3leIb6/J2DVvyLOF13dI6n4pfYVAcRk=
Received: from DBBPR08MB4250.eurprd08.prod.outlook.com (20.179.40.149) by
 DBBPR08MB4917.eurprd08.prod.outlook.com (20.179.47.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Sat, 24 Aug 2019 20:38:48 +0000
Received: from DBBPR08MB4250.eurprd08.prod.outlook.com
 ([fe80::c1aa:9c2d:d6b8:b0d]) by DBBPR08MB4250.eurprd08.prod.outlook.com
 ([fe80::c1aa:9c2d:d6b8:b0d%7]) with mapi id 15.20.2178.022; Sat, 24 Aug 2019
 20:38:48 +0000
From:   Denis Lunev <den@virtuozzo.com>
To:     David Miller <davem@davemloft.net>,
        Jan Dakinevich <jan.dakinevich@virtuozzo.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "hare@suse.com" <hare@suse.com>,
        "kgraul@linux.ibm.com" <kgraul@linux.ibm.com>,
        "kyeongdon.kim@lge.com" <kyeongdon.kim@lge.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] af_unix: utilize skb's fragment list for sending large
 datagrams
Thread-Topic: [PATCH] af_unix: utilize skb's fragment list for sending large
 datagrams
Thread-Index: AQHVWNXCVy+NB8D6AkS8eOMw9lnGGacHhyOAgAM/CoA=
Date:   Sat, 24 Aug 2019 20:38:48 +0000
Message-ID: <bdf81fa5-c578-a4c0-a7b3-87cbd3ea10cc@virtuozzo.com>
References: <1566470311-4089-1-git-send-email-jan.dakinevich@virtuozzo.com>
 <20190822.120421.71092037400077946.davem@davemloft.net>
In-Reply-To: <20190822.120421.71092037400077946.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR05CA0133.eurprd05.prod.outlook.com
 (2603:10a6:207:3::11) To DBBPR08MB4250.eurprd08.prod.outlook.com
 (2603:10a6:10:c2::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=den@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [87.26.82.92]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e13d3e08-680d-41d3-ff68-08d728d310d6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DBBPR08MB4917;
x-ms-traffictypediagnostic: DBBPR08MB4917:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR08MB4917DA2030035E94925CE56AB6A70@DBBPR08MB4917.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0139052FDB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(366004)(39840400004)(346002)(396003)(199004)(189003)(5660300002)(305945005)(7736002)(71190400001)(71200400001)(66066001)(2906002)(6512007)(86362001)(66476007)(66946007)(6436002)(66446008)(64756008)(3846002)(6116002)(66556008)(31696002)(81156014)(6636002)(14454004)(81166006)(8936002)(8676002)(99286004)(54906003)(76176011)(102836004)(53546011)(52116002)(316002)(7416002)(386003)(6506007)(110136005)(36756003)(446003)(11346002)(2616005)(476003)(486006)(53936002)(26005)(186003)(478600001)(256004)(14444005)(25786009)(4326008)(6486002)(31686004)(6246003)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:DBBPR08MB4917;H:DBBPR08MB4250.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: X0YrnbOteFGR6dtoGTK5ISizXhhc4EurKSufDACYLmGpX1oQkU2MsN3XyFXCnW57Bq7X/gRWgUNIIDH3Dx80oIxjwYwC5QGOvyO51IceqEboUSnuERzmsFfu+8ifCycSTTbKvs37YOo76xYcz5JUGDFgit07SPWijDENu11VPp8cGa1APAlqn7Sxj8hoQ10jlCpqdZLliQScQVkl3nhf6YCqgs84c1Nw9r5bY+9b7i1IeSp/xaONbdvhzDMXnAXwYfW3xaRDsEPpmWPo2ZhzJOuUs77rPQCcI6yb15XKM52RihoWA0i3fXMerAl9nXeeyK/LhattjwMux74wtraaXO8uVJFrfkMO5h340HTcjdmg8kN1PaTNtq6yLWjrGpnzn8KUfQZxpD/XVqJhHK9ExNMvOM37YLJYYAXRheoY/Co=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E1EBF43BA416542980747C787186FDF@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e13d3e08-680d-41d3-ff68-08d728d310d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2019 20:38:48.4279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LnHDXVUOHmZI45iPX+TlkjelBl/2Wke5ugfej3H/K1A2dqxFj6IcJyRpbhO5m84oSO/pN6wYbTzdpO+Y20LIQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4917
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8yMi8xOSA5OjA0IFBNLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+IEZyb206IEphbiBEYWtp
bmV2aWNoIDxqYW4uZGFraW5ldmljaEB2aXJ0dW96em8uY29tPg0KPiBEYXRlOiBUaHUsIDIyIEF1
ZyAyMDE5IDEwOjM4OjM5ICswMDAwDQo+DQo+PiBIb3dldmVyLCBwYWdlZCBwYXJ0IGNhbiBub3Qg
ZXhjZWVkIE1BWF9TS0JfRlJBR1MgKiBQQUdFX1NJWkUsIGFuZCBsYXJnZQ0KPj4gZGF0YWdyYW0g
Y2F1c2VzIGluY3JlYXNpbmcgc2tiJ3MgZGF0YSBidWZmZXIuIFRodXMsIGlmIGFueSB1c2VyLXNw
YWNlDQo+PiBwcm9ncmFtIHNldHMgc2VuZCBidWZmZXIgKGJ5IGNhbGxpbmcgc2V0c29ja29wdChT
T19TTkRCVUYsIC4uLikpIHRvDQo+PiBtYXhpbXVtIGFsbG93ZWQgc2l6ZSAod21lbV9tYXgpIGl0
IGJlY29tZXMgYWJsZSB0byBjYXVzZSBhbnkgYW1vdW50DQo+PiBvZiB1bmNvbnRyb2xsZWQgaGln
aC1vcmRlciBrZXJuZWwgYWxsb2NhdGlvbnMuDQo+IFNvPyAgWW91IHdhbnQgaHVnZSBTS0JzIHlv
dSBnZXQgdGhlIGhpZ2ggb3JkZXIgYWxsb2NhdGlvbnMsIHNlZW1zDQo+IHJhdGhlciByZWFzb25h
YmxlIHRvIG1lLg0KPg0KPiBTS0JzIHVzaW5nIGZyYWdtZW50IGxpc3RzIGFyZSB0aGUgbW9zdCBk
aWZmaWN1bHQgYW5kIGNwdSBpbnRlbnNpdmUNCj4gZ2VvbWV0cnkgZm9yIGFuIFNLQiB0byBoYXZl
IGFuZCB3ZSBzaG91bGQgYXZvaWQgdXNpbmcgaXQgd2hlcmUNCj4gZmVhc2libGUuDQo+DQo+IEkg
ZG9uJ3Qgd2FudCB0byBhcHBseSB0aGlzLCBzb3JyeS4NClVuZGVyIGV2ZW4gbWVkaW9jcmUgbWVt
b3J5IHByZXNzdXJlIHRoaXMgd2lsbCBlaXRoZXIgdGFrZXMgc2Vjb25kcyBvciBmYWlsLA0Kd2hp
Y2ggZG9lcyBub3QgbG9vayBnb29kLiBXZSBjYW4gdHJ5IHRvIGFsbG9jYXRlIG1lbW9yeSBvZiBi
aWcgb3JkZXINCmJ1dCBub3QgdGhhdCBoYXJkIGFuZCBzd2l0Y2ggdG8gZnJhZ21lbnRzIHdoZW4g
cG9zc2libGUuDQoNClBsZWFzZSBhbHNvIG5vdGUgdGhhdCBldmVuIG9yZGluYXJ5IHVzZXIgY291
bGQgdHJpZ2dlciByZWFsbHkgYmlnDQphbGxvY2F0aW9ucw0KYW5kIHRodXMgZm9yY2UgdGhlIHdo
b2xlIG5vZGUgdG8gZGFuY2UuDQoNCkRlbg0KDQpEZW4NCg==
