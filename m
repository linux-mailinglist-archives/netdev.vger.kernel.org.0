Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78CB5192D37
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgCYPri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:47:38 -0400
Received: from mail-eopbgr80098.outbound.protection.outlook.com ([40.107.8.98]:24022
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727701AbgCYPri (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 11:47:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8Evp2cTym91D8INk1QdZ5xyyIDZGD9nhNWoaka2p2VJeVuu+Zd/GcG4aMqbRrKu5YMEfy+hDnxBC1+2tAhOR/SEP/z5UiHPVQKeMGBEyhv9DeUyPrAQ5+k9vYWiUlSypGQTLKyNBrzQwNQ+kFBe73idUCblK6Bc2gLn7wBlen7f0Hv+Nxv5PTAQubwrBML025olpxQcUWsVmnc8o2ZY0TLf+G8HycEQrBDydTmH+kL4fhXkG7mKGnl9CMMaTQNb50vjhDa0xUfoEU0DuU8PuE0cVX+IqYkm6UV/AHl+2n/AxPG5PJr6ts1JA8p+rR9kLjjlCp801/7HncaWT+Lksg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7BM/T1ytw7JUCqB4/dvAHNxrgi2PXFIUGC1AoHTJi8=;
 b=ZES7+RgtD17sOBzU24fhzNgIkfG9axtw8bLeNRiIU2g8Yu7DeD0Tr9s2JwnVTcXBCIkLdpbSbOWZB/IGlzpooUWKPkILbULftKHh/Ov6Q9xSx/obGicD+RlbPOAw9ShiL3nekbh+9imQt5ZLzC5Y0TMat4KJ+EnpHiR92svBZNMByHbhXPH/LHQHHSLMHxX6W7vpnWpr6mFBhUsAdqrEj/wpGg73csTWzpr//8lXJTtiPLg43WU0O5I+8eIaAuszfjtrfq4HVPRmdgYj+uYj9WNtWyjFuW57YMOLZ3hmh9jFVv8XnJBnzxP6hB/h83+ClBtufwcp7TWLBJiqWfIiUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7BM/T1ytw7JUCqB4/dvAHNxrgi2PXFIUGC1AoHTJi8=;
 b=nZvsmU8BP/cqg4ZTwDtnQ2ps9w4IdqYCTHFT2zsuZmVtr89xVlP6izE/f3A+jti0CG3WewDykQAwE9Nwuu/y6Y8AiBavo/sUcgzVjja91NH0I8b0rXHhpf8v/79Q6NH4cq4bmjSZgvdzRO+LZVBFbdGMFv+f3VqpUpvjbegMkDg=
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com (20.179.1.217) by
 AM6PR05MB6055.eurprd05.prod.outlook.com (20.179.3.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Wed, 25 Mar 2020 15:47:33 +0000
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::dee:ffa2:1d09:30e]) by AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::dee:ffa2:1d09:30e%4]) with mapi id 15.20.2835.021; Wed, 25 Mar 2020
 15:47:33 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
CC:     "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.fatoum@pengutronix.de" <a.fatoum@pengutronix.de>,
        "silvan.murer@gmail.com" <silvan.murer@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] net: phy: micrel.c: add rgmii interface delay
 possibility to ksz9131
Thread-Topic: [PATCH 1/2] net: phy: micrel.c: add rgmii interface delay
 possibility to ksz9131
Thread-Index: AQHWAraTCUxME8WysEi2b/8453xgs6hZbWMAgAAGlAA=
Date:   Wed, 25 Mar 2020 15:47:32 +0000
Message-ID: <00c7067dc44e0293b497de4ec3527bc8d18f58b9.camel@toradex.com>
References: <20200325150329.228329-1-philippe.schenker@toradex.com>
         <d1067087-2cb8-f7c7-7929-2c4c9d2a4cb3@gmail.com>
In-Reply-To: <d1067087-2cb8-f7c7-7929-2c4c9d2a4cb3@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.0 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=philippe.schenker@toradex.com; 
x-originating-ip: [31.10.206.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2545caf-7837-4d72-c7e9-08d7d0d3d544
x-ms-traffictypediagnostic: AM6PR05MB6055:
x-microsoft-antispam-prvs: <AM6PR05MB6055209A0CC249A7E8B565F7F4CE0@AM6PR05MB6055.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0353563E2B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(366004)(136003)(396003)(39850400004)(36756003)(2906002)(186003)(2616005)(81156014)(71200400001)(8676002)(316002)(54906003)(110136005)(6486002)(81166006)(8936002)(53546011)(6506007)(7416002)(66556008)(66476007)(64756008)(66446008)(66946007)(86362001)(4326008)(26005)(76116006)(44832011)(91956017)(478600001)(6512007)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB6055;H:AM6PR05MB6120.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D5txuqhhx6QluWanD4qNWaJhgKHXEWSxdJWrYQI1B0m9TMFON8zHYv0s3q/K4X8RsRa08ltSdsak9llLZyGegcG96ews4M6tSWLt4TLVd7Hl7S2gYVTPWpRpaIEa5Oarr70c1DhWsdZXq+RiT1lzg3fV8hL38JyVYQbEl8NRG2KEftx7BQ/7lRTs2MitgeqBFCUKak7vQkURsDub5WBJOIXNJGOiThcRa6sKdKDu54PVFAN5CbuB57h4CBAQP2OsQO5axnXZfvQ9niWC+J5rEn5hRQdqAUl/gm8MV1JgahDAfZk8pRZt3rW7eeOrN0iwV1QxYiE2r0DZweTym1sObywbYJR7ltWqm4QbUOxAfS7DeyxxYhLWhsXnRhL6heR+Bxtx9HdPoFkhPp537+xZAXy7L1C30C+rxX1gWg1i5M4KRC2NbbMjgMX4dZ3Nlql0
x-ms-exchange-antispam-messagedata: 1Bq25IZGifT6RJF1za1gleeqNRu8i59w5Mo7vOkzC/jX1Tgul9W9xscj0930oH/G9e29i3TDc4Y6TCE9bMmICRIbi/bUnuZevDclUN5DcFBBv5cYjzuEkqnLrc99tK/t6fGa0LThkmvxyQjhBoza0w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <17FAF7673F276347991CE671F971397B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2545caf-7837-4d72-c7e9-08d7d0d3d544
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2020 15:47:32.9686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LRsbn3FBiEDs8V4c5IS8PaRjsWMej7IqcPKmUwnd8OEGUismsY+PchZyHZ0FcqPPRtTShjQoLTcaTh+1BXTfGP4wrB+C6lWaf/ouwxzLoBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6055
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTAzLTI1IGF0IDE2OjI0ICswMTAwLCBIZWluZXIgS2FsbHdlaXQgd3JvdGU6
DQo+IE9uIDI1LjAzLjIwMjAgMTY6MDMsIFBoaWxpcHBlIFNjaGVua2VyIHdyb3RlOg0KPiA+IFRo
ZSBLU1o5MTMxIHByb3ZpZGVzIERMTCBjb250cm9sbGVkIGRlbGF5cyBvbiBSWEMgYW5kIFRYQyBs
aW5lcy4NCj4gPiBUaGlzDQo+ID4gcGF0Y2ggbWFrZXMgdXNlIG9mIHRob3NlIGRlbGF5cy4gVGhl
IGluZm9ybWF0aW9uIHdoaWNoIGRlbGF5cyBzaG91bGQNCj4gPiBiZSBlbmFibGVkIG9yIGRpc2Fi
bGVkIGNvbWVzIGZyb20gdGhlIGludGVyZmFjZSBuYW1lcywgZG9jdW1lbnRlZCBpbg0KPiA+IGV0
aGVybmV0LWNvbnRyb2xsZXIueWFtbDoNCj4gPiANCj4gPiByZ21paTogICAgICBEaXNhYmxlIFJY
QyBhbmQgVFhDIGRlbGF5cw0KPiA+IHJnbWlpLWlkOiAgIEVuYWJsZSBSWEMgYW5kIFRYQyBkZWxh
eXMNCj4gPiByZ21paS10eGlkOiBFbmFibGUgb25seSBUWEMgZGVsYXksIGRpc2FibGUgUlhDIGRl
bGF5DQo+ID4gcmdtaWktcnhpZDogRW5hYmxlIG9ubHggUlhDIGRlbGF5LCBkaXNhYmxlIFRYQyBk
ZWxheQ0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFBoaWxpcHBlIFNjaGVua2VyIDxwaGlsaXBw
ZS5zY2hlbmtlckB0b3JhZGV4LmNvbT4NCj4gPiAtLS0NCj4gPiANCj4gPiAgZHJpdmVycy9uZXQv
cGh5L21pY3JlbC5jIHwgNDUNCj4gPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA0NSBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9taWNyZWwuYyBiL2RyaXZlcnMvbmV0L3BoeS9t
aWNyZWwuYw0KPiA+IGluZGV4IDYzZGVkZWMwNDMzZC4uZDNhZDA5Nzc0ODQ3IDEwMDY0NA0KPiA+
IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9taWNyZWwuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3Bo
eS9taWNyZWwuYw0KPiA+IEBAIC03MDQsNiArNzA0LDQ4IEBAIHN0YXRpYyBpbnQga3N6OTEzMV9v
Zl9sb2FkX3NrZXdfdmFsdWVzKHN0cnVjdA0KPiA+IHBoeV9kZXZpY2UgKnBoeWRldiwNCj4gPiAg
CXJldHVybiBwaHlfd3JpdGVfbW1kKHBoeWRldiwgMiwgcmVnLCBuZXd2YWwpOw0KPiA+ICB9DQo+
ID4gIA0KPiA+ICsvKiBNTUQgQWRkcmVzcyAweDIgKi8NCj4gPiArI2RlZmluZSBLU1o5MTMxUk5f
UlhDX0RMTF9DVFJMCQk3Ng0KPiA+ICsjZGVmaW5lIEtTWjkxMzFSTl9UWENfRExMX0NUUkwJCTc3
DQo+ID4gKyNkZWZpbmUgS1NaOTEzMVJOX0RMTF9DVFJMX0JZUEFTUwlCSVRfTUFTSygxMikNCj4g
PiArI2RlZmluZSBLU1o5MTMxUk5fRExMX0VOQUJMRV9ERUxBWQkwDQo+ID4gKyNkZWZpbmUgS1Na
OTEzMVJOX0RMTF9ESVNBQkxFX0RFTEFZCUJJVCgxMikNCj4gPiArDQo+ID4gK3N0YXRpYyBpbnQg
a3N6OTEzMV9jb25maWdfcmdtaWlfZGVsYXkoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4g
PiArew0KPiA+ICsJaW50IHJldDsNCj4gPiArCXUxNiByeGNkbGxfdmFsLCB0eGNkbGxfdmFsOw0K
PiA+ICsNCj4gDQo+IFJldmVyc2UgeG1hcyB0cmVlIG9yZGVyIHBsZWFzZS4NCj4gDQo+ID4gKwlz
d2l0Y2ggKHBoeWRldi0+aW50ZXJmYWNlKSB7DQo+ID4gKwljYXNlIFBIWV9JTlRFUkZBQ0VfTU9E
RV9SR01JSToNCj4gPiArCQlyeGNkbGxfdmFsID0gS1NaOTEzMVJOX0RMTF9ESVNBQkxFX0RFTEFZ
Ow0KPiA+ICsJCXR4Y2RsbF92YWwgPSBLU1o5MTMxUk5fRExMX0RJU0FCTEVfREVMQVk7DQo+ID4g
KwkJYnJlYWs7DQo+ID4gKwljYXNlIFBIWV9JTlRFUkZBQ0VfTU9ERV9SR01JSV9JRDoNCj4gPiAr
CQlyeGNkbGxfdmFsID0gS1NaOTEzMVJOX0RMTF9FTkFCTEVfREVMQVk7DQo+ID4gKwkJdHhjZGxs
X3ZhbCA9IEtTWjkxMzFSTl9ETExfRU5BQkxFX0RFTEFZOw0KPiA+ICsJCWJyZWFrOw0KPiA+ICsJ
Y2FzZSBQSFlfSU5URVJGQUNFX01PREVfUkdNSUlfUlhJRDoNCj4gPiArCQlyeGNkbGxfdmFsID0g
S1NaOTEzMVJOX0RMTF9FTkFCTEVfREVMQVk7DQo+ID4gKwkJdHhjZGxsX3ZhbCA9IEtTWjkxMzFS
Tl9ETExfRElTQUJMRV9ERUxBWTsNCj4gPiArCQlicmVhazsNCj4gPiArCWNhc2UgUEhZX0lOVEVS
RkFDRV9NT0RFX1JHTUlJX1RYSUQ6DQo+ID4gKwkJcnhjZGxsX3ZhbCA9IEtTWjkxMzFSTl9ETExf
RElTQUJMRV9ERUxBWTsNCj4gPiArCQl0eGNkbGxfdmFsID0gS1NaOTEzMVJOX0RMTF9FTkFCTEVf
REVMQVk7DQo+ID4gKwkJYnJlYWs7DQo+ID4gKwlkZWZhdWx0Og0KPiA+ICsJCXJldHVybiAwOw0K
PiA+ICsJfQ0KPiA+ICsNCj4gPiArCXJldCA9IHBoeV9tb2RpZnlfbW1kX2NoYW5nZWQocGh5ZGV2
LCAyLCBLU1o5MTMxUk5fUlhDX0RMTF9DVFJMLA0KPiA+ICsJCQkJICAgICBLU1o5MTMxUk5fRExM
X0NUUkxfQllQQVNTLA0KPiA+IHJ4Y2RsbF92YWwpOw0KPiA+ICsJaWYgKHJldCA8IDApDQo+ID4g
KwkJcmV0dXJuIHJldDsNCj4gPiArDQo+ID4gKwlyZXR1cm4gcGh5X21vZGlmeV9tbWRfY2hhbmdl
ZChwaHlkZXYsIDIsIEtTWjkxMzFSTl9UWENfRExMX0NUUkwsDQo+ID4gKwkJCQkgICAgIEtTWjkx
MzFSTl9ETExfQ1RSTF9CWVBBU1MsDQo+ID4gdHhjZGxsX3ZhbCk7DQo+IA0KPiBwaHlfbW9kaWZ5
X21tZF9jaGFuZ2VkKCkgcmV0dXJucyAxIGlmIHRoZSByZWdpc3RlciB2YWx1ZSB3YXMgY2hhbmdl
ZCwNCj4gYW5kIHRoYXQncyBub3Qgd2hhdCB5b3Ugd2FudCBoZXJlLiBTaW1wbHkgdXNlIHBoeV9t
b2RpZnlfbW1kKCkgaW4gYm90aA0KPiBvY2N1cnJlbmNlcy4gQW5kIHlvdXIgZnVuY3Rpb24gaGFz
IGEgcmV0dXJuIHZhbHVlLCBidXQgaXQncyBub3QgdXNlZA0KPiBieQ0KPiB0aGUgY2FsbGVyLg0K
DQpUaGFua3MgZm9yIHlvdXIgZmVlZGJhY2ssIEknbGwgc2VuZCBhIHYyIHdpdGggdGhvc2UgZml4
ZXMuDQo+IA0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0aWMgaW50IGtzejkxMzFfY29uZmlnX2lu
aXQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4gPiAgew0KPiA+ICAJY29uc3Qgc3RydWN0
IGRldmljZSAqZGV2ID0gJnBoeWRldi0+bWRpby5kZXY7DQo+ID4gQEAgLTczMCw2ICs3NzIsOSBA
QCBzdGF0aWMgaW50IGtzejkxMzFfY29uZmlnX2luaXQoc3RydWN0IHBoeV9kZXZpY2UNCj4gPiAq
cGh5ZGV2KQ0KPiA+ICAJaWYgKCFvZl9ub2RlKQ0KPiA+ICAJCXJldHVybiAwOw0KPiA+ICANCj4g
PiArCWlmIChwaHlfaW50ZXJmYWNlX2lzX3JnbWlpKHBoeWRldikpDQo+ID4gKwkJa3N6OTEzMV9j
b25maWdfcmdtaWlfZGVsYXkocGh5ZGV2KTsNCj4gPiArDQo+ID4gIAlyZXQgPSBrc3o5MTMxX29m
X2xvYWRfc2tld192YWx1ZXMocGh5ZGV2LCBvZl9ub2RlLA0KPiA+ICAJCQkJCSAgTUlJX0tTWjkw
MzFSTl9DTEtfUEFEX1NLRVcsIDUsDQo+ID4gIAkJCQkJICBjbGtfc2tld3MsIDIpOw0KPiA+IA0K
