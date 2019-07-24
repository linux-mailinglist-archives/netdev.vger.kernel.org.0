Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC7173629
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 19:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfGXRz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 13:55:26 -0400
Received: from mail-eopbgr20061.outbound.protection.outlook.com ([40.107.2.61]:23686
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725851AbfGXRz0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 13:55:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U2rWtmO7WqUOn9bWLitmzhNO7aDdW1dctgkaDbN4qSaOtmwHJCpPA9ZGJGaz4hOpOoQF6bBZoDpTykZfOiOYHgiR7d4hu6ysGW5ygwZzCV/wh+uiu5qnoZDzoSRKR4sLOL+Z+iGcQHPjZXMC64aPR9ZRD5sFuPnCV3/Wp4iH1b+fcCCp2VLsyBc0fQalb/ccyyilJ1MNExfYYEZykyqZaf1uLJ3sMfI0pMw1CdutPTMav2FUJw4CvufhTHWwqb+w4KL3bugnEIFoKw+bzbIjgiyU8oS0o7W7opxYLBD2N5FzOhdUg70o/nptiwGoJr8cXX4TCr77oh2KIWZHiGDofw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMwMLUId9R4rLiioUJzbl//494g0UXf0fRJMVen+kwU=;
 b=Ex8/WaNHc3JojIy7mDM+kODm0TkPZYjP4A9u7aQ3Kq5m2lgutvcJjIKOUSvcrgYJunbKzXNNpdAIQPffvwz4zZtwEpQtpJm/Y1MFuASm0vnmSGOfVpMfX2nEwp9mmGgwhgyt+MuB5KYum2IbqnwkaSemUYqweo24pJ/DDgdO5z1DLL6pkP7r+MrC5O+pvzArcDGz4TLvZBehmwGSHuI6ugZYzSpGMSq5QkLuzxjoa0MlVkHj2CLRpqTgOfjBudYOGYvx76dbAXFF8LxjGQzxL8KhySIvUElE6LJcbfvPvEtOI6sO8yFTEKAzB+/bkDczOPkCi1T/0/kcyn5XepiiJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMwMLUId9R4rLiioUJzbl//494g0UXf0fRJMVen+kwU=;
 b=iiTwuTyCYKHL2Fl5kEIQsO7YiojXHrqNvkgh/hRQewHYTXNlA5Y6FEx5B4YNboTRcjqQA0oDlpDI3XMFVRKcdMwKvlmAy+UH+pL07K3DT1PMfXZvy000TVbI/Q6FNtfu7GF4XO1qjre8mGLOL3eQrFmcQpy2n+ecxqpGYJZczuE=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2408.eurprd05.prod.outlook.com (10.168.75.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Wed, 24 Jul 2019 17:55:22 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Wed, 24 Jul 2019
 17:55:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "willy@infradead.org" <willy@infradead.org>
CC:     "hch@lst.de" <hch@lst.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 4/7] net: Reorder the contents of skb_frag_t
Thread-Topic: [PATCH v3 4/7] net: Reorder the contents of skb_frag_t
Thread-Index: AQHVOLf8iJMmCRNg5EmRYlClumhf36bY2qAAgAAyIACAARO4AA==
Date:   Wed, 24 Jul 2019 17:55:21 +0000
Message-ID: <681207979b3e5db22193e841a54139b3f5a2771c.camel@mellanox.com>
References: <20190712134345.19767-1-willy@infradead.org>
         <20190712134345.19767-5-willy@infradead.org>
         <2b45504e005f88a033405225b04fba0b5dcf2e92.camel@mellanox.com>
         <20190724012828.GQ363@bombadil.infradead.org>
In-Reply-To: <20190724012828.GQ363@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66c7f76e-2099-4a18-81c6-08d710601931
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB6PR0501MB2408;
x-ms-traffictypediagnostic: DB6PR0501MB2408:
x-microsoft-antispam-prvs: <DB6PR0501MB240809EABA32EAB1D9F1D48CBEC60@DB6PR0501MB2408.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(199004)(189003)(66066001)(53936002)(58126008)(71190400001)(91956017)(8936002)(76116006)(5640700003)(71200400001)(305945005)(66476007)(64756008)(6246003)(66556008)(6512007)(4326008)(118296001)(54906003)(478600001)(7736002)(8676002)(316002)(66946007)(68736007)(6486002)(6436002)(81166006)(99286004)(25786009)(86362001)(2351001)(229853002)(81156014)(11346002)(2501003)(486006)(14444005)(2906002)(36756003)(6116002)(3846002)(256004)(186003)(14454004)(76176011)(66446008)(2616005)(26005)(1730700003)(6916009)(102836004)(476003)(5660300002)(6506007)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2408;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GMPzWeI8XnlssaVsyQORnCXcfF0ika1jG2i/bAaPf3OHXEoUDta7A0Zz59hCw2OCbKN1fbNiLE7Nw8ihnZtsQH6dO5hO193j7GxlaYQs4iYcUxYUjyMsjtDtkps/iq5dvqX0QR6SQSZYwxKvZvzmiTe8yiNc0l1ezUHnsdPPA3V2YT0XEJ1SZqS5Py2F5B46lUl0sLg6XMwDvQh8aw+L2YhmcwS+dW0rvA+yxG3K3rrdKiAkO4HPG+nZ3Hxzf+wyGtUnVmaxWqhtlMFXzru8W3WL1lFcWtEsd88iYideCKEiVq3g7oxf6ABcrR75QsWks95iDabNLjGL2gTnjOuRT0reE4u4E8W+COzRJPZmvLO6gP81k5nw11F45AqRKK0g7z0OoFPW4pSS8Y5yOsGxCrvdpM7Hk7NWCHtuc8DCTxw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3951EE3412D49B45B1917A20F69A0A71@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c7f76e-2099-4a18-81c6-08d710601931
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 17:55:22.0005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA3LTIzIGF0IDE4OjI4IC0wNzAwLCBNYXR0aGV3IFdpbGNveCB3cm90ZToN
Cj4gT24gVHVlLCBKdWwgMjMsIDIwMTkgYXQgMTA6Mjk6MDZQTSArMDAwMCwgU2FlZWQgTWFoYW1l
ZWQgd3JvdGU6DQo+ID4gT24gRnJpLCAyMDE5LTA3LTEyIGF0IDA2OjQzIC0wNzAwLCBNYXR0aGV3
IFdpbGNveCB3cm90ZToNCj4gPiA+IEZyb206ICJNYXR0aGV3IFdpbGNveCAoT3JhY2xlKSIgPHdp
bGx5QGluZnJhZGVhZC5vcmc+DQo+ID4gPiANCj4gPiA+IE1hdGNoIHRoZSBsYXlvdXQgb2YgYmlv
X3ZlYy4NCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogTWF0dGhldyBXaWxjb3ggKE9yYWNs
ZSkgPHdpbGx5QGluZnJhZGVhZC5vcmc+DQo+ID4gPiAtLS0NCj4gPiA+ICBpbmNsdWRlL2xpbnV4
L3NrYnVmZi5oIHwgMiArLQ0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MSBkZWxldGlvbigtKQ0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9z
a2J1ZmYuaCBiL2luY2x1ZGUvbGludXgvc2tidWZmLmgNCj4gPiA+IGluZGV4IDc5MTA5MzU0MTBl
Ni4uYjlkYzhiNGYyNGIxIDEwMDY0NA0KPiA+ID4gLS0tIGEvaW5jbHVkZS9saW51eC9za2J1ZmYu
aA0KPiA+ID4gKysrIGIvaW5jbHVkZS9saW51eC9za2J1ZmYuaA0KPiA+ID4gQEAgLTMxNCw4ICsz
MTQsOCBAQCBzdHJ1Y3Qgc2tiX2ZyYWdfc3RydWN0IHsNCj4gPiA+ICAJc3RydWN0IHsNCj4gPiA+
ICAJCXN0cnVjdCBwYWdlICpwOw0KPiA+ID4gIAl9IHBhZ2U7DQo+ID4gPiAtCV9fdTMyIHBhZ2Vf
b2Zmc2V0Ow0KPiA+ID4gIAlfX3UzMiBzaXplOw0KPiA+ID4gKwlfX3UzMiBwYWdlX29mZnNldDsN
Cj4gPiA+ICB9Ow0KPiA+ID4gIA0KPiA+IA0KPiA+IFdoeSBkbyB5b3UgbmVlZCB0aGlzIHBhdGNo
PyB0aGlzIHN0cnVjdCBpcyBnb2luZyB0byBiZSByZW1vdmVkDQo+ID4gZG93bnN0cmVhbSBldmVu
dHVhbGx5IC4uDQo+IA0KPiBJZiB0aGVyZSdzIGEgcGVyZm9ybWFuY2UgcmVncmVzc2lvbiwgdGhp
cyBpcyB0aGUgcGVyZmVjdCBwYXRjaCB0bw0KPiBpbmNsdWRlDQo+IGFzIHBhcnQgb2YgdGhlIGJp
c2VjdGlvbi4gIFlvdSdkIHRoaW5rIHRoYXQgdGhpcyBjaGFuZ2UgY291bGQgaGF2ZSBubw0KPiBl
ZmZlY3QsIGJ1dCBJJ3ZlIHNlZW4gd2VpcmRlciB0aGluZ3MuDQoNCm9rIG1ha2Ugc2Vuc2UgIQ0K
