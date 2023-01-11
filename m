Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698A0665EA8
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 16:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbjAKPC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 10:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbjAKPCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 10:02:31 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04121D7
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 07:02:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CupZ5DIKBDosA5oDCSlYYIg2nTBaQ7ulHFqlAVQCMRi+VeR+0dPC4JozHESn5Qw6OTp+sW9X3ohEJCcv9v9OTWCV9R/BY+eQ0smrlh8x/gy5c6YoEWA6+WhSsuEaMFzVZAZ4LanLYVQEpHKwclArssBF+d5rtVItX1S8Ks/jXqoyyH/tmibSoYKpFtvTcqHsmNug/0p/ldEU4B2ZOud3K+S3ohj10ru/IF1HiFquqvPQdSkCvc3KRemwsLr0KD25ZsScXm/avgEpyp8olXFD7VSRCpcwRL5iz1edqhOk6CyZeXcnYd2ylrdktS7gNbqDtWEU7/0ew2cfeCIjV4zW3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTGrgh9PDU7LX/iO9gKku73Um0qriLI/xYZMasB8Pcw=;
 b=IIkCHY8TTu4yLGeglWwka+AxRXGjoDM9Jw8tJULpaCb8AiNs3AwNGSm8PT/2PuRiUCobVksP1o6FEQjRWIeeScnSoNCUdEUhl31fv55R+bKup6HQpIrXpcCsnv/1s6fdOaeK/tJeoMTjoIR6EBs8rKVkfp5Em7xL7fZGV3v62fy3rJDNfz7hHOwb/sa21AVeneIAIwEuRMV7zmscWgQN+wsmIrIUygIlcOedfWc6ixxPkjGUljJKpFkdm94olg+fxYCVirPtnPk8DWC34NcAADmRKDs5OGYr4RIIXl+LagEQZEXI2GuOJy4dqoTL8DnmAoedLxR7Dg25cmCOStTIUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nTGrgh9PDU7LX/iO9gKku73Um0qriLI/xYZMasB8Pcw=;
 b=ETsAnnp2qeUdEeTlMfW3KML9KxyAvfBTj1cPBbdA2OA1sqFCx2F+yrj9lBhi8OFdJWSrEE7ev3Rx6hB5DHgBn6FTK3u/M7y4XLgLheB2Kbh4soO8UsbbdUeQ7tB3XVwPut+0TzwJUXSmX7BApDr9/UKJgd5GygTKB29HTRf7o8KzSblbgxjdDAdcjWFXs7NwsyHf9+YJ5gZz+2MtWSbR7nNpEK4Rty2ybSky0XQGP27NBNmOVHWw1CvZVUhjC5sU4eRAMC3UIOPJGinO82Bu7sfZfbTpP8+BF6dBtoxDO1eACiUm8I6LtN4Ty7Ey3rvrd36a7x+S5o/vnp37aCRFeQ==
Received: from MW4PR03CA0288.namprd03.prod.outlook.com (2603:10b6:303:b5::23)
 by SN7PR12MB7300.namprd12.prod.outlook.com (2603:10b6:806:298::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 15:02:27 +0000
Received: from CO1NAM11FT076.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::5a) by MW4PR03CA0288.outlook.office365.com
 (2603:10b6:303:b5::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13 via Frontend
 Transport; Wed, 11 Jan 2023 15:02:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT076.mail.protection.outlook.com (10.13.174.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.16 via Frontend Transport; Wed, 11 Jan 2023 15:02:27 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 11 Jan
 2023 07:02:20 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 11 Jan
 2023 07:02:19 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Wed, 11 Jan
 2023 07:02:17 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v9 0/2] Add support to offload macsec using netlink update
Date:   Wed, 11 Jan 2023 17:02:08 +0200
Message-ID: <20230111150210.8246-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT076:EE_|SN7PR12MB7300:EE_
X-MS-Office365-Filtering-Correlation-Id: adbf0e7f-0d57-4e3d-f4ed-08daf3e4da90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q2DCSwPTDOleBnEQS0R0wQrX4L9Xj/eTvn3IRdOVQSWuIWcYnEC7pkH/Aza7XY5Od1u81kYa50gd7SLDufW0vKPsGtCLPsqdk4HN2M5MkmX+ne5mnQcIdga9HgUEigOwv5M0hHCjThYSR8ojt/R30xnpew/w1kZD3UQ8g6KbLOA/WVgOb/BnsTmhRw+InwU13Pt1OTZEWCzTEHK8emu/scHsSs8H6ZrTLFYwSbuht0pKA5gJXByREOF5wU+IdEVjyVZeQbntyVcOyeBiRpLzw+TBWjU0JGMaVswjjdhhL3WwD4rnnmOh8WI1YB3wqceSw4zkEs50KekP7+KRX8lYULtHFmoaonavtycmWdzFCBQQKr7mfQUyGVInV1PrnKceCkFVEbxevncQNSXIUiNuEjqA/tglsXAyvLZNQi7JVazM1RV3NOE3USXmbB4IIxGVFpd1fGbKXRvcnfv++jHCmjXelj2oESH9JYMD+Oo23vQTBCON8JAieoS7CgXY18OlIDoCOjAiKuJ6Rbs/Zpbret8j2+bF+G8nApTH2VQw9bSMqQWMYDJmHYIfU5j3seQEHNlisXOJFqTmfR8q1B81wxpmyF43Z82jALRwMD1mHaBLJr6KMudiU3CihlLRwZRFR9lNLOYOrnyIO3mAz31K4DIZ63k3nAXW2IOOUnK/2RHATJzEjFI8MBd/rRBPPJ5haBOKnUCk8eRVOGXTsy6c9A==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(396003)(136003)(451199015)(40470700004)(46966006)(36840700001)(2876002)(107886003)(6666004)(2906002)(26005)(186003)(15650500001)(426003)(8936002)(40460700003)(82310400005)(478600001)(7696005)(82740400003)(1076003)(336012)(2616005)(83380400001)(4744005)(316002)(36756003)(54906003)(47076005)(41300700001)(8676002)(40480700001)(4326008)(36860700001)(5660300002)(70586007)(70206006)(7636003)(356005)(6916009)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 15:02:27.0435
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: adbf0e7f-0d57-4e3d-f4ed-08daf3e4da90
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT076.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7300
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

This series adds support for offloading macsec as part of the netlink
update routine, command example:
ip link set link eth2 macsec0 type macsec offload mac

The above is done using the IFLA_MACSEC_OFFLOAD attribute hence
the second patch of dumping this attribute as part of the macsec
dump.

Emeel Hakim (2):
  macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
  macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump

 drivers/net/macsec.c | 126 ++++++++++++++++++++++++-------------------
 1 file changed, 70 insertions(+), 56 deletions(-)

-- 
2.21.3

