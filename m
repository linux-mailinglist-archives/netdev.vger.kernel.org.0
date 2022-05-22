Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750DC53032A
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 14:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345362AbiEVMxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 08:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344663AbiEVMxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 08:53:17 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60072.outbound.protection.outlook.com [40.107.6.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10B4248D8
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 05:53:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6iTKttt9UyVhC0xxoi2eda1NLCLD76/8z7nroJQYqp374VwQ03eMcGZSc7xUFRXB4CiGqBv380hYNLIkrpf9cmt/p3MnA1PvyxDePEJ5UnLGZfxFyDLlx4sglIytbdANVWqkJhcxoymNhveyRev+OJuu/CPtpldvOdbNBWqssTewZRIsSrzgxzO88Zb0zote8pKrZ6FAeIYxIs8WS1VZgmVySrwLyBci2SjLi9J/CT3ZERjzwU45YJnllXB6OM33EaXj4PHd6BIjP1Zv0XJC1xO/qhhiZi5F6U7XvvUIMt1Gn2MqTWr/bwvsyYliBR+FIuja24gz7rBzo3koqJ6kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+mI6UThyKgzu62DhbXRd3piyXRq/qbr8xieb6WiK3o=;
 b=nVbVSuNzaAH2OxW7PZeEgCVq3a+b/7bl9TY3J/U9qN87HurlPbdm3FOfA/opQDnWUOTpcUeDFR/24mQKHs+31f9PQWj3+Zx7DLabEWRvnrRdS/JnaPfoOHlcJzENGpQxE84Fh6EMh574ShK/OQlvBu2LncTpF2WL81FRwwfPQ+mI53Uv0islLtCO5UYP0LJt41ugXJ9um475Jd7Lw4ZlFEscA7B1xZCNtOHz0kNHy/wcvD5pOkKOP2dDm8DPaGNADTDC6K0Z31EJeS4MvfdsccxHHmBNlVwHEjb2tnZP6AxWDCLfQyTwHyzBlzM/r4hgIoA3QvFrE7lBMeYNpGIxmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+mI6UThyKgzu62DhbXRd3piyXRq/qbr8xieb6WiK3o=;
 b=K5c+lkfMv36aLP7nXJdwwIuP/hWoPuQfKA75E0JFB6Q6mfi+Y62O+41Ij9CNr1OFntRiSy3b261uRJyfXon96ZVmcKyVokqHAOH4wnWiA4Pl1A12RzD8mhA7HDOpn1zbJcDfd2q5n2y3QqQCNYhZXp5jmKvAee4YuJwpdYo179g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AM0PR04MB4385.eurprd04.prod.outlook.com (2603:10a6:208:74::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Sun, 22 May
 2022 12:53:13 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::482e:89a:5ef4:21fd]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::482e:89a:5ef4:21fd%5]) with mapi id 15.20.5186.021; Sun, 22 May 2022
 12:53:13 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net 1/3] dpaa2-eth: retrieve the virtual address before dma_unmap
Date:   Sun, 22 May 2022 15:52:49 +0300
Message-Id: <20220522125251.444477-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220522125251.444477-1-ioana.ciornei@nxp.com>
References: <20220522125251.444477-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0008.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::21) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e0a24f1-bc5e-4959-1a6d-08da3bf2081b
X-MS-TrafficTypeDiagnostic: AM0PR04MB4385:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB438583C554E9E4216E92CD6BE0D59@AM0PR04MB4385.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qeLliPL0+MvDssJGbdh+bV8ANfgyYdGRohUwFFpoGc/tNBF6y9IC7DDECWN1RBy8b+jGS3jKF5ypwNu/ErJ2yfcliIfae92s3n2S3guudB2i9mEdi8pSpPVljNV9MJt7184M7cRuqZPpM1dOj3NnMIdhKCzUaRdot/BIJ8y6ZHRzzMYV8uSoETqxeYnhZRaDrPET7CMxXWKEzqVmPHAv70BM4nZgW1JSXfp8i6+qjh6D3BllodtWgwcS+eHtEqDPQbdBzEjUdGunhh1jScgtBSEhKgjg/iKcBpMmiQ46W9LqyfsSR2x2jVFrW80qNR1umXvVx8Zq+iMvYPvdtR0YJ6Gjm1h3R29h5sBU2l0CJkBasmqdJv9ovvf+uPBB2rd9xW4jdQPiVrsOIJJOWIo7QHvwy7fCwYZHqFDb3LwsFLEMSPFUd+2Km4u6sTPUgYNSOxq7eWtyatEHvyZ/1+xMeLZPxNflVEQYUXajUIzzBbfMZ8b83DpbgryOtI+wmT+r8FPjAhwnNCCus9wNqBUNErXoj+uIFZz6fSaRjVZF8kl5WfPn87WWcWauyhc+Y1yMCO7gOzA7o/Qrtl0faevpeg9vKguDQnUMU99CWAOCdViFKr4xjaIGN8kf9CAiyoGIRDFWEgXMKtei0tDDpDn/sx2uyDFJMCXJOJgW5QEdUPVHenECllic/AEMaveHZcldlN5+gbumI1Jl1nLeX2Vt0fd/f0h0iqSufLHi7HVgdQ3FE509qXmwhkbtLbXrgIWYJmiudMiuT1OAAR2gAtespPx4OaxMK4HgN3gvPtshRHE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(44832011)(186003)(5660300002)(4326008)(2616005)(1076003)(38350700002)(38100700002)(83380400001)(2906002)(6506007)(6512007)(26005)(52116002)(36756003)(6666004)(6486002)(8936002)(966005)(316002)(8676002)(508600001)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OtOR1qH5gkonQQ5vJ/R1vUuFoKrR6tQB9KA+YDH3KkjQq4VqoCGSTGURA1gs?=
 =?us-ascii?Q?t/6ryfxuVzs3CCavEAc1w0zL8gAJ6C9UevAd/2Iz043ZCMa2HL8e8mdEPuqX?=
 =?us-ascii?Q?5BVBsWLOBf52G/LgqCbDtcYWTH+vd4I2eaWTymVsYnItajqJ6NGOuBD90HWc?=
 =?us-ascii?Q?ACybsMyD5S73z3g2Dt/eetX753ptEAPRbUoOoxLdvu8Ap0bEKIkfTTnmIfK0?=
 =?us-ascii?Q?dJpstGbOdtodzy70XpsnJO0Amr96AS9p+qgCMhgm87hDogT64rdHN0neAX3Z?=
 =?us-ascii?Q?8DCL19coTinm87OnsX4Emuywo/6e+bPSdLGI8ccMYe7zrTg55tyBXAuLSYYF?=
 =?us-ascii?Q?j6HNPNKcb1qevpcfe6a6P2dta14QQjjZWJR/qMETYNgY90CnzOmoa3LLx8pb?=
 =?us-ascii?Q?q4krLzwemRZhWl3KZvMEL/inps1Q+pbZ2nQ0Yy/GwyOIoGSBQwYRVOZYiioT?=
 =?us-ascii?Q?6ifM1Zo6T0FL+iShej8qYTENKQlh+M0uJ2dmLV0BvfI4GA7FP9UVGeTJf1da?=
 =?us-ascii?Q?X4gTeZUldjTZUFTnpjbylCLp6kd50cdIr2Ggq5S7XkJHUB+48vwdp/13n4QG?=
 =?us-ascii?Q?ygBCatjgvQpzXANl629Fc4C9ZbryNZje+WdZ5T1j8R7kMchtfPHnn3GgCxrm?=
 =?us-ascii?Q?pvcCEwlqjIo4Xoo6ZQBQsCDtR2hixe6y+j4pbKlZHbNSiGuPrGEa5vRqYyXW?=
 =?us-ascii?Q?gaKzqsoZaGIwbn6MK5qwWLF04O5t5riHtG5uVlm4t9elHQ7gUumttSW8JioJ?=
 =?us-ascii?Q?7hOBx2p6I9ycXnfqnvmBR/UjT7T1an0X/Hp/0q4AAD8kooPJq1jPHdbKEjfX?=
 =?us-ascii?Q?dq1zWaPpHB+F/V8p5/T0zp2xKqlNn8Z0GLXo3bf8g1pKunnZxEqAaGFwQANx?=
 =?us-ascii?Q?JX1UqQMnlvr80Fp3VDU64se+gLAsP6BsVWrykAw1c1qLs6At0nezFBkW9+vB?=
 =?us-ascii?Q?Ng0VI9zWfS9TRuLu8nTmqYI+n7O33NCdrtsrIrNvnYqSw55jVVa5NOdFUpZs?=
 =?us-ascii?Q?JOzjM87oTqMrJMsBImm5+M9PP7BH0QbuJvUbx48d9eE89zAcrADEHcgxVBoL?=
 =?us-ascii?Q?D5qNVOmuT2hwKe1+ZFTHCAYBWBEDhikaTwwtrNZAvEDn/ZnQ+kgoTfo+miz+?=
 =?us-ascii?Q?8kMroZFSavbEDuOvw9vbc0foGjs9JKyKIUIejuxAtSIsptEz82a1KrPi2N9p?=
 =?us-ascii?Q?0pPTtPE4RQmqmLjFtrW7HL22i59K78pm1qUJ6wf1Y72mlok3CPgi1zCGQk0M?=
 =?us-ascii?Q?oJKhjZr7P5R5BK4a7tqnho9FZElvIa0o5PqBMwvwNS81NFFu8kYuzlRpuip1?=
 =?us-ascii?Q?wAjDeBMElObJ/KhIuRsrU2/ky8u8RGZPot8fp74Dn9jTpOtgdKApPKDPCOIy?=
 =?us-ascii?Q?oCjTBlQhDIJu4nZja5+Ul0hROjt6YtfDMbtgMmLOn3501djYfJ0CqPU6xkE9?=
 =?us-ascii?Q?00RiYqjVdbJmiLdI3uYxBHpb0DFQSs6xF9nLStOKEygyMUH6IgAlvWZF2f+A?=
 =?us-ascii?Q?ZoyCF28oAr4LyHBwh3C/y+Lulk3Qp/RptD+lf3bweqGCKpQ3N7NNE11tbgjn?=
 =?us-ascii?Q?1b3UdaNhywiD3GQDqbxwlJ4nEW6gNdBoKoy8uog6vYasIvBaJqXzDUe4f8L4?=
 =?us-ascii?Q?9VJaffEU0NmadvtP/OE5UgjXEpIt3XAyvUt33S8kVZEq/qHtXUeBzagNXxCo?=
 =?us-ascii?Q?0LA+FYj+QSDwaj+BOxGEivHOdOy1GhPZ3LrRS9aYJRa0SYLO5fNcRNjVNoS8?=
 =?us-ascii?Q?ukN282FJQ7QwQBoVJKnSZBdzAnoE450=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e0a24f1-bc5e-4959-1a6d-08da3bf2081b
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2022 12:53:13.2183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fuFEsvh4gMG8S7C8/HkvUNFUQwTk6FB6J01PQaFuuhEIeIVxvYWMtz+7oppD1X/OUvvcxUo822pgnFq9ekExcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4385
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TSO header was DMA unmapped before the virtual address was retrieved
and then used to free the buffer. This meant that we were actually
removing the DMA map and then trying to search for it to help in
retrieving the virtual address. This lead to a invalid virtual address
being used in the kfree call.

Fix this by calling dpaa2_iova_to_virt() prior to the dma_unmap call.

[  487.231819] Unable to handle kernel paging request at virtual address fffffd9807000008

(...)

[  487.354061] Hardware name: SolidRun LX2160A Honeycomb (DT)
[  487.359535] pstate: a0400005 (NzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  487.366485] pc : kfree+0xac/0x304
[  487.369799] lr : kfree+0x204/0x304
[  487.373191] sp : ffff80000c4eb120
[  487.376493] x29: ffff80000c4eb120 x28: ffff662240c46400 x27: 0000000000000001
[  487.383621] x26: 0000000000000001 x25: ffff662246da0cc0 x24: ffff66224af78000
[  487.390748] x23: ffffad184f4ce008 x22: ffffad1850185000 x21: ffffad1838d13cec
[  487.397874] x20: ffff6601c0000000 x19: fffffd9807000000 x18: 0000000000000000
[  487.405000] x17: ffffb910cdc49000 x16: ffffad184d7d9080 x15: 0000000000004000
[  487.412126] x14: 0000000000000008 x13: 000000000000ffff x12: 0000000000000000
[  487.419252] x11: 0000000000000004 x10: 0000000000000001 x9 : ffffad184d7d927c
[  487.426379] x8 : 0000000000000000 x7 : 0000000ffffffd1d x6 : ffff662240a94900
[  487.433505] x5 : 0000000000000003 x4 : 0000000000000009 x3 : ffffad184f4ce008
[  487.440632] x2 : ffff662243eec000 x1 : 0000000100000100 x0 : fffffc0000000000
[  487.447758] Call trace:
[  487.450194]  kfree+0xac/0x304
[  487.453151]  dpaa2_eth_free_tx_fd.isra.0+0x33c/0x3e0 [fsl_dpaa2_eth]
[  487.459507]  dpaa2_eth_tx_conf+0x100/0x2e0 [fsl_dpaa2_eth]
[  487.464989]  dpaa2_eth_poll+0xdc/0x380 [fsl_dpaa2_eth]

Fixes: 3dc709e0cd47 ("dpaa2-eth: add support for software TSO")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215886
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 4b047255d928..766391310d1b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1097,6 +1097,7 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 	u32 fd_len = dpaa2_fd_get_len(fd);
 	struct dpaa2_sg_entry *sgt;
 	int should_free_skb = 1;
+	void *tso_hdr;
 	int i;
 
 	fd_addr = dpaa2_fd_get_addr(fd);
@@ -1136,9 +1137,10 @@ static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 							priv->tx_data_offset);
 
 			/* Unmap and free the header */
+			tso_hdr = dpaa2_iova_to_virt(priv->iommu_domain, dpaa2_sg_get_addr(sgt));
 			dma_unmap_single(dev, dpaa2_sg_get_addr(sgt), TSO_HEADER_SIZE,
 					 DMA_TO_DEVICE);
-			kfree(dpaa2_iova_to_virt(priv->iommu_domain, dpaa2_sg_get_addr(sgt)));
+			kfree(tso_hdr);
 
 			/* Unmap the other SG entries for the data */
 			for (i = 1; i < swa->tso.num_sg; i++)
-- 
2.33.1

