Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2925737E
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 23:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfFZVTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 17:19:38 -0400
Received: from mail-eopbgr20134.outbound.protection.outlook.com ([40.107.2.134]:41538
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726223AbfFZVTi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 17:19:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=r48fmh2iszHtIIyj9RIj64Hq0Vawrqmx2oybgZ4A3zciBlynDNsBWTlH/YayQYMl6O91GIDfDq1sYvGO4qDSIsSBnzbhVmLAJVY3OVw07NVVwYqS+H155aUqE78FqWGXM5qtCTtziBcu1ZkdlgCmdow3GLkZAQS1imhPBTaEUzU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yllxSvKRo/FNHBsyHuDfDuvhTpa/xrddlX+O13dtAIU=;
 b=nepS3/ASwNtzDb3+1Hw0CxCi3kbMOIlP3RHePs2g3GF93SeZg7YTgcpSOzIfi/wjuQMI1W+ULj3lU6Rbc7NRVLuMtY6STcflmWIIdZ2cPwjKp5Lj2zLCgJH/XcoT09te/vcRzgYzGGPViwVEgeuvDsrtsNUqqg/L8YRzEBNm5rg=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yllxSvKRo/FNHBsyHuDfDuvhTpa/xrddlX+O13dtAIU=;
 b=dSvsmOzC+imPjY7W0nPPAjHFdQ6ZpkihsEUg/qi/iWqTZTDDkOx5bBfp0FJwcKPSmTdedHHABvXmA82m2FkMlJ5Ro0zVyoJdf3MVM91rs6IFGUv2La/RVYG6nU+rLmySx+HyLmH7rCcraUarbmRpDDxsJn/2Uwopa1OfBfQl3zE=
Received: from AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM (10.255.30.92) by
 AM0PR10MB2404.EURPRD10.PROD.OUTLOOK.COM (20.177.111.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 21:19:32 +0000
Received: from AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::d591:47a7:70ee:3162]) by AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::d591:47a7:70ee:3162%7]) with mapi id 15.20.2008.014; Wed, 26 Jun 2019
 21:19:32 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] can: dev: call netif_carrier_off() in
 register_candev()
Thread-Topic: [PATCH net-next] can: dev: call netif_carrier_off() in
 register_candev()
Thread-Index: AQHVKmeahsDxJm0SfUSG50fnY2XQS6arDw4AgALBkICAAC45gIAAdgeA
Date:   Wed, 26 Jun 2019 21:19:32 +0000
Message-ID: <838ce911-7205-f828-4fc5-79cebc32322a@prevas.dk>
References: <20190624083352.29257-1-rasmus.villemoes@prevas.dk>
 <CA+FuTSeHhz1kntLyeUfAB4ZbtYjO1=Ornwse-yQbPwo5c-_2=g@mail.gmail.com>
 <ff8160d4-3357-9b4f-1840-bbe46195da5a@prevas.dk>
 <CAF=yD-KyWJwdESFmY=CvbkTBT8yey2atKDY-tgd19yAeMf525g@mail.gmail.com>
In-Reply-To: <CAF=yD-KyWJwdESFmY=CvbkTBT8yey2atKDY-tgd19yAeMf525g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P191CA0010.EURP191.PROD.OUTLOOK.COM (2603:10a6:3:cf::20)
 To AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:160::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [5.186.112.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c5fed7e-4dab-47c7-df13-08d6fa7bfb1b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR10MB2404;
x-ms-traffictypediagnostic: AM0PR10MB2404:
x-microsoft-antispam-prvs: <AM0PR10MB2404C178631A1E103688BA8A8AE20@AM0PR10MB2404.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(366004)(376002)(39850400004)(346002)(199004)(189003)(2906002)(6246003)(14454004)(14444005)(72206003)(6486002)(42882007)(31686004)(11346002)(446003)(476003)(44832011)(66066001)(2616005)(8936002)(486006)(305945005)(52116002)(36756003)(6916009)(54906003)(316002)(99286004)(7736002)(68736007)(6512007)(256004)(76176011)(53936002)(8976002)(6436002)(71200400001)(71190400001)(25786009)(74482002)(81166006)(53546011)(386003)(6506007)(4326008)(71446004)(3846002)(102836004)(186003)(6116002)(8676002)(5660300002)(229853002)(478600001)(64756008)(66446008)(81156014)(66476007)(31696002)(66556008)(26005)(66946007)(73956011);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR10MB2404;H:AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CI97NnNbPq5lf5SwGz5rxmDbH0H7l/tUV+KMEbyqd9KKj4wC7JHpdQ7YvQvD5bRxgumqb6oJeghBMisF1BUgevvfnLVANCMMQ7j7SeieePv7EWIFcir6oxuUADXwujWKytoWDzRGcHFyG49gzI5k5G0fmRVkMor+AOjEg2moLe8J3sNtFm253Boc6GTHB9dbhUuVrv/A2Tr16elRQzVu66exojcxxGowTDCH3ezBBkLSNwktR19rMPuvXJ16DmulIQZdLMRuTpE5v8TVbxB4QB+N3222l7zYCcnoVcmA/9GWcG+JKzd+v31lXRUZRf2HIGGnM23acjpU5B7aD5kpZtk9VUAHHlMS+gC8LM0ZxoyoI2qTjGcpzYKJETgJXgWy0Q4G7yDKxndhb8zcsv61qjw5E4mwQje+oFMb0YS1qQY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <769FE66E4A783C46AB6C56A20A0F0A58@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c5fed7e-4dab-47c7-df13-08d6fa7bfb1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 21:19:32.4610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2404
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjYvMDYvMjAxOSAxNi4xNywgV2lsbGVtIGRlIEJydWlqbiB3cm90ZToNCj4gT24gV2VkLCBK
dW4gMjYsIDIwMTkgYXQgNTozMSBBTSBSYXNtdXMgVmlsbGVtb2VzDQo+IDxyYXNtdXMudmlsbGVt
b2VzQHByZXZhcy5kaz4gd3JvdGU6DQo+Pg0KPj4gT24gMjQvMDYvMjAxOSAxOS4yNiwgV2lsbGVt
IGRlIEJydWlqbiB3cm90ZToNCj4+PiBPbiBNb24sIEp1biAyNCwgMjAxOSBhdCA0OjM0IEFNIFJh
c211cyBWaWxsZW1vZXMNCj4+PiA8cmFzbXVzLnZpbGxlbW9lc0BwcmV2YXMuZGs+IHdyb3RlOg0K
Pj4+Pg0KPj4+PiBNYWtlIHN1cmUgdGhlIExFRCBhbHdheXMgcmVmbGVjdHMgdGhlIHN0YXRlIG9m
IHRoZSBDQU4gZGV2aWNlLg0KPj4+DQo+Pj4gU2hvdWxkIHRoaXMgdGFyZ2V0IG5ldD8NCj4+DQo+
PiBObywgSSB0aGluayB0aGlzIHNob3VsZCBnbyB0aHJvdWdoIHRoZSBDQU4gdHJlZS4gUGVyaGFw
cyBJJ3ZlDQo+PiBtaXN1bmRlcnN0b29kIHdoZW4gdG8gdXNlIHRoZSBuZXQtbmV4dCBwcmVmaXgg
LSBpcyB0aGF0IG9ubHkgZm9yIHRoaW5ncw0KPj4gdGhhdCBzaG91bGQgYmUgYXBwbGllZCBkaXJl
Y3RseSB0byB0aGUgbmV0LW5leHQgdHJlZT8gSWYgc28sIHNvcnJ5Lg0KPiANCj4gSSBkb24ndCBz
ZWUgY29uc2lzdGVudCBiZWhhdmlvciBvbiB0aGUgbGlzdCwgc28gdGhpcyBpcyBwcm9iYWJseSBm
aW5lLg0KPiBJdCB3b3VsZCBwcm9iYWJseSBoZWxwIHRvIHRhcmdldCBjYW4gKGZvciBmaXhlcykg
b3IgY2FuLW5leHQgKGZvciBuZXcNCj4gZmVhdHVyZXMpLg0KPiANCj4gTGV0IG1lIHJlZnJhbWUg
dGhlIHF1ZXN0aW9uOiBzaG91bGQgdGhpcyB0YXJnZXQgY2FuLCBpbnN0ZWFkIG9mIGNhbi1uZXh0
Pw0KDQpBaCwgbm93IEkgc2VlIHdoYXQgeW91IG1lYW50LCBidXQgYXQgbGVhc3QgSSBsZWFybmVk
IHdoZW4gdG8gdXNlDQpuZXQvbmV0LW5leHQuDQoNCkkgdGhpbmsgY2FuLW5leHQgaXMgZmluZSwg
ZXNwZWNpYWxseSB0aGlzIGxhdGUgaW4gdGhlIHJjIGN5Y2xlLiBCdXQgSSdsbA0KbGVhdmUgaXQg
dG8gdGhlIENBTiBtYWludGFpbmVyKHMpLg0KDQo+Pj4gUmVnYXJkbGVzcyBvZiBDT05GSUdfQ0FO
X0xFRFMgZGVwcmVjYXRpb24sDQo+Pj4gdGhpcyBpcyBhbHJlYWR5IG5vdCBpbml0aWFsaXplZCBw
cm9wZXJseSBpZiB0aGF0IENPTkZJRyBpcyBkaXNhYmxlZA0KPj4+IGFuZCBhIGNhbl9sZWRfZXZl
bnQgY2FsbCBhdCBkZXZpY2UgcHJvYmUgaXMgYSBub29wLg0KPj4NCj4+IEknbSBub3Qgc3VyZSBJ
IHVuZGVyc3RhbmQgdGhpcyBwYXJ0LiBUaGUgQ09ORklHX0NBTl9MRURTIHN1cHBvcnQgZm9yDQo+
PiBzaG93aW5nIHRoZSBzdGF0ZSBvZiB0aGUgaW50ZXJmYWNlIGlzIGltcGxlbWVudGVkIHZpYSBo
b29raW5nIGludG8gdGhlDQo+PiBuZG9fb3Blbi9uZG9fc3RvcCBjYWxsYmFja3MsIGFuZCBkb2Vz
IG5vdCBsb29rIGF0IG9yIHRvdWNoIHRoZQ0KPj4gX19MSU5LX1NUQVRFX05PQ0FSUklFUiBiaXQg
YXQgYWxsLg0KPj4NCj4+IE90aGVyIHRoYW4gdmlhIHRoZSBuZXRkZXYgTEVEIHRyaWdnZXIgSSBk
b24ndCB0aGluayBvbmUgY2FuIGV2ZW4gb2JzZXJ2ZQ0KPj4gdGhlIHNsaWdodGx5IG9kZCBpbml0
aWFsIHN0YXRlIG9mIHRoZSBfX0xJTktfU1RBVEVfTk9DQVJSSUVSIGJpdCBmb3IgQ0FODQo+PiBk
ZXZpY2VzLA0KPiANCj4gaXQncyBzdGlsbCBpbmNvcnJlY3QsIHRob3VnaCBJIGd1ZXNzIHRoYXQn
cyBtb290IGluIHByYWN0aWNlLg0KRXhhY3RseS4NCg0KPj4gd2hpY2ggaXMgd2h5IEkgZnJhbWVk
IHRoaXMgYXMgYSBmaXggcHVyZWx5IHRvIGFsbG93IHRoZSBuZXRkZXYNCj4+IHRyaWdnZXIgdG8g
YmUgYSBjbG9zZXIgZHJvcC1pbiByZXBsYWNlbWVudCBmb3IgQ09ORklHX0NBTl9MRURTLg0KPiAN
Cj4gU28gdGhlIGVudGlyZSBDT05GSUdfQ0FOX0xFRFMgY29kZSBpcyB0byBiZSByZW1vdmVkPyBX
aGF0IGV4YWN0bHkgaXMNCj4gdGhpcyBuZXRkZXYgdHJpZ2dlciByZXBsYWNlbWVudCwgaWYgbm90
IGNhbl9sZWRfZXZlbnQ/IFNvcnJ5LCBJDQo+IHByb2JhYmx5IG1pc3Mgc29tZSBjb250ZXh0Lg0K
DQpkcml2ZXJzL25ldC9jYW4vS2NvbmZpZyBjb250YWlucyB0aGVzZSBjb21tZW50cw0KDQogICAg
ICAgICMgVGhlIG5ldGRldiB0cmlnZ2VyIChMRURTX1RSSUdHRVJfTkVUREVWKSBzaG91bGQgYmUg
YWJsZSB0byBkbw0KICAgICAgICAjIGV2ZXJ5dGhpbmcgdGhhdCB0aGlzIGRyaXZlciBpcyBkb2lu
Zy4gVGhpcyBpcyBtYXJrZWQgYXMgYnJva2VuDQogICAgICAgICMgYmVjYXVzZSBpdCB1c2VzIHN0
dWZmIHRoYXQgaXMgaW50ZW5kZWQgdG8gYmUgY2hhbmdlZCBvciByZW1vdmVkLg0KICAgICAgICAj
IFBsZWFzZSBjb25zaWRlciBzd2l0Y2hpbmcgdG8gdGhlIG5ldGRldiB0cmlnZ2VyIGFuZCBjb25m
aXJtIGl0DQogICAgICAgICMgZnVsZmlsbHMgeW91ciBuZWVkcyBpbnN0ZWFkIG9mIGZpeGluZyB0
aGlzIGRyaXZlci4NCg0KaW50cm9kdWNlZCBieSB0aGUgY29tbWl0IDMwZjNiNDIxNDdiYTYgd2hp
Y2ggYWxzbyBtYXJrZWQgQ09ORklHX0NBTl9MRURTDQphcyAoZGVwZW5kcyBvbikgQlJPS0VOLiBT
byB3aGlsZSBhIC5kdHMgZm9yIHVzaW5nIHRoZSBDQU4gbGVkIHRyaWdnZXINCm1pZ2h0IGJlDQoN
CiAgICAgICAgICAgICAgICBjYW5hIHsNCiAgICAgICAgICAgICAgICAgICAgICAgIGxhYmVsID0g
ImNhbmE6Z3JlZW46YWN0aXZpdHkiOw0KICAgICAgICAgICAgICAgICAgICAgICAgZ3Bpb3MgPSA8
JmdwaW8wIDEwIDA+Ow0KICAgICAgICAgICAgICAgICAgICAgICAgZGVmYXVsdC1zdGF0ZSA9ICJv
ZmYiOw0KICAgICAgICAgICAgICAgICAgICAgICAgbGludXgsZGVmYXVsdC10cmlnZ2VyID0gImNh
bjAtcnh0eCI7DQogICAgICAgICAgICAgICAgfTsNCg0Kb25lIGNhbiBhY2hpZXZlIG1vc3RseSB0
aGUgc2FtZSB0aGluZyB3aXRoIENBTl9MRURTPW4sDQpMRURTX1RSSUdHRVJfTkVUREVWPXkgc2V0
dGluZyBsaW51eCxkZWZhdWx0LXRyaWdnZXIgPSAibmV0ZGV2IiBwbHVzIGENCnNtYWxsIGluaXQg
c2NyaXB0IChvciB1ZGV2IHJ1bGUgb3Igd2hhdGV2ZXIgd29ya3MpIHRoYXQgZG9lcw0KDQpkPS9z
eXMvY2xhc3MvbGVkcy9jYW5hOmdyZWVuOmFjdGl2aXR5DQplY2hvIGNhbjAgPiAkZC9kZXZpY2Vf
bmFtZQ0KZWNobyAxID4gJGQvbGluaw0KZWNobyAxID4gJGQvcngNCmVjaG8gMSA+ICRkL3R4DQoN
CnRvIHRpZSB0aGUgY2FuYSBMRUQgdG8gdGhlIGNhbjAgZGV2aWNlLCBwbHVzIGNvbmZpZ3VyZSBp
dCB0byBzaG93ICJsaW5rIg0Kc3RhdGUgYXMgd2VsbCBhcyBibGluayBvbiByeCBhbmQgdHguDQoN
ClRoaXMgd29ya3MganVzdCBmaW5lLCBleGNlcHQgZm9yIHRoZSBpbml0aWFsIHN0YXRlIG9mIHRo
ZSBMRUQuIEFGQUlVLA0KdGhlIG5ldGRldiB0cmlnZ2VyIGRvZXNuJ3QgbmVlZCBjb29wZXJhdGlv
biBmcm9tIGVhY2ggZGV2aWNlIGRyaXZlcg0Kc2luY2UgaXQgc2ltcGx5IHdvcmtzIG9mIGEgdGlt
ZXIgdGhhdCBwZXJpb2RpY2FsbHkgY2hlY2tzIGZvciBjaGFuZ2VzIGluDQpkZXZfZ2V0X3N0YXRz
KCkuDQoNClJhc211cw0K
