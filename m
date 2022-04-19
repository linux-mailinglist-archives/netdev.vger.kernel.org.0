Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8F8507124
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 16:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346700AbiDSO6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 10:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353707AbiDSO6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 10:58:23 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7788B33EAD
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 07:55:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WkTDeYdFvWGwqLH/pkHG3juBWUfBk0uZONyrVSNpvwoiU1WGKu8AEfJB50ybdp7PzNT1Kxd0S0lNa/LDxNdVT5sMlNhjMHAI6b+NAeQzQzeb2PiAFgvDjMQWounDRpjGuNfAGxsz+xJJwPn7NuKy4Y6H3xv+kwmc6ANYBeNrgCUs4qPG2hvuiAGpP/Cd7fmDpep0BTtdaqvmIxiUFJk6cYmlxx8yCKbf3QswEtpKNUi4DYpCw+S24FsriwQcyvzTzLr7lZgusuECKPTCUll87yWba0jbChw7257ZFv2dzIRQiO6r37hL0ao4sipNBa2d3dWINSBrlyt4N4YXeuDbtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DlDtQIbRmcNPmYTkhXaDF6wuRujGCnttTp5ooD7tj24=;
 b=fTVMHLBhiI3Idpb/BGnv8L0xnHI4RONtSxSR4ONV2hPnCiaaVogoa4Qlliduwtvd/gActJEz1we4T97TA43iXU+mIOrLIP4WsTJG2MnZFf4GxnIacicJ9XbGzKMAPwk7mBTUqDDpPyJmKVmVmXlz0rTPjq1zzGbgQ3ZkxyW7VMDJdeqT0jdgba2HXDtxygy9TZKJnlkNs8lnki/Mrf2VG64w2nS8jSvapfx21hFu0Vu6Rvy+fCIz7OzkKHoO9Chj6ndgBnLdzsLJ8xPJXy0+3QrPtd2576bJ1uPlE8THHnme2r6gX+bSZYyPyYBczrSWvscTuQQII1TYSJH3XTMPNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DlDtQIbRmcNPmYTkhXaDF6wuRujGCnttTp5ooD7tj24=;
 b=GWMkjC3YGYqnwm3TMyqlbjYdnZT5kMjmYEXDcaQcU2/O4IpsoHH7sRiqW9HhyKxI54Jh+ove9BMz9H/gbU9OTX4yKYIPp53WUl0AhrkFO9yoG3UPbc7AkpJk3bnbGF3fcQWg9nxyMMGiMuof14tMVHeFgnyWXfQONrOt+Ifze8HkyD6uIDycyP351Gzx/NczryQQKG/tBH2QO3Ew3mKTQD0tQ7taDsd5ItFNDDQQVkZHu1kiNMYsYh0+hqmNG879BCIQ1N/pZSij4wgJvkuldg9QXo4ayJbtdwC1px1KUgxZcWRk2tUIQKW64bx/YSbF8LyQRP4kPmUlICqpcDf6GA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4347.namprd12.prod.outlook.com (2603:10b6:303:2e::10)
 by BN6PR12MB1378.namprd12.prod.outlook.com (2603:10b6:404:1e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 14:55:38 +0000
Received: from MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d]) by MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d%2]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 14:55:38 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/6] mlxsw: core_thermal: Add interfaces for line card initialization and de-initialization
Date:   Tue, 19 Apr 2022 17:54:30 +0300
Message-Id: <20220419145431.2991382-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220419145431.2991382-1-idosch@nvidia.com>
References: <20220419145431.2991382-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0032.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::45) To MW3PR12MB4347.namprd12.prod.outlook.com
 (2603:10b6:303:2e::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 024a3003-01c7-4a00-d504-08da2214aa96
X-MS-TrafficTypeDiagnostic: BN6PR12MB1378:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1378994EB42CDEA66E3F7F3EB2F29@BN6PR12MB1378.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AgR2dd7cBpB3EsJeZyc86eEhb+vipQlKEgnwC0ovCUE/DXt4/tHpiUe2lTHnwOrYv0OaVB1NZwDmTggskraAQA8ET8pQBeLiWnEWeS198tGMVL+xpGKKyraRHr2WM0+gmNSK231lB2EH5mCReZgo6i9BOq4wKHm0zivnwDEFpvqX/5XGkHkfKOkqOfdwQ0JrMCNauZlniHUN0eD6eo45gwqMxIjQjmNfMFaX40tbsF5gXkhiQ/SJtk+nJ3Ub38pNMg6FCMxJ4IYGnajUU7LBn1xEEbkXOh+dOgDxIsFjOuSI7qj98xgzh190Tpulw6+yZXOJEaDU5JebzhiN9RsHeml7uo+qzm07vyAG6vf++B6WSP8GoyeQt9iueZn6d1BP3mi4uqPsyFLgQPoIK4A45yFd+jCO7T8tRCtJGXxNQQKrlPDVqq64/RYXKnUTuiOlPCFTKjnVuwo6+99oCCf6PLgTjct5qQdZ9KUtuYDEeWnK+k+h3b9i2glmzC04Hc/BbDAf2flr7yNK8O6QyGu1SJKmu6zDfQPo689Ku9QUyYa6C5LkNa66cEi4/S9ob0vsfKY6OuyFmBZ/5KAnY1l4gvAz/+ru/6vUpg1PaxaROBFMO23PwXPLqdwepEhfut6CcfL17l0zZB2k5fPEsG25+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4347.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(38100700002)(6486002)(508600001)(6666004)(8936002)(5660300002)(316002)(26005)(6512007)(8676002)(4326008)(66946007)(66556008)(186003)(66476007)(2906002)(6506007)(6916009)(2616005)(1076003)(107886003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LDK392H95pPJ6h2rYzxG8UHf8FgtjQBEQ6tgDzzXUb1vHJESSH8YLa+1HcWN?=
 =?us-ascii?Q?q3gjVlSJEVTh5OvQTX/VfhRXCDk/SPtUxEqWuSDemBlSx4JodHpNs+sVoRv+?=
 =?us-ascii?Q?KZSKZTv3Js8wFVS428Yo8p9n4YIK2Dv1xAtRRLf0P7ZiT0f2FvGDd14xLbuw?=
 =?us-ascii?Q?iBE/U2pJn0JkzmkeGSBD3BMu8FW+JX3QMSSusH64vrGl0XlPkhHnLABtNxD7?=
 =?us-ascii?Q?3EscnBA1L1AsLeqWyiLyoCMRtIlX7XZHh8GWrkjvINda2fxfTSZNdZZKJfK9?=
 =?us-ascii?Q?sBsKR1P2SARbR031nzhIO66bNPXIQEagPonuTK+h8+s26c2WRUO4/E90kVgH?=
 =?us-ascii?Q?jK2ouTBNExpylnAefE2U0PC0T6qoUyhU1aVd0fgNCrWqlwh9yA+RVoFEmfuS?=
 =?us-ascii?Q?h581ZRP78LfiFk6tdWIbcvW3CSdIoEDFbKqVxgL9mSLC1kLSl1vtcPBJ5gE5?=
 =?us-ascii?Q?nHpAKaq4ACpwqiOnXxGOYXBfTSc0uFokIGYWZBZr+RcYoBFpLBDGOtCADHlK?=
 =?us-ascii?Q?ofTc4HZ9T72cQ1fgJfLKGSBZAGtVEtUnN5K+sw4wv6YUbkTPBu9bkA4vUtU9?=
 =?us-ascii?Q?OXQvcwHu540dcFjavn8G8fs9D4WYK/Y7rOheeE9QB0uGMoJHpAiTAo9UzZWS?=
 =?us-ascii?Q?MoMlHqHkyRH4abGFx55hhCohmEgv4r1dq5XDKah6u3q91H8YJ2poYdkMLoJd?=
 =?us-ascii?Q?3N9o+0cMmWAEuHOKtA+kImx6U+hwH+boBtkj+o8cP6fPCp4G4nXy+SW6a+Wt?=
 =?us-ascii?Q?FVvt9bINA8rscBvBkIuGU2MKnSmRKD/hgq2ijvQSZEO3Ube7+0LK9DhgNjeQ?=
 =?us-ascii?Q?JLtyQFzNjC/8GcfvMay5NFpr0HwpIcue3rGtxDMaDQ01zRMpWsA6BqF9rUK7?=
 =?us-ascii?Q?OtFpJ6lRTcHfUjcj6Md0vel51YV/5KIE/BNfPuwxkYGaGHgYXhfSu7BJ1d2Q?=
 =?us-ascii?Q?fu53bvYNP6WiJ+r9ucm32QlhEJn33xt4bwiaGMpn8aEuS3QRNBZfFHQby+Iw?=
 =?us-ascii?Q?UjjMB8kDIYyMUvY5XXa0hyaKRSAYpilLwpqeEagZ5ncqqiRvK2/tB4nT8D/Y?=
 =?us-ascii?Q?gO7qrZEZEnMnMrNj6rKK1aWxQSBOmBsbIdEV1BZcQ9DT28UNaGT4pSRD+k4C?=
 =?us-ascii?Q?tPAOZK+/kPy2WXEgVavaQJVgdLyMVY/yhL+W5Yd2mfHD6T4p5O4Q/i90KcHI?=
 =?us-ascii?Q?5SJ7hCpH6Kujz9BvUiMrQBlOviuiD12CshIj2XjWvuljy/CdrnEXz4g8LorZ?=
 =?us-ascii?Q?tIHsCtzEcuriztUszlf8E54PjXbFUZnu+/9J/FsEWSccQ4uXWHwqQy9I+peN?=
 =?us-ascii?Q?sl8DIazntbRLA9JJBWgLxHaMRP+Tpbcli3xW5PmBt6eVTXKhC+4LjzOqCzOe?=
 =?us-ascii?Q?QJrxUdJ9SloFyw9E7JSi3/fffNaVdmd4U8eVCzVYAvGqre9hHQeknpFS+bMX?=
 =?us-ascii?Q?saHM2cfoyk632Htvqoc2yDKRHvdFpWZypTGgvAop9Zcdt95POrrXyjixO5bb?=
 =?us-ascii?Q?mSh+sxuK1wXkcd3Uall6B96TWOngTM5hQvkZAmFGfoHVWBjjb3H/V8upih3S?=
 =?us-ascii?Q?h3kpBkkZd7R5tQOkCxgGWK93X6/z5fEEpmBJdb53V/hZpZy2AqWFSNzHNVIo?=
 =?us-ascii?Q?PAA+CSeam+765IL/8rt4vXAGZHkycDmZpIjkNIfjLV1Ka3PTMaZgjyBHmwbQ?=
 =?us-ascii?Q?6UGk+r0rZ/tzm1lzSAwa7CHgaHv0V5yOUgsK1RLJ+TQ4mOyqMFT/gIpDvdWd?=
 =?us-ascii?Q?GE9u4zkXeg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 024a3003-01c7-4a00-d504-08da2214aa96
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4347.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 14:55:38.4923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rQPuG2lsFZ61s/c9SU/+RleVZMpksI/h5cUNq9jfObVv/Ojxb7oLFdmPBynNqhN/b2M86SKIVRq+/55/C39Dww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1378
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Add callback functions for line card thermal area initialization and
de-initialization. Each line card is associated with the relevant
thermal area, which may contain thermal zones for cages and gearboxes
found on this line card.

The line card thermal initialization / de-initialization APIs are to be
called when line card is set to active / inactive state by
got_active() / got_inactive() callbacks from line card state machine.

For example thermal zone for module #9 located at line card #7 will
have type:
mlxsw-lc7-module9.
And thermal zone for gearbox #2 located at line card #5 will have type:
mlxsw-lc5-gearbox2.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 74 +++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index e8ce26a1d483..3548fe1df7c8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -90,6 +90,7 @@ struct mlxsw_thermal_area {
 	struct mlxsw_thermal_module *tz_gearbox_arr;
 	u8 tz_gearbox_num;
 	u8 slot_index;
+	bool active;
 };
 
 struct mlxsw_thermal {
@@ -913,6 +914,64 @@ mlxsw_thermal_gearboxes_fini(struct mlxsw_thermal *thermal,
 	kfree(area->tz_gearbox_arr);
 }
 
+static void
+mlxsw_thermal_got_active(struct mlxsw_core *mlxsw_core, u8 slot_index,
+			 void *priv)
+{
+	struct mlxsw_thermal *thermal = priv;
+	struct mlxsw_thermal_area *linecard;
+	int err;
+
+	linecard = &thermal->line_cards[slot_index];
+
+	if (linecard->active)
+		return;
+
+	linecard->slot_index = slot_index;
+	err = mlxsw_thermal_modules_init(thermal->bus_info->dev, thermal->core,
+					 thermal, linecard);
+	if (err) {
+		dev_err(thermal->bus_info->dev, "Failed to configure thermal objects for line card modules in slot %d\n",
+			slot_index);
+		return;
+	}
+
+	err = mlxsw_thermal_gearboxes_init(thermal->bus_info->dev,
+					   thermal->core, thermal, linecard);
+	if (err) {
+		dev_err(thermal->bus_info->dev, "Failed to configure thermal objects for line card gearboxes in slot %d\n",
+			slot_index);
+		goto err_thermal_linecard_gearboxes_init;
+	}
+
+	linecard->active = true;
+
+	return;
+
+err_thermal_linecard_gearboxes_init:
+	mlxsw_thermal_modules_fini(thermal, linecard);
+}
+
+static void
+mlxsw_thermal_got_inactive(struct mlxsw_core *mlxsw_core, u8 slot_index,
+			   void *priv)
+{
+	struct mlxsw_thermal *thermal = priv;
+	struct mlxsw_thermal_area *linecard;
+
+	linecard = &thermal->line_cards[slot_index];
+	if (!linecard->active)
+		return;
+	linecard->active = false;
+	mlxsw_thermal_gearboxes_fini(thermal, linecard);
+	mlxsw_thermal_modules_fini(thermal, linecard);
+}
+
+static struct mlxsw_linecards_event_ops mlxsw_thermal_event_ops = {
+	.got_active = mlxsw_thermal_got_active,
+	.got_inactive = mlxsw_thermal_got_inactive,
+};
+
 int mlxsw_thermal_init(struct mlxsw_core *core,
 		       const struct mlxsw_bus_info *bus_info,
 		       struct mlxsw_thermal **p_thermal)
@@ -1018,14 +1077,25 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
 	if (err)
 		goto err_thermal_gearboxes_init;
 
+	err = mlxsw_linecards_event_ops_register(core,
+						 &mlxsw_thermal_event_ops,
+						 thermal);
+	if (err)
+		goto err_linecards_event_ops_register;
+
 	err = thermal_zone_device_enable(thermal->tzdev);
 	if (err)
 		goto err_thermal_zone_device_enable;
 
+	thermal->line_cards[0].active = true;
 	*p_thermal = thermal;
 	return 0;
 
 err_thermal_zone_device_enable:
+	mlxsw_linecards_event_ops_unregister(thermal->core,
+					     &mlxsw_thermal_event_ops,
+					     thermal);
+err_linecards_event_ops_register:
 	mlxsw_thermal_gearboxes_fini(thermal, &thermal->line_cards[0]);
 err_thermal_gearboxes_init:
 	mlxsw_thermal_modules_fini(thermal, &thermal->line_cards[0]);
@@ -1049,6 +1119,10 @@ void mlxsw_thermal_fini(struct mlxsw_thermal *thermal)
 {
 	int i;
 
+	thermal->line_cards[0].active = false;
+	mlxsw_linecards_event_ops_unregister(thermal->core,
+					     &mlxsw_thermal_event_ops,
+					     thermal);
 	mlxsw_thermal_gearboxes_fini(thermal, &thermal->line_cards[0]);
 	mlxsw_thermal_modules_fini(thermal, &thermal->line_cards[0]);
 	if (thermal->tzdev) {
-- 
2.33.1

