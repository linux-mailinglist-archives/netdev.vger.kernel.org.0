Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8D1910ECE
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 23:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfEAVzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 17:55:03 -0400
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:32576
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726240AbfEAVzB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 17:55:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Ugfgjt8T4IW3+5pdWXGr3uIwe9qEN4m0sROszS8wu8=;
 b=deeihdi8iM3SOsrnjDk7881/EDtxXOZVh9a4tcVdz1zWCa001gzdshc+e1T1zNHm6msquC9SAuFr/X61iAV/TDs4g73i7pAaY7DudI0xfX2rQzJRVA1WhHu4/Ad+BIDIOOfjDYMH7pAIyzdxRoKMhu9GsAnfpHlNdpDRfRnLWk4=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5868.eurprd05.prod.outlook.com (20.179.8.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Wed, 1 May 2019 21:54:55 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.008; Wed, 1 May 2019
 21:54:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 05/15] net/mlx5e: Return error when trying to insert
 existing flower filter
Thread-Topic: [net-next V2 05/15] net/mlx5e: Return error when trying to
 insert existing flower filter
Thread-Index: AQHVAGiCLF/qQ94hh02VS0d+hCcrwA==
Date:   Wed, 1 May 2019 21:54:55 +0000
Message-ID: <20190501215433.24047-6-saeedm@mellanox.com>
References: <20190501215433.24047-1-saeedm@mellanox.com>
In-Reply-To: <20190501215433.24047-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0012.prod.exchangelabs.com (2603:10b6:a02:80::25)
 To DB8PR05MB5898.eurprd05.prod.outlook.com (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05caab0e-4b95-45fa-78b5-08d6ce7fa52a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5868;
x-ms-traffictypediagnostic: DB8PR05MB5868:
x-microsoft-antispam-prvs: <DB8PR05MB5868E0F923C4214DAF041750BE3B0@DB8PR05MB5868.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(366004)(39860400002)(346002)(199004)(189003)(5660300002)(256004)(86362001)(6512007)(14444005)(66066001)(71190400001)(71200400001)(316002)(478600001)(446003)(11346002)(476003)(2616005)(186003)(1076003)(6486002)(26005)(486006)(6436002)(2906002)(102836004)(52116002)(6506007)(36756003)(6916009)(4326008)(76176011)(50226002)(107886003)(66446008)(68736007)(7736002)(66946007)(66476007)(66556008)(64756008)(53936002)(54906003)(305945005)(8676002)(81156014)(3846002)(81166006)(386003)(25786009)(73956011)(8936002)(99286004)(6116002)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5868;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: b0/6dBsdgr5jtqN2//WY9AFCdqshbcAdEvKIi43+h+/7ydsnItO+ROlNQGzQDQqSQzO5RXnYSTnzaZrQZBlePRd8aWLluADNVg+ap1lj14W2PWNr44FSID7ysop5RWzMuYNDfBmnSkB7D78vXNcZNo/WPOA7t22Bhqd0R3EufYuRvcFzSRAbeWcCWoFIXvkuZ1FHgo3yjtPIK2l2l+jIzans2qJMo4YuHoKm0rWGvZEWg6t21DnPMk5wutmWj5FgC/JvEwFJrcoT8E5zVl8pnFFQDJbwSieNdiR94uxHxIa8ZBBZIApJ4waRh+wjRtYv2SD82LfWEyImYKLhv0VeJvb+9Sp1OFeAbqrzZpu06pj3LUjJUUuLKsWpqSpdftXxOfaM+24AtF2pYE6Q9+6z/P0BCBcAIOraYNSOzAioxS8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05caab0e-4b95-45fa-78b5-08d6ce7fa52a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 21:54:55.1980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5868
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVmxhZCBCdXNsb3YgPHZsYWRidUBtZWxsYW5veC5jb20+DQoNCldpdGggdW5sb2NrZWQg
VEMgaXQgaXMgcG9zc2libGUgdG8gaGF2ZSBzcHVyaW91cyBkZWxldGVzIGFuZCBpbnNlcnRzIG9m
DQpzYW1lIGZpbHRlci4gVEMgbGF5ZXIgbmVlZHMgZHJpdmVycyB0byBhbHdheXMgcmV0dXJuIGVy
cm9yIHdoZW4gZmxvdw0KaW5zZXJ0aW9uIGZhaWxlZCBpbiBvcmRlciB0byBjb3JyZWN0bHkgY2Fs
Y3VsYXRlICJpbl9od19jb3VudCIgZm9yIGVhY2gNCmZpbHRlci4gRml4IG1seDVlX2NvbmZpZ3Vy
ZV9mbG93ZXIoKSB0byByZXR1cm4gLUVFWElTVCB3aGVuIFRDIHRyaWVzIHRvDQppbnNlcnQgYSBm
aWx0ZXIgdGhhdCBpcyBhbHJlYWR5IHByb3Zpc2lvbmVkIHRvIHRoZSBkcml2ZXIuDQoNClNpZ25l
ZC1vZmYtYnk6IFZsYWQgQnVzbG92IDx2bGFkYnVAbWVsbGFub3guY29tPg0KUmV2aWV3ZWQtYnk6
IFJvaSBEYXlhbiA8cm9pZEBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhh
bWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbl90Yy5jIHwgMSArDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW5fdGMuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bl90Yy5jDQppbmRleCBjNzlkYjU1ZjhhNzYuLjEyMmY0NTcwOTFhMiAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5jDQorKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYw0KQEAgLTMzNjQsNiAr
MzM2NCw3IEBAIGludCBtbHg1ZV9jb25maWd1cmVfZmxvd2VyKHN0cnVjdCBuZXRfZGV2aWNlICpk
ZXYsIHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2LA0KIAkJbmV0ZGV2X3dhcm5fb25jZShwcml2LT5u
ZXRkZXYsDQogCQkJCSAiZmxvdyBjb29raWUgJWx4IGFscmVhZHkgZXhpc3RzLCBpZ25vcmluZ1xu
IiwNCiAJCQkJIGYtPmNvb2tpZSk7DQorCQllcnIgPSAtRUVYSVNUOw0KIAkJZ290byBvdXQ7DQog
CX0NCiANCi0tIA0KMi4yMC4xDQoNCg==
