Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A99190AF7
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 11:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbgCXK26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 06:28:58 -0400
Received: from mail-eopbgr30048.outbound.protection.outlook.com ([40.107.3.48]:53921
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726697AbgCXK26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 06:28:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nic/LnCVtvdfJ1cO8Bwx0gY+9wCCndf53vQYV5IaTX3YNRBDW8gYLjp78W3fWuK2WQRWt3HMGQpSk7ruNtRNjfNBEWWBAkiwypedk4vT+AOrt5f7BjoYkq6HAa4M4AQzDVlYS62p0My1OCWtDvtsqPWnugD1mbkmiQWEQYHpNlGYVnGX03qUDkIODgnj43Sya0Zgr+Xzu2wqJ8FlCRW9NB+enIyMj9ruLQIG7KvcHF8415470rJe9m21/EbMkb4cD9tlwGL1C4pRFdeKqObvwajstkdle05wiKoFpVBdvseD8DVERPzzsOKXAheBinPiZxcgeZnZ1OqlFsu1Zbroxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Hfo2MJi1XSRj8pm35QMxsVsI0gc8K+oxRPZuB/Fmks=;
 b=EoXx8rZ+6JSIfdb+v4ej1DzS2xYI1jjTYJTX7qmUl6iHo8BpckmhAESOSKg8mHP1dk4nPKMShhlrM2DagDbmEAEoBmIDLGfE7ibFwfm7bbIUyPLgVKEoGMUPSNNd9n8rQ7zhuPJjDm4Pn7lANHvJLGUWxJEFqf+rrGNE7w8jkCplYG9UPi4Omvn/Rb32FWixJZu2sQX++IcLjgPlzfkS+9rDbfV+EyYyK4ppsR25zX0kV05FtoELawkGu99AAUIgnEfRjmR8c5SedGtGFiZ9TwuwmnUJ78sit1ZalHDkvL0YHr95hjl4YcgkROH1Zi5dLn91b+FFU2gjx1jUMSsEaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Hfo2MJi1XSRj8pm35QMxsVsI0gc8K+oxRPZuB/Fmks=;
 b=SlL9erqApw7n0NwZvQaDmUeyYTvO2gOBcGnJyhetkCFCwFu0jOTx+TlZra1tsmurT9C3prHC0sREF2wQRt8YlNzOGbLyDGBQypGhcU63Xsn9HGu8qu4GW9KpYq6l7JAiuklM1WDN5n65NSyKeU43L4M5fB3CXMeawaM6dvYImW0=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6366.eurprd04.prod.outlook.com (10.255.118.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Tue, 24 Mar 2020 10:28:52 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 10:28:52 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
Subject: RE: [EXT] Re: [v1,net-next  2/5] net: qos: introduce a gate control
 flow action
Thread-Topic: [EXT] Re: [v1,net-next  2/5] net: qos: introduce a gate control
 flow action
Thread-Index: AQHWAZG/EVECQOvwMUSKIro+DDUGHahXiDqAgAABusA=
Date:   Tue, 24 Mar 2020 10:28:51 +0000
Message-ID: <VE1PR04MB6496483D01ACD1C10372D47792F10@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20200306125608.11717-11-Po.Liu@nxp.com>
 <20200324034745.30979-1-Po.Liu@nxp.com>
 <20200324034745.30979-3-Po.Liu@nxp.com>
 <20200324101921.GS11304@nanopsycho.orion>
In-Reply-To: <20200324101921.GS11304@nanopsycho.orion>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c97bea6d-99d6-4cb5-304f-08d7cfde25d4
x-ms-traffictypediagnostic: VE1PR04MB6366:|VE1PR04MB6366:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB63660E11CFCCEE848F318AAD92F10@VE1PR04MB6366.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 03524FBD26
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(55016002)(26005)(9686003)(71200400001)(53546011)(4326008)(81166006)(81156014)(8676002)(7696005)(8936002)(186003)(6506007)(54906003)(2906002)(478600001)(33656002)(316002)(6916009)(66476007)(66556008)(64756008)(66446008)(66946007)(44832011)(52536014)(76116006)(86362001)(7416002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6366;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8KgOL7VV47+yLIF763HOuKmhjH2Q1eTjb/RuAdSzinuJgTyUhHsXDTuUxeSQKUMyZp7Javu2+dhS/TGDNJqcaZcBE6KGf1wgb3FPyoMfTiCRgrtb5pJOz7+sxR42L57xIGofhcUdK34brO+VU6PySezQ5jSKv1sUkkeuXL9sJDs1LKR4Kq3MEQm007zhlAWtPDZ6HNPQDj0KivNHkEVCxGfjkzKnZazBN92l2Rfdq81Bksr1wLJFWQdEYnBRDBcw3OpbOlj8mNPIGHc6f4GJ35gE501Zkn0q4ePf+Ies0A2mB0G1smLNEtvK3JY56XPWvll7gYtDwqzntYMnHWZ0L+5Tfx58tqGGI7HvW6Ie2Y1fEhY4rBRMHfHA3K5srEOBWqzL+p8FvTa3JIoiSHQiC73CI1iBRUGPGImocf4oAXaIHiBRqLGyPQRYojPor/EE
x-ms-exchange-antispam-messagedata: HmQFPoACLKJbHeg1s27bGGMh3yw+NyRDhwt3Wk21+ykx8GwvqHliydIdoaVviW5Hg9QpRNJw02z37SnTFbo1l1rODqgKmQFt62046P6nl51tByx2tWpbEkZiPN61oUZM59YvTL9C3uTjapfQ/J3QCQ==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c97bea6d-99d6-4cb5-304f-08d7cfde25d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2020 10:28:51.8727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oWgv/URVjhwcMBS0Quoi3DGVEvGQ24Kwq9fnT1bLZNcPaYiQRiTRXzwhBvCQT9hx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6366
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmlyaSwNCg0KSSB3b3VsZCB1cGRhdGUgZGVzY3JpcHRpb25zIG1vcmUgY2xlYXJseS4NCg0K
PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKaXJpIFBpcmtvIDxqaXJpQHJl
c251bGxpLnVzPg0KPiBTZW50OiAyMDIwxOoz1MIyNMjVIDE4OjE5DQo+IFRvOiBQbyBMaXUgPHBv
LmxpdUBueHAuY29tPg0KPiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZzsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgdmluaWNpdXMuZ29tZXNA
aW50ZWwuY29tOyBDbGF1ZGl1IE1hbm9pbA0KPiA8Y2xhdWRpdS5tYW5vaWxAbnhwLmNvbT47IFZs
YWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+Ow0KPiBBbGV4YW5kcnUgTWFy
Z2luZWFuIDxhbGV4YW5kcnUubWFyZ2luZWFuQG54cC5jb20+OyBYaWFvbGlhbmcgWWFuZw0KPiA8
eGlhb2xpYW5nLnlhbmdfMUBueHAuY29tPjsgUm95IFphbmcgPHJveS56YW5nQG54cC5jb20+OyBN
aW5na2FpIEh1DQo+IDxtaW5na2FpLmh1QG54cC5jb20+OyBKZXJyeSBIdWFuZyA8amVycnkuaHVh
bmdAbnhwLmNvbT47IExlbyBMaQ0KPiA8bGVveWFuZy5saUBueHAuY29tPjsgbWljaGFlbC5jaGFu
QGJyb2FkY29tLmNvbTsgdmlzaGFsQGNoZWxzaW8uY29tOw0KPiBzYWVlZG1AbWVsbGFub3guY29t
OyBsZW9uQGtlcm5lbC5vcmc7IGppcmlAbWVsbGFub3guY29tOw0KPiBpZG9zY2hAbWVsbGFub3gu
Y29tOyBhbGV4YW5kcmUuYmVsbG9uaUBib290bGluLmNvbTsNCj4gVU5HTGludXhEcml2ZXJAbWlj
cm9jaGlwLmNvbTsga3ViYUBrZXJuZWwub3JnOyBqaHNAbW9qYXRhdHUuY29tOw0KPiB4aXlvdS53
YW5nY29uZ0BnbWFpbC5jb207IHNpbW9uLmhvcm1hbkBuZXRyb25vbWUuY29tOw0KPiBwYWJsb0Bu
ZXRmaWx0ZXIub3JnOyBtb3NoZUBtZWxsYW5veC5jb207IG0ta2FyaWNoZXJpMkB0aS5jb207DQo+
IGFuZHJlLmd1ZWRlc0BsaW51eC5pbnRlbC5jb207IHN0ZXBoZW5AbmV0d29ya3BsdW1iZXIub3Jn
DQo+IFN1YmplY3Q6IFtFWFRdIFJlOiBbdjEsbmV0LW5leHQgMi81XSBuZXQ6IHFvczogaW50cm9k
dWNlIGEgZ2F0ZSBjb250cm9sIGZsb3cNCj4gYWN0aW9uDQo+IA0KPiBDYXV0aW9uOiBFWFQgRW1h
aWwNCj4gDQo+IFR1ZSwgTWFyIDI0LCAyMDIwIGF0IDA0OjQ3OjQwQU0gQ0VULCBQby5MaXVAbnhw
LmNvbSB3cm90ZToNCj4gPkludHJvZHVjZSBhIGluZ3Jlc3MgZnJhbWUgZ2F0ZSBjb250cm9sIGZs
b3cgYWN0aW9uLiB0YyBjcmVhdGUgYSBnYXRlDQo+ID5hY3Rpb24gd291bGQgcHJvdmlkZSBhIGdh
dGUgbGlzdCB0byBjb250cm9sIHdoZW4gb3Blbi9jbG9zZSBzdGF0ZS4gd2hlbg0KPiA+dGhlIGdh
dGUgb3BlbiBzdGF0ZSwgdGhlIGZsb3cgY291bGQgcGFzcyBidXQgbm90IHdoZW4gZ2F0ZSBzdGF0
ZSBpcw0KPiA+Y2xvc2UuIFRoZSBkcml2ZXIgd291bGQgcmVwZWF0IHRoZSBnYXRlIGxpc3QgY3lj
bGljYWxseS4gVXNlciBhbHNvDQo+ID5jb3VsZCBhc3NpZ24gYSB0aW1lIHBvaW50IHRvIHN0YXJ0
IHRoZSBnYXRlIGxpc3QgYnkgdGhlIGJhc2V0aW1lDQo+ID5wYXJhbWV0ZXIuIGlmIHRoZSBiYXNl
dGltZSBoYXMgcGFzc2VkIGN1cnJlbnQgdGltZSwgc3RhcnQgdGltZSB3b3VsZA0KPiA+Y2FsY3Vs
YXRlIGJ5IHRoZSBjeWNsZXRpbWUgb2YgdGhlIGdhdGUgbGlzdC4NCj4gDQo+IENhbm5vdCBkZWN5
cGhlciB0aGlzIGVpdGhlciA6LyBTZXJpb3VzbHksIHBsZWFzZSBtYWtlIHRoZSBwYXRjaA0KPiBk
ZXNjcmlwdGlvbnMgcmVhZGFibGUuDQo+IA0KDQpPay4NCg0KPiBBbHNvLCBhIHNlbnRlbmNlIHN0
YXJ0cyB3aXRoIGNhcGl0YWwgbGV0dGVyLg0KPiANCj4gDQo+IA0KPiA+VGhlIGFjdGlvbiBnYXRl
IGJlaGF2aW9yIHRyeSB0byBrZWVwIGFjY29yZGluZyB0byB0aGUgSUVFRSA4MDIuMVFjaSBzcGVj
Lg0KPiA+Rm9yIHRoZSBzb2Z0d2FyZSBzaW11bGF0aW9uLCByZXF1aXJlIHRoZSB1c2VyIGlucHV0
IHRoZSBjbG9jayB0eXBlLg0KPiA+DQo+ID5CZWxvdyBpcyB0aGUgc2V0dGluZyBleGFtcGxlIGlu
IHVzZXIgc3BhY2UuIFRjIGZpbHRlciBhIHN0cmVhbSBzb3VyY2UNCj4gPmlwIGFkZHJlc3MgaXMg
MTkyLjE2OC4wLjIwIGFuZCBnYXRlIGFjdGlvbiBvd24gdHdvIHRpbWUgc2xvdHMuIE9uZSBpcw0K
PiA+bGFzdCAyMDBtcyBnYXRlIG9wZW4gbGV0IGZyYW1lIHBhc3MgYW5vdGhlciBpcyBsYXN0IDEw
MG1zIGdhdGUgY2xvc2UNCj4gPmxldCBmcmFtZXMgZHJvcHBlZC4gV2hlbiB0aGUgcGFzc2VkIHRv
dGFsIGZyYW1lcyBvdmVyIDgwMDAwMDAgYnl0ZXMsIGl0DQo+ID53aWxsIGRyb3BwZWQgaW4gb25l
IDIwMDAwMDAwMG5zIHRpbWUgc2xvdC4NCj4gPg0KPiA+PiB0YyBxZGlzYyBhZGQgZGV2IGV0aDAg
aW5ncmVzcw0KPiA+DQo+ID4+IHRjIGZpbHRlciBhZGQgZGV2IGV0aDAgcGFyZW50IGZmZmY6IHBy
b3RvY29sIGlwIFwNCj4gPiAgICAgICAgICBmbG93ZXIgc3JjX2lwIDE5Mi4xNjguMC4yMCBcDQo+
ID4gICAgICAgICAgYWN0aW9uIGdhdGUgaW5kZXggMiBjbG9ja2lkIENMT0NLX1RBSSBcDQo+ID4g
ICAgICAgICAgc2NoZWQtZW50cnkgT1BFTiAyMDAwMDAwMDAgLTEgODAwMDAwMCBcDQo+ID4gICAg
ICAgICAgc2NoZWQtZW50cnkgQ0xPU0UgMTAwMDAwMDAwIC0xIC0xDQo+IA0KPiBUaGUgcmVzdCBv
ZiB0aGUgY29tbWFuZHMgZG8gbm90IHVzZSBjYXBpdGFscy4gUGxlYXNlIGxvd2VyY2FzZSB0aGVz
ZS4NCj4gDQoNCk9rLg0KDQo+IA0KPiA+DQo+ID4+IHRjIGNoYWluIGRlbCBkZXYgZXRoMCBpbmdy
ZXNzIGNoYWluIDANCj4gPg0KPiA+InNjaGVkLWVudHJ5IiBmb2xsb3cgdGhlIG5hbWUgdGFwcmlv
IHN0eWxlLiBnYXRlIHN0YXRlIGlzDQo+ID4iT1BFTiIvIkNMT1NFIi4gRm9sbG93IHRoZSBwZXJp
b2QgbmFub3NlY29uZC4gVGhlbiBuZXh0IGl0ZW0gaXMNCj4gPmludGVybmFsIHByaW9yaXR5IHZh
bHVlIG1lYW5zIHdoaWNoIGluZ3Jlc3MgcXVldWUgc2hvdWxkIHB1dC4gIi0xIg0KPiA+bWVhbnMg
d2lsZGNhcmQuIFRoZSBsYXN0IHZhbHVlIG9wdGlvbmFsIHNwZWNpZmllcyB0aGUgbWF4aW11bSBu
dW1iZXINCj4gb2YNCj4gPk1TRFUgb2N0ZXRzIHRoYXQgYXJlIHBlcm1pdHRlZCB0byBwYXNzIHRo
ZSBnYXRlIGR1cmluZyB0aGUgc3BlY2lmaWVkDQo+ID50aW1lIGludGVydmFsLg0KPiA+QmFzZS10
aW1lIGlzIG5vdCBzZXQgd2lsbCBiZSBhcyAwIGFzIGRlZmF1bHQsIGFzIHJlc3VsdCBzdGFydCB0
aW1lDQo+ID53b3VsZCBiZSAoKE4gKyAxKSAqIGN5Y2xldGltZSkgd2hpY2ggaXMgdGhlIG1pbmlt
YWwgb2YgZnV0dXJlIHRpbWUuDQo+ID4NCj4gPkJlbG93IGV4YW1wbGUgc2hvd3MgZmlsdGVyaW5n
IGEgc3RyZWFtIHdpdGggZGVzdGluYXRpb24gbWFjIGFkZHJlc3MgaXMNCj4gPjEwOjAwOjgwOjAw
OjAwOjAwIGFuZCBpcCB0eXBlIGlzIElDTVAsIGZvbGxvdyB0aGUgYWN0aW9uIGdhdGUuIFRoZSBn
YXRlDQo+ID5hY3Rpb24gd291bGQgcnVuIHdpdGggb25lIGNsb3NlIHRpbWUgc2xvdCB3aGljaCBt
ZWFucyBhbHdheXMga2VlcCBjbG9zZS4NCj4gPlRoZSB0aW1lIGN5Y2xlIGlzIHRvdGFsIDIwMDAw
MDAwMG5zLiBUaGUgYmFzZS10aW1lIHdvdWxkIGNhbGN1bGF0ZSBieToNCj4gPg0KPiA+IDEzNTcw
MDAwMDAwMDAgKyAoTiArIDEpICogY3ljbGV0aW1lDQo+ID4NCj4gPldoZW4gdGhlIHRvdGFsIHZh
bHVlIGlzIHRoZSBmdXR1cmUgdGltZSwgaXQgd2lsbCBiZSB0aGUgc3RhcnQgdGltZS4NCj4gPlRo
ZSBjeWNsZXRpbWUgaGVyZSB3b3VsZCBiZSAyMDAwMDAwMDBucyBmb3IgdGhpcyBjYXNlLg0KPiA+
DQo+ID4+IHRjIGZpbHRlciBhZGQgZGV2IGV0aDAgcGFyZW50IGZmZmY6ICBwcm90b2NvbCBpcCBc
DQo+ID4gICAgICAgICAgZmxvd2VyIHNraXBfaHcgaXBfcHJvdG8gaWNtcCBkc3RfbWFjIDEwOjAw
OjgwOjAwOjAwOjAwIFwNCj4gPiAgICAgICAgICBhY3Rpb24gZ2F0ZSBpbmRleCAxMiBiYXNlLXRp
bWUgMTM1NzAwMDAwMDAwMCBcDQo+ID4gICAgICAgICAgc2NoZWQtZW50cnkgQ0xPU0UgMjAwMDAw
MDAwIC0xIC0xIFwNCj4gPiAgICAgICAgICBjbG9ja2lkIENMT0NLX1RBSQ0KPiA+DQo+ID5OT1RF
OiBUaGlzIHNvZnR3YXJlIHNpbXVsYXRvciB2ZXJzaW9uIG5vdCBzZXBhcmF0ZSB0aGUgYWRtaW4v
b3BlcmF0aW9uDQo+ID5zdGF0ZSBtYWNoaW5lLiBVcGRhdGUgc2V0dGluZyB3b3VsZCBvdmVyd3Jp
dGUgc3RvcCB0aGUgcHJldmlvcyBzZXR0aW5nDQo+ID5hbmQgd2FpdGluZyBuZXcgY3ljbGUgc3Rh
cnQuDQo+ID4NCj4gDQo+IFsuLi5dDQo+IA0KPiANCj4gPmRpZmYgLS1naXQgYS9uZXQvc2NoZWQv
S2NvbmZpZyBiL25ldC9zY2hlZC9LY29uZmlnIGluZGV4DQo+ID5iZmJlZmI3YmZmOWQuLjMyMDQ3
MWEwYTIxZCAxMDA2NDQNCj4gPi0tLSBhL25ldC9zY2hlZC9LY29uZmlnDQo+ID4rKysgYi9uZXQv
c2NoZWQvS2NvbmZpZw0KPiA+QEAgLTk4MSw2ICs5ODEsMjEgQEAgY29uZmlnIE5FVF9BQ1RfQ1QN
Cj4gPiAgICAgICAgIFRvIGNvbXBpbGUgdGhpcyBjb2RlIGFzIGEgbW9kdWxlLCBjaG9vc2UgTSBo
ZXJlOiB0aGUNCj4gPiAgICAgICAgIG1vZHVsZSB3aWxsIGJlIGNhbGxlZCBhY3RfY3QuDQo+ID4N
Cj4gPitjb25maWcgTkVUX0FDVF9HQVRFDQo+ID4rICAgICAgdHJpc3RhdGUgIkZyYW1lIGdhdGUg
bGlzdCBjb250cm9sIHRjIGFjdGlvbiINCj4gPisgICAgICBkZXBlbmRzIG9uIE5FVF9DTFNfQUNU
DQo+ID4rICAgICAgaGVscA0KPiA+KyAgICAgICAgU2F5IFkgaGVyZSB0byBhbGxvdyB0aGUgY29u
dHJvbCB0aGUgaW5ncmVzcyBmbG93IGJ5IHRoZSBnYXRlDQo+ID4rbGlzdA0KPiANCj4gInRvIGNv
bnRyb2wiPw0KDQpPay4NCg0KPiANCj4gDQo+ID4rICAgICAgICBjb250cm9sLiBUaGUgZnJhbWUg
cG9saWNpbmcgYnkgdGhlIHRpbWUgZ2F0ZSBsaXN0IGNvbnRyb2wNCj4gPisgb3Blbi9jbG9zZQ0K
PiANCj4gSW5jb21wbGV0ZSBzZW50ZW5jZS4NCj4gDQo+IA0KPiA+KyAgICAgICAgY3ljbGUgdGlt
ZS4gVGhlIG1hbmlwdWxhdGlvbiB3aWxsIHNpbXVsYXRlIHRoZSBJRUVFIDgwMi4xUWNpIHN0cmVh
bQ0KPiA+KyAgICAgICAgZ2F0ZSBjb250cm9sIGJlaGF2aW9yLiBUaGUgYWN0aW9uIGNvdWxkIGJl
IG9mZmxvYWQgYnkgdGhlIHRjIGZsb3dlcg0KPiA+KyAgICAgICAgdG8gaGFyZHdhcmUgZHJpdmVy
IHdoaWNoIHRoZSBoYXJkd2FyZSBvd24gdGhlIGNhcGFiaWxpdHkgb2YgSUVFRQ0KPiA+KyAgICAg
ICAgODAyLjFRY2kuDQo+IA0KPiBXZSBkbyBub3QgbWVudGlvbiBvZmZsb2FkIGZvciB0aGUgb3Ro
ZXIgYWN0aW9ucy4gSSBzdWdnZXN0IHRvIG5vdCB0bw0KPiBtZW50aW9uIGl0IGhlcmUgZWl0aGVy
Lg0KDQpPay4NCg0KPiANCj4gDQo+ID4rDQo+ID4rICAgICAgICBJZiB1bnN1cmUsIHNheSBOLg0K
PiA+KyAgICAgICAgVG8gY29tcGlsZSB0aGlzIGNvZGUgYXMgYSBtb2R1bGUsIGNob29zZSBNIGhl
cmU6IHRoZQ0KPiA+KyAgICAgICAgbW9kdWxlIHdpbGwgYmUgY2FsbGVkIGFjdF9nYXRlLg0KPiA+
Kw0KPiA+IGNvbmZpZyBORVRfSUZFX1NLQk1BUksNCj4gPiAgICAgICB0cmlzdGF0ZSAiU3VwcG9y
dCB0byBlbmNvZGluZyBkZWNvZGluZyBza2IgbWFyayBvbiBJRkUgYWN0aW9uIg0KPiA+ICAgICAg
IGRlcGVuZHMgb24gTkVUX0FDVF9JRkUNCj4gDQo+IFsuLi5dDQoNClRoYW5rcyENCg0KQnIsDQpQ
byBMaXUNCg==
