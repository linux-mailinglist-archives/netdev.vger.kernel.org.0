Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6461366F98
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 18:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241463AbhDUQAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 12:00:08 -0400
Received: from mail-dm3nam07on2064.outbound.protection.outlook.com ([40.107.95.64]:54817
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241397AbhDUQAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 12:00:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SiaJh7EZ87NzlEiDb+5uXyMlxjmJbSeh7uaS22Hxn8HIgVBKQz6YL4XEE2yVL5rrx0DHIE47f8aPIiypRky6xcQA0adQpZVwkQTOKqmkBWp3kgjIqhMxHTAP/RHpO5gvzSyS19515eNKbqvOddqqJl93v2gAmWAxOuqQqZn68XPYkqvxx+/j2xEzqkbqB0u55vDrmGQB4U0RWFFDXaklotDw5nfKqau5bVAzFTng3BSaLUxBvuSErc5ESCHPgXzvt9UvRuA01gDQ9TCIM8SSiiqv0J0JiG7nyhP8yu0xi24ywkm3bfNWrCd3Z3PelWs8/EKMnZuEQTELFbsA/nyqLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olVyyWd5jy/nH075ilXHUd2fS1DbS4/x3flsA+f/DKw=;
 b=GZuYmoz5KkXjfl96nbGLsoEh/tji0VgunBToE5UKO+ihc3f5QbPjy7ntoWfQWRY5VwL7e0NT3//nzFmnh2PRRw/EJ2M805Thq90n+hmAWm/u0i//S/0+2IusWHxYD5sSyAgGYFDoG8NIg7N6PNWB8aGwuszbILFGBGR4Qc/NEnqbTcN6gAi5waujiHM5NX4FZogo8Oca306IqFF7x5UXpg54MtIMSNW2fE4S1fHeVeGdPjM8js8mFbL36SkU3jvdPX8P2R4tHA9SLE81kTZBwABzxrOT5rGFMXFsk66kCyhFG+1N/zYnp6afrhELavEANJyLY9Npd3Vh3FDj5GMAfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olVyyWd5jy/nH075ilXHUd2fS1DbS4/x3flsA+f/DKw=;
 b=GqiCyeWg5iGOIvmnjFZ8kqfbPvHiKciCD7NgBECnVysJURsvasQk8NAFlo0oJ1V2KBZ5ItJnPsrMVsh78Bnkj5/kLCARDg9db/IjbBX0GE/5a3rI42kCknlL0dOxJP7LSCwUAS3gFU6DAXGf9bePSniceutR10LaYiMz2TT++kXvlnKIMK5If5gHxeKJ+/RxSg2mrT6ERqHPyc1MyI82ArPBBR/JZgA4xfxhdmo6hpETTB9m0+5gZkGzTSfi6SbQd5b4eNRJDXpnnMLwvJ82kURxudMGSRcexJCEsoNDwtSU7GKybaGSHeqhyhQaC8wqcDB2za9/qHST3xEwt+WVhg==
Received: from MWHPR01CA0028.prod.exchangelabs.com (2603:10b6:300:101::14) by
 BN6PR12MB1635.namprd12.prod.outlook.com (2603:10b6:405:3::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.18; Wed, 21 Apr 2021 15:59:32 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:101:cafe::ea) by MWHPR01CA0028.outlook.office365.com
 (2603:10b6:300:101::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend
 Transport; Wed, 21 Apr 2021 15:59:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:59:31 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:59:31 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:59:28 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND RFC iproute2 net-next 1/4] uapi: update devlink kernel header
Date:   Wed, 21 Apr 2021 18:59:22 +0300
Message-ID: <1619020765-20823-2-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020765-20823-1-git-send-email-dlinkin@nvidia.com>
References: <1619020765-20823-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cf29243-16d1-4b47-c679-08d904de7388
X-MS-TrafficTypeDiagnostic: BN6PR12MB1635:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1635E30E268FEC28DF5386B9CB479@BN6PR12MB1635.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gOyIL5q90WZpxeEm3rI0CLd7soBjZZM0WWpV9OskXukFaCHTNoTCAe9QJzANURer1OosgYiTiRNK3iEWzyotCZIEg0SoXd7E/ENcl39e2VcEnS+eQG1ylyz2jtjLKQ0O44EQmP7ZbHqnwW7BtAU4E2UmTGURXwG5RtzHg+XtWmDBJnhNJVqFDmoKXwa5CsMEjnamnVXZSlTKAGlbwtWF+qUSaJLwfDNl38BI7OV6d97v1Uc8HV4Q/cW+D9lzWcHg9+MpqpLxJ/bvFsbxTx6O3NPphKw0v3cUtUeJcjJreo/ab08xRXjLxJXqGUXxwKJWdh6+wSvumaU7VIvblj+wPDSoFzU3TDvxzsUt+OCixh2RVTDkjjmZFMLDkN0aN7QvtEawSuDxZtF2s1qqENXskzzvHaqiZdGxb5zz2tyhV0wB4OnrsGhYtsXgdlsP7HW5sMKId0jeXe2u6dhdQa9pQca8/v/ITfKUMyHzEo3TxQAKTFb9j3B1OLjASaIMlKPnTTkhUgnTAUUkSbRxzST8Lftt0C+gBv6fivE3XjkaE6+d6iVJWhfKvwGlvRhpPkXlUYbwk5loiox4ebhINjhaG6Ws4enHvvMK6egU8BoXi1HY5nAXuICxHYqGIzTTQabho2f+4BcsbWZy/TsZ0ssr2Rf9tDxyk4KPpzJGxQdy1Tw=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(46966006)(36840700001)(2616005)(54906003)(36860700001)(336012)(8676002)(47076005)(316002)(36906005)(4326008)(70586007)(86362001)(6916009)(6666004)(82310400003)(36756003)(70206006)(426003)(8936002)(2906002)(7696005)(2876002)(7636003)(26005)(186003)(82740400003)(478600001)(107886003)(5660300002)(15650500001)(83380400001)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:59:31.6060
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf29243-16d1-4b47-c679-08d904de7388
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1635
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
---
 include/uapi/linux/devlink.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index a430775..6408b40 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -126,6 +126,11 @@ enum devlink_command {
 
 	DEVLINK_CMD_HEALTH_REPORTER_TEST,
 
+	DEVLINK_CMD_RATE_GET,		/* can dump */
+	DEVLINK_CMD_RATE_SET,
+	DEVLINK_CMD_RATE_NEW,
+	DEVLINK_CMD_RATE_DEL,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
@@ -206,6 +211,11 @@ enum devlink_port_flavour {
 				      */
 };
 
+enum devlink_rate_type {
+	DEVLINK_RATE_TYPE_LEAF,
+	DEVLINK_RATE_TYPE_NODE,
+};
+
 enum devlink_param_cmode {
 	DEVLINK_PARAM_CMODE_RUNTIME,
 	DEVLINK_PARAM_CMODE_DRIVERINIT,
@@ -534,6 +544,13 @@ enum devlink_attr {
 	DEVLINK_ATTR_RELOAD_ACTION_STATS,       /* nested */
 
 	DEVLINK_ATTR_PORT_PCI_SF_NUMBER,	/* u32 */
+
+	DEVLINK_ATTR_RATE_TYPE,			/* u16 */
+	DEVLINK_ATTR_RATE_TX_SHARE,		/* u64 */
+	DEVLINK_ATTR_RATE_TX_MAX,		/* u64 */
+	DEVLINK_ATTR_RATE_NODE_NAME,		/* string */
+	DEVLINK_ATTR_RATE_PARENT_NODE_NAME,	/* string */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
-- 
1.8.3.1

