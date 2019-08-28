Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2328A0069
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 13:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfH1LCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 07:02:50 -0400
Received: from mail-eopbgr690070.outbound.protection.outlook.com ([40.107.69.70]:33253
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725991AbfH1LCt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 07:02:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FD9FTwI29+ZDs+CXX/PVuZmEEymVPzUYrmtP2usfqsUkbjFPddyb06njMiVBciDg3ZsJR2KAQ99ibwJoOG14zQTh6VcxSJ/LiohMDpcuAESDWJ4jHDhZ5Jl5DQahTHhmy78JBRgJlrYidKW5lyxLy+iQp0cdYUK2q4kLXCepyDCEnF5pIpzGgur9m4yeKl49H3wh/W7Ag42ppNCfWy2W6wRjGXujHBzmaNkdwEIsICEPqnRjANMibzHIAOWnLWeCTbnipHHOSVpxRC6F5mf1DHhisCp1ZbCDTpx0SotSNTAkluaTUfZts6k5TM6meBYsjEF5436gW4ITWdBwYBknGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FsoGGZEritR8DiafCwKqGFNDvLLdAYyTEeEB1kj3LlQ=;
 b=TWJT9g3lduB40FtFILmVV503nDvf/NSmEvb1a6hqu4fYHfAWBn9Uurnid5v84aU+32TTtm9LjpE59RSzRb4JDnKWDDat57b6QJ3yTS7/z7adaAHEzN10HwR+PArMB8Pi04DkggkP1Wa08IC3n5jhm/DnR+NA1dAUikX9gyVh4Qoom/acc4KaZy+vIXc6pKVLkyrUp1czas5t2PjZlhEaN0JM3wZcJu09sPvlOQdHejE00U6bEznA+H73WjQiNPYrx5IvVOWsCudP4kNzW+rwskA2fXDnNRUHPzr+r/i05qDIEsqVy74BfORRfZwrJTbDhiV7r5MQq8DSUjaXlEx/iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FsoGGZEritR8DiafCwKqGFNDvLLdAYyTEeEB1kj3LlQ=;
 b=RzbQfE4C9Nrjz9vW+IIAiVgBg3oyknEbr5al8YYWpkCH9EpRNL+9QwoiAi4klkOMsh6kjJDp2/TYKEQTz1p+U5GCGN1RdNJ+KHkGt/sgijz0fm6cdrEhHt4cj44aoPNyhtGn7q7MZ8v5NivfwLtqXfL5IzfroGSVERO3JZereoI=
Received: from BYAPR02MB5464.namprd02.prod.outlook.com (20.177.230.18) by
 BYAPR02MB5383.namprd02.prod.outlook.com (20.177.228.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Wed, 28 Aug 2019 11:02:43 +0000
Received: from BYAPR02MB5464.namprd02.prod.outlook.com
 ([fe80::1df:3c23:8827:e5ea]) by BYAPR02MB5464.namprd02.prod.outlook.com
 ([fe80::1df:3c23:8827:e5ea%3]) with mapi id 15.20.2199.020; Wed, 28 Aug 2019
 11:02:43 +0000
From:   Srinivas Neeli <sneeli@xilinx.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "wg@grandegger.com" <wg@grandegger.com>
CC:     Srinivas Goud <sgoud@xilinx.com>,
        Naga Sureshkumar Relli <nagasure@xilinx.com>,
        Appana Durga Kedareswara Rao <appanad@xilinx.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Query on possible bug in the can_create_echo_skb() API
Thread-Topic: Query on possible bug in the can_create_echo_skb() API
Thread-Index: AQHVXQ5IJ80aCois8EqYfhY1+ZSkeacQZEtA
Date:   Wed, 28 Aug 2019 11:02:43 +0000
Message-ID: <BYAPR02MB546403642B2233DDD5C456C4AFA30@BYAPR02MB5464.namprd02.prod.outlook.com>
References: <BYAPR02MB5464DC9DA2D38AF1100A5A8FAFAA0@BYAPR02MB5464.namprd02.prod.outlook.com>
 <6bd3a657-dd8a-03a5-1e7c-bac532008f6e@pengutronix.de>
In-Reply-To: <6bd3a657-dd8a-03a5-1e7c-bac532008f6e@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sneeli@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c96793b-11e5-41cd-88dc-08d72ba7405b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR02MB5383;
x-ms-traffictypediagnostic: BYAPR02MB5383:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR02MB5383FD96AEB10F4D034CC5F8AFA30@BYAPR02MB5383.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(199004)(13464003)(189003)(2501003)(81166006)(81156014)(8676002)(7736002)(486006)(76116006)(54906003)(476003)(26005)(229853002)(256004)(2906002)(76176011)(66066001)(966005)(99286004)(8936002)(66446008)(66556008)(186003)(64756008)(316002)(7696005)(66476007)(110136005)(66946007)(74316002)(53936002)(5660300002)(33656002)(6506007)(71190400001)(6246003)(71200400001)(53386004)(25786009)(305945005)(102836004)(53546011)(3846002)(6116002)(11346002)(478600001)(6306002)(9686003)(55016002)(446003)(4326008)(86362001)(6436002)(14454004)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR02MB5383;H:BYAPR02MB5464.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: p6fEr1r5BKKYAw9pHcLklFiNsV+8K2qFm9TvDGRUCgZKaoZVpPVxsyxxIRaIHul1KJ42uxaW9mK7hK/rdAQm27L0yjFVYHyb0bdgeIMyowg7NLpXrmV+vmuK0Q1yi/KJPd3D9oDVo8/HYcFtOCdf0YsbHD0mdSUNzZAtg8z+kLOzDL13AepaeDtuMnnUP/lh16GF+EfSBM3lPti9d2fhzHgaTOEpb61wgGOq9TOCybxynM6FZvv37HVlGgBK/7qIb1rm3393A3V4EX9gH8KtoRu/bt1W2LL7rIybznnVTAUw8WzCy+gpwbxtXosPZ1OE5K6Ym8JYMnc791k1KVSE5onVIJzMi+v7TVO5XnyvM1ghrF2BhSCYy5lQ3vqx6l5eU6ySoyuxCUx745xEuenhzodMiiZ14NTAVytQ7Bw63IM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c96793b-11e5-41cd-88dc-08d72ba7405b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 11:02:43.3738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qBYu0uccfKaKgVv9ALRP2jNLWqJyrPblsfjtobqq0Rslhs3se4Ns1Yr8riTrBlNZsUKFI//QQW2pCCYTBzorjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCkNhc2UgMToNCmNhbl9wdXRfZWNob19za2IoKTsgLT4gc2tiID0gY2FuX2NyZWF0ZV9l
Y2hvX3NrYihza2IpOyAtPiByZXR1cm4gc2tiOw0KDQpJbiBjYW5fY3JlYXRlX2VjaG9fc2tiKCkg
bm90IHVzaW5nIHRoZSBzaGFyZWRfc2tiLCBzbyB3ZSBhcmUgcmV0dXJuaW5nIHRoZSBvbGQgc2ti
Lg0KU3RvcmluZyB0aGUgcmV0dXJuIHZhbHVlIGluICJza2IiLiBCdXQgaXQncyBhIHBvaW50ZXIs
IGZvciBzdG9yaW5nIHRoYXQgbmVlZCBkb3VibGUgcG9pbnRlci4NCkluc3RlYWQgb2YgZG91Ymxl
LXBvaW50ZXIgdXNpbmcgYSBzaW5nbGUgcG9pbnRlci4gSW4gdGhpcyBzY2VuYXJpbyBpdCdzIG9r
ICwgd2UgYXJlIHJldHVybmluZyB0aGUgc2FtZSBTS0IuDQoNCkNhc2UgMjoNCmNhbl9wdXRfZWNo
b19za2Ioc2tiLCBuZGV2LCBwcml2LT50eF9oZWFkICUgcHJpdi0+dHhfbWF4KTsgLT4gc2tiID0g
Y2FuX2NyZWF0ZV9lY2hvX3NrYihza2IpOyAtPiBjYW5fc2tiX3NldF9vd25lcihuc2tiLCBza2It
PnNrKTsgLSBSZXR1cm5pbmcgbnNrYjsNCg0Kc2hhcmVkX3NrYiBzY2VuYXJpbzoNCkluIHNoYXJl
LXNrYiBjYXNlIOKAnGNhbl9jcmVhdGVfZWNob19za2Ioc2tiKTvigJ0gIHJldHVybmluZyAibmV3
IHNrYiIuIEZvciBzdG9yaW5nIG5ldyBza2IgbmVlZCBhIGRvdWJsZSBwb2ludGVyLg0KDQpQcm92
aWRpbmcgYW4gZXhhbXBsZSBmb3Igb3ZlcmNvbWluZyBhYm92ZSBpc3N1ZS4NCkV4YW1wbGU6DQpj
YW5fcHV0X2VjaG9fc2tiKHN0cnVjdCBza19idWZmICoqc2tiLHN0cnVjdCBuZXRfZGV2aWNlICpk
ZXYsdW5zaWduZWQgaW50IGlkeCk7DQoNCklmIHlvdSBvayB3aXRoIHRoaXMgY2hhbmdlLCBJIHdp
bGwgc2VuZCBhIHBhdGNoLg0KDQoNClRoYW5rcw0KU3Jpbml2YXMgTmVlbGkNCg0KPiAtLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBNYXJjIEtsZWluZS1CdWRkZSA8bWtsQHBlbmd1
dHJvbml4LmRlPg0KPiBTZW50OiBXZWRuZXNkYXksIEF1Z3VzdCAyOCwgMjAxOSAxOjAzIEFNDQo+
IFRvOiBTcmluaXZhcyBOZWVsaSA8c25lZWxpQHhpbGlueC5jb20+OyB3Z0BncmFuZGVnZ2VyLmNv
bQ0KPiBDYzogU3Jpbml2YXMgR291ZCA8c2dvdWRAeGlsaW54LmNvbT47IE5hZ2EgU3VyZXNoa3Vt
YXIgUmVsbGkNCj4gPG5hZ2FzdXJlQHhpbGlueC5jb20+OyBBcHBhbmEgRHVyZ2EgS2VkYXJlc3dh
cmEgUmFvDQo+IDxhcHBhbmFkQHhpbGlueC5jb20+OyBsaW51eC1jYW5Admdlci5rZXJuZWwub3Jn
DQo+IFN1YmplY3Q6IFJlOiBRdWVyeSBvbiBwb3NzaWJsZSBidWcgaW4gdGhlIGNhbl9jcmVhdGVf
ZWNob19za2IoKSBBUEkNCj4gDQo+IEhlbGxvIFNyaW5pdmFzIE5lZWxpLA0KPiANCj4gcGxlYXNl
IGRvbid0IHNlbmQgSFRNTCBtZXNzYWdlcyB0byB0aGUga2VybmVsIG1haWxpbmdsaXN0cy4NCj4g
DQo+IE9uIDgvMjEvMTkgMTI6NTEgUE0sIFNyaW5pdmFzIE5lZWxpIHdyb3RlOg0KPiA+IFdoaWxl
IHdhbGtpbmcgdGhyb3VnaCB0aGUgQ0FOIGNvcmUgbGF5ZXIgZGV2LmMgZmlsZSBpbiB0aGUNCj4g
PiBjYW5fcHV0X2VjaG9fc2tiKCkgQVBJIFsxXSwgU2VlbXMgdG8gYmUgdGhlcmUgaXMgYSByYWNl
IGNvbmRpdGlvbiBpbg0KPiA+IHRoZQ0KPiA+IGNhbl9jcmVhdGVfZWNob19za2IoKSBBUEksIG1v
cmUgZGV0YWlscyBiZWxvdw0KPiA+DQo+ID4gSWYgdGhlIHNrYiBpcyBhIHNoYXJlZCBza2IsIHdl
IGFyZSBvdmVyd3JpdGluZyB0aGUgc2tiIHBvaW50ZXIgWzJdIGluDQo+ID4gdGhlIGNhbl9jcmVh
dGVfZWNob19za2IoKSBBUEkgYW5kIHJldHVybmluZyB0aGUgbmV3IHNrYiBiYWNrLg0KPiANCj4g
V2hlcmUgYW5kIGhvdyBpcyB0aGUgc2tiIHBvaW50ZXIgb3ZlcndyaXR0ZW4/IENhbiB5b3UgZXhw
bGFpbiBhIGJpdCBtb3JlLg0KPiANCj4gPiBJZiB0aGUgY29yZSBsYXllci9kcml2ZXJzIHVzZSB0
aGlzIHNrYiBpdCBpcyBub3QgdmFsaWQgYW55IG1vcmUgKGl0DQo+ID4gbWF5IGxlYWQgdG8gY3Jh
c2gvb29wcykuDQo+ID4NCj4gPg0KPiA+DQo+ID4gQSBwb3NzaWJsZSBzb2x1dGlvbiBmb3IgdGhp
cyBpc3N1ZSB3b3VsZCBtYWtlIHRoZSBmdW5jdGlvbiBpbnB1dA0KPiA+IGFyZ3VtZW50IHNob3Vs
ZCBiZSBkb3VibGUtcG9pbnRlci4NCj4gPg0KPiA+IFBsZWFzZSBjb3JyZWN0IG1lIGlmIG15IGFu
YWx5emF0aW9uIGlzIHdyb25nLg0KPiANCj4gQ2FuIHlvdSBwcm92aWRlIGEgcGF0Y2ggb2YgeW91
ciBwcm9wb3NlZCBjaGFuZ2VzPw0KPiANCj4gcmVnYXJkcywNCj4gTWFyYw0KPiANCj4gLS0NCj4g
UGVuZ3V0cm9uaXggZS5LLiAgICAgICAgICAgICAgICAgIHwgTWFyYyBLbGVpbmUtQnVkZGUgICAg
ICAgICAgIHwNCj4gSW5kdXN0cmlhbCBMaW51eCBTb2x1dGlvbnMgICAgICAgIHwgUGhvbmU6ICs0
OS0yMzEtMjgyNi05MjQgICAgIHwNCj4gVmVydHJldHVuZyBXZXN0L0RvcnRtdW5kICAgICAgICAg
IHwgRmF4OiAgICs0OS01MTIxLTIwNjkxNy01NTU1IHwNCj4gQW10c2dlcmljaHQgSGlsZGVzaGVp
bSwgSFJBIDI2ODYgIHwgaHR0cDovL3d3dy5wZW5ndXRyb25peC5kZSAgIHwNCg0K
