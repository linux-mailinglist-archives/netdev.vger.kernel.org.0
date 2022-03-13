Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DBB4D7731
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 18:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235122AbiCMRNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 13:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbiCMRNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 13:13:35 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547FB139CDC
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 10:12:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XA2irtCPzRKbEDMKLu/iv0aKwlLmPiWnQ7C9Tisz+QZ/KamTf3oR5sGeXt6kRYKGdmmJZEysJEEoZTvSoRY69cRqnn7OBGAItc1e0NIDjDyfsexPrGiFmlx9kfoO/D2aoOpNW/dfA07Y89YSABFDeEiiexY7oluDfBOHaqMjGE/vUSIXcI9wvbhXvw1ZklfLzxceFB1uC8uH806HZi2B/CHudMAMG5CMcWhLoKujcCKGp6n+9vVFrPEiQlh8DxtWAqK6gF6zcS/V7gMJHkqOIo/3doN16DrvkKWu9D9ZFz3/oHlxelXYqHovKvAM25PU5FEk2JPe+OdGRAC3PlaRrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KApaurkjwskNQ2kmBpw1e3fuIxl5+nPJSJGZo4kul3U=;
 b=Hr8BsrFvHL3XEP2cI7z1OFt9azpiSkk0vwKbkrPc/x3pL29gxy6EdtuLis/V8/X87c3c5qW5xamVqrmPcTeONUkEdsnrmDJRqk36tWj6FWoH7lYroAlbsfOQ63M7/Jr3w4UxgBrcSMGZTInoci1wOEH5GG0G3QlAiS6UFZAqw8M/kpUbWy72t088S+llPbAelEm5ahlG1nT9vlCdgUPgJ+G9FC5Hya0Ulza2Agi+J4ZlGqdQ8wCs9t/VbVIHrQEvYvrmGuINqinq4optxZZC0OEP1l/jxsZrmG/7f90r4FqS0VqPNHdRgjGMEq/g5nvQAbo8txX+0BqeYAaIhXaKlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KApaurkjwskNQ2kmBpw1e3fuIxl5+nPJSJGZo4kul3U=;
 b=pefXpKVb033YotRKJsWSWCML+GUjxajj30pImd5R3NNsEIkiKCJLB5k+8zC6jlTq+rfqg1uKGaS44SQkQxXRSEZCaj6K/dZsqG6MWUZqHW7b9rH/F+cyCOdNwjFcBzNWaRsdB4xx4NGxmLDgtT3fgkZ5rmiGpG4pAtxu1Nwa/MzmDgYkHjuscfMh2IWwRWkhplyK+D+RMOWfkOdgNoIh1QYbF+YA0C6L4hkf8FcEPbdqS6ycd1WbRH00ZZPG+XEmhjqFud06WfXCaVG2aR3tVfzJyoxRsuxgxCLaarJywPQt8SxG+TPlbvCavuSL1yXicX3l1LJf+kSO5GykVwUQ3w==
Received: from DM3PR12CA0137.namprd12.prod.outlook.com (2603:10b6:0:51::33) by
 BL1PR12MB5159.namprd12.prod.outlook.com (2603:10b6:208:318::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.25; Sun, 13 Mar 2022 17:12:26 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:51:cafe::aa) by DM3PR12CA0137.outlook.office365.com
 (2603:10b6:0:51::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22 via Frontend
 Transport; Sun, 13 Mar 2022 17:12:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Sun, 13 Mar 2022 17:12:26 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 13 Mar
 2022 17:12:25 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 13 Mar
 2022 10:12:24 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Sun, 13 Mar
 2022 10:12:22 -0700
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>
Subject: [PATCH v7 0/4] vdpa tool enhancements
Date:   Sun, 13 Mar 2022 19:12:15 +0200
Message-ID: <20220313171219.305089-1-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c835d4c8-1561-4038-3724-08da0514a5a6
X-MS-TrafficTypeDiagnostic: BL1PR12MB5159:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5159EE644E1BD4755553BBABAB0E9@BL1PR12MB5159.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bPxxJgeDomtRiCEB+XqLuzvcjrcBWYebG4HQUAW0eNC0zfCJwugR3RYAGc6kFvN4+PJ/p9cPEgshefvfui7QgjRkXUK6/KuVvdd+FtA8xQk3DKfCoH6Am2UTWGCNGh2u8wLdQV7itp6f6U7ugfjJLtqIpDVWfGeohkF1/f1szWWT2OxlySgOqYa9AoLqhcVvK2ZdnwSwyXy2A7WLlounCXvU9n1pKJSxGTx2Fyl4gYQrKtBQNk6crbpDarx7iyhdpsv2pkdJFlbwLZTGP/NxkP/tBOVhAH992uvhF3le4yfH+uZffEnpiN/190yTZ4WU+0KyKZZqtUiHNDoZEPI0uMrJkOfy/IHCxchbpJtDxFTAS5/TH0yPG81xmBC447MBtIdCpvYaHOr6SZIkh3222LFP/0Ie7usMOFKGsun34JbZArMcrcdCX+qs17F1UH6uAKu/fBxRvwuJvIy6OIIp2wZJtLmFtZss+nVKLvVPjP0O6XexWB1nlUkkD9+H+e1+8++4J3iNUasXhbA0IgtFN1Dpnl3k8yJRlSeVhAho+fM+bPYBsa4Be6G/fS9afIrIkRLpcxa+EKhq4/YyidoF8n/OKMtfSg5qLsif7XoYAgf6kGowFpjOxtR+WaT/knt/AnemhescrXb6M14+IyGXtve6R0bI/a60gyPUQ1llid4fHmIPceOwfvCOdqsh3/dKtv2oS35jHmMfQ0YzCJ9Y7A==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(6666004)(107886003)(8936002)(83380400001)(2616005)(186003)(336012)(426003)(26005)(1076003)(5660300002)(47076005)(4744005)(7696005)(36860700001)(2906002)(82310400004)(110136005)(40460700003)(4326008)(356005)(36756003)(81166007)(54906003)(70206006)(8676002)(86362001)(316002)(508600001)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2022 17:12:26.1871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c835d4c8-1561-4038-3724-08da0514a5a6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5159
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

v6->v7:
Fix minor checkpatch warning


Eli Cohen (4):
  vdpa: Remove unsupported command line option
  vdpa: Allow for printing negotiated features of a device
  vdpa: Support for configuring max VQ pairs for a device
  vdpa: Support reading device features

 vdpa/vdpa.c | 150 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 144 insertions(+), 6 deletions(-)

-- 
2.35.1

