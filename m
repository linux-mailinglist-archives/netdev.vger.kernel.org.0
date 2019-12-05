Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5C8113FE8
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 12:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbfLELFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 06:05:03 -0500
Received: from mail-eopbgr20080.outbound.protection.outlook.com ([40.107.2.80]:37027
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729018AbfLELFC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 06:05:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9R0Aq5cak+kNZYuUc6xKekInBWV90SNbOuM0PEbYU13lDtFUoN4zAki0Id1ePwDCmoDvPWuutPvdKX0G7fYvbka0oNjCOpHsCnVuRWF/d7t8DKt37pUneRi9tIn9eVYtgWvTX1Blxgwd6tH4zVPWGs0P4KrXhxrysx49M9CT+TG2Y3KnRWhXVIK028CBL3J0NWYs86AwkSX977ZLgAZG5PfkDjDCX9oE1VlYOgecBA0GVzkMkYuhtU8muBFP/nDIezVjARHyvbyQPGqcfVgaTaGs2JC8gspsBZrPLq0CKeeKaIHQLuHtM6Ri8yXe/BU8xsWKysPNRBS5szda4MBMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmyLz210qs5EchZ+RG/NQ8bD07mB2g/fzFhlhdb713E=;
 b=gzP6jtv2o9p7UYKuJ+y10OCj9ipbV46Wk6JTmNxM6W0rIvxc86+Y2LO3S7a1IHI4kA0CjZo/ySenLtl/9qwnxBg+H23roj3NA71oWPs3TkU/5h6A35iJgQJ4T/rkcaMnhc54pT+G5bDTZdDju/PJCGpaQSSHA66HmOmd2Qa3l3tWYgE5QyuiA08LegH9a8MnH12V/dzwQu3LjLKfCU6wqw7cTpB/hfEQ0bBeE8myokm68gvfdgSn5F0PQ00KSt2Opi0rXqUxqztl2Vx0qjsGxF7+pYAacEnWziHfLllpTjEG+KBVAxGfdTGjcgzUI6EtuLqPJWPUA2zwv2SHhSusOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmyLz210qs5EchZ+RG/NQ8bD07mB2g/fzFhlhdb713E=;
 b=h5Vxa6Q1bATVLKWn7zPpxAexv08K5WvKD2wC6rrUxyM3Vf2IjWLiHDZQW+wCBQzUiyrqkb3t5l6DZcx4gANZR3/zrXSmIIIpOgI/0cD+ZiCE4RCFydu6utffB8X928jVTBl+Im56rGaGCOW5mAe3mETUn2DpOlf/FEUyl1sS1E0=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB5353.eurprd04.prod.outlook.com (20.178.105.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Thu, 5 Dec 2019 11:04:53 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.014; Thu, 5 Dec 2019
 11:04:53 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 2/4] can: flexcan: try to exit stop mode during probe
 stage
Thread-Topic: [PATCH V2 2/4] can: flexcan: try to exit stop mode during probe
 stage
Thread-Index: AQHVpOd0/zAyRBOEIkuRK6cuc/m3PqeowUOAgACCKzCAAHEBAIABnIgAgAAZ27A=
Date:   Thu, 5 Dec 2019 11:04:53 +0000
Message-ID: <DB7PR04MB46184164EAC5719BDCF3822CE65C0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <20191127055334.1476-3-qiangqing.zhang@nxp.com>
 <ad7e7b15-26f3-daa1-02d2-782ff548756d@pengutronix.de>
 <DB7PR04MB46180C5F1EAC7C4A69A45E0CE65D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
 <d68b2b79-34ec-eb4c-cf4b-047b5157d5e3@pengutronix.de>
 <a1ded645-9e12-d939-7920-8e79983b02a0@geanix.com>
In-Reply-To: <a1ded645-9e12-d939-7920-8e79983b02a0@geanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1427112b-9063-4cb9-08d7-08d77972f4ac
x-ms-traffictypediagnostic: DB7PR04MB5353:|DB7PR04MB5353:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB53538728069E2C7F39E2B12FE65C0@DB7PR04MB5353.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02426D11FE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(366004)(136003)(346002)(189003)(199004)(13464003)(8936002)(11346002)(86362001)(71200400001)(478600001)(229853002)(7696005)(102836004)(66556008)(26005)(14444005)(19627235002)(76176011)(53546011)(99286004)(4326008)(6506007)(25786009)(8676002)(9686003)(74316002)(55016002)(2906002)(316002)(5660300002)(54906003)(186003)(33656002)(110136005)(64756008)(66446008)(66946007)(14454004)(81166006)(81156014)(305945005)(66476007)(71190400001)(76116006)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5353;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z07w2U6Bd7ynDlXItlS1IvPO+shSbV4sAlt7EpTsjQwejsElPBKamCH52AfOgUDYQYj9PRbXQlE+8BmsTLuM4YcXYSejj+sxFAlx9AI64vubKT5HC756mXd7ESnQDfz4tg9m/F5T+nKew5ua8XokfInwfaqXwxc70nLuRH45xRfCDf4RbD+7hGd6egA84V838RT3qWiXw+IXvbaJIujNMREuwW6dkxjsTMqSAITepipYqQY1u/A5+H35IDjTnlnhkfjdjDhLU8iyoqnCD7lER71UFAJStArcWhOCKSaoxy91YOA6gVupj8tpSrTHXA07AqxsDLZBwz5qIQZP99QasD05Wus1G7iRKqblK8gz7uWsr0HkVxiwwopqzQhqJhiLMf+v0ZI7f6ZxmYgjQAbXxnF86g4aZItl1FV2DipAxuCUSqVoItlKiTwviGZEvN1BMuUCGyorSDTN8RbKmAHUnsxbRW0IWh/tf/+A/XG9zF8P0hqsihvvjbG12MjWS8HN
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1427112b-9063-4cb9-08d7-08d77972f4ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2019 11:04:53.3622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 30zqM6VZXhmjIoLVrr8Ri86sUXL7meqbUMEITLpqDj5KVHXjI7JtBXdNDavHGB3E7eI7xTzv/m3G5Jdxu0SWBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5353
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlYW4gTnlla2phZXIgPHNl
YW5AZ2Vhbml4LmNvbT4NCj4gU2VudDogMjAxOeW5tDEy5pyINeaXpSAxNzoyMg0KPiBUbzogTWFy
YyBLbGVpbmUtQnVkZGUgPG1rbEBwZW5ndXRyb25peC5kZT47IEpvYWtpbSBaaGFuZw0KPiA8cWlh
bmdxaW5nLnpoYW5nQG54cC5jb20+OyBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnDQo+IENjOiBk
bC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0K
PiBTdWJqZWN0OiBSZTogW1BBVENIIFYyIDIvNF0gY2FuOiBmbGV4Y2FuOiB0cnkgdG8gZXhpdCBz
dG9wIG1vZGUgZHVyaW5nIHByb2JlDQo+IHN0YWdlDQo+IA0KPiANCj4gDQo+IE9uIDA0LzEyLzIw
MTkgMDkuNDUsIE1hcmMgS2xlaW5lLUJ1ZGRlIHdyb3RlOg0KPiA+IE9uIDEyLzQvMTkgMzoyMiBB
TSwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+Pg0KPiA+Pj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdl
LS0tLS0NCj4gPj4+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRlIDxta2xAcGVuZ3V0cm9uaXguZGU+
DQo+ID4+PiBTZW50OiAyMDE55bm0MTLmnIg05pelIDI6MTUNCj4gPj4+IFRvOiBKb2FraW0gWmhh
bmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgc2VhbkBnZWFuaXguY29tOw0KPiA+Pj4gbGlu
dXgtY2FuQHZnZXIua2VybmVsLm9yZw0KPiA+Pj4gQ2M6IGRsLWxpbnV4LWlteCA8bGludXgtaW14
QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+ID4+PiBTdWJqZWN0OiBSZTogW1BB
VENIIFYyIDIvNF0gY2FuOiBmbGV4Y2FuOiB0cnkgdG8gZXhpdCBzdG9wIG1vZGUNCj4gPj4+IGR1
cmluZyBwcm9iZSBzdGFnZQ0KPiA+Pj4NCj4gPj4+IE9uIDExLzI3LzE5IDY6NTYgQU0sIEpvYWtp
bSBaaGFuZyB3cm90ZToNCj4gPj4+PiBDQU4gY29udHJvbGxlciBjb3VsZCBiZSBzdHVja2VkIGlu
IHN0b3AgbW9kZSBvbmNlIGl0IGVudGVycyBzdG9wDQo+ID4+Pj4gbW9kZQ0KPiA+Pj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgXl5eXl5eXiBzdHVjaw0KPiA+Pj4+IHdoZW4gc3VzcGVuZCwg
YW5kIHRoZW4gaXQgZmFpbHMgdG8gZXhpdCBzdG9wIG1vZGUgd2hlbiByZXN1bWUuDQo+ID4+Pg0K
PiA+Pj4gSG93IGNhbiB0aGlzIGhhcHBlbj8NCj4gPj4NCj4gPj4gSSBhbSBhbHNvIGNvbmZ1c2Vk
IGhvdyBjYW4gdGhpcyBoYXBwZW4sIGFzIEkgYXNrZWQgU2Vhbiwgb25seSBDQU4NCj4gPj4gZW50
ZXIgc3RvcCBtb2RlIHdoZW4gc3VzcGVuZCwgdGhlbiBzeXN0ZW0gaGFuZywNCj4gPiBIb3cgZG8g
eW91IHJlY292ZXIgdGhlIHN5c3RlbSB3aGVuIHN1c3BlbmRlZD8NCj4gPg0KPiA+PiBpdCBjb3Vs
ZCBsZXQgQ0FODQo+ID4+IHN0dWNrIGluIHN0b3AgbW9kZS4gSG93ZXZlciwgU2VhbiBzYWlkIHRo
aXMgaW5kZWVkIGhhcHBlbiBhdCBoaXMNCj4gPj4gc2lkZSwgQHNlYW5AZ2Vhbml4LmNvbSwgY291
bGQgeW91IGV4cGxhaW4gaG93IHRoaXMgaGFwcGVuIGluIGRldGFpbHM/DQo+ID4gVGhhdCB3b3Vs
ZCBiZSBnb29kLg0KPiA+DQo+ID4+Pj4gT25seSBjb2RlIHJlc2V0IGNhbiBnZXQgQ0FOIG91dCBv
ZiBzdG9wIG1vZGUsDQo+ID4+Pg0KPiA+Pj4gV2hhdCBpcyAiY29kZSByZXNldCI/DQo+ID4+DQo+
ID4+IEFzIEkga25vdywgImNvZGUgcmVzZXQiIGlzIHRvIHByZXNzIHRoZSBQT1dFUiBLRVkgZnJv
bSB0aGUgYm9hcmQuIEF0DQo+ID4+IG15IHNpZGUsIHJlYm9vdCBjb21tYW5kIGZyb20gT1MgYWxz
byBjYW4gZ2V0IENBTiBvdXQgb2Ygc3RvcCBtb2RlLg0KPiA+IERvIHlvdSBtZWFuICJjb2xkIHJl
c2V0IiwgYWxzbyBrbm93biBhcyBQb3dlci1Pbi1SZXNldCwgUE9SIG9yIHBvd2VyDQo+IGN5Y2xl
Pw0KPiA+DQo+ID4gV2hhdCBkb2VzIHByZXNzaW5nIHRoZSBQT1dFUiBLRVkgZG8/IEEgcG93ZXIg
Y3ljbGUgb2YgdGhlIHN5c3RlbSBvcg0KPiA+IHRvZ2dsaW5nIHRoZSByZXNldCBsaW5lIG9mIHRo
ZSBpbXg/DQo+ID4NCj4gPiBXZSBuZWVkIHRvIGRlc2NyaWJlIGluIGRldGFpbCwgYXMgbm90IGV2
ZXJ5b25lIGhhcyB0aGUgc2FtZSBib2FyZCBhcw0KPiA+IHlvdSwgYW5kIHRoZXNlIGJvYXJkcyBt
aWdodCBub3QgZXZlbiBoYXZlIGEgcG93ZXIga2V5IDopDQo+ID4NCj4gPj4gQmVsb3cgaXMgZXhw
ZXJpbWVudCBJIGRpZDoNCj4gPj4gCUZpcnN0bHksIGRvIGEgaGFja2luZyB0byBsZXQgQ0FOIHN0
dWNrIGludG8gc3RvcCBtb2RlLCB0aGVuOg0KPiA+DQo+ID4gWW91IG1lYW4geW91IHB1dCB0aGUg
Q0FOIGludG8gc3RvcCBtb2RlIHdpdGhvdXQga2VlcGluZyB0cmFjayBpbiB0aGUNCj4gPiBDQU4g
ZHJpdmVyIHRoYXQgdGhlIENBTi1JUCBpcyBpbiBzdG9wIG1vZGUsIGUuZy4gYnkgaGFja2luZyB0
aGUgZHJpdmVyLg0KPiA+DQo+ID4gVGhlbiB5b3UgdHJ5IHNldmVyYWwgbWV0aG9kcyB0byByZWNv
dmVyOg0KPiA+DQo+ID4+IAkoMSkgcHJlc3MgcG93ZXIgb24vb2ZmIGtleSwgZ2V0IENBTiBvdXQg
b2Ygc3RvcCBtb2RlOw0KPiA+PiAJKDIpIHJlYm9vdCBjb21tYW5kIGZyb20gY29uc29sZSwgZ2V0
IENBTiBvdXQgb2Ygc3RvcCBtb2RlOw0KPiA+PiAJKDMpIHVuYmluZC9iaW5kIGRyaXZlciwgY2Fu
bm90IGdldCBDQU4gb3V0IG9mIHN0b3AgbW9kZTsNCj4gPj4gCSg0KSByZW1vZC9pbnNtb2QgbW9k
dWxlLCBjYW5ub3QgZ2V0IENBTiBvdXQgb2Ygc3RvcCBtb2RlOw0KPiA+DQo+ID4gKDIpIHJlc2V0
cyB0aGUgY29tcGxldGUgaW14LCBpbmNsdWRpbmcgdGhlIENBTi1JUCBjb3JlLCAoMSkgcHJvYmFi
bHksIHRvby4NCj4gTm8sIGlmIHRoZSBDQU4tSVAgY29yZSBpcyBpbiBzdG9wLW1vZGUgaXQgd2ls
bCBzdGF5IHRoYXQgd2F5IGV2ZW4gYWZ0ZXIgYSByZWJvb3QNCj4gZnJvbSB0aGUgY29uc29sZS4N
Cj4gQXQgbGVhc3QgaXQncyB3aGF0IHdlIGFyZSBzZWVpbmcgaW4gdGhlIGZpZWxkLg0KPiANCj4g
VGhpcyBjb3VsZCBiZSBiZWNhdXNlIHdlIGFyZSBtaXNzaW5nIGEgd2lyZSBmcm9tIHRoZSB3YXRj
aGRvZyBvdXQgdG8gdGhlDQo+IFJFU0VUQk1DVS9QV1JPTiBvbiB0aGUgUE1JQy4NCj4gQnV0IGkg
Z3Vlc3MgYSBjaGVjayBmb3IgaWYgdGhlIENBTi1JcCBpcyBpbiBzdG9wLW1vZGUgZG9lc24ndCBo
dXJ0IGFueXRoaW5nIDopDQpIaSBTZWFuLA0KDQpBdCBteSBzaWRlLCBib3RoIFBvd2VyLU9uLVJl
c2V0IGFuZCByZWJvb3QgZnJvbSBjb25zb2xlIGNhbiBnZXQgQ0FOLUlQIG91dCBvZiBzdG9wIG1v
ZGUsIEhXIGlzIGkuTVg3RC1TREIvaS5NWDhRWFAtbWVrLg0KSSB0aGluayBIVyBkZXNpZ24gY291
bGQgbWFrZSBkaWZmZXJlbmNlLg0KDQpXZSBtb3JlIGNhcmUgYWJvdXQgaG93IGRvZXMgQ0FOLUlQ
IHN0dWNrIGluIHN0b3AgbW9kZSwgY291bGQgeW91IHBsZWFzZSBleHBsYWluIGluIGRldGFpbHM/
IFdlIHdhbnQgZmlndXJlIG91dCB0aGUgcm9vdCBjYXVzZS4NCg0KPiAvU2Vhbg0K
