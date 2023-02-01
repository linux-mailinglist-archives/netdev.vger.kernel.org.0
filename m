Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A3E686B47
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbjBAQMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232466AbjBAQME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:12:04 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88C376412
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 08:12:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZIJSv8YUvTboLWjK69psRGFHekTPiSXq22512PLYoasebt4PtoVElzvi+VnZTOzpggRDFoxHf0cOIa7Jy15D2bkc7gxh92RAwMSxw9asVSOMxY/RUlZKK/ZuGhXIkivt30TqtYhOiQbFXYDzXTMx2YOGTfR0ZdQp7HOFic2Sb0dwL9SbGY0bgvxswCH2cVQkr9DRmy6KHjt+98KDzprvJ8KpKGFHFqK1a5kALE/9WI1jQpxB2jmSeaK837z3h0bqH8lsN6AC9hujD+TgRpdY/Qu/0SZKh0W1qwfPA+IJUqAe40+m/K9MFCjdgaFu296Xh78RCkd61jwhSiIjcdce+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oeI3HnsFSoPGB9L8q9Vqtc8BRtMQ/wdADB40hNm1TTk=;
 b=Z41l5/Z7Gh9j3DWaH9SugUqYH+goY2wTJZ1koI6xfjfZbwAcYnlKNIKjoErnjxKL0DsiilmV7CsfpG1CkEE8QVjV2AV2SUpKBzdLsxqNZMte53Ys5tr+7RRpLKu70Hn3AM/uCdUgHXq9Qd5xgfTD+YzcnloyFiqc0po85ZCocg6eqkm3zRskSMnUXIkQ42XfZ+Sxq3Xeh2WOJVzY0IukqCqtpQm9GEePibaYrVsbCrU0s5czDxAbSKwICA3TVonJ3MS8N44jfsXT09bZRHjwkOzsn4efkRhdpoQdikAjWpjMzdRyeauwV9nWQtl+PVvCMzxPxImeSkgGfv5grS3YqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oeI3HnsFSoPGB9L8q9Vqtc8BRtMQ/wdADB40hNm1TTk=;
 b=T+MNb/cDtepmVD3gBRHhpAvRGHPjqT6KRIf7l/OmiIE77AGogsPOF7LztOtOdXJeB85qA3hs4TlEdN6iVZ5A2jx4+H49EASrczW9BHlL4ljH/LQGKvITKalOh2aNRamI/7MnWCRahDJqnb/8cRjIN+3J+EQh1lLwLgxMw6OEYeHJPMfxR96OrzFG+tOdSk/dmh47LDjyEqttIdu8tnMsSaoeNJq6jOIhqXIqRRHqBVSdxxncWJiOgnY9q3mIW/mtfr/5p9pPywmOmRdSEEIZXlSnBP3JYUXc5kyTeRlZmTc87FWFGo8Zy9N9Ap33VmAJqiateh0x0YJ0Uhouje6N0w==
Received: from BN9PR03CA0342.namprd03.prod.outlook.com (2603:10b6:408:f6::17)
 by DM4PR12MB5357.namprd12.prod.outlook.com (2603:10b6:5:39b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 16:12:01 +0000
Received: from BN8NAM11FT086.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::d9) by BN9PR03CA0342.outlook.office365.com
 (2603:10b6:408:f6::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Wed, 1 Feb 2023 16:12:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT086.mail.protection.outlook.com (10.13.176.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.22 via Frontend Transport; Wed, 1 Feb 2023 16:12:01 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:11:49 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:11:49 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Wed, 1 Feb 2023 08:11:46 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "Oz Shlomo" <ozsh@nvidia.com>
Subject: [PATCH  net-next 2/9] net/sched: act_pedit, setup offload action for action stats query
Date:   Wed, 1 Feb 2023 18:10:31 +0200
Message-ID: <20230201161039.20714-3-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230201161039.20714-1-ozsh@nvidia.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT086:EE_|DM4PR12MB5357:EE_
X-MS-Office365-Filtering-Correlation-Id: 20e6c19a-d3c4-435e-4515-08db046f0d3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5pkDEKKUOpbyxIXP1GmvM0mMQS6PnG7ZwVM+VVmafLrBmhec+th9TNg1I9VY1t+bfsywNk2SFAmaYvfFvsjzDkqsiQQHSFJmnYn7L/Sq2+wwoaA8n8mVyt94pj1gMHm1rJ/iTWoUDRy+ZMj0u+NQ789dhyR1skHgW+lFojy9LF+b6+5d+BQdar0Gw2+fVCuSBXfAuYm1xNVcRs+hRg9L3Y54sPr4xrRnDVVofJjjlt+e7MCGLema8P3dgyx3jsM8fFnqaKK7kQNjhj1shRbrvlPYrRYSJsLdeb8DoD00ZfODg18GLbjh2b8UK4KGlG0kdvNRsp/LSessMfXkbZnsDsT9I2D9C1mPx6kEgn/+E3GJ2rtzdNDbH0QfHHlkiQiCrGOE+12B8JsO1Lz4yTlagBRXyGn2PSnDcy/vPeyKGID6xolM3fg51X2IfhbJbwbCKETF1Q5hNf3Mnz8GJvSLg6WTC9LNNFaZNCcfds5rZIRS1v1OgB+xFkBt2CQzXSx0mI2wFlyKH5GuS5KGJZQoHS9F+mINpNFlJMcxz2yPq6vWO2ZRZ+Mh59JsSwkHG7qrr2ZH3997oziDsFDlYT7SY3cA9LiNEkXabel4wende7TsV5wCnqMSuJ7jaW/aV+YR28tOOv9OeLKGdtnQdL5nyvwcFeM2+SBixq7lsTSFgCSN99b4LssP1r2RVMXXQjbkLetUyrv+Ga9GXZ7fZKYGzA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(39860400002)(136003)(451199018)(36840700001)(40470700004)(46966006)(6666004)(41300700001)(70206006)(36756003)(6916009)(54906003)(316002)(8676002)(4326008)(8936002)(82310400005)(5660300002)(70586007)(7636003)(86362001)(356005)(82740400003)(36860700001)(107886003)(186003)(26005)(1076003)(40480700001)(426003)(336012)(2906002)(40460700003)(47076005)(83380400001)(478600001)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:12:01.1091
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20e6c19a-d3c4-435e-4515-08db046f0d3e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT086.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5357
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A single tc pedit action may be translated to multiple flow_offload
actions.
Offload only actions that translate to a single pedit command value.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
---
 net/sched/act_pedit.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index a0378e9f0121..abceef794f28 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -522,7 +522,29 @@ static int tcf_pedit_offload_act_setup(struct tc_action *act, void *entry_data,
 		}
 		*index_inc = k;
 	} else {
-		return -EOPNOTSUPP;
+		struct flow_offload_action *fl_action = entry_data;
+		u32 last_cmd;
+		int k;
+
+		for (k = 0; k < tcf_pedit_nkeys(act); k++) {
+			u32 cmd = tcf_pedit_cmd(act, k);
+
+			if (k && cmd != last_cmd)
+				return -EOPNOTSUPP;
+
+			last_cmd = cmd;
+			switch (cmd) {
+			case TCA_PEDIT_KEY_EX_CMD_SET:
+				fl_action->id = FLOW_ACTION_MANGLE;
+				break;
+			case TCA_PEDIT_KEY_EX_CMD_ADD:
+				fl_action->id = FLOW_ACTION_ADD;
+				break;
+			default:
+				NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
+				return -EOPNOTSUPP;
+			}
+		}
 	}
 
 	return 0;
-- 
1.8.3.1

