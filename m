Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13AE31554F2
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 10:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgBGJnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 04:43:01 -0500
Received: from mail-am6eur05on2078.outbound.protection.outlook.com ([40.107.22.78]:6208
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726867AbgBGJnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Feb 2020 04:43:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mh5xoHdwaVNg9IY5xCJX7N6uOAhhCek1uvztt4kRFy/Ak1O6d/8Yc+7+yip2Sitp3DVZUtbEdEIw88TrQrEYaB5VV12m7HIFSZ0BjYEvF8Gp//QS7m/rUrwSXz+foJQGAEUiEZu9PWHRoFqJAaXSGaAs/dAd+J8ko/t7yaOw9rL0XBy9yepkYPUz5wvF6gIm4BOqJxr/Oqc/E39IKvVtwo422uBtNitOOnSOtTlRHruDa04Y0Y71fKTVIIktYUqppsvikZVuTTjLOnsFb85kWUJCAhMrb4MWJMbp/jAD7o5ZKtmd9LsKcVBj+2Dd+G5N0OTZbnVkOg7Cnw2HGFXI9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZnQ0m1RQQ++sDRuldcRhvJaWXYm3/J9u0HODncqmC8=;
 b=Y+7VqA2kYL4OsUtYBuPW1r17KVX47apPIhuTgkNKZNNtHjOtB79PRhHV0ja+MogOeglPg92ttP2HLmvSNdttAf2Ye3kFW5QkDUUQiN/rfxAaTKtPMWukfUKxAN4lfsBTZYq/xJASiZwTpP1dhgy8rs48M9OpOk0viD2rDc/QS0r5ltC8w9jdoUkLqL308HA6xhQ3R6mf7YNfBR+OcH8jHOyIrmB+9RZz9nNXYLDZ3z24+O54Om8XACjRvYj3/8Zg6Yp9jadIfmUcfLOc0R2wf9svypbGTl4Vt+tuFX0+294ohNBOS1b4OgJYEz2ywILX1BGy6heLX9mjRL582nhp/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZnQ0m1RQQ++sDRuldcRhvJaWXYm3/J9u0HODncqmC8=;
 b=Pa/tk1kro3uQLZEXDw0f2j8oJD5x5hKHXGtmaROsVi+PQfc8Ws4LMFExClNz1TBGHhIo+AtzrlNK4REXqlQlqeNUGpoEXvvSetxLrq+5EhgzRrpU7g7A2jY+Kv1IkWd+M/B3TbIDKBFazDqRvlBWziFdhAyt4m4Su0XD1xUDqrI=
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (20.178.202.86) by
 AM0PR04MB4610.eurprd04.prod.outlook.com (52.135.149.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.24; Fri, 7 Feb 2020 09:42:56 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1b4:31d2:1485:6e07]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1b4:31d2:1485:6e07%7]) with mapi id 15.20.2686.036; Fri, 7 Feb 2020
 09:42:56 +0000
From:   "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>
To:     Jeremy Linton <jeremy.linton@arm.com>,
        "linux.cj@gmail.com" <linux.cj@gmail.com>,
        Jon Nettleton <jon@solid-run.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "Rajesh V. Bikkina" <rajesh.bikkina@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
CC:     Marcin Wojtas <mw@semihalf.com>,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v1 1/7] mdio_bus: Introduce fwnode MDIO helpers
Thread-Topic: [EXT] Re: [PATCH v1 1/7] mdio_bus: Introduce fwnode MDIO helpers
Thread-Index: AQHV2EwP/pAQL9rldkeFtJ0S9YjbKagMrXsAgAKqQ/A=
Date:   Fri, 7 Feb 2020 09:42:56 +0000
Message-ID: <AM0PR04MB56366808BA5C841E4E7BC86E931C0@AM0PR04MB5636.eurprd04.prod.outlook.com>
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
 <20200131153440.20870-2-calvin.johnson@nxp.com>
 <371ff9b4-4de6-7a03-90f8-a1eae4d5402d@arm.com>
In-Reply-To: <371ff9b4-4de6-7a03-90f8-a1eae4d5402d@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8f690f09-10bc-4d46-991b-08d7abb21c83
x-ms-traffictypediagnostic: AM0PR04MB4610:|AM0PR04MB4610:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB46109C4CF3962E37BF9ED96DD21C0@AM0PR04MB4610.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0306EE2ED4
x-forefront-antispam-report: SFV:NSPM;SFS:(10001)(10009020)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(189003)(199004)(26005)(55016002)(6506007)(45080400002)(9686003)(186003)(52536014)(8676002)(478600001)(86362001)(966005)(81156014)(8936002)(81166006)(7696005)(66476007)(66556008)(4326008)(7416002)(316002)(54906003)(2906002)(5660300002)(66946007)(71200400001)(66446008)(110136005)(76116006)(64756008)(33656002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4610;H:AM0PR04MB5636.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TRKio4j1Ka2YuSwcpBl0yITLeZKFsxK9TBZZD7SBLDPGL+jEGiHEbHln+Zec6v17egmYs6ujOxb/lI6ewsjsvvKgnBaZJYR+ewo995/m/+PW5bL7fI+pXGUr0rFI0pNg9S5jlMjnbGe5eNb48e4/tAuoWHPEI31B1vUniPnEFh5ZBftYRD3Hy98gcigcGHQ9GcXDnTk5XWoOJja2U+5r6ks5JRoLigGT616rdJCCRF8tT/P4DTHFoKr6a5V2h/hv8mivdu65j0gG8tuxL057SKgO0g0uUOoUhzAHmUscZaygjU++w1RilqJosOwlz9R/3IfNJBZ14038xXx8khoDwZm2QA68+86TRD0DOMb4eL8DH7NpNrBfIoS8CSouGtkxsbdKRp3dW7cgVcLTDCJd6ZkVRW8tmj8+vdAD48V7KdYCcSUaM2hTM4kkyx1lRLG0V9KmnQHidJS8ZRZVwM/wnC4u2NyFfYcGGkrkqx5rL4nEQONrn7qDlAzFqKnZt8xeVLIfSTTrUcVEnD5aPGyZ/w1n6ai2xFu3KKnNyQKi9w4THQiJVoF/MaLdMH8BuVcyXp9OxeRTym6uPn+tSsdC4N9Dt3khEuY0MUS/7mqcL6+/L0mzT35Tpwpc1lypN/WywNrZt0A72v148tcRscwEhQIxPJMnlEL2+VIG7Kf8bItZvo4qNQcKwhqc3mkVp4fJ
x-ms-exchange-antispam-messagedata: ejDoq/4wmfzKM6nRVKo2PZef4bxbqo1kxK+O2wuCRsvSqd0J62nZJTSBxpfTWRJl3CSTl/uGuhPc3c6CF7ua86wDIQ+7C98vHxd6mjxOhNp4qCks+qiVQd1M+vVZw2JS3aagVVqboucMYMTjOlA3dg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f690f09-10bc-4d46-991b-08d7abb21c83
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2020 09:42:56.5750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 57KiMEI4DQ9YY1KFLEgNvrPbO9uqaA5mdqWEl9IUfyP67QYZ0HhRWwd3hvK2Kem/6hiRn4lXjaP4ieAADnAqcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4610
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmVyZW15LA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEplcmVt
eSBMaW50b24gPGplcmVteS5saW50b25AYXJtLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBGZWJy
dWFyeSA1LCAyMDIwIDc6NDggUE0NCg0KPHNuaXA+DQoNCj4gPiArc3RhdGljIGludCBmd25vZGVf
bWRpb19wYXJzZV9hZGRyKHN0cnVjdCBkZXZpY2UgKmRldiwNCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGNvbnN0IHN0cnVjdCBmd25vZGVfaGFuZGxlICpmd25vZGUpIHsNCj4g
PiArICAgICB1MzIgYWRkcjsNCj4gPiArICAgICBpbnQgcmV0Ow0KPiA+ICsNCj4gPiArICAgICBy
ZXQgPSBmd25vZGVfcHJvcGVydHlfcmVhZF91MzIoZndub2RlLCAicmVnIiwgJmFkZHIpOw0KPiA+
ICsgICAgIGlmIChyZXQgPCAwKSB7DQo+ID4gKyAgICAgICAgICAgICBkZXZfZXJyKGRldiwgIlBI
WSBub2RlIGhhcyBubyAncmVnJyBwcm9wZXJ0eVxuIik7DQo+ID4gKyAgICAgICAgICAgICByZXR1
cm4gcmV0Ow0KPiA+ICsgICAgIH0NCj4gPiArDQo+ID4gKyAgICAgLyogQSBQSFkgbXVzdCBoYXZl
IGEgcmVnIHByb3BlcnR5IGluIHRoZSByYW5nZSBbMC0zMV0gKi8NCj4gPiArICAgICBpZiAoYWRk
ciA8IDAgfHwgYWRkciA+PSBQSFlfTUFYX0FERFIpIHsNCj4gPiArICAgICAgICAgICAgIGRldl9l
cnIoZGV2LCAiUEhZIGFkZHJlc3MgJWkgaXMgaW52YWxpZFxuIiwgYWRkcik7DQo+ID4gKyAgICAg
ICAgICAgICByZXR1cm4gLUVJTlZBTDsNCj4gPiArICAgICB9DQo+ID4gKw0KPiA+ICsgICAgIHJl
dHVybiBhZGRyOw0KPiA+ICt9DQo+IA0KPiBBbG1vc3QgYXNzdXJlZGx5IHRoaXMgaXMgd3Jvbmcs
IHRoZSBfQURSIG1ldGhvZCBleGlzdHMgdG8gaWRlbnRpZnkgYSBkZXZpY2UNCj4gb24gaXRzIHBh
cmVudCBidXMuIFRoZSBEVCByZWcgcHJvcGVydHkgc2hvdWxkbid0IGJlIHVzZWQgbGlrZSB0aGlz
IGluIGFuIEFDUEkNCj4gZW52aXJvbWVudC4NCj4gDQo+IEZ1cnRoZXIsIHRoZXJlIGFyZSBhIG51
bWJlciBvZiBvdGhlciBkdCBiaW5kaW5ncyBpbiB0aGlzIHNldCB0aGF0IHNlZW0NCj4gaW5hcHBy
b3ByaWF0ZSBpbiBjb21tb24vc2hhcmVkIEFDUEkgY29kZSBwYXRocy4gVGhhdCBpcyBiZWNhdXNl
IEFGQUlLIHRoZQ0KPiBfRFNEIG1ldGhvZHMgYXJlIHRoZXJlIHRvIHByb3ZpZGUgZGV2aWNlIGlt
cGxlbWVudGF0aW9uIHNwZWNpZmljDQo+IGJlaGF2aW9ycywgbm90IGFzIHN0YW5kYXJkaXplZCBt
ZXRob2RzIGZvciBhIGdlbmVyaWMgY2xhc3NlcyBvZiBkZXZpY2VzLg0KPiBJdHMgdmFndWx5IHRo
ZSBlcXVpdmxhbnQgb2YgdGhlICJ2ZW5kb3IseHh4eCIgcHJvcGVydGllcyBpbiBEVC4NCj4gDQo+
IFRoaXMgaGFzIGJlZW4gYSBkaXNjdXNzaW9uIHBvaW50IG9uL29mZiBmb3IgYSB3aGlsZSB3aXRo
IGFueSBhdHRlbXB0IHRvDQo+IHB1YmxpY2x5IHNwZWNpZnkvc3RhbmRhcmRpemUgZm9yIGFsbCBP
UyB2ZW5kb3JzIHdoYXQgdGhleSBtaWdodCBmaW5kIGVuY29kZWQNCj4gaW4gYSBEU0QgcHJvcGVy
dHkuIFRoZSBmZXcgeWVhciBvbGQgIldPUktfSU5fUFJPR1JFU1MiIGxpbmsgb24gdGhlIHVlZmkN
Cj4gcGFnZSBoYXMgYSBmZXcgc3VnZ2VzdGVkIG9uZXMNCj4gDQo+IGh0dHBzOi8vZXVyMDEuc2Fm
ZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRnVlZmkuDQo+
IG9yZyUyRnNpdGVzJTJGZGVmYXVsdCUyRmZpbGVzJTJGcmVzb3VyY2VzJTJGbmljLXJlcXVlc3Qt
DQo+IHYyLnBkZiZhbXA7ZGF0YT0wMiU3QzAxJTdDY2FsdmluLmpvaG5zb24lNDBueHAuY29tJTdD
ZjE2MzUwYjgzMTQNCj4gYjQ5OTIwNjMwMDhkN2FiNGY2NDg2JTdDNjg2ZWExZDNiYzJiNGM2ZmE5
MmNkOTljNWMzMDE2MzUlN0MwJTdDMQ0KPiAlN0M2MzcxNjYyMjk3OTUzNzQ0ODYmYW1wO3NkYXRh
PXpjWHUlMkZ1JTJGeHc1JTJGZjdlSmQlMkZsZWRSJQ0KPiAyRmduYWJ2RmNDVXRPZndUWHRNb0RC
SSUzRCZhbXA7cmVzZXJ2ZWQ9MA0KPiANCj4gQW55d2F5LCB0aGUgdXNlIG9mIHBoeS1oYW5kbGUg
d2l0aCBhIHJlZmVyZW5jZSB0byB0aGUgcGh5IGRldmljZSBvbiBhDQo+IHNoYXJlZCBNRElPIGlz
IGEgdGVjaGljYWxseSB3b3JrYWJsZSBzb2x1dGlvbiB0byB0aGUgcHJvYmxlbSBicm91Z2h0IHVw
IGluDQo+IHRoZSBSUEkvQUNQSSB0aHJlYWQgYXMgd2VsbC4gT1RPSCwgaXQgc3VmZmVycyBmcm9t
IHRoZSB1c2Ugb2YgRFNEIGFuZCBhdCBhDQo+IG1pbmltdW0gc2hvdWxkIHByb2JhYmx5IGJlIGFk
ZGVkIHRvIHRoZSBkb2N1bWVudCBsaW5rZWQgYWJvdmUgaWYgaXRzDQo+IGZvdW5kIHRvIGJlIHRo
ZSBiZXN0IHdheSB0byBoYW5kbGUgdGhpcy4gQWx0aG91Z2gsIGluIHRoZSBjb21tb24gY2FzZSBv
ZiBhDQo+IG1kaW8gYnVzLCBtYXRjaGluZyBhY3BpIGRlc2NyaWJlZCBkZXZpY2VzIHdpdGggdGhl
aXIgZGlzY292ZXJlZA0KPiBjb3VudGVycGFydHMgKG5vdGUgdGhlIGRldmljZSgpIGRlZmludGlv
biBpbiB0aGUgc3BlYw0KPiAxOS42LjMwKSBvbmx5IHRvIGRlZmluZSBEU0QgcmVmcmVuY2VzIGlz
IGEgYml0IG92ZXJraWxsLg0KPiANCj4gUHV0IGFub3RoZXIgd2F5LCB3aGlsZSBzZWVtaW5nbHkg
bm90IG5lc3NpYXJ5IGlmIGEgYnVzIGNhbiBiZSBwcm9iZWQsIGENCj4gbmljL2RldmljZS0+bWRp
by0+cGh5IGNhbiBiZSBkZXNjcmliZWQgaW4gdGhlIG5vcm1hbCBBQ1BJIGhlaXJhcmNoeSB3aXRo
DQo+IG9ubHkgYXBwcm9wcmlhdGx5IG5lc3RlZCBDUlMgYW5kIEFEUiByZXNvdXJjZXMuIEl0cyB0
aGUgc2hhcmVkIG5hdHVyZSBvZiB0aGUNCj4gTURJTyBidXMgdGhhdCBjYXVzZXMgcHJvYmxlbXMu
DQoNClRoYW5rcyEgSSdsbCBkZWZpbml0ZWx5IGNvbnNpZGVyIHlvdXIgc3VnZ2VzdGlvbnMgYWxv
bmcgd2l0aCB0aGUgb3RoZXJzIHJlY2VpdmVkIGVhcmxpZXIuDQoNCldoaWxlIEkgZG8gbW9yZSBz
dHVkeSBvbiB0aGlzLCB0aG91Z2h0IG9mIGZvcndhcmRpbmcgRFNURCB0YWJsZXMgdXNlZCBieSB0
aGlzIHBhdGNoLXNldC4NCmh0dHBzOi8vc291cmNlLmNvZGVhdXJvcmEub3JnL2V4dGVybmFsL3Fv
cmlxL3FvcmlxLWNvbXBvbmVudHMvZWRrMi1wbGF0Zm9ybXMvdHJlZS9QbGF0Zm9ybS9OWFAvTFgy
MTYwYVJkYlBrZy9BY3BpVGFibGVzL0RzZHQvTWRpby5hc2w/aD1MWDIxNjBfVUVGSV9BQ1BJX0VB
UjENCmh0dHBzOi8vc291cmNlLmNvZGVhdXJvcmEub3JnL2V4dGVybmFsL3FvcmlxL3FvcmlxLWNv
bXBvbmVudHMvZWRrMi1wbGF0Zm9ybXMvdHJlZS9QbGF0Zm9ybS9OWFAvTFgyMTYwYVJkYlBrZy9B
Y3BpVGFibGVzL0RzZHQvTWMuYXNsP2g9TFgyMTYwX1VFRklfQUNQSV9FQVIxDQoNClJlZ2FyZHMN
CkNhbHZpbg0K
