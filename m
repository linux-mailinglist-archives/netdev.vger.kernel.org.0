Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01E7500DB7
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243428AbiDNMjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243425AbiDNMju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:39:50 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1CB8FE45;
        Thu, 14 Apr 2022 05:37:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6XhW6Y5TqNY0TxCc/ZVh9oP4+epWBHWRVztvI6IdyMzY1vTb64rizzxXwrX+JyrX/fA+5lv5avJRFthvOST08k2d2UFzXeBln6Takz1E7WYwC+Udt6atmDzk6HXA2AfUxhzj7AL8S5MFcg8yP0y/eAFRtZMSzEG9IW8ljAdRsE3NE3dRuEC30+j3gr9h3KUI0GK+suEA5cmPXknsaLIOuE6tucuxzXIvGBZtwZBVLr9PREtppz6/HIEfp97u8Mf2Hn8L993qZWuRAD2KhEcN/hztrR6Jdu/1H29NEjrnxVEVq2LqdZaOIx0JcrVzn3dvV6al7omr0KKNsW5DtcjJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ixDr9U32vfWoMo7NQyInjvyRL5TVLl1fKaWLV1f9Bns=;
 b=D/aSUzBH1wbp040k+3l4k1WUPSPoLeE7Umm27PlbN0b4AuSz4SUGiPWWCy6ye4OKJqCle2e2xdoLUS1n6wC4SIRuMCvBKbQyWfYvxCm6pLXHs1OWQ5d9W5LXOEsEsZyQIEZhJAt4R/Vp68FOZH81EvGcYIhhjvrZWEzBJrnwycXlSTHO6dpb1HlvZ9/J3yb+8PrgTb/nyifHmVaEAgcyrlXbswFB8E/JhWkG9BWrfiCzSRgKFnUkHUVglnynOdOnGQnEDM2LMqWSh3dzp/PB82KJvWdmHEQtT8pIBx3oEsHS/EFQzar0249+IY4CMsmAf1KxbhtGCpUBgdUBtudhBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ixDr9U32vfWoMo7NQyInjvyRL5TVLl1fKaWLV1f9Bns=;
 b=K6UdUKQQFTsVM7JGkeGEeJQN/2VfObMBhajzzj+JYWyQlXdR8RiNU8jVie6XxdxJrBGV0P6FFclUzTbsk71yE5p3QeAhxewBXDeLFHkqjyOaZXT0PWVS1niqV4wv0hjCj648QrTN4BFZGf02EnfCPWHFLH2riwX6Su+C8MwmohA=
Received: from BN9PR03CA0717.namprd03.prod.outlook.com (2603:10b6:408:ef::32)
 by CY4PR02MB3303.namprd02.prod.outlook.com (2603:10b6:910:7d::34) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 12:37:24 +0000
Received: from BN1NAM02FT024.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:ef:cafe::bb) by BN9PR03CA0717.outlook.office365.com
 (2603:10b6:408:ef::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18 via Frontend
 Transport; Thu, 14 Apr 2022 12:37:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT024.mail.protection.outlook.com (10.13.2.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5164.19 via Frontend Transport; Thu, 14 Apr 2022 12:37:23 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 14 Apr 2022 05:37:20 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 14 Apr 2022 05:37:20 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 linux-arm-kernel@lists.infradead.org,
 andrew@lunn.ch,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.6] (port=53837 helo=xhdvnc106.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1neyit-0006qP-Mu; Thu, 14 Apr 2022 05:37:20 -0700
Received: by xhdvnc106.xilinx.com (Postfix, from userid 13245)
        id E762E61054; Thu, 14 Apr 2022 18:07:18 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <andrew@lunn.ch>
CC:     <michal.simek@xilinx.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next 0/3] net: emaclite: Trivial code cleanup
Date:   Thu, 14 Apr 2022 18:07:08 +0530
Message-ID: <1649939831-14901-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 956c5153-da49-4284-4715-08da1e138647
X-MS-TrafficTypeDiagnostic: CY4PR02MB3303:EE_
X-Microsoft-Antispam-PRVS: <CY4PR02MB3303E0AB0F99995D079CCEDBC7EF9@CY4PR02MB3303.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g5/zQa5jvbEKvDDQAIb0BCspBnOV2gji9Grs9kiMSTS3MHR4AATJTJDo7AzrXt6u0D3USsXZEV7ZTdN3id3YJFdOgWTDY1Jq3S8i9pYbxLIMRVjQg6xuWVGVQlp2tUq8rZ/smnKLyrQfD6abBlZkewQqYPJNWHnDpwGEMDtJQ5SLG+/IfSCqQpFhT96Djr5gkpzCtl3p5rXxjbdIToH8ORz5BK2IoFLjOcfv+bCoJcHY46f1ENx1FKYlyfjX+XWuBDQoI7KMV/LJfG2lkw8NsitMMRbsyLUQyp5p3OyCqvDHHDh42IVcwVate0Ks+7hw6GyQx/d4ys/FUiemhGWy4qxASGyXS3zdVssVyC6n1w6eEN9S3Pi40Pf6OvqP9lVN63awTG5Kg0m0R+Wrt3VAzELx8z0ebbs0VrU6sq2I7HuTYU0G+HWuH+f46FghgWr9afwueDU+6FGUWmVxXt6lbK0Q9+OqoNyBb73iYngxultw+UEeRVaBt0NstyG/KMiq643JZRaIrpAhir8BOXNZ1upv7mKHyvfnpq2RGac63KS8uHJvgBlMKLeuZe1dg9URQuuGOgoNCTorFt8o1jNGaphruAWE4R6UUiNiqswYfuX4f2NZj5NY+0AoFpmGVWCmzig9O0ZwQ8q5hN17imAr4/rt7pawnyws0PrxW9hXNIKGMIVI5IR1W9xkeHRo+0fK4ZkvGFOkOJF1JdyL1Zy8Qw==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(2906002)(336012)(70586007)(54906003)(40460700003)(70206006)(2616005)(42186006)(47076005)(186003)(26005)(7636003)(356005)(8936002)(4744005)(36756003)(82310400005)(5660300002)(316002)(426003)(6266002)(6666004)(110136005)(107886003)(4326008)(508600001)(36860700001)(83380400001)(8676002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 12:37:23.0970
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 956c5153-da49-4284-4715-08da1e138647
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT024.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR02MB3303
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This patchset fix coding style issues, remove BUFFER_ALIGN
macro and also update copyright text.


I have to resend as earlier series didn't reach mailing list
due to some configuration issue.


Michal Simek (1):
  net: emaclite: Update copyright text to correct format

Radhey Shyam Pandey (1):
  net: emaclite: Fix coding style

Shravya Kumbham (1):
  net: emaclite: Remove custom BUFFER_ALIGN macro

 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 55 +++++++++------------------
 1 file changed, 18 insertions(+), 37 deletions(-)

-- 
2.7.4

