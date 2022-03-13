Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B52F4D7732
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 18:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235128AbiCMRNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 13:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235126AbiCMRNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 13:13:40 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CFF13A1E6
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 10:12:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EavLlOPNKI83A4+5b98BSphUE094nEUTUDWW36K3U5KYUhsDN9rHFGc3szxiJ2QsHRDXy+jYI1fVLfi4yXrdMo9DitJ4LCx2yoiRpmIAi1lfmgtvVbcCuXQdI74rVUpWLy1z/TJPnd8QdjqsS4ntwBYe45v4ckzp+35R5ZNBtjwak14qyTT2/cpv8umQDabW5enK6Fb49ue5mFvdYUwz+OEoDF+xZqntLRRzvLCV+Py2M9qEosdI5I9+LlpvLFO6EnigVukTUSiRU1DmHwDkTsGJlU7zMoFL/RVCLa8oBw524Hv6jX7g6R2FmTJfalgOa6AgAbWWeRYa49RdB/c1OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=elG1J40xfziWfEzxXTaCmVzClifDsoIWJIaSpNtwrfs=;
 b=H60aHsUdVQsRWsbVMK3fBd1jgCX7SuA4zFzcgY33iQEws//KjCu/KraWkDoYIn9GuxXwr3NCVd0OZuPXGY4UTRfmGt0kLIu0aIWjlw3es+aVf/odRnxr9cgdOMOBPNOrDLNRlkleHahaqaOMoMs9dVXGVH9g3QYiNGrFeK+uGvPBpczoseSHPn822j3wuwcPN4pfC9lJpGUjosAvPUD7Iug2K/7TuWwYHQUe1Ag80TojfXmxFiKSWZepApX5pm+gPQKKAXyl7pTrsL0XopXLw14TrdgSaloUxU7AOYtFvXwTQZt62KKCKgPkc3cUkkX+UZxlxpGxidkrNjl4QpxpkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elG1J40xfziWfEzxXTaCmVzClifDsoIWJIaSpNtwrfs=;
 b=UsP6yBYW0bouan8L/F6OUYNuzfCWrDJdzPJHLVCauz8kL2OWfiuNhKgkIrPyt9IWofor1CDUubfYQ4p4lD1qHkqkT+jM/ooATuBZCqLm5aCX3YsPCYZWtkCVmOQWDEY0gcZ40G1YbEVVPSR74Y2z8fapntHE4gMKkIeErUU8vxcsUh8BKDdNLqHjzk5qeGGZnrqwxYUKJMSmFMJSlneHH9CLZMb0L8LhYSLLiS/0ENsXu+7arWeCFswpDoxU3ObEKi7ZN5sj8JTSpcafJGkaSEgaWk5EhTydtOY0EN4GJmuwmvzxI2urRbX3a9UADPx7CexnGZcGd/qJu2TcLRo4dA==
Received: from DS7PR03CA0272.namprd03.prod.outlook.com (2603:10b6:5:3ad::7) by
 BN9PR12MB5067.namprd12.prod.outlook.com (2603:10b6:408:134::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Sun, 13 Mar
 2022 17:12:29 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::d2) by DS7PR03CA0272.outlook.office365.com
 (2603:10b6:5:3ad::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25 via Frontend
 Transport; Sun, 13 Mar 2022 17:12:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Sun, 13 Mar 2022 17:12:29 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 13 Mar
 2022 17:12:28 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 13 Mar
 2022 10:12:28 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Sun, 13 Mar
 2022 10:12:25 -0700
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Jianbo Liu <jianbol@mellanox.com>
Subject: [PATCH v7 1/4] vdpa: Remove unsupported command line option
Date:   Sun, 13 Mar 2022 19:12:16 +0200
Message-ID: <20220313171219.305089-2-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220313171219.305089-1-elic@nvidia.com>
References: <20220313171219.305089-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfc44f71-e841-461b-d146-08da0514a7a5
X-MS-TrafficTypeDiagnostic: BN9PR12MB5067:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB506747E922E8B265526EBD40AB0E9@BN9PR12MB5067.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uiMxY+n6rq7RrHhEyolb6O7xZvwnMib7QVMqhJK7Ez2bMMkCgps3VlRHp4V7FH6J6v/hEVJPYKU044KDGBRE4Q+Yy6dsb5YuZPC+OE24AnH4TjzTEpmUwaqGfX/2U4IN472DkTbnCb2bi/LpiTahnvqnD2d4tEykxLZlQf4uX3hVjsOMNMD96fx8glmpDBYe9Bnm5P2fODaf/l4G+BpgjWjFXZNkSXdlR0ctqABG9s8g+7UmnHPYdPB5odRt/L9JEazoMmoCNb3fpJYsRhVNDT00THwrSOlaUb5HZafvfA6kTJC5+MNG9k5K49Eoc9WqGbqy3NqDW1PsmkzjuGtNPSecw7YOavC2RzhtfMwRfwkAJPsFIUGVdxkEt2+YBNAStLLUZHYkzGQMQjbI85wS+zkZwXfXhp89yCNQKsdPaw/58qkrprigOBm3l3FHlWr41T5lvmOySHLQ+lPDFL68Hgezg93+7UeuqNyrflVCIDkp9+RCmUdqCU4l2Keg474n2Ojm7iNI6c6GESMlE2OEgvOtLXt+nYCwvL94Xvqc41I4DPImRfIKxsTY1p+xUYmeH6CLKdPV/YUpJF8xMbU2oGPyDZIYg3GMXk99y0xnKJIQ3AXUdF+MMEoiNdwubofNKtNoM0e88zqP6ZLc+8VRQj1rDDT3bTH43pzQ1LqrDt/jIfNntgBoxaqv5CenbMsNTsLPX9DW5/hdgAO+QsU/sQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(83380400001)(36860700001)(316002)(36756003)(107886003)(7696005)(6666004)(2906002)(1076003)(47076005)(186003)(336012)(426003)(2616005)(26005)(54906003)(8676002)(5660300002)(70206006)(70586007)(86362001)(8936002)(4326008)(4744005)(40460700003)(508600001)(81166007)(82310400004)(110136005)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2022 17:12:29.5243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfc44f71-e841-461b-d146-08da0514a7a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5067
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"-v[erbose]" option is not supported.
Remove it.

Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 vdpa/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index f048e470c929..4ccb564872a0 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -711,7 +711,7 @@ static void help(void)
 	fprintf(stderr,
 		"Usage: vdpa [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"where  OBJECT := { mgmtdev | dev }\n"
-		"       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] }\n");
+		"       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] }\n");
 }
 
 static int vdpa_cmd(struct vdpa *vdpa, int argc, char **argv)
-- 
2.35.1

