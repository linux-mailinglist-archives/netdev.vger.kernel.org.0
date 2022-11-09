Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDEC623683
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 23:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbiKIWZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 17:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbiKIWZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 17:25:38 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2135.outbound.protection.outlook.com [40.107.22.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E8A18392;
        Wed,  9 Nov 2022 14:25:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6GPZTnioFJoOMiAU8KQqxAcYiZHWE7UJoeCVVVIhna/K8ltloaqkelY3roZIlUh6UXT6s+r3BTyvAu1p3mLKoxvfSXEC89e9GHy0BaBQcRoa8VYs8A5W1h22tZgNPxAgb2TJ6tltVxpcqevxSGASYw6dyFdZniostukZZmplJyVlQdgjB//SEEQyRI+5G9wRSF9UGI3TjnG48prtqfwMNFcJh9gZep4bFrU5kvHoIqgMkkHT7RPPwHiU7vpI5sWj+cIg5SBfE9JOzogjEp/02pHnlmf6jMJyIR5L4zPiyfzCmvZMk8mlcSD8xcME2RoWqAjAlYQWVsOGAZwfe1YFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eigVf2JlXtpDzqmIvhFgNjmbsB0G7rl4+B2BZ2Lq+4A=;
 b=V37D12sXeb7BUcCe47nqbvSgLUII4YX2pm2PrpPftsaLkU8eZgPAb+17DkcMA9f5jtsvMR3qRDBP1F84yuzL4pmX6Rli9egKUPVIWnww6p7TjLvZsEfoUibPYrcjdMSXORmw7VFwvqbDXa+0GijUDfkvSslu38+6tPRiNzdq9yCVVV+GSmtPjWGrywNrxaWTtI5UJHoL5au7ZU92oxm9R3SdR6VwVk0HOfvGol2QaSYmElwqJwGS6Blg/+H50uySeyYH0DPCC2lAg+9SpW15wvPXxALu+cv2n4POTn+jsSE+GDDqzR0I2YZo6O3V9ShAQ3mzcBswKlkKU3vY1gxW3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eigVf2JlXtpDzqmIvhFgNjmbsB0G7rl4+B2BZ2Lq+4A=;
 b=H1x4K9FdgsXXPOSurfqKjE7/OpHCeqisxYGdKsW0mtMeE9e584t37pnhsRcaa7nd5HzD0oqF/nhLB6BhtlkOgue363lg4qufsxrgd8s0rA6dhoQ/YpsIGqTp4ukk2dJVHmyoyQcerUpcfW7YdEzqQAZI1fxfW2M4g+AFmFGC7Lw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by DBAP190MB0950.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:1b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 22:25:35 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::4162:747a:1be7:da87]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::4162:747a:1be7:da87%4]) with mapi id 15.20.5791.022; Wed, 9 Nov 2022
 22:25:35 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, edumazet@google.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        maksym.glubokiy@plvision.eu, vadym.kochan@plvision.eu,
        tchornyi@marvell.com, mickeyr@marvell.com,
        oleksandr.mazur@plvision.eu
Subject: [PATCH 1/3] net: marvell: prestera: pci: use device-id defines
Date:   Thu, 10 Nov 2022 00:25:20 +0200
Message-Id: <20221109222522.14554-2-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221109222522.14554-1-oleksandr.mazur@plvision.eu>
References: <20221109222522.14554-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::18) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1P190MB2019:EE_|DBAP190MB0950:EE_
X-MS-Office365-Filtering-Correlation-Id: 92b56798-88f9-4ff9-a2f4-08dac2a15275
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AExHifcA5rYw65lKaKlkOarnpOfR99hicD+buDPC8sH3QwbDh98mSeT75q+3eu/t9uXksSyr65YD4QEmDSKkSdR8vjA/30nzXDmJoT7GdNSym9T4Vu8fxRbSNmUTFdFYLAZ64irJX9ANagpqva2W8vGxu770HpcyzGZRG7DFOsxkbEDoJ41gcZeowwl9R+tWmaNFLy5gNojNdrcku0nZYeyF+4qTQjMFu2oyRCcIMWn0yPG7ocgT2piCEi8V9/iH1yTe7QvrkYccVIfJRiWtm1+zLzWprEpKJnWvNsU1k3mkkYwLCK6ZwA9HSbMWlBz5s0qRZ/9R3aFQYsBdHSuxN82GOTNtxl1cBnKXdIcfhNBC7mxWC09XolgFdiT+mF92+t1DgCMaCUF3Kpy3rRRVcq8s6JKqZxnFbwV6ZXEgMG1dL87ftKCzQgxInqoySb9GfYCF2XumH0HRMhe7B0gtO8qN2gOU2b5WyZJR39WW31N7TV0En/nH9tnux+RFnfJoz6qnVDcZzIforV/u1rr820DindUirn7YXx5LagdLLFghSsqPIaVVHhlOTDZcPnLgkIXZAKqre9DPQGGoNIIx/r/cf9dREVCn3WeGN19dZnz+Za5FzxZtwi3mRL1GXk+AEqefbrp1aQ+gdAWPr3JJsz2trZ8I5iwRQt0UADEBuhoEaHBtb/w+NJ1rWinjaZFww9A+cHjUEou6BpyZIalHhsFZbxhUuih3coWPECeLDmeGH7CtmjcbFPwAFUZ2eDLt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39830400003)(34036004)(346002)(376002)(136003)(366004)(451199015)(6486002)(508600001)(6916009)(41320700001)(6666004)(107886003)(316002)(8676002)(38350700002)(52116002)(66476007)(4326008)(66556008)(66946007)(26005)(38100700002)(6512007)(86362001)(6506007)(8936002)(36756003)(5660300002)(2616005)(186003)(1076003)(83380400001)(44832011)(41300700001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SFmbzlNrM3v1IhGkDbBhp/ZEM6z0RtcKgksmRimpY0DTllgyaBm20pw4MFKX?=
 =?us-ascii?Q?bYeiNNzdZ4kCOucFPeY70KUZvacMsJInbeAkS8TWG0u3RkQy408SJ7TR8bj9?=
 =?us-ascii?Q?60RG00o0BUlAkzKmvnQafihs6WEp2hAk/vJGbxDNCbCVUClFhsL/4J2+ViFC?=
 =?us-ascii?Q?B3bb2m6RhSI98VmPu1nxsOAjXMIsMS68dctkmrc/SSdiQ2levSKyLXEgGjXp?=
 =?us-ascii?Q?KCFIbF7PtVjdW85geznIWbizUmmH8tzzahXMGfQBk1gbtl+yVE82KBpoY9oD?=
 =?us-ascii?Q?BIJiC43gbnOpSbcifi/9nAP3xar1Noh3MCkt31nh0Vxko4kLVAr3/w9f8oOG?=
 =?us-ascii?Q?FPE/HAhMCVnh6mwCB3fmFqqHVAWdU3BssOKe/9hsWvkwR4AmL/mqwNapX5n1?=
 =?us-ascii?Q?+Mc6FJyIfx+MrvL6Lh416fPdQ2pSubZnkoa6L4jO2pqt1hJdAwnls0//pEfs?=
 =?us-ascii?Q?gKUGJuR0iJwmkkxtsSqywv2ejCBMSZvXOBw6M0g9ETD+zV5C1cZPJ+CnH0al?=
 =?us-ascii?Q?0/xAxzGpei0wAxiLDKDw2AYR98b7dQRrXtiq0WZMM4iYCduf6d67FFcBSwU0?=
 =?us-ascii?Q?H5qLp17b8jj615CCUUCUyerkyipXovDymx9DzojcTSEV5ccC8bQrl49IKcEm?=
 =?us-ascii?Q?PqNL9RbtZekf4dwIHUhDc3FatUMeAAZvuikIUAMTRqi0AohVV+XopmdXtvux?=
 =?us-ascii?Q?oybUyyLuQFjnP6gTNNhAmq6VSZeqMDYagR9HVmY3/sfz1ztUp54gX5uKAB8+?=
 =?us-ascii?Q?sznnnXMHQzIiujhFNu7s4wBbWMpzjLV5ZXLVlHkckS8nLadXtaajnnTxd2gH?=
 =?us-ascii?Q?8V4fvstp20hiSDx0L3ze8l1PnqSQUgXN2+pcvxeXltvuVFnewhke234QUWug?=
 =?us-ascii?Q?eFvq/YEf9dhQL/hvcv+tHOelQZKihsm77cBgnDSVuSLdNlOLvvdgNc3n6l7n?=
 =?us-ascii?Q?sJ3h3Haa5aN0etsjra2e43UfSSUyFyXbBu2HOH5wXSpHDODUWakcqynXWWOU?=
 =?us-ascii?Q?hnrilaYrcg0YcVk9Oa42y+kbt/7/tcHwBr1nqKps7ERTvZE/QZYDVgEm0Q1c?=
 =?us-ascii?Q?OhCWb2o7qwukdXDtlmfQy5AG30008LO1g8EWstVW7JWFM2is+808Zkw5x5H1?=
 =?us-ascii?Q?MIukB2dLZv5UYFpsdEU8Io5CV9DxW1n4ouHiC2lv26/R1pF0l/QWw9halVjV?=
 =?us-ascii?Q?z00IxF9NUvncV9TOS/zmcC2+hrDMunf5v7rcP9/nWonZkCWr9C/ByiCTUCrG?=
 =?us-ascii?Q?BWmc2/AEwlEM+whOdBgoL769dj3H7GTwdVyqrDm1OF6Iw7uTY0TlZDHSFf+X?=
 =?us-ascii?Q?Ro+FhES2V69wes90Gu+6h3qORZp7kDv6b5P/W8U4bBPckd9Gk2CD/QCAv7un?=
 =?us-ascii?Q?4Atim1J7PxXNmP7HivQNoc77kXUf/v9g5Z9ieFYajrYZyfmE0MRwu6NWj120?=
 =?us-ascii?Q?UI8j36YYAm8KPxKIgefr4qRtKOFx1EcMi9rCsXhVU2l8eZyn1P1z5cHBOqrn?=
 =?us-ascii?Q?Enr0p1OK9bU9GdDX04hscyNNAhXm9kzm37y4EtYfeTzTnEayaQGSxjyse77D?=
 =?us-ascii?Q?SM2//gInCTxE1OiKsbcT98FYrPyqRfFCxXtFtp3BO1HAKa3S4eSXN3thsPin?=
 =?us-ascii?Q?iA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 92b56798-88f9-4ff9-a2f4-08dac2a15275
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 22:25:35.7510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: trcMRBrNv6mFXJhAezxKVRI1XRnAU13PlC2oVGdLw3xlt1xlJYxS1y/qt27PDqFzZeTucJycYPRs/NrhChNv+gIXy0bR005JgGGwSzIBtjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAP190MB0950
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use defines with proper device names instead of device-id in pci-devices
listing.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index 59470d99f522..14639966e53e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -184,6 +184,10 @@ struct prestera_fw_regs {
 #define PRESTERA_FW_CMD_DEFAULT_WAIT_MS	30000
 #define PRESTERA_FW_READY_WAIT_MS	20000
 
+#define PRESTERA_DEV_ID_AC3X_98DX_55	0xC804
+#define PRESTERA_DEV_ID_AC3X_98DX_65	0xC80C
+#define PRESTERA_DEV_ID_ALDRIN2		0xCC1E
+
 struct prestera_fw_evtq {
 	u8 __iomem *addr;
 	size_t len;
@@ -870,9 +874,9 @@ static void prestera_pci_remove(struct pci_dev *pdev)
 }
 
 static const struct pci_device_id prestera_pci_devices[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC804) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC80C) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xCC1E) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, PRESTERA_DEV_ID_AC3X_98DX_55) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, PRESTERA_DEV_ID_AC3X_98DX_65) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, PRESTERA_DEV_ID_ALDRIN2) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, prestera_pci_devices);
-- 
2.17.1

