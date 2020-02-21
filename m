Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34314168736
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 20:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgBUTG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 14:06:58 -0500
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:37269
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726423AbgBUTG6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 14:06:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uf0qRkwi/vlTFUwaC/hAJKBBrBSBTLhczxSYqhTmCUDWnMz6uihGGeqF5O95l/7zyZGmMHnO9FG9Z9UZnaxYtQxViCRCCC7BfBUV3vj3npO56O/Gk0PT2klymL9R1UtuTLVdRt/y9XBYOUT9HWjS0UL1lHxfcQ7lAU4Wyta5BkpacYnpKWfzuuSzKC//4gcVkp5dEidA44ZYZZBevRcPdEjFVFxythwz+Y9iTF/bVWcETHZdj0pTcNjrLmlWDLZSzc5z9JaIzwrzWllETeYRV5GHtP02AyXT/1RSsl0+I1OzQ+cMUk+DTHCeJ75F+9Wxg6p/TR3NY3xsozEw+l5pfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mhnTP7uUd/BNBa5U7jhePY+SS2INOH9T+tYBjLnDOTM=;
 b=PeGxZ7G8ekK5UR7GIWFLhVQfwwENTYjGut+nfNk9E7OCPSsemmsQ/IZryZrqI4wE1ADUOx7b2hoetri6JpCtntRwq4T5rcRl0r6YBK/m/3s4jfoRL/cEoTfP6e32QT9bFRmt8Ab7LAmB5gzej8JNqITitVv3OJDj3B1aZ6ISIuRn9crL475TbR/wYY/oyJnYG0xFSlqGueXbvX+vIsLLRRPTGeo3p1+n+5YfgjFaSst6bgTQLC8m4PWSasop5vqIbcpPmiA81gtmTQGDfVcRj9FKv5pikpOV5VGJhAz5psxLJp9MfWO1MzzS29dVdqDTR65pH0TsDXMzkcWAKwPM3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mhnTP7uUd/BNBa5U7jhePY+SS2INOH9T+tYBjLnDOTM=;
 b=Sq1iw0iB8NeRFZgYKH+pxxhRfyoKCHV1jKXrCM2kStenwM1lK7y9WgNwX/iQ0sK9vhTKVJuUXurIt84mPYxfORszrbx54zGOqWxMBSW2QP0vu3uLN6yzVgRjt/rVMrrNEPDJ0Dl8uLNGqCBJpNEVZm689EMEVAlkN1PxXWS5xD8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4752.eurprd05.prod.outlook.com (20.176.7.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Fri, 21 Feb 2020 19:06:54 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 19:06:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Roi Dayan <roid@mellanox.com>,
        "saeedm@dev.mellanox.co.il" <saeedm@dev.mellanox.co.il>,
        "xiangxia.m.yue@gmail.com" <xiangxia.m.yue@gmail.com>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v4] net/mlx5e: Don't allow forwarding between
 uplink
Thread-Topic: [PATCH net-next v4] net/mlx5e: Don't allow forwarding between
 uplink
Thread-Index: AQHV5ZvRed9uUazW60+PfhYgNANri6gmCO4A
Date:   Fri, 21 Feb 2020 19:06:54 +0000
Message-ID: <db8982236a8694262b0848ad8fdd46f5d8c0cf52.camel@mellanox.com>
References: <20200217140850.4509-1-xiangxia.m.yue@gmail.com>
In-Reply-To: <20200217140850.4509-1-xiangxia.m.yue@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ffa11724-233e-46ee-403d-08d7b701372f
x-ms-traffictypediagnostic: VI1PR05MB4752:|VI1PR05MB4752:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4752F7406FF882F562515CC1BE120@VI1PR05MB4752.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39850400004)(376002)(346002)(396003)(366004)(199004)(189003)(2906002)(478600001)(110136005)(186003)(6512007)(316002)(36756003)(71200400001)(6506007)(26005)(6486002)(66556008)(81156014)(8676002)(66476007)(5660300002)(2616005)(64756008)(81166006)(76116006)(4744005)(91956017)(66446008)(4326008)(86362001)(8936002)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4752;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +e4SIuqCXUCpUmKFqatfICcwftqzpYW/HSPrjdzKdFnfxcMPFkakQSmxcGMZ892lF3c9rW1w9UoNtzMBmet2EUHICUXDiKMGs98bmxpLoDvEfo7f9CWIxYukYM6r8TF+aDuSmr5azmaGxP5kbY3BmrsWrM+qg+zCiYVUA8kkWOnVDALmQb2p1cd+ADqpxhTlO64vhwehFUNAnquP+kFNJ9jYHy4KotSmRX/uXxEmMJFUGGZO/7SpQ9pjjSrJlDhTRgninK/d1ffrZqL5ZKKj33AsdQrmI0KP5e3+ZZfYRTb3pPhxZYid4iwHA//uCCH2Ejr2lrTHX/AZJ6e1Iub+j7GmWExJI46CI/KKC/JcDNxIMfzgGdfZgEv9WFdvO17h/TH4rNqSFI8yEDAEYpzEetrW/AuE8mtrQLe7CEwFrK+bffRVTrLz1gG/1hTpFgGb
x-ms-exchange-antispam-messagedata: 81Wg0VVpZS1qmHzfQMam42gdTdytDF1sWTgnwrodr3TGwPBsV6b9AMBb4Pzc2CuzcO+xfoEYt22J0zG71KPElhG57HroHdUSP1Kg3YOQMSModFnmI4jyJ/1aCX4ZujVCD1AFFJwbLnXGzfIORYfgQw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <78540DFA281E134DBAA976C694A3683B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffa11724-233e-46ee-403d-08d7b701372f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 19:06:54.2959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4n2Soqo45i8f8FVepJQs/+C1e8XKvMaEc1bNuziXLwjUFHEf0uYpa3wIMcQYkHVry5YbMVjq1mIRH2tpj6IAqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4752
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTAyLTE3IGF0IDIyOjA4ICswODAwLCB4aWFuZ3hpYS5tLnl1ZUBnbWFpbC5j
b20gd3JvdGU6DQo+IEZyb206IFRvbmdoYW8gWmhhbmcgPHhpYW5neGlhLm0ueXVlQGdtYWlsLmNv
bT4NCj4gDQo+IFdlIGNhbiBpbnN0YWxsIGZvcndhcmRpbmcgcGFja2V0cyBydWxlIGJldHdlZW4g
dXBsaW5rDQo+IGluIHN3aXRjaGRldiBtb2RlLCBhcyBzaG93IGJlbG93LiBCdXQgdGhlIGhhcmR3
YXJlIGRvZXMNCj4gbm90IGRvIHRoYXQgYXMgZXhwZWN0ZWQgKG1sbnhfcGVyZiAtaSAkUEYxLCB3
ZSBjYW4ndCBnZXQNCj4gdGhlIGNvdW50ZXIgb2YgdGhlIFBGMSkuIEJ5IHRoZSB3YXksIGlmIHdl
IGFkZCB0aGUgdXBsaW5rDQo+IFBGMCwgUEYxIHRvIE9wZW4gdlN3aXRjaCBhbmQgZW5hYmxlIGh3
LW9mZmxvYWQsIHRoZSBydWxlcw0KPiBjYW4gYmUgb2ZmbG9hZGVkIGJ1dCBub3Qgd29yayBmaW5l
IHRvby4gVGhpcyBwYXRjaCBhZGQgYQ0KPiBjaGVjayBhbmQgaWYgc28gcmV0dXJuIC1FT1BOT1RT
VVBQLg0KPiANCj4gJCB0YyBmaWx0ZXIgYWRkIGRldiAkUEYwIHByb3RvY29sIGFsbCBwYXJlbnQg
ZmZmZjogcHJpbyAxIGhhbmRsZSAxIFwNCj4gICAgIGZsb3dlciBza2lwX3N3IGFjdGlvbiBtaXJy
ZWQgZWdyZXNzIHJlZGlyZWN0IGRldiAkUEYxDQo+IA0KPiAkIHRjIC1kIC1zIGZpbHRlciBzaG93
IGRldiAkUEYwIGluZ3Jlc3MNCj4gICAgIHNraXBfc3cNCj4gICAgIGluX2h3IGluX2h3X2NvdW50
IDENCj4gICAgIGFjdGlvbiBvcmRlciAxOiBtaXJyZWQgKEVncmVzcyBSZWRpcmVjdCB0byBkZXZp
Y2UgZW5wMTMwczBmMSkNCj4gc3RvbGVuDQo+ICAgICAuLi4NCj4gICAgIFNlbnQgaGFyZHdhcmUg
NDA4OTU0IGJ5dGVzIDQxNzMgcGt0DQo+ICAgICAuLi4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFRv
bmdoYW8gWmhhbmcgPHhpYW5neGlhLm0ueXVlQGdtYWlsLmNvbT4NCg0KQXBwbGllZCB0byBuZXQt
bmV4dC1tbHg1DQoNClRoYW5rcyENCg==
