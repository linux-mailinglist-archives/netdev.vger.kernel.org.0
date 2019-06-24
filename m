Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C75A6505F4
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 11:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbfFXJk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 05:40:26 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:10439 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfFXJk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 05:40:26 -0400
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.63,411,1557212400"; 
   d="scan'208";a="38619739"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jun 2019 02:40:24 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex01.mchp-main.com (10.10.87.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 24 Jun 2019 02:40:23 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5 via Frontend
 Transport; Mon, 24 Jun 2019 02:40:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ndqZxmJEHi/yp3s8nmdtPdYVVEDyz3XboI48dhOU5w=;
 b=xgeKvwJY5A0UBIe/ZJp4xbjvcuIKMu/c87tppi0x/KxaUFWIIGcUJQxRQlinHUkH07dlTga6VZBvOahupeoqu3us9eoNq1oH/aaVbf9VGVbZAL8kWfOD+YgaYGDIT/iVOXDQKMCppyVMLNmt5Lt3Gn2wHzIRcWbjQrGPWW5h12Q=
Received: from MWHPR11MB1662.namprd11.prod.outlook.com (10.172.55.15) by
 MWHPR11MB1536.namprd11.prod.outlook.com (10.172.53.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 09:40:21 +0000
Received: from MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::7534:63dc:8504:c2b3]) by MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::7534:63dc:8504:c2b3%6]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 09:40:21 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <palmer@sifive.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] net: macb: Fix compilation on systems without
 COMMON_CLK
Thread-Topic: [PATCH 1/2] net: macb: Fix compilation on systems without
 COMMON_CLK
Thread-Index: AQHVKnDXi485ADnTLUKbfkOedJsT3g==
Date:   Mon, 24 Jun 2019 09:40:21 +0000
Message-ID: <c440e194-dc93-5a3e-7608-710afade9774@microchip.com>
References: <20190624061603.1704-1-palmer@sifive.com>
 <20190624061603.1704-2-palmer@sifive.com>
In-Reply-To: <20190624061603.1704-2-palmer@sifive.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0224.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::20) To MWHPR11MB1662.namprd11.prod.outlook.com
 (2603:10b6:301:e::15)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [213.41.198.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4cb21e2f-2468-443d-acf1-08d6f887f96c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1536;
x-ms-traffictypediagnostic: MWHPR11MB1536:
x-microsoft-antispam-prvs: <MWHPR11MB153649732609BBB79522C024E0E00@MWHPR11MB1536.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(39860400002)(346002)(136003)(366004)(189003)(199004)(7736002)(86362001)(305945005)(11346002)(446003)(2616005)(486006)(476003)(52116002)(68736007)(99286004)(386003)(71190400001)(66446008)(6506007)(64756008)(66556008)(26005)(53546011)(102836004)(66476007)(36756003)(2906002)(66066001)(8676002)(478600001)(2501003)(72206003)(73956011)(14454004)(186003)(14444005)(256004)(31686004)(8936002)(53936002)(6512007)(5660300002)(71200400001)(4326008)(81166006)(81156014)(76176011)(3846002)(6246003)(6436002)(110136005)(229853002)(6486002)(25786009)(316002)(54906003)(6116002)(31696002)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1536;H:MWHPR11MB1662.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9rh6uJ8Q/zvMrRqzBlmL4e43jVrpwVLtuBewI9dyxk/trf1Ya0OyhzcMmK7x7hWFvfXylTFy9Y96FfTsmr5kAF0+Z7vqf2N/aP86ancX9xjlY2xFv4A36L0R7oEpkzLpBHpBtYfb9pARm9Kz+WWGMAHZczEKjm0D20JyFnRCc6XRF7rdy6n3UphKjp895kAvMcriD0OZAMFA8hzek6ZwVL86cLuPAfl6X1husukNUz6sJ8gRRii2zfqaqdIfhNtjr6ayrsf7UgqqRsJW47syAirzUSezrL/x2SDlgSlJu+9Ymiwu9He2Vej+N2r6IBubTht7CVa/vH3yxVNGQPEssDyP1DVgAHwqtFMyFSd6DYTqzzVaXE3r5bKOawwoopY7peo0TEZvPYKO6UWNkddqOGt5pncVZikt29ZNtSLWGOE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <11CFFB9686219D40AB9585E5D8E1A4F2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb21e2f-2468-443d-acf1-08d6f887f96c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 09:40:21.3380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nicolas.ferre@microchip.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1536
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjQvMDYvMjAxOSBhdCAwODoxNiwgUGFsbWVyIERhYmJlbHQgd3JvdGU6DQo+IEV4dGVybmFs
IEUtTWFpbA0KPiANCj4gDQo+IFRoZSBwYXRjaCB0byBhZGQgc3VwcG9ydCBmb3IgdGhlIEZVNTQw
LUMwMDAgYWRkZWQgYSBkZXBlbmRlbmN5IG9uDQo+IENPTU1PTl9DTEssIGJ1dCBkaWRuJ3QgZXhw
cmVzcyB0aGF0IHZpYSBLY29uZmlnLiAgVGhpcyBmaXhlcyB0aGUgYnVpbGQNCj4gZmFpbHVyZSBi
eSBhZGRpbmcgQ09ORklHX01BQ0JfRlU1NDAsIHdoaWNoIGRlcGVuZHMgb24gQ09NTU9OX0NMSyBh
bmQNCj4gY29uZGl0aW9uYWxseSBlbmFibGVzIHRoZSBGVTU0MC1DMDAwIHN1cHBvcnQuDQoNCkxl
dCdzIHRyeSB0byBsaW1pdCB0aGUgdXNlIG9mICAjaWZkZWYncyB0aHJvdWdob3V0IHRoZSBjb2Rl
LiBXZSBhcmUgDQp1c2luZyB0aGVtIGluIHRoaXMgZHJpdmVyIGJ1dCBvbmx5IGZvciB0aGUgaG90
IHBhdGhzIGFuZCB0aGluZ3MgdGhhdCANCmhhdmUgYW4gaW1wYWN0IG9uIHBlcmZvcm1hbmNlLiBJ
IGRvbid0IHRoaW5rIGl0J3MgdGhlIGNhc2UgaGVyZTogc28gDQpwbGVhc2UgZmluZCBhbm90aGVy
IG9wdGlvbiA9PiBOQUNLLg0KDQo+IEkndmUgYnVpbHQgdGhpcyB3aXRoIGEgcG93ZXJwYyBhbGx5
ZXNjb25maWcgKHdoaWNoIHBvaW50ZWQgb3V0IHRoZSBidWcpDQo+IGFuZCBvbiBSSVNDLVYsIG1h
bnVhbGx5IGNoZWNraW5nIHRvIGVuc3VyZSB0aGUgY29kZSB3YXMgYnVpbHQuICBJDQo+IGhhdmVu
J3QgZXZlbiBib290ZWQgdGhlIHJlc3VsdGluZyBrZXJuZWxzLg0KPiANCj4gRml4ZXM6IGMyMThh
ZDU1OTAyMCAoIm1hY2I6IEFkZCBzdXBwb3J0IGZvciBTaUZpdmUgRlU1NDAtQzAwMCIpDQo+IFNp
Z25lZC1vZmYtYnk6IFBhbG1lciBEYWJiZWx0IDxwYWxtZXJAc2lmaXZlLmNvbT4NCj4gLS0tDQo+
ICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9LY29uZmlnICAgICB8IDExICsrKysrKysr
KysrDQo+ICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyB8IDEyICsr
KysrKysrKysrKw0KPiAgIDIgZmlsZXMgY2hhbmdlZCwgMjMgaW5zZXJ0aW9ucygrKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvS2NvbmZpZyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvS2NvbmZpZw0KPiBpbmRleCAxNzY2Njk3YzljNWEuLjc0
ZWUyYmZkMjM2OSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9L
Y29uZmlnDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvS2NvbmZpZw0KPiBA
QCAtNDAsNiArNDAsMTcgQEAgY29uZmlnIE1BQ0JfVVNFX0hXU1RBTVANCj4gICAJLS0taGVscC0t
LQ0KPiAgIAkgIEVuYWJsZSBJRUVFIDE1ODggUHJlY2lzaW9uIFRpbWUgUHJvdG9jb2wgKFBUUCkg
c3VwcG9ydCBmb3IgTUFDQi4NCj4gICANCj4gK2NvbmZpZyBNQUNCX0ZVNTQwDQo+ICsJYm9vbCAi
RW5hYmxlIHN1cHBvcnQgZm9yIHRoZSBTaUZpdmUgRlU1NDAgY2xvY2sgY29udHJvbGxlciINCj4g
KwlkZXBlbmRzIG9uIE1BQ0IgJiYgQ09NTU9OX0NMSw0KPiArCWRlZmF1bHQgeQ0KPiArCS0tLWhl
bHAtLS0NCj4gKwkgIEVuYWJsZSBzdXBwb3J0IGZvciB0aGUgTUFDQi9HRU0gY2xvY2sgY29udHJv
bGxlciBvbiB0aGUgU2lGaXZlDQo+ICsJICBGVTU0MC1DMDAwLiAgVGhpcyBkZXZpY2UgaXMgbmVj
ZXNzYXJ5IGZvciBzd2l0Y2hpbmcgYmV0d2VlbiAxMC8xMDANCj4gKwkgIGFuZCBnaWdhYml0IG1v
ZGVzIG9uIHRoZSBGVTU0MC1DMDAwIFNvQywgd2l0aG91dCB3aGljaCBpdCBpcyBvbmx5DQo+ICsJ
ICBwb3NzaWJsZSB0byBicmluZyB1cCB0aGUgRXRoZXJuZXQgbGluayBpbiB3aGF0ZXZlciBtb2Rl
IHRoZQ0KPiArCSAgYm9vdGxvYWRlciBwcm9iZWQuDQo+ICsNCj4gICBjb25maWcgTUFDQl9QQ0kN
Cj4gICAJdHJpc3RhdGUgIkNhZGVuY2UgUENJIE1BQ0IvR0VNIHN1cHBvcnQiDQo+ICAgCWRlcGVu
ZHMgb24gTUFDQiAmJiBQQ0kgJiYgQ09NTU9OX0NMSw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Nh
ZGVuY2UvbWFjYl9tYWluLmMNCj4gaW5kZXggYzU0NWM1YjQzNWQ4Li5hOTAzZGZkZDQxODMgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4g
KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiBAQCAtNDEs
NiArNDEsNyBAQA0KPiAgICNpbmNsdWRlIDxsaW51eC9wbV9ydW50aW1lLmg+DQo+ICAgI2luY2x1
ZGUgIm1hY2IuaCINCj4gICANCj4gKyNpZmRlZiBDT05GSUdfTUFDQl9GVTU0MA0KPiAgIC8qIFRo
aXMgc3RydWN0dXJlIGlzIG9ubHkgdXNlZCBmb3IgTUFDQiBvbiBTaUZpdmUgRlU1NDAgZGV2aWNl
cyAqLw0KPiAgIHN0cnVjdCBzaWZpdmVfZnU1NDBfbWFjYl9tZ210IHsNCj4gICAJdm9pZCBfX2lv
bWVtICpyZWc7DQo+IEBAIC00OSw2ICs1MCw3IEBAIHN0cnVjdCBzaWZpdmVfZnU1NDBfbWFjYl9t
Z210IHsNCj4gICB9Ow0KPiAgIA0KPiAgIHN0YXRpYyBzdHJ1Y3Qgc2lmaXZlX2Z1NTQwX21hY2Jf
bWdtdCAqbWdtdDsNCj4gKyNlbmRpZg0KPiAgIA0KPiAgICNkZWZpbmUgTUFDQl9SWF9CVUZGRVJf
U0laRQkxMjgNCj4gICAjZGVmaW5lIFJYX0JVRkZFUl9NVUxUSVBMRQk2NCAgLyogYnl0ZXMgKi8N
Cj4gQEAgLTM5NTYsNiArMzk1OCw3IEBAIHN0YXRpYyBpbnQgYXQ5MWV0aGVyX2luaXQoc3RydWN0
IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gICAJcmV0dXJuIDA7DQo+ICAgfQ0KPiAgIA0KPiAr
I2lmZGVmIENPTkZJR19NQUNCX0ZVNTQwDQo+ICAgc3RhdGljIHVuc2lnbmVkIGxvbmcgZnU1NDBf
bWFjYl90eF9yZWNhbGNfcmF0ZShzdHJ1Y3QgY2xrX2h3ICpodywNCj4gICAJCQkJCSAgICAgICB1
bnNpZ25lZCBsb25nIHBhcmVudF9yYXRlKQ0KPiAgIHsNCj4gQEAgLTQwNTYsNyArNDA1OSw5IEBA
IHN0YXRpYyBpbnQgZnU1NDBfYzAwMF9pbml0KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYp
DQo+ICAgDQo+ICAgCXJldHVybiBtYWNiX2luaXQocGRldik7DQo+ICAgfQ0KPiArI2VuZGlmDQo+
ICAgDQo+ICsjaWZkZWYgQ09ORklHX01BQ0JfRlU1NDANCj4gICBzdGF0aWMgY29uc3Qgc3RydWN0
IG1hY2JfY29uZmlnIGZ1NTQwX2MwMDBfY29uZmlnID0gew0KPiAgIAkuY2FwcyA9IE1BQ0JfQ0FQ
U19HSUdBQklUX01PREVfQVZBSUxBQkxFIHwgTUFDQl9DQVBTX0pVTUJPIHwNCj4gICAJCU1BQ0Jf
Q0FQU19HRU1fSEFTX1BUUCwNCj4gQEAgLTQwNjUsNiArNDA3MCw3IEBAIHN0YXRpYyBjb25zdCBz
dHJ1Y3QgbWFjYl9jb25maWcgZnU1NDBfYzAwMF9jb25maWcgPSB7DQo+ICAgCS5pbml0ID0gZnU1
NDBfYzAwMF9pbml0LA0KPiAgIAkuanVtYm9fbWF4X2xlbiA9IDEwMjQwLA0KPiAgIH07DQo+ICsj
ZW5kaWYNCj4gICANCj4gICBzdGF0aWMgY29uc3Qgc3RydWN0IG1hY2JfY29uZmlnIGF0OTFzYW05
MjYwX2NvbmZpZyA9IHsNCj4gICAJLmNhcHMgPSBNQUNCX0NBUFNfVVNSSU9fSEFTX0NMS0VOIHwg
TUFDQl9DQVBTX1VTUklPX0RFRkFVTFRfSVNfTUlJX0dNSUksDQo+IEBAIC00MTU1LDcgKzQxNjEs
OSBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG9mX2RldmljZV9pZCBtYWNiX2R0X2lkc1tdID0gew0K
PiAgIAl7IC5jb21wYXRpYmxlID0gImNkbnMsZW1hYyIsIC5kYXRhID0gJmVtYWNfY29uZmlnIH0s
DQo+ICAgCXsgLmNvbXBhdGlibGUgPSAiY2Rucyx6eW5xbXAtZ2VtIiwgLmRhdGEgPSAmenlucW1w
X2NvbmZpZ30sDQo+ICAgCXsgLmNvbXBhdGlibGUgPSAiY2Rucyx6eW5xLWdlbSIsIC5kYXRhID0g
Jnp5bnFfY29uZmlnIH0sDQo+ICsjaWZkZWYgQ09ORklHX01BQ0JfRlU1NDANCj4gICAJeyAuY29t
cGF0aWJsZSA9ICJzaWZpdmUsZnU1NDAtbWFjYiIsIC5kYXRhID0gJmZ1NTQwX2MwMDBfY29uZmln
IH0sDQo+ICsjZW5kaWYNCj4gICAJeyAvKiBzZW50aW5lbCAqLyB9DQo+ICAgfTsNCj4gICBNT0RV
TEVfREVWSUNFX1RBQkxFKG9mLCBtYWNiX2R0X2lkcyk7DQo+IEBAIC00MzYzLDcgKzQzNzEsOSBA
QCBzdGF0aWMgaW50IG1hY2JfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4g
ICANCj4gICBlcnJfZGlzYWJsZV9jbG9ja3M6DQo+ICAgCWNsa19kaXNhYmxlX3VucHJlcGFyZSh0
eF9jbGspOw0KPiArI2lmZGVmIENPTkZJR19NQUNCX0ZVNTQwDQo+ICAgCWNsa191bnJlZ2lzdGVy
KHR4X2Nsayk7DQo+ICsjZW5kaWYNCj4gICAJY2xrX2Rpc2FibGVfdW5wcmVwYXJlKGhjbGspOw0K
PiAgIAljbGtfZGlzYWJsZV91bnByZXBhcmUocGNsayk7DQo+ICAgCWNsa19kaXNhYmxlX3VucHJl
cGFyZShyeF9jbGspOw0KPiBAQCAtNDM5OCw3ICs0NDA4LDkgQEAgc3RhdGljIGludCBtYWNiX3Jl
bW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgIAkJcG1fcnVudGltZV9kb250
X3VzZV9hdXRvc3VzcGVuZCgmcGRldi0+ZGV2KTsNCj4gICAJCWlmICghcG1fcnVudGltZV9zdXNw
ZW5kZWQoJnBkZXYtPmRldikpIHsNCj4gICAJCQljbGtfZGlzYWJsZV91bnByZXBhcmUoYnAtPnR4
X2Nsayk7DQo+ICsjaWZkZWYgQ09ORklHX01BQ0JfRlU1NDANCj4gICAJCQljbGtfdW5yZWdpc3Rl
cihicC0+dHhfY2xrKTsNCj4gKyNlbmRpZg0KPiAgIAkJCWNsa19kaXNhYmxlX3VucHJlcGFyZShi
cC0+aGNsayk7DQo+ICAgCQkJY2xrX2Rpc2FibGVfdW5wcmVwYXJlKGJwLT5wY2xrKTsNCj4gICAJ
CQljbGtfZGlzYWJsZV91bnByZXBhcmUoYnAtPnJ4X2Nsayk7DQo+IA0KDQoNCi0tIA0KTmljb2xh
cyBGZXJyZQ0K
