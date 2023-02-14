Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70056969DA
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbjBNQie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbjBNQi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:38:29 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A566F2BED4
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:38:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F61XrFpYPTPbXv2RkIK44MCJUX4yBIEYEvwppOxMlfdPq5QDPuo0xRwG4NXNcy0hSg8Wf0om/+ymAueXgc8mUWv6MVOEwCpLhAO3eF0wvkfi46RJFM25ausSOZJGvc6ClEmNeJcYqMitZ0D/tlneR6LxMy0odvBWLVBEDCJTZdQ0fHrFbPZNnhoO3nQdjdv/izEozehvoXDnTowa6n5JJzN2UWwXf+0XLg8FE9BLHpxo8l8mLlM1wYAFeDQeOokZvbXNERHPjLkHVbH8c3yYH78QRc5hXEyld7uUNdkUkU4ek9r6T3/V5EsUNwULBdUOHGhPPuzsG64+ytOAkXpsFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=04DKLg4sYlzACFcmtrHVeYDtcg7vksB1uX++KgYO54k=;
 b=ep4Iw3VGYztKVur7qRaBBC240M5J2l4vpSdfOXCp9/1UQQdBJAq4x/vWYBFgtWx0We5th69anov9Kl/CZHvYEFcweeNnAlMcZWfziE1eKzq1dx0BL8BF3C2C+wG7deIlF1JilrbbggXkL1OI0wOOqbVY4tnHpzzNbGkF5buobFYQTiZxjqmGYKBXbhRi7a0LSFItMYUGEon3YVvqBDex5tVq0wCCk9JU36XRuMMPG+wiRklp7i2HfQOdlzNtWgc6LulG7dQbJKKQxfqQsx4x1eGbnIkkXZJoGMfcnYXTrqoVl8z9GayJ/niPjcT0z2d23c260VWpF8NIf2gXxuNJfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=04DKLg4sYlzACFcmtrHVeYDtcg7vksB1uX++KgYO54k=;
 b=UN9qZM1LK5xPT1N+/sedmox78i1xdtmf1gT8gCPDwbgSsaUZO06LUH+vf2MiGWc7b0PC2hvofIVCPEoXPPRN03GYCvpOY8A9x9PaCRF2Fvn5SwuXxEtrwTqN474I6dBGvNzKG8VnCWlqx8vZdcBs+/W2ln0tXYZqbcFurVF5/J2ubli5F/OhyHQcG7SeR1nRsXNr3I7DbQ7eDYYL5HzN9QHiDVuqiKtraAVF4MGyAwPdoK6E2RUXV8q4YKqP7+ybXzIRdh29tFQuagx/EgBSJr7gMrqkZHJ/FVLMJX+B6rXIbSOt+q+D5lMaiPaMdY3niYsJmX7yGk2NwfO4Zs5erA==
Received: from BN9PR03CA0769.namprd03.prod.outlook.com (2603:10b6:408:13a::24)
 by SJ0PR12MB5661.namprd12.prod.outlook.com (2603:10b6:a03:422::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Tue, 14 Feb
 2023 16:38:22 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13a:cafe::4b) by BN9PR03CA0769.outlook.office365.com
 (2603:10b6:408:13a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Tue, 14 Feb 2023 16:38:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26 via Frontend Transport; Tue, 14 Feb 2023 16:38:21 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 08:38:11 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 14 Feb 2023 08:38:10 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 14 Feb 2023 08:38:09 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>
CC:     Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 00/10] devlink: cleanups and move devlink health functionality to separate file
Date:   Tue, 14 Feb 2023 18:37:56 +0200
Message-ID: <1676392686-405892-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT023:EE_|SJ0PR12MB5661:EE_
X-MS-Office365-Filtering-Correlation-Id: 41c53d25-e013-4bd0-9e35-08db0ea9e298
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BqFi+8WD2IpwSHsHJSuJOM8ZDgmzLGGxehkQ74jwIIw2ZHX7OY5GIuVajc58OmUJKt7jB54OOJAYEeTElXz5/Ax/Mt69jmb+N2OafobHyBIWEp4VphHJnOCq7cWcresBwtBbFDMrkvwDgTQnD6kuVmGPCWj9G/ntFuNJ2jVB2emInhnslbhkQUrmOwyeNUPPmgPK3Ws0fCr3V3pFjZYojoaXgqI/2OsE5Om1HQOBQXL6v5cWfFleln+DpMNndy5nMwXHI0HRr4xWAtcHQw0jeNdITsdqS4+AHG3fXrIWVQTqW43swrBDGFKE99cfhYF0juf464TgXznq8LXxyHNtFEIABbCsuWxjf5Y7KQ9DxWVefg2MiFNaeCiS2HEE4vNZvMTMJHQEZJ+laDsooJuAYLCBVZCaniSHFGFPcf9+kP5MY2Uje/oOxSG8WNVDcQEukX0kPXyx08Vfo/hSOBUKN1uAHQvtWZyIJ3flCvkr9ldoHFf+Y4RE0oMvDDHgRiZFxxibItZ84X8cIiuoJyRy6I1rUP8wwt6JqQ3IGBaNhaWKVfk2V+wRmuVQ6h+mvxX1rf3VDzE98p1tv8vl04m6pgdMm+Wf7s+6kbw/mQ/cQkGOZkAdYYq8gsz9X/Jq0Wr7Sn0LPq5TUgDjkUCRXgKqTHn9fJwozWOeFS2kaew+ekfmQsl1hPjNjBhDS3DmmhYi6CgmZOTVXLC0vhyZKLKTEQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(396003)(376002)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(356005)(316002)(426003)(47076005)(110136005)(41300700001)(36860700001)(36756003)(2906002)(8936002)(82740400003)(7636003)(40480700001)(5660300002)(83380400001)(82310400005)(4326008)(40460700003)(107886003)(6666004)(8676002)(86362001)(186003)(26005)(2616005)(478600001)(70206006)(70586007)(7696005)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:38:21.4784
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41c53d25-e013-4bd0-9e35-08db0ea9e298
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5661
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset moves devlink health callbacks, helpers and related code
from leftover.c to new file health.c. About 1.3K LoC are moved by this
patchset, covering all devlink health functionality.

In addition this patchset includes a couple of small cleanups in devlink
health code and documentation update.

---
v1->v2:
- Fix kdoc indentation and make reporter create/destroy kdoc more clear
- Add note on the two cleanup patches that the bug is harmless
- Drop patch 4 ("devlink: health: Don't try to add trace with NULL msg")
- Add patch "devlink: Fix TP_STRUCT_entry in trace of devlink health report"


Moshe Shemesh (10):
  devlink: Split out health reporter create code
  devlink: health: Fix nla_nest_end in error flow
  devlink: Move devlink health get and set code to health file
  devlink: Move devlink health report and recover to health file
  devlink: Move devlink fmsg and health diagnose to health file
  devlink: Move devlink health dump to health file
  devlink: Move devlink health test to health file
  devlink: Move health common function to health file
  devlink: Update devlink health documentation
  devlink: Fix TP_STRUCT_entry in trace of devlink health report

 .../networking/devlink/devlink-health.rst     |   23 +-
 include/trace/events/devlink.h                |    2 +-
 net/devlink/Makefile                          |    2 +-
 net/devlink/devl_internal.h                   |   16 +
 net/devlink/health.c                          | 1333 +++++++++++++++++
 net/devlink/leftover.c                        | 1330 +---------------
 6 files changed, 1374 insertions(+), 1332 deletions(-)
 create mode 100644 net/devlink/health.c

-- 
2.27.0

