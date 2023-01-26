Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89F667D133
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbjAZQWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbjAZQWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:22:16 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2069.outbound.protection.outlook.com [40.107.100.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E0E3432E
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:22:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=adSXjKXhI4H6NzwPerOqLbR4zLKIehIZCTzH6sNZ2xwu4vcvwbkulro6D8zdDtI/qjbVvBXsse1f6p7NY0FmwN2dMtsmdQFnb+6JvLdrx2fWEmyqBCTPhGz1gTCKBBhecTVEy0lqHAzWhsatI8aQqzfI5puCc62m9YQpo6BSWLx8JDGlfSJK8/rIsnlh0SfBLxCN3BgZNiXL9ev72CzOz6C+AU3XOgcZDhpruukDPIADnYsJrIF32EK7pYmVH+1y6cSQE/Y2jOryuIOnomQKgLErj04LqkATwWYHg6QcL9quvOYygcV+rXbHRgwrbsdL0FHHpULCvIDS27Zq71K9og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9V9HCsy8GS8zPQwPGtLyqFy+v2pfwrjvnaqP6WKT9i0=;
 b=UpQ6ILxS6e2vgS9NF3AMDje9HzcNs51YFs3VFyxF2mvqAFRojnc/tOvpGV1Ib+4IhMXllHmUgJrZLdYPmyU5UveXwYHeIyDMliF9Fxq2VdYTxc5dsJEzOD1BnTYCQqw4gB7Cw0TRCl0jwO2+vlgyqrAbZcACgHMlY7viBetHavWnxci9t+MQC92PPY5TGMRrJZT7RPf8kATz6XCJ5KliyL+3pUMIDX+5a0oqxK+VHcMt6S7uSXkrc3j/ZuOdS79AM7HC0jiYn9Grl+gQbBhcOw2oiZIfRxX87HWrTMezzX3cOqr5c1ZY8C8yix5QKYkyf3ZvgVLPdCZZ4ok1zRkERg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9V9HCsy8GS8zPQwPGtLyqFy+v2pfwrjvnaqP6WKT9i0=;
 b=swe0XkdsBFuQoYZbGtpmgSiuR2QqdkU8AZu3kzvcmXBGrNM0wXQkvAClbNcEjQhmutHw/Wa1Bjk2Lj92FeoeYxM9e48G2ELfxj5TnIOKxD/iE2jnUw1V9UdaC5iBH/8H5zj3rRXM/RZ4K87E35uK1lp57MZhYEXeUosnpy9lPLsKeXHpf+DQC2bnn5jo73Fj2qJ+RDzxvpqul/0PuO816qX7+QlWU8nnYwK2Wb+eUwM1HGlRQyebhdss4+81tmdoJMHczkkwc/LQdc8tX4SAeRa2ntAInKO/Lwp5pbXoK3iFNDDI9UR65mtsYOY3ieApeM9thjvNSmshaodovLLYfg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by SJ0PR12MB5422.namprd12.prod.outlook.com (2603:10b6:a03:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 16:22:05 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:22:05 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 03/25] net/ethtool: add ULP_DDP_{GET,SET} operations for caps and stats
Date:   Thu, 26 Jan 2023 18:21:14 +0200
Message-Id: <20230126162136.13003-4-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0279.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::18) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|SJ0PR12MB5422:EE_
X-MS-Office365-Filtering-Correlation-Id: cb6a6d1d-9e16-4c48-6275-08daffb9769b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EF1djKwji1+8zH90qjAkMHd5oqzxgfcPFTgwKcPX7zmq3Le4KPCUUAUB/HVT6Jz3b3MqZ7BNr2mKUGuSSh3YtOAN4RmEFrwOGzj4A7wRuUGrMID33H/86V/oI/hic3N/JgkM8HTAY4fdQjSGJG1079hfxgxhSpWGjVjrtgwohAF5r9gC+kS21aWhxV9MTJPFR8CImUW+dzLWjaxr3trTqnQUDQnJFdR6OyhhDeONLNZWOv4mqKX0+MvG0i+EoeGA36kdWcjv1bKD37CQrzaXPH5SSnr9BVyfRdLXc+PcNa7FJUmQCsqDcmz7QdGjdbRGzEMtqbmg1eVudfkQazmQofg40164JIM/K91VZ4h0IfAIbj4uNtMScdQiezI+GVG4HlHTdCRpTmU9EaKZ9Vzyrb86gcJy9DrORY51+AmUvb/hhg/w/ECQTDbTVaYUhD2W2PIs7ESsgwku+dS+yHNkcUfFpcT+zg6I5o12acNYFgPfL/j6LYrwXWuGO2j1DgiIl/SRv17pDFnTx7v27KM5FP5oobrW6c+/teXqY6/jWap1y0ONc4IShgvlXg+58D7UQZYaWmYu17+w03UEYo4aGbM6K/TlrWH+8k82+dFPEOR/FXbR3PFjIH7qv27j9Ap+mlKCPjHDR2ykop1I7E2Ing==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(451199018)(316002)(38100700002)(41300700001)(8676002)(66556008)(66946007)(66476007)(4326008)(5660300002)(30864003)(7416002)(36756003)(86362001)(8936002)(2906002)(6506007)(1076003)(26005)(6512007)(186003)(478600001)(6486002)(83380400001)(6666004)(107886003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ag8i3PtBhbM3x3mc4TnGjsSGc3V8Qn9zI0ciGCNHSe85ZcmVQiK3SZ7GNHv8?=
 =?us-ascii?Q?AKz2XNiDyy4EjzseydfdIvEwYTROtwSlWUpLBFogXpk7e1lsyExYDs2sElTM?=
 =?us-ascii?Q?vQxq4hsbYbgnvuVrq7gsEwM6++pjAxgA973A6GiSw+Ycj7XyS8tcBNq07J7G?=
 =?us-ascii?Q?rTPwEWdzOKwZf0qKpXzI2EzayRzlw4SRFXijojpc6JJhZwsvkJYAr4CTRhyr?=
 =?us-ascii?Q?C+9gRQKLxHQzw+COXkP53EL8tZAdPVfjjTdU19YSc1wS69tDuwt6S+B8Gwl+?=
 =?us-ascii?Q?E9KGCEPi+CgFDkNz23Z7p0vJx2yPgdisBL8jqYGsLwBKZ888U2xvYOl36K0z?=
 =?us-ascii?Q?sHb9immy20cPpAPG455zDIKkkV+jSyYoAYCoMxB0je/odlMS5Ia9od3xe6Yr?=
 =?us-ascii?Q?JNB6Lnnr6tXQZ/1Ug5/FDO+PT+6msC6qPbi6Co9jLkePnwpMmrZ4vy7SbffE?=
 =?us-ascii?Q?ZJIk6qL/uVs2mgq2jhDH+6QFe5yqWHgIwCjPjeN3aXxMbTVzQjKDhpuPdtg7?=
 =?us-ascii?Q?y1nUjLKV4ygXbSVHisY4CE/1gA6cWYX4Y07r9/wRUO1GNx7KW8vHJx3LsJQl?=
 =?us-ascii?Q?eIOuDx7ihQlzXLEWtQMqIHTl9QkbPfzXGwEIGtpoSA3xnofBe7mquJkWBWWd?=
 =?us-ascii?Q?F0gUKb8SK3/IyLvc2M1S/h0ypAUNmm1xHL8Z/BAPArSvTHRo7oNZBYo0C3Jw?=
 =?us-ascii?Q?wzltVaPwOzCaPbw6yEs8cR4S+/aEXSwefTujUBSwFEwxFKdhjDWokqTwpLJG?=
 =?us-ascii?Q?fNHJqQGS2vC/qxDFIerS3xll3R+0Qpgq9NSOsaYVVH1b9eMGbSXV1ojQ/+KM?=
 =?us-ascii?Q?a6djXfuhxU08DT1MlN0PQqrNuR7ESoQ8afeSk398nprm2JgRCiMNjs+mdT+q?=
 =?us-ascii?Q?L8GcDOXVlkxpZG5Ldc5ZXGIZ4AFXKziFG22AG/8do6MNUQ1GCNUMSWi2Dbqs?=
 =?us-ascii?Q?L6cUxca5q+IWJ/baH88TdK0eNhYBbQCRzyUmcRnMBKMaYjkkSr9JGXOUFzxf?=
 =?us-ascii?Q?gzLS9Up9wkCc2p29x0IiavdJzl8XCCwsHjghmGyDcpl6Jdtr0ojh1ZYU51av?=
 =?us-ascii?Q?mG34OVcPAVtd3CE+U9mXHoEuPsPvqCcMRz45uUqq4hlhX0XWO5KHU+C0WFSs?=
 =?us-ascii?Q?2ENQoUz2vdsf33CIoTgx9CoT4vC2s4DpCjObjiyLVyJmsl2RCumzoRfoxkR1?=
 =?us-ascii?Q?/5pHlkOUip9Igs5PAFDC2OoaXKoVdSmyiHGgqZRe9XnkeQpMepB3dcapWi+s?=
 =?us-ascii?Q?/AgByHh1bNtP+hrL1JEGPVt5tHjgeSB3FWBhQz8eOb2KhfXhpNOWo4FFvZvi?=
 =?us-ascii?Q?1hlPppN13u7AIVwNa8cAH0EFdvu1TlbesaAy6nHBDp/So9zK4TpMbkgIKGrQ?=
 =?us-ascii?Q?bmT8E3fO6YbIN7WZN+fUjz8TKiyMqlaHT7K0iPgCPrMDwjQYna5QS5E9bRiB?=
 =?us-ascii?Q?Kg/apWCDJdeGI0jaD1npZiB6lov5yX354ANuiPQ9jU7qyRbNvtRW+NO1Nua6?=
 =?us-ascii?Q?dsfe1TW1cS9ZqT5v5QLlM4rcvmGKlMFAmpIdz6Ii58WQh/RAaYQ4m0hhGtSK?=
 =?us-ascii?Q?Bs9NOG2E7orqCMurVBMfXlDG9Uw8ASsD7k9P5gT5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb6a6d1d-9e16-4c48-6275-08daffb9769b
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:22:05.1992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ye71iLjsLDGhEofNw0xTz0i2IYw4erQC860G6FheZr/0CsFQdOzKZeFrqAIL/KCxZRIbnFHI1F8gIYpCOIIZpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5422
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds:

- 2 new netlink messages:
  * ULP_DDP_GET: returns a bitset of supported and active capabilities
  * ULP_DDP_SET: tries to activate requested bitset and returns results

ULP DDP capabilities handling is similar to netdev features
handling.

If a ULP_DDP_GET message has requested statistics via the
ETHTOOL_FLAG_STATS header flag, then statistics are returned to
userspace.

  ULP_DDP_GET request: (header only)
  ULP_DDP_GET reply:

      HW             (bitset)
      ACTIVE         (bitset)
      STATS          (nest, optional)
          STATS_xxxx (u64)
          ....

  ULP_DDP_SET request:
      WANTED         (bitset)
  ULP_DDP_SET reply:
      WANTED         (bitset)
      ACTIVE         (bitset)

Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 include/uapi/linux/ethtool_netlink.h |  17 ++
 net/ethtool/Makefile                 |   2 +-
 net/ethtool/netlink.c                |  17 ++
 net/ethtool/netlink.h                |   4 +
 net/ethtool/ulp_ddp.c                | 334 +++++++++++++++++++++++++++
 5 files changed, 373 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/ulp_ddp.c

diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 14a1858fd106..35805d8d12a3 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -57,6 +57,8 @@ enum {
 	ETHTOOL_MSG_PLCA_GET_STATUS,
 	ETHTOOL_MSG_MM_GET,
 	ETHTOOL_MSG_MM_SET,
+	ETHTOOL_MSG_ULP_DDP_GET,
+	ETHTOOL_MSG_ULP_DDP_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -109,6 +111,8 @@ enum {
 	ETHTOOL_MSG_PLCA_NTF,
 	ETHTOOL_MSG_MM_GET_REPLY,
 	ETHTOOL_MSG_MM_NTF,
+	ETHTOOL_MSG_ULP_DDP_GET_REPLY,
+	ETHTOOL_MSG_ULP_DDP_SET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -974,6 +978,19 @@ enum {
 
 /* ULP DDP */
 
+enum {
+	ETHTOOL_A_ULP_DDP_UNSPEC,
+	ETHTOOL_A_ULP_DDP_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_ULP_DDP_HW,				/* bitset */
+	ETHTOOL_A_ULP_DDP_ACTIVE,			/* bitset */
+	ETHTOOL_A_ULP_DDP_WANTED,			/* bitset */
+	ETHTOOL_A_ULP_DDP_STATS,			/* nest - _A_ULP_DDP_STATS_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_ULP_DDP_CNT,
+	ETHTOOL_A_ULP_DDP_MAX = __ETHTOOL_A_ULP_DDP_CNT - 1
+};
+
 enum {
 	ETHTOOL_A_ULP_DDP_STATS_UNSPEC,
 	ETHTOOL_A_ULP_DDP_STATS_RX_NVMEOTCP_SK_ADD,
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 504f954a1b28..a2fdc5ed7655 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -8,4 +8,4 @@ ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o rss.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
 		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o mm.o \
-		   module.o pse-pd.o plca.o mm.o
+		   module.o pse-pd.o plca.o ulp_ddp.o
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 6412c4dc663d..7fe126abb72e 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -291,6 +291,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_PLCA_GET_CFG]	= &ethnl_plca_cfg_request_ops,
 	[ETHTOOL_MSG_PLCA_GET_STATUS]	= &ethnl_plca_status_request_ops,
 	[ETHTOOL_MSG_MM_GET]		= &ethnl_mm_request_ops,
+	[ETHTOOL_MSG_ULP_DDP_GET]	= &ethnl_ulp_ddp_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -1095,6 +1096,22 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_mm_set_policy,
 		.maxattr = ARRAY_SIZE(ethnl_mm_set_policy) - 1,
 	},
+	{
+		.cmd    = ETHTOOL_MSG_ULP_DDP_GET,
+		.doit   = ethnl_default_doit,
+		.start  = ethnl_default_start,
+		.dumpit = ethnl_default_dumpit,
+		.done   = ethnl_default_done,
+		.policy = ethnl_ulp_ddp_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_ulp_ddp_get_policy) - 1,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_ULP_DDP_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_ulp_ddp,
+		.policy = ethnl_ulp_ddp_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_ulp_ddp_set_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index b01f7cd542c4..68db2e073c4b 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -376,6 +376,7 @@ extern const struct ethnl_request_ops ethnl_rss_request_ops;
 extern const struct ethnl_request_ops ethnl_plca_cfg_request_ops;
 extern const struct ethnl_request_ops ethnl_plca_status_request_ops;
 extern const struct ethnl_request_ops ethnl_mm_request_ops;
+extern const struct ethnl_request_ops ethnl_ulp_ddp_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -422,6 +423,8 @@ extern const struct nla_policy ethnl_plca_set_cfg_policy[ETHTOOL_A_PLCA_MAX + 1]
 extern const struct nla_policy ethnl_plca_get_status_policy[ETHTOOL_A_PLCA_HEADER + 1];
 extern const struct nla_policy ethnl_mm_get_policy[ETHTOOL_A_MM_HEADER + 1];
 extern const struct nla_policy ethnl_mm_set_policy[ETHTOOL_A_MM_MAX + 1];
+extern const struct nla_policy ethnl_ulp_ddp_get_policy[ETHTOOL_A_ULP_DDP_HEADER + 1];
+extern const struct nla_policy ethnl_ulp_ddp_set_policy[ETHTOOL_A_ULP_DDP_WANTED + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
@@ -444,6 +447,7 @@ int ethnl_set_module(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_pse(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_mm(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_ulp_ddp(struct sk_buff *skb, struct genl_info *info);
 
 extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
diff --git a/net/ethtool/ulp_ddp.c b/net/ethtool/ulp_ddp.c
new file mode 100644
index 000000000000..de20e9cfb24f
--- /dev/null
+++ b/net/ethtool/ulp_ddp.c
@@ -0,0 +1,334 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *
+ * ulp_ddp.c
+ *     Author: Aurelien Aptel <aaptel@nvidia.com>
+ *     Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES.  All rights reserved.
+ */
+
+#include "netlink.h"
+#include "common.h"
+#include "bitset.h"
+#include <net/ulp_ddp.h>
+
+static struct ulp_ddp_netdev_caps *netdev_ulp_ddp_caps(struct net_device *dev)
+{
+#ifdef CONFIG_ULP_DDP
+	return &dev->ulp_ddp_caps;
+#else
+	return NULL;
+#endif
+}
+
+static const struct ulp_ddp_dev_ops *netdev_ulp_ddp_ops(struct net_device *dev)
+{
+#ifdef CONFIG_ULP_DDP
+	return dev->netdev_ops->ulp_ddp_ops;
+#else
+	return NULL;
+#endif
+}
+
+/* ULP_DDP_GET */
+
+struct ulp_ddp_req_info {
+	struct ethnl_req_info	base;
+};
+
+struct ulp_ddp_reply_data {
+	struct ethnl_reply_data	base;
+	DECLARE_BITMAP(hw, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(active, ULP_DDP_C_COUNT);
+	struct ethtool_ulp_ddp_stats stats;
+};
+
+#define ULP_DDP_REPDATA(__reply_base) \
+	container_of(__reply_base, struct ulp_ddp_reply_data, base)
+
+const struct nla_policy ethnl_ulp_ddp_get_policy[] = {
+	[ETHTOOL_A_ULP_DDP_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy_stats),
+};
+
+static int ulp_ddp_stats64_size(unsigned int count)
+{
+	unsigned int len = 0;
+	unsigned int i;
+
+	for (i = 0; i < count; i++)
+		len += nla_total_size(sizeof(u64));
+
+	/* outermost nest */
+	return nla_total_size(len);
+}
+
+static int ulp_ddp_put_stats64(struct sk_buff *skb, int attrtype, const u64 *val,
+			       unsigned int count)
+{
+	struct nlattr *nest;
+	unsigned int i;
+
+	nest = nla_nest_start(skb, attrtype);
+	if (!nest)
+		return -EMSGSIZE;
+
+	/* skip attribute 0 (unspec) */
+	for (i = 0 ; i < count; i++)
+		if (nla_put_64bit(skb, i+1, sizeof(u64), &val[i], 0))
+			goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static int ulp_ddp_prepare_data(const struct ethnl_req_info *req_base,
+				struct ethnl_reply_data *reply_base,
+				struct genl_info *info)
+{
+	const struct ulp_ddp_dev_ops *ops = netdev_ulp_ddp_ops(reply_base->dev);
+	struct ulp_ddp_netdev_caps *caps = netdev_ulp_ddp_caps(reply_base->dev);
+	struct ulp_ddp_reply_data *data = ULP_DDP_REPDATA(reply_base);
+
+	if (!caps || !ops)
+		return -EOPNOTSUPP;
+
+	bitmap_copy(data->hw, caps->hw, ULP_DDP_C_COUNT);
+	bitmap_copy(data->active, caps->active, ULP_DDP_C_COUNT);
+
+	if (req_base->flags & ETHTOOL_FLAG_STATS) {
+		if (!ops->get_stats)
+			return -EOPNOTSUPP;
+		ops->get_stats(reply_base->dev, &data->stats);
+	}
+	return 0;
+}
+
+static int ulp_ddp_reply_size(const struct ethnl_req_info *req_base,
+			      const struct ethnl_reply_data *reply_base)
+{
+	const struct ulp_ddp_reply_data *data = ULP_DDP_REPDATA(reply_base);
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	unsigned int len = 0;
+	int ret;
+
+	ret = ethnl_bitset_size(data->hw, NULL, ULP_DDP_C_COUNT,
+				ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		return ret;
+	len += ret;
+	ret = ethnl_bitset_size(data->active, NULL, ULP_DDP_C_COUNT,
+				ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		return ret;
+	len += ret;
+
+	if (req_base->flags & ETHTOOL_FLAG_STATS) {
+		/* When requested (ETHTOOL_FLAG_STATS) ULP DDP stats
+		 * are appended to the response.
+		 */
+		ret = ulp_ddp_stats64_size(__ETHTOOL_A_ULP_DDP_STATS_CNT-1);
+		if (ret < 0)
+			return ret;
+		len += ret;
+	}
+	return len;
+}
+
+static int ulp_ddp_fill_reply(struct sk_buff *skb,
+			      const struct ethnl_req_info *req_base,
+			      const struct ethnl_reply_data *reply_base)
+{
+	const struct ulp_ddp_reply_data *data = ULP_DDP_REPDATA(reply_base);
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	int ret;
+
+	ret = ethnl_put_bitset(skb, ETHTOOL_A_ULP_DDP_HW, data->hw,
+			       NULL, ULP_DDP_C_COUNT,
+			       ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		return ret;
+
+	ret = ethnl_put_bitset(skb, ETHTOOL_A_ULP_DDP_ACTIVE, data->active,
+			       NULL, ULP_DDP_C_COUNT,
+			       ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		return ret;
+
+	if (req_base->flags & ETHTOOL_FLAG_STATS) {
+		ret = ulp_ddp_put_stats64(skb, ETHTOOL_A_ULP_DDP_STATS,
+					  (u64 *)&data->stats,
+					  __ETHTOOL_A_ULP_DDP_STATS_CNT-1);
+		if (ret < 0)
+			return ret;
+	}
+	return ret;
+}
+
+const struct ethnl_request_ops ethnl_ulp_ddp_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_ULP_DDP_GET,
+	.reply_cmd		= ETHTOOL_MSG_ULP_DDP_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_ULP_DDP_HEADER,
+	.req_info_size		= sizeof(struct ulp_ddp_req_info),
+	.reply_data_size	= sizeof(struct ulp_ddp_reply_data),
+
+	.prepare_data		= ulp_ddp_prepare_data,
+	.reply_size		= ulp_ddp_reply_size,
+	.fill_reply		= ulp_ddp_fill_reply,
+};
+
+/* ULP_DDP_SET */
+
+const struct nla_policy ethnl_ulp_ddp_set_policy[] = {
+	[ETHTOOL_A_ULP_DDP_HEADER]	=
+		NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_ULP_DDP_WANTED]	= { .type = NLA_NESTED },
+};
+
+static int ulp_ddp_send_reply(struct net_device *dev, struct genl_info *info,
+			      const unsigned long *wanted,
+			      const unsigned long *wanted_mask,
+			      const unsigned long *active,
+			      const unsigned long *active_mask, bool compact)
+{
+	struct sk_buff *rskb;
+	void *reply_payload;
+	int reply_len = 0;
+	int ret;
+
+	reply_len = ethnl_reply_header_size();
+	ret = ethnl_bitset_size(wanted, wanted_mask, ULP_DDP_C_COUNT,
+				ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		goto err;
+	reply_len += ret;
+	ret = ethnl_bitset_size(active, active_mask, ULP_DDP_C_COUNT,
+				ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		goto err;
+	reply_len += ret;
+
+	ret = -ENOMEM;
+	rskb = ethnl_reply_init(reply_len, dev, ETHTOOL_MSG_ULP_DDP_SET_REPLY,
+				ETHTOOL_A_ULP_DDP_HEADER, info,
+				&reply_payload);
+	if (!rskb)
+		goto err;
+
+	ret = ethnl_put_bitset(rskb, ETHTOOL_A_ULP_DDP_WANTED, wanted,
+			       wanted_mask, ULP_DDP_C_COUNT,
+			       ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		goto nla_put_failure;
+	ret = ethnl_put_bitset(rskb, ETHTOOL_A_ULP_DDP_ACTIVE, active,
+			       active_mask, ULP_DDP_C_COUNT,
+			       ulp_ddp_caps_names, compact);
+	if (ret < 0)
+		goto nla_put_failure;
+
+	genlmsg_end(rskb, reply_payload);
+	ret = genlmsg_reply(rskb, info);
+	return ret;
+
+nla_put_failure:
+	nlmsg_free(rskb);
+	WARN_ONCE(1, "calculated message payload length (%d) not sufficient\n",
+		  reply_len);
+err:
+	GENL_SET_ERR_MSG(info, "failed to send reply message");
+	return ret;
+}
+
+int ethnl_set_ulp_ddp(struct sk_buff *skb, struct genl_info *info)
+{
+	DECLARE_BITMAP(old_active, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(new_active, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(req_wanted, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(req_mask, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(all_bits, ULP_DDP_C_COUNT);
+	DECLARE_BITMAP(tmp, ULP_DDP_C_COUNT);
+	struct ethnl_req_info req_info = {};
+	const struct ulp_ddp_dev_ops *ops;
+	struct nlattr **tb = info->attrs;
+	struct ulp_ddp_netdev_caps *caps;
+	struct net_device *dev;
+	int ret;
+
+	if (!tb[ETHTOOL_A_ULP_DDP_WANTED])
+		return -EINVAL;
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_ULP_DDP_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+
+	dev = req_info.dev;
+	rtnl_lock();
+	caps = netdev_ulp_ddp_caps(dev);
+	ops = netdev_ulp_ddp_ops(dev);
+	if (!caps || !ops || !ops->set_caps) {
+		ret = -EOPNOTSUPP;
+		goto out_rtnl;
+	}
+
+	ret = ethnl_parse_bitset(req_wanted, req_mask, ULP_DDP_C_COUNT,
+				 tb[ETHTOOL_A_ULP_DDP_WANTED],
+				 ulp_ddp_caps_names, info->extack);
+	if (ret < 0)
+		goto out_rtnl;
+
+	/* if (req_mask & ~all_bits) */
+	bitmap_fill(all_bits, ULP_DDP_C_COUNT);
+	bitmap_andnot(tmp, req_mask, all_bits, ULP_DDP_C_COUNT);
+	if (!bitmap_empty(tmp, ULP_DDP_C_COUNT)) {
+		ret = -EINVAL;
+		goto out_rtnl;
+	}
+
+	/* new_active = (old_active & ~req_mask) | (wanted & req_mask)
+	 * new_active &= caps_hw
+	 */
+	bitmap_copy(old_active, caps->active, ULP_DDP_C_COUNT);
+	bitmap_and(req_wanted, req_wanted, req_mask, ULP_DDP_C_COUNT);
+	bitmap_andnot(new_active, old_active, req_mask, ULP_DDP_C_COUNT);
+	bitmap_or(new_active, new_active, req_wanted, ULP_DDP_C_COUNT);
+	bitmap_and(new_active, new_active, caps->hw, ULP_DDP_C_COUNT);
+	if (!bitmap_equal(old_active, new_active, ULP_DDP_C_COUNT)) {
+		ret = ops->set_caps(dev, new_active);
+		if (ret)
+			netdev_err(dev, "set_ulp_ddp_capabilities() returned error %d\n", ret);
+		bitmap_copy(new_active, caps->active, ULP_DDP_C_COUNT);
+	}
+
+	ret = 0;
+	if (!(req_info.flags & ETHTOOL_FLAG_OMIT_REPLY)) {
+		DECLARE_BITMAP(wanted_diff_mask, ULP_DDP_C_COUNT);
+		DECLARE_BITMAP(active_diff_mask, ULP_DDP_C_COUNT);
+		bool compact = req_info.flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+
+		/* wanted_diff_mask = req_wanted ^ new_active
+		 * active_diff_mask = old_active ^ new_active -> mask of bits that have changed
+		 * wanted_diff_mask &= req_mask    -> mask of bits that have diff value than wanted
+		 * req_wanted &= wanted_diff_mask  -> bits that have diff value than wanted
+		 * new_active &= active_diff_mask  -> bits that have changed
+		 */
+		bitmap_xor(wanted_diff_mask, req_wanted, new_active, ULP_DDP_C_COUNT);
+		bitmap_xor(active_diff_mask, old_active, new_active, ULP_DDP_C_COUNT);
+		bitmap_and(wanted_diff_mask, wanted_diff_mask, req_mask, ULP_DDP_C_COUNT);
+		bitmap_and(req_wanted, req_wanted, wanted_diff_mask,  ULP_DDP_C_COUNT);
+		bitmap_and(new_active, new_active, active_diff_mask,  ULP_DDP_C_COUNT);
+		ret = ulp_ddp_send_reply(dev, info,
+					 req_wanted, wanted_diff_mask,
+					 new_active, active_diff_mask,
+					 compact);
+	}
+
+out_rtnl:
+	rtnl_unlock();
+	ethnl_parse_header_dev_put(&req_info);
+	return ret;
+}
-- 
2.31.1

