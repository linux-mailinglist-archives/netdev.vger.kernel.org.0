Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7959869C5C
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732443AbfGOUKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:10:01 -0400
Received: from mail-eopbgr50045.outbound.protection.outlook.com ([40.107.5.45]:60879
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732127AbfGOUJ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 16:09:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iaosADfaqYEf1A8Foc9ttNwxZWDLMW/HPWP3ECzq4u/1cnCKJvG8d6C9DEoALiE52rJMoVgssFEKp1rYAE4fzmBfMPcxvlPK7HMRDWHeIsbYVXrHS9lNIWnzulkxvLsVnbTdHrO39PHEHxGamXidSAMom7iziFS0c/BkW/SactkRAwWO/ekFRaBgqSWCDAKh4fR2o77RbArEiSS7Th8KeMG2hqDVtvWvjjfVdjX/K2EGmz7hYtJbEqaGdXc1OEwTkkuTGcuSLgJHPpV5UGQNSK7sGjz8dvH9r3s+IVLr/bdsPCrNiOwVJMECoTkjs9pNzO6xM5JxCWm6Fg2TYNcI8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LrBgTxTjEGJvTpGoP0th/Y22p+T71JyDujAQcRjZb/A=;
 b=CS2tCLDgU7kbpHQLCxOAQZM+DtzDM4dYD8H+vuybChhSmymL4iteOBlqb8UEjzc7MdvneJL/g3pjGSf80v7psxkpSVAJczAeZcpRBnCOTElQj1sbVwx24P+w+a1ddy8aM9BTunsHWKd8Wvgkvg5STjdn0laS8h2vcNmcvCrjRagz/FIQu4kXPBVc8IAMlKR2H0EVB81k3leaa19KwoiBmz/x5iucq+MksAcXyVJo5hYDMXnljnAMRhqdQ4RKVX0Px1wvWPaf5DIxtM22I205npgYa978W/4xUGV3YoOpwZY+CZBF8kSJvkKvH02sLujBatYltY6kA/TeOWHVNxjNjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LrBgTxTjEGJvTpGoP0th/Y22p+T71JyDujAQcRjZb/A=;
 b=gDJUKB3m/G6JzUUsO67m53q9eRZMmGgVqFpBHIdPVMd1+sS0E6DSun1CYtKQ/wYp8KNd+RCmgeBXYXbxilmqh5lFpY1ODqbNl4AOwvAOQacsvvXe4LyUlgUq7huFzXyZHa2jrX7O6UL5EwHP2+IeLi8rkidAnqXYZli3gVua90w=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2485.eurprd05.prod.outlook.com (10.168.74.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Mon, 15 Jul 2019 20:09:55 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2073.012; Mon, 15 Jul 2019
 20:09:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/3] net/mlx5e: Verify encapsulation is supported
Thread-Topic: [net 1/3] net/mlx5e: Verify encapsulation is supported
Thread-Index: AQHVO0lEd1uCafCkG0mai6HPpclcGA==
Date:   Mon, 15 Jul 2019 20:09:55 +0000
Message-ID: <20190715200940.31799-2-saeedm@mellanox.com>
References: <20190715200940.31799-1-saeedm@mellanox.com>
In-Reply-To: <20190715200940.31799-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR07CA0061.namprd07.prod.outlook.com
 (2603:10b6:a03:60::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 532ef0f0-65d0-4827-8cda-08d709606718
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2485;
x-ms-traffictypediagnostic: DB6PR0501MB2485:
x-microsoft-antispam-prvs: <DB6PR0501MB24852802128CC67F1519F6ACBECF0@DB6PR0501MB2485.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00997889E7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(199004)(189003)(6436002)(305945005)(25786009)(7736002)(102836004)(6116002)(26005)(6506007)(81166006)(3846002)(81156014)(5024004)(53936002)(107886003)(36756003)(478600001)(486006)(6512007)(186003)(256004)(8676002)(68736007)(386003)(8936002)(2906002)(66556008)(86362001)(99286004)(66476007)(476003)(66946007)(64756008)(2616005)(446003)(11346002)(66066001)(5660300002)(71200400001)(66446008)(14454004)(71190400001)(4326008)(6916009)(52116002)(76176011)(1076003)(50226002)(54906003)(6486002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2485;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KQ3ZdkxBAgL9DcMWpQEfNXDitar6oHGAo/VS8VdJuRzugp3w7q+PlAKF5WB8d+G4EWxtdg0ihEsCS9N9UycBLgcrOX7SghTLs3S50fJVLt7pC7vzJG0VR5/lRZ8YxnS6jR12p59nvY5Mue6uAxE6H8eIncYqEUR4sAx/+SLB2FqAsX3sWBjA+6I+skakwAThKUoLHXsMZ6TlgXwJsZcV0TXJp88t0BlIUYUTg0l0hL2TtChMi8eWQh8uiKaLNGyoM60Py9Kd7b0MofjD6PRdVZ8qG6AWSgvvwAlBMrQekGxbq152/k6maw0oS7XuVLJ5DOyGPxqQQobS1GtVYUWAx2gh8pRkZpr+Qq9L7QC6MK6pQvjN8Z/eB7JUffrjgLFcTKL+0pRSYzUMTZbMtgseGDTl2JqkMyVtB1nKxrk+qZ0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 532ef0f0-65d0-4827-8cda-08d709606718
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2019 20:09:55.1525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2485
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

When mlx5e_attach_encap() calls mlx5e_get_tc_tun() to get the tunnel
info data struct, check that returned value is not NULL, as would be in
the case of unsupported encapsulation.

Fixes: d386939a327d2 ("net/mlx5e: Rearrange tc tunnel code in a modular way=
")
Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 2d6436257f9d..018709a4343f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2647,6 +2647,10 @@ static int mlx5e_attach_encap(struct mlx5e_priv *pri=
v,
 	family =3D ip_tunnel_info_af(tun_info);
 	key.ip_tun_key =3D &tun_info->key;
 	key.tc_tunnel =3D mlx5e_get_tc_tun(mirred_dev);
+	if (!key.tc_tunnel) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported tunnel");
+		return -EOPNOTSUPP;
+	}
=20
 	hash_key =3D hash_encap_info(&key);
=20
--=20
2.21.0

