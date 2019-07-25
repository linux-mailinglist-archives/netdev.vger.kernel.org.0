Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9E06758F0
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfGYUgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:36:47 -0400
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:18494
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726763AbfGYUgo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 16:36:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQHw/BiKY8yU2B0xhOILw+h760raQMWE46O9OA1+2tX4nrtg7jfZ68VOV2TLbqYA7HufgRBUtwRuGXxUWfzk/Nged8StxSQWMkkCK8hm+AXhtTQNLHc3VI3xycPNUBZz76tdoZj/z4HekglVASvWvKklFLy9GLjf5cy7OWSQhuNiqEGwWlaxADINMlLFd8+eOxa9f79Gs2K/HJDSBLtq5FptwIes1MT2MaBarpf/tZXwkSzXJBs5Am4N7TDlYUxNjH62+F+NQ8xa6WFW/QjGfqvNW/C73ucZrwK7WQrMfhElrcCe4oeh3J/okWM8mlAC2PvPkb11sedPMpBGCUSldA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=euMiyfXT2yQ0nZv/FnYTGdfJxOW2j7kIgdwA/PTpX08=;
 b=Wm07r/q9i9weGaLwKNAFtLC2D69oH5jfaBX/DLLaJSQakCgEaMz76BW98eimSMdeNgqJ901CRbrJ7yf4i7Mw0cLjpc/xLcICVyx+bYHwtoYIIc5vNhi2MatUyvop5n85zX+eiTWtguvRxNgO8elOdH2qAQ10L0WYpjXv8sAGwVYlcaEtDaGVAXnSNtoUN+A1j4/EqR0MfTwFqPuWS7wby6R4N+OsHyycttMzZ4twlGpKwfdk8uFG11e67uWZXO0VpJfCbJc6gfzdLVko7/9sIIn51IWdFeJzNs4vZdimL9stxyenplcNg+JBy6YrYt66fsFW6HxALN9uz7a+YYcNjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=euMiyfXT2yQ0nZv/FnYTGdfJxOW2j7kIgdwA/PTpX08=;
 b=kVVV3ZpGTolCmHs50eC0urje86MlmUF/8D3xPjFyIv8cwki3pU4Uaq1X7QO1ZFRBzpcjBVBCDucSesJlAxPuXFbAaAe5rRk3tcJo2RJ6y7j9eXwBiLC1xz/KHfK60d6uzCQ2hoDvNfkhIDv6dTxwzwk2O5UGLPMXGAyuuBQeskQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2504.eurprd05.prod.outlook.com (10.168.76.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 20:36:40 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Thu, 25 Jul 2019
 20:36:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Edward Srouji <edwards@mellanox.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/9] net/mlx5: Fix modify_cq_in alignment
Thread-Topic: [net 3/9] net/mlx5: Fix modify_cq_in alignment
Thread-Index: AQHVQyipfxlObBfl5UqyfJ9uPQNrTg==
Date:   Thu, 25 Jul 2019 20:36:40 +0000
Message-ID: <20190725203618.11011-4-saeedm@mellanox.com>
References: <20190725203618.11011-1-saeedm@mellanox.com>
In-Reply-To: <20190725203618.11011-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0042.namprd02.prod.outlook.com
 (2603:10b6:a03:54::19) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53f18c4f-eba4-4bf5-c3e7-08d7113fcc1e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2504;
x-ms-traffictypediagnostic: DB6PR0501MB2504:
x-microsoft-antispam-prvs: <DB6PR0501MB2504AA07CA0729EED2A59BA9BEC10@DB6PR0501MB2504.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(189003)(199004)(2906002)(6512007)(25786009)(305945005)(81166006)(7736002)(8936002)(53936002)(71190400001)(107886003)(476003)(6436002)(2616005)(50226002)(186003)(52116002)(1076003)(71200400001)(386003)(99286004)(6506007)(6116002)(36756003)(14444005)(256004)(4744005)(81156014)(478600001)(316002)(446003)(11346002)(64756008)(86362001)(66446008)(14454004)(6916009)(8676002)(66946007)(66476007)(4326008)(54906003)(68736007)(66556008)(26005)(76176011)(6486002)(66066001)(486006)(5660300002)(102836004)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2504;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mCspZvl0FgocDZQEh8aiq7pnePybVB2nZ4BxGdQa/MjVOkaSnnK7VkUS/ywTYjs0jTaGGr+DlbCaxajmvIbKSk3+zytktCygRVYotGHUfV5sLjp3760oeHj1MJM1r5vEjt33e3LQ7UGwqBl6xHduk03tpVx7BPml2Ook0V9E3jnOSAWJC7IDsJiA7j2miwzG8sUgbNF5psaMI2wSdhpd1ifwWzG3Y3VrMe+zQZYSBFECuK6vDHCZCIduRWvHa8LNruy+6Dw06NMhj7cEQUWLzdKCAZ4msSQnzD6Kux9OAdJ1K6XbVO9zTBalsVHkZ90en00V4OQKORzeuDaj8TmhCClqKMRTXC1TPC8rHA51+RgFtYYNPoFjFqh3edSETAwx8ZPNrIhPXvApVKLAiMxWrcoXOuXymgBKh7KYFOA8Qis=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53f18c4f-eba4-4bf5-c3e7-08d7113fcc1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 20:36:40.4333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2504
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Srouji <edwards@mellanox.com>

Fix modify_cq_in alignment to match the device specification.
After this fix the 'cq_umem_valid' field will be in the right offset.

Cc: <stable@vger.kernel.org> # 4.19
Fixes: bd37197554eb ("net/mlx5: Update mlx5_ifc with DEVX UID bits")
Signed-off-by: Edward Srouji <edwards@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index b3d5752657d9..ec571fd7fcf8 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -5975,10 +5975,12 @@ struct mlx5_ifc_modify_cq_in_bits {
=20
 	struct mlx5_ifc_cqc_bits cq_context;
=20
-	u8         reserved_at_280[0x40];
+	u8         reserved_at_280[0x60];
=20
 	u8         cq_umem_valid[0x1];
-	u8         reserved_at_2c1[0x5bf];
+	u8         reserved_at_2e1[0x1f];
+
+	u8         reserved_at_300[0x580];
=20
 	u8         pas[0][0x40];
 };
--=20
2.21.0

