Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65176D084A
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 09:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbfJIHb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 03:31:26 -0400
Received: from mail-eopbgr760085.outbound.protection.outlook.com ([40.107.76.85]:22163
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbfJIHb0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 03:31:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cln2tRgSpwgVN2orCImqsT8uSH0Z94IZu40s9EGnpd0BhGiqS678s2f/CHTQMPrVj+KxGw3BHkj7SGzEBHb1TUsLQuqpNbKHfJHl+VogsY3xqOySdQ0WXE05MMSe7sBe2w3mxUefq7KjksZhlbaPDxGntwXmpTAm6Cah3iYtZvoNXmT+mWY9dc0ny2fLIhvjy6i1XfAJ4E8l2kksJ2dKE6DDXZEHnpfoH9QnIGyCb9tqwCI159idD79R39l81kr5vo0dBciqJn3owxWHabpNeugMuqCT5DTjq9lYUQ/4BFZTK8a2WLL0sKhpWeOqFE1wUoGwHGL7kIQXrsjObsaotQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TICxxJ4gbVYstsWViRFhRaaguQCT6iZ2qqwVW/bgP1I=;
 b=UHp6lxzGc70ANJKdujglnNcOxQkY7Ct+evtCo+mdGDfXHvUSH0axlBe/kjZxRZgFGs1OQvQP0TZwvDfyT58NdCnvOaFAucxVLaCljJyDZvNK/kJxBPr5BJD0b6T+Mtek3/QSGZKWrMDAFO5UdRNUDa8YIkPWE9nQYWio99wihbZSkeuUe9lm8mTt9kUFj/eThfZbyfouKr32cPDFzVhU2XnRt8FFzl1cW3Sv0WM3nkj008Ndo/bJylPBS5PHq156e3eSOl/glSxl+sSrLjU4VrB2PAYEr5A6ESsMgpNrFl1AvmENceH3I3vwjMB+8hrs94NOWvq0fqbSW5b7gnm/2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TICxxJ4gbVYstsWViRFhRaaguQCT6iZ2qqwVW/bgP1I=;
 b=p/7hODrHMbalsWORDZ1qhskFDGD+5CgidhSxpsAOa0hH78LrCtxFeQPdDU5x0yKJCSX5kdI7KhmmP25y8onXE6cIs/ac5hiWHyWQoWcTw6GlmplKMc59KliiQV3FJsmVWUMNRcXpVKGmjPAAci/sdaPMho8GDV6hi8cmRztCUnU=
Received: from MN2PR02MB6400.namprd02.prod.outlook.com (52.132.173.155) by
 MN2PR02MB6046.namprd02.prod.outlook.com (52.132.174.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 9 Oct 2019 07:31:22 +0000
Received: from MN2PR02MB6400.namprd02.prod.outlook.com
 ([fe80::2490:5890:f2e7:14b3]) by MN2PR02MB6400.namprd02.prod.outlook.com
 ([fe80::2490:5890:f2e7:14b3%7]) with mapi id 15.20.2327.026; Wed, 9 Oct 2019
 07:31:21 +0000
From:   Appana Durga Kedareswara Rao <appanad@xilinx.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Subject: RE: [PATCH 2/6] net: can: xilinx_can: Fix flags field initialization
 for axi can and canps
Thread-Topic: [PATCH 2/6] net: can: xilinx_can: Fix flags field initialization
 for axi can and canps
Thread-Index: AQHVesCfvo8HLFt+ZUeAzSH0lYp+g6dRtjlAgAA3lYCAAANrwA==
Date:   Wed, 9 Oct 2019 07:31:21 +0000
Message-ID: <MN2PR02MB640062BAF9E353802FF9EDA0DC950@MN2PR02MB6400.namprd02.prod.outlook.com>
References: <1552908766-26753-1-git-send-email-appana.durga.rao@xilinx.com>
 <1552908766-26753-3-git-send-email-appana.durga.rao@xilinx.com>
 <d1bedb13-f66f-b0fd-bd6d-9f95b64fc405@bitwise.fi>
 <MN2PR02MB64004059908C95EB5E16746FDC950@MN2PR02MB6400.namprd02.prod.outlook.com>
 <644fb76f-8169-4911-2293-92ae2dfe4e1c@pengutronix.de>
In-Reply-To: <644fb76f-8169-4911-2293-92ae2dfe4e1c@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=appanad@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3aef0c8-2d47-4967-552e-08d74c8aaeef
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR02MB6046:|MN2PR02MB6046:
x-ms-exchange-purlcount: 1
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR02MB60469015DEACA261DA16DE1ADC950@MN2PR02MB6046.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(199004)(189003)(7736002)(5660300002)(305945005)(316002)(2906002)(7696005)(74316002)(6116002)(3846002)(99286004)(256004)(110136005)(55016002)(54906003)(81166006)(6436002)(6306002)(966005)(4326008)(8936002)(229853002)(8676002)(52536014)(6246003)(81156014)(14454004)(9686003)(478600001)(33656002)(76116006)(66476007)(25786009)(64756008)(66946007)(26005)(186003)(102836004)(66556008)(66446008)(6506007)(53546011)(76176011)(86362001)(486006)(71200400001)(71190400001)(66066001)(11346002)(476003)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR02MB6046;H:MN2PR02MB6400.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rmHYal2828jrvC/d9/gQRpY9QcOaxWdaZtXTdgwcmUc9MxenKCPsZ6vUYKvgDfBgvmdOMVB00h3VMUSlSinTUlMXeAowSeLIFSL/IOG6AI8hRqie1DKaLu5x8o9G60AxDFt1MrOrFhWxpIhGL2vybVcLvUH6F1pdnjcVjDxOciERGB+Q+0zflOTUXtQ3GH2ylVwRO4s7mf7FxQDMFFfnkyJwtFeL8jqRyeZ/ZTNGfG6V3h0lZWBIJqWko27fxKHghIZwJQOEfSrdAW/ndWYI8uYyGxMI29aCZckC3brcPRJ28U6QVZZiI9770qvc//PKEeufCdFf6db1yV8uooH2dhSB789AMJlxNQQaNfcs49pveWj4kSRDVCwMTM8N4AMmJQGUT01HBlnQvgpwi2Fz5Bq8FcxhDt0oirVNRzjbecSYgNX3BWDrPnGCbNZwZhFBFCr/tRE2Ap0LKi5hKWEYrw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3aef0c8-2d47-4967-552e-08d74c8aaeef
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 07:31:21.6545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lx2DR9b/mADNn/4gQd4TlTLMTsll+aIVNe2T9i+qiLfZFbsVTK+hvRIKJvv2m4MJ5rdi6ahOstLX8KBTfxB//Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6046
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KPFNuaXA+DQo+IE9uIDEwLzkvMTkgNjowMSBBTSwgQXBwYW5hIER1cmdhIEtl
ZGFyZXN3YXJhIFJhbyB3cm90ZToNCj4gPiBIaSwNCj4gPg0KPiA+IDxTbmlwPg0KPiA+PiBPbiAx
OC4zLjIwMTkgMTMuMzIsIEFwcGFuYSBEdXJnYSBLZWRhcmVzd2FyYSByYW8gd3JvdGU6DQo+ID4+
PiBBWEkgQ0FOIElQIGFuZCBDQU5QUyBJUCBzdXBwb3J0cyB0eCBmaWZvIGVtcHR5IGZlYXR1cmUs
IHRoaXMgcGF0Y2gNCj4gPj4+IHVwZGF0ZXMgdGhlIGZsYWdzIGZpZWxkIGZvciB0aGUgc2FtZS4N
Cj4gPj4+DQo+ID4+PiBTaWduZWQtb2ZmLWJ5OiBBcHBhbmEgRHVyZ2EgS2VkYXJlc3dhcmEgcmFv
DQo+ID4+PiA8YXBwYW5hLmR1cmdhLnJhb0B4aWxpbnguY29tPg0KPiA+Pj4gLS0tDQo+ID4+PiAg
ZHJpdmVycy9uZXQvY2FuL3hpbGlueF9jYW4uYyB8IDIgKysNCj4gPj4+ICAxIGZpbGUgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspDQo+ID4+Pg0KPiA+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2Nhbi94aWxpbnhfY2FuLmMNCj4gPj4+IGIvZHJpdmVycy9uZXQvY2FuL3hpbGlueF9jYW4uYyBp
bmRleCAyZGU1MWFjLi4yMjU2OWVmIDEwMDY0NA0KPiA+Pj4gLS0tIGEvZHJpdmVycy9uZXQvY2Fu
L3hpbGlueF9jYW4uYw0KPiA+Pj4gKysrIGIvZHJpdmVycy9uZXQvY2FuL3hpbGlueF9jYW4uYw0K
PiA+Pj4gQEAgLTE0MjgsNiArMTQyOCw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZGV2X3BtX29w
cw0KPiB4Y2FuX2Rldl9wbV9vcHMNCj4gPj4gPQ0KPiA+Pj4geyAgfTsNCj4gPj4+DQo+ID4+PiAg
c3RhdGljIGNvbnN0IHN0cnVjdCB4Y2FuX2RldnR5cGVfZGF0YSB4Y2FuX3p5bnFfZGF0YSA9IHsN
Cj4gPj4+ICsJLmZsYWdzID0gWENBTl9GTEFHX1RYRkVNUCwNCj4gPj4+ICAJLmJpdHRpbWluZ19j
b25zdCA9ICZ4Y2FuX2JpdHRpbWluZ19jb25zdCwNCj4gPj4+ICAJLmJ0cl90czJfc2hpZnQgPSBY
Q0FOX0JUUl9UUzJfU0hJRlQsDQo+ID4+PiAgCS5idHJfc2p3X3NoaWZ0ID0gWENBTl9CVFJfU0pX
X1NISUZULA0KPiA+Pg0KPiA+PiBUaGFua3MgZm9yIGNhdGNoaW5nIHRoaXMsIHRoaXMgbGluZSBz
ZWVtZWQgdG8gaGF2ZSBiZWVuIGluY29ycmVjdGx5DQo+ID4+IHJlbW92ZWQgYnkgbXkgOWU1ZjFi
MjczZSAoImNhbjogeGlsaW54X2NhbjogYWRkIHN1cHBvcnQgZm9yIFhpbGlueCBDQU4gRkQNCj4g
Y29yZSIpLg0KPiA+Pg0KPiA+PiBCdXQ6DQo+ID4+DQo+ID4+PiBAQCAtMTQzNSw2ICsxNDM2LDcg
QEAgc3RhdGljIGNvbnN0IHN0cnVjdCB4Y2FuX2RldnR5cGVfZGF0YQ0KPiA+Pj4geGNhbl96eW5x
X2RhdGEgPSB7ICB9Ow0KPiA+Pj4NCj4gPj4+ICBzdGF0aWMgY29uc3Qgc3RydWN0IHhjYW5fZGV2
dHlwZV9kYXRhIHhjYW5fYXhpX2RhdGEgPSB7DQo+ID4+PiArCS5mbGFncyA9IFhDQU5fRkxBR19U
WEZFTVAsDQo+ID4+PiAgCS5iaXR0aW1pbmdfY29uc3QgPSAmeGNhbl9iaXR0aW1pbmdfY29uc3Qs
DQo+ID4+PiAgCS5idHJfdHMyX3NoaWZ0ID0gWENBTl9CVFJfVFMyX1NISUZULA0KPiA+Pj4gIAku
YnRyX3Nqd19zaGlmdCA9IFhDQU5fQlRSX1NKV19TSElGVCwNCj4gPj4NCj4gPj4NCj4gPj4gQXJl
IHlvdSBzdXJlIHRoaXMgaXMgcmlnaHQ/DQo+ID4+IEluIHRoZSBkb2N1bWVudGF0aW9uIFsxXSB0
aGVyZSBkb2VzIG5vdCBzZWVtIHRvIGJlIGFueSBUWEZFTVANCj4gPj4gaW50ZXJydXB0LCBpdCB3
b3VsZCBiZSBpbnRlcnJ1cHQgYml0IDE0IGJ1dCBBWEkgQ0FOIDUuMCBzZWVtcyB0byBvbmx5IGdv
IHVwDQo+IHRvIDExLg0KPiA+Pg0KPiA+PiBPciBtYXliZSBpdCBpcyB1bmRvY3VtZW50ZWQgb3Ig
dGhlcmUgaXMgYSBuZXdlciB2ZXJzaW9uIHNvbWV3aGVyZT8NCj4gPg0KPiA+IFNvcnJ5IGZvciB0
aGUgZGVsYXkgaW4gdGhlIHJlcGx5Lg0KPiA+IEFncmVlIFRYRkVNUCBpbnRlcnJ1cHQgZmVhdHVy
ZSBpcyBub3Qgc3VwcG9ydGVkIGJ5IHRoZSBTb2Z0IElQIENBTi4NCj4gPiBTaW5jZSB0aGlzIHBh
dGNoIGFscmVhZHkgZ290IGFwcGxpZWQgd2lsbCBzZW5kIGEgc2VwYXJhdGUgcGF0Y2ggdG8gZml4
IHRoaXMuDQo+IA0KPiBQbGVhc2UgYmFzZSB5b3VyIHBhdGNoIG9uIG5ldC9tYXN0ZXIgYW5kIGFk
ZCB0aGUgYXBwcm9wcmlhdGUgZml4ZXMgdGFnOg0KPiANCj4gRml4ZXM6IDMyODFiMzgwZWM5ZiAo
ImNhbjogeGlsaW54X2NhbjogRml4IGZsYWdzIGZpZWxkIGluaXRpYWxpemF0aW9uIGZvciBheGkg
Y2FuDQo+IGFuZCBjYW5wcyIpDQoNClN1cmUgTWFyYyB3aWxsIHNlbmQgdGhlIHBhdGNoIG9uIHRv
cCBvZiBuZXQvbWFzdGVyLiANCg0KUmVnYXJkcywNCktlZGFyLg0KDQo+IA0KPiBNYXJjDQo+IA0K
PiAtLQ0KPiBQZW5ndXRyb25peCBlLksuICAgICAgICAgICAgICAgICAgfCBNYXJjIEtsZWluZS1C
dWRkZSAgICAgICAgICAgfA0KPiBJbmR1c3RyaWFsIExpbnV4IFNvbHV0aW9ucyAgICAgICAgfCBQ
aG9uZTogKzQ5LTIzMS0yODI2LTkyNCAgICAgfA0KPiBWZXJ0cmV0dW5nIFdlc3QvRG9ydG11bmQg
ICAgICAgICAgfCBGYXg6ICAgKzQ5LTUxMjEtMjA2OTE3LTU1NTUgfA0KPiBBbXRzZ2VyaWNodCBI
aWxkZXNoZWltLCBIUkEgMjY4NiAgfCBodHRwOi8vd3d3LnBlbmd1dHJvbml4LmRlICAgfA0KDQo=
