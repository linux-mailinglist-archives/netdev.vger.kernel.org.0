Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFFC93BBDA
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 20:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387500AbfFJScO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 14:32:14 -0400
Received: from mail-eopbgr70043.outbound.protection.outlook.com ([40.107.7.43]:28036
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726214AbfFJScO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 14:32:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iy70Os0iG78rxan88n9/gp4sQkE/kR58/A04tJM9RuY=;
 b=GO4MtGbP9jhV1RU1bzw/CxSKcTZBWZuPo5Pcg9ccTWQ3yjSPdi+A8LP5eohRZBeerAPtlB0CUe2QSVC4G+FC4LHk6sjkSoGtZuxCrdk109M8Meh9FsFz7VJ3TQxBWrMwxt5KvzfvWdi1L9NWuVh96TKULpxrFs992LOJWk557Hg=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB2621.eurprd03.prod.outlook.com (10.171.103.146) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.17; Mon, 10 Jun 2019 18:32:09 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::74:c526:8946:7cf3]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::74:c526:8946:7cf3%2]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 18:32:09 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     David Ahern <dsahern@gmail.com>
CC:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        "toke@redhat.com" <toke@redhat.com>
Subject: Re: [PATCH iproute2-next v2] tc: add support for action act_ctinfo
Thread-Topic: [PATCH iproute2-next v2] tc: add support for action act_ctinfo
Thread-Index: AQHVGtzNurC7hdDeX0mmNovBMm5F+qaVL32AgAAQaAA=
Date:   Mon, 10 Jun 2019 18:32:09 +0000
Message-ID: <1F6A10E4-A704-4796-BB7D-1F45F2376746@darbyshire-bryant.me.uk>
References: <20190603135219.180df8e6@hermes.lan>
 <20190604135208.94432-1-ldir@darbyshire-bryant.me.uk>
 <0d3ae9d1-ec38-22b8-e7a2-fa832f305e90@gmail.com>
In-Reply-To: <0d3ae9d1-ec38-22b8-e7a2-fa832f305e90@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.240.142.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c429892b-106e-41f4-6f76-08d6edd1f2be
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR0302MB2621;
x-ms-traffictypediagnostic: VI1PR0302MB2621:
x-microsoft-antispam-prvs: <VI1PR0302MB26218BF0A68182863ED09D3FC9130@VI1PR0302MB2621.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39830400003)(366004)(136003)(396003)(346002)(376002)(199004)(189003)(76176011)(256004)(91956017)(229853002)(26005)(14454004)(102836004)(14444005)(86362001)(6486002)(99286004)(6506007)(71190400001)(81166006)(186003)(53546011)(83716004)(71200400001)(53936002)(8936002)(33656002)(66946007)(6512007)(446003)(76116006)(7736002)(73956011)(81156014)(8676002)(66446008)(64756008)(6916009)(66556008)(305945005)(25786009)(66476007)(476003)(508600001)(2616005)(486006)(11346002)(6436002)(4326008)(6246003)(36756003)(1411001)(5660300002)(2906002)(316002)(68736007)(54906003)(6116002)(3846002)(82746002)(74482002)(4744005)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB2621;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mxUy3ms6V+I6jKWCniZgBxpiBT3IQLMAMef5gseya9pnbc1XKXU+TSmkH/bDFj1I1XYHlC4VEIEug+qYj2e63d/6Qj65yFuVseP+8gl9WNNUCNhwVtryD0aKhtMnmnzjK6KCgHg9gEH8T1pJZDJ1byCqdThD4lfbjFlhS/0QALY5hy48aBpstkzN381FTAY3EqZGVOPsFoYoXWIzDfGU9FW1cVL9uqXDgJNJe958qYnY8qOMJppezryouDmGoFZh/GXtynY6Rp+18CT9qKPrRCn+qvOfLiIqX1S3TAXpZNdULRIsAn6a+R1xgQuypBHRYqTqad6Q9cUHBwXrvLKN9MgBzOIX5PbxfjH4s2OCFzpRV3tyozsgfWnMkh1vyjtQMT39J8fGX2AXnP9A3FGQ+8/L01YyVSExDPC95qdmcYE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A34C914A8475042BDE1D6B182434C18@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: c429892b-106e-41f4-6f76-08d6edd1f2be
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 18:32:09.4917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevin@darbyshire-bryant.me.uk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2621
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMTAgSnVuIDIwMTksIGF0IDE4OjMzLCBEYXZpZCBBaGVybiA8ZHNhaGVybkBnbWFp
bC5jb20+IHdyb3RlOg0KPiANCj4gT24gNi80LzE5IDc6NTIgQU0sIEtldmluIERhcmJ5c2hpcmUt
QnJ5YW50IHdyb3RlOg0KPj4gY3RpbmZvIGlzIGEgdGMgYWN0aW9uIHJlc3RvcmluZyBkYXRhIHN0
b3JlZCBpbiBjb25udHJhY2sgbWFya3MgdG8NCj4+IA0KPHNuaXBwZWQ+DQo+PiBjcmVhdGUgbW9k
ZSAxMDA2NDQgaW5jbHVkZS91YXBpL2xpbnV4L3RjX2FjdC90Y19jdGluZm8uaA0KPj4gY3JlYXRl
IG1vZGUgMTAwNjQ0IG1hbi9tYW44L3RjLWN0aW5mby44DQo+PiBjcmVhdGUgbW9kZSAxMDA2NDQg
dGMvbV9jdGluZm8uYw0KPj4gDQo+IA0KPiBEcm9wcGVkIHRoZSB1YXBpIGJpdHM7IHRob3NlIGFy
ZSBhcHBsaWVkIHNlcGFyYXRlbHkgYW5kIGZpeGVkIGEgZmV3DQo+IGxpbmVzIHRoYXQgaGFkIHNw
YWNlcyBhdCB0aGUgZW5kLg0KPiANCj4gYXBwbGllZCB0byBpcHJvdXRlMi1uZXh0LiBUaGFua3MN
Cg0KT2ggd293LiAgVGhhbmsgeW91LiAgTXVjaCBhcHByZWNpYXRlZC4gIEFwb2xvZ2llcyBmb3Ig
dGhlIHJvZ3VlIHNwYWNlcy4NCg0KVGhhdOKAmXMgdGhlIHJlc3RvcmUgYml0IGRvbmUsIHRpbWUg
dG8gY29uY2VudHJhdGUgb24gdGhlIHNldHRpbmcgc2lkZQ0Kb2YgdGhpbmdzIG5vdy4NCg0KDQpL
ZXZpbiBELUINCg0KZ3BnOiAwMTJDIEFDQjIgMjhDNiBDNTNFIDk3NzUgIDkxMjMgQjNBMiAzODlC
IDlERTIgMzM0QQ0KDQo=
