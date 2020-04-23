Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31891B57EB
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 11:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgDWJP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 05:15:56 -0400
Received: from mail-eopbgr40060.outbound.protection.outlook.com ([40.107.4.60]:40544
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbgDWJPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 05:15:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h2uRIgW5yJOBhNXDg1DU7fEDv+CdWj10Pm4DD/172H5eUVGOKLZr/Z+Xh7EdXpERb4v3w0xWEcD90zZ+k2vwU4GWTzDekeky/YgQLlYMaeKLkt7Q+eEDd1xwA/xcOkIydnqWg6hHdwVkNvlHzhnGlph6SvhTJDWUyJPk206JQP1jlzWhtRzVubtsWRdiN3xL/PJGAazopXRoq0M4w8JSfFmkj4TTY5l4V8f5b+5qPG/2a0Tyaj2mbeHfvYIUol7wRSH5+av65vZdDaeIKPo6P/UkPoPzMZTh2YAPkqsx7lg0RLQ9KgJDECEdshVbQ3Ls01DBRXae+UuyOGWesVPfaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rhAJgA1MH+2OazCz+GqRDTPikihzvSB4TrGEIi5Jz0=;
 b=UIBM09mB7VM4mdNThBZ889L6/MC2MCEoaP8fiPgGRWubvXUDRTB8auI53B6URPa5AYeBMXR1fMsdGErJlnq5THYSfFN2TWH2DOsjfE34cJSit8eAUtWeemHWOopwyQ0Y2dq2q42lVeylB3wrG7G8StWiTtnDBZIPzt/NKgKxhYejVc1D0n3IFKM1+Tt1fS/1gpcJhxRmsb48AZdY+6pBKZnFmPBD+MI29+kjUsebVKflr6iiKN62MQPIvn3uODQPtz/0CKccMdLDN64mOOVHTSrhi/Oo+DyjCILzgindaplA0V8uAtd1morDw0zbe75tacpXjbAd8kFGqonHLWKj+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rhAJgA1MH+2OazCz+GqRDTPikihzvSB4TrGEIi5Jz0=;
 b=cThfUMsUdq96T4+f4J7MI/jNqTTYAEdM9XB8uBQIwmWX+QmThTT24eDCN3cYn7e5gXnT1WJIflB7MpwcI5/pimt6kwX0tQJztQJZXQUEeMqnlqdUnUfzTv8OkU/m3jyJ1hCqePQGmZDSnxrwFbrsPXY5rNd1USQ2WNLFXnu2dl8=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6366.eurprd04.prod.outlook.com (2603:10a6:803:12a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Thu, 23 Apr
 2020 09:15:50 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2921.032; Thu, 23 Apr 2020
 09:15:50 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Vlad Buslov <vlad@buslov.dev>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
Subject: RE: [EXT] Re: [v3,net-next  1/4] net: qos: introduce a gate control
 flow action
Thread-Topic: [EXT] Re: [v3,net-next  1/4] net: qos: introduce a gate control
 flow action
Thread-Index: AQHWGFNl1uy1t0tlFE2NuiTq9Lz8sqiFIacAgADVg0CAAF3QgIAACTUAgAANEnA=
Date:   Thu, 23 Apr 2020 09:15:50 +0000
Message-ID: <VE1PR04MB6496F4805BCF53AF5889CB3892D30@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20200418011211.31725-5-Po.Liu@nxp.com>
 <20200422024852.23224-1-Po.Liu@nxp.com>
 <20200422024852.23224-2-Po.Liu@nxp.com> <877dy7bqo7.fsf@buslov.dev>
 <VE1PR04MB6496969AB18E17938671FA6092D30@VE1PR04MB6496.eurprd04.prod.outlook.com>
 <871roebqbe.fsf@buslov.dev>
 <VE1PR04MB6496AAA71717BBAD4C4CE2BC92D30@VE1PR04MB6496.eurprd04.prod.outlook.com>
In-Reply-To: <VE1PR04MB6496AAA71717BBAD4C4CE2BC92D30@VE1PR04MB6496.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [221.221.133.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 40114c64-98e4-446d-3d7c-08d7e766ea76
x-ms-traffictypediagnostic: VE1PR04MB6366:|VE1PR04MB6366:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB636661DF95FF9ECA09A164DC92D30@VE1PR04MB6366.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03827AF76E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(8676002)(81156014)(4326008)(8936002)(33656002)(6916009)(9686003)(6506007)(52536014)(316002)(478600001)(44832011)(7696005)(55016002)(54906003)(26005)(5660300002)(186003)(66946007)(2906002)(64756008)(2940100002)(66476007)(66556008)(76116006)(7416002)(86362001)(71200400001)(66446008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /LV8XtzJmPOz1PMk5WAYeTJsAJ9Mu3ihMYS47LcUly+lwMz4jXKQ0eVdVnkyCMUkwpwFyfFd2ZG9uE1WutUs2f5IpdNh4jxdZuRqvfug/+MMuwAatwmJ6arObM9eZ63LlT+zjhTbTCViu207KzNNwdlSGet988N88/FYHrjUd80gjeAt4CR7x+w6VNac5b004Mfe7Etip/UjjC66zqvqzVuSIUP3YQjjovTJ2tZ1kGAq4rf8scvgzfo7YYJFvdxZ37WRnjPirrcuVmsPEuXCgta4Dc2z4BPc5cyLzQALkS2ewTglJmVLd+cqFaFO1SymxZe8xNESh4HEYgLq59RtN6CcOfnltrLZ9DK7m+YhV3t0XF7nBvVhADvmp1YWRcSqwPF/O0D7otxqYEh/o8UR8pu90Vgks+HADx3g1k1iHv9zXsx2uYQaqZLtyqmaCHON
x-ms-exchange-antispam-messagedata: 5IihMQbuAPwR7FXOn9pckmRWavzMJ/yrYTlR9epd8hX2jABQWTi+BOcnn0X5ug4hn6ReeNG9pTfLBBLtET9DppFLd+LY5CxarWwaQrQ9mhYOyzxmFzlIm2ib2NJ3RuXwM0tbbVlYPD3KLdeIflg7Ag==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40114c64-98e4-446d-3d7c-08d7e766ea76
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2020 09:15:50.0543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /TTz6DQRLM+eFTkXzl9YK959ZPvtdwrjDPNMjjgDq2rSgW7UU02M3XsBJ0Yad4a8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6366
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZCBCdXNsb3YsDQoNCj4gPiA+PiA+ICtzdGF0aWMgZW51bSBocnRpbWVyX3Jlc3RhcnQg
Z2F0ZV90aW1lcl9mdW5jKHN0cnVjdCBocnRpbWVyICp0aW1lcikNCj4gew0KPiA+ID4+ID4gKyAg
ICAgc3RydWN0IGdhdGVfYWN0aW9uICpnYWN0ID0gY29udGFpbmVyX29mKHRpbWVyLCBzdHJ1Y3QN
Cj4gZ2F0ZV9hY3Rpb24sDQo+ID4gPj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgaGl0aW1lcik7DQo+ID4gPj4gPiArICAgICBzdHJ1Y3QgdGNmX2dhdGVf
cGFyYW1zICpwID0gZ2V0X2dhdGVfcGFyYW0oZ2FjdCk7DQo+ID4gPj4gPiArICAgICBzdHJ1Y3Qg
dGNmZ19nYXRlX2VudHJ5ICpuZXh0Ow0KPiA+ID4+ID4gKyAgICAga3RpbWVfdCBjbG9zZV90aW1l
LCBub3c7DQo+ID4gPj4gPiArDQo+ID4gPj4gPiArICAgICBzcGluX2xvY2soJmdhY3QtPmVudHJ5
X2xvY2spOw0KPiA+ID4+ID4gKw0KPiA+ID4+ID4gKyAgICAgbmV4dCA9IHJjdV9kZXJlZmVyZW5j
ZV9wcm90ZWN0ZWQoZ2FjdC0+bmV4dF9lbnRyeSwNCj4gPiA+PiA+ICsNCj4gPiA+PiA+ICsgbG9j
a2RlcF9pc19oZWxkKCZnYWN0LT5lbnRyeV9sb2NrKSk7DQo+ID4gPj4gPiArDQo+ID4gPj4gPiAr
ICAgICAvKiBjeWNsZSBzdGFydCwgY2xlYXIgcGVuZGluZyBiaXQsIGNsZWFyIHRvdGFsIG9jdGV0
cyAqLw0KPiA+ID4+ID4gKyAgICAgZ2FjdC0+Y3VycmVudF9nYXRlX3N0YXR1cyA9IG5leHQtPmdh
dGVfc3RhdGUgPw0KPiA+ID4+IEdBVEVfQUNUX0dBVEVfT1BFTiA6IDA7DQo+ID4gPj4gPiArICAg
ICBnYWN0LT5jdXJyZW50X2VudHJ5X29jdGV0cyA9IDA7DQo+ID4gPj4gPiArICAgICBnYWN0LT5j
dXJyZW50X21heF9vY3RldHMgPSBuZXh0LT5tYXhvY3RldHM7DQo+ID4gPj4gPiArDQo+ID4gPj4g
PiArICAgICBnYWN0LT5jdXJyZW50X2Nsb3NlX3RpbWUgPSBrdGltZV9hZGRfbnMoZ2FjdC0NCj4g
PiA+Y3VycmVudF9jbG9zZV90aW1lLA0KPiA+ID4+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIG5leHQtPmludGVydmFsKTsNCj4gPiA+PiA+ICsNCj4gPiA+
PiA+ICsgICAgIGNsb3NlX3RpbWUgPSBnYWN0LT5jdXJyZW50X2Nsb3NlX3RpbWU7DQo+ID4gPj4g
PiArDQo+ID4gPj4gPiArICAgICBpZiAobGlzdF9pc19sYXN0KCZuZXh0LT5saXN0LCAmcC0+ZW50
cmllcykpDQo+ID4gPj4gPiArICAgICAgICAgICAgIG5leHQgPSBsaXN0X2ZpcnN0X2VudHJ5KCZw
LT5lbnRyaWVzLA0KPiA+ID4+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBzdHJ1Y3QgdGNmZ19nYXRlX2VudHJ5LCBsaXN0KTsNCj4gPiA+PiA+ICsgICAgIGVsc2UNCj4g
PiA+PiA+ICsgICAgICAgICAgICAgbmV4dCA9IGxpc3RfbmV4dF9lbnRyeShuZXh0LCBsaXN0KTsN
Cj4gPiA+PiA+ICsNCj4gPiA+PiA+ICsgICAgIG5vdyA9IGdhdGVfZ2V0X3RpbWUoZ2FjdCk7DQo+
ID4gPj4gPiArDQo+ID4gPj4gPiArICAgICBpZiAoa3RpbWVfYWZ0ZXIobm93LCBjbG9zZV90aW1l
KSkgew0KPiA+ID4+ID4gKyAgICAgICAgICAgICBrdGltZV90IGN5Y2xlLCBiYXNlOw0KPiA+ID4+
ID4gKyAgICAgICAgICAgICB1NjQgbjsNCj4gPiA+PiA+ICsNCj4gPiA+PiA+ICsgICAgICAgICAg
ICAgY3ljbGUgPSBwLT50Y2ZnX2N5Y2xldGltZTsNCj4gPiA+PiA+ICsgICAgICAgICAgICAgYmFz
ZSA9IG5zX3RvX2t0aW1lKHAtPnRjZmdfYmFzZXRpbWUpOw0KPiA+ID4+ID4gKyAgICAgICAgICAg
ICBuID0gZGl2NjRfdTY0KGt0aW1lX3N1Yl9ucyhub3csIGJhc2UpLCBjeWNsZSk7DQo+ID4gPj4g
PiArICAgICAgICAgICAgIGNsb3NlX3RpbWUgPSBrdGltZV9hZGRfbnMoYmFzZSwgKG4gKyAxKSAq
IGN5Y2xlKTsNCj4gPiA+PiA+ICsgICAgIH0NCj4gPiA+PiA+ICsNCj4gPiA+PiA+ICsgICAgIHJj
dV9hc3NpZ25fcG9pbnRlcihnYWN0LT5uZXh0X2VudHJ5LCBuZXh0KTsNCj4gPiA+PiA+ICsgICAg
IHNwaW5fdW5sb2NrKCZnYWN0LT5lbnRyeV9sb2NrKTsNCj4gPiA+Pg0KPiA+ID4+IEkgaGF2ZSBj
b3VwbGUgb2YgcXVlc3Rpb24gYWJvdXQgc3luY2hyb25pemF0aW9uIGhlcmU6DQo+ID4gPj4NCj4g
PiA+PiAtIFdoeSBkbyB5b3UgbmVlZCBuZXh0X2VudHJ5IHRvIGJlIHJjdSBwb2ludGVyPyBJdCBp
cyBvbmx5IGFzc2lnbmVkDQo+ID4gPj4gaGVyZSB3aXRoIGVudHJ5X2xvY2sgcHJvdGVjdGlvbiBh
bmQgaW4gaW5pdCBjb2RlIGJlZm9yZSBhY3Rpb24gaXMNCj4gPiA+PiB2aXNpYmxlIHRvIGNvbmN1
cnJlbnQgdXNlcnMuIEkgZG9uJ3Qgc2VlIGFueSB1bmxvY2tlZCByY3UtcHJvdGVjdGVkDQo+ID4g
Pj4gcmVhZGVycyBoZXJlIHRoYXQgY291bGQgYmVuZWZpdCBmcm9tIGl0Lg0KPiA+ID4+DQo+ID4g
Pj4gLSBXaHkgY3JlYXRlIGRlZGljYXRlZCBlbnRyeV9sb2NrIGluc3RlYWQgb2YgdXNpbmcgYWxy
ZWFkeSBleGlzdGluZw0KPiA+ID4+IHBlci0gYWN0aW9uIHRjZl9sb2NrPw0KPiA+ID4NCj4gPiA+
IFdpbGwgdHJ5IHRvIHVzZSB0aGUgdGNmX2xvY2sgZm9yIHZlcmlmaWNhdGlvbi4NCg0KSSB0aGlu
ayBJIGFkZGVkIGVudHJ5X2xvY2sgd2FzIHRoYXQgSSBjYW4ndCBnZXQgdGhlIHRjX2FjdGlvbiBj
b21tb24gcGFyYW1ldGVyIGluIHRoaXMgIHRpbWVyIGZ1bmN0aW9uLiBJZiBJIGluc2lzdCB0byB1
c2UgdGhlIHRjZl9sb2NrLCBJIGhhdmUgdG8gbW92ZSB0aGUgaHJ0aW1lciB0byBzdHJ1Y3QgdGNm
X2dhdGUgd2hpY2ggaGFzIHRjX2FjdGlvbiBjb21tb24uDQpXaGF0IGRvIHlvdSB0aGluaz8NCg0K
PiA+ID4gVGhlIHRob3VnaHRzIGNhbWUgZnJvbSB0aGF0IHRoZSB0aW1lciBwZXJpb2QgYXJyaXZl
ZCB0aGVuIGNoZWNrDQo+ID4gPiB0aHJvdWdoIHRoZSBsaXN0IGFuZCB0aGVuIHVwZGF0ZSBuZXh0
IHRpbWUgd291bGQgdGFrZSBtdWNoIG1vcmUNCj4gdGltZS4NCj4gPiA+IEFjdGlvbiBmdW5jdGlv
biB3b3VsZCBiZSBidXN5IHdoZW4gdHJhZmZpYy4gU28gdXNlIGEgc2VwYXJhdGUgbG9jaw0KPiA+
ID4gaGVyZSBmb3INCj4gPiA+DQo+ID4gPj4NCj4gPiA+PiA+ICsNCj4gPiA+PiA+ICsgICAgIGhy
dGltZXJfc2V0X2V4cGlyZXMoJmdhY3QtPmhpdGltZXIsIGNsb3NlX3RpbWUpOw0KPiA+ID4+ID4g
Kw0KPiA+ID4+ID4gKyAgICAgcmV0dXJuIEhSVElNRVJfUkVTVEFSVDsNCj4gPiA+PiA+ICt9DQo+
ID4gPj4gPiArDQo+ID4gPj4gPiArc3RhdGljIGludCB0Y2ZfZ2F0ZV9hY3Qoc3RydWN0IHNrX2J1
ZmYgKnNrYiwgY29uc3Qgc3RydWN0IHRjX2FjdGlvbiAqYSwNCj4gPiA+PiA+ICsgICAgICAgICAg
ICAgICAgICAgICBzdHJ1Y3QgdGNmX3Jlc3VsdCAqcmVzKSB7DQo+ID4gPj4gPiArICAgICBzdHJ1
Y3QgdGNmX2dhdGUgKmcgPSB0b19nYXRlKGEpOw0KPiA+ID4+ID4gKyAgICAgc3RydWN0IGdhdGVf
YWN0aW9uICpnYWN0Ow0KPiA+ID4+ID4gKyAgICAgaW50IGFjdGlvbjsNCj4gPiA+PiA+ICsNCj4g
PiA+PiA+ICsgICAgIHRjZl9sYXN0dXNlX3VwZGF0ZSgmZy0+dGNmX3RtKTsNCj4gPiA+PiA+ICsg
ICAgIGJzdGF0c19jcHVfdXBkYXRlKHRoaXNfY3B1X3B0cihnLT5jb21tb24uY3B1X2JzdGF0cyks
IHNrYik7DQo+ID4gPj4gPiArDQo+ID4gPj4gPiArICAgICBhY3Rpb24gPSBSRUFEX09OQ0UoZy0+
dGNmX2FjdGlvbik7DQo+ID4gPj4gPiArICAgICByY3VfcmVhZF9sb2NrKCk7DQo+ID4gPj4NCj4g
PiA+PiBBY3Rpb24gZmFzdHBhdGggaXMgYWxyZWFkeSByY3UgcmVhZCBsb2NrIHByb3RlY3RlZCwg
eW91IGRvbid0IG5lZWQNCj4gPiA+PiB0byBtYW51YWxseSBvYnRhaW4gaXQuDQo+ID4gPg0KPiA+
ID4gV2lsbCBiZSByZW1vdmVkLg0KPiA+ID4NCj4gPiA+Pg0KPiA+ID4+ID4gKyAgICAgZ2FjdCA9
IHJjdV9kZXJlZmVyZW5jZV9iaChnLT5hY3RnKTsNCj4gPiA+PiA+ICsgICAgIGlmICh1bmxpa2Vs
eShnYWN0LT5jdXJyZW50X2dhdGVfc3RhdHVzICYgR0FURV9BQ1RfUEVORElORykpDQo+ID4gPj4g
PiArIHsNCj4gPiA+Pg0KPiA+ID4+IENhbid0IGN1cnJlbnRfZ2F0ZV9zdGF0dXMgYmUgY29uY3Vy
cmVudGx5IG1vZGlmaWVkIGJ5IHRpbWVyIGNhbGxiYWNrPw0KPiA+ID4+IFRoaXMgZnVuY3Rpb24g
ZG9lc24ndCB1c2UgZW50cnlfbG9jayB0byBzeW5jaHJvbml6ZSB3aXRoIHRpbWVyLg0KPiA+ID4N
Cj4gPiA+IFdpbGwgdHJ5IHRjZl9sb2NrIGVpdGhlci4NCj4gPiA+DQo+ID4gPj4NCj4gPiA+PiA+
ICsgICAgICAgICAgICAgcmN1X3JlYWRfdW5sb2NrKCk7DQo+ID4gPj4gPiArICAgICAgICAgICAg
IHJldHVybiBhY3Rpb247DQo+ID4gPj4gPiArICAgICB9DQo+ID4gPj4gPiArDQo+ID4gPj4gPiAr
ICAgICBpZiAoIShnYWN0LT5jdXJyZW50X2dhdGVfc3RhdHVzICYgR0FURV9BQ1RfR0FURV9PUEVO
KSkNCj4gPiA+Pg0KPiA+ID4+IC4uLmFuZCBoZXJlDQo+ID4gPj4NCj4gPiA+PiA+ICsgICAgICAg
ICAgICAgZ290byBkcm9wOw0KPiA+ID4+ID4gKw0KPiA+ID4+ID4gKyAgICAgaWYgKGdhY3QtPmN1
cnJlbnRfbWF4X29jdGV0cyA+PSAwKSB7DQo+ID4gPj4gPiArICAgICAgICAgICAgIGdhY3QtPmN1
cnJlbnRfZW50cnlfb2N0ZXRzICs9IHFkaXNjX3BrdF9sZW4oc2tiKTsNCj4gPiA+PiA+ICsgICAg
ICAgICAgICAgaWYgKGdhY3QtPmN1cnJlbnRfZW50cnlfb2N0ZXRzID4NCj4gPiA+PiA+ICsgZ2Fj
dC0+Y3VycmVudF9tYXhfb2N0ZXRzKSB7DQo+ID4gPj4NCj4gPiA+PiBoZXJlIGFsc28uDQo+ID4g
Pj4NCj4gPiA+PiA+ICsNCj4gPiA+PiA+ICsgcXN0YXRzX292ZXJsaW1pdF9pbmModGhpc19jcHVf
cHRyKGctPmNvbW1vbi5jcHVfcXN0YXRzKSk7DQo+ID4gPj4NCj4gPiA+PiBQbGVhc2UgdXNlIHRj
Zl9hY3Rpb25faW5jX292ZXJsaW1pdF9xc3RhdHMoKSBhbmQgb3RoZXIgd3JhcHBlcnMgZm9yDQo+
ID4gc3RhdHMuDQo+ID4gPj4gT3RoZXJ3aXNlIGl0IHdpbGwgY3Jhc2ggaWYgdXNlciBwYXNzZXMN
Cj4gPiBUQ0FfQUNUX0ZMQUdTX05PX1BFUkNQVV9TVEFUUw0KPiA+ID4+IGZsYWcuDQo+ID4gPg0K
PiA+ID4gVGhlIHRjZl9hY3Rpb25faW5jX292ZXJsaW1pdF9xc3RhdHMoKSBjYW4ndCBzaG93IGxp
bWl0IGNvdW50cyBpbiB0Yw0KPiA+ID4gc2hvdw0KPiA+IGNvbW1hbmQuIElzIHRoZXJlIGFueXRo
aW5nIG5lZWQgdG8gZG8/DQo+ID4NCj4gPiBXaGF0IGRvIHlvdSBtZWFuPyBJbnRlcm5hbGx5IHRj
Zl9hY3Rpb25faW5jX292ZXJsaW1pdF9xc3RhdHMoKSBqdXN0DQo+ID4gY2FsbHMgcXN0YXRzX292
ZXJsaW1pdF9pbmMsIGlmIGNwdV9xc3RhdHMgcGVyY3B1IGNvdW50ZXIgaXMgbm90IE5VTEw6DQo+
ID4NCj4gPg0KPiA+ICAgICAgICAgaWYgKGxpa2VseShhLT5jcHVfcXN0YXRzKSkgew0KPiA+ICAg
ICAgICAgICAgICAgICBxc3RhdHNfb3ZlcmxpbWl0X2luYyh0aGlzX2NwdV9wdHIoYS0+Y3B1X3Fz
dGF0cykpOw0KPiA+ICAgICAgICAgICAgICAgICByZXR1cm47DQo+ID4gICAgICAgICB9DQo+ID4N
Cj4gPiBJcyB0aGVyZSBhIHN1YnRsZSBidWcgc29tZXdoZXJlIGluIHRoaXMgZnVuY3Rpb24/DQo+
IA0KPiBTb3JyeSwgSSB1cGRhdGVkIHVzaW5nIHRoZSB0Y2ZfYWN0aW9uXyosIGFuZCB0aGUgY291
bnRpbmcgaXMgb2suIEkgbW92ZWQNCj4gYmFjayB0byB0aGUgcXN0YXRzX292ZXJsaW1pdF9pbmMo
KSBiZWNhdXNlIHRjZl9hY3Rpb25fKiAoKSBpbmNsdWRlIHRoZQ0KPiBzcGluX2xvY2soJmEtPnRj
ZmFfbG9jaykuDQo+IEkgd291bGQgdXBkYXRlIHRvICB0Y2ZfYWN0aW9uXyogKCkgaW5jcmVhdGUu
DQo+IA0KPiA+DQo+ID4gPg0KPiA+ID4gQnIsDQo+ID4gPiBQbyBMaXUNCj4gDQo+IFRoYW5rcyBh
IGxvdC4NCj4gDQo+IEJyLA0KPiBQbyBMaXUNCg0KVGhhbmtzIGEgbG90Lg0KDQpCciwNClBvIExp
dQ0KDQo=
