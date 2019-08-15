Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 911608F503
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731769AbfHOTq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:46:26 -0400
Received: from mail-eopbgr70050.outbound.protection.outlook.com ([40.107.7.50]:51424
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730512AbfHOTqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:46:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofCeXoeV225OZKwvfv1I6oO/ZfVfo6gkcnR1Zjg9g0Yl0Ov6bCrTRcOGIcmQ7TyptLO64Hkajb4IPMClV4ww76nnNvFlS5G1PT/ZH48XuBdMk0URPwPzqnadX+KAX8iQPDHIP87QNvT6BH2KH2L2OA6U5lmMHjfuMtjbklV9ddpFdb+uWrEyS+ot7q1ZDW3et1DuPODM5CIHBIvJ2hH83WPqeTv/5HM0SCRWtJLt1QZ5+JOPK7WqPUDos0LBVRoqaJ1lpMXVED774ZG5VxsKUyngtHaCRfZPr5EsfpQo5MxLaYiwJ5mMXmngac1cuRYKRvAcMS8eozoqUgfl0dHMMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CidwOrsOu+w6kLp8klJ1vS5Hc5Tw22ZxCTZ0akY4lD0=;
 b=RX3x3nnyBn7c8gHSjvStmHgy0vhmR+e4tZFwqMHWY0ZCw4p239iXTbUR2FD6Ck5GP+56DDAoDKBFXW7cWcku0aTTgObKZKEvnrrxZ+OdnUWfE+VKY8YDv5xvKm97DUUAKoS3Su6V/QaILXvhfdeKnYbwp2WqQoATnzzacQAlPohetxbSHSLkmTApS9C+cc5eFt4qZf0qDVVm3hGf1tn45hnowUz5KpcpFyDNU2miAmvnhzctatz3od/qwMzyoIubXUlnhNftbNi5c6cNicbsUbalVGkkZVYH8GNUik96ntxwgTS8EFTWluz2DZO1SGn4M+twvLVkuMb70gOMz9qKVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CidwOrsOu+w6kLp8klJ1vS5Hc5Tw22ZxCTZ0akY4lD0=;
 b=MTa9ShUtBM0r07LeLgqLvt73Gf9gJ/Z+fZmH0wKCtAF5rIEIVeO9d7bf2v5bE47SGBzN2ujR2yNmEeThJdhTsWYWeers3fTClTLzUUMGQbTVgGHdW1bKlF0M9I8FNNY61LCWtA8nbZi1Q3+bbakcZy0oBA4I20JGrgOBupcYfL0=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2693.eurprd05.prod.outlook.com (10.172.226.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Thu, 15 Aug 2019 19:46:18 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:46:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH mlx5-next 5/5] net/mlx5: Add lag_tx_port_affinity capability
 bit
Thread-Topic: [PATCH mlx5-next 5/5] net/mlx5: Add lag_tx_port_affinity
 capability bit
Thread-Index: AQHVU6IZ2DBFYXeURUSMsyX/55btkg==
Date:   Thu, 15 Aug 2019 19:46:16 +0000
Message-ID: <20190815194543.14369-6-saeedm@mellanox.com>
References: <20190815194543.14369-1-saeedm@mellanox.com>
In-Reply-To: <20190815194543.14369-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a2567fd-fc9d-4e9e-c6bb-08d721b93c34
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2693;
x-ms-traffictypediagnostic: DB6PR0501MB2693:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB269373C08E11B23AB6639ECBBEAC0@DB6PR0501MB2693.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1013;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(199004)(189003)(478600001)(64756008)(6506007)(186003)(102836004)(476003)(66556008)(26005)(14454004)(66446008)(86362001)(2906002)(25786009)(66476007)(66946007)(3846002)(4326008)(6486002)(6116002)(6636002)(76176011)(386003)(450100002)(53936002)(66066001)(107886003)(5660300002)(1076003)(71190400001)(8676002)(71200400001)(256004)(486006)(4744005)(54906003)(81156014)(8936002)(6512007)(14444005)(99286004)(36756003)(305945005)(50226002)(52116002)(316002)(6436002)(110136005)(11346002)(446003)(7736002)(2616005)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2693;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HJzQDcNwWWb4lWvT2D4ceunkAURdWuuWmydLQ5lC7Qf/vp8LssCaRNl8o1/sWGu2h9Ssm60B1JjRdokgQiov4eOaXVIJdpq7m2I0PpbcgG1E+TafHbumJzJ4sXniSKx3vql3VchU/wNK1PVm+aH7c0mamSo5PoiOUeZiYWnDJGedKLxV7kjZIEiXgqw2lBfjBWJVdK4RfVJtw4BteFTvPKyhGCy2YtC6UQRGgpbMQj5dW6uEEhpKVyW+1CBQrXznFcqgicqNUG4SbHQocX5GQGt2C1L05V3/VLpygxDP539mCUIhfboAOWJsYmVASzHp4Dnd2PYydaJh88DpPMlLPf9w/LQ3Y7t1mGQ+x2uxVgWMqCd8DGLj9DRL6dllO6u4yjUTSi/rEMno9UztirfPBrmsZuUeUM9LFZVeKsfC8/U=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a2567fd-fc9d-4e9e-c6bb-08d721b93c34
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:46:16.1841
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IiEly1amo/XRudzrQNeMexLoF9jOay2G/NpDQDLTHCvr/AmuPWO/5V0Kk7LcrYfTGHaay86LARh3BRXc22JLUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2693
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Add the lag_tx_port_affinity HCA capability bit that indicates that
setting port affinity of TISes is supported.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 2837fe4d8901..1e55cf73e88c 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1249,7 +1249,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_263[0x8];
 	u8         log_bf_reg_size[0x5];
=20
-	u8         reserved_at_270[0xb];
+	u8         reserved_at_270[0x8];
+	u8         lag_tx_port_affinity[0x1];
+	u8         reserved_at_279[0x2];
 	u8         lag_master[0x1];
 	u8         num_lag_ports[0x4];
=20
--=20
2.21.0

