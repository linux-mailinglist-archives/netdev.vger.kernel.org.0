Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4CB440D63
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 07:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhJaGwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 02:52:33 -0400
Received: from mail-mw2nam10on2059.outbound.protection.outlook.com ([40.107.94.59]:40289
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229638AbhJaGw1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Oct 2021 02:52:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgEcJ2ieZZOyugFfQO9nY9EQN2mD8xQmUoFGS1veKtaBsFBR8UnsEuTKimiQ2AH0KDvRMXB7Wrh509has9wG+/jukCpgAlh5iGr2ucoyhUGUlKsRlHnhu3HW8+STgkeCxHNuWFa5nobKBWz9Qo0upl0ES6oY3RFCC6FwRnoITzSR9BXkWElUveVwg3utfJ5y1TfTskC6MQybUGybumoRygZGLzukorgIbaiAGX4/yE+xpJl+INdPHGOMa5JfFQV/AfkYkcE7bq1ax76+47AvErFTWKBVswOSrnH23aAd2iw+cN0svOv6+0nZ/I1ht/ApPfZdi8PxwJ6RvX0yY6QLKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQl04ZQ2olduOe76bmuFbuXpb9jhRNK6k38TGNpzymc=;
 b=B0laIJJMuUhcRGUm8X+3d64dlRa8d7Q1DinYGyRnwg5EUWRr0EVXC2obl3Q+5aCIePySZlu3ZHNXeFVjvyZyF0qWjS+rjFWtLHxb3k3Ou3c2xJYr4U8ChKxn2Tf2+ZmsYGrwQNSdy0ADuveyDAfFpfVH51BN6JXNVzQFJ1O5HWI7pbAxGgn18kfZFgsnd89ai3IvgKKhgI401UegI1FnJYdALe73D63phZ8Ju+Jl77j2VDLGDq4H47qmcMyGvHP9nGom+sgzK0iFXqy1ty9GgodjrUo1UByKPj2gt7RpyfUfZpvAYSWYs+gVYP/HpMpOQ7xusBfqC97wRdXR8hcARw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQl04ZQ2olduOe76bmuFbuXpb9jhRNK6k38TGNpzymc=;
 b=Ch3oUQZh+X64A1tPVbGiDKInSjX+lHOzWDgSqqdcCOK9ZyzV5SNedxA5na+27aBG4ajhhJXVBlW1vj2paZksXULqOL5uvlrkTMJY1k1cBfjnS5YbakGMwfwAXdntiJbVfTA7BhDqeTJ89JlebZB5ZNsHc5LO9iZnEr5HjRrbXuUYW8wUV79bMO8YLyPsmvoS2Asm5kqPtPampxLpJohbvnp9CF9R9MgiDqs+pulY9pA+/TXHT+DSUk/AaFaIvrgez5pOkeb3TJlNXPUdtrqLlLGQCnoQIh6BG451Br1or77W3Q4KLaJFyyGu6262qZ4PBVIWuccWYcfM1eLTtpSuQA==
Received: from BN1PR14CA0023.namprd14.prod.outlook.com (2603:10b6:408:e3::28)
 by DM5PR12MB1802.namprd12.prod.outlook.com (2603:10b6:3:109::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Sun, 31 Oct
 2021 06:49:55 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e3:cafe::c4) by BN1PR14CA0023.outlook.office365.com
 (2603:10b6:408:e3::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.18 via Frontend
 Transport; Sun, 31 Oct 2021 06:49:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Sun, 31 Oct 2021 06:49:55 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sat, 30 Oct
 2021 23:49:49 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 31 Oct 2021 06:49:48 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@mellanox.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH iproute2] devlink: Fix cmd_dev_param_set() to check configuration mode
Date:   Sun, 31 Oct 2021 08:48:47 +0200
Message-ID: <1635662927-3810-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b3a6d72-31a8-44f9-98a9-08d99c3aa5c8
X-MS-TrafficTypeDiagnostic: DM5PR12MB1802:
X-Microsoft-Antispam-PRVS: <DM5PR12MB180287B3440DE268BE13727BD4899@DM5PR12MB1802.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /RtljMWwPi+x37al5XgRYGk+ntVPp0+C20vp+CxrC8Ig1EmGRB0UYxzLUTrp0Xb9A8q1WIwScCULzMaZHrz2GxWPwWXXuLCx16waYEFKMXi0ig/S0gA+3GqsSXlCSSeAx6LLe7dlQrADMH3CU8+UWdsKuaorjRsVj56ezxxalZOaj6Ugz4aY1bUWnIe0Ksl/RRP0zeHzxv2RqAuRTLHnJITezo3QvfZRnI4BZS1k7JtizuROoRVyDNnE6o1quXb3AomL572RGJW+/43DtvMkuCDKKIX6PvHO9UW2Ew+Yf/4a4TWq034/SQnyA8O8mj+Ger4OXETFFdoRJqwBU+0WO90KVWIKXtCCSSyLJNXJwBt78HqIpXXCNBOt6NLdzOYDfPy5lyBYsmHTbhQqyeX+sVo4KBOyvoK3GUHxAYncbDmXlHEedHWHFwtYFEpTGSgbLHG3ZAJX1dqhx3zbpbsknXBc0wq0J6W5ATjg7u6w4iY8UUr7nGciXFV+EXEOa4avkC00SBPGknS1hRyga6zOFshR7MyEsmBCWiKvqK9n2xQIWMoDg7xq6trTDHZHCKcj8vDfcT4LAp5Q4S010gWBS5n6D4FF8UpIIRoMhS3owOtCQeryeugV4E1GNKviMz3WuAWRy4oojMmuzVxj27A0EqarGqHYmQoxRuS8kzddoUTxKkBrnW1cOJdlbVz4Z2FJfHx4vVW++JYKM0Dh6EXCKw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(8676002)(356005)(36860700001)(86362001)(36756003)(426003)(107886003)(5660300002)(508600001)(7636003)(26005)(83380400001)(8936002)(2906002)(70586007)(7696005)(110136005)(186003)(4326008)(82310400003)(54906003)(316002)(47076005)(70206006)(336012)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2021 06:49:55.1499
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b3a6d72-31a8-44f9-98a9-08d99c3aa5c8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1802
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is fixing a bug, when param set user command includes
configuration mode which is not supported, the tool may not respond
with error if the requested value is 0. In such case
cmd_dev_param_set_cb() won't find the requested configuration mode and
returns ctx->value as initialized (equal 0). Then cmd_dev_param_set()
may find that requested value equals current value and returns success.

Fixing the bug by adding a flag cmode_found which is set only if
cmd_dev_param_set_cb() finds the requested configuration mode.

Fixes: 13925ae9eb38 ("devlink: Add param command support")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
 devlink/devlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 2f2142e..14fbc85 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3036,6 +3036,7 @@ static int cmd_dev_param_show_cb(const struct nlmsghdr *nlh, void *data)
 struct param_ctx {
 	struct dl *dl;
 	int nla_type;
+	bool cmode_found;
 	union {
 		uint8_t vu8;
 		uint16_t vu16;
@@ -3088,6 +3089,7 @@ static int cmd_dev_param_set_cb(const struct nlmsghdr *nlh, void *data)
 
 		cmode = mnl_attr_get_u8(nla_value[DEVLINK_ATTR_PARAM_VALUE_CMODE]);
 		if (cmode == dl->opts.cmode) {
+			ctx->cmode_found = true;
 			val_attr = nla_value[DEVLINK_ATTR_PARAM_VALUE_DATA];
 			switch (nla_type) {
 			case MNL_TYPE_U8:
@@ -3140,6 +3142,10 @@ static int cmd_dev_param_set(struct dl *dl)
 	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dev_param_set_cb, &ctx);
 	if (err)
 		return err;
+	if (!ctx.cmode_found) {
+		pr_err("Configuration mode not supported\n");
+		return -ENOTSUP;
+	}
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PARAM_SET,
 			       NLM_F_REQUEST | NLM_F_ACK);
-- 
1.8.3.1

