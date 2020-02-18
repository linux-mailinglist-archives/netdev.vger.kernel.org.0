Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECC0162828
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 15:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgBROaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 09:30:05 -0500
Received: from mail-eopbgr20044.outbound.protection.outlook.com ([40.107.2.44]:61186
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726422AbgBROaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 09:30:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KAWMW2e2ErTExdF9tKHS7/kuM56lbVdkLtbHfDyQH72x9uvQZFGtFctqyaDJzv8qhgL2rOdYZ0df44vjepl/7stHSdvSTSbMaVPAJ2R8OEJPNYls1IyEpHiBTOMGgJnGHpmmbNwx9NHqhe0sQd+8N31yy1cxyRS4t5+JV5QLdQ+6NFWEpqyyQE+u0KiyhBR/su/JnrBtOoZ94GYQXf4jt3aLSA2FjyXRhA7fJgsyptNlgA7iIwQUs+xVf9p50NhMvTZQVdL+HZ30w8uk2dF1SrG6ZdIBsdVrdyiM+rgBoOYqZEfxib3Zgd/1JARi2Qz21MFKvQHtDzMfxehek3hujQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HMoDe5kjRzHnVt7ffMoprC9wk9fpJr0+6i56bzM0P9U=;
 b=b7p52txXbPKMXF51jjSgtI6UAWwqMIlZUyL+Q5qYqh4DeaN0tfbR7qE0vyQadfujz9WAhpk/XRNyQWZ9vkqbj5Whui/i5lSh45DBVQf/td4/cXEV1iPi7aYEm7jjOpQoZ7cW82JD8gU3G4afugOEE+Omc23/Sq3oLfKa74Nt1QEa28twnOh7ul62RmleuBJjP2YW7w4bLVwVAfcjD+UljS5QNTCYYdelN7b9nzbcPo5q3W4NGRdtodVDnVP0412TGjJAQ+4z7O+FkSve924I+oqC+Z69n6zXDc4q8iPFoQbWyD09ItHtnKKBfYso4ASRrY2NSkZQ3DXj5xwX4o2MFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HMoDe5kjRzHnVt7ffMoprC9wk9fpJr0+6i56bzM0P9U=;
 b=UR7133RKMbM0ISUxy+prGUzCaTjc4xcfA3GRSWo6ztGsIItaw2haWkD0vWYGHuFOSM/xStjfp5DLOEOwDzivL73anoFphfbvphqsZAwbTi9DmAKZOjzl+Ob7FAN2X0kp2X3TkTRg7C3OE/T62u9TknVjVErZQaDHbpltuRw57jE=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB2831.eurprd04.prod.outlook.com (10.175.23.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Tue, 18 Feb 2020 14:30:01 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::18c:4d15:c3ab:afa6]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::18c:4d15:c3ab:afa6%7]) with mapi id 15.20.2729.032; Tue, 18 Feb 2020
 14:30:01 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: RE: [EXT] Re: [PATCH net-next] net: fec: Use a proper ID allocation
 scheme
Thread-Topic: [EXT] Re: [PATCH net-next] net: fec: Use a proper ID allocation
 scheme
Thread-Index: AQHV5h8UIR0p36NlJkiaMX6HnulgEKgggl2AgABu8wCAAAe5cIAAA4iAgAAEh5A=
Date:   Tue, 18 Feb 2020 14:30:01 +0000
Message-ID: <VI1PR0402MB360000C02868DB471237E08AFF110@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20200217223651.22688-1-festevam@gmail.com>
 <20200217.214840.486235315714211732.davem@davemloft.net>
 <VI1PR0402MB3600C163FEFD846B1D5869B4FF110@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CAOMZO5CWX9dhcg_v3LgPvK97yESAi_kS72e0=vjiB+-15C5J1g@mail.gmail.com>
 <VI1PR0402MB3600B90E7775C368E81B533DFF110@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CAOMZO5A_LvVOEQKqbrm5xKUR5vBLcgpB6e50_Vmf5BDFsRnaTw@mail.gmail.com>
In-Reply-To: <CAOMZO5A_LvVOEQKqbrm5xKUR5vBLcgpB6e50_Vmf5BDFsRnaTw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3587d2f4-82fa-4c18-4182-08d7b47f0a03
x-ms-traffictypediagnostic: VI1PR0402MB2831:
x-microsoft-antispam-prvs: <VI1PR0402MB2831FF55E2D7444C480A29B0FF110@VI1PR0402MB2831.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:489;
x-forefront-prvs: 031763BCAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(199004)(189003)(55016002)(6916009)(186003)(478600001)(26005)(86362001)(53546011)(6506007)(81166006)(5660300002)(8676002)(81156014)(4326008)(54906003)(316002)(71200400001)(33656002)(8936002)(52536014)(2906002)(9686003)(66946007)(66476007)(7696005)(66446008)(64756008)(66556008)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2831;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: conPBTlHR6nB3DzDaeJ5pao5RDeUiwnhktVQE5G7x0sGiCV+J4RKBCI0/TcxPZbo4hB+ioT6EizAPct5YAUxHLSqFeseHkgpL/4vWgC+JpEcMvTYS0IQfBLAZhn03f5eWjTQ50f1eIM0hhiFTX8Co2ceYjMRrqE2QVjJNDaxpB0z3kHTg2yT0tsj0hDzU4IdGbBaDcOiiwuXHCmaIagjsuhWHhX9ujnyifLVR1HXA+GaDjDF+//oTl0Bnq3c8LJcV3oIUMA08Zufqc/IVE3YRcOyN5zISfktA0DPD4KB5UO4tYYQbYyYh6ebrqLBdDX2MvohJxT0+OC9dcPDre2kYjk5oshnonrMX478pPIVCnhZCfJREfa4rnnoVFcSmIUHZEx/orUadYigsQpyrhRrwxcC7XkitAfrE3pXPlTIPilWbQVS9jiQOwB13QPK3uDk
x-ms-exchange-antispam-messagedata: PMxm1p07NRVks82tYphJt8HbMWr1qmIQB6VkudkdGaw/s6F7DeaBRHGGcBh/2+UQ5kh1x1dvqTaf5BfdsloMCrAPNo6XG1nM5xjs0HtJe2DmoN6Mka2rC1tAKbkJF3FiHTcM68iefBzvpKPN9OF8ew==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3587d2f4-82fa-4c18-4182-08d7b47f0a03
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2020 14:30:01.2519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0xg49JGz6k5ze5Nexno9eRvOmvBev4qav+HdSG5mZuHuHYLiqZFsO4bmkpgIInRADwCtnsCjBlrmgAfv/5lcfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2831
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRmFiaW8gRXN0ZXZhbSA8ZmVzdGV2YW1AZ21haWwuY29tPiBTZW50OiBUdWVzZGF5LCBG
ZWJydWFyeSAxOCwgMjAyMCAxMDowNSBQTQ0KPiBIaSBBbmR5LA0KPiANCj4gT24gVHVlLCBGZWIg
MTgsIDIwMjAgYXQgMTA6NTQgQU0gQW5keSBEdWFuIDxmdWdhbmcuZHVhbkBueHAuY29tPg0KPiB3
cm90ZToNCj4gDQo+ID4gRm9yIGlteDZzbC9pbXg4bXAvaW14OG1tL2lteDhtbiwgc29jIG9ubHkg
aGFzIG9uZSBpbnN0YW5jZSwgYmluZA0KPiA+IG9wZXJhdGlvbiBpcyBzdXBwb3J0ZWQgYW5kIGhh
cyBubyBwcm9ibGVtLg0KPiANCj4gVGhpcyBpcyBub3QgdHJ1ZS4NCj4gDQo+IEFzIHBlciB0aGUg
Y29tbWl0IGxvZywgaGVyZSBpcyB0aGUgcmVzdWx0IG9mIHVuYmluZC9iaW5kIG9uIGEgaS5teDZx
cCwgd2hpY2gNCj4gb25seSBoYXMgYSBzaW5nbGUgRkVDIGluc3RhbmNlOg0KSSBtZWFuIGlmIGFw
cGx5IHRoZSBwYXRjaCwgaXQgc2hvdWxkIHdvcmsgZm9yIG9uZSBpbnN0YW5jZS4NCg0KPiANCj4g
IyBlY2hvIDIxODgwMDAuZXRoZXJuZXQgPiAvc3lzL2J1cy9wbGF0Zm9ybS9kcml2ZXJzL2ZlYy91
bmJpbmQNCj4gIyBlY2hvIDIxODgwMDAuZXRoZXJuZXQgPiAvc3lzL2J1cy9wbGF0Zm9ybS9kcml2
ZXJzL2ZlYy9iaW5kDQo+IFsgICAxMC43NTY1MTldIHBwcyBwcHMwOiBuZXcgUFBTIHNvdXJjZSBw
dHAwDQo+IFsgICAxMC43OTI2MjZdIGxpYnBoeTogZmVjX2VuZXRfbWlpX2J1czogcHJvYmVkDQo+
IFsgICAxMC43OTkzMzBdIGZlYyAyMTg4MDAwLmV0aGVybmV0IGV0aDA6IHJlZ2lzdGVyZWQgUEhD
IGRldmljZSAxDQo+ICMgdWRoY3BjIC1pIGV0aDANCj4gdWRoY3BjOiBzdGFydGVkLCB2MS4zMS4x
DQo+IFsgICAxNC45ODUyMTFdIGZlYyAyMTg4MDAwLmV0aGVybmV0IGV0aDA6IG5vIFBIWSwgYXNz
dW1pbmcgZGlyZWN0DQo+IGNvbm5lY3Rpb24gdG8gc3dpdGNoDQo+IFsgICAxNC45OTMxNDBdIGxp
YnBoeTogUEhZIGZpeGVkLTA6MDAgbm90IGZvdW5kDQo+IFsgICAxNC45OTc2NDNdIGZlYyAyMTg4
MDAwLmV0aGVybmV0IGV0aDA6IGNvdWxkIG5vdCBhdHRhY2ggdG8gUEhZDQo+IA0KPiBBZnRlciBw
ZXJmb3JtaW5nIHVuYmluZC9iaW5kIG9wZXJhdGlvbiB0aGUgbmV0d29yayBpcyBub3QgZnVuY3Rp
b25hbCBhdCBhbGwuDQo+IA0KPiBEb24ndCB5b3UgYWdyZWUgdGhhdCB1bmJpbmQvYmluZCBpcyBj
dXJyZW50bHkgYnJva2VuIGhlcmUgZXZlbiBmb3IgU29DcyB3aXRoDQo+IGEgc2luZ2xlIEZFQz8N
Cj4gDQo+IFNob3VsZCB3ZSBwcmV2ZW50IHVuYmluZD8gT3IgYW55IG90aGVyIHN1Z2dlc3Rpb24/
DQpTdXBwb3NlIGFwcGx5IHRoZSBwYXRjaCwgaXQgY2FuIHdvcmsgZm9yIG9uZSBpbnN0YW5jZSwg
YnV0IG5vdCBmb3IgdHdvIGluc3RhbmNlcy4NCkN1cnJlbnRseSwgSSBhZ3JlZSB0byBwcmV2ZW50
IHVuYmluZCBvcGVyYXRpb24uDQo=
