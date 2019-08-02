Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFBDB801F6
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 22:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437061AbfHBUsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 16:48:50 -0400
Received: from mail-eopbgr60069.outbound.protection.outlook.com ([40.107.6.69]:27065
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726999AbfHBUsu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 16:48:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKKPKt6lZm2L+XuIhal+2QOz+HXxE6EOBTg+6AsukAKKJ+Tx21l6Li58HbVq8osfS558dkGOfAwhSJFzudbKDLGzpTyMus85+hSn+pXXaBaERGFEpmpQpFHXKOu9XeJs1Dc8NRhs5UeJAWNj5OcDzFOMmtHkD43qnbUYvEBf1pzP5gTnf8KtE6m5Ute8UwMw9xalvhkUbkayNvHINxgnIItmDIlr68WCfkAO5tsms6sxFY2xk1E6/eiKNwt2b51WJjRPvL8ptiEtRe6iTwTKo++GZwpqin5b4SxwKgW0qLsYeN8dUO7Wdg/1Fmqa5e6uXItpca4/qNxbiOnso0VLgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e0IePG6k+DcCH7EDwSjCRwvfZ6SoIz7K30rSZVnViME=;
 b=SNCJG6L2WwfI1Q8elMPKNAsgqrGWSP1211YJf+F5nZa40XBNvCtdIgHig3/YqZePvC7SkXEteY9bruCn1EIC+D5USaw2mjmMwFXBHQlTt4cvdzPNpSPKpBz0FPbbfqPGgvZ1w4l7ybW8+h8wBXHRxnV1EyyT7nd6+wQ0ZmMUyml+sGRTDaMdRCXWdasLvhdAfawB/9AFqSFowBaTCXeGjJHi+tThSCveDtm1J8kv2fh9wZcsG61zSnTp4yB7XaYgQAitxEmCgEN92fze6IbwQiVOEHnM0s5zjNpd12/aqc5hnsvQAulk0npEL9ZxUHt4BtofFW18oPxQ5O/i0DYxyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e0IePG6k+DcCH7EDwSjCRwvfZ6SoIz7K30rSZVnViME=;
 b=fFSL2KrKn0fOVjnTneGs5Zk0i7K9PYGfYUaQNNR1KFl9PEu0dQH7pMDfVH5LSc7lQLuhQbSL/Tv85bfZlLUc3atFDhYfpNIQ5GOmvD0AwIaSUOQtCTLyrZi/umdGFoTfQCMDIxXp/9MsvF9u0zQr/9lHgYQNKnEU5CcpVlsPyMg=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2645.eurprd05.prod.outlook.com (10.172.230.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Fri, 2 Aug 2019 20:48:07 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 20:48:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>
CC:     Eli Cohen <eli@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>
Subject: Re: [net-next 01/12] net/mlx5: E-Switch, add ingress rate support
Thread-Topic: [net-next 01/12] net/mlx5: E-Switch, add ingress rate support
Thread-Index: AQHVSKNDPnW5aHKn80u4pfZRmdQ1/KboII2AgAAdYICAAAY0gIAAEcKA
Date:   Fri, 2 Aug 2019 20:48:06 +0000
Message-ID: <56b51e1c9f960498ee698e412bfab278a7e79c47.camel@mellanox.com>
References: <20190801195620.26180-1-saeedm@mellanox.com>
         <20190801195620.26180-2-saeedm@mellanox.com>
         <CAADnVQ+VOSYxbF9RiMJx4kY9bxJCS+Tsf97nsOnRLvi2r6RCog@mail.gmail.com>
         <b2c77010e96b5fdb6693e5cf0a46a2017f389b44.camel@mellanox.com>
         <20190802194429.m34bpvf5hzgkop4g@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190802194429.m34bpvf5hzgkop4g@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7895880b-59ec-4202-8567-08d7178ab8d9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2645;
x-ms-traffictypediagnostic: DB6PR0501MB2645:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB6PR0501MB2645532FAC26B69B3E0F1C4ABED90@DB6PR0501MB2645.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(189003)(199004)(966005)(26005)(7736002)(478600001)(2501003)(2351001)(71190400001)(71200400001)(6116002)(3846002)(66066001)(2906002)(81156014)(53546011)(6506007)(14454004)(8676002)(102836004)(8936002)(6246003)(486006)(81166006)(1361003)(66476007)(76116006)(91956017)(66946007)(186003)(53936002)(6436002)(5640700003)(6512007)(6306002)(76176011)(36756003)(305945005)(476003)(2616005)(66446008)(446003)(5660300002)(64756008)(6916009)(14444005)(256004)(11346002)(68736007)(118296001)(58126008)(66556008)(86362001)(99286004)(316002)(25786009)(4326008)(107886003)(229853002)(54906003)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2645;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SaDoAwQwopkDXel8Ugjo0BgQyAKTykm8paaKinxsb+ndYkJRYo4W/ZGwpklcx1dDiUjq0zEz2rrJveadlmud5udDQLR3/Pa1+TbPuvM+nhMoT2JTei9CkBI+Uq9RMYPfgwqXMo79qj3Y0nBzmIVBAKDv4eQ9BckXHCGoRsKqT5KG3P8SYOnPmCn9wV3jjEttu93j4fvBn9wKN+6sklgwLIa2sAOq6AJjHcmSgZzlRX/pPjemq2O+pC+X8RQept0qPvGH9V59xBnrFV1VwerscqgXAQfThUaD5X4zxt6Lp2QKWQnLHKyMp4He7KSpS+Dm1rL9eipxkEEDSZ/IE4zWncrddovWDUT5P0A74ICQsPlDmuZdHyNUvrPrdOg5Sy1y0ImK0JCcBowyciyRvZ9vnkEQQrWf2Yd+7QvqIso/Qxc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <03E457BC966FBB4185E910C5C93F16B4@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7895880b-59ec-4202-8567-08d7178ab8d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 20:48:06.9463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2645
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA4LTAyIGF0IDEyOjQ0IC0wNzAwLCBBbGV4ZWkgU3Rhcm92b2l0b3Ygd3Jv
dGU6DQo+IE9uIEZyaSwgQXVnIDAyLCAyMDE5IGF0IDA3OjIyOjIxUE0gKzAwMDAsIFNhZWVkIE1h
aGFtZWVkIHdyb3RlOg0KPiA+IE9uIEZyaSwgMjAxOS0wOC0wMiBhdCAxMDozNyAtMDcwMCwgQWxl
eGVpIFN0YXJvdm9pdG92IHdyb3RlOg0KPiA+ID4gT24gVGh1LCBBdWcgMSwgMjAxOSBhdCA2OjMw
IFBNIFNhZWVkIE1haGFtZWVkIDwNCj4gPiA+IHNhZWVkbUBtZWxsYW5veC5jb20+DQo+ID4gPiB3
cm90ZToNCj4gPiA+ID4gRnJvbTogRWxpIENvaGVuIDxlbGlAbWVsbGFub3guY29tPg0KPiA+ID4g
PiANCj4gPiA+ID4gVXNlIHRoZSBzY2hlZHVsaW5nIGVsZW1lbnRzIHRvIGltcGxlbWVudCBpbmdy
ZXNzIHJhdGUgbGltaXRlcg0KPiA+ID4gPiBvbiBhbg0KPiA+ID4gPiBlc3dpdGNoIHBvcnRzIGlu
Z3Jlc3MgdHJhZmZpYy4gU2luY2UgdGhlIGluZ3Jlc3Mgb2YgZXN3aXRjaA0KPiA+ID4gPiBwb3J0
IGlzDQo+ID4gPiA+IHRoZQ0KPiA+ID4gPiBlZ3Jlc3Mgb2YgVkYgcG9ydCwgd2UgY29udHJvbCBl
c3dpdGNoIGluZ3Jlc3MgYnkgY29udHJvbGxpbmcgVkYNCj4gPiA+ID4gZWdyZXNzLg0KPiA+ID4g
DQo+ID4gPiBMb29rcyBsaWtlIHRoZSBwYXRjaCBpcyBvbmx5IHBhc3NpbmcgYXJncyB0byBmaXJt
d2FyZSB3aGljaCBpcw0KPiA+ID4gZG9pbmcNCj4gPiA+IHRoZSBtYWdpYy4NCj4gPiA+IENhbiB5
b3UgcGxlYXNlIGRlc2NyaWJlIHdoYXQgaXMgdGhlIGFsZ29yaXRobSB0aGVyZT8NCj4gPiA+IElz
IGl0IGNvbmZpZ3VyYWJsZT8NCj4gPiANCj4gPiBIaSBBbGV4ZWksIA0KPiA+IA0KPiA+IEkgYW0g
bm90IHN1cmUgaG93IG11Y2ggZGV0YWlscyB5b3UgYXJlIGxvb2tpbmcgZm9yLCBidXQgbGV0IG1l
DQo+ID4gc2hhcmUNCj4gPiBzb21lIG9mIHdoYXQgaSBrbm93Og0KPiA+IA0KPiA+IEZyb20gYSBw
cmV2aW91cyBzdWJtaXNzaW9uIGZvciBsZWdhY3kgbW9kZSBzcmlvdiB2ZiBidyBsaW1pdCwgd2hl
cmUNCj4gPiB3ZSANCj4gPiBpbnRyb2R1Y2VkIHRoZSBGVyBjb25maWd1cmF0aW9uIEFQSSBhbmQg
dGhlIGxlZ2FjeSBzcmlvdiB1c2UgY2FzZTogDQo+ID4gaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVs
Lm9yZy9wYXRjaC85NDA0NjU1Lw0KPiA+IA0KPiA+IFNvIGJhc2ljYWxseSB0aGUgYWxnb3JpdGht
IGlzIERlZmljaXQgV2VpZ2h0ZWQgUm91bmQgUm9iaW4gKERXUlIpDQo+ID4gYmV0d2VlbiB0aGUg
YWdlbnRzLCB3ZSBjYW4gY29udHJvbCBCVyBhbGxvY2F0aW9uL3dlaWdodCBvZiBlYWNoDQo+ID4g
YWdlbnQNCj4gPiAodmYgdnBvcnQpLg0KPiANCj4gY29tbWl0IGxvZyBvZiB0aGlzIHBhdGNoIHNh
eXMgbm90aGluZyBhYm91dCBEV1JSLg0KDQppdCBzYXlzIGl0IHVzZXMgdGhlICJzY2hlZHVsaW5n
IGVsZW1lbnRzIGluZ3Jlc3MgcmF0ZSBsaW1pdGVyIiB3aGljaA0KYXV0b21hdGljYWxseSB0cmFu
c2xhdGVzIHRvIERXUlIsIHRoaXMgaXMgYmFzaWMga25vd2xlZGdlIGZvciBtbHg1DQpkZXZlbG9w
ZXJzLCBhbmQgaXQgaXMgY2xlYXIgaW4gdGhlIGNvbW1pdCBtZXNzYWdlIHdoZW4gdGhlIEZXIEFQ
SSB3YXMNCmludHJvZHVjZWQuDQoNCj4gSXQgaXMgYWxzbyBub3QgdXNpbmcgYW55IG9mIHRoZSBh
cGkgdGhhdCB3ZXJlIHByb3ZpZGVkIGJ5IHRoYXQNCj4gZWFybGllciBwYXRjaC4NCg0KSXQgaXMg
dXNpbmcgdGhlIGFwaTogDQptbHg1ZV90Y19jb25maWd1cmVfbWF0Y2hhbGwgPT4gYXBwbHlfcG9s
aWNlX3BhcmFtcyA9Pg0KbWx4NV9lc3dfbW9kaWZ5X3Zwb3J0X3JhdGUgPT4gbWx4NV9tb2RpZnlf
c2NoZWR1bGluZ19lbGVtZW50X2NtZCgpLi4NCg0KPiB3aGF0IGlzIGdvaW5nIG9uPw0KPiANCg0K
Y2FuIHlvdSBwbGVhc2UgY2xhcmlmeSB3aGF0IGlzIGJvdGhlcmluZyB5b3UgPyB3ZSBjYW4gZml4
IGl0IGlmDQpuZWNlc3NhcnkuDQoNClRoYW5rcywNClNhZWVkLg0KDQoNCg==
