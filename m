Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95182396150
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 16:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbhEaOjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 10:39:11 -0400
Received: from mail-am6eur05on2118.outbound.protection.outlook.com ([40.107.22.118]:17120
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232946AbhEaOgi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 10:36:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1wzkRxfrH0NU4zkesFV20SPaykB6GvZrg6+uyvlbG6w/XNH0qlvatPhIih8cQVyS4hLEo/W6gqP2xN81Nw7ekp7GCQ4mfb3K8QB1w5gzl38mlzZBBZuFgYqvfxDNJhO1+BMmcduyWxpa/iYJeCNVNRf6S4kjT/frgOndYBq7nxxzHZMGO7nlXzTqhnK/FnoojLPrE+OEaQe6EqhtDM66AlY4AVUFHl3JAU+WsOPDV2NJOWJ8uPgWZ3TaPGiHPr5rZ0R/L9ySGINKg3CoVsGkeND990ncYruTh2RHrDgGmpFx+dszpCy+FGZmSin+Vb9WFvhWx0qzOS2a9pZI/Af3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nm5M0IGogy/b30i99jK4zCqxL/S9+iPH1g7g2oXLShg=;
 b=E/67bw3QdgrX3UZ3tWSjuRgPVlDTEESo0Rb+ODwCu1D0LN4Zt5KgIFl4iaCVHiDvxxIdocezVJOxui4SWLVliI6Q+R7tPvd5q52Gbc9jxThb9EgYMEbDxc4x0CEIZ1GYYxeG5t4mFcmDqVCciqIfVQO/0QcoCAmrQKg2W8+q+E0hHiWFDK5RRphH1YC5AGP7ZEavqjZR/uusL24/T+Bp5CBA5YuelhxLQnjZRxXkGpCsX/0Z8kQjf9s7NIyRQ5H8bK/jeifD5/zEaWPEP8hmtGOO4sq1TbKzq2ANNXSQu5Xj7BFwxDwh0pluSVKOp7M9Qws6MtZVXo02TqTDoWMUlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nm5M0IGogy/b30i99jK4zCqxL/S9+iPH1g7g2oXLShg=;
 b=p/JvhLdpObUosgU/EY1Ab8PR3G4Ec/5ZkgKYP9Cz8mMySZYdqPkyiW+BcnPiF7XUKTeFbzbOB5KQA0wwmWVUQ5ILZ/mAHswl19B9h1d90Rf5yTWWRCoXfKFp8dTWuDKGOd2PFaMKdHBQ80ky3vAb3/E5b/i18NvqbeVCMGNQs84=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0459.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.29; Mon, 31 May 2021 14:33:27 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a%4]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 14:33:27 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next v2 3/4] net: marvell: prestera: bump supported firmware version to 3.0
Date:   Mon, 31 May 2021 17:32:45 +0300
Message-Id: <20210531143246.24202-4-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210531143246.24202-1-vadym.kochan@plvision.eu>
References: <20210531143246.24202-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR04CA0036.eurprd04.prod.outlook.com
 (2603:10a6:208:122::49) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM0PR04CA0036.eurprd04.prod.outlook.com (2603:10a6:208:122::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.26 via Frontend Transport; Mon, 31 May 2021 14:33:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4d1713b-c526-401e-fcf7-08d924410dc4
X-MS-TrafficTypeDiagnostic: HE1P190MB0459:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB04591A9ADA00FCA7607C1BC1953F9@HE1P190MB0459.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wlOi/3iD/CJJIz2gmUmJMmBNZYjcvKQ/aJB+dsM7so6232KjCy5QnxlgeWV3o8xFrcdjKCTwaH7o3Y1rVbCGlxTsff49Y8N/gGdjjPtbOMcj1tdSDqAqdOLC+l9CxXiavhY/e9WYvoKigjtYS91jz6NdSK+ev8im3q9mB4yIJTd8wOfUkI7JNJnJlVUGZnLt3P7yxA0GG0VrgGCb8Zsbj53+nHs4H97xjYXgvtOx0ifWHoqmlU2RAOlrWRYAm4bc9MhEOJIRoVsol+uH3QioWVLLRP110sgHehUy7Vl0Qu47x4hjr4catC+d+dQUu4JEUO44WyPvTA7OSoKh69WbY2UHNT29KgPv+HteHLQ83WbkA+rgKxj9Ip7G5y4yflal+Q0S6NHnw7VFzZOAMAYG8GIMcq/KUMs0LjCB0xV/lAQAdoRg3yhpxk9REg0/sEooB0UKxRVpQfBrirw+yRqXND6A05OA7ePB6Wfiyk2fR8LEV22+ct4fR5Hx0z0nbRamqzCW5s6llDnr1URcOOgxinyS/MC8LJE2dJwutfVlZdk+i9soeIIK16z4X1IQZPNlaKHCvl9im2ITCPFoal7i1T2nvSMhulNcKe1OAXtU5u7djfhjSySUPiCYhAVEXB+2jX/OyjrDpt6VS5OpCpYMzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39830400003)(136003)(366004)(16526019)(26005)(5660300002)(6506007)(4744005)(8676002)(2906002)(6512007)(6486002)(38100700002)(38350700002)(44832011)(316002)(186003)(66476007)(54906003)(110136005)(478600001)(66946007)(86362001)(66556008)(2616005)(6666004)(4326008)(36756003)(83380400001)(1076003)(8936002)(956004)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dsx10KngfQaXIDR8aSpt3V1yURAzQS268D1VIurHJ+aTLPbaVbpWwDQDXCNj?=
 =?us-ascii?Q?L5+ZeP9KYxoEMNDKh2IM74ZKEUvB/9ah1Vpv1Ujfacm5gKwFzjRqA4o2CaWl?=
 =?us-ascii?Q?DZUuYkg/4iDgl60ENBuaYlvurqomdYEXCmgyr8b5RR6wjtzSDf4rZ63CQwRL?=
 =?us-ascii?Q?rSRD2xWdqgd+uOYIh6DRrJjIdMmD5uFBZh9CyyC7lTlN2b2rOJCRg2lampJK?=
 =?us-ascii?Q?T8kZk/lxuczjSvnJvofcdNmJInGPFq7S7a+dhJjJZ+FMOT1Ts8ZPfsP/6NcR?=
 =?us-ascii?Q?D9sZDHSAHhZH952iGFXjZnhcukBREeLGxZrtLANv1MbhxxYVljSqsVr4E7Y2?=
 =?us-ascii?Q?97apSEEZwFSaSS+aZtKIZdpNofLWfOW1rDe6yOrXPfXC00zuLjroUDycXcKD?=
 =?us-ascii?Q?0GcqhKqat+bzOQTTNVqc4RzHYZn/hn5BZZrpIETsf6bGnx2BfExXw6/x3YuO?=
 =?us-ascii?Q?7A1cDRAp931t+ohDK5ZzYEvewcqOL58Q/e6YIU4tsFUaJ+X3q/PU9CuNF73x?=
 =?us-ascii?Q?2D1UJa5yVaxhKKXJGZaVWajfwE86R3lgjaM+cFOpiDy4dCQImUKybdpEnaYm?=
 =?us-ascii?Q?rnbAitqssAFWG9JZBGltaVFDmtPqvAmVptfSQ7kRw0UnBd2gfPNA40ZOfhQ5?=
 =?us-ascii?Q?OHvfy2kgPQMg657kqST/ZR4su8+pyqF9zqTMZqgWb1/1jui4pAgnTb/oPl/W?=
 =?us-ascii?Q?aZTnQmSiPZXzK7J0cox1PP6Z2Z59olnubqpA2hYJKsiP31DpEYa3EYRqAsOU?=
 =?us-ascii?Q?1T458FIynpSJt15E4/xcu37ox9j975sketWBx+ie00caSJ5bGJ6vYZ8r6Hwy?=
 =?us-ascii?Q?4AtRRm0jqbLQwD6iTJTj9VbOJPdViRl+M2xkqZ5vcfQWsGkkcCbKf0LJ141r?=
 =?us-ascii?Q?ZLAMdZvXKGsEIMiCTMCKbztGwOUUJTFx29VW/YMHoAGbFcWo1uSNdhFHqqWI?=
 =?us-ascii?Q?2O55gdylKozGLRPys15x7/uFskMEhbE5cROuOk4MI5tZBKVPApcBzw9z/ZcW?=
 =?us-ascii?Q?+PspcnH1wxN73MsQVQG3i1tQSyt5kg9Ph6DEIP9F3NtqG/+onP0Icl1nsLs/?=
 =?us-ascii?Q?A+pBbgMyuIFrz0ZdKcEEPzUEYgTbrCN+UdDmlauw1e4vS+mz49YNsw/LdsIx?=
 =?us-ascii?Q?b225W0lwPjbfIWM3c98j6joEJA4ScR6AWbzTspTrzb4xfmJcpscW7ST+ywkX?=
 =?us-ascii?Q?o07omPwjPP0rK5dAKVx4yFiLO6F7+KmjGxIzFVH6PfdzI1S9D+klCg7/5OS8?=
 =?us-ascii?Q?/Ksc0DoHz8M7nF2+xJZfsLvpl/SFEV839jw2+EPLAjZPAqZNXjzYnvaDSRIY?=
 =?us-ascii?Q?vm7tiZWJovO+U9kPSNMhPGmb?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: c4d1713b-c526-401e-fcf7-08d924410dc4
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 14:33:27.4052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iFh30CkcyDXxGJeSd5Q8IZKSwxVDgsHZMk1gJAc2pdM7MT6dSNXmgwOXluxiNFZ/3i5yCEMyBKG5pyugxI5yHgzUtELBgyW95p1ikrCBYQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0459
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

New firmware version has some ABI and feature changes like:

    - LAG support
    - initial L3 support
    - changed events handling logic

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index dba6cacd7d9c..5edd4d2ac672 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -14,7 +14,7 @@
 
 #define PRESTERA_MSG_MAX_SIZE 1500
 
-#define PRESTERA_SUPP_FW_MAJ_VER	2
+#define PRESTERA_SUPP_FW_MAJ_VER	3
 #define PRESTERA_SUPP_FW_MIN_VER	0
 
 #define PRESTERA_FW_PATH_FMT	"mrvl/prestera/mvsw_prestera_fw-v%u.%u.img"
-- 
2.17.1

