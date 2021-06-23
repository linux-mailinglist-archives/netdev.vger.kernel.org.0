Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF42C3B1B68
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 15:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhFWNpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 09:45:40 -0400
Received: from mail-mw2nam12on2086.outbound.protection.outlook.com ([40.107.244.86]:7649
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230274AbhFWNpi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 09:45:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l9mf/WP/LF6snKT6o5UhO8EfRBHLJ6QGgvLWqn0eEMIjnpb1AJ9yhnWdE/5TSEBp4BErXBdO8XGD7jNeuxcX+yoUoPFkSkbcn0B0YaDh8h8y9b4sWSXc9uziTujkzLQsOBR2zeXH7Qz96mdjsESoKKHjcFTx8We5M7mEAqHu4i6uZ3EdYvu5BtShkaQVmBXgXdIyH0bTGn7NfEZ0XVyhyAGgBb97lGD4jrlE48UIyoe/RWrH0kfUIvjHWCUARFdi29G1LLLOKHo90BjQPuinmMgwADMaxEuIhbLk23uh9d0TvQBHeHc+3Le9XUCvtt0pZ2yJneKF6rkrxAS1gE/O8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3fS5Nr76se9tsqMcdw8y0cMc49/VYzmxics71kL0Es=;
 b=gt6skged7ZK7pS2DGoMsyOVQDprBIANpvrbguue4fTlOppwaI0kuf22lI0MEPjd53Iy2ljkD8Fz1eQAv2P3COIxDfj1Xep5jZ+5Omw0tuAZpGthIE+7vis0Oq3Nh0PdRQ8DOQZjESuT8gWz1wgUjyuqB1/QaDac+qu5D3FwT1NP2O/ZF6f25ON0lMfeMUr17SZruA5JJe+Dq6NHwa/XStsgLP8O1aVyHYZwrdfzk+QUDxLfzCNZVuH0giCA/eukUP9eAB8l9wQjJvQSLT2K/uIcQEDQ6RgZ2l9oYug2wz1RKLgfzxMtloAtEPDo5kYs47o34p2DSfJ1quiYwMt3h2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3fS5Nr76se9tsqMcdw8y0cMc49/VYzmxics71kL0Es=;
 b=UC40c8DNYdaiGq/DvMymd0QI+nwpNxMGLLU9ngfq4Xu4Q7kvTbqakk5nA9F87eOKaMCtndgiiu03hNyB1Omv57SGcV4gjK4QYk+vZBPCpWyTWorPlPdCsvy9J1YAGrvyvCO+qIISFSb/9gF28d0NCXPgobdFQmW66qHUTEQp4F8BhSACouA12+SsSHF90g8K4Sz3E1XFstSJi9TyvIxG3IhTrHdq/kdEhfO/5t3cGt3JHCF+0piVMVbcsRMCwNeEY8GG09rCu2O8zUuQqcFWPJBDOFAZNnL0S/11QemlBJ+FTlfmc7m9LqYZrlF5swAhCgbCXsaeMsaEXkxdeH4G0A==
Received: from CO2PR05CA0066.namprd05.prod.outlook.com (2603:10b6:102:2::34)
 by BYAPR12MB3639.namprd12.prod.outlook.com (2603:10b6:a03:db::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Wed, 23 Jun
 2021 13:43:19 +0000
Received: from CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:2:cafe::8d) by CO2PR05CA0066.outlook.office365.com
 (2603:10b6:102:2::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7 via Frontend
 Transport; Wed, 23 Jun 2021 13:43:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT012.mail.protection.outlook.com (10.13.175.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4264.18 via Frontend Transport; Wed, 23 Jun 2021 13:43:19 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 23 Jun
 2021 13:43:18 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 23 Jun 2021 13:43:16 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <parav@nvidia.com>, <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH net-next 0/3] Fixes for devlink rate objects API
Date:   Wed, 23 Jun 2021 16:43:12 +0300
Message-ID: <1624455795-5160-1-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fd23ba7-f721-4edb-287b-08d9364cdc6d
X-MS-TrafficTypeDiagnostic: BYAPR12MB3639:
X-Microsoft-Antispam-PRVS: <BYAPR12MB36397C71E4B427EFA6B9F88ACB089@BYAPR12MB3639.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:120;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1SL+KBLi57/f8hU0BBetjXLUGEwMTAP3dNwpvr0NeFK+Bg30/mxUPeS1ivYBFBFn/yfOVxPwm5YwLPfmie3ig6R0dfHA3sJMP1uNbhSC7cfnwdsKjInFksQwqv8aGMrg9EjBT8K76KuNyB3zHrrxYwhVCqJn4HUX9YgRSZilnGolJ+7ELcLlrzxrL81tK0Daas3/GIvHD5c6vtAW+1AJTO0bpvp4jl93MqbonJRW7A+4YIzmhFLxgehYBr/q/gwKRSUaL7JCLI+J3xjTJePUBpvAGgn4dA45J2MfZjb4dTkVOwrSqvdoiaUwP/gQvpnY5t0ZPYiaPIvrTRspkKiXtHk3l4DgG+qDx0sWv29AlXRW0a+aasGgtl8kV/DnPjrHedz9zr2RC70tH8w0l6Mq7ZNv6BVVvUYhS/usSKaVOZyoGyMvyabMCnqZV32Ohm+Hzjz8UtKIPuutiU+wzcGcHgQVOQ3KA/bOMnvnlpoO5J+/wHWdds5WRb+3neKSTs5FqRKHMNvZqqLbHx7cMsmiAnAgKU/cTEn7E7QvXCnVfBLAPkNMvDrRdQ9qKUBItoGIQYuEPSEU1gToJqR1Z6Dtdh8dZSWY8SANMlqgXCdO+vbTdvWXI8Yifv7dgn0ckvB/4ovNhqvfrtf/fs9tfhmSKGWSMHhPAb7A5kDuXow8BcA=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(36840700001)(46966006)(47076005)(86362001)(426003)(5660300002)(36906005)(336012)(316002)(36756003)(2906002)(7696005)(2876002)(8676002)(107886003)(4326008)(26005)(2616005)(186003)(82740400003)(8936002)(6666004)(70586007)(70206006)(4744005)(356005)(6916009)(478600001)(82310400003)(36860700001)(54906003)(83380400001)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 13:43:19.2122
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd23ba7-f721-4edb-287b-08d9364cdc6d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3639
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Patch #1 fixes not decreased refcount of parent node for destroyed leaf
object.

Patch #2 fixes incorect eswitch mode check.

Patch #3 protects list traversing with a lock.

Dmytro Linkin (3):
  devlink: Decrease refcnt of parent rate object on leaf destroy
  devlink: Remove eswitch mode check for mode set call
  devlink: Protect rate list with lock while switching modes

 net/core/devlink.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

-- 
1.8.3.1

