Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9655A4567A8
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 02:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbhKSB5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 20:57:37 -0500
Received: from mail-eopbgr1300091.outbound.protection.outlook.com ([40.107.130.91]:26592
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233601AbhKSB5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 20:57:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lop9DfcO4zMhw0+du/zGT08VLqpuq7U9vfDxTF0NWHZmZBwpvT6J9yyu92pw2XjQm3xtjp+N7Cxl+OAOfTxcTixq+e7PHEIHGUgIwXQ5p+h9d9AnKLTwoaGHOuO4QoXwCyOfRRuYdsrTVR2IaZFk4xsPuBLEbJEU09P4jV/I/CbPuR9qlO8gqvxNYOiv/ZRGKMG995nMwlUmBT/UVtYxGLqhCCZT5aHAWrxYApUBpxyAaIZR0KNiVlTnQ13RsQvCBZWneV7De0pxwCmO3rs0YttXD1ByJLEdFQjn/hs6iiUouUgeV75lAPuL1kXopPV/Oeg81FSEG8iMDc0QC/jOYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=33+7LUT8N8DnKMEBWT7SVJB959TZLYcQdbG5CkLzZRU=;
 b=dQ2aImPYLCGJYSj3f9de4OKQw5QJSSwsGIMPEmP/Ex8ROw74hzPT7hO+x9crc7YyQX7TeugD77kfeZDsLdBFUMLWdBqSvm2/CQ5E0/Zdt0zz+QqEog39JcapZ3G9MvKwB7V4rLpp1HrZdsXZbHcyO7zZQCIX2EbHTp5sVhDn67ZUCclgbq1xLKZDB1L+Idaaw7UJQS/vxqlsmvGvfzHXG0JM+sBpS5135rsikHexds/lcSdhBwyT6GK/wXkeYLVKeyNNI1uiX5rSqmFUXKyluXGAbgsiRj2M1neKB97SYZKkLStkbzq1dYDugrVOsp8CEsCLl1tw8deee8G39V1hhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33+7LUT8N8DnKMEBWT7SVJB959TZLYcQdbG5CkLzZRU=;
 b=OEVAcFt86/7B0tkqrym4zgwp2oS9lEdKgFEbY5uNy/TE7Tr5v60bmrrWmp6CdYQGP6VEVChdYy7zwfwU+QY7MurP9mDVkPzXrsb5oUrVUh9uR37ImVHzNaHzaBShJWWIuEWNMOcqrBZu6rr6X/PxEQxdiCqAZxK2rd9PfFJEbzY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com (2603:1096:301:37::11)
 by PS2PR06MB2936.apcprd06.prod.outlook.com (2603:1096:300:53::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Fri, 19 Nov
 2021 01:54:31 +0000
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::395a:f2d7:d67f:b385]) by PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::395a:f2d7:d67f:b385%4]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 01:54:31 +0000
From:   Bernard Zhao <bernard@vivo.com>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bernard Zhao <bernard@vivo.com>
Subject: [PATCH] net/core: remove useless type conversion to bool
Date:   Thu, 18 Nov 2021 17:54:21 -0800
Message-Id: <20211119015421.108124-1-bernard@vivo.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR03CA0058.apcprd03.prod.outlook.com
 (2603:1096:202:17::28) To PSAPR06MB4021.apcprd06.prod.outlook.com
 (2603:1096:301:37::11)
MIME-Version: 1.0
Received: from ubuntu.localdomain (203.90.234.87) by HK2PR03CA0058.apcprd03.prod.outlook.com (2603:1096:202:17::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.7 via Frontend Transport; Fri, 19 Nov 2021 01:54:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e645118-c620-42e5-5025-08d9aaff86f4
X-MS-TrafficTypeDiagnostic: PS2PR06MB2936:
X-Microsoft-Antispam-PRVS: <PS2PR06MB29364EBC359FF461EC60D272DF9C9@PS2PR06MB2936.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3xhrOTCUONdF5qS2SO77wBNUeziDHnpg6g2MyIIMNYtoYXqkd72dbxXf9TMll2moufk+Y7lp/dQazbyDTOgvQBXSaAjSO8UIvFjChGuT+ZGmDl67PWm1AvBQfiTISioQtDJd6aWkPMjJOVUiRhHS8lhLfEz+yUUfZ62phR9D85EMs1NUXS3yKwgEDsRJzNvaU1010zAQEewbFVVQxKLvQ+qzBvbC1T7pABVYTyouyRtt8FP+CznYECxPv4kvUb9MLZP09loNUr/VrnRAt2CA8zZP/zv76/V+NJ66wMlWo2CzrLLv+GBfr5BlKqvTaaIZ0GqW5b7WNK9uvqoAc2J3a6HcHx0Txz+gDnRIVXoWilA+6jICsiWeYoTIkNWHURIJbVFdgyW+7dO9sCEvtyisyXvCj5tAnfVP3OSc+bKvRaqqAZKlg8W9LCHyZs9G5o55phGEvXCqYCgBLJNKkx7icPApSfviKliOEsaM5UVtT2glf/cFDcr8WYIF2HsvDo4Kn58S1j0QteMTSaME/KwX/Di3skrAqXx0AeVyi0K9jgbKnn7NJFfUDu7f+y5fEQqIuDrGz+nX7Frx/1hdUuBFfVoOjCl5XeDSvqhUPfnQPsUa1HOAQwUuWFJZOXwLxV3AUPu8cASlky3QLCAd18nZOB1Va0awTjmc0AwVAAM0KerCuwyQbqOTeoWxnYiKg/VPaQuiVrO/Go9ApXp8s6G1fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB4021.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(38350700002)(38100700002)(8676002)(86362001)(4326008)(2616005)(956004)(1076003)(66476007)(6512007)(6506007)(186003)(107886003)(26005)(66946007)(66556008)(508600001)(83380400001)(8936002)(36756003)(4744005)(110136005)(2906002)(52116002)(6486002)(5660300002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BQSayhy6Q3r7GUilY5eUq7nW/ZxRpyWRHxcgNpbtN2rRLZOUSg9eugTPM2X9?=
 =?us-ascii?Q?d307zMXducGtclI/CCnP6avIAlahg05sPiTtDxSNTNp7dzBQWGKlEwQnJSrH?=
 =?us-ascii?Q?4ZI7jGtxaHJAnglzzHOTOeAUDupo2jA6i67/evt451z4Z8xtjEGS70VPGvbO?=
 =?us-ascii?Q?HTiQGQmBOIjgzLJhBplFeFIZi2FeVHhGdwuSf/ahX4XTTSPzq5NzTGEOa0tw?=
 =?us-ascii?Q?2l99zHOXr/oW6IPHfh+blqO9wrHCwTGWmC3IMpQgw339qOvzbgNLc0CSELVc?=
 =?us-ascii?Q?TbH8DZVGF8UmE5tJJTI3QAHONh8AcBebPf6fVe8zlsbH3eYgpVZZAWO5azp6?=
 =?us-ascii?Q?rz6jakQVdGtVlSBGG35jJx/JTpKXATw/pJZp6Eh3/jJp0W5gigqY8RAdA8rV?=
 =?us-ascii?Q?xzNnFcYNbvreOfxUJG83oinOZnOPh4VtOZB8HRLZT/OfrKnZFd289blgCaLP?=
 =?us-ascii?Q?EG11ZGru6eI7D4umzz1cmpRS9W+gjFyT5R7gc+3H8TtYXDrdBJiaS05sVLeP?=
 =?us-ascii?Q?i6JtlI4vdRURbpdNrg4I7ZgkX5xjaVYVMwMt6YHBdET4dk0y0X5tqbDE7Hts?=
 =?us-ascii?Q?qomH2QNSH1dinbahXS7NNB+KdgC+rXAvEqGd683B2bDB3upd+OoFtUvV92CS?=
 =?us-ascii?Q?XDL2JnBc/vlMVw5KnIpquuIZ3Ec5fA+JnFzb9XiFEmxbJCfr/j3dheTn7BGS?=
 =?us-ascii?Q?Jm6mmu6U70p3euTzsCYwp7YT4FPM7C/cE52PHWAwg+Tz8vt7aAsmN4xaouVG?=
 =?us-ascii?Q?AOh0zEtiIXpid/t8t7t+/AXyzn10/nI4AthRo7JtYJDk3Sy3tZ/rNkhX+UEO?=
 =?us-ascii?Q?zVnJC4IvCIGUKzHLF9e6NJ8UE4+6AQAHBH2puDUUS4Y92+3Q11Don5G/se1V?=
 =?us-ascii?Q?e/y7oxC+5nriAcrPEhP13/fopQgENHj5S8D3Th+1dHWx5fIfpGkovgzuY3Ju?=
 =?us-ascii?Q?Ney4MGIGxylqt27OgbPc4LlQaHw09//jaEXTg7xlD+Vk4DMX+1hm6C6A0JQV?=
 =?us-ascii?Q?AJkhuBEHum0AIlb/JBdl+D/0TUU+DAg+u/H3M/l8lutNt6gVMqh355QnZ/eK?=
 =?us-ascii?Q?bKNejH88BSolLkJzU+xVQHNhCZ86AergzfnnonsaaOcHiym0N9wD2bz8lqga?=
 =?us-ascii?Q?XBn8CZA3nZFLMW4XF3qgCmMf5StCMvp8KNbJyBxGpAA9F7PglHIZyN1oHntw?=
 =?us-ascii?Q?zvYh2TgAw9z8XNZjg9tpeI1zMfgA2XIp/xbRuXwNTG/aRqOVrsaSttzmTDhn?=
 =?us-ascii?Q?68h3z/n2niCxbpZTpZ2B2NXRoa+hgNROT/9dcOQeR67lXJ+BZufxNpTyPoR+?=
 =?us-ascii?Q?X1PFAzfARxAUfi2L24lp3b7VTUtIMI2QjskJlL5wth52L3MZ1mqzO7/sJbPD?=
 =?us-ascii?Q?+zdFCrPFMkhoCUdUlQ1e0NKmr965uL7SaFGvv+rFlkZWIcE8U7wN8pGnUHjh?=
 =?us-ascii?Q?9Cz1rRuFcw5vLlDoAIfjUR+wwBZUyX9ROeUJZ43w8zh2wRv3F1/6k/0Y4eXg?=
 =?us-ascii?Q?LuOVbyoHhBhdVaEf2/bKNjM8m223+Xtjvgt1OYk8Ruzie2y3r4UG70Air9L+?=
 =?us-ascii?Q?RKNGVS/RDeYUUwaOHaXZNsK/h2QseaIGnn3vLCdpWVyE9vq50sXoncNV7VL/?=
 =?us-ascii?Q?1aIwP+IMY7IXYkEJzFiqDuU=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e645118-c620-42e5-5025-08d9aaff86f4
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB4021.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 01:54:30.9486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v5CX7k5/pFHkAzsKQSFfaxRzY9PZ7CMYqsDbm50DApTGT4ZJfPwTYWWEpgRhzs8xyGqGXuVra6jS8DeBPnUHxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS2PR06MB2936
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(ret == 0) is bool value, the type conversion to true/false value
is not needed.

Signed-off-by: Bernard Zhao <bernard@vivo.com>
---
 net/core/page_pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9b60e4301a44..d660d46f6ad6 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -398,7 +398,7 @@ static bool page_pool_recycle_in_ring(struct page_pool *pool, struct page *page)
 	else
 		ret = ptr_ring_produce_bh(&pool->ring, page);
 
-	return (ret == 0) ? true : false;
+	return (ret == 0);
 }
 
 /* Only allow direct recycling in special circumstances, into the
-- 
2.33.1

