Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56D9410105
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 22:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfD3UkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 16:40:05 -0400
Received: from mail-eopbgr10048.outbound.protection.outlook.com ([40.107.1.48]:9176
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726372AbfD3UkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 16:40:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Ugfgjt8T4IW3+5pdWXGr3uIwe9qEN4m0sROszS8wu8=;
 b=xqstiXYsB/zJI6brg/BcX3UezuRVfQU9CXtbBkbxIgtFlMmGHzY3OecvnRXSm0qqm/w3t8maUeKaqhBRt6UUkV5Dxg0e9fGnzMy+Cqqq0Kv8tRem0uBdJewJ/0Mdfws1QBLbQ9ORjCmZ6l55ccEOF4H0LfNGc4+5Ou5YdLXYykw=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB6542.eurprd05.prod.outlook.com (20.179.27.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 20:39:54 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::1d74:be4b:cfe9:59a2]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::1d74:be4b:cfe9:59a2%5]) with mapi id 15.20.1835.018; Tue, 30 Apr 2019
 20:39:54 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/15] net/mlx5e: Return error when trying to insert
 existing flower filter
Thread-Topic: [net-next 05/15] net/mlx5e: Return error when trying to insert
 existing flower filter
Thread-Index: AQHU/5TeOo5yvZMMeEWqa4TRmBkuPA==
Date:   Tue, 30 Apr 2019 20:39:54 +0000
Message-ID: <20190430203926.19284-6-saeedm@mellanox.com>
References: <20190430203926.19284-1-saeedm@mellanox.com>
In-Reply-To: <20190430203926.19284-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:a03:54::32) To VI1PR05MB5902.eurprd05.prod.outlook.com
 (2603:10a6:803:df::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac25440a-728e-4063-c19d-08d6cdac0037
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6542;
x-ms-traffictypediagnostic: VI1PR05MB6542:
x-microsoft-antispam-prvs: <VI1PR05MB654278A8A17D6E80C6F9A33DBE3A0@VI1PR05MB6542.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(366004)(39860400002)(189003)(199004)(99286004)(25786009)(102836004)(53936002)(36756003)(386003)(478600001)(186003)(6506007)(7736002)(26005)(2616005)(476003)(446003)(52116002)(6436002)(4326008)(305945005)(5660300002)(76176011)(486006)(66066001)(11346002)(14454004)(107886003)(6512007)(6486002)(68736007)(71200400001)(2906002)(6916009)(81166006)(316002)(1076003)(97736004)(81156014)(66446008)(64756008)(66556008)(50226002)(66476007)(66946007)(73956011)(8936002)(54906003)(256004)(8676002)(3846002)(86362001)(14444005)(6116002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6542;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OO44LcuKGOT5kuRCpnaWncVmmSmukbeXXsvPhGsW56uiLmykmvZoHmzwFvRsY7XMahHTmf5z9r/khxKh87oGGb2uyd7lRG1MxbtZBboUjUdteHXK1/lX4GCu1qKbbe/jLhRz/2a9A7HK99pGaqXOzZZ4PRJZSJ0UPbpHaB7dBziDNXGkDx6i04dfTC7QIg8RN/Aalgn/e3QPaUGtwBn7rX+D+MJkqYJPg3gHKL4JEnL7OW61GLfGqP5f8nN2EO+FjJFsT5fGacmOmJCoqGv7oz2GLuMzWpxdbnsBOGHXD643IooNs3AlJFS20HZyZz7WEb5Twyi3GyPmgnPDoB23owEQkvAqMWWo4tyLkF80LvACOcfT1O+3XZP5DzUJC4E8kmfQ0uT1utr1GR/n1qN5I4WZduRs23PuRA9HUKdUgiY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac25440a-728e-4063-c19d-08d6cdac0037
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 20:39:54.6981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6542
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
