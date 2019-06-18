Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5434AB67
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 22:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730586AbfFRUGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 16:06:01 -0400
Received: from mail-eopbgr20081.outbound.protection.outlook.com ([40.107.2.81]:64723
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729331AbfFRUGA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 16:06:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pbiS99nnqULATf1DLumHtLXJJnWoprRkY3ZjLQuvNDI=;
 b=IXN7EZWC3Se0MuJ9CUz1MaLTTcnQWZVBnMVjdNXgkBc1LSXcl3atQ55Q2RGRKbAdSSTK+TuKi4fQ5iXHdKxuG33GncUQ3alE7SJ48kJQogIBIL4b0jJGc2Jegu5+BSR43eIyZqKkKKS4o+IPnyveQlvdIt4SGdG0oReJLYBX3xw=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2168.eurprd05.prod.outlook.com (10.168.56.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.15; Tue, 18 Jun 2019 20:05:56 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 20:05:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "arnd@arndb.de" <arnd@arndb.de>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Eli Britstein <elibr@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] [v2] net/mlx5e: reduce stack usage in
 mlx5_eswitch_termtbl_create
Thread-Topic: [PATCH] [v2] net/mlx5e: reduce stack usage in
 mlx5_eswitch_termtbl_create
Thread-Index: AQHVJcdJRWq22DhMyUGAw6Thkk8zhaah1uiA
Date:   Tue, 18 Jun 2019 20:05:56 +0000
Message-ID: <6eae69d099b2818f03e661e489f87b3adb94bf17.camel@mellanox.com>
References: <20190618111621.3030135-1-arnd@arndb.de>
In-Reply-To: <20190618111621.3030135-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90316fd5-5dc4-4666-836c-08d6f4285fc0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2168;
x-ms-traffictypediagnostic: DB6PR0501MB2168:
x-microsoft-antispam-prvs: <DB6PR0501MB216899B963EE4DDAE47F6E0ABEEA0@DB6PR0501MB2168.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(366004)(39860400002)(396003)(346002)(189003)(199004)(66946007)(2906002)(86362001)(99286004)(3846002)(6116002)(71200400001)(118296001)(6506007)(478600001)(71190400001)(2501003)(4744005)(76176011)(4326008)(26005)(256004)(5660300002)(7736002)(102836004)(14444005)(2616005)(229853002)(446003)(66066001)(486006)(6486002)(6246003)(68736007)(36756003)(110136005)(476003)(91956017)(66556008)(25786009)(54906003)(8676002)(8936002)(81156014)(64756008)(11346002)(58126008)(76116006)(66446008)(186003)(73956011)(316002)(81166006)(53936002)(14454004)(6512007)(305945005)(66476007)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2168;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9Mg10VfE1j99x0sYr4ClpVCtclWvsCyI6ZKeAdsVgvzUIRCuvZQZ1L03/R1RKPuwFQl2UNXsTCCgRZKORTRGe6IWCeb2OCKigdkwKGdoDzuGA6iaDkItjLb7TDXbkieh6atVxEMPhRBOX5Ks2SPhsxbFsYWRxDYckk5GX9IRKPDMJ6e9E0ei8/g8vvCTxh2wL2E7HrylJ7H1xzWMaCEv7EoMxgAe6H6bs4C8x4z5ERrkcYhQ36/gNxgDhIaF8jGStVeLdkkI0iq/EgHsEBb5cZu7m7KyDJ1qpR2icfY8F9i+khzLfcVirfCIfYRy6l6vp8srLu3WNl6bAiR+tvUT52Fc2FYX+6IzHrbKiusNlETCFHeRdf3gYXH7rV709QeeRoyGCnpZaLw50/2pWuq56Pr3RCDU/q6DWNKNMruHfYs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CFCA9F575402AD44A774A299FC2B1D44@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90316fd5-5dc4-4666-836c-08d6f4285fc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 20:05:56.0704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2168
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTE4IGF0IDEzOjE1ICswMjAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBQdXR0aW5nIGFuIGVtcHR5ICdtbHg1X2Zsb3dfc3BlYycgc3RydWN0dXJlIG9uIHRoZSBzdGFj
ayBpcyBhIGJpdA0KPiB3YXN0ZWZ1bCBhbmQgY2F1c2VzIGEgd2FybmluZyBvbiAzMi1iaXQgYXJj
aGl0ZWN0dXJlcyB3aGVuIGJ1aWxkaW5nDQo+IHdpdGggY2xhbmcgLWZzYW5pdGl6ZS1jb3ZlcmFn
ZToNCj4gDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNo
X29mZmxvYWRzX3Rlcm10YmwuYzoNCj4gSW4gZnVuY3Rpb24gJ21seDVfZXN3aXRjaF90ZXJtdGJs
X2NyZWF0ZSc6DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dp
dGNoX29mZmxvYWRzX3Rlcm10YmwuYzo5MA0KPiA6MTogZXJyb3I6IHRoZSBmcmFtZSBzaXplIG9m
IDEwMzIgYnl0ZXMgaXMgbGFyZ2VyIHRoYW4gMTAyNCBieXRlcyBbLQ0KPiBXZXJyb3I9ZnJhbWUt
bGFyZ2VyLXRoYW49XQ0KPiANCj4gU2luY2UgdGhlIHN0cnVjdHVyZSBpcyBuZXZlciB3cml0dGVu
IHRvLCB3ZSBjYW4gc3RhdGljYWxseSBhbGxvY2F0ZQ0KPiBpdCB0byBhdm9pZCB0aGUgc3RhY2sg
dXNhZ2UuIFRvIGJlIG9uIHRoZSBzYWZlIHNpZGUsIG1hcmsgYWxsDQo+IHN1YnNlcXVlbnQgZnVu
Y3Rpb24gYXJndW1lbnRzIHRoYXQgd2UgcGFzcyBpdCBpbnRvIGFzICdjb25zdCcNCj4gYXMgd2Vs
bC4NCj4gDQo+IEZpeGVzOiAxMGNhYWJkYWFkNWEgKCJuZXQvbWx4NWU6IFVzZSB0ZXJtaW5hdGlv
biB0YWJsZSBmb3IgVkxBTiBwdXNoDQo+IGFjdGlvbnMiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBBcm5k
IEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiBBY2tlZC1ieTogU2FlZWQgTWFoYW1lZWQgPHNh
ZWVkbUBtZWxsYW5veC5jb20+DQo+IEFja2VkLWJ5OiBNYXJrIEJsb2NoIDxtYXJrYkBtZWxsYW5v
eC5jb20+DQoNCkFwcGxpZWQgdG8gbmV0LW5leHQtbWx4NSBhbmQgd2lsbCBiZSBzdWJtaXR0ZWQg
dG8gbmV0LW5leHQgc29vbi4NCg0KVGhhbmtzLA0KU2FlZWQuDQo=
