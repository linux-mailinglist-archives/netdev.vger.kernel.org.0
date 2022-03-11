Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03B94D5FF8
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236111AbiCKKou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235596AbiCKKoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:44:46 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2138.outbound.protection.outlook.com [40.107.244.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23772198D39
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 02:43:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lgSPTlziyJG3udlP1TCNWjxl1OtN03hP/4x21GlGAaqsq8UNzgygG/CFNnAh2rj/7QbljNQFHjgC2QDMPaTfuMXyLzoaMNQBIeyDvPwinndZEXDOuQedpi6njUT6exscpG0o7mcHBvqEy7IKqYjGwFVFWegEWyWLp4dbt2xqo1UwYLUBR/Kt4OIRjP6TG0NeUzXYJzSWJH9cjwlwKR4p4QdYREyf6DDx1nd/I3tMc7ZRrsM0vA/vMz3vox/dycz0HL1FWhAGRqFRK2KRpmEU+mzktIC9qBhyeEhoswSa7gNb6cLHpp7MZu5MekHgKa8Cbw9wMUURPuwJtp2wJwPldA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=64vSt+OJHnIIGgaOlY9Hx954rCfhppIH89wyKFkxpjo=;
 b=CLVesyHWjXAJg6LGuhEm3PA0b2jStynB00ft4+B+jd2nT0emY5w6G4+rUUXpLlqbg9ONPPtA1WPQbxTKX+mb3q53JEigho/jW/n28QGCK5SaFFhBr16UmBafxP/imggg0patCADFuvtJZwqDo2W7J/tdAU75DUya65dPcNTqs6w1Nl52b/4XkhngSCjIVTNYYt+KzuCtuE6VZBoW6y6ZWw46HN07NeVSH8dq/+XjQjHUuFjUyfLdVA8ywM9k6VesnIcEn6zeHHy4m7YU3oMeZWnZFo+LRueHWihZ5NqDWVmba7TEnQAJlT3whRnSqNvzNOIFxgaMEValf1S74jBgeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64vSt+OJHnIIGgaOlY9Hx954rCfhppIH89wyKFkxpjo=;
 b=RcwOHCgyq3p63qlDNhf7B2yHRrfW3vuZyg21neAPby6adlppPbLiZuwcV7wBfVUQ41H4u5Y9zMj5r3ROCwg0IPh49qhB88aFujWM73BGwJNr9i8FbBErwNuFT/wu4RGF4bwuUp1fv/W+tt+aHULYcrruiFsfYNBDUOrCHxW7goY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4748.namprd13.prod.outlook.com (2603:10b6:610:c3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.9; Fri, 11 Mar
 2022 10:43:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5061.018; Fri, 11 Mar 2022
 10:43:33 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 09/11] nfp: parametrize QCP offset/size using dev_info
Date:   Fri, 11 Mar 2022 11:43:04 +0100
Message-Id: <20220311104306.28357-10-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220311104306.28357-1-simon.horman@corigine.com>
References: <20220311104306.28357-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0026.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ce33d45-b197-4dd0-3fb2-08da034bfd73
X-MS-TrafficTypeDiagnostic: CH0PR13MB4748:EE_
X-Microsoft-Antispam-PRVS: <CH0PR13MB474893831BDBE11C926CB5F1E80C9@CH0PR13MB4748.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JEcIozWDF93R1wAw5sWmarQmnRwWYhGU5mlpzc1+FrFWofTf9FM40ztKUmepQM5MvpM4J5Tn6TILiWIF789q0FmEB2nHy67epsBg7Es8Vy+eZ2IHPB4vLjpFiZvsMsWA4feGNLj9y4RD19B9+1AOhnP7Cv/TVZ0zs5H5iUQcDs4uvAO2991akONCailorYxhKB57KAppvv7XZlSWgiaDjj5Ow8Sl9LLfeez69t3tNUYo1qCu8jd26IeFJP/FsVuupGz3bKAB5GL3ixbfmiCK9JP+x1DBLTkeyo4zsH8iHlz1+pxV/cLLfnC++ffSeqSu6QP6UBZv+yS10MLvWtSKViJjU/WNjTfU0nVtrxALEQtAGaS/uaFoHbfKEUviCLrz55M1xKXsxHaImt2LGJpNjvUatQ8BuVsncsD8lfkgSlvRp7HA/9lqvI/TumMr6meX4vZQi/6URXGGpMdEUeDBYEE7X96f1x7ZK6KkRgF2ef5GiQUzWL6tqIRFp6J017shWetJMJMAcn0HWOjgpFOijxMvBJkCcRDqUKRZBOsF2B55dayBzBAovh9rNPyf5Gx4KwdTLtmZtE+cjp1FFnvbZLnjueITF7MfHJl0/3j6Z8YE+8fYjshZJUgx61EB9sFlaCH000ilK2K/pBWApPeGRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(376002)(366004)(396003)(136003)(39840400004)(66946007)(66556008)(66476007)(4326008)(316002)(36756003)(8676002)(52116002)(86362001)(6666004)(6512007)(6506007)(5660300002)(508600001)(6486002)(110136005)(8936002)(44832011)(38100700002)(186003)(1076003)(2616005)(2906002)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VV9mKIR+TK3d41Xuo8GU5NCcKh0C7J1SeUMgAvgMfixzs9+BL1XL1GpAQE/w?=
 =?us-ascii?Q?W40LZVewROhCLaPZS9DxrLZYumVkOUm5nxXFjq6cD0vNasDHxy6a8ArG1CSt?=
 =?us-ascii?Q?5QX6L1Wgg8u89kEzxhwgXAtqX0biaY+FIcVlY5YAL4TtqDozrDrDBs0LNXFo?=
 =?us-ascii?Q?iMklK6heWxCQPTQgKKdPuWfYD3NoLh443mfDxXshc1W4t9W94lnsEGlQptih?=
 =?us-ascii?Q?YnLhSd9EwJrYbyc0ba/HQP0LdaHi+kfJoGYXd2W4sieNHUV6X5DdpeRQUtLQ?=
 =?us-ascii?Q?3zt8R5sJaatBIs78FFH+bsdl2NGs7TJPPFigDFx/exZyrkXWiaytxGpFMq2y?=
 =?us-ascii?Q?wo/KRSj+5pphIX7fiyJARrvEFCDubKhy8MgQVS5ufEZ7DWQEXwuA+OraAPQ/?=
 =?us-ascii?Q?7YGj88jneSkxyU5+915TtJ1L1pVYewU5RMt64Dbw10hAZjN3b0/Qjh2WGV8B?=
 =?us-ascii?Q?fmj6fdLHkScJPtYBRqGci735BSJnPbS6hatp0xOgyMYpzMi6HYUB2jwT2bfX?=
 =?us-ascii?Q?7CMGlP0PNK+fTzp7PnskEJwZL9a0z9VK6oT0YAFCetSRUe1m6vSlyu13vMhn?=
 =?us-ascii?Q?sruFmjPBgJqQ5bo8gPWbO9WxIIOhdy2nf2A1I6/HE2O5E3pX4XxkuefBRRZk?=
 =?us-ascii?Q?ClvR8gAC0OkS+Xm9Luy2yUY9BZLyHlnOkoMlyHyWfY2aoTxuAJ39WsxKgT85?=
 =?us-ascii?Q?xX1XBOgBalmIJfQDhK2BWe9AkT+KwYlkCIVDhMkdHUD4oAFVDK6jbXmAplWJ?=
 =?us-ascii?Q?CFMqjs8uYaDJZSEM6OkTJKkOmt3vDY7LX5rqRFV96KvXYeVOVzOyibhDlMNE?=
 =?us-ascii?Q?bB6/cha8P+lysfqcg91ZkO1DL2kqZw4euaA2iQM+XmZi0Fq7L7To9Hi3uKBt?=
 =?us-ascii?Q?gs+uOfDqvFXY4s1bLawDwRSxiTtqf8SU2ChG6KGdZXg2KUxNyiZ9G0bVdNsu?=
 =?us-ascii?Q?5INWyt2I6ikTSuR5Y6cSl2PClaAFLw6I51WPvzXnCZLvEVvvvU9OkEnio9XW?=
 =?us-ascii?Q?sDkx24VXfXakITV0ONcFvSivzQI9p+GUDpYHZsLXiXj+pd3Cyg4jYRhcoApn?=
 =?us-ascii?Q?aWhVa7ymX2UBNceSh4Gtd9YJrxns956lqAThiTkiLKC9Z3IMtdKeoHpuRvQo?=
 =?us-ascii?Q?toQNzvXiFz8lGkTxxC759YNlhIdL6a1e1KqRCZiHbB8whyNIHuo75nQBcnds?=
 =?us-ascii?Q?low4PmOO4OBgZCTuoFZJd2lI/+0VKjYQRBOWAmTyEVxddesZQoPIELp1jvJX?=
 =?us-ascii?Q?pnHH/u/BnBa9JWSumTTJk2XIrcAq0BI92lPmLAcbUbAVH8+rPaAONTcoHeZU?=
 =?us-ascii?Q?3JXgVM/iFf+77C5qJegF2AATyEg7ZYFhLCxHlkqL1+RtwgiACxr4DSyborg4?=
 =?us-ascii?Q?WN/bNqsEBPII/euX1P/tq+aOmBqQtF/Qj5PfeZZzsXLvmy2BUX5qXipypSLs?=
 =?us-ascii?Q?i8debaymN8qGsvyo6bLfnvIlqWJqYuMK8aral2ICunqdD0r7AjVxiokH04JS?=
 =?us-ascii?Q?TAPDThqK5gcPFRq6CKU2nhHPV37yUakEAmB8uBbYdTxSDLekAu5zNQ+NWw?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ce33d45-b197-4dd0-3fb2-08da034bfd73
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 10:43:33.6902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ucfqiwvBEyEhJ0cQJHYKp/H07ywKi0AysGDv+flg0Wy5T4Zi59BLoHF6H1kxa41Y9dHtmNNbnKwwn3So2ccLtKwVbZVUPtovBsgEPfEYbw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4748
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

The queue controller (QCP) is accessed based on a device specific
offset. The NFP3800 device also supports more queues.

Furthermore, the NFP3800 VFs also access the QCP differently to how the
NFP6000 VFs accesses it, though still indirectly. Fortunately, we can
remove the offset all together for both VF types. This is safe for
NFP6000 VFs since the offset was effectively a wrap around and only used
for convenience to have it set the same as the NFP6000 PF.

Use nfp_dev_info to store queue controller parameters.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h         |  6 ++----
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c  |  7 +++++++
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c    |  5 +++--
 drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c  |  6 +++---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c | 10 ++++++++++
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h |  7 +++++++
 6 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 232e0a622ee7..5ae15046e585 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -796,7 +796,6 @@ static inline void nn_pci_flush(struct nfp_net *nn)
  * either add to a pointer or to read the pointer value.
  */
 #define NFP_QCP_QUEUE_ADDR_SZ			0x800
-#define NFP_QCP_QUEUE_AREA_SZ			0x80000
 #define NFP_QCP_QUEUE_OFF(_x)			((_x) * NFP_QCP_QUEUE_ADDR_SZ)
 #define NFP_QCP_QUEUE_ADD_RPTR			0x0000
 #define NFP_QCP_QUEUE_ADD_WPTR			0x0004
@@ -805,9 +804,6 @@ static inline void nn_pci_flush(struct nfp_net *nn)
 #define NFP_QCP_QUEUE_STS_HI			0x000c
 #define NFP_QCP_QUEUE_STS_HI_WRITEPTR_mask	0x3ffff
 
-/* The offset of a QCP queues in the PCIe Target */
-#define NFP_PCIE_QUEUE(_q) (0x80000 + (NFP_QCP_QUEUE_ADDR_SZ * ((_q) & 0xff)))
-
 /* nfp_qcp_ptr - Read or Write Pointer of a queue */
 enum nfp_qcp_ptr {
 	NFP_QCP_READ_PTR = 0,
@@ -876,6 +872,8 @@ static inline u32 nfp_qcp_wr_ptr_read(u8 __iomem *q)
 	return _nfp_qcp_read(q, NFP_QCP_WRITE_PTR);
 }
 
+u32 nfp_qcp_queue_offset(const struct nfp_dev_info *dev_info, u16 queue);
+
 static inline bool nfp_net_is_data_vnic(struct nfp_net *nn)
 {
 	WARN_ON_ONCE(!nn->dp.netdev && nn->port);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 5d993772c1d9..ef8645b77e79 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -40,6 +40,7 @@
 #include <net/vxlan.h>
 #include <net/xdp_sock_drv.h>
 
+#include "nfpcore/nfp_dev.h"
 #include "nfpcore/nfp_nsp.h"
 #include "ccm.h"
 #include "nfp_app.h"
@@ -65,6 +66,12 @@ void nfp_net_get_fw_version(struct nfp_net_fw_version *fw_ver,
 	put_unaligned_le32(reg, fw_ver);
 }
 
+u32 nfp_qcp_queue_offset(const struct nfp_dev_info *dev_info, u16 queue)
+{
+	queue &= dev_info->qc_idx_mask;
+	return dev_info->qc_addr_offset + NFP_QCP_QUEUE_ADDR_SZ * queue;
+}
+
 static dma_addr_t nfp_net_dma_map_rx(struct nfp_net_dp *dp, void *frag)
 {
 	return dma_map_single_attrs(dp->dev, frag + NFP_NET_RX_BUF_HEADROOM,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index 8934d5418b1a..a18b99c93ab3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -496,8 +496,9 @@ static int nfp_net_pci_map_mem(struct nfp_pf *pf)
 	}
 
 	cpp_id = NFP_CPP_ISLAND_ID(0, NFP_CPP_ACTION_RW, 0, 0);
-	mem = nfp_cpp_map_area(pf->cpp, "net.qc", cpp_id, NFP_PCIE_QUEUE(0),
-			       NFP_QCP_QUEUE_AREA_SZ, &pf->qc_area);
+	mem = nfp_cpp_map_area(pf->cpp, "net.qc", cpp_id,
+			       nfp_qcp_queue_offset(pf->dev_info, 0),
+			       pf->dev_info->qc_area_sz, &pf->qc_area);
 	if (IS_ERR(mem)) {
 		nfp_err(pf->cpp, "Failed to map Queue Controller area.\n");
 		err = PTR_ERR(mem);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
index 1ac2a1d97c18..db4301f8cd85 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
@@ -40,7 +40,7 @@ static const char nfp_net_driver_name[] = "nfp_netvf";
 static const struct pci_device_id nfp_netvf_pci_device_ids[] = {
 	{ PCI_VENDOR_ID_NETRONOME, PCI_DEVICE_ID_NETRONOME_NFP6000_VF,
 	  PCI_VENDOR_ID_NETRONOME, PCI_ANY_ID,
-	  PCI_ANY_ID, 0, NFP_DEV_NFP6000,
+	  PCI_ANY_ID, 0, NFP_DEV_NFP6000_VF,
 	},
 	{ 0, } /* Required last entry. */
 };
@@ -169,9 +169,9 @@ static int nfp_netvf_pci_probe(struct pci_dev *pdev,
 	}
 
 	startq = readl(ctrl_bar + NFP_NET_CFG_START_TXQ);
-	tx_bar_off = NFP_PCIE_QUEUE(startq);
+	tx_bar_off = nfp_qcp_queue_offset(dev_info, startq);
 	startq = readl(ctrl_bar + NFP_NET_CFG_START_RXQ);
-	rx_bar_off = NFP_PCIE_QUEUE(startq);
+	rx_bar_off = nfp_qcp_queue_offset(dev_info, startq);
 
 	/* Allocate and initialise the netdev */
 	nn = nfp_net_alloc(pdev, dev_info, ctrl_bar, true,
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
index 5a8be13a5596..368c6a08d887 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
@@ -2,14 +2,24 @@
 /* Copyright (C) 2019 Netronome Systems, Inc. */
 
 #include <linux/dma-mapping.h>
+#include <linux/kernel.h>
 
 #include "nfp_dev.h"
 
 const struct nfp_dev_info nfp_dev_info[NFP_DEV_CNT] = {
 	[NFP_DEV_NFP6000] = {
 		.dma_mask		= DMA_BIT_MASK(40),
+		.qc_idx_mask		= GENMASK(7, 0),
+		.qc_addr_offset		= 0x80000,
+
 		.chip_names		= "NFP4000/NFP5000/NFP6000",
 		.pcie_cfg_expbar_offset	= 0x0400,
 		.pcie_expl_offset	= 0x1000,
+		.qc_area_sz		= 0x80000,
+	},
+	[NFP_DEV_NFP6000_VF] = {
+		.dma_mask		= DMA_BIT_MASK(40),
+		.qc_idx_mask		= GENMASK(7, 0),
+		.qc_addr_offset		= 0,
 	},
 };
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
index ea61156c2075..4152be0f8b01 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
@@ -8,14 +8,21 @@
 
 enum nfp_dev_id {
 	NFP_DEV_NFP6000,
+	NFP_DEV_NFP6000_VF,
 	NFP_DEV_CNT,
 };
 
 struct nfp_dev_info {
+	/* Required fields */
 	u64 dma_mask;
+	u32 qc_idx_mask;
+	u32 qc_addr_offset;
+
+	/* PF-only fields */
 	const char *chip_names;
 	u32 pcie_cfg_expbar_offset;
 	u32 pcie_expl_offset;
+	u32 qc_area_sz;
 };
 
 extern const struct nfp_dev_info nfp_dev_info[NFP_DEV_CNT];
-- 
2.30.2

