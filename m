Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CE71B531B
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 05:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgDWD1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 23:27:09 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:30466
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726448AbgDWD1I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 23:27:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljkNQiuHd5zUKDJeVbiEqbN9CurGnQIgGKiFFEtLajmArcpOi5xksh/jj9qtuGG76ADRv8rJ9OhQ6QPTqgvMjt/DGNVC3dun8gZap8AB5CVjWfF5ldGBq6Vw+UeJMhbSJQVyIrIE4wADqhDrl5arfdT7XEtHP/oyizBRd3sCYz/Kl5C+6EnliVaTQURBVW1ji4MEDr48myh2KAGEXRrtisk67jhddksEiCEOE29NYEUOmliCJrCOJa9Z3wp3MRbicso/x0YQc7NTQAKyGTRHTf5Mex7S4DjPzLzsDs6AbsxGM36+GfmLTqY1mua4JwbUdmI1xZr+a4Bnk4BQ6Ui2iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LECYD03G3BcZKIOrk48VvGd+B8EVr80xE/caaxenqmc=;
 b=FQg7tnsDYobrHR93Xdh0JIWRZoZtjRqVhMVuHsS/s6St3YuFl8yIlw9k7IhV8gOesv3DDgpxpf83ntJh+zQnpk3NOos5yDhaFLi9EEU2C/2/faYqhaenH6V7vZD4ctDSHzjd1/LXqnNU9gSa75yEug3/pTQ10zFAw9BMRrlhPaWbViap1neZDCTPfbfGd5FN3Pzo0F9OrTFoXUzfyfiaoZpHIXAy9QWYW0bgQyl6lYwLbfSp1Yr/Yg/cBovCEviwWVJuM+5TvCm4JZn0a/DODVpw42OZrSzwTXd+nADdbrkxMRSVmZuMcRaNL/i5mfHjiYfFveghL7GEUMtmlXG/Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LECYD03G3BcZKIOrk48VvGd+B8EVr80xE/caaxenqmc=;
 b=JE0OiCJFYhcFvDFZkY/TSFWVvSqzziY/wz104p8wWAhxQ7z0uURwz8kVxBkqgZWqHNv7J92Ku80k60BGEUWYMDFQT6L9jFKotQ5WFNS7Fve4fkw3W/NRss5ZWyIDf2WIPl4DBMRv2t0HF3p1i3ho9lt7ESufkn8bOa9Jch30M98=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6525.eurprd04.prod.outlook.com (2603:10a6:803:120::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Thu, 23 Apr
 2020 03:27:02 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2921.032; Thu, 23 Apr 2020
 03:27:02 +0000
From:   Po Liu <po.liu@nxp.com>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
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
Subject: RE: [EXT] Re: [v3,net-next  1/4] net: qos: introduce a gate control
 flow action
Thread-Topic: [EXT] Re: [v3,net-next  1/4] net: qos: introduce a gate control
 flow action
Thread-Index: AQHWGFNl1uy1t0tlFE2NuiTq9Lz8sqiFhSUAgACEwxA=
Date:   Thu, 23 Apr 2020 03:27:02 +0000
Message-ID: <VE1PR04MB64968B11D1F7AAD2FE7A7BC692D30@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20200418011211.31725-5-Po.Liu@nxp.com>
 <20200422024852.23224-1-Po.Liu@nxp.com>
 <20200422024852.23224-2-Po.Liu@nxp.com>
 <20200422191910.gacjlviegrjriwcx@ws.localdomain>
In-Reply-To: <20200422191910.gacjlviegrjriwcx@ws.localdomain>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [221.221.133.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3c0babd0-f42f-4589-b278-08d7e736309a
x-ms-traffictypediagnostic: VE1PR04MB6525:|VE1PR04MB6525:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB652538ABBE17FEA90E11D2E092D30@VE1PR04MB6525.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03827AF76E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(7696005)(8936002)(26005)(6506007)(478600001)(2906002)(33656002)(53546011)(76116006)(66556008)(64756008)(66446008)(66476007)(86362001)(44832011)(66946007)(7416002)(81156014)(6916009)(71200400001)(9686003)(4326008)(5660300002)(52536014)(8676002)(316002)(186003)(55016002)(54906003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g8TiqjXAaeeC40kYhhvl4NDZp0SuxBed01iSJ2zISSHV8l5SOT7M9DKi0RAd0wxBCVl7b8gZI7Xce2AqUoCp62EJ2seBjjiAaGUjx5NJZGf0v7Sp8RsGZLDFZQVjbZxw0DEPqkiNFd3P7mPvucQW1u/V9YlJbVCU6eKCPXS7pMtcfpywidui6gGQ7EEy7jN9AtdsuH9GVWR303RiXxPF/J3rj8xvX6+XSp1Z3lyrkPjPvLhue0iKi6E/cJcS8/j+g+NxPGmrevr8kdO8D46p4g3qXbASyeYGZFxmkFumPRx8bqUxSUNZ5N3xeYS2zs4ksTZyArGLayRAJ8H42xGnr/8GCc7WDamCeI2YceQ5ZVLI6p9RkVOsgYZSgR7hEcFbSj/ELZi7Xzg8fsUjpVlSegB0eByxx4rgpmMCtSZeg6+6XwJwxm4kb/xsUlW2ujEP
x-ms-exchange-antispam-messagedata: G1c9RD5A+fWFTP25uem1IpO0bdh2EEe9bDlgOJzADNpBWS83A16kmVpWG6YoPQ+tTcINlrmVzHOJjstNtuj7aMQ7wibGMNsKEcCRzKESr1Ke4+znIL9JZbb5QM2BqbqUEifzy42HMZHhUU/f/yox1g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c0babd0-f42f-4589-b278-08d7e736309a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2020 03:27:02.4580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cN4nNvirVENJqyrS6pYcLu+fJv+A0HRr/mSmk8amnMQLl+xFgvEG9asYd4OEdBsq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6525
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTmllbHNlbiwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbGxh
biBXLiBOaWVsc2VuIDxhbGxhbi5uaWVsc2VuQG1pY3JvY2hpcC5jb20+DQo+IFNlbnQ6IDIwMjDl
ubQ05pyIMjPml6UgMzoxOQ0KPiBUbzogUG8gTGl1IDxwby5saXVAbnhwLmNvbT4NCj4gQ2M6IGRh
dmVtQGRhdmVtbG9mdC5uZXQ7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7IHZpbmljaXVzLmdvbWVzQGludGVsLmNvbTsgQ2xhdWRpdSBNYW5v
aWwNCj4gPGNsYXVkaXUubWFub2lsQG54cC5jb20+OyBWbGFkaW1pciBPbHRlYW4gPHZsYWRpbWly
Lm9sdGVhbkBueHAuY29tPjsNCj4gQWxleGFuZHJ1IE1hcmdpbmVhbiA8YWxleGFuZHJ1Lm1hcmdp
bmVhbkBueHAuY29tPjsNCj4gbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTsgdmlzaGFsQGNoZWxz
aW8uY29tOw0KPiBzYWVlZG1AbWVsbGFub3guY29tOyBsZW9uQGtlcm5lbC5vcmc7IGppcmlAbWVs
bGFub3guY29tOw0KPiBpZG9zY2hAbWVsbGFub3guY29tOyBhbGV4YW5kcmUuYmVsbG9uaUBib290
bGluLmNvbTsNCj4gVU5HTGludXhEcml2ZXJAbWljcm9jaGlwLmNvbTsga3ViYUBrZXJuZWwub3Jn
OyBqaHNAbW9qYXRhdHUuY29tOw0KPiB4aXlvdS53YW5nY29uZ0BnbWFpbC5jb207IHNpbW9uLmhv
cm1hbkBuZXRyb25vbWUuY29tOw0KPiBwYWJsb0BuZXRmaWx0ZXIub3JnOyBtb3NoZUBtZWxsYW5v
eC5jb207IG0ta2FyaWNoZXJpMkB0aS5jb207DQo+IGFuZHJlLmd1ZWRlc0BsaW51eC5pbnRlbC5j
b207IHN0ZXBoZW5AbmV0d29ya3BsdW1iZXIub3JnDQo+IFN1YmplY3Q6IFtFWFRdIFJlOiBbdjMs
bmV0LW5leHQgMS80XSBuZXQ6IHFvczogaW50cm9kdWNlIGEgZ2F0ZSBjb250cm9sIGZsb3cNCj4g
YWN0aW9uDQo+IA0KPiBDYXV0aW9uOiBFWFQgRW1haWwNCj4gDQo+IEhpIFBvLA0KPiANCj4gTmlj
ZSB0byBzZWUgZXZlbiBtb3JlIHdvcmsgb24gdGhlIFRTTiBzdGFuZGFyZHMgaW4gdGhlIHVwc3Ry
ZWFtIGtlcm5lbC4NCj4gDQo+IE9uIDIyLjA0LjIwMjAgMTA6NDgsIFBvIExpdSB3cm90ZToNCj4g
PkVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1
bmxlc3MgeW91IGtub3cNCj4gPnRoZSBjb250ZW50IGlzIHNhZmUNCj4gPg0KPiA+SW50cm9kdWNl
IGEgaW5ncmVzcyBmcmFtZSBnYXRlIGNvbnRyb2wgZmxvdyBhY3Rpb24uDQo+ID5UYyBnYXRlIGFj
dGlvbiBkb2VzIHRoZSB3b3JrIGxpa2UgdGhpczoNCj4gPkFzc3VtZSB0aGVyZSBpcyBhIGdhdGUg
YWxsb3cgc3BlY2lmaWVkIGluZ3Jlc3MgZnJhbWVzIGNhbiBiZSBwYXNzZWQgYXQNCj4gPnNwZWNp
ZmljIHRpbWUgc2xvdCwgYW5kIGJlIGRyb3BwZWQgYXQgc3BlY2lmaWMgdGltZSBzbG90LiBUYyBm
aWx0ZXINCj4gPmNob29zZXMgdGhlIGluZ3Jlc3MgZnJhbWVzLCBhbmQgdGMgZ2F0ZSBhY3Rpb24g
d291bGQgc3BlY2lmeSB3aGF0IHNsb3QNCj4gPmRvZXMgdGhlc2UgZnJhbWVzIGNhbiBiZSBwYXNz
ZWQgdG8gZGV2aWNlIGFuZCB3aGF0IHRpbWUgc2xvdCB3b3VsZCBiZQ0KPiA+ZHJvcHBlZC4NCj4g
PlRjIGdhdGUgYWN0aW9uIHdvdWxkIHByb3ZpZGUgYW4gZW50cnkgbGlzdCB0byB0ZWxsIGhvdyBt
dWNoIHRpbWUgZ2F0ZQ0KPiA+a2VlcCBvcGVuIGFuZCBob3cgbXVjaCB0aW1lIGdhdGUga2VlcCBz
dGF0ZSBjbG9zZS4gR2F0ZSBhY3Rpb24gYWxzbw0KPiA+YXNzaWduIGEgc3RhcnQgdGltZSB0byB0
ZWxsIHdoZW4gdGhlIGVudHJ5IGxpc3Qgc3RhcnQuIFRoZW4gZHJpdmVyDQo+ID53b3VsZCByZXBl
YXQgdGhlIGdhdGUgZW50cnkgbGlzdCBjeWNsaWNhbGx5Lg0KPiA+Rm9yIHRoZSBzb2Z0d2FyZSBz
aW11bGF0aW9uLCBnYXRlIGFjdGlvbiByZXF1aXJlcyB0aGUgdXNlciBhc3NpZ24gYQ0KPiA+dGlt
ZSBjbG9jayB0eXBlLg0KPiA+DQo+ID5CZWxvdyBpcyB0aGUgc2V0dGluZyBleGFtcGxlIGluIHVz
ZXIgc3BhY2UuIFRjIGZpbHRlciBhIHN0cmVhbSBzb3VyY2UNCj4gPmlwIGFkZHJlc3MgaXMgMTky
LjE2OC4wLjIwIGFuZCBnYXRlIGFjdGlvbiBvd24gdHdvIHRpbWUgc2xvdHMuIE9uZSBpcw0KPiA+
bGFzdCAyMDBtcyBnYXRlIG9wZW4gbGV0IGZyYW1lIHBhc3MgYW5vdGhlciBpcyBsYXN0IDEwMG1z
IGdhdGUgY2xvc2UNCj4gPmxldCBmcmFtZXMgZHJvcHBlZC4gV2hlbiB0aGUgZnJhbWVzIGhhdmUg
cGFzc2VkIHRvdGFsIGZyYW1lcyBvdmVyDQo+ID44MDAwMDAwIGJ5dGVzLCBmcmFtZXMgd2lsbCBi
ZSBkcm9wcGVkIGluIG9uZSAyMDAwMDAwMDBucyB0aW1lIHNsb3QuDQo+ID4NCj4gPj4gdGMgcWRp
c2MgYWRkIGRldiBldGgwIGluZ3Jlc3MNCj4gPg0KPiA+PiB0YyBmaWx0ZXIgYWRkIGRldiBldGgw
IHBhcmVudCBmZmZmOiBwcm90b2NvbCBpcCBcDQo+ID4gICAgICAgICAgIGZsb3dlciBzcmNfaXAg
MTkyLjE2OC4wLjIwIFwNCj4gPiAgICAgICAgICAgYWN0aW9uIGdhdGUgaW5kZXggMiBjbG9ja2lk
IENMT0NLX1RBSSBcDQo+ID4gICAgICAgICAgIHNjaGVkLWVudHJ5IG9wZW4gMjAwMDAwMDAwIC0x
IDgwMDAwMDAgXA0KPiA+ICAgICAgICAgICBzY2hlZC1lbnRyeSBjbG9zZSAxMDAwMDAwMDAgLTEg
LTENCj4gDQo+IEZpcnN0IG9mIGFsbCwgaXQgaXMgYSBsb25nIHRpbWUgc2luY2UgSSByZWFkIHRo
ZSA4MDIuMVFjaSBhbmQgd2hlbiBJIGRpZCBpdCwgaXQNCj4gd2FzIGEgZHJhZnQuIFNvIHBsZWFz
ZSBsZXQgbWUga25vdyBpZiBJJ20gY29tcGxldGx5IG9mZiBoZXJlLg0KPiANCj4gSSBrbm93IHlv
dSBhcmUgZm9jdXNpbmcgb24gdGhlIGdhdGUgY29udHJvbCBpbiB0aGlzIHBhdGNoIHNlcmllLCBi
dXQgSQ0KPiBhc3N1bWUgdGhhdCB5b3UgbGF0ZXIgd2lsbCB3YW50IHRvIGRvIHRoZSBwb2xpY2lu
ZyBhbmQgZmxvdy1tZXRlciBhcyB3ZWxsLg0KPiBBbmQgaXQgY291bGQgbWFrZSBzZW5zZSB0byBj
b25zaWRlciBob3cgYWxsIG9mIHRoaXMgd29yayB0b2doZXRoZXIuDQoNClRoZSBnYXRlIGFjdGlv
biBpcyB0aGUgbXVzdCBoYXZlIGZlYXR1cmUsIHNvIGhlcmUgaXMgdGhlIHBhcnQgb2YgaXQuIEFu
ZCBwcm92aWRlIHRoZSBzdHJlYW0gZmlsdGVyIGltcGxlbWVudGF0aW9uIHBhcnQgaW4gdGhlIGRy
aXZlci4NCkkgcHJvdmlkZWQgYSB3aG9sZSB0aG91Z2h0cywgd2l0aCBmbG93LW1ldGVyIGFwcGx5
IHRvIHBvbGljaW5nIGFjdGlvbiBhbmQgb3RoZXIgdGhyb3VnaHMgaW4gdGhlIFJGQyB2ZXJzaW9u
LiBZb3UgY2FuIGxvb2sgYmFjayB0byB0aGF0IHZlcnNpb24gZm9yIHJlZmVyZW5jZS4NCg0KPiAN
Cj4gQSBjb21tb24gdXNlLWNhc2UgZm9yIHRoZSBwb2xpY2luZyBpcyB0byBoYXZlIG11bHRpcGxl
IHJ1bGVzIHBvaW50aW5nIGF0DQo+IHRoZSBzYW1lIHBvbGljaW5nIGluc3RhbmNlLiBNYXliZSB5
b3Ugd2FudCB0aGUgc3VtIG9mIHRoZSB0cmFmZmljIG9uIDINCj4gcG9ydHMgdG8gYmUgbGltaXRl
ZCB0byAxMDBtYml0LiBJZiB5b3Ugc3BlY2lmeSBzdWNoIGFjdGlvbiBvbiB0aGUgaW5kaXZpZHVh
bA0KPiBydWxlIChsaWtlIGRvbmUgd2l0aCB0aGUgZ2F0ZSksIHRoZW4geW91IGNhbiBub3QgaGF2
ZSB0d28gcnVsZXMgcG9pbnRpbmcgYXQNCj4gdGhlIHNhbWUgcG9saWNlciBpbnN0YW5jZS4NCj4g
DQo+IExvbmcgc3RvcnJ5IHNob3J0LCBoYXZlIHlvdSBjb25zaWRlcmVkIGlmIGl0IHdvdWxkIGJl
IGJldHRlciB0byBkbw0KPiBzb21ldGhpbmcgbGlrZToNCj4gDQo+ICAgIHRjIGZpbHRlciBhZGQg
ZGV2IGV0aDAgcGFyZW50IGZmZmY6IHByb3RvY29sIGlwIFwNCj4gICAgICAgICAgICAgZmxvd2Vy
IHNyY19pcCAxOTIuMTY4LjAuMjAgXA0KPiAgICAgICAgICAgICBhY3Rpb24gcHNmcC1pZCA0Mg0K
PiANCj4gQW5kIHRoZW4gaGF2ZSBzb21lIG90aGVyIGZ1bmN0aW9uIHRvIGNvbmZpZ3VyZSB0aGUg
cHJvcGVydGllcyBvZiBwc2ZwLWlkDQo+IDQyPw0KDQpJIHRoaW5rIHRoZSBwc2ZwLWlkIHlvdSBt
ZW50aW9uIGlzIGZvciB0aGUgZ2F0ZSBhbmQgc3RyZWFtIGZpbHRlciBhbmQgZmxvdyBtZXRlciBh
bmQgc3RyZWFtLWlkZW50aWZ5LiBGb3IgZWFjaCB0aGV5IHNob3VsZCBoYXZlIGFuIGluZGV4Lg0K
VGhlIHN0cmVhbS1pZGVudGlmeSBpbmRleCBjb21lIGZyb20gdGhlIGNoYWluIHZhbHVlLiBHYXRl
IGluZGV4IGNvbWVzIGZyb20gdGhlIGluZGV4IGluIHRoZSBnYXRlIGFjdGlvbiwgdHdvIHBvcnRz
IG9yIG1vcmUgY2FuIHNoYXJlIG9uZSBzYW1lIGluZGV4IGdhdGUgaW5kZXguIFdpbGwgc2FtZSBm
b3IgdGhlIGZsb3ctbWV0ZXIgYWN0aW9uLg0KDQo+IA0KPiANCj4gL0FsbGFuDQoNClRoYW5rcyEN
Cg0KQnIsDQpQbyBMaXUNCg==
