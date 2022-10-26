Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1224F60E446
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 17:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbiJZPPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 11:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234321AbiJZPPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 11:15:48 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942FD7FF84;
        Wed, 26 Oct 2022 08:15:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XRQl61kOzm8m2XOOfFZbpbAo6UpZ8R9m2zASxbgbEh27B1bSXbMwnkcpDj8BFxo1pgJ+UjelX+NicsVwb3ecY2pT9WVhG0QvUjoECNmj6uZmZ5culAGyNzM8zD09B/pgqN1cYgU5l7Ry7bH2/gW0eD36f64m+XFpNRdG4VaTTABAGI7JQB3wpmuGf3F+bovmiF9WCiitBTM4FmTWSIFKknPIvAS0a0KX77lbSUZ99yJUnA1rg8IGdKSwGmNUEWAszHH/42c6ivr5Ezy7OgKcBgADilUU3u/uBF8njw9G4RHdki9PTSxt7kQBo2kdxdWFqtSItuNwxj4oMx20AybPMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OBoywryoQlg9SixBF+WF9QRtiOzpkB6a9mEh0+x21c4=;
 b=SfSI0HIHQwkrD0qSaBeW0BHpbWNK9wxCp4/3X44VIzRgWoc3scNocBLoumNiKxJamBrfk9u3LUBAicnXwm6sVILlT3e69qyaRdGCtZdRMHfUdGde69w/VicGHGq+vY8ud1MG4b9H5BRV3Fh1yZXhakGnqdz/oYHJ8hMiKEAD1wRT2tLIsGo6xTrpuoDAWXQEiJV+JzKmv8lwUbx6cw5HVviABXvJaNhnBqgTCYGciyLQvRKUhCTJg1KyXblOXDaRp3sKIvtkTo5bh24q6SRDiRPk0SkUpBwex+LuOy7U4jNZR24kkvpiL9E+dyVeDDCuOfLdF+FxWBKOcUgPd7y3nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=amd.com smtp.mailfrom=xilinx.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OBoywryoQlg9SixBF+WF9QRtiOzpkB6a9mEh0+x21c4=;
 b=j2Nm4rmwAuDip9XtTT0Jsp8wBaTfnOXn8vH/4baBlwNsC5QiyS6wEz6AbplcbLxqspydCbU9x5HiXjp+TN+bP8algw01Fi+Vv2CHDgLCA3dOk1WSxwGdO6NpA/bKROeGFLr2CyPJgQ9tc7IhtSnD2TXVj6U9HOB2pN0dx38Y6DU=
Received: from DM6PR08CA0050.namprd08.prod.outlook.com (2603:10b6:5:1e0::24)
 by SJ0PR02MB7661.namprd02.prod.outlook.com (2603:10b6:a03:328::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Wed, 26 Oct
 2022 15:15:42 +0000
Received: from DM3NAM02FT004.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::e7) by DM6PR08CA0050.outlook.office365.com
 (2603:10b6:5:1e0::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28 via Frontend
 Transport; Wed, 26 Oct 2022 15:15:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT004.mail.protection.outlook.com (10.13.5.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Wed, 26 Oct 2022 15:15:42 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 26 Oct 2022 08:15:40 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2507.9 via Frontend Transport; Wed, 26 Oct 2022 08:15:40 -0700
Envelope-to: git@amd.com,
 radhey.shyam.pandey@amd.com,
 davem@davemloft.net,
 edumazet@google.com,
 kuba@kernel.org,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.3] (port=40015 helo=xhdvnc103.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1oni84-000D2d-KA; Wed, 26 Oct 2022 08:15:40 -0700
Received: by xhdvnc103.xilinx.com (Postfix, from userid 13245)
        id 7A38710550D; Wed, 26 Oct 2022 20:45:39 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <michal.simek@xilinx.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <git@amd.com>, Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH] net: emaclite: update reset_lock member documentation
Date:   Wed, 26 Oct 2022 20:45:24 +0530
Message-ID: <1666797324-1780-1-git-send-email-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3NAM02FT004:EE_|SJ0PR02MB7661:EE_
X-MS-Office365-Filtering-Correlation-Id: b1b063ff-51d6-499a-de6d-08dab764f2ef
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 79X2fvJtbepAvSlguQylfHiKHZBg5QJRaX+Qq/1y52JO9aWSh4CKWu0Gvjw6vXH++9K2pGTPz/deFplGDj1qdjpm01VSBrg1dEVx4gTPBoZ+Sjwo1ZLjLNdJEAgLgmebILdt8ET0nn6NF68U/vehqFTGBfF3n0QcQi5sxl7ngyfqk8ltEEWJZDpaFPINdVAive/fB0KccUBPDP25RFWr0jnGgoSMcKWll9oLgnzKBKC07RMEFkdyL5e6ldZwshxPL2Psuq2X60B8bp6BUU0BFFtLS2TYwaqAv9jiKjw8Xdr9alzOvWecvJJ1N4+swPq+P9Vi+m8Td1QVCZh0BHO0XVsjz2XHKkCuQ1jEV4Xbbm+Akl0ZbY48zQbB7Z8oyoQ8PnAjinS/SeaLfxv/0fuTfKuVvlXF4kbahRGww9hpinDlbBFQK97QEB1o89Qao5tK2UnESrdqGBG3H5TJHORAnV2+m3Lm5AlVQSsBsk5nxCocaJDQNUpMjA22/l6yWMOVEN4A6A29/Raw4RRQZ8BeiKswfN0D0I/J0naSR3mp8huFEERRTB1b4W3OZlmGyKtSy03Uy57t+2SSsrACJUpwCnjdgx5N/qnh2fA8HLiwQ1f9qkuy/iQ2nTxnPo2olj+fCJ899uvE3fhUB01sdgqgwIHFwDOQ75qK3165POImSa1NfgBwk/eG1UXHWHkzIcarMGfwdBT+G41VEr/lRO4qNJAkDx07wm/1eKNJj+ydMeLMhfOywJwiO4U4CAOVTqM4DIvH54DmuVNeRn2+Q4wOiG0dUpR0yJ0/30Z/8kTLbxw=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199015)(40470700004)(46966006)(36840700001)(36756003)(82740400003)(7636003)(110136005)(83170400001)(8936002)(70586007)(5660300002)(4744005)(70206006)(47076005)(83380400001)(42882007)(36860700001)(356005)(54906003)(2616005)(26005)(478600001)(6266002)(40460700003)(41300700001)(2906002)(42186006)(316002)(82310400005)(6666004)(8676002)(4326008)(40480700001)(336012)(186003)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 15:15:42.5203
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1b063ff-51d6-499a-de6d-08dab764f2ef
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT004.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7661
X-Spam-Status: No, score=0.6 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of generic description, mention what reset_lock actually
protects i.e. lock to serialize xmit and tx_timeout execution.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 05848ff15fb5..a3967f8de417 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -108,7 +108,7 @@
  * @next_tx_buf_to_use:	next Tx buffer to write to
  * @next_rx_buf_to_use:	next Rx buffer to read from
  * @base_addr:		base address of the Emaclite device
- * @reset_lock:		lock used for synchronization
+ * @reset_lock:		lock to serialize xmit and tx_timeout execution
  * @deferred_skb:	holds an skb (for transmission at a later time) when the
  *			Tx buffer is not free
  * @phy_dev:		pointer to the PHY device
-- 
2.25.1

