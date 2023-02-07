Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA74768D430
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjBGK37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbjBGK3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:29:43 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFDC2916C
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 02:29:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7AcemTX3r1yJbunjSnN51dguPsaa5LsDE6EG8oREqwL/tsvP6+Em4npNQDJrTakYP3vE03OxpsYLzIRDeE4pPfEq5/vV0s+IWhmX+vU61SiSagsbrFJK/OHJPnZwN3OdTvnq6+3rODFSErRLuWxmi8ByZl5d6Nt9EBB+tJDVdXVZJ7hhKG0OHhNuVIbY+OX6S3BIrUmmd5glMh7L3MIGHhsNvWiPJaBqQ5TuaPszRRrx10hO7jdEAliXDbKPp1rhI25QFf2d1iKVLr0rJpbPw3z/MB7wrgbksvizL/txPHEXOkwqQZTsdpLCcxUZ6P27ye78t3XikZJiLkl2uHEOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z/1cnYZMnqM9CUEc/NEMPtGSz0Zq+zDAOjARzDopEHs=;
 b=HWZDrkFK+Y22f7FqTu2eJBQKomYtGk6aVzZJ7C0+kuapyCxiJ4MDiIXCVXt+q2taMHnDvYQ+QtLP8g7/25UVpW7+JHzf2jb5rW+ThKCpeeTjoxqpLrA+0Ah2dsKeDtP/KIdL8h7gzLWiU+FwwZl0VvWqjv7HI+EO4Q6djpueTS7WX8ApgH8T69M/6spROXd1LZIJ2quJv9B1fNCEZsS8Z6b+yMfZcL0ecfRjE1Cj5RPhhdqpgtMvSHhCxnvHVYC+D9m87sP6H6+9jjOfecNU1NBMnRtoaQpzHhLnJPybt8DlzgiC8wvcG2t4p8b1K/CCtFjbH3v0Jke/vGu51WzitA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/1cnYZMnqM9CUEc/NEMPtGSz0Zq+zDAOjARzDopEHs=;
 b=QrS2HQgzqQgwLN2e4aUcijylBlv+R4MP/qP2ZrAAJ2NDofbY+UkzZYUwty3W2xeQSzzWgFedRNxGLn73HjvHgMU3feVc47/k+AsnrEd7OLwxYQ6GQBVAemxfc8lEKj9o/XcFUOxSnjwd/fOysQO4XH9xKtDIwppPsWeDDGKNGnAirC3aRuSeL50nQkEFp6GVg2T1rjFq7omnpFL4SmcGkMbBhEq5eGXRfsbMiXDx7pCECW6wlpXs9DDSX3I3N7TuOlEgre+YlMYznuMhNX2mIuicycq3GBZfa+azn/wu+8FwIybBck6qk6rlNuSuGN+WjLTMWvooOt1/T9SIn2U1Lw==
Received: from MW4PR02CA0013.namprd02.prod.outlook.com (2603:10b6:303:16d::13)
 by CY8PR12MB7658.namprd12.prod.outlook.com (2603:10b6:930:9e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 10:29:26 +0000
Received: from CO1NAM11FT107.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::6e) by MW4PR02CA0013.outlook.office365.com
 (2603:10b6:303:16d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35 via Frontend
 Transport; Tue, 7 Feb 2023 10:29:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT107.mail.protection.outlook.com (10.13.175.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.16 via Frontend Transport; Tue, 7 Feb 2023 10:29:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 7 Feb 2023
 02:29:09 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 7 Feb 2023
 02:29:07 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v2 0/3] bridge: Support mcast_n_groups, mcast_max_groups
Date:   Tue, 7 Feb 2023 11:27:47 +0100
Message-ID: <cover.1675765297.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT107:EE_|CY8PR12MB7658:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ef8cc79-e948-4011-e4f3-08db08f62fd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y2VdtCs7+aI5Y6idNrbbnftrOAedSkf4aaS2xzhw4SBQvCrNS4WpI6sdsCiIii4diN85wdruFDxDdjEQBwnZBcSS3iVH9zgJa/e0cRFmaQsYzomB4BiHFqKFQOYZGEYt3ah44gD4PJl9tnsCmoGLVK38INaZAp370d03dIaTMwx7nelmgCc7T3lOXp5IWlp6CEtudAPebkRrOUepra29Cj7v9GiOCG4l9U5ssVZ6bRzxrOYVM9YgFeDCrm0Jqta3BixHUrn6N1kXKlNMeZdHU5ZfvsuewNl9rfWi0ag4vmuZ17C8Fes2KvtDyQW6BzqgWhuhrchNphXSjUZYxI9uQWpB6o07NQ05f5JEJUzbapoUhsauBJHM9TZ3WnBg5QlZV54LBNc1VKQm1VYmHsn//RtbvIjcgVULZY5AxVxiw4EcgTDNOlRHLb+1iZD8WK3YiTea9fnscAwt+7Wt7x55anqp8B/LAQGvZ7RkbWWLb2+DqFzHHgM/bQgqXsjF8u0VDkkUagPLNozhJ8/qywFBXlMIT4PRntSh0i2HYxH19/Q8jiuK/k+1vSkRperM5YxZTJC+B1o3fuE+lTk4TtyEDLQHe8sD3P7eKUaY7av6sHC/Y/7usJhY+zM4flIyuDuhOOQzDQ+AauRvzyxomkRcdsdyK6polXxCRmDP+of1SdyffeuE/mgKAr1uU/hto6pT+GfzhEi+OJUcpoOkIRs08Q==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(376002)(396003)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(40460700003)(107886003)(26005)(16526019)(186003)(36756003)(82310400005)(6666004)(47076005)(7636003)(356005)(110136005)(54906003)(82740400003)(36860700001)(316002)(5660300002)(40480700001)(2616005)(8936002)(41300700001)(2906002)(4744005)(426003)(336012)(83380400001)(70586007)(4326008)(70206006)(86362001)(478600001)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 10:29:25.9381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ef8cc79-e948-4011-e4f3-08db08f62fd1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT107.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7658
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

v2:
- Patch #3:
    - Mention that the default value is 0.

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

