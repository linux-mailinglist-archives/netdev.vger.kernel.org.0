Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 736B583A5D
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 22:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbfHFUhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 16:37:52 -0400
Received: from mail-eopbgr30065.outbound.protection.outlook.com ([40.107.3.65]:15259
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726018AbfHFUhw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 16:37:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJycX9+5e6MUfsxwjGtWi6y8ZAtQsYTkkZW70VHbWe8RaIBBO7V9rqd6e5wTrCnlJEXR2tTc9gMYA1Yk4+639WMZnhumv21AHGaBYwBvQN60d2pOzIybIRU3LLDG7cwmkw+eqQy22Nsk+N2xNyUvCsiHc14Lx6KpJ2tuPn4AmvvMoCdHB8pbCFdrTcUFzMtJ1gLbuNO2X6QNeH9r4L2Y6oViZ/7NPGhSocQkl451Jy/A/ONJBKC+9ei1adQky7JLDFczN1/QitqDvAfrc6EdzPqXkyevvbs6MLF6NTXyHvZEYrRyWg6u9terCocjX/Bx1sAzlYraRSOon/gEwa+otw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVJFIvVMrUtkZph8/eS2ZlMu6CP5xxgZRORM+JLUb7g=;
 b=lNRwcx/8qUg05BKoBmscKheG0rV0EyoYexEmz60xkyHenO9kchnChligqj+MeHdU5bYH/N9N4ejbi8VIOYUnz86mLuBbbElE+uzX6DgrpSWGqnhvm5Ii9ingkjtpR+ld3jCsmTaxvvdOEQSw8yKwcyaGx0g3T8Av9bqau3YvQSd7+I+XBE4wxnZTXt8Nk+STny+9C3/9+2ByhW2HeYo6G8ZiK8TtswSizptRIrwK/7MaWkDC2d5257C2Sj0EUKkTneUBUbxT/G1OFoGp6G1MBVkIWPwiSaRwzR9CO67IPT4grai3L4CUpunIiMS0TIaTHdtfzK4dtY3KKBXhbZK+bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVJFIvVMrUtkZph8/eS2ZlMu6CP5xxgZRORM+JLUb7g=;
 b=MqXdYxUy0rr8QsfTIecInjUOtRJIMjPcJ1pm6r/fzcKCbpfFa3zRmyQOFEIm+nnurQL/X6kYQn21r33SPB/W3SKa7xhWf9nSSLW63rqMtkbLzIgDua92vCc1CB9suFhcDpz5KTO2LANsnNzpZwomRK17Zkrl+AgfIb1n5QiXigI=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2790.eurprd05.prod.outlook.com (10.172.227.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Tue, 6 Aug 2019 20:37:46 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2136.018; Tue, 6 Aug 2019
 20:37:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH 03/17] mlx5: no need to check return value of
 debugfs_create functions
Thread-Topic: [PATCH 03/17] mlx5: no need to check return value of
 debugfs_create functions
Thread-Index: AQHVTHGxAql7Mh9Nt0CFTl4RatXQv6bulLUA
Date:   Tue, 6 Aug 2019 20:37:46 +0000
Message-ID: <84cbce3a185e00612c189dd1b6cc5114d225d2fd.camel@mellanox.com>
References: <20190806161128.31232-1-gregkh@linuxfoundation.org>
         <20190806161128.31232-4-gregkh@linuxfoundation.org>
In-Reply-To: <20190806161128.31232-4-gregkh@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51162a53-2dee-4bcc-e7f7-08d71aadf07d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2790;
x-ms-traffictypediagnostic: DB6PR0501MB2790:
x-microsoft-antispam-prvs: <DB6PR0501MB2790FAFCBBC09A3CF71B63E2BED50@DB6PR0501MB2790.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(199004)(189003)(186003)(6486002)(11346002)(256004)(6436002)(91956017)(3846002)(6116002)(8676002)(86362001)(446003)(68736007)(478600001)(229853002)(76116006)(66556008)(36756003)(476003)(6512007)(6246003)(81156014)(66476007)(99286004)(66946007)(2616005)(81166006)(26005)(76176011)(7736002)(14454004)(2501003)(8936002)(53936002)(66446008)(316002)(64756008)(4744005)(71200400001)(71190400001)(102836004)(58126008)(2906002)(5660300002)(4326008)(305945005)(25786009)(6506007)(110136005)(486006)(118296001)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2790;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9UeQLj8w7hhFvCrkqSXO2/L3qRdMYeMjIEaEDsZIq8p9eD0A7qtYVg/UyZaXlGlb26j/ckIyo7nIdp5K5MOVXrZ2JODO5oOMxbVQEVE8qzoM8vf/++dgPNe8u2G9N73xWNBN22U9+Ob4RGRXZiKbZ+w63gSYs7S9RiNWJzUcFPJ3uo4M/QCjDTneABMR6yMlobkvWjcdCCgEiYlYgVaXb+2fDw7kfvb+tZgoSFl8z8K1tY+cw3sE5x0nv/3Fd0j14hYhLXrJ4tvqdxSVa1sXX1/KmbUxrmiezOPBZoUj0kOsbm/dBvOBhhC+MJ8wx1rxXpeeALz2+RbToaC/keJ5hLQ3Lg54nQba8pGQyfArqaeolkL6M9hKBX1NieS5LMypzvrfwxUMzrOLX3Fu712Bf4xfV9DbRB09MxWhEX4/kWc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <419E4AE79961C1489F911F4C132F35D6@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51162a53-2dee-4bcc-e7f7-08d71aadf07d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 20:37:46.0952
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2790
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTA2IGF0IDE4OjExICswMjAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3Jv
dGU6DQo+IFdoZW4gY2FsbGluZyBkZWJ1Z2ZzIGZ1bmN0aW9ucywgdGhlcmUgaXMgbm8gbmVlZCB0
byBldmVyIGNoZWNrIHRoZQ0KPiByZXR1cm4gdmFsdWUuICBUaGUgZnVuY3Rpb24gY2FuIHdvcmsg
b3Igbm90LCBidXQgdGhlIGNvZGUgbG9naWMNCj4gc2hvdWxkDQo+IG5ldmVyIGRvIHNvbWV0aGlu
ZyBkaWZmZXJlbnQgYmFzZWQgb24gdGhpcy4NCj4gDQo+IFRoaXMgY2xlYW5zIHVwIGEgbG90IG9m
IHVubmVlZGVkIGNvZGUgYW5kIGxvZ2ljIGFyb3VuZCB0aGUgZGVidWdmcw0KPiBmaWxlcywgbWFr
aW5nIGFsbCBvZiB0aGlzIG11Y2ggc2ltcGxlciBhbmQgZWFzaWVyIHRvIHVuZGVyc3RhbmQgYXMg
d2UNCj4gZG9uJ3QgbmVlZCB0byBrZWVwIHRoZSBkZW50cmllcyBzYXZlZCBhbnltb3JlLg0KPiAN
Cj4gQ2M6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiBDYzogTGVvbiBS
b21hbm92c2t5IDxsZW9uQGtlcm5lbC5vcmc+DQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
DQo+IFNpZ25lZC1vZmYtYnk6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRh
dGlvbi5vcmc+DQoNCkFja2VkLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNv
bT4NCg0KU29tZSB1bmV4cGVjdGVkL3VuZGVmaW5lZCBkcml2ZXIgYmVoYXZpb3IgbWlnaHQgb2Nj
dXIgaWYgc29tZSBvZiB0aGUNCmRlYnVnX2ZzXyogY2FsbHMgc2hvdWxkIGZhaWwgaW4gdGhpcyBk
cml2ZXIsIEkgd2lsbCBmb2xsb3cgdXAgd2l0aCBhDQpwYXRjaCB0byBhZGRyZXNzIHRoaXMuDQoN
ClRoYW5rcywNClNhZWVkLg0KDQo=
