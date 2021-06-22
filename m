Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9783B0179
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 12:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhFVKhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 06:37:33 -0400
Received: from mail-eopbgr140084.outbound.protection.outlook.com ([40.107.14.84]:15943
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229900AbhFVKhc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 06:37:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AtMap+W0Ecy7VEiha03Vj2IEAR99+tORJ4jUhwZPicoTH0dsShwk3/z74nNzeKKgvXhYf50pXeddzuaCKd0n/fAzA0ZwQq5B9K7fgUW6SCDvrIgMMac5LqWqBhCgJYNtcUE9tWDU86YNTYu1VhsIAWh6b1i/Fk855nAHBN7GCdxXy42kr9Ox84HLNm4igG3G26mRD+Y2tjSYZkUJApsyG+foNqOYIC0fmXR+RTIGEzktz+qb0aXX4InYFIrPw+GwlzPmJp6wrSxCQd7JJV7jzPA41GpLM0l4khHr0fvabsv0IupayXM2ZISjMrO4kkxJOopip8t2NzSuJ+/TUyKmqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RuCS4HD7tG2Zkfa43n8Bz0LgaCzZrypBe0oiR+M88dQ=;
 b=GWk7MLgYmLFVwXn/k8XdSX1f0m5icpZRuLFucm933GhoF+EOoyowKNmEC1WfcTFBDNmZgU+0sUklQDQxIGPF+RmymEEG3/1VwffZidmSp9yxDMFW+bwEmIx0QVnvrjMXmUDI9Zwnz4E/O5hSNldG5/R1VHwHJyyeInkS5ygATTvJ1pD0R3lcNnc8+U1Q3SfrunOikB2e+Jh3Mo53WFR0XTJjPBLpm8Uy/l3icK1yEiLDpNJtq9jo+ho+czQ/4nOeDqm0hy91qOEPFXlK8zkgIe+mBpSHaB21WJzVtVgmufiRZc2YOryKIcyUpzXgz0y5qJ2a/yXB54r/JK7DC0VbRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RuCS4HD7tG2Zkfa43n8Bz0LgaCzZrypBe0oiR+M88dQ=;
 b=MuDNxu4bhwIHSs9N/NQZ5e7rIUPw6WKWlNK2JlGtXg1bM4uqLlB6SzBIt9eZNkaYhnqsq6YHdcuqYk9idJHJFlPOIPzkLqWBl+GyDnDgsMLaMdSpOqhE2ayleD96wJEguUeZ0TCEYHh9cns7JyAVMpWOxi6UvNkRTx3ShRZUlrM=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DB3PR0402MB3788.eurprd04.prod.outlook.com (2603:10a6:8:10::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Tue, 22 Jun
 2021 10:35:13 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd%7]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 10:35:13 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mptcp@lists.linux.dev" <mptcp@lists.linux.dev>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: RE: [net-next, v3, 02/10] ptp: support ptp physical/virtual clocks
 conversion
Thread-Topic: [net-next, v3, 02/10] ptp: support ptp physical/virtual clocks
 conversion
Thread-Index: AQHXYcnwaUvaYN3/1UWKJ0RWryDTcKsYiVqAgAdTHVA=
Date:   Tue, 22 Jun 2021 10:35:13 +0000
Message-ID: <DB7PR04MB5017355B61A31D61340A52A3F8099@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210615094517.48752-1-yangbo.lu@nxp.com>
 <20210615094517.48752-3-yangbo.lu@nxp.com> <20210617182745.GC4770@localhost>
In-Reply-To: <20210617182745.GC4770@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88d63a3b-c4b2-4183-ea99-08d935696b49
x-ms-traffictypediagnostic: DB3PR0402MB3788:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB3PR0402MB3788578198FAF9FDE73D7647F8099@DB3PR0402MB3788.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pGeNd4FaDgEStBYMw3Q9hTGppGAT9zz7evnv1bEsVUIwpJs3OYaexBKaD05iJeJtFHUKim1CJw4dFwl/UBajRbGASPCbuLg1qKfqnIJJae+4id3uHNP7a8uSvTxeTb9mUIQdD3TlLZ2TjlPm7FX23Nlh1b3C32EoowiuubL1UNPI78+xcZuL2Oyrn0A/29WrVeA1HA50PqpKb2FLdpwFW+bSeV2DHdI5cIfk2kcIkkRSYDWrZSMnmSYqaRRrlvNyUl/7X0A4DUWl1OoxuqWQzRq1+3ApC5wdclEygs/4Q9PHkEwrv8wYA7J/LDFO05qfAxZGVrZG1m/836gE1PSTLhLgdqkhSrjHd+K/vc7BtfjMCiOz1z5h5UqGnTPCNMNM/lyBD9Qm9S4hf6cCfmSVUNXJZemi27OzUn9XClXNCN6TvfC9eYco3dXoPcKCXSnZgBSPJj0vSwvXMOY4Ye+QIUhY/upTSC1xfPpCMr0MMk0iqPl/9DHxIqNK6t+790KxabXRptloz05VUHHUKXzgoHnZ2afqmyse3uDxaJHf/JckNYsJcDEgokozFOKTkzJ/nOXcA6jxwZayPVRI7dmicrFiMrIfR5OqgdvY67l5yQQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(26005)(71200400001)(316002)(33656002)(6916009)(8676002)(8936002)(54906003)(478600001)(83380400001)(2906002)(186003)(122000001)(5660300002)(86362001)(4326008)(66476007)(66446008)(38100700002)(7696005)(52536014)(55016002)(53546011)(76116006)(66946007)(7416002)(6506007)(9686003)(66556008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?OGlrQ05xejRhZUI2NktpRXZZWmE0Y3BIYTNORUtYVHYrbUNEQnJrMndZLzdT?=
 =?gb2312?B?TytDbVF0VCt1cW1BZGJSSkRLeFFGTFA0OVVnVnRVNFlTWWlqbTB2eDgxY3ZS?=
 =?gb2312?B?bmR5RXdqR3Y1WUhJWDdoT1l1QVRlWEdTZzRFWmRGQ2RkWi9INU9xY0VXL2hR?=
 =?gb2312?B?b0Z4dUVnai95alp1RTRFSlFrbjFhaXZVUWZxK051dW81aXFPTkVCeEgxeWZF?=
 =?gb2312?B?Y0ZvYnNDenE2MUF3bkhwalhUQkpiekl4WWUxSVpLQnVoZHZ1OTdWZkdJS0pX?=
 =?gb2312?B?WGFwSWY3YVViMHBwelV3b25US0xyRDRFVzYrNG1CTG5xM1RVRDZRbHozWWd2?=
 =?gb2312?B?dmsxM1Q4U3FSaWRucjFzUlEvMXZqem5FdUNTdDdsWHlMZFNRTW0xeDErMTBz?=
 =?gb2312?B?Vmh1U2RUV3J2WXVHajdMbGVobXgwcEkwZkpvMjkzRkxiNjBzd2dibkx6ZWlh?=
 =?gb2312?B?aExJUG9UZnlFWFlkSkNKKzVXNFd3MEVtVVhIbk5Va1BGVEUza3BuZGlpd09k?=
 =?gb2312?B?aGFoMjRrc2hGOHo2NjE5dFU3S2NNYVZGb3g3a2FvNmxvVEFxSUhUb0JiazFL?=
 =?gb2312?B?allZMWViRUYxeXRtUVF0VHZjV052TlNuSWFlM3VZYWdnc1RLb2RVYVZJbDU2?=
 =?gb2312?B?ZEtrRVlzZWhPc0s4WDArTlI3NFcyQ1NCWXBmcW1VQmgvM3M1dldPUzk5MHlB?=
 =?gb2312?B?bjJwVFlYRmNwSGplTG9vb1pNdWxHVDJ2Snh6NldmTlJmUzB6TVFadFE2R3lu?=
 =?gb2312?B?RWF2d1IrNExMMFRLbEVrbGo2TG0yS1U4YmdZVllSay9Fc3hQSE9uRm9rMjRW?=
 =?gb2312?B?c1YzNFdTN2lUN1lKMVBKR2w1Yzh4dC8rNHEzbTdRMHBJRG96ZXh4UmsrM0RW?=
 =?gb2312?B?cjA4Z2xlV3kzZ0s5UTVzZjRERStGblU3QUdXaFQyVFE5anU3Y2l5ZXNRckt2?=
 =?gb2312?B?dHFZR20vT2FoZFhwb0RpUEUyQWJZOXlpdDB2Ukkwb005UmNQUXNWV05mZ1dS?=
 =?gb2312?B?QjFiSlFaMzRvdHVpVzJvblpSc1pOWnlNYlQvQUtmSWpDT3VDV3RyZktmd1BD?=
 =?gb2312?B?OXpSbE5Uc2plK1pGQkNKcEFDK00yTWpqY1VZSXRMdEgrMHF6bm9QVUN3ZmY1?=
 =?gb2312?B?NjZHSDhOY0lJanJhSWpFV3dFT0ZuSjZ1aFcyR3lqNjVmSS9iSWpBU1N5dENu?=
 =?gb2312?B?U3pMYVF1d0VHaHlMMnVJeVZoR1R1dXNLaTI4d3BHeC9TTVhmVmUwdFVUUC9i?=
 =?gb2312?B?Qy85QWZWUlVHdmNGOG45MXJRb0dMSk5lakxSWVo2UEkrcE9DcnFDUFhhdG91?=
 =?gb2312?B?K3FESFVBdFgwaS9ES1BtYk9MMFZZTzB3WitHR1daeU5DR3JzSnl0NUVwQ0I2?=
 =?gb2312?B?MzArQ09LWkR0NnQrZ0ZsNitFdjFzU21DQ0NrYUFzTkgyRVU0K0F4K2NCTG43?=
 =?gb2312?B?eUdOWitzbGdVTW9oUkh2TTh5RjJHdHNaZTBMWEdNd3VNdXhvcnNnTzNhbGZv?=
 =?gb2312?B?K1NjMTdKYlNYSFIrV3lZQVVwelJsYTcycWlNM3hVMEZSVlQ0VWREQU43YVlK?=
 =?gb2312?B?S29WTldFbldaQ09ibytkREZVQnBkT3J0TGExNEdmVHExRyt0WmVuc2Uwc1Bt?=
 =?gb2312?B?Kzl4d0hZK0FWVlNiemF0aHcrT1F6bkdLUXJjRkd3NXdabldvNmx2VnVPSkk3?=
 =?gb2312?B?eHZuWHZ2c2FTRVhzQWE4Q2lCSU5CM3VCdEt4alZReXFnTEh5Z0E4ajk5dEdI?=
 =?gb2312?Q?zn0fgZmrYpuaHn04vMxltiWRH7kW2vX1RuEEVZQ?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88d63a3b-c4b2-4183-ea99-08d935696b49
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2021 10:35:13.6650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MxrkceGynL5t5fXjOtNVhsI7AyNgjEVqDxZn9hXbyY4yfmXjCnwad57P4IdkzjCthsXTZDAwtX6G7AoWKlELlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3788
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUmljaGFyZCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNo
YXJkIENvY2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqNtTC
MTjI1SAyOjI4DQo+IFRvOiBZLmIuIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gQ2M6IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4
LWtzZWxmdGVzdEB2Z2VyLmtlcm5lbC5vcmc7IG1wdGNwQGxpc3RzLmxpbnV4LmRldjsgRGF2aWQg
UyAuIE1pbGxlcg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViIEtpY2luc2tpIDxrdWJh
QGtlcm5lbC5vcmc+OyBNYXQgTWFydGluZWF1DQo+IDxtYXRoZXcuai5tYXJ0aW5lYXVAbGludXgu
aW50ZWwuY29tPjsgTWF0dGhpZXUgQmFlcnRzDQo+IDxtYXR0aGlldS5iYWVydHNAdGVzc2FyZXMu
bmV0PjsgU2h1YWggS2hhbiA8c2h1YWhAa2VybmVsLm9yZz47IE1pY2hhbA0KPiBLdWJlY2VrIDxt
a3ViZWNla0BzdXNlLmN6PjsgRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+
Ow0KPiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+OyBSdWkgU291c2EgPHJ1aS5zb3VzYUBu
eHAuY29tPjsgU2ViYXN0aWVuDQo+IExhdmV6ZSA8c2ViYXN0aWVuLmxhdmV6ZUBueHAuY29tPg0K
PiBTdWJqZWN0OiBSZTogW25ldC1uZXh0LCB2MywgMDIvMTBdIHB0cDogc3VwcG9ydCBwdHAgcGh5
c2ljYWwvdmlydHVhbCBjbG9ja3MNCj4gY29udmVyc2lvbg0KPiANCj4gT24gVHVlLCBKdW4gMTUs
IDIwMjEgYXQgMDU6NDU6MDlQTSArMDgwMCwgWWFuZ2JvIEx1IHdyb3RlOg0KPiANCj4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9wdHAvcHRwX3ByaXZhdGUuaCBiL2RyaXZlcnMvcHRwL3B0cF9wcml2
YXRlLmgNCj4gPiBpbmRleCAzZjM4OGQ2MzkwNGMuLjY5NDlhZmM5ZDczMyAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL3B0cC9wdHBfcHJpdmF0ZS5oDQo+ID4gKysrIGIvZHJpdmVycy9wdHAvcHRw
X3ByaXZhdGUuaA0KPiA+IEBAIC00Niw2ICs0Niw5IEBAIHN0cnVjdCBwdHBfY2xvY2sgew0KPiA+
ICAJY29uc3Qgc3RydWN0IGF0dHJpYnV0ZV9ncm91cCAqcGluX2F0dHJfZ3JvdXBzWzJdOw0KPiA+
ICAJc3RydWN0IGt0aHJlYWRfd29ya2VyICprd29ya2VyOw0KPiA+ICAJc3RydWN0IGt0aHJlYWRf
ZGVsYXllZF93b3JrIGF1eF93b3JrOw0KPiA+ICsJdTggbl92Y2xvY2tzOw0KPiANCj4gSG0sIHR5
cGUgaXMgdTgsIGJ1dCAuLi4NCj4gDQo+ID4gKwlzdHJ1Y3QgbXV0ZXggbl92Y2xvY2tzX211eDsg
LyogcHJvdGVjdCBjb25jdXJyZW50IG5fdmNsb2NrcyBhY2Nlc3MgKi8NCj4gPiArCWJvb2wgdmNs
b2NrX2ZsYWc7DQo+ID4gIH07DQo+ID4NCj4gDQo+ID4gICNkZWZpbmUgaW5mb190b192Y2xvY2so
ZCkgY29udGFpbmVyX29mKChkKSwgc3RydWN0IHB0cF92Y2xvY2ssIGluZm8pDQo+ID4gZGlmZiAt
LWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9wdHBfY2xvY2suaA0KPiA+IGIvaW5jbHVkZS91YXBp
L2xpbnV4L3B0cF9jbG9jay5oIGluZGV4IDFkMTA4ZDU5N2Y2Ni4uNGI5MzNkYzFiODFiDQo+ID4g
MTAwNjQ0DQo+ID4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L3B0cF9jbG9jay5oDQo+ID4gKysr
IGIvaW5jbHVkZS91YXBpL2xpbnV4L3B0cF9jbG9jay5oDQo+ID4gQEAgLTY5LDYgKzY5LDExIEBA
DQo+ID4gICAqLw0KPiA+ICAjZGVmaW5lIFBUUF9QRVJPVVRfVjFfVkFMSURfRkxBR1MJKDApDQo+
ID4NCj4gPiArLyoNCj4gPiArICogTWF4IG51bWJlciBvZiBQVFAgdmlydHVhbCBjbG9ja3MgcGVy
IFBUUCBwaHlzaWNhbCBjbG9jayAgKi8NCj4gPiArI2RlZmluZSBQVFBfTUFYX1ZDTE9DS1MJCQky
MA0KPiANCj4gT25seSAyMCBjbG9ja3MgYXJlIGFsbG93ZWQ/ICBXaHk/DQoNCkluaXRpYWxseSBJ
IHRoaW5rIHZjbG9jayBjYW4gYmUgdXNlZCBmb3IgcHRwIG11bHRpcGxlIGRvbWFpbnMgc3luY2hy
b25pemF0aW9uLiBTaW5jZSB0aGUgUFRQIGRvbWFpblZhbHVlIGlzIHU4LCB1OCB2Y2xvY2sgbnVt
YmVyIGlzIGxhcmdlIGVub3VnaC4NClRoaXMgaXMgbm90IGEgZ29vZCBpZGVhIHRvIGhhcmQtY29k
ZSBhIFBUUF9NQVhfVkNMT0NLUyB2YWx1ZS4gQnV0IGl0IGxvb2tzIGEgbGl0dGxlIGNyYXp5IHRv
IGNyZWF0ZSBudW1iZXJzIG9mIHZjbG9ja3MgdmlhIG9uZSBjb21tYW5kIChlY2hvIG4gPiAvc3lz
L2NsYXNzL3B0cC9wdHAwL25fdmNsb2NrcykuDQpNYXliZSBhIHR5cG8gY3JlYXRlcyBodW5kcmVk
cyBvZiB2Y2xvY2tzIHdlIGRvbqGvdCBuZWVkLiANCkRvIHlvdSB0aGluayB3ZSBzaG91bGQgYmUg
Y2FyZSBhYm91dCBzZXR0aW5nIGEgbGltaXRhdGlvbiBvZiB2Y2xvY2sgbnVtYmVyPyBBbnkgc3Vn
Z2VzdGlvbiBmb3IgaW1wbGVtZW50YXRpb24/DQpUaGFua3MuDQoNCj4gDQo+IFRoYW5rcywNCj4g
UmljaGFyZA0K
