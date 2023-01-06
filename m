Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C54366015D
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 14:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjAFNgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 08:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbjAFNgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 08:36:13 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2071.outbound.protection.outlook.com [40.107.100.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C4A39C
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 05:36:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZmCluY9BRGB23TLGorAk7X1s0x4flcsm1Y00XXcY4nbDJJDvHorOhjlsJnasjkvDpv7RdslPWAXsX8emZZnTI7CbK05/ctRisuELjOC4FQGfcBxgyvVfLcGH4/Om7mXpTegT/vvuDEuS3HgzqlKEIMdxjKlNCQBW7Kgratoo81M525YXyiu2MmzIprEGV/ukHmkw/alH71hNQ9r8YwJlqVrcPB3VGYkhaPBd3u7NoI3KzWRYEfHSO0ANhkFejo0hCNYguiIbDc9jAiMbRUeaRVPC7rHc1WGqNtCWmoiAQaJ+aouId0ZnST9Nfy/aMbX2upx7y41FR3gUuF65Aenpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68t5NsV4p6KwyYpZdzovIb9BYzqQtqSd8KhSr1wLA8I=;
 b=Lyr8ARvFYgd+Lz7F/uhlTIHNKt/LQMnnyLLE6tw4MW5dOWHqoYXVKJqJuU/s/uMXr39vaqtzZnH0SQIXZDRpsKAw8hBYQvcykpb57O7VC3kQwOHLs6vwysL2OOgUQ+6QjoekFuxZZsn3QHZc12T4V3/OVR7fpdz6poCNdG63j+QkQpunFqfPncEsjX8FThMxMBRhezW+jm5CJOp+JkhSnrwCIuY3mvDjggZfng1/iewGzWtKCrZn2sW3GJWqftVeqniTJkCPwzTyRTlb8u3SshMZ58Gze7PmJeK2tGPsoXFzAx5EVzo/ueve6IcoGsh1QmTrIs6wbrqrqZwobacicQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68t5NsV4p6KwyYpZdzovIb9BYzqQtqSd8KhSr1wLA8I=;
 b=Dl6uZTJ+EyDRoDz6QNNrwuCTciI76dMJ3esqmke/V1+bvkfZLl/nRIddWVhWKLpQBhdm0g2Z2WenTyQs5JhJmEcpRX+0g4OaD1GxdRgC1OH79BANsAbG5os8pbr7F59D9Qoe/UW48qU9VVA4G40DS6lIuIzL5ECeAhUZtAdF4frxnXUaVcNEPbG5NOzNLAP+V8Ka4WmAAe2+DBQ2uXjkCcVyz734IvmiUBRXXhWDxS+bjib57Z8lSS9FMcbdTyud4rVJg2jhpPuYa2rLkwYCdVxld3AmSb5HRRiqls7LMTBwr3W1I8MwiyuMWCxvIBqcRioe6TXheoMI8H6wz1w4Nw==
Received: from DM6PR08CA0023.namprd08.prod.outlook.com (2603:10b6:5:80::36) by
 MW3PR12MB4441.namprd12.prod.outlook.com (2603:10b6:303:59::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.19; Fri, 6 Jan 2023 13:36:06 +0000
Received: from DM6NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::9a) by DM6PR08CA0023.outlook.office365.com
 (2603:10b6:5:80::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.15 via Frontend
 Transport; Fri, 6 Jan 2023 13:36:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT088.mail.protection.outlook.com (10.13.172.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5966.17 via Frontend Transport; Fri, 6 Jan 2023 13:36:06 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 6 Jan 2023
 05:36:00 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 6 Jan 2023
 05:35:59 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 6 Jan
 2023 05:35:57 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v6 0/2] Add support to offload macsec using netlink update
Date:   Fri, 6 Jan 2023 15:35:49 +0200
Message-ID: <20230106133551.31940-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT088:EE_|MW3PR12MB4441:EE_
X-MS-Office365-Filtering-Correlation-Id: 09ff039a-2e71-4109-5086-08daefeaf6b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OQyIemqjIt6NMVDkkzkhiC/eWAxjn1mbD0ksWkOYnk315nsEWYgnZt1UriJjThp6/6Dbk7aTokYoEd6UdGhRQh8ZsPqLGLoCHHPgj6B0A24IUMNb4cyJAraYamcn6kmPicv5RN5qCnv/frCMZVmUNICdBul7wc7uzj2qq1WiIqP7S7o2pyB7gd23pEdyiLXzJICHz1Y4sBRWKxZ/eopo2WpNVyFLu1u2EvyefSq7UqO3oICbb4ueeJ99Bvk9Pq7TwJLlkSOESg1oO3L1F71owXKfZg9WGYbN24QlNG4B/ACFz5oyl8VccgvXtSHD/V3Jo3+nCLSwoZkL6YhR50DVqhTRzNdSYVkdKFshq/yN9IUBW8NUKQ/p6kacfNgAHghFQhW2U9fEbqS2C4n8GIsSUNHSVyMqqnzFRrblkb7fEpEqzfXFY9UKapgWFk4SLrFyIW0sjI4K+uAQMchCtut67mHgEqR3G5bKQ0BHm0tCUWdfZUG8J2aoZFJM3CV9xEJh+rlH4X7GuU2ALhMVpDso9RctapfWkA5UpHeZ1wteNQ3oGz7zRQu4gsd4iStctFJWfMenI1pxwQpFzRIoOu+VO2rIOQIrRzWYgronDeaMwIvFFt4xkrlunOY2FIlmAC0J//7a6Kxsgk1Per6t9AmPgoqfPf7VhbG5mhquegw/FUUWArpDwz7BI5s4tlpQkvKsnf5MTPLfKHubY67xTGCMTQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199015)(46966006)(36840700001)(40470700004)(83380400001)(26005)(186003)(336012)(40480700001)(426003)(86362001)(2616005)(40460700003)(82310400005)(7636003)(36756003)(356005)(47076005)(82740400003)(36860700001)(1076003)(478600001)(54906003)(15650500001)(70586007)(2906002)(6916009)(4744005)(41300700001)(316002)(8676002)(5660300002)(6666004)(4326008)(70206006)(8936002)(107886003)(2876002)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 13:36:06.5207
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09ff039a-2e71-4109-5086-08daefeaf6b2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4441
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
update routine , command example:
ip link set link eth2 macsec0 type macsec offload mac

The above is done using the IFLA_MACSEC_OFFLOAD attribute hence
the second patch of dumping this attribute as part of the macsec
dump.

Emeel Hakim (2):
  macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
  macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump

 drivers/net/macsec.c | 127 ++++++++++++++++++++++---------------------
 1 file changed, 66 insertions(+), 61 deletions(-)

-- 
2.21.3

