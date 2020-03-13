Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 485F61840B5
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 07:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgCMGAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 02:00:14 -0400
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:55523
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725809AbgCMGAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 02:00:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReW25i3kwMNfEGPWmxy23Racga+P+SmG2bEGhPosRh3m1f1w5HyI4PLK1VFGtZHacKxdHWVOT8w96ZoR/mlaaD++/PEJN5SnQjYG5R1Pa/SeXjbcVx5k+F3vUJ3urgMoEx3cboA6bmti2ZPut+QLi6dYbxXeIWDjTvHgIT6ycHAHY6ugeooVuR/PPyukWpUszt3fZZjvEJgkDuQdgv4gfdvpEVvYDyqqulJvYDxW3fz7TaF1tObyl1U8pZjSX6+H9deCNaK5U5RngI7oH1v6e9RP0ZI4443X+WVeYYcbaEMCcR7vY45IX55XDDybAeupOEs5epS124XqEVsubqZAcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IO++ChStpm4KXRrDY6aLeSPuT6Gvrowo3BXnxHxzP5o=;
 b=XeVcfmoPAlZvahvYa7JZ1B3DvEm7TWRPNuwQo5agNTP8Vj6GG7wWJO7cV6LSCPPfrH7bDVhVxEG6FkhPztKIoQoxumL5VSfGb/casiJCknvpWujRsF65M9zPsIWUifqPo/GrjO2ywta9J32LQboeKZhWpoPnTokBN6N4uMaV4vxxk61SjGYx205lS/tyfflhKzY9k4WKzvgpXR1QpH+h0f4yGPMGq/ulL5oGoBjR3RBQtrmj0du4Sn3mUKXuxfwD825fkhfdmBfhvZfkEIP0p54+tBQ0NYsAoAJQpm7DYEHPTI5aglxemc/mdWOfvEcHx3bWJA1Q6yaGfLA13+mWQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IO++ChStpm4KXRrDY6aLeSPuT6Gvrowo3BXnxHxzP5o=;
 b=sR8y5IgjkiRsIub8wGeaRvmubB/MPJ+XYMh6UN0AFUg1ucJEADUtzFfEOlvXudW0O8Ksq66+CHripdb5Pp5WIEM0uQBsb3tPZR2OTtj5+70/cIgTjLaYrlGu1HgMuxz3MqWD2iSVqyT5VJTPX8jyD73hI5twVIzL/zqyUNBn6VM=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6640.eurprd04.prod.outlook.com (20.179.234.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Fri, 13 Mar 2020 06:00:09 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2814.018; Fri, 13 Mar 2020
 06:00:09 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: RE: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame
 preemption of traffic classes
Thread-Topic: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame
 preemption of traffic classes
Thread-Index: AQHVpQlV0arssjH64ECVUQFpoidQiagmtdqAgABRRQCAHzxzAIAAR3Zw
Date:   Fri, 13 Mar 2020 06:00:09 +0000
Message-ID: <VE1PR04MB6496B3F68B96A0123B49BCBA92FA0@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
 <87a75br4ze.fsf@linux.intel.com>
 <VE1PR04MB64968E2DE71D1BCE48C6E17192EE0@VE1PR04MB6496.eurprd04.prod.outlook.com>
 <87a74lgnad.fsf@linux.intel.com>
In-Reply-To: <87a74lgnad.fsf@linux.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 501ba536-de86-4767-5624-08d7c713c991
x-ms-traffictypediagnostic: VE1PR04MB6640:|VE1PR04MB6640:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB66405A45A2799D427860F31F92FA0@VE1PR04MB6640.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 034119E4F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(376002)(136003)(396003)(346002)(199004)(81166006)(7416002)(55016002)(2906002)(186003)(81156014)(110136005)(15974865002)(8936002)(76116006)(44832011)(86362001)(54906003)(4326008)(33656002)(478600001)(6506007)(26005)(71200400001)(53546011)(52536014)(9686003)(316002)(64756008)(8676002)(66556008)(66476007)(7696005)(5660300002)(66946007)(66446008)(921003)(21314003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6640;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5qPXmnwliL+ptYxueLCJLQMXGn98t3qbzAEb2og48kIWWoITtGyd42+wb+EL9P8oMlG1t0hS0cic/iwiqG7f2Rt1kdghuZkwFUzC/Tgdz9/XxHHtx/ib3ZwLY2jtXIPc5dqMgZlf3TIvbhFhobOsnbWXeq48aXdRPNOal0luzhQ1hjBij1K4pNnxD0c2N8sI9LpUXgv22oqxIEcHpO/hPELLnuYcN/uBIKkTkb2kZw6CHAeBB3L7pHy+khKlAdM/FEgvNyBzknnUkrwXw02eIzm6bQpux+qLABFGDa79NXcXq8n8x6pGLBKy5eAAfL/c7M9SaIngH+FXFIahcg/X0mjYY1RgYuu953DmDitbtUg7JsArsOa/Xq0fpsIdJpZFTEZ/lhv+AKWQ+BzfGXzJhalpOjF2XeRgrJAD3Kx76LvmyxzxzkpzPI9pjQ+vTU6Vs119dbd1HPBMjiavSM8nK0nlBfeuGpae67BvMoiHTUCB+GhK9rqiebPw443Njo1WlM4hN8SEwGNWDEyWuLfuO0PpG6taujcz2QjnGk8IYgmwIvooqEByAAECV2WyGLZBfqHlug7IuY54DkDTBGF3Yv4rH5Rtt8C3ZqXr1tFPZP0=
x-ms-exchange-antispam-messagedata: 2gHYM1GyZ3vc8d9rpHTfCFOqWqZ49ZlIvJDY4VfLEasKseAYlqcKJdmwYffZ0Z41ig4OdbDPW+HWbr+9xTE6+mZv99Nz1NJ9DvGcpPshZwKrAHHDMScPaIvRODcn8jfNFCsqZsi+nx7El1oY/efTUA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 501ba536-de86-4767-5624-08d7c713c991
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2020 06:00:09.4616
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CgnIZZmqziAXAsauaJhFf382M4heiLxO/bebmYunD/juANQw6fm2j5TUTrvAnmpU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6640
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCg0KQnIsDQpQbyBMaXUNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9t
OiBWaW5pY2l1cyBDb3N0YSBHb21lcyA8dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPg0KPiBTZW50
OiAyMDIw5bm0M+aciDEz5pelIDc6MzUNCj4gVG86IFBvIExpdSA8cG8ubGl1QG54cC5jb20+OyBk
YXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBoYXVrZS5tZWhydGVuc0BpbnRlbC5jb207IGdyZWdraEBs
aW51eGZvdW5kYXRpb24ub3JnOw0KPiBhbGxpc29uQGxvaHV0b2submV0OyB0Z2x4QGxpbnV0cm9u
aXguZGU7IGhrYWxsd2VpdDFAZ21haWwuY29tOw0KPiBzYWVlZG1AbWVsbGFub3guY29tOyBhbmRy
ZXdAbHVubi5jaDsgZi5mYWluZWxsaUBnbWFpbC5jb207DQo+IGFsZXhhbmRydS5hcmRlbGVhbkBh
bmFsb2cuY29tOyBqaXJpQG1lbGxhbm94LmNvbTsgYXlhbEBtZWxsYW5veC5jb207DQo+IHBhYmxv
QG5ldGZpbHRlci5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmcNCj4gQ2M6IHNpbW9uLmhvcm1hbkBuZXRyb25vbWUuY29tOyBDbGF1ZGl1IE1h
bm9pbA0KPiA8Y2xhdWRpdS5tYW5vaWxAbnhwLmNvbT47IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGlt
aXIub2x0ZWFuQG54cC5jb20+Ow0KPiBBbGV4YW5kcnUgTWFyZ2luZWFuIDxhbGV4YW5kcnUubWFy
Z2luZWFuQG54cC5jb20+OyBYaWFvbGlhbmcgWWFuZw0KPiA8eGlhb2xpYW5nLnlhbmdfMUBueHAu
Y29tPjsgUm95IFphbmcgPHJveS56YW5nQG54cC5jb20+OyBNaW5na2FpIEh1DQo+IDxtaW5na2Fp
Lmh1QG54cC5jb20+OyBKZXJyeSBIdWFuZyA8amVycnkuaHVhbmdAbnhwLmNvbT47IExlbyBMaQ0K
PiA8bGVveWFuZy5saUBueHAuY29tPjsgTXVyYWxpIEthcmljaGVyaSA8bS1rYXJpY2hlcmkyQHRp
LmNvbT47IEl2YW4NCj4gS2hvcm9uemh1ayA8aXZhbi5raG9yb256aHVrQGxpbmFyby5vcmc+DQo+
IFN1YmplY3Q6IFJFOiBbRVhUXSBSZTogW3YxLG5ldC1uZXh0LCAxLzJdIGV0aHRvb2w6IGFkZCBz
ZXR0aW5nIGZyYW1lDQo+IHByZWVtcHRpb24gb2YgdHJhZmZpYyBjbGFzc2VzDQo+IA0KPiBDYXV0
aW9uOiBFWFQgRW1haWwNCj4gDQo+IEhpLA0KPiANCj4gUG8gTGl1IDxwby5saXVAbnhwLmNvbT4g
d3JpdGVzOg0KPiANCj4gPiBIaSBWaW5pY2l1cywNCj4gPg0KPiA+DQo+ID4gQnIsDQo+ID4gUG8g
TGl1DQo+ID4NCj4gPj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPj4gRnJvbTogVmlu
aWNpdXMgQ29zdGEgR29tZXMgPHZpbmljaXVzLmdvbWVzQGludGVsLmNvbT4NCj4gPj4gU2VudDog
MjAyMOW5tDLmnIgyMuaXpSA1OjQ0DQo+ID4+IFRvOiBQbyBMaXUgPHBvLmxpdUBueHAuY29tPjsg
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gPj4gaGF1a2UubWVocnRlbnNAaW50ZWwuY29tOyBncmVn
a2hAbGludXhmb3VuZGF0aW9uLm9yZzsNCj4gPj4gYWxsaXNvbkBsb2h1dG9rLm5ldDsgdGdseEBs
aW51dHJvbml4LmRlOyBoa2FsbHdlaXQxQGdtYWlsLmNvbTsNCj4gPj4gc2FlZWRtQG1lbGxhbm94
LmNvbTsgYW5kcmV3QGx1bm4uY2g7IGYuZmFpbmVsbGlAZ21haWwuY29tOw0KPiA+PiBhbGV4YW5k
cnUuYXJkZWxlYW5AYW5hbG9nLmNvbTsgamlyaUBtZWxsYW5veC5jb207IGF5YWxAbWVsbGFub3gu
Y29tOw0KPiA+PiBwYWJsb0BuZXRmaWx0ZXIub3JnOyBsaW51eC0ga2VybmVsQHZnZXIua2VybmVs
Lm9yZzsNCj4gPj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiA+PiBDYzogc2ltb24uaG9ybWFu
QG5ldHJvbm9tZS5jb207IENsYXVkaXUgTWFub2lsDQo+ID4+IDxjbGF1ZGl1Lm1hbm9pbEBueHAu
Y29tPjsgVmxhZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT47DQo+ID4+IEFs
ZXhhbmRydSBNYXJnaW5lYW4gPGFsZXhhbmRydS5tYXJnaW5lYW5AbnhwLmNvbT47IFhpYW9saWFu
ZyBZYW5nDQo+ID4+IDx4aWFvbGlhbmcueWFuZ18xQG54cC5jb20+OyBSb3kgWmFuZyA8cm95Lnph
bmdAbnhwLmNvbT47IE1pbmdrYWkgSHUNCj4gPj4gPG1pbmdrYWkuaHVAbnhwLmNvbT47IEplcnJ5
IEh1YW5nIDxqZXJyeS5odWFuZ0BueHAuY29tPjsgTGVvIExpDQo+ID4+IDxsZW95YW5nLmxpQG54
cC5jb20+OyBQbyBMaXUgPHBvLmxpdUBueHAuY29tPg0KPiA+PiBTdWJqZWN0OiBbRVhUXSBSZTog
W3YxLG5ldC1uZXh0LCAxLzJdIGV0aHRvb2w6IGFkZCBzZXR0aW5nIGZyYW1lDQo+ID4+IHByZWVt
cHRpb24gb2YgdHJhZmZpYyBjbGFzc2VzDQo+ID4+DQo+ID4+IENhdXRpb246IEVYVCBFbWFpbA0K
PiA+Pg0KPiA+PiBIaSwNCj4gPj4NCj4gPj4gUG8gTGl1IDxwby5saXVAbnhwLmNvbT4gd3JpdGVz
Og0KPiA+Pg0KPiA+PiA+IElFRUUgU3RkIDgwMi4xUWJ1IHN0YW5kYXJkIGRlZmluZWQgdGhlIGZy
YW1lIHByZWVtcHRpb24gb2YgcG9ydA0KPiA+PiA+IHRyYWZmaWMgY2xhc3Nlcy4gVGhpcyBwYXRj
aCBpbnRyb2R1Y2UgYSBtZXRob2QgdG8gc2V0IHRyYWZmaWMNCj4gPj4gPiBjbGFzc2VzIHByZWVt
cHRpb24uIEFkZCBhIHBhcmFtZXRlciAncHJlZW1wdGlvbicgaW4gc3RydWN0DQo+ID4+ID4gZXRo
dG9vbF9saW5rX3NldHRpbmdzLiBUaGUgdmFsdWUgd2lsbCBiZSB0cmFuc2xhdGVkIHRvIGEgYmlu
YXJ5LA0KPiA+PiA+IGVhY2ggYml0IHJlcHJlc2VudCBhIHRyYWZmaWMgY2xhc3MuIEJpdCAiMSIg
bWVhbnMgcHJlZW1wdGFibGUNCj4gPj4gPiB0cmFmZmljIGNsYXNzLiBCaXQgIjAiIG1lYW5zIGV4
cHJlc3MgdHJhZmZpYyBjbGFzcy4gIE1TQiByZXByZXNlbnQNCj4gPj4gPiBoaWdoIG51bWJlciB0
cmFmZmljIGNsYXNzLg0KPiA+PiA+DQo+ID4+ID4gSWYgaGFyZHdhcmUgc3VwcG9ydCB0aGUgZnJh
bWUgcHJlZW1wdGlvbiwgZHJpdmVyIGNvdWxkIHNldCB0aGUNCj4gPj4gPiBldGhlcm5ldCBkZXZp
Y2Ugd2l0aCBod19mZWF0dXJlcyBhbmQgZmVhdHVyZXMgd2l0aA0KPiA+PiA+IE5FVElGX0ZfUFJF
RU1QVElPTiB3aGVuIGluaXRpYWxpemluZyB0aGUgcG9ydCBkcml2ZXIuDQo+ID4+ID4NCj4gPj4g
PiBVc2VyIGNhbiBjaGVjayB0aGUgZmVhdHVyZSAndHgtcHJlZW1wdGlvbicgYnkgY29tbWFuZCAn
ZXRodG9vbCAtaw0KPiA+PiA+IGRldm5hbWUnLiBJZiBoYXJld2FyZSBzZXQgcHJlZW1wdGlvbiBm
ZWF0dXJlLiBUaGUgcHJvcGVydHkgd291bGQgYmUNCj4gPj4gPiBhIGZpeGVkIHZhbHVlICdvbicg
aWYgaGFyZHdhcmUgc3VwcG9ydCB0aGUgZnJhbWUgcHJlZW1wdGlvbi4NCj4gPj4gPiBGZWF0dXJl
IHdvdWxkIHNob3cgYSBmaXhlZCB2YWx1ZSAnb2ZmJyBpZiBoYXJkd2FyZSBkb24ndCBzdXBwb3J0
DQo+ID4+ID4gdGhlIGZyYW1lIHByZWVtcHRpb24uDQo+ID4+ID4NCj4gPj4gPiBDb21tYW5kICdl
dGh0b29sIGRldm5hbWUnIGFuZCAnZXRodG9vbCAtcyBkZXZuYW1lIHByZWVtcHRpb24gTicNCj4g
Pj4gPiB3b3VsZCBzaG93L3NldCB3aGljaCB0cmFmZmljIGNsYXNzZXMgYXJlIGZyYW1lIHByZWVt
cHRhYmxlLg0KPiA+PiA+DQo+ID4+ID4gUG9ydCBkcml2ZXIgd291bGQgaW1wbGVtZW50IHRoZSBm
cmFtZSBwcmVlbXB0aW9uIGluIHRoZSBmdW5jdGlvbg0KPiA+PiA+IGdldF9saW5rX2tzZXR0aW5n
cygpIGFuZCBzZXRfbGlua19rc2V0dGluZ3MoKSBpbiB0aGUgc3RydWN0IGV0aHRvb2xfb3BzLg0K
PiA+PiA+DQo+ID4+DQo+ID4+IEFueSB1cGRhdGVzIG9uIHRoaXMgc2VyaWVzPyBJZiB5b3UgdGhp
bmsgdGhhdCB0aGVyZSdzIHNvbWV0aGluZyB0aGF0DQo+ID4+IEkgY291bGQgaGVscCwganVzdCB0
ZWxsLg0KPiA+DQo+ID4gU29ycnkgZm9yIHRoZSBsb25nIHRpbWUgbm90IGludm9sdmUgdGhlIGRp
c2N1c3Npb24uIEkgYW0gZm9jdXMgb24gb3RoZXIgdHNuDQo+IGNvZGUgZm9yIHRjIGZsb3dlci4N
Cj4gPiBJZiB5b3UgY2FuIHRha2UgbW9yZSBhYm91dCB0aGlzIHByZWVtcHRpb24gc2VyaWFsLCB0
aGF0IHdvdWxkIGJlIGdvb2QuDQo+ID4NCj4gPiBJIHN1bW1hcnkgc29tZSBzdWdnZXN0aW9ucyBm
cm9tIE1hcmFsaSBLYXJpY2hlcmkgYW5kIEl2YW4gS2hvcm5vbnpodWsNCj4gYW5kIGJ5IHlvdSBh
bmQgYWxzbyBvdGhlcnM6DQo+ID4gLSBBZGQgY29uZmlnIHRoZSBmcmFnbWVudCBzaXplLCBob2xk
IGFkdmFuY2UsIHJlbGVhc2UgYWR2YW5jZSBhbmQgZmxhZ3M7DQo+ID4gICAgIE15IGNvbW1lbnRz
IGFib3V0IHRoZSBmcmFnbWVudCBzaXplIGlzIGluIHRoZSBRYnUgc3BlYyBsaW1pdCB0aGUNCj4g
PiBmcmFnbWVudCBzaXplICIgdGhlIG1pbmltdW0gbm9uLWZpbmFsIGZyYWdtZW50IHNpemUgaXMg
NjQsIDEyOCwgMTkyLCBvciAyNTYNCj4gb2N0ZXRzICIgdGhpcyBzZXR0aW5nIHdvdWxkIGFmZmVj
dCB0aGUgZ3VhcmRiYW5kIHNldHRpbmcgZm9yIFFidi4gQnV0IHRoZQ0KPiBldGh0b29sIHNldHRp
bmcgY291bGQgbm90IGludm9sdmUgdGhpcyBpc3N1ZXMgYnV0IGJ5IHRoZSB0YXByaW8gc2lkZS4N
Cj4gPiAtICIgRnVydGhlcm1vcmUsIHRoaXMgc2V0dGluZyBjb3VsZCBiZSBleHRlbmQgZm9yIGEg
c2VyaWFsIHNldHRpbmcgZm9yIG1hYyBhbmQNCj4gdHJhZmZpYyBjbGFzcy4iICAiQmV0dGVyIG5v
dCB0byB1c2luZyB0aGUgdHJhZmZpYyBjbGFzcyBjb25jZXB0LiINCj4gPiAgICBDb3VsZCBhZGRp
bmcgYSBzZXJpYWwgc2V0dGluZyBieSAiZXRodG9vbCAtLXByZWVtcHRpb24geHh4IiBvciBvdGhl
ciBuYW1lLg0KPiBJIGRvbicgdCB0aGluayBpdCBpcyBnb29kIHRvIGludm9sdmUgaW4gdGhlIHF1
ZXVlIGNvbnRyb2wgc2luY2UgcXVldWVzIG51bWJlcg0KPiBtYXkgYmlnZ2VyIHRoYW4gdGhlIFRD
IG51bWJlci4NCj4gPiAtIFRoZSBldGh0b29sIGlzIHRoZSBiZXR0ZXIgY2hvaWNlIHRvIGNvbmZp
Z3VyZSB0aGUgcHJlZW1wdGlvbg0KPiA+ICAgSSBhZ3JlZS4NCj4gDQo+IEp1c3QgYSBxdWljayB1
cGRhdGUuIEkgd2FzIGFibGUgdG8gZGVkaWNhdGUgc29tZSB0aW1lIHRvIHRoaXMsIGFuZCBoYXZl
DQo+IHNvbWV0aGluZyBhcHJvYWNoaW5nIFJGQy1xdWFsaXR5LCBidXQgaXQgbmVlZHMgbW9yZSB0
ZXN0aW5nLg0KPiANCj4gU28sIHF1ZXN0aW9uLCB3aGF0IHdlcmUgeW91IHVzaW5nIGZvciB0ZXN0
aW5nIHRoaXM/IEFueXRoaW5nIHNwZWNpYWw/DQoNCkkgdGVzdGVkIG9uIHd3dy5ueHAuY29tL0xT
MTAyOEEuIFRoZXJlIGlzIG5vdGhpbmcgc3BlY2lhbCBmb3IgcHJlZW1wdGlvbi4gDQoNCj4gDQo+
IEFuZCBidHcsIHRoYW5rcyBmb3IgdGhlIHN1bW1hcnkgb2YgdGhlIGRpc2N1c3Npb24uDQoNCg0K
PiANCj4gPg0KPiA+IFRoYW5rc++8gQ0KPiA+Pg0KPiA+Pg0KPiA+PiBDaGVlcnMsDQo+ID4+IC0t
DQo+ID4+IFZpbmljaXVzDQo+IA0KPiANCj4gLS0NCj4gVmluaWNpdXMNCg==
