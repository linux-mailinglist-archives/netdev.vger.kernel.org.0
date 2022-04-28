Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BC35139D1
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350011AbiD1Qb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 12:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236269AbiD1Qb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 12:31:26 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2AFA27D8;
        Thu, 28 Apr 2022 09:28:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4kJ3QFc/w3omAH0sg9IZbxStAEfrtqcT3UO6J5WbvWFXrNoe4vZT4hmOuirq9pEqsQWjrttlewZPLRIoh+yTkHTZTqPGWRSoqiK78KzvVddGBfWJM9+PtOTW/jsM3NkiJnvtjjAT4THkilRDZkxHyjuJI8bSGXvNzXpf9kCEyKAB6hHhcugqTU2rIJKVsw1/aDYRGtAdyik2pwFYf+vKkkUqsZEvimnCXOPB9fPmvASxeZLuuKsKq1KtZuzp8MRZeW8tcLEYB96Ta2PtlrSnRxY2vx/I471yAhQd1vRPr9cvPfdk66FzzhYQkFijMsQozXEr0Z91SB+y5dmwBUD5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Mbvadlm5uW3lf5pKKe21MUmvOdVIDpBEG2nvlZ5ELc=;
 b=i7X0oMRrvtnIy7fM/rVr16PX5U9/idgV2Dp7hovnFKnQpJLjvve6CjV++3hZQoBZo9W9Ekpc4WivsC5BKI/LbHyyqiaxurNKUzRUMf6gyfC2HwBpHzqB2tzcV8bMYqRWFHJgxr/xzpn2d/gyITPMn+vLUxPHvdGQ4z4seK5uis+MEv0AVFQ1FuQ+fpE/TJ7H3RNkgDA/2GUXtdjY27zMK7vNUYsVmXN3j37/PsHXuPlbalEmP2pHJYDaEHvBw5boNL4Kx/V5YWjsfjeKwdkIXyVBvC6iXTy/g/pNhRhGrK1ZiFlAiL/ds9sEPGEeLgrQ0k1daOmV4nWlpGfMkCIvoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Mbvadlm5uW3lf5pKKe21MUmvOdVIDpBEG2nvlZ5ELc=;
 b=DSZil4c8EOR+yLr6XvKH6KKW/o3aZLnEYUvTbUfckX6cu/oSekcfb2WCbXqPkpjQK8lNEuCD29FCBHtVpyytaSWlnDAHekimcXGBXh3OaILy09wnQY6pmkpj5e19By/qtn65tEHHPC2WwmHTO9Odycp1khKcmUrFJ2yT+S9/X94=
Received: from BN0PR08CA0018.namprd08.prod.outlook.com (2603:10b6:408:142::29)
 by BYAPR02MB5352.namprd02.prod.outlook.com (2603:10b6:a03:63::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 16:28:09 +0000
Received: from BN1NAM02FT018.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::9c) by BN0PR08CA0018.outlook.office365.com
 (2603:10b6:408:142::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13 via Frontend
 Transport; Thu, 28 Apr 2022 16:28:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT018.mail.protection.outlook.com (10.13.3.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5206.12 via Frontend Transport; Thu, 28 Apr 2022 16:28:08 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 28 Apr 2022 09:28:02 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 28 Apr 2022 09:28:02 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 linux-arm-kernel@lists.infradead.org,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.6] (port=50303 helo=xhdvnc106.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1nk6zp-0009eb-Rj; Thu, 28 Apr 2022 09:28:02 -0700
Received: by xhdvnc106.xilinx.com (Postfix, from userid 13245)
        id 198E660E77; Thu, 28 Apr 2022 21:58:01 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <michal.simek@xilinx.com>
CC:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH 0/2] emaclite: improve error handling and minor cleanup
Date:   Thu, 28 Apr 2022 21:57:56 +0530
Message-ID: <1651163278-12701-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3460d0f7-8165-46c8-9ae4-08da29341463
X-MS-TrafficTypeDiagnostic: BYAPR02MB5352:EE_
X-Microsoft-Antispam-PRVS: <BYAPR02MB53525BDD370651257A4B77EBC7FD9@BYAPR02MB5352.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zt9nFaCASv9LeJNkRQzcO34atQqsqC6I/sTAwUULG14wkk00iYQvSG6vWizy/UGoAojyW12bBgiI0WpOgHb2HBJCkbwJ44UzPYme9JjSSbvusjsHQ5m6qTLMtari7h4XIOvTr50qfvE5XMUsD3HAosTr11OVpMCqYY/nde9Oi4EJP77jcK7PrYaWXJ87Oy8aLXvQNFW+19nWrEFvtjO6Zbtf1XS2bm4nh9rVcIwgIJTulAnjhUU1qKN4VsoLKKnhKEMLV3dJ/BkuFkokWHJytGrbX8TzZs88gdsAKN+QEO1FR96hMY2jB+3ovrPWIrhKRSV9iXL5/cAzAS0iPNUYgYq6dGOhPbtMhEfc0rwhBfoI4KV5HAdx3WUcQPR5jL1Wj44lHu8YtcY+xHgirizkOUBjnxroFGbq7ALJFrmXPz/d4sMMgHKdocd3THBwLNPn4sSYJ3PZYuAMygfb1aYTjXcjZ+q6ur3aJPpLafkkJVgTk4XapntmUaBPDdepXfa9328i9DEx8G/JjjSjJRxKp8lMjkf10zWb6o7Hc0AenQmHtIpqggIPFG0VB2f7d4umBK7vB0jf0P2wDhqiTuN6lZQftQmT70SkdbvWxTL85Emkoy9htCy1jsZd53odZ0NaqxI6zVvFE23AMd96GL6gwUpZTZimR6AJgvVg9fGuv5AO9y13Z5dPM+Betz575f11WALwtIc+Xx147rgG7JUYYg==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(316002)(36756003)(508600001)(107886003)(356005)(2616005)(8936002)(2906002)(8676002)(7636003)(26005)(47076005)(70586007)(426003)(336012)(83380400001)(40460700003)(110136005)(6636002)(54906003)(186003)(42186006)(5660300002)(6266002)(4744005)(70206006)(36860700001)(6666004)(4326008)(82310400005)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 16:28:08.2050
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3460d0f7-8165-46c8-9ae4-08da29341463
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT018.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5352
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It patchset does error handling for of_address_to_resource() and also
removes "Don't advertise 1000BASE-T" and auto negotiation.

TREE: net-next

Shravya Kumbham (2):
  net: emaclite: Don't advertise 1000BASE-T and do auto negotiation
  net: emaclite: Add error handling for of_address_to_resource()

 drivers/net/ethernet/xilinx/xilinx_emaclite.c |   30 ++++++++++---------------
 1 files changed, 12 insertions(+), 18 deletions(-)

