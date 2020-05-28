Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAE81E5ADD
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 10:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgE1IeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 04:34:02 -0400
Received: from mail-db8eur05on2068.outbound.protection.outlook.com ([40.107.20.68]:19560
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726939AbgE1IeC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 04:34:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNMDsXPjJ0SOay/sEEVO4C9ASGSw+Ktm8DshyajerhrsBBSQgHFjRREbsXTtLERTaCxT5EeC+gIKDKtKf0ipK6/hEzWQg29QyVa0w6oAczf3R3XJFd4T+HgtzJB6nlPuKe4j0Bwlok3R1En/y3PfD9rjPy0VieMriZchsy5pPwFJhPyYpGIeCzFAfZwc/yzi4nN5B4URjjm5Vj3VbVH5JaFG90pk1bTAExoMAx6AAlRR5w43qX6kr0mW+KNQR90dsKD0HGcfFRnMQ/30Iah/BXRxvw3wJUvgHOJVjGqkwuAUH+WN4keDy4VHCjStu07sFdGsuJQbBSCLSOi8KZNkag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHiYWTcm7RM6EbxYOIgI4uOXuHqgKhfzEvbnitwYWgs=;
 b=oYnvneR73r0mbWcZjM3qOlSUARjVLjmhjLdh4gniu5nU3gzY/2qG2Iat+mbfyQVnWBDSBJXhTydsA3JXy+Dn//94NNxHwyvIa4Cun1UmJXCPaPR5cjkbu7QGYA2ZszvhEz6slLkAYvty2962gXIRkNN6i7HRudPXbLDeUWFZ2KRoica1xDd1m90bRVK8ok7FR7o7xrVWR64P/5OXEHJdUX9Oq+EDIOlXsx0155X+3kqV5d2JmWt+IfCfGLt2mb9KVRSOWUfV3cJ2Ere5fp4wL396mSdy4b3WcjxNV12YMdeYR7Qn7QGSo7nUphb7b8ounz9rYUoKmLdH0k4tWms78A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHiYWTcm7RM6EbxYOIgI4uOXuHqgKhfzEvbnitwYWgs=;
 b=kSmqDb+PMmElAM/xM3BJ/ZoAAuau8s31iFbt6UhqasWCUUSC/MQaP7aj2vQolJtFIOdclVwbc0qlDGnqbdSy2/x4KCwj3JliCZ2Rx0TSfI58pw7im3aqN06anuDtR7OLLibKGS+UvrysBpfLYWAgmVt3L/lwvfMdyhhAxTuVHdY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3768.eurprd04.prod.outlook.com
 (2603:10a6:209:1c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Thu, 28 May
 2020 08:33:59 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 08:33:59 +0000
From:   fugang.duan@nxp.com
To:     davem@davemloft.net, andrew@lunn.ch, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, mcoquelin.stm32@gmail.com,
        p.zabel@pengutronix.de, fugang.duan@nxp.com
Subject: [PATCH v2 net 1/3] stmmac: platform: add "snps, dwmac-5.10a" IP compatible string
Date:   Thu, 28 May 2020 16:26:23 +0800
Message-Id: <20200528082625.27218-2-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200528082625.27218-1-fugang.duan@nxp.com>
References: <20200528082625.27218-1-fugang.duan@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0401CA0014.apcprd04.prod.outlook.com
 (2603:1096:3:1::24) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611-OptiPlex-7040.ap.freescale.net (119.31.174.66) by SG2PR0401CA0014.apcprd04.prod.outlook.com (2603:1096:3:1::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 08:33:52 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 36d281fc-d010-4b35-b73b-08d802e1de2f
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3768:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3768F13521ABA66C86F2AADBFF8E0@AM6PR0402MB3768.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3L3YgSorhCTELhHqY4qVDZ2DcTHq0NDRkMnSglS+pK/8N/Ewqkbj97PuYqwZYwRqMW7j9TVMEmOyHhdyoGikX/0iR4Lf2wsSEusVF1H8cdcvhhznoOxMH45HM706N64GyKWeVTd+FCqVJQnU/khi/FjXVH5cXOu4Uxrh1AW74oACb6TuWqLIoBFVhQc6MfOUOvW5C528q8DyMr/n0Ofa2yNJXbxTejmEPhN9XrNSgXzMZtGs4m7dB9qyeYa+XbrnjDXEBbgafBhzUFt6e6smavjLThHDgUH72VrbjLV68HsnMVbBXX7yCUpGD/6vDbW6APk3szhVIeruEpn6GUsjZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(5660300002)(8676002)(36756003)(26005)(86362001)(16526019)(186003)(1076003)(6486002)(52116002)(6506007)(478600001)(8936002)(66476007)(66946007)(316002)(66556008)(9686003)(6512007)(2616005)(2906002)(956004)(83380400001)(6666004)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wD/ixxdPFyMJnLM44+B+I887D5d0I23Kl/CHpIKtkCFdXWpLsjxiBV+rs4UxrCdgU059qHwP2dpD2x8oUFM/MBIhf6IClZ0kuwDfdNNZ2yG9XhDN8q2fke2owzIbH7osoaROZKfLFsgI9xBSuOgtq7uiCM56Ba+Vhkdwiff4lsieyMbZlz4MVZs1YmdFvjSSKfxlSsHGoPiNbVQUtNLYgxJ83F0migfNKlg3yTfvImkPnYEFe86wFMBJ/a9OVO2Q2l6+HE0s2WdFvC3iMkP9JHVniB1naHwUlBrxyEoiuZPB+u/1tB3CEsG3uAakAIS++8OMEIrBYejXjxrf53l+6TynFeDpXRhvL3PSswrZ4F0iTshHW9xwSGi8Y3iOcp8BevSN7TAVpyKyHT2Wn5XcTYhPSDpgYNSkwa+w6nO14djhP4PNa6GvVCFZvw2pCDveK57sO6mRbCbypDIaURuboSgcRPk4QalHIoUOHsi/ylqkv0Wnuajkt30i03nNeu9C
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d281fc-d010-4b35-b73b-08d802e1de2f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 08:33:59.4570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: URJTq9pfiZLxTW0DSg3pYO3wgpzyF+OaT/1QTmeAgRd/GguJLAYSNGFF7w+FRT8QU2yIrBLYKUw+XIQrC1W2iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

Add "snps,dwmac-5.10a" compatible string for 5.10a version that can
avoid to define some plat data in glue layer.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index bcda49dcf619..f32317fa75c8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -507,7 +507,8 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 
 	if (of_device_is_compatible(np, "snps,dwmac-4.00") ||
 	    of_device_is_compatible(np, "snps,dwmac-4.10a") ||
-	    of_device_is_compatible(np, "snps,dwmac-4.20a")) {
+	    of_device_is_compatible(np, "snps,dwmac-4.20a") ||
+	    of_device_is_compatible(np, "snps,dwmac-5.10a")) {
 		plat->has_gmac4 = 1;
 		plat->has_gmac = 0;
 		plat->pmt = 1;
-- 
2.17.1

