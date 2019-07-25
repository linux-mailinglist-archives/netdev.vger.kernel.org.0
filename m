Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1725758F4
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfGYUg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:36:57 -0400
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:18494
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726763AbfGYUg4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 16:36:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OAFR+Zj3t73jC5X637D0WuyGEQ2PX946FegY+QSp3j6143zoJVcUJXtx5hiKJoiRnbr1hIZpPfkTFYUpn5hxFbBONW9mV3QDCWoqOyyijuzHmx4nY4tVr5v7yC0uIAg4Vp0E3cHtuYsQ4fsfTvvYmuFdTw0ceesiZmUYtzYVDBMaMND6pj0DIvX2cWJwWLY9NTiKjltnv+RLAozwnJYQJTrqLlH5QzqvSgBx5DBWWb8NhX8dBinTdZjiOVH2G641RaKHESTx7zK2ROpz3Je20bHbsWOg7CaOvRNBqsNJo/d/eYTgWFD2aL+lqgyVzjt0MU6Mvs0lM/DamRiX0CiuoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qiJaUJ6b9/HuQ6aflbYuuxidoWK1uIRj6vjxCQYSfj0=;
 b=U4U3s7krdV6o0C0lDMis2WQeDw70Y34JtBPZLTy8wtInuRL7oB4UXw15ac/Ec2f5K4QVBUqr5uxjFn258XBWoQqSPfUuhxgwZSNOIlGg0qxmtv1D5idHznaS3IjHiofbnf2Gxw9pKvkeAJBspTXPdQ/GIaujd1AUp8aev9CkfPS+P318MKJ0XUkCQiWZLUM5SA8dYtav4Vo+aAVt52+1h9TKFxv++pjPbRITH7dWlywVGl/ouFGY0jcOhlFfJWtgoqrxXnoijSJg7puJ5J2k8pNgwVOHwq+Ah5wR0Q0mWdpjbiElOCZP7ON+jZN4ocnxLAhg/xlzNpwKYi+RVz/m4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qiJaUJ6b9/HuQ6aflbYuuxidoWK1uIRj6vjxCQYSfj0=;
 b=U4za2D5AMlH7ZFPNJ1YjJPMDtuIPH7TZkdJZI5YtNzZRBhPjRKoQ6R/XDW1p6TeARSNQW0LW4Z5pzFjhV+iC9aosVuaW239i7Q3kNwS11eMGxV27tZz9tYs486DXsM/dIzGaMaDy5peP8WwAF8ou/z5wxTjNm97Hyiqr4+RjER0=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2504.eurprd05.prod.outlook.com (10.168.76.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 20:36:48 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Thu, 25 Jul 2019
 20:36:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 7/9] net/mlx5e: kTLS, Call WARN_ONCE on netdev mismatch
Thread-Topic: [net 7/9] net/mlx5e: kTLS, Call WARN_ONCE on netdev mismatch
Thread-Index: AQHVQyiuIyJivam7i0Wpy/eyS+CZSg==
Date:   Thu, 25 Jul 2019 20:36:48 +0000
Message-ID: <20190725203618.11011-8-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 59f8e9bb-b541-4cb7-dbc4-08d7113fd0d9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2504;
x-ms-traffictypediagnostic: DB6PR0501MB2504:
x-microsoft-antispam-prvs: <DB6PR0501MB2504DCC0C9C5E86564D0DE4EBEC10@DB6PR0501MB2504.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(189003)(199004)(2906002)(6512007)(25786009)(305945005)(81166006)(7736002)(8936002)(53936002)(71190400001)(107886003)(476003)(6436002)(2616005)(50226002)(186003)(52116002)(1076003)(71200400001)(386003)(99286004)(6506007)(6116002)(36756003)(14444005)(256004)(81156014)(478600001)(316002)(446003)(11346002)(64756008)(86362001)(66446008)(14454004)(6916009)(8676002)(66946007)(66476007)(4326008)(54906003)(68736007)(66556008)(26005)(76176011)(6486002)(66066001)(486006)(5660300002)(102836004)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2504;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1RagiyOLxYOUyRhlD3QYMbs3dZ0E6nZz/etDEMkghdLrQ/353wtypbTma58DDIPKmJUwUD9qX3lumd2I0W96k4ecSh/7hUmHJHA3jAUTZQM38JhPQUGADeX9wtK2wKICsbe381TxOyTLij0pEA4g4zbaAHD2UTCzr/qZIDmt2UZyBqWz+B7lDlImXcapNy79lh4EPwF6/H2PjRLsY/VyG9AcRAWn7DGaxAWgShl4llylYUiIjOuoMuhkmV2EyIvu+Z/gxtt4CZADO/GqWDPd4yocaPykoYlm8cTTgOVZPzOF3IxqTQ0ipz5f+1TDz6OihghCLW0bF98wLLGCl+f4j6Had2knX94Zy7GpeDeMWitRTQJITXSQ7DmzsoyhJRCMsLj/Hre0ewloaVVhF3u6v5o27kSajjVJgUTfgu3qcg8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f8e9bb-b541-4cb7-dbc4-08d7113fd0d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 20:36:48.4323
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

From: Tariq Toukan <tariqt@mellanox.com>

A netdev mismatch in the processed TLS SKB should not occur,
and indicates a kernel bug.
Add WARN_ONCE to spot such cases.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index ea032f54197e..3766545ce259 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -412,7 +412,7 @@ struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_dev=
ice *netdev,
 		goto out;
=20
 	tls_ctx =3D tls_get_ctx(skb->sk);
-	if (unlikely(tls_ctx->netdev !=3D netdev))
+	if (unlikely(WARN_ON_ONCE(tls_ctx->netdev !=3D netdev)))
 		goto err_out;
=20
 	priv_tx =3D mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
--=20
2.21.0

