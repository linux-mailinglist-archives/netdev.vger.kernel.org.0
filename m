Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA34583157
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 19:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243090AbiG0R7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 13:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243114AbiG0R72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 13:59:28 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EA96D9F3
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:04:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JBjuV/98l2F/wJxcKVG2WfhS8DuK7/gLtRpBlfakgyur6tFzk82bgpaQO95GTILwVAeq+SmlPdJ2xEcQQgt1BGL/62fNti8J/+Do6wkc0HAQlKso+nVOsLpCrFD6qASn+u+FBFFK9eLGcAJCX2Ou5sjig1miES5sKwVsxq97ntNU5QIT9dKU0fkwkLuh2Q7hMdFOuFcEJJ30lub9P6Z0fwbv4OhgvFFb/fX4tS0F+J8vEJmQ5K11R0SHZkDy87rKjfEFtOtpAFJ8EaubjY6gGsz/kuqZNybBxvJG9hT3AgmY5AChqREtmQx4XO4KI1MoBHB5iMdBcdKoQZJt/AOwIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fZZtKQnybC3OXoaFzm9U/q5fMyJB/vWG0h0EilQIWQk=;
 b=HvGc5Tf22NRWMfcZdfLCWTwPo2uVzViFF69cSKjfOkhi5Yb137KpZnO7NTh/eIDLuDWSlQ7Q/HazwZItUX8vv8hqZbDfGE7fOFNdeymOY3jHGSo9x6WRfSStPta7k9LUCzdf2JvTUElCO6Gh/YDJkFQgGsMzrYy/w7MVfj+r6Scj0+lW6U/L6/4T3bWzCM3UJhLAhDAzlNM7zCpZ5Tl4qqg/NQCQSPdGJQK2U70ByALt4q1oeODi4NQlmlitoojH30CIg76mqqA1p151UzP+dvyw3psWIq5c3t9nio/bZxwhAOzMSbOZAGDkOISZC7LFBiFSLSgO+PJNGy7WouduXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZZtKQnybC3OXoaFzm9U/q5fMyJB/vWG0h0EilQIWQk=;
 b=ZMS1x3iU+tFtRlfci2R4rnZOMYhBU5KyOjjAHNn3OUs2/iJ6LB9n6sK0aLzloIAA/IMQ3QaK+7AOBmcx8HiX7skCxXHxDS/q4E4yytAghTsEj0OnKj18psqXp9B+NXM6N9oMXwTlUkqWBShSuxgC64V5ONDnxVTTVaUfXpOghjrhCmoeFEeDunwqtYIWRCoij9rhAsIoG4UjBvRal/oJnqVCYdo6NTsSqGSyYeFwkcBmnKfNt5aEz3LZPrXUrA5IhhFY5GFFCDFGhVWNmYYIr/fqPOtz5p9GrNbBL8mVtrZTJGx3sNnGdjKE1BVm9VIQG6taeMCdcFqwLQgwkQ2uvg==
Received: from MW4PR04CA0314.namprd04.prod.outlook.com (2603:10b6:303:82::19)
 by BN6PR12MB1203.namprd12.prod.outlook.com (2603:10b6:404:19::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 17:04:05 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::a7) by MW4PR04CA0314.outlook.office365.com
 (2603:10b6:303:82::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.10 via Frontend
 Transport; Wed, 27 Jul 2022 17:04:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:04:05 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 27 Jul 2022 17:04:04 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 27 Jul 2022 10:04:04 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 27 Jul 2022 10:04:01 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 0/9] Take devlink lock on mlx4 and mlx5 callbacks
Date:   Wed, 27 Jul 2022 20:03:27 +0300
Message-ID: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07651e23-91e4-42fa-3238-08da6ff20323
X-MS-TrafficTypeDiagnostic: BN6PR12MB1203:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JF8OaPKkQMGgqQYQbhl2vQi6zc7m5mbzWj3YARUlo9dWILBXeHaWe2Gh3yLB4HFowbfEFp5VS+NytAl1doLrCwOiGEMfZ92tpbtU9YeTrrA8WDl+ul8fmEawU7EKGVuSWKf9SwMNzSJFeIrStejdK/bP96qQN13BWevkwy/Oj+FWDHRR5WolYgsmF6sjUws7lY/XkACSNJYu4THzXMgeg0hVtQ+Ld7FhzKlKYNIY0cH5LhlFHSfI37hI6UdkOtHWPqIPumPdWCoGbVYphk/TTK2B5Y1IKoU8f4/A/bzFKZCGmn5fNfGqLaGc1lG6SpI+nEWcTUA79eR+h7FmcQnsq5gcuOTDcYqe9XFhYwe0DWLJBRgNlJv54E2v0p63Q72Eugr5oKCuUv6nZVZT/ueS9Ora1aG7Nzx/7mnbmLKZMDUCfOCL2Vv/PUfR6S79NQQD5m42liB0oY69EDJJWoV0FZ/2wiVNXJiF5c9gBcR7IiB2baKibCBdoI2wnVmCKaFYxWRGUwMW+piJcM9ov5f1GnQbjGciBpEbRHTbFtXNguyG9fOJiciLgfiXlQIi/QEqyr98IwzXbxpBik3utvtBZ1oUI9eXWn/FyaQMLzTYKZpQ1r16sAFOyf4mdjRxJc07S8YXM+KstsbMVOz72L6fScr21CnJoHzYpc8r9w2OZq/ybQRbb/gMDJhsWpqAwNY7ZFkQ2Vqstb4RYnzCVZzlSiIdeDr40xSX7dv50E4vA5pv4sxm9VSnqz9pqZ3a1o8rgWhZbLe3CkTOfsyxMa3nnKRVL77M6UnWuVJhWGJoRm07VNSFp6e7PpoOJdmueRCg5Uj3bZx6/JrAGFTeLASuSw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(39860400002)(396003)(36840700001)(46966006)(40470700004)(82310400005)(6666004)(47076005)(186003)(86362001)(316002)(36756003)(41300700001)(107886003)(83380400001)(426003)(7696005)(40460700003)(336012)(5660300002)(356005)(2616005)(4326008)(2906002)(82740400003)(40480700001)(54906003)(8936002)(478600001)(110136005)(26005)(70586007)(36860700001)(70206006)(8676002)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:04:05.0816
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07651e23-91e4-42fa-3238-08da6ff20323
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1203
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare mlx4 and mlx5 drivers to have all devlink callbacks called with
devlink instance locked. Change mlx4 driver to use devl_ API where
needed to have devlink reload callbacks locked. Change mlx5 driver to
use devl_ API where needed to have devlink reload and devlink health
callbacks locked.

As mlx5 is the only driver which needed changes to enable calling health
callbacks with devlink instance locked, this patchset also removes
DEVLINK_NL_FLAG_NO_LOCK flag from devlink health callbacks.

This patchset will be followed by a patchset that will remove
DEVLINK_NL_FLAG_NO_LOCK flag from devlink and will remove devlink_mutex.

Jiri Pirko (2):
  net: devlink: remove region snapshot ID tracking dependency on
    devlink->lock
  net: devlink: remove region snapshots list dependency on devlink->lock

Moshe Shemesh (7):
  net/mlx5: Move fw reset unload to mlx5_fw_reset_complete_reload
  net/mlx5: Lock mlx5 devlink reload callbacks
  net/mlx4: Use devl_ API for devlink region create / destroy
  net/mlx4: Use devl_ API for devlink port register / unregister
  net/mlx4: Lock mlx4 devlink reload callback
  net/mlx5: Lock mlx5 devlink health recovery callback
  devlink: Hold the instance lock in health callbacks

 drivers/net/ethernet/mellanox/mlx4/catas.c    |   5 +
 drivers/net/ethernet/mellanox/mlx4/crdump.c   |  20 +--
 drivers/net/ethernet/mellanox/mlx4/main.c     |  44 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  19 +--
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  59 ++++++---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  18 +--
 .../ethernet/mellanox/mlx5/core/fw_reset.c    |  10 +-
 .../net/ethernet/mellanox/mlx5/core/health.c  |   4 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  38 +++++-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |   6 +
 net/core/devlink.c                            | 123 ++++++++++--------
 12 files changed, 219 insertions(+), 129 deletions(-)

-- 
2.18.2

