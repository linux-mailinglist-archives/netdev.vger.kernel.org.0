Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 027178A4EE
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 19:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfHLRwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 13:52:10 -0400
Received: from mail-eopbgr80050.outbound.protection.outlook.com ([40.107.8.50]:36228
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726236AbfHLRwI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 13:52:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dBPQcRZ5u0aowtPWC0JHStmbUgKt1j3ScIYyBm2dHInFd0E0ZLAqJX+J6MA0W1uO/KoBJYScpQEYQHK928B62C85OjsU/Zj6ULyotE+RvsivnXQyODmYI5svZ+1P+IeembFE/kCzSNpkhsCBT5L8vs7+c1A9pNcKK3jSBRGTE/ZDwC5Ch8LuJz+NSjtY7feOjC5uqo8RBjEwcRX00RpXXBr/Ov0yo/nrrTE0vI70JwxBhcS6pMATOuFfULG9ag5GqcxWkNQ1RJyA23Oy0V4fRrkGMYC/KDTsWkU/+cjqTfXmLHp+MFeFZbH+9oVw7XD5ZkhBTXQ1bNA+bOfItphXAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+LkCnz5oKhKk63GxKrz30qbpCDyS3CH3qv9Kl8Bjizo=;
 b=TELknicEGAUUprl6YlrB1TfV3q6dozXWQKBfXefHdYlUex/+HKt3QCNg1K0inmBbxyEujCUbEzlXgD25ZmPf7TBA/k5ftSvgs7+uHTgLse+IKxiISpycB/Y8Uw00a/e0ZJkFZ5ZkF2Y7yPWgiVXzUfjuEKkUCVyLP0ZgCw1O1q5gBSLVbteUCo0PTHfV9ayq0hRxkB0rLybn+uisSGSummj8RY21LqkJk+eOlgDghOdDsSPHjGjqoiCoHtAdYxhMOWa9RG7kPKH8MuNtwtdPK1D3XQMkhs1w6iO36+FJpKHNXcTmjY3oqUFNMf4Ww/85Ne5cS0kqT3AbyajkC1BBzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+LkCnz5oKhKk63GxKrz30qbpCDyS3CH3qv9Kl8Bjizo=;
 b=W5QDXo05D4Mzxl7HA03EtCSvceoFJlZ8btkxAp3Zi1nu5BX/4mh9bXS+6ROV9IQ8fkQY/9mSZNRbnYohEx5nno7XAwi1HhYcw6UVBHJzigLso0yT7fPXuhDdjZ/V1pAntf9u/V/0wmXcOFozmuHisgbjDzzNfkZfuMRTj1PXlm8=
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com (20.176.215.215) by
 AM0PR04MB5124.eurprd04.prod.outlook.com (20.177.40.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.21; Mon, 12 Aug 2019 17:51:52 +0000
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::41a7:61ce:8705:d82d]) by AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::41a7:61ce:8705:d82d%2]) with mapi id 15.20.2157.022; Mon, 12 Aug 2019
 17:51:52 +0000
From:   Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
To:     Edward Cree <ecree@solarflare.com>
CC:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-net-drivers@solarflare.com" <linux-net-drivers@solarflare.com>
Subject: RE: [PATCH v3 net-next 0/3] net: batched receive in GRO path
Thread-Topic: [PATCH v3 net-next 0/3] net: batched receive in GRO path
Thread-Index: AQHVTF4qlNUmbVhe8E+hjl7kqsPKZ6bzEZTwgAAGZQCABLYrQA==
Date:   Mon, 12 Aug 2019 17:51:52 +0000
Message-ID: <AM0PR04MB4994A035C6121DC13C0EFBB194D30@AM0PR04MB4994.eurprd04.prod.outlook.com>
References: <c6e2474e-2c8a-5881-86bf-59c66bdfc34f@solarflare.com>
 <AM0PR04MB4994C1A8F32FB6C9A7EE057E94D60@AM0PR04MB4994.eurprd04.prod.outlook.com>
 <a6faf533-6dd3-d7d7-9464-1fe87d0ac7fc@solarflare.com>
In-Reply-To: <a6faf533-6dd3-d7d7-9464-1fe87d0ac7fc@solarflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ruxandra.radulescu@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58458dfe-bc42-492f-6d6c-08d71f4dc1da
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR04MB5124;
x-ms-traffictypediagnostic: AM0PR04MB5124:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM0PR04MB51244EE0EE8BA4992E48893194D30@AM0PR04MB5124.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 012792EC17
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(39860400002)(136003)(376002)(189003)(199004)(13464003)(446003)(4326008)(86362001)(52536014)(102836004)(11346002)(99286004)(486006)(74316002)(6246003)(476003)(53936002)(305945005)(256004)(76176011)(14444005)(26005)(6506007)(53546011)(25786009)(7736002)(186003)(316002)(7696005)(81156014)(54906003)(8676002)(8936002)(6436002)(81166006)(66066001)(478600001)(76116006)(14454004)(6916009)(6116002)(229853002)(966005)(66446008)(33656002)(71200400001)(66556008)(55016002)(71190400001)(66476007)(64756008)(3846002)(6306002)(9686003)(5660300002)(66946007)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5124;H:AM0PR04MB4994.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0Z2M+DnT3oBz/NgP0RAEf3KGchMcxwzQDDLnXI1AHohcfDU6efLzGwU+4X2OG4E6M++hfPrBYxGNVnro69SQBjWF0WF+l67sLoQe1iwbiATwX1eLCRfazsx4SxTUF3aUbue608k3f0bX0DyTHRKDQaVZ8ArSY5G8qI52XazeNHlijvSotFx517yFawKsHp9CFLU9oHIaePTIqYSecyuAJ3/3lhyKVpyf6vvJs2Rh/EAV0ibnxLedtKVVKo6A5SggKmIvBs+gZlKNzCiDsmHlrUCQM8QHUSFKp3iu4KbC9w2eBN6Rz5Z2cSCerg896fzdlQ3oOkVawfntao4RyWdR1ogH1OCLcCo8Cf2pqPfi13CTFy8kwym06FZDXLqMCOC42fYOj0kUeLDWKcQgcOSKcWZWOQkxwaZW9AjqO1PVcOo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58458dfe-bc42-492f-6d6c-08d71f4dc1da
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2019 17:51:52.1105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gpqaKfGw3p+ChH2J3tWPRULPmKvvQnaoDm9zqEe/56x08E+0lR5/yLQab4Ezcgmb3QpTjFxtGmUy5cYnXEzWpoykEBGd9FdQZDGMtm80mgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBFZHdhcmQgQ3JlZSA8ZWNyZWVA
c29sYXJmbGFyZS5jb20+DQo+IFNlbnQ6IEZyaWRheSwgQXVndXN0IDksIDIwMTkgODozMiBQTQ0K
PiBUbzogSW9hbmEgQ2lvY29pIFJhZHVsZXNjdSA8cnV4YW5kcmEucmFkdWxlc2N1QG54cC5jb20+
DQo+IENjOiBEYXZpZCBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBuZXRkZXYgPG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc+Ow0KPiBFcmljIER1bWF6ZXQgPGVyaWMuZHVtYXpldEBnbWFpbC5j
b20+OyBsaW51eC1uZXQtZHJpdmVyc0Bzb2xhcmZsYXJlLmNvbQ0KPiBTdWJqZWN0OiBSZTogW1BB
VENIIHYzIG5ldC1uZXh0IDAvM10gbmV0OiBiYXRjaGVkIHJlY2VpdmUgaW4gR1JPIHBhdGgNCj4g
DQo+IE9uIDA5LzA4LzIwMTkgMTg6MTQsIElvYW5hIENpb2NvaSBSYWR1bGVzY3Ugd3JvdGU6DQo+
ID4gSGkgRWR3YXJkLA0KPiA+DQo+ID4gSSdtIHByb2JhYmx5IG1pc3NpbmcgYSBsb3Qgb2YgY29u
dGV4dCBoZXJlLCBidXQgaXMgdGhlcmUgYSByZWFzb24NCj4gPiB0aGlzIGNoYW5nZSB0YXJnZXRz
IG9ubHkgdGhlIG5hcGlfZ3JvX2ZyYWdzKCkgcGF0aCBhbmQgbm90IHRoZQ0KPiA+IG5hcGlfZ3Jv
X3JlY2VpdmUoKSBvbmU/DQo+ID4gSSdtIHRyeWluZyB0byB1bmRlcnN0YW5kIHdoYXQgZHJpdmVy
cyB0aGF0IGRvbid0IGNhbGwgbmFwaV9ncm9fZnJhZ3MoKQ0KPiA+IHNob3VsZCBkbyBpbiBvcmRl
ciB0byBiZW5lZml0IGZyb20gdGhpcyBiYXRjaGluZyBmZWF0dXJlLg0KPiBUaGUgc2ZjIGRyaXZl
ciAod2hpY2ggaXMgd2hhdCBJIGhhdmUgbG90cyBvZiBoYXJkd2FyZSBmb3IsIHNvIEkgY2FuDQo+
IMKgdGVzdCBpdCkgdXNlcyBuYXBpX2dyb19mcmFncygpLg0KPiBJdCBzaG91bGQgYmUgcG9zc2li
bGUgdG8gZG8gYSBzaW1pbGFyIHBhdGNoIHRvIG5hcGlfZ3JvX3JlY2VpdmUoKSwNCj4gwqBpZiBz
b21lb25lIHdhbnRzIHRvIHB1dCBpbiB0aGUgZWZmb3J0IG9mIHdyaXRpbmcgYW5kIHRlc3Rpbmcg
aXQuDQoNClJhdGhlciB0cmlja3ksIHNpbmNlIEknbSBub3QgcmVhbGx5IGZhbWlsaWFyIHdpdGgg
R1JPIGludGVybmFscyBhbmQNCnByb2JhYmx5IGRvbid0IHVuZGVyc3RhbmQgYWxsIHRoZSBpbXBs
aWNhdGlvbnMgb2Ygc3VjaCBhIGNoYW5nZSA6LS8NCkFueSBwb2ludGVycyB0byB3aGF0IEkgc2hv
dWxkIHBheSBhdHRlbnRpb24gdG8vc2Vuc2l0aXZlIGFyZWFzIHRoYXQNCm5lZWQgZXh0cmEgY2Fy
ZT8NCg0KPiBIb3dldmVyLCB0aGVyZSBhcmUgbWFueSBtb3JlIGNhbGxlcnMsIHNvIG1vcmUgZWZm
b3J0IHJlcXVpcmVkIHRvDQo+IMKgbWFrZSBzdXJlIG5vbmUgb2YgdGhlbSBjYXJlIHdoZXRoZXIg
dGhlIHJldHVybiB2YWx1ZSBpcyBHUk9fRFJPUA0KPiDCoG9yIEdST19OT1JNQUwgKHNpbmNlIHRo
ZSBsaXN0aWZpZWQgdmVyc2lvbiBjYW5ub3QgZ2l2ZSB0aGF0DQo+IMKgaW5kaWNhdGlvbikuDQoN
CkF0IGEgcXVpY2sgZ2xhbmNlLCB0aGVyZSdzIG9ubHkgb25lIGRyaXZlciB0aGF0IGxvb2tzIGF0
IHRoZSByZXR1cm4NCnZhbHVlIG9mIG5hcGlfZ3JvX3JlY2VpdmUgKGRyaXZlcnMvbmV0L2V0aGVy
bmV0L3NvY2lvbmV4dC9uZXRzZWMuYyksDQphbmQgaXQgb25seSB1cGRhdGVzIGludGVyZmFjZSBz
dGF0cyBiYXNlZCBvbiBpdC4NCg0KPiBBbHNvLCB0aGUgZ3VpZGFuY2UgZnJvbSBFcmljIGlzIHRo
YXQgZHJpdmVycyBzZWVraW5nIGhpZ2ggcGVyZm9ybWFuY2UNCj4gwqBzaG91bGQgdXNlIG5hcGlf
Z3JvX2ZyYWdzKCksIGFzIHRoaXMgYWxsb3dzIEdSTyB0byByZWN5Y2xlIHRoZSBTS0IuDQoNCkJ1
dCB0aGlzIGd1aWRhbmNlIGlzIGZvciBHUk8tYWJsZSBmcmFtZXMgb25seSwgcmlnaHQ/IElmIEkg
dHJ5IHRvIHVzZQ0KbmFwaV9ncm9fZnJhZ3MoKSBpbmRpc2NyaW1pbmF0ZWx5IG9uIHRoZSBSeCBw
YXRoLCBJIGdldCBhIGJpZw0KcGVyZm9ybWFuY2UgcGVuYWx0eSBpbiBzb21lIGNhc2VzIC0gZS5n
LiBmb3J3YXJkaW5nIG9mIG5vbi1UQ1ANCnNpbmdsZSBidWZmZXIgZnJhbWVzLg0KDQpPbiB0aGUg
b3RoZXIgaGFuZCwgRXJpYyBzaG90IGRvd24gbXkgYXR0ZW1wdCB0byBkaWZmZXJlbnRpYXRlIGJl
dHdlZW4NClRDUCBhbmQgbm9uLVRDUCBmcmFtZXMgaW5zaWRlIHRoZSBkcml2ZXIgKHNlZSANCmh0
dHBzOi8vcGF0Y2h3b3JrLm96bGFicy5vcmcvcGF0Y2gvMTEzNTgxNy8jMjIyMjIzNiksIHNvIEkn
bSBub3QNCnJlYWxseSBzdXJlIHdoYXQncyB0aGUgcmVjb21tZW5kZWQgYXBwcm9hY2ggaGVyZT8N
Cg0KPiANCj4gQWxsIG9mIHRoaXMgdG9nZXRoZXIgbWVhbnMgSSBkb24ndCBwbGFuIHRvIHN1Ym1p
dCBzdWNoIGEgcGF0Y2g7IEkNCj4gwqB3b3VsZCBob3dldmVyIGJlIGhhcHB5IHRvIHJldmlldyBh
IHBhdGNoIGlmIHNvbWVvbmUgZWxzZSB3cml0ZXMgb25lLg0KDQpUaGFua3MgYSBsb3QgZm9yIHRo
ZSBleHBsYW5hdGlvbnMhDQpJb2FuYQ0K
