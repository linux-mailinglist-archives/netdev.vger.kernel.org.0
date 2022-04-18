Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1944A504CC8
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbiDRGqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236800AbiDRGqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:46:23 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2041.outbound.protection.outlook.com [40.107.101.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A6B18E38
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 23:43:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QzrjJT0ODstpV8jGpQ2Lo+R9j5WIh5HHWcHIu3g7zFJ4eW8kUwWIl8dMhjYEINgTE3noI92wiISJaVdNaWj+eHemFp8lI0BWaikf4eAa898LWX8aKkGq9B5ITPbMtPdTAHOHkGUWsu1G5Fuf3xGq+Az36Yx0XWI+M+yfXzShLw7pPc+7VQdrZjKrv/9ALFz6D2BTKdrAoK9fhxCKE9fFHVCbbCXgCyD6F5Brefzaa0wpB/Y9XMoYzXV9AJn9SuQpoGjjQV9L8TXmAhfvSp7kVn29DUtc/4n4pbxV+OCMYYtl13kwRNY7Iwe9JsdLzU8l14DkL+Xk5eVQ/H5fDAcvfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OPvQHzFOFuJIvhYGTkU0X13nJ2klROzwDet0U/0KqEk=;
 b=lZxhBYlwHKP7g4o9LQVcqKXloFUTcZ5W23QM5l6TEoxutVegfKW3f7EmEydCftGcLI5tVAT6MSj/IJHdiqcmu/SwuqKfqKX+W8Kb+MARWEk6wTBw0aqo89CeLHtsv3PMEEyqudpl0mY9M7GnvcOXsCmznjaFgsYkj3XYmabBPhqODOXolL8kSfYIaWhNnatxZ/7kw3Qb7yIFWCBh/tn7fjmTXRdHYd5i53xuJM3yh1+EHydP0UylNaiqEyI8Ql00dpoTA18LoFDUsc3nMV2FRjdV5M7i+FDnM/JiAtI0tZVM1uVOK695OY2r/UCRnuOJ3ZUDL9aAVv5cW5WrfJ7UUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPvQHzFOFuJIvhYGTkU0X13nJ2klROzwDet0U/0KqEk=;
 b=OlcvzX19uKlRd2HKcsIU6G2bFpL3oZLTKnRU1AYuV7Kl+fLSCaCBlNUDLDlj97jTbBGb/j0rQkoIPXUD8eAld0yLD9l+rYVltWAgWSmNer5s99IqgEqnwqtG/+UNE9OeRWAmM+Qych9RPv3H/7jQj0WdC0fu5B0ok0faJk2zAL4ceJXETej82egbq/ThFBc1SXGHRdyIGapybhR6KMRM0fMpnJCLSNonRsUCoxQCWM4pvd5Yky7xK/wYdY4WV9Hgx9gCcHRVx1es/VeLzahVIkiZNCCiy3DvnOnKbuG6CnASMGeGTIlfC+4p4E5v1pPJpTycl6hpSS64BjqmGr9D+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by PH0PR12MB5420.namprd12.prod.outlook.com (2603:10b6:510:e8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:43:43 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:43:43 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/17] devlink: implement line card active state
Date:   Mon, 18 Apr 2022 09:42:27 +0300
Message-Id: <20220418064241.2925668-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
References: <20220418064241.2925668-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0153.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::14) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef517cbc-1fba-4099-40c2-08da2106c7f6
X-MS-TrafficTypeDiagnostic: PH0PR12MB5420:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB542018AC5E917882D7070F2DB2F39@PH0PR12MB5420.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f98YJleaOZyxNha+fOaQ0VuYUEYUKwSZxPDhKdODBrg0Bu6f1Xc6SNQKpXYK0mX5FMrVSGk7mIderekhfh8paytON8ISljY+8jnBxb5DjmoVLA8GrNScHOrUs2XwYS96gno300lhl5YTPcRpg4bc3Xx+VDTWGvLAghYzjhnMG38/bwrX4Txg/oLyiPe1/b5Ebqp+gdb6yHovZikjDWvEU9b+4V3cnxT0D8AxW6Fxi/V0mzdudxA7RDIt6SQfeZt86QTWAWewrUXUZoRkNt2bV/q9SDQWXawjPawwe6NxLoCI9XiaACd2BfpU289W9fVmO/o2OlTocwTM66ZP4anTfBDYCG9lgQqEZlmTHWogDhBc0W0Wwdos/daeDWffsILefZcb9u/Ri57aw04K8ZX7XtVzk1leAWknLn/qH3c4dHTyDnR/SEJ4KFyandj9ntCAXV84IBCGJQ1Cv84b9cY45ZouuEh0eQzeWra4TkZXhIiWoxOVC3dnbnsbEeO5+wWIAULxI5ocXErXPasaxRkzSRCHqmXKqLfPsrJcSeK+DgzvbPmlfhLdXKoGH1xsblF3/w9OtTPXH6aKOSOVi8rZv+/CWjNo6p4z4oaoBU7KrXpaBRjEjNtCjzViLq3SOpAPFmKIQRPlefP+QlB9U5uvJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6486002)(508600001)(1076003)(2906002)(6512007)(6506007)(86362001)(6666004)(36756003)(186003)(26005)(83380400001)(66946007)(38100700002)(5660300002)(66556008)(66476007)(107886003)(2616005)(4326008)(8676002)(6916009)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V8a9gN9yEr+Oxy2NI6TkoD0AbYF1jDpkSIV90ziDki/JH6W38JSw8z+h7yAa?=
 =?us-ascii?Q?wslcaO3vbZlFTBhJEjVUWmnmHvEHNbA3rQjCnqe1t0tF5yWas61IynNURPdb?=
 =?us-ascii?Q?Tl0NbLOe/V52TSZt/PXXe16kltB6YvRnNcUnFq9Kp5kts9emeT0zrSJXcvpk?=
 =?us-ascii?Q?jfYMXNMnqCwngFcDdVCjDCdJUPfXUep/s8wS/hZUHdwVVHAyOeXvhsbY/rUH?=
 =?us-ascii?Q?an08pDjBGZADcrVOgJeKs/2A40UTW1vknh9pNwYTx3gIUKGT71bxXkjXdxlx?=
 =?us-ascii?Q?qhPbI+l4qZT/9pawLSeZOcQDKl316s4BjVIBZ73olwVhrfC4WdV4VI+tQhVw?=
 =?us-ascii?Q?WWIoBctwbvyDPtepkhktB+KM/9fvMK9SF7hC68mVYvG3No+OzSTMMtrD/nOC?=
 =?us-ascii?Q?w8iL3n7R28aWfI8LcxLcm8tTGpLneEGce/HuliedpjIjBS+DaEeLk3d+1yVE?=
 =?us-ascii?Q?4ne5w7zc8Pn7RTohtw5hgDmnlG8FmD1UhC1d2Ah4QKKbLTHUp+nmQ/EElbdJ?=
 =?us-ascii?Q?TgFgrule4OW1tfOtSidOgkt9fbOKtGcxNpOqQbBhDpNlg4Ay584Q46bj/JD+?=
 =?us-ascii?Q?s88KBEVak/jA1/eU1hn7ct8uOeF/hwdYXMRXpHXAi9PT8u2X1CDt6SvcoqM7?=
 =?us-ascii?Q?mD0mhoi7Ne90yCwm+87pOgoJMvuyP4hITKNd7oRK5fOM/G+T6ScLrzBBV45r?=
 =?us-ascii?Q?L4IFdcafUs9cB3Fr/p3mkJ3pOcn5QrPNnhJ3gP1rn+Q/82UjnoozY3qoneN3?=
 =?us-ascii?Q?oBJ7+khIpUCDDX/Dxrek9a7eh9lj+eEodvLFySt7iwDYgsxIqrrB2hvpVEoL?=
 =?us-ascii?Q?ww4e03vU6hgLAtoP5ZhIjwpDlNCyR12I9VPVi8XwJLexsQ1e+IIf+/k3ZR15?=
 =?us-ascii?Q?dJrO774Gnj1mazKSoQhyHNbxzlQhtsYDqZvrhpR0XVVeuQcfX/iqs6ekK2Ha?=
 =?us-ascii?Q?nkqjjFkBwwcnl/sB8FblahLzMn7Wa7AQ2slwkdqNqsxtEUxk8UX6R0ahA5gR?=
 =?us-ascii?Q?KMp8SL4IPNaSkeBigZBqgv6vPVuhiGodZ2Ryi4Z5BQ50TLaMDZeAcO8RvnRO?=
 =?us-ascii?Q?Cf7pLU6whihAbXX9xjAKXlTErt1t5UPgNasqNZ5Rugvj7hwwzILvbwdzBbWK?=
 =?us-ascii?Q?Umd5Mmr5RPMviaPb85pKku4uoF65FqQtLgNSaLUSH2PcRiFtc1o+sWbZaZSU?=
 =?us-ascii?Q?ly4do2nbh0Hx0tnlEv4am/JZtPPe/3eCh2jppxBddmL+RV2/5yxiPDyQS5B2?=
 =?us-ascii?Q?CEykwvqlkqwZiZzTO5IPJbB1KECgofc0DVBzUjdhyU/DpGtyF2ay4Vsm1X6P?=
 =?us-ascii?Q?pExeh3a57MFMtX1KnY7EGoi+USdBdNYSy2RqZz337+Txu086lWxd9BrUbNEh?=
 =?us-ascii?Q?a0GEmNYgRuoOzkAn7u/EK5CQZFTz7SN7iqxY41t/vLusyPSyb8/f8S+JRHQS?=
 =?us-ascii?Q?tacVEY/FhmNbPoqD5FgXhaPOABlY104pM2Gb4qOOduWjFKWKiFtexrtY7QYs?=
 =?us-ascii?Q?H4S9gWZhzNP/032cKDE4cLRZ/4AUjQoebeqsB2u6DsyHRL8W6eB/Jmm/zon2?=
 =?us-ascii?Q?x6mFzgtPIfUYsw5X7fJqzV8DBaOFcaz0anMiUwGHE/Sz1/HEdUUuZgrEWgb3?=
 =?us-ascii?Q?BjshCzHia6vVBcNwSshhwl5L5dkb9Ax6SABI75EhvRfiwePI4Udr6gayDshh?=
 =?us-ascii?Q?cEaQHaMMEQkl/LxGpB0fxcfRSjTb0SdHJ7ZV4joJcMCcTiGvMkpIKhh0nsvF?=
 =?us-ascii?Q?suDPRZLb+A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef517cbc-1fba-4099-40c2-08da2106c7f6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:43:43.6078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wzt0i76/OG89ZUbTxcmXjhVo49zxgR5np4nqBXJqi+EyGQ1/nGXbk2bU3FDxczJ3ytR2Fk6DeZl/QyWN+8OvUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5420
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

Allow driver to mark a line card as active. Expose this state to the
userspace over devlink netlink interface with proper notifications.
'active' state means that line card was plugged in after
being provisioned.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../networking/devlink/devlink-linecard.rst   | 11 ++---
 include/net/devlink.h                         |  2 +
 include/uapi/linux/devlink.h                  |  1 +
 net/core/devlink.c                            | 41 +++++++++++++++++++
 4 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-linecard.rst b/Documentation/networking/devlink/devlink-linecard.rst
index 63ccd17f40ac..6c0b8928bc13 100644
--- a/Documentation/networking/devlink/devlink-linecard.rst
+++ b/Documentation/networking/devlink/devlink-linecard.rst
@@ -66,6 +66,7 @@ The ``devlink-linecard`` mechanism supports the following line card states:
     with a line card type.
   * ``provisioning_failed``: Provisioning was not successful.
   * ``provisioned``: Line card slot is provisioned with a type.
+  * ``active``: Line card is powered-up and active.
 
 The following diagram provides a general overview of ``devlink-linecard``
 state transitions::
@@ -85,11 +86,11 @@ state transitions::
        |                                               |
        |                 +-----------------------------+
        |                 |                             |
-       |    +------------v------------+   +------------v------------+
-       |    |                         |   |                         |
-       +-----   provisioning_failed   |   |       provisioned       |
-       |    |                         |   |                         |
-       |    +------------^------------+   +------------|------------+
+       |    +------------v------------+   +------------v------------+   +-------------------------+
+       |    |                         |   |                         ---->                         |
+       +-----   provisioning_failed   |   |       provisioned       |   |         active          |
+       |    |                         |   |                         <----                         |
+       |    +------------^------------+   +------------|------------+   +-------------------------+
        |                 |                             |
        |                 |                             |
        |                 |                +------------v------------+
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 3e49d4ff498c..d8061a11fee6 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1579,6 +1579,8 @@ void devlink_linecard_provision_set(struct devlink_linecard *linecard,
 				    const char *type);
 void devlink_linecard_provision_clear(struct devlink_linecard *linecard);
 void devlink_linecard_provision_fail(struct devlink_linecard *linecard);
+void devlink_linecard_activate(struct devlink_linecard *linecard);
+void devlink_linecard_deactivate(struct devlink_linecard *linecard);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index de91e4a0d476..b3d40a5d72ff 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -350,6 +350,7 @@ enum devlink_linecard_state {
 	DEVLINK_LINECARD_STATE_PROVISIONING,
 	DEVLINK_LINECARD_STATE_PROVISIONING_FAILED,
 	DEVLINK_LINECARD_STATE_PROVISIONED,
+	DEVLINK_LINECARD_STATE_ACTIVE,
 
 	__DEVLINK_LINECARD_STATE_MAX,
 	DEVLINK_LINECARD_STATE_MAX = __DEVLINK_LINECARD_STATE_MAX - 1
diff --git a/net/core/devlink.c b/net/core/devlink.c
index b7c3a82fbd4b..aec0a517282c 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10331,6 +10331,47 @@ void devlink_linecard_provision_fail(struct devlink_linecard *linecard)
 }
 EXPORT_SYMBOL_GPL(devlink_linecard_provision_fail);
 
+/**
+ *	devlink_linecard_activate - Set linecard active
+ *
+ *	@linecard: devlink linecard
+ */
+void devlink_linecard_activate(struct devlink_linecard *linecard)
+{
+	mutex_lock(&linecard->state_lock);
+	WARN_ON(linecard->state != DEVLINK_LINECARD_STATE_PROVISIONED);
+	linecard->state = DEVLINK_LINECARD_STATE_ACTIVE;
+	devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+	mutex_unlock(&linecard->state_lock);
+}
+EXPORT_SYMBOL_GPL(devlink_linecard_activate);
+
+/**
+ *	devlink_linecard_deactivate - Set linecard inactive
+ *
+ *	@linecard: devlink linecard
+ */
+void devlink_linecard_deactivate(struct devlink_linecard *linecard)
+{
+	mutex_lock(&linecard->state_lock);
+	switch (linecard->state) {
+	case DEVLINK_LINECARD_STATE_ACTIVE:
+		linecard->state = DEVLINK_LINECARD_STATE_PROVISIONED;
+		devlink_linecard_notify(linecard, DEVLINK_CMD_LINECARD_NEW);
+		break;
+	case DEVLINK_LINECARD_STATE_UNPROVISIONING:
+		/* Line card is being deactivated as part
+		 * of unprovisioning flow.
+		 */
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+	mutex_unlock(&linecard->state_lock);
+}
+EXPORT_SYMBOL_GPL(devlink_linecard_deactivate);
+
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
-- 
2.33.1

