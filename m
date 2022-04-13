Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95BA4FEDA1
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 05:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbiDMDho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 23:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbiDMDhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 23:37:43 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4B426563;
        Tue, 12 Apr 2022 20:35:22 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23CNGcaV018361;
        Tue, 12 Apr 2022 20:35:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=hzHiKLdQ9Q59UUcSqUnwprRkPSWk/owC0jQN2MMbQu8=;
 b=TpulGVz3E1WMisN7/OYhlNgkgNIuF6iWSyg8d9k11v4dfWL26cUJwJLxMZJd8MapZKZP
 /08F0Tio4RAL7BlqWC+iMAa2LYHtJ4ZGuU+O6qUonACvqpKdlcjy7/P7DeMzf2R8nGRO
 aY8cx0ER4WR6UQ3fnFCVUKZOTnM1nJ2uZmgRckQL2MMY3On0GiklZfYJHEOSxqzrO0Zc
 avJ8jomZHqtAJaeXEdwQ/HKH0qZdgauBuvYYYgp2KJKXj/6Zx0w0fXW5TucvDLQNo3q9
 CZcNbldjiXlU+7eI1LqcRzb8QU2hmNsZt6vukkYWotpmBiGCMEhwmZm7JeEUtMTwca/h Fg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3fdjxyrtjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 12 Apr 2022 20:35:09 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 12 Apr
 2022 20:35:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 12 Apr 2022 20:35:07 -0700
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id C92435B6922;
        Tue, 12 Apr 2022 20:35:07 -0700 (PDT)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <vburru@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <corbet@lwn.net>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Abhijit Ayarekar <aayarekar@marvell.com>,
        Satananda Burla <sburla@marvell.com>
Subject: [net-next PATCH v5 2/7] octeon_ep: add hardware configuration APIs
Date:   Tue, 12 Apr 2022 20:34:58 -0700
Message-ID: <20220413033503.3962-3-vburru@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220413033503.3962-1-vburru@marvell.com>
References: <20220413033503.3962-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: maI7MepxezF8v8WFksqZYTUQ1SEbnY1f
X-Proofpoint-ORIG-GUID: maI7MepxezF8v8WFksqZYTUQ1SEbnY1f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-12_06,2022-04-12_02,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement hardware resource init and shutdown helper APIs.
This includes hardware Tx/Rx queue init/enable/disable/reset,
non queue interrupt handler that decodes non-queue interrupt type.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
Signed-off-by: Satananda Burla <sburla@marvell.com>
---
V4 -> V5:
  - remove static from declaration of octep_wq; accessed in
    other files.

V3 -> V4:
  - Fix warnings/errors from "make W=1 C=1" that were missed to fix in
    V3 patchset.

V2 -> V3: no change.

V1 -> V2:
  - created by dividing PATCH 1/4 of original patch series.

 .../marvell/octeon_ep/octep_cn9k_pf.c         | 498 +++++++++++++++++-
 .../ethernet/marvell/octeon_ep/octep_main.c   |   2 +-
 .../ethernet/marvell/octeon_ep/octep_main.h   |  12 +-
 3 files changed, 505 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
index a38b52788619..1e47143c596d 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
@@ -33,19 +33,164 @@ static char *cn93_non_ioq_msix_names[] = {
 	"epf_rsvd",
 };
 
+/* Dump useful hardware CSRs for debug purpose */
+static void cn93_dump_regs(struct octep_device *oct, int qno)
+{
+	struct device *dev = &oct->pdev->dev;
+
+	dev_info(dev, "IQ-%d register dump\n", qno);
+	dev_info(dev, "R[%d]_IN_INSTR_DBELL[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_IN_INSTR_DBELL(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_IN_INSTR_DBELL(qno)));
+	dev_info(dev, "R[%d]_IN_CONTROL[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_IN_CONTROL(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_IN_CONTROL(qno)));
+	dev_info(dev, "R[%d]_IN_ENABLE[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_IN_ENABLE(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_IN_ENABLE(qno)));
+	dev_info(dev, "R[%d]_IN_INSTR_BADDR[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_IN_INSTR_BADDR(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_IN_INSTR_BADDR(qno)));
+	dev_info(dev, "R[%d]_IN_INSTR_RSIZE[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_IN_INSTR_RSIZE(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_IN_INSTR_RSIZE(qno)));
+	dev_info(dev, "R[%d]_IN_CNTS[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_IN_CNTS(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_IN_CNTS(qno)));
+	dev_info(dev, "R[%d]_IN_INT_LEVELS[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_IN_INT_LEVELS(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_IN_INT_LEVELS(qno)));
+	dev_info(dev, "R[%d]_IN_PKT_CNT[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_IN_PKT_CNT(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_IN_PKT_CNT(qno)));
+	dev_info(dev, "R[%d]_IN_BYTE_CNT[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_IN_BYTE_CNT(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_IN_BYTE_CNT(qno)));
+
+	dev_info(dev, "OQ-%d register dump\n", qno);
+	dev_info(dev, "R[%d]_OUT_SLIST_DBELL[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_OUT_SLIST_DBELL(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_OUT_SLIST_DBELL(qno)));
+	dev_info(dev, "R[%d]_OUT_CONTROL[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_OUT_CONTROL(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_OUT_CONTROL(qno)));
+	dev_info(dev, "R[%d]_OUT_ENABLE[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_OUT_ENABLE(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_OUT_ENABLE(qno)));
+	dev_info(dev, "R[%d]_OUT_SLIST_BADDR[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_OUT_SLIST_BADDR(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_OUT_SLIST_BADDR(qno)));
+	dev_info(dev, "R[%d]_OUT_SLIST_RSIZE[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_OUT_SLIST_RSIZE(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_OUT_SLIST_RSIZE(qno)));
+	dev_info(dev, "R[%d]_OUT_CNTS[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_OUT_CNTS(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_OUT_CNTS(qno)));
+	dev_info(dev, "R[%d]_OUT_INT_LEVELS[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_OUT_INT_LEVELS(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_OUT_INT_LEVELS(qno)));
+	dev_info(dev, "R[%d]_OUT_PKT_CNT[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_OUT_PKT_CNT(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_OUT_PKT_CNT(qno)));
+	dev_info(dev, "R[%d]_OUT_BYTE_CNT[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_OUT_BYTE_CNT(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_OUT_BYTE_CNT(qno)));
+	dev_info(dev, "R[%d]_ERR_TYPE[0x%llx]: 0x%016llx\n",
+		 qno, CN93_SDP_R_ERR_TYPE(qno),
+		 octep_read_csr64(oct, CN93_SDP_R_ERR_TYPE(qno)));
+}
+
+/* Reset Hardware Tx queue */
+static int cn93_reset_iq(struct octep_device *oct, int q_no)
+{
+	struct octep_config *conf = oct->conf;
+	u64 val = 0ULL;
+
+	dev_dbg(&oct->pdev->dev, "Reset PF IQ-%d\n", q_no);
+
+	/* Get absolute queue number */
+	q_no += conf->pf_ring_cfg.srn;
+
+	/* Disable the Tx/Instruction Ring */
+	octep_write_csr64(oct, CN93_SDP_R_IN_ENABLE(q_no), val);
+
+	/* clear the Instruction Ring packet/byte counts and doorbell CSRs */
+	octep_write_csr64(oct, CN93_SDP_R_IN_CNTS(q_no), val);
+	octep_write_csr64(oct, CN93_SDP_R_IN_INT_LEVELS(q_no), val);
+	octep_write_csr64(oct, CN93_SDP_R_IN_PKT_CNT(q_no), val);
+	octep_write_csr64(oct, CN93_SDP_R_IN_BYTE_CNT(q_no), val);
+	octep_write_csr64(oct, CN93_SDP_R_IN_INSTR_BADDR(q_no), val);
+	octep_write_csr64(oct, CN93_SDP_R_IN_INSTR_RSIZE(q_no), val);
+
+	val = 0xFFFFFFFF;
+	octep_write_csr64(oct, CN93_SDP_R_IN_INSTR_DBELL(q_no), val);
+
+	return 0;
+}
+
+/* Reset Hardware Rx queue */
+static void cn93_reset_oq(struct octep_device *oct, int q_no)
+{
+	u64 val = 0ULL;
+
+	q_no += CFG_GET_PORTS_PF_SRN(oct->conf);
+
+	/* Disable Output (Rx) Ring */
+	octep_write_csr64(oct, CN93_SDP_R_OUT_ENABLE(q_no), val);
+
+	/* Clear count CSRs */
+	val = octep_read_csr(oct, CN93_SDP_R_OUT_CNTS(q_no));
+	octep_write_csr(oct, CN93_SDP_R_OUT_CNTS(q_no), val);
+
+	octep_write_csr64(oct, CN93_SDP_R_OUT_PKT_CNT(q_no), 0xFFFFFFFFFULL);
+	octep_write_csr64(oct, CN93_SDP_R_OUT_SLIST_DBELL(q_no), 0xFFFFFFFF);
+}
+
 /* Reset all hardware Tx/Rx queues */
 static void octep_reset_io_queues_cn93_pf(struct octep_device *oct)
 {
+	struct pci_dev *pdev = oct->pdev;
+	int q;
+
+	dev_dbg(&pdev->dev, "Reset OCTEP_CN93 PF IO Queues\n");
+
+	for (q = 0; q < CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf); q++) {
+		cn93_reset_iq(oct, q);
+		cn93_reset_oq(oct, q);
+	}
 }
 
 /* Initialize windowed addresses to access some hardware registers */
 static void octep_setup_pci_window_regs_cn93_pf(struct octep_device *oct)
 {
+	u8 __iomem *bar0_pciaddr = oct->mmio[0].hw_addr;
+
+	oct->pci_win_regs.pci_win_wr_addr = (u8 __iomem *)(bar0_pciaddr + CN93_SDP_WIN_WR_ADDR64);
+	oct->pci_win_regs.pci_win_rd_addr = (u8 __iomem *)(bar0_pciaddr + CN93_SDP_WIN_RD_ADDR64);
+	oct->pci_win_regs.pci_win_wr_data = (u8 __iomem *)(bar0_pciaddr + CN93_SDP_WIN_WR_DATA64);
+	oct->pci_win_regs.pci_win_rd_data = (u8 __iomem *)(bar0_pciaddr + CN93_SDP_WIN_RD_DATA64);
 }
 
 /* Configure Hardware mapping: inform hardware which rings belong to PF. */
 static void octep_configure_ring_mapping_cn93_pf(struct octep_device *oct)
 {
+	struct octep_config *conf = oct->conf;
+	struct pci_dev *pdev = oct->pdev;
+	u64 pf_srn = CFG_GET_PORTS_PF_SRN(oct->conf);
+	int q;
+
+	for (q = 0; q < CFG_GET_PORTS_ACTIVE_IO_RINGS(conf); q++) {
+		u64 regval = 0;
+
+		if (oct->pcie_port)
+			regval = 8 << CN93_SDP_FUNC_SEL_EPF_BIT_POS;
+
+		octep_write_csr64(oct, CN93_SDP_EPVF_RING(pf_srn + q), regval);
+
+		regval = octep_read_csr64(oct, CN93_SDP_EPVF_RING(pf_srn + q));
+		dev_dbg(&pdev->dev, "Write SDP_EPVF_RING[0x%llx] = 0x%llx\n",
+			CN93_SDP_EPVF_RING(pf_srn + q), regval);
+	}
 }
 
 /* Initialize configuration limits and initial active config 93xx PF. */
@@ -95,27 +240,265 @@ static void octep_init_config_cn93_pf(struct octep_device *oct)
 /* Setup registers for a hardware Tx Queue  */
 static void octep_setup_iq_regs_cn93_pf(struct octep_device *oct, int iq_no)
 {
+	struct octep_iq *iq = oct->iq[iq_no];
+	u32 reset_instr_cnt;
+	u64 reg_val;
+
+	iq_no += CFG_GET_PORTS_PF_SRN(oct->conf);
+	reg_val = octep_read_csr64(oct, CN93_SDP_R_IN_CONTROL(iq_no));
+
+	/* wait for IDLE to set to 1 */
+	if (!(reg_val & CN93_R_IN_CTL_IDLE)) {
+		do {
+			reg_val = octep_read_csr64(oct, CN93_SDP_R_IN_CONTROL(iq_no));
+		} while (!(reg_val & CN93_R_IN_CTL_IDLE));
+	}
+
+	reg_val |= CN93_R_IN_CTL_RDSIZE;
+	reg_val |= CN93_R_IN_CTL_IS_64B;
+	reg_val |= CN93_R_IN_CTL_ESR;
+	octep_write_csr64(oct, CN93_SDP_R_IN_CONTROL(iq_no), reg_val);
+
+	/* Write the start of the input queue's ring and its size  */
+	octep_write_csr64(oct, CN93_SDP_R_IN_INSTR_BADDR(iq_no),
+			  iq->desc_ring_dma);
+	octep_write_csr64(oct, CN93_SDP_R_IN_INSTR_RSIZE(iq_no),
+			  iq->max_count);
+
+	/* Remember the doorbell & instruction count register addr
+	 * for this queue
+	 */
+	iq->doorbell_reg = oct->mmio[0].hw_addr +
+			   CN93_SDP_R_IN_INSTR_DBELL(iq_no);
+	iq->inst_cnt_reg = oct->mmio[0].hw_addr +
+			   CN93_SDP_R_IN_CNTS(iq_no);
+	iq->intr_lvl_reg = oct->mmio[0].hw_addr +
+			   CN93_SDP_R_IN_INT_LEVELS(iq_no);
+
+	/* Store the current instruction counter (used in flush_iq calculation) */
+	reset_instr_cnt = readl(iq->inst_cnt_reg);
+	writel(reset_instr_cnt, iq->inst_cnt_reg);
+
+	/* INTR_THRESHOLD is set to max(FFFFFFFF) to disable the INTR */
+	reg_val = CFG_GET_IQ_INTR_THRESHOLD(oct->conf) & 0xffffffff;
+	octep_write_csr64(oct, CN93_SDP_R_IN_INT_LEVELS(iq_no), reg_val);
 }
 
 /* Setup registers for a hardware Rx Queue  */
 static void octep_setup_oq_regs_cn93_pf(struct octep_device *oct, int oq_no)
 {
+	u64 reg_val;
+	u64 oq_ctl = 0ULL;
+	u32 time_threshold = 0;
+	struct octep_oq *oq = oct->oq[oq_no];
+
+	oq_no += CFG_GET_PORTS_PF_SRN(oct->conf);
+	reg_val = octep_read_csr64(oct, CN93_SDP_R_OUT_CONTROL(oq_no));
+
+	/* wait for IDLE to set to 1 */
+	if (!(reg_val & CN93_R_OUT_CTL_IDLE)) {
+		do {
+			reg_val = octep_read_csr64(oct, CN93_SDP_R_OUT_CONTROL(oq_no));
+		} while (!(reg_val & CN93_R_OUT_CTL_IDLE));
+	}
+
+	reg_val &= ~(CN93_R_OUT_CTL_IMODE);
+	reg_val &= ~(CN93_R_OUT_CTL_ROR_P);
+	reg_val &= ~(CN93_R_OUT_CTL_NSR_P);
+	reg_val &= ~(CN93_R_OUT_CTL_ROR_I);
+	reg_val &= ~(CN93_R_OUT_CTL_NSR_I);
+	reg_val &= ~(CN93_R_OUT_CTL_ES_I);
+	reg_val &= ~(CN93_R_OUT_CTL_ROR_D);
+	reg_val &= ~(CN93_R_OUT_CTL_NSR_D);
+	reg_val &= ~(CN93_R_OUT_CTL_ES_D);
+	reg_val |= (CN93_R_OUT_CTL_ES_P);
+
+	octep_write_csr64(oct, CN93_SDP_R_OUT_CONTROL(oq_no), reg_val);
+	octep_write_csr64(oct, CN93_SDP_R_OUT_SLIST_BADDR(oq_no),
+			  oq->desc_ring_dma);
+	octep_write_csr64(oct, CN93_SDP_R_OUT_SLIST_RSIZE(oq_no),
+			  oq->max_count);
+
+	oq_ctl = octep_read_csr64(oct, CN93_SDP_R_OUT_CONTROL(oq_no));
+	oq_ctl &= ~0x7fffffULL;	//clear the ISIZE and BSIZE (22-0)
+	oq_ctl |= (oq->buffer_size & 0xffff);	//populate the BSIZE (15-0)
+	octep_write_csr64(oct, CN93_SDP_R_OUT_CONTROL(oq_no), oq_ctl);
+
+	/* Get the mapped address of the pkt_sent and pkts_credit regs */
+	oq->pkts_sent_reg = oct->mmio[0].hw_addr + CN93_SDP_R_OUT_CNTS(oq_no);
+	oq->pkts_credit_reg = oct->mmio[0].hw_addr +
+			      CN93_SDP_R_OUT_SLIST_DBELL(oq_no);
+
+	time_threshold = CFG_GET_OQ_INTR_TIME(oct->conf);
+	reg_val = ((u64)time_threshold << 32) |
+		  CFG_GET_OQ_INTR_PKT(oct->conf);
+	octep_write_csr64(oct, CN93_SDP_R_OUT_INT_LEVELS(oq_no), reg_val);
 }
 
 /* Setup registers for a PF mailbox */
 static void octep_setup_mbox_regs_cn93_pf(struct octep_device *oct, int q_no)
 {
+	struct octep_mbox *mbox = oct->mbox[q_no];
+
+	mbox->q_no = q_no;
+
+	/* PF mbox interrupt reg */
+	mbox->mbox_int_reg = oct->mmio[0].hw_addr + CN93_SDP_EPF_MBOX_RINT(0);
+
+	/* PF to VF DATA reg. PF writes into this reg */
+	mbox->mbox_write_reg = oct->mmio[0].hw_addr + CN93_SDP_R_MBOX_PF_VF_DATA(q_no);
+
+	/* VF to PF DATA reg. PF reads from this reg */
+	mbox->mbox_read_reg = oct->mmio[0].hw_addr + CN93_SDP_R_MBOX_VF_PF_DATA(q_no);
+}
+
+/* Mailbox Interrupt handler */
+static void cn93_handle_pf_mbox_intr(struct octep_device *oct)
+{
+	u64 mbox_int_val = 0ULL, val = 0ULL, qno = 0ULL;
+
+	mbox_int_val = readq(oct->mbox[0]->mbox_int_reg);
+	for (qno = 0; qno < OCTEP_MAX_VF; qno++) {
+		val = readq(oct->mbox[qno]->mbox_read_reg);
+		dev_dbg(&oct->pdev->dev,
+			"PF MBOX READ: val:%llx from VF:%llx\n", val, qno);
+	}
+
+	writeq(mbox_int_val, oct->mbox[0]->mbox_int_reg);
 }
 
 /* Interrupts handler for all non-queue generic interrupts. */
 static irqreturn_t octep_non_ioq_intr_handler_cn93_pf(void *dev)
 {
+	struct octep_device *oct = (struct octep_device *)dev;
+	struct pci_dev *pdev = oct->pdev;
+	u64 reg_val = 0;
+	int i = 0;
+
+	/* Check for IRERR INTR */
+	reg_val = octep_read_csr64(oct, CN93_SDP_EPF_IRERR_RINT);
+	if (reg_val) {
+		dev_info(&pdev->dev,
+			 "received IRERR_RINT intr: 0x%llx\n", reg_val);
+		octep_write_csr64(oct, CN93_SDP_EPF_IRERR_RINT, reg_val);
+
+		for (i = 0; i < CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf); i++) {
+			reg_val = octep_read_csr64(oct,
+						   CN93_SDP_R_ERR_TYPE(i));
+			if (reg_val) {
+				dev_info(&pdev->dev,
+					 "Received err type on IQ-%d: 0x%llx\n",
+					 i, reg_val);
+				octep_write_csr64(oct, CN93_SDP_R_ERR_TYPE(i),
+						  reg_val);
+			}
+		}
+		goto irq_handled;
+	}
+
+	/* Check for ORERR INTR */
+	reg_val = octep_read_csr64(oct, CN93_SDP_EPF_ORERR_RINT);
+	if (reg_val) {
+		dev_info(&pdev->dev,
+			 "Received ORERR_RINT intr: 0x%llx\n", reg_val);
+		octep_write_csr64(oct, CN93_SDP_EPF_ORERR_RINT, reg_val);
+		for (i = 0; i < CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf); i++) {
+			reg_val = octep_read_csr64(oct, CN93_SDP_R_ERR_TYPE(i));
+			if (reg_val) {
+				dev_info(&pdev->dev,
+					 "Received err type on OQ-%d: 0x%llx\n",
+					 i, reg_val);
+				octep_write_csr64(oct, CN93_SDP_R_ERR_TYPE(i),
+						  reg_val);
+			}
+		}
+
+		goto irq_handled;
+	}
+
+	/* Check for VFIRE INTR */
+	reg_val = octep_read_csr64(oct, CN93_SDP_EPF_VFIRE_RINT(0));
+	if (reg_val) {
+		dev_info(&pdev->dev,
+			 "Received VFIRE_RINT intr: 0x%llx\n", reg_val);
+		octep_write_csr64(oct, CN93_SDP_EPF_VFIRE_RINT(0), reg_val);
+		goto irq_handled;
+	}
+
+	/* Check for VFORE INTR */
+	reg_val = octep_read_csr64(oct, CN93_SDP_EPF_VFORE_RINT(0));
+	if (reg_val) {
+		dev_info(&pdev->dev,
+			 "Received VFORE_RINT intr: 0x%llx\n", reg_val);
+		octep_write_csr64(oct, CN93_SDP_EPF_VFORE_RINT(0), reg_val);
+		goto irq_handled;
+	}
+
+	/* Check for MBOX INTR */
+	reg_val = octep_read_csr64(oct, CN93_SDP_EPF_MBOX_RINT(0));
+	if (reg_val) {
+		dev_info(&pdev->dev,
+			 "Received MBOX_RINT intr: 0x%llx\n", reg_val);
+		cn93_handle_pf_mbox_intr(oct);
+		goto irq_handled;
+	}
+
+	/* Check for OEI INTR */
+	reg_val = octep_read_csr64(oct, CN93_SDP_EPF_OEI_RINT);
+	if (reg_val) {
+		dev_info(&pdev->dev,
+			 "Received OEI_EINT intr: 0x%llx\n", reg_val);
+		octep_write_csr64(oct, CN93_SDP_EPF_OEI_RINT, reg_val);
+		queue_work(octep_wq, &oct->ctrl_mbox_task);
+		goto irq_handled;
+	}
+
+	/* Check for DMA INTR */
+	reg_val = octep_read_csr64(oct, CN93_SDP_EPF_DMA_RINT);
+	if (reg_val) {
+		octep_write_csr64(oct, CN93_SDP_EPF_DMA_RINT, reg_val);
+		goto irq_handled;
+	}
+
+	/* Check for DMA VF INTR */
+	reg_val = octep_read_csr64(oct, CN93_SDP_EPF_DMA_VF_RINT(0));
+	if (reg_val) {
+		dev_info(&pdev->dev,
+			 "Received DMA_VF_RINT intr: 0x%llx\n", reg_val);
+		octep_write_csr64(oct, CN93_SDP_EPF_DMA_VF_RINT(0), reg_val);
+		goto irq_handled;
+	}
+
+	/* Check for PPVF INTR */
+	reg_val = octep_read_csr64(oct, CN93_SDP_EPF_PP_VF_RINT(0));
+	if (reg_val) {
+		dev_info(&pdev->dev,
+			 "Received PP_VF_RINT intr: 0x%llx\n", reg_val);
+		octep_write_csr64(oct, CN93_SDP_EPF_PP_VF_RINT(0), reg_val);
+		goto irq_handled;
+	}
+
+	/* Check for MISC INTR */
+	reg_val = octep_read_csr64(oct, CN93_SDP_EPF_MISC_RINT);
+	if (reg_val) {
+		dev_info(&pdev->dev,
+			 "Received MISC_RINT intr: 0x%llx\n", reg_val);
+		octep_write_csr64(oct, CN93_SDP_EPF_MISC_RINT, reg_val);
+		goto irq_handled;
+	}
+
+	dev_info(&pdev->dev, "Reserved inerrupts raised; Ignore\n");
+irq_handled:
 	return IRQ_HANDLED;
 }
 
 /* Tx/Rx queue interrupt handler */
 static irqreturn_t octep_ioq_intr_handler_cn93_pf(void *data)
 {
+	struct octep_ioq_vector *vector = (struct octep_ioq_vector *)data;
+	struct octep_oq *oq = vector->oq;
+
+	napi_schedule_irqoff(oq->napi);
 	return IRQ_HANDLED;
 }
 
@@ -139,57 +522,170 @@ static int octep_soft_reset_cn93_pf(struct octep_device *oct)
 /* Re-initialize Octeon hardware registers */
 static void octep_reinit_regs_cn93_pf(struct octep_device *oct)
 {
+	u32 i;
+
+	for (i = 0; i < CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf); i++)
+		oct->hw_ops.setup_iq_regs(oct, i);
+
+	for (i = 0; i < CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf); i++)
+		oct->hw_ops.setup_oq_regs(oct, i);
+
+	oct->hw_ops.enable_interrupts(oct);
+	oct->hw_ops.enable_io_queues(oct);
+
+	for (i = 0; i < CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf); i++)
+		writel(oct->oq[i]->max_count, oct->oq[i]->pkts_credit_reg);
 }
 
 /* Enable all interrupts */
 static void octep_enable_interrupts_cn93_pf(struct octep_device *oct)
 {
+	u64 intr_mask = 0ULL;
+	int srn, num_rings, i;
+
+	srn = CFG_GET_PORTS_PF_SRN(oct->conf);
+	num_rings = CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf);
+
+	for (i = 0; i < num_rings; i++)
+		intr_mask |= (0x1ULL << (srn + i));
+
+	octep_write_csr64(oct, CN93_SDP_EPF_IRERR_RINT_ENA_W1S, intr_mask);
+	octep_write_csr64(oct, CN93_SDP_EPF_ORERR_RINT_ENA_W1S, intr_mask);
+	octep_write_csr64(oct, CN93_SDP_EPF_OEI_RINT_ENA_W1S, -1ULL);
+	octep_write_csr64(oct, CN93_SDP_EPF_MISC_RINT_ENA_W1S, intr_mask);
+	octep_write_csr64(oct, CN93_SDP_EPF_DMA_RINT_ENA_W1S, intr_mask);
 }
 
 /* Disable all interrupts */
 static void octep_disable_interrupts_cn93_pf(struct octep_device *oct)
 {
+	u64 intr_mask = 0ULL;
+	int srn, num_rings, i;
+
+	srn = CFG_GET_PORTS_PF_SRN(oct->conf);
+	num_rings = CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf);
+
+	for (i = 0; i < num_rings; i++)
+		intr_mask |= (0x1ULL << (srn + i));
+
+	octep_write_csr64(oct, CN93_SDP_EPF_IRERR_RINT_ENA_W1C, intr_mask);
+	octep_write_csr64(oct, CN93_SDP_EPF_ORERR_RINT_ENA_W1C, intr_mask);
+	octep_write_csr64(oct, CN93_SDP_EPF_OEI_RINT_ENA_W1C, -1ULL);
+	octep_write_csr64(oct, CN93_SDP_EPF_MISC_RINT_ENA_W1C, intr_mask);
+	octep_write_csr64(oct, CN93_SDP_EPF_DMA_RINT_ENA_W1C, intr_mask);
 }
 
 /* Get new Octeon Read Index: index of descriptor that Octeon reads next. */
 static u32 octep_update_iq_read_index_cn93_pf(struct octep_iq *iq)
 {
-	return 0;
+	u32 pkt_in_done = readl(iq->inst_cnt_reg);
+	u32 last_done, new_idx;
+
+	last_done = pkt_in_done - iq->pkt_in_done;
+	iq->pkt_in_done = pkt_in_done;
+
+	new_idx = (iq->octep_read_index + last_done) % iq->max_count;
+
+	return new_idx;
 }
 
 /* Enable a hardware Tx Queue */
 static void octep_enable_iq_cn93_pf(struct octep_device *oct, int iq_no)
 {
+	u64 loop = HZ;
+	u64 reg_val;
+
+	iq_no += CFG_GET_PORTS_PF_SRN(oct->conf);
+
+	octep_write_csr64(oct, CN93_SDP_R_IN_INSTR_DBELL(iq_no), 0xFFFFFFFF);
+
+	while (octep_read_csr64(oct, CN93_SDP_R_IN_INSTR_DBELL(iq_no)) &&
+	       loop--) {
+		schedule_timeout_interruptible(1);
+	}
+
+	reg_val = octep_read_csr64(oct,  CN93_SDP_R_IN_INT_LEVELS(iq_no));
+	reg_val |= (0x1ULL << 62);
+	octep_write_csr64(oct, CN93_SDP_R_IN_INT_LEVELS(iq_no), reg_val);
+
+	reg_val = octep_read_csr64(oct, CN93_SDP_R_IN_ENABLE(iq_no));
+	reg_val |= 0x1ULL;
+	octep_write_csr64(oct, CN93_SDP_R_IN_ENABLE(iq_no), reg_val);
 }
 
 /* Enable a hardware Rx Queue */
 static void octep_enable_oq_cn93_pf(struct octep_device *oct, int oq_no)
 {
+	u64 reg_val = 0ULL;
+
+	oq_no += CFG_GET_PORTS_PF_SRN(oct->conf);
+
+	reg_val = octep_read_csr64(oct,  CN93_SDP_R_OUT_INT_LEVELS(oq_no));
+	reg_val |= (0x1ULL << 62);
+	octep_write_csr64(oct, CN93_SDP_R_OUT_INT_LEVELS(oq_no), reg_val);
+
+	octep_write_csr64(oct, CN93_SDP_R_OUT_SLIST_DBELL(oq_no), 0xFFFFFFFF);
+
+	reg_val = octep_read_csr64(oct, CN93_SDP_R_OUT_ENABLE(oq_no));
+	reg_val |= 0x1ULL;
+	octep_write_csr64(oct, CN93_SDP_R_OUT_ENABLE(oq_no), reg_val);
 }
 
 /* Enable all hardware Tx/Rx Queues assined to PF */
 static void octep_enable_io_queues_cn93_pf(struct octep_device *oct)
 {
+	u8 q;
+
+	for (q = 0; q < CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf); q++) {
+		octep_enable_iq_cn93_pf(oct, q);
+		octep_enable_oq_cn93_pf(oct, q);
+	}
 }
 
 /* Disable a hardware Tx Queue assined to PF */
 static void octep_disable_iq_cn93_pf(struct octep_device *oct, int iq_no)
 {
+	u64 reg_val = 0ULL;
+
+	iq_no += CFG_GET_PORTS_PF_SRN(oct->conf);
+
+	reg_val = octep_read_csr64(oct, CN93_SDP_R_IN_ENABLE(iq_no));
+	reg_val &= ~0x1ULL;
+	octep_write_csr64(oct, CN93_SDP_R_IN_ENABLE(iq_no), reg_val);
 }
 
 /* Disable a hardware Rx Queue assined to PF */
 static void octep_disable_oq_cn93_pf(struct octep_device *oct, int oq_no)
 {
+	u64 reg_val = 0ULL;
+
+	oq_no += CFG_GET_PORTS_PF_SRN(oct->conf);
+	reg_val = octep_read_csr64(oct, CN93_SDP_R_OUT_ENABLE(oq_no));
+	reg_val &= ~0x1ULL;
+	octep_write_csr64(oct, CN93_SDP_R_OUT_ENABLE(oq_no), reg_val);
 }
 
 /* Disable all hardware Tx/Rx Queues assined to PF */
 static void octep_disable_io_queues_cn93_pf(struct octep_device *oct)
 {
+	int q = 0;
+
+	for (q = 0; q < CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf); q++) {
+		octep_disable_iq_cn93_pf(oct, q);
+		octep_disable_oq_cn93_pf(oct, q);
+	}
 }
 
 /* Dump hardware registers (including Tx/Rx queues) for debugging. */
 static void octep_dump_registers_cn93_pf(struct octep_device *oct)
 {
+	u8 srn, num_rings, q;
+
+	srn = CFG_GET_PORTS_PF_SRN(oct->conf);
+	num_rings = CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf);
+
+	for (q = srn; q < srn + num_rings; q++)
+		cn93_dump_regs(oct, q);
 }
 
 /**
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 3b55510b2550..8b3dc50d08fd 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -18,7 +18,7 @@
 #include "octep_main.h"
 #include "octep_ctrl_net.h"
 
-static struct workqueue_struct *octep_wq;
+struct workqueue_struct *octep_wq;
 
 /* Supported Devices */
 static const struct pci_device_id octep_pci_id_tbl[] = {
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
index 4950b4418035..520f2c3664f9 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
@@ -109,17 +109,17 @@ struct octep_mbox {
 	u32 state;
 
 	/* SLI_MAC_PF_MBOX_INT for PF, SLI_PKT_MBOX_INT for VF. */
-	void *mbox_int_reg;
+	u8 __iomem *mbox_int_reg;
 
 	/* SLI_PKT_PF_VF_MBOX_SIG(0) for PF,
 	 * SLI_PKT_PF_VF_MBOX_SIG(1) for VF.
 	 */
-	void *mbox_write_reg;
+	u8 __iomem *mbox_write_reg;
 
 	/* SLI_PKT_PF_VF_MBOX_SIG(1) for PF,
 	 * SLI_PKT_PF_VF_MBOX_SIG(0) for VF.
 	 */
-	void *mbox_read_reg;
+	u8 __iomem *mbox_read_reg;
 
 	struct octep_mbox_data mbox_data;
 };
@@ -294,13 +294,13 @@ static inline u16 OCTEP_MINOR_REV(struct octep_device *oct)
 
 /* Octeon CSR read/write access APIs */
 #define octep_write_csr(octep_dev, reg_off, value) \
-	writel(value, (u8 *)(octep_dev)->mmio[0].hw_addr + (reg_off))
+	writel(value, (octep_dev)->mmio[0].hw_addr + (reg_off))
 
 #define octep_write_csr64(octep_dev, reg_off, val64) \
 	writeq(val64, (octep_dev)->mmio[0].hw_addr + (reg_off))
 
 #define octep_read_csr(octep_dev, reg_off)         \
-	readl((u8 *)(octep_dev)->mmio[0].hw_addr + (reg_off))
+	readl((octep_dev)->mmio[0].hw_addr + (reg_off))
 
 #define octep_read_csr64(octep_dev, reg_off)         \
 	readq((octep_dev)->mmio[0].hw_addr + (reg_off))
@@ -349,6 +349,8 @@ OCTEP_PCI_WIN_WRITE(struct octep_device *oct, u64 addr, u64 val)
 		"%s: reg: 0x%016llx val: 0x%016llx\n", __func__, addr, val);
 }
 
+extern struct workqueue_struct *octep_wq;
+
 int octep_device_setup(struct octep_device *oct);
 int octep_setup_iqs(struct octep_device *oct);
 void octep_free_iqs(struct octep_device *oct);
-- 
2.17.1

