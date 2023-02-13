Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD466951E1
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 21:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjBMUak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 15:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbjBMUah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 15:30:37 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2071.outbound.protection.outlook.com [40.107.101.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECBE6EB1
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 12:30:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1oDgAxsKoAiqE6B9kcSu3bLBS+xrkNLGcE4Xm1cFGjFB8X8mC50YrxVRUJ4Bo861/xxnC63GZBPLDFUKTGKqq8nQ+Xl2NTBk1p72l/lHnoym5LM6kU578rhQyXfQzYBoTaYTIjxc59QZmqaZipUbRDh6RJZ/+Z92Jgws6f/5mSwtZPdqqqHGHfc3ltNyPNRI5Ofxw2ZPzp1TYzVe67IF394ARrFDFsRBtEKmxWF95VQ7ZZpaWEobQAxgnYT29tDjmp2cgJRAyJtnrG92egux9J5MHgEeqWDLzv8nFsILPgXEmM95VgFHfQ34mR1wpS55XWHn+TGTd7teoyYhlB1zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5KfPVbq8/0cZsu3P/bqlVCrbbPH8dnaZSv96i/rW3s=;
 b=kTAYjtOJTveWbAu/bsUUjlScrv058M1Loy6FOpTH5y6StR8Otiee+LrQ8olnmfoY38uqj2OEq07mq6/bX4x1IwSRDXEAMstSmPqcgiyiF/RPIOjmRseSz5TIPuqmRK3HQA0jmC9l/XBu9Xys3xXIbVyVYGUgiRi61CZdEw6COy60fHKHo1XTDu4+22jhc/m7Io+/DuJ0LoRhuIJKy8vKurEeQK3dP8+Y7EDii1SXDcTapUW+h/nCmERG+LnedczCJsRs8wb1b9Q1qEGNSfsgnlEcmZODmV5/GhvtmgjzSp+q3iq7GAbYJ/1uMAsOBHTRyp9/mcglIGRuZsyOitstZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5KfPVbq8/0cZsu3P/bqlVCrbbPH8dnaZSv96i/rW3s=;
 b=gSzjKEOc4n2wPuzFNypX+XcFTZFIfLCb9jgSITo57jcU0dZCLHsagBsFNjjZizpfBZ/uTbHuOQZT/fgBch2L1JXca49ylnUAS19LYTMDLwi0qJiiWamLeJYd0tnAEbfitvpxEOiqWDnRyZoA5DmPP2vSm4w18HQbyOLsiWqq/4c=
Received: from DM5PR07CA0069.namprd07.prod.outlook.com (2603:10b6:4:ad::34) by
 DM4PR12MB5985.namprd12.prod.outlook.com (2603:10b6:8:68::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24; Mon, 13 Feb 2023 20:30:32 +0000
Received: from DS1PEPF0000E649.namprd02.prod.outlook.com
 (2603:10b6:4:ad:cafe::5f) by DM5PR07CA0069.outlook.office365.com
 (2603:10b6:4:ad::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 20:30:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E649.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 20:30:32 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 14:30:31 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <mkubecek@suse.cz>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH ethtool-next 1/2] ethtool: uapi update for RX_PUSH ringparam attribute
Date:   Mon, 13 Feb 2023 12:30:07 -0800
Message-ID: <20230213203008.2321-2-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230213203008.2321-1-shannon.nelson@amd.com>
References: <20230213203008.2321-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E649:EE_|DM4PR12MB5985:EE_
X-MS-Office365-Filtering-Correlation-Id: 68c871e6-120a-4f7d-c1e3-08db0e0127ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kpzF1v1n4Wysz/uEw7yCKm3Giv7YndzMQo/txg6D7vGrZ7YIQ1PY5efRVggjRBgdYi8nWYjjZreJi89vrS9GpiU3luAKQ9e5VHbQ59sb+cU5ibpKH1VNEzJ6u38d/QDRgQj152WNxagarViUL1LqbBzW1xvfmV/TE11LTvXK3yBTS16P+Cqdi9SXfXLGHL7jEXIs0StgKRQmP0PBMZDistlkwaXFNqSSJJz4GAS2vJrELrQn8KISOl99+NRf6JZnJu5pSu1C64IPyD4AQCStaWCs81+CEXrBITfWdf8HOTjHF6goXGEQbAh7zo+WHXwr9H4RFWuGnycgi5wNbnQFg/AI5QT3XxqchLVQ9jSmUVPHVrALOQnPU/hYV4A7QKFFrGSA565jVvzxmoPQQ14HArUOHxWZvwxQdDTQtl/pOStwCo8hTNUvKtL4S8mzwBbzN2Rs0jwZQzcA/o10qIWVnG1uQEoygL2/FYryKJUHq7z/wCkwFV1B7nXpDskLBnojRdaxIREX+E6DFhX3Dxe4SHJkba6fQtyC7FoMeHB1cKKLFQQMwpTesG1vljRxuXqjChS91y26HlA4ds0H2XHkYtJNFvaF0KwRyjL0UvdLxitdA8hzOzsPQKrTiWEpnnCh2+yL58zkx4V8rfyOCwsrC5XnlBlSgKUCbHm3iYet9N/v/e0selnU3xynhfm66hvX3WwK/CsA66p+xH3c2oBBi0ZBcFQmRBMC0LpmUfAGNIINQbRkIob4uMhKDkODa0a2mDGyjFmnQBAo6RxO33N3jeOg09qPxCiDHcbFjXeekXg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199018)(46966006)(36840700001)(40470700004)(16526019)(36756003)(70586007)(4326008)(1076003)(8676002)(54906003)(110136005)(316002)(86362001)(40460700003)(336012)(186003)(26005)(2616005)(40480700001)(426003)(47076005)(81166007)(41300700001)(44832011)(4744005)(478600001)(6666004)(70206006)(2906002)(36860700001)(82740400003)(356005)(5660300002)(8936002)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 20:30:32.7631
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c871e6-120a-4f7d-c1e3-08db0e0127ca
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E649.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5985
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds the new uapi ETHTOOL_A_RINGS_RX_PUSH attribute as found in the
next-next commit
5b4e9a7a71ab ("net: ethtool: extend ringparam set/get APIs for rx_push")

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 uapi/linux/ethtool_netlink.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index 4cf91e5..13493c9 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -356,6 +356,7 @@ enum {
 	ETHTOOL_A_RINGS_TCP_DATA_SPLIT,			/* u8 */
 	ETHTOOL_A_RINGS_CQE_SIZE,			/* u32 */
 	ETHTOOL_A_RINGS_TX_PUSH,			/* u8 */
+	ETHTOOL_A_RINGS_RX_PUSH,			/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_RINGS_CNT,
-- 
2.31.1

