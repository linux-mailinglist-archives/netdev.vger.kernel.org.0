Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6871153F8E0
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 10:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238760AbiFGI5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 04:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbiFGI5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 04:57:05 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A999D7715;
        Tue,  7 Jun 2022 01:57:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWH6dTz//RHf3YR0uklX8Vx3gnfyvcYROyAp5mmxnyNEbTjPZDZHuMzZBcxAdyJLv+cz9LWovlvxzvt0HFnpQQL65tN4wfg5G/E9PhFmUC/tczV3yZwQnKhHGi8ffLsApOqvNWwMc9+YAqVM5Bqnu4WY0mcFeS5SgbU8oAe3N0N49WD4w9hH5Y8ziCmRktB3qSjxATzFfbWW4bOusbZU2IQHyOOmrQAapjWTiCWjt2Q6zC1zgjFN8xC/5bJ4NDU/DhmdvZn4KZPYxR8R7Kj3lDgd+8koHTyXuL7P3XEhQYVL9WKZlMjzxSAgW2g5hOPnX2FvHQwjXRKfOqIzNs2PBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YobFsZHJGNZ+57CrHpH2ArWEqdlmn+6oe2O1k+uU5SA=;
 b=GVveU68RXIElN1An+kG3qDGEMoLLZKllpuCVdXAgsLC8xBQLgx5wZUKDFek2REectFLK7JWg5THtBsNdFXg50YQIGDbfmblKrw3ri71KKYmJdRUxvXqedhDfBDIH1kYEZBgc+LozIVganpCQjWLXR+CNKhjTJqFd4n9p+SSd+rvogVim0Oq5Y6gc96gBoFN4KYRnSW+CYdkYQmQlo/kukpopKmLuEOgd08g3teVE/gmj1bJoRnUTHxEk11aZNLMDKRCziUbD4J/IzoFFnIZ95Qj6JjsK8Nrx71exhSfzcrLMUk2aK5laMmMbTY3CK9kGGUVhkfbxoFAiqKLCv/TiqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=grandegger.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YobFsZHJGNZ+57CrHpH2ArWEqdlmn+6oe2O1k+uU5SA=;
 b=LD4/UWpB2LdkXkcvN00k8NrolnCB+S+FJeCOxj6yKK0LeCgkfODApnNaLBaMFbJYJj3UcbPKRmTDhsyVFhg/dsbiKBCyBAb9ECdCDlCL9jZOFxXHgCpQ5vpxD7chNZu8B+ZGMJpF+wFrX016AgGYehjfor3LpnB/c/HGLK1sDEY=
Received: from SA9PR13CA0165.namprd13.prod.outlook.com (2603:10b6:806:28::20)
 by MWHPR02MB2608.namprd02.prod.outlook.com (2603:10b6:300:43::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15; Tue, 7 Jun
 2022 08:57:02 +0000
Received: from SN1NAM02FT0045.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:28:cafe::83) by SA9PR13CA0165.outlook.office365.com
 (2603:10b6:806:28::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.6 via Frontend
 Transport; Tue, 7 Jun 2022 08:57:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0045.mail.protection.outlook.com (10.97.5.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5314.12 via Frontend Transport; Tue, 7 Jun 2022 08:57:01 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 7 Jun 2022 01:57:00 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 7 Jun 2022 01:57:00 -0700
Envelope-to: git@xilinx.com,
 wg@grandegger.com,
 mkl@pengutronix.de,
 davem@davemloft.net,
 edumazet@google.com,
 kuba@kernel.org,
 pabeni@redhat.com,
 linux-can@vger.kernel.org,
 netdev@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Received: from [10.140.6.18] (port=44264 helo=xhdlakshmis40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1nyV1H-0007h1-T3; Tue, 07 Jun 2022 01:57:00 -0700
From:   Srinivas Neeli <srinivas.neeli@xilinx.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <edumazet@google.com>, <appana.durga.rao@xilinx.com>,
        <sgoud@xilinx.com>, <michal.simek@xilinx.com>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Srinivas Neeli <srinivas.neeli@xilinx.com>
Subject: [PATCH V2 0/2] xilinx_can: Update on xilinx can
Date:   Tue, 7 Jun 2022 14:26:52 +0530
Message-ID: <20220607085654.4178-1-srinivas.neeli@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bcfd2f7-03b8-4dc0-7d04-08da4863afea
X-MS-TrafficTypeDiagnostic: MWHPR02MB2608:EE_
X-Microsoft-Antispam-PRVS: <MWHPR02MB2608A98DFBC0E5769BF2C9EDAFA59@MWHPR02MB2608.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VQ9QCrbgDCWooHJZu30IY8x+UmroPOZIP7IOVvjZqPC5+x+ZXPtcp/kankwKm+98yW0FXgeILjbL9Fl+edP7XxupuVd2B7OfSUdakjC87Mk5jXIdj0ygzbNoE6e7kJovVsEpurZSGODCycXOpK+OQK6X/Br+bLkvLWHuzpd74Q4Y2E3uFSq4nkKr0LioGW4nN+TJt+lvpEpDWQHb6SJW6YG0dzbCscN2daFuVdzkRrmOZvwXwcdFu069nnrJuIinslSGl1Kt+AvpjQKIMyIddm2XUCyKgPKaNYIJaZIeg/RToDbPJ/guc1uS3VouyLpQcp2IzMbQcNEuPglN7HPJOiFtTQtmSTeruG4L+cQbOFyMD4BD4bjuV/WDALgv0mGjoflgBNJEty50bx2l785t2o+bE7jTofaUt7bR/Evi7jWxZcSXud7wx2eDZArqbHMW7RDZBso3RQzzSQr9YfE+pMTyRlz1lA0YvWSBnBLQdnhxG5Vfn6C0DOzVM9AmGRlYvM7C69Te365vkSTnBvd6aOrO7R7FE1R31JmvN3E7cRXa751cUcgA06/A0gluKQJgoeaubpLbMhTqrWtVL1OdKBA0hCNaIAPZu7fC2sbcluRQ4WzW42rEi8IFAiaozjHKI1JWR1aBIzYtzrWzQShTejJs5CAY9v4ImrILgFuqR0gfwZxfX6O3BtvsbNfo09U4cucFR1Q3nKy7tU01LjjoYQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(83380400001)(70206006)(1076003)(54906003)(8676002)(70586007)(6636002)(316002)(426003)(2616005)(186003)(47076005)(336012)(110136005)(107886003)(9786002)(6666004)(2906002)(7696005)(26005)(40460700003)(36756003)(508600001)(4744005)(7416002)(8936002)(5660300002)(4326008)(44832011)(36860700001)(7636003)(356005)(82310400005)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 08:57:01.5595
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bcfd2f7-03b8-4dc0-7d04-08da4863afea
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0045.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB2608
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series addresses
1) Reverts the limiting CANFD brp_min to 2.
2) Adds TDC support for Xilinx can driver.

Srinivas Neeli (2):
  Revert "can: xilinx_can: Limit CANFD brp to 2"
  can: xilinx_can: Add Transmitter delay compensation (TDC) feature
    support

 drivers/net/can/xilinx_can.c | 50 ++++++++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 5 deletions(-)

-- 
2.25.1

