Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C503C244C6F
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 18:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgHNQGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 12:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728117AbgHNQGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 12:06:35 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7B3C061385;
        Fri, 14 Aug 2020 09:06:35 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id v5so2218475plo.4;
        Fri, 14 Aug 2020 09:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lf0C3hbRMqaDB5wVArQhiKT9vS1FzLot+BV74UsBFQ8=;
        b=bv7MdteIxnqlwaT5NWfHPvEvLe3+YJTmn2tCFecDnpvq7O2DFCPY/NiSWe4uf8LMTB
         UhVeNcoX8Jp0VqDhK7u9HbHkuC+aI07yyqZz0CRpw8UbUnoNea0CVX0UVbsuWQ6zTl4U
         1YV2bTmMib1fu2nsQdrzG9rNGc5F2/7a8QLWkt6eGsBdBvKpQl6uaW0bUtGhmoLGQWRQ
         EnHApRjDuzlzn11ikqe8lO/WQG1G2x8BSOSuoLFQdVfjWuipsErz0DuCfxcUbyGu4eWL
         oqCAxVEj02ULhqkNOvh7HkE7haO0QbugcWeRcDrI5UhBF38ZWn/usNxQf2yrCF4JMYJa
         kXPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lf0C3hbRMqaDB5wVArQhiKT9vS1FzLot+BV74UsBFQ8=;
        b=nU0lISVOxPovOFroLYu0weOyNti3E0Y/npI4CBBBPSr6CwJLWz6VKII3AkLr+pkr0b
         JveXgLLi1afDiDsrR8BySMfSO/RhlerAMmJHj1kTjkiFmN3+h2GZFNSQF9A1r/BWCl6q
         D0bCabUuwwIP2/19CDZF5cQGRJjNf/8c8H5szFUf0QEQ77JkIwkDkEAkHbKoJIY9htdM
         YSzohjvjJF3oFJppZWm9LJPgXbesksxQ1vRvDIsN+XFkaCC4BZZ/TXkEO1l7TubMR7c0
         /OvcWRn3dzeGs/KINdM30zrKbsmc+r1xAuEjBRRacxPfPXYGJoWYpxg9oaSY2DGcOsrp
         jQMg==
X-Gm-Message-State: AOAM533FkGuZv40EkNdM91R/nm6yC7WW6i4TxEYZFjtf/BSmR7Q5KVLy
        9ew1E9tSBdtdhAmdLuHQtFD71rT5IbtdWOuc+9g=
X-Google-Smtp-Source: ABdhPJw3TNvXSJER+cHpMvRVFBhDwG4cZqekj1vwnhXEMHtlQ5Vyrwi2W4n4cI/EHtKo0w7JemARgw==
X-Received: by 2002:a17:90a:f68a:: with SMTP id cl10mr2844611pjb.40.1597421193510;
        Fri, 14 Aug 2020 09:06:33 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id h18sm9770875pfo.21.2020.08.14.09.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 09:06:33 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 3/3] staging: qlge: clean up code that dump info to dmesg
Date:   Sat, 15 Aug 2020 00:06:01 +0800
Message-Id: <20200814160601.901682-4-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200814160601.901682-1-coiby.xu@gmail.com>
References: <20200814160601.901682-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The related code are not necessary because,
- Device status and general registers can be obtained by ethtool.
- Coredump can be done via devlink health reporter.
- Structure related to the hardware (struct ql_adapter) can be obtained
  by crash or drgn.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge.h         |  82 ----
 drivers/staging/qlge/qlge_dbg.c     | 672 ----------------------------
 drivers/staging/qlge/qlge_ethtool.c |   1 -
 drivers/staging/qlge/qlge_main.c    |   6 -
 4 files changed, 761 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 055ded6dab60..8ed81ae0f9d8 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2288,86 +2288,4 @@ void ql_check_lb_frame(struct ql_adapter *, struct sk_buff *);
 int ql_own_firmware(struct ql_adapter *qdev);
 int ql_clean_lb_rx_ring(struct rx_ring *rx_ring, int budget);

-/* #define QL_ALL_DUMP */
-/* #define QL_REG_DUMP */
-/* #define QL_DEV_DUMP */
-/* #define QL_CB_DUMP */
-/* #define QL_IB_DUMP */
-/* #define QL_OB_DUMP */
-
-#ifdef QL_REG_DUMP
-void ql_dump_xgmac_control_regs(struct ql_adapter *qdev);
-void ql_dump_routing_entries(struct ql_adapter *qdev);
-void ql_dump_regs(struct ql_adapter *qdev);
-#define QL_DUMP_REGS(qdev) ql_dump_regs(qdev)
-#define QL_DUMP_ROUTE(qdev) ql_dump_routing_entries(qdev)
-#define QL_DUMP_XGMAC_CONTROL_REGS(qdev) ql_dump_xgmac_control_regs(qdev)
-#else
-#define QL_DUMP_REGS(qdev)
-#define QL_DUMP_ROUTE(qdev)
-#define QL_DUMP_XGMAC_CONTROL_REGS(qdev)
-#endif
-
-#ifdef QL_STAT_DUMP
-void ql_dump_stat(struct ql_adapter *qdev);
-#define QL_DUMP_STAT(qdev) ql_dump_stat(qdev)
-#else
-#define QL_DUMP_STAT(qdev)
-#endif
-
-#ifdef QL_DEV_DUMP
-void ql_dump_qdev(struct ql_adapter *qdev);
-#define QL_DUMP_QDEV(qdev) ql_dump_qdev(qdev)
-#else
-#define QL_DUMP_QDEV(qdev)
-#endif
-
-#ifdef QL_CB_DUMP
-void ql_dump_wqicb(struct wqicb *wqicb);
-void ql_dump_tx_ring(struct tx_ring *tx_ring);
-void ql_dump_ricb(struct ricb *ricb);
-void ql_dump_cqicb(struct cqicb *cqicb);
-void ql_dump_rx_ring(struct rx_ring *rx_ring);
-void ql_dump_hw_cb(struct ql_adapter *qdev, int size, u32 bit, u16 q_id);
-#define QL_DUMP_RICB(ricb) ql_dump_ricb(ricb)
-#define QL_DUMP_WQICB(wqicb) ql_dump_wqicb(wqicb)
-#define QL_DUMP_TX_RING(tx_ring) ql_dump_tx_ring(tx_ring)
-#define QL_DUMP_CQICB(cqicb) ql_dump_cqicb(cqicb)
-#define QL_DUMP_RX_RING(rx_ring) ql_dump_rx_ring(rx_ring)
-#define QL_DUMP_HW_CB(qdev, size, bit, q_id) \
-		ql_dump_hw_cb(qdev, size, bit, q_id)
-#else
-#define QL_DUMP_RICB(ricb)
-#define QL_DUMP_WQICB(wqicb)
-#define QL_DUMP_TX_RING(tx_ring)
-#define QL_DUMP_CQICB(cqicb)
-#define QL_DUMP_RX_RING(rx_ring)
-#define QL_DUMP_HW_CB(qdev, size, bit, q_id)
-#endif
-
-#ifdef QL_OB_DUMP
-void ql_dump_tx_desc(struct tx_buf_desc *tbd);
-void ql_dump_ob_mac_iocb(struct ob_mac_iocb_req *ob_mac_iocb);
-void ql_dump_ob_mac_rsp(struct ob_mac_iocb_rsp *ob_mac_rsp);
-#define QL_DUMP_OB_MAC_IOCB(ob_mac_iocb) ql_dump_ob_mac_iocb(ob_mac_iocb)
-#define QL_DUMP_OB_MAC_RSP(ob_mac_rsp) ql_dump_ob_mac_rsp(ob_mac_rsp)
-#else
-#define QL_DUMP_OB_MAC_IOCB(ob_mac_iocb)
-#define QL_DUMP_OB_MAC_RSP(ob_mac_rsp)
-#endif
-
-#ifdef QL_IB_DUMP
-void ql_dump_ib_mac_rsp(struct ib_mac_iocb_rsp *ib_mac_rsp);
-#define QL_DUMP_IB_MAC_RSP(ib_mac_rsp) ql_dump_ib_mac_rsp(ib_mac_rsp)
-#else
-#define QL_DUMP_IB_MAC_RSP(ib_mac_rsp)
-#endif
-
-#ifdef	QL_ALL_DUMP
-void ql_dump_all(struct ql_adapter *qdev);
-#define QL_DUMP_ALL(qdev) ql_dump_all(qdev)
-#else
-#define QL_DUMP_ALL(qdev)
-#endif
-
 #endif /* _QLGE_H_ */
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 058889687907..368394123d16 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1326,675 +1326,3 @@ void ql_mpi_core_to_log(struct work_struct *work)
 		       sizeof(*qdev->mpi_coredump), false);
 }

-#ifdef QL_REG_DUMP
-static void ql_dump_intr_states(struct ql_adapter *qdev)
-{
-	int i;
-	u32 value;
-
-	for (i = 0; i < qdev->intr_count; i++) {
-		ql_write32(qdev, INTR_EN, qdev->intr_context[i].intr_read_mask);
-		value = ql_read32(qdev, INTR_EN);
-		pr_err("%s: Interrupt %d is %s\n",
-		       qdev->ndev->name, i,
-		       (value & INTR_EN_EN ? "enabled" : "disabled"));
-	}
-}
-
-#define DUMP_XGMAC(qdev, reg)					\
-do {								\
-	u32 data;						\
-	ql_read_xgmac_reg(qdev, reg, &data);			\
-	pr_err("%s: %s = 0x%.08x\n", qdev->ndev->name, #reg, data); \
-} while (0)
-
-void ql_dump_xgmac_control_regs(struct ql_adapter *qdev)
-{
-	if (ql_sem_spinlock(qdev, qdev->xg_sem_mask)) {
-		pr_err("%s: Couldn't get xgmac sem\n", __func__);
-		return;
-	}
-	DUMP_XGMAC(qdev, PAUSE_SRC_LO);
-	DUMP_XGMAC(qdev, PAUSE_SRC_HI);
-	DUMP_XGMAC(qdev, GLOBAL_CFG);
-	DUMP_XGMAC(qdev, TX_CFG);
-	DUMP_XGMAC(qdev, RX_CFG);
-	DUMP_XGMAC(qdev, FLOW_CTL);
-	DUMP_XGMAC(qdev, PAUSE_OPCODE);
-	DUMP_XGMAC(qdev, PAUSE_TIMER);
-	DUMP_XGMAC(qdev, PAUSE_FRM_DEST_LO);
-	DUMP_XGMAC(qdev, PAUSE_FRM_DEST_HI);
-	DUMP_XGMAC(qdev, MAC_TX_PARAMS);
-	DUMP_XGMAC(qdev, MAC_RX_PARAMS);
-	DUMP_XGMAC(qdev, MAC_SYS_INT);
-	DUMP_XGMAC(qdev, MAC_SYS_INT_MASK);
-	DUMP_XGMAC(qdev, MAC_MGMT_INT);
-	DUMP_XGMAC(qdev, MAC_MGMT_IN_MASK);
-	DUMP_XGMAC(qdev, EXT_ARB_MODE);
-	ql_sem_unlock(qdev, qdev->xg_sem_mask);
-}
-
-static void ql_dump_ets_regs(struct ql_adapter *qdev)
-{
-}
-
-static void ql_dump_cam_entries(struct ql_adapter *qdev)
-{
-	int i;
-	u32 value[3];
-
-	i = ql_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
-	if (i)
-		return;
-	for (i = 0; i < 4; i++) {
-		if (ql_get_mac_addr_reg(qdev, MAC_ADDR_TYPE_CAM_MAC, i, value)) {
-			pr_err("%s: Failed read of mac index register\n",
-			       __func__);
-			return;
-		} else {
-			if (value[0])
-				pr_err("%s: CAM index %d CAM Lookup Lower = 0x%.08x:%.08x, Output = 0x%.08x\n",
-				       qdev->ndev->name, i, value[1], value[0],
-				       value[2]);
-		}
-	}
-	for (i = 0; i < 32; i++) {
-		if (ql_get_mac_addr_reg
-		    (qdev, MAC_ADDR_TYPE_MULTI_MAC, i, value)) {
-			pr_err("%s: Failed read of mac index register\n",
-			       __func__);
-			return;
-		} else {
-			if (value[0])
-				pr_err("%s: MCAST index %d CAM Lookup Lower = 0x%.08x:%.08x\n",
-				       qdev->ndev->name, i, value[1], value[0]);
-		}
-	}
-	ql_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
-}
-
-void ql_dump_routing_entries(struct ql_adapter *qdev)
-{
-	int i;
-	u32 value;
-
-	i = ql_sem_spinlock(qdev, SEM_RT_IDX_MASK);
-	if (i)
-		return;
-	for (i = 0; i < 16; i++) {
-		value = 0;
-		if (ql_get_routing_reg(qdev, i, &value)) {
-			pr_err("%s: Failed read of routing index register\n",
-			       __func__);
-			return;
-		} else {
-			if (value)
-				pr_err("%s: Routing Mask %d = 0x%.08x\n",
-				       qdev->ndev->name, i, value);
-		}
-	}
-	ql_sem_unlock(qdev, SEM_RT_IDX_MASK);
-}
-
-#define DUMP_REG(qdev, reg)			\
-	pr_err("%-32s= 0x%x\n", #reg, ql_read32(qdev, reg))
-
-void ql_dump_regs(struct ql_adapter *qdev)
-{
-	pr_err("reg dump for function #%d\n", qdev->func);
-	DUMP_REG(qdev, SYS);
-	DUMP_REG(qdev, RST_FO);
-	DUMP_REG(qdev, FSC);
-	DUMP_REG(qdev, CSR);
-	DUMP_REG(qdev, ICB_RID);
-	DUMP_REG(qdev, ICB_L);
-	DUMP_REG(qdev, ICB_H);
-	DUMP_REG(qdev, CFG);
-	DUMP_REG(qdev, BIOS_ADDR);
-	DUMP_REG(qdev, STS);
-	DUMP_REG(qdev, INTR_EN);
-	DUMP_REG(qdev, INTR_MASK);
-	DUMP_REG(qdev, ISR1);
-	DUMP_REG(qdev, ISR2);
-	DUMP_REG(qdev, ISR3);
-	DUMP_REG(qdev, ISR4);
-	DUMP_REG(qdev, REV_ID);
-	DUMP_REG(qdev, FRC_ECC_ERR);
-	DUMP_REG(qdev, ERR_STS);
-	DUMP_REG(qdev, RAM_DBG_ADDR);
-	DUMP_REG(qdev, RAM_DBG_DATA);
-	DUMP_REG(qdev, ECC_ERR_CNT);
-	DUMP_REG(qdev, SEM);
-	DUMP_REG(qdev, GPIO_1);
-	DUMP_REG(qdev, GPIO_2);
-	DUMP_REG(qdev, GPIO_3);
-	DUMP_REG(qdev, XGMAC_ADDR);
-	DUMP_REG(qdev, XGMAC_DATA);
-	DUMP_REG(qdev, NIC_ETS);
-	DUMP_REG(qdev, CNA_ETS);
-	DUMP_REG(qdev, FLASH_ADDR);
-	DUMP_REG(qdev, FLASH_DATA);
-	DUMP_REG(qdev, CQ_STOP);
-	DUMP_REG(qdev, PAGE_TBL_RID);
-	DUMP_REG(qdev, WQ_PAGE_TBL_LO);
-	DUMP_REG(qdev, WQ_PAGE_TBL_HI);
-	DUMP_REG(qdev, CQ_PAGE_TBL_LO);
-	DUMP_REG(qdev, CQ_PAGE_TBL_HI);
-	DUMP_REG(qdev, COS_DFLT_CQ1);
-	DUMP_REG(qdev, COS_DFLT_CQ2);
-	DUMP_REG(qdev, SPLT_HDR);
-	DUMP_REG(qdev, FC_PAUSE_THRES);
-	DUMP_REG(qdev, NIC_PAUSE_THRES);
-	DUMP_REG(qdev, FC_ETHERTYPE);
-	DUMP_REG(qdev, FC_RCV_CFG);
-	DUMP_REG(qdev, NIC_RCV_CFG);
-	DUMP_REG(qdev, FC_COS_TAGS);
-	DUMP_REG(qdev, NIC_COS_TAGS);
-	DUMP_REG(qdev, MGMT_RCV_CFG);
-	DUMP_REG(qdev, XG_SERDES_ADDR);
-	DUMP_REG(qdev, XG_SERDES_DATA);
-	DUMP_REG(qdev, PRB_MX_ADDR);
-	DUMP_REG(qdev, PRB_MX_DATA);
-	ql_dump_intr_states(qdev);
-	ql_dump_xgmac_control_regs(qdev);
-	ql_dump_ets_regs(qdev);
-	ql_dump_cam_entries(qdev);
-	ql_dump_routing_entries(qdev);
-}
-#endif
-
-#ifdef QL_STAT_DUMP
-
-#define DUMP_STAT(qdev, stat)	\
-	pr_err("%s = %ld\n", #stat, (unsigned long)(qdev)->nic_stats.stat)
-
-void ql_dump_stat(struct ql_adapter *qdev)
-{
-	pr_err("%s: Enter\n", __func__);
-	DUMP_STAT(qdev, tx_pkts);
-	DUMP_STAT(qdev, tx_bytes);
-	DUMP_STAT(qdev, tx_mcast_pkts);
-	DUMP_STAT(qdev, tx_bcast_pkts);
-	DUMP_STAT(qdev, tx_ucast_pkts);
-	DUMP_STAT(qdev, tx_ctl_pkts);
-	DUMP_STAT(qdev, tx_pause_pkts);
-	DUMP_STAT(qdev, tx_64_pkt);
-	DUMP_STAT(qdev, tx_65_to_127_pkt);
-	DUMP_STAT(qdev, tx_128_to_255_pkt);
-	DUMP_STAT(qdev, tx_256_511_pkt);
-	DUMP_STAT(qdev, tx_512_to_1023_pkt);
-	DUMP_STAT(qdev, tx_1024_to_1518_pkt);
-	DUMP_STAT(qdev, tx_1519_to_max_pkt);
-	DUMP_STAT(qdev, tx_undersize_pkt);
-	DUMP_STAT(qdev, tx_oversize_pkt);
-	DUMP_STAT(qdev, rx_bytes);
-	DUMP_STAT(qdev, rx_bytes_ok);
-	DUMP_STAT(qdev, rx_pkts);
-	DUMP_STAT(qdev, rx_pkts_ok);
-	DUMP_STAT(qdev, rx_bcast_pkts);
-	DUMP_STAT(qdev, rx_mcast_pkts);
-	DUMP_STAT(qdev, rx_ucast_pkts);
-	DUMP_STAT(qdev, rx_undersize_pkts);
-	DUMP_STAT(qdev, rx_oversize_pkts);
-	DUMP_STAT(qdev, rx_jabber_pkts);
-	DUMP_STAT(qdev, rx_undersize_fcerr_pkts);
-	DUMP_STAT(qdev, rx_drop_events);
-	DUMP_STAT(qdev, rx_fcerr_pkts);
-	DUMP_STAT(qdev, rx_align_err);
-	DUMP_STAT(qdev, rx_symbol_err);
-	DUMP_STAT(qdev, rx_mac_err);
-	DUMP_STAT(qdev, rx_ctl_pkts);
-	DUMP_STAT(qdev, rx_pause_pkts);
-	DUMP_STAT(qdev, rx_64_pkts);
-	DUMP_STAT(qdev, rx_65_to_127_pkts);
-	DUMP_STAT(qdev, rx_128_255_pkts);
-	DUMP_STAT(qdev, rx_256_511_pkts);
-	DUMP_STAT(qdev, rx_512_to_1023_pkts);
-	DUMP_STAT(qdev, rx_1024_to_1518_pkts);
-	DUMP_STAT(qdev, rx_1519_to_max_pkts);
-	DUMP_STAT(qdev, rx_len_err_pkts);
-};
-#endif
-
-#ifdef QL_DEV_DUMP
-
-#define DUMP_QDEV_FIELD(qdev, type, field)		\
-	pr_err("qdev->%-24s = " type "\n", #field, (qdev)->field)
-#define DUMP_QDEV_DMA_FIELD(qdev, field)		\
-	pr_err("qdev->%-24s = %llx\n", #field, (unsigned long long)qdev->field)
-#define DUMP_QDEV_ARRAY(qdev, type, array, index, field) \
-	pr_err("%s[%d].%s = " type "\n",		 \
-	       #array, index, #field, (qdev)->array[index].field)
-void ql_dump_qdev(struct ql_adapter *qdev)
-{
-	int i;
-
-	DUMP_QDEV_FIELD(qdev, "%lx", flags);
-	DUMP_QDEV_FIELD(qdev, "%p", pdev);
-	DUMP_QDEV_FIELD(qdev, "%p", ndev);
-	DUMP_QDEV_FIELD(qdev, "%d", chip_rev_id);
-	DUMP_QDEV_FIELD(qdev, "%p", reg_base);
-	DUMP_QDEV_FIELD(qdev, "%p", doorbell_area);
-	DUMP_QDEV_FIELD(qdev, "%d", doorbell_area_size);
-	DUMP_QDEV_FIELD(qdev, "%x", msg_enable);
-	DUMP_QDEV_FIELD(qdev, "%p", rx_ring_shadow_reg_area);
-	DUMP_QDEV_DMA_FIELD(qdev, rx_ring_shadow_reg_dma);
-	DUMP_QDEV_FIELD(qdev, "%p", tx_ring_shadow_reg_area);
-	DUMP_QDEV_DMA_FIELD(qdev, tx_ring_shadow_reg_dma);
-	DUMP_QDEV_FIELD(qdev, "%d", intr_count);
-	if (qdev->msi_x_entry)
-		for (i = 0; i < qdev->intr_count; i++) {
-			DUMP_QDEV_ARRAY(qdev, "%d", msi_x_entry, i, vector);
-			DUMP_QDEV_ARRAY(qdev, "%d", msi_x_entry, i, entry);
-		}
-	for (i = 0; i < qdev->intr_count; i++) {
-		DUMP_QDEV_ARRAY(qdev, "%p", intr_context, i, qdev);
-		DUMP_QDEV_ARRAY(qdev, "%d", intr_context, i, intr);
-		DUMP_QDEV_ARRAY(qdev, "%d", intr_context, i, hooked);
-		DUMP_QDEV_ARRAY(qdev, "0x%08x", intr_context, i, intr_en_mask);
-		DUMP_QDEV_ARRAY(qdev, "0x%08x", intr_context, i, intr_dis_mask);
-		DUMP_QDEV_ARRAY(qdev, "0x%08x", intr_context, i, intr_read_mask);
-	}
-	DUMP_QDEV_FIELD(qdev, "%d", tx_ring_count);
-	DUMP_QDEV_FIELD(qdev, "%d", rx_ring_count);
-	DUMP_QDEV_FIELD(qdev, "%d", ring_mem_size);
-	DUMP_QDEV_FIELD(qdev, "%p", ring_mem);
-	DUMP_QDEV_FIELD(qdev, "%d", intr_count);
-	DUMP_QDEV_FIELD(qdev, "%p", tx_ring);
-	DUMP_QDEV_FIELD(qdev, "%d", rss_ring_count);
-	DUMP_QDEV_FIELD(qdev, "%p", rx_ring);
-	DUMP_QDEV_FIELD(qdev, "%d", default_rx_queue);
-	DUMP_QDEV_FIELD(qdev, "0x%08x", xg_sem_mask);
-	DUMP_QDEV_FIELD(qdev, "0x%08x", port_link_up);
-	DUMP_QDEV_FIELD(qdev, "0x%08x", port_init);
-	DUMP_QDEV_FIELD(qdev, "%u", lbq_buf_size);
-}
-#endif
-
-#ifdef QL_CB_DUMP
-void ql_dump_wqicb(struct wqicb *wqicb)
-{
-	pr_err("Dumping wqicb stuff...\n");
-	pr_err("wqicb->len = 0x%x\n", le16_to_cpu(wqicb->len));
-	pr_err("wqicb->flags = %x\n", le16_to_cpu(wqicb->flags));
-	pr_err("wqicb->cq_id_rss = %d\n",
-	       le16_to_cpu(wqicb->cq_id_rss));
-	pr_err("wqicb->rid = 0x%x\n", le16_to_cpu(wqicb->rid));
-	pr_err("wqicb->wq_addr = 0x%llx\n",
-	       (unsigned long long)le64_to_cpu(wqicb->addr));
-	pr_err("wqicb->wq_cnsmr_idx_addr = 0x%llx\n",
-	       (unsigned long long)le64_to_cpu(wqicb->cnsmr_idx_addr));
-}
-
-void ql_dump_tx_ring(struct tx_ring *tx_ring)
-{
-	if (!tx_ring)
-		return;
-	pr_err("===================== Dumping tx_ring %d ===============\n",
-	       tx_ring->wq_id);
-	pr_err("tx_ring->base = %p\n", tx_ring->wq_base);
-	pr_err("tx_ring->base_dma = 0x%llx\n",
-	       (unsigned long long)tx_ring->wq_base_dma);
-	pr_err("tx_ring->cnsmr_idx_sh_reg, addr = 0x%p, value = %d\n",
-	       tx_ring->cnsmr_idx_sh_reg,
-	       tx_ring->cnsmr_idx_sh_reg
-			? ql_read_sh_reg(tx_ring->cnsmr_idx_sh_reg) : 0);
-	pr_err("tx_ring->size = %d\n", tx_ring->wq_size);
-	pr_err("tx_ring->len = %d\n", tx_ring->wq_len);
-	pr_err("tx_ring->prod_idx_db_reg = %p\n", tx_ring->prod_idx_db_reg);
-	pr_err("tx_ring->valid_db_reg = %p\n", tx_ring->valid_db_reg);
-	pr_err("tx_ring->prod_idx = %d\n", tx_ring->prod_idx);
-	pr_err("tx_ring->cq_id = %d\n", tx_ring->cq_id);
-	pr_err("tx_ring->wq_id = %d\n", tx_ring->wq_id);
-	pr_err("tx_ring->q = %p\n", tx_ring->q);
-	pr_err("tx_ring->tx_count = %d\n", atomic_read(&tx_ring->tx_count));
-}
-
-void ql_dump_ricb(struct ricb *ricb)
-{
-	int i;
-
-	pr_err("===================== Dumping ricb ===============\n");
-	pr_err("Dumping ricb stuff...\n");
-
-	pr_err("ricb->base_cq = %d\n", ricb->base_cq & 0x1f);
-	pr_err("ricb->flags = %s%s%s%s%s%s%s%s%s\n",
-	       ricb->base_cq & RSS_L4K ? "RSS_L4K " : "",
-	       ricb->flags & RSS_L6K ? "RSS_L6K " : "",
-	       ricb->flags & RSS_LI ? "RSS_LI " : "",
-	       ricb->flags & RSS_LB ? "RSS_LB " : "",
-	       ricb->flags & RSS_LM ? "RSS_LM " : "",
-	       ricb->flags & RSS_RI4 ? "RSS_RI4 " : "",
-	       ricb->flags & RSS_RT4 ? "RSS_RT4 " : "",
-	       ricb->flags & RSS_RI6 ? "RSS_RI6 " : "",
-	       ricb->flags & RSS_RT6 ? "RSS_RT6 " : "");
-	pr_err("ricb->mask = 0x%.04x\n", le16_to_cpu(ricb->mask));
-	for (i = 0; i < 16; i++)
-		pr_err("ricb->hash_cq_id[%d] = 0x%.08x\n", i,
-		       le32_to_cpu(ricb->hash_cq_id[i]));
-	for (i = 0; i < 10; i++)
-		pr_err("ricb->ipv6_hash_key[%d] = 0x%.08x\n", i,
-		       le32_to_cpu(ricb->ipv6_hash_key[i]));
-	for (i = 0; i < 4; i++)
-		pr_err("ricb->ipv4_hash_key[%d] = 0x%.08x\n", i,
-		       le32_to_cpu(ricb->ipv4_hash_key[i]));
-}
-
-void ql_dump_cqicb(struct cqicb *cqicb)
-{
-	pr_err("Dumping cqicb stuff...\n");
-
-	pr_err("cqicb->msix_vect = %d\n", cqicb->msix_vect);
-	pr_err("cqicb->flags = %x\n", cqicb->flags);
-	pr_err("cqicb->len = %d\n", le16_to_cpu(cqicb->len));
-	pr_err("cqicb->addr = 0x%llx\n",
-	       (unsigned long long)le64_to_cpu(cqicb->addr));
-	pr_err("cqicb->prod_idx_addr = 0x%llx\n",
-	       (unsigned long long)le64_to_cpu(cqicb->prod_idx_addr));
-	pr_err("cqicb->pkt_delay = 0x%.04x\n",
-	       le16_to_cpu(cqicb->pkt_delay));
-	pr_err("cqicb->irq_delay = 0x%.04x\n",
-	       le16_to_cpu(cqicb->irq_delay));
-	pr_err("cqicb->lbq_addr = 0x%llx\n",
-	       (unsigned long long)le64_to_cpu(cqicb->lbq_addr));
-	pr_err("cqicb->lbq_buf_size = 0x%.04x\n",
-	       le16_to_cpu(cqicb->lbq_buf_size));
-	pr_err("cqicb->lbq_len = 0x%.04x\n",
-	       le16_to_cpu(cqicb->lbq_len));
-	pr_err("cqicb->sbq_addr = 0x%llx\n",
-	       (unsigned long long)le64_to_cpu(cqicb->sbq_addr));
-	pr_err("cqicb->sbq_buf_size = 0x%.04x\n",
-	       le16_to_cpu(cqicb->sbq_buf_size));
-	pr_err("cqicb->sbq_len = 0x%.04x\n",
-	       le16_to_cpu(cqicb->sbq_len));
-}
-
-static const char *qlge_rx_ring_type_name(struct rx_ring *rx_ring)
-{
-	struct ql_adapter *qdev = rx_ring->qdev;
-
-	if (rx_ring->cq_id < qdev->rss_ring_count)
-		return "RX COMPLETION";
-	else
-		return "TX COMPLETION";
-};
-
-void ql_dump_rx_ring(struct rx_ring *rx_ring)
-{
-	if (!rx_ring)
-		return;
-	pr_err("===================== Dumping rx_ring %d ===============\n",
-	       rx_ring->cq_id);
-	pr_err("Dumping rx_ring %d, type = %s\n", rx_ring->cq_id,
-	       qlge_rx_ring_type_name(rx_ring));
-	pr_err("rx_ring->cqicb = %p\n", &rx_ring->cqicb);
-	pr_err("rx_ring->cq_base = %p\n", rx_ring->cq_base);
-	pr_err("rx_ring->cq_base_dma = %llx\n",
-	       (unsigned long long)rx_ring->cq_base_dma);
-	pr_err("rx_ring->cq_size = %d\n", rx_ring->cq_size);
-	pr_err("rx_ring->cq_len = %d\n", rx_ring->cq_len);
-	pr_err("rx_ring->prod_idx_sh_reg, addr = 0x%p, value = %d\n",
-	       rx_ring->prod_idx_sh_reg,
-	       rx_ring->prod_idx_sh_reg
-			? ql_read_sh_reg(rx_ring->prod_idx_sh_reg) : 0);
-	pr_err("rx_ring->prod_idx_sh_reg_dma = %llx\n",
-	       (unsigned long long)rx_ring->prod_idx_sh_reg_dma);
-	pr_err("rx_ring->cnsmr_idx_db_reg = %p\n",
-	       rx_ring->cnsmr_idx_db_reg);
-	pr_err("rx_ring->cnsmr_idx = %d\n", rx_ring->cnsmr_idx);
-	pr_err("rx_ring->curr_entry = %p\n", rx_ring->curr_entry);
-	pr_err("rx_ring->valid_db_reg = %p\n", rx_ring->valid_db_reg);
-
-	pr_err("rx_ring->lbq.base = %p\n", rx_ring->lbq.base);
-	pr_err("rx_ring->lbq.base_dma = %llx\n",
-	       (unsigned long long)rx_ring->lbq.base_dma);
-	pr_err("rx_ring->lbq.base_indirect = %p\n",
-	       rx_ring->lbq.base_indirect);
-	pr_err("rx_ring->lbq.base_indirect_dma = %llx\n",
-	       (unsigned long long)rx_ring->lbq.base_indirect_dma);
-	pr_err("rx_ring->lbq = %p\n", rx_ring->lbq.queue);
-	pr_err("rx_ring->lbq.prod_idx_db_reg = %p\n",
-	       rx_ring->lbq.prod_idx_db_reg);
-	pr_err("rx_ring->lbq.next_to_use = %d\n", rx_ring->lbq.next_to_use);
-	pr_err("rx_ring->lbq.next_to_clean = %d\n", rx_ring->lbq.next_to_clean);
-
-	pr_err("rx_ring->sbq.base = %p\n", rx_ring->sbq.base);
-	pr_err("rx_ring->sbq.base_dma = %llx\n",
-	       (unsigned long long)rx_ring->sbq.base_dma);
-	pr_err("rx_ring->sbq.base_indirect = %p\n",
-	       rx_ring->sbq.base_indirect);
-	pr_err("rx_ring->sbq.base_indirect_dma = %llx\n",
-	       (unsigned long long)rx_ring->sbq.base_indirect_dma);
-	pr_err("rx_ring->sbq = %p\n", rx_ring->sbq.queue);
-	pr_err("rx_ring->sbq.prod_idx_db_reg addr = %p\n",
-	       rx_ring->sbq.prod_idx_db_reg);
-	pr_err("rx_ring->sbq.next_to_use = %d\n", rx_ring->sbq.next_to_use);
-	pr_err("rx_ring->sbq.next_to_clean = %d\n", rx_ring->sbq.next_to_clean);
-	pr_err("rx_ring->cq_id = %d\n", rx_ring->cq_id);
-	pr_err("rx_ring->irq = %d\n", rx_ring->irq);
-	pr_err("rx_ring->cpu = %d\n", rx_ring->cpu);
-	pr_err("rx_ring->qdev = %p\n", rx_ring->qdev);
-}
-
-void ql_dump_hw_cb(struct ql_adapter *qdev, int size, u32 bit, u16 q_id)
-{
-	void *ptr;
-
-	pr_err("%s: Enter\n", __func__);
-
-	ptr = kmalloc(size, GFP_ATOMIC);
-	if (!ptr)
-		return;
-
-	if (ql_write_cfg(qdev, ptr, size, bit, q_id)) {
-		pr_err("%s: Failed to upload control block!\n", __func__);
-		goto fail_it;
-	}
-	switch (bit) {
-	case CFG_DRQ:
-		ql_dump_wqicb((struct wqicb *)ptr);
-		break;
-	case CFG_DCQ:
-		ql_dump_cqicb((struct cqicb *)ptr);
-		break;
-	case CFG_DR:
-		ql_dump_ricb((struct ricb *)ptr);
-		break;
-	default:
-		pr_err("%s: Invalid bit value = %x\n", __func__, bit);
-		break;
-	}
-fail_it:
-	kfree(ptr);
-}
-#endif
-
-#ifdef QL_OB_DUMP
-void ql_dump_tx_desc(struct tx_buf_desc *tbd)
-{
-	pr_err("tbd->addr  = 0x%llx\n",
-	       le64_to_cpu((u64) tbd->addr));
-	pr_err("tbd->len   = %d\n",
-	       le32_to_cpu(tbd->len & TX_DESC_LEN_MASK));
-	pr_err("tbd->flags = %s %s\n",
-	       tbd->len & TX_DESC_C ? "C" : ".",
-	       tbd->len & TX_DESC_E ? "E" : ".");
-	tbd++;
-	pr_err("tbd->addr  = 0x%llx\n",
-	       le64_to_cpu((u64) tbd->addr));
-	pr_err("tbd->len   = %d\n",
-	       le32_to_cpu(tbd->len & TX_DESC_LEN_MASK));
-	pr_err("tbd->flags = %s %s\n",
-	       tbd->len & TX_DESC_C ? "C" : ".",
-	       tbd->len & TX_DESC_E ? "E" : ".");
-	tbd++;
-	pr_err("tbd->addr  = 0x%llx\n",
-	       le64_to_cpu((u64) tbd->addr));
-	pr_err("tbd->len   = %d\n",
-	       le32_to_cpu(tbd->len & TX_DESC_LEN_MASK));
-	pr_err("tbd->flags = %s %s\n",
-	       tbd->len & TX_DESC_C ? "C" : ".",
-	       tbd->len & TX_DESC_E ? "E" : ".");
-}
-
-void ql_dump_ob_mac_iocb(struct ob_mac_iocb_req *ob_mac_iocb)
-{
-	struct ob_mac_tso_iocb_req *ob_mac_tso_iocb =
-	    (struct ob_mac_tso_iocb_req *)ob_mac_iocb;
-	struct tx_buf_desc *tbd;
-	u16 frame_len;
-
-	pr_err("%s\n", __func__);
-	pr_err("opcode         = %s\n",
-	       (ob_mac_iocb->opcode == OPCODE_OB_MAC_IOCB) ? "MAC" : "TSO");
-	pr_err("flags1          = %s %s %s %s %s\n",
-	       ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_OI ? "OI" : "",
-	       ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_I ? "I" : "",
-	       ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_D ? "D" : "",
-	       ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_IP4 ? "IP4" : "",
-	       ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_IP6 ? "IP6" : "");
-	pr_err("flags2          = %s %s %s\n",
-	       ob_mac_tso_iocb->flags2 & OB_MAC_TSO_IOCB_LSO ? "LSO" : "",
-	       ob_mac_tso_iocb->flags2 & OB_MAC_TSO_IOCB_UC ? "UC" : "",
-	       ob_mac_tso_iocb->flags2 & OB_MAC_TSO_IOCB_TC ? "TC" : "");
-	pr_err("flags3          = %s %s %s\n",
-	       ob_mac_tso_iocb->flags3 & OB_MAC_TSO_IOCB_IC ? "IC" : "",
-	       ob_mac_tso_iocb->flags3 & OB_MAC_TSO_IOCB_DFP ? "DFP" : "",
-	       ob_mac_tso_iocb->flags3 & OB_MAC_TSO_IOCB_V ? "V" : "");
-	pr_err("tid = %x\n", ob_mac_iocb->tid);
-	pr_err("txq_idx = %d\n", ob_mac_iocb->txq_idx);
-	pr_err("vlan_tci      = %x\n", ob_mac_tso_iocb->vlan_tci);
-	if (ob_mac_iocb->opcode == OPCODE_OB_MAC_TSO_IOCB) {
-		pr_err("frame_len      = %d\n",
-		       le32_to_cpu(ob_mac_tso_iocb->frame_len));
-		pr_err("mss      = %d\n",
-		       le16_to_cpu(ob_mac_tso_iocb->mss));
-		pr_err("prot_hdr_len   = %d\n",
-		       le16_to_cpu(ob_mac_tso_iocb->total_hdrs_len));
-		pr_err("hdr_offset     = 0x%.04x\n",
-		       le16_to_cpu(ob_mac_tso_iocb->net_trans_offset));
-		frame_len = le32_to_cpu(ob_mac_tso_iocb->frame_len);
-	} else {
-		pr_err("frame_len      = %d\n",
-		       le16_to_cpu(ob_mac_iocb->frame_len));
-		frame_len = le16_to_cpu(ob_mac_iocb->frame_len);
-	}
-	tbd = &ob_mac_iocb->tbd[0];
-	ql_dump_tx_desc(tbd);
-}
-
-void ql_dump_ob_mac_rsp(struct ob_mac_iocb_rsp *ob_mac_rsp)
-{
-	pr_err("%s\n", __func__);
-	pr_err("opcode         = %d\n", ob_mac_rsp->opcode);
-	pr_err("flags          = %s %s %s %s %s %s %s\n",
-	       ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_OI ? "OI" : ".",
-	       ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_I ? "I" : ".",
-	       ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_E ? "E" : ".",
-	       ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_S ? "S" : ".",
-	       ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_L ? "L" : ".",
-	       ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_P ? "P" : ".",
-	       ob_mac_rsp->flags2 & OB_MAC_IOCB_RSP_B ? "B" : ".");
-	pr_err("tid = %x\n", ob_mac_rsp->tid);
-}
-#endif
-
-#ifdef QL_IB_DUMP
-void ql_dump_ib_mac_rsp(struct ib_mac_iocb_rsp *ib_mac_rsp)
-{
-	pr_err("%s\n", __func__);
-	pr_err("opcode         = 0x%x\n", ib_mac_rsp->opcode);
-	pr_err("flags1 = %s%s%s%s%s%s\n",
-	       ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_OI ? "OI " : "",
-	       ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_I ? "I " : "",
-	       ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_TE ? "TE " : "",
-	       ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_NU ? "NU " : "",
-	       ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_IE ? "IE " : "",
-	       ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_B ? "B " : "");
-
-	if (ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_M_MASK)
-		pr_err("%s%s%s Multicast\n",
-		       (ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_M_MASK) ==
-		       IB_MAC_IOCB_RSP_M_HASH ? "Hash" : "",
-		       (ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_M_MASK) ==
-		       IB_MAC_IOCB_RSP_M_REG ? "Registered" : "",
-		       (ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_M_MASK) ==
-		       IB_MAC_IOCB_RSP_M_PROM ? "Promiscuous" : "");
-
-	pr_err("flags2 = %s%s%s%s%s\n",
-	       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_P) ? "P " : "",
-	       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_V) ? "V " : "",
-	       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_U) ? "U " : "",
-	       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_T) ? "T " : "",
-	       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_FO) ? "FO " : "");
-
-	if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK)
-		pr_err("%s%s%s%s%s error\n",
-		       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
-		       IB_MAC_IOCB_RSP_ERR_OVERSIZE ? "oversize" : "",
-		       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
-		       IB_MAC_IOCB_RSP_ERR_UNDERSIZE ? "undersize" : "",
-		       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
-		       IB_MAC_IOCB_RSP_ERR_PREAMBLE ? "preamble" : "",
-		       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
-		       IB_MAC_IOCB_RSP_ERR_FRAME_LEN ? "frame length" : "",
-		       (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
-		       IB_MAC_IOCB_RSP_ERR_CRC ? "CRC" : "");
-
-	pr_err("flags3 = %s%s\n",
-	       ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DS ? "DS " : "",
-	       ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL ? "DL " : "");
-
-	if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK)
-		pr_err("RSS flags = %s%s%s%s\n",
-		       ((ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK) ==
-			IB_MAC_IOCB_RSP_M_IPV4) ? "IPv4 RSS" : "",
-		       ((ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK) ==
-			IB_MAC_IOCB_RSP_M_IPV6) ? "IPv6 RSS " : "",
-		       ((ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK) ==
-			IB_MAC_IOCB_RSP_M_TCP_V4) ? "TCP/IPv4 RSS" : "",
-		       ((ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK) ==
-			IB_MAC_IOCB_RSP_M_TCP_V6) ? "TCP/IPv6 RSS" : "");
-
-	pr_err("data_len	= %d\n",
-	       le32_to_cpu(ib_mac_rsp->data_len));
-	pr_err("data_addr    = 0x%llx\n",
-	       (unsigned long long)le64_to_cpu(ib_mac_rsp->data_addr));
-	if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK)
-		pr_err("rss    = %x\n",
-		       le32_to_cpu(ib_mac_rsp->rss));
-	if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_V)
-		pr_err("vlan_id    = %x\n",
-		       le16_to_cpu(ib_mac_rsp->vlan_id));
-
-	pr_err("flags4 = %s%s%s\n",
-	       ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV ? "HV " : "",
-		ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS ? "HS " : "",
-		ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HL ? "HL " : "");
-
-	if (ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV) {
-		pr_err("hdr length	= %d\n",
-		       le32_to_cpu(ib_mac_rsp->hdr_len));
-		pr_err("hdr addr    = 0x%llx\n",
-		       (unsigned long long)le64_to_cpu(ib_mac_rsp->hdr_addr));
-	}
-}
-#endif
-
-#ifdef QL_ALL_DUMP
-void ql_dump_all(struct ql_adapter *qdev)
-{
-	int i;
-
-	QL_DUMP_REGS(qdev);
-	QL_DUMP_QDEV(qdev);
-	for (i = 0; i < qdev->tx_ring_count; i++) {
-		QL_DUMP_TX_RING(&qdev->tx_ring[i]);
-		QL_DUMP_WQICB((struct wqicb *)&qdev->tx_ring[i]);
-	}
-	for (i = 0; i < qdev->rx_ring_count; i++) {
-		QL_DUMP_RX_RING(&qdev->rx_ring[i]);
-		QL_DUMP_CQICB((struct cqicb *)&qdev->rx_ring[i]);
-	}
-}
-#endif
diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index 949abd53a7a9..aa455aca2ab4 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -328,7 +328,6 @@ static void ql_update_stats(struct ql_adapter *qdev)
 quit:
 	spin_unlock(&qdev->stats_lock);

-	QL_DUMP_STAT(qdev);
 }

 static void ql_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index b2be7f4b7dd6..75a313008f20 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -1857,8 +1857,6 @@ static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
 	struct net_device *ndev = qdev->ndev;
 	struct sk_buff *skb = NULL;

-	QL_DUMP_IB_MAC_RSP(ib_mac_rsp);
-
 	skb = ql_build_rx_skb(qdev, rx_ring, ib_mac_rsp);
 	if (unlikely(!skb)) {
 		netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
@@ -1955,8 +1953,6 @@ static unsigned long ql_process_mac_rx_intr(struct ql_adapter *qdev,
 			((le16_to_cpu(ib_mac_rsp->vlan_id) &
 			IB_MAC_IOCB_RSP_VLAN_MASK)) : 0xffff;

-	QL_DUMP_IB_MAC_RSP(ib_mac_rsp);
-
 	if (ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV) {
 		/* The data and headers are split into
 		 * separate buffers.
@@ -2002,7 +1998,6 @@ static void ql_process_mac_tx_intr(struct ql_adapter *qdev,
 	struct tx_ring *tx_ring;
 	struct tx_ring_desc *tx_ring_desc;

-	QL_DUMP_OB_MAC_RSP(mac_rsp);
 	tx_ring = &qdev->tx_ring[mac_rsp->txq_idx];
 	tx_ring_desc = &tx_ring->q[mac_rsp->tid];
 	ql_unmap_send(qdev, tx_ring_desc, tx_ring_desc->map_cnt);
@@ -2594,7 +2589,6 @@ static netdev_tx_t qlge_send(struct sk_buff *skb, struct net_device *ndev)
 		tx_ring->tx_errors++;
 		return NETDEV_TX_BUSY;
 	}
-	QL_DUMP_OB_MAC_IOCB(mac_iocb_ptr);
 	tx_ring->prod_idx++;
 	if (tx_ring->prod_idx == tx_ring->wq_len)
 		tx_ring->prod_idx = 0;
--
2.27.0

