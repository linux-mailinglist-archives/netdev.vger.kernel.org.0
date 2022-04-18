Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C77504CD0
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbiDRGry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236887AbiDRGrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:47:36 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2041.outbound.protection.outlook.com [40.107.100.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9966319280
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 23:44:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ik1EiDZodsQeL43zshcmBDzHhkANG3qUGXHMKAuRL+6zL2RiqiNS7CGyHNiI2a0Frdx14LNxN7FtEH0hnTHa2xOeJRM1zpx9nFUhEFJrQJsynVJqKhVEHESQxBqxDT50vM4ikWFl80GoP/JX4iIv3bOm8fzvvoZKGaDRjpo+1O9lfpqGIcQtUyBgNjFBZ3+sYS4S+ZNQLHezRAoAVRyvnLi6ngLXihhy+avHi3D7z2/mVQoEvm47VNAWjg9Y34kg6QrYKgae1wtoLNp7jHYybAI/phpzjz7StHkFbMtWGq9xES/6li0oe54ll+yJbX3j+Lt6mS3TxhGRutxjfoFe+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P67b8rd1F3gkfaAJC9PFTkYlUCUQXdMbv6+TZ+EMAg8=;
 b=NPxet/loCo0XU61mpGAkIfsHUNed6BN3ZDTepPVEmzasUJynv8FosDkFUGcSO09W+m87PWQpxflALvHsgBawp+PLIafYJvXZEsulQAqE9uXzS91ddLaiiuFBAMxuL/y8/p1miZJEIOjFuRUpWNF3cKtskb4mtuO5K2qY901xuPoiaZJvxu3sx4ptjoZx94qmSrYOSZv6sewKaOMf1Go2v6i8Km+4Juwm9yrZbMRqRUyMbXd2g2vyWDe7nKqN/ew82IG2kd4X6xf8U1PtnyRFb6vSESHwGBXVjyIkS6KBNKyneKNi4BjzBG7IbU5BNxsav4YZKAvNVZzF+ZR0U7yVGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P67b8rd1F3gkfaAJC9PFTkYlUCUQXdMbv6+TZ+EMAg8=;
 b=ePIbP1tz6H1zGvhtxI++vHmTdcqcMZ6nsj6+e/8oJ7rKP1aL9zkwh1MrSEy6PXLT2+edmC+YspBX8/ayO32+giMW2tVlKXc+4VsOIZpMA9YaODK6vkbPVvk6xGKvYHEXxsO0ArSG9VdS23HUhTbokdzU1fnZAWr2z2epyt8nRsUefjEEfxD3G9NXLnVB5x/fgmDr3dZwZYrn1Dk29w1VGOHYwcIvGxzZ1AHI5KPkqlWrEE/H6T6eWfmLNjFC/O6+H1/SlC5/hxG4xu1j1La5DFh0oT9zF89svAW0xy99FEtJo1h2F3KtMXEkySau9qf128lH6nlMAbsYEwfWtwrx0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB3664.namprd12.prod.outlook.com (2603:10b6:208:159::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:44:42 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:44:42 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 14/17] mlxsw: core_linecards: Implement line card activation process
Date:   Mon, 18 Apr 2022 09:42:38 +0300
Message-Id: <20220418064241.2925668-15-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
References: <20220418064241.2925668-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0504.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::23) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ab6479e-16e8-47d7-172c-08da2106eacb
X-MS-TrafficTypeDiagnostic: MN2PR12MB3664:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3664298CBC365408F76FBA1FB2F39@MN2PR12MB3664.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jtk6dcRuwWR3x2ScitixX83gSymTtl1W50LIQTFJ6ie/Q9qEnIb5HGoPWxguSNkev3aEHa/jcKzyG+uf0iJuilTjw5V/ok2w89FMQ1VriOVMJknMMFw3X1O0ute+5TKui+Da0pNxF+jDaW36jORcIcrr6uX4LGjcGbM/of0/HFs2JCM384CTR60WoaHhy6XwCLBwvvQMjZOgpe4soQ+ihTbnAS0aVWhojzTyKgMU0pBC8kAA4NlSWaXEKKoVCaxvDKS3BiXgye1xywVPIHuWuDIWdKpgIQNFFizV9En3HbT9h/2tpB5Pm7tttBwxs/8zh9oUhOqnicB2KJ/Klv/5RfKVsNkL4aHT6LqqtMzJcROAqrHZ5OZCQt785DNctclEHm86B9B7cs3lMNFOmQ/6B3yyKs2g2z6QbTapN5K35azeDT5fdTZa/e3IiQNIJC4Wb2ZZn+r9V71ozxI43A4P/JNd31jroHNLXRHCrp3zg7DXkXDMgnWTAt1ZjTp0BesMv/CvR9V/L76rKdwwsCxtzcA7d5m1gRxr7YfGVBEQBuaxXh0BrXRH86KXxCdTNu8NsYBNEB6GMtI2LtPeQiG+20wySc0g+3l1ewCb7z/fQ/ffOI3jRQamNfbVHnFtWg3wJY7/BydKwKJ79pIuyTtFqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(66556008)(316002)(4326008)(8676002)(508600001)(8936002)(6486002)(66476007)(5660300002)(6512007)(186003)(66946007)(38100700002)(86362001)(26005)(83380400001)(36756003)(2616005)(6666004)(2906002)(6916009)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c0B6iUTNPRacZ7QX0WMdHXVNj/KE3SP92OQZf1847B6yJ4uSvBekpHp16HRr?=
 =?us-ascii?Q?7ZWex92DDLXoXG6T2V+X9XEaMHD6Yh0WBaMh64ToM7IVRuUU/Z7KbqAUUnQX?=
 =?us-ascii?Q?N8u9fye5DXIjFxv3jaAWbbtvQMQaZHLUKlnkABDP/sK+NgY6Myi4C/BbKbDE?=
 =?us-ascii?Q?js+TI8bam/2VCdcjOH7WMB1VIaSAHmNNazTxzxRuQgmTbNuYsCi//xTvNmPd?=
 =?us-ascii?Q?RWKNsssoOSOgBYiUwP0cWtBpolEsJ/p3JfzDGhCjUALiKHMkDYjYZ9QvuCEf?=
 =?us-ascii?Q?53iJiE+HeEouPxIPdZxskHC1mYEHoK9/aKhGP8Sg2xIH9ybuVc5QcYvuOWl4?=
 =?us-ascii?Q?jiZ+sXMKdjB53DUq7o7eDwKTkDTGefWLobz+jmMXr2aLW3DBLPlv4tQGcimn?=
 =?us-ascii?Q?mBy75w0RRKN86dvyzhirx3p0kF4hkQ57KbSC4+PkFOpt5GTLxupkHjPaVHsp?=
 =?us-ascii?Q?2sOfvk3oWy1Lx6QQ1zcYFiBvbZ7s05k2YEvU0PqsJpjL2cuw+2FY3CU8QUuO?=
 =?us-ascii?Q?0nLENJyjnXuury1pK4JqSeTrvg2aboBkyz6yS/IOWZvq8boXt3k1fM3qV7LS?=
 =?us-ascii?Q?lq/SAP+eg1Vu6cid38gs8TSXNtwjTgPtE7vUTCAIS9kMFSReO8sOGEQHyLI5?=
 =?us-ascii?Q?UU6ohty1XlS+KyX+3EW2lyBZu3XeBJkF+CPaC1koL4UMTHHs2AaXAAHpx6Wz?=
 =?us-ascii?Q?/ndxwHmVHqVm52KkEgaELSOzSo75XK3aaKVt/1yMVhMMpO0PouzIiOUgGDCy?=
 =?us-ascii?Q?a3RezlvyO1q6LNAQctV0+Hz5In9jiaXmlFw0EB7vS7edls1fyxgrfwusv+lS?=
 =?us-ascii?Q?7BBDLIDt8v+JjzzWwMocT8UI+/3jf+fLjs7UMNZcCN3bnXo0/ys37+ptz7Cy?=
 =?us-ascii?Q?SgfQxH1pFoZ8/5SS8OIPWl4rhMKvuyvnJOA5VMBXITu7c2FkMM4HQIA5B5L1?=
 =?us-ascii?Q?U1dF2T1/xslKLQFPM5MySJ05ZzKx2RM7tz9C9yj+2dUwsO2/Rn+6N/cpxdzA?=
 =?us-ascii?Q?CmJ0dtJ1p5kOFiboSNWMdv9NII9xHHJURbgxoWnO8wn5YuiC/PLtuqhTo8Vt?=
 =?us-ascii?Q?V+wFKE01tRlmSbcyeaGOfdaNGgN+DrcKmXnJU7Fie1YyAUh/tZjO/JAxlEsD?=
 =?us-ascii?Q?NstquO49N3uxXYcBe3tV0e/dW9TBo561PqFrr6FSVdPXHFw3cHnOcSwDtAxM?=
 =?us-ascii?Q?6gmpu98kTQVbO/kntT1K6pxJeF6crdtLX4YIJiHdVAPgWzMmKoyIKV0LF0t5?=
 =?us-ascii?Q?Om5Mi6aEZBwybZXRw2VTjG+TK7kxMzTcE7Hhlo/ETqw+Bt8NQnfWPrCZI5cr?=
 =?us-ascii?Q?/6zx4c8bfdD0eQW3OMqSR8M8jhRLtj36xwG0r0L/CCeCklFmtRIOEbWvhmDV?=
 =?us-ascii?Q?FqKfQ6IkFyIDTvYAT288l9ULRucnjLPViXHFrs6sPFv9RkFfsOPZmETtnshV?=
 =?us-ascii?Q?s+q5lR87k/mU8xM/JOnJsptiBLmj/pz01r0BNcJzK+ZcGbYoZvQWrXx6qdV9?=
 =?us-ascii?Q?51C8ACfvWfPbJaozMgFGRKhUJnNCA5FoQ8IcrL9FMFZDuAYgR8RHkUXrp/Lg?=
 =?us-ascii?Q?VjkJaiihJlVHM3N8G07CYdV7thxG+XNtVBakO4K9ViQRTpr0yP0QFNVLKnXi?=
 =?us-ascii?Q?wigUlRAOVRUSUFjh7IChvCobHhC8pvjIjuhSeCCyGb+GiJAC1MPdijh2pHNo?=
 =?us-ascii?Q?D1gjYZsh5H8upb/CpSW/R8xwb3illd7tL9WXnUWizNuct/kCVSG/wdjxVnRg?=
 =?us-ascii?Q?qyDmKbh7Tw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ab6479e-16e8-47d7-172c-08da2106eacb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:44:42.0801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AxUKGuzHnvLGUgdSGowZC2tIad/nLx/g7z9/cxldESRPHELJcZsRPPS0b0z7aE92xQO7jcSZfOXd/1vIaKgdkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3664
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Allow to process events generated upon line card getting "ready" and
"active".

When DSDSC event with "ready" bit set is delivered, that means the
line card is powered up. Use MDDC register to push the line card to
active state. Once FW is done with that, the DSDSC event with "active"
bit set is delivered.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  4 +-
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 63 +++++++++++++++++++
 2 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 44c8a7888985..7d6f8f3bcd93 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -564,7 +564,9 @@ struct mlxsw_linecard {
 	char mbct_pl[MLXSW_REG_MBCT_LEN]; /* Too big for stack */
 	enum mlxsw_linecard_status_event_type status_event_type_to;
 	struct delayed_work status_event_to_dw;
-	u8 provisioned:1;
+	u8 provisioned:1,
+	   ready:1,
+	   active:1;
 	u16 hw_revision;
 	u16 ini_version;
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index 1401f6d34635..49dfec14da75 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -90,6 +90,8 @@ static const char *mlxsw_linecard_type_name(struct mlxsw_linecard *linecard)
 static void mlxsw_linecard_provision_fail(struct mlxsw_linecard *linecard)
 {
 	linecard->provisioned = false;
+	linecard->ready = false;
+	linecard->active = false;
 	devlink_linecard_provision_fail(linecard->devlink_linecard);
 }
 
@@ -131,6 +133,46 @@ static void mlxsw_linecard_provision_clear(struct mlxsw_linecard *linecard)
 	devlink_linecard_provision_clear(linecard->devlink_linecard);
 }
 
+static int mlxsw_linecard_ready_set(struct mlxsw_linecard *linecard)
+{
+	struct mlxsw_core *mlxsw_core = linecard->linecards->mlxsw_core;
+	char mddc_pl[MLXSW_REG_MDDC_LEN];
+	int err;
+
+	mlxsw_reg_mddc_pack(mddc_pl, linecard->slot_index, false, true);
+	err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(mddc), mddc_pl);
+	if (err)
+		return err;
+	linecard->ready = true;
+	return 0;
+}
+
+static int mlxsw_linecard_ready_clear(struct mlxsw_linecard *linecard)
+{
+	struct mlxsw_core *mlxsw_core = linecard->linecards->mlxsw_core;
+	char mddc_pl[MLXSW_REG_MDDC_LEN];
+	int err;
+
+	mlxsw_reg_mddc_pack(mddc_pl, linecard->slot_index, false, false);
+	err = mlxsw_reg_write(mlxsw_core, MLXSW_REG(mddc), mddc_pl);
+	if (err)
+		return err;
+	linecard->ready = false;
+	return 0;
+}
+
+static void mlxsw_linecard_active_set(struct mlxsw_linecard *linecard)
+{
+	linecard->active = true;
+	devlink_linecard_activate(linecard->devlink_linecard);
+}
+
+static void mlxsw_linecard_active_clear(struct mlxsw_linecard *linecard)
+{
+	linecard->active = false;
+	devlink_linecard_deactivate(linecard->devlink_linecard);
+}
+
 static int mlxsw_linecard_status_process(struct mlxsw_linecards *linecards,
 					 struct mlxsw_linecard *linecard,
 					 const char *mddq_pl)
@@ -164,6 +206,25 @@ static int mlxsw_linecard_status_process(struct mlxsw_linecards *linecards,
 			goto out;
 	}
 
+	if (ready == MLXSW_REG_MDDQ_SLOT_INFO_READY_READY && !linecard->ready) {
+		err = mlxsw_linecard_ready_set(linecard);
+		if (err)
+			goto out;
+	}
+
+	if (active && linecard->active != active)
+		mlxsw_linecard_active_set(linecard);
+
+	if (!active && linecard->active != active)
+		mlxsw_linecard_active_clear(linecard);
+
+	if (ready != MLXSW_REG_MDDQ_SLOT_INFO_READY_READY &&
+	    linecard->ready) {
+		err = mlxsw_linecard_ready_clear(linecard);
+		if (err)
+			goto out;
+	}
+
 	if (!provisioned && linecard->provisioned != provisioned)
 		mlxsw_linecard_provision_clear(linecard);
 
@@ -676,6 +737,8 @@ static void mlxsw_linecard_fini(struct mlxsw_core *mlxsw_core,
 	cancel_delayed_work_sync(&linecard->status_event_to_dw);
 	/* Make sure all scheduled events are processed */
 	mlxsw_core_flush_owq();
+	if (linecard->active)
+		mlxsw_linecard_active_clear(linecard);
 	devlink_linecard_destroy(linecard->devlink_linecard);
 	mutex_destroy(&linecard->lock);
 }
-- 
2.33.1

