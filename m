Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1812C1C8509
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 10:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgEGImz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 04:42:55 -0400
Received: from mail-eopbgr60120.outbound.protection.outlook.com ([40.107.6.120]:25856
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725802AbgEGImz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 04:42:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kt1DoQ85l8zYI5HkjGfzghagTffigmD2kK5/j8GoUcW462/IoWHIrHC2HhaL9jG3KkZ+NFeh5iqZ4WWPYu3TPpLg03LY74C8Ba6yIQPG8D7tqSwGI2ELDgLliqAOfotU8DcxrG7YSqMZ2R7QiyRfCD/zuZ6KDS/b+sycHr93zempEmXWMOnpBXkPELKLKKi9F+ZDgQslU6+DKiIMoz1J27fyxzgjqDZOor9Iouu4amgaNYrJN+AmPNau0nMANUVBLUQIKVQXpVO4tlJwMK3Kwh7MvPlhDjilgIHaM7NFBxRmciz7CbNmEvW8kDe/YeigHVgm24L67E/zGdhQlDZ/Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qEgZbanxMUshygYNftIUzVGryapzffBFNay4nbF97Yo=;
 b=PpUW6vkJnDjHxwlzKLrU95HI2pevEskVJXih9pEbkb5Me8ROTimr5al+kCI0YfJUg8KOLUdL083iW+3c0Y1u8Dwo6ykANAVh2USj92JrEcQooYPU03Q3On0I+NIThl50AU1HHn4AOh2i+e8twODGGVzLSu/5PN9lLAgoyfkd0TtzpGKBIZjsAwPN0OnIw1kuVgvy3xkoy8WPAGEAVgLdwH9QgnbJ9pXJlCkZfzlQ91for87gwtJ9C5/C5jcbudHr1MnflU0Zm94sJiBMgq1msHCIZmlPB9AXd7s53xH3G0TNemyjiTjFkW4f256OXcLjS2zeoMX1kld00uXZcr9xvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qEgZbanxMUshygYNftIUzVGryapzffBFNay4nbF97Yo=;
 b=c0lks69NT48dFCTWGefoN9CiChpqvEYcFPMjlLn/8hXEGM9Sb3zzwVv0LNbjRpLf3hFEyE84S9ba6IEE9p0S5Ba34sujrSJCI/nxfrYbrtXST1KQjA9Of20UTyo8oQGXqQ1B+I1NqoUnSXSLh+9+R/T1h8FLNByZWW64BHmVur4=
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com (2603:10a6:20b:a8::25)
 by AM6PR05MB5846.eurprd05.prod.outlook.com (2603:10a6:20b:a0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.27; Thu, 7 May
 2020 08:42:50 +0000
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::d8d3:ead7:9f42:4289]) by AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::d8d3:ead7:9f42:4289%6]) with mapi id 15.20.2979.030; Thu, 7 May 2020
 08:42:50 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "tony@atomide.com" <tony@atomide.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>
CC:     "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH next] ARM: dts: am57xx: fix networking on boards with
 ksz9031 phy
Thread-Topic: [PATCH next] ARM: dts: am57xx: fix networking on boards with
 ksz9031 phy
Thread-Index: AQHWI9owvz86t4uWZk6jv5dSVMH06KicT0YA
Date:   Thu, 7 May 2020 08:42:50 +0000
Message-ID: <eab549aed345683a3ee79835369169c99e003488.camel@toradex.com>
References: <20200506191124.31569-1-grygorii.strashko@ti.com>
In-Reply-To: <20200506191124.31569-1-grygorii.strashko@ti.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 
authentication-results: atomide.com; dkim=none (message not signed)
 header.d=none;atomide.com; dmarc=none action=none header.from=toradex.com;
x-originating-ip: [51.154.7.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6cf6009-8b63-4dd7-0c4b-08d7f262a07e
x-ms-traffictypediagnostic: AM6PR05MB5846:
x-microsoft-antispam-prvs: <AM6PR05MB5846FBB0A1CFDA7D9DDD6FDFF4A50@AM6PR05MB5846.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-forefront-prvs: 03965EFC76
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HY+ddRDvhNkyJ90jexKyLavnJkYy9BbzxauRzwl46vzN+G/CneQFo5qqI49YIjjLiroZZSXNXHc+4oWfpkzX3pttrie3MV9+U6fAxm9EfRtjyur2oROLQLsFMzli2f4H49qu4OcE6Xkyni+FotO4ZDd29NW75bVlXG9JI0BoFK87MsW+Cv3mR9rqblCPhjwzPdBFgBW9MmVA1utaMHsTgwMbNbP/jLtf4b0AwZry+B2xVBR0YHQ6S95jYwIOf7SwijWYuXpBuuSQhKu6FKjlhsjohJHCKG9X8L4Ql0xkFMXluM9oOk8vfEXpeoydKYJa8yzqH7BBX/ZHC6xk50eUfWL/blMOiME84wp2ZUFV4n9lsq6uAMSDYje2vrxwd/iGv7WRuq3KVeuubG66mSbnIskcmgN1VNo/V7bj0Y/kcNZoVlYkkreWU2m+PaRVH5q0LgeEHOitIyOWcnwA3nyHHQbNUCLk3qGcFbqh1NjMUsZI+VVgLCkDfzPIwO7qnW5wBhRq/tkf4Wa8LVCWsZhHrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6120.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(136003)(376002)(366004)(39850400004)(33430700001)(91956017)(6512007)(316002)(76116006)(5660300002)(66476007)(66946007)(64756008)(66446008)(66556008)(71200400001)(83290400001)(83310400001)(83300400001)(478600001)(83320400001)(83280400001)(6486002)(4326008)(36756003)(44832011)(110136005)(2616005)(86362001)(8676002)(8936002)(2906002)(6506007)(26005)(186003)(54906003)(33440700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: DXVPHYwJ/CL2rT7vY6wMtFWj46azVdPdTJL7pJfsC3qwryzo6yqLRK77NkJgHWHstZgmswUu2ppHlL8KSK0poT+aE06ha7gnkqXmgWjLVHLDaM4gU3p+yhIce3EX/sVLFgxUNF/iFwNnN9oMt9XC1LNJzDS1Cm2wOPuZaZmB4U9CoHZz8a7ra9IRyT5BqQGOyPSTa+mn/LVDKGeSnFEoq5g7SY6q3q8tlSeRh2+RKDl3PaExtaosH3K0TGw20gO4jS8c2BvOIOEetXkTByKAjgdpL/rG5xC1DNT3kB2hDahVeL8hsqbCPAo9moH0JrZ7+frCBBlr7uVqx63VH6vmFQwOI2gZMxE5G19+VlXMeaK4aAorYguJmGiLZ3JjZUSgmfePAmmsUlHLjPvukNhlSbEbIMvf5DgMwYsiHNsDMevtFnUcdMmpXswk1NDZsZvqsBMXFZRMEEorvKtFj+j616BupzK+f7WIMuSr72RF3b9ponZ79dfZNCUAiTbQqdfLRpKmV5OUywbcatLLAT6a5BJOuJTb/ighNf7bzDc6caONbs2weNv7Tc0v4jwgq+LA84T4DsUoVSPBHF4v7zmh5nzwpthhcooprMUVgFpVEarBHzWC+34if5/uWNFXnFwI3vlbZyaQfz1QujvXmGc8Rz0VAUCpI1DYi70iwNMJAtom0IsCKGBxBWMfxnWVIeF9xjicmZbAvPkjVyHiyAimew0VDPAuwLnZCMXj7tKcWbZrAfj2RlUHaB7y21WWESEkd8NRMfB2pMoWe+Wgi99UIzuYw2LdNEJoDqL7S+qLj78=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <789BF0A31A4DED409AE0E21EE46E32BE@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6cf6009-8b63-4dd7-0c4b-08d7f262a07e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2020 08:42:50.8667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: egzv9rAiMXFWa7DLExYg2I+DKI2E7W2bgVNVjaRbtt8YRlCVKIVohzIlHLe5Pt3bq2QGrFwTrO8hTbmNI4Mf/HupHMU5XNnxenJnwmGgKAo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5846
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA1LTA2IGF0IDIyOjExICswMzAwLCBHcnlnb3JpaSBTdHJhc2hrbyB3cm90
ZToNCj4gU2luY2UgY29tbWl0IGJjZjM0NDBjNmRkNyAoIm5ldDogcGh5OiBtaWNyZWw6IGFkZCBw
aHktbW9kZSBzdXBwb3J0IGZvcg0KPiB0aGUNCj4gS1NaOTAzMSBQSFkiKSB0aGUgbmV0d29ya2lu
ZyBpcyBicm9rZW4gb24gYm9hcmRzOg0KPiAgYW01NzF4LWlkaw0KPiAgYW01NzJ4LWlkaw0KPiAg
YW01NzR4LWlkaw0KPiAgYW01N3h4LWJlYWdsZS14MTUNCj4gDQo+IEFsbCBhYm92ZSBib2FyZHMg
aGF2ZSBwaHktbW9kZSA9ICJyZ21paSIgYW5kIHRoaXMgaXMgd29ya2VkIGJlZm9yZQ0KPiBiZWNh
dXNlDQo+IEtTWjkwMzEgUEhZIHN0YXJ0ZWQgd2l0aCBkZWZhdWx0IFJHTUlJIGludGVybmFsIGRl
bGF5cyBjb25maWd1cmF0aW9uDQo+IChUWA0KPiBvZmYsIFJYIG9uIDEuMiBucykgYW5kIE1BQyBw
cm92aWRlZCBUWCBkZWxheS4gQWZ0ZXIgYWJvdmUgY29tbWl0LCB0aGUNCj4gS1NaOTAzMSBQSFkg
c3RhcnRzIGhhbmRsaW5nIHBoeSBtb2RlIHByb3Blcmx5IGFuZCBkaXNhYmxlcyBSWCBkZWxheSwN
Cj4gYXMNCj4gcmVzdWx0IG5ldHdvcmtpbmcgaXMgYmVjb21lIGJyb2tlbi4NCj4gDQo+IEZpeCBp
dCBieSBzd2l0Y2hpbmcgdG8gcGh5LW1vZGUgPSAicmdtaWktcnhpZCIgdG8gcmVmbGVjdCBwcmV2
aW91cw0KPiBiZWhhdmlvci4NCj4gDQo+IENjOiBPbGVrc2lqIFJlbXBlbCA8by5yZW1wZWxAcGVu
Z3V0cm9uaXguZGU+DQo+IENjOiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQo+IENjOiBQ
aGlsaXBwZSBTY2hlbmtlciA8cGhpbGlwcGUuc2NoZW5rZXJAdG9yYWRleC5jb20+DQo+IEZpeGVz
OiBjb21taXQgYmNmMzQ0MGM2ZGQ3ICgibmV0OiBwaHk6IG1pY3JlbDogYWRkIHBoeS1tb2RlIHN1
cHBvcnQNCj4gZm9yIHRoZSBLU1o5MDMxIFBIWSIpDQo+IFNpZ25lZC1vZmYtYnk6IEdyeWdvcmlp
IFN0cmFzaGtvIDxncnlnb3JpaS5zdHJhc2hrb0B0aS5jb20+DQoNClRoYW5rcyBHcnlnb3JpaSEN
Cg0KUmV2aWV3ZWQtYnk6IFBoaWxpcHBlIFNjaGVua2VyIDwNCnBoaWxpcHBlLnNjaGVua2VyQHRv
cmFkZXguY29tPg0KDQo+IC0tLQ0KPiAgYXJjaC9hcm0vYm9vdC9kdHMvYW01NzF4LWlkay5kdHMg
ICAgICAgICAgICAgICAgfCA0ICsrLS0NCj4gIGFyY2gvYXJtL2Jvb3QvZHRzL2FtNTd4eC1iZWFn
bGUteDE1LWNvbW1vbi5kdHNpIHwgNCArKy0tDQo+ICBhcmNoL2FybS9ib290L2R0cy9hbTU3eHgt
aWRrLWNvbW1vbi5kdHNpICAgICAgICB8IDQgKystLQ0KPiAgMyBmaWxlcyBjaGFuZ2VkLCA2IGlu
c2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm0v
Ym9vdC9kdHMvYW01NzF4LWlkay5kdHMNCj4gYi9hcmNoL2FybS9ib290L2R0cy9hbTU3MXgtaWRr
LmR0cw0KPiBpbmRleCA2Njk1NTljOWM5NWIuLmMxMzc1NmZhMGY1NSAxMDA2NDQNCj4gLS0tIGEv
YXJjaC9hcm0vYm9vdC9kdHMvYW01NzF4LWlkay5kdHMNCj4gKysrIGIvYXJjaC9hcm0vYm9vdC9k
dHMvYW01NzF4LWlkay5kdHMNCj4gQEAgLTE5MCwxMyArMTkwLDEzIEBADQo+ICANCj4gICZjcHN3
X3BvcnQxIHsNCj4gIAlwaHktaGFuZGxlID0gPCZldGhwaHkwX3N3PjsNCj4gLQlwaHktbW9kZSA9
ICJyZ21paSI7DQo+ICsJcGh5LW1vZGUgPSAicmdtaWktcnhpZCI7DQo+ICAJdGksZHVhbC1lbWFj
LXB2aWQgPSA8MT47DQo+ICB9Ow0KPiAgDQo+ICAmY3Bzd19wb3J0MiB7DQo+ICAJcGh5LWhhbmRs
ZSA9IDwmZXRocGh5MV9zdz47DQo+IC0JcGh5LW1vZGUgPSAicmdtaWkiOw0KPiArCXBoeS1tb2Rl
ID0gInJnbWlpLXJ4aWQiOw0KPiAgCXRpLGR1YWwtZW1hYy1wdmlkID0gPDI+Ow0KPiAgfTsNCj4g
IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm0vYm9vdC9kdHMvYW01N3h4LWJlYWdsZS14MTUtY29t
bW9uLmR0c2kNCj4gYi9hcmNoL2FybS9ib290L2R0cy9hbTU3eHgtYmVhZ2xlLXgxNS1jb21tb24u
ZHRzaQ0KPiBpbmRleCBhODEzYTBjZjNmZjMuLjU2NTY3NTM1NGRlNCAxMDA2NDQNCj4gLS0tIGEv
YXJjaC9hcm0vYm9vdC9kdHMvYW01N3h4LWJlYWdsZS14MTUtY29tbW9uLmR0c2kNCj4gKysrIGIv
YXJjaC9hcm0vYm9vdC9kdHMvYW01N3h4LWJlYWdsZS14MTUtY29tbW9uLmR0c2kNCj4gQEAgLTQz
MywxMyArNDMzLDEzIEBADQo+ICANCj4gICZjcHN3X2VtYWMwIHsNCj4gIAlwaHktaGFuZGxlID0g
PCZwaHkwPjsNCj4gLQlwaHktbW9kZSA9ICJyZ21paSI7DQo+ICsJcGh5LW1vZGUgPSAicmdtaWkt
cnhpZCI7DQo+ICAJZHVhbF9lbWFjX3Jlc192bGFuID0gPDE+Ow0KPiAgfTsNCj4gIA0KPiAgJmNw
c3dfZW1hYzEgew0KPiAgCXBoeS1oYW5kbGUgPSA8JnBoeTE+Ow0KPiAtCXBoeS1tb2RlID0gInJn
bWlpIjsNCj4gKwlwaHktbW9kZSA9ICJyZ21paS1yeGlkIjsNCj4gIAlkdWFsX2VtYWNfcmVzX3Zs
YW4gPSA8Mj47DQo+ICB9Ow0KPiAgDQo+IGRpZmYgLS1naXQgYS9hcmNoL2FybS9ib290L2R0cy9h
bTU3eHgtaWRrLWNvbW1vbi5kdHNpDQo+IGIvYXJjaC9hcm0vYm9vdC9kdHMvYW01N3h4LWlkay1j
b21tb24uZHRzaQ0KPiBpbmRleCBhYTVlNTVmOTgxNzkuLmEzZmYxMjM3ZDFmYSAxMDA2NDQNCj4g
LS0tIGEvYXJjaC9hcm0vYm9vdC9kdHMvYW01N3h4LWlkay1jb21tb24uZHRzaQ0KPiArKysgYi9h
cmNoL2FybS9ib290L2R0cy9hbTU3eHgtaWRrLWNvbW1vbi5kdHNpDQo+IEBAIC00MDgsMTMgKzQw
OCwxMyBAQA0KPiAgDQo+ICAmY3Bzd19lbWFjMCB7DQo+ICAJcGh5LWhhbmRsZSA9IDwmZXRocGh5
MD47DQo+IC0JcGh5LW1vZGUgPSAicmdtaWkiOw0KPiArCXBoeS1tb2RlID0gInJnbWlpLXJ4aWQi
Ow0KPiAgCWR1YWxfZW1hY19yZXNfdmxhbiA9IDwxPjsNCj4gIH07DQo+ICANCj4gICZjcHN3X2Vt
YWMxIHsNCj4gIAlwaHktaGFuZGxlID0gPCZldGhwaHkxPjsNCj4gLQlwaHktbW9kZSA9ICJyZ21p
aSI7DQo+ICsJcGh5LW1vZGUgPSAicmdtaWktcnhpZCI7DQo+ICAJZHVhbF9lbWFjX3Jlc192bGFu
ID0gPDI+Ow0KPiAgfTsNCj4gIA0K
