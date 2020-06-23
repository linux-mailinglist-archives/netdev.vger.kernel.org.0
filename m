Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A9F204B59
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731534AbgFWHjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:39:11 -0400
Received: from mail-am6eur05on2050.outbound.protection.outlook.com ([40.107.22.50]:45025
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731169AbgFWHjK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 03:39:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/oYNi5202CuAM9+BheLta60ZHwRSe1l3EGeoY0yanzcdBX06lKTW+/PTS0jivzpQYui6YeliFVaLI4xh6eBMzhCNfs+zKVrJNE6o6s6LmTarAPy5FJ1qHnp6izKVZRO8stLwh+mF88WJmbpDlo7owx2qaEgwFJ3c0MSl/SVmnQFeALnn7x6gN3Y1a154mer1WXBQ0PcI6JQmhi804jvVVt+XcWoY8kn2KyoE3KbauXSVmRKjH2wuyJvu9x0UoRwwRVJfsGBGvlaH2UHoDT7k+hhFneuls41bmkOqfpKKTwYGWhrQu6vvGu/AXqiib55LqHp6hclqq8WVyeh/9qlGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hoxyaT6lJl6jrAcE+wsvIbM0dCagF72oUZOM/hAljA=;
 b=gWRKxfQ3ruv4Eg3f05whMvSqlw5UmnKEmPFb1OHjmu7ub2Dgr/O5ms8dJEp0Rb8TeH1kjONGAIq+57nEIWUpvNKbXjCGYiHDK6jPr34SQUswRQiapd/BCm+rp7IEeF6PxIOsqSqof5gb/5b2uG0SKKzJzxHJHRoDQo9+DINKKwvygyH/8xitqukpzhSRKcyhIZVO3axYkqY/2dhkLnkG8GZboLIWFFj544k5Ngoy7ABwyhIGv7JKKYTwnr+roVzcww6QWf1SNQXOnvMGlPuD9Y6pQdM/4VP9ZozFQqL80vg3dd5ZI7fqDJT7AyCiFNJkqBMcvqt2E708VoDskFTecQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hoxyaT6lJl6jrAcE+wsvIbM0dCagF72oUZOM/hAljA=;
 b=lKe+m8XwCpk8Q+NwEqa0TkZ2TIvDMmXa5f6a1n5YDldk6TuZRnsmR3jGnV2/tvC1napxg1XptaY0OVSSGlLeOXX6ULjzNtsDh9Q/RV6KdKGtw2FHMsAtYyvM4Swt4LOpDGhxZzDB2awdk2x/nQKWldK/Ay0fI8rH3omwCmlEKq4=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6544.eurprd04.prod.outlook.com (2603:10a6:803:124::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 07:39:05 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 07:39:05 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "vlad@buslov.dev" <vlad@buslov.dev>,
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
Subject: RE: [EXT] Re: [v1,net-next 3/4] net: qos: police action add index for
 tc flower offloading
Thread-Topic: [EXT] Re: [v1,net-next 3/4] net: qos: police action add index
 for tc flower offloading
Thread-Index: AQHWSSgm4bD6kMzzL0eVhBuxWC9fNqjlyC4AgAAIJmA=
Date:   Tue, 23 Jun 2020 07:39:05 +0000
Message-ID: <VE1PR04MB6496877FDCEEB2317A35089F92940@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20200306125608.11717-7-Po.Liu@nxp.com>
 <20200623063412.19180-1-po.liu@nxp.com>
 <20200623063412.19180-3-po.liu@nxp.com> <20200623070934.GB575172@splinter>
In-Reply-To: <20200623070934.GB575172@splinter>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [221.221.90.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9ade9c1d-723a-42c1-c832-08d8174881fc
x-ms-traffictypediagnostic: VE1PR04MB6544:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6544053CC4DEFD2A9CF5F11192940@VE1PR04MB6544.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d2Sevt5VkoyjSjbK6wAraEOlQA44mB99JQEvM1xGGiSFK4e8MDOO4ogx7Uk37sSLZ7tLAdqM6pPpw6Y2y1tPsJYFOfxcwN8+XmVfKZGu/XxDgTFmtfMydPzz2r8Y603iayE6fuZgMu4baX6t8MfIt80n90r6lQ+tNtB1PRHxCOaliVYrzPN0apmoqPki6BbZKoXdMq3wY2QZpiCXb8K+QS3Jjg5Ii8Rbn3iH++TnmGqXQtIDXxu/Sm0Jss+5cfI/wNH6L7nRkSgZEVto/z3Kpcifm9MN9+WEwjIrGoB7ez53dIS7M1gCaAie9aUry1RO0SB+zXFfVTVc2hNfILD8dw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(346002)(366004)(136003)(376002)(54906003)(55016002)(2906002)(9686003)(71200400001)(83380400001)(52536014)(8936002)(44832011)(186003)(26005)(53546011)(6506007)(8676002)(33656002)(6916009)(478600001)(86362001)(64756008)(66556008)(66446008)(7696005)(76116006)(4326008)(316002)(66476007)(5660300002)(7416002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Xw6psmbG7dTW/I+7LvF355k/9hNisfikDL6bgqhSZ5g/QuWzsKeq3t7AykASxPJIGx1NJkFOz1iaB6wV6Pqz2qd2DCWuX+p+EZFKObbhzVOwBQHm/hYqxnaRR540QSa3Ivu2VaRYRu1/cxCZJWs9MVHDmgo/XoTVOwmtfDK9ErE5OPM9nw8QrmjpML1qlVHQWK0hZ9f+NHl/d50gGrdosdI/XSOJ9hdWBi5DN91NIQ8aKFJh2kwZO/UGw6AmD/oe0XWZuauzQPAVwXbdshmMwHweOQm9TLBLB2+rtk1gh1DssRkeC3P/7fztjRElbUI/SDIAIEzwIOgcYARJYElBT5UnpONA0hh0Ujh1ECSzHadff47WWDs85uslWt9iZ1uQd8bZ5mXkaudIQIOyc+TdIJYvCAxOFYmXKKT2czuVBiLt+r0fYBLsI1ATap8bN6qvffRiCdZvbDl8r5vq3buMZ+toOUimdUdAxB+wSGgEFGQ=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ade9c1d-723a-42c1-c832-08d8174881fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 07:39:05.6457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fMZ8g17oESRosfCtYYieHQSPtJ0PrQV6wMffD9SaSWkJVsx1TBmN/vgR4Xbbtro5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6544
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSWRvLA0KDQoNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBJZG8g
U2NoaW1tZWwgPGlkb3NjaEBpZG9zY2gub3JnPg0KPiBTZW50OiAyMDIwxOo21MIyM8jVIDE1OjEw
DQo+IFRvOiBQbyBMaXUgPHBvLmxpdUBueHAuY29tPg0KPiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dDsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgamlyaUByZXNudWxsaS51czsgdmluaWNpdXMuZ29tZXNAaW50ZWwuY29tOw0KPiB2bGFkQGJ1
c2xvdi5kZXY7IENsYXVkaXUgTWFub2lsIDxjbGF1ZGl1Lm1hbm9pbEBueHAuY29tPjsgVmxhZGlt
aXINCj4gT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT47IEFsZXhhbmRydSBNYXJnaW5l
YW4NCj4gPGFsZXhhbmRydS5tYXJnaW5lYW5AbnhwLmNvbT47IG1pY2hhZWwuY2hhbkBicm9hZGNv
bS5jb207DQo+IHZpc2hhbEBjaGVsc2lvLmNvbTsgc2FlZWRtQG1lbGxhbm94LmNvbTsgbGVvbkBr
ZXJuZWwub3JnOw0KPiBqaXJpQG1lbGxhbm94LmNvbTsgaWRvc2NoQG1lbGxhbm94LmNvbTsNCj4g
YWxleGFuZHJlLmJlbGxvbmlAYm9vdGxpbi5jb207IFVOR0xpbnV4RHJpdmVyQG1pY3JvY2hpcC5j
b207DQo+IGt1YmFAa2VybmVsLm9yZzsgamhzQG1vamF0YXR1LmNvbTsgeGl5b3Uud2FuZ2NvbmdA
Z21haWwuY29tOw0KPiBzaW1vbi5ob3JtYW5AbmV0cm9ub21lLmNvbTsgcGFibG9AbmV0ZmlsdGVy
Lm9yZzsNCj4gbW9zaGVAbWVsbGFub3guY29tOyBtLWthcmljaGVyaTJAdGkuY29tOw0KPiBhbmRy
ZS5ndWVkZXNAbGludXguaW50ZWwuY29tOyBzdGVwaGVuQG5ldHdvcmtwbHVtYmVyLm9yZw0KPiBT
dWJqZWN0OiBbRVhUXSBSZTogW3YxLG5ldC1uZXh0IDMvNF0gbmV0OiBxb3M6IHBvbGljZSBhY3Rp
b24gYWRkIGluZGV4IGZvciB0Yw0KPiBmbG93ZXIgb2ZmbG9hZGluZw0KPiANCj4gQ2F1dGlvbjog
RVhUIEVtYWlsDQo+IA0KPiBPbiBUdWUsIEp1biAyMywgMjAyMCBhdCAwMjozNDoxMVBNICswODAw
LCBQbyBMaXUgd3JvdGU6DQo+ID4gRnJvbTogUG8gTGl1IDxQby5MaXVAbnhwLmNvbT4NCj4gPg0K
PiA+IEhhcmR3YXJlIG1heSBvd24gbWFueSBlbnRyaWVzIGZvciBwb2xpY2UgZmxvdy4gU28gdGhh
dCBtYWtlIG9uZShvcg0KPiA+ICBtdWx0aSkgZmxvdyB0byBiZSBwb2xpY2VkIGJ5IG9uZSBoYXJk
d2FyZSBlbnRyeS4gVGhpcyBwYXRjaCBhZGQgdGhlDQo+ID4gcG9saWNlIGFjdGlvbiBpbmRleCBw
cm92aWRlIHRvIHRoZSBkcml2ZXIgc2lkZSBtYWtlIGl0IG1hcHBpbmcgdGhlDQo+ID4gZHJpdmVy
IGhhcmR3YXJlIGVudHJ5IGluZGV4Lg0KPiANCj4gTWF5YmUgZmlyc3QgbWVudGlvbiB0aGF0IGl0
IGlzIHBvc3NpYmxlIGZvciBtdWx0aXBsZSBmaWx0ZXJzIGluIHNvZnR3YXJlIHRvDQo+IHNoYXJl
IHRoZSBzYW1lIHBvbGljZXIuIFNvbWV0aGluZyBsaWtlOg0KPiANCj4gIg0KPiBJdCBpcyBwb3Nz
aWJsZSBmb3Igc2V2ZXJhbCB0YyBmaWx0ZXJzIHRvIHNoYXJlIHRoZSBzYW1lIHBvbGljZSBhY3Rp
b24gYnkNCj4gc3BlY2lmeWluZyB0aGUgYWN0aW9uJ3MgaW5kZXggd2hlbiBpbnN0YWxsaW5nIHRo
ZSBmaWx0ZXJzLg0KPiANCj4gUHJvcGFnYXRlIHRoaXMgaW5kZXggdG8gZGV2aWNlIGRyaXZlcnMg
dGhyb3VnaCB0aGUgZmxvdyBvZmZsb2FkDQo+IGludGVybWVkaWF0ZSByZXByZXNlbnRhdGlvbiwg
c28gdGhhdCBkcml2ZXJzIGNvdWxkIHNoYXJlIGEgc2luZ2xlIGhhcmR3YXJlDQo+IHBvbGljZXIg
YmV0d2VlbiBtdWx0aXBsZSBmaWx0ZXJzLg0KPiAiDQo+IA0KPiA+DQo+ID4gU2lnbmVkLW9mZi1i
eTogUG8gTGl1IDxQby5MaXVAbnhwLmNvbT4NCj4gPiAtLS0NCj4gPiAgaW5jbHVkZS9uZXQvZmxv
d19vZmZsb2FkLmggfCAxICsNCj4gPiAgbmV0L3NjaGVkL2Nsc19hcGkuYyAgICAgICAgfCAxICsN
Cj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1n
aXQgYS9pbmNsdWRlL25ldC9mbG93X29mZmxvYWQuaCBiL2luY2x1ZGUvbmV0L2Zsb3dfb2ZmbG9h
ZC5oDQo+ID4gaW5kZXggYzJlZjE5YzZiMjdkLi5lZWQ5ODA3NWIxYWUgMTAwNjQ0DQo+ID4gLS0t
IGEvaW5jbHVkZS9uZXQvZmxvd19vZmZsb2FkLmgNCj4gPiArKysgYi9pbmNsdWRlL25ldC9mbG93
X29mZmxvYWQuaA0KPiA+IEBAIC0yMzIsNiArMjMyLDcgQEAgc3RydWN0IGZsb3dfYWN0aW9uX2Vu
dHJ5IHsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgYm9vbCAgICAgICAgICAgICAgICAgICAg
dHJ1bmNhdGU7DQo+ID4gICAgICAgICAgICAgICB9IHNhbXBsZTsNCj4gPiAgICAgICAgICAgICAg
IHN0cnVjdCB7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAvKiBGTE9XX0FDVElPTl9Q
T0xJQ0UgKi8NCj4gPiArICAgICAgICAgICAgICAgICAgICAgdTMyICAgICAgICAgICAgICAgICAg
ICAgaW5kZXg7DQo+ID4gICAgICAgICAgICAgICAgICAgICAgIHM2NCAgICAgICAgICAgICAgICAg
ICAgIGJ1cnN0Ow0KPiA+ICAgICAgICAgICAgICAgICAgICAgICB1NjQgICAgICAgICAgICAgICAg
ICAgICByYXRlX2J5dGVzX3BzOw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICB1MzIgICAgICAg
ICAgICAgICAgICAgICBtdHU7DQo+ID4gZGlmZiAtLWdpdCBhL25ldC9zY2hlZC9jbHNfYXBpLmMg
Yi9uZXQvc2NoZWQvY2xzX2FwaS5jIGluZGV4DQo+ID4gNmFiYTdkNWJhMWVjLi5mZGM0Yzg5Y2Ex
ZmEgMTAwNjQ0DQo+ID4gLS0tIGEvbmV0L3NjaGVkL2Nsc19hcGkuYw0KPiA+ICsrKyBiL25ldC9z
Y2hlZC9jbHNfYXBpLmMNCj4gPiBAQCAtMzY1OSw2ICszNjU5LDcgQEAgaW50IHRjX3NldHVwX2Zs
b3dfYWN0aW9uKHN0cnVjdCBmbG93X2FjdGlvbg0KPiAqZmxvd19hY3Rpb24sDQo+ID4gICAgICAg
ICAgICAgICAgICAgICAgIGVudHJ5LT5wb2xpY2UucmF0ZV9ieXRlc19wcyA9DQo+ID4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgdGNmX3BvbGljZV9yYXRlX2J5dGVzX3BzKGFjdCk7DQo+
ID4gICAgICAgICAgICAgICAgICAgICAgIGVudHJ5LT5wb2xpY2UubXR1ID0gdGNmX3BvbGljZV90
Y2ZwX210dShhY3QpOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBlbnRyeS0+cG9saWNlLmlu
ZGV4ID0gYWN0LT50Y2ZhX2luZGV4Ow0KPiA+ICAgICAgICAgICAgICAgfSBlbHNlIGlmIChpc190
Y2ZfY3QoYWN0KSkgew0KPiA+ICAgICAgICAgICAgICAgICAgICAgICBlbnRyeS0+aWQgPSBGTE9X
X0FDVElPTl9DVDsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgZW50cnktPmN0LmFjdGlvbiA9
IHRjZl9jdF9hY3Rpb24oYWN0KTsNCj4gPiAtLQ0KPiA+IDIuMTcuMQ0KPiA+DQoNCg0K
