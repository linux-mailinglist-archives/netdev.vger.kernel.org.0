Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C874ABF3A
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447890AbiBGNCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447275AbiBGM4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 07:56:20 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA022C043181
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 04:56:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YzqYUP683DnQFN4f64OxmUTHDGF7/L9vaVXWY5qq2D94osLHPm8/JxpTMbp5cWFklAQy65doA7wktzekbeHz0fVN4QZsemDYPToRFeyG5HYqUZuJ5DlH/9xteP2hT7Hpv3pLa9sn6e2X8xaIwPMzI9iPZMxKOj4vEsSAuDtoP1x7Sil+yL5UY64JXdtwt1Vh/3A2PQlU+JQtJdd8Ui7Tj1n4cgHBV8j3wAogsjC2tVl4MPd63Pl6579wIwnuvB2Vn7ep+KZo9c9+telMK64zeXlJRZGZ/VKA7Eo9J9/EMtXBIPnHGjyEy2O9J9hfO4B6Gp6EiCg0SJ/OhSv8/4Yr8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sea60hjWDy9yRCNsnxMsPkYi6ukLm7qKYdqjhe6Ep3A=;
 b=UxhqQBl7zIfeyNsrt2M8esHBjy/aYM7Xz031BcTbpWitAs2KkUGMSkVsU8aqlsZ2m5yiZ0FkxuPcCUSGlq3nIz9O1fPVQoAdHcigLWz6fCm+zH8ayo95lcdfA059aCgErICvaebTNtRge5ICeoNDo/HOC+Cdb8YdrQHhPhuk4yQfdJOce087x3QxtDmO9ikBvsiHcshyFpthrDh0d/1a6atb9RF/NaOKJoN51eq5gHy4asK93uXTMDx2rTbAJnjLiR/aZDDA13YCGf0RKF60tNJgmNJlkNkYt+l44P+lLOjE1/g5CIPu5H9sY6KcvW42LHv4Gg3g76Z0nR45y0w/Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sea60hjWDy9yRCNsnxMsPkYi6ukLm7qKYdqjhe6Ep3A=;
 b=kHwUQjZI5DdGTxccXTyx6d7/Kr24v4sEpii17nh8AH6kyq2ZZKMMZQyLRSs16ggEE+i2FgLVsHBjeWQNOe2hv+3En9UQWLPzRoneCW+bzNe7Pls7PHQTC1pEeJU0rV6a+S8B71xsRjUJZYgTLHbW2US64/1kI62xTKMdh15RA0lMw3RqM1cC41ckKp+sbwBkq+NOQEoPPaW6jMLec/dqob0GRnmVIxjp7F36C/4LUD3yuwa+57SZ1/rqszX0GEfFksrym4GlppLiKr0iBRs2dGqiiBGTF5Tk3+oKVGLuNdLp8yN1DA/R7aXpcm1s2LPqebLpSbvQ0sPunUQTGmPvZA==
Received: from BN8PR15CA0004.namprd15.prod.outlook.com (2603:10b6:408:c0::17)
 by CH2PR12MB4953.namprd12.prod.outlook.com (2603:10b6:610:36::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Mon, 7 Feb
 2022 12:56:17 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::c5) by BN8PR15CA0004.outlook.office365.com
 (2603:10b6:408:c0::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Mon, 7 Feb 2022 12:56:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 12:56:16 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 12:56:16 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Feb 2022
 04:56:15 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 7 Feb
 2022 04:56:13 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>
CC:     <jasowang@redhat.com>, <si-wei.liu@oracle.com>,
        Eli Cohen <elic@nvidia.com>
Subject: [PATCH 0/3] vdpa tool support for configuring max VQs
Date:   Mon, 7 Feb 2022 14:55:34 +0200
Message-ID: <20220207125537.174619-1-elic@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdd3b6df-b608-4a98-264c-08d9ea393ac3
X-MS-TrafficTypeDiagnostic: CH2PR12MB4953:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB49539720CC43DC6914798EF5AB2C9@CH2PR12MB4953.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yqdjUmu0847U8UN1hUIuWBBy7PtZ9swDDwkoXFoOW3aa3Uvqyx9gj7JYKgUHaGJi/nTSYHWBGjG8TlEekGjiBoIjn6dJJB6HTfhwmiCVd8rGTnobev98p6P5gLQy4iBB/O7hGGqrmxIFFyg9n1TlvgASCbtEZX/mzgDfOXv64SxSFZ+9K1YpdcBQj2uAQjwP08FI59ZukEhRoK3b8mvPfMY3TL7ZTp0+VAUOozaQKTFuME8TfEfxee7irdwJaGtifR3crJy2LD2du/ZUzTU1z6BUxPlzSVFISWBHX5XbmDWdNcbzBfIk7mysiFlXpNrBmD8fyinZsKWnZ0i80tAwjkSne6N/lxS3GEwc8bJKe21ZIjGQk3U+tKvPpxyG7DSQiFLl9mL+hJ8K1EoKFbmXB2CJ7gw3MmRwkMV7oEfcG4hFyKguXXqGl+oP1vqnYf7KVZ8URr16GTp81utPos424z3Kw+PqNmwsM0JNnWvGwCMlANZTLiNSUyIfLaIgiEHZulMesZk/I2B5kTJNkkOXRTTdFFL8+mYAO+W2Dx0u4awMzfMrI1z2CrNdZlUUCFG3ybCnxtk44KLoQMCvNHcWQEjPHYXUvVXuSUWJaHdu463DlLr4DFaGsRAZYX9cV0aAM/nJxIcb/+rQ1s6t3X+TO0gBpdqRV9kR2Sz6DyuPXwdm9gcdxTLNMBOLHNU6QCE2HnM4YGglGjx0By+mTGY2oQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(47076005)(36860700001)(86362001)(40460700003)(82310400004)(81166007)(356005)(316002)(70206006)(70586007)(4744005)(5660300002)(2906002)(54906003)(8936002)(8676002)(26005)(110136005)(4326008)(107886003)(36756003)(83380400001)(1076003)(186003)(336012)(2616005)(426003)(7696005)(6666004)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 12:56:16.7664
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bdd3b6df-b608-4a98-264c-08d9ea393ac3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4953
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following three patch series contains:
1. Small fix to vdpa help message
2. Introduce missing definitions for virtio feature flags so they can be
used in the 3rd patch.
3. Add support for configuring max number of VQs for a vdpa device and
allow to get negotiated or max features for a vdpa device/mangement
device.

Eli Cohen (3):
  vdpa: Remove unsupported command line option
  virtio: Define bit numbers for device independent features
  vdpa: Add support to configure max number of VQs

 include/uapi/linux/virtio_config.h |  16 ++--
 vdpa/include/uapi/linux/vdpa.h     |   4 +
 vdpa/vdpa.c                        | 115 ++++++++++++++++++++++++++++-
 3 files changed, 123 insertions(+), 12 deletions(-)

-- 
2.34.1

