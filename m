Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4672F640CF7
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbiLBSSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbiLBSRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:17:41 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2065.outbound.protection.outlook.com [40.107.105.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19238AE62;
        Fri,  2 Dec 2022 10:17:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CtvjV0yuJZzI0BQ/Khgymd3IatECjDijHZh7W2Xb6telZGGD2AdZM3QUd93s0eAZltQ1Kj5HT/7d+qSDZ1NJX2fUKweOMDUB5Rb3+5/XHE26PZyrr2On2hlqo1ZCeAdZVfeUapbkOT62im7EA50II/KmtPSqTe8hOag7B5cvjHBaiMH/OLfRpA0BZ8tP/FpWUUM+lGwYkSmJ5mui9dFzLTHWQrnKw/eOBl5209ukyngFtK3NpePtNP9N0m7Vm58hAXl8J/nC2FncHhfYbDNhSZ0kGxWl5PdBpt/OyJGMbiiXfhEl7fjxA54rh+Q6JvbddojJ6vcoP+Htn7lmtsW7pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jLqIuvf2AT5eFpBCvndQYqDKO2eKnKNkuYn/2OiJIOc=;
 b=mytW8ynY9jPHlun9yD/g64ihzYzfQRYgjuJth/DFLRe4ckevO9mi31vy/i88VHYQIzmHXuyPQUpGA/sIA1PzrwKOkoH6BFvqrWmdGCKurG969BoR1qhwj2rv1RC16e7wrOL8zD2ZRsE2OkfWRa4QZVNYlNwxXdl88J4A55N2Zrlw3Sw3+ZHAkcJwwWzENrtFcX4TJkL8T531KSjfmash7UpkORCI753s4RXI/KaHhFZCpeCH43fZEWZdggkyJlVN30s6DmJqbLpdqjYDK9XgSJ9RvyKeguWkhe3NMy/z9lhEN84v2isUyGtr5xQGeL9j9DpoRQDsMZG46zeEtf0wOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLqIuvf2AT5eFpBCvndQYqDKO2eKnKNkuYn/2OiJIOc=;
 b=HjUHJdY4VVanWXQcOvdj94P/7fNwoJjbDSQAjNf9V0SYPRKMUscLhnSVYlF01rqZmEPQ8l1UH+uSkcD7VOhWhe6y2YPQvck86Rlm9Rrs7HhRsucnLl/DB2+N6wXwdWXRFk1n+9oglvrUkqdRffHkmbvhoTsnM0qcs7CkONYjeK74KzuVSQrHjVCZCLpzaDMm+7TyuySrb55LiQ+BCogq977jAtjY5zy6UQwuxZjMZsMIiFf70T7yB5s9FvxKsWKB1PSTOg4BGms4rAQGlwtLC0JNn2V5RHifBcNPzg+GXIL1vbQO1o3i2qCVtyR2R0tFj9Gp9zkCGdBCh1Y1ZZHTMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DBBPR03MB7081.eurprd03.prod.outlook.com (2603:10a6:10:206::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 18:17:34 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 18:17:33 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Tim Harvey <tharvey@gateworks.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 2/3] net: mdio: Update speed register bits
Date:   Fri,  2 Dec 2022 13:17:17 -0500
Message-Id: <20221202181719.1068869-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221202181719.1068869-1-sean.anderson@seco.com>
References: <20221202181719.1068869-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0012.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::17) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DBBPR03MB7081:EE_
X-MS-Office365-Filtering-Correlation-Id: fd0298d2-e48d-4506-9f05-08dad4917bcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LL5zXNYqS4To5D/xZVvFpba7zmLowScJCTHl6IAZu0tlqA7aHM4DLE/Vbq5loXA2RLeu9d/IhwTNqu+89tMLVoRX1/2asUtSBMJzRom+Bxmn8G8TfcZ5zEBMr7iFY5A8rszPhSdnY0NjdFcxEFKFpq3poJRHeF1alXN2ucJcu8P00hrE+vZdqZh09mueBAiB4bgpiGVTZmaFO1+150iAzWzNz1WzP7q9NjZ5DSHEfrC6VRmK4NnwWLjzAfh5wmI6T5B/Z9PH0m61oqpbfztAhhGYmVDLBRuxcdfG6mYlUgJZ2Lz03lOhYehoaiysmQOKa4yjUz0XrKj/44QbXHKKmyIYm4R2a6gfNNORKlD1SUCHdyuJI+zprbk99BQuBjrR6VGgZqbShvaix5RcgCiVEvwT8iZsjp6zfZSKtNYCXSXqo6YwrqeFEA/d3fUEqRO0QFFVRfvad6WWAeyiKf9NqB9rwPY5L+9dU9r56tj8HEotBiScmaxiUp7J3Fk9XbNJl6X9YzhT4Ccpq1FEGlFqQMp3wMzpSsL5jOHP4DtkwhDokbClVGpR60LAvo+bSDI5TbXbXnrgQ56ZZUoSSIWNqwiUM2L2JXnl1b5dAhxsvBH4tDu6OpmAm09TMYDRiO98jVAL+vfOS5roz3hxfG2xc4Hr6m9SKtxkMiYwBFdaCQWRxxaq0R6ByasnL0gnZ5Qo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39850400004)(396003)(366004)(376002)(451199015)(36756003)(38100700002)(38350700002)(86362001)(54906003)(316002)(110136005)(8676002)(107886003)(6666004)(478600001)(6486002)(26005)(6512007)(6506007)(52116002)(83380400001)(15650500001)(1076003)(186003)(41300700001)(2906002)(66556008)(66476007)(2616005)(7416002)(5660300002)(4326008)(66946007)(44832011)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4UfQtgRBUIUuP93m9y4qE7Jl4IJYOPFQ9KRv5+aiwY2qtKX+OHCLmseslCY8?=
 =?us-ascii?Q?CIuUFELpcmmA5O1qHJdwCjQ+N8XcQDXoR2V1KsyJABliClL2WcihUZCEDOU/?=
 =?us-ascii?Q?A0gXL9MKTyoeAaN9UsciM9KLNVlawFtKyD71BUrUnDxhjnyFGSLGQ/T5FlKQ?=
 =?us-ascii?Q?VQro3esjbdd94P780L1B59Iz3Rymoenb5HJLLSrrlTok+c8CjGI9U0cnYVKU?=
 =?us-ascii?Q?O37GPagrXGh3BjCc+BK/xuKmfYgdGuP01Ad9LbCWvM043QGRzj01/jmHKxje?=
 =?us-ascii?Q?Dd5Oi499IsySg9EMJgIU8bWpuH/5ETCpexVRkQEQaFHK+1Lxbd6NkzVciVKX?=
 =?us-ascii?Q?K9943fXjZwnhvo6TBbwiC9EeTtxeVRui81cgKfMaq19HNlS9QFeZIlZMS66H?=
 =?us-ascii?Q?baCWf0qEziICR5jv2x7gtao1dj+AUGFnuv/WgoozDMeJubeXAXWd+++xTCif?=
 =?us-ascii?Q?LW3Z7tugXiYL9TipjBBJfYQk40qy8XtlZNytt0fnAAJCZh6lXGm858QsrZGN?=
 =?us-ascii?Q?Rru335h3aDdYPBg8PMzXrCwcJ0KwD9pQmPKdWmdxnJze9x79qwPmCGw856GP?=
 =?us-ascii?Q?lQpY4j5eAZA1fcEi3Z5nQ1CkJo92IbLCjWLUfgNOwDza3r7o4gVxnWGWQ1oU?=
 =?us-ascii?Q?iULDoqwpyyrViMNgcVUgmYLBLAzWnPOCgqJKuaDgHWKfEM7JxyD4fjhOCBCQ?=
 =?us-ascii?Q?4dThkj1pP/HTqolyQJzOa30yYrTsMN3mnkRjl6dRKyU/iRpRL+GGLm3MOueX?=
 =?us-ascii?Q?xbZzz6RHwPmCkLuegte1KOYFJmXdwlSFme4wbfN6rzB51uJHjlrDm3L5WyN4?=
 =?us-ascii?Q?MW36Jq9MbONch+M2XSeWwXsmD7URO/82B483eQmRIUCjUsHsmeJ020CtqvBU?=
 =?us-ascii?Q?utM3/H3W2FgUXWD/vrRP0k2EmvQTC5U9PvwNlE+BsxuhoxRTINDx64Jj4DWT?=
 =?us-ascii?Q?jfDXoMD7fTT4sHMKu7SysXOXT01Pj613WyPzsA8CJ38B4cArrZQdpYSlV4rs?=
 =?us-ascii?Q?wMub0jq72Y2fTLvR7mYMtJgB/H+z+sFqc801IfjNChG+zXs+ZjY1nLfhS2k7?=
 =?us-ascii?Q?Uny+MAdu4Er+OoraEvhFJTepqEh3s0OPqwVslzNiugE4HZ0nfW+pSGYbisPr?=
 =?us-ascii?Q?70UJM4728RtsSSeAfzFceqj6rY9ybW30xkEhunqFkfgQrKo8nI/7ecqY9D2+?=
 =?us-ascii?Q?hJKX6sn96A0m8eMymvq/Fujerv4CAOp3D30x60PHUfeCFSAZ8c/NHb3Vs7E6?=
 =?us-ascii?Q?MNB2yzLoJG0Lai2595njbz2VBiDFZwee6C4cVr2cARWFuNkcfMCw/WGFYJ6X?=
 =?us-ascii?Q?4vO9JLY5OQ6bk7EWmAi7K85wT81xIKIHMkSMvVulHtxZ6Prc/NCB4x8SsnY+?=
 =?us-ascii?Q?iEuLOuBOsCTmLeZFnJ6RVy9xNR5+1ChxxEmsLW5p7cmrOy1jFjJogBu/5sDa?=
 =?us-ascii?Q?80nH8iGyzbBpWBbkh/VRyhr/LoP4+TLszKsOgJHeiL7kqNSdIMjOoUJ1Co/G?=
 =?us-ascii?Q?2lrfdMu7werYezWH/g6VYgf9GGhllpxNn5mVQqOdwhbAPXK3GgcUUgywGjgr?=
 =?us-ascii?Q?wyHcEBRaH8SoAKocOfLcm9TSXgOxMyrpmGRg81XeWymUo59bYOjN55vPOF1B?=
 =?us-ascii?Q?gg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd0298d2-e48d-4506-9f05-08dad4917bcc
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 18:17:33.9637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: plOZGw0jPaZ/y/1Qmtc9HRbM3CD/ef8o/yST1AzdaE8pBtmuhEQxvNGgyNrEzuXxfUU+OHec9j9ZYVXw1xXGPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB7081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This updates the speed register bits to the 2018 revision of 802.3. It
also splits up the definitions to prevent confusion in casual observers.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v3:
- New

 include/uapi/linux/mdio.h | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index 75b7257a51e1..d700e9e886b9 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -127,16 +127,36 @@
 #define MDIO_AN_STAT1_PAGE		0x0040	/* Page received */
 #define MDIO_AN_STAT1_XNP		0x0080	/* Extended next page status */
 
-/* Speed register. */
+/* Generic speed register */
 #define MDIO_SPEED_10G			0x0001	/* 10G capable */
+
+/* PMA/PMD Speed register. */
+#define MDIO_PMA_SPEED_10G		MDIO_SPEED_10G
 #define MDIO_PMA_SPEED_2B		0x0002	/* 2BASE-TL capable */
 #define MDIO_PMA_SPEED_10P		0x0004	/* 10PASS-TS capable */
 #define MDIO_PMA_SPEED_1000		0x0010	/* 1000M capable */
 #define MDIO_PMA_SPEED_100		0x0020	/* 100M capable */
 #define MDIO_PMA_SPEED_10		0x0040	/* 10M capable */
+#define MDIO_PMA_SPEED_10G1G		0x0080	/* 10/1G capable */
+#define MDIO_PMA_SPEED_40G		0x0100	/* 40G capable */
+#define MDIO_PMA_SPEED_100G		0x0200	/* 100G capable */
+#define MDIO_PMA_SPEED_10GP		0x0400	/* 10GPASS-XR capable */
+#define MDIO_PMA_SPEED_25G		0x0800	/* 25G capable */
+#define MDIO_PMA_SPEED_200G		0x1000	/* 200G capable */
+#define MDIO_PMA_SPEED_2_5G		0x2000	/* 2.5G capable */
+#define MDIO_PMA_SPEED_5G		0x4000	/* 5G capable */
+#define MDIO_PMA_SPEED_400G		0x8000	/* 400G capable */
+
+/* PCS et al. Speed register. */
+#define MDIO_PCS_SPEED_10G		MDIO_SPEED_10G
 #define MDIO_PCS_SPEED_10P2B		0x0002	/* 10PASS-TS/2BASE-TL capable */
+#define MDIO_PCS_SPEED_40G		0x0004  /* 450G capable */
+#define MDIO_PCS_SPEED_100G		0x0008  /* 100G capable */
+#define MDIO_PCS_SPEED_25G		0x0010  /* 25G capable */
 #define MDIO_PCS_SPEED_2_5G		0x0040	/* 2.5G capable */
 #define MDIO_PCS_SPEED_5G		0x0080	/* 5G capable */
+#define MDIO_PCS_SPEED_200G		0x0100  /* 200G capable */
+#define MDIO_PCS_SPEED_400G		0x0200  /* 400G capable */
 
 /* Device present registers. */
 #define MDIO_DEVS_PRESENT(devad)	(1 << (devad))
-- 
2.35.1.1320.gc452695387.dirty

