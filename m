Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6501023C384
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 04:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgHECc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 22:32:59 -0400
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:62273
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725864AbgHECc7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 22:32:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8fit8cQ3vRQ2neQaei2cOtT/z9yuiQmtjOeqNKm43m7+sXys85xDxFXWto71mjLpaZbXcmv1JxhtBJz3nWrvu+yvYFpOfR5MqLYmlnZ04j68LjjY6A5iyGspW1YaNeWxTLNi+TnSqW4spRchUpFCr4WQp03vBLjiehmc2z510IXGPGKUWbwrtx4cdF+QJ/5NUQpnb6PSUkf3P+xjlv8TLZz1mRxxwPdFLkSKQf3PIde3X5ePCqVUWWv+HmtE7a+moCXqdmBNvXiwVP3+i3hWZnCFY348rHq2FndiTP/CaMnTcRWbhe5htzwwo4lwxQUBpyucHlfUJ8VqMKdbJtYMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R+T6m1nCYaJz02jrGu3wwvzSLLRE2tbOImJW8ixg3g8=;
 b=GRMlCfLqqG9KS5T2qW8Z+OqRI5cf9VoedAwQyTzZGVfElyc9vEunR9ou8PpjSyvMqUbxb+cp8M235QTB4mVxvS0zP0rr9K909lh9E4cRd/WEqGwZamIWVRrzRG+Yf42/vGJzcmFHpnaRyIGBH5qYbcS3bccMqh/w9wmKtwaONak7BrBz3tAu6NHbKITvCLWKo7wVm0B/tJncUlvW3+enIU/i3mu+hKJlZJQgIEL/MXOcJ4U608ejWmOSPMsDB7JwsSFTrkvLvIlaE/vnpRz1VCnSgW9ejjQQZBv1Jken55aEWkEXjX/Wd3fPa0CyajHMDWrqx5cNySmdfyAb2rdzJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R+T6m1nCYaJz02jrGu3wwvzSLLRE2tbOImJW8ixg3g8=;
 b=eDzxX2YVJGPv6mTu+ofhBgPOxmQGJKAMvSZ7kBYzmCZL+EjeDofli71ISqsFiJ6nk0SZirpekYq6nYjNXc2Tg8bGBqwhPRoU0MIZdWzO6oU4rz+7q8gmn0Y+dTBMbmodMTC8731pCIRXzDonebBBVsiJNfDpjgRvZBR5omBWcxA=
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
 by VI1PR04MB7103.eurprd04.prod.outlook.com (2603:10a6:800:123::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Wed, 5 Aug
 2020 02:32:54 +0000
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::2c2c:20a4:38cd:73c3]) by VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::2c2c:20a4:38cd:73c3%7]) with mapi id 15.20.3261.016; Wed, 5 Aug 2020
 02:32:54 +0000
From:   Hongbo Wang <hongbo.wang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>
Subject: RE: [EXT] Re: [PATCH v4 2/2] net: dsa: ocelot: Add support for QinQ
 Operation
Thread-Topic: [EXT] Re: [PATCH v4 2/2] net: dsa: ocelot: Add support for QinQ
 Operation
Thread-Index: AQHWZltTjJoiQZyRB0ahxfHbav3IXakm9cqAgACG/8CAALHUgIAApDFw
Date:   Wed, 5 Aug 2020 02:32:54 +0000
Message-ID: <VI1PR04MB5103D05A76BE5A0F8D76F131E14B0@VI1PR04MB5103.eurprd04.prod.outlook.com>
References: <20200730102505.27039-1-hongbo.wang@nxp.com>
 <20200730102505.27039-3-hongbo.wang@nxp.com>
 <20200803.145843.2285407129021498421.davem@davemloft.net>
 <VI1PR04MB51039B32C580321D99B8DEE8E14A0@VI1PR04MB5103.eurprd04.prod.outlook.com>
 <2906dc1e-fe37-e9d8-984d-2630549f0462@gmail.com>
In-Reply-To: <2906dc1e-fe37-e9d8-984d-2630549f0462@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d38a82ac-e711-40e4-8f85-08d838e7dba9
x-ms-traffictypediagnostic: VI1PR04MB7103:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB7103C524E7FB47734468DBA2E14B0@VI1PR04MB7103.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pjUU1V8pUkt97XY/nY235+D95wjRy2njT0k7cbtIWo4wIhZtU/pYdb7y5Ew1y7O8NT+tlwv9i/rrhuh/RkDUJ3bwwnDOqglwgZnVj6WPMaYZ54ntCqsAKVkpuHID+s9WIlnH/0KAPCDrDjY0j8NHWftMnBYuv9HtM23DgdHNSk/4AXY1di1/TC7H6gYYut/eVULZXJfz1e5GkqK9ons/R41eLLpBI+YeS9wGfSSd5QHWPP6ra3Yf5+EjpbKt6Q9QAHqG0/X5KxjOWD14IrdAYbyczjGgTYxoI6VeNUGoiQYxOlf45hLNC1V00w5EqVYT9KXrDdsPVymoejvRiOMzBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5103.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(26005)(8676002)(52536014)(55016002)(9686003)(66556008)(66446008)(66476007)(33656002)(76116006)(8936002)(2906002)(186003)(66946007)(64756008)(4326008)(86362001)(110136005)(83380400001)(44832011)(316002)(478600001)(5660300002)(7696005)(7416002)(6506007)(54906003)(53546011)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: vJHUT9KRa9Qh4N+q0S8s1XpM7SIwMTWIVhdu/oCDJ98/X/nfrX0lrq91wr5NltUGKmToTlLI/KGKLKekWXtLXVzIlTIV8vAj+vC0Vl0w9mWtb3xnuL5YzoKrJUQpYjzIiEGeA3GptQP+9cz7YGrLm9cGXz5pBDp9ahnTVuNKzX/mMIByme52mLK3MoAwRTnxbtuL61d0l3bpnVFjdrRFShmFmKbjHTKieYCcy23cohXZQNRSrHYo363Q26TwUyUtgWGHdM50BF5VCtFloo4qobDnyWm53Z1rH8CASQyqCjvKiTdsR/yKfeVa39wzeE9WjmnkJsYg0QFqgiNV7F5qni/hx18lT4hqa+nPcOMkn5C7E+DXU0s+8w7iPNezGy6IF9bdzgu5mOyBj7EBmsPhu7bXuN4VoCOf3+mo93vwmhifNahBKu8FI8m4AHnMfXcbgEi+Fw+GvfkyWDU8zH6rqZxrUpLVNd42pORKP1Yg7Av93xXKg9AgyYg5G9iu/luiRFISnGABdkN5qcCb1I5HhuyM4MVQC5Fspum8DuqPpA71imq5LGu5qEnhb5v70llGdgvy647d0ylehQ6tgtck9J0MNbdIifU3OP9oIxjn56huYMzmHbPStGQJWYsH3ZzBTFun0XizoGKYmoxSLk6X7Q==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5103.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d38a82ac-e711-40e4-8f85-08d838e7dba9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2020 02:32:54.5129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XSzRdrIhZaXQX/q6bpeu7foYDyjXFgInt9aMC/eu0mD78rvkCta0y7vSp0M5qAoRemRhjLT/5pzZ6vbqt7zUUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7103
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBDYXV0aW9uOiBFWFQgRW1haWwNCj4gDQo+IE9uIDgvMy8yMDIwIDExOjM2IFBNLCBIb25nYm8g
V2FuZyB3cm90ZToNCj4gPj4+ICsgICAgIGlmICh2bGFuLT5wcm90byA9PSBFVEhfUF84MDIxQUQp
IHsNCj4gPj4+ICsgICAgICAgICAgICAgb2NlbG90LT5lbmFibGVfcWlucSA9IHRydWU7DQo+ID4+
PiArICAgICAgICAgICAgIG9jZWxvdF9wb3J0LT5xaW5xX21vZGUgPSB0cnVlOw0KPiA+Pj4gKyAg
ICAgfQ0KPiA+PiAgLi4uDQo+ID4+PiArICAgICBpZiAodmxhbi0+cHJvdG8gPT0gRVRIX1BfODAy
MUFEKSB7DQo+ID4+PiArICAgICAgICAgICAgIG9jZWxvdC0+ZW5hYmxlX3FpbnEgPSBmYWxzZTsN
Cj4gPj4+ICsgICAgICAgICAgICAgb2NlbG90X3BvcnQtPnFpbnFfbW9kZSA9IGZhbHNlOw0KPiA+
Pj4gKyAgICAgfQ0KPiA+Pj4gKw0KPiA+Pg0KPiA+PiBJIGRvbid0IHVuZGVyc3RhbmQgaG93IHRo
aXMgY2FuIHdvcmsganVzdCBieSB1c2luZyBhIGJvb2xlYW4gdG8gdHJhY2sNCj4gPj4gdGhlIHN0
YXRlLg0KPiA+Pg0KPiA+PiBUaGlzIHdvbid0IHdvcmsgcHJvcGVybHkgaWYgeW91IGFyZSBoYW5k
bGluZyBtdWx0aXBsZSBRaW5RIFZMQU4gZW50cmllcy4NCj4gPj4NCj4gPj4gQWxzbywgSSBuZWVk
IEFuZHJldyBhbmQgRmxvcmlhbiB0byByZXZpZXcgYW5kIEFDSyB0aGUgRFNBIGxheWVyDQo+ID4+
IGNoYW5nZXMgdGhhdCBhZGQgdGhlIHByb3RvY29sIHZhbHVlIHRvIHRoZSBkZXZpY2Ugbm90aWZp
ZXIgYmxvY2suDQo+ID4NCj4gPiBIaSBEYXZpZCwNCj4gPiBUaGFua3MgZm9yIHJlcGx5Lg0KPiA+
DQo+ID4gV2hlbiBzZXR0aW5nIGJyaWRnZSdzIFZMQU4gcHJvdG9jb2wgdG8gODAyLjFBRCBieSB0
aGUgY29tbWFuZCAiaXAgbGluaw0KPiA+IHNldCBicjAgdHlwZSBicmlkZ2Ugdmxhbl9wcm90b2Nv
bCA4MDIuMWFkIiwgaXQgd2lsbCBjYWxsDQo+ID4gZHNhX3NsYXZlX3ZsYW5fcnhfYWRkKGRldiwg
cHJvdG8sIHZpZCkgZm9yIGV2ZXJ5IHBvcnQgaW4gdGhlIGJyaWRnZSwNCj4gPiB0aGUgcGFyYW1l
dGVyIHZpZCBpcyBwb3J0J3MgcHZpZCAxLCBpZiBwdmlkJ3MgcHJvdG8gaXMgODAyLjFBRCwgSSB3
aWxsDQo+ID4gZW5hYmxlIHN3aXRjaCdzIGVuYWJsZV9xaW5xLCBhbmQgdGhlIHJlbGF0ZWQgcG9y
dCdzIHFpbnFfbW9kZSwNCj4gPg0KPiA+IFdoZW4gdGhlcmUgYXJlIG11bHRpcGxlIFFpblEgVkxB
TiBlbnRyaWVzLCBJZiBvbmUgVkxBTidzIHByb3RvIGlzIDgwMi4xQUQsDQo+IEkgd2lsbCBlbmFi
bGUgc3dpdGNoIGFuZCB0aGUgcmVsYXRlZCBwb3J0IGludG8gUWluUSBtb2RlLg0KPiANCj4gVGhl
IGVuYWJsaW5nIGFwcGVhcnMgZmluZSwgdGhlIHByb2JsZW0gaXMgdGhlIGRpc2FibGluZywgdGhl
IGZpcnN0IDgwMi4xQUQgVkxBTg0KPiBlbnRyeSB0aGF0IGdldHMgZGVsZXRlZCB3aWxsIGxlYWQg
dG8gdGhlIHBvcnQgYW5kIHN3aXRjaCBubyBsb25nZXIgYmVpbmcgaW4gUWluUQ0KPiBtb2RlLCBh
bmQgdGhpcyBkb2VzIG5vdCBsb29rIGludGVuZGVkLg0KPiAtLQ0KPiBGbG9yaWFuDQoNClRoYW5r
cywgRmxvcmlhbg0KDQpJIHdpbGwgYWRkIHJlZmVyZW5jZSBjb3VudGVyLg0KV2hlbiBkZWxldGlu
ZyBWTEFOIGVudHJ5LCBvbmx5IGlmIHRoZSBjb3VudGVyIGlzIHplcm8sIEkgd2lsbCBzZXQgdGhl
IHN3aXRjaCB0byBleGl0IFFpblEgbW9kZS4NCg0KaG9uZ2JvDQoNCg==
