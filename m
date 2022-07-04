Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B140564D93
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 08:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbiGDGN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 02:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbiGDGN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 02:13:57 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2082.outbound.protection.outlook.com [40.107.101.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D1F6261
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 23:13:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFWXGLj54UAAwiPfQhDhEdEP95Ena8NLBuYnz6/rBVMCsFhZXKE+mPe5J7PYaQVzSH5gf8kKWkqtOZm3Orv8lvAcxvcybnVAbF4ac30Y39pv5NBK3cMP84H4LQfG68gIUuVRs43o0CbSXtQDQ6a0eSsFerMbThPMhKYfs7RipRZKEAiB5Tl+SJg4XANNgnRVJ3SR6j6UnaLILvb1iX7cRnlSfQR1d+7C9LVpN5uBOjfP6HUTl5A08pw5hCdAwthjK1G1WCQAoIxwM2xL7eMOhG+rMZJ80pZillL06QywplFAGtOEyfFdYfXBr9Jh4BmYdOG2reN/ESiL8O7Yjdb6Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pAY9bdJrKQVa9FYFtogwrVTSIUhBUBzO15JNbcf5CuY=;
 b=bT3lmF2nURBrSGDcCe4IfVH3wrP8v36i7TAtJYhR8dj8DpjDBTMF3TKVEiohVX0p02j1LEVHKct+Q6DdwQBwj2SMSvYKhronD4ZkYCF5I4OLPgoTX0i2e5muhLbjPfF4Ek8pZnb2zHUyJ7TNxmLXwMF3YvJ9XE3ftFSjwi7Az/T/2g4bKO5BHcGpCxFm11R+q0/WMhioEO2dP3sTU4cSWz/WFuc3rg3IlRPVwyh5fNtk4Q0N8Cl9YEKx7l30L/C3uWPZKSnUpZCyoOgcuVN6OlnXCsiGwqJycgxZdXmksY4xwz3BJFdgFRJ8HRPrSKQfsrEOd2qUoKEJ16mBblhKkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pAY9bdJrKQVa9FYFtogwrVTSIUhBUBzO15JNbcf5CuY=;
 b=L6zTiJz8COMAr2SEZbrrpBRhDn3gIdX79NST8hB13g/rrhoqqwy0GvYzCiixiui2BV69eJDuvFwr3FdRlshOez9GBKsl4AOqXF1Lr6hD1SLQkaMuRuY9AK+MEA2+uW1cWw9CS3KgXgpCLTWdF7sb/DfruIoOzBWFNmNxVj2AsGJaCkNs0QWXDXqA1RY4aMNixgZimXm2i6cw02qzIix3LadPKZc7QbyCaE292eaYDxjCrttLZatpyzHQrV66pTSwCNKAaV/PhHORJReyZ5lajMhl9pW887hGMC4fScKOAGiYcZxdn0pColM92w7wytiDvzYJ5YW5MkBRGv5Nk95ceQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY4PR12MB1862.namprd12.prod.outlook.com (2603:10b6:903:121::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.19; Mon, 4 Jul
 2022 06:13:53 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 06:13:53 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 10/13] mlxsw: Add ubridge to config profile
Date:   Mon,  4 Jul 2022 09:11:36 +0300
Message-Id: <20220704061139.1208770-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704061139.1208770-1-idosch@nvidia.com>
References: <20220704061139.1208770-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0502CA0018.eurprd05.prod.outlook.com
 (2603:10a6:803:1::31) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 153c2177-28aa-4c0f-f9c0-08da5d845eb4
X-MS-TrafficTypeDiagnostic: CY4PR12MB1862:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A+ExuJVigmd9VwLkrKpcwsFAbzx3CAxOU91SnuXscHLrAStFLFxvnzLCkkjEo3AUTesqC7/y3eOhUZ/Ue3ptcmvh+7Xqm7dUVgZSgNP4bwifVuKFEtkRD0MUbsetOT8Uwv0uaAAkfF6W1+E6IKCah0CDegkoc3tX7lek+mCw6HI1Gj/0TDeJAx0xItkg1eG3DCp8BEZx8TiYUCx+i9iCLyN6NVA+4WmdWzh+C9kS+XJcCA1KZOpEBTAs5Rq75h2j/Zv6rSLC4J3Xv/xdkCDRz2WIyCS//nmTTvMIoMQqQeRaRAryvX3YxLnxht13HtSWyq6Jn9HluTB+SCCMZfN2GxfEOMLvinZ7P8RuZyRoEp//bpBV1CkxzBzdlPs7INeKPSemwsfELR8hBzJ9sRkp8wT2eZz6BOinAUw+DKjDdar42UefAluRyZYN5BkeD98y5vHFIHzgibGbZMsZrUp0SfNLCSJGKyByqJSQ5Q3OoH5+p60nYm7n/IDhzGEbQYidT1DsaMAvBIupulzbTTWmcpd/U3oOC7zjac9+BJtawyDD+62q2e9mLa/7LxHA2PECjesrkurS6Q90jws+BJargGtJgVShmTl3/pluBGua+S7m1z00LigC2Cj2wPLsuSd775L5ZrBDmmXjKs+N4qRK8R5xQcmxhrbwC1kZUBnX2+g7oF5tJwuw6U9gcN63kERlY3Mp59hTWyajxfFOsrm6h4IWCGpqzJ6EHqIoSy7v4gZ9193FSrSovz6mr/iEc6nCheBlhcGcuJ1XeTF0BAOppg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(2616005)(38100700002)(66946007)(4326008)(8676002)(66476007)(66556008)(478600001)(6486002)(316002)(6916009)(26005)(6512007)(86362001)(41300700001)(6506007)(6666004)(8936002)(83380400001)(36756003)(2906002)(5660300002)(1076003)(107886003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EXteTBYhMcpo45IEEYBS5c5JS4OPdK+SN+wrqiJkHdF1YnjAGFQnOpvqxYJ3?=
 =?us-ascii?Q?RvGR8X3XoHCvee9uNXaNeCYMSgv5pYTlFE9Zuo9SvMNSXGlslGu5Q/tK3HiF?=
 =?us-ascii?Q?ZmU7kTP1lTqVJuirI0Z4S2lVORm6Z5bmY4VqxzVmFxK8+E3aPtu4CQkAuGXX?=
 =?us-ascii?Q?6Mbvhl6Rv4JeAOTD295ypWOY8Vp7kha1f+Mwk/plX3RuMmrGU0zLRfxXi0Rn?=
 =?us-ascii?Q?+CoEbDGeavhw7D2lTvHFGkpRz7C1U4VzjMvLNFBnXcLdEfUXxOB4IZDXdLtQ?=
 =?us-ascii?Q?yAN6f9Hy49bzDbXg4syn+m+pMlSgENaqntc4H7Av6yzfT9P9ekOwMfXD5Dq3?=
 =?us-ascii?Q?q07+PwT3uRBIZgMK2z3u0wEe1fFMfRzlsIoc6BpmFhdD+TZbTgT0DZvCSlyR?=
 =?us-ascii?Q?s1m+aONTFsoTNCz1XII5J9GpZm4hcDxv3aDs0njekjJsmg3zrpxfgerz4mWp?=
 =?us-ascii?Q?alYiOKPpAaPVWVIFXo8a0SAALa1N6ezD5nCc8OyvAUArEfIjZ3p79hOmRfxY?=
 =?us-ascii?Q?uaMCae/kCktVi0dusZqLzfKUWP9ZJbQeBBNpJk/oRn/h4qM0Dh7/6i/4KTeB?=
 =?us-ascii?Q?dgxWBwd1AYbwrkdYULpqcL05XiU92B9Q1MSOIAvb6ezB7Z/oO+HUSmC3RX0D?=
 =?us-ascii?Q?xRvyjUMRUmlxyhdoloIWgu02PDy4HC+C8taDU/Jh9/F64Ff86FcdDEK/hKka?=
 =?us-ascii?Q?oRepPIEM8VpfjSPDM4GUwCDf/NaE/vC2OyDVtUqx+cIIFXmXb3siwul5G+uy?=
 =?us-ascii?Q?ksz/kbRwz5hh2+MI1Gqn/xKJ664oxfqxnLkEFr88iN17JZAZRkaia+5EZHgH?=
 =?us-ascii?Q?Zp9tWf4rEyFWxYbm3UiORWgBRtBCgJ/APY6M/4F27rzpo1IaKoRXiZttXEqh?=
 =?us-ascii?Q?nAX+d3uAFxrsT0fTkZFSMyDV6CUly9MV5V/fEnklKrcIPmKvF+MBbdyQUCeZ?=
 =?us-ascii?Q?V8CQ66LBOVSfLMR7EmqL2mYDxFabpmsgdZZZoIR8/m5hFPi4tdz99h2yrrFo?=
 =?us-ascii?Q?vutmvIs4/65Um+v0k7tNocG6XOTPYLuz0ZaTFlbvY4+lcXX4klI2tWtLA2p9?=
 =?us-ascii?Q?HmLA4orjsHW1gwYuNOXBhOG9YuYyes9xOV8pDuJWQBEpiUSnVnlClpDEl9vZ?=
 =?us-ascii?Q?dpL395hFfntr3gVTFLQekIL+hnjuNefbsa/s9HDDCl1nLiYXskSPDYpmCOsl?=
 =?us-ascii?Q?egYEUmqC+2O0Lml05ldxwzKoDi6KJd+J/waewIOCXjsvXJ8zNL8qLLaM3k8v?=
 =?us-ascii?Q?KuIn+br6HOFUIeOq7po/438MxjfRmjJSQnPyEH0u4krfqeO1TEQoCZ5Y7J0R?=
 =?us-ascii?Q?pLtDUBK/2/vx3gVNIZjH+C9MidRvQoU2swSfTe7Ebxi3RDKtY5evit53WiHY?=
 =?us-ascii?Q?MbPHhwuX00tZJBSF8bqdCHSaPCzwP2PeZCJhp4d2q4lHQGQ3j70DrUq4VzIV?=
 =?us-ascii?Q?Cr13JSqV2CIf5rSREe1TdNxBYVSv46z8GtnyQc2xL3AqRjEdzBjkFiQEpyiT?=
 =?us-ascii?Q?oKIOj4VsHT51PTVakKbYq3/qMbU/s1qXlBdeNXqx+4yJnJguzM1N07JC5c/C?=
 =?us-ascii?Q?HXN07xG0mYiM6c+XfrqTSUAB0sRREENZqIRLR6Jk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 153c2177-28aa-4c0f-f9c0-08da5d845eb4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 06:13:53.3269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 28+VD81Nc8lA09ZqQPxu68ekDDKR5aXnTApccDV+hzNcjLzCRHphk4UyJEH6LhLY/u/7yQuvyakcWfs6MfxtZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1862
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The unified bridge model is enabled via the CONFIG_PROFILE command
during driver initialization. Add the definition of the relevant fields
to the command's payload in preparation for unified bridge enablement.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/cmd.h  | 13 +++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h |  2 ++
 drivers/net/ethernet/mellanox/mlxsw/pci.c  |  5 +++++
 3 files changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/cmd.h b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
index 8a89c2773294..666d6b6e4dbf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/cmd.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
@@ -633,6 +633,12 @@ MLXSW_ITEM32(cmd_mbox, config_profile,
  */
 MLXSW_ITEM32(cmd_mbox, config_profile, set_ar_sec, 0x0C, 15, 1);
 
+/* cmd_mbox_config_set_ubridge
+ * Capability bit. Setting a bit to 1 configures the profile
+ * according to the mailbox contents.
+ */
+MLXSW_ITEM32(cmd_mbox, config_profile, set_ubridge, 0x0C, 22, 1);
+
 /* cmd_mbox_config_set_kvd_linear_size
  * Capability bit. Setting a bit to 1 configures the profile
  * according to the mailbox contents.
@@ -792,6 +798,13 @@ MLXSW_ITEM32(cmd_mbox, config_profile, adaptive_routing_group_cap, 0x4C, 0, 16);
  */
 MLXSW_ITEM32(cmd_mbox, config_profile, arn, 0x50, 31, 1);
 
+/* cmd_mbox_config_profile_ubridge
+ * Unified Bridge
+ * 0 - non unified bridge
+ * 1 - unified bridge
+ */
+MLXSW_ITEM32(cmd_mbox, config_profile, ubridge, 0x50, 4, 1);
+
 /* cmd_mbox_config_kvd_linear_size
  * KVD Linear Size
  * Valid for Spectrum only
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index d1e8b8b8d0c1..a3491ef2aa7e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -295,6 +295,7 @@ struct mlxsw_config_profile {
 		used_max_pkey:1,
 		used_ar_sec:1,
 		used_adaptive_routing_group_cap:1,
+		used_ubridge:1,
 		used_kvd_sizes:1;
 	u8	max_vepa_channels;
 	u16	max_mid;
@@ -314,6 +315,7 @@ struct mlxsw_config_profile {
 	u8	ar_sec;
 	u16	adaptive_routing_group_cap;
 	u8	arn;
+	u8	ubridge;
 	u32	kvd_linear_size;
 	u8	kvd_hash_single_parts;
 	u8	kvd_hash_double_parts;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 4687dabaaf09..41f0f68bc911 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1235,6 +1235,11 @@ static int mlxsw_pci_config_profile(struct mlxsw_pci *mlxsw_pci, char *mbox,
 		mlxsw_cmd_mbox_config_profile_adaptive_routing_group_cap_set(
 			mbox, profile->adaptive_routing_group_cap);
 	}
+	if (profile->used_ubridge) {
+		mlxsw_cmd_mbox_config_profile_set_ubridge_set(mbox, 1);
+		mlxsw_cmd_mbox_config_profile_ubridge_set(mbox,
+							  profile->ubridge);
+	}
 	if (profile->used_kvd_sizes && MLXSW_RES_VALID(res, KVD_SIZE)) {
 		err = mlxsw_pci_profile_get_kvd_sizes(mlxsw_pci, profile, res);
 		if (err)
-- 
2.36.1

