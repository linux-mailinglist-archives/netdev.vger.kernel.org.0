Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC20EFFA59
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 15:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbfKQOq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 09:46:58 -0500
Received: from mail-eopbgr70057.outbound.protection.outlook.com ([40.107.7.57]:53056
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726076AbfKQOq6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Nov 2019 09:46:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDhXpoJjWl823hncD0Jd+4Jg/Lqwh0StzYFtdOGjSPXmJOqToXWynNb+PJjGigupbqwG9MX2AmW8HbSczVVRa+ujR4rm+04XKlnWPLbSxG1pwscH/Fe38eojFxF3Be5E9uO/MOYUI+XKlgBHBKFKPQKgijEiESs3eWBvzQ/kcHJIeZwziljraHTAfP5XyH2Gm/jKQbOPrP5vWmTkViBBsBJIpYqH4pWJMeO+puKxyIei0ZQiQjJar/oWWnPOCO+laOSZfddpjVQTsij0yoMtWXBW6vXn+VlFSPYrBNjMGCgzE2EXpgcmQyNAbtxx/4JG9zRQaKehVJn8Z4nLFF5F/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EE71lzoqzMyXH6VgBWRWPWryiSV+F3JaTieuM6tVfJE=;
 b=RVhd7tQI/3RLT6gzZcRcV2CcBKj0j1YTF/QVkXaWjn7IuEqMLkJ9oUxnpIVLquFv6i/n6S95gBihwZRmVfR/p7nGfYvlvYnicx0ZYqTaC47xTjOOKmMbQKZhjIWUJA7CSdGLHdfFRwxugtY8BK0tBCa8MDsQmFWTG84lG0CeZVBpKM+ngHykpcEyiA+gYOAr3JvSixWHZAUF8tFEmP3qT/hRaIQKpPAEsJEme44MWrKN7TcV7pH3qsWoimtuD32NOY2YokQE9N+EwS+TzptfKvE0pBF5I8IrD29BgeokVSNgNk2EPOzAYJQPqP0uW1YvEMp5Y3Bv0c1AJ1ezN/hxQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EE71lzoqzMyXH6VgBWRWPWryiSV+F3JaTieuM6tVfJE=;
 b=CRlv6pSe5BpokpNiCHDYLjEyoV8DFZUuDHs9FM/HexmUC8moXJGEHBZZfPb/Im5Mtp81fRMjh6FKFgJFV+xVSsrIyf6kzUvYLZtiyzB47+IrtfuIf/NXQWGyKtZZbiRjyYMMR0I77n4ozaR4YDeWRu1BBWdJ+06yN8obKSKJ4Bg=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.43.208) by
 DBBPR05MB6329.eurprd05.prod.outlook.com (20.179.41.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Sun, 17 Nov 2019 14:46:51 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::8032:b650:9659:1c3a]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::8032:b650:9659:1c3a%7]) with mapi id 15.20.2451.029; Sun, 17 Nov 2019
 14:46:51 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     David Miller <davem@davemloft.net>,
        "lrizzo@google.com" <lrizzo@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH] net/mlx4_en: fix mlx4 ethtool -N insertion
Thread-Topic: [PATCH] net/mlx4_en: fix mlx4 ethtool -N insertion
Thread-Index: AQHVm/EMSXbZQwpspUCUKjixDQl+CaeOTMwAgAEm8oA=
Date:   Sun, 17 Nov 2019 14:46:50 +0000
Message-ID: <59ebfae8-ac93-75a1-7a60-2bb3820a9a79@mellanox.com>
References: <20191115201225.92888-1-lrizzo@google.com>
 <20191116.131058.1856199123293908506.davem@davemloft.net>
In-Reply-To: <20191116.131058.1856199123293908506.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR05CA0044.eurprd05.prod.outlook.com
 (2603:10a6:208:be::21) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:cf::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 59a30144-7fc4-49d7-4f94-08d76b6cfaf6
x-ms-traffictypediagnostic: DBBPR05MB6329:|DBBPR05MB6329:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR05MB63297890DFAF3823BB75B079AE720@DBBPR05MB6329.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02243C58C6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(39860400002)(376002)(396003)(189003)(199004)(81166006)(64756008)(102836004)(31686004)(6246003)(6506007)(386003)(53546011)(25786009)(6116002)(81156014)(107886003)(4326008)(71190400001)(71200400001)(52116002)(3846002)(478600001)(8936002)(8676002)(4744005)(186003)(110136005)(99286004)(5660300002)(476003)(2616005)(66066001)(54906003)(486006)(2906002)(14454004)(36756003)(11346002)(86362001)(2501003)(6512007)(446003)(66476007)(66556008)(7736002)(305945005)(6436002)(26005)(229853002)(76176011)(66946007)(316002)(66446008)(6486002)(256004)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6329;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3ZdbnTcxux7tOm/kDH+RVmPixafWDf4wQCbMxhpKpKx+lhDABCuU3Kq9zUXKHmmAgh1Bj0GeLUuql8cw40J54wg3jeARdkKl5M/WQDPpUx+/Au48LVok49QyARG7y6NNu7b7HxAYi0Vzs6IPq5aQebovCNvzk9n4wiCEdHzsrOFDHA8eTqkAZUqo651pfTNOD70XdZ8cuteDjm6uI9ZydLUo/Ud4KDDVI+WQXCJC68yjBdP3tDMqfhSg/m/EURKiOt/FWC+POIgVpfenzjZK7g7m8fHoihLh7KxgsdaoI+BeKIzVhhjtReUXHhy4wkBcWvOQA5brtq7O0gWG3p47yphjW7vKdiGhXRnFG2qgN/lZ7O+hLQgjkswZRu7VS4g7BGyMuOr3ja6vZYaQ9YSzuSgiEqFQ3GtofqvfFjpeRHyFbFefX2rGiubpiRQ6w8a9
Content-Type: text/plain; charset="utf-8"
Content-ID: <282A150AF2EFA74EAF7BDCC7A301575A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59a30144-7fc4-49d7-4f94-08d76b6cfaf6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2019 14:46:50.9999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nd7oNg8/3e25tICBJ+FQP4TNHgyIX7YtVV6BHBXMheny9M9s6qEOi6qwgij3ZFEu6+P9zhChKHAvhazTc6KkdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6329
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDExLzE2LzIwMTkgMTE6MTAgUE0sIERhdmlkIE1pbGxlciB3cm90ZToNCj4gRnJvbTog
THVpZ2kgUml6em8gPGxyaXp6b0Bnb29nbGUuY29tPg0KPiBEYXRlOiBGcmksIDE1IE5vdiAyMDE5
IDEyOjEyOjI1IC0wODAwDQo+IA0KPj4gZXRodG9vbCBleHBlY3RzIEVUSFRPT0xfR1JYQ0xTUkxB
TEwgdG8gc2V0IGV0aHRvb2xfcnhuZmMtPmRhdGEgd2l0aCB0aGUNCj4+IHRvdGFsIG51bWJlciBv
ZiBlbnRyaWVzIGluIHRoZSByeCBjbGFzc2lmaWVyIHRhYmxlLiAgU3VycHJpc2luZ2x5LCBtbHg0
DQo+PiBpcyBtaXNzaW5nIHRoaXMgcGFydCAoaW4gcHJpbmNpcGxlIGV0aHRvb2wgY291bGQgc3Rp
bGwgbW92ZSBmb3J3YXJkIGFuZA0KPj4gdHJ5IHRoZSBpbnNlcnQpLg0KPj4NCj4+IFRlc3RlZDog
Y29tcGlsZWQgYW5kIHJ1biBjb21tYW5kOg0KPj4gCXBoaDEzOn4jIGV0aHRvb2wgLU4gZXRoMSBm
bG93LXR5cGUgdWRwNCAgcXVldWUgNA0KPj4gCUFkZGVkIHJ1bGUgd2l0aCBJRCAyNTUNCj4+DQo+
PiBTaWduZWQtb2ZmLWJ5OiBMdWlnaSBSaXp6byA8bHJpenpvQGdvb2dsZS5jb20+DQo+PiBDaGFu
Z2UtSWQ6IEkxOGE3MmYwOGRmY2ZiNmI5ZjZhYTgwZmJjMTJkNTg1NTNlMWZkYTc2DQo+IA0KPiBM
dWlnaSwgX2Fsd2F5c18gQ0M6IHRoZSBhcHByb3ByaWF0ZSBtYWludGFpbmVyIHdoZW4gbWFraW5n
IGNoYW5nZXMgdG8gdGhlDQo+IGtlcm5lbCwgYXMgcGVyIHRoZSB0b3AtbGV2ZWwgTUFJTlRBSU5F
UlMgZmlsZS4NCj4gDQo+IFRhcmlxIGV0IGFsLiwgcGxlYXNlIHJldmlldy4NCj4gDQoNClJldmll
d2VkLWJ5OiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBtZWxsYW5veC5jb20+DQoNClRoYW5rcyBmb3Ig
eW91ciBwYXRjaC4NCg0KVGFyaXENCg==
