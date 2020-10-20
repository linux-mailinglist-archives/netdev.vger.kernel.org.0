Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943502904C9
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 14:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407219AbgJPMMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 08:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407182AbgJPMMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 08:12:15 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C691C061755;
        Fri, 16 Oct 2020 05:12:15 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id n14so1393166pff.6;
        Fri, 16 Oct 2020 05:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bm9xpGBEhIT+9GP6Ojt5Ze37ljhDc2Et6nor3gbUpuk=;
        b=robVBmPTvFhtBLe7VsWaa08lB5HofMzEOeUDgmwDULX79bHssR9ZDto2LcHmbkagjj
         dQlYn2KqbZ3c85Jbm217Pnu0jsoipDwZyWQA55xFzevW6BGB0nsQAPZXWZUVaDLmYEOA
         iNw8ciFlAWH+BXtlA9KIM8EVOkrRiiXV/qkpcRVnNBVPlAFG/YQLXy+vDHy0tuIbosgd
         Y3/ic0VDxcSz67RwrhZOADs3k9qIHjUzt6QNaxH9Nar2GZkBbHBnTRwQeXs+7q7pw2MT
         8idYkdolaoJCcfGnZseckscqdWjZrlJy8Pr4klEl6t5JDyzqQU7LVVCve/urIYDZxPmT
         B0dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bm9xpGBEhIT+9GP6Ojt5Ze37ljhDc2Et6nor3gbUpuk=;
        b=SSQGDchjz3+PA4HLiylAuVwKkm+3oDUwCGmsBZ/OtHYnSqfCtvAez58BlPPkSF7J8v
         F0F/PaCkBNK1ZQTyJaZKL7Eww+dnVWN8du/pZmwTcyWwAZWzOItr+vFhoJQRVaDl5gx8
         JQrUJu/PNGVxqqEPGtbQCIjAmkh8RX7bC+nBPacitSktLO+tHa0dA61NZOamFxgKdPj0
         DOhnIu1pJUBfWsz1w6xYkCvPTRGEuk9DpPA+3pYh8O6JpTRFleZdY+bkZ9Y14cAJq4mB
         xqQwol0jrOqWZAcyCbeQyoyG2GH/993ii6YdKFtFxSL/R1PYR4zKbiGGqRtXYYCI2AJm
         jipw==
X-Gm-Message-State: AOAM533iaCAMYc/EsLpwuFkP8ZhjyZ51ZgzVtx7hjzzYeX9RMuhUPCen
        pH/kfMKUjIFxk9Ag+FeTCs0=
X-Google-Smtp-Source: ABdhPJxJQJ86wtPs0yD0bSkAL3eXvXBZxXvEuKnava/3zWpsreW7Ca8sCmTFveLoJJ6zbWrSbVp9Ew==
X-Received: by 2002:a63:5352:: with SMTP id t18mr2831464pgl.51.1602850334254;
        Fri, 16 Oct 2020 05:12:14 -0700 (PDT)
Received: from localhost ([160.16.113.140])
        by smtp.gmail.com with ESMTPSA id y22sm2849819pfr.62.2020.10.16.05.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 05:12:13 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 7/8] staging: qlge: clean up debugging code in the QL_ALL_DUMP ifdef land
Date:   Fri, 16 Oct 2020 19:54:06 +0800
Message-Id: <20201016115407.170821-8-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016115407.170821-1-coiby.xu@gmail.com>
References: <20201016115407.170821-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The debugging code in the following ifdef land
 - QL_ALL_DUMP
 - QL_REG_DUMP
 - QL_DEV_DUMP
 - QL_CB_DUMP
 - QL_IB_DUMP
 - QL_OB_DUMP

becomes unnecessary because,
 - Device status and general registers can be obtained by ethtool.
 - Coredump can be done via devlink health reporter.
 - Structure related to the hardware (struct ql_adapter) can be obtained
   by crash or drgn.

Link: https://lkml.org/lkml/2020/6/30/19
Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/TODO           |   4 -
 drivers/staging/qlge/qlge.h         |  82 ----
 drivers/staging/qlge/qlge_dbg.c     | 688 ----------------------------
 drivers/staging/qlge/qlge_ethtool.c |   2 -
 drivers/staging/qlge/qlge_main.c    |   7 +-
 5 files changed, 1 insertion(+), 782 deletions(-)

diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
index e68c95f47754..c76394b9451b 100644
--- a/drivers/staging/qlge/TODO
+++ b/drivers/staging/qlge/TODO
@@ -14,10 +14,6 @@
   queues" is confusing.
 * struct rx_ring is used for rx and tx completions, with some members relevant
   to one case only
-* there is an inordinate amount of disparate debugging code, most of which is
-  of questionable value. In particular, qlge_dbg.c has hundreds of lines of
-  code bitrotting away in ifdef land (doesn't compile since commit
-  18c49b91777c ("qlge: do vlan cleanup", v3.1-rc1), 8 years ago).
 * the flow control implementation in firmware is buggy (sends a flood of pause
   frames, resets the link, device and driver buffer queues become
   desynchronized), disable it by default
diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 8552ca7433f5..9015e2b0b54a 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2289,86 +2289,4 @@ void qlge_check_lb_frame(struct qlge_adapter *qdev, struct sk_buff *skb);
 int qlge_own_firmware(struct qlge_adapter *qdev);
 int qlge_clean_lb_rx_ring(struct rx_ring *rx_ring, int budget);
 
-/* #define QL_ALL_DUMP */
-/* #define QL_REG_DUMP */
-/* #define QL_DEV_DUMP */
-/* #define QL_CB_DUMP */
-/* #define QL_IB_DUMP */
-/* #define QL_OB_DUMP */
-
-#ifdef QL_REG_DUMP
-void qlge_dump_xgmac_control_regs(struct qlge_adapter *qdev);
-void qlge_dump_routing_entries(struct qlge_adapter *qdev);
-void qlge_dump_regs(struct qlge_adapter *qdev);
-#define QL_DUMP_REGS(qdev) qlge_dump_regs(qdev)
-#define QL_DUMP_ROUTE(qdev) qlge_dump_routing_entries(qdev)
-#define QL_DUMP_XGMAC_CONTROL_REGS(qdev) qlge_dump_xgmac_control_regs(qdev)
-#else
-#define QL_DUMP_REGS(qdev)
-#define QL_DUMP_ROUTE(qdev)
-#define QL_DUMP_XGMAC_CONTROL_REGS(qdev)
-#endif
-
-#ifdef QL_STAT_DUMP
-void qlge_dump_stat(struct qlge_adapter *qdev);
-#define QL_DUMP_STAT(qdev) qlge_dump_stat(qdev)
-#else
-#define QL_DUMP_STAT(qdev)
-#endif
-
-#ifdef QL_DEV_DUMP
-void qlge_dump_qdev(struct qlge_adapter *qdev);
-#define QL_DUMP_QDEV(qdev) qlge_dump_qdev(qdev)
-#else
-#define QL_DUMP_QDEV(qdev)
-#endif
-
-#ifdef QL_CB_DUMP
-void qlge_dump_wqicb(struct wqicb *wqicb);
-void qlge_dump_tx_ring(struct tx_ring *tx_ring);
-void qlge_dump_ricb(struct ricb *ricb);
-void qlge_dump_cqicb(struct cqicb *cqicb);
-void qlge_dump_rx_ring(struct rx_ring *rx_ring);
-void qlge_dump_hw_cb(struct qlge_adapter *qdev, int size, u32 bit, u16 q_id);
-#define QL_DUMP_RICB(ricb) qlge_dump_ricb(ricb)
-#define QL_DUMP_WQICB(wqicb) qlge_dump_wqicb(wqicb)
-#define QL_DUMP_TX_RING(tx_ring) qlge_dump_tx_ring(tx_ring)
-#define QL_DUMP_CQICB(cqicb) qlge_dump_cqicb(cqicb)
-#define QL_DUMP_RX_RING(rx_ring) qlge_dump_rx_ring(rx_ring)
-#define QL_DUMP_HW_CB(qdev, size, bit, q_id) \
-		qlge_dump_hw_cb(qdev, size, bit, q_id)
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
-void qlge_dump_tx_desc(struct qlge_adapter *qdev, struct tx_buf_desc *tbd);
-void qlge_dump_ob_mac_iocb(struct qlge_adapter *qdev, struct qlge_ob_mac_iocb_req *ob_mac_iocb);
-void qlge_dump_ob_mac_rsp(struct qlge_adapter *qdev, struct qlge_ob_mac_iocb_rsp *ob_mac_rsp);
-#define QL_DUMP_OB_MAC_IOCB(qdev, ob_mac_iocb) qlge_dump_ob_mac_iocb(qdev, ob_mac_iocb)
-#define QL_DUMP_OB_MAC_RSP(qdev, ob_mac_rsp) qlge_dump_ob_mac_rsp(qdev, ob_mac_rsp)
-#else
-#define QL_DUMP_OB_MAC_IOCB(qdev, ob_mac_iocb)
-#define QL_DUMP_OB_MAC_RSP(qdev, ob_mac_rsp)
-#endif
-
-#ifdef QL_IB_DUMP
-void qlge_dump_ib_mac_rsp(struct qlge_adapter *qdev, struct qlge_ib_mac_iocb_rsp *ib_mac_rsp);
-#define QL_DUMP_IB_MAC_RSP(qdev, ib_mac_rsp) qlge_dump_ib_mac_rsp(qdev, ib_mac_rsp)
-#else
-#define QL_DUMP_IB_MAC_RSP(qdev, ib_mac_rsp)
-#endif
-
-#ifdef	QL_ALL_DUMP
-void qlge_dump_all(struct qlge_adapter *qdev);
-#define QL_DUMP_ALL(qdev) qlge_dump_all(qdev)
-#else
-#define QL_DUMP_ALL(qdev)
-#endif
-
 #endif /* _QLGE_H_ */
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 5c64d6de3b30..37e593f0fd82 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1312,691 +1312,3 @@ void qlge_get_dump(struct qlge_adapter *qdev, void *buff)
 		qlge_get_core_dump(qdev);
 	}
 }
-
-#ifdef QL_REG_DUMP
-static void qlge_dump_intr_states(struct qlge_adapter *qdev)
-{
-	int i;
-	u32 value;
-
-	for (i = 0; i < qdev->intr_count; i++) {
-		qlge_write32(qdev, INTR_EN, qdev->intr_context[i].intr_read_mask);
-		value = qlge_read32(qdev, INTR_EN);
-		netdev_err(qdev->ndev, "Interrupt %d is %s\n", i,
-			   (value & INTR_EN_EN ? "enabled" : "disabled"));
-	}
-}
-
-#define DUMP_XGMAC(qdev, reg)					\
-	do {								\
-		u32 data;						\
-		qlge_read_xgmac_reg(qdev, reg, &data);			\
-		netdev_err(qdev->ndev, "%s = 0x%.08x\n", #reg, data); \
-	} while (0)
-
-void qlge_dump_xgmac_control_regs(struct qlge_adapter *qdev)
-{
-	if (qlge_sem_spinlock(qdev, qdev->xg_sem_mask)) {
-		netdev_err(qdev->ndev, "%s: Couldn't get xgmac sem\n",
-			   __func__);
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
-	qlge_sem_unlock(qdev, qdev->xg_sem_mask);
-}
-
-static void qlge_dump_ets_regs(struct qlge_adapter *qdev)
-{
-}
-
-static void qlge_dump_cam_entries(struct qlge_adapter *qdev)
-{
-	int i;
-	u32 value[3];
-
-	i = qlge_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
-	if (i)
-		return;
-	for (i = 0; i < 4; i++) {
-		if (qlge_get_mac_addr_reg(qdev, MAC_ADDR_TYPE_CAM_MAC, i, value)) {
-			netdev_err(qdev->ndev,
-				   "%s: Failed read of mac index register\n",
-				   __func__);
-			break;
-		}
-		if (value[0])
-			netdev_err(qdev->ndev,
-				   "CAM index %d CAM Lookup Lower = 0x%.08x:%.08x, Output = 0x%.08x\n",
-				   i, value[1], value[0], value[2]);
-	}
-	for (i = 0; i < 32; i++) {
-		if (qlge_get_mac_addr_reg
-		    (qdev, MAC_ADDR_TYPE_MULTI_MAC, i, value)) {
-			netdev_err(qdev->ndev,
-				   "%s: Failed read of mac index register\n",
-				   __func__);
-			break;
-		}
-		if (value[0])
-			netdev_err(qdev->ndev,
-				   "MCAST index %d CAM Lookup Lower = 0x%.08x:%.08x\n",
-				   i, value[1], value[0]);
-	}
-	qlge_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
-}
-
-void qlge_dump_routing_entries(struct qlge_adapter *qdev)
-{
-	int i;
-	u32 value;
-
-	i = qlge_sem_spinlock(qdev, SEM_RT_IDX_MASK);
-	if (i)
-		return;
-	for (i = 0; i < 16; i++) {
-		value = 0;
-		if (qlge_get_routing_reg(qdev, i, &value)) {
-			netdev_err(qdev->ndev,
-				   "%s: Failed read of routing index register\n",
-				   __func__);
-			break;
-		}
-		if (value)
-			netdev_err(qdev->ndev,
-				   "Routing Mask %d = 0x%.08x\n",
-				   i, value);
-	}
-	qlge_sem_unlock(qdev, SEM_RT_IDX_MASK);
-}
-
-#define DUMP_REG(qdev, reg)			\
-	netdev_err(qdev->ndev, "%-32s= 0x%x\n", #reg, qlge_read32(qdev, reg))
-
-void qlge_dump_regs(struct qlge_adapter *qdev)
-{
-	netdev_err(qdev->ndev, "reg dump for function #%d\n", qdev->func);
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
-	qlge_dump_intr_states(qdev);
-	qlge_dump_xgmac_control_regs(qdev);
-	qlge_dump_ets_regs(qdev);
-	qlge_dump_cam_entries(qdev);
-	qlge_dump_routing_entries(qdev);
-}
-#endif
-
-#ifdef QL_STAT_DUMP
-
-#define DUMP_STAT(qdev, stat)	\
-	netdev_err(qdev->ndev, "%s = %ld\n", #stat,  \
-		   (unsigned long)(qdev)->nic_stats.stat)
-
-void qlge_dump_stat(struct qlge_adapter *qdev)
-{
-	netdev_err(qdev->ndev, "%s: Enter\n", __func__);
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
-	netdev_err(qdev->ndev, "qdev->%-24s = " type "\n", #field, (qdev)->field)
-#define DUMP_QDEV_DMA_FIELD(qdev, field)		\
-	netdev_err(qdev->ndev, "qdev->%-24s = %llx\n", #field, \
-		   (unsigned long long)qdev->field)
-#define DUMP_QDEV_ARRAY(qdev, type, array, index, field) \
-	netdev_err(qdev->ndev, "%s[%d].%s = " type "\n",		 \
-#array, index, #field, (qdev)->array[index].field)
-	void qlge_dump_qdev(struct qlge_adapter *qdev)
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
-void qlge_dump_wqicb(struct wqicb *wqicb)
-{
-	struct tx_ring *tx_ring = container_of(wqicb, struct tx_ring, wqicb);
-	struct qlge_adapter *qdev = tx_ring->qdev;
-
-	netdev_err(qdev->ndev, "Dumping wqicb stuff...\n");
-	netdev_err(qdev->ndev, "wqicb->len = 0x%x\n", le16_to_cpu(wqicb->len));
-	netdev_err(qdev->ndev, "wqicb->flags = %x\n",
-		   le16_to_cpu(wqicb->flags));
-	netdev_err(qdev->ndev, "wqicb->cq_id_rss = %d\n",
-		   le16_to_cpu(wqicb->cq_id_rss));
-	netdev_err(qdev->ndev, "wqicb->rid = 0x%x\n", le16_to_cpu(wqicb->rid));
-	netdev_err(qdev->ndev, "wqicb->wq_addr = 0x%llx\n",
-		   (unsigned long long)le64_to_cpu(wqicb->addr));
-	netdev_err(qdev->ndev, "wqicb->wq_cnsmr_idx_addr = 0x%llx\n",
-		   (unsigned long long)le64_to_cpu(wqicb->cnsmr_idx_addr));
-}
-
-void qlge_dump_tx_ring(struct tx_ring *tx_ring)
-{
-	struct qlge_adapter *qdev = tx_ring->qdev;
-
-	netdev_err(qdev->ndev, "===================== Dumping tx_ring %d ===============\n",
-		   tx_ring->wq_id);
-	netdev_err(qdev->ndev, "tx_ring->base = %p\n", tx_ring->wq_base);
-	netdev_err(qdev->ndev, "tx_ring->base_dma = 0x%llx\n",
-		   (unsigned long long)tx_ring->wq_base_dma);
-	netdev_err(qdev->ndev, "tx_ring->cnsmr_idx_sh_reg, addr = 0x%p, value = %d\n",
-		   tx_ring->cnsmr_idx_sh_reg,
-		   tx_ring->cnsmr_idx_sh_reg
-		   ? qlge_read_sh_reg(tx_ring->cnsmr_idx_sh_reg) : 0);
-	netdev_err(qdev->ndev, "tx_ring->size = %d\n", tx_ring->wq_size);
-	netdev_err(qdev->ndev, "tx_ring->len = %d\n", tx_ring->wq_len);
-	netdev_err(qdev->ndev, "tx_ring->prod_idx_db_reg = %p\n", tx_ring->prod_idx_db_reg);
-	netdev_err(qdev->ndev, "tx_ring->valid_db_reg = %p\n", tx_ring->valid_db_reg);
-	netdev_err(qdev->ndev, "tx_ring->prod_idx = %d\n", tx_ring->prod_idx);
-	netdev_err(qdev->ndev, "tx_ring->cq_id = %d\n", tx_ring->cq_id);
-	netdev_err(qdev->ndev, "tx_ring->wq_id = %d\n", tx_ring->wq_id);
-	netdev_err(qdev->ndev, "tx_ring->q = %p\n", tx_ring->q);
-	netdev_err(qdev->ndev, "tx_ring->tx_count = %d\n", atomic_read(&tx_ring->tx_count));
-}
-
-void qlge_dump_ricb(struct ricb *ricb)
-{
-	int i;
-	struct qlge_adapter *qdev =
-		container_of(ricb, struct qlge_adapter, ricb);
-
-	netdev_err(qdev->ndev, "===================== Dumping ricb ===============\n");
-	netdev_err(qdev->ndev, "Dumping ricb stuff...\n");
-
-	netdev_err(qdev->ndev, "ricb->base_cq = %d\n", ricb->base_cq & 0x1f);
-	netdev_err(qdev->ndev, "ricb->flags = %s%s%s%s%s%s%s%s%s\n",
-		   ricb->base_cq & RSS_L4K ? "RSS_L4K " : "",
-		   ricb->flags & RSS_L6K ? "RSS_L6K " : "",
-		   ricb->flags & RSS_LI ? "RSS_LI " : "",
-		   ricb->flags & RSS_LB ? "RSS_LB " : "",
-		   ricb->flags & RSS_LM ? "RSS_LM " : "",
-		   ricb->flags & RSS_RI4 ? "RSS_RI4 " : "",
-		   ricb->flags & RSS_RT4 ? "RSS_RT4 " : "",
-		   ricb->flags & RSS_RI6 ? "RSS_RI6 " : "",
-		   ricb->flags & RSS_RT6 ? "RSS_RT6 " : "");
-	netdev_err(qdev->ndev, "ricb->mask = 0x%.04x\n", le16_to_cpu(ricb->mask));
-	for (i = 0; i < 16; i++)
-		netdev_err(qdev->ndev, "ricb->hash_cq_id[%d] = 0x%.08x\n", i,
-			   le32_to_cpu(ricb->hash_cq_id[i]));
-	for (i = 0; i < 10; i++)
-		netdev_err(qdev->ndev, "ricb->ipv6_hash_key[%d] = 0x%.08x\n", i,
-			   le32_to_cpu(ricb->ipv6_hash_key[i]));
-	for (i = 0; i < 4; i++)
-		netdev_err(qdev->ndev, "ricb->ipv4_hash_key[%d] = 0x%.08x\n", i,
-			   le32_to_cpu(ricb->ipv4_hash_key[i]));
-}
-
-void qlge_dump_cqicb(struct cqicb *cqicb)
-{
-	struct rx_ring *rx_ring = container_of(cqicb, struct rx_ring, cqicb);
-	struct qlge_adapter *qdev = rx_ring->qdev;
-
-	netdev_err(qdev->ndev, "Dumping cqicb stuff...\n");
-
-	netdev_err(qdev->ndev, "cqicb->msix_vect = %d\n", cqicb->msix_vect);
-	netdev_err(qdev->ndev, "cqicb->flags = %x\n", cqicb->flags);
-	netdev_err(qdev->ndev, "cqicb->len = %d\n", le16_to_cpu(cqicb->len));
-	netdev_err(qdev->ndev, "cqicb->addr = 0x%llx\n",
-		   (unsigned long long)le64_to_cpu(cqicb->addr));
-	netdev_err(qdev->ndev, "cqicb->prod_idx_addr = 0x%llx\n",
-		   (unsigned long long)le64_to_cpu(cqicb->prod_idx_addr));
-	netdev_err(qdev->ndev, "cqicb->pkt_delay = 0x%.04x\n",
-		   le16_to_cpu(cqicb->pkt_delay));
-	netdev_err(qdev->ndev, "cqicb->irq_delay = 0x%.04x\n",
-		   le16_to_cpu(cqicb->irq_delay));
-	netdev_err(qdev->ndev, "cqicb->lbq_addr = 0x%llx\n",
-		   (unsigned long long)le64_to_cpu(cqicb->lbq_addr));
-	netdev_err(qdev->ndev, "cqicb->lbq_buf_size = 0x%.04x\n",
-		   le16_to_cpu(cqicb->lbq_buf_size));
-	netdev_err(qdev->ndev, "cqicb->lbq_len = 0x%.04x\n",
-		   le16_to_cpu(cqicb->lbq_len));
-	netdev_err(qdev->ndev, "cqicb->sbq_addr = 0x%llx\n",
-		   (unsigned long long)le64_to_cpu(cqicb->sbq_addr));
-	netdev_err(qdev->ndev, "cqicb->sbq_buf_size = 0x%.04x\n",
-		   le16_to_cpu(cqicb->sbq_buf_size));
-	netdev_err(qdev->ndev, "cqicb->sbq_len = 0x%.04x\n",
-		   le16_to_cpu(cqicb->sbq_len));
-}
-
-static const char *qlge_rx_ring_type_name(struct rx_ring *rx_ring)
-{
-	struct qlge_adapter *qdev = rx_ring->qdev;
-
-	if (rx_ring->cq_id < qdev->rss_ring_count)
-		return "RX COMPLETION";
-	else
-		return "TX COMPLETION";
-};
-
-void qlge_dump_rx_ring(struct rx_ring *rx_ring)
-{
-	struct qlge_adapter *qdev = rx_ring->qdev;
-
-	netdev_err(qdev->ndev,
-		   "===================== Dumping rx_ring %d ===============\n",
-		   rx_ring->cq_id);
-	netdev_err(qdev->ndev,
-		   "Dumping rx_ring %d, type = %s\n", rx_ring->cq_id,
-		   qlge_rx_ring_type_name(rx_ring));
-	netdev_err(qdev->ndev, "rx_ring->cqicb = %p\n", &rx_ring->cqicb);
-	netdev_err(qdev->ndev, "rx_ring->cq_base = %p\n", rx_ring->cq_base);
-	netdev_err(qdev->ndev, "rx_ring->cq_base_dma = %llx\n",
-		   (unsigned long long)rx_ring->cq_base_dma);
-	netdev_err(qdev->ndev, "rx_ring->cq_size = %d\n", rx_ring->cq_size);
-	netdev_err(qdev->ndev, "rx_ring->cq_len = %d\n", rx_ring->cq_len);
-	netdev_err(qdev->ndev,
-		   "rx_ring->prod_idx_sh_reg, addr = 0x%p, value = %d\n",
-		   rx_ring->prod_idx_sh_reg,
-		   rx_ring->prod_idx_sh_reg ? qlge_read_sh_reg(rx_ring->prod_idx_sh_reg) : 0);
-	netdev_err(qdev->ndev, "rx_ring->prod_idx_sh_reg_dma = %llx\n",
-		   (unsigned long long)rx_ring->prod_idx_sh_reg_dma);
-	netdev_err(qdev->ndev, "rx_ring->cnsmr_idx_db_reg = %p\n",
-		   rx_ring->cnsmr_idx_db_reg);
-	netdev_err(qdev->ndev, "rx_ring->cnsmr_idx = %d\n", rx_ring->cnsmr_idx);
-	netdev_err(qdev->ndev, "rx_ring->curr_entry = %p\n", rx_ring->curr_entry);
-	netdev_err(qdev->ndev, "rx_ring->valid_db_reg = %p\n", rx_ring->valid_db_reg);
-
-	netdev_err(qdev->ndev, "rx_ring->lbq.base = %p\n", rx_ring->lbq.base);
-	netdev_err(qdev->ndev, "rx_ring->lbq.base_dma = %llx\n",
-		   (unsigned long long)rx_ring->lbq.base_dma);
-	netdev_err(qdev->ndev, "rx_ring->lbq.base_indirect = %p\n",
-		   rx_ring->lbq.base_indirect);
-	netdev_err(qdev->ndev, "rx_ring->lbq.base_indirect_dma = %llx\n",
-		   (unsigned long long)rx_ring->lbq.base_indirect_dma);
-	netdev_err(qdev->ndev, "rx_ring->lbq = %p\n", rx_ring->lbq.queue);
-	netdev_err(qdev->ndev, "rx_ring->lbq.prod_idx_db_reg = %p\n",
-		   rx_ring->lbq.prod_idx_db_reg);
-	netdev_err(qdev->ndev, "rx_ring->lbq.next_to_use = %d\n", rx_ring->lbq.next_to_use);
-	netdev_err(qdev->ndev, "rx_ring->lbq.next_to_clean = %d\n", rx_ring->lbq.next_to_clean);
-
-	netdev_err(qdev->ndev, "rx_ring->sbq.base = %p\n", rx_ring->sbq.base);
-	netdev_err(qdev->ndev, "rx_ring->sbq.base_dma = %llx\n",
-		   (unsigned long long)rx_ring->sbq.base_dma);
-	netdev_err(qdev->ndev, "rx_ring->sbq.base_indirect = %p\n",
-		   rx_ring->sbq.base_indirect);
-	netdev_err(qdev->ndev, "rx_ring->sbq.base_indirect_dma = %llx\n",
-		   (unsigned long long)rx_ring->sbq.base_indirect_dma);
-	netdev_err(qdev->ndev, "rx_ring->sbq = %p\n", rx_ring->sbq.queue);
-	netdev_err(qdev->ndev, "rx_ring->sbq.prod_idx_db_reg addr = %p\n",
-		   rx_ring->sbq.prod_idx_db_reg);
-	netdev_err(qdev->ndev, "rx_ring->sbq.next_to_use = %d\n", rx_ring->sbq.next_to_use);
-	netdev_err(qdev->ndev, "rx_ring->sbq.next_to_clean = %d\n", rx_ring->sbq.next_to_clean);
-	netdev_err(qdev->ndev, "rx_ring->cq_id = %d\n", rx_ring->cq_id);
-	netdev_err(qdev->ndev, "rx_ring->irq = %d\n", rx_ring->irq);
-	netdev_err(qdev->ndev, "rx_ring->cpu = %d\n", rx_ring->cpu);
-	netdev_err(qdev->ndev, "rx_ring->qdev = %p\n", rx_ring->qdev);
-}
-
-void qlge_dump_hw_cb(struct qlge_adapter *qdev, int size, u32 bit, u16 q_id)
-{
-	void *ptr;
-
-	netdev_err(qdev->ndev, "%s: Enter\n", __func__);
-
-	ptr = kmalloc(size, GFP_ATOMIC);
-	if (!ptr)
-		return;
-
-	if (qlge_write_cfg(qdev, ptr, size, bit, q_id)) {
-		netdev_err(qdev->ndev, "%s: Failed to upload control block!\n", __func__);
-		goto fail_it;
-	}
-	switch (bit) {
-	case CFG_DRQ:
-		qlge_dump_wqicb((struct wqicb *)ptr);
-		break;
-	case CFG_DCQ:
-		qlge_dump_cqicb((struct cqicb *)ptr);
-		break;
-	case CFG_DR:
-		qlge_dump_ricb((struct ricb *)ptr);
-		break;
-	default:
-		netdev_err(qdev->ndev, "%s: Invalid bit value = %x\n", __func__, bit);
-		break;
-	}
-fail_it:
-	kfree(ptr);
-}
-#endif
-
-#ifdef QL_OB_DUMP
-void qlge_dump_tx_desc(struct qlge_adapter *qdev, struct tx_buf_desc *tbd)
-{
-	netdev_err(qdev->ndev, "tbd->addr  = 0x%llx\n",
-		   le64_to_cpu((u64)tbd->addr));
-	netdev_err(qdev->ndev, "tbd->len   = %d\n",
-		   le32_to_cpu(tbd->len & TX_DESC_LEN_MASK));
-	netdev_err(qdev->ndev, "tbd->flags = %s %s\n",
-		   tbd->len & TX_DESC_C ? "C" : ".",
-		   tbd->len & TX_DESC_E ? "E" : ".");
-	tbd++;
-	netdev_err(qdev->ndev, "tbd->addr  = 0x%llx\n",
-		   le64_to_cpu((u64)tbd->addr));
-	netdev_err(qdev->ndev, "tbd->len   = %d\n",
-		   le32_to_cpu(tbd->len & TX_DESC_LEN_MASK));
-	netdev_err(qdev->ndev, "tbd->flags = %s %s\n",
-		   tbd->len & TX_DESC_C ? "C" : ".",
-		   tbd->len & TX_DESC_E ? "E" : ".");
-	tbd++;
-	netdev_err(qdev->ndev, "tbd->addr  = 0x%llx\n",
-		   le64_to_cpu((u64)tbd->addr));
-	netdev_err(qdev->ndev, "tbd->len   = %d\n",
-		   le32_to_cpu(tbd->len & TX_DESC_LEN_MASK));
-	netdev_err(qdev->ndev, "tbd->flags = %s %s\n",
-		   tbd->len & TX_DESC_C ? "C" : ".",
-		   tbd->len & TX_DESC_E ? "E" : ".");
-}
-
-void qlge_dump_ob_mac_iocb(struct qlge_adapter *qdev, struct qlge_ob_mac_iocb_req *ob_mac_iocb)
-{
-	struct qlge_ob_mac_tso_iocb_req *ob_mac_tso_iocb =
-		(struct qlge_ob_mac_tso_iocb_req *)ob_mac_iocb;
-	struct tx_buf_desc *tbd;
-	u16 frame_len;
-
-	netdev_err(qdev->ndev, "%s\n", __func__);
-	netdev_err(qdev->ndev, "opcode         = %s\n",
-		   (ob_mac_iocb->opcode == OPCODE_OB_MAC_IOCB) ? "MAC" : "TSO");
-	netdev_err(qdev->ndev, "flags1          = %s %s %s %s %s\n",
-		   ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_OI ? "OI" : "",
-		   ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_I ? "I" : "",
-		   ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_D ? "D" : "",
-		   ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_IP4 ? "IP4" : "",
-		   ob_mac_tso_iocb->flags1 & OB_MAC_TSO_IOCB_IP6 ? "IP6" : "");
-	netdev_err(qdev->ndev, "flags2          = %s %s %s\n",
-		   ob_mac_tso_iocb->flags2 & OB_MAC_TSO_IOCB_LSO ? "LSO" : "",
-		   ob_mac_tso_iocb->flags2 & OB_MAC_TSO_IOCB_UC ? "UC" : "",
-		   ob_mac_tso_iocb->flags2 & OB_MAC_TSO_IOCB_TC ? "TC" : "");
-	netdev_err(qdev->ndev, "flags3          = %s %s %s\n",
-		   ob_mac_tso_iocb->flags3 & OB_MAC_TSO_IOCB_IC ? "IC" : "",
-		   ob_mac_tso_iocb->flags3 & OB_MAC_TSO_IOCB_DFP ? "DFP" : "",
-		   ob_mac_tso_iocb->flags3 & OB_MAC_TSO_IOCB_V ? "V" : "");
-	netdev_err(qdev->ndev, "tid = %x\n", ob_mac_iocb->tid);
-	netdev_err(qdev->ndev, "txq_idx = %d\n", ob_mac_iocb->txq_idx);
-	netdev_err(qdev->ndev, "vlan_tci      = %x\n", ob_mac_tso_iocb->vlan_tci);
-	if (ob_mac_iocb->opcode == OPCODE_OB_MAC_TSO_IOCB) {
-		netdev_err(qdev->ndev, "frame_len      = %d\n",
-			   le32_to_cpu(ob_mac_tso_iocb->frame_len));
-		netdev_err(qdev->ndev, "mss      = %d\n",
-			   le16_to_cpu(ob_mac_tso_iocb->mss));
-		netdev_err(qdev->ndev, "prot_hdr_len   = %d\n",
-			   le16_to_cpu(ob_mac_tso_iocb->total_hdrs_len));
-		netdev_err(qdev->ndev, "hdr_offset     = 0x%.04x\n",
-			   le16_to_cpu(ob_mac_tso_iocb->net_trans_offset));
-		frame_len = le32_to_cpu(ob_mac_tso_iocb->frame_len);
-	} else {
-		netdev_err(qdev->ndev, "frame_len      = %d\n",
-			   le16_to_cpu(ob_mac_iocb->frame_len));
-		frame_len = le16_to_cpu(ob_mac_iocb->frame_len);
-	}
-	tbd = &ob_mac_iocb->tbd[0];
-	qlge_dump_tx_desc(qdev, tbd);
-}
-
-void qlge_dump_ob_mac_rsp(struct qlge_adapter *qdev, struct qlge_ob_mac_iocb_rsp *ob_mac_rsp)
-{
-	netdev_err(qdev->ndev, "%s\n", __func__);
-	netdev_err(qdev->ndev, "opcode         = %d\n", ob_mac_rsp->opcode);
-	netdev_err(qdev->ndev, "flags          = %s %s %s %s %s %s %s\n",
-		   ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_OI ?
-		   "OI" : ".", ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_I ? "I" : ".",
-		   ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_E ? "E" : ".",
-		   ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_S ? "S" : ".",
-		   ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_L ? "L" : ".",
-		   ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_P ? "P" : ".",
-		   ob_mac_rsp->flags2 & OB_MAC_IOCB_RSP_B ? "B" : ".");
-	netdev_err(qdev->ndev, "tid = %x\n", ob_mac_rsp->tid);
-}
-#endif
-
-#ifdef QL_IB_DUMP
-void qlge_dump_ib_mac_rsp(struct qlge_adapter *qdev, struct qlge_ib_mac_iocb_rsp *ib_mac_rsp)
-{
-	netdev_err(qdev->ndev, "%s\n", __func__);
-	netdev_err(qdev->ndev, "opcode         = 0x%x\n", ib_mac_rsp->opcode);
-	netdev_err(qdev->ndev, "flags1 = %s%s%s%s%s%s\n",
-		   ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_OI ? "OI " : "",
-		   ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_I ? "I " : "",
-		   ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_TE ? "TE " : "",
-		   ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_NU ? "NU " : "",
-		   ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_IE ? "IE " : "",
-		   ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_B ? "B " : "");
-
-	if (ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_M_MASK)
-		netdev_err(qdev->ndev, "%s%s%s Multicast\n",
-			   (ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_M_MASK) ==
-			   IB_MAC_IOCB_RSP_M_HASH ? "Hash" : "",
-			   (ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_M_MASK) ==
-			   IB_MAC_IOCB_RSP_M_REG ? "Registered" : "",
-			   (ib_mac_rsp->flags1 & IB_MAC_IOCB_RSP_M_MASK) ==
-			   IB_MAC_IOCB_RSP_M_PROM ? "Promiscuous" : "");
-
-	netdev_err(qdev->ndev, "flags2 = %s%s%s%s%s\n",
-		   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_P) ? "P " : "",
-		   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_V) ? "V " : "",
-		   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_U) ? "U " : "",
-		   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_T) ? "T " : "",
-		   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_FO) ? "FO " : "");
-
-	if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK)
-		netdev_err(qdev->ndev, "%s%s%s%s%s error\n",
-			   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
-			   IB_MAC_IOCB_RSP_ERR_OVERSIZE ? "oversize" : "",
-			   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
-			   IB_MAC_IOCB_RSP_ERR_UNDERSIZE ? "undersize" : "",
-			   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
-			   IB_MAC_IOCB_RSP_ERR_PREAMBLE ? "preamble" : "",
-			   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
-			   IB_MAC_IOCB_RSP_ERR_FRAME_LEN ? "frame length" : "",
-			   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) ==
-			   IB_MAC_IOCB_RSP_ERR_CRC ? "CRC" : "");
-
-	netdev_err(qdev->ndev, "flags3 = %s%s\n",
-		   ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DS ? "DS " : "",
-		   ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL ? "DL " : "");
-
-	if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK)
-		netdev_err(qdev->ndev, "RSS flags = %s%s%s%s\n",
-			   ((ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK) ==
-			    IB_MAC_IOCB_RSP_M_IPV4) ? "IPv4 RSS" : "",
-			   ((ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK) ==
-			    IB_MAC_IOCB_RSP_M_IPV6) ? "IPv6 RSS " : "",
-			   ((ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK) ==
-			    IB_MAC_IOCB_RSP_M_TCP_V4) ? "TCP/IPv4 RSS" : "",
-			   ((ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK) ==
-			    IB_MAC_IOCB_RSP_M_TCP_V6) ? "TCP/IPv6 RSS" : "");
-
-	netdev_err(qdev->ndev, "data_len	= %d\n",
-		   le32_to_cpu(ib_mac_rsp->data_len));
-	netdev_err(qdev->ndev, "data_addr    = 0x%llx\n",
-		   (unsigned long long)le64_to_cpu(ib_mac_rsp->data_addr));
-	if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_RSS_MASK)
-		netdev_err(qdev->ndev, "rss    = %x\n",
-			   le32_to_cpu(ib_mac_rsp->rss));
-	if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_V)
-		netdev_err(qdev->ndev, "vlan_id    = %x\n",
-			   le16_to_cpu(ib_mac_rsp->vlan_id));
-
-	netdev_err(qdev->ndev, "flags4 = %s%s%s\n",
-		   ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV ? "HV " : "",
-		   ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HS ? "HS " : "",
-		   ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HL ? "HL " : "");
-
-	if (ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV) {
-		netdev_err(qdev->ndev, "hdr length	= %d\n",
-			   le32_to_cpu(ib_mac_rsp->hdr_len));
-		netdev_err(qdev->ndev, "hdr addr    = 0x%llx\n",
-			   (unsigned long long)le64_to_cpu(ib_mac_rsp->hdr_addr));
-	}
-}
-#endif
-
-#ifdef QL_ALL_DUMP
-void qlge_dump_all(struct qlge_adapter *qdev)
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
index 3e911f147dfc..a296a51078bc 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -328,8 +328,6 @@ static void qlge_update_stats(struct qlge_adapter *qdev)
 	qlge_sem_unlock(qdev, qdev->xg_sem_mask);
 quit:
 	spin_unlock(&qdev->stats_lock);
-
-	QL_DUMP_STAT(qdev);
 }
 
 static void qlge_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index b138109a24a5..ca300df89700 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -1857,8 +1857,6 @@ static void qlge_process_mac_split_rx_intr(struct qlge_adapter *qdev,
 	struct net_device *ndev = qdev->ndev;
 	struct sk_buff *skb = NULL;
 
-	QL_DUMP_IB_MAC_RSP(qdev, ib_mac_rsp);
-
 	skb = qlge_build_rx_skb(qdev, rx_ring, ib_mac_rsp);
 	if (unlikely(!skb)) {
 		netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
@@ -1955,8 +1953,6 @@ static unsigned long qlge_process_mac_rx_intr(struct qlge_adapter *qdev,
 		((le16_to_cpu(ib_mac_rsp->vlan_id) &
 		  IB_MAC_IOCB_RSP_VLAN_MASK)) : 0xffff;
 
-	QL_DUMP_IB_MAC_RSP(qdev, ib_mac_rsp);
-
 	if (ib_mac_rsp->flags4 & IB_MAC_IOCB_RSP_HV) {
 		/* The data and headers are split into
 		 * separate buffers.
@@ -2002,7 +1998,6 @@ static void qlge_process_mac_tx_intr(struct qlge_adapter *qdev,
 	struct tx_ring *tx_ring;
 	struct tx_ring_desc *tx_ring_desc;
 
-	QL_DUMP_OB_MAC_RSP(qdev, mac_rsp);
 	tx_ring = &qdev->tx_ring[mac_rsp->txq_idx];
 	tx_ring_desc = &tx_ring->q[mac_rsp->tid];
 	qlge_unmap_send(qdev, tx_ring_desc, tx_ring_desc->map_cnt);
@@ -2593,7 +2588,7 @@ static netdev_tx_t qlge_send(struct sk_buff *skb, struct net_device *ndev)
 		tx_ring->tx_errors++;
 		return NETDEV_TX_BUSY;
 	}
-	QL_DUMP_OB_MAC_IOCB(qdev, mac_iocb_ptr);
+
 	tx_ring->prod_idx++;
 	if (tx_ring->prod_idx == tx_ring->wq_len)
 		tx_ring->prod_idx = 0;
-- 
2.28.0

