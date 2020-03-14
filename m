Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA9E91853BB
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 02:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbgCNBQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 21:16:47 -0400
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:20602
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726893AbgCNBQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 21:16:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cy8XmbTNBF5Z75cCKnnqO3kG8VCdU6PDMeo/kLo5f/vAZ8LLTP1Zc2AsJUXAzY9TjG/2tF1jplmKcGoGMlG8njSd8SF91Efm0wmvAjrcN6E7xCiyr5QebuWJiAZdJUmCHB3Au3SkbdHtdF3TgOFNBc3y9eom/UcZ7DI2u7syG3gEHWD/sJ2IJUqr3wUlHxCo8ewAm7nbYqRP9U49M10ySPoAaMEBqkPqMrT6kcAQ6vpSxPgD7STD4SGd5MG35oblhSju0n2ScX+A7BL6xWGEbaiAbzwsNEtRWpRgs/AwVN46l1VlMdYQKFcosSimVxvYyWltvAZizPvm2dPsHer8eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdzdVagxYRJ0rQspefBm6u0sPAWMVWQcULpe2VZAM9A=;
 b=V4UZq1wMQFNJ+ACQXzeASjogH7/QaOl6gM0gtivGp0QyfdBB7hIeKshHkQjOMxseCplkWaFHaU3tRdc8oNr019DSFHMENRa63w0/SF27SHb1hA2bBrVeDO9s9KuSUbGL8ZLaGN0K9Wpo3qQu9t8L3U544ZAASv+R1hWBBzMqFWJbVAPS6f1CJ5h5IqpUBjF+WxoLmgn3MJIHFxceLjF86zm8JQXPXKlOVwAtx4DP/9Rt1OvhW2MtfYWlpoQw5snBNTyrQq2XJ2FLKvg7agBI8weZo938N9qnOesIttyVZOVXwlzKbYDvjuH6BM0pL8BdDCKGKlM4TKpd6gYfSL8QJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdzdVagxYRJ0rQspefBm6u0sPAWMVWQcULpe2VZAM9A=;
 b=ipmszOcEx+xIktKdSMpcY4RohTEiwldLWxI4hl15rcmiNtCj8D5PDBK19QWpzepn55pXEmnJStFGXO3TW+Xjrl8Q1Nmoyqudc02YmVjfvpY7ZR6pr79+po7+FxUHczI6ilO0fB8stW6s+0ReFvwnpNeWsGylIrwiE/41eMPoQD0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6845.eurprd05.prod.outlook.com (10.186.163.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Sat, 14 Mar 2020 01:16:43 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 01:16:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/14] net/mlx5: E-Switch, Remove redundant check of eswitch manager cap
Date:   Fri, 13 Mar 2020 18:16:09 -0700
Message-Id: <20200314011622.64939-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200314011622.64939-1-saeedm@mellanox.com>
References: <20200314011622.64939-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Sat, 14 Mar 2020 01:16:41 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2d101d44-7584-4a11-b0d4-08d7c7b55b39
X-MS-TrafficTypeDiagnostic: VI1PR05MB6845:|VI1PR05MB6845:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6845D1D2AFDB1768622146E0BEFB0@VI1PR05MB6845.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(199004)(86362001)(54906003)(6506007)(52116002)(4326008)(6486002)(6512007)(107886003)(2906002)(5660300002)(478600001)(316002)(66476007)(26005)(66946007)(8936002)(66556008)(8676002)(81166006)(81156014)(2616005)(36756003)(956004)(186003)(16526019)(1076003)(6916009)(6666004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6845;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xc1pbjsVPMh8+N1P0jICkHMm3gF5r6JCuhk1j20iHyWlreD6mArlWzrMLBLzFaXXL7LfNo+i9LPF+gMv+c8+Vr0mnH712635NrogMy+A3/sH9AQe5L54yIXhCZA12yBNTg9znXyJVzfD//LThjlinGn0mHkvDFfwxrJgFY+yoIVT+fAdI4QM2f8FQW5fAgg1TFHScesG9+sKk8SrihwKZu+QwZbf0OsPnWsCp+hIs2yNvAdKtMhaap3h17B4YxD7w0BSVolBEyMkUGey8q156hMeAW5egamLDhpK23d8ei3zZU5L5EusBrwTPrAX0NCSnLCrucAd3Mtjie2t5XJJO9eZmWtn/Ck9vLJ2TvG/ZEy4WB/a2iqepvSc8e5OS9eLZFPcZIqgS+cMCKzcJSrq8zlzZ/iGkBcqci1z2YNt2e4+MTIWPkPtoJSCpJI8QANhf2fad/1hdBNxRKfmX7VigVh6r58mIm2y+4XSllYZCNmSGk2IGZSvgK9/SJp1muIHsdDOIp9yri8mWl7aXJ5/YTmR8eHKy8YWm2awMkb5alw=
X-MS-Exchange-AntiSpam-MessageData: qX0NtxyZWeGS+p73Q1p+u9hfMwkRdFbkJiys1rsEpnLpLFgU6ZL23Krcc/R24R2NA9Ie7N4Y8XgjQtbWT7ZBoelsD+u8VdN3uIfVrFXyjFIz78dVMBZN/zYoeYwvHuAhXSZdAklmnSTXSIZ4Gr04Eg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d101d44-7584-4a11-b0d4-08d7c7b55b39
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 01:16:43.2618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6FEI+Q+bYC3SNL8XKngSY3PgakMWOaCgVpuxcfMsziWjjlMEBtR6yY6hMtdP02xfXod7sK607TVPgjAhSB+CuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6845
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

esw_vport_create_legacy_acl_tables bails out immediately for eswitch
manager, hence remove all the check of esw manager cap after.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 25640864c375..b123089866e2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1707,8 +1707,7 @@ static int esw_vport_create_legacy_acl_tables(struct mlx5_eswitch *esw,
 	if (mlx5_esw_is_manager_vport(esw, vport->vport))
 		return 0;
 
-	if (!mlx5_esw_is_manager_vport(esw, vport->vport) &&
-	    MLX5_CAP_ESW_INGRESS_ACL(esw->dev, flow_counter)) {
+	if (MLX5_CAP_ESW_INGRESS_ACL(esw->dev, flow_counter)) {
 		vport->ingress.legacy.drop_counter = mlx5_fc_create(esw->dev, false);
 		if (IS_ERR(vport->ingress.legacy.drop_counter)) {
 			esw_warn(esw->dev,
@@ -1722,8 +1721,7 @@ static int esw_vport_create_legacy_acl_tables(struct mlx5_eswitch *esw,
 	if (ret)
 		goto ingress_err;
 
-	if (!mlx5_esw_is_manager_vport(esw, vport->vport) &&
-	    MLX5_CAP_ESW_EGRESS_ACL(esw->dev, flow_counter)) {
+	if (MLX5_CAP_ESW_EGRESS_ACL(esw->dev, flow_counter)) {
 		vport->egress.legacy.drop_counter = mlx5_fc_create(esw->dev, false);
 		if (IS_ERR(vport->egress.legacy.drop_counter)) {
 			esw_warn(esw->dev,
-- 
2.24.1

