Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909701EE7EF
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 17:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbgFDPkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 11:40:03 -0400
Received: from mail-co1nam11on2132.outbound.protection.outlook.com ([40.107.220.132]:33601
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729216AbgFDPkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 11:40:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLBU5A9nOz82Mn7TuQuBMdMps71jK1gKOvqDhSr0qSiHqPoGnc0zGNHmUyF440tF2woZ8w6QN/G8ESPlZge3OJImTDj7d89t1UA+IHJJtKaREs5UG7Gv3bX9FfRWjwlGcpiCfeSye/zS7H5ockGbtOV9sd1ck8jGoBN4Iz1ITmdbWIybsHADamkbVrO/KnmCKUXGIKrKql5IRJuhXh0AyOqUq2JTRw8zKajH7GtXGrog6OL0TUrA30pJ+09liZ+1XGd7PMNz2fTzhPb031j3Xyw2Fa7OA0PY+IXoWGIhn4eLV6GUVltRS+2qYETtfYUNae8emd59JtK903ZtlzRmSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KvO0mHkFtYlOnztwjTuyGm9c0c16yyFGlaSZBgmsFOQ=;
 b=OU2dLyX03DEF3ozB/YGpeK+Tk17qY/abJe7NDnrf7eP65LzRtR8GHAsgerIy4NL1iN2lVJGG+jI+OUaR2O7np1GyellmtbhDDju/WCTYe6SuYLibqipe756TFdxa6pJgxJNxTrCM5xjDwXmHcK+5udp2J/az19r/09D+F0yo8q5xmLx0gfK9xIQHhKV1R4A3zM8Bld24jdpQpXnV5fuYLvhRnxUI0aTfifQTAL5nj2fC/J80YaAeYRBX6OOAxMmXmGqACFe+eqNXTvJh7qSpv9nnyezOgS24+ifPnWXkrulLS/ofy73XvYt65+L9q+05Oup+tGojfFQGQPfQxFoJ7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KvO0mHkFtYlOnztwjTuyGm9c0c16yyFGlaSZBgmsFOQ=;
 b=M7akBFm6I30nVkFbG0yT6E6NA4BAqoJCpM0YFXdWXCycio1GPJ41iXbmqYIfYlOYaqtcK21vT+sjcD1Djow+o07X8+5kWKJDnLuMqE6UR4lf3IwkjisV+A+3bOYClOabq1xlI8dByJuOsE6jM/j5M0Sm6ZWe0iUES1YpixN2uW8=
Received: from CH2PR13MB3398.namprd13.prod.outlook.com (2603:10b6:610:2a::33)
 by CH2PR13MB3734.namprd13.prod.outlook.com (2603:10b6:610:9b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.9; Thu, 4 Jun
 2020 15:39:59 +0000
Received: from CH2PR13MB3398.namprd13.prod.outlook.com
 ([fe80::49f6:ce9b:9803:2493]) by CH2PR13MB3398.namprd13.prod.outlook.com
 ([fe80::49f6:ce9b:9803:2493%6]) with mapi id 15.20.3066.016; Thu, 4 Jun 2020
 15:39:59 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "zhengbin13@huawei.com" <zhengbin13@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>
CC:     "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>
Subject: Re: [PATCH] sunrpc: need delete xprt->timer in xs_destroy
Thread-Topic: [PATCH] sunrpc: need delete xprt->timer in xs_destroy
Thread-Index: AQHWOn5Zh6+x4WmBK0y1uFEnW2D2E6jIl84A
Date:   Thu, 4 Jun 2020 15:39:58 +0000
Message-ID: <bc4755e6c5cee7a326cf06f983907a3170be1649.camel@hammerspace.com>
References: <20200604144910.133756-1-zhengbin13@huawei.com>
In-Reply-To: <20200604144910.133756-1-zhengbin13@huawei.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=hammerspace.com;
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22ffc3e9-ad5f-4412-54c5-08d8089d8a0c
x-ms-traffictypediagnostic: CH2PR13MB3734:
x-microsoft-antispam-prvs: <CH2PR13MB37346EF5F1CE3031C0B95FC3B8890@CH2PR13MB3734.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 04244E0DC5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9FfO6/F99J0nqdbbB2XhqwipV0e5+OLyW3aWLoYJips6TcvfPVI7ulEJEH41rs5nQTYox4ckr9ZDrJev4gk6Pmoe8UL3jifrPFCAKmhps2ecY8cH/5JOif3SVna/7q4AK3Jdxtib1zg1TWHdzA0KQu5UNAtdjm5PllK2qfU0aSm7TAxeG9uw1JVVy58oaQ5A7ITqjdXpoxYr0wiutP3IaQiYrw/SPjjyOx7bsu+dIvoyk/T92C2aL9CdjpldBrCdXzjj6cKf24hNwgJ59Hf71164kCgz2vPvhvwRD5M4JvgWA7qiZOwos/kJnceMrAT2uJvcmMALSMKsPmA2US2SNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR13MB3398.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(376002)(39830400003)(396003)(136003)(478600001)(54906003)(66946007)(316002)(71200400001)(83380400001)(8936002)(110136005)(2616005)(36756003)(66476007)(64756008)(66556008)(7416002)(26005)(2906002)(4326008)(6506007)(86362001)(76116006)(5660300002)(66446008)(186003)(8676002)(6512007)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: o4f3n/L+S+bikfqwe342VlVjdTNdxqy6BfyC0Pt4UW8G+CVpTHjCJkN9sB4m7YjAGkD+FpbObcWjkZUYyYWvrz8vMd/UtHJa8ndAAc+1FZYGZPMiTatUuIyGv4SWjaGmgmNzDPNUmNErL8sdrcTAfC49b6E0hzdRcURrbt0r1obstYpzl69p04SQ+WXnwvikKPyn9Ihs4tU7LBqXF1Szr1dMLP7Az6710vEUSzRlAvSPOre+B+KOPxEfVQqf4xCSTAp51x/zWH4ZDSOD3zbyZMBrnL8Ur8216fVt+soo4eFrmpUi3TpMmIPXfOhBWRuHZrQ1s4dCkBoP6LjFBPo7wsaeflrItlhri72OEQ86bJAwDHJxftFo2FoLbNK0Ff73Eg5V97Tp/pviZg0bWUUtZiHbTFzM7qJi3s+RYBivbbY4LW7nCULeSBDquXVqlbzrtGxoXej6jROcPiRo+ZQkUGJkQ+vKL75LBjG/EGWGeT8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <945FD89B176D7F41AF882BEDE92E40B7@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22ffc3e9-ad5f-4412-54c5-08d8089d8a0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2020 15:39:59.1407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U1Gvd45wt2jb2UQgoN73b0lVSRpS7pbbx/1o0h0K+lfikz0VlpsiIRInyPLtjyMCyfY1nXdOgr//ZcxhQZD5eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3734
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA2LTA0IGF0IDIyOjQ5ICswODAwLCBaaGVuZyBCaW4gd3JvdGU6DQo+IElm
IFJQQyB1c2UgdWRwIGFzIGl0J3MgdHJhbnNwb3J0IHByb3RvY29sLCB0cmFuc3BvcnQtPmNvbm5l
Y3Rfd29ya2VyDQo+IHdpbGwgY2FsbCB4c191ZHBfc2V0dXBfc29ja2V0Lg0KPiB4c191ZHBfc2V0
dXBfc29ja2V0DQo+ICAgc29jayA9IHhzX2NyZWF0ZV9zb2NrDQo+ICAgaWYgKElTX0VSUihzb2Nr
KSkNCj4gICAgIGdvdG8gb3V0Ow0KPiAgIG91dDoNCj4gICAgIHhwcnRfdW5sb2NrX2Nvbm5lY3QN
Cj4gICAgICAgeHBydF9zY2hlZHVsZV9hdXRvZGlzY29ubmVjdA0KPiAgICAgICAgIG1vZF90aW1l
cg0KPiAgICAgICAgICAgaW50ZXJuYWxfYWRkX3RpbWVyICAtLT5pbnNlcnQgeHBydC0+dGltZXIg
dG8gYmFzZSB0aW1lcg0KPiBsaXN0DQo+IA0KPiB4c19kZXN0cm95DQo+ICAgY2FuY2VsX2RlbGF5
ZWRfd29ya19zeW5jKCZ0cmFuc3BvcnQtPmNvbm5lY3Rfd29ya2VyKQ0KPiAgIHhzX3hwcnRfZnJl
ZSh4cHJ0KSAgICAgICAgICAgLS0+ZnJlZSB4cHJ0DQo+IA0KPiBUaHVzIHVzZS1hZnRlci1mcmVl
IHdpbGwgaGFwcGVuLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogWmhlbmcgQmluIDx6aGVuZ2JpbjEz
QGh1YXdlaS5jb20+DQo+IC0tLQ0KPiAgbmV0L3N1bnJwYy94cHJ0c29jay5jIHwgMSArDQo+ICAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gDQo+IGRpZmYgLS1naXQgYS9uZXQvc3Vu
cnBjL3hwcnRzb2NrLmMgYi9uZXQvc3VucnBjL3hwcnRzb2NrLmMNCj4gaW5kZXggODQ1ZDBiZTgw
NWVjLi5jNzk2ODA4ZTdmN2EgMTAwNjQ0DQo+IC0tLSBhL25ldC9zdW5ycGMveHBydHNvY2suYw0K
PiArKysgYi9uZXQvc3VucnBjL3hwcnRzb2NrLmMNCj4gQEAgLTEyNDIsNiArMTI0Miw3IEBAIHN0
YXRpYyB2b2lkIHhzX2Rlc3Ryb3koc3RydWN0IHJwY194cHJ0ICp4cHJ0KQ0KPiAgCWRwcmludGso
IlJQQzogICAgICAgeHNfZGVzdHJveSB4cHJ0ICVwXG4iLCB4cHJ0KTsNCj4gDQo+ICAJY2FuY2Vs
X2RlbGF5ZWRfd29ya19zeW5jKCZ0cmFuc3BvcnQtPmNvbm5lY3Rfd29ya2VyKTsNCj4gKwlkZWxf
dGltZXJfc3luYygmeHBydC0+dGltZXIpOw0KPiAgCXhzX2Nsb3NlKHhwcnQpOw0KPiAgCWNhbmNl
bF93b3JrX3N5bmMoJnRyYW5zcG9ydC0+cmVjdl93b3JrZXIpOw0KPiAgCWNhbmNlbF93b3JrX3N5
bmMoJnRyYW5zcG9ydC0+ZXJyb3Jfd29ya2VyKTsNCj4gLS0NCj4gMi4yNi4wLjEwNi5nOWZhZGVk
ZA0KPiANCg0KSSdtIGNvbmZ1c2VkLiBIb3cgY2FuIHRoaXMgaGFwcGVuIGdpdmVuIHRoYXQgeHBy
dF9kZXN0cm95KCkgZmlyc3QgdGFrZXMNCnRoZSBYUFJUX0xPQ0ssIGFuZCB0aGVuIGRlbGV0ZXMg
eHBydC0+dGltZXI/DQoNClJpZ2h0IG5vdywgdGhlIHNvY2tldCBjb2RlIGtub3dzIG5vdGhpbmcg
YWJvdXQgdGhlIGRldGFpbHMgb2YgeHBydC0NCj50aW1lciBhbmQgd2hhdCBpdCBpcyB1c2VkIGZv
ci4gSSdkIHByZWZlciB0byBrZWVwIGl0IHRoYXQgd2F5IGlmDQpwb3NzaWJsZS4NCg0KLS0gDQpU
cm9uZCBNeWtsZWJ1c3QNCkxpbnV4IE5GUyBjbGllbnQgbWFpbnRhaW5lciwgSGFtbWVyc3BhY2UN
CnRyb25kLm15a2xlYnVzdEBoYW1tZXJzcGFjZS5jb20NCg0KDQo=
