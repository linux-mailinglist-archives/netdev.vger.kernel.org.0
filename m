Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4BC649408
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 12:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiLKL7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 06:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiLKL7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 06:59:11 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE5CC767
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 03:59:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLH5BDDXvSW3pWkKt7OCNEGD7EJX7hxhQl82EydZVxuT8FGwqtx32E4Qpgk7xYzbvqpurYXhDJku/2dd/hrJs0ecrYAE3Zceom1BZGQGGrtE+wiW4yvpzDb1KXWuNwprjf4FzD+SvbEG6oDjjsLNFj9nHuvkoR3SWC7meqYnRho+Cw819Fc4S0165xITn2OYyQafp4H2cOkKyD47CClvOr+nBwwpYE739rVO4O6hR9W1T/iCNwbBDCKrB0Kzg6apGrOPgV9CcdwthpJW8Oakg7ZwCFBf+fOB2Sy8vlsv3jZj4qLs/+6r217JR7FsIXT0YvHdJdJYqYTueY2WvTa+Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Ohl44uLz1yCJWhb+7YYJqT8+e11N05VTlCNTZwYWqo=;
 b=QI5RnuCd0uPwRzbrRzXy74Yj+lxmqNBQv+EJmhqVATdfHrVT6OaqIVFrIrB812dYQWxN5MF/5FCjCzXPH+vKxKFBABdolTHbh8XV9jPZYQDQnBNfrGCp+BgdIMIAwyu0t5m/E5mAEfDDS99T1CFTrwqL2mrml5CqTAK+vG1g+iF7jhqP1QbHf9XwFXaqkt3GMB3FKh6C7CDrS5X2GKc7JvWxCjw/rvLZ2gnlA/BYQzTzdj5yfwTFfSUob2ZIRsnEPdE7qAxoXyx74F0Qx/QQdQxjxmvNimBDMHDawBrLLH7oSW3MsGAJoP2D8K6/LapFRoFB2MCLfGYCNEQyBJrM/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Ohl44uLz1yCJWhb+7YYJqT8+e11N05VTlCNTZwYWqo=;
 b=PDr9NAnhujg+EQgcE5vrgvaachldrnMJ0R1a0UTRqHzqQDqibp1qZR4Xp7WGWZGbz3zswTlmEVt1fF8Ngp46KlTbHX38CXTXuEERRAN0VnGdt8y7rx4N5HFC6CwW0Hm5pY2ZwIW5ni16g4cmq43JHrUdgN4pqa6FQ3ItXwBD4+ae+o2WNOTR9afOGs3NQARkzjHg8bTPYI4EDw66ma/9DmEWFvPV+EPP/oKvXyShzDL+gkiU6W641vs5cMGKohGW+LmmGswFHFA/JLL+kJs6MjgjT94bZT9ruCk/YgC1tuV/G4Zq2Qv3QKOPufeBm6ciw+0evZecxYqQrRAZ6zhd9A==
Received: from DM6PR02CA0046.namprd02.prod.outlook.com (2603:10b6:5:177::23)
 by MN0PR12MB6175.namprd12.prod.outlook.com (2603:10b6:208:3c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sun, 11 Dec
 2022 11:59:08 +0000
Received: from DM6NAM11FT086.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::f9) by DM6PR02CA0046.outlook.office365.com
 (2603:10b6:5:177::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19 via Frontend
 Transport; Sun, 11 Dec 2022 11:59:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT086.mail.protection.outlook.com (10.13.173.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.17 via Frontend Transport; Sun, 11 Dec 2022 11:59:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 11 Dec
 2022 03:59:07 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 11 Dec 2022 03:59:05 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, <jiri@nvidia.com>
Subject: [PATCH iproute2-next 4/4] devlink: Add documentation for roce and migratable port function attributes
Date:   Sun, 11 Dec 2022 13:58:49 +0200
Message-ID: <20221211115849.510284-5-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221211115849.510284-1-shayd@nvidia.com>
References: <20221211115849.510284-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT086:EE_|MN0PR12MB6175:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cd503e9-9808-4727-e0a1-08dadb6f1c09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AzR97AjDW+pkDoUB1O03idb05Nw7XWk1sQoKJuosPkv92SjVpxGIhchuoXYWNF7X/JQBGofxCw9KGbzbMoAWWOb+hbOf+f1RgyIVGKn7Jt6CbDxPCBnLJG0M5oznUljAj8cm5ikx9g3bxCA+dqgKykkko2yWt5OotSehxWHC3mtvB2D+aX+dHmSkcue3L1yH9ltvqt65H3uXsoHop2NwZescoeEK0PBmzQDqK1LbUoVKJej6593fdY+md8o5RWKgCL1Vg6ialiHcFY0UfUDXeJj91DqJS8ba+Mwi+PXmtUTB70rUrvEDFYjyot4qAwOKOIds/0HbENo28oy1/gQaAGIiXZ8pW7WDc7gjH2lLnUrGyp5xnSwYSNMeAgTP+Uhx0RVCvxm5szQU+jHzhWLVLdB9pfbz/ejEUxjXr6G5moU67vWFg7c2odJGkvyfgBnDxqocSVCmkmwqx+OS1nG8ZERTYzP9FAzMogX6MDc/jdUUud0T2lbxAGTvDzvBpJm1HCQP9yxSb54chLeXoCTQwX0hZmbmdM6InQaDSofaH/7W/Ffye1QrFdPfp+KlcvVpzOz/cCtrpy6TsCo3ElPzGK7TgrSHk82bPjYXN+CBeDq5NQCF8RkEUV9fWbZ6ftyMEVIU8dFAthw71UOTX9tORz99v37e3QZ9QywNAaGUfGpWQJYA+ojX4+QDMiPY+7Vkwe8fuZ1alK6mr19lwMpvqw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199015)(40470700004)(36840700001)(46966006)(478600001)(2906002)(6666004)(426003)(47076005)(82310400005)(86362001)(36756003)(40460700003)(26005)(8936002)(5660300002)(186003)(7636003)(82740400003)(40480700001)(356005)(1076003)(2616005)(6636002)(41300700001)(336012)(36860700001)(16526019)(83380400001)(70206006)(8676002)(110136005)(70586007)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2022 11:59:08.3202
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cd503e9-9808-4727-e0a1-08dadb6f1c09
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT086.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6175
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New port function attributes roce and migratable were added.
Update the man page for devlink-port to account for new attributes.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 man/man8/devlink-port.8 | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index e668d0a2..56049f73 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -71,6 +71,12 @@ devlink-port \- devlink port configuration
 .RI "[ "
 .BR state " { " active " | " inactive " }"
 .RI "]"
+.RI "[ "
+.BR roce " { " enable " | " disable " }"
+.RI "]"
+.RI "[ "
+.BR migratable " { " enable " | " disable " }"
+.RI "]"
 
 .ti -8
 .BR "devlink port function rate "
@@ -208,6 +214,14 @@ New state of the function to change to.
 .I inactive
 - To inactivate the function and its device(s), set to inactive.
 
+.TP
+.BR roce " { " enable " | " disable  " } "
+Set the RoCE capability of the function.
+
+.TP
+.BR migratable " { " enable " | " disable  " } "
+Set the migratable capability of the function.
+
 .ti -8
 .SS devlink port del - delete a devlink port
 .PP
@@ -327,6 +341,16 @@ Deactivate the function. This will initiate the function teardown which results
 in driver unload and device removal.
 .RE
 .PP
+devlink port function set pci/0000:01:00.0/1 roce enable
+.RS 4
+This will enable the RoCE functionality of the function.
+.RE
+.PP
+devlink port function set pci/0000:01:00.0/1 migratable enable
+.RS 4
+This will enable the migratable functionality of the function.
+.RE
+.PP
 devlink port function set pci/0000:01:00.0/1 hw_addr 00:00:00:11:22:33 state active
 .RS 4
 Configure hardware address and also active the function. When a function is
-- 
2.38.1

