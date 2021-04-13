Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898FD35D621
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 05:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242834AbhDMDqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 23:46:52 -0400
Received: from mail-db8eur05on2055.outbound.protection.outlook.com ([40.107.20.55]:44640
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238999AbhDMDqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 23:46:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dm4q3o34gyZNLuuiSRGxpZnHtnEZ5YAPBSNjLzHMkYnWquis8Iqdk/5hzJMo6XDTb2dU3b6x99Ar8Bo84NDf/jNJOvjcZXBm8I+Bcr5xF8ibWKxAcbFmuDrB2JMx23wes28OgSk42iXmSvzDPePfv0Ss/EvHxCJN4tzpy+PObp9XRmnS4PyAAvvX13sGh6pws3q7+BsZIg9ZEYQqdGl2sGp4I33cTKKCcBgEptXRySmGcUIXvg/oJqiNgNORzkf1KMzOx8CkGEtRRJIaCU50TpYFGDgzJMxBZA3jNErM3h5jTZe2XHMDhbZiBp4iUE8j9CFPVnZMuBRrbHU/FhhJWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iyi8R7B8l+muSkSoBjc8aaEdE4xSPgQWqnwObXNryIg=;
 b=SoOaeUIAoyZmewCPddm0K2I8Poj6LNt7jIjiWsiJWb+6ssIUbAGTnOIo4hqtH84hX5QX+qaonkAyFq4xlscxdFdppBW8lvJ+nShBO16qai3rxllRnM/xGLqZXjtueoMXjMDXLD7p5LOkC93LnF+AL/gSN4IQY/bnY2zqanpdfqa04W5FXfct4+TaDsPT4GrGG+ZfSnGx7++spo7USzAMSw3UWFoJynAtpRuNNoq9Kj5vhyEAabijBmookQ+Gp0umh353MbRtZFfA9d8uqe7792ZMnSOK2cRFfP+lvF5qlrtX88JVaOvvXiyuRpJky2SOap/q8ntYsMWuBOk6ZrDt4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iyi8R7B8l+muSkSoBjc8aaEdE4xSPgQWqnwObXNryIg=;
 b=W1Jx54Tr41BxLPMNxe8wCWZhliFvaNS5aGvELpARPGA5ewcvDLdzIqXNx1xnzcN30Zusczcbhj3OjmTr2hThniX7+zbdGJq/a4F18xo0Qc+vfONGaFlcBjPwmZgGBmaNydNq2VqcT57RFIsnm5L4v9hqsOblJ6WdWiN4Gguf1zM=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM7PR04MB6791.eurprd04.prod.outlook.com (2603:10a6:20b:103::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Tue, 13 Apr
 2021 03:46:29 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::358e:fb22:2f7c:2777%3]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 03:46:29 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: RE: [net-next, v3, 2/2] enetc: support PTP Sync packet one-step
 timestamping
Thread-Topic: [net-next, v3, 2/2] enetc: support PTP Sync packet one-step
 timestamping
Thread-Index: AQHXL3nN/f1K5lXHPU6kK4hIsU1TSqqxz4wg
Date:   Tue, 13 Apr 2021 03:46:28 +0000
Message-ID: <AM7PR04MB688507FC7456976F7EBF1D3EF84F9@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20210412090327.22330-1-yangbo.lu@nxp.com>
 <20210412090327.22330-3-yangbo.lu@nxp.com>
In-Reply-To: <20210412090327.22330-3-yangbo.lu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 447e0bf5-0e4b-4125-1d87-08d8fe2eb893
x-ms-traffictypediagnostic: AM7PR04MB6791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB67913B2E26AF681D0AC1D473F84F9@AM7PR04MB6791.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LYQhpDYtzMe3vn/SoKaXFwYVfQrJH6wTNM0SBIt1yxj1oTaTyrPz5T7wv8JH9tqZ5mzVPp1gntY0N4T50z9h1IXdzmgZleDcNOk4DbXvpbk4fPGoZmq15ONRq3fmTFhwqTJpbpWGcLIi72OUpv7r3e/FtMZQLaPucIgPAX0vmVsX1zRKSnXPkayAzd8UCYYm09SO3Q8sJZdupDd9gp4X6oWSvbkP30OnqpDR03jGgrrf1drnAH93Ipi2J7APUh1QV1EHM3JeNRRCXJ38U1Kxc4F95oMdb7tqeVeGuS0UxUonbTTw62C3TCEkDS8wnN91pLO3CAd2wMPo9cZK9qn56YV+/L/6Vbd479zNI1EpM+F+rdWEdzMx1KaMIIPWfFPzbu6ADyySj7b1gSEG6SaTwE1+qxsaZJbi6pprNsZ/CESNIYDZVxd1ZQT9wbtCGx0vlV1SGxzWeUgF20T5OgbZJqN9UDwO0rKis+EXltswsvJGng35QSYpdoQPF+Ms6rI9Gz55IqGhZBBcY4jXeQPq8IS0D/BroGnXfJ8TC/fG9xi77RQT+Iy85XZumAIuGzwms20+wIrLBc2R9DEpuJhs9UQJ0AqMGmnIGAJtSZ8PQivMIF1Wp0+G1TcKwkxw3TsIRHRdEZ2UmN+Bt5Zn45yAV1NlVz9IyVRORv5XVzx/CGwuBEfpyvo3AEcnYSe2EUaR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(76116006)(2906002)(966005)(66946007)(86362001)(71200400001)(478600001)(55016002)(5660300002)(54906003)(6916009)(9686003)(6506007)(186003)(26005)(316002)(66476007)(38100700002)(4326008)(7696005)(8936002)(83380400001)(53546011)(33656002)(52536014)(66556008)(66446008)(8676002)(64756008)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?MTlBNjBjaVQ2bml4clZsS2h5VzBGalhlaS9IVnZXaUdvNkR4Y2czMThtYU1z?=
 =?gb2312?B?TElxMWRGZmMxL3FVbGhRdDRVTEN0N2pteWtqRDZYeXl0TnRrSUdnS3RXejZz?=
 =?gb2312?B?S1RDNzVjNmVDayttMnFKdFNQN2t3M0VBZzJLd2RwTTNRcHRDNWVXQ1pycW52?=
 =?gb2312?B?N3dCWjljNWJQbVJnWG9heXZCQWsxN0xkajZIODRwb2VXUTBRMTZsR2ZQSHJi?=
 =?gb2312?B?aCtKM2FneVlRUlZyQm1MVHlkL21IazhJYUpZUWNMdXZoRzU2UFEwYk05eW9i?=
 =?gb2312?B?a1RKak0wZmlNZzBBSFJBaUw4NFY5WWxaKzRSOUlTM0hGY2ZvbXFzRktJSnV4?=
 =?gb2312?B?dmNPLy9pMGdHRHZWUHBlYWJaTUQzd1hQY0FKd1llVDBKRVQrR3hHZFBoWXcv?=
 =?gb2312?B?THNLaGNtbUVydXlBMXBpOWZncUs5dnVFaVFWNlJCZnpDcUN2Z1VodDNIWWNE?=
 =?gb2312?B?TXhVQ2lHU0twN3hjbWVGbnF0d05LMXRiM0NsQm0zdDQ1ZWFDL3JzNFZkT1BO?=
 =?gb2312?B?YURxeXRhSnc1VUNMT04wdlZWUVFvRHJDQmdNOHllbzExakRPN3Z6ejQ4ZU0x?=
 =?gb2312?B?ZHdMdkZPSjJUcTVmS3Q5cVgvUmVxTnJIWFhKZVRsZXRJcEVpY0dud3EwZ2hG?=
 =?gb2312?B?alhEZDFTRzFUeTMzalc0S1pScExwd3huRWVveE1QZE0yalZ0clRmY1NoMG9n?=
 =?gb2312?B?Y3hKS3dzbHNlMVRoUUFpWGJpZHU1cGVaeUd2QWxSNVowanhrckpnTDdqYmRC?=
 =?gb2312?B?TXVtVVlmY3VnRGc5aXRpaDZVdTg2VVhCOUo3eXhoN1hrdkxUSjJHbFl2NnRl?=
 =?gb2312?B?STZyY0t6NWladWtZc21mdHpRTlk4ZmZkT21peklrM3VDb3I5ZW14RUp4NlMx?=
 =?gb2312?B?TjBSb2VtSnBYcFdtai94RHZXMEFpQXVwdEJ2WUdFenNLZHZTVS9LZGZTZVp3?=
 =?gb2312?B?L2I5VGp3VDFEV2ovM0pPZWYxWjVQR1ZmaTUyeXRBSTdDL2RDVWx4clpjaDlp?=
 =?gb2312?B?OTRQc3ZXQ3FYR2JYcmpTK29mMmZ5VlZCb3kwYncwL216QlhvYTFpSENOK2Er?=
 =?gb2312?B?RWd4V2RqNjhici9Pdm9SNmVodFI2MnMwK0hDL2NueVl0b0dYQVlYTTFXOUtK?=
 =?gb2312?B?T0FpL2pnUDEyNHdHRTBCQjBYOUMzdnRYdmdsWm1SMjNmYjhTak9BcUgzbStQ?=
 =?gb2312?B?Q2IxVDVNOGk4TVNENVJzZHVFdXliRGRoeUsvNDZqK3lUTkdBWXRlbFhOQTh0?=
 =?gb2312?B?c3ZGZHNvZzc1am5LSVptL3RQSmdaRGQzeCtabmJ3WWQyOU93K0xidnNwSTRC?=
 =?gb2312?B?Wm9MM1JHNVdCcFAxMVJ2UEkxcytQMnFwR3FEbHVPeWJ4MitSNDFpZ3lmNWxI?=
 =?gb2312?B?OTd3VUxoTkZBMUNlN3lORWo5K2l6ZGZtM1QwaUxaYk1RTEEwUW5WbUh6Z09i?=
 =?gb2312?B?Q21QcnprdHdMZ0lmQmpXK0xUcVliNkVkTGJJbnJqUFJYbHRkOWJMKzVzU3A3?=
 =?gb2312?B?YkxZQUhyNW1xQmRSV0VsaUd0cmZoOVh4aXMxN1NsTExHZUZxWjU2cVRUVDc3?=
 =?gb2312?B?ZXFlVnpBZmtKbUhQSVN6VUtRbmpFajNrU0hXckt2dlRvUXJRZ28vL2R4Sjha?=
 =?gb2312?B?RnpnMm1PSFJNTXJiUUJ4MUxOdnpieVU1UjdNS1BZWlBWRlVMb012VEl4SFhY?=
 =?gb2312?B?azhqMzRFbGN5WW02amtKMmFJbUJMSFpvcVNYbkZtb3d1TDdqcmY5V2VzR2ln?=
 =?gb2312?Q?FbicGIzf5n4ZI9wTEP9pRiidjF9qSWOt5XfNFQ0?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6885.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 447e0bf5-0e4b-4125-1d87-08d8fe2eb893
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 03:46:29.0031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +8heQavxti6U5eEnfI3sD4CF0ZoeIjnimCddEqG1TZ0HT2cN9pQWRDJkBJ7/3kEqk5R/FGnCcbB+njIaR8sjaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6791
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBZYW5nYm8gTHUgPHlhbmdiby5s
dUBueHAuY29tPg0KPiBTZW50OiAyMDIxxOo01MIxMsjVIDE3OjAzDQo+IFRvOiBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnDQo+IENjOiBZLmIuIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT47IERhdmlkIFMg
LiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+Ow0KPiBSaWNoYXJkIENvY2hyYW4gPHJpY2hh
cmRjb2NocmFuQGdtYWlsLmNvbT47IENsYXVkaXUgTWFub2lsDQo+IDxjbGF1ZGl1Lm1hbm9pbEBu
eHAuY29tPjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IFZsYWRpbWlyDQo+IE9s
dGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+OyBSdXNzZWxsIEtpbmcgPGxpbnV4QGFybWxp
bnV4Lm9yZy51az4NCj4gU3ViamVjdDogW25ldC1uZXh0LCB2MywgMi8yXSBlbmV0Yzogc3VwcG9y
dCBQVFAgU3luYyBwYWNrZXQgb25lLXN0ZXANCj4gdGltZXN0YW1waW5nDQo+IA0KPiBUaGlzIHBh
dGNoIGlzIHRvIGFkZCBzdXBwb3J0IGZvciBQVFAgU3luYyBwYWNrZXQgb25lLXN0ZXAgdGltZXN0
YW1waW5nLg0KPiBTaW5jZSBFTkVUQyBzaW5nbGUtc3RlcCByZWdpc3RlciBoYXMgdG8gYmUgY29u
ZmlndXJlZCBkeW5hbWljYWxseSBwZXIgcGFja2V0DQo+IGZvciBjb3JyZWN0aW9uRmllbGQgb2Zm
ZXNldCBhbmQgVURQIGNoZWNrc3VtIHVwZGF0ZSwgY3VycmVudCBvbmUtc3RlcA0KPiB0aW1lc3Rh
bXBpbmcgcGFja2V0IGhhcyB0byBiZSBzZW50IG9ubHkgd2hlbiB0aGUgbGFzdCBvbmUgY29tcGxl
dGVzDQo+IHRyYW5zbWl0dGluZyBvbiBoYXJkd2FyZS4gU28sIG9uIHRoZSBUWCwgdGhpcyBwYXRj
aCBoYW5kbGVzIG9uZS1zdGVwDQo+IHRpbWVzdGFtcGluZyBwYWNrZXQgYXMgYmVsb3c6DQo+IA0K
PiAtIFRyYXNtaXQgcGFja2V0IGltbWVkaWF0ZWx5IGlmIG5vIG90aGVyIG9uZSBpbiB0cmFuc2Zl
ciwgb3IgcXVldWUgdG8NCj4gICBza2IgcXVldWUgaWYgdGhlcmUgaXMgYWxyZWFkeSBvbmUgaW4g
dHJhbnNmZXIuDQo+ICAgVGhlIHRlc3RfYW5kX3NldF9iaXRfbG9jaygpIGlzIHVzZWQgaGVyZSB0
byBsb2NrIGFuZCBjaGVjayBzdGF0ZS4NCj4gLSBTdGFydCBhIHdvcmsgd2hlbiBjb21wbGV0ZSB0
cmFuc2ZlciBvbiBoYXJkd2FyZSwgdG8gcmVsZWFzZSB0aGUgYml0DQo+ICAgbG9jayBhbmQgdG8g
c2VuZCBvbmUgc2tiIGluIHNrYiBxdWV1ZSBpZiBoYXMuDQoNClNvcnJ5LCBJIG1hZGUgYSBtaXN0
YWtlIG9uIHRoZSBpbXBsZW1lbnRhdGlvbiBvZiB0aGUgbG9naWMuIEEgZml4LXVwIHdhcyBzZW50
Lg0KaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L25ldGRldmJwZi9wYXRjaC8y
MDIxMDQxMzAzNDgxNy44OTI0LTEteWFuZ2JvLmx1QG54cC5jb20vDQoNCj4gDQo+IEFuZCB0aGUg
Y29uZmlndXJhdGlvbiBmb3Igb25lLXN0ZXAgdGltZXN0YW1waW5nIG9uIEVORVRDIGJlZm9yZQ0K
PiB0cmFuc21pdHRpbmcgaXMsDQo+IA0KPiAtIFNldCBvbmUtc3RlcCB0aW1lc3RhbXBpbmcgZmxh
ZyBpbiBleHRlbnNpb24gQkQuDQo+IC0gV3JpdGUgMzAgYml0cyBjdXJyZW50IHRpbWVzdGFtcCBp
biB0c3RhbXAgZmllbGQgb2YgZXh0ZW5zaW9uIEJELg0KPiAtIFVwZGF0ZSBQVFAgU3luYyBwYWNr
ZXQgb3JpZ2luVGltZXN0YW1wIGZpZWxkIHdpdGggY3VycmVudCB0aW1lc3RhbXAuDQo+IC0gQ29u
ZmlndXJlIHNpbmdsZS1zdGVwIHJlZ2lzdGVyIGZvciBjb3JyZWN0aW9uRmllbGQgb2ZmZXNldCBh
bmQgVURQDQo+ICAgY2hlY2tzdW0gdXBkYXRlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogWWFuZ2Jv
IEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gLS0tDQo+IENoYW5nZXMgZm9yIHYyOg0KPiAJLSBS
ZWJhc2VkLg0KPiAJLSBGaXhlZCBpc3N1ZXMgZnJvbSBwYXRjaHdvcmsgY2hlY2tzLg0KPiAJLSBu
ZXRpZl90eF9sb2NrIGZvciBvbmUtc3RlcCB0aW1lc3RhbXBpbmcgcGFja2V0IHNlbmRpbmcuDQo+
IENoYW5nZXMgZm9yIHYzOg0KPiAJLSBVc2VkIHN5c3RlbSB3b3JrcXVldWUuDQo+IAktIFNldCBi
aXQgbG9jayB3aGVuIHRyYW5zbWl0dGVkIG9uZS1zdGVwIHBhY2tldCwgYW5kIHNjaGVkdWxlZA0K
PiAJICB3b3JrIHdoZW4gY29tcGxldGVkLiBUaGUgd29ya2VyIGNsZWFyZWQgdGhlIGJpdCBsb2Nr
LCBhbmQNCj4gCSAgdHJhbnNtaXR0ZWQgb25lIHNrYiBpbiBza2IgcXVldWUgaWYgaGFzLCBpbnN0
ZWFkIG9mIGEgbG9vcC4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUv
ZW5ldGMvZW5ldGMuYyAgfCAxOTEgKysrKysrKysrKysrKysrKy0tDQo+IGRyaXZlcnMvbmV0L2V0
aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Yy5oICB8ICAyMCArLQ0KPiAgLi4uL2V0aGVybmV0
L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Y19ldGh0b29sLmMgIHwgICAzICstDQo+ICAuLi4vbmV0L2V0
aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Y19ody5oICAgfCAgIDcgKw0KPiAgNCBmaWxlcyBj
aGFuZ2VkLCAxOTUgaW5zZXJ0aW9ucygrKSwgMjYgZGVsZXRpb25zKC0pDQpbLi4uXQ0KDQo=
