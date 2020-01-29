Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6B914C838
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 10:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgA2Jju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 04:39:50 -0500
Received: from mail-am6eur05on2049.outbound.protection.outlook.com ([40.107.22.49]:6266
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726010AbgA2Jju (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 04:39:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gf2USi8q0jjhn+LM/wphSRSrTEaCXlWon41hjb23bjvD1OU9acMP3ZkV2jbQsD3t42AFde+NMQlf8y8xCXk7ckkpNKGO8NMJMKye27db8RkqQnKjMIFfhrAXBcbkc5RYfTpeofD3lj2UwaeiGPNmfK2JxkhdDmKIN+K83AeU5mN6g9kWYR7m6N+zrO0TDt0+w4o8W9Woamq9w/PRTD76Ogbv23x5fB1QWimboQSe/ay3H8N1nCpGlPQlV+FhzqxQ273eCcbFfM4k5/UBbrkirPK/YXp7nJZ4REHkfmq+FpVM/qWfgQDCKwQ+iHJBeN0YDDIC5WyaMe2dscTLB6CJHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWyYaDQlUpfJTalEIOUnQJ9sOctTw2fn1nnPFGEI1bs=;
 b=NrFP3+Oagw4BqO2rqMtUGHJcMe7IaY62J/spoTSy3HCP4iGIzn3awD8QUZrA0ixxnkNltkwf+2sPjNNHrDgLBur6ZOqP0Qjp7+sHz3vMIKYlqFCRbnDxYD3AU+8XZGBQThg4b3qXeeHu75QINfQxhCS1bdrB1jgQL9hdcjico1tB4gOr9xjmPwROkQNk+jwuIYSSNHwMS7uXj2eGxF8QCd7xEQbuOK+ejETXc9pbxcYUdOBPpd8gjeqiLF9OPIicELKpBj1JJGaVHxvKNz0PDAjpMNzsrYB+B6S4if1s1y7uL7NvQ7251kKc7HxeqkvozLlNfu9Jlx6mt9Gv+PSQvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWyYaDQlUpfJTalEIOUnQJ9sOctTw2fn1nnPFGEI1bs=;
 b=BEdMuw+YU9hGmsxvZCxIiwcFyIKikkpHFMbPKeb7wKUfSAl+FYHYyR11tmEfLjVemh+BesYnR7EPZ0yyoGcUZ9rhf1JZ3S98fs+ZBzLXDVljqmM8JB6bpEAuHlwciWTbXEQaNiin/SLze5Z1Z18vSQ2zxjX2P12KkteLH9En6qc=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB7050.eurprd04.prod.outlook.com (52.135.62.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.24; Wed, 29 Jan 2020 09:38:06 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3%6]) with mapi id 15.20.2665.027; Wed, 29 Jan 2020
 09:38:06 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ykaukab@suse.de" <ykaukab@suse.de>
Subject: RE: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
 indication
Thread-Topic: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
 indication
Thread-Index: AQHV0Sw23V0HaV1F6UKjzaVeqBvXWaf2+L4AgADjpXCABvOdgIABdECAgAEnbfA=
Date:   Wed, 29 Jan 2020 09:38:06 +0000
Message-ID: <DB8PR04MB6985139D4ABED85B701445A9EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1579701573-6609-2-git-send-email-madalin.bucur@oss.nxp.com>
 <68921c8a-06b6-d5c0-e857-14e7bc2c0a94@gmail.com>
 <DB8PR04MB6985606F38572D8512E8D27EEC0F0@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <77e3ddcb-bddb-32d8-9c87-48ba9a7f2773@gmail.com>
 <CA+h21hq7U_EtetuLZN5rjXcq+cRUoD0y_76LxuHpoC53J70CEQ@mail.gmail.com>
In-Reply-To: <CA+h21hq7U_EtetuLZN5rjXcq+cRUoD0y_76LxuHpoC53J70CEQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8711cb94-4225-4c45-3d39-08d7a49ef1db
x-ms-traffictypediagnostic: DB8PR04MB7050:|DB8PR04MB7050:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB7050B36C9533B19FBAD15B97AD050@DB8PR04MB7050.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 02973C87BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(189003)(199004)(86362001)(76116006)(53546011)(6506007)(64756008)(66476007)(186003)(66446008)(4326008)(66556008)(81166006)(8936002)(81156014)(52536014)(33656002)(66946007)(26005)(2906002)(8676002)(55016002)(316002)(7696005)(9686003)(54906003)(5660300002)(110136005)(71200400001)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB7050;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KAOo8wrp4Chz1YdL9SKk3hY844DUb3jfpYvWQbwq1BwG/13IogZmXMxYizjQcETGe3x+wujhdx6vrtheWf3nxiR0uvbcmuL5sKIcoEeMANeuhhc9VJS+NG4RBiz524jbnTWM0MM7I7EpAVvXU6qNOh+2W3T0kdeV/k6fQbpBfj0VJTV0wWPUJFT2Z9lyDWToVUv0dVw9SxLsYWO/OiBTcLw5MAoredaw/rf2OUCoDDPfBVyyaQ3ltL+xm+RolEFjh1m61qsi/FUMpoLJPVTmapt5P+31sfYLmQqzW0IN9Gy3o/lpI7+NUgXbawjzomVTCdvjDu1kTJJ0F88kaSHPgm259Ceocm14+uB2TtFeV+q3TD61M6lLEW/kWy96igXItuC6thO7nX2M27k4umS3UrhEn+PC66vVqfh5rwxDLJVxSw3YcRNHxunoJQ6vHehX
x-ms-exchange-antispam-messagedata: dclnBW/NtPCCBTDS59AS5Vd2rgwPiiwajUOVSRZJ1FbOlP2E3CbEjIujoP1fUHY+w37TfmCuErI/EKJKD/FIIVmjfB+1ZQI0eoSJCXCG7oYIXKQbIw7itBpU5wgL0p5Iv+k9iovdPxcI6X+M7pQj1w==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8711cb94-4225-4c45-3d39-08d7a49ef1db
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2020 09:38:06.4305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5a3xYmJv76i8x8kUkaGEtDifUBnjKtJ7xYS269NEZ6c3eCPWzkJoUqe2Z/o0OxUy84qAIWx+LwGIh3wBTffvxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7050
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBWbGFkaW1pciBPbHRlYW4gPG9s
dGVhbnZAZ21haWwuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBKYW51YXJ5IDI4LCAyMDIwIDU6NTUg
UE0NCj4gVG86IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiBDYzog
TWFkYWxpbiBCdWN1ciAoT1NTKSA8bWFkYWxpbi5idWN1ckBvc3MubnhwLmNvbT47IGRhdmVtQGRh
dmVtbG9mdC5uZXQ7DQo+IGFuZHJld0BsdW5uLmNoOyBoa2FsbHdlaXQxQGdtYWlsLmNvbTsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4geWthdWthYkBzdXNlLmRlDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggbmV0LW5leHQgMS8yXSBuZXQ6IHBoeTogYXF1YW50aWE6IGFkZCByYXRlX2FkYXB0YXRp
b24NCj4gaW5kaWNhdGlvbg0KPiANCj4gSGkgRmxvcmlhbiwNCj4gDQo+IE9uIE1vbiwgMjcgSmFu
IDIwMjAgYXQgMTk6NDQsIEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPg0K
PiB3cm90ZToNCj4gPg0KPiA+IE9uIDEvMjIvMjAgMTE6MzggUE0sIE1hZGFsaW4gQnVjdXIgKE9T
Uykgd3JvdGU6DQo+ID4gPj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+PiBGcm9t
OiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT4NCj4gPiA+PiBTZW50OiBX
ZWRuZXNkYXksIEphbnVhcnkgMjIsIDIwMjAgNzo1OCBQTQ0KPiA+ID4+IFRvOiBNYWRhbGluIEJ1
Y3VyIChPU1MpIDxtYWRhbGluLmJ1Y3VyQG9zcy5ueHAuY29tPjsNCj4gZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldA0KPiA+ID4+IENjOiBhbmRyZXdAbHVubi5jaDsgaGthbGx3ZWl0MUBnbWFpbC5jb207IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+ID4gPj4geWthdWthYkBzdXNlLmRlDQo+ID4gPj4gU3Vi
amVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAxLzJdIG5ldDogcGh5OiBhcXVhbnRpYTogYWRkDQo+
IHJhdGVfYWRhcHRhdGlvbg0KPiA+ID4+IGluZGljYXRpb24NCj4gPiA+Pg0KPiA+ID4+IE9uIDEv
MjIvMjAgNTo1OSBBTSwgTWFkYWxpbiBCdWN1ciB3cm90ZToNCj4gPiA+Pj4gVGhlIEFRUiBQSFlz
IGFyZSBhYmxlIHRvIHBlcmZvcm0gcmF0ZSBhZGFwdGF0aW9uIGJldHdlZW4NCj4gPiA+Pj4gdGhl
IHN5c3RlbSBpbnRlcmZhY2UgYW5kIHRoZSBsaW5lIGludGVyZmFjZXMuIFdoZW4gc3VjaA0KPiA+
ID4+PiBhIFBIWSBpcyBkZXBsb3llZCwgdGhlIGV0aGVybmV0IGRyaXZlciBzaG91bGQgbm90IGxp
bWl0DQo+ID4gPj4+IHRoZSBtb2RlcyBzdXBwb3J0ZWQgb3IgYWR2ZXJ0aXNlZCBieSB0aGUgUEhZ
LiBUaGlzIHBhdGNoDQo+ID4gPj4+IGludHJvZHVjZXMgdGhlIGJpdCB0aGF0IGFsbG93cyBjaGVj
a2luZyBmb3IgdGhpcyBmZWF0dXJlDQo+ID4gPj4+IGluIHRoZSBwaHlfZGV2aWNlIHN0cnVjdHVy
ZSBhbmQgaXRzIHVzZSBmb3IgdGhlIEFxdWFudGlhDQo+ID4gPj4+IFBIWXMuDQo+ID4gPj4+DQo+
ID4gPj4+IFNpZ25lZC1vZmYtYnk6IE1hZGFsaW4gQnVjdXIgPG1hZGFsaW4uYnVjdXJAb3NzLm54
cC5jb20+DQo+ID4gPj4+IC0tLQ0KPiA+ID4+PiAgZHJpdmVycy9uZXQvcGh5L2FxdWFudGlhX21h
aW4uYyB8IDMgKysrDQo+ID4gPj4+ICBpbmNsdWRlL2xpbnV4L3BoeS5oICAgICAgICAgICAgIHwg
MyArKysNCj4gPiA+Pj4gIDIgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspDQo+ID4gPj4+
DQo+ID4gPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9waHkvYXF1YW50aWFfbWFpbi5jDQo+
ID4gPj4gYi9kcml2ZXJzL25ldC9waHkvYXF1YW50aWFfbWFpbi5jDQo+ID4gPj4+IGluZGV4IDk3
NTc4OWQ5MzQ5ZC4uMzZmZGQ1MjNiNzU4IDEwMDY0NA0KPiA+ID4+PiAtLS0gYS9kcml2ZXJzL25l
dC9waHkvYXF1YW50aWFfbWFpbi5jDQo+ID4gPj4+ICsrKyBiL2RyaXZlcnMvbmV0L3BoeS9hcXVh
bnRpYV9tYWluLmMNCj4gPiA+Pj4gQEAgLTIwOSw2ICsyMDksOSBAQCBzdGF0aWMgaW50IGFxcl9j
b25maWdfYW5lZyhzdHJ1Y3QgcGh5X2RldmljZQ0KPiA+ID4+ICpwaHlkZXYpDQo+ID4gPj4+ICAg
ICB1MTYgcmVnOw0KPiA+ID4+PiAgICAgaW50IHJldDsNCj4gPiA+Pj4NCj4gPiA+Pj4gKyAgIC8q
IGFkZCBoZXJlIGFzIHRoaXMgaXMgY2FsbGVkIGZvciBhbGwgZGV2aWNlcyAqLw0KPiA+ID4+PiAr
ICAgcGh5ZGV2LT5yYXRlX2FkYXB0YXRpb24gPSAxOw0KPiA+ID4+DQo+ID4gPj4gSG93IGFib3V0
IGludHJvZHVjaW5nIGEgbmV3IFBIWV9TVVBQT1JUU19SQVRFX0FEQVBUQVRJT04gZmxhZyBhbmQN
Cj4geW91DQo+ID4gPj4gc2V0IHRoYXQgZGlyZWN0bHkgZnJvbSB0aGUgcGh5X2RyaXZlciBlbnRy
eT8gdXNpbmcgdGhlICJmbGFncyINCj4gYml0bWFzaw0KPiA+ID4+IGluc3RlYWQgb2YgYWRkaW5n
IGFub3RoZXIgc3RydWN0dXJlIG1lbWJlciB0byBwaHlfZGV2aWNlPw0KPiA+ID4NCj4gPiA+IEkn
dmUgbG9va2VkIGF0IHRoZSBwaHlkZXYtPmRldl9mbGFncyB1c2UsIGl0IHNlZW1lZCB0byBtZSB0
aGF0IG1vc3RseQ0KPiBpdA0KPiA+ID4gaXMgdXNlZCB0byBjb252ZXkgY29uZmlndXJhdGlvbiBv
cHRpb25zIHRvd2FyZHMgdGhlIFBIWS4NCj4gPg0KPiA+IFlvdSByZWFkIG1lIGluY29ycmVjdGx5
LCBJIGFtIHN1Z2dlc3RpbmcgdXNpbmcgdGhlIHBoeV9kcml2ZXI6OmZsYWdzDQo+ID4gbWVtYmVy
LCBub3QgdGhlIHBoeV9kZXZpY2U6OmRldl9mbGFncyBlbnRyeSwgcGxlYXNlIHJlLWNvbnNpZGVy
IHlvdXINCj4gPiBwb3NpdGlvbi4NCj4gPg0KPiANCj4gV2hldGhlciB0aGUgUEhZIHBlcmZvcm1z
IHJhdGUgYWRhcHRhdGlvbiBpcyBhIGR5bmFtaWMgcHJvcGVydHkuDQo+IEl0IHdpbGwgcGVyZm9y
bSBpdCBhdCB3aXJlIHNwZWVkcyBsb3dlciB0aGFuIDI1MDBNYnBzICgxMDAwLzEwMCkgd2hlbg0K
PiBzeXN0ZW0gc2lkZSBpcyAyNTAwQmFzZS1YLCBidXQgbm90IGF0IHdpcmUgc3BlZWQgMjUwMCAm
IDI1MDBCYXNlLVgsDQo+IGFuZCBub3QgYXQgd2lyZSBzcGVlZCAxMDAwICYgVVNYR01JSS4NCj4g
WW91IGNhbid0IHJlYWxseSBlbmNvZGUgdGhhdCBpbiBwaHlkZXYtPmZsYWdzLg0KDQpWbGFkaW1p
ciwgdGhlIHBhdGNoIGFkZHMgYSBiaXQgdGhhdCBpbmRpY2F0ZXMgdGhlIFBIWSBhYmlsaXR5IHRv
IHBlcmZvcm0NCnJhdGUgYWRhcHRhdGlvbiwgbm90IHdoZXRoZXIgaXQgaXMgYWN0dWFsbHkgaW4g
dXNlIGluIGEgY2VydGFpbiBjb21iaW5hdGlvbg0Kb2Ygc3lzdGVtIGludGVyZmFjZSBhbmQgbGlu
ZSBpbnRlcmZhY2UgbW9kZXMuIFBsZWFzZSByZXZpZXcgdGhlIHN1Ym1pc3Npb24NCmFnYWluLCBJ
IHVuZGVyc3RhbmQgeW91IGhhdmUgc29tZXRoaW5nIHNsaWdodGx5IGRpZmZlcmVudCBpbiBtaW5k
LCBidXQgdGhpcw0KaXMganVzdCBhZGRyZXNzaW5nIGEgYmFzaWMgbmVlZCBvZiBrbm93aW5nIHdo
ZXRoZXIgdGhlcmUgaXMgYSBjaGFuY2UgdGhlDQpsaW5lIHNpZGUgY291bGQgd29yayBhdCBvdGhl
ciBzcGVlZHMgdGhhbiB0aGUgc3lzdGVtIGludGVyZmFjZSBhbmQgYWxsb3cgaXQNCnRvIGRvIHNv
Lg0KIA0KPiBJIHdhcyBhY3R1YWxseSBzZWFyY2hpbmcgZm9yIGEgd2F5IHRvIGVuY29kZSBzb21l
IG1vcmUgUEhZIGNhcGFiaWxpdGllczoNCj4gLSBEb2VzIGl0IHdvcmsgd2l0aCBpbi1iYW5kIGF1
dG9uZWcgZW5hYmxlZD8NCj4gLSBEb2VzIGl0IHdvcmsgd2l0aCBpbi1iYW5kIGF1dG9uZWcgYnlw
YXNzZWQ/DQo+IC0gRG9lcyBpdCBlbWl0IHBhdXNlIGZyYW1lcz8gPC0gTWFkYWxpbiBnb3QgYWhl
YWQgb2YgbWUgb24gdGhpcyBvbmUuDQo+IA0KPiBGb3IgdGhlIGZpcnN0IDIsIEkgd2FudCBhIG1l
Y2hhbmlzbSBmb3IgdGhlIFBIWSBsaWJyYXJ5IHRvIGZpZ3VyZSBvdXQNCj4gd2hldGhlciB0aGUg
TUFDIGFuZCB0aGUgUEhZIHNob3VsZCB1c2UgaW4tYmFuZCBhdXRvbmVnIG9yIG5vdC4gSWYgYm90
aA0KPiBzdXBwb3J0IGluLWJhbmQgYXV0b25lZywgdGhhdCB3b3VsZCBiZSBwcmVmZXJyZWQuIE90
aGVyd2lzZSwNCj4gb3V0LW9mLWJhbmQgKE1ESU8pIGlzIHByZWZlcnJlZCwgYW5kIGluLWJhbmQg
YXV0b25lZyBpcyBleHBsaWNpdGx5DQo+IGRpc2FibGVkIGluIGJvdGgsIGlmIHRoYXQgaXMgY2xh
aW1lZCB0byBiZSBzdXBwb3J0ZWQuIE90aGVyd2lzZSwNCj4gcmVwb3J0IGVycm9yIHRvIHVzZXIu
IFllcywgdGhpcyBkZXByZWNhdGVzICJtYW5hZ2VkID0NCj4gJ2luLWJhbmQtc3RhdHVzJyIgaW4g
dGhlIGRldmljZSB0cmVlLCBhbmQgdGhhdCdzIGZvciAod2hhdCBJIHRoaW5rIGlzKQ0KPiB0aGUg
YmV0dGVyLiBXZSBjYW4gbWFrZSAibWFuYWdlZCA9ICdpbi1iYW5kLXN0YXR1cyciIHRvIGp1c3Qg
Y2xlYXIgdGhlDQo+IE1BQydzIGFiaWxpdHkgdG8gc3VwcG9ydCB0aGUgImluLWJhbmQgYXV0b25l
ZyBieXBhc3NlZCIgbW9kZS4NCj4gDQo+IFNvIEkgdGhvdWdodCBhIGZ1bmN0aW9uIHBvaW50ZXIg
aW4gdGhlIHBoeSBkcml2ZXIgd291bGQgYmUgYmV0dGVyLCBhbmQNCj4gbW9yZSBleHRlbnNpYmxl
Lg0KPiBUaG91Z2h0cz8NCg0KVGhpcyBpcyB3aGVyZSB5b3UgZ2V0IHdoZW4geW91IHRyeSB0byBp
bXBsZW1lbnQgYW50aS1zdHVwaWQgZGV2aWNlcywgaXQgZ2V0cw0KY29tcGxpY2F0ZWQgZmFzdCBh
bmQsIG1vc3Qgb2Z0ZW4sIGl0IGdldHMgaW4gdGhlIHdheS4gU2hvdWxkIHNvbWVvbmUgY2hhbmdl
DQphIHNldHRpbmcgKHBhdXNlIHNldHRpbmdzKSBhbmQgZXhwZXJpZW5jZSBhZHZlcnNlIGVmZmVj
dHMgKGV4Y2Vzc2l2ZSBmcmFtZQ0KbG9zcyksIHdlIHNob3VsZCByZWx5IG9uIGhpcyBhbmFseXRp
Y2FsIGFiaWxpdGllcyB0byBjb25uZWN0IHRoZSBkb3RzLCBpbWhvLg0KDQpNYWRhbGluDQoNCiAN
Cj4gPiAtLQ0KPiA+IEZsb3JpYW4NCj4gDQo+IFJlZ2FyZHMsDQo+IC1WbGFkaW1pcg0K
