Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84675AAE0C
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389743AbfIEVvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:51:11 -0400
Received: from mail-eopbgr150049.outbound.protection.outlook.com ([40.107.15.49]:1505
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388932AbfIEVvJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 17:51:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5oM36ikg9LDkKR0xvc8Vfde5qhhoXZwVG4T+1JVTseWA5QJAVW3rQAa03WZzAIZKI+KiIJ+98wUkVnHmpNYtMFZiTxEwLZP1LQySpP4OYWTNoU/gktawYJmWMkG6Rl5G6S4neE0lsMLN+bFws0mP3ZTOf7Wc8cMCMtnUlQy27vjgpRuHX7iDdAKxqILL+zWckCzbotHTcSoKEVJK3V16geopZZisJvepMY/3ooeIZAWzzwDzmqoXTzPmguFwyGeXEnexP5Va7dRroVQ8Vtg7KVUjwETeNMnT5EXTU0JQWxC+Iw+1w+3mv9CQNueB08cKO5OqNTsTSDPaKWkjxtjng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTe/lEkDddGEeFg35mPL7hmcH7yh4S+qS9x065Flas8=;
 b=jsRfiObJxhdHAefshc00bm2GwExMMuVYA3LlGNCfQHZZsg4f/S7iNUd70O5OA1GPxuzKeiQVdsCC2fkCxC+rtFGSk72FPtxOtucArIr5swGqCSAe9kzOge/jNxzLbWp8CqLXvAxuSR09yuP+sGqmBdhqD2/s9JgqKRZnLZStvEvqNDuCnzJusAf+tFLTHIga+51gfw1PA/5K/NQ4K/nOTyjIlGuShUso3HlpjAAZaR5laURTYqldpdSz7lb+Piakxe9Zx4EZe0ZAGE43oevt242VpGUJX5qw6TD9PnXEwu4BcXAMqVNItFKZWm7d5xLdYYEK5GNXyMg5kjnuXtbbxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTe/lEkDddGEeFg35mPL7hmcH7yh4S+qS9x065Flas8=;
 b=o+3F6K52fRu40r4hBSA3qTGY4GYJhKuWrwJt9/66Lr0ELgOt3HjjXeTOCpuK7fGX5FP9gSYG1UNWgS+j+nYmC/ENobesnYZr6C+kvt//hqV1iNne80HDjku4+tnQeUBUssqeIXs6S/+pfffjIV7bKfe72Fd9E1QpjwZOacNxK04=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2768.eurprd05.prod.outlook.com (10.172.81.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Thu, 5 Sep 2019 21:51:04 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 21:51:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/14] net/mlx5: fix missing assignment of variable err
Thread-Topic: [net-next 06/14] net/mlx5: fix missing assignment of variable
 err
Thread-Index: AQHVZDQDgwucjjQiekWOYjLoSSZbSg==
Date:   Thu, 5 Sep 2019 21:51:03 +0000
Message-ID: <20190905215034.22713-7-saeedm@mellanox.com>
References: <20190905215034.22713-1-saeedm@mellanox.com>
In-Reply-To: <20190905215034.22713-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::36) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e91b423-3938-4b2d-1452-08d7324b25d1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2768;
x-ms-traffictypediagnostic: VI1PR0501MB2768:|VI1PR0501MB2768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB27682925A2E52E3B60730C4CBEBB0@VI1PR0501MB2768.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(199004)(189003)(478600001)(86362001)(14454004)(446003)(486006)(2616005)(11346002)(7736002)(256004)(6916009)(305945005)(71190400001)(71200400001)(102836004)(476003)(6506007)(14444005)(66066001)(6512007)(386003)(2906002)(81156014)(52116002)(66476007)(66446008)(3846002)(36756003)(316002)(6436002)(53936002)(54906003)(107886003)(66946007)(8936002)(4326008)(64756008)(99286004)(81166006)(26005)(8676002)(186003)(5660300002)(50226002)(25786009)(6116002)(1076003)(6486002)(66556008)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2768;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: j7KZEVOqu+YLkYUxWznGYgrzwcVHvMOyponBLzn+VDl1Elkhi2mhSN6JuTcCdifK98eTM2Ts+CcXTg407qqHOEVPSPPSiFANAfJLL/WX4R2W4ElmEJAmeF6hH627mDN7M07d22qzjEyvx+VrKSaBNFtpmggY9A+ZdhCBx7pdpf2fmxQOXIs9LsAEQKtsUJXgnbQU5Basyr3fkZXiO9lABG1fMG9//vkNJFLoJQBn5+N4OsOSID3SXXgav3FFxTVfb/pQj/9mQ/Sa/Mn7LQr3nQgLi5ff+xwq2zOjWeXmu8O50W48bEInSaNC8EZfekl59GI7W3cRsm1l9NN5MZybcHeW5ks3w7i3jFHHmF+f3MGRONrwXpqN3suLHj3kNUDJY+WFKSD7OK0qyL4iFakb4sJ9FsybcdA+g36VjSn+0Wg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e91b423-3938-4b2d-1452-08d7324b25d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 21:51:04.1521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XErQfREtTdW42i3hd3cVw/u4Q0cepNJv7GRTWOjxVMErP6if9ULsQ+AJGNkyye3mUmgbkcQWxTCa8i5b5ykctQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The error return from a call to mlx5_flow_namespace_set_peer is not
being assigned to variable err and hence the error check following
the call is currently not working.  Fix this by assigning ret as
intended.

Addresses-Coverity: ("Logically dead code")
Fixes: 8463daf17e80 ("net/mlx5: Add support to use SMFS in switchdev mode")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index afa623b15a38..00d71db15f22 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1651,7 +1651,7 @@ static int mlx5_esw_offloads_set_ns_peer(struct mlx5_=
eswitch *esw,
 		if (err)
 			return err;
=20
-		mlx5_flow_namespace_set_peer(peer_ns, ns);
+		err =3D mlx5_flow_namespace_set_peer(peer_ns, ns);
 		if (err) {
 			mlx5_flow_namespace_set_peer(ns, NULL);
 			return err;
--=20
2.21.0

