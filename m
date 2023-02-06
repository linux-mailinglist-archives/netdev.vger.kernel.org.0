Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F0268C522
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjBFRu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjBFRuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:50:55 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9EC2BEE0
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:50:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AvQe4gvK8nDFz9POCp8FAVn/Vq4xU7Mj1LKRPEOSeBcgwYLZEvlbvejSicRObrvrukvAuPDKTD+GMZ1QYti+JzNxCcnLcFjwd9ZjuoVCQZoEA9gIDjnQkNCDh0qTw84CwOSq4zRb2xgXFDorANJXUiMxfPOMmTZwaqF0LyYvqvCrZ3hvQKQhMfgtx+N8gAZ2GRAXjeDIYDVySG7KhF7TZ1MU5OHZDs3NRS2dK8olKXAx/cixKiqMaDeuLB59XKNczjkeOle7Sy40X9Zv6V9Ypkkw/KEMKL0KOd4Iz9Wg5GAhgF3fxAt/ROUbsnONHIoSoYD+gojj6t3PuXFhOucnrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wea0sO0jM+YtVG/xzMlZkVum5ExoB3d3hfIW+HtUOeI=;
 b=GBwStLFAaDIsj8V2NfdkuLgPv77WaM/j1sOpa4E2OF5Ky3m0ghNeiaWy3lpZYUafy61AhpRMAwM6yzJumKLqIerTCJpbQnd29sa9ObbzNAuoi0QMlJd1rrmIy0LLl9PDJ6704o6vGqOs13sT9jy8cwDXuVrSM4SXBQ8HpL13+r8MBu6FEkTLBvyMXWtVMjsV2TNzMZ+CcJzEY33s3Rpyl59QuLfSpckTD8973v5qEdcU8tbMVF8neIB+OvcKMuveOdXcO5NSGN69w44JivB54r0hUCwtaX0bIOFY7zLb4c9FxCgY9BMzDl5ZyEjgYjcCF49YTifNCjajY3kxVOGZQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wea0sO0jM+YtVG/xzMlZkVum5ExoB3d3hfIW+HtUOeI=;
 b=irrad4p62LtrWiDOB5veKKuEKnAJe0W20Zyu51nZsSxradAoMwo2RplG+NIe7EKEVQ1tDAeX3lNsT3exC+YV6xkVrBs6WaTF130y5PSbFQOD8QCfhkDHLK6jjuvGfbwmZbvwjW9AKLUsRtwqOLPshMTfV6Uj0KfW43FKw9kKMEVEbfDiEyfpkDiEjFFzgv4zGJHklfG+XxPUOtQn24zSQEIBBaBAxikPyULu0wj7ju5IHWZ5OF7PoYDnvTcASrVxPlmfKmVQ4095t2rpZTe14mWMZ1i9rEH8nniqR0ab9+Z13YCc76Jq0EIJhvC0bEwnFa+RRDJK5hwiB4JLwUEeow==
Received: from CY5PR22CA0074.namprd22.prod.outlook.com (2603:10b6:930:80::22)
 by SA0PR12MB4399.namprd12.prod.outlook.com (2603:10b6:806:98::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 17:50:50 +0000
Received: from CY4PEPF0000C981.namprd02.prod.outlook.com
 (2603:10b6:930:80:cafe::ee) by CY5PR22CA0074.outlook.office365.com
 (2603:10b6:930:80::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35 via Frontend
 Transport; Mon, 6 Feb 2023 17:50:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000C981.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.17 via Frontend Transport; Mon, 6 Feb 2023 17:50:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 09:50:42 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 09:50:41 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 0/3] bridge: Support mcast_n_groups, mcast_max_groups
Date:   Mon, 6 Feb 2023 18:50:24 +0100
Message-ID: <cover.1675705077.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C981:EE_|SA0PR12MB4399:EE_
X-MS-Office365-Filtering-Correlation-Id: f10da158-1f7f-4997-c5b4-08db086aaefb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3maoAfQNSV2HdATNFwySMEqJUIbUFtZK9tIB/v6KQp6CQsMNCN0+YmdP8+63dib8HQvL8lqFAI4b0a5HWiNqUkun47PQCToMEGHnbQOLfjAG20kO+5I/IfXySQv6uEGOhkkPvEIkunBwILd1fyzkCkLr4epXHeU160vU6UnUBr3sKV9LwUYRmwh0c50XqvwqCqsCAfwGqa3+yVhfHqs5qwsWEryAuGY6D34KFMYd+cZDpoGA+n+iD3oJ+lqRR0QMYnEcoXGez8dU5Q8qhNuTis8kfwi750Tk4gbfAFcqwqyJguCHBY9YDB6cmDYEqMdTV7/tIuO+pmpYky6k0WOng0hhcrHBDhVKwkfY1j+cI1+Tar7igATiAc96gbExAQgs3CtR3T0K3QZb2yklYkn9TOuKTe4KbXuTVxCvwt/dVAOYQS3+kQ57fFzeez5UeW+eFXM4frgMidAOMwI+aBZ3OKfYKCDg2BAOwuKnHszcBYrEerNixu9ct0mP1UkMcjRNuKVJHHz7q3OblXioQbY1GJaWlH9i2RNUehyhvdUXdjP7hLJhZWEofb9pr5gDfx5PQk29obiMyFC6IancbP0l7P/lmSE2hSaA6R4npmB39EWNFq4JeC1wNYf6bHh1QsMT8F6MRmYN9HNYXcw9r1uc3LhcsGiqTI8wWOiVGsmeRyAqk+6qJ5ULOtSvPY1TGJYc6eupOBwJTYnQSaVpeRDq8Q==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(396003)(376002)(136003)(451199018)(40470700004)(46966006)(36840700001)(40480700001)(86362001)(82740400003)(36756003)(7636003)(356005)(82310400005)(40460700003)(2906002)(316002)(54906003)(478600001)(41300700001)(70586007)(70206006)(8676002)(4326008)(6666004)(8936002)(5660300002)(83380400001)(36860700001)(26005)(186003)(16526019)(4744005)(107886003)(426003)(47076005)(336012)(110136005)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:50:49.7254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f10da158-1f7f-4997-c5b4-08db086aaefb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C981.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4399
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the Linux kernel commit cb3086cee656 ("Merge branch
'bridge-mdb-limit'"), the bridge driver gained support for limiting number
of MDB entries that a given port or port-VLAN is a member of. Support these
new attributes in iproute2's bridge tool.

After syncing the two relevant headers in patch #1, patch #2 introduces the
meat of the support, and patch #3 the man page coverage.

An example command line session is shown in patch #2.

Petr Machata (3):
  uapi: Update if_bridge, if_link
  bridge: Add support for mcast_n_groups, mcast_max_groups
  man: man8: bridge: Describe mcast_max_groups

 bridge/link.c                  | 21 +++++++++++++++++++++
 bridge/vlan.c                  | 20 ++++++++++++++++++++
 include/uapi/linux/if_bridge.h |  2 ++
 include/uapi/linux/if_link.h   |  5 +++++
 man/man8/bridge.8              | 22 ++++++++++++++++++++++
 5 files changed, 70 insertions(+)

-- 
2.39.0

