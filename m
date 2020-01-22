Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F40814521A
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 11:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbgAVKF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 05:05:26 -0500
Received: from mail-db8eur05on2095.outbound.protection.outlook.com ([40.107.20.95]:54720
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729078AbgAVKF0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 05:05:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5ENIEROutNhqmFt+mnO3bMbA7FpItLyE0p6FgU/eanrqZs/c/BZfeBNBxsTiW3aqU/3QRQv5hDBTp8BmwZSpWrf918UsK7hCPotAfiNN7haGxZcyekeZbVVdcRFbJtOL2P7K+Rch0uIHpXKJCmCqaTpo7dtLcW1lo4xEHCEMSwbeD8eeCrxxi1ZBsvFtoRi6nGEhG7MyloLC9wYt2PM7gWhy1E2T9jexocbboo/Tv5h6lsly+e+SXKDDaD8kZps+U1S01uJLLnY2EyxOXquiql+nKnxb8ttQJzzy1XTCtzbJRDsASvfQjH1JvxxDXgji0YbNZ/E1yf2mmwcAo5Lbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CASeRVJzg1Zgmh2ZrJVBTqpb5ewSbN1cUkBizEERPm4=;
 b=KYZ58/gAdd1lOxkMVvqd660o2u74QGydAkf7GamIymjqCpc94c26R6ZYCcoF4m2jwlLbJkHvxJ0Lgefvzq1J5P7je23BYXuCFI+B+j5Ip6WIM2FAPpsY/pkimChf1s+C5j7yWbRuVWlZ0pARhEMyvLDbdBQ0vVo89HNIkiLXhkqqznJTBtYSnJPovKZ26f4qCtdMPdqtz6H60rqaTCZmHVp5A5rTTHO0avt9b9emuqtARqSKGLWP2R9qQlv+1VeHojddRZhpXeUX96jfHZGAHb0vpqNsKx8TvSfs8E9MohQHy+bDY1dQoTmoklIW5IayqNdRIo57Vpx1uEQaXOyh7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CASeRVJzg1Zgmh2ZrJVBTqpb5ewSbN1cUkBizEERPm4=;
 b=AKnQZY8BRbdlxU7+s3HlHSIWVnsgfMQ4ZKAik4HDFhHoWFZB19YaFqBvsxz5O71jiqcVgWG4HgVecWu70jKDwjmYe3DNItt9XgqR2INbHlp286wv6Cc5wMQHcTj3+ONwWjrfegB+NLRu8qi3L/j7ry+yZCCqxzVvDYjRIkeNQBc=
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com (20.178.20.19) by
 AM0PR05MB5939.eurprd05.prod.outlook.com (20.178.118.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 22 Jan 2020 10:05:21 +0000
Received: from AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7]) by AM0PR05MB5156.eurprd05.prod.outlook.com
 ([fe80::28cb:442b:6907:83e7%6]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 10:05:21 +0000
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "matteo.croce@redhat.com" <matteo.croce@redhat.com>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: [PATCH] mvneta driver XDP fixes armhf
Thread-Topic: [PATCH] mvneta driver XDP fixes armhf
Thread-Index: AQHV0Qt0wGHHU1bPe06KgczxouriXQ==
Date:   Wed, 22 Jan 2020 10:05:21 +0000
Message-ID: <C39F91BD-26BA-4373-A056-CE2E6B9D750E@voleatech.de>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sven.auhagen@voleatech.de; 
x-originating-ip: [37.24.174.42]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b93cf1e-7071-4350-694a-08d79f229736
x-ms-traffictypediagnostic: AM0PR05MB5939:
x-microsoft-antispam-prvs: <AM0PR05MB5939DEF48CA80EE47755426FEF0C0@AM0PR05MB5939.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(199004)(189003)(6512007)(2616005)(15974865002)(4326008)(81156014)(8936002)(8676002)(508600001)(33656002)(44832011)(86362001)(76116006)(64756008)(2906002)(66556008)(66476007)(66446008)(36756003)(66946007)(6916009)(81166006)(26005)(186003)(6506007)(54906003)(71200400001)(6486002)(5660300002)(66574012);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR05MB5939;H:AM0PR05MB5156.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: voleatech.de does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b0Bm0FRxBTQPOmQZaMT9DGHrLIZ2UWNySjFNePHJKgKKs+BG4VGFnf0FW/i06FnkbzFNi2vAuERWka62dmGAs4EuQga+CsHeR7tokyGiC9DWZkXiwPC7QZoyUAUOQaw6xFXd0iP7KJdS4hBGiHPxAUbwx7mDtm7NJ5mLJjE1e773ZUpBEvgFfIgWzZWYmdzmfyWpyZTPYSV7Aq/K60t4ZrV29Be5NJ+iz8lGpxFazjyI6FXy6NWULprDdrTz+z2EBQGNEOjGtHfnDskJkFJXmJSb0t4Fc6/+FVIOqJ/O3cgPiai/OfZL1i9ZTm6jhZgRUDPKFuNoQnwLNe+GufvJyhfdL4qFQqMjBqXQ31CTs22RGaIA+9y3Ma9Zz3n5WoZ945el+zPilw6THfiWp/vpasfRdG0n75G9tW48Zv3vPpS629O9KuDU7Y6a4A4PxP0g
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3939AA22C595144ABCB34AAD265218E5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b93cf1e-7071-4350-694a-08d79f229736
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 10:05:21.0394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PrFYmC98rIQEIF5bMUbuE5+xNacQAqeUP4ZgJLgVUOM127VJelmF8WnI6BracioHxAU6wCDXtGjVyNwXi3ZtCox708ynfZPbzChqI9mUVUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5939
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UmVjZW50bHkgWERQIFN1cHBvcnQgd2FzIGFkZGVkIHRvIHRoZSBtdm5ldGEgZHJpdmVyIGZvciBz
b2Z0d2FyZSBidWZmZXIgbWFuYWdlbWVudC4NCkkgdGVzdGVkIFhEUCB3aXRoIG15IGFybWFkYSAz
ODggYm9hcmQuIEl0IGhhcyBoYXJkd2FyZSBidWZmZXIgbWFuYWdlbWVudCBkZWZpbmVkIGluIHRo
ZSBkZXZpY2UgdHJlZSBmaWxlLg0KSSBkaXNhYmxlZCB0aGUgbXZuZXRhX2JtIG1vZHVsZSB0byB0
ZXN0IFhEUC4NCg0KSSBmb3VuZCBtdWx0aXBsZSBwcm9ibGVtcy4NCg0KMS4gV2l0aCBoYXJkd2Fy
ZSBidWZmZXIgbWFuYWdlbWVudCBlbmFibGVkIGFuZCBtdm5ldGFfYm0gZGlzYWJsZWQgdGhlIHJ4
X29mZnNldCB3YXMgc2V0IHRvIDAgd2l0aCBhcm1oZiAoMzIgYml0KSB3aGljaCBsZWFkcyB0byBu
byBoZWFkcm9vbSBpbiBYRFAgYW5kIHRoZXJlZm9yZSB0aGUgWERQIFJlZGlyZWN0IGRpZCBub3Qg
d29yay4NCjIuIFJlbW92aW5nIHRoZSBoYXJkd2FyZSBidWZmZXIgbWFuYWdlbWVudCBmcm9tIHRo
ZSBkZXZpY2UgdHJlZSBmaWxlIGNvbXBsZXRlbHkgbWFkZSB0aGUgbXZuZXRhIGRyaXZlciB1bnVz
YWJsZSBhcyBpdCBkaWQgbm90IHdvcmsgYW55bW9yZS4NCg0KQWZ0ZXIgc29tZSBkZWJ1Z2dpbmcg
SSBmb3VuZCBvdXQgdGhhdCB4ZHAtPmRhdGEgPSBkYXRhICsgcHAtPnJ4X29mZnNldF9jb3JyZWN0
aW9uICsgTVZORVRBX01IX1NJWkU7ICBoYXMgdG8gYmUgeGRwLT5kYXRhID0gZGF0YSArIHBwLT5y
eF9vZmZzZXRfY29ycmVjdGlvbjsgaWYgcHAtPnJ4X29mZnNldF9jb3JyZWN0aW9uID4gMC4NCkkg
YW0gbm90IHN1cmUgd2h5IGFuZCBJIGFtIGxvb2tpbmcgZm9yIGhlbHAgaWYgc29tZW9uZSBpcyBz
ZWVpbmcgdGhlIHNhbWUgb24gYW4gYXJtNjQgYm9hcmQuDQoNCkF0dGFjaGVkIGlzIGEgcGF0Y2gg
dGhhdCBmaXhlcyB0aGUgcHJvYmxlbSBvbiBteSBhcm1oZiBwbGF0Zm9ybSwgYXMgc2FpZCBJIGFt
IG5vdCBzdXJlIGlmIHRoaXMgaXMgYSB1bml2ZXJzYWwgZml4IG9yIGFybWhmIG9ubHkuDQoNCkFu
eSBmZWVkYmFjayBpcyBhcHByZWNpYXRlZC4NCg0KU2lnbmVkLW9mZi1ieTogU3ZlbiBBdWhhZ2Vu
IDxzdmVuLmF1aGFnZW5Adm9sZWF0ZWNoLmRlPg0KDQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tYXJ2ZWxsL212bmV0YS5jMjAyMC0wMS0yMiAwODo0NDowNS42MTEzOTU5NjAgKzAwMDANCisr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvbXZuZXRhLmMyMDIwLTAxLTIyIDA4OjU5
OjI3LjA1MzczOTQzMyArMDAwMA0KQEAgLTIxNTgsNyArMjE1OCw3IEBAIG12bmV0YV9zd2JtX3J4
X2ZyYW1lKHN0cnVjdCBtdm5ldGFfcG9ydA0KIHByZWZldGNoKGRhdGEpOw0KDQogeGRwLT5kYXRh
X2hhcmRfc3RhcnQgPSBkYXRhOw0KLXhkcC0+ZGF0YSA9IGRhdGEgKyBwcC0+cnhfb2Zmc2V0X2Nv
cnJlY3Rpb24gKyBNVk5FVEFfTUhfU0laRTsNCit4ZHAtPmRhdGEgPSBkYXRhICsgcHAtPnJ4X29m
ZnNldF9jb3JyZWN0aW9uOw0KIHhkcC0+ZGF0YV9lbmQgPSB4ZHAtPmRhdGEgKyBkYXRhX2xlbjsN
CiB4ZHBfc2V0X2RhdGFfbWV0YV9pbnZhbGlkKHhkcCk7DQoNCkBAIC00OTYwLDcgKzQ5NjAsOCBA
QCBzdGF0aWMgaW50IG12bmV0YV9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fDQogICogTkVUX1NLQl9Q
QUQsIGV4Y2VlZHMgNjRCLiBJdCBzaG91bGQgYmUgNjRCIGZvciA2NC1iaXQNCiAgKiBwbGF0Zm9y
bXMgYW5kIDBCIGZvciAzMi1iaXQgb25lcy4NCiAgKi8NCi1wcC0+cnhfb2Zmc2V0X2NvcnJlY3Rp
b24gPSBtYXgoMCwNCitpZiAocHAtPmJtX3ByaXYpDQorcHAtPnJ4X29mZnNldF9jb3JyZWN0aW9u
ID0gbWF4KDAsDQogICAgICAgIE5FVF9TS0JfUEFEIC0NCiAgICAgICAgTVZORVRBX1JYX1BLVF9P
RkZTRVRfQ09SUkVDVElPTik7DQogfQ0KDQoNCg0KDQorKysgVm9sZWF0ZWNoIGF1ZiBkZXIgRS1X
b3JsZCwgMTEuIGJpcyAxMy4gRmVicnVhciAyMDIwLCBIYWxsZSA1LCBTdGFuZCA1MjEgKysrDQoN
CkJlc3RlIEdyw7zDn2UvQmVzdCByZWdhcmRzDQoNClN2ZW4gQXVoYWdlbg0KRGlwbC4gTWF0aC4g
b2VjLiwgTS5TYy4NClZvbGVhdGVjaCBHbWJIDQpIUkI6IEIgNzU0NjQzDQpVU1RJRDogREUzMDM2
NDMxODANCkdyYXRod29obHN0ci4gNQ0KNzI3NjIgUmV1dGxpbmdlbg0KVGVsOiArNDkgNzEyMTUz
OTU1MA0KRmF4OiArNDkgNzEyMTUzOTU1MQ0KRS1NYWlsOiBzdmVuLmF1aGFnZW5Adm9sZWF0ZWNo
LmRlDQp3d3cudm9sZWF0ZWNoLmRlPGh0dHBzOi8vd3d3LnZvbGVhdGVjaC5kZT4NCkRpZXNlIElu
Zm9ybWF0aW9uIGlzdCBhdXNzY2hsaWXDn2xpY2ggZsO8ciBkZW4gQWRyZXNzYXRlbiBiZXN0aW1t
dCB1bmQga2FubiB2ZXJ0cmF1bGljaCBvZGVyIGdlc2V0emxpY2ggZ2VzY2jDvHR6dGUgSW5mb3Jt
YXRpb25lbiBlbnRoYWx0ZW4uIFdlbm4gU2llIG5pY2h0IGRlciBiZXN0aW1tdW5nc2dlbcOkw59l
IEFkcmVzc2F0IHNpbmQsIHVudGVycmljaHRlbiBTaWUgYml0dGUgZGVuIEFic2VuZGVyIHVuZCB2
ZXJuaWNodGVuIFNpZSBkaWVzZSBNYWlsLiBBbmRlcmVuIGFscyBkZW0gYmVzdGltbXVuZ3NnZW3D
pMOfZW4gQWRyZXNzYXRlbiBpc3QgZXMgdW50ZXJzYWd0LCBkaWVzZSBFLU1haWwgenUgbGVzZW4s
IHp1IHNwZWljaGVybiwgd2VpdGVyenVsZWl0ZW4gb2RlciBpaHJlbiBJbmhhbHQgYXVmIHdlbGNo
ZSBXZWlzZSBhdWNoIGltbWVyIHp1IHZlcndlbmRlbi4gRsO8ciBkZW4gQWRyZXNzYXRlbiBzaW5k
IGRpZSBJbmZvcm1hdGlvbmVuIGluIGRpZXNlciBNYWlsIG51ciB6dW0gcGVyc8O2bmxpY2hlbiBH
ZWJyYXVjaC4gRWluZSBXZWl0ZXJsZWl0dW5nIGRhcmYgbnVyIG5hY2ggUsO8Y2tzcHJhY2hlIG1p
dCBkZW0gQWJzZW5kZXIgZXJmb2xnZW4uIFdpciB2ZXJ3ZW5kZW4gYWt0dWVsbGUgVmlyZW5zY2h1
dHpwcm9ncmFtbWUuIEbDvHIgU2Now6RkZW4sIGRpZSBkZW0gRW1wZsOkbmdlciBnbGVpY2h3b2hs
IGR1cmNoIHZvbiB1bnMgenVnZXNhbmR0ZSBtaXQgVmlyZW4gYmVmYWxsZW5lIEUtTWFpbHMgZW50
c3RlaGVuLCBzY2hsaWXDn2VuIHdpciBqZWRlIEhhZnR1bmcgYXVzLg0K
