Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34FD649406
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 12:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiLKL7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 06:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiLKL7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 06:59:03 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD79D108A
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 03:59:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FVuZHOuhBxRroZRZHF/d4DE61Xs7eYDxX19V96GT0CctMQDMIG1V7ntuBSQKEXjDWoh5EHN1yzR/i5w+Izs5Hox/Rd9ff+rn8JSF8V+scWh9ZSC+gDJ3b+2ZgQZwRfWZtG498SJj0Rh1x/meAHx6ABhFJzPX5pD9MgW9lZiBOep8KS9LYnTfwK2VLMB9z9xrwI08u8FrKB4mk+639ZoKoTpot6mRtr2BHRvsvP/IR+imGPA4mRl9kUX1J8imQxCORO0YbVK0TMwkUE2eaH7oVLmV21gTMlyWWeVPF5NFFXhTZ7/NzRxhbsJ3kaImnSDY0qYTOxBTY2aXh343tm7WYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ENHlBIBGUY8GuX3AcViyOHR7g24gA11SKOiy5NJx0Os=;
 b=YhfKEnCD+2L7YVzYE1q5PCyqA+jowkoG2X65TvkB1Gf8955DFAagePGPpJRl817w5faP9pJ0GDMiYw3yBFUxakIYuLs3Z3eyQOqW4S9l7I2QbatENxksIm7MMeb16gKq/UzjcQwSlhNgr/LwtOfcMVQBHBlAAgJudmSA2CxTNcSF1sUV5ZDuOFsT9UU1PJmCAiKnFoBmDg4W4YcV7EvaQX1Nug+TVZndBn30URaqxe1EbzbBI3NC8fO9o8vRzLHvhRbRzweiKZONqnwbwB9DUDc1MBvR96t+/xsnvXvAG3i4unCxi4B77ke8PEJ0P/6Nmnm9gsR8Hf0bg+LjyytWXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ENHlBIBGUY8GuX3AcViyOHR7g24gA11SKOiy5NJx0Os=;
 b=sF8lZm1spZLHEAGoByMab4deSt85RAHo7RQX2LpWVhzBX0K6u2M8HnH7eBGg/+NQ2NqxW8ShBq3QnWpOy6wk/TDsPHUw8WDeW32tZygvU8+dLI8IN3+z3tnZx+SOtifBR6U7BRAJqC+ILcyd6R2zt8X5XzX7KwU8Z2e1q6FRpCYCIk+4YFRXqvcAWi52R1l56zTdOIChk/tI1h0WvbE/BDvhpJdJm+or7jCF/ZOX6HTFuh9ve+menzXc0jFLKktIEdWy9oVbb656DA7+X+c1h6JifSnScU9IMLKt0Oo3Sa8egCBYmHMUTPpgypIdCzVq+E0n6lI9JUw890drCaBDjw==
Received: from DM6PR10CA0001.namprd10.prod.outlook.com (2603:10b6:5:60::14) by
 BL1PR12MB5110.namprd12.prod.outlook.com (2603:10b6:208:312::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sun, 11 Dec
 2022 11:59:00 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:60:cafe::be) by DM6PR10CA0001.outlook.office365.com
 (2603:10b6:5:60::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19 via Frontend
 Transport; Sun, 11 Dec 2022 11:59:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.21 via Frontend Transport; Sun, 11 Dec 2022 11:58:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 11 Dec
 2022 03:58:59 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 11 Dec 2022 03:58:57 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, <jiri@nvidia.com>
Subject: [PATCH iproute2-next 0/4] Implement new netlink attribute for devlink-port function in iproute2
Date:   Sun, 11 Dec 2022 13:58:45 +0200
Message-ID: <20221211115849.510284-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT068:EE_|BL1PR12MB5110:EE_
X-MS-Office365-Filtering-Correlation-Id: eee763fc-2f8b-4d02-5199-08dadb6f16fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DyoEgZRStN+r2jQnkneqWUet3lHhe0s/ke2zd51ExDZZn409S7AN85xWfsTxP+WCoiSs/Ns5JORvUN5QtXay2OWCjvg4a23FzehNyyMqMa4c4oQke+QtizBOisBnSBQnK33WIfib87TxTPVtT788FRce3tlIBvdVWzTvTNYIaQwWF60Kbv/dwkwR6BY0NPF96+ZrIEgvMocmivXDkom72WT6VbZHByesHRiAQn059GxqDPl9Z4WRq/7rAd3pTgK6PBiMUQLOoU7hsovUyIbsYt1EsmGGiuSJX2OYz4z8PpTfgit0EoIIVGAvXNjU3Nc+8DwTJqe5T5hdWJSNTV+OE9bZvY6LY0B9IRze4qdYWMQibI0J1gWzx2MDUudjYYtOkFkhRrX42FcuRn/2zogKRdr9mGoQcSMuWmAtP7kX+o0U2WT1MX5vnIkHKp+/ALYa8AOf1OwGmi6T4rf4gxc9r4EiOpbhhk3CLT/sRnZjAgkqlaNSboCwsCtR9qBjpeXZ5lByoY0BDt0BeqKpdgnh+L9tRYD4a2Tlh9YEhIAzQysPM0gMyvWWJjm5yoX3DkmrLXUSTcq7cQF23/qtoEWehFz/mtVmTi1O9dKgRSNBS65NK15crAw4SFIbMDiDUBxJiOQIAyZSMdJWO/ZgZyrYp94lOkTs1DosMeJTdKEJMfG/nNOmq2h330Wh6MLVfaTnEWchjiFu60wgFbAvHd0KWPQeNlw+gNVNs7fRtqBD9VLS/vrt0pjEguV38lKoZMPRyAoM2szM+bM/QoWGail40wSONZKg0iKElnTdtAQm1wQ=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(376002)(396003)(451199015)(46966006)(40470700004)(36840700001)(82740400003)(2906002)(7636003)(40480700001)(4744005)(82310400005)(26005)(36860700001)(36756003)(41300700001)(6666004)(70206006)(86362001)(8936002)(6636002)(5660300002)(316002)(110136005)(8676002)(70586007)(478600001)(356005)(966005)(186003)(1076003)(16526019)(2616005)(336012)(426003)(47076005)(83380400001)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2022 11:58:59.8493
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eee763fc-2f8b-4d02-5199-08dadb6f16fd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5110
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch implementing new netlink attribute for devlink-port function got
merged to net-next.
https://lore.kernel.org/netdev/20221206185119.380138-1-shayd@nvidia.com/

Now there is a need to support these new attribute in the userspace
tool. Implement roce and migratable port function attributes in devlink
userspace tool. Update documentation.

Shay Drory (4):
  devlink: Add uapi changes for roce and migratable port function attrs
  devlink: Support setting port function roce cap
  devlink: Support setting port function migratable cap
  devlink: Add documentation for roce and migratable port function
    attributes

 devlink/devlink.c            | 51 ++++++++++++++++++++++++++++++++++--
 include/uapi/linux/devlink.h | 13 +++++++++
 man/man8/devlink-port.8      | 24 +++++++++++++++++
 3 files changed, 86 insertions(+), 2 deletions(-)

-- 
2.38.1

