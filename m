Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE3052B8F3
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 13:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235673AbiERLdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 07:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235692AbiERLd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 07:33:29 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96398111B9E;
        Wed, 18 May 2022 04:33:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T72GiVIMJzDZ731AeqcmzKVmeqv/yKpN/Hp+PMiQLX7/zojdNbQENb6oWiQxGmgFlZfqxXW/FeH4YqgppeC7pJTT7XkYoXrJXFwyxKIkNiibVJUqFQLNKwLjjrwjvfmJSYcN7PMwmxlzOathCuUz3gQRm2cyAgQXJtgCS76x5HaXft78yMweDwVPdIp5Z0jnW8SBpYWV4MmL+AW5Gz2r7604ZP0bfYjp8MzRyR/dgTI6wt/HTaEIi+oBVh1SscNDIVGWMJlXsa99wJOkZ8dsKb/CxY8O6VIcTdTD/4rBgjhjHs4agj0li9voAbX9ZoCg6zgi6LjFPq8wJkYH/cgQ4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FcuSpLEywbuFAfH5li1/EqYk1T/U3iTYF8qpgkrGwJg=;
 b=J/C+kp6WEAxjSgwmT2tC/6bfjaGJTDqnr+fGN+toIwzrtyLxWxYiOxVMhSD2iSOchmjRD7i4/aQHmiViTdUeIxQKPYc4WYciF/OxfhFoeokT9DH0zsBRFr2hFadLf+yjkF/lTEVxJi6h/IF7gjsllLoyfsNPQIuFhX+cFDLWhb1Nhtj+v745pJi63YxA9uQ7cyYdg8Ohr1FqP0oNEb98n7Ium8gQUeSHRLZ0QnH6wEZr4XsCpRT8WfMValkuQRixIca5gf2ECq40ImDW9eKv7tlZxsg4plNmyOxbLm0AiuFMsL8qMcJaTEYwhUA0i32WX6W9bESB8Ji82Ik66Lnplg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FcuSpLEywbuFAfH5li1/EqYk1T/U3iTYF8qpgkrGwJg=;
 b=AbaYMZtNIHAmMh0o6CLV88gNjwwOgRJKOCCffYcUy5VNxpNvEdr3Pg9TGwLiLyLLk1i375xKVIf3lQR9LJFAHv8KyKB2K9gxx69+3gzvM84+jbJ9cwrOanYjXrpKTC2SJrIoEQHz/fAVTnTjxWmio6+xEwVIf17tF18G84ZFN78=
Received: from BN9PR03CA0895.namprd03.prod.outlook.com (2603:10b6:408:13c::30)
 by BL0PR02MB6483.namprd02.prod.outlook.com (2603:10b6:208:1cb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Wed, 18 May
 2022 11:33:25 +0000
Received: from BN1NAM02FT014.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::6e) by BN9PR03CA0895.outlook.office365.com
 (2603:10b6:408:13c::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13 via Frontend
 Transport; Wed, 18 May 2022 11:33:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT014.mail.protection.outlook.com (10.13.2.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 11:33:25 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 18 May 2022 04:33:18 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 18 May 2022 04:33:18 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 richardcochran@gmail.com,
 claudiu.beznea@microchip.com,
 kuba@kernel.org,
 edumazet@google.com,
 pabeni@redhat.com,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com
Received: from [10.140.6.13] (port=41766 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1nrHva-000DlO-9B; Wed, 18 May 2022 04:33:18 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net v2 1/2] include: ptp: Add common two step flag mask
Date:   Wed, 18 May 2022 17:03:09 +0530
Message-ID: <20220518113310.28132-2-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220518113310.28132-1-harini.katakam@xilinx.com>
References: <20220518113310.28132-1-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53a6b4dd-dd14-4ef0-111b-08da38c23909
X-MS-TrafficTypeDiagnostic: BL0PR02MB6483:EE_
X-Microsoft-Antispam-PRVS: <BL0PR02MB64838DA34E91D2A74BDB5C8AC9D19@BL0PR02MB6483.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +WVKQDZOi52KVr656POlFcTCcthnkkX21sGrRV4TxHHtYKEdLfnRe5/GfF1uQDgwku/KLHeQRDi4caM6Ekz3vODin9f/6B/0/zwQWXtj9fJ+XJKVylFADzp90KKula6qxTS+5448VE6qnN4OlOq1nNDNLXLbxYHCRtEPm7aEMrBt8g3uu6lTLlk772YqwQpfZKxgfyl6KiWHJtJJ7MmSOwkJ6dHzvhIrecbObbATRCsGM5AyMiLM/15hcH1OmU4YuM+HHuI6+qZqT7uTaoWo4ykIWGt3KgLgiNHgH7I1dvI5P21fpOV3QHcq7cEPZwul9yUvCidBD+61loNt4oi6oVrsOGLvwppJSvuFwq7ixZyOI+dZqbk2Ss0t3ZYeagcceXL+nSUq/ONXnIe1wBljRKitQQlZewn7QFV8t0BuLJB69iKYsXEPcdNVlBNqYaAoV1qe+2cigEFakftRew0ZRHjbRc6rMgSKexgsMbI2h+DvX1jo1r/2ST7biQfG4edUEBaKb4LovWSxf1sKmLoZ8JSQcnAXTyouxjCCF7ynpQrbYpVph360DKi7uAvROVeY6/weI6hFDkKGm5w7+17gj8kgOWftzSbBu8lyWbsj+ZRDoCc2taGepvnK+SuBaFu9/bsb8LoDFj6quFHQZ6WTjx6BKw93DHTrv+FH+beHbJZFhcw+yqq4JO8W29AfXyQGietf6HkYFhxZgB9KKFGWxg==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(316002)(8676002)(54906003)(36756003)(82310400005)(110136005)(70206006)(70586007)(4326008)(36860700001)(508600001)(6666004)(40460700003)(356005)(7416002)(5660300002)(7636003)(8936002)(44832011)(4744005)(9786002)(2906002)(186003)(7696005)(1076003)(26005)(426003)(336012)(2616005)(47076005)(107886003)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 11:33:25.6646
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a6b4dd-dd14-4ef0-111b-08da38c23909
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT014.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB6483
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add mask for PTP header flag field "twoStepflag".

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
---
 include/linux/ptp_classify.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index fefa7790dc46..2b6ea36ad162 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -43,6 +43,9 @@
 #define OFF_PTP_SOURCE_UUID	22 /* PTPv1 only */
 #define OFF_PTP_SEQUENCE_ID	30
 
+/* PTP header flag fields */
+#define PTP_FLAG_TWOSTEP	BIT(1)
+
 /* Below defines should actually be removed at some point in time. */
 #define IP6_HLEN	40
 #define UDP_HLEN	8
-- 
2.17.1

