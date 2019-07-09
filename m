Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B64963CA0
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 22:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbfGIUQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 16:16:29 -0400
Received: from mail-eopbgr700040.outbound.protection.outlook.com ([40.107.70.40]:58625
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729165AbfGIUQ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 16:16:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UhGhIuFXIOyflNMGdqGdS0i3vWEzYlQ82RcY26Uj3oc=;
 b=NXqm2flOrAmCe9BTe2vHeGx6DX5lx7AheISuovmfOIGp74hFDHm+HvzOaGoTKDzPbhDINacl+aTqhDW7uD/QCX2aSoSM7VoMl/cVP60OE45g69CH38VsST44JfbYRKiaJWFpu+HryTjk6VqKPz2X/8/i1WBbfDj1vr+NvY1kipk=
Received: from MN2PR15MB3581.namprd15.prod.outlook.com (52.132.172.94) by
 MN2PR15MB2816.namprd15.prod.outlook.com (20.179.148.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Tue, 9 Jul 2019 20:15:44 +0000
Received: from MN2PR15MB3581.namprd15.prod.outlook.com
 ([fe80::7d02:e054:fcd1:f7a0]) by MN2PR15MB3581.namprd15.prod.outlook.com
 ([fe80::7d02:e054:fcd1:f7a0%7]) with mapi id 15.20.2052.020; Tue, 9 Jul 2019
 20:15:44 +0000
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] tipc: ensure skb->lock is initialised
Thread-Topic: [PATCH] tipc: ensure skb->lock is initialised
Thread-Index: AQHVNRbZCg2+IkEFUEKEsAEksjW2W6bB5j8AgABgI5CAAAiXAIAAV45A
Date:   Tue, 9 Jul 2019 20:15:43 +0000
Message-ID: <MN2PR15MB35813EA3ADE7E5E83A657D3F9AF10@MN2PR15MB3581.namprd15.prod.outlook.com>
References: <20190707225328.15852-1-chris.packham@alliedtelesis.co.nz>
 <2298b9eb-100f-6130-60c4-0e5e2c7b84d1@gmail.com>
 <361940337b0d4833a5634ddd1e1896a9@svr-chch-ex1.atlnz.lc>
 <87fd2150548041219fc42bce80b63c9c@svr-chch-ex1.atlnz.lc>
 <b862a74b-9f1e-fb64-0641-550a83b64664@gmail.com>
 <MN2PR15MB35811151C4A627C0AF364CAC9AF10@MN2PR15MB3581.namprd15.prod.outlook.com>
 <ef9a2ec1-1413-e8f9-1193-d53cf8ee52ba@gmail.com>
In-Reply-To: <ef9a2ec1-1413-e8f9-1193-d53cf8ee52ba@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jon.maloy@ericsson.com; 
x-originating-ip: [24.225.233.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24d44e21-b776-42f1-b8e1-08d704aa38fd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR15MB2816;
x-ms-traffictypediagnostic: MN2PR15MB2816:
x-microsoft-antispam-prvs: <MN2PR15MB28160DD2E6721138BB8D67169AF10@MN2PR15MB2816.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(189003)(199004)(13464003)(7696005)(2906002)(99286004)(305945005)(476003)(74316002)(316002)(6506007)(102836004)(53546011)(54906003)(478600001)(14454004)(110136005)(26005)(186003)(33656002)(4326008)(14444005)(256004)(2501003)(76176011)(8676002)(8936002)(68736007)(11346002)(71190400001)(446003)(44832011)(486006)(81156014)(81166006)(6436002)(25786009)(5660300002)(2201001)(86362001)(66476007)(76116006)(66556008)(52536014)(66446008)(64756008)(66946007)(7736002)(53936002)(6116002)(9686003)(3846002)(55016002)(71200400001)(66066001)(6246003)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR15MB2816;H:MN2PR15MB3581.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: ericsson.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pfAykqAVsvo5XE/N0/CQJedya5n5mt99lIC+OxqIiiKtNoEamBk2PhSZJ5Ymn34Wf8HEBV39yhjtCghmhyWOZeebdh2xblaO2VsGT726LqsG9OzeJh1QK04JaPApIPYhhh7PePHJjhV2v6LzKrlq/Uq6DR5+WDVXRv2z23moWYpbG2jEXBW/hpOH5OXW/bynaD/9YeDLX1AR/YRtnWaTr3z/IO28z+ysnbZ2nMdqTN2rzl4GKlDZgq+0sW+CTFqhUEq+l6xpcGFe1MZS3d9VTjYaBolWuKyVnZHqItkQFLFDfqlwWiz2BUheKEPoeiVmOSOsLn8GuxJD6oafbd53T1Is4sdjPFFTCwiEuJz4jrWlOD9fiikr7yhNO7Urfq6vH+VQgpZKp9vhrtA7z29Bj+zQ/a4a5MQkNiCKYibIviQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24d44e21-b776-42f1-b8e1-08d704aa38fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 20:15:44.0599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jon.maloy@ericsson.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2816
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJpYyBEdW1hemV0IDxl
cmljLmR1bWF6ZXRAZ21haWwuY29tPg0KPiBTZW50OiA5LUp1bC0xOSAwOTo0Ng0KPiBUbzogSm9u
IE1hbG95IDxqb24ubWFsb3lAZXJpY3Nzb24uY29tPjsgRXJpYyBEdW1hemV0DQo+IDxlcmljLmR1
bWF6ZXRAZ21haWwuY29tPjsgQ2hyaXMgUGFja2hhbQ0KPiA8Q2hyaXMuUGFja2hhbUBhbGxpZWR0
ZWxlc2lzLmNvLm56PjsgeWluZy54dWVAd2luZHJpdmVyLmNvbTsNCj4gZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldA0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgdGlwYy1kaXNjdXNzaW9uQGxpc3Rz
LnNvdXJjZWZvcmdlLm5ldDsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3Vi
amVjdDogUmU6IFtQQVRDSF0gdGlwYzogZW5zdXJlIHNrYi0+bG9jayBpcyBpbml0aWFsaXNlZA0K
PiANCj4gDQo+IA0KPiBPbiA3LzkvMTkgMzoyNSBQTSwgSm9uIE1hbG95IHdyb3RlOg0KDQpbLi4u
XQ0KDQo+ID4gVElQQyBpcyB1c2luZyB0aGUgbGlzdCBsb2NrIGF0IG1lc3NhZ2UgcmVjZXB0aW9u
IHdpdGhpbiB0aGUgc2NvcGUgb2YNCj4gdGlwY19za19yY3YoKS90aXBjX3NrYl9wZWVrX3BvcnQo
KSwgc28gaXQgaXMgZnVuZGFtZW50YWwgdGhhdCB0aGUgbG9jayBhbHdheXMNCj4gaXMgY29ycmVj
dGx5IGluaXRpYWxpemVkLg0KPiANCj4gV2hlcmUgaXMgdGhlIGxvY2sgYWNxdWlyZWQsIHdoeSB3
YXMgaXQgb25seSBhY3F1aXJlZCBieSBxdWV1ZSBwdXJnZSBhbmQgbm90DQo+IG5vcm1hbCBkZXF1
ZXVlcyA/Pz8NCg0KSXQgaXMgYWNxdWlyZWQgdHdpY2U6DQotIEZpcnN0LCBpbiB0aXBjX3NrX3Jj
digpLT50aXBjX3NrYl9wZWVrX3BvcnQoKSwgdG8gcGVlayBpbnRvIG9uZSBvciBtb3JlIHF1ZXVl
IG1lbWJlcnMgYW5kIHJlYWQgdGhlaXIgZGVzdGluYXRpb24gcG9ydCBudW1iZXIuDQotIFNlY29u
ZCwgaW4gdGlwY19za19yY3YoKS0+dGlwY19za19lbnF1ZXVlKCktPnRpcGNfc2tiX2RlcXVldWUo
KSB0byB1bmxpbmsgYSBsaXN0IG1lbWJlciBmcm9tIHRoZSBxdWV1ZS4NCg0KPiA+Pg0KPiA+IFsu
Li5dDQo+ID4+DQo+ID4+IHRpcGNfbGlua194bWl0KCkgZm9yIGV4YW1wbGUgbmV2ZXIgYWNxdWly
ZXMgdGhlIHNwaW5sb2NrLCB5ZXQgdXNlcw0KPiA+PiBza2JfcGVlaygpIGFuZCBfX3NrYl9kZXF1
ZXVlKCkNCj4gPg0KPiA+DQo+ID4gWW91IHNob3VsZCBsb29rIGF0IHRpcGNfbm9kZV94bWl0IGlu
c3RlYWQuIE5vZGUgbG9jYWwgbWVzc2FnZXMgYXJlDQo+ID4gc2VudCBkaXJlY3RseSB0byB0aXBj
X3NrX3JjdigpLCBhbmQgbmV2ZXIgZ28gdGhyb3VnaCB0aXBjX2xpbmtfeG1pdCgpDQo+IA0KPiB0
aXBjX25vZGVfeG1pdCgpIGNhbGxzIHRpcGNfbGlua194bWl0KCkgZXZlbnR1YWxseSwgcmlnaHQg
Pw0KDQpOby4gDQp0aXBjX2xpbmtfeG1pdCgpIGlzIGNhbGxlZCBvbmx5IGZvciBtZXNzYWdlcyB3
aXRoIGEgbm9uLWxvY2FsIGRlc3RpbmF0aW9uLiAgT3RoZXJ3aXNlLCB0aXBjX25vZGVfeG1pdCgp
IHNlbmRzIG5vZGUgbG9jYWwgbWVzc2FnZXMgZGlyZWN0bHkgdG8gdGhlIGRlc3RpbmF0aW9uIHNv
Y2tldCB2aWEgdGlwY19za19yY3YoKS4NClRoZSBhcmd1bWVudCAneG1pdHEnIGJlY29tZXMgJ2lu
cHV0cScgaW4gdGlwY19za19yY3YoKSBhbmQgJ2xpc3QnIGluIHRpcGNfc2tiX3BlZWtfcG9ydCgp
LCBzaW5jZSB0aG9zZSBmdW5jdGlvbnMgZG9uJ3QgZGlzdGluZ3Vpc2ggYmV0d2VlbiBsb2NhbCBh
bmQgbm9kZSBleHRlcm5hbCBpbmNvbWluZyBtZXNzYWdlcy4NCg0KPiANCj4gUGxlYXNlIHNob3cg
bWUgd2hlcmUgdGhlIGhlYWQtPmxvY2sgaXMgYWNxdWlyZWQsIGFuZCB3aHkgaXQgbmVlZGVkLg0K
DQpUaGUgYXJndW1lbnQgICdpbnB1dHEnICB0byB0aXBjX3NrX3JjdigpIG1heSBjb21lIGZyb20g
dHdvIHNvdXJjZXM6IA0KMSkgQXMgYW4gYWdncmVnYXRlZCBtZW1iZXIgb2YgZWFjaCB0aXBjX25v
ZGU6OnRpcGNfbGlua19lbnRyeS4gVGhpcyBxdWV1ZSBpcyBuZWVkZWQgdG8gZ3VhcmFudGVlIHNl
cXVlbnRpYWwgZGVsaXZlcnkgb2YgbWVzc2FnZXMgZnJvbSB0aGUgbm9kZS9saW5rIGxheWVyIHRv
IHRoZSBzb2NrZXQgbGF5ZXIuIEluIHRoaXMgY2FzZSwgdGhlcmUgbWF5IGJlIGJ1ZmZlcnMgZm9y
IG11bHRpcGxlIGRlc3RpbmF0aW9uIHNvY2tldHMgaW4gdGhlIHNhbWUgcXVldWUsIGFuZCB3ZSBt
YXkgaGF2ZSBtdWx0aXBsZSBjb25jdXJyZW50IHRpcGNfc2tfcmN2KCkgam9icyB3b3JraW5nIHRo
YXQgcXVldWUuIFNvLCB0aGUgbG9jayBpcyBuZWVkZWQgYm90aCBmb3IgYWRkaW5nIChpbiAgbGlu
ay5jOjp0aXBjX2RhdGFfaW5wdXQoKSksIHBlZWtpbmcgYW5kIHJlbW92aW5nIGJ1ZmZlcnMuDQoN
CjIpIFRoZSBjYXNlIHlvdSBoYXZlIGJlZW4gbG9va2luZyBhdCwgd2hlcmUgaXQgaXMgY3JlYXRl
ZCBhcyAneG1pdHEnIG9uIHRoZSBzdGFjayBieSBhIGxvY2FsIHNvY2tldC4gIEhlcmUsIHRoZSBs
b2NrIGlzIG5vdCBzdHJpY3RseSBuZWVkZWQsIGFzIHlvdSBoYXZlIG9ic2VydmVkLiBCdXQgdG8g
cmVkdWNlIGNvZGUgZHVwbGljYXRpb24gd2UgaGF2ZSBjaG9zZW4gdG8gbGV0IHRoZSBjb2RlIGlu
IHRpcGNfc2tfcmN2KCkgaGFuZGxlIGJvdGggdHlwZXMgb2YgcXVldWVzIHVuaWZvcm1seSwgaS5l
LiwgYXMgaWYgdGhleSBhbGwgY29udGFpbiBidWZmZXJzIHdpdGggcG90ZW50aWFsbHkgbXVsdGlw
bGUgZGVzdGluYXRpb24gc29ja2V0cywgd29ya2VkIG9uIGJ5IG11bHRpcGxlIGNvbmN1cnJlbnQg
Y2FsbHMuIFRoaXMgcmVxdWlyZXMgdGhhdCB0aGUgbG9jayBpcyBpbml0aWFsaXplZCBldmVuIGZv
ciB0aGlzIHR5cGUgb2YgcXVldWUuIFdlIGhhdmUgc2VlbiBubyBtZWFzdXJhYmxlIHBlcmZvcm1h
bmNlIGRpZmZlcmVuY2UgYmV0d2VlbiB0aGlzICdnZW5lcmljJyByZWNlcHRpb24gYWxnb3JpdGht
IGFuZCBhIHRhaWxvci1tYWRlIGRpdHRvIGZvciBsb2NhbCBtZXNzYWdlcyBvbmx5LCAgd2hpbGUg
dGhlIGFtb3VudCBvZiBzYXZlZCBjb2RlIGlzIHNpZ25pZmljYW50Lg0KDQo+IA0KPiBJZiB0aGlz
IGlzIG1hbmRhdG9yeSwgdGhlbiBtb3JlIGZpeGVzIGFyZSBuZWVkZWQgdGhhbiBqdXN0IGluaXRp
YWxpemluZyB0aGUgbG9jaw0KPiBmb3IgbG9ja2RlcCBwdXJwb3Nlcy4NCg0KSXQgaXMgbm90IG9u
bHkgZm9yIGxvY2tkZXAgcHVycG9zZXMsIC1pdCBpcyBlc3NlbnRpYWwuICBCdXQgcGxlYXNlIHBy
b3ZpZGUgZGV0YWlscyBhYm91dCB3aGVyZSB5b3Ugc2VlIHRoYXQgbW9yZSBmaXhlcyBhcmUgbmVl
ZGVkLg0KDQpCUg0KLy8vam9uDQoNCg0K
