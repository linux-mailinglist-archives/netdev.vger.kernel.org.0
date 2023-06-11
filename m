Return-Path: <netdev+bounces-9903-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CA1672B17C
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 12:57:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4690728121A
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 10:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B03B8480;
	Sun, 11 Jun 2023 10:57:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDDF7469
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 10:57:48 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A96173A
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 03:57:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SBg0Y6HyWGtkmDx8mu4/uQF/K/op2GDDgvVb2hcU+4iqeziO8zFl3KGl74gW2RryI+cwCQOx8P+/3ULkrcMYl8NERrswxQRDBvplW698xxlj0AUQhmmx1RoqdWDN3uxHjo4/RRIukZxIV3gsE/Y/xGK7/tY2uexMd0MZcRZUjQPwsf9/0H8ftbAd7J6pVkMZWiCUcV3bbtibGHKK/J9rSDTx++nrYAGeSHvVc6szoJxY0JQr3NnG4WCm28nj299BErpuujRmToVp4yo75wbrI4zg5llLMzqMDXU3c3XW1gl7LcJ9AZJ2jcskk1bHh+hYmsHcUXrK3nxGfj6U35ifdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=StuHAMcUVXgENuzERCiQTGlhAbwlmhluh5t8s+DFrU8=;
 b=i7pK0raABDQJsfnIHrspUiwi0cXm1FEzq6oR+N5VJPzq1VaiatB/54VKU48My/HLSHk6WhxXbL/mMdIMlTeJ9tIPEzEyMGUTtmKm1LbxHx8QKgZT2O5n6NsgdAafvqaWiuSJrh02Pm7zt/BWRBJ1gBOJjv1nfpyrvrgD9MVzZqgA2u2FQFqldCQmgg95qvZca5LjILyWrxuWF7KqiH4ur6unCux4Ho0jvMq3hm89VcXNzVk0CZV3DfvkJ/o6VrE9f79N3gbKJDiNBUt9GpPBOl289LJjx39X0bYkXdQ2Mdle39Wzv5siUvabo2dt3vO9ls8fSOHFuSVOLbo8bI55eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=StuHAMcUVXgENuzERCiQTGlhAbwlmhluh5t8s+DFrU8=;
 b=GGT3+1nlikUWvUD9WRtdm0i2/HSbjXC9USkYp7EakhWgVydLq8Mxf/yfTe6HhVgjw9ILFmcmTFlUT0CxXNjMkYtzTk1RggpTK0lCCBgzDOGyeyESunqAdmlGglVSQx7LK1eFsrSdONnvbStqu6fpgkd7pniS99pQpHJt87t4CF7XBXHINrH+TMCxNT9I0MZXJ985UhBeA6wnYjjNK4evxVj5mDXNbe2sH0eo1t+mFYBhJN52eM1ZX4W5WmzOga436bP084FVMKSfaaIrjcnYLoIWsj0vegqwYouK/zChwktQCQtnmElmntzLHX58ZBAMfPG/juNRy4WDZgf7Q5j6Aw==
Received: from CY5PR20CA0030.namprd20.prod.outlook.com (2603:10b6:930:3::28)
 by SJ0PR12MB7476.namprd12.prod.outlook.com (2603:10b6:a03:48d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Sun, 11 Jun
 2023 10:57:43 +0000
Received: from CY4PEPF0000E9D2.namprd03.prod.outlook.com
 (2603:10b6:930:3:cafe::ab) by CY5PR20CA0030.outlook.office365.com
 (2603:10b6:930:3::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Sun, 11 Jun 2023 10:57:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000E9D2.mail.protection.outlook.com (10.167.241.145) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.20 via Frontend Transport; Sun, 11 Jun 2023 10:57:42 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 11 Jun 2023
 03:57:42 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Sun, 11 Jun 2023 03:57:42 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Sun, 11 Jun 2023 03:57:39 -0700
From: Gal Pressman <gal@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
CC: David Ahern <dsahern@gmail.com>, Stephen Hemminger
	<stephen@networkplumber.org>, Michal Kubecek <mkubecek@suse.cz>,
	<netdev@vger.kernel.org>, Edwin Peer <edwin.peer@broadcom.com>, Edwin Peer
	<espeer@gmail.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH iproute2-next] iplink: filter stats using RTEXT_FILTER_SKIP_STATS
Date: Sun, 11 Jun 2023 13:57:38 +0300
Message-ID: <20230611105738.122706-1-gal@nvidia.com>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D2:EE_|SJ0PR12MB7476:EE_
X-MS-Office365-Filtering-Correlation-Id: a8995bc5-4eae-405c-bfeb-08db6a6aae83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	a/9BEDmeYvMWg+OKYR5YUEtRKPiW3R50NhD7tqP1xTtCQjEGXBzFnCBkT6b9UI6bcvgXPKNUmMd0A5nSjT69Haeuejzsp91S3JOoCSXBVM6lD6vJaJajTt2A98yhFE80Z4VNep46SSUSBhIWuLkl9EMnIHo79FNGj+uABA/4DLFOYFdf7P0uXvCmXueQcVlJbTH7W6UHOXxAzzK2Dzp6A6pgxSel4iBxFsV/e8L2eLB1o+42ulDNjmXZaVZm1DFjy4gzBikuwdSiPJ8XNF3JBnMWV8pz3JiWQXiOqxGX6OoCqOPw69uJkW0euL38WRMQmPwZtmo/NzmlMPfkEiC8wbKEYr0ksV4DJm/uMNx8rlPdM3tUln5jkKKBEm+6kmL1MFV1rjYDghkKBZOr7YRTiMKKGdms79qywWiY1+s5CZ6WuR2d67vL4CAw+GcGUSOnnLXtWEO+PibNH83iuFmI7L/0QYmKj9vGFWGOz7UQZ0F0umFPfbChIV7lZEfooEu3l94ecy+Gnl36o5LX0uJHHnZKL4Eb8Z/899O6y96gjdsm/cDiGX6/x9mSz/ikUV3EtgXdHFKLFb2yKypnu2BfjQHaQn5FjcLm/v2J9cTR9LC5jcilB5qo/Frxf26r6r9DisNhH1CFUo2zPmoabJRve3Yj7a+oK7gETKn26m0FWhriyFRGx1ZpZOsyo/0wvf++/KngIcbdSyv6AsB+AEjCkVWy7mP9X6hsJWm+3SWlFRzpk0MA7WDzZephQmJpUKAwrVm9WaKzRUv/rYkzcDvyMWeVx2sHclTi4dUIPTyXyeE=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(39860400002)(346002)(451199021)(46966006)(40470700004)(36840700001)(1076003)(26005)(186003)(2616005)(426003)(966005)(107886003)(47076005)(83380400001)(36860700001)(82310400005)(336012)(356005)(7636003)(82740400003)(70206006)(2906002)(70586007)(41300700001)(7696005)(40460700003)(54906003)(5660300002)(8936002)(36756003)(8676002)(110136005)(86362001)(478600001)(316002)(40480700001)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2023 10:57:42.8910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8995bc5-4eae-405c-bfeb-08db6a6aae83
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7476
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Edwin Peer <edwin.peer@broadcom.com>

Don't request statistics we do not intend to render. This avoids the
possibility of a truncated IFLA_VFINFO_LIST when statistics are not
requested as well as the fetching of unnecessary data.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Cc: Edwin Peer <espeer@gmail.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
Userspace side for kernel submission:
https://lore.kernel.org/all/20230611105108.122586-1-gal@nvidia.com/

It is only a partial "fix", but increases the number of VFs presented
before the truncation occurs.
---
 ip/ipaddress.c | 6 +++++-
 ip/iplink.c    | 3 +++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 361e6875b671..8197709d172e 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -2031,9 +2031,13 @@ static int ipaddr_flush(void)
 
 static int iplink_filter_req(struct nlmsghdr *nlh, int reqlen)
 {
+	__u32 filt_mask;
 	int err;
 
-	err = addattr32(nlh, reqlen, IFLA_EXT_MASK, RTEXT_FILTER_VF);
+	filt_mask = RTEXT_FILTER_VF;
+	if (!show_stats)
+		filt_mask |= RTEXT_FILTER_SKIP_STATS;
+	err = addattr32(nlh, reqlen, IFLA_EXT_MASK, filt_mask);
 	if (err)
 		return err;
 
diff --git a/ip/iplink.c b/ip/iplink.c
index 690636b65190..6c5d13d53a84 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -1166,6 +1166,9 @@ int iplink_get(char *name, __u32 filt_mask)
 			  !check_ifname(name) ? IFLA_IFNAME : IFLA_ALT_IFNAME,
 			  name, strlen(name) + 1);
 	}
+
+	if (!show_stats)
+		filt_mask |= RTEXT_FILTER_SKIP_STATS;
 	addattr32(&req.n, sizeof(req), IFLA_EXT_MASK, filt_mask);
 
 	if (rtnl_talk(&rth, &req.n, &answer) < 0)
-- 
2.39.1


