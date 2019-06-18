Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 987EC4AECA
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 01:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbfFRXkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 19:40:24 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:44447 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfFRXkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 19:40:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560901223; x=1592437223;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rTdzvx4BnqS+baqPNqIr93jUsKqxMVc8BIc7zB3KOVA=;
  b=VscejnPcZJpjYSCSqBHwUhAoqF/IZyqQa3Q57Xu3frUy+8SjZONTl3Di
   OeL4zPHOfm7r+CXJTS1iHEhLWWDUxBvwBBC3WpwQgQ7qh9yoAUB8ZWlxG
   JGukJtrhEm/SgbYuskv8qzjXlV4dXbsWP1c2DMuGbMk3kt95P5EY7IyXh
   kOfdRKg6k8iMugFayhnCV/e3ffNVyN5YjGDXRdrQj9b+Mz1KaboH+Jngs
   NIX3KsZdHHCRqxbDm4l/Uz7I3CQyJq25xlMmKbKS46yL3ZUcS3mlFPxZy
   NzUHeT6choeyelhxZH3VfIZt7H4cKT/kMLxBWWBy45pmlgo1Uxf9aWp71
   w==;
X-IronPort-AV: E=Sophos;i="5.63,390,1557158400"; 
   d="scan'208";a="115813829"
Received: from mail-co1nam05lp2055.outbound.protection.outlook.com (HELO NAM05-CO1-obe.outbound.protection.outlook.com) ([104.47.48.55])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2019 07:40:22 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rTdzvx4BnqS+baqPNqIr93jUsKqxMVc8BIc7zB3KOVA=;
 b=OGqSvKnBAbfCfT5cDE55LaVwoOqdkB65cHLD8aoTUw1UKZNs+32gx8AZ5ENqsRLfADD3TGVWwiq/z5wI1euISnRvYokT/2fKzp8k1X/9ff+FKYWGc8P1Gyfscr7EkoAU8RG2+8uzY4tx+eFBmjrEchKeh3IDJUQo2WunvcQHHk4=
Received: from BYAPR04MB3782.namprd04.prod.outlook.com (52.135.214.142) by
 BYAPR04MB4310.namprd04.prod.outlook.com (20.176.251.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Tue, 18 Jun 2019 23:40:20 +0000
Received: from BYAPR04MB3782.namprd04.prod.outlook.com
 ([fe80::65e3:6069:d7d5:90a2]) by BYAPR04MB3782.namprd04.prod.outlook.com
 ([fe80::65e3:6069:d7d5:90a2%5]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 23:40:20 +0000
From:   Atish Patra <Atish.Patra@wdc.com>
To:     "anup@brainfault.org" <anup@brainfault.org>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "palmer@sifive.com" <palmer@sifive.com>
CC:     "bmeng.cn@gmail.com" <bmeng.cn@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "yash.shah@sifive.com" <yash.shah@sifive.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ynezz@true.cz" <ynezz@true.cz>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "sachin.ghadi@sifive.com" <sachin.ghadi@sifive.com>,
        "jamez@wit.com" <jamez@wit.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "schwab@suse.de" <schwab@suse.de>,
        "lukas.auer@aisec.fraunhofer.de" <lukas.auer@aisec.fraunhofer.de>,
        "troy.benjegerdes@sifive.com" <troy.benjegerdes@sifive.com>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH v2 0/2] Add macb support for SiFive FU540-C000
Thread-Topic: [PATCH v2 0/2] Add macb support for SiFive FU540-C000
Thread-Index: AQHVJMPyFET8FkDc8E6eBeIAOASoY6afgwyegAAZzgCAAAD/moAAAOUAgAAC0/yAABYlAIAALLGAgADdTxmAAGZTgIAA7M4A
Date:   Tue, 18 Jun 2019 23:40:20 +0000
Message-ID: <5172a1fc3b249b84c1f2c65631a7a4fbc47ad571.camel@wdc.com>
References: <1560745167-9866-1-git-send-email-yash.shah@sifive.com>
         <mvmtvco62k9.fsf@suse.de>
         <alpine.DEB.2.21.9999.1906170252410.19994@viisi.sifive.com>
         <mvmpnnc5y49.fsf@suse.de>
         <alpine.DEB.2.21.9999.1906170305020.19994@viisi.sifive.com>
         <mvmh88o5xi5.fsf@suse.de>
         <alpine.DEB.2.21.9999.1906170419010.19994@viisi.sifive.com>
         <F48A4F7F-0B0D-4191-91AD-DC51686D1E78@sifive.com>
         <d2836a90b92f3522a398d57ab8555d08956a0d1f.camel@wdc.com>
         <alpine.DEB.2.21.9999.1906172019040.15057@viisi.sifive.com>
         <CAAhSdy3zODw=JFaN=2F4K5-umihJDivLO8J8LBdkFkuZgzu41Q@mail.gmail.com>
In-Reply-To: <CAAhSdy3zODw=JFaN=2F4K5-umihJDivLO8J8LBdkFkuZgzu41Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Atish.Patra@wdc.com; 
x-originating-ip: [199.255.44.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5b37b7c-9ee0-4517-5d05-08d6f4465382
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB4310;
x-ms-traffictypediagnostic: BYAPR04MB4310:
x-ms-exchange-purlcount: 4
wdcipoutbound: EOP-TRUE
x-microsoft-antispam-prvs: <BYAPR04MB431027191B974E4AA8111E11FAEA0@BYAPR04MB4310.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6029001)(396003)(39860400002)(346002)(376002)(136003)(366004)(199004)(189003)(6512007)(6486002)(76176011)(26005)(102836004)(53936002)(36756003)(186003)(6306002)(2501003)(25786009)(73956011)(305945005)(81156014)(256004)(66946007)(66446008)(6436002)(5660300002)(7736002)(76116006)(86362001)(8676002)(2201001)(118296001)(6506007)(53546011)(81166006)(99286004)(7416002)(14454004)(72206003)(2906002)(6116002)(966005)(3846002)(8936002)(66476007)(66556008)(478600001)(4326008)(486006)(110136005)(6246003)(64756008)(54906003)(11346002)(446003)(71190400001)(68736007)(71200400001)(229853002)(316002)(2616005)(476003)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4310;H:BYAPR04MB3782.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tPaQGWbzrirk83NXshqx+E7VUEyP3eii809tKd6AY2lm2aV8J3SMAKd4k82A1LjB2gnlewFzH6z0obb8sbAUNFV+GPPEGC6/faGsgxptWWl6nxLhuxU8sSYOZ67OSBooaZJhuLYywv1kBk5n5EDlzUo59julRmSaU15DVei4YF50szA4rmW1oJZ0xhInkK8RtdCRPNpjPk+3pUaaZg+xi8ooVqDoQW6leK4XZ6SHTsYIXLpclSk54/xV2OvMztKmOadf37eqQbT/UtcC0MQbm8rI/Oa8sjU8L9QtxztLsnynm5faoocLpT8QVUSCvpf4Fhm6LMEoR6a7EevUFX+3Licas2F7Z0H8iKe08s6e2yv3a0ltYySH4/tBLxsfckAlPieE3OJkAMecORap1ZQkLZSpAFmkHmw8ve/ni9lOXJs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <17C38DEF824F8D47BC6F2EA0CBD171D3@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5b37b7c-9ee0-4517-5d05-08d6f4465382
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 23:40:20.3435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Atish.Patra@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4310
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTE4IGF0IDE1OjAyICswNTMwLCBBbnVwIFBhdGVsIHdyb3RlOg0KPiBP
biBUdWUsIEp1biAxOCwgMjAxOSBhdCA4OjU2IEFNIFBhdWwgV2FsbXNsZXkgPA0KPiBwYXVsLndh
bG1zbGV5QHNpZml2ZS5jb20+IHdyb3RlOg0KPiA+IE9uIE1vbiwgMTcgSnVuIDIwMTksIEFsaXN0
YWlyIEZyYW5jaXMgd3JvdGU6DQo+ID4gDQo+ID4gPiA+IFRoZSBsZWdhY3kgTS1tb2RlIFUtYm9v
dCBoYW5kbGVzIHRoZSBwaHkgcmVzZXQgYWxyZWFkeSwgYW5kDQo+ID4gPiA+IEnigJl2ZSBiZWVu
DQo+ID4gPiA+IGFibGUgdG8gbG9hZCB1cHN0cmVhbSBTLW1vZGUgdWJvb3QgYXMgYSBwYXlsb2Fk
IHZpYSBURlRQLCBhbmQNCj4gPiA+ID4gdGhlbg0KPiA+ID4gPiBsb2FkIGFuZCBib290IGEgNC4x
OSBrZXJuZWwuDQo+ID4gPiA+IA0KPiA+ID4gPiBJdCB3b3VsZCBiZSBuaWNlIHRvIGdldCB0aGlz
IGFsbCB3b3JraW5nIHdpdGggNS54LCBob3dldmVyDQo+ID4gPiA+IHRoZXJlIGFyZQ0KPiA+ID4g
PiBzdGlsbA0KPiA+ID4gPiBzZXZlcmFsIG1pc3NpbmcgcGllY2VzIHRvIHJlYWxseSBoYXZlIGl0
IHdvcmsgd2VsbC4NCj4gPiA+IA0KPiA+ID4gTGV0IG1lIGtub3cgd2hhdCBpcyBzdGlsbCBtaXNz
aW5nL2RvZXNuJ3Qgd29yayBhbmQgSSBjYW4gYWRkIGl0Lg0KPiA+ID4gQXQgdGhlDQo+ID4gPiBt
b21lbnQgdGhlIG9ubHkga25vd24gaXNzdWUgSSBrbm93IG9mIGlzIGEgbWlzc2luZyBTRCBjYXJk
IGRyaXZlcg0KPiA+ID4gaW4gVS0NCj4gPiA+IEJvb3QuDQo+ID4gDQo+ID4gVGhlIERUIGRhdGEg
aGFzIGNoYW5nZWQgYmV0d2VlbiB0aGUgbm9uLXVwc3RyZWFtIGRhdGEgdGhhdCBwZW9wbGUNCj4g
PiBkZXZlbG9wZWQgYWdhaW5zdCBwcmV2aW91c2x5LCB2cy4gdGhlIERUIGRhdGEgdGhhdCBqdXN0
IHdlbnQNCj4gPiB1cHN0cmVhbQ0KPiA+IGhlcmU6DQo+ID4gDQo+ID4gaHR0cHM6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0L2NvbW1p
dC8/aWQ9NzIyOTZiZGU0ZjQyMDc1NjY4NzJlZTM1NTk1MGE1OWNiYzI5Zjg1Mg0KPiA+IA0KPiA+
IGFuZA0KPiA+IA0KPiA+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC9jb21taXQvP2lkPWMzNWYxYjg3ZmM1OTU4MDdmZjE1
ZDI4MzRkMjQxZjk3NzE0OTcyMDUNCj4gPiANCj4gPiBTbyBVcHN0cmVhbSBVLUJvb3QgaXMgZ29p
bmcgdG8gbmVlZCBzZXZlcmFsIHBhdGNoZXMgdG8gZ2V0IHRoaW5ncw0KPiA+IHdvcmtpbmcNCj4g
PiBhZ2Fpbi4gIENsb2NrIGlkZW50aWZpZXJzIGFuZCBFdGhlcm5ldCBhcmUgdHdvIGtub3duIGFy
ZWFzLg0KPiANCj4gRG9uZS4NCj4gDQo+IEkganVzdCBzZW5kLW91dCBmZXcgcGF0Y2hlcyB0byBm
aXggVS1Cb290IFNpRml2ZSBDbG9jayBkcml2ZXIuDQo+IA0KPiBUaGUgVS1Cb290IFNpRml2ZSBD
bG9jayBkcml2ZXIgZml4IHNlcmllcyBjYW4gYmUgZm91bmQgaW4NCj4gcmlzY3ZfdW5sZWFzaGVk
X2Nsa19zeW5jX3YxIGJyYW5jaCBvZjoNCj4gaHR0cHM6Ly9naXRodWIuY29tL2F2cGF0ZWwvdS1i
b290LmdpdA0KPiANCj4gVXNlcnMgd2lsbCBhbHNvIHJlcXVpcmUgT3BlblNCSSBEVEIgZml4IHdo
aWNoIGNhbiBiZSBmb3VuZA0KPiBpbiBzaWZpdmVfdW5sZWFzaGVkX2R0Yl9maXhfdjEgYnJhbmNo
IG9mOg0KPiBodHRwczovL2dpdGh1Yi5jb20vYXZwYXRlbC9vcGVuc2JpLmdpdA0KPiANCg0KQWRk
aXRpb25hbGx5LCB1c2VyIGNhbiBhbHNvIHVzZSBGV19QQVlMT0FEX0ZEVF9QQVRIIGFyZ3VtZW50
IGR1cmluZw0KYnVpbGQgdG8gaW5jbHVkZSB0aGUgZHRiIGJ1aWx0IGZyb20ga2VybmVsLg0KDQpl
eGFtcGxlOg0KbWFrZSAtaiAzMiBQTEFURk9STT1zaWZpdmUvZnU1NDAgRldfUEFZTE9BRF9QQVRI
PTx1LWJvb3QgcGF0aD4vdS0NCmJvb3QuYmluIEZXX1BBWUxPQURfRkRUX1BBVEg9PGtlcm5lbF9k
dGJfcGF0aD4NCg0KDQo+IFdpdGggYWJvdmUgZml4ZXMsIHdlIGNhbiBub3cgdXNlIHNhbWUgRFRC
IGZvciBib3RoIFUtQm9vdA0KPiBhbmQgTGludXgga2VybmVsICg1LjItcmMxKS4gQWx0aG91Z2gs
IHVzZXJzIGFyZSBmcmVlIHRvIHBhc3MgYQ0KPiBkaWZmZXJlbnQgRFRCIHRvIExpbnV4IGtlcm5l
bCB2aWEgVEZUUC4NCj4gDQo+IEkgaGF2ZSB0ZXN0ZWQgU2lGaXZlIHNlcmlhbCBhbmQgQ2FkYW5j
ZSBNQUNCIGV0aGVybmV0IG9uDQo+IGJvdGggVS1Cb290IGFuZCBMaW51eCAoNS4yLXJjMSkNCj4g
DQo+IFJlZ2FyZHMsDQo+IEFudXANCi0tIA0KUmVnYXJkcywNCkF0aXNoDQo=
