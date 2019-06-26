Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E1E565AC
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 11:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfFZJbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 05:31:44 -0400
Received: from mail-eopbgr50097.outbound.protection.outlook.com ([40.107.5.97]:28647
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725379AbfFZJbn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 05:31:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3UmchpQjV68nFeTKcfNuDUgiEf9Z412PKJjMH8xTT7M=;
 b=IYOpHiHy71/4wSgdsxaXRvYDqHg06a4UAWK++vN3xI12i1dAuGq9czRlb4rYMb2FDe0au3nA5m0NCWBkgpTL6bkQQcTcsYu9JZqAbU0NBcsdjsN1hj715xAX/+ZeC1SaXy+OWgU00sqA9jCXZgHlPUNn96c7Vq/k50wEIH2/Xrs=
Received: from AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM (10.255.30.92) by
 AM0PR10MB2289.EURPRD10.PROD.OUTLOOK.COM (20.177.109.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 09:31:39 +0000
Received: from AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::d591:47a7:70ee:3162]) by AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::d591:47a7:70ee:3162%7]) with mapi id 15.20.2008.014; Wed, 26 Jun 2019
 09:31:39 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] can: dev: call netif_carrier_off() in
 register_candev()
Thread-Topic: [PATCH net-next] can: dev: call netif_carrier_off() in
 register_candev()
Thread-Index: AQHVKmeahsDxJm0SfUSG50fnY2XQS6arDw4AgAKgCYA=
Date:   Wed, 26 Jun 2019 09:31:39 +0000
Message-ID: <ff8160d4-3357-9b4f-1840-bbe46195da5a@prevas.dk>
References: <20190624083352.29257-1-rasmus.villemoes@prevas.dk>
 <CA+FuTSeHhz1kntLyeUfAB4ZbtYjO1=Ornwse-yQbPwo5c-_2=g@mail.gmail.com>
In-Reply-To: <CA+FuTSeHhz1kntLyeUfAB4ZbtYjO1=Ornwse-yQbPwo5c-_2=g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0202CA0014.eurprd02.prod.outlook.com
 (2603:10a6:3:8c::24) To AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:160::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5afc0410-8121-4538-06a1-08d6fa191741
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM0PR10MB2289;
x-ms-traffictypediagnostic: AM0PR10MB2289:
x-microsoft-antispam-prvs: <AM0PR10MB228975B70913236166A778338AE20@AM0PR10MB2289.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(39850400004)(366004)(136003)(346002)(189003)(199004)(229853002)(6436002)(8936002)(14444005)(6512007)(6486002)(256004)(5660300002)(8976002)(72206003)(478600001)(4326008)(25786009)(66446008)(64756008)(66556008)(305945005)(73956011)(66476007)(66946007)(7736002)(31686004)(14454004)(8676002)(81166006)(81156014)(68736007)(2906002)(71200400001)(71190400001)(26005)(476003)(486006)(54906003)(44832011)(36756003)(99286004)(2616005)(3846002)(186003)(6116002)(11346002)(316002)(66066001)(76176011)(52116002)(53546011)(6506007)(386003)(102836004)(6246003)(74482002)(446003)(6916009)(42882007)(53936002)(31696002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR10MB2289;H:AM0PR10MB3027.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: g7a0gOxCMwZmkstquGvSTeNpVlE98g5sp17AH8HU8Jhyn4kTWA7Na0TqMuV/bNQNuAGxNyD0OBtpv516OdybeaxxR2UvNWSYz9F1pioOQEV7Iy45ojZXJQWvkdcPRzyrKHXYbAaxNhLuWjIUDu1yJv3Wxrhm7V54MbPwLhbNfM7+92DSxQ4ym/jWFCHKq5BWpgHPjHk43jYctaEpub01WUSOiHnB48Ft3L3O2x3rMyzSMcFINBbPOiPqJItvCW18AArzv6ZsQrLPctQ7yBMkpr3wimvkX4GF5jyJi4ha3rWWKO97ClVLp5IP4hqbT3LkyAf3rwVLApjv9DhKAJHgEyCDsU5DY/j8mw7dTG4fz70UKrwxlAIspA8CvMw5D/bVXdjlhBDgC9Z07U1hsZExxEK56Jt3CcGb1sAYZyI7FG8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1038AA6E0DD7FA4689BDA53C0FEA4596@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 5afc0410-8121-4538-06a1-08d6fa191741
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 09:31:39.4635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2289
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjQvMDYvMjAxOSAxOS4yNiwgV2lsbGVtIGRlIEJydWlqbiB3cm90ZToNCj4gT24gTW9uLCBK
dW4gMjQsIDIwMTkgYXQgNDozNCBBTSBSYXNtdXMgVmlsbGVtb2VzDQo+IDxyYXNtdXMudmlsbGVt
b2VzQHByZXZhcy5kaz4gd3JvdGU6DQo+Pg0KPj4gQ09ORklHX0NBTl9MRURTIGlzIGRlcHJlY2F0
ZWQuIFdoZW4gdHJ5aW5nIHRvIHVzZSB0aGUgZ2VuZXJpYyBuZXRkZXYNCj4+IHRyaWdnZXIgYXMg
c3VnZ2VzdGVkLCB0aGVyZSdzIGEgc21hbGwgaW5jb25zaXN0ZW5jeSB3aXRoIHRoZSBsaW5rDQo+
PiBwcm9wZXJ0eTogVGhlIExFRCBpcyBvbiBpbml0aWFsbHksIHN0YXlzIG9uIHdoZW4gdGhlIGRl
dmljZSBpcyBicm91Z2h0DQo+PiB1cCwgYW5kIHRoZW4gdHVybnMgb2ZmIChhcyBleHBlY3RlZCkg
d2hlbiB0aGUgZGV2aWNlIGlzIGJyb3VnaHQgZG93bi4NCj4+DQo+PiBNYWtlIHN1cmUgdGhlIExF
RCBhbHdheXMgcmVmbGVjdHMgdGhlIHN0YXRlIG9mIHRoZSBDQU4gZGV2aWNlLg0KPj4NCj4+IFNp
Z25lZC1vZmYtYnk6IFJhc211cyBWaWxsZW1vZXMgPHJhc211cy52aWxsZW1vZXNAcHJldmFzLmRr
Pg0KPiANCj4gU2hvdWxkIHRoaXMgdGFyZ2V0IG5ldD8NCg0KTm8sIEkgdGhpbmsgdGhpcyBzaG91
bGQgZ28gdGhyb3VnaCB0aGUgQ0FOIHRyZWUuIFBlcmhhcHMgSSd2ZQ0KbWlzdW5kZXJzdG9vZCB3
aGVuIHRvIHVzZSB0aGUgbmV0LW5leHQgcHJlZml4IC0gaXMgdGhhdCBvbmx5IGZvciB0aGluZ3MN
CnRoYXQgc2hvdWxkIGJlIGFwcGxpZWQgZGlyZWN0bHkgdG8gdGhlIG5ldC1uZXh0IHRyZWU/IElm
IHNvLCBzb3JyeS4NCg0KPiBSZWdhcmRsZXNzIG9mIENPTkZJR19DQU5fTEVEUyBkZXByZWNhdGlv
biwNCj4gdGhpcyBpcyBhbHJlYWR5IG5vdCBpbml0aWFsaXplZCBwcm9wZXJseSBpZiB0aGF0IENP
TkZJRyBpcyBkaXNhYmxlZA0KPiBhbmQgYSBjYW5fbGVkX2V2ZW50IGNhbGwgYXQgZGV2aWNlIHBy
b2JlIGlzIGEgbm9vcC4NCg0KSSdtIG5vdCBzdXJlIEkgdW5kZXJzdGFuZCB0aGlzIHBhcnQuIFRo
ZSBDT05GSUdfQ0FOX0xFRFMgc3VwcG9ydCBmb3INCnNob3dpbmcgdGhlIHN0YXRlIG9mIHRoZSBp
bnRlcmZhY2UgaXMgaW1wbGVtZW50ZWQgdmlhIGhvb2tpbmcgaW50byB0aGUNCm5kb19vcGVuL25k
b19zdG9wIGNhbGxiYWNrcywgYW5kIGRvZXMgbm90IGxvb2sgYXQgb3IgdG91Y2ggdGhlDQpfX0xJ
TktfU1RBVEVfTk9DQVJSSUVSIGJpdCBhdCBhbGwuDQoNCk90aGVyIHRoYW4gdmlhIHRoZSBuZXRk
ZXYgTEVEIHRyaWdnZXIgSSBkb24ndCB0aGluayBvbmUgY2FuIGV2ZW4gb2JzZXJ2ZQ0KdGhlIHNs
aWdodGx5IG9kZCBpbml0aWFsIHN0YXRlIG9mIHRoZSBfX0xJTktfU1RBVEVfTk9DQVJSSUVSIGJp
dCBmb3IgQ0FODQpkZXZpY2VzLCB3aGljaCBpcyB3aHkgSSBmcmFtZWQgdGhpcyBhcyBhIGZpeCBw
dXJlbHkgdG8gYWxsb3cgdGhlIG5ldGRldg0KdHJpZ2dlciB0byBiZSBhIGNsb3NlciBkcm9wLWlu
IHJlcGxhY2VtZW50IGZvciBDT05GSUdfQ0FOX0xFRFMuDQoNClJhc211cw0K
