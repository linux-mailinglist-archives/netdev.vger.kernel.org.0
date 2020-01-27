Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2545149F79
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 09:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgA0IIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 03:08:52 -0500
Received: from mail-db8eur05on2058.outbound.protection.outlook.com ([40.107.20.58]:35200
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725955AbgA0IIw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 03:08:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b68im0XjNDExwb3sfmppoZ391ArpUxWV48yO/xCQzxGjG3XKzLachKQyR1CIhCE6WlvYeYjWI5mz/imHfJ1s9fX7sqQ8AjyUIw5tIEyzzydibu3LuPgFP7PC31pcYkMpxp+7X8u74Ao8cF1swy0V7AM3lCv10WqaEVNG0BtnMQN6GitFo9jFFi24+LAuAESSarjKqGQUWT0UO9j+8gndgo5Frq6NFjpUpDVcui4jyhE5niPmQfkzy0308GNXY7j5TVhIAwFQIbtO4PsYGYTAP2heFN+Dj+WqSiktutZ7gc3CMptIiGzNhddD/YiTNhPE/yNwPCfKJwO6nmoIBOwByQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRimNDtcrqpAoob8H+ybJK2CtM2WDSMt9Sgk/XLq0Rc=;
 b=Nax1i9luUEhrCPS6RwGDb/F9QSr6Qkf/Mr5+9CwXOQj/SM3qBNCIUfzcdh8zqGuOWSNueqWsSsTV3zguFs7sXovsN5qmMj7BakBl8a5hersjWKL+BtUgOeyn/0pvYMcyqT7sd2Vm5BbKNfEq8K0WOS6Ppudf6BQQ9gavqhGUyR5abrqq884GBQkzmvYOsIxmMeFsEd7/BqW5B52VnNWY/rdluPvikORs75sVI4u9qas5RSLeggslXwTxUc/4WJ5V+umTepw+av7y1f7bhtu574xelbZQvNyD6MuIh5gff7kMain+AwISzG/NEC0TyRzX5JLd2NNXklzv1qh2BTyQ9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRimNDtcrqpAoob8H+ybJK2CtM2WDSMt9Sgk/XLq0Rc=;
 b=gOVL8mR226InZ57Ijfdt4LJmarU8DZNeCEZhjRjT2b8LMsVnk6i1qCqn94V645/+XOBDQdsrehM4/JjHrplRhoGesV5+c0bZzQdm9YqBnxjEZs6DR3u7DPuVdhS3v5zSpI4Sf46l6MdxxNPwvA70CtoMB0wPcXzFgpMtPxev9Pw=
Received: from AM6PR05MB5460.eurprd05.prod.outlook.com (20.177.189.76) by
 AM6PR05MB6167.eurprd05.prod.outlook.com (20.178.94.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Mon, 27 Jan 2020 08:08:48 +0000
Received: from AM6PR05MB5460.eurprd05.prod.outlook.com
 ([fe80::c5ae:717a:f178:c829]) by AM6PR05MB5460.eurprd05.prod.outlook.com
 ([fe80::c5ae:717a:f178:c829%4]) with mapi id 15.20.2665.025; Mon, 27 Jan 2020
 08:08:48 +0000
Received: from [10.80.4.9] (193.47.165.251) by AM3PR05CA0145.eurprd05.prod.outlook.com (2603:10a6:207:3::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Mon, 27 Jan 2020 08:08:47 +0000
From:   Boris Pismenny <borisp@mellanox.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5: Remove a useless 'drain_workqueue()' call in
 'mlx5e_ipsec_cleanup()'
Thread-Topic: [PATCH] net/mlx5: Remove a useless 'drain_workqueue()' call in
 'mlx5e_ipsec_cleanup()'
Thread-Index: AQHV1HE08SQb1JAKjECDsRl72U4cTqf+KRuA
Date:   Mon, 27 Jan 2020 08:08:48 +0000
Message-ID: <f9b066c7-e59a-9106-da57-a7c0ffc36d9b@mellanox.com>
References: <20200126175104.17948-1-christophe.jaillet@wanadoo.fr>
In-Reply-To: <20200126175104.17948-1-christophe.jaillet@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR05CA0145.eurprd05.prod.outlook.com
 (2603:10a6:207:3::23) To AM6PR05MB5460.eurprd05.prod.outlook.com
 (2603:10a6:20b:36::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=borisp@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 60ee128f-c99c-423f-a08d-08d7a3002348
x-ms-traffictypediagnostic: AM6PR05MB6167:|AM6PR05MB6167:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB61675BF1B61EEB1F3EB1A230B00B0@AM6PR05MB6167.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:222;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(199004)(189003)(6486002)(956004)(5660300002)(4744005)(16576012)(4326008)(2616005)(316002)(8936002)(31696002)(66476007)(66556008)(66446008)(66946007)(64756008)(31686004)(186003)(52116002)(54906003)(53546011)(2906002)(478600001)(110136005)(81166006)(71200400001)(81156014)(36756003)(16526019)(26005)(8676002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6167;H:AM6PR05MB5460.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PK/IOnhVfdhwBcs1xxHf/c8OglTbwkV+6fS2OddkVWYRG8JEHc0x1lv/EIjA3txKbtLfGIka8N+15vGlEWtuNzlhC32IPBCYOl24QDzjE1YPw/BfiVU3AnmxYqetSpyotmQJr/+RjleFudkMvH4aSz2w7Ega3Xu3ZObhel/nTPJeYRPR39IcbNQDxp0/ZVyKZhJ+M/MFcjAZTgH0T0V+DO4+J0akVoM0azJLDGRFC2IEy+obcVcR+Qansqzq9jgfIiMiYaqxaxXkj35odQVZRrc5qE7BYC+iWznuA4nMyVuUMYmW2iHGP7Kwi7/9YMXLDOOeyoNa4FYb9YSbwRA3cpQGGtGfiAgU2LuWyzp5cFHC+F0dKB+TKSiuq5QzCA+f9kxZT25RnVV2bOJNSAm629M4H4UZuDrdfe7k/R/A5Dbgizpl9Ous4MaCWJ7DCk+9
x-ms-exchange-antispam-messagedata: whwvN6CLSTW8pnTAurC5jQpTZuGXCSQX/YvddMLOCNyEwaUtsaQODAv1e4S77EbZdlHwaiKxC4g3UleUh/ZgmomLbCDoSEwWYvFbTC1J+YtjvuDQQK5AWWW90K3v0ew5JDgMhiup17NdIsYeDjEuKA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <0C6E3EBCF9707E4294ED0A0030D613C7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60ee128f-c99c-423f-a08d-08d7a3002348
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2020 08:08:48.5583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XytIj7c7dUatZehNxsSre/F2MODLShDZNAlepotNrZFaTSxBAljiYh2JWmE8RokDcfJcGZYWBLB5eX4lQ20gjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6167
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxLzI2LzIwMjAgNzo1MSBQTSwgQ2hyaXN0b3BoZSBKQUlMTEVUIHdyb3RlOg0KPiAnZGVz
dHJveV93b3JrcXVldWUoKScgYWxyZWFkeSBjYWxscyAnZHJhaW5fd29ya3F1ZXVlKCknLCB0aGVy
ZSBpcyBubyBuZWVkDQo+IHRvIGNhbGwgaXQgZXhwbGljaXRseS4NCj4NCj4gU2lnbmVkLW9mZi1i
eTogQ2hyaXN0b3BoZSBKQUlMTEVUIDxjaHJpc3RvcGhlLmphaWxsZXRAd2FuYWRvby5mcj4NCj4g
LS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fYWNjZWwv
aXBzZWMuYyB8IDEgLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgZGVsZXRpb24oLSkNCj4NCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hY2Nl
bC9pcHNlYy5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2Fj
Y2VsL2lwc2VjLmMNCj4gaW5kZXggY2Y1OGM5NjM3OTA0Li4yOTYyNmM2YzljMjUgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9p
cHNlYy5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bl9hY2NlbC9pcHNlYy5jDQo+IEBAIC00MzMsNyArNDMzLDYgQEAgdm9pZCBtbHg1ZV9pcHNlY19j
bGVhbnVwKHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2KQ0KPiAgCWlmICghaXBzZWMpDQo+ICAJCXJl
dHVybjsNCj4gIA0KPiAtCWRyYWluX3dvcmtxdWV1ZShpcHNlYy0+d3EpOw0KPiAgCWRlc3Ryb3lf
d29ya3F1ZXVlKGlwc2VjLT53cSk7DQo+ICANCj4gIAlpZGFfZGVzdHJveSgmaXBzZWMtPmhhbGxv
Yyk7DQpMR1RNDQo=
