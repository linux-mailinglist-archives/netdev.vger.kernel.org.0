Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A001B5324
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 05:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgDWDaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 23:30:04 -0400
Received: from mail-eopbgr30061.outbound.protection.outlook.com ([40.107.3.61]:54233
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726002AbgDWDaD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 23:30:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bh02M8O3ec/9AsfhGe0jU8bSQoOu4R2ALH4cH935df3+WzWQgzQkQWZYWmBaoOcT6II6oZ9Bv1VW7Ya3gv0Vpjtqm2iQxa0tKDjU+I5XNlZRHdOHHDU2k9HtWjrAdMIO8MMM1sHvkhEQ6HqA2ZbkV4mH5W+oeEZu1EqscqBxtnNowlcAi/OsBYqLFFPw+s5+uF4SM0J/f24P9jE/XdKteoOBk/X8zbbETqcXtPARgGWSr8MZ5TUrPM5wfGk4K/TOteCJCIw4abUM7FBu7SziJwjU2Om6t3Bicj7Cx45OxlOiULNC8YsDN+NS987CbUmLW+lpLto4OuSm5nl+5FM4QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnuIDcjuMZBUuyZo/KQgZpwgkNTgjXXp+bJI42t2Tgk=;
 b=c6VzJYZ0OW6lRbIKkJoqS2jog/f7E3XTolDXq7SVSADFvoVWxzxWeiUR3IYMqoEiO0w958D9N2FNAlcVaJInwYpdAjCQMJU+S58DdDKmswq8JV/2dnR6/fgf2iO06ddIu5SoHgGcy7l0qd5e8DUAS2UIhW+37sTAX7UWjN89ZQCnJHmR1/hVP09rVIiuAKiFWkaxa7DPmiin+PidZ0BE817wAok+RjKlgrg6CM8tbGdwasDsSMnnZK6VnU725Izg8ww9owre/+f5KyOjeC1WvSp8dIrZUA5LMfjgxZ7fj/lOVv8juuTZXo7UarUQPYWV0qQHPQbhF1EOQ8zw2kTLAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnuIDcjuMZBUuyZo/KQgZpwgkNTgjXXp+bJI42t2Tgk=;
 b=h15ij1T395YNWcSTbi/9d0b+dcDPG7tJC6A2DEhhKrvAT8O1qaNcIwJ+63Piy6WUxQNbmjJeWeTlzZqHMIhrUcbO1h/elV9VCCrf1AoMrftWKmfE0v6TRDwakTUsVty0a4U8b4WaV71g4DOSiNkWZG4+yMgLoq44UUb+70dLsUw=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6671.eurprd04.prod.outlook.com (2603:10a6:803:11f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Thu, 23 Apr
 2020 03:29:57 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2921.032; Thu, 23 Apr 2020
 03:29:57 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Dave Taht <dave.taht@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Andre Guedes <andre.guedes@linux.intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: RE: [EXT] Re: [v3,net-next 1/4] net: qos: introduce a gate control
 flow action
Thread-Topic: [EXT] Re: [v3,net-next 1/4] net: qos: introduce a gate control
 flow action
Thread-Index: AQHWGNxDbd5otshFWkyHERcqCXItD6iFkRiAgAB7TiA=
Date:   Thu, 23 Apr 2020 03:29:57 +0000
Message-ID: <VE1PR04MB64962CE93FEF960CC356956392D30@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20200418011211.31725-5-Po.Liu@nxp.com>
 <20200422024852.23224-1-Po.Liu@nxp.com>
 <20200422024852.23224-2-Po.Liu@nxp.com>
 <20200422191910.gacjlviegrjriwcx@ws.localdomain>
 <CA+h21hrZiRq2-8Dx31X_rwgJ2Lkp6eF9H7M3cOyiBAWs0_xxhw@mail.gmail.com>
 <CAA93jw6fAyKHCLGD8vsXXz1yGPwXk5tOzWXDMbbn3z3Kw5P8PA@mail.gmail.com>
In-Reply-To: <CAA93jw6fAyKHCLGD8vsXXz1yGPwXk5tOzWXDMbbn3z3Kw5P8PA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [221.221.133.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: de44c0e7-a78a-4bf4-f8d6-08d7e73698b6
x-ms-traffictypediagnostic: VE1PR04MB6671:|VE1PR04MB6671:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB667113BCAF9437F4F05DA7C392D30@VE1PR04MB6671.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03827AF76E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(7416002)(83080400001)(55016002)(7696005)(53546011)(6506007)(8676002)(9686003)(71200400001)(66574012)(2906002)(33656002)(86362001)(5660300002)(4326008)(45080400002)(966005)(186003)(478600001)(26005)(54906003)(110136005)(81156014)(66556008)(316002)(44832011)(8936002)(66476007)(66946007)(64756008)(76116006)(52536014)(66446008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fe4Ger+R60bsvETFeV2Hj67WChVL6EEsTtlDRAHho4913fzKVFonCjKDIAffPwnipzPWfKq3Ariyow0w4LGYRazUzHu+drVZaEfLDbKCpEfY7zsYzHe/w9JH8uAcOaTRPngbeGZO29/vg8d4bz8C9ubXqS+KTHdfXAYLZ7hzPoNf9UqLaChcPR3c5A9KiPzsqkW1ONsSMJWHq+wUCbJ0XtLO0sBkn5EGqZXp/iVBZmXDxSy71cYZ60eq11BLqh7E//ethnarGPWE2WlP3AiudQvX5xF/bIlvYWJoBpgtQK+J56kyCASKBJZM8NqDcoLB5NnI4BLJzJ53JS94WEfl6fNVlGJt3QSmwuJAdwkfyGVdxQPaCNpaCSunHQCruKvWXfHpxH+O7NEN9ECZ5gCMppZM00Zqb6ErwuzKsrBYSzVFBeMNkiVbAneFUUYza9FVvfRn1k9v5/W9yRX5hwgoZmt4SNhF8tU0o6ryRUOl2BOeiPgTaIWbmx7uQei5m4TlEkQC49XFXYTPuy40+FjFvA==
x-ms-exchange-antispam-messagedata: GSkcRcRb8knDjUnO++KXC+5lsDb9rgQL3lqSPerylmBXPwOCWfTXeL4dIg8AHV0OmYMuwS2nI9UVv5WhzCDU+MpLmgiTOlEVOrnPJV/9ggR+PFGI4Z+I7dBPiRWRu75yYKL1+OhPtHK040o66T4LtQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de44c0e7-a78a-4bf4-f8d6-08d7e73698b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2020 03:29:57.0604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q7t4lC/g0hJY4eWtCi7/uldXww4s1GnG8+mVMrqmpMLsJRJFtYXs6oF7z2Z1C3TK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6671
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2ZSBUaGF0LA0KDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTog
RGF2ZSBUYWh0IDxkYXZlLnRhaHRAZ21haWwuY29tPg0KPiBTZW50OiAyMDIw5bm0NOaciDIz5pel
IDQ6MDYNCj4gVG86IFZsYWRpbWlyIE9sdGVhbiA8b2x0ZWFudkBnbWFpbC5jb20+DQo+IENjOiBB
bGxhbiBXLiBOaWVsc2VuIDxhbGxhbi5uaWVsc2VuQG1pY3JvY2hpcC5jb20+OyBQbyBMaXUNCj4g
PHBvLmxpdUBueHAuY29tPjsgRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pjsg
bGttbCA8bGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+OyBuZXRkZXYgPG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc+OyBWaW5pY2l1cyBDb3N0YQ0KPiBHb21lcyA8dmluaWNpdXMuZ29tZXNA
aW50ZWwuY29tPjsgQ2xhdWRpdSBNYW5vaWwNCj4gPGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBW
bGFkaW1pciBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPjsNCj4gQWxleGFuZHJ1IE1h
cmdpbmVhbiA8YWxleGFuZHJ1Lm1hcmdpbmVhbkBueHAuY29tPjsNCj4gbWljaGFlbC5jaGFuQGJy
b2FkY29tLmNvbTsgdmlzaGFsQGNoZWxzaW8uY29tOyBTYWVlZCBNYWhhbWVlZA0KPiA8c2FlZWRt
QG1lbGxhbm94LmNvbT47IGxlb25Aa2VybmVsLm9yZzsgSmlyaSBQaXJrbw0KPiA8amlyaUBtZWxs
YW5veC5jb20+OyBJZG8gU2NoaW1tZWwgPGlkb3NjaEBtZWxsYW5veC5jb20+OyBBbGV4YW5kcmUN
Cj4gQmVsbG9uaSA8YWxleGFuZHJlLmJlbGxvbmlAYm9vdGxpbi5jb20+OyBNaWNyb2NoaXAgTGlu
dXggRHJpdmVyIFN1cHBvcnQNCj4gPFVOR0xpbnV4RHJpdmVyQG1pY3JvY2hpcC5jb20+OyBKYWt1
YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsNCj4gSmFtYWwgSGFkaSBTYWxpbSA8amhzQG1v
amF0YXR1LmNvbT47IENvbmcgV2FuZw0KPiA8eGl5b3Uud2FuZ2NvbmdAZ21haWwuY29tPjsgc2lt
b24uaG9ybWFuQG5ldHJvbm9tZS5jb207IFBhYmxvDQo+IE5laXJhIEF5dXNvIDxwYWJsb0BuZXRm
aWx0ZXIub3JnPjsgbW9zaGVAbWVsbGFub3guY29tOyBNdXJhbGkNCj4gS2FyaWNoZXJpIDxtLWth
cmljaGVyaTJAdGkuY29tPjsgQW5kcmUgR3VlZGVzDQo+IDxhbmRyZS5ndWVkZXNAbGludXguaW50
ZWwuY29tPjsgU3RlcGhlbiBIZW1taW5nZXINCj4gPHN0ZXBoZW5AbmV0d29ya3BsdW1iZXIub3Jn
Pg0KPiBTdWJqZWN0OiBbRVhUXSBSZTogW3YzLG5ldC1uZXh0IDEvNF0gbmV0OiBxb3M6IGludHJv
ZHVjZSBhIGdhdGUgY29udHJvbCBmbG93DQo+IGFjdGlvbg0KPiANCj4gQ2F1dGlvbjogRVhUIEVt
YWlsDQo+IA0KPiBPbiBXZWQsIEFwciAyMiwgMjAyMCBhdCAxMjozMSBQTSBWbGFkaW1pciBPbHRl
YW4gPG9sdGVhbnZAZ21haWwuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+IEhpIEFsbGFuLA0KPiA+
DQo+ID4gT24gV2VkLCAyMiBBcHIgMjAyMCBhdCAyMjoyMCwgQWxsYW4gVy4gTmllbHNlbg0KPiA+
IDxhbGxhbi5uaWVsc2VuQG1pY3JvY2hpcC5jb20+IHdyb3RlOg0KPiA+ID4NCj4gPiA+IEhpIFBv
LA0KPiA+ID4NCj4gPiA+IE5pY2UgdG8gc2VlIGV2ZW4gbW9yZSB3b3JrIG9uIHRoZSBUU04gc3Rh
bmRhcmRzIGluIHRoZSB1cHN0cmVhbQ0KPiBrZXJuZWwuDQo+ID4gPg0KPiA+ID4gT24gMjIuMDQu
MjAyMCAxMDo0OCwgUG8gTGl1IHdyb3RlOg0KPiA+ID4gPkVYVEVSTkFMIEVNQUlMOiBEbyBub3Qg
Y2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91DQo+ID4gPiA+a25vdyB0
aGUgY29udGVudCBpcyBzYWZlDQo+ID4gPiA+DQo+ID4gPiA+SW50cm9kdWNlIGEgaW5ncmVzcyBm
cmFtZSBnYXRlIGNvbnRyb2wgZmxvdyBhY3Rpb24uDQo+ID4gPiA+VGMgZ2F0ZSBhY3Rpb24gZG9l
cyB0aGUgd29yayBsaWtlIHRoaXM6DQo+ID4gPiA+QXNzdW1lIHRoZXJlIGlzIGEgZ2F0ZSBhbGxv
dyBzcGVjaWZpZWQgaW5ncmVzcyBmcmFtZXMgY2FuIGJlIHBhc3NlZA0KPiA+ID4gPmF0IHNwZWNp
ZmljIHRpbWUgc2xvdCwgYW5kIGJlIGRyb3BwZWQgYXQgc3BlY2lmaWMgdGltZSBzbG90LiBUYw0K
PiA+ID4gPmZpbHRlciBjaG9vc2VzIHRoZSBpbmdyZXNzIGZyYW1lcywgYW5kIHRjIGdhdGUgYWN0
aW9uIHdvdWxkIHNwZWNpZnkNCj4gPiA+ID53aGF0IHNsb3QgZG9lcyB0aGVzZSBmcmFtZXMgY2Fu
IGJlIHBhc3NlZCB0byBkZXZpY2UgYW5kIHdoYXQgdGltZQ0KPiA+ID4gPnNsb3Qgd291bGQgYmUg
ZHJvcHBlZC4NCj4gPiA+ID5UYyBnYXRlIGFjdGlvbiB3b3VsZCBwcm92aWRlIGFuIGVudHJ5IGxp
c3QgdG8gdGVsbCBob3cgbXVjaCB0aW1lDQo+ID4gPiA+Z2F0ZSBrZWVwIG9wZW4gYW5kIGhvdyBt
dWNoIHRpbWUgZ2F0ZSBrZWVwIHN0YXRlIGNsb3NlLiBHYXRlDQo+IGFjdGlvbg0KPiA+ID4gPmFs
c28gYXNzaWduIGEgc3RhcnQgdGltZSB0byB0ZWxsIHdoZW4gdGhlIGVudHJ5IGxpc3Qgc3RhcnQu
IFRoZW4NCj4gPiA+ID5kcml2ZXIgd291bGQgcmVwZWF0IHRoZSBnYXRlIGVudHJ5IGxpc3QgY3lj
bGljYWxseS4NCj4gPiA+ID5Gb3IgdGhlIHNvZnR3YXJlIHNpbXVsYXRpb24sIGdhdGUgYWN0aW9u
IHJlcXVpcmVzIHRoZSB1c2VyIGFzc2lnbiBhDQo+ID4gPiA+dGltZSBjbG9jayB0eXBlLg0KPiA+
ID4gPg0KPiA+ID4gPkJlbG93IGlzIHRoZSBzZXR0aW5nIGV4YW1wbGUgaW4gdXNlciBzcGFjZS4g
VGMgZmlsdGVyIGEgc3RyZWFtDQo+ID4gPiA+c291cmNlIGlwIGFkZHJlc3MgaXMgMTkyLjE2OC4w
LjIwIGFuZCBnYXRlIGFjdGlvbiBvd24gdHdvIHRpbWUNCj4gPiA+ID5zbG90cy4gT25lIGlzIGxh
c3QgMjAwbXMgZ2F0ZSBvcGVuIGxldCBmcmFtZSBwYXNzIGFub3RoZXIgaXMgbGFzdA0KPiA+ID4g
PjEwMG1zIGdhdGUgY2xvc2UgbGV0IGZyYW1lcyBkcm9wcGVkLiBXaGVuIHRoZSBmcmFtZXMgaGF2
ZSBwYXNzZWQNCj4gPiA+ID50b3RhbCBmcmFtZXMgb3ZlciA4MDAwMDAwIGJ5dGVzLCBmcmFtZXMg
d2lsbCBiZSBkcm9wcGVkIGluIG9uZQ0KPiAyMDAwMDAwMDBucyB0aW1lIHNsb3QuDQo+ID4gPiA+
DQo+ID4gPiA+PiB0YyBxZGlzYyBhZGQgZGV2IGV0aDAgaW5ncmVzcw0KPiA+ID4gPg0KPiA+ID4g
Pj4gdGMgZmlsdGVyIGFkZCBkZXYgZXRoMCBwYXJlbnQgZmZmZjogcHJvdG9jb2wgaXAgXA0KPiA+
ID4gPiAgICAgICAgICAgZmxvd2VyIHNyY19pcCAxOTIuMTY4LjAuMjAgXA0KPiA+ID4gPiAgICAg
ICAgICAgYWN0aW9uIGdhdGUgaW5kZXggMiBjbG9ja2lkIENMT0NLX1RBSSBcDQo+ID4gPiA+ICAg
ICAgICAgICBzY2hlZC1lbnRyeSBvcGVuIDIwMDAwMDAwMCAtMSA4MDAwMDAwIFwNCj4gPiA+ID4g
ICAgICAgICAgIHNjaGVkLWVudHJ5IGNsb3NlIDEwMDAwMDAwMCAtMSAtMQ0KPiA+ID4NCj4gPiA+
IEZpcnN0IG9mIGFsbCwgaXQgaXMgYSBsb25nIHRpbWUgc2luY2UgSSByZWFkIHRoZSA4MDIuMVFj
aSBhbmQgd2hlbiBJDQo+ID4gPiBkaWQgaXQsIGl0IHdhcyBhIGRyYWZ0LiBTbyBwbGVhc2UgbGV0
IG1lIGtub3cgaWYgSSdtIGNvbXBsZXRseSBvZmYgaGVyZS4NCj4gPiA+DQo+ID4gPiBJIGtub3cg
eW91IGFyZSBmb2N1c2luZyBvbiB0aGUgZ2F0ZSBjb250cm9sIGluIHRoaXMgcGF0Y2ggc2VyaWUs
IGJ1dA0KPiA+ID4gSSBhc3N1bWUgdGhhdCB5b3UgbGF0ZXIgd2lsbCB3YW50IHRvIGRvIHRoZSBw
b2xpY2luZyBhbmQgZmxvdy1tZXRlcg0KPiA+ID4gYXMgd2VsbC4gQW5kIGl0IGNvdWxkIG1ha2Ug
c2Vuc2UgdG8gY29uc2lkZXIgaG93IGFsbCBvZiB0aGlzIHdvcmsNCj4gPiA+IHRvZ2hldGhlci4N
Cj4gPiA+DQo+ID4gPiBBIGNvbW1vbiB1c2UtY2FzZSBmb3IgdGhlIHBvbGljaW5nIGlzIHRvIGhh
dmUgbXVsdGlwbGUgcnVsZXMNCj4gPiA+IHBvaW50aW5nIGF0IHRoZSBzYW1lIHBvbGljaW5nIGlu
c3RhbmNlLiBNYXliZSB5b3Ugd2FudCB0aGUgc3VtIG9mDQo+ID4gPiB0aGUgdHJhZmZpYyBvbiAy
IHBvcnRzIHRvIGJlIGxpbWl0ZWQgdG8gMTAwbWJpdC4gSWYgeW91IHNwZWNpZnkgc3VjaA0KPiA+
ID4gYWN0aW9uIG9uIHRoZSBpbmRpdmlkdWFsIHJ1bGUgKGxpa2UgZG9uZSB3aXRoIHRoZSBnYXRl
KSwgdGhlbiB5b3UNCj4gPiA+IGNhbiBub3QgaGF2ZSB0d28gcnVsZXMgcG9pbnRpbmcgYXQgdGhl
IHNhbWUgcG9saWNlciBpbnN0YW5jZS4NCj4gPiA+DQo+ID4gPiBMb25nIHN0b3JyeSBzaG9ydCwg
aGF2ZSB5b3UgY29uc2lkZXJlZCBpZiBpdCB3b3VsZCBiZSBiZXR0ZXIgdG8gZG8NCj4gPiA+IHNv
bWV0aGluZyBsaWtlOg0KPiA+ID4NCj4gPiA+ICAgIHRjIGZpbHRlciBhZGQgZGV2IGV0aDAgcGFy
ZW50IGZmZmY6IHByb3RvY29sIGlwIFwNCj4gPiA+ICAgICAgICAgICAgIGZsb3dlciBzcmNfaXAg
MTkyLjE2OC4wLjIwIFwNCj4gPiA+ICAgICAgICAgICAgIGFjdGlvbiBwc2ZwLWlkIDQyDQo+ID4g
Pg0KPiA+ID4gQW5kIHRoZW4gaGF2ZSBzb21lIG90aGVyIGZ1bmN0aW9uIHRvIGNvbmZpZ3VyZSB0
aGUgcHJvcGVydGllcyBvZg0KPiA+ID4gcHNmcC1pZCA0Mj8NCj4gPiA+DQo+ID4gPg0KPiA+ID4g
L0FsbGFuDQo+ID4gPg0KPiA+DQo+ID4gSXQgaXMgdmVyeSBnb29kIHRoYXQgeW91IGJyb3VnaHQg
aXQgdXAgdGhvdWdoLCBzaW5jZSBpbiBteSBvcGluaW9uIHRvbw0KPiA+IGl0IGlzIGEgcmF0aGVy
IGltcG9ydGFudCBhc3BlY3QsIGFuZCBpdCBzZWVtcyB0aGF0IHRoZSBmYWN0IHRoaXMNCj4gPiBm
ZWF0dXJlIGlzIGFscmVhZHkgZGVzaWduZWQtaW4gd2FzIGEgYml0IHRvbyBzdWJ0bGUuDQo+ID4N
Cj4gPiAicHNmcC1pZCIgaXMgYWN0dWFsbHkgaGlzICJpbmRleCIgYXJndW1lbnQuDQo+ID4NCj4g
PiBZb3UgY2FuIGFjdHVhbGx5IGRvIHRoaXM6DQo+ID4gdGMgZmlsdGVyIGFkZCBkZXYgZXRoMCBp
bmdyZXNzIFwNCj4gPiAgICAgICAgIGZsb3dlciBza2lwX2h3IGRzdF9tYWMgMDE6ODA6YzI6MDA6
MDA6MGUgXA0KPiA+ICAgICAgICAgYWN0aW9uIGdhdGUgaW5kZXggMSBjbG9ja2lkIENMT0NLX1RB
SSBcDQo+ID4gICAgICAgICBiYXNlLXRpbWUgMjAwMDAwMDAwMDAwIFwNCj4gPiAgICAgICAgIHNj
aGVkLWVudHJ5IE9QRU4gMjAwMDAwMDAwIC0xIC0xIFwNCj4gPiAgICAgICAgIHNjaGVkLWVudHJ5
IENMT1NFIDEwMDAwMDAwMCAtMSAtMSB0YyBmaWx0ZXIgYWRkIGRldiBldGgwDQo+ID4gaW5ncmVz
cyBcDQo+ID4gICAgICAgICBmbG93ZXIgc2tpcF9odyBkc3RfbWFjIDAxOjgwOmMyOjAwOjAwOjBm
IFwNCj4gPiAgICAgICAgIGFjdGlvbiBnYXRlIGluZGV4IDENCj4gPg0KPiA+IFRoZW4gMiBmaWx0
ZXJzIGdldCBjcmVhdGVkIHdpdGggdGhlIHNhbWUgYWN0aW9uOg0KPiA+DQo+ID4gdGMgLXMgZmls
dGVyIHNob3cgZGV2IHN3cDIgaW5ncmVzcw0KPiA+IGZpbHRlciBwcm90b2NvbCBhbGwgcHJlZiA0
OTE1MSBmbG93ZXIgY2hhaW4gMCBmaWx0ZXIgcHJvdG9jb2wgYWxsIHByZWYNCj4gPiA0OTE1MSBm
bG93ZXIgY2hhaW4gMCBoYW5kbGUgMHgxDQo+ID4gICBkc3RfbWFjIDAxOjgwOmMyOjAwOjAwOjBm
DQo+ID4gICBza2lwX2h3DQo+ID4gICBub3RfaW5faHcNCj4gPiAgICAgICAgIGFjdGlvbiBvcmRl
ciAxOg0KPiA+ICAgICAgICAgcHJpb3JpdHkgd2lsZGNhcmQgICAgICAgY2xvY2tpZCBUQUkgICAg
IGZsYWdzIDB4NjQwNGYNCj4gPiAgICAgICAgIGJhc2UtdGltZSAyMDAwMDAwMDAwMDAgICAgICAg
ICAgICAgICAgICBjeWNsZS10aW1lIDMwMDAwMDAwMA0KPiA+ICAgICAgICAgIGN5Y2xlLXRpbWUt
ZXh0IDANCj4gPiAgICAgICAgICBudW1iZXIgICAgMCAgICBnYXRlLXN0YXRlIG9wZW4gICAgICAg
ICBpbnRlcnZhbCAyMDAwMDAwMDANCj4gPiAgICAgICAgICBpcHYgd2lsZGNhcmQgICAgbWF4LW9j
dGV0cyB3aWxkY2FyZA0KPiA+ICAgICAgICAgIG51bWJlciAgICAxICAgIGdhdGUtc3RhdGUgY2xv
c2UgICAgICAgIGludGVydmFsIDEwMDAwMDAwMA0KPiA+ICAgICAgICAgIGlwdiB3aWxkY2FyZCAg
ICBtYXgtb2N0ZXRzIHdpbGRjYXJkDQo+ID4gICAgICAgICBwaXBlDQo+ID4gICAgICAgICAgaW5k
ZXggMiByZWYgMiBiaW5kIDIgaW5zdGFsbGVkIDE2OCBzZWMgdXNlZCAxNjggc2VjDQo+ID4gICAg
ICAgICBBY3Rpb24gc3RhdGlzdGljczoNCj4gPiAgICAgICAgIFNlbnQgMCBieXRlcyAwIHBrdCAo
ZHJvcHBlZCAwLCBvdmVybGltaXRzIDAgcmVxdWV1ZXMgMCkNCj4gPiAgICAgICAgIGJhY2tsb2cg
MGIgMHAgcmVxdWV1ZXMgMA0KPiA+DQo+ID4gZmlsdGVyIHByb3RvY29sIGFsbCBwcmVmIDQ5MTUy
IGZsb3dlciBjaGFpbiAwIGZpbHRlciBwcm90b2NvbCBhbGwgcHJlZg0KPiA+IDQ5MTUyIGZsb3dl
ciBjaGFpbiAwIGhhbmRsZSAweDENCj4gPiAgIGRzdF9tYWMgMDE6ODA6YzI6MDA6MDA6MGUNCj4g
PiAgIHNraXBfaHcNCj4gPiAgIG5vdF9pbl9odw0KPiA+ICAgICAgICAgYWN0aW9uIG9yZGVyIDE6
DQo+ID4gICAgICAgICBwcmlvcml0eSB3aWxkY2FyZCAgICAgICBjbG9ja2lkIFRBSSAgICAgZmxh
Z3MgMHg2NDA0Zg0KPiA+ICAgICAgICAgYmFzZS10aW1lIDIwMDAwMDAwMDAwMCAgICAgICAgICAg
ICAgICAgIGN5Y2xlLXRpbWUgMzAwMDAwMDAwDQo+ID4gICAgICAgICAgY3ljbGUtdGltZS1leHQg
MA0KPiA+ICAgICAgICAgIG51bWJlciAgICAwICAgIGdhdGUtc3RhdGUgb3BlbiAgICAgICAgIGlu
dGVydmFsIDIwMDAwMDAwMA0KPiA+ICAgICAgICAgIGlwdiB3aWxkY2FyZCAgICBtYXgtb2N0ZXRz
IHdpbGRjYXJkDQo+ID4gICAgICAgICAgbnVtYmVyICAgIDEgICAgZ2F0ZS1zdGF0ZSBjbG9zZSAg
ICAgICAgaW50ZXJ2YWwgMTAwMDAwMDAwDQo+ID4gICAgICAgICAgaXB2IHdpbGRjYXJkICAgIG1h
eC1vY3RldHMgd2lsZGNhcmQNCj4gPiAgICAgICAgIHBpcGUNCj4gPiAgICAgICAgICBpbmRleCAy
IHJlZiAyIGJpbmQgMiBpbnN0YWxsZWQgMTY4IHNlYyB1c2VkIDE2OCBzZWMNCj4gPiAgICAgICAg
IEFjdGlvbiBzdGF0aXN0aWNzOg0KPiA+ICAgICAgICAgU2VudCAwIGJ5dGVzIDAgcGt0IChkcm9w
cGVkIDAsIG92ZXJsaW1pdHMgMCByZXF1ZXVlcyAwKQ0KPiA+ICAgICAgICAgYmFja2xvZyAwYiAw
cCByZXF1ZXVlcyAwDQo+ID4NCj4gPiBBY3R1YWxseSBteSBvbmx5IGNvbmNlcm4gaXMgdGhhdCBt
YXliZSB0aGlzIG1lY2hhbmlzbSBzaG91bGQgKD8pIGhhdmUNCj4gPiBiZWVuIG1vcmUgZ2VuZXJp
Yy4gQXQgdGhlIG1vbWVudCwgdGhpcyBwYXRjaCBzZXJpZXMgaW1wbGVtZW50cyBpdCB2aWENCj4g
PiBhIFRDQV9HQVRFX0VOVFJZX0lOREVYIG5ldGxpbmsgYXR0cmlidXRlLCBzbyBldmVyeSBhY3Rp
b24gd2hpY2gNCj4gd2FudHMNCj4gPiB0byBiZSBzaGFyZWQgYWNyb3NzIGZpbHRlcnMgbmVlZHMg
dG8gcmVpbnZlbnQgdGhpcyB3aGVlbC4NCj4gPg0KPiA+IFRob3VnaHRzLCBldmVyeW9uZT8NCj4g
DQo+IEkgZG9uJ3QgaGF2ZSBhbnl0aGluZyB2YWx1YWJsZSB0byBhZGQsIGFzaWRlIGZyb20gY29t
bWVudGluZyB0aGlzIHdob2xlDQo+IHRoaW5nIG1ha2VzIG15IGJyYWluIGh1cnQuDQoNClRoYW5r
cyBmb3IgZXhwcmVzcyB5b3VyIHRob3VnaHRzLg0KDQo+IA0KPiA+IFRoYW5rcywNCj4gPiAtVmxh
ZGltaXINCj4gDQo+IA0KPiANCj4gLS0NCj4gTWFrZSBNdXNpYywgTm90IFdhcg0KDQpUaGFua3Mh
DQoNCj4gDQo+IERhdmUgVMOkaHQNCj4gQ1RPLCBUZWtMaWJyZSwgTExDDQo+IGh0dHBzOi8vZXVy
MDEuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwJTNBJTJGJTJGd3d3
DQo+IC50ZWtsaWJyZS5jb20lMkYmYW1wO2RhdGE9MDIlN0MwMSU3Q1BvLkxpdSU0MG54cC5jb20l
N0MwOWNmNjNiYg0KPiA3M2VlNGZiMmUwODEwOGQ3ZTZmODkyOWYlN0M2ODZlYTFkM2JjMmI0YzZm
YTkyY2Q5OWM1YzMwMTYzNSU3QzANCj4gJTdDMCU3QzYzNzIzMTgyNzU5OTIxNzQ3OSZhbXA7c2Rh
dGE9dTNJTG1CbEs2UnNWWURMeTlndEZ5dGhwJTINCj4gRmJHMiUyQnc0MHhlYTJOMXNKdnI0JTNE
JmFtcDtyZXNlcnZlZD0wDQo+IFRlbDogMS04MzEtNDM1LTA3MjkNCg0KDQoNCkJyLA0KUG8gTGl1
DQo=
