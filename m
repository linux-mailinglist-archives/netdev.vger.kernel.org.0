Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF535A8B3B
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 04:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbiIACLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 22:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiIACLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 22:11:05 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A78E42CA
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 19:11:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZ2mNfDTib85FgVvAfGGWISQCjutkluELSYzw+rK9t/EBMeJ09wVmK51JqyUcJUZ2ZPUBZED9SiGAFFrk46Wdx9PSAy44fkPN0yehjIu5rixPzYiQLPFVmPWdRoKGn5zJQvJ3tv6aPVfrSX5WJEiQ+mNkAOY5RhERVeuRAkCy7bGOnQCU25X/+DZj2Yeqq2ZE+Oz6prPO3JGuogpXBn5idR80OiUCagbJa6YCobmPz6/rlSmksMXfSnBGljw5X4OQokONMG3VVrKs9TiWVTPUTsxXqVRJAPn9RF31yuRJKd3DiQb2Q3BDm516/7IxZyMm3cjY5EL4OT5JaA6Yy+aiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l610MN/Cc7d6YBUHIUe6/7GnbyR/mP/YRiWe+LQFMkA=;
 b=eTsgdlI6mhxBHlBya4eG1W6Y0jpmZg+ASv18df4LR755gAor3xYgSPKduQ6W6730NPvFuKuiayaxUaa1UNJ54ud7izi0bldvxgwj0H7GwsbezigYiwNqeqD/QuHu2jBKwdP+Cn36DjuhtWlU8Cnw9KBDiQo4PjZWdPP4VVgbXE1aBwWkL19pdc3XGowrvqgESjKp6aM5PVzHtCJD3J4snIzyF3ubbWhFRFSuj7ES62u5ftdi+pDvBBFSmCMpSViDR2gGbAEhgwFWEzboSpK0FBW+Lp6Fz+xmISEZKGS1wr+nNeOFA79X6HNTsojlNe2A4SLMxNc59Vogis1y+PD8hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l610MN/Cc7d6YBUHIUe6/7GnbyR/mP/YRiWe+LQFMkA=;
 b=P6kC+LTVkJsrvRa+qP/1ozcz2QWzvKpgDSkGppQ45RlCwGrJeS0B+a/A5p/FwbDi85uvhxG6zEB7CWRTNaaYLchtHtv4/D7cvE/02nCYpbuYYr7CyBeBMHM6pRoU+e46q/BUW5pcgo5ENRU5RNo15djKLPRBBmMz7iAAz1a5H6W1SzWKWbq3yCnSkMqkbpr0xlUV0OVpGaZMj8pwzjjoLyE+P6nc7QCndyIVR0OiWHRzWmPRs20M/yVokk6yPhzBE2CZAV6xwJ7XO2x06Y5+1gLTti2nzbsR7aFcRZUXegUktonw5Ba7hs38kqZzthf2EkhOdi/p+L50Qagak7zxOQ==
Received: from DM6PR21CA0024.namprd21.prod.outlook.com (2603:10b6:5:174::34)
 by BL1PR12MB5303.namprd12.prod.outlook.com (2603:10b6:208:317::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 02:11:00 +0000
Received: from DM6NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::71) by DM6PR21CA0024.outlook.office365.com
 (2603:10b6:5:174::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.6 via Frontend
 Transport; Thu, 1 Sep 2022 02:11:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT103.mail.protection.outlook.com (10.13.172.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Thu, 1 Sep 2022 02:11:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 1 Sep
 2022 02:10:59 +0000
Received: from nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 31 Aug
 2022 19:10:55 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <stephen@networkplumber.org>, <davem@davemloft.net>,
        <jesse.brandeburg@intel.com>, <alexander.h.duyck@intel.com>,
        <kuba@kernel.org>, <sridhar.samudrala@intel.com>,
        <jasowang@redhat.com>, <loseweigh@gmail.com>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <virtio-dev@lists.oasis-open.org>, <mst@redhat.com>
CC:     <gavi@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH v5 0/2] Improve virtio performance for 9k mtu
Date:   Thu, 1 Sep 2022 05:10:36 +0300
Message-ID: <20220901021038.84751-1-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 431317af-cdc8-4d66-4afc-08da8bbf36ec
X-MS-TrafficTypeDiagnostic: BL1PR12MB5303:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A6fr/dezr04J9sPhN+cl+pkAgxKpwf31Cslz4QFxPHk8YuOQRMW5ELtyEdrBqce/V1DK75ZsxUZnfnM9zVEg4+SO/xhXbHasQmZtmwUQWoy51ZBRqobqZMHStPu6sV2ijUEKv44RY7g7SoTvlllnni9K41lxeURAYw5sMCqvLE6QoaM8eUI4OjYZlCip5x2UxgW7b7BTn1ASsr8S4KI5rSzWrwwXafnVUz484b2jwaMz7YlSGJCbYrZ28kA483ocEdp6M3cq6PPi8kB6kAeIpM76oBQZFGkOMcrksiEjUErNB0WNp6NCXLk4eFTjSo0hgiq5C7+BoFdRIfRQmsJCmqOmDvCVKZx74S5Q/GBUXq3LuB4igdTDalMH8PvRTpX6TAwjHiY6hr5wham6ZIea0BM8AKSov+Kv2Mp/gPuIgk52BlBp4ZkU6tXblolYr+btJWueqgtWtk8I2sW54odELrJ+2con+pKzYW8CK4WEduDcTKbHv27qHzFtQvxCblXtud9hJPtrUj0/3YSi0v8tnUMTlGEWYctUCE0m1y8R8soOdDDILnEnm3t4IYfgNYupMyQmMYE8GRDQFrjXZhKvioLmUJeRSH6Y1/TJOnPwUj4MNbRHARFZnn2gWNVMYpRX+pmyhZ5dBZAlB+OzClFlo/Tw8Sox3QkS22MJsLRHtd4VED/y+qlhGFuuo3mc4ur64r1TVe/YPurObq1dmpX+2yJD/ZPkBWcWUpI/HZMpqPp8Yo/+vbmLtK93BwNpOoF86OrRcL70aULTcEai1Oz3lMZblazl128DxQP0Yk8bSowJxDnNafCFLqufPMc7HgcK
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(136003)(39860400002)(346002)(40470700004)(46966006)(36840700001)(7416002)(4744005)(55016003)(2906002)(6666004)(107886003)(82740400003)(40480700001)(110136005)(336012)(54906003)(16526019)(41300700001)(47076005)(426003)(7696005)(316002)(40460700003)(81166007)(86362001)(82310400005)(83380400001)(186003)(1076003)(2616005)(921005)(4326008)(356005)(36860700001)(8936002)(36756003)(6286002)(70206006)(5660300002)(26005)(478600001)(8676002)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 02:11:00.1566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 431317af-cdc8-4d66-4afc-08da8bbf36ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5303
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series contains two patches that improves virtio netdevice
performance for 9K mtu when GRO/ guest TSO is disabled.

Gavin Li (2):
  virtio-net: introduce and use helper function for guest gso support
    checks
  virtio-net: use mtu size as buffer length for big packets

 drivers/net/virtio_net.c | 48 ++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 16 deletions(-)

-- 
2.31.1

