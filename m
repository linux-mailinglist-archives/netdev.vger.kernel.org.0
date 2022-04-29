Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F6D5154DA
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 21:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380391AbiD2TxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 15:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238988AbiD2TxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 15:53:02 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2047.outbound.protection.outlook.com [40.107.220.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F083ED4CAA;
        Fri, 29 Apr 2022 12:49:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWsJpg7N1S4ECmK3uJYrH5oKPIUx7tmFBT0fv3sHTO17sab4l9NNmyLzcXSWPWzs4Zkvnn11pB5lA9nYcF36lExkfau/5zhYHmkZGzxJABO5Yi5MO3sw5ojRiirqAhMHCfb0+79qamdfWVJiAfUAMqpzX0gs/cTj3O0A1vpJgUn+Y6zZKt+JTQd7lE2PlGDAQVftUc09tJGI0Qqc0PDncTaD9fOlS8tPkZGgtihpZKnriZF2TwFZlfXyEEF/cDRTY6q/yG9aFOawSOCsovrsk8dOBy+Wr1kXi3MFCOpYRLnRPWsd0Kumcl0ZcNk+OmDUl4svuUT+SeOgw7f2TsTQvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q/+0S1s/+0/4agPQHwe1zwjEJRNowWNE4/bh6tOqG8U=;
 b=VAnsz6kfapEo/7cwqDSdnVhTsPrNPYex/wVnX0Gtr0T5rblmra+j2PMSHBs/cfkp+W3P68ghJ86/bG5d4LJ6j3aSxpV33a6zRU3gt890D57i6s/ebKponRb98oFUiSi8ktRggFqyy06YEzUQvriIl58Q8HjKjpRpg20gYa7tRg40pLLn6tR7SCrb8RuKIS6BsVxh/TTyBey7Z/gJw20MUzWPgiW/lmR86HpeQ9d1zXe8hhilvi+gvcVXNIyJ5kvmd0JTkvum8nckrLAqSwf13frYZnktjdjuib3kedP15OliJ8I+TBSDroRMhbw1Mb9T0VhJ2Poq/zrxIeSfvywkYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q/+0S1s/+0/4agPQHwe1zwjEJRNowWNE4/bh6tOqG8U=;
 b=rffVfkOHsQtt49ywkDY2jzUBcMokufIrKG0y7sr7d1Xvu/rDZ9DhFOO799pqweBPBzN9IZBvrRG5xQ/m5urpjHsIuJO7gVKZLiUUlmdPXM4CYmfLn35eYTR1fHXLiE37zRxNjkTizQ82egvshM+p8QJpGugdJnoPa7v/1cr7UqE=
Received: from DS7PR05CA0103.namprd05.prod.outlook.com (2603:10b6:8:56::18) by
 BN7PR02MB3906.namprd02.prod.outlook.com (2603:10b6:408::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.13; Fri, 29 Apr 2022 19:49:40 +0000
Received: from DM3NAM02FT034.eop-nam02.prod.protection.outlook.com
 (2603:10b6:8:56:cafe::79) by DS7PR05CA0103.outlook.office365.com
 (2603:10b6:8:56::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.6 via Frontend
 Transport; Fri, 29 Apr 2022 19:49:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT034.mail.protection.outlook.com (10.13.4.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5206.12 via Frontend Transport; Fri, 29 Apr 2022 19:49:39 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 29 Apr 2022 12:49:38 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 29 Apr 2022 12:49:38 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 andrew@lunn.ch,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.6] (port=52256 helo=xhdvnc106.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1nkWcT-000EST-U8; Fri, 29 Apr 2022 12:49:38 -0700
Received: by xhdvnc106.xilinx.com (Postfix, from userid 13245)
        id 25D1360528; Sat, 30 Apr 2022 01:19:37 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <michal.simek@xilinx.com>, <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <git@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net v2 0/2] emaclite: improve error handling and minor cleanup
Date:   Sat, 30 Apr 2022 01:19:28 +0530
Message-ID: <1651261770-6025-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e90465d-a033-4a58-f89a-08da2a1965fa
X-MS-TrafficTypeDiagnostic: BN7PR02MB3906:EE_
X-Microsoft-Antispam-PRVS: <BN7PR02MB3906930F4E7DBFBC784B709EC7FC9@BN7PR02MB3906.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mkkLw+LEGFnzFBxG+IsKVMkP7Pehagp3pN2MAIgmJ4VcuuxcNuYT+NDyzwceDZLOx2YaDENSEzNMul5RcZ6VmyJ8ucsuyqALLDfrYyzSM/318hdNJ53Am5hu6BjkqLxh8mk0cgUykFXmgBZoz3Hr8jVYrXPV9oPiM2bdrvFyqzEi50cSWqy2dg8Fm3ubTz2MvxFaki+9bF/NscRWV3ESruH6BuMqy+KkoL7Rsr8xzRHoU9U9+gelfdkflsvHUu5BvRqPkpX3N+Ekdv00NUHitNFzD4Q3ze+2MuFykgYZtWE4zsu32HEYbt8MH1vTdjJ5rPnRvsJmwMONrRlHlt6F/GwR7sz8Ylsk+PzR7flHcL9UXNov3kCdLL0s/t4SigvGZyZdpPxo63bBa6ug80EBlKxepZWmyuDVPNZNKY4n2UPolW6yGY3znuAgmdz++CqSiGOZrX9soFVFsKj7FBIfH+CTdVj+yBNaLjYHSTCvQPzrlDtPBSUGqgNyd5Y9Nl9MultaDsyAbhu0daWRQ8RFlLLq3R3kjEfILt1El1N0nUagSaKKl/oOgYv4/aKqJH8iAI1+116LfVUILotiG1IupdJkaQAc1DUpqpmAMcjcdy+DVQS6v1fa0Y+pc6BthR2B7kvV+69cAqdIE81hW5vIUWbpTdEMOXhlPqzp8nwCjD+HVlLT/YF0A+J0i9c/An1H0yKvhv3HhOGTUnnnge9ZyA==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(426003)(54906003)(36756003)(2616005)(83380400001)(508600001)(110136005)(186003)(82310400005)(47076005)(7636003)(107886003)(42186006)(336012)(316002)(6666004)(40460700003)(8676002)(70586007)(2906002)(356005)(36860700001)(26005)(6266002)(4744005)(8936002)(5660300002)(4326008)(70206006)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 19:49:39.8904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e90465d-a033-4a58-f89a-08da2a1965fa
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT034.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB3906
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset does error handling for of_address_to_resource() and also
removes "Don't advertise 1000BASE-T" and auto negotiation.


Changes for v2:
- Added Andrew's reviewed by tag in 1/2 patch.
- Move ret to down to align with reverse xmas tree style in 2/2 patch.
- Also add fixes tag in 2/2 patch.
- Specify tree name in subject prefix.

Shravya Kumbham (2):
  net: emaclite: Don't advertise 1000BASE-T and do auto negotiation
  net: emaclite: Add error handling for of_address_to_resource()

 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 30 +++++++++++----------------
 1 file changed, 12 insertions(+), 18 deletions(-)

-- 
2.7.4

