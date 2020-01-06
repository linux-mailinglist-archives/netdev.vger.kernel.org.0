Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF97131AE8
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgAFV7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:59:36 -0500
Received: from mail-eopbgr30066.outbound.protection.outlook.com ([40.107.3.66]:49223
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726721AbgAFV7f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 16:59:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1Hb+ytl6pVCIYGYuKAUL4IfRkJwoBSR2l/G2JrBVlcc0QrUgjxyG44wmyWS9CCYcXmm6M2g3xvyaZsksspyYeOh3Ay3EUZTv0NwjFigpv8cJ+VXMTaa8fGqpBF0Wc2BeCjYeyuIvbd83LnZf+CEuKy2qHSrge0b5Z1FPp7tJRybmO2xvf88vH3wMtRaq/lAooMOoXJMl648zRG3sp456IjusGaOp/wzWo6SVkoIvEF8owlZPd/wRuEFg97CovVg81Iqj6/fCmPEl/OXql59PQPEb3Ib8vMpaiFKitcMfbgxy5RAUJcElxCBxwrUu5QsIwESlyVd1pdZsxKJU57hjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0sH9CFyQ39ShtJFKATt+Kw+ab5ZKED9G/vYgASH3a0=;
 b=PqakB6ik3tyScO+chIKRcese5E+WAF9gqKXXIia7HzAqP5/61zaiItc9w8GJLT0RNINlsUaQaqPk3f9BrVuy25rNrNjZxQp01kp3z8UC6cHusbh9qZOd/Mp5y5PdRVWitxxSznF7kUY8uCcuUjpDBTlf2DvqMq0yZFPY5UYLlZn9xuPkPWTZIbNYtAkWrCacUOFdpBiLikv2/9v9tbIwWeUyxcNFQprkjl/QiWaOde2qi82X/E7f8Bt/yQ+W2+d43RtcBP0y0cfUU2j9GMELMkjcv09mv3v7V1O0HaOZJP7X9Svcroji0FAybS0F+BXDJug+gn1K13YJYXuvyS+FCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0sH9CFyQ39ShtJFKATt+Kw+ab5ZKED9G/vYgASH3a0=;
 b=nVlVKLOcmOCxxsGzgRvMNCe+3cUYsypNHRc1udqv/H8u5nXfYtLrsrGy2Bsdt4gu87ax5GS1Nlhrsh2PU37gFA5DriE21nLWDUfPYvZJku97oMWxeAPMlrNj7TDkWLsTeUDfQd1pbpQt07PDG1mldH/Z257GonL8V2S07uF7sXo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3263.eurprd05.prod.outlook.com (10.170.238.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Mon, 6 Jan 2020 21:59:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 21:59:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@redhat.com" <davem@redhat.com>,
        "arnd@arndb.de" <arnd@arndb.de>
CC:     Aya Levin <ayal@mellanox.com>, Shay Agroskin <shayag@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "adhemerval.zanella@linaro.org" <adhemerval.zanella@linaro.org>
Subject: Re: [PATCH] mlx5: work around high stack usage with gcc
Thread-Topic: [PATCH] mlx5: work around high stack usage with gcc
Thread-Index: AQHVw0kzsw03dQvW2Uqe2O1L3hoaFKfeK6sAgAAG5AA=
Date:   Mon, 6 Jan 2020 21:59:30 +0000
Message-ID: <057f4159f41b1d470d47a375435bc5afcb2c0261.camel@mellanox.com>
References: <20200104215156.689245-1-arnd@arndb.de>
         <20200106.133448.1654261172205332113.davem@redhat.com>
In-Reply-To: <20200106.133448.1654261172205332113.davem@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.2 (3.34.2-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 127d17b7-3b62-4051-19c3-08d792f3b505
x-ms-traffictypediagnostic: VI1PR05MB3263:|VI1PR05MB3263:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB3263A10A1043DDD9C71ED172BE3C0@VI1PR05MB3263.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(189003)(199004)(2616005)(186003)(6486002)(478600001)(76116006)(66446008)(66946007)(66476007)(64756008)(66556008)(6512007)(26005)(71200400001)(6506007)(91956017)(110136005)(966005)(2906002)(36756003)(316002)(86362001)(8936002)(54906003)(4326008)(5660300002)(8676002)(81156014)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3263;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hc3eYdV2/hdV6v2TzYmfxmMy0uFH2rI30OfqXwpAHTmz/RoWYhCH1fPq1GN4M5nPdVEygUxD7CblYM0JgPhBY57MYBZUNTXPHNxtXhx7b6Jt8cSDzUkxb1LuXaWTN3N8nFm7GooaiZ4kC9ujG7CdZxcscbTqNpHw3ZCy8r1SDPjEtDyT4cqAkFgeh+vULBEAyDo4iT8e12kM6+aoZgQiPnnCxywf8Vvb4NWkhGDyKnQgP/ATRugRUx5g2SlaD3YzYAJdAXfEJBFBItXdB408QQyHQ4YLCfyPcu+DVJLq/z9YpbZd0sot+rgmY1ymbQe9g2KHhUdjBZ7XTBctTONtpDr3OkZSTUgGbBvM2pPtSr8zNkD2WmXCI5tBLE4ED/M/PeSLOujx3E81bpqPDHWbcxpcZdVaj9vHQulnJFf1UpXY6F6AqA0FtPCJWjNfm9rDBk8KDKLRa3b3qlgZ/sJFyz/aOYTcIN+yxT629E8VzTQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E38C54E7607F94ABD2B17EF5FFDC135@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 127d17b7-3b62-4051-19c3-08d792f3b505
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 21:59:30.5254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OEJeWZwyki/7ghEWLu/5UOSJdR8yX1GoObLB7Gh+n70s818QyRJXUy+HEfzCqAFOaIUppns85bLVikd13u1vcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3263
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTAxLTA2IGF0IDEzOjM0IC0wODAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+DQo+IERhdGU6IFNhdCwgIDQgSmFu
IDIwMjAgMjI6NTE6NDQgKzAxMDANCj4gDQo+ID4gSW4gc29tZSBjb25maWd1cmF0aW9ucywgZ2Nj
IHRyaWVzIHRvbyBoYXJkIHRvIG9wdGltaXplIHRoaXMgY29kZToNCj4gPiANCj4gPiBkcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fc3RhdHMuYzogSW4gZnVuY3Rpb24N
Cj4gJ21seDVlX2dycF9zd191cGRhdGVfc3RhdHMnOg0KPiA+IGRyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbl9zdGF0cy5jOjMwMjoxOiBlcnJvcjoNCj4gdGhlIGZyYW1l
IHNpemUgb2YgMTMzNiBieXRlcyBpcyBsYXJnZXIgdGhhbiAxMDI0IGJ5dGVzIFstDQo+IFdlcnJv
cj1mcmFtZS1sYXJnZXItdGhhbj1dDQo+ID4gDQo+ID4gQXMgd2FzIHN0YXRlZCBpbiB0aGUgYnVn
IHJlcG9ydCwgdGhlIHJlYXNvbiBpcyB0aGF0IGdjYyBydW5zIGludG8gYQ0KPiBjb3JuZXINCj4g
PiBjYXNlIGluIHRoZSByZWdpc3RlciBhbGxvY2F0b3IgdGhhdCBpcyByYXRoZXIgaGFyZCB0byBm
aXggaW4gYSBnb29kDQo+IHdheS4NCj4gPiANCj4gPiBBcyB0aGVyZSBpcyBhbiBlYXN5IHdheSB0
byB3b3JrIGFyb3VuZCBpdCwganVzdCBhZGQgYSBjb21tZW50IGFuZA0KPiB0aGUNCj4gPiBiYXJy
aWVyIHRoYXQgc3RvcHMgZ2NjIGZyb20gdHJ5aW5nIHRvIG92ZXJvcHRpbWl6ZSB0aGUgZnVuY3Rp
b24uDQo+ID4gDQo+ID4gTGluazogaHR0cHM6Ly9nY2MuZ251Lm9yZy9idWd6aWxsYS9zaG93X2J1
Zy5jZ2k/aWQ9OTI2NTcNCj4gPiBDYzogQWRoZW1lcnZhbCBaYW5lbGxhIDxhZGhlbWVydmFsLnph
bmVsbGFAbGluYXJvLm9yZz4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5k
QGFybmRiLmRlPg0KPiANCj4gU2FlZWQsIHBsZWFzZSB0YWtlIHRoaXMuDQo+IA0KPiBUaGFuayB5
b3UuDQo+IA0KDQpBcHBsaWVkIHRvIG5ldC1uZXh0LW1seDUNCg0Kd2lsbCBzdWJtaXQgdG8gbmV0
LW5leHQgbGF0ZXIgdG9kYXkuDQoNClRoYW5rcyAhIA0K
