Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9DDD77EFE
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 12:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbfG1KEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 06:04:46 -0400
Received: from mail-eopbgr10052.outbound.protection.outlook.com ([40.107.1.52]:47495
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725961AbfG1KEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Jul 2019 06:04:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJqIsbwGVupg7UJYNv/sT/R7SrHSYZ3IT0E5BWRBgBInrzD7nNxFiCkMi10S58YsiaqFTHvr0gvTmLywqz7E1F4YAwOI3tAhTF03bBDEMSHErR6QWCBL89jXlzltQKyq+LJ8ygvX6/xuU1TtXee+2paLCCEEEsb1qZ/gLCq0+O2q3AU4rGQsADI51TKwl8A9KIlJ9XQ+rCNLlU7OF7ZNB30q72cZGJFErLw6P6QHNO8pb44zzhz3R2kKPhSZrogmcDnTlOe7XNUllxmzpnJ8VYlBh24PyVYOk6Nvr5N6QaBDe/gl94dnEr+gQrTzP7HEl2wwtkhUUxBkuz2TldAVMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B5UAS44GuuwkEA2V1eWyahpD5FLwIvm4iDRTdo+Bigo=;
 b=enpbnZBtons2j06S8t8QX1t7U8GakOHFyyVrwE6QuEl7WquqvdQTjkE3sCv2t8wIe1mGke+v7YF3XuvUJs4JpTTJwX8er76q+nLSe/IX0CecjW7rmOC48Z5C0ah0bZrASEkvGcN/Ge8wHo35GLxi5b0uQ0SzEozVPWWIhkZvLE+cxApfUF31d5k47upPaNzvFQGNE+iZh89G/KXCRShBaCxtm8r15Cg8vRgFFvvg1d+CGSiXCOvTmZLGAA0vAHHelHf9FxRGQHU5YQqRd0ufQ1nnQndf88AwcvNYkk4YWkYFn3jqNRk2dzBmxBJYRGjEtEVI2Nh8ovjGpezSOPfZew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B5UAS44GuuwkEA2V1eWyahpD5FLwIvm4iDRTdo+Bigo=;
 b=niQ7tFSLwqmdVtNxu4SON8wjpGYGgaD530AtxsXtYkLvZwIoQ+NRe0RBlM8xqo3SA8h7GRWhicwjZXc0cWNF4Jp+bKmHTKZQpFeRMYLmWbuTpQj0iq++/tJ6hOKluOg/Q6tbpyDepAH5q5WUM+W8VN77nCa95n2OfgquShMHo00=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3219.eurprd05.prod.outlook.com (10.170.126.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Sun, 28 Jul 2019 10:04:40 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::d027:14a2:95db:6f1f]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::d027:14a2:95db:6f1f%7]) with mapi id 15.20.2115.005; Sun, 28 Jul 2019
 10:04:40 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        wenxu <wenxu@ucloud.cn>
CC:     Or Gerlitz <gerlitz.or@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] net/mlx5e: Fix zero table prio set by user.
Thread-Topic: [PATCH] net/mlx5e: Fix zero table prio set by user.
Thread-Index: AQHVQy8UfL9U6tzPAEGn17vM8sqTq6bc0kuAgAAFvICAABboAIACx+bw
Date:   Sun, 28 Jul 2019 10:04:40 +0000
Message-ID: <AM4PR05MB3411EB711FA8B14D8F8B75ACCFC20@AM4PR05MB3411.eurprd05.prod.outlook.com>
References: <1564053847-28756-1-git-send-email-wenxu@ucloud.cn>
 <7b03d1fdda172ce99c3693d8403cbdaf5a31bb6c.camel@mellanox.com>
 <CAJ3xEMi65JcF97nHeE482xgkps0GLLso+b6hp=34uX+wF=BjiQ@mail.gmail.com>
 <692b090f-c19e-aa8b-796e-17999ac79df1@ucloud.cn>
 <20190726140142.GC4063@localhost.localdomain>
In-Reply-To: <20190726140142.GC4063@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f757b278-89cd-4939-37ca-08d71343017a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3219;
x-ms-traffictypediagnostic: AM4PR05MB3219:
x-microsoft-antispam-prvs: <AM4PR05MB3219EB954EA250C2FD4CFFDBCFC20@AM4PR05MB3219.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01128BA907
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(189003)(199004)(476003)(486006)(6246003)(14454004)(7736002)(53546011)(4326008)(6506007)(446003)(66556008)(14444005)(256004)(66946007)(66476007)(8936002)(305945005)(478600001)(8676002)(102836004)(26005)(2906002)(76176011)(25786009)(76116006)(99286004)(74316002)(52536014)(11346002)(7696005)(66446008)(64756008)(186003)(81156014)(81166006)(5660300002)(86362001)(9686003)(33656002)(6436002)(229853002)(71200400001)(71190400001)(55016002)(53936002)(316002)(110136005)(54906003)(68736007)(3846002)(6116002)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3219;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pEYUZWxR7Xrhk2681HU6ZJXgN6Eskd/DLc6/nR6puDOhlR50c+NrLN4KxzEC9hFGe5NDj6i3LcDtO+fjk2Wyxp0ipJ+zv7rLypuGGY8r9PfRzNRD5248E0OkKM1SS0JWDrpQJ/8bjugZTWgqs8NTCzlPnYxMVDdYQRd5HmBbqJug0m0nm8AJukpS1Rp+skRCJvewc3yPWdI3mX6XINqLRCE3IImFRm7tHO0gC0DDXU9e7tM2JPwpQ6lX8W5flzWvUeNfic5yG/+2XZF3JPweEuj9D9lcFan7UvbQVPOb7L2+WKyJjT2ZJyTKzNBNW9qrCZaLdepX6fA0V+tq9P3P668wS6ob47gpQe1PuNFMn6Cp5nGMGakP2DbXh6TwnioYiAR4gld8cNm5BPpebIbnRNRggM/so8HecApeEKLEdek=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f757b278-89cd-4939-37ca-08d71343017a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2019 10:04:40.3448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paulb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3219
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA3LzI2LzIwMTkgNTowMSBQTSwgTWFyY2VsbyBSaWNhcmRvIExlaXRuZXIgd3JvdGU6DQo+
IE9uIEZyaSwgSnVsIDI2LCAyMDE5IGF0IDA4OjM5OjQzUE0gKzA4MDAsIHdlbnh1IHdyb3RlOg0K
Pj4NCj4+IOWcqCAyMDE5LzcvMjYgMjA6MTksIE9yIEdlcmxpdHog5YaZ6YGTOg0KPj4+IE9uIEZy
aSwgSnVsIDI2LCAyMDE5IGF0IDEyOjI0IEFNIFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFu
b3guY29tPiB3cm90ZToNCj4+Pj4gT24gVGh1LCAyMDE5LTA3LTI1IGF0IDE5OjI0ICswODAwLCB3
ZW54dUB1Y2xvdWQuY24gd3JvdGU6DQo+Pj4+PiBGcm9tOiB3ZW54dSA8d2VueHVAdWNsb3VkLmNu
Pg0KPj4+Pj4NCj4+Pj4+IFRoZSBmbG93X2Nsc19jb21tb25fb2ZmbG9hZCBwcmlvIGlzIHplcm8N
Cj4+Pj4+DQo+Pj4+PiBJdCBsZWFkcyB0aGUgaW52YWxpZCB0YWJsZSBwcmlvIGluIGh3Lg0KPj4+
Pj4NCj4+Pj4+IEVycm9yOiBDb3VsZCBub3QgcHJvY2VzcyBydWxlOiBJbnZhbGlkIGFyZ3VtZW50
DQo+Pj4+Pg0KPj4+Pj4ga2VybmVsIGxvZzoNCj4+Pj4+IG1seDVfY29yZSAwMDAwOjgxOjAwLjA6
IEUtU3dpdGNoOiBGYWlsZWQgdG8gY3JlYXRlIEZEQiBUYWJsZSBlcnIgLTIyDQo+Pj4+PiAodGFi
bGUgcHJpbzogNjU1MzUsIGxldmVsOiAwLCBzaXplOiA0MTk0MzA0KQ0KPj4+Pj4NCj4+Pj4+IHRh
YmxlX3ByaW8gPSAoY2hhaW4gKiBGREJfTUFYX1BSSU8pICsgcHJpbyAtIDE7DQo+Pj4+PiBzaG91
bGQgY2hlY2sgKGNoYWluICogRkRCX01BWF9QUklPKSArIHByaW8gaXMgbm90IDANCj4+Pj4+DQo+
Pj4+PiBTaWduZWQtb2ZmLWJ5OiB3ZW54dSA8d2VueHVAdWNsb3VkLmNuPg0KPj4+Pj4gLS0tDQo+
Pj4+PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2Zm
bG9hZHMuYyB8IDQgKysrLQ0KPj4+Pj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyks
IDEgZGVsZXRpb24oLSkNCj4+Pj4+DQo+Pj4+PiBkaWZmIC0tZ2l0DQo+Pj4+PiBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMNCj4+Pj4+
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2ZmbG9h
ZHMuYw0KPj4+Pj4gaW5kZXggMDg5YWU0ZC4uNjRjYTkwZiAxMDA2NDQNCj4+Pj4+IC0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMN
Cj4+Pj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dp
dGNoX29mZmxvYWRzLmMNCj4+Pj4+IEBAIC05NzAsNyArOTcwLDkgQEAgc3RhdGljIGludCBlc3df
YWRkX2ZkYl9taXNzX3J1bGUoc3RydWN0DQo+Pj4+IHRoaXMgcGllY2Ugb2YgY29kZSBpc24ndCBp
biB0aGlzIGZ1bmN0aW9uLCB3ZWlyZCBob3cgaXQgZ290IHRvIHRoZQ0KPj4+PiBkaWZmLCBwYXRj
aCBhcHBsaWVzIGNvcnJlY3RseSB0aG91Z2ggIQ0KPj4+Pg0KPj4+Pj4gbWx4NV9lc3dpdGNoICpl
c3cpDQo+Pj4+PiAgICAgICAgICAgICAgIGZsYWdzIHw9IChNTFg1X0ZMT1dfVEFCTEVfVFVOTkVM
X0VOX1JFRk9STUFUIHwNCj4+Pj4+ICAgICAgICAgICAgICAgICAgICAgICAgIE1MWDVfRkxPV19U
QUJMRV9UVU5ORUxfRU5fREVDQVApOw0KPj4+Pj4NCj4+Pj4+IC0gICAgIHRhYmxlX3ByaW8gPSAo
Y2hhaW4gKiBGREJfTUFYX1BSSU8pICsgcHJpbyAtIDE7DQo+Pj4+PiArICAgICB0YWJsZV9wcmlv
ID0gKGNoYWluICogRkRCX01BWF9QUklPKSArIHByaW87DQo+Pj4+PiArICAgICBpZiAodGFibGVf
cHJpbykNCj4+Pj4+ICsgICAgICAgICAgICAgdGFibGVfcHJpbyA9IHRhYmxlX3ByaW8gLSAxOw0K
Pj4+Pj4NCj4+Pj4gVGhpcyBpcyBibGFjayBtYWdpYywgZXZlbiBiZWZvcmUgdGhpcyBmaXguDQo+
Pj4+IHRoaXMgLTEgc2VlbXMgdG8gYmUgbmVlZGVkIGluIG9yZGVyIHRvIGNhbGwNCj4+Pj4gY3Jl
YXRlX25leHRfc2l6ZV90YWJsZSh0YWJsZV9wcmlvKSB3aXRoIHRoZSBwcmV2aW91cyAidGFibGUg
cHJpbyIgPw0KPj4+PiAodGFibGVfcHJpbyAtIDEpICA/DQo+Pj4+DQo+Pj4+IFRoZSB3aG9sZSB0
aGluZyBsb29rcyB3cm9uZyB0byBtZSBzaW5jZSB3aGVuIHByaW8gaXMgMCBhbmQgY2hhaW4gaXMg
MCwNCj4+Pj4gdGhlcmUgaXMgbm90IHN1Y2ggdGhpbmcgdGFibGVfcHJpbyAtIDEuDQo+Pj4+DQo+
Pj4+IG1sbnggZXN3aXRjaCBndXlzIGluIHRoZSBjYywgcGxlYXNlIGFkdmlzZS4NCj4+PiBiYXNp
Y2FsbHksIHByaW8gMCBpcyBub3Qgc29tZXRoaW5nIHdlIGV2ZXIgZ2V0IGluIHRoZSBkcml2ZXIs
IHNpbmNlIGlmDQo+Pj4gdXNlciBzcGFjZQ0KPj4+IHNwZWNpZmllcyAwLCB0aGUga2VybmVsIGdl
bmVyYXRlcyBzb21lIHJhbmRvbSBub24temVybyBwcmlvLCBhbmQgd2Ugc3VwcG9ydA0KPj4+IG9u
bHkgcHJpb3MgMS0xNiAtLSBXZW54dSAtLSB3aGF0IGRvIHlvdSBydW4gdG8gZ2V0IHRoaXMgZXJy
b3I/DQo+Pj4NCj4+Pg0KPj4gSSBydW4gb2ZmbG9hZCB3aXRoIG5mYXRibGVzKGJ1dCBub3QgdGMp
LCB0aGVyZSBpcyBubyBwcmlvIGZvciBlYWNoIHJ1bGUuDQo+Pg0KPj4gcHJpbyBvZiBmbG93X2Ns
c19jb21tb25fb2ZmbG9hZCBpbml0IGFzIDAuDQo+Pg0KPj4gc3RhdGljIHZvaWQgbmZ0X2Zsb3df
b2ZmbG9hZF9jb21tb25faW5pdChzdHJ1Y3QgZmxvd19jbHNfY29tbW9uX29mZmxvYWQgKmNvbW1v
biwNCj4+DQo+PiAgICAgICAgICAgICAgICAgICAgICBfX2JlMTYgcHJvdG8sDQo+PiAgICAgICAg
ICAgICAgICAgICAgIHN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4dGFjaykNCj4+IHsNCj4+ICAg
ICBjb21tb24tPnByb3RvY29sID0gcHJvdG87DQo+PiAgICAgY29tbW9uLT5leHRhY2sgPSBleHRh
Y2s7DQo+PiB9DQo+Pg0KPj4NCj4+IGZsb3dfY2xzX2NvbW1vbl9vZmZsb2FkDQo+DQo+IE5vdGUg
dGhhdCBvbg0KPiBbUEFUQ0ggbmV0LW5leHRdIG5ldGZpbHRlcjogbmZfdGFibGVfb2ZmbG9hZDog
Rml4IHplcm8gcHJpbyBvZiBmbG93X2Nsc19jb21tb25fb2ZmbG9hZA0KPiBJIGFza2VkIFBhYmxv
IG9uIGhvdyBuZnRhYmxlcyBzaG91bGQgYmVoYXZlIG9uIHRoaXMgc2l0dWF0aW9uLg0KPg0KPiBJ
dCdzIHRoZSBzYW1lIGlzc3VlIGFzIGluIHRoZSBwYXRjaCBhYm92ZSBidXQgYmVpbmcgZml4ZWQg
YXQgYQ0KPiBkaWZmZXJlbnQgbGV2ZWwuDQoNClRoYXQncyBiZXR0ZXIsIHNpbmNlIHRoZSBvcmln
aW5hbCBjb2RlIHJlbGllZCBvbiBub3QgaGF2aW5nIHByaW8gMCBhcyB2YWxpZCwgdGhlIHN1Z2dl
c3RlZCBmaXggKG5ldC9tbHg1ZTogRml4IHplcm8gdGFibGUgcHJpbyBzZXQgYnkgdXNlcikgbWFw
cyBORlQgb2ZmbG9hZCBwcmlvIDAgYW5kIHRjIHByaW8gMSB0byB0aGUgc2FtZQ0KDQpoYXJkd2Fy
ZSB0YWJsZS4gVGhpcyBpcyB3cm9uZyBhbmQgY2FuIGNhdXNlIGlzc3Vlcy4NCg==
