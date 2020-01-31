Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5E614EA9E
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 11:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgAaK1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 05:27:55 -0500
Received: from mail-eopbgr770055.outbound.protection.outlook.com ([40.107.77.55]:58203
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728291AbgAaK1z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 05:27:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFlKWAGFT1wcUfVGDUdehJGZv0xv2IWt8pP1mAPfqOceheIqPyLQMlcaOY2tadfqELhtdnx6sJca0DLnqyxCEL944XZEpxRxaAmXUluv/w3w9V2KeKLGETGdS5ckuWU6qdVL7UKVuhLBYfkfDh8rUzIWsOIanWHIh3ru6wxOtd73G+nC9iBIkaUBR6WnHENnvy7bTLviUEJOlLnp83wXfsCUCq8L39c/27HADf1ZdIw6Vp6Rum6Z35D2UGN4AeCzmoDo+9ZskD5VkYhtwCHJZrLPu5bbpG+rrpI37X9j3Qbf9YXlYMxWxm73tZ16V9d+qC4Xzypkqh+KfAc/wkAqPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Otco+yxbGO2mcsOi4AwRrYqBJnX4QRPIXWdL9kZDPao=;
 b=GxXQmrNF6EI7hyxHwMq902fcXRNFFoA3k0GODWcCzV6KfnUDsyuukACLk91/Zx+H6fBJUNMJ8UtH8ud+3prqdOgzTcI1Gq57zYZbFWJFdvHpH6aoQWgK5kWOlXb6/AK9a2Y00kIAzvafpb9WRUqVlCLMb7vdfAi8Hl6Z8BfMgZtQgRLIDKEx4cO7BHOT+J7d84E8G50FDux6iY8ZXSFogGUU1UQxpf5kiASM2A7vURyYXBuR1edgCUi68ny47oD3inx1ArvWAp8Iq9EOqpqEatYfdmotUVvWqIU56A2G8mryFMMbNeKYg5cxkQgtYXO/a2ibqrY4ndWndbVUMQQwbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=gmail.com smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Otco+yxbGO2mcsOi4AwRrYqBJnX4QRPIXWdL9kZDPao=;
 b=feQOhdA2BFrF7ygeJ5zH4dO6mnphblL2ijBIeQKag8OZ5BvVSdMc49Rw9hEX8Vs8j39f1Xm6zMNGOOnl0jE/FBzVX1MdamZxAkaXjJIyINjYuS+AGxBGcVMDd65RqoQu8mihCOnEnGN+JFQfLOfd44b6mgBaq4qbCrPx7Itqplo=
Received: from SN4PR0201CA0057.namprd02.prod.outlook.com
 (2603:10b6:803:20::19) by MN2PR02MB6751.namprd02.prod.outlook.com
 (2603:10b6:208:1dc::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.27; Fri, 31 Jan
 2020 10:27:52 +0000
Received: from SN1NAM02FT040.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::207) by SN4PR0201CA0057.outlook.office365.com
 (2603:10b6:803:20::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend
 Transport; Fri, 31 Jan 2020 10:27:52 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT040.mail.protection.outlook.com (10.152.72.195) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2686.25
 via Frontend Transport; Fri, 31 Jan 2020 10:27:51 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1ixTWh-0003vB-H9; Fri, 31 Jan 2020 02:27:51 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1ixTWc-0007is-DW; Fri, 31 Jan 2020 02:27:46 -0800
Received: from xsj-pvapsmtp01 (smtp2.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 00VARfGj007864;
        Fri, 31 Jan 2020 02:27:41 -0800
Received: from [10.140.6.13] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1ixTWW-0007h3-Ut; Fri, 31 Jan 2020 02:27:41 -0800
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        harini.katakam@xilinx.com
Subject: [PATCH 1/2] net: macb: Remove unnecessary alignment check for TSO
Date:   Fri, 31 Jan 2020 15:57:34 +0530
Message-Id: <1580466455-27288-2-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580466455-27288-1-git-send-email-harini.katakam@xilinx.com>
References: <1580466455-27288-1-git-send-email-harini.katakam@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39850400004)(346002)(376002)(189003)(199004)(2616005)(70206006)(426003)(316002)(44832011)(4326008)(8676002)(356004)(6666004)(70586007)(336012)(9786002)(2906002)(81166006)(81156014)(4744005)(36756003)(8936002)(5660300002)(7696005)(186003)(26005)(107886003)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR02MB6751;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fcf84c7-8eae-44a0-76c0-08d7a6383a24
X-MS-TrafficTypeDiagnostic: MN2PR02MB6751:
X-Microsoft-Antispam-PRVS: <MN2PR02MB675108C3288ADDECD22BDF78C9070@MN2PR02MB6751.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 029976C540
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SKEcLfwlMamlcsD5aAJyQLhmvAiUB6mXT/To1A2l8W/LUMAP1ggbVsxocn3wikKwjrJnErgE60tjggDWXtky4ENt1GyUsUdGYtzCsAaYuf5zW/GwPfXyveyVnX7LM91I+4QzCMZzvSJZf4Mn1KztWyU+sCWO+mwhb3oe5PMuy40wJwhSk3UFBe7LZzhdQVN8AE6lTHtwkMlPECbnBtO3flfJrILG8rXzmBSibIXOuLVMGRzyQukDF0WEgrI2wfe83QDjkSPpq2hf3fpBJ5zMCaQAsXDRieHtAOSz88yszYnQwN/r7MnWUdJpjc32Fw5YF1fww2p0EL3++ZH+mDzZrsao85wHNDujbAjRKHlH0gWtvG8a3vBZ5YTv06O5G2yUcrKJUHCKmpm2tpsNqzzNIdE+hFXSeQi6iQ4BjYe9qdWkvK53+ztBYQwZmIZ+YcDG
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2020 10:27:51.8931
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fcf84c7-8eae-44a0-76c0-08d7a6383a24
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6751
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IP TSO implementation does NOT require the length to be a
multiple of 8. That is only a requirement for UFO as per IP
documentation.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 7a2fe63..2e418b8 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1792,7 +1792,7 @@ static netdev_features_t macb_features_check(struct sk_buff *skb,
 	/* Validate LSO compatibility */
 
 	/* there is only one buffer */
-	if (!skb_is_nonlinear(skb))
+	if (!skb_is_nonlinear(skb) || (ip_hdr(skb)->protocol != IPPROTO_UDP))
 		return features;
 
 	/* length of header */
-- 
2.7.4

