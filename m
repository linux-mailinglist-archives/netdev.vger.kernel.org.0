Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACDEB438B0
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732591AbfFMPHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:07:44 -0400
Received: from mail-eopbgr20046.outbound.protection.outlook.com ([40.107.2.46]:23618
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732392AbfFMOCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 10:02:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5CrquF4enKfagJjpgecW5N5Sj1CkibVoY4w9l5058eI=;
 b=F78G6zqxzj5/WWb4jfwVZr6qn9Sjab5zZV+C19Dg8z3G9BkXnZgDKZ4g9T09bE7QT4rhrVn2vfBS/0RCCLDn2v3sol+jUOnTSjnCl1USiRu4OsSctE/12NI2r6XQzn0q9V9NVB9SFcIC825YC4uo6d9qW3cSVExcLie6nth5vTA=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5688.eurprd05.prod.outlook.com (20.178.94.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 13 Jun 2019 14:01:57 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Thu, 13 Jun 2019
 14:01:57 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next v4 00/17] AF_XDP infrastructure improvements and
 mlx5e support
Thread-Topic: [PATCH bpf-next v4 00/17] AF_XDP infrastructure improvements and
 mlx5e support
Thread-Index: AQHVITdoe6rurVkq00yTWSmwKXBCXaaYfdWAgAEPPACAABGPgA==
Date:   Thu, 13 Jun 2019 14:01:57 +0000
Message-ID: <65cf2b7b-79a5-c660-358c-a265fc03b495@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
 <20190612134805.3bf4ea25@cakuba.netronome.com>
 <CAJ+HfNh3KcoZC5W6CLgnx2tzH41Kz11Zs__2QkOKF+CyEMzdMQ@mail.gmail.com>
In-Reply-To: <CAJ+HfNh3KcoZC5W6CLgnx2tzH41Kz11Zs__2QkOKF+CyEMzdMQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR11CA0050.namprd11.prod.outlook.com
 (2603:10b6:a03:80::27) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [159.224.90.213]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 795bb6ef-69c6-440c-f6fa-08d6f007b2a5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5688;
x-ms-traffictypediagnostic: AM6PR05MB5688:
x-microsoft-antispam-prvs: <AM6PR05MB5688F58F09891B4D59DB1B4AD1EF0@AM6PR05MB5688.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(136003)(366004)(396003)(376002)(189003)(199004)(31696002)(86362001)(73956011)(66556008)(476003)(71190400001)(71200400001)(486006)(256004)(5024004)(26005)(2616005)(99286004)(66476007)(66946007)(52116002)(446003)(186003)(31686004)(53546011)(11346002)(316002)(386003)(6506007)(102836004)(55236004)(5660300002)(66066001)(76176011)(7416002)(36756003)(7736002)(6246003)(8936002)(3846002)(6116002)(6436002)(4326008)(25786009)(53936002)(110136005)(478600001)(66446008)(64756008)(68736007)(14454004)(229853002)(81166006)(81156014)(2906002)(6486002)(54906003)(6512007)(305945005)(8676002)(42413003)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5688;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fP9i2afz0qbLBm96sJh2MMKkw7Byc8JNRK745OjrP6hmPLYPhEYupe7Il1eDRyyRNcIp0U+ctvRxq4XWT6/WJBIZypp/o7chNEVidD/0AjTQ5JpG3doClz4mupDCfbLS+UHtJp6NqYdV4OX8DDW597lR+LIUTAhRPkFmx+bHHx7LwIXd3OQxN2MUfT5reCfBkLYtk2Ru4xO/7zHxo0aivDHxJZP3YozU0pyUU2DH6c6XQJYJ0qtHhjJiSU/mW9We/g3kMrISMMim5FZhlxlj3gdVCHeyh1o5n6iCOt11GYmsNHw2ctDhqr/M7hVvSjNY0D3b2oLEJci0klb8QwsoojQOHGHIKwG0a9yUkBFuEaywPcdfzgKudN+etD8Qk7MMuBNMw6sptyXZXgxp/P00YLJOWUNl8ND+hcXOUW+6i2c=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E80707A643A2646A0F1D942D32529E6@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 795bb6ef-69c6-440c-f6fa-08d6f007b2a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 14:01:57.4700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5688
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNi0xMyAxNTo1OCwgQmrDtnJuIFTDtnBlbCB3cm90ZToNCj4gT24gV2VkLCAxMiBK
dW4gMjAxOSBhdCAyMjo0OSwgSmFrdWIgS2ljaW5za2kNCj4gPGpha3ViLmtpY2luc2tpQG5ldHJv
bm9tZS5jb20+IHdyb3RlOg0KPj4NCj4+IE9uIFdlZCwgMTIgSnVuIDIwMTkgMTU6NTY6MzMgKzAw
MDAsIE1heGltIE1pa2l0eWFuc2tpeSB3cm90ZToNCj4+PiBVQVBJIGlzIG5vdCBjaGFuZ2VkLCBY
U0sgUlggcXVldWVzIGFyZSBleHBvc2VkIHRvIHRoZSBrZXJuZWwuIFRoZSBsb3dlcg0KPj4+IGhh
bGYgb2YgdGhlIGF2YWlsYWJsZSBhbW91bnQgb2YgUlggcXVldWVzIGFyZSByZWd1bGFyIHF1ZXVl
cywgYW5kIHRoZQ0KPj4+IHVwcGVyIGhhbGYgYXJlIFhTSyBSWCBxdWV1ZXMuDQo+Pg0KPj4gSWYg
SSBoYXZlIDMyIHF1ZXVlcyBlbmFibGVkIG9uIHRoZSBOSUMgYW5kIEkgaW5zdGFsbCBBRl9YRFAg
c29ja2V0IG9uDQo+PiBxdWV1ZSAxMCwgZG9lcyB0aGUgTklDIG5vdyBoYXZlIDY0IFJRcywgYnV0
IG9ubHkgZmlyc3QgMzIgYXJlIGluIHRoZQ0KPj4gbm9ybWFsIFJTUyBtYXA/DQo+Pg0KPiANCj4g
QWRkaXRpb25hbCwgcmVsYXRlZCwgcXVlc3Rpb24gdG8gSmFrdWInczogU2F5IHRoYXQgSSdkIGxp
a2UgdG8gaGlqYWNrDQo+IGFsbCAzMiBSeCBxdWV1ZXMgb2YgdGhlIE5JQy4gSSBjcmVhdGUgMzIg
QUZfWERQIHNvY2tldCBhbmQgYXR0YWNoIHRoZW0NCj4gaW4gemVyby1jb3B5IG1vZGUgdG8gdGhl
IGRldmljZS4gV2hhdCdzIHRoZSByZXN1bHQ/DQoNClRoZXJlIGFyZSAzMiByZWd1bGFyIFJYIHF1
ZXVlcyAoMC4uMzEpIGFuZCAzMiBYU0sgUlggcXVldWVzICgzMi4uNjMpLiBJZiANCnlvdSB3YW50
IDMyIHplcm8tY29weSBBRl9YRFAgc29ja2V0cywgeW91IGNhbiBhdHRhY2ggdGhlbSB0byBxdWV1
ZXMgDQozMi4uNjMsIGFuZCB0aGUgcmVndWxhciB0cmFmZmljIHdvbid0IGJlIGFmZmVjdGVkIGF0
IGFsbC4NCg0KPj4+IFRoZSBwYXRjaCAieHNrOiBFeHRlbmQgY2hhbm5lbHMgdG8gc3VwcG9ydCBj
b21iaW5lZCBYU0svbm9uLVhTSw0KPj4+IHRyYWZmaWMiIHdhcyBkcm9wcGVkLiBUaGUgZmluYWwg
cGF0Y2ggd2FzIHJld29ya2VkIGFjY29yZGluZ2x5Lg0KPj4NCj4+IFRoZSBmaW5hbCBwYXRjaGVz
IGhhcyAyayBMb0MsIGtpbmQgb2YgaGFyZCB0byBkaWdlc3QuICBZb3UgY2FuIGFsc28NCj4+IHBv
c3QgdGhlIGNsZWFuIHVwIHBhdGNoZXMgc2VwYXJhdGVseSwgbm8gbmVlZCBmb3IgbGFyZ2Ugc2Vy
aWVzIGhlcmUuDQoNCg==
