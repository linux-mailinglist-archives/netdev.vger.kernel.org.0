Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0912034FEE
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 20:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfFDSk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 14:40:56 -0400
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:57247
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725933AbfFDSk4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 14:40:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZRgYljs8XlZcuYMFAdhUnodZ3KZ7f+ncoeuXH0YEXQ=;
 b=b+C6OdQLVjilkwBGrHaUryKqY0MAV5DFfJ9O8X8kbU2OCfxiAPcW1MxAU5ezfwWqFMLA4F6JTuPsNqt7zqvM9rZyXK1/VMG+x6jTtk/1Sbj8Vuv9FtQXLkWjMgcjgg8fOjNukiXnwSDMC1M03FWSdndfC3rjKCUvmPAa5nvLv3c=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6138.eurprd05.prod.outlook.com (20.179.10.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.21; Tue, 4 Jun 2019 18:40:52 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031%5]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 18:40:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        mlxsw <mlxsw@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [patch net-next v3 2/8] mlx5: Move firmware flash implementation
 to devlink
Thread-Topic: [patch net-next v3 2/8] mlx5: Move firmware flash implementation
 to devlink
Thread-Index: AQHVGtsf50Caa2JOGEWD8EIf6iZ4uKaL1FkA
Date:   Tue, 4 Jun 2019 18:40:52 +0000
Message-ID: <efee9e7278d3864384f7165255a2388deb5919c0.camel@mellanox.com>
References: <20190604134044.2613-1-jiri@resnulli.us>
         <20190604134044.2613-3-jiri@resnulli.us>
In-Reply-To: <20190604134044.2613-3-jiri@resnulli.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8042d9e-b326-4f03-58f3-08d6e91c2bef
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6138;
x-ms-traffictypediagnostic: DB8PR05MB6138:
x-microsoft-antispam-prvs: <DB8PR05MB6138F3AE0A011EA97550BFE2BE150@DB8PR05MB6138.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(366004)(39860400002)(396003)(346002)(199004)(189003)(14454004)(6486002)(6246003)(64756008)(36756003)(73956011)(76116006)(66556008)(14444005)(68736007)(66946007)(91956017)(86362001)(25786009)(81166006)(118296001)(54906003)(53936002)(66446008)(6512007)(58126008)(99286004)(110136005)(8936002)(26005)(229853002)(256004)(2906002)(8676002)(186003)(7736002)(4326008)(66066001)(6436002)(66476007)(5660300002)(81156014)(316002)(6116002)(305945005)(558084003)(2501003)(476003)(3846002)(486006)(6506007)(71200400001)(102836004)(71190400001)(11346002)(446003)(508600001)(2616005)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6138;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XXvGIMHHFSZurq3nY10GfkQcZBLNrXarMiQ0pkQUejCou/dhsF/13OX3NjGwBDyjLalri8UGnBKq0XW1oBVDaGiNfMREzFY9R3aCFM73kznDZFUk3bmcXl4KuWBhfI+B9Rq920kcV8svG0aZYQEm61RQcZN2dNlJvXFD1CTzTII+GWkIz4jme4Jvg7uinJtDXbP7NNQf+yfsrj7Fxl6l5y9SkYyvDG5EYyDG4p3+FYCl+CtwSROPqRh5l9zZvCefmoLIXU5Mh+cAH8+GyRuKRhabCcu0iPcdjMcQhvdGMNEAwnTrekgwdQfPQccXZrRhjHUnXhL8V2qUhypP0Syi6Ne1kIpV5hORQaXkxHFs+f3jahQIR2UY0rCgwBDM00qx4tR26xpH9iwMMO7vNEtlZ3LOHdDMUFA5qyyohKuHcig=
Content-Type: text/plain; charset="utf-8"
Content-ID: <34F7F1BEC142894E8C42EC3BD7793F7A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8042d9e-b326-4f03-58f3-08d6e91c2bef
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 18:40:52.3147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTA0IGF0IDE1OjQwICswMjAwLCBKaXJpIFBpcmtvIHdyb3RlOg0KPiBG
cm9tOiBKaXJpIFBpcmtvIDxqaXJpQG1lbGxhbm94LmNvbT4NCj4gDQo+IEJlbmVmaXQgZnJvbSB0
aGUgZGV2bGluayBmbGFzaCB1cGRhdGUgaW1wbGVtZW50YXRpb24gYW5kIGV0aHRvb2wNCj4gZmFs
bGJhY2sgdG8gaXQgYW5kIG1vdmUgZmlybXdhcmUgZmxhc2ggaW1wbGVtZW50YXRpb24gdGhlcmUu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBKaXJpIFBpcmtvIDxqaXJpQG1lbGxhbm94LmNvbT4NCg0K
QWNrZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0K
