Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5FD68C1E4
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 16:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjBFPmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 10:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbjBFPmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 10:42:01 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC70B2129F
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 07:41:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=csGgOL3m2EaNj0CgMNVKZ3JZk7FCU7t9DP5wZz1kwgIGcf+Wnbhk34qLPdz8T5SB+XvYOHt6KuDBN3C6WsOrP2FMiFixyUBv7iFMgwOWb0Beoxn4NguFyiZIWAc2/S6ckLonoYRvm8beW98ymi2JxZ0ojqFcYyYZjv2ig4zT7HECPuNKiCtMjSi1Te+mgdFoXnfiI5gVCfCTW2TohKg16kCQnPe/vbF2ipbD4pGeQ7+Y3WlFoMMqujnm15KVX9Fd6alrH5HYEOEuq4AA4t2AUIRGgGEVTROsG4zodWLNNTYJRNBecF3VR8sI+UFrlX5IL5FzbhLW2MirbBvFvgkQfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KMdG/m00SpWq/FdBhIMyXFuO8WbZ8wfUOo0Irp92YkA=;
 b=KcIlKkbv9mGFqW1Iv8Y3dYi1gkEuuw9bPomW5jtRWpR9L0yW3F6oX1wnPPAC5NJT8dkGb6ltEK6zo17V0z9yMHQrNpJMXXX2kTWaxF/XIQwOEDvHwsGvXF4+Pj6YviMdumz/ra9dxQkMZM13iexeiWMQneLYqpyfhQo68B0iX8FF3/HH2+id1wF3yrmYW0LHxwZb44qnbn0Vi7NZyWezXtSlBxKybMpQeNS/X1J6pO0WRRDwTenHyVguaUwTKxN6t84kgufK6tFgAuSx+VU68Ae7P77jd5om4mc2rDtavxYHdk5lXKIaCJB8YuTd5UnqLajo4AdUgC13obwBjsgPdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMdG/m00SpWq/FdBhIMyXFuO8WbZ8wfUOo0Irp92YkA=;
 b=D8PLn0QknjQnVIa6Og2bo7EqOL1px40jH3HmRoDwvlCvn0TU+sJ2dNm+XyYpPqeXPYNw9KKqevZ7UmcxdwNEsFOMdonYkj89niaQHTdKjFUdPgWsZoTJbcj0LFNysQguA2yWgWG5wD2Z9SdOCmq0r7VCc6u6B6wLUZk+hojY0CnyxCFNF9pfQTz9k2qSwVfE9ftuhu+clGuK1ihX8ASb7ekYiz58sFnYyfyUMsO0tuoTtkNHiX6dqaIYx8oMHmFvzLdIEwmek3hOpsF854fR2LTm0ADgTN02hfK7eIhdi6ju8fy3OQ47w3gAJluWV9AfmUGRSJ4P0T/6Jl0SuDtUPw==
Received: from BN9PR03CA0486.namprd03.prod.outlook.com (2603:10b6:408:130::11)
 by MW4PR12MB5625.namprd12.prod.outlook.com (2603:10b6:303:168::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Mon, 6 Feb
 2023 15:39:59 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:130:cafe::d) by BN9PR03CA0486.outlook.office365.com
 (2603:10b6:408:130::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35 via Frontend
 Transport; Mon, 6 Feb 2023 15:39:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.31 via Frontend Transport; Mon, 6 Feb 2023 15:39:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 07:39:44 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 07:39:41 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Jacob Keller <jacob.e.keller@intel.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Danielle Ratson" <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 0/6] mlxsw: Misc devlink changes
Date:   Mon, 6 Feb 2023 16:39:17 +0100
Message-ID: <cover.1675692666.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT039:EE_|MW4PR12MB5625:EE_
X-MS-Office365-Filtering-Correlation-Id: d177a218-3ad8-45e5-c368-08db08586786
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VU0igLEzFoMj4uuaLPqGgbM5ctPIsL/86FO91uLfX93f6gcoW9cV3RDBxo2htrPjanOpH/Nn0UJwKb9LXRe0lTXB/u/E7Wisp18/mLOBhVDzE/K8C6yhoVCTGy3R8dzlqgmlmDlCLHUe0Xn0WNcxM7rniyAA2rHCMziWZgGZe632Ip005ra5nT+0CQnuqWopef6zncRdLGp0QgtJrldIIFrVEFLBsHhmy9gCs9U1DpiLbsXrxPdlzGNPQTDGWYWZuhAd/U02pisNpoaFRtJt+Sq0N2kkF1xv2RBi5yJC6R1BmADff1fcj9VO9U8g6K4ty3lhEpI2FhrojMoWQtkMDh/G3SCxWR69GSJksN04Ko+445u25EapNGqewhw56pUHELuro2xUo2TdxO5bkY/Z7DKGnmWl/w0X2KWloWN9nK7UhLdRLZqdn27eOCYYkrNR0RQ+JgBFsC01R96aaxsCbwV2zMJ/BNdt/A6ddCSsVlinbuahQZjeBB3SlBmX3C2tBVtTF//xILhYPoPwmKOm/NL54if70RxzNgzl9AQ06huDCOsBjRrzxtbwcX+nQU1lQJ8A5HHfZCq1s1aNYBjWNHvl0uGTsTr8KNNRiRqxHTL5AFu/KDxJ/QoijKyWHchx8R9S/5EoVPI/2DmpzKOE2WAuab1B7tQSnR6DHaI1V85jXB7qAEFd9h1rHk7gWsN8yRaJ0LW2obf4aUM6rIDxLA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(346002)(376002)(396003)(451199018)(40470700004)(36840700001)(46966006)(54906003)(110136005)(316002)(107886003)(86362001)(6666004)(82740400003)(16526019)(356005)(186003)(478600001)(26005)(82310400005)(2616005)(2906002)(7636003)(5660300002)(83380400001)(40460700003)(36860700001)(36756003)(426003)(336012)(40480700001)(70206006)(70586007)(8936002)(4326008)(41300700001)(47076005)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 15:39:58.7899
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d177a218-3ad8-45e5-c368-08db08586786
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5625
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adjusts mlxsw to recent devlink changes in net-next.

Patch #1 removes a devl_param_driverinit_value_set() call that was
unnecessary, but now additionally triggers a WARN_ON.

Patches #2-#4 are non-functional preparations for the following patches.

Patch #5 fixes a use-after-free that is triggered while changing network
namespaces.

Patch #6 makes mlxsw consistent with netdevsim by having mlxsw register
its devlink instance before its sub-objects. It helps us avoid a warning
described in the commit message.

Danielle Ratson (1):
  mlxsw: spectrum: Remove pointless call to
    devlink_param_driverinit_value_set()

Ido Schimmel (5):
  mlxsw: spectrum_acl_tcam: Add missing mutex_destroy()
  mlxsw: spectrum_acl_tcam: Make fini symmetric to init
  mlxsw: spectrum_acl_tcam: Reorder functions to avoid forward
    declarations
  mlxsw: spectrum_acl_tcam: Move devlink param to TCAM code
  mlxsw: core: Register devlink instance before sub-objects

 drivers/net/ethernet/mellanox/mlxsw/core.c    |  31 +--
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   2 -
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  62 -----
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   3 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |  21 +-
 .../mellanox/mlxsw/spectrum_acl_tcam.c        | 244 +++++++++++-------
 .../mellanox/mlxsw/spectrum_acl_tcam.h        |   5 -
 7 files changed, 161 insertions(+), 207 deletions(-)

-- 
2.39.0

