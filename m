Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D08817CBF3
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 05:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgCGEiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 23:38:50 -0500
Received: from mail-eopbgr10073.outbound.protection.outlook.com ([40.107.1.73]:46822
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726314AbgCGEiu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 23:38:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzVQ2LTVJdP1jSKSVgG6afLfH/dgsGzgKr/QC8a02HpmNqDOeYyq8fVW8KI6BavQ30mrNCQV7ZK8bE/PJ8deQMKmhbOC5V48ngdE0TN5mar+gnSENgP0PxK7QW7FMgZA9TYd2hNAvI/+OwIikxcOqRHrQ9eRjIPs/9K1M+yY35beJYZSCCI+8lmDBa3SrrO77StBnqV7PVjInnDhZv+WOYWbySRAlxc7JprXFGdGyBxSaRA4UvYRd32JL35Kw/CaEWFkhQgUUZ23nyB6rMl/FbBR8u2WwvLk4VSBlJNpJZzwAzchyVGtN/usv0pWqyBZa3XBkA0vDmWMGQ3Ohg6hWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QhhHRqfJIaY/udB049E7TKW+Y2BW1/m0Lu5eHSmBtk4=;
 b=SDOuU0CC1SZjjJXij4OaNlHazH/gI97KBYwlDGTYp0Vva3+aDVXkX/pw4kD8mqAwYWnZ1GRLU5timybXleenBIMZvAV5XEn45PxX6rjwG0oVh/B87TRfQZUHA9pRgpbilfXKOeExzh1Bue88IpdQgADAdus3IK9dyMyMWJFmIzzeIfRJatcd8XvIdb5q565SyZAgs4cNfZ++2WZzIPs9RAZa0kUnMl5CBP2zIeV3+jAnkmju/iwjSkma78D93vmatQyHgmjA0LQHSkNVv00Br6pACcoVn+51xj12yZ+owjL8u3vKgbPbFgjfcZDRWQVLYbg/u86GGLNZGgYtlZYpFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QhhHRqfJIaY/udB049E7TKW+Y2BW1/m0Lu5eHSmBtk4=;
 b=M+QJeKGIfop6BVqjpBGf0ggfjcTTh3uB2SmprqEfPoyukl8wdWoGSrYy7E14bsSVfIVK9Te/5ByJye9rEH2x1RzMc/3mGQKJzm/d75I19MZSKqvsIT34qh/eEUiOmXg65Mnz6wrKGyoJp7HedU9ccRPObnCs1IqQqrvBmGzzCoY=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (20.179.232.221) by
 VE1PR04MB6734.eurprd04.prod.outlook.com (20.179.234.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.16; Sat, 7 Mar 2020 04:38:46 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::8cb8:5c41:d843:b66d%5]) with mapi id 15.20.2772.019; Sat, 7 Mar 2020
 04:38:46 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
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
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>
Subject: RE: [EXT] Re: [RFC,net-next  3/9] net: schedule: add action gate
 offloading
Thread-Topic: [EXT] Re: [RFC,net-next  3/9] net: schedule: add action gate
 offloading
Thread-Index: AQHV87k9BJj+4mbdAEuLYipoGQWuwag76/sAgAAE14CAAIzXgA==
Date:   Sat, 7 Mar 2020 04:38:45 +0000
Message-ID: <VE1PR04MB64962289FD3F748DC3F2350992E00@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20200306125608.11717-1-Po.Liu@nxp.com>
        <20200306125608.11717-4-Po.Liu@nxp.com>
        <20200306110200.5fc47ad7@kicinski-fedora-PC1C0HJN>
 <20200306111914.746d9bb3@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200306111914.746d9bb3@kicinski-fedora-PC1C0HJN>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c5c638f6-1c59-4a27-62b1-08d7c2516c48
x-ms-traffictypediagnostic: VE1PR04MB6734:|VE1PR04MB6734:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB673418563F9A010A205A776E92E00@VE1PR04MB6734.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 03355EE97E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(199004)(189003)(33656002)(55016002)(26005)(186003)(7696005)(2906002)(478600001)(71200400001)(8676002)(5660300002)(81166006)(8936002)(52536014)(66946007)(66446008)(76116006)(64756008)(66476007)(66556008)(81156014)(53546011)(6506007)(7416002)(316002)(6916009)(44832011)(54906003)(9686003)(86362001)(4326008)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:VE1PR04MB6734;H:VE1PR04MB6496.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4zZymmzdghJD7/AVrFBIjJYeX8VKLnrsFPCw7hji4XQGH2/Y0yDVYqGbekbFIUK7mbVQIDtpIPCnFSPnzIfNGlJMkQjwAZ3EUqrLJiEQ4GtDpmZ/G73EFAdfjG7IvSmLrKKEpOKzHok/IPRT9NQt1WfzhnavL0rv4xNfPYgr2AJCwDM2YCapacrv/aEs6z0rM0zZwlEvw4Shvo4l6yT4pg/xrChJPgylI3htjLdugap6VTOYuQonPQNrXSyurj4EywTGyZev6BPy8iAhOCjKp47X5kc483vvdJsM8v2NAJPluzUMm0SsbS9Ho1v2t0M1g0RMpRByA66UTX2dFEV4dykVRtxpkFLs6bmItzJyNvh0aP6zx3bfqcoINlEZlhuRRyp9YLRbp5XeIZb8CBqRp7mB0hPPxMa81XrK1HVUJJpZs+D43ux+DotPj0dF9bwKZPuEcRXtr+tXxSpnChmcTM3j/h2Q8wgu4ZNpIRo7GA7WdWhSmwdca6o7oaP5y4vE
x-ms-exchange-antispam-messagedata: 8f/MHvcxbXK/mxXFtCqWWwQNohDPh0izxF8j7G/P6kO/HfAvyOXnLGOVpy+Xa/orN8S0d9t9On0R890jVt1r9F++N7ZAAbLIT3yS0knu5/2ApYOuzOcnt1TNENUAq2hB2CpJfKkk0x5ciTWtfP/ItQ==
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5c638f6-1c59-4a27-62b1-08d7c2516c48
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2020 04:38:46.0007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WVy0PnSc2pm5e6XGokqiX8OQaT89C12pJkmBFQTbUMJYnTNWjq3ejOS0uOt23iWe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6734
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrdWIsDQoNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYWt1
YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiBTZW50OiAyMDIwxOoz1MI3yNUgMzoxOQ0K
PiBUbzogUG8gTGl1IDxwby5saXVAbnhwLmNvbT4NCj4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7
IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7
IHZpbmljaXVzLmdvbWVzQGludGVsLmNvbTsgQ2xhdWRpdSBNYW5vaWwNCj4gPGNsYXVkaXUubWFu
b2lsQG54cC5jb20+OyBWbGFkaW1pciBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPjsN
Cj4gQWxleGFuZHJ1IE1hcmdpbmVhbiA8YWxleGFuZHJ1Lm1hcmdpbmVhbkBueHAuY29tPjsgWGlh
b2xpYW5nIFlhbmcNCj4gPHhpYW9saWFuZy55YW5nXzFAbnhwLmNvbT47IFJveSBaYW5nIDxyb3ku
emFuZ0BueHAuY29tPjsgTWluZ2thaSBIdQ0KPiA8bWluZ2thaS5odUBueHAuY29tPjsgSmVycnkg
SHVhbmcgPGplcnJ5Lmh1YW5nQG54cC5jb20+OyBMZW8gTGkNCj4gPGxlb3lhbmcubGlAbnhwLmNv
bT47IG1pY2hhZWwuY2hhbkBicm9hZGNvbS5jb207IHZpc2hhbEBjaGVsc2lvLmNvbTsNCj4gc2Fl
ZWRtQG1lbGxhbm94LmNvbTsgbGVvbkBrZXJuZWwub3JnOyBqaXJpQG1lbGxhbm94LmNvbTsNCj4g
aWRvc2NoQG1lbGxhbm94LmNvbTsgYWxleGFuZHJlLmJlbGxvbmlAYm9vdGxpbi5jb207DQo+IFVO
R0xpbnV4RHJpdmVyQG1pY3JvY2hpcC5jb207IGpoc0Btb2phdGF0dS5jb207DQo+IHhpeW91Lndh
bmdjb25nQGdtYWlsLmNvbTsgam9obi5odXJsZXlAbmV0cm9ub21lLmNvbTsNCj4gc2ltb24uaG9y
bWFuQG5ldHJvbm9tZS5jb207DQo+IHBpZXRlci5qYW5zZW52YW52dXVyZW5AbmV0cm9ub21lLmNv
bTsgcGFibG9AbmV0ZmlsdGVyLm9yZzsNCj4gbW9zaGVAbWVsbGFub3guY29tOyBpdmFuLmtob3Jv
bnpodWtAbGluYXJvLm9yZzsgbS1rYXJpY2hlcmkyQHRpLmNvbTsNCj4gYW5kcmUuZ3VlZGVzQGxp
bnV4LmludGVsLmNvbTsgamFrdWIua2ljaW5za2lAbmV0cm9ub21lLmNvbQ0KPiBTdWJqZWN0OiBb
RVhUXSBSZTogW1JGQyxuZXQtbmV4dCAzLzldIG5ldDogc2NoZWR1bGU6IGFkZCBhY3Rpb24gZ2F0
ZQ0KPiBvZmZsb2FkaW5nDQo+IA0KPiBDYXV0aW9uOiBFWFQgRW1haWwNCj4gDQo+IE9uIEZyaSwg
NiBNYXIgMjAyMCAxMTowMjowMCAtMDgwMCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gPiBPbiBG
cmksICA2IE1hciAyMDIwIDIwOjU2OjAxICswODAwIFBvIExpdSB3cm90ZToNCj4gPiA+ICtzdGF0
aWMgaW50IHRjZl9nYXRlX2dldF9lbnRyaWVzKHN0cnVjdCBmbG93X2FjdGlvbl9lbnRyeSAqZW50
cnksDQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc3Qgc3RydWN0IHRjX2Fj
dGlvbiAqYWN0KSB7DQo+ID4gPiArICAgZW50cnktPmdhdGUuZW50cmllcyA9IHRjZl9nYXRlX2dl
dF9saXN0KGFjdCk7DQo+ID4gPiArDQo+ID4gPiArICAgaWYgKCFlbnRyeS0+Z2F0ZS5lbnRyaWVz
KQ0KPiA+ID4gKyAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+ID4gPiArDQo+ID4gPiArICAg
ZW50cnktPmRlc3RydWN0b3IgPSB0Y2ZfZ2F0ZV9lbnRyeV9kZXN0cnVjdG9yOw0KPiA+ID4gKyAg
IGVudHJ5LT5kZXN0cnVjdG9yX3ByaXYgPSBlbnRyeS0+Z2F0ZS5lbnRyaWVzOw0KPiA+DQo+ID4g
V2hhdCdzIHRoaXMgZGVzdHJ1Y3RvciBzdHVmZiBkb2luZz8gSSBkb24ndCBpdCBiZWluZyBjYWxs
ZWQuDQoNCkl0IHByZXBhcmUgYSBnYXRlIGxpc3QgYXJyYXkgcGFyYW1ldGVycyBmb3Igb2ZmbG9h
ZGluZy4gIFNvIHRoZSBkcml2ZXIgc2lkZSB3b3VsZCBub3QgbGluayB0aGUgZGF0YSB3aXRoIHBy
b3RvY29sIHNpZGUuIERlc3RydWN0b3Igd291bGQgZnJlZSB0aGUgdGVtcG9yYXJ5IGdhdGUgbGlz
dCBhcnJheS4NCg0KPiANCj4gQWgsIGl0J3MgdGhlIGFjdGlvbiBkZXN0cnVjdG9yLCBub3Qgc29t
ZXRoaW5nIGdhdGUgc3BlY2lmaWMuIERpc3JlZ2FyZC4NCg0KSSB1bmRlcnN0YW5kIGhlcmUgd2l0
aCBhY3Rpb25zIGFyZTogDQpFYWNoIHRjIGZsb3dlciBmb2xsb3cgdXAgd2l0aCBhY3Rpb25zLiBF
YWNoIGFjdGlvbiBkZWZpbmVkOg0KDQpzdHJ1Y3QgZmxvd19hY3Rpb25fZW50cnkgew0KCWVudW0g
Zmxvd19hY3Rpb25faWQgICAgICAgICAgICAgaWQ7DQoJYWN0aW9uX2Rlc3RyICAgICAgICAgICAg
ICAgICAgICBkZXN0cnVjdG9yOw0KCXZvaWQgICAgICAgICAgICAgICAgICAgICAgICAgICAgKmRl
c3RydWN0b3JfcHJpdjsNCgl1bmlvbiB7DQoJCS4uLi4uLg0KCQl7fXNhbXBsZSwNCgkJe31wb2xp
Y2UsDQoJCXt9Z2F0ZSwNCgl9DQp9DQoNClNvIGZvciB0aGUgZGVzdHJ1Y3RvciBhbmQgZGVzdHJ1
Y3Rvcl9wcml2IGFyZSBwcm92aWRlZCBzcGVjaWZpYyBmb3IgdGhlIHVuaW9uIGFjdGlvbi4gU28g
aXQgaXMgbm90IGdhdGUgc3BlY2lmaWMuIEZvciBtaXJyb3IgYWN0aW9uLCBkZXN0cnVjdG9yX3By
aXYgd291bGQgYmUgcG9pbnQgdG8gYSBtaXJyb3IgZGV2aWNlIGRhdGEuIA0KSSBzdXBwb3NlIGl0
IGlzIGZvciBkZXN0cm95IHRoZSB0ZW1wb3JhcnkgIGRhdGEgbGlrZSBpdCBuYW1lLiAgQW5kIGFm
dGVyIHRjX3NldHVwX2Zsb3dfYWN0aW9uKCkgbG9hZGVkLCB0aGUgZGVzdHJ1Y3RvciBmdW5jdGlv
biB3b3VsZCBiZSBsb2FkZWQgYnkgdGNfY2xlYW51cF9mbG93X2FjdGlvbigpIHRvIGRlc3Ryb3kg
YW5kIGZyZWUgdGhlIHRlbXBvcmFyeSBkYXRhLg0KDQpDb2RlIGZsb3cgaXMgOg0KbmV0L3NjaGVk
L2Nsc19mbG93ZXIuYw0KCXN0YXRpYyBpbnQgZmxfaHdfcmVwbGFjZV9maWx0ZXIoKQ0KCXsNCgkJ
Li4uLi4uDQoJCXRjX3NldHVwX2Zsb3dfYWN0aW9uKCk7IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLT4gYXNzaWduIGFjdGlvbiBwYXJhbWV0ZXJzICh3aXRoIHRoZSBkZXN0
cnVjdG9yIGFuZCBkZXN0cnVjdG9yX3ByaXYgaWYgdGhlIGFjdGlvbiBuZWVkZWQpDQoJCS4uLi4u
Lg0KCQl0Y19zZXR1cF9jYl9hZGQoKSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tPiBjYWxsIHRoZSBkcml2ZXIgcHJvdmlkZSBydWxlcyB3aXRoIGFjdGlvbnMg
ZGF0YXMgZm9yIGRldmljZQ0KCQkuLi4uLi4NCgkJdGNfY2xlYW51cF9mbG93X2FjdGlvbigmY2xz
X2Zsb3dlci5ydWxlLT5hY3Rpb24pOyAgLS0tPiBsb2FkaW5nIGVhY2ggYWN0aW9uJydzIGRlc3Ry
dWN0b3IoZGVzdHJ1Y3Rvcl9wcml2KQ0KCX0NCg0KU28gZm9yIGVhY2ggYWN0aW9uIHdvdWxkIGJl
IHdpdGggaXRzIHByaXZhdGUgZGVzdHJ1Y3RvciBhbmQgZGVzdHJ1Y3Rvcl9wcml2IGlmIHRoZSBh
Y3Rpb24gbmVlZGVkLCBhbmQgdGhlbiBkZXN0cm95ZWQgYXQgdGNfY2xlYW51cF9mbG93X2FjdGlv
bigpLiANCg0KRGlkIEkgbWlzdW5kZXJzdGFuZCBhbnl0aGluZz8NCg0KVGhhbmtzIQ0KDQpCciwN
ClBvIExpdQ0K
