Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2953191FA6
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 04:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgCYDUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 23:20:54 -0400
Received: from mail-am6eur05on2081.outbound.protection.outlook.com ([40.107.22.81]:6199
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727253AbgCYDUy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 23:20:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUCoxliu59yNxmiKKoAzylpmMbxcsjW4vB4gHa2PHMQwz119i5g9kXPgnik8H1fTqYQZCdEiSuBu60jFGrmtyrOwZlmjaFe6diQz7o21DhZ38vsN6AXSbDJlN78Fzip6wJDKn1Ao/nLBnAIOjyuGxngrzjHLlApkoysaVjrYMAOloX+F9lYDzg05D9byMR/rG655l6eKiYwuHG0KDlVwGNP2jk8lmyhGD6286g9V5NNBOsb57W8l4xDDrXX2vYFKl7T/E0Rp+RVRV3i69qJ8+wISJLNXVm01hBBtqBouGgst1+TosRl/tGAda/Iej/NGtzGxC/ko8crCkxjqHw6t9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7XaG7NhVvGfaxAcVW7QIp4vxdpH7wNG91mqEcuWTh8Y=;
 b=T1LW/uBTh7O8qMzMsYs7wVVJeK6+rqTWBh3jfqrEWSIe934iOKEsk/0kUa3w+TLqzlKoSbiAkXOabphuxRNSfCZstfHevk3BfSn3zt2ZsSY2BH1OjalWWJxMwjK81iJFZbTcswj50t0USbX4N/sxjyc2H04kOCOexURk6nDdoZQV7V9rjaom4ruZtdpRFffdvEfqCYKMH8922COhTZJPfnTs4K4rpO6jBJMKp4/rks6r1hs6heCTQ9hxFT9KFEbnsqTSrOuETGA376Rhta1Pb0OiSvt5gVZZKbEc0oAf39DqwOQAi28xaKed6g+DW6qFBjnmdB1sC9jfoxkCeLdcaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7XaG7NhVvGfaxAcVW7QIp4vxdpH7wNG91mqEcuWTh8Y=;
 b=Nlajya1HX5v+s8unPh0ZiYazOCrGYSwuX3f4hZUKev5tmF0tqyOosOv/SvLgAV02lgPW7nvRnI+5ODLCmpOIbtJNFDUs3QdJUH2wRbZ5oMMNE6ogIxn4+/GAs+qeZ4DBh9CEG+ouTnPW7BbQLe/RNCM6ikb1NEiQHpGvXq08wwM=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (10.141.174.88) by
 AM7PR04MB7190.eurprd04.prod.outlook.com (52.135.56.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Wed, 25 Mar 2020 03:20:50 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::dcc0:6a0:c64b:9f94%2]) with mapi id 15.20.2835.021; Wed, 25 Mar 2020
 03:20:50 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
Thread-Topic: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
Thread-Index: AQHV/qQWBIiKj5A/T0WD8BjMeGVxRqhRd2EAgAW7PoCAAI3mAIAA5+3A
Date:   Wed, 25 Mar 2020 03:20:50 +0000
Message-ID: <AM7PR04MB6885C1550F684EA4107F9C75F8CE0@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
 <20200320103726.32559-7-yangbo.lu@nxp.com>
 <CA+h21hoBwDuWCFbO70u1FAERB8zc5F+H5URBkn=2_bpRRRz1oA@mail.gmail.com>
 <AM7PR04MB6885A8C98CA60FC435024647F8F10@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20200324131952.GB18149@localhost>
In-Reply-To: <20200324131952.GB18149@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.68.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a3874106-7fc3-4e00-a95b-08d7d06b84fb
x-ms-traffictypediagnostic: AM7PR04MB7190:|AM7PR04MB7190:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB7190D7069D6416B30C83566CF8CE0@AM7PR04MB7190.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0353563E2B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(33656002)(7416002)(5660300002)(966005)(478600001)(8676002)(86362001)(45080400002)(52536014)(66946007)(66476007)(76116006)(66556008)(64756008)(66446008)(6916009)(186003)(2906002)(81166006)(81156014)(7696005)(71200400001)(26005)(9686003)(8936002)(55016002)(54906003)(53546011)(6506007)(316002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR04MB7190;H:AM7PR04MB6885.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zS0S1VoP+ORWtXp+otEl+NdyDbia37nrjPJ+6FJqNg2HSeCnvtESS5amcqJbmqsUhUaD2iHJQhryrPiZT/ldsgEc0YJgw/8ZBWy0/ZQP7ZMNHd7NEYFa6LVpPiOLY9h8S3JlL6IHprUOB6rzEIq5ZXDJ9Q/YJ5ZVxel39ALOtjZZhZfE7dsKBlfLNpQdbVnLSbv38lrwmC+IXGPeb8L6w0thhltnnl7NxP19UFH5cxg2u3epIoBnM7PmcDY3Id7aeo/cbtYX7bxJego999d+FXBWhsNTGpt1jQDb9Q/gwpC7az/qYyXtW/9BFKLDausDhPsF9c7HznEqKxUz2gjJgKtiJlUH63xsXxtiwMf9boY63PJh3R4N1ARMvAFP8f92/sYMDzoRJjxHQsg5z0BxEZPr4wBywgXQD8ytzish8qs1bc1sJKXjPZq+D2EUIUDVLCq7qtwwVppwW+iMJECSkZcWkPevYtMqO2IKAp3fTvO7X3fa3hdslIbjIql6hG3h+2t38XoyX4OpcC0HwbRRVg==
x-ms-exchange-antispam-messagedata: +IEAjKmnHlm7VpKHobB4YoIzHzYotv/T6mJwLtL3b5F9TKuvB1M3T3zjeLAyZO4ZIhsG9FWqhykGBQCWH9eXNxoH+ckWH28FnKqGSh2AeMcbtlMjPNTC3ylAZX8c4yr38trudkQzog5ZoZ/9ONqkqw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3874106-7fc3-4e00-a95b-08d7d06b84fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2020 03:20:50.6272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7It1/dIMRXRs0UXjQTOIj/u/1i49d+1TVTw/tKG34XH6chnLbCGU+isGoyx55QHcBS8HPerh0OEIIbDM7BzFpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7190
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNoYXJkIENvY2hyYW4gPHJp
Y2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2VudDogVHVlc2RheSwgTWFyY2ggMjQsIDIwMjAg
OToyMCBQTQ0KPiBUbzogWS5iLiBMdSA8eWFuZ2JvLmx1QG54cC5jb20+DQo+IENjOiBWbGFkaW1p
ciBPbHRlYW4gPG9sdGVhbnZAZ21haWwuY29tPjsgbGttbA0KPiA8bGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZz47IG5ldGRldiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IERhdmlkIFMgLg0K
PiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBWbGFkaW1pciBPbHRlYW4gPHZsYWRpbWly
Lm9sdGVhbkBueHAuY29tPjsNCj4gQ2xhdWRpdSBNYW5vaWwgPGNsYXVkaXUubWFub2lsQG54cC5j
b20+OyBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+Ow0KPiBWaXZpZW4gRGlkZWxvdCA8dml2
aWVuLmRpZGVsb3RAZ21haWwuY29tPjsgRmxvcmlhbiBGYWluZWxsaQ0KPiA8Zi5mYWluZWxsaUBn
bWFpbC5jb20+OyBBbGV4YW5kcmUgQmVsbG9uaSA8YWxleGFuZHJlLmJlbGxvbmlAYm9vdGxpbi5j
b20+Ow0KPiBNaWNyb2NoaXAgTGludXggRHJpdmVyIFN1cHBvcnQgPFVOR0xpbnV4RHJpdmVyQG1p
Y3JvY2hpcC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggNi82XSBwdHBfb2NlbG90OiBzdXBw
b3J0IDQgcHJvZ3JhbW1hYmxlIHBpbnMNCj4gDQo+IE9uIFR1ZSwgTWFyIDI0LCAyMDIwIGF0IDA1
OjIxOjI3QU0gKzAwMDAsIFkuYi4gTHUgd3JvdGU6DQo+ID4gSW4gbXkgb25lIHByZXZpb3VzIHBh
dGNoLCBJIHdhcyBzdWdnZXN0ZWQgdG8gaW1wbGVtZW50IFBQUyB3aXRoDQo+IHByb2dyYW1tYWJs
ZSBwaW4gcGVyaW9kaWMgY2xvY2sgZnVuY3Rpb24uDQo+ID4gQnV0IEkgZGlkbuKAmXQgZmluZCBo
b3cgc2hvdWxkIFBQUyBiZSBpbXBsZW1lbnRlZCB3aXRoIHBlcmlvZGljIGNsb2NrDQo+IGZ1bmN0
aW9uIGFmdGVyIGNoZWNraW5nIHB0cCBkcml2ZXIuDQo+ID4NCj4gaHR0cHM6Ly9ldXIwMS5zYWZl
bGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJGcGF0Y2h3DQo+
IG9yay5vemxhYnMub3JnJTJGcGF0Y2glMkYxMjE1NDY0JTJGJmFtcDtkYXRhPTAyJTdDMDElN0N5
YW5nYm8ubHUNCj4gJTQwbnhwLmNvbSU3Q2JmZGJkMjA5YWUwMTRjZDg0ODRiMDhkN2NmZjYwYzEz
JTdDNjg2ZWExZDNiYzJiNGM2DQo+IGZhOTJjZDk5YzVjMzAxNjM1JTdDMCU3QzAlN0M2MzcyMDY1
Mjc5ODExOTExNjEmYW1wO3NkYXRhPW95OW0NCj4gVCUyQmw2OUglMkJtcHpNOVQya1BYUU5TTW01
dyUyRm93TGh6emlVSlgyZ1pjJTNEJmFtcDtyZXNlcnYNCj4gZWQ9MA0KPiANCj4gWWVzLCBmb3Ig
Z2VuZXJhdGluZyBhIDEtUFBTIG91dHB1dCB3YXZlZm9ybSwgdXNlcnMgY2FsbCBpb2N0bA0KPiBQ
VFBfQ0xLX1JFUV9QRVJPVVQgd2l0aCBwdHBfcGVyb3V0X3JlcXVlc3QucGVyaW9kPXsxLDB9Lg0K
PiANCj4gSWYgeW91ciBkZXZpY2UgY2FuJ3QgY29udHJvbCB0aGUgc3RhcnQgdGltZSwgdGhlbiBp
dCBjYW4gYWNjZXB0IGFuDQo+IHVuc3BlY2lmaWVkIHRpbWUgb2YgcHRwX3Blcm91dF9yZXF1ZXN0
LnN0YXJ0PXswLDB9Lg0KDQpHZXQgaXQuIFRoYW5rcyBhIGxvdC4NCg0KPiANCj4gPiBWbGFkaW1p
ciB0YWxrZWQgd2l0aCBtZSwgZm9yIHRoZSBzcGVjaWFsIFBQUyBjYXNlLCB3ZSBtYXkgY29uc2lk
ZXIsDQo+ID4gaWYgKHJlcS5wZXJvdXQucGVyaW9kLnNlYyA9PTEgJiYgcmVxLnBlcm91dC5wZXJp
b2QubnNlYyA9PSAwKSBhbmQgY29uZmlndXJlDQo+IFdBVkVGT1JNX0xPVyB0byBiZSBlcXVhbCB0
byByZXFfcGVyb3V0LnN0YXJ0Lm5zZWMuDQo+ID4NCj4gPiBSaWNoYXJkLCBkbyB5b3UgdGhpbmsg
aXMgaXQgb2s/DQo+IA0KPiBTb3VuZCBva2F5IHRvIG1lIChidXQgSSBkb24ndCBrbm93IGFib3V0
IFdBVkVGT1JNX0xPVykuDQoNClNvcnJ5LiBJIHNob3VsZCBoYXZlIGV4cGxhaW4gbW9yZS4gVGhl
cmUgaXMgYSBTWU5DIGJpdCBpbiBPY2Vsb3QgUFRQIGhhcmR3YXJlIGZvciBQUFMgZ2VuZXJhdGlv
bi4NCldBRkVGT1JNX0xPVyByZWdpc3RlciBjb3VsZCBiZSB1c2VkIHRvIGFkanVzdCBwaGFzZS4N
Cg0KUk0gc2F5cywNCiJGb3IgdGhlIENMT0NLIGFjdGlvbiwgdGhlIHN5bmMgb3B0aW9uIG1ha2Vz
IHRoZSBwaW4gZ2VuZXJhdGUgYSBzaW5nbGUgcHVsc2UsIDxXQUZFRk9STV9MT1c+DQpuYW5vc2Vj
b25kcyBhZnRlciB0aGUgdGltZSBvZiBkYXkgaGFzIGluY3JlYXNlZCB0aGUgc2Vjb25kcy4gVGhl
IHB1bHNlIHdpbGwgZ2V0IGEgd2lkdGggb2YNCjxXQVZFRk9STV9ISUdIPiBuYW5vc2Vjb25kcy4i
DQoNClRoZW4gSSB3aWxsIGFkZCBQUFMgY2FzZSBpbiBuZXh0IHZlcnNpb24gcGF0Y2guDQpUaGFu
a3MuDQoNCj4gDQo+ID4gQW5kIGFub3RoZXIgcHJvYmxlbSBJIGFtIGZhY2luZyBpcywgaW4gLmVu
YWJsZSgpIGNhbGxiYWNrDQo+IChQVFBfQ0xLX1JFUV9QRVJPVVQgcmVxdWVzdCkgSSBkZWZpbmVk
Lg0KPiA+ICAgICAgICAgICAgICAgICAvKg0KPiA+ICAgICAgICAgICAgICAgICAgKiBUT0RPOiBz
dXBwb3J0IGRpc2FibGluZyBmdW5jdGlvbg0KPiA+ICAgICAgICAgICAgICAgICAgKiBXaGVuIHB0
cF9kaXNhYmxlX3BpbmZ1bmMoKSBpcyB0byBkaXNhYmxlIGZ1bmN0aW9uLA0KPiA+ICAgICAgICAg
ICAgICAgICAgKiBpdCBoYXMgYWxyZWFkeSBoZWxkIHBpbmNmZ19tdXguDQo+ID4gICAgICAgICAg
ICAgICAgICAqIEhvd2V2ZXIgcHRwX2ZpbmRfcGluKCkgaW4gLmVuYWJsZSgpIGNhbGxlZCBhbHNv
IG5lZWRzDQo+ID4gICAgICAgICAgICAgICAgICAqIHRvIGhvbGQgcGluY2ZnX211eC4NCj4gPiAg
ICAgICAgICAgICAgICAgICogVGhpcyBjYXVzZXMgZGVhZCBsb2NrLiBTbywganVzdCByZXR1cm4g
Zm9yIGZ1bmN0aW9uDQo+ID4gICAgICAgICAgICAgICAgICAqIGRpc2FibGluZywgYW5kIHRoaXMg
bmVlZHMgZml4LXVwLg0KPiA+ICAgICAgICAgICAgICAgICAgKi8NCj4gPiBIb3BlIHNvbWUgc3Vn
Z2VzdGlvbnMgaGVyZS4NCj4gDQo+IFNlZSBteSByZXBseSB0byB0aGUgcGF0Y2guDQo+IA0KPiBU
aGFua3MsDQo+IFJpY2hhcmQNCg==
