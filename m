Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F22506836
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348574AbiDSKFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242209AbiDSKFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:05:45 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2123.outbound.protection.outlook.com [40.107.223.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BCC15735;
        Tue, 19 Apr 2022 03:03:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fx+QA5FsvM7Grla9wzLOLHVuoHXsVUPVfxC3j/uxdyz+GCSA7DQxSyLVl4AJbYOYbT086yFg2dYheBOZi1lMLcaAZrpBi4D09ZHlrsqXBlV4CL978N1dGMnJNPvjx32V36Huw3Dqb59Be0KNnYn7zdMC9YmtbuSryAIc0rDEBY6GWy2a1Z0MjxsYjeO40ZL7oxqhhdY4J8OVACpcgtFWegrvww/Ggkz21keIyCe1u/REmYgVInO1aKiH46I+Ls8gdmXBsk/6Pn0o5n/OPWRxUjHNLzScXrADwKNiU6OrpMPrjzDyF4p+EX9B5eNkm+2NdOzPxnTpfVuMgayZnWLdXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mhYqaFJu1Qs4f15xpP0e/JhAmC2aR7A1/Td65CksCVs=;
 b=E+ZbnuxgXNRFv1sZX1Vy/QKtBtX5nJbwC+MLqoKiMSfpMHCzlFe9aySwOh9SvELTAnwqN7nVDFQUp0/Q4p/xDXUsMfERAGNCfSYWc9KIXuWPEWt9LtEP6OGxxBDPWBRqYvS4FlVHAf6fCmo/0x8egb2Jk576saoW3PWuQ6TsEgX+qKd2bm+KliYK3DVivn/OZZlyfQdrPuOWZBcnl9+iIFags3nnnq+4VIAAH8gEhNlagKfKRDNMfLOAIdk4DFMQfkOoXh3e6/yV4bHAfNvb7A7IMcz3TMNuC1UgLv93n7CxXMUrO1TV+FiCvW5BPI52Y5i7r4hiPRSea8VQK16yow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mhYqaFJu1Qs4f15xpP0e/JhAmC2aR7A1/Td65CksCVs=;
 b=oWK1NQ0hMRwApdklwteJRA9ydnVkYh7xOhc60+j19dCI1OYy8D+zDH8on4//cPZwQqmBr7pHeJgDiq0jO14ohPO+eOh9T9SCZGBsDiPBDo1TxmIMLB3QzaiiLPoD/9SPzIoTblbehxBXXqEwy0BKwUCqZ3KVWe07kalUKhzHRaY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by BY5PR13MB3539.namprd13.prod.outlook.com (2603:10b6:a03:1a6::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 10:03:00 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::5cb2:d978:65bc:9137]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::5cb2:d978:65bc:9137%5]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 10:02:59 +0000
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Yinjun Zhang <yinjun.zhang@corigine.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] PCI: add Corigine vendor ID into pci_ids.h
Date:   Tue, 19 Apr 2022 18:02:48 +0800
Message-Id: <1650362568-11119-1-git-send-email-yinjun.zhang@corigine.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0122.apcprd02.prod.outlook.com
 (2603:1096:4:188::10) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 749d9937-b0a2-4602-009e-08da21ebc8e2
X-MS-TrafficTypeDiagnostic: BY5PR13MB3539:EE_
X-Microsoft-Antispam-PRVS: <BY5PR13MB3539180145DE78E1B739F72CFCF29@BY5PR13MB3539.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vAn0mi0aq2SJzzoOe9A16l+i1Bgwrk4z/dIA2fwbYLqtz/0m2MuQC7kNQsVuoA+RU3iK9YGgrL2W4hxyF0hz1LsaByuvGlRcjMQO8eGyU6IZB06gIq70NAxe/qRjbFJNE/KGS6gvRDq9ssDXijskzhdtLQILZ8u1dmDc1Pern58pOaZ1JSx7Drmd1cCeQ2wJSikvtg+AzE8cdOavVm4Uf5FTqIZg9hSWcVHRF/Vv7EK1yWDPtlD7NdhYAP+vGJP1RCYRkgFX9uSkZvWO9RAnlGk4+uR0Z41xpN73dwKaDkzI2nVT4572O+tYA1iFDF3lrYy0SY5+0Ssx8fBkkd/81E7sfomx7R7UWrQTU9M1Aafqzm5Wh27P0w9wocV8Lo3PiTZ35MihyZrpqnQWUybTdckl67o3Afu6BqJHAcgf8xsFzJX66nfApjcR+j9cW39g5Za2E+f3DJOJRRv4kZY+a8ecY1PQewg7pseSWxu7d+AwN75EiILPQCCytp1ImZfKuKJl0ql5Uo5ePEmx2hchCB4LrCrEH6NV9ZWvGjTRZDST1hgMlmnqlPk51hdNEyoDfC22E1hUtNSHfGOPH3I+Uz+ILEdNZm2bvzxr0vNofdWCW2aqTfxWBeHyZcCiYgxhXEXG+u6jqpdcmu8OEyVE+piuJ09DS6uQGdZmMu7WqugBPmwDu6lK4IoIsWNcFc8vCMkZwEuHC3elO1JTcrnylg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(136003)(396003)(366004)(39840400004)(346002)(26005)(186003)(36756003)(2616005)(8936002)(44832011)(107886003)(52116002)(66946007)(6512007)(8676002)(4326008)(66556008)(66476007)(6506007)(5660300002)(316002)(6666004)(508600001)(6486002)(4744005)(2906002)(38350700002)(38100700002)(54906003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P3zoi4xqYd3ZrUsdloEtL3vj9OO0VPpsFXZIoY6THrDrq/2tLuG7wP1rV88J?=
 =?us-ascii?Q?1+cccY51KRquEoyxkN0HFNjLJSlZFkrH+/Puzwb4xHeKfw7P/wiMneoT2V+3?=
 =?us-ascii?Q?F6FAWhtI4s8RrcNX/b78Iut8XFRVRulXaZZFpSzGg0b7csiq8HxM22E/amUD?=
 =?us-ascii?Q?6NW6eAcnzm03eFTMeOck9oi+ZNtNo4kb0PjDxg9UxkJCP8je78EJZ12Bf25k?=
 =?us-ascii?Q?KpwXqHhO1/8EnwIDHB4nBTSGNOxD6pqJhQuRFLtGI7wbWSUZxTAlV9nbs2OS?=
 =?us-ascii?Q?LlMKzZ8NQoVc2OEyULvJA1XqlwNgvxdqoKNdl7Q1i716qsRjemxk+7GGOGnZ?=
 =?us-ascii?Q?JhRkL4Vkts6mDv0aNyArbUI8TTS6j1S0mFWkY3OAQKifHe7UqwFFIDeNNONv?=
 =?us-ascii?Q?06WrR20tx9jSXBRrAhFTC7gI9kT7u/0DH0G4a+lZ2phQuo6XuB3J/uilf0JD?=
 =?us-ascii?Q?UVBpv0IIcAYtU5oPdlDjiIU3idtLQf7N0LETC3jetme7WBrxgjbn1ZbcCUA4?=
 =?us-ascii?Q?W/txJVf79fdNfQoo8WUFYoEBJd8YQTl5uFm6zIIyIJh+9+43a5XA+i/Koejt?=
 =?us-ascii?Q?ovHl0A1GTggn4pNsz+bWyCU+IUwV+qAy55mBNVIZg7mli+P/PjM3XznZhvDk?=
 =?us-ascii?Q?PzKdzPSXLoov2vw4ThQKZuhKwIijyw7sWpyWiyDeHEz6Bnr92ZfMdNcGqG7l?=
 =?us-ascii?Q?phTK0m4SYThdRvAt2d3AU8riqk6MC5QZOxMmfbSGQ90EOgEx4h+LMP1GpqG/?=
 =?us-ascii?Q?f+Pz+Tx4TqxM/FSoA5aKco7mPdc7ZLv+C2KZdpgtWrA2Q/HLhkWaD1gq3y94?=
 =?us-ascii?Q?xQR4RoNQ0SxBULBSkoikIhdwzVEGwCtYsYkFjCLJWg0XcpoKV2hAco1ssfC4?=
 =?us-ascii?Q?5i47RaZThXw2PWSuGMi2EwUfyRRNiIhq4bZiStCy/nrt2EEBs9X/y6ZZZVrz?=
 =?us-ascii?Q?uYo6Nk19Wwrq3fPyMqDISP8smmU9pMLS+EpZJRhHZ8aG8pBUMtmksicA86aI?=
 =?us-ascii?Q?esh+XfBgSpjTv63MkO3dtWm7AptNubx0RI7aQknnQ/yXoLkGpBoF0RZYrR2L?=
 =?us-ascii?Q?ghmYxF0rkqFKtgkfLSyi+YH8j30mAeS3hiMJt/euVgLGHFx2W77PtzZ5RNiK?=
 =?us-ascii?Q?UF3QOtRQunbTpiz/nYK53w6mr5kL8be9bs/bVEyHprAoHqw+Ztj2NkZCmISQ?=
 =?us-ascii?Q?9o2LrMoKMa1i+80WnRUICU21A5EIXFPsWSg2mpOnetCJq1pktXiY9MSWnJPN?=
 =?us-ascii?Q?chBRwm7cu6Fd2GqQMPbGQ6qHlzJwmzVis4hkXj/PxgbCs9ltNVzMJoZJplPp?=
 =?us-ascii?Q?gvZ5HuPt2mhTYU7I5bkSYiUN/EDYaDfa4ipQqUGDes/RbhZ3ZlK4SVKRregr?=
 =?us-ascii?Q?krcVsIhgv9uuY4KpfelWtGC0AmyIpDHDUjD7AfpUDQ4P7GU5IOHeYCVr1HnB?=
 =?us-ascii?Q?cuKsiaSa3kkxIPouH/6TdNpLTmVcFoZ9SbxsZhPX5c458f7fMOphbASCmATw?=
 =?us-ascii?Q?F8FV1mgrmQ8Uv0zlscTDDPUNl7Dr/03MzXl+nRO/H4Cug7ZYJS+WWl1wwCAi?=
 =?us-ascii?Q?A06N3oqGEX7qlNaasgtH9xEO+gsSkEhV93n1WCmKNB7QP8vY70I/1KYf6F2y?=
 =?us-ascii?Q?ZQGZdueiFUSOtFhYQKofglnblvNR1VIibPsJi9Y7/d+a2KeuIjUHrjoMK1JF?=
 =?us-ascii?Q?rIAEcsDyoO+wblrhKIjKk14yrbNmpuo4yoiNMntctHZl4iEUEtsy49/vkQ42?=
 =?us-ascii?Q?sAbmCJqkjsss2rn7qIDRd9zrBhEZfRM=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 749d9937-b0a2-4602-009e-08da21ebc8e2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 10:02:59.8569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AXE/10k2bg86KBQhPO5MW3M+v4rDX2V65UNTdpnROUhO9yp9X9QrQV6P17l006zF1x8S0lNveF+fglS+Q6cG8mWg2amlv5p8wduDsyoXXks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3539
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/linux/pci_ids.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 0178823ce8c2..6d12b6d71c61 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2568,6 +2568,8 @@
 
 #define PCI_VENDOR_ID_HYGON		0x1d94
 
+#define PCI_VENDOR_ID_CORIGINE		0x1da8
+
 #define PCI_VENDOR_ID_FUNGIBLE		0x1dad
 
 #define PCI_VENDOR_ID_HXT		0x1dbf
-- 
1.8.3.1

