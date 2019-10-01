Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00720C427F
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfJAVRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:17:46 -0400
Received: from mail-eopbgr60124.outbound.protection.outlook.com ([40.107.6.124]:42755
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726681AbfJAVRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 17:17:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NiBpETAOBqpSTBWjLVYdj2+OHEjZk69x5g15iPq5ADKixIr1Xt5PeuKdDTdA4BvVGXSAe8ABGUBLBpEYMBqonCGt98lOQ6PzgIsCu9XjsrhU6TF9RYxEVy3ykIw8XSTVoVh3zDnGxqbR2iTLgf3iMLWJYQrmR4Dxu8DIFsjmQnbRHqYUXyUo1d4t2K2YBeACdqNOAQ2GTtDRzZ/X2T005KeqHKE3ab1VdgB7AwYmTkgDD3NvYkKVvr02tzGh5lhr9NskyMsA1AmHQq54VG2zX55jQuW/q1d8SVPiim0sKkg4ZQWJhhPcAQjP19kXj91XcqkOglNhWLJyXOR29GiSdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZQMoEdwZW9fbH8RS0CdA4ktON/JljHylgfHUJi0U/A=;
 b=fRROq4FheC0eBt7eEhyoJ3X5S9cw8zVy+ajpWBrbC+SopjDFbAcfZDyu5KeJpnhf0fZ7RrABvGggoLHG3qrXi/LADE7PFj3PTSLxWnpwv0djCEWa2eTnxGjj/5Dh7yjr1mIU2Z70lpifPIdzztu89dSNaNy8du76qaik5tT+bKhDfASnENjfpwQblI8pWN1OA5FNq5RSTI/0Wq4O2/xQIvIXXx6KQF2PPNGskgozxoHbiNrZf7r4ALiecEvlISmWbzRdl3cZ2iryIV04zRIpH2fXqRnV57DlWUYUcO39iM3Og9f4FlVw6517g3JWCIdWRKVw7hK4c80/fnLvHzZung==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZQMoEdwZW9fbH8RS0CdA4ktON/JljHylgfHUJi0U/A=;
 b=OBGRDUKOLl7rAMXm5o9IU3KUBAiobamK25F/k34HufZjCSn6QvXOPUW+pZXLJX3APZuxblFRWf9NsINdHkzM4js3io9/VXtMiw1N03prgYT8FswFNTQTG6GGKwZ8xJmXUiYaMIR9PxDedhyMT54JlUSYxwa3w4oHLdBm7jsVHm4=
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com (10.173.82.19) by
 VI1PR0701MB2173.eurprd07.prod.outlook.com (10.169.135.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.9; Tue, 1 Oct 2019 21:17:01 +0000
Received: from VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1]) by VI1PR0701MB2623.eurprd07.prod.outlook.com
 ([fe80::dc92:2e0d:561a:fbb1%8]) with mapi id 15.20.2305.017; Tue, 1 Oct 2019
 21:17:01 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] can: D_CAN: perform a sofware reset on open
Thread-Topic: [PATCH 1/2] can: D_CAN: perform a sofware reset on open
Thread-Index: AQHVdEd7etT22gKeN0iCyvC9ZUyGFadF4WyAgABxJIA=
Date:   Tue, 1 Oct 2019 21:17:01 +0000
Message-ID: <04f38523-07fb-4ea9-3031-932176f68660@victronenergy.com>
References: <20190926085005.24805-1-jhofstee@victronenergy.com>
 <20190926085005.24805-2-jhofstee@victronenergy.com>
 <b30e9834-a324-ad97-2050-df9600a95347@pengutronix.de>
In-Reply-To: <b30e9834-a324-ad97-2050-df9600a95347@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-originating-ip: [2001:1c01:3bc5:4e00:5c2:1c3a:9351:514c]
x-clientproxiedby: AM3PR07CA0066.eurprd07.prod.outlook.com
 (2603:10a6:207:4::24) To VI1PR0701MB2623.eurprd07.prod.outlook.com
 (2603:10a6:801:b::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhofstee@victronenergy.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b3cc6b0-6ec7-420c-2b04-08d746b4b32f
x-ms-traffictypediagnostic: VI1PR0701MB2173:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0701MB2173085A7D0C7702493FCA7BC09D0@VI1PR0701MB2173.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(4636009)(346002)(396003)(39850400004)(376002)(366004)(136003)(199004)(189003)(186003)(446003)(305945005)(486006)(2501003)(36756003)(6486002)(6436002)(2616005)(7736002)(102836004)(11346002)(476003)(6506007)(53546011)(386003)(86362001)(52116002)(6306002)(81156014)(6512007)(76176011)(8676002)(46003)(229853002)(81166006)(31686004)(6246003)(110136005)(256004)(31696002)(316002)(65806001)(99286004)(71200400001)(71190400001)(14454004)(54906003)(66556008)(25786009)(8936002)(4326008)(65956001)(2906002)(5660300002)(478600001)(58126008)(966005)(66446008)(66476007)(64756008)(6116002)(66946007)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR0701MB2173;H:VI1PR0701MB2623.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: victronenergy.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j4CShGhBO0bHbTXSi5VnyOog+8t/L2ecCnNLiURcXN21wDVXhsyzBlvy59IYrojjOHpj/54pfzvQoK9XtPtpbyHlPzuVPRnc6gWa81Dac+RueX61OAixEOGVLiEm61xX5kPLcvf9MIT9qWLxW5jaq5WKCdiboETZuFYysJpfMyckwBHMnMoCIDzs7t0GZ6cfw2HarFI2upbVhMiDcDKSkjtlHF10VQuTXOJy/RmONp/gsBHPVOarzThfY3Pccuj7BXlQzzO/56TX2EMYnCuT/V5Xe7wobat014iGBHx2Q/VxUdzhLQKoRSSvmWMjKzg+zZo4IbR3kyZZGKIt41acYh27NEVAevHPRX/Tv/6ft+isA8XR52mjJk043thskItbgRT+8gjPGz29PDIlGCV0QI/3PYnSZaslRBuJdeHdszrYacLSxKqpgxaftLLZn7F7qIyULTbYc5Pxn24UR1lx6g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7F7F6AD8CEF9145A094951C873E3341@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b3cc6b0-6ec7-420c-2b04-08d746b4b32f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2019 21:17:01.2773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vN2YWlS255ZHWCUYNNTrvi0b4ZJDhlMZ+bueY1PUKOiEzPFQj+US24UJnBsGtYZyiAhzWHTfvm74hwq2ySTcx8ZjB4CkCNwoIT/yng62hy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0701MB2173
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gTWFyYywNCg0KT24gMTAvMS8xOSA0OjMyIFBNLCBNYXJjIEtsZWluZS1CdWRkZSB3cm90
ZToNCj4gT24gOS8yNi8xOSAxMDo1MCBBTSwgSmVyb2VuIEhvZnN0ZWUgd3JvdGU6DQo+PiBXaGVu
IHRoZSBDX0NBTiBpbnRlcmZhY2UgaXMgY2xvc2VkIGl0IGlzIHB1dCBpbiBwb3dlciBkb3duIG1v
ZGUsIGJ1dA0KPj4gZG9lcyBub3QgcmVzZXQgdGhlIGVycm9yIGNvdW50ZXJzIC8gc3RhdGUuIFNv
IHJlc2V0IHRoZSBEX0NBTiBvbiBvcGVuLA0KPj4gc28gdGhlIHJlcG9ydGVkIHN0YXRlIGFuZCB0
aGUgYWN0dWFsIHN0YXRlIG1hdGNoLg0KPj4NCj4+IEFjY29yZGluZyB0byBbMV0sIHRoZSBDX0NB
TiBtb2R1bGUgZG9lc24ndCBoYXZlIHRoZSBzb2Z0d2FyZSByZXNldC4NCj4+DQo+PiBbMV0gaHR0
cDovL3d3dy5ib3NjaC1zZW1pY29uZHVjdG9ycy5jb20vbWVkaWEvaXBfbW9kdWxlcy9wZGZfMi9j
X2Nhbl9mZDgvdXNlcnNfbWFudWFsX2NfY2FuX2ZkOF9yMjEwXzEucGRmDQo+Pg0KPj4gU2lnbmVk
LW9mZi1ieTogSmVyb2VuIEhvZnN0ZWUgPGpob2ZzdGVlQHZpY3Ryb25lbmVyZ3kuY29tPg0KPj4g
LS0tDQo+PiAgIGRyaXZlcnMvbmV0L2Nhbi9jX2Nhbi9jX2Nhbi5jIHwgMjYgKysrKysrKysrKysr
KysrKysrKysrKysrKysNCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDI2IGluc2VydGlvbnMoKykNCj4+
DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvY2FuL2NfY2FuL2NfY2FuLmMgYi9kcml2ZXJz
L25ldC9jYW4vY19jYW4vY19jYW4uYw0KPj4gaW5kZXggNjA2YjdkOGZmZTEzLi41MDJhMTgxZDAy
ZTcgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC9jYW4vY19jYW4vY19jYW4uYw0KPj4gKysr
IGIvZHJpdmVycy9uZXQvY2FuL2NfY2FuL2NfY2FuLmMNCj4+IEBAIC01Miw2ICs1Miw3IEBADQo+
PiAgICNkZWZpbmUgQ09OVFJPTF9FWF9QRFIJCUJJVCg4KQ0KPj4gICANCj4+ICAgLyogY29udHJv
bCByZWdpc3RlciAqLw0KPj4gKyNkZWZpbmUgQ09OVFJPTF9TV1IJCUJJVCgxNSkNCj4+ICAgI2Rl
ZmluZSBDT05UUk9MX1RFU1QJCUJJVCg3KQ0KPj4gICAjZGVmaW5lIENPTlRST0xfQ0NFCQlCSVQo
NikNCj4+ICAgI2RlZmluZSBDT05UUk9MX0RJU0FCTEVfQVIJQklUKDUpDQo+PiBAQCAtNTY5LDYg
KzU3MCwyNiBAQCBzdGF0aWMgdm9pZCBjX2Nhbl9jb25maWd1cmVfbXNnX29iamVjdHMoc3RydWN0
IG5ldF9kZXZpY2UgKmRldikNCj4+ICAgCQkJCSAgIElGX01DT05UX1JDVl9FT0IpOw0KPj4gICB9
DQo+PiAgIA0KPj4gK3N0YXRpYyBpbnQgc29mdHdhcmVfcmVzZXQoc3RydWN0IG5ldF9kZXZpY2Ug
KmRldikNCj4gUGxlYXNlIGFkZCB0aGUgY29tbW9uIHByZWZpeCAiY19jYW5fIiB0byB0aGUgZnVu
Y3Rpb24NCg0KRmluZSB3aXRoIG1lLCBJIGRpZCBzZW50IGEgdjIuDQoNClJlZ2FyZHMsDQpKZXJv
ZW4NCg0K
