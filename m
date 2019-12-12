Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0CFE11D94E
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 23:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731006AbfLLWYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 17:24:51 -0500
Received: from mail-eopbgr30058.outbound.protection.outlook.com ([40.107.3.58]:8622
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730868AbfLLWYu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 17:24:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vto9WGODMzkhZ3iNTiJOSOx3SCW/tb6u9ghUki3d5nC4V/sOn5cDcJ8Pw8mF5Cv79zxx1eS99uH5dlaG0QrwR73WrRpOewDFkeTnl46OZxIh9U7HOJXYzoyTspNM8gvLcRwD23vMufo3nRbVdzi3SRoRizFWll5crrLE6aqzO+xYSkCqKHk15JWUYjgNM1WgsQfoCMRcqKIgeX3fl/rLnef+JJsI9URqZBcpNLUCv5TNu4TTvyz7LU5ca9ZcQOa7oSUUvo1gkfoOqS4GqQVHm2hjrt+yy3hHgc2RpD3zUzB9PC0J6FKpwoksh0w49vDCzpL8PxjdvLyM1Xz/KHQztA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mA3Xvy7C+iK5nTeZ2RfzoWZVJQXsaqSNYevv+oLRCXc=;
 b=FtbXs0Tj0CAg+VQI0DCN33UH5XPFQJAxfDDrrxi/R5BBrZNOjWfNcyokTJbLTpKv0gn1tpt/bqUQgw3U2C72ww+IAtEwqP/Xl2A+j4w4Bo6H6blmUZBMWaADJukkUi8c1iH2ug4ITFo8V6AIhej7FJvUP7FDXvnwEMySyhGARxlScPcyj+A93ZeEF4PMMzptWJdb0iVjEikBo7C5FgOkxpqQYVgJcLdKaquhcMeNapsrjFr51Wc+vt34GfabvQ1r7OmqfoHYui9GxpWPmgRHoL7bhUjsflW5IiFCGozMKv/bQU8G4L5SsU1D5MFmwx2eFHV80G7SfzgggUVchRAR2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mA3Xvy7C+iK5nTeZ2RfzoWZVJQXsaqSNYevv+oLRCXc=;
 b=PQVnu628Jtfrafll9cLeZbwdtjVrHcvbR23r3lSo5p8YVJ+vpFbjolgXYwGUxLpqqTlUJYm2n5Lko6BRezNwU1wz+BhJJn1iqZw2uF70lKIkeTX3eeg12p4o4doXmQdifuTgyAYGuA9jS6zK2PSPkDnwr+Q4CG4+2FxKyIun1nM=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4114.eurprd05.prod.outlook.com (52.134.93.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Thu, 12 Dec 2019 22:24:45 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::16:9951:5a4b:9ec6]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::16:9951:5a4b:9ec6%7]) with mapi id 15.20.2516.020; Thu, 12 Dec 2019
 22:24:45 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Shannon Nelson <snelson@pensando.io>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v2 net-next 2/2] ionic: support sr-iov operations
Thread-Topic: [PATCH v2 net-next 2/2] ionic: support sr-iov operations
Thread-Index: AQHVsIPZtKRJJ1k2sk+Nw8POrjaYSqe2EL8AgADZlgCAAAIPAIAAGscAgAANtQA=
Date:   Thu, 12 Dec 2019 22:24:45 +0000
Message-ID: <a135f5fa-3745-69f6-4787-1695f47f1df8@mellanox.com>
References: <20191212003344.5571-1-snelson@pensando.io>
 <20191212003344.5571-3-snelson@pensando.io>
 <acfcf58b-93ff-fba5-5769-6bc29ed0d375@mellanox.com>
 <20191212115228.2caf0c63@cakuba.netronome.com>
 <bd7553cd-8784-6dfd-0b51-552b49ca8eaa@pensando.io>
 <20191212133540.3992ac0c@cakuba.netronome.com>
In-Reply-To: <20191212133540.3992ac0c@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [107.77.200.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b903f1c2-1176-4986-15b5-08d77f521784
x-ms-traffictypediagnostic: AM0PR05MB4114:
x-microsoft-antispam-prvs: <AM0PR05MB41144BD680F1FAB59D34C105D1550@AM0PR05MB4114.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0249EFCB0B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(199004)(189003)(8676002)(478600001)(110136005)(6512007)(6486002)(186003)(31686004)(81166006)(81156014)(8936002)(31696002)(26005)(316002)(71200400001)(54906003)(2906002)(5660300002)(2616005)(66946007)(86362001)(6506007)(66446008)(4326008)(36756003)(53546011)(76116006)(66556008)(64756008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4114;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dizp/cFPCf8xXXEiBXIIrZArJhwJIudei7UmFV/ai3IMneHRSk6btDFwhmLDoCwMP87014yBFRRDIj33eG5QZN0AvFCgxkP/M4gpW2GsHvQA1IJgLZOj02ofnbyCZeTzO6huX3Hgyhj4Q2VDUZHdFgKiFtsmjs1ws1L7jcmFBhNxvCk6TTOjoF1dMROJ8GfEOlifSoKooRInuqjjpG75ADru39FBeH5lpY02sgGWx14d5vVhj9efRIq5SU5nZ+VoYEpiTQ2OkM6Af+VUFFfV4VR5nKcCSRcjbUJ8NkepGvZF6Fasqc5SLNZlsYYYKCVp5S8Kk2QgeBs4Cs9AWSPwSffEAbiBY4HenrNz/IZZRBWW8Q5c8Y5Wd9POKATzRgy3SLYmxb5yGK0AWHmFfytTEfsOAazD7IN1s5JbnrSUoajC48ORnQb6F8Rnq/WnC8Ts
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <CEDD570EDC53004797550D7DAFE5FE4C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b903f1c2-1176-4986-15b5-08d77f521784
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2019 22:24:45.3123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GgbcX+U+gh1uKv3wod35cRP8OoskIRw6hhQzxADIWK/4TFuC+aztUW5mJ0xYI7xPG4TDNl/1nKigu0fczW+77g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTIvMjAxOSAzOjM1IFBNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gT24gVGh1LCAx
MiBEZWMgMjAxOSAxMTo1OTo1MCAtMDgwMCwgU2hhbm5vbiBOZWxzb24gd3JvdGU6DQo+PiBPbiAx
Mi8xMi8xOSAxMTo1MiBBTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+Pj4gT24gVGh1LCAxMiBE
ZWMgMjAxOSAwNjo1Mzo0MiArMDAwMCwgUGFyYXYgUGFuZGl0IHdyb3RlOiAgDQo+Pj4+PiAgIHN0
YXRpYyB2b2lkIGlvbmljX3JlbW92ZShzdHJ1Y3QgcGNpX2RldiAqcGRldikNCj4+Pj4+ICAgew0K
Pj4+Pj4gICAJc3RydWN0IGlvbmljICppb25pYyA9IHBjaV9nZXRfZHJ2ZGF0YShwZGV2KTsNCj4+
Pj4+IEBAIC0yNTcsNiArMzM4LDkgQEAgc3RhdGljIHZvaWQgaW9uaWNfcmVtb3ZlKHN0cnVjdCBw
Y2lfZGV2ICpwZGV2KQ0KPj4+Pj4gICAJaWYgKCFpb25pYykNCj4+Pj4+ICAgCQlyZXR1cm47DQo+
Pj4+PiAgIA0KPj4+Pj4gKwlpZiAocGNpX251bV92ZihwZGV2KSkNCj4+Pj4+ICsJCWlvbmljX3Ny
aW92X2NvbmZpZ3VyZShwZGV2LCAwKTsNCj4+Pj4+ICsgIA0KPj4+PiBVc3VhbGx5IHNyaW92IGlz
IGxlZnQgZW5hYmxlZCB3aGlsZSByZW1vdmluZyBQRi4NCj4+Pj4gSXQgaXMgbm90IHRoZSByb2xl
IG9mIHRoZSBwY2kgUEYgcmVtb3ZhbCB0byBkaXNhYmxlIGl0IHNyaW92LiAgDQo+Pj4gSSBkb24n
dCB0aGluayB0aGF0J3MgdHJ1ZS4gSSBjb25zaWRlciBpZ2IgYW5kIGl4Z2JlIHRvIHNldCB0aGUg
c3RhbmRhcmQNCj4+PiBmb3IgbGVnYWN5IFNSLUlPViBoYW5kbGluZyBzaW5jZSB0aGV5IHdlcmUg
b25lIG9mIHRoZSBmaXJzdCAodGhlIGZpcnN0PykNCj4+PiBhbmQgQWxleCBEdXljayB3cm90ZSB0
aGVtLg0KPj4+DQo+Pj4gbWx4NCwgYm54dCBhbmQgbmZwIGFsbCBkaXNhYmxlIFNSLUlPViBvbiBy
ZW1vdmUuICANCj4+DQo+PiBUaGlzIHdhcyBteSB1bmRlcnN0YW5kaW5nIGFzIHdlbGwsIGJ1dCBu
b3cgSSBjYW4gc2VlIHRoYXQgaXhnYmUgYW5kIGk0MGUgDQo+PiBhcmUgYm90aCBjaGVja2luZyBm
b3IgZXhpc3RpbmcgVkZzIGluIHByb2JlIGFuZCBzZXR0aW5nIHVwIHRvIHVzZSB0aGVtLCANCj4+
IGFzIHdlbGwgYXMgdGhlIG5ld2VyIGljZSBkcml2ZXIuwqAgSSBmb3VuZCB0aGlzIHRvZGF5IGJ5
IGxvb2tpbmcgZm9yIA0KPj4gd2hlcmUgdGhleSB1c2UgcGNpX251bV92ZigpLg0KPiANCj4gUmln
aHQsIGlmIHRoZSBWRnMgdmVyeSBhbHJlYWR5IGVuYWJsZWQgb24gcHJvYmUgdGhleSBhcmUgc2V0
IHVwLg0KPiANCj4gSXQncyBhIGJpdCBvZiBhIGFzeW1tZXRyaWMgZGVzaWduLCBpbiBjYXNlIHNv
bWUgb3RoZXIgZHJpdmVyIGxlZnQNCj4gU1ItSU9WIG9uLCBJIGd1ZXNzLg0KPiANCg0KSSByZW1l
bWJlciBvbiBvbmUgZW1haWwgdGhyZWFkIG9uIG5ldGRldiBsaXN0IGZyb20gc29tZW9uZSB0aGF0
IGluIG9uZQ0KdXNlIGNhc2UsIHRoZXkgdXBncmFkZSB0aGUgUEYgZHJpdmVyIHdoaWxlIFZGcyBh
cmUgc3RpbGwgYm91bmQgYW5kDQpTUi1JT1Yga2VwdCBlbmFibGVkLg0KSSBhbSBub3Qgc3VyZSBo
b3cgbXVjaCBpdCBpcyB1c2VkIGluIHByYWN0aWNlL29yIHByYWN0aWNhbC4NClN1Y2ggdXNlIGNh
c2UgbWF5IGJlIHRoZSByZWFzb24gdG8ga2VlcCBTUi1JT1YgZW5hYmxlZC4NCg==
