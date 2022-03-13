Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D2E4D754D
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 13:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbiCMMsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 08:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbiCMMsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 08:48:32 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C77360DA7
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 05:47:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLWDIk11X6VCYfrUTx9NuyMJFMVaiQjTJ0SqjpNIZ6nhWmNXrErpRBQ0WyecVSdOmoGyXpGJejOpa7gPZTsjNHVCiko1eUWzJqgijptjRv8ZJZ6yO/GOS1q0q+I4zZM4X/IsO44pufyKWt35FqH8MKYGCDt2GlrzzC3bnfQmFilXHCV5WLVZ7OgdJVKOMSaKg6RJCT3zNvMvqek5G2XysAuY80ZgUjfvlaXndfXwUXIQlhWaaqj6NNY9JFNPcDNFEwvrclFHHFSK6yhAOzBA0boOOtiswm44qhj258J6W/QbzXBviDW8oYx7CVuqSPhFCGGpGNC514jRk6822VwU+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DWz1I1PEIcg2MVoWmmzrvPpbZiYKD4Gd7egT519yN4A=;
 b=NybR2rAscnzeMxmU8x6O/qW0oE6IYhL4zYNVuuI/xkdJm5zTwvuYtAsWW7hFKkzJASf0qEfw4A24MVLUv9FYnASk3t4XGOEmTehad7YQOQJON1y/R0sKRsw9E+hSE6hbviRI0JHcoMWnCq1PQSKFTqw67kNlvfvfzB7jZ63lETjKwW7VBrel+GwnS/PT+EVLKbuPUb8A+P02bR4CvBRd52SKvpHgQKG0PCnnd1J8+4NECcK8ppDN7NdgAAseTqoHjfe4Ug4y0nlRNdautrBQTgt2i53/rDwBncdEZoHNQKxUf5hz1K37Y3kd8pqYI2bySSc7/lS6z/Ah4Ci7oSiXNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DWz1I1PEIcg2MVoWmmzrvPpbZiYKD4Gd7egT519yN4A=;
 b=rGMnDQ9MtCG9Hcg29uXGOX9ZVd0sw7O2O9T6M9UvBKHuBqpKQS0Z5W8DgnW7YqYInaevQsjKziNflKYnw4/XLKAF0ljSYTckv+ivX/Lt8AmDg98f02Ey3BrPwtgv4n7gQ1GwUH4BhuP76LCQncRB5q0UjIdJ2QYM9tEEyu3s35zMCwdo/wvJlfSSjrZvq7ZC35EZSbkkR6ZcLC3B7wXzaoyD12lbZuvDGJGz5ezCeAYKjFFg8Fqk88Tsr0DmSOwG6MgK24e+TfLH36h0BmuQqJ3MV84vlpH1+ZF7fscRD8FqORblm09Wm4CSz20yz8YpVpOGBGk5CKKqqjr2rcQp7A==
Received: from BN9PR03CA0435.namprd03.prod.outlook.com (2603:10b6:408:113::20)
 by MN2PR12MB3567.namprd12.prod.outlook.com (2603:10b6:208:c9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Sun, 13 Mar
 2022 12:47:20 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::b) by BN9PR03CA0435.outlook.office365.com
 (2603:10b6:408:113::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25 via Frontend
 Transport; Sun, 13 Mar 2022 12:47:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Sun, 13 Mar 2022 12:47:19 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 13 Mar
 2022 12:46:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 13 Mar
 2022 05:46:35 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Sun, 13 Mar
 2022 05:46:32 -0700
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>
Subject: [PATCH v6 0/4] vdpa tool enhancements
Date:   Sun, 13 Mar 2022 14:46:25 +0200
Message-ID: <20220313124629.297014-1-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d315729-a8b9-4435-1fc5-08da04ef9cce
X-MS-TrafficTypeDiagnostic: MN2PR12MB3567:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB35679FAA01A1A1863836C684AB0E9@MN2PR12MB3567.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VHaYcylUIw8+HMvDvKtTeAOTThGQVwN4UNu7lmK5+lw/ErB9Usml9o1hNseEvigff6sl/QjJkvAYFpogExSM9BdR41wSySjCRB/NPEXpi+WJ+IkoMkhg/MOAIfPZIcJuZO5SkaisrDinu8r6QH12HmnqdiAhnN5UMnNieStEr1+m+aZRZPQdVoEHqB7v0f/qzB/tsp3LaVVwtOzntWQwnStmq5bwKxJ0N46eAtM5g+RyCzmTjTOkt18eh4jE7I1irc62i3AiwW7nMdOet8HareTRpKg09zk2m0CTyzlOPynXWtOMyy+h2a/MQXcF9b7CHy/UuOCG9BTTNHxWTDIr8SitAlKkht4gY8rjJnJ1VPN4hWqcUpaOYM2KEoxqxej4GzN+uv9qHGSdg/LKZCClD53L+VLLLmnPpqTqEMob2sSSwCMb8y+3G5ETDvuHBgJvylkvKcJgjUZE/nqHhTza0odwXSVSpgXx0S2txv+QDM6pXE2lcYAYNcEOlkwyPVLLjTRgLwfikb0FCsjnUFg9Jv/EaXv/goY1g08wLHInOOIZCtNmWErHQnDPgDGVjZt6K/V1SBGKtA8dQap1KgD+Cp3+XKHPqSFOeoMUczUG+kJaKPe759GGYyl5g2a96aQfZ6x/wSaKXHrJO3EwFYAyFXqJDjIDyTCjKeK7c5OUbCt0HlupI24u0ZYuAoZTuqDezJcAybc3qc4Iy0wsz7gcJA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(2906002)(4744005)(40460700003)(36756003)(4326008)(7696005)(2616005)(8676002)(81166007)(5660300002)(70586007)(70206006)(8936002)(356005)(86362001)(83380400001)(426003)(336012)(36860700001)(1076003)(186003)(107886003)(26005)(316002)(54906003)(110136005)(6666004)(82310400004)(47076005)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2022 12:47:19.9076
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d315729-a8b9-4435-1fc5-08da04ef9cce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3567
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following four patch series enhances vdpa to show negotiated
features for a vdpa device, max features for a management device and
allows to configure max number of virtqueue pairs.


v5->v6:
1. Use macro to define number of feature bits
2. Use print_nl() to print new line in non json output.
3. Break usage message to two line so resulting output is confined to 80
   columns.


Eli Cohen (4):
  vdpa: Remove unsupported command line option
  vdpa: Allow for printing negotiated features of a device
  vdpa: Support for configuring max VQ pairs for a device
  vdpa: Support reading device features

 vdpa/vdpa.c | 151 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 145 insertions(+), 6 deletions(-)

-- 
2.35.1

