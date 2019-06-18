Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A98BB4AE94
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 01:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfFRXL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 19:11:59 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:41881 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfFRXL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 19:11:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560899520; x=1592435520;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wdGDk/rCK6MmREYzQrYgnXHm1djyjycy3pwOyCJ2Sm8=;
  b=GoLpQBkVtzgQCyYB9QRLf8fU0NqUXQ09qtsTitHksyp9E3axurPskUR4
   ehI3M6BhTLJq42ktNCF5jfToWLL7jmi7RqDHJyXPVxOC9yh9YVSbplvad
   +EJ5CoDgTyKxKbgsLtkEHHtc1UZOFqvkp2OCbs8qs+vYu5qSjkWfBfReS
   0zPMX2UZQBa5ZpCal/hHFKBm9gf9lZSPkRyuAGXw0yYbTDEDTZU4023c4
   U8EuI0SWjyn9Rm94S4P2yqRWfgO/jDjp0LPX7eyQ/Y3DWiM7ppcj/UmTH
   u/TfIjlRAZpALbhBD1cY3yldIE6Bc0L185wDiUN4Zm2RgoUkg8DwxOO4G
   w==;
X-IronPort-AV: E=Sophos;i="5.63,390,1557158400"; 
   d="scan'208";a="112554704"
Received: from mail-bn3nam01lp2058.outbound.protection.outlook.com (HELO NAM01-BN3-obe.outbound.protection.outlook.com) ([104.47.33.58])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jun 2019 07:11:57 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdGDk/rCK6MmREYzQrYgnXHm1djyjycy3pwOyCJ2Sm8=;
 b=G1Qftan7ZUcsP6dKZAWN/BNMD2mJB9OEYAzEurgd0k4c87z5UcjI3n0g3jpHGWwB2jzV0a2xwRTESFPO7JzmFD++ndY9Y37LdOzF8smWhAe+EYoVMlFxAeC3XrMBXKpYDurx5YShQQ/oEVpFP8YMkeOQlxUGIAmuOlPZNREHbG4=
Received: from BYAPR04MB4901.namprd04.prod.outlook.com (52.135.232.206) by
 BYAPR04MB4167.namprd04.prod.outlook.com (20.176.250.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Tue, 18 Jun 2019 23:11:55 +0000
Received: from BYAPR04MB4901.namprd04.prod.outlook.com
 ([fe80::40b0:3c4b:b778:664d]) by BYAPR04MB4901.namprd04.prod.outlook.com
 ([fe80::40b0:3c4b:b778:664d%7]) with mapi id 15.20.1987.012; Tue, 18 Jun 2019
 23:11:55 +0000
From:   Alistair Francis <Alistair.Francis@wdc.com>
To:     "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "palmer@sifive.com" <palmer@sifive.com>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "yash.shah@sifive.com" <yash.shah@sifive.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sachin.ghadi@sifive.com" <sachin.ghadi@sifive.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ynezz@true.cz" <ynezz@true.cz>, "jamez@wit.com" <jamez@wit.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "schwab@suse.de" <schwab@suse.de>,
        "troy.benjegerdes@sifive.com" <troy.benjegerdes@sifive.com>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH v2 0/2] Add macb support for SiFive FU540-C000
Thread-Topic: [PATCH v2 0/2] Add macb support for SiFive FU540-C000
Thread-Index: AQHVJMPxUGJ6CrWTfEOSlZ7T+RNJNKafgw4CgAAZzACAAAECfoAAAOIAgAAC1UKAABYjAIAALLGAgABKKYCAAJMSAIABSp2A
Date:   Tue, 18 Jun 2019 23:11:54 +0000
Message-ID: <e054e1c22cc52c41cea36b005de5a5ade0f8a23e.camel@wdc.com>
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
In-Reply-To: <alpine.DEB.2.21.9999.1906172019040.15057@viisi.sifive.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Alistair.Francis@wdc.com; 
x-originating-ip: [199.255.44.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7841107-ad62-4dfd-a4d1-08d6f4425b11
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB4167;
x-ms-traffictypediagnostic: BYAPR04MB4167:
x-ms-exchange-purlcount: 2
wdcipoutbound: EOP-TRUE
x-microsoft-antispam-prvs: <BYAPR04MB4167558D7B95D6A935ED14CF90EA0@BYAPR04MB4167.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6029001)(39860400002)(376002)(346002)(136003)(366004)(396003)(199004)(189003)(81166006)(7736002)(6116002)(118296001)(2906002)(486006)(71200400001)(316002)(4326008)(36756003)(8936002)(6306002)(11346002)(186003)(54906003)(2351001)(6436002)(73956011)(6512007)(6246003)(53936002)(446003)(71190400001)(5640700003)(25786009)(99286004)(72206003)(305945005)(66066001)(7416002)(6916009)(3846002)(66946007)(478600001)(2616005)(229853002)(2501003)(68736007)(8676002)(966005)(6506007)(102836004)(76116006)(66556008)(6486002)(66446008)(86362001)(66476007)(64756008)(476003)(76176011)(5660300002)(14454004)(26005)(256004)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4167;H:BYAPR04MB4901.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SXMcN5hIZqKBgsnD5O6yENR/GBnGh6DilH52ZRaPKP47w5hOx7NyBj8Q8tM8zxkVpJwyFb/t6qN3G71Zs4AzxwF2ZUsDgietuXwLK2e03Da/fXG3GNoR6HK7hnWEq6jvAzGklqJZUEhLeRODpgcyOOZeqluakaJy1hxX4li9Kt8PxfZXsj4v2Ua/kIxZkjoxNii38+2BiWOJAha30LJyteOfa3rWNusB8Vpjaznh5Spskv+8jE25Ip/TiVeyvOhIgHEP392jyWdsZelmAVKFnt9CQ2AALlolWMvN/8ldYK4q3Ovm1soEYB29s0hE5SKsqyH/vhqdEGLvQM02esSPrJDoZAHzzeTRf0ZqCMMOky4ArA0QNoUXTX82q/F1GFQxmqnNzRFkkkZoa99ELhZnO0F2BF81DmUc6nHS8Pd9mjo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B51FAF1422A4224AB60D396DA226F398@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7841107-ad62-4dfd-a4d1-08d6f4425b11
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 23:11:55.0886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Alistair.Francis@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4167
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA2LTE3IGF0IDIwOjI2IC0wNzAwLCBQYXVsIFdhbG1zbGV5IHdyb3RlOg0K
PiBPbiBNb24sIDE3IEp1biAyMDE5LCBBbGlzdGFpciBGcmFuY2lzIHdyb3RlOg0KPiANCj4gPiA+
IFRoZSBsZWdhY3kgTS1tb2RlIFUtYm9vdCBoYW5kbGVzIHRoZSBwaHkgcmVzZXQgYWxyZWFkeSwg
YW5kIEnigJl2ZQ0KPiA+ID4gYmVlbg0KPiA+ID4gYWJsZSB0byBsb2FkIHVwc3RyZWFtIFMtbW9k
ZSB1Ym9vdCBhcyBhIHBheWxvYWQgdmlhIFRGVFAsIGFuZA0KPiA+ID4gdGhlbiANCj4gPiA+IGxv
YWQgYW5kIGJvb3QgYSA0LjE5IGtlcm5lbC4gDQo+ID4gPiANCj4gPiA+IEl0IHdvdWxkIGJlIG5p
Y2UgdG8gZ2V0IHRoaXMgYWxsIHdvcmtpbmcgd2l0aCA1LngsIGhvd2V2ZXIgdGhlcmUNCj4gPiA+
IGFyZQ0KPiA+ID4gc3RpbGwNCj4gPiA+IHNldmVyYWwgbWlzc2luZyBwaWVjZXMgdG8gcmVhbGx5
IGhhdmUgaXQgd29yayB3ZWxsLg0KPiA+IA0KPiA+IExldCBtZSBrbm93IHdoYXQgaXMgc3RpbGwg
bWlzc2luZy9kb2Vzbid0IHdvcmsgYW5kIEkgY2FuIGFkZCBpdC4gQXQNCj4gPiB0aGUNCj4gPiBt
b21lbnQgdGhlIG9ubHkga25vd24gaXNzdWUgSSBrbm93IG9mIGlzIGEgbWlzc2luZyBTRCBjYXJk
IGRyaXZlcg0KPiA+IGluIFUtDQo+ID4gQm9vdC4NCj4gDQo+IFRoZSBEVCBkYXRhIGhhcyBjaGFu
Z2VkIGJldHdlZW4gdGhlIG5vbi11cHN0cmVhbSBkYXRhIHRoYXQgcGVvcGxlIA0KPiBkZXZlbG9w
ZWQgYWdhaW5zdCBwcmV2aW91c2x5LCB2cy4gdGhlIERUIGRhdGEgdGhhdCBqdXN0IHdlbnQNCj4g
dXBzdHJlYW0gDQo+IGhlcmU6DQo+IA0KPiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lz9pZD03MjI5NmJkZTRm
NDIwNzU2Njg3MmVlMzU1OTUwYTU5Y2JjMjlmODUyDQo+IA0KPiBhbmQNCj4gDQo+IGh0dHBzOi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4Lmdp
dC9jb21taXQvP2lkPWMzNWYxYjg3ZmM1OTU4MDdmZjE1ZDI4MzRkMjQxZjk3NzE0OTcyMDUNCj4g
DQo+IFNvIFVwc3RyZWFtIFUtQm9vdCBpcyBnb2luZyB0byBuZWVkIHNldmVyYWwgcGF0Y2hlcyB0
byBnZXQgdGhpbmdzDQo+IHdvcmtpbmcgDQo+IGFnYWluLiAgQ2xvY2sgaWRlbnRpZmllcnMgYW5k
IEV0aGVybmV0IGFyZSB0d28ga25vd24gYXJlYXMuDQoNClllcCwgQW51cCBoYXMgc2VudCBwYXRj
aGVzIHRvIFUtQm9vdCBhbmQgT3BlblNCSS4NCg0KQWxpc3RhaXINCg0KPiANCj4gDQo+IC0gUGF1
bA0K
