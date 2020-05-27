Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5471E4A24
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390599AbgE0Q3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:29:02 -0400
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:41478
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387775AbgE0Q3C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 12:29:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dz0BMHRV4xhbcS9CYZNiFnarox3FO++Ur9og5bFXsZ3accu/cVnhFC55D8/yu6yssml6RfUN/+9PUeow1Bk8HdIKJ/gF8efdgGgriAyd1n51KjXahNAFtvhRLyFl7JG2GqrAp/oxLuI9ndu7JvPM5kTg6kqqIhdSIfJE6D0f1AZrx5NYj4Hfm2QAWNkXUFHd6D1Xxz3QPyaf0XL9Baj+F6xcOev+8GVZ9xZl80U0nLUTHrGBoXVMirg0oG3woy1mRd9DbPiuMRg7Vyif7U6PbKn0w+/GJnRL/aWQvSaTimvVVmqxKfXJmNe0v+29H/DuAdXVsZMsT97iT8TgZKad1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jtjmjoLemD5dILtAlznJFmS7F0DmmCjaj6pGgrdqOJU=;
 b=HystMcJ52kufftrNACNRBYP7suEJmkwPverCxXiX9Rc/bzitgJt5z2+Ol/kNyWveGI8eyDp54HOhXlrtXrS4ffTYBWnzQDADqElQPkC4DHcg0g0Dyx7bSUJe7fP46PZLsXq8jLhj6lJBQFTAP/MbTA4OypBRJoYvwUt34ZEmByZmllLPrhZtyB+lFNN0fodU9T5x46dorNqUfYqv+sI7FOr503yveX1vimt6Tbj8kHH0mtgeAkVPu74YE/RG6Mo9QWRJSHTsCHdfdSSf9Y5Fg2yhKHiHYA/ngYCQpmzt3gGmItkZS4FzDp3ILbvknlB5JL4rWHfwPRGT3JwuComIng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jtjmjoLemD5dILtAlznJFmS7F0DmmCjaj6pGgrdqOJU=;
 b=BPdKIiqQ4ZEsmQMjell9GJhG6F9IN5/NT0IIKaqgNQ4nbDJ1p6evu9Tiw6HKjvrpsg2WZfb/fG713NIfYIBuFyroomvyr6DwxaiGVrUfaOsLjnx4CTjj1Q3LP+yMGHnEP7EF0eEnpq5U8W+jgQgclwklaYiSR3NRcU3IvGUrQdg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6895.eurprd05.prod.outlook.com (2603:10a6:800:180::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Wed, 27 May
 2020 16:28:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 16:28:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "natechancellor@gmail.com" <natechancellor@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5e: Don't use err uninitialized in
 mlx5e_attach_decap
Thread-Topic: [PATCH] net/mlx5e: Don't use err uninitialized in
 mlx5e_attach_decap
Thread-Index: AQHWM/uW1M9R5MKUQ06oEOaaCPeIWai8H94A
Date:   Wed, 27 May 2020 16:28:58 +0000
Message-ID: <df7438fed1ee6a2829a3745068f0938a6f159fdf.camel@mellanox.com>
References: <20200527075021.3457912-1-natechancellor@gmail.com>
In-Reply-To: <20200527075021.3457912-1-natechancellor@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d61b0348-277a-4127-be13-08d8025b0e8c
x-ms-traffictypediagnostic: VI1PR05MB6895:
x-microsoft-antispam-prvs: <VI1PR05MB689583A3D18443E85993B4AABEB10@VI1PR05MB6895.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:350;
x-forefront-prvs: 04163EF38A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SlR5uwimAR1lLZcavCS3qXLDmwU3bOd6NaF5XiknJlG3mgORWtynTic83TTaXAKD7of4SLnSlViohRBYT8JDf3x2uYHuDeBtRdb1Wo+ZJjkZe/7pg74dlUQqlPfNv9DiG36TrHd3ZeWwTuhgfdm+E9Zv1cS1WnLld2KJWCGNUEST7XXbM9khQKtv8ahIKgBP6QQO4KNGseIpe4ZdQnMUJ/4DJFUrDtoGA1my3PZ4In7SK1rTjD0AwvWlv7F0AQhXW/RbnWfuAvCCq5GXAbZkelnOAE19vQHt0/r2gRd+OwKTZpXf/Oug7gVmgO/5huA1Yg8cc+KN9zmGCAQVJXLrm1weuIrq60/rA8BRMi0buDPHyMQndD63loCYdf2JMBOiqIUXDCYY31tfUvNgGqYxCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(86362001)(5660300002)(66446008)(66946007)(91956017)(66556008)(36756003)(478600001)(76116006)(66476007)(64756008)(2616005)(2906002)(71200400001)(110136005)(966005)(26005)(186003)(316002)(6486002)(6512007)(8676002)(6506007)(54906003)(8936002)(83380400001)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 15XUp+G4wTXK3i0a52JUj2JHXE84ZyAsgsDOvegfna6jV1RvPcbam3LLhshedkPMhXCI0EyCFER2P/CzouXQIGQQFng7Ib2RkrXMNDSvdQj8bOxByJ+agvvVdIvm4xWMTp/I943njHpPtTKahO+LD7PkI8tK+2CZU0UzUZzE5TenMmjB9CNGOxTKJ/SeBzRNU5mUMx0WHBQjZhf/AksP8kES6n+5Quis1vtHEi7BIcckNKbXGrxagyBDZ6f8tIo6YktjpR7ggjRLfiVMBDY77c6P7BQasJje2Agjy0omXC9lwLgcaScTxCN7B/vb9sRaGHpqyp0cdsFx75WiWLUdrOlNrR2+hLMb0IBfMRO1S8dt7KzZM+IWp3iTIJEqNfvmjrASzVnw/ltThPfWcl93XL5KkGna2aSzv+7dOkQh7hEBJ5/+RB9QXkvYcm7LyvUTjOLiusIxpD8Tp/XOD8s+5j93jTeRchf8RFAQ45LpgKY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <44C337C62E7DAD42AD04C573403D8AA8@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d61b0348-277a-4127-be13-08d8025b0e8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2020 16:28:58.0830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zLGX8GZ3rQ6rkN1Dtn6qcYVtmVPaNTUOtIs1LdC3AEc1FInHIePZ+fkq17w+OVqiFKhAtyWWVZGf0LsgZAtAQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6895
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA1LTI3IGF0IDAwOjUwIC0wNzAwLCBOYXRoYW4gQ2hhbmNlbGxvciB3cm90
ZToNCj4gQ2xhbmcgd2FybnM6DQo+IA0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW5fdGMuYzozNzEyOjY6IHdhcm5pbmc6DQo+IHZhcmlhYmxlICdlcnInIGlzIHVz
ZWQgdW5pbml0aWFsaXplZCB3aGVuZXZlciAnaWYnIGNvbmRpdGlvbiBpcyBmYWxzZQ0KPiBbLVdz
b21ldGltZXMtdW5pbml0aWFsaXplZF0NCj4gICAgICAgICBpZiAoSVNfRVJSKGQtPnBrdF9yZWZv
cm1hdCkpIHsNCj4gICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4NCj4gZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmM6MzcxODo2OiBub3RlOg0K
PiB1bmluaXRpYWxpemVkIHVzZSBvY2N1cnMgaGVyZQ0KPiAgICAgICAgIGlmIChlcnIpDQo+ICAg
ICAgICAgICAgIF5+fg0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
ZW5fdGMuYzozNzEyOjI6IG5vdGU6IHJlbW92ZQ0KPiB0aGUNCj4gJ2lmJyBpZiBpdHMgY29uZGl0
aW9uIGlzIGFsd2F5cyB0cnVlDQo+ICAgICAgICAgaWYgKElTX0VSUihkLT5wa3RfcmVmb3JtYXQp
KSB7DQo+ICAgICAgICAgXn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4NCj4gZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmM6MzY3MDo5OiBub3RlOg0KPiBp
bml0aWFsaXplDQo+IHRoZSB2YXJpYWJsZSAnZXJyJyB0byBzaWxlbmNlIHRoaXMgd2FybmluZw0K
PiAgICAgICAgIGludCBlcnI7DQo+ICAgICAgICAgICAgICAgIF4NCj4gICAgICAgICAgICAgICAg
ID0gMA0KPiAxIHdhcm5pbmcgZ2VuZXJhdGVkLg0KPiANCj4gSXQgaXMgbm90IHdyb25nLCBlcnIg
aXMgb25seSBldmVyIGluaXRpYWxpemVkIGluIGlmIHN0YXRlbWVudHMgYnV0DQo+IHRoaXMNCj4g
b25lIGlzIG5vdCBpbiBvbmUuIEluaXRpYWxpemUgZXJyIHRvIDAgdG8gZml4IHRoaXMuDQo+IA0K
PiBGaXhlczogMTRlNmIwMzhhZmEwICgibmV0L21seDVlOiBBZGQgc3VwcG9ydCBmb3IgaHcgZGVj
YXBzdWxhdGlvbiBvZg0KPiBNUExTIG92ZXIgVURQIikNCj4gTGluazogaHR0cHM6Ly9naXRodWIu
Y29tL0NsYW5nQnVpbHRMaW51eC9saW51eC9pc3N1ZXMvMTAzNw0KPiBTaWduZWQtb2ZmLWJ5OiBO
YXRoYW4gQ2hhbmNlbGxvciA8bmF0ZWNoYW5jZWxsb3JAZ21haWwuY29tPg0KPiAtLS0NCg0KQXBw
bGllZCB0byBuZXQtbmV4dC1tbHg1LCB3aWxsIHNlbmQgc2hvcnRseSB0byBuZXQtbmV4dA0KDQpU
aGFua3MsDQpTYWVlZC4NCg==
