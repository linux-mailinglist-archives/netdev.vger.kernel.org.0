Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D75C1F035C
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390354AbfKEQqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:46:38 -0500
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:62639
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390333AbfKEQqi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 11:46:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i9B+MNY9seoQXLzF750P2dDVSQHuLxe46Of8ZLJylclR262czemywdgWwW2+qoFr5nCoUWaL9ypKQxq9Yb4VNTcEFshCFUwIxVBq57uvSl1lS2yqKEE5ge9UYm8syTePgpguPfeEmXbxUxhshu2q7aUYzp0oGre+/8FlJxbs0MWVVGGrdPb7KCOA5IAxPXP/UqhE5rlNH6XQ0htPm6eY6COwB1anbf0FvZFLEtpLMnSvGtW5ZyqbW2l72HUB90gJ32/xlXXBLWv5Oc/9dPMx3tkAPbRm2ELjOkrLdFs5fAjU2Tc60kCGBir+6hs7q5J5njz7YHBL2l3Q/26Uq/DwRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K8Uo1kEDw2LDUUHbDRPE6MoHeDFMmsA5HlSTjnTzjis=;
 b=Udr5vzA+UL1AGDsF2etgIYe/4ovaPbXoSOZnJQtyWzp8CIbFZW62gbLEZw2aoXFFROZAhoiSLwn+Q3P2/P+/Uw03SH2VCP1HXYi4W/+9La5jACisYD/O4XGqJ04WkjBdyaMOhW6P4z+n80iJFkXaVvVrPDeyAxp6G5Mz+UvnogaDdu7JEpi5SYETa92FDIMK6CG13EBDKc1lQeJ0J9Xmp6f7Fqs7t8UcaOH9wrWp1Gs1SNEwMrlcMkkSIFcy88cjZJGjhXWrDadia8c/NrHOJJau65NKk8pGJFBmoqV9spvIeuAQLDW9o2ZrKJCYxdngStIxior9X45B8w1ZILY9sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K8Uo1kEDw2LDUUHbDRPE6MoHeDFMmsA5HlSTjnTzjis=;
 b=Yc3RBX++1UaiJT0Iqwob8tIQH0gr8GG6KMmjvnNTys5Z0oIKNfSfdqnD0/nAr8YKfT0zPzrIyYMzT37oZF/ue2tTnF8nSJaYcAjOy6rJgQF0gtousKIF119imjRGW98S0ouDmIo/sZnqLXO+Bw/s0/aaIoFcWt0G0T7xkGV1mOk=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3741.eurprd04.prod.outlook.com (52.134.12.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 16:46:30 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::5dd6:297c:51e5:2b52]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::5dd6:297c:51e5:2b52%7]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 16:46:30 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Chuhong Yuan <hslester96@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] net: fec: add missed clk_disable_unprepare in
 remove
Thread-Topic: [EXT] [PATCH] net: fec: add missed clk_disable_unprepare in
 remove
Thread-Index: AQHVkyeLajpiMEtWy0a0Faj4h+gvxqd7yAhwgADukoCAABOSYA==
Date:   Tue, 5 Nov 2019 16:46:30 +0000
Message-ID: <VI1PR0402MB36008CCD634F6E320EED733EFF7E0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20191104155000.8993-1-hslester96@gmail.com>
 <VI1PR0402MB36006B7BEAA7F4BCB9278598FF7E0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CANhBUQ26kCOGJvQn2Hg9HTyZPZi5ZOcOhAsfBCUvJhU-TSM_7w@mail.gmail.com>
In-Reply-To: <CANhBUQ26kCOGJvQn2Hg9HTyZPZi5ZOcOhAsfBCUvJhU-TSM_7w@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5f996fd2-1e5f-46a0-1645-08d7620fb590
x-ms-traffictypediagnostic: VI1PR0402MB3741:
x-microsoft-antispam-prvs: <VI1PR0402MB3741C9F8DEB3AEFFCDD08A47FF7E0@VI1PR0402MB3741.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(396003)(366004)(376002)(199004)(189003)(81156014)(4326008)(186003)(71190400001)(8936002)(6916009)(486006)(446003)(6506007)(52536014)(5660300002)(74316002)(53546011)(55016002)(102836004)(76176011)(7736002)(86362001)(305945005)(33656002)(6436002)(81166006)(7696005)(8676002)(229853002)(25786009)(66446008)(66476007)(99286004)(66946007)(71200400001)(6116002)(76116006)(64756008)(66556008)(11346002)(2906002)(3846002)(9686003)(6246003)(478600001)(26005)(54906003)(316002)(14444005)(476003)(1411001)(256004)(66066001)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3741;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TPxlpT9vF2Oqk+Hy+DwH9YajtBZa0C49UVBYEvq1Kg71NZYDWxM0Jj82NtwECR2+vLlM9sW17fwXjx50kCGDhBKbdetLuCCj6MZgaerbYsRQKqAACS4AWdhBc+x1vY/M7yl0w1hqZi9l5yJFKM1tw5+T7gIHE8sY0O1nJAmW31FG3i/8AkSiiE+HVGiT9EZ2N6n+7EJHrTuBSUfGlCZZP00pFRO5MGBVFZgWdudboTnHGKnaAzaS+xWkefzoq7ajkngHLfnCxDuNJcIU6LuzUjVG7IfRXqZYxuAUX3r00E3fECMfuyYQYTuuCJNq5ayDG1+dlLcqfjC27XcS6AoWFaVXxci3OJDay9jcZEVsfZhf5/T6TkzMZA5BbcrWogl6qJ9VQJZqyMueSOg/FOCwxz8SFYAxZmSO0ry0XTvyL5B8dry6AP5E0ImSxdDloyT6
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f996fd2-1e5f-46a0-1645-08d7620fb590
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 16:46:30.5695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n3h+O8wJILkPJxhxx5B/fgssVucFFwHGDtVX6Qk6juS+w1EvhDvzMfAk7WsiBG6kxv4KeKwENmuGsNC8nCZtwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3741
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2h1aG9uZyBZdWFuIDxoc2xlc3Rlcjk2QGdtYWlsLmNvbT4gU2VudDogVHVlc2RheSwg
Tm92ZW1iZXIgNSwgMjAxOSAxMTozNCBQTQ0KPiBPbiBUdWUsIE5vdiA1LCAyMDE5IGF0IDk6MjYg
QU0gQW5keSBEdWFuIDxmdWdhbmcuZHVhbkBueHAuY29tPiB3cm90ZToNCj4gPg0KPiA+IEZyb206
IENodWhvbmcgWXVhbiA8aHNsZXN0ZXI5NkBnbWFpbC5jb20+IFNlbnQ6IE1vbmRheSwgTm92ZW1i
ZXIgNCwNCj4gPiAyMDE5IDExOjUwIFBNDQo+ID4gPiBUaGlzIGRyaXZlciBmb3JnZXRzIHRvIGRp
c2FibGUgYW5kIHVucHJlcGFyZSBjbGtzIHdoZW4gcmVtb3ZlLg0KPiA+ID4gQWRkIGNhbGxzIHRv
IGNsa19kaXNhYmxlX3VucHJlcGFyZSB0byBmaXggaXQuDQo+ID4gPg0KPiA+ID4gU2lnbmVkLW9m
Zi1ieTogQ2h1aG9uZyBZdWFuIDxoc2xlc3Rlcjk2QGdtYWlsLmNvbT4NCj4gPg0KPiA+IElmIHJ1
bnRpbWUgaXMgZW5hYmxlZCwgdGhlIHBhdGNoIHdpbGwgaW50cm9kdWNlIGNsb2NrIGNvdW50IG1p
cy1tYXRjaC4NCj4gPiBQcm9iZS0+DQo+ID4gICAgIEVuYWJsZSBjbGtfaXBnLCBjbGtfYWhiIGNs
b2Nrcw0KPiA+ICAgICAuLi4NCj4gPiAgICAgSW4gdGhlIGVuZCwgcnVudGltZSBhdXRvIHN1c3Bl
bmQgY2FsbGJhY2sgZGlzYWJsZSBjbGtfaXBnLCBjbGtfYWhiDQo+IGNsb2Nrcy4NCj4gPg0KPiA+
IFlvdSBzaG91bGQgY2hlY2sgQ09ORklHX1BNIGlzIGVuYWJsZWQgb3Igbm90IGluIHlvdXIgcGxh
dGZvcm0sIGlmIG5vdCwNCj4gPiBpdCBjYW4gZGlzYWJsZSB0aGVzZSB0d28gY2xvY2tzIGJ5IGNo
ZWNraW5nIENPTkZJR19QTS4NCj4gPg0KPiANCj4gVGhhbmtzIGZvciB5b3VyIGhpbnQhDQo+IEJ1
dCBJIGFtIHN0aWxsIG5vdCB2ZXJ5IGNsZWFyIGFib3V0IHRoZSBtZWNoYW5pc20uDQo+IEluIG15
IG9waW5pb24sIGl0IG1lYW5zIHRoYXQgaWYgQ09ORklHX1BNIGlzIGRpc2FibGVkLCBydW50aW1l
X3N1c3BlbmQgd2lsbA0KPiBiZSBjYWxsZWQgYXV0b21hdGljYWxseSB0byBkaXNhYmxlIGNsa3Mu
DQpDT05GSUdfUE0gaXMgZW5hYmxlZCwgcnVudGltZSBwbSB3b3Jrcy4gT3RoZXJ3aXNlLCBpdCBk
b2Vzbid0IHdvcmssIHRoZW4gaXQNClJlcXVpcmVzIC5yZW1vdmUoKSB0byBkaXNhYmxlIHRoZSBj
bGtzLg0KDQpBbmR5DQo+IFRoZXJlZm9yZSwgI2lmZGVmIENPTkZJR19QTSBjaGVjayBzaG91bGQg
YmUgYWRkZWQgYmVmb3JlIGRpc2FibGluZyBjbGtzIGluDQo+IHJlbW92ZS4NCj4gSSBhbSBub3Qg
c3VyZSB3aGV0aGVyIHRoaXMgdW5kZXJzdGFuZGluZyBpcyByaWdodCBvciBub3Q/DQo+IA0KPiBS
ZWdhcmRzLA0KPiBDaHVob25nDQo+IA0KPiA+IFJlZ2FyZHMsDQo+ID4gQW5keQ0KPiA+ID4gLS0t
DQo+ID4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMgfCAyICsr
DQo+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KPiA+ID4NCj4gPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiA+
ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiA+ID4gaW5k
ZXggMjJjMDFiMjI0YmFhLi5hOWMzODZiNjM1ODEgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiA+ID4gKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMNCj4gPiA+IEBAIC0zNjQ1LDYgKzM2NDUs
OCBAQCBmZWNfZHJ2X3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiA+ID4g
ICAgICAgICAgICAgICAgIHJlZ3VsYXRvcl9kaXNhYmxlKGZlcC0+cmVnX3BoeSk7DQo+ID4gPiAg
ICAgICAgIHBtX3J1bnRpbWVfcHV0KCZwZGV2LT5kZXYpOw0KPiA+ID4gICAgICAgICBwbV9ydW50
aW1lX2Rpc2FibGUoJnBkZXYtPmRldik7DQo+ID4gPiArICAgICAgIGNsa19kaXNhYmxlX3VucHJl
cGFyZShmZXAtPmNsa19haGIpOw0KPiA+ID4gKyAgICAgICBjbGtfZGlzYWJsZV91bnByZXBhcmUo
ZmVwLT5jbGtfaXBnKTsNCj4gPiA+ICAgICAgICAgaWYgKG9mX3BoeV9pc19maXhlZF9saW5rKG5w
KSkNCj4gPiA+ICAgICAgICAgICAgICAgICBvZl9waHlfZGVyZWdpc3Rlcl9maXhlZF9saW5rKG5w
KTsNCj4gPiA+ICAgICAgICAgb2Zfbm9kZV9wdXQoZmVwLT5waHlfbm9kZSk7DQo+ID4gPiAtLQ0K
PiA+ID4gMi4yMy4wDQo+ID4NCg==
