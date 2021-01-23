Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5CBD30149E
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 11:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbhAWKrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 05:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbhAWKrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 05:47:22 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D866C06174A;
        Sat, 23 Jan 2021 02:46:42 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id m5so5461336pjv.5;
        Sat, 23 Jan 2021 02:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XS9s6QzYzZnFdCcrnXfNRB7PNo15vgZmoru8aD+ih64=;
        b=rmODAOSN6TRlXtZtt7ZYKBzzQRk2AYe9IPXFYPNJkUAM1TDDIFj+HtbEDapRJ8Uyh8
         f1EJd+DWj12p9MZmtKJBUBXTUgpTjJU53SmJS7ikv/n9YsTK1e9V29RAAxxK0MEWJcZw
         g/b48Uw/Yna9TX1Ambu6b0HK71ixJIE3wGX+Ey5USIv6N7wuhbBw2VhfmdM95uuZaG4Z
         y4pxzQw7oKvZM6hx1a0oURL/ner0LNTQxcfQCCqykJ8BfHu2NmaDJgp3FjIISpiGj9JG
         ZpCX4hKJkI3ZAF3E9lugopzSGTKsIAPv7fGV7IDNQ87w4ahZVkAC/dLsLddHLcanSWe1
         JSrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XS9s6QzYzZnFdCcrnXfNRB7PNo15vgZmoru8aD+ih64=;
        b=a+ByYBBoKRuul9vaH9aim03qFhgZ+b0KLwzOA0EA28hpQ5f+hTaAyarhfVBQ4uCE+p
         mOmtSORUTlrihTYS0uwuAnh0uIjJ6dLniP4APtIYhdD0jRQvyWKsJwI94AJRk9oLdP0+
         VXUhrMZDEuZUzllo86UNX77d55VHpaBC1zYPTU1P0bgmvcOyGD+eI0up+8OHADVE0fhb
         HP6eTXtW08Gv0o6nAG80G93tkBHURA/iimLy7fofCC49OdHEufXS5JysRdRZXQAtriuE
         j48i4dFc2Roz2uJn4IruyWJxvYqb+3sR7ueMRHO8wDlY4badgu/gMzULn8MC/44rhTO4
         uyhQ==
X-Gm-Message-State: AOAM532TrkuJxSZ7JUQffPZZOJk+qtgSoFskazQwYQCTul4ekemjFgc4
        BRfB32Ueaogkz7VsS9jT+BUKySyp9kyCOxz2
X-Google-Smtp-Source: ABdhPJzV76bgx0Q+wNsNKpc2KSjFwAB85m6JOup9pg+t55gR8Y041BXpw+jxmGAjY+TwOKaATiIGUA==
X-Received: by 2002:a17:902:d2cb:b029:de:757c:1f0c with SMTP id n11-20020a170902d2cbb02900de757c1f0cmr932712plc.40.1611398801123;
        Sat, 23 Jan 2021 02:46:41 -0800 (PST)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id j18sm5942180pfc.99.2021.01.23.02.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 02:46:40 -0800 (PST)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        GR-Linux-NIC-Dev@marvell.com, Manish Chopra <manishc@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 1/8] staging: qlge: use qlge_* prefix to avoid namespace clashes with other qlogic drivers
Date:   Sat, 23 Jan 2021 18:46:06 +0800
Message-Id: <20210123104613.38359-2-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210123104613.38359-1-coiby.xu@gmail.com>
References: <20210123104613.38359-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To avoid namespace clashes with other qlogic drivers and also for the
sake of naming consistency, use the "qlge_" prefix as suggested in
drivers/staging/qlge/TODO,
 - For existing ql_ prefix,
   sed -i "s/ql_/qlge_/g" *.{c,h}
 - for structs not having a prefix
   1. get a list of structs
      grep "struct.*{" qlge.
   2. add qlge_ for each struct, e.g.,
      sed -i "s/ib_ae_iocb_rsp/qlge_ib_ae_iocb_rsp/g" *.{c,h}

Link: https://lore.kernel.org/patchwork/patch/1318503/#1516131
Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/TODO           |    4 -
 drivers/staging/qlge/qlge.h         |  210 ++---
 drivers/staging/qlge/qlge_dbg.c     | 1075 ++++++++++++-----------
 drivers/staging/qlge/qlge_ethtool.c |  230 ++---
 drivers/staging/qlge/qlge_main.c    | 1268 +++++++++++++--------------
 drivers/staging/qlge/qlge_mpi.c     |  352 ++++----
 6 files changed, 1567 insertions(+), 1572 deletions(-)

diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
index f93f7428f5d5..5ac55664c3e2 100644
--- a/drivers/staging/qlge/TODO
+++ b/drivers/staging/qlge/TODO
@@ -28,10 +28,6 @@
 * the driver has a habit of using runtime checks where compile time checks are
   possible (ex. ql_free_rx_buffers(), ql_alloc_rx_buffers())
 * reorder struct members to avoid holes if it doesn't impact performance
-* in terms of namespace, the driver uses either qlge_, ql_ (used by
-  other qlogic drivers, with clashes, ex: ql_sem_spinlock) or nothing (with
-  clashes, ex: struct ob_mac_iocb_req). Rename everything to use the "qlge_"
-  prefix.
 * avoid legacy/deprecated apis (ex. replace pci_dma_*, replace pci_enable_msi,
   use pci_iomap)
 * some "while" loops could be rewritten with simple "for", ex.
diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 0381f3f56bc7..1ac85f2f770f 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -1081,7 +1081,7 @@ struct tx_buf_desc {
 #define OPCODE_IB_MPI_IOCB		0x21
 #define OPCODE_IB_AE_IOCB		0x3f
 
-struct ob_mac_iocb_req {
+struct qlge_ob_mac_iocb_req {
 	u8 opcode;
 	u8 flags1;
 #define OB_MAC_IOCB_REQ_OI	0x01
@@ -1104,7 +1104,7 @@ struct ob_mac_iocb_req {
 	struct tx_buf_desc tbd[TX_DESC_PER_IOCB];
 } __packed;
 
-struct ob_mac_iocb_rsp {
+struct qlge_ob_mac_iocb_rsp {
 	u8 opcode;		/* */
 	u8 flags1;		/* */
 #define OB_MAC_IOCB_RSP_OI	0x01	/* */
@@ -1121,7 +1121,7 @@ struct ob_mac_iocb_rsp {
 	__le32 reserved[13];
 } __packed;
 
-struct ob_mac_tso_iocb_req {
+struct qlge_ob_mac_tso_iocb_req {
 	u8 opcode;
 	u8 flags1;
 #define OB_MAC_TSO_IOCB_OI	0x01
@@ -1149,7 +1149,7 @@ struct ob_mac_tso_iocb_req {
 	struct tx_buf_desc tbd[TX_DESC_PER_IOCB];
 } __packed;
 
-struct ob_mac_tso_iocb_rsp {
+struct qlge_ob_mac_tso_iocb_rsp {
 	u8 opcode;
 	u8 flags1;
 #define OB_MAC_TSO_IOCB_RSP_OI	0x01
@@ -1166,7 +1166,7 @@ struct ob_mac_tso_iocb_rsp {
 	__le32 reserved2[13];
 } __packed;
 
-struct ib_mac_iocb_rsp {
+struct qlge_ib_mac_iocb_rsp {
 	u8 opcode;		/* 0x20 */
 	u8 flags1;
 #define IB_MAC_IOCB_RSP_OI	0x01	/* Override intr delay */
@@ -1225,7 +1225,7 @@ struct ib_mac_iocb_rsp {
 	__le64 hdr_addr;	/* */
 } __packed;
 
-struct ib_ae_iocb_rsp {
+struct qlge_ib_ae_iocb_rsp {
 	u8 opcode;
 	u8 flags1;
 #define IB_AE_IOCB_RSP_OI		0x01
@@ -1250,7 +1250,7 @@ struct ib_ae_iocb_rsp {
  * These three structures are for generic
  * handling of ib and ob iocbs.
  */
-struct ql_net_rsp_iocb {
+struct qlge_net_rsp_iocb {
 	u8 opcode;
 	u8 flags0;
 	__le16 length;
@@ -1258,7 +1258,7 @@ struct ql_net_rsp_iocb {
 	__le32 reserved[14];
 } __packed;
 
-struct net_req_iocb {
+struct qlge_net_req_iocb {
 	u8 opcode;
 	u8 flags0;
 	__le16 flags1;
@@ -1346,7 +1346,7 @@ struct ricb {
 
 /* SOFTWARE/DRIVER DATA STRUCTURES. */
 
-struct oal {
+struct qlge_oal {
 	struct tx_buf_desc oal[TX_DESC_PER_OAL];
 };
 
@@ -1357,9 +1357,9 @@ struct map_list {
 
 struct tx_ring_desc {
 	struct sk_buff *skb;
-	struct ob_mac_iocb_req *queue_entry;
+	struct qlge_ob_mac_iocb_req *queue_entry;
 	u32 index;
-	struct oal oal;
+	struct qlge_oal oal;
 	struct map_list map[MAX_SKB_FRAGS + 2];
 	int map_cnt;
 	struct tx_ring_desc *next;
@@ -1388,7 +1388,7 @@ struct tx_ring {
 	spinlock_t lock;
 	atomic_t tx_count;	/* counts down for every outstanding IO */
 	struct delayed_work tx_work;
-	struct ql_adapter *qdev;
+	struct qlge_adapter *qdev;
 	u64 tx_packets;
 	u64 tx_bytes;
 	u64 tx_errors;
@@ -1469,7 +1469,7 @@ struct rx_ring {
 	dma_addr_t prod_idx_sh_reg_dma;
 	void __iomem *cnsmr_idx_db_reg;	/* PCI doorbell mem area + 0 */
 	u32 cnsmr_idx;		/* current sw idx */
-	struct ql_net_rsp_iocb *curr_entry;	/* next entry on queue */
+	struct qlge_net_rsp_iocb *curr_entry;	/* next entry on queue */
 	void __iomem *valid_db_reg;	/* PCI doorbell mem area + 0x04 */
 
 	/* Large buffer queue elements. */
@@ -1487,7 +1487,7 @@ struct rx_ring {
 	char name[IFNAMSIZ + 5];
 	struct napi_struct napi;
 	u8 reserved;
-	struct ql_adapter *qdev;
+	struct qlge_adapter *qdev;
 	u64 rx_packets;
 	u64 rx_multicast;
 	u64 rx_bytes;
@@ -1752,14 +1752,14 @@ enum {
 #define SHADOW_OFFSET	0xb0000000
 #define SHADOW_REG_SHIFT	20
 
-struct ql_nic_misc {
+struct qlge_nic_misc {
 	u32 rx_ring_count;
 	u32 tx_ring_count;
 	u32 intr_count;
 	u32 function;
 };
 
-struct ql_reg_dump {
+struct qlge_reg_dump {
 	/* segment 0 */
 	struct mpi_coredump_global_header mpi_global_header;
 
@@ -1769,7 +1769,7 @@ struct ql_reg_dump {
 
 	/* segment 30 */
 	struct mpi_coredump_segment_header misc_nic_seg_hdr;
-	struct ql_nic_misc misc_nic_info;
+	struct qlge_nic_misc misc_nic_info;
 
 	/* segment 31 */
 	/* one interrupt state for each CQ */
@@ -1792,7 +1792,7 @@ struct ql_reg_dump {
 	u32 ets[8 + 2];
 };
 
-struct ql_mpi_coredump {
+struct qlge_mpi_coredump {
 	/* segment 0 */
 	struct mpi_coredump_global_header mpi_global_header;
 
@@ -1914,7 +1914,7 @@ struct ql_mpi_coredump {
 
 	/* segment 30 */
 	struct mpi_coredump_segment_header misc_nic_seg_hdr;
-	struct ql_nic_misc misc_nic_info;
+	struct qlge_nic_misc misc_nic_info;
 
 	/* segment 31 */
 	/* one interrupt state for each CQ */
@@ -1991,7 +1991,7 @@ struct ql_mpi_coredump {
  * irq environment as a context to the ISR.
  */
 struct intr_context {
-	struct ql_adapter *qdev;
+	struct qlge_adapter *qdev;
 	u32 intr;
 	u32 irq_mask;		/* Mask of which rings the vector services. */
 	u32 hooked;
@@ -2056,15 +2056,15 @@ enum {
 };
 
 struct nic_operations {
-	int (*get_flash)(struct ql_adapter *qdev);
-	int (*port_initialize)(struct ql_adapter *qdev);
+	int (*get_flash)(struct qlge_adapter *qdev);
+	int (*port_initialize)(struct qlge_adapter *qdev);
 };
 
 /*
  * The main Adapter structure definition.
  * This structure has all fields relevant to the hardware.
  */
-struct ql_adapter {
+struct qlge_adapter {
 	struct ricb ricb;
 	unsigned long flags;
 	u32 wol;
@@ -2139,7 +2139,7 @@ struct ql_adapter {
 	u32 port_link_up;
 	u32 port_init;
 	u32 link_status;
-	struct ql_mpi_coredump *mpi_coredump;
+	struct qlge_mpi_coredump *mpi_coredump;
 	u32 core_is_dumped;
 	u32 link_config;
 	u32 led_config;
@@ -2166,7 +2166,7 @@ struct ql_adapter {
 /*
  * Typical Register accessor for memory mapped device.
  */
-static inline u32 ql_read32(const struct ql_adapter *qdev, int reg)
+static inline u32 qlge_read32(const struct qlge_adapter *qdev, int reg)
 {
 	return readl(qdev->reg_base + reg);
 }
@@ -2174,7 +2174,7 @@ static inline u32 ql_read32(const struct ql_adapter *qdev, int reg)
 /*
  * Typical Register accessor for memory mapped device.
  */
-static inline void ql_write32(const struct ql_adapter *qdev, int reg, u32 val)
+static inline void qlge_write32(const struct qlge_adapter *qdev, int reg, u32 val)
 {
 	writel(val, qdev->reg_base + reg);
 }
@@ -2189,7 +2189,7 @@ static inline void ql_write32(const struct ql_adapter *qdev, int reg, u32 val)
  * 1 4k chunk of memory.  The lower half of the space is for outbound
  * queues. The upper half is for inbound queues.
  */
-static inline void ql_write_db_reg(u32 val, void __iomem *addr)
+static inline void qlge_write_db_reg(u32 val, void __iomem *addr)
 {
 	writel(val, addr);
 }
@@ -2205,7 +2205,7 @@ static inline void ql_write_db_reg(u32 val, void __iomem *addr)
  * queues. The upper half is for inbound queues.
  * Caller has to guarantee ordering.
  */
-static inline void ql_write_db_reg_relaxed(u32 val, void __iomem *addr)
+static inline void qlge_write_db_reg_relaxed(u32 val, void __iomem *addr)
 {
 	writel_relaxed(val, addr);
 }
@@ -2220,7 +2220,7 @@ static inline void ql_write_db_reg_relaxed(u32 val, void __iomem *addr)
  * update the relevant index register and then copy the value to the
  * shadow register in host memory.
  */
-static inline u32 ql_read_sh_reg(__le32  *addr)
+static inline u32 qlge_read_sh_reg(__le32  *addr)
 {
 	u32 reg;
 
@@ -2233,51 +2233,51 @@ extern char qlge_driver_name[];
 extern const char qlge_driver_version[];
 extern const struct ethtool_ops qlge_ethtool_ops;
 
-int ql_sem_spinlock(struct ql_adapter *qdev, u32 sem_mask);
-void ql_sem_unlock(struct ql_adapter *qdev, u32 sem_mask);
-int ql_read_xgmac_reg(struct ql_adapter *qdev, u32 reg, u32 *data);
-int ql_get_mac_addr_reg(struct ql_adapter *qdev, u32 type, u16 index,
-			u32 *value);
-int ql_get_routing_reg(struct ql_adapter *qdev, u32 index, u32 *value);
-int ql_write_cfg(struct ql_adapter *qdev, void *ptr, int size, u32 bit,
-		 u16 q_id);
-void ql_queue_fw_error(struct ql_adapter *qdev);
-void ql_mpi_work(struct work_struct *work);
-void ql_mpi_reset_work(struct work_struct *work);
-void ql_mpi_core_to_log(struct work_struct *work);
-int ql_wait_reg_rdy(struct ql_adapter *qdev, u32 reg, u32 bit, u32 ebit);
-void ql_queue_asic_error(struct ql_adapter *qdev);
-void ql_set_ethtool_ops(struct net_device *ndev);
-int ql_read_xgmac_reg64(struct ql_adapter *qdev, u32 reg, u64 *data);
-void ql_mpi_idc_work(struct work_struct *work);
-void ql_mpi_port_cfg_work(struct work_struct *work);
-int ql_mb_get_fw_state(struct ql_adapter *qdev);
-int ql_cam_route_initialize(struct ql_adapter *qdev);
-int ql_read_mpi_reg(struct ql_adapter *qdev, u32 reg, u32 *data);
-int ql_write_mpi_reg(struct ql_adapter *qdev, u32 reg, u32 data);
-int ql_unpause_mpi_risc(struct ql_adapter *qdev);
-int ql_pause_mpi_risc(struct ql_adapter *qdev);
-int ql_hard_reset_mpi_risc(struct ql_adapter *qdev);
-int ql_soft_reset_mpi_risc(struct ql_adapter *qdev);
-int ql_dump_risc_ram_area(struct ql_adapter *qdev, void *buf, u32 ram_addr,
-			  int word_count);
-int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump);
-int ql_mb_about_fw(struct ql_adapter *qdev);
-int ql_mb_wol_set_magic(struct ql_adapter *qdev, u32 enable_wol);
-int ql_mb_wol_mode(struct ql_adapter *qdev, u32 wol);
-int ql_mb_set_led_cfg(struct ql_adapter *qdev, u32 led_config);
-int ql_mb_get_led_cfg(struct ql_adapter *qdev);
-void ql_link_on(struct ql_adapter *qdev);
-void ql_link_off(struct ql_adapter *qdev);
-int ql_mb_set_mgmnt_traffic_ctl(struct ql_adapter *qdev, u32 control);
-int ql_mb_get_port_cfg(struct ql_adapter *qdev);
-int ql_mb_set_port_cfg(struct ql_adapter *qdev);
-int ql_wait_fifo_empty(struct ql_adapter *qdev);
-void ql_get_dump(struct ql_adapter *qdev, void *buff);
-netdev_tx_t ql_lb_send(struct sk_buff *skb, struct net_device *ndev);
-void ql_check_lb_frame(struct ql_adapter *qdev, struct sk_buff *skb);
-int ql_own_firmware(struct ql_adapter *qdev);
-int ql_clean_lb_rx_ring(struct rx_ring *rx_ring, int budget);
+int qlge_sem_spinlock(struct qlge_adapter *qdev, u32 sem_mask);
+void qlge_sem_unlock(struct qlge_adapter *qdev, u32 sem_mask);
+int qlge_read_xgmac_reg(struct qlge_adapter *qdev, u32 reg, u32 *data);
+int qlge_get_mac_addr_reg(struct qlge_adapter *qdev, u32 type, u16 index,
+			  u32 *value);
+int qlge_get_routing_reg(struct qlge_adapter *qdev, u32 index, u32 *value);
+int qlge_write_cfg(struct qlge_adapter *qdev, void *ptr, int size, u32 bit,
+		   u16 q_id);
+void qlge_queue_fw_error(struct qlge_adapter *qdev);
+void qlge_mpi_work(struct work_struct *work);
+void qlge_mpi_reset_work(struct work_struct *work);
+void qlge_mpi_core_to_log(struct work_struct *work);
+int qlge_wait_reg_rdy(struct qlge_adapter *qdev, u32 reg, u32 bit, u32 ebit);
+void qlge_queue_asic_error(struct qlge_adapter *qdev);
+void qlge_set_ethtool_ops(struct net_device *ndev);
+int qlge_read_xgmac_reg64(struct qlge_adapter *qdev, u32 reg, u64 *data);
+void qlge_mpi_idc_work(struct work_struct *work);
+void qlge_mpi_port_cfg_work(struct work_struct *work);
+int qlge_mb_get_fw_state(struct qlge_adapter *qdev);
+int qlge_cam_route_initialize(struct qlge_adapter *qdev);
+int qlge_read_mpi_reg(struct qlge_adapter *qdev, u32 reg, u32 *data);
+int qlge_write_mpi_reg(struct qlge_adapter *qdev, u32 reg, u32 data);
+int qlge_unpause_mpi_risc(struct qlge_adapter *qdev);
+int qlge_pause_mpi_risc(struct qlge_adapter *qdev);
+int qlge_hard_reset_mpi_risc(struct qlge_adapter *qdev);
+int qlge_soft_reset_mpi_risc(struct qlge_adapter *qdev);
+int qlge_dump_risc_ram_area(struct qlge_adapter *qdev, void *buf, u32 ram_addr,
+			    int word_count);
+int qlge_core_dump(struct qlge_adapter *qdev, struct qlge_mpi_coredump *mpi_coredump);
+int qlge_mb_about_fw(struct qlge_adapter *qdev);
+int qlge_mb_wol_set_magic(struct qlge_adapter *qdev, u32 enable_wol);
+int qlge_mb_wol_mode(struct qlge_adapter *qdev, u32 wol);
+int qlge_mb_set_led_cfg(struct qlge_adapter *qdev, u32 led_config);
+int qlge_mb_get_led_cfg(struct qlge_adapter *qdev);
+void qlge_link_on(struct qlge_adapter *qdev);
+void qlge_link_off(struct qlge_adapter *qdev);
+int qlge_mb_set_mgmnt_traffic_ctl(struct qlge_adapter *qdev, u32 control);
+int qlge_mb_get_port_cfg(struct qlge_adapter *qdev);
+int qlge_mb_set_port_cfg(struct qlge_adapter *qdev);
+int qlge_wait_fifo_empty(struct qlge_adapter *qdev);
+void qlge_get_dump(struct qlge_adapter *qdev, void *buff);
+netdev_tx_t qlge_lb_send(struct sk_buff *skb, struct net_device *ndev);
+void qlge_check_lb_frame(struct qlge_adapter *qdev, struct sk_buff *skb);
+int qlge_own_firmware(struct qlge_adapter *qdev);
+int qlge_clean_lb_rx_ring(struct rx_ring *rx_ring, int budget);
 
 /* #define QL_ALL_DUMP */
 /* #define QL_REG_DUMP */
@@ -2287,12 +2287,12 @@ int ql_clean_lb_rx_ring(struct rx_ring *rx_ring, int budget);
 /* #define QL_OB_DUMP */
 
 #ifdef QL_REG_DUMP
-void ql_dump_xgmac_control_regs(struct ql_adapter *qdev);
-void ql_dump_routing_entries(struct ql_adapter *qdev);
-void ql_dump_regs(struct ql_adapter *qdev);
-#define QL_DUMP_REGS(qdev) ql_dump_regs(qdev)
-#define QL_DUMP_ROUTE(qdev) ql_dump_routing_entries(qdev)
-#define QL_DUMP_XGMAC_CONTROL_REGS(qdev) ql_dump_xgmac_control_regs(qdev)
+void qlge_dump_xgmac_control_regs(struct qlge_adapter *qdev);
+void qlge_dump_routing_entries(struct qlge_adapter *qdev);
+void qlge_dump_regs(struct qlge_adapter *qdev);
+#define QL_DUMP_REGS(qdev) qlge_dump_regs(qdev)
+#define QL_DUMP_ROUTE(qdev) qlge_dump_routing_entries(qdev)
+#define QL_DUMP_XGMAC_CONTROL_REGS(qdev) qlge_dump_xgmac_control_regs(qdev)
 #else
 #define QL_DUMP_REGS(qdev)
 #define QL_DUMP_ROUTE(qdev)
@@ -2300,33 +2300,33 @@ void ql_dump_regs(struct ql_adapter *qdev);
 #endif
 
 #ifdef QL_STAT_DUMP
-void ql_dump_stat(struct ql_adapter *qdev);
-#define QL_DUMP_STAT(qdev) ql_dump_stat(qdev)
+void qlge_dump_stat(struct qlge_adapter *qdev);
+#define QL_DUMP_STAT(qdev) qlge_dump_stat(qdev)
 #else
 #define QL_DUMP_STAT(qdev)
 #endif
 
 #ifdef QL_DEV_DUMP
-void ql_dump_qdev(struct ql_adapter *qdev);
-#define QL_DUMP_QDEV(qdev) ql_dump_qdev(qdev)
+void qlge_dump_qdev(struct qlge_adapter *qdev);
+#define QL_DUMP_QDEV(qdev) qlge_dump_qdev(qdev)
 #else
 #define QL_DUMP_QDEV(qdev)
 #endif
 
 #ifdef QL_CB_DUMP
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
+void qlge_dump_wqicb(struct wqicb *wqicb);
+void qlge_dump_tx_ring(struct tx_ring *tx_ring);
+void qlge_dump_ricb(struct ricb *ricb);
+void qlge_dump_cqicb(struct cqicb *cqicb);
+void qlge_dump_rx_ring(struct rx_ring *rx_ring);
+void qlge_dump_hw_cb(struct qlge_adapter *qdev, int size, u32 bit, u16 q_id);
+#define QL_DUMP_RICB(ricb) qlge_dump_ricb(ricb)
+#define QL_DUMP_WQICB(wqicb) qlge_dump_wqicb(wqicb)
+#define QL_DUMP_TX_RING(tx_ring) qlge_dump_tx_ring(tx_ring)
+#define QL_DUMP_CQICB(cqicb) qlge_dump_cqicb(cqicb)
+#define QL_DUMP_RX_RING(rx_ring) qlge_dump_rx_ring(rx_ring)
 #define QL_DUMP_HW_CB(qdev, size, bit, q_id) \
-		ql_dump_hw_cb(qdev, size, bit, q_id)
+		qlge_dump_hw_cb(qdev, size, bit, q_id)
 #else
 #define QL_DUMP_RICB(ricb)
 #define QL_DUMP_WQICB(wqicb)
@@ -2337,26 +2337,26 @@ void ql_dump_hw_cb(struct ql_adapter *qdev, int size, u32 bit, u16 q_id);
 #endif
 
 #ifdef QL_OB_DUMP
-void ql_dump_tx_desc(struct ql_adapter *qdev, struct tx_buf_desc *tbd);
-void ql_dump_ob_mac_iocb(struct ql_adapter *qdev, struct ob_mac_iocb_req *ob_mac_iocb);
-void ql_dump_ob_mac_rsp(struct ql_adapter *qdev, struct ob_mac_iocb_rsp *ob_mac_rsp);
-#define QL_DUMP_OB_MAC_IOCB(qdev, ob_mac_iocb) ql_dump_ob_mac_iocb(qdev, ob_mac_iocb)
-#define QL_DUMP_OB_MAC_RSP(qdev, ob_mac_rsp) ql_dump_ob_mac_rsp(qdev, ob_mac_rsp)
+void qlge_dump_tx_desc(struct qlge_adapter *qdev, struct tx_buf_desc *tbd);
+void qlge_dump_ob_mac_iocb(struct qlge_adapter *qdev, struct qlge_ob_mac_iocb_req *ob_mac_iocb);
+void qlge_dump_ob_mac_rsp(struct qlge_adapter *qdev, struct qlge_ob_mac_iocb_rsp *ob_mac_rsp);
+#define QL_DUMP_OB_MAC_IOCB(qdev, ob_mac_iocb) qlge_dump_ob_mac_iocb(qdev, ob_mac_iocb)
+#define QL_DUMP_OB_MAC_RSP(qdev, ob_mac_rsp) qlge_dump_ob_mac_rsp(qdev, ob_mac_rsp)
 #else
 #define QL_DUMP_OB_MAC_IOCB(qdev, ob_mac_iocb)
 #define QL_DUMP_OB_MAC_RSP(qdev, ob_mac_rsp)
 #endif
 
 #ifdef QL_IB_DUMP
-void ql_dump_ib_mac_rsp(struct ql_adapter *qdev, struct ib_mac_iocb_rsp *ib_mac_rsp);
-#define QL_DUMP_IB_MAC_RSP(qdev, ib_mac_rsp) ql_dump_ib_mac_rsp(qdev, ib_mac_rsp)
+void qlge_dump_ib_mac_rsp(struct qlge_adapter *qdev, struct qlge_ib_mac_iocb_rsp *ib_mac_rsp);
+#define QL_DUMP_IB_MAC_RSP(qdev, ib_mac_rsp) qlge_dump_ib_mac_rsp(qdev, ib_mac_rsp)
 #else
 #define QL_DUMP_IB_MAC_RSP(qdev, ib_mac_rsp)
 #endif
 
 #ifdef	QL_ALL_DUMP
-void ql_dump_all(struct ql_adapter *qdev);
-#define QL_DUMP_ALL(qdev) ql_dump_all(qdev)
+void qlge_dump_all(struct qlge_adapter *qdev);
+#define QL_DUMP_ALL(qdev) qlge_dump_all(qdev)
 #else
 #define QL_DUMP_ALL(qdev)
 #endif
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 42fd13990f3a..b0d4ea071f32 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -6,8 +6,8 @@
 #include "qlge.h"
 
 /* Read a NIC register from the alternate function. */
-static u32 ql_read_other_func_reg(struct ql_adapter *qdev,
-				  u32 reg)
+static u32 qlge_read_other_func_reg(struct qlge_adapter *qdev,
+				    u32 reg)
 {
 	u32 register_to_read;
 	u32 reg_val;
@@ -17,7 +17,7 @@ static u32 ql_read_other_func_reg(struct ql_adapter *qdev,
 				| MPI_NIC_READ
 				| (qdev->alt_func << MPI_NIC_FUNCTION_SHIFT)
 				| reg;
-	status = ql_read_mpi_reg(qdev, register_to_read, &reg_val);
+	status = qlge_read_mpi_reg(qdev, register_to_read, &reg_val);
 	if (status != 0)
 		return 0xffffffff;
 
@@ -25,8 +25,8 @@ static u32 ql_read_other_func_reg(struct ql_adapter *qdev,
 }
 
 /* Write a NIC register from the alternate function. */
-static int ql_write_other_func_reg(struct ql_adapter *qdev,
-				   u32 reg, u32 reg_val)
+static int qlge_write_other_func_reg(struct qlge_adapter *qdev,
+				     u32 reg, u32 reg_val)
 {
 	u32 register_to_read;
 
@@ -35,17 +35,17 @@ static int ql_write_other_func_reg(struct ql_adapter *qdev,
 				| (qdev->alt_func << MPI_NIC_FUNCTION_SHIFT)
 				| reg;
 
-	return ql_write_mpi_reg(qdev, register_to_read, reg_val);
+	return qlge_write_mpi_reg(qdev, register_to_read, reg_val);
 }
 
-static int ql_wait_other_func_reg_rdy(struct ql_adapter *qdev, u32 reg,
-				      u32 bit, u32 err_bit)
+static int qlge_wait_other_func_reg_rdy(struct qlge_adapter *qdev, u32 reg,
+					u32 bit, u32 err_bit)
 {
 	u32 temp;
 	int count;
 
 	for (count = 10; count; count--) {
-		temp = ql_read_other_func_reg(qdev, reg);
+		temp = qlge_read_other_func_reg(qdev, reg);
 
 		/* check for errors */
 		if (temp & err_bit)
@@ -57,80 +57,80 @@ static int ql_wait_other_func_reg_rdy(struct ql_adapter *qdev, u32 reg,
 	return -1;
 }
 
-static int ql_read_other_func_serdes_reg(struct ql_adapter *qdev, u32 reg,
-					 u32 *data)
+static int qlge_read_other_func_serdes_reg(struct qlge_adapter *qdev, u32 reg,
+					   u32 *data)
 {
 	int status;
 
 	/* wait for reg to come ready */
-	status = ql_wait_other_func_reg_rdy(qdev, XG_SERDES_ADDR / 4,
-					    XG_SERDES_ADDR_RDY, 0);
+	status = qlge_wait_other_func_reg_rdy(qdev, XG_SERDES_ADDR / 4,
+					      XG_SERDES_ADDR_RDY, 0);
 	if (status)
 		goto exit;
 
 	/* set up for reg read */
-	ql_write_other_func_reg(qdev, XG_SERDES_ADDR / 4, reg | PROC_ADDR_R);
+	qlge_write_other_func_reg(qdev, XG_SERDES_ADDR / 4, reg | PROC_ADDR_R);
 
 	/* wait for reg to come ready */
-	status = ql_wait_other_func_reg_rdy(qdev, XG_SERDES_ADDR / 4,
-					    XG_SERDES_ADDR_RDY, 0);
+	status = qlge_wait_other_func_reg_rdy(qdev, XG_SERDES_ADDR / 4,
+					      XG_SERDES_ADDR_RDY, 0);
 	if (status)
 		goto exit;
 
 	/* get the data */
-	*data = ql_read_other_func_reg(qdev, (XG_SERDES_DATA / 4));
+	*data = qlge_read_other_func_reg(qdev, (XG_SERDES_DATA / 4));
 exit:
 	return status;
 }
 
 /* Read out the SERDES registers */
-static int ql_read_serdes_reg(struct ql_adapter *qdev, u32 reg, u32 *data)
+static int qlge_read_serdes_reg(struct qlge_adapter *qdev, u32 reg, u32 *data)
 {
 	int status;
 
 	/* wait for reg to come ready */
-	status = ql_wait_reg_rdy(qdev, XG_SERDES_ADDR, XG_SERDES_ADDR_RDY, 0);
+	status = qlge_wait_reg_rdy(qdev, XG_SERDES_ADDR, XG_SERDES_ADDR_RDY, 0);
 	if (status)
 		goto exit;
 
 	/* set up for reg read */
-	ql_write32(qdev, XG_SERDES_ADDR, reg | PROC_ADDR_R);
+	qlge_write32(qdev, XG_SERDES_ADDR, reg | PROC_ADDR_R);
 
 	/* wait for reg to come ready */
-	status = ql_wait_reg_rdy(qdev, XG_SERDES_ADDR, XG_SERDES_ADDR_RDY, 0);
+	status = qlge_wait_reg_rdy(qdev, XG_SERDES_ADDR, XG_SERDES_ADDR_RDY, 0);
 	if (status)
 		goto exit;
 
 	/* get the data */
-	*data = ql_read32(qdev, XG_SERDES_DATA);
+	*data = qlge_read32(qdev, XG_SERDES_DATA);
 exit:
 	return status;
 }
 
-static void ql_get_both_serdes(struct ql_adapter *qdev, u32 addr,
-			       u32 *direct_ptr, u32 *indirect_ptr,
-			       bool direct_valid, bool indirect_valid)
+static void qlge_get_both_serdes(struct qlge_adapter *qdev, u32 addr,
+				 u32 *direct_ptr, u32 *indirect_ptr,
+				 bool direct_valid, bool indirect_valid)
 {
 	unsigned int status;
 
 	status = 1;
 	if (direct_valid)
-		status = ql_read_serdes_reg(qdev, addr, direct_ptr);
+		status = qlge_read_serdes_reg(qdev, addr, direct_ptr);
 	/* Dead fill any failures or invalids. */
 	if (status)
 		*direct_ptr = 0xDEADBEEF;
 
 	status = 1;
 	if (indirect_valid)
-		status = ql_read_other_func_serdes_reg(
-						qdev, addr, indirect_ptr);
+		status = qlge_read_other_func_serdes_reg(qdev, addr,
+							 indirect_ptr);
 	/* Dead fill any failures or invalids. */
 	if (status)
 		*indirect_ptr = 0xDEADBEEF;
 }
 
-static int ql_get_serdes_regs(struct ql_adapter *qdev,
-			      struct ql_mpi_coredump *mpi_coredump)
+static int qlge_get_serdes_regs(struct qlge_adapter *qdev,
+				struct qlge_mpi_coredump *mpi_coredump)
 {
 	int status;
 	bool xfi_direct_valid = false, xfi_indirect_valid = false;
@@ -140,9 +140,9 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 	u32 *indirect_ptr;
 
 	/* The XAUI needs to be read out per port */
-	status = ql_read_other_func_serdes_reg(qdev,
-					       XG_SERDES_XAUI_HSS_PCS_START,
-					       &temp);
+	status = qlge_read_other_func_serdes_reg(qdev,
+						 XG_SERDES_XAUI_HSS_PCS_START,
+						 &temp);
 	if (status)
 		temp = XG_SERDES_ADDR_XAUI_PWR_DOWN;
 
@@ -150,7 +150,7 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 				XG_SERDES_ADDR_XAUI_PWR_DOWN)
 		xaui_indirect_valid = false;
 
-	status = ql_read_serdes_reg(qdev, XG_SERDES_XAUI_HSS_PCS_START, &temp);
+	status = qlge_read_serdes_reg(qdev, XG_SERDES_XAUI_HSS_PCS_START, &temp);
 
 	if (status)
 		temp = XG_SERDES_ADDR_XAUI_PWR_DOWN;
@@ -163,7 +163,7 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 	 * XFI register is shared so only need to read one
 	 * functions and then check the bits.
 	 */
-	status = ql_read_serdes_reg(qdev, XG_SERDES_ADDR_STS, &temp);
+	status = qlge_read_serdes_reg(qdev, XG_SERDES_ADDR_STS, &temp);
 	if (status)
 		temp = 0;
 
@@ -198,8 +198,8 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 	}
 
 	for (i = 0; i <= 0x000000034; i += 4, direct_ptr++, indirect_ptr++)
-		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
-				   xaui_direct_valid, xaui_indirect_valid);
+		qlge_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
+				     xaui_direct_valid, xaui_indirect_valid);
 
 	/* Get XAUI_HSS_PCS register block. */
 	if (qdev->func & 1) {
@@ -215,8 +215,8 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 	}
 
 	for (i = 0x800; i <= 0x880; i += 4, direct_ptr++, indirect_ptr++)
-		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
-				   xaui_direct_valid, xaui_indirect_valid);
+		qlge_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
+				     xaui_direct_valid, xaui_indirect_valid);
 
 	/* Get XAUI_XFI_AN register block. */
 	if (qdev->func & 1) {
@@ -228,8 +228,8 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 	}
 
 	for (i = 0x1000; i <= 0x1034; i += 4, direct_ptr++, indirect_ptr++)
-		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
-				   xfi_direct_valid, xfi_indirect_valid);
+		qlge_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
+				     xfi_direct_valid, xfi_indirect_valid);
 
 	/* Get XAUI_XFI_TRAIN register block. */
 	if (qdev->func & 1) {
@@ -243,8 +243,8 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 	}
 
 	for (i = 0x1050; i <= 0x107c; i += 4, direct_ptr++, indirect_ptr++)
-		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
-				   xfi_direct_valid, xfi_indirect_valid);
+		qlge_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
+				     xfi_direct_valid, xfi_indirect_valid);
 
 	/* Get XAUI_XFI_HSS_PCS register block. */
 	if (qdev->func & 1) {
@@ -260,8 +260,8 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 	}
 
 	for (i = 0x1800; i <= 0x1838; i += 4, direct_ptr++, indirect_ptr++)
-		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
-				   xfi_direct_valid, xfi_indirect_valid);
+		qlge_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
+				     xfi_direct_valid, xfi_indirect_valid);
 
 	/* Get XAUI_XFI_HSS_TX register block. */
 	if (qdev->func & 1) {
@@ -275,8 +275,8 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 			mpi_coredump->serdes2_xfi_hss_tx;
 	}
 	for (i = 0x1c00; i <= 0x1c1f; i++, direct_ptr++, indirect_ptr++)
-		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
-				   xfi_direct_valid, xfi_indirect_valid);
+		qlge_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
+				     xfi_direct_valid, xfi_indirect_valid);
 
 	/* Get XAUI_XFI_HSS_RX register block. */
 	if (qdev->func & 1) {
@@ -291,8 +291,8 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 	}
 
 	for (i = 0x1c40; i <= 0x1c5f; i++, direct_ptr++, indirect_ptr++)
-		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
-				   xfi_direct_valid, xfi_indirect_valid);
+		qlge_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
+				     xfi_direct_valid, xfi_indirect_valid);
 
 	/* Get XAUI_XFI_HSS_PLL register block. */
 	if (qdev->func & 1) {
@@ -307,33 +307,33 @@ static int ql_get_serdes_regs(struct ql_adapter *qdev,
 			mpi_coredump->serdes2_xfi_hss_pll;
 	}
 	for (i = 0x1e00; i <= 0x1e1f; i++, direct_ptr++, indirect_ptr++)
-		ql_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
-				   xfi_direct_valid, xfi_indirect_valid);
+		qlge_get_both_serdes(qdev, i, direct_ptr, indirect_ptr,
+				     xfi_direct_valid, xfi_indirect_valid);
 	return 0;
 }
 
-static int ql_read_other_func_xgmac_reg(struct ql_adapter *qdev, u32 reg,
-					u32 *data)
+static int qlge_read_other_func_xgmac_reg(struct qlge_adapter *qdev, u32 reg,
+					  u32 *data)
 {
 	int status = 0;
 
 	/* wait for reg to come ready */
-	status = ql_wait_other_func_reg_rdy(qdev, XGMAC_ADDR / 4,
-					    XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
+	status = qlge_wait_other_func_reg_rdy(qdev, XGMAC_ADDR / 4,
+					      XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
 	if (status)
 		goto exit;
 
 	/* set up for reg read */
-	ql_write_other_func_reg(qdev, XGMAC_ADDR / 4, reg | XGMAC_ADDR_R);
+	qlge_write_other_func_reg(qdev, XGMAC_ADDR / 4, reg | XGMAC_ADDR_R);
 
 	/* wait for reg to come ready */
-	status = ql_wait_other_func_reg_rdy(qdev, XGMAC_ADDR / 4,
-					    XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
+	status = qlge_wait_other_func_reg_rdy(qdev, XGMAC_ADDR / 4,
+					      XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
 	if (status)
 		goto exit;
 
 	/* get the data */
-	*data = ql_read_other_func_reg(qdev, XGMAC_DATA / 4);
+	*data = qlge_read_other_func_reg(qdev, XGMAC_DATA / 4);
 exit:
 	return status;
 }
@@ -341,8 +341,8 @@ static int ql_read_other_func_xgmac_reg(struct ql_adapter *qdev, u32 reg,
 /* Read the 400 xgmac control/statistics registers
  * skipping unused locations.
  */
-static int ql_get_xgmac_regs(struct ql_adapter *qdev, u32 *buf,
-			     unsigned int other_function)
+static int qlge_get_xgmac_regs(struct qlge_adapter *qdev, u32 *buf,
+			       unsigned int other_function)
 {
 	int status = 0;
 	int i;
@@ -370,9 +370,9 @@ static int ql_get_xgmac_regs(struct ql_adapter *qdev, u32 *buf,
 			(i > 0x000005c8 && i < 0x00000600)) {
 			if (other_function)
 				status =
-				ql_read_other_func_xgmac_reg(qdev, i, buf);
+				qlge_read_other_func_xgmac_reg(qdev, i, buf);
 			else
-				status = ql_read_xgmac_reg(qdev, i, buf);
+				status = qlge_read_xgmac_reg(qdev, i, buf);
 
 			if (status)
 				*buf = 0xdeadbeef;
@@ -382,46 +382,46 @@ static int ql_get_xgmac_regs(struct ql_adapter *qdev, u32 *buf,
 	return status;
 }
 
-static int ql_get_ets_regs(struct ql_adapter *qdev, u32 *buf)
+static int qlge_get_ets_regs(struct qlge_adapter *qdev, u32 *buf)
 {
 	int i;
 
 	for (i = 0; i < 8; i++, buf++) {
-		ql_write32(qdev, NIC_ETS, i << 29 | 0x08000000);
-		*buf = ql_read32(qdev, NIC_ETS);
+		qlge_write32(qdev, NIC_ETS, i << 29 | 0x08000000);
+		*buf = qlge_read32(qdev, NIC_ETS);
 	}
 
 	for (i = 0; i < 2; i++, buf++) {
-		ql_write32(qdev, CNA_ETS, i << 29 | 0x08000000);
-		*buf = ql_read32(qdev, CNA_ETS);
+		qlge_write32(qdev, CNA_ETS, i << 29 | 0x08000000);
+		*buf = qlge_read32(qdev, CNA_ETS);
 	}
 
 	return 0;
 }
 
-static void ql_get_intr_states(struct ql_adapter *qdev, u32 *buf)
+static void qlge_get_intr_states(struct qlge_adapter *qdev, u32 *buf)
 {
 	int i;
 
 	for (i = 0; i < qdev->rx_ring_count; i++, buf++) {
-		ql_write32(qdev, INTR_EN,
-			   qdev->intr_context[i].intr_read_mask);
-		*buf = ql_read32(qdev, INTR_EN);
+		qlge_write32(qdev, INTR_EN,
+			     qdev->intr_context[i].intr_read_mask);
+		*buf = qlge_read32(qdev, INTR_EN);
 	}
 }
 
-static int ql_get_cam_entries(struct ql_adapter *qdev, u32 *buf)
+static int qlge_get_cam_entries(struct qlge_adapter *qdev, u32 *buf)
 {
 	int i, status;
 	u32 value[3];
 
-	status = ql_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
+	status = qlge_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
 	if (status)
 		return status;
 
 	for (i = 0; i < 16; i++) {
-		status = ql_get_mac_addr_reg(qdev,
-					     MAC_ADDR_TYPE_CAM_MAC, i, value);
+		status = qlge_get_mac_addr_reg(qdev,
+					       MAC_ADDR_TYPE_CAM_MAC, i, value);
 		if (status) {
 			netif_err(qdev, drv, qdev->ndev,
 				  "Failed read of mac index register\n");
@@ -432,8 +432,8 @@ static int ql_get_cam_entries(struct ql_adapter *qdev, u32 *buf)
 		*buf++ = value[2];	/* output */
 	}
 	for (i = 0; i < 32; i++) {
-		status = ql_get_mac_addr_reg(qdev,
-					     MAC_ADDR_TYPE_MULTI_MAC, i, value);
+		status = qlge_get_mac_addr_reg(qdev, MAC_ADDR_TYPE_MULTI_MAC,
+					       i, value);
 		if (status) {
 			netif_err(qdev, drv, qdev->ndev,
 				  "Failed read of mac index register\n");
@@ -443,21 +443,21 @@ static int ql_get_cam_entries(struct ql_adapter *qdev, u32 *buf)
 		*buf++ = value[1];	/* upper Mcast address */
 	}
 err:
-	ql_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
+	qlge_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
 	return status;
 }
 
-static int ql_get_routing_entries(struct ql_adapter *qdev, u32 *buf)
+static int qlge_get_routing_entries(struct qlge_adapter *qdev, u32 *buf)
 {
 	int status;
 	u32 value, i;
 
-	status = ql_sem_spinlock(qdev, SEM_RT_IDX_MASK);
+	status = qlge_sem_spinlock(qdev, SEM_RT_IDX_MASK);
 	if (status)
 		return status;
 
 	for (i = 0; i < 16; i++) {
-		status = ql_get_routing_reg(qdev, i, &value);
+		status = qlge_get_routing_reg(qdev, i, &value);
 		if (status) {
 			netif_err(qdev, drv, qdev->ndev,
 				  "Failed read of routing index register\n");
@@ -467,23 +467,23 @@ static int ql_get_routing_entries(struct ql_adapter *qdev, u32 *buf)
 		}
 	}
 err:
-	ql_sem_unlock(qdev, SEM_RT_IDX_MASK);
+	qlge_sem_unlock(qdev, SEM_RT_IDX_MASK);
 	return status;
 }
 
 /* Read the MPI Processor shadow registers */
-static int ql_get_mpi_shadow_regs(struct ql_adapter *qdev, u32 *buf)
+static int qlge_get_mpi_shadow_regs(struct qlge_adapter *qdev, u32 *buf)
 {
 	u32 i;
 	int status;
 
 	for (i = 0; i < MPI_CORE_SH_REGS_CNT; i++, buf++) {
-		status = ql_write_mpi_reg(qdev,
-					  RISC_124,
-				(SHADOW_OFFSET | i << SHADOW_REG_SHIFT));
+		status = qlge_write_mpi_reg(qdev,
+					    RISC_124,
+					    (SHADOW_OFFSET | i << SHADOW_REG_SHIFT));
 		if (status)
 			goto end;
-		status = ql_read_mpi_reg(qdev, RISC_127, buf);
+		status = qlge_read_mpi_reg(qdev, RISC_127, buf);
 		if (status)
 			goto end;
 	}
@@ -492,13 +492,13 @@ static int ql_get_mpi_shadow_regs(struct ql_adapter *qdev, u32 *buf)
 }
 
 /* Read the MPI Processor core registers */
-static int ql_get_mpi_regs(struct ql_adapter *qdev, u32 *buf,
-			   u32 offset, u32 count)
+static int qlge_get_mpi_regs(struct qlge_adapter *qdev, u32 *buf,
+			     u32 offset, u32 count)
 {
 	int i, status = 0;
 
 	for (i = 0; i < count; i++, buf++) {
-		status = ql_read_mpi_reg(qdev, offset + i, buf);
+		status = qlge_read_mpi_reg(qdev, offset + i, buf);
 		if (status)
 			return status;
 	}
@@ -506,8 +506,8 @@ static int ql_get_mpi_regs(struct ql_adapter *qdev, u32 *buf,
 }
 
 /* Read the ASIC probe dump */
-static unsigned int *ql_get_probe(struct ql_adapter *qdev, u32 clock,
-				  u32 valid, u32 *buf)
+static unsigned int *qlge_get_probe(struct qlge_adapter *qdev, u32 clock,
+				    u32 valid, u32 *buf)
 {
 	u32 module, mux_sel, probe, lo_val, hi_val;
 
@@ -519,15 +519,15 @@ static unsigned int *ql_get_probe(struct ql_adapter *qdev, u32 clock,
 				| PRB_MX_ADDR_ARE
 				| mux_sel
 				| (module << PRB_MX_ADDR_MOD_SEL_SHIFT);
-			ql_write32(qdev, PRB_MX_ADDR, probe);
-			lo_val = ql_read32(qdev, PRB_MX_DATA);
+			qlge_write32(qdev, PRB_MX_ADDR, probe);
+			lo_val = qlge_read32(qdev, PRB_MX_DATA);
 			if (mux_sel == 0) {
 				*buf = probe;
 				buf++;
 			}
 			probe |= PRB_MX_ADDR_UP;
-			ql_write32(qdev, PRB_MX_ADDR, probe);
-			hi_val = ql_read32(qdev, PRB_MX_DATA);
+			qlge_write32(qdev, PRB_MX_ADDR, probe);
+			hi_val = qlge_read32(qdev, PRB_MX_DATA);
 			*buf = lo_val;
 			buf++;
 			*buf = hi_val;
@@ -537,23 +537,23 @@ static unsigned int *ql_get_probe(struct ql_adapter *qdev, u32 clock,
 	return buf;
 }
 
-static int ql_get_probe_dump(struct ql_adapter *qdev, unsigned int *buf)
+static int qlge_get_probe_dump(struct qlge_adapter *qdev, unsigned int *buf)
 {
 	/* First we have to enable the probe mux */
-	ql_write_mpi_reg(qdev, MPI_TEST_FUNC_PRB_CTL, MPI_TEST_FUNC_PRB_EN);
-	buf = ql_get_probe(qdev, PRB_MX_ADDR_SYS_CLOCK,
-			   PRB_MX_ADDR_VALID_SYS_MOD, buf);
-	buf = ql_get_probe(qdev, PRB_MX_ADDR_PCI_CLOCK,
-			   PRB_MX_ADDR_VALID_PCI_MOD, buf);
-	buf = ql_get_probe(qdev, PRB_MX_ADDR_XGM_CLOCK,
-			   PRB_MX_ADDR_VALID_XGM_MOD, buf);
-	buf = ql_get_probe(qdev, PRB_MX_ADDR_FC_CLOCK,
-			   PRB_MX_ADDR_VALID_FC_MOD, buf);
+	qlge_write_mpi_reg(qdev, MPI_TEST_FUNC_PRB_CTL, MPI_TEST_FUNC_PRB_EN);
+	buf = qlge_get_probe(qdev, PRB_MX_ADDR_SYS_CLOCK,
+			     PRB_MX_ADDR_VALID_SYS_MOD, buf);
+	buf = qlge_get_probe(qdev, PRB_MX_ADDR_PCI_CLOCK,
+			     PRB_MX_ADDR_VALID_PCI_MOD, buf);
+	buf = qlge_get_probe(qdev, PRB_MX_ADDR_XGM_CLOCK,
+			     PRB_MX_ADDR_VALID_XGM_MOD, buf);
+	buf = qlge_get_probe(qdev, PRB_MX_ADDR_FC_CLOCK,
+			     PRB_MX_ADDR_VALID_FC_MOD, buf);
 	return 0;
 }
 
 /* Read out the routing index registers */
-static int ql_get_routing_index_registers(struct ql_adapter *qdev, u32 *buf)
+static int qlge_get_routing_index_registers(struct qlge_adapter *qdev, u32 *buf)
 {
 	int status;
 	u32 type, index, index_max;
@@ -561,7 +561,7 @@ static int ql_get_routing_index_registers(struct ql_adapter *qdev, u32 *buf)
 	u32 result_data;
 	u32 val;
 
-	status = ql_sem_spinlock(qdev, SEM_RT_IDX_MASK);
+	status = qlge_sem_spinlock(qdev, SEM_RT_IDX_MASK);
 	if (status)
 		return status;
 
@@ -574,11 +574,11 @@ static int ql_get_routing_index_registers(struct ql_adapter *qdev, u32 *buf)
 			val = RT_IDX_RS
 				| (type << RT_IDX_TYPE_SHIFT)
 				| (index << RT_IDX_IDX_SHIFT);
-			ql_write32(qdev, RT_IDX, val);
+			qlge_write32(qdev, RT_IDX, val);
 			result_index = 0;
 			while ((result_index & RT_IDX_MR) == 0)
-				result_index = ql_read32(qdev, RT_IDX);
-			result_data = ql_read32(qdev, RT_DATA);
+				result_index = qlge_read32(qdev, RT_IDX);
+			result_data = qlge_read32(qdev, RT_DATA);
 			*buf = type;
 			buf++;
 			*buf = index;
@@ -589,12 +589,12 @@ static int ql_get_routing_index_registers(struct ql_adapter *qdev, u32 *buf)
 			buf++;
 		}
 	}
-	ql_sem_unlock(qdev, SEM_RT_IDX_MASK);
+	qlge_sem_unlock(qdev, SEM_RT_IDX_MASK);
 	return status;
 }
 
 /* Read out the MAC protocol registers */
-static void ql_get_mac_protocol_registers(struct ql_adapter *qdev, u32 *buf)
+static void qlge_get_mac_protocol_registers(struct qlge_adapter *qdev, u32 *buf)
 {
 	u32 result_index, result_data;
 	u32 type;
@@ -657,13 +657,13 @@ static void ql_get_mac_protocol_registers(struct ql_adapter *qdev, u32 *buf)
 					| (type << MAC_ADDR_TYPE_SHIFT)
 					| (index << MAC_ADDR_IDX_SHIFT)
 					| (offset);
-				ql_write32(qdev, MAC_ADDR_IDX, val);
+				qlge_write32(qdev, MAC_ADDR_IDX, val);
 				result_index = 0;
 				while ((result_index & MAC_ADDR_MR) == 0) {
-					result_index = ql_read32(qdev,
-								 MAC_ADDR_IDX);
+					result_index = qlge_read32(qdev,
+								   MAC_ADDR_IDX);
 				}
-				result_data = ql_read32(qdev, MAC_ADDR_DATA);
+				result_data = qlge_read32(qdev, MAC_ADDR_DATA);
 				*buf = result_index;
 				buf++;
 				*buf = result_data;
@@ -673,7 +673,7 @@ static void ql_get_mac_protocol_registers(struct ql_adapter *qdev, u32 *buf)
 	}
 }
 
-static void ql_get_sem_registers(struct ql_adapter *qdev, u32 *buf)
+static void qlge_get_sem_registers(struct qlge_adapter *qdev, u32 *buf)
 {
 	u32 func_num, reg, reg_val;
 	int status;
@@ -682,7 +682,7 @@ static void ql_get_sem_registers(struct ql_adapter *qdev, u32 *buf)
 		reg = MPI_NIC_REG_BLOCK
 			| (func_num << MPI_NIC_FUNCTION_SHIFT)
 			| (SEM / 4);
-		status = ql_read_mpi_reg(qdev, reg, &reg_val);
+		status = qlge_read_mpi_reg(qdev, reg, &reg_val);
 		*buf = reg_val;
 		/* if the read failed then dead fill the element. */
 		if (!status)
@@ -692,9 +692,8 @@ static void ql_get_sem_registers(struct ql_adapter *qdev, u32 *buf)
 }
 
 /* Create a coredump segment header */
-static void ql_build_coredump_seg_header(
-		struct mpi_coredump_segment_header *seg_hdr,
-		u32 seg_number, u32 seg_size, u8 *desc)
+static void qlge_build_coredump_seg_header(struct mpi_coredump_segment_header *seg_hdr,
+					   u32 seg_number, u32 seg_size, u8 *desc)
 {
 	memset(seg_hdr, 0, sizeof(struct mpi_coredump_segment_header));
 	seg_hdr->cookie = MPI_COREDUMP_COOKIE;
@@ -710,7 +709,7 @@ static void ql_build_coredump_seg_header(
  * space for this function as well as a coredump structure that
  * will contain the dump.
  */
-int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
+int qlge_core_dump(struct qlge_adapter *qdev, struct qlge_mpi_coredump *mpi_coredump)
 {
 	int status;
 	int i;
@@ -724,9 +723,9 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 	 * it isn't available.  If the firmware died it
 	 * might be holding the sem.
 	 */
-	ql_sem_spinlock(qdev, SEM_PROC_REG_MASK);
+	qlge_sem_spinlock(qdev, SEM_PROC_REG_MASK);
 
-	status = ql_pause_mpi_risc(qdev);
+	status = qlge_pause_mpi_risc(qdev);
 	if (status) {
 		netif_err(qdev, drv, qdev->ndev,
 			  "Failed RISC pause. Status = 0x%.08x\n", status);
@@ -740,155 +739,155 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 	mpi_coredump->mpi_global_header.header_size =
 		sizeof(struct mpi_coredump_global_header);
 	mpi_coredump->mpi_global_header.image_size =
-		sizeof(struct ql_mpi_coredump);
+		sizeof(struct qlge_mpi_coredump);
 	strncpy(mpi_coredump->mpi_global_header.id_string, "MPI Coredump",
 		sizeof(mpi_coredump->mpi_global_header.id_string));
 
 	/* Get generic NIC reg dump */
-	ql_build_coredump_seg_header(&mpi_coredump->nic_regs_seg_hdr,
-				     NIC1_CONTROL_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->nic_regs), "NIC1 Registers");
+	qlge_build_coredump_seg_header(&mpi_coredump->nic_regs_seg_hdr,
+				       NIC1_CONTROL_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->nic_regs), "NIC1 Registers");
 
-	ql_build_coredump_seg_header(&mpi_coredump->nic2_regs_seg_hdr,
-				     NIC2_CONTROL_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->nic2_regs), "NIC2 Registers");
+	qlge_build_coredump_seg_header(&mpi_coredump->nic2_regs_seg_hdr,
+				       NIC2_CONTROL_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->nic2_regs), "NIC2 Registers");
 
 	/* Get XGMac registers. (Segment 18, Rev C. step 21) */
-	ql_build_coredump_seg_header(&mpi_coredump->xgmac1_seg_hdr,
-				     NIC1_XGMAC_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->xgmac1), "NIC1 XGMac Registers");
+	qlge_build_coredump_seg_header(&mpi_coredump->xgmac1_seg_hdr,
+				       NIC1_XGMAC_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->xgmac1), "NIC1 XGMac Registers");
 
-	ql_build_coredump_seg_header(&mpi_coredump->xgmac2_seg_hdr,
-				     NIC2_XGMAC_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->xgmac2), "NIC2 XGMac Registers");
+	qlge_build_coredump_seg_header(&mpi_coredump->xgmac2_seg_hdr,
+				       NIC2_XGMAC_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->xgmac2), "NIC2 XGMac Registers");
 
 	if (qdev->func & 1) {
 		/* Odd means our function is NIC 2 */
 		for (i = 0; i < NIC_REGS_DUMP_WORD_COUNT; i++)
 			mpi_coredump->nic2_regs[i] =
-					 ql_read32(qdev, i * sizeof(u32));
+				qlge_read32(qdev, i * sizeof(u32));
 
 		for (i = 0; i < NIC_REGS_DUMP_WORD_COUNT; i++)
 			mpi_coredump->nic_regs[i] =
-			ql_read_other_func_reg(qdev, (i * sizeof(u32)) / 4);
+				qlge_read_other_func_reg(qdev, (i * sizeof(u32)) / 4);
 
-		ql_get_xgmac_regs(qdev, &mpi_coredump->xgmac2[0], 0);
-		ql_get_xgmac_regs(qdev, &mpi_coredump->xgmac1[0], 1);
+		qlge_get_xgmac_regs(qdev, &mpi_coredump->xgmac2[0], 0);
+		qlge_get_xgmac_regs(qdev, &mpi_coredump->xgmac1[0], 1);
 	} else {
 		/* Even means our function is NIC 1 */
 		for (i = 0; i < NIC_REGS_DUMP_WORD_COUNT; i++)
 			mpi_coredump->nic_regs[i] =
-					ql_read32(qdev, i * sizeof(u32));
+				qlge_read32(qdev, i * sizeof(u32));
 		for (i = 0; i < NIC_REGS_DUMP_WORD_COUNT; i++)
 			mpi_coredump->nic2_regs[i] =
-			ql_read_other_func_reg(qdev, (i * sizeof(u32)) / 4);
+				qlge_read_other_func_reg(qdev, (i * sizeof(u32)) / 4);
 
-		ql_get_xgmac_regs(qdev, &mpi_coredump->xgmac1[0], 0);
-		ql_get_xgmac_regs(qdev, &mpi_coredump->xgmac2[0], 1);
+		qlge_get_xgmac_regs(qdev, &mpi_coredump->xgmac1[0], 0);
+		qlge_get_xgmac_regs(qdev, &mpi_coredump->xgmac2[0], 1);
 	}
 
 	/* Rev C. Step 20a */
-	ql_build_coredump_seg_header(&mpi_coredump->xaui_an_hdr,
-				     XAUI_AN_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->serdes_xaui_an),
-			"XAUI AN Registers");
+	qlge_build_coredump_seg_header(&mpi_coredump->xaui_an_hdr,
+				       XAUI_AN_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->serdes_xaui_an),
+				       "XAUI AN Registers");
 
 	/* Rev C. Step 20b */
-	ql_build_coredump_seg_header(&mpi_coredump->xaui_hss_pcs_hdr,
-				     XAUI_HSS_PCS_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->serdes_xaui_hss_pcs),
-			"XAUI HSS PCS Registers");
-
-	ql_build_coredump_seg_header(&mpi_coredump->xfi_an_hdr, XFI_AN_SEG_NUM,
-				     sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->serdes_xfi_an),
-			"XFI AN Registers");
-
-	ql_build_coredump_seg_header(&mpi_coredump->xfi_train_hdr,
-				     XFI_TRAIN_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->serdes_xfi_train),
-			"XFI TRAIN Registers");
-
-	ql_build_coredump_seg_header(&mpi_coredump->xfi_hss_pcs_hdr,
-				     XFI_HSS_PCS_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->serdes_xfi_hss_pcs),
-			"XFI HSS PCS Registers");
-
-	ql_build_coredump_seg_header(&mpi_coredump->xfi_hss_tx_hdr,
-				     XFI_HSS_TX_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->serdes_xfi_hss_tx),
-			"XFI HSS TX Registers");
-
-	ql_build_coredump_seg_header(&mpi_coredump->xfi_hss_rx_hdr,
-				     XFI_HSS_RX_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->serdes_xfi_hss_rx),
-			"XFI HSS RX Registers");
-
-	ql_build_coredump_seg_header(&mpi_coredump->xfi_hss_pll_hdr,
-				     XFI_HSS_PLL_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->serdes_xfi_hss_pll),
-			"XFI HSS PLL Registers");
-
-	ql_build_coredump_seg_header(&mpi_coredump->xaui2_an_hdr,
-				     XAUI2_AN_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->serdes2_xaui_an),
-			"XAUI2 AN Registers");
-
-	ql_build_coredump_seg_header(&mpi_coredump->xaui2_hss_pcs_hdr,
-				     XAUI2_HSS_PCS_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->serdes2_xaui_hss_pcs),
-			"XAUI2 HSS PCS Registers");
-
-	ql_build_coredump_seg_header(&mpi_coredump->xfi2_an_hdr,
-				     XFI2_AN_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->serdes2_xfi_an),
-			"XFI2 AN Registers");
-
-	ql_build_coredump_seg_header(&mpi_coredump->xfi2_train_hdr,
-				     XFI2_TRAIN_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->serdes2_xfi_train),
-			"XFI2 TRAIN Registers");
-
-	ql_build_coredump_seg_header(&mpi_coredump->xfi2_hss_pcs_hdr,
-				     XFI2_HSS_PCS_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->serdes2_xfi_hss_pcs),
-			"XFI2 HSS PCS Registers");
-
-	ql_build_coredump_seg_header(&mpi_coredump->xfi2_hss_tx_hdr,
-				     XFI2_HSS_TX_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->serdes2_xfi_hss_tx),
-			"XFI2 HSS TX Registers");
-
-	ql_build_coredump_seg_header(&mpi_coredump->xfi2_hss_rx_hdr,
-				     XFI2_HSS_RX_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->serdes2_xfi_hss_rx),
-			"XFI2 HSS RX Registers");
-
-	ql_build_coredump_seg_header(&mpi_coredump->xfi2_hss_pll_hdr,
-				     XFI2_HSS_PLL_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->serdes2_xfi_hss_pll),
-			"XFI2 HSS PLL Registers");
-
-	status = ql_get_serdes_regs(qdev, mpi_coredump);
+	qlge_build_coredump_seg_header(&mpi_coredump->xaui_hss_pcs_hdr,
+				       XAUI_HSS_PCS_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->serdes_xaui_hss_pcs),
+				       "XAUI HSS PCS Registers");
+
+	qlge_build_coredump_seg_header(&mpi_coredump->xfi_an_hdr, XFI_AN_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->serdes_xfi_an),
+				       "XFI AN Registers");
+
+	qlge_build_coredump_seg_header(&mpi_coredump->xfi_train_hdr,
+				       XFI_TRAIN_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->serdes_xfi_train),
+				       "XFI TRAIN Registers");
+
+	qlge_build_coredump_seg_header(&mpi_coredump->xfi_hss_pcs_hdr,
+				       XFI_HSS_PCS_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->serdes_xfi_hss_pcs),
+				       "XFI HSS PCS Registers");
+
+	qlge_build_coredump_seg_header(&mpi_coredump->xfi_hss_tx_hdr,
+				       XFI_HSS_TX_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->serdes_xfi_hss_tx),
+				       "XFI HSS TX Registers");
+
+	qlge_build_coredump_seg_header(&mpi_coredump->xfi_hss_rx_hdr,
+				       XFI_HSS_RX_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->serdes_xfi_hss_rx),
+				       "XFI HSS RX Registers");
+
+	qlge_build_coredump_seg_header(&mpi_coredump->xfi_hss_pll_hdr,
+				       XFI_HSS_PLL_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->serdes_xfi_hss_pll),
+				       "XFI HSS PLL Registers");
+
+	qlge_build_coredump_seg_header(&mpi_coredump->xaui2_an_hdr,
+				       XAUI2_AN_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->serdes2_xaui_an),
+				       "XAUI2 AN Registers");
+
+	qlge_build_coredump_seg_header(&mpi_coredump->xaui2_hss_pcs_hdr,
+				       XAUI2_HSS_PCS_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->serdes2_xaui_hss_pcs),
+				       "XAUI2 HSS PCS Registers");
+
+	qlge_build_coredump_seg_header(&mpi_coredump->xfi2_an_hdr,
+				       XFI2_AN_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->serdes2_xfi_an),
+				       "XFI2 AN Registers");
+
+	qlge_build_coredump_seg_header(&mpi_coredump->xfi2_train_hdr,
+				       XFI2_TRAIN_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->serdes2_xfi_train),
+				       "XFI2 TRAIN Registers");
+
+	qlge_build_coredump_seg_header(&mpi_coredump->xfi2_hss_pcs_hdr,
+				       XFI2_HSS_PCS_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->serdes2_xfi_hss_pcs),
+				       "XFI2 HSS PCS Registers");
+
+	qlge_build_coredump_seg_header(&mpi_coredump->xfi2_hss_tx_hdr,
+				       XFI2_HSS_TX_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->serdes2_xfi_hss_tx),
+				       "XFI2 HSS TX Registers");
+
+	qlge_build_coredump_seg_header(&mpi_coredump->xfi2_hss_rx_hdr,
+				       XFI2_HSS_RX_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->serdes2_xfi_hss_rx),
+				       "XFI2 HSS RX Registers");
+
+	qlge_build_coredump_seg_header(&mpi_coredump->xfi2_hss_pll_hdr,
+				       XFI2_HSS_PLL_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->serdes2_xfi_hss_pll),
+				       "XFI2 HSS PLL Registers");
+
+	status = qlge_get_serdes_regs(qdev, mpi_coredump);
 	if (status) {
 		netif_err(qdev, drv, qdev->ndev,
 			  "Failed Dump of Serdes Registers. Status = 0x%.08x\n",
@@ -896,185 +895,185 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 		goto err;
 	}
 
-	ql_build_coredump_seg_header(&mpi_coredump->core_regs_seg_hdr,
-				     CORE_SEG_NUM,
-				sizeof(mpi_coredump->core_regs_seg_hdr) +
-				sizeof(mpi_coredump->mpi_core_regs) +
-				sizeof(mpi_coredump->mpi_core_sh_regs),
-				"Core Registers");
+	qlge_build_coredump_seg_header(&mpi_coredump->core_regs_seg_hdr,
+				       CORE_SEG_NUM,
+				       sizeof(mpi_coredump->core_regs_seg_hdr) +
+				       sizeof(mpi_coredump->mpi_core_regs) +
+				       sizeof(mpi_coredump->mpi_core_sh_regs),
+				       "Core Registers");
 
 	/* Get the MPI Core Registers */
-	status = ql_get_mpi_regs(qdev, &mpi_coredump->mpi_core_regs[0],
-				 MPI_CORE_REGS_ADDR, MPI_CORE_REGS_CNT);
+	status = qlge_get_mpi_regs(qdev, &mpi_coredump->mpi_core_regs[0],
+				   MPI_CORE_REGS_ADDR, MPI_CORE_REGS_CNT);
 	if (status)
 		goto err;
 	/* Get the 16 MPI shadow registers */
-	status = ql_get_mpi_shadow_regs(qdev,
-					&mpi_coredump->mpi_core_sh_regs[0]);
+	status = qlge_get_mpi_shadow_regs(qdev,
+					  &mpi_coredump->mpi_core_sh_regs[0]);
 	if (status)
 		goto err;
 
 	/* Get the Test Logic Registers */
-	ql_build_coredump_seg_header(&mpi_coredump->test_logic_regs_seg_hdr,
-				     TEST_LOGIC_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->test_logic_regs),
-				"Test Logic Regs");
-	status = ql_get_mpi_regs(qdev, &mpi_coredump->test_logic_regs[0],
-				 TEST_REGS_ADDR, TEST_REGS_CNT);
+	qlge_build_coredump_seg_header(&mpi_coredump->test_logic_regs_seg_hdr,
+				       TEST_LOGIC_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->test_logic_regs),
+				       "Test Logic Regs");
+	status = qlge_get_mpi_regs(qdev, &mpi_coredump->test_logic_regs[0],
+				   TEST_REGS_ADDR, TEST_REGS_CNT);
 	if (status)
 		goto err;
 
 	/* Get the RMII Registers */
-	ql_build_coredump_seg_header(&mpi_coredump->rmii_regs_seg_hdr,
-				     RMII_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->rmii_regs),
-				"RMII Registers");
-	status = ql_get_mpi_regs(qdev, &mpi_coredump->rmii_regs[0],
-				 RMII_REGS_ADDR, RMII_REGS_CNT);
+	qlge_build_coredump_seg_header(&mpi_coredump->rmii_regs_seg_hdr,
+				       RMII_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->rmii_regs),
+				       "RMII Registers");
+	status = qlge_get_mpi_regs(qdev, &mpi_coredump->rmii_regs[0],
+				   RMII_REGS_ADDR, RMII_REGS_CNT);
 	if (status)
 		goto err;
 
 	/* Get the FCMAC1 Registers */
-	ql_build_coredump_seg_header(&mpi_coredump->fcmac1_regs_seg_hdr,
-				     FCMAC1_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->fcmac1_regs),
-				"FCMAC1 Registers");
-	status = ql_get_mpi_regs(qdev, &mpi_coredump->fcmac1_regs[0],
-				 FCMAC1_REGS_ADDR, FCMAC_REGS_CNT);
+	qlge_build_coredump_seg_header(&mpi_coredump->fcmac1_regs_seg_hdr,
+				       FCMAC1_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->fcmac1_regs),
+				       "FCMAC1 Registers");
+	status = qlge_get_mpi_regs(qdev, &mpi_coredump->fcmac1_regs[0],
+				   FCMAC1_REGS_ADDR, FCMAC_REGS_CNT);
 	if (status)
 		goto err;
 
 	/* Get the FCMAC2 Registers */
 
-	ql_build_coredump_seg_header(&mpi_coredump->fcmac2_regs_seg_hdr,
-				     FCMAC2_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->fcmac2_regs),
-				"FCMAC2 Registers");
+	qlge_build_coredump_seg_header(&mpi_coredump->fcmac2_regs_seg_hdr,
+				       FCMAC2_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->fcmac2_regs),
+				       "FCMAC2 Registers");
 
-	status = ql_get_mpi_regs(qdev, &mpi_coredump->fcmac2_regs[0],
-				 FCMAC2_REGS_ADDR, FCMAC_REGS_CNT);
+	status = qlge_get_mpi_regs(qdev, &mpi_coredump->fcmac2_regs[0],
+				   FCMAC2_REGS_ADDR, FCMAC_REGS_CNT);
 	if (status)
 		goto err;
 
 	/* Get the FC1 MBX Registers */
-	ql_build_coredump_seg_header(&mpi_coredump->fc1_mbx_regs_seg_hdr,
-				     FC1_MBOX_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->fc1_mbx_regs),
-				"FC1 MBox Regs");
-	status = ql_get_mpi_regs(qdev, &mpi_coredump->fc1_mbx_regs[0],
-				 FC1_MBX_REGS_ADDR, FC_MBX_REGS_CNT);
+	qlge_build_coredump_seg_header(&mpi_coredump->fc1_mbx_regs_seg_hdr,
+				       FC1_MBOX_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->fc1_mbx_regs),
+				       "FC1 MBox Regs");
+	status = qlge_get_mpi_regs(qdev, &mpi_coredump->fc1_mbx_regs[0],
+				   FC1_MBX_REGS_ADDR, FC_MBX_REGS_CNT);
 	if (status)
 		goto err;
 
 	/* Get the IDE Registers */
-	ql_build_coredump_seg_header(&mpi_coredump->ide_regs_seg_hdr,
-				     IDE_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->ide_regs),
-				"IDE Registers");
-	status = ql_get_mpi_regs(qdev, &mpi_coredump->ide_regs[0],
-				 IDE_REGS_ADDR, IDE_REGS_CNT);
+	qlge_build_coredump_seg_header(&mpi_coredump->ide_regs_seg_hdr,
+				       IDE_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->ide_regs),
+				       "IDE Registers");
+	status = qlge_get_mpi_regs(qdev, &mpi_coredump->ide_regs[0],
+				   IDE_REGS_ADDR, IDE_REGS_CNT);
 	if (status)
 		goto err;
 
 	/* Get the NIC1 MBX Registers */
-	ql_build_coredump_seg_header(&mpi_coredump->nic1_mbx_regs_seg_hdr,
-				     NIC1_MBOX_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->nic1_mbx_regs),
-				"NIC1 MBox Regs");
-	status = ql_get_mpi_regs(qdev, &mpi_coredump->nic1_mbx_regs[0],
-				 NIC1_MBX_REGS_ADDR, NIC_MBX_REGS_CNT);
+	qlge_build_coredump_seg_header(&mpi_coredump->nic1_mbx_regs_seg_hdr,
+				       NIC1_MBOX_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->nic1_mbx_regs),
+				       "NIC1 MBox Regs");
+	status = qlge_get_mpi_regs(qdev, &mpi_coredump->nic1_mbx_regs[0],
+				   NIC1_MBX_REGS_ADDR, NIC_MBX_REGS_CNT);
 	if (status)
 		goto err;
 
 	/* Get the SMBus Registers */
-	ql_build_coredump_seg_header(&mpi_coredump->smbus_regs_seg_hdr,
-				     SMBUS_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->smbus_regs),
-				"SMBus Registers");
-	status = ql_get_mpi_regs(qdev, &mpi_coredump->smbus_regs[0],
-				 SMBUS_REGS_ADDR, SMBUS_REGS_CNT);
+	qlge_build_coredump_seg_header(&mpi_coredump->smbus_regs_seg_hdr,
+				       SMBUS_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->smbus_regs),
+				       "SMBus Registers");
+	status = qlge_get_mpi_regs(qdev, &mpi_coredump->smbus_regs[0],
+				   SMBUS_REGS_ADDR, SMBUS_REGS_CNT);
 	if (status)
 		goto err;
 
 	/* Get the FC2 MBX Registers */
-	ql_build_coredump_seg_header(&mpi_coredump->fc2_mbx_regs_seg_hdr,
-				     FC2_MBOX_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->fc2_mbx_regs),
-				"FC2 MBox Regs");
-	status = ql_get_mpi_regs(qdev, &mpi_coredump->fc2_mbx_regs[0],
-				 FC2_MBX_REGS_ADDR, FC_MBX_REGS_CNT);
+	qlge_build_coredump_seg_header(&mpi_coredump->fc2_mbx_regs_seg_hdr,
+				       FC2_MBOX_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->fc2_mbx_regs),
+				       "FC2 MBox Regs");
+	status = qlge_get_mpi_regs(qdev, &mpi_coredump->fc2_mbx_regs[0],
+				   FC2_MBX_REGS_ADDR, FC_MBX_REGS_CNT);
 	if (status)
 		goto err;
 
 	/* Get the NIC2 MBX Registers */
-	ql_build_coredump_seg_header(&mpi_coredump->nic2_mbx_regs_seg_hdr,
-				     NIC2_MBOX_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->nic2_mbx_regs),
-				"NIC2 MBox Regs");
-	status = ql_get_mpi_regs(qdev, &mpi_coredump->nic2_mbx_regs[0],
-				 NIC2_MBX_REGS_ADDR, NIC_MBX_REGS_CNT);
+	qlge_build_coredump_seg_header(&mpi_coredump->nic2_mbx_regs_seg_hdr,
+				       NIC2_MBOX_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->nic2_mbx_regs),
+				       "NIC2 MBox Regs");
+	status = qlge_get_mpi_regs(qdev, &mpi_coredump->nic2_mbx_regs[0],
+				   NIC2_MBX_REGS_ADDR, NIC_MBX_REGS_CNT);
 	if (status)
 		goto err;
 
 	/* Get the I2C Registers */
-	ql_build_coredump_seg_header(&mpi_coredump->i2c_regs_seg_hdr,
-				     I2C_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->i2c_regs),
-				"I2C Registers");
-	status = ql_get_mpi_regs(qdev, &mpi_coredump->i2c_regs[0],
-				 I2C_REGS_ADDR, I2C_REGS_CNT);
+	qlge_build_coredump_seg_header(&mpi_coredump->i2c_regs_seg_hdr,
+				       I2C_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->i2c_regs),
+				       "I2C Registers");
+	status = qlge_get_mpi_regs(qdev, &mpi_coredump->i2c_regs[0],
+				   I2C_REGS_ADDR, I2C_REGS_CNT);
 	if (status)
 		goto err;
 
 	/* Get the MEMC Registers */
-	ql_build_coredump_seg_header(&mpi_coredump->memc_regs_seg_hdr,
-				     MEMC_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->memc_regs),
-				"MEMC Registers");
-	status = ql_get_mpi_regs(qdev, &mpi_coredump->memc_regs[0],
-				 MEMC_REGS_ADDR, MEMC_REGS_CNT);
+	qlge_build_coredump_seg_header(&mpi_coredump->memc_regs_seg_hdr,
+				       MEMC_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->memc_regs),
+				       "MEMC Registers");
+	status = qlge_get_mpi_regs(qdev, &mpi_coredump->memc_regs[0],
+				   MEMC_REGS_ADDR, MEMC_REGS_CNT);
 	if (status)
 		goto err;
 
 	/* Get the PBus Registers */
-	ql_build_coredump_seg_header(&mpi_coredump->pbus_regs_seg_hdr,
-				     PBUS_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->pbus_regs),
-				"PBUS Registers");
-	status = ql_get_mpi_regs(qdev, &mpi_coredump->pbus_regs[0],
-				 PBUS_REGS_ADDR, PBUS_REGS_CNT);
+	qlge_build_coredump_seg_header(&mpi_coredump->pbus_regs_seg_hdr,
+				       PBUS_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->pbus_regs),
+				       "PBUS Registers");
+	status = qlge_get_mpi_regs(qdev, &mpi_coredump->pbus_regs[0],
+				   PBUS_REGS_ADDR, PBUS_REGS_CNT);
 	if (status)
 		goto err;
 
 	/* Get the MDE Registers */
-	ql_build_coredump_seg_header(&mpi_coredump->mde_regs_seg_hdr,
-				     MDE_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->mde_regs),
-				"MDE Registers");
-	status = ql_get_mpi_regs(qdev, &mpi_coredump->mde_regs[0],
-				 MDE_REGS_ADDR, MDE_REGS_CNT);
+	qlge_build_coredump_seg_header(&mpi_coredump->mde_regs_seg_hdr,
+				       MDE_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->mde_regs),
+				       "MDE Registers");
+	status = qlge_get_mpi_regs(qdev, &mpi_coredump->mde_regs[0],
+				   MDE_REGS_ADDR, MDE_REGS_CNT);
 	if (status)
 		goto err;
 
-	ql_build_coredump_seg_header(&mpi_coredump->misc_nic_seg_hdr,
-				     MISC_NIC_INFO_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->misc_nic_info),
-				"MISC NIC INFO");
+	qlge_build_coredump_seg_header(&mpi_coredump->misc_nic_seg_hdr,
+				       MISC_NIC_INFO_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->misc_nic_info),
+				       "MISC NIC INFO");
 	mpi_coredump->misc_nic_info.rx_ring_count = qdev->rx_ring_count;
 	mpi_coredump->misc_nic_info.tx_ring_count = qdev->tx_ring_count;
 	mpi_coredump->misc_nic_info.intr_count = qdev->intr_count;
@@ -1082,79 +1081,79 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 
 	/* Segment 31 */
 	/* Get indexed register values. */
-	ql_build_coredump_seg_header(&mpi_coredump->intr_states_seg_hdr,
-				     INTR_STATES_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->intr_states),
-				"INTR States");
-	ql_get_intr_states(qdev, &mpi_coredump->intr_states[0]);
-
-	ql_build_coredump_seg_header(&mpi_coredump->cam_entries_seg_hdr,
-				     CAM_ENTRIES_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->cam_entries),
-				"CAM Entries");
-	status = ql_get_cam_entries(qdev, &mpi_coredump->cam_entries[0]);
+	qlge_build_coredump_seg_header(&mpi_coredump->intr_states_seg_hdr,
+				       INTR_STATES_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->intr_states),
+				       "INTR States");
+	qlge_get_intr_states(qdev, &mpi_coredump->intr_states[0]);
+
+	qlge_build_coredump_seg_header(&mpi_coredump->cam_entries_seg_hdr,
+				       CAM_ENTRIES_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->cam_entries),
+				       "CAM Entries");
+	status = qlge_get_cam_entries(qdev, &mpi_coredump->cam_entries[0]);
 	if (status)
 		goto err;
 
-	ql_build_coredump_seg_header(&mpi_coredump->nic_routing_words_seg_hdr,
-				     ROUTING_WORDS_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->nic_routing_words),
-				"Routing Words");
-	status = ql_get_routing_entries(qdev,
-					&mpi_coredump->nic_routing_words[0]);
+	qlge_build_coredump_seg_header(&mpi_coredump->nic_routing_words_seg_hdr,
+				       ROUTING_WORDS_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->nic_routing_words),
+				       "Routing Words");
+	status = qlge_get_routing_entries(qdev,
+					  &mpi_coredump->nic_routing_words[0]);
 	if (status)
 		goto err;
 
 	/* Segment 34 (Rev C. step 23) */
-	ql_build_coredump_seg_header(&mpi_coredump->ets_seg_hdr,
-				     ETS_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->ets),
-				"ETS Registers");
-	status = ql_get_ets_regs(qdev, &mpi_coredump->ets[0]);
+	qlge_build_coredump_seg_header(&mpi_coredump->ets_seg_hdr,
+				       ETS_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->ets),
+				       "ETS Registers");
+	status = qlge_get_ets_regs(qdev, &mpi_coredump->ets[0]);
 	if (status)
 		goto err;
 
-	ql_build_coredump_seg_header(&mpi_coredump->probe_dump_seg_hdr,
-				     PROBE_DUMP_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->probe_dump),
-				"Probe Dump");
-	ql_get_probe_dump(qdev, &mpi_coredump->probe_dump[0]);
-
-	ql_build_coredump_seg_header(&mpi_coredump->routing_reg_seg_hdr,
-				     ROUTING_INDEX_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->routing_regs),
-				"Routing Regs");
-	status = ql_get_routing_index_registers(qdev,
-						&mpi_coredump->routing_regs[0]);
+	qlge_build_coredump_seg_header(&mpi_coredump->probe_dump_seg_hdr,
+				       PROBE_DUMP_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->probe_dump),
+				       "Probe Dump");
+	qlge_get_probe_dump(qdev, &mpi_coredump->probe_dump[0]);
+
+	qlge_build_coredump_seg_header(&mpi_coredump->routing_reg_seg_hdr,
+				       ROUTING_INDEX_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->routing_regs),
+				       "Routing Regs");
+	status = qlge_get_routing_index_registers(qdev,
+						  &mpi_coredump->routing_regs[0]);
 	if (status)
 		goto err;
 
-	ql_build_coredump_seg_header(&mpi_coredump->mac_prot_reg_seg_hdr,
-				     MAC_PROTOCOL_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->mac_prot_regs),
-				"MAC Prot Regs");
-	ql_get_mac_protocol_registers(qdev, &mpi_coredump->mac_prot_regs[0]);
+	qlge_build_coredump_seg_header(&mpi_coredump->mac_prot_reg_seg_hdr,
+				       MAC_PROTOCOL_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->mac_prot_regs),
+				       "MAC Prot Regs");
+	qlge_get_mac_protocol_registers(qdev, &mpi_coredump->mac_prot_regs[0]);
 
 	/* Get the semaphore registers for all 5 functions */
-	ql_build_coredump_seg_header(&mpi_coredump->sem_regs_seg_hdr,
-				     SEM_REGS_SEG_NUM,
-			sizeof(struct mpi_coredump_segment_header) +
-			sizeof(mpi_coredump->sem_regs),	"Sem Registers");
+	qlge_build_coredump_seg_header(&mpi_coredump->sem_regs_seg_hdr,
+				       SEM_REGS_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header) +
+				       sizeof(mpi_coredump->sem_regs),	"Sem Registers");
 
-	ql_get_sem_registers(qdev, &mpi_coredump->sem_regs[0]);
+	qlge_get_sem_registers(qdev, &mpi_coredump->sem_regs[0]);
 
 	/* Prevent the mpi restarting while we dump the memory.*/
-	ql_write_mpi_reg(qdev, MPI_TEST_FUNC_RST_STS, MPI_TEST_FUNC_RST_FRC);
+	qlge_write_mpi_reg(qdev, MPI_TEST_FUNC_RST_STS, MPI_TEST_FUNC_RST_FRC);
 
 	/* clear the pause */
-	status = ql_unpause_mpi_risc(qdev);
+	status = qlge_unpause_mpi_risc(qdev);
 	if (status) {
 		netif_err(qdev, drv, qdev->ndev,
 			  "Failed RISC unpause. Status = 0x%.08x\n", status);
@@ -1162,20 +1161,20 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 	}
 
 	/* Reset the RISC so we can dump RAM */
-	status = ql_hard_reset_mpi_risc(qdev);
+	status = qlge_hard_reset_mpi_risc(qdev);
 	if (status) {
 		netif_err(qdev, drv, qdev->ndev,
 			  "Failed RISC reset. Status = 0x%.08x\n", status);
 		goto err;
 	}
 
-	ql_build_coredump_seg_header(&mpi_coredump->code_ram_seg_hdr,
-				     WCS_RAM_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->code_ram),
-				"WCS RAM");
-	status = ql_dump_risc_ram_area(qdev, &mpi_coredump->code_ram[0],
-				       CODE_RAM_ADDR, CODE_RAM_CNT);
+	qlge_build_coredump_seg_header(&mpi_coredump->code_ram_seg_hdr,
+				       WCS_RAM_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->code_ram),
+				       "WCS RAM");
+	status = qlge_dump_risc_ram_area(qdev, &mpi_coredump->code_ram[0],
+					 CODE_RAM_ADDR, CODE_RAM_CNT);
 	if (status) {
 		netif_err(qdev, drv, qdev->ndev,
 			  "Failed Dump of CODE RAM. Status = 0x%.08x\n",
@@ -1184,13 +1183,13 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 	}
 
 	/* Insert the segment header */
-	ql_build_coredump_seg_header(&mpi_coredump->memc_ram_seg_hdr,
-				     MEMC_RAM_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->memc_ram),
-				"MEMC RAM");
-	status = ql_dump_risc_ram_area(qdev, &mpi_coredump->memc_ram[0],
-				       MEMC_RAM_ADDR, MEMC_RAM_CNT);
+	qlge_build_coredump_seg_header(&mpi_coredump->memc_ram_seg_hdr,
+				       MEMC_RAM_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->memc_ram),
+				       "MEMC RAM");
+	status = qlge_dump_risc_ram_area(qdev, &mpi_coredump->memc_ram[0],
+					 MEMC_RAM_ADDR, MEMC_RAM_CNT);
 	if (status) {
 		netif_err(qdev, drv, qdev->ndev,
 			  "Failed Dump of MEMC RAM. Status = 0x%.08x\n",
@@ -1198,13 +1197,13 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 		goto err;
 	}
 err:
-	ql_sem_unlock(qdev, SEM_PROC_REG_MASK); /* does flush too */
+	qlge_sem_unlock(qdev, SEM_PROC_REG_MASK); /* does flush too */
 	return status;
 }
 
-static void ql_get_core_dump(struct ql_adapter *qdev)
+static void qlge_get_core_dump(struct qlge_adapter *qdev)
 {
-	if (!ql_own_firmware(qdev)) {
+	if (!qlge_own_firmware(qdev)) {
 		netif_err(qdev, drv, qdev->ndev, "Don't own firmware!\n");
 		return;
 	}
@@ -1214,11 +1213,11 @@ static void ql_get_core_dump(struct ql_adapter *qdev)
 			  "Force Coredump can only be done from interface that is up\n");
 		return;
 	}
-	ql_queue_fw_error(qdev);
+	qlge_queue_fw_error(qdev);
 }
 
-static void ql_gen_reg_dump(struct ql_adapter *qdev,
-			    struct ql_reg_dump *mpi_coredump)
+static void qlge_gen_reg_dump(struct qlge_adapter *qdev,
+			      struct qlge_reg_dump *mpi_coredump)
 {
 	int i, status;
 
@@ -1228,71 +1227,71 @@ static void ql_gen_reg_dump(struct ql_adapter *qdev,
 	mpi_coredump->mpi_global_header.header_size =
 		sizeof(struct mpi_coredump_global_header);
 	mpi_coredump->mpi_global_header.image_size =
-		sizeof(struct ql_reg_dump);
+		sizeof(struct qlge_reg_dump);
 	strncpy(mpi_coredump->mpi_global_header.id_string, "MPI Coredump",
 		sizeof(mpi_coredump->mpi_global_header.id_string));
 
 	/* segment 16 */
-	ql_build_coredump_seg_header(&mpi_coredump->misc_nic_seg_hdr,
-				     MISC_NIC_INFO_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->misc_nic_info),
-				"MISC NIC INFO");
+	qlge_build_coredump_seg_header(&mpi_coredump->misc_nic_seg_hdr,
+				       MISC_NIC_INFO_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->misc_nic_info),
+				       "MISC NIC INFO");
 	mpi_coredump->misc_nic_info.rx_ring_count = qdev->rx_ring_count;
 	mpi_coredump->misc_nic_info.tx_ring_count = qdev->tx_ring_count;
 	mpi_coredump->misc_nic_info.intr_count = qdev->intr_count;
 	mpi_coredump->misc_nic_info.function = qdev->func;
 
 	/* Segment 16, Rev C. Step 18 */
-	ql_build_coredump_seg_header(&mpi_coredump->nic_regs_seg_hdr,
-				     NIC1_CONTROL_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->nic_regs),
-				"NIC Registers");
+	qlge_build_coredump_seg_header(&mpi_coredump->nic_regs_seg_hdr,
+				       NIC1_CONTROL_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->nic_regs),
+				       "NIC Registers");
 	/* Get generic reg dump */
 	for (i = 0; i < 64; i++)
-		mpi_coredump->nic_regs[i] = ql_read32(qdev, i * sizeof(u32));
+		mpi_coredump->nic_regs[i] = qlge_read32(qdev, i * sizeof(u32));
 
 	/* Segment 31 */
 	/* Get indexed register values. */
-	ql_build_coredump_seg_header(&mpi_coredump->intr_states_seg_hdr,
-				     INTR_STATES_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->intr_states),
-				"INTR States");
-	ql_get_intr_states(qdev, &mpi_coredump->intr_states[0]);
-
-	ql_build_coredump_seg_header(&mpi_coredump->cam_entries_seg_hdr,
-				     CAM_ENTRIES_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->cam_entries),
-				"CAM Entries");
-	status = ql_get_cam_entries(qdev, &mpi_coredump->cam_entries[0]);
+	qlge_build_coredump_seg_header(&mpi_coredump->intr_states_seg_hdr,
+				       INTR_STATES_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->intr_states),
+				       "INTR States");
+	qlge_get_intr_states(qdev, &mpi_coredump->intr_states[0]);
+
+	qlge_build_coredump_seg_header(&mpi_coredump->cam_entries_seg_hdr,
+				       CAM_ENTRIES_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->cam_entries),
+				       "CAM Entries");
+	status = qlge_get_cam_entries(qdev, &mpi_coredump->cam_entries[0]);
 	if (status)
 		return;
 
-	ql_build_coredump_seg_header(&mpi_coredump->nic_routing_words_seg_hdr,
-				     ROUTING_WORDS_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->nic_routing_words),
-				"Routing Words");
-	status = ql_get_routing_entries(qdev,
-					&mpi_coredump->nic_routing_words[0]);
+	qlge_build_coredump_seg_header(&mpi_coredump->nic_routing_words_seg_hdr,
+				       ROUTING_WORDS_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->nic_routing_words),
+				       "Routing Words");
+	status = qlge_get_routing_entries(qdev,
+					  &mpi_coredump->nic_routing_words[0]);
 	if (status)
 		return;
 
 	/* Segment 34 (Rev C. step 23) */
-	ql_build_coredump_seg_header(&mpi_coredump->ets_seg_hdr,
-				     ETS_SEG_NUM,
-				sizeof(struct mpi_coredump_segment_header)
-				+ sizeof(mpi_coredump->ets),
-				"ETS Registers");
-	status = ql_get_ets_regs(qdev, &mpi_coredump->ets[0]);
+	qlge_build_coredump_seg_header(&mpi_coredump->ets_seg_hdr,
+				       ETS_SEG_NUM,
+				       sizeof(struct mpi_coredump_segment_header)
+				       + sizeof(mpi_coredump->ets),
+				       "ETS Registers");
+	status = qlge_get_ets_regs(qdev, &mpi_coredump->ets[0]);
 	if (status)
 		return;
 }
 
-void ql_get_dump(struct ql_adapter *qdev, void *buff)
+void qlge_get_dump(struct qlge_adapter *qdev, void *buff)
 {
 	/*
 	 * If the dump has already been taken and is stored
@@ -1304,21 +1303,21 @@ void ql_get_dump(struct ql_adapter *qdev, void *buff)
 	 */
 
 	if (!test_bit(QL_FRC_COREDUMP, &qdev->flags)) {
-		if (!ql_core_dump(qdev, buff))
-			ql_soft_reset_mpi_risc(qdev);
+		if (!qlge_core_dump(qdev, buff))
+			qlge_soft_reset_mpi_risc(qdev);
 		else
 			netif_err(qdev, drv, qdev->ndev, "coredump failed!\n");
 	} else {
-		ql_gen_reg_dump(qdev, buff);
-		ql_get_core_dump(qdev);
+		qlge_gen_reg_dump(qdev, buff);
+		qlge_get_core_dump(qdev);
 	}
 }
 
 /* Coredump to messages log file using separate worker thread */
-void ql_mpi_core_to_log(struct work_struct *work)
+void qlge_mpi_core_to_log(struct work_struct *work)
 {
-	struct ql_adapter *qdev =
-		container_of(work, struct ql_adapter, mpi_core_to_log.work);
+	struct qlge_adapter *qdev =
+		container_of(work, struct qlge_adapter, mpi_core_to_log.work);
 
 	print_hex_dump(KERN_DEBUG, "Core is dumping to log file!\n",
 		       DUMP_PREFIX_OFFSET, 32, 4, qdev->mpi_coredump,
@@ -1326,29 +1325,29 @@ void ql_mpi_core_to_log(struct work_struct *work)
 }
 
 #ifdef QL_REG_DUMP
-static void ql_dump_intr_states(struct ql_adapter *qdev)
+static void qlge_dump_intr_states(struct qlge_adapter *qdev)
 {
 	int i;
 	u32 value;
 
 	for (i = 0; i < qdev->intr_count; i++) {
-		ql_write32(qdev, INTR_EN, qdev->intr_context[i].intr_read_mask);
-		value = ql_read32(qdev, INTR_EN);
+		qlge_write32(qdev, INTR_EN, qdev->intr_context[i].intr_read_mask);
+		value = qlge_read32(qdev, INTR_EN);
 		netdev_err(qdev->ndev, "Interrupt %d is %s\n", i,
 			   (value & INTR_EN_EN ? "enabled" : "disabled"));
 	}
 }
 
 #define DUMP_XGMAC(qdev, reg)					\
-do {								\
-	u32 data;						\
-	ql_read_xgmac_reg(qdev, reg, &data);			\
-	netdev_err(qdev->ndev, "%s = 0x%.08x\n", #reg, data); \
-} while (0)
+	do {								\
+		u32 data;						\
+		qlge_read_xgmac_reg(qdev, reg, &data);			\
+		netdev_err(qdev->ndev, "%s = 0x%.08x\n", #reg, data); \
+	} while (0)
 
-void ql_dump_xgmac_control_regs(struct ql_adapter *qdev)
+void qlge_dump_xgmac_control_regs(struct qlge_adapter *qdev)
 {
-	if (ql_sem_spinlock(qdev, qdev->xg_sem_mask)) {
+	if (qlge_sem_spinlock(qdev, qdev->xg_sem_mask)) {
 		netdev_err(qdev->ndev, "%s: Couldn't get xgmac sem\n",
 			   __func__);
 		return;
@@ -1370,23 +1369,23 @@ void ql_dump_xgmac_control_regs(struct ql_adapter *qdev)
 	DUMP_XGMAC(qdev, MAC_MGMT_INT);
 	DUMP_XGMAC(qdev, MAC_MGMT_IN_MASK);
 	DUMP_XGMAC(qdev, EXT_ARB_MODE);
-	ql_sem_unlock(qdev, qdev->xg_sem_mask);
+	qlge_sem_unlock(qdev, qdev->xg_sem_mask);
 }
 
-static void ql_dump_ets_regs(struct ql_adapter *qdev)
+static void qlge_dump_ets_regs(struct qlge_adapter *qdev)
 {
 }
 
-static void ql_dump_cam_entries(struct ql_adapter *qdev)
+static void qlge_dump_cam_entries(struct qlge_adapter *qdev)
 {
 	int i;
 	u32 value[3];
 
-	i = ql_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
+	i = qlge_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
 	if (i)
 		return;
 	for (i = 0; i < 4; i++) {
-		if (ql_get_mac_addr_reg(qdev, MAC_ADDR_TYPE_CAM_MAC, i, value)) {
+		if (qlge_get_mac_addr_reg(qdev, MAC_ADDR_TYPE_CAM_MAC, i, value)) {
 			netdev_err(qdev->ndev,
 				   "%s: Failed read of mac index register\n",
 				   __func__);
@@ -1398,7 +1397,7 @@ static void ql_dump_cam_entries(struct ql_adapter *qdev)
 				   i, value[1], value[0], value[2]);
 	}
 	for (i = 0; i < 32; i++) {
-		if (ql_get_mac_addr_reg
+		if (qlge_get_mac_addr_reg
 		    (qdev, MAC_ADDR_TYPE_MULTI_MAC, i, value)) {
 			netdev_err(qdev->ndev,
 				   "%s: Failed read of mac index register\n",
@@ -1410,20 +1409,20 @@ static void ql_dump_cam_entries(struct ql_adapter *qdev)
 				   "MCAST index %d CAM Lookup Lower = 0x%.08x:%.08x\n",
 				   i, value[1], value[0]);
 	}
-	ql_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
+	qlge_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
 }
 
-void ql_dump_routing_entries(struct ql_adapter *qdev)
+void qlge_dump_routing_entries(struct qlge_adapter *qdev)
 {
 	int i;
 	u32 value;
 
-	i = ql_sem_spinlock(qdev, SEM_RT_IDX_MASK);
+	i = qlge_sem_spinlock(qdev, SEM_RT_IDX_MASK);
 	if (i)
 		return;
 	for (i = 0; i < 16; i++) {
 		value = 0;
-		if (ql_get_routing_reg(qdev, i, &value)) {
+		if (qlge_get_routing_reg(qdev, i, &value)) {
 			netdev_err(qdev->ndev,
 				   "%s: Failed read of routing index register\n",
 				   __func__);
@@ -1434,13 +1433,13 @@ void ql_dump_routing_entries(struct ql_adapter *qdev)
 				   "Routing Mask %d = 0x%.08x\n",
 				   i, value);
 	}
-	ql_sem_unlock(qdev, SEM_RT_IDX_MASK);
+	qlge_sem_unlock(qdev, SEM_RT_IDX_MASK);
 }
 
 #define DUMP_REG(qdev, reg)			\
-	netdev_err(qdev->ndev, "%-32s= 0x%x\n", #reg, ql_read32(qdev, reg))
+	netdev_err(qdev->ndev, "%-32s= 0x%x\n", #reg, qlge_read32(qdev, reg))
 
-void ql_dump_regs(struct ql_adapter *qdev)
+void qlge_dump_regs(struct qlge_adapter *qdev)
 {
 	netdev_err(qdev->ndev, "reg dump for function #%d\n", qdev->func);
 	DUMP_REG(qdev, SYS);
@@ -1496,11 +1495,11 @@ void ql_dump_regs(struct ql_adapter *qdev)
 	DUMP_REG(qdev, XG_SERDES_DATA);
 	DUMP_REG(qdev, PRB_MX_ADDR);
 	DUMP_REG(qdev, PRB_MX_DATA);
-	ql_dump_intr_states(qdev);
-	ql_dump_xgmac_control_regs(qdev);
-	ql_dump_ets_regs(qdev);
-	ql_dump_cam_entries(qdev);
-	ql_dump_routing_entries(qdev);
+	qlge_dump_intr_states(qdev);
+	qlge_dump_xgmac_control_regs(qdev);
+	qlge_dump_ets_regs(qdev);
+	qlge_dump_cam_entries(qdev);
+	qlge_dump_routing_entries(qdev);
 }
 #endif
 
@@ -1510,7 +1509,7 @@ void ql_dump_regs(struct ql_adapter *qdev)
 	netdev_err(qdev->ndev, "%s = %ld\n", #stat,  \
 		   (unsigned long)(qdev)->nic_stats.stat)
 
-void ql_dump_stat(struct ql_adapter *qdev)
+void qlge_dump_stat(struct qlge_adapter *qdev)
 {
 	netdev_err(qdev->ndev, "%s: Enter\n", __func__);
 	DUMP_STAT(qdev, tx_pkts);
@@ -1567,8 +1566,8 @@ void ql_dump_stat(struct ql_adapter *qdev)
 		   (unsigned long long)qdev->field)
 #define DUMP_QDEV_ARRAY(qdev, type, array, index, field) \
 	netdev_err(qdev->ndev, "%s[%d].%s = " type "\n",		 \
-	       #array, index, #field, (qdev)->array[index].field)
-void ql_dump_qdev(struct ql_adapter *qdev)
+#array, index, #field, (qdev)->array[index].field)
+	void qlge_dump_qdev(struct qlge_adapter *qdev)
 {
 	int i;
 
@@ -1615,10 +1614,10 @@ void ql_dump_qdev(struct ql_adapter *qdev)
 #endif
 
 #ifdef QL_CB_DUMP
-void ql_dump_wqicb(struct wqicb *wqicb)
+void qlge_dump_wqicb(struct wqicb *wqicb)
 {
 	struct tx_ring *tx_ring = container_of(wqicb, struct tx_ring, wqicb);
-	struct ql_adapter *qdev = tx_ring->qdev;
+	struct qlge_adapter *qdev = tx_ring->qdev;
 
 	netdev_err(qdev->ndev, "Dumping wqicb stuff...\n");
 	netdev_err(qdev->ndev, "wqicb->len = 0x%x\n", le16_to_cpu(wqicb->len));
@@ -1633,9 +1632,9 @@ void ql_dump_wqicb(struct wqicb *wqicb)
 		   (unsigned long long)le64_to_cpu(wqicb->cnsmr_idx_addr));
 }
 
-void ql_dump_tx_ring(struct tx_ring *tx_ring)
+void qlge_dump_tx_ring(struct tx_ring *tx_ring)
 {
-	struct ql_adapter *qdev = tx_ring->qdev;
+	struct qlge_adapter *qdev = tx_ring->qdev;
 
 	netdev_err(qdev->ndev, "===================== Dumping tx_ring %d ===============\n",
 		   tx_ring->wq_id);
@@ -1645,7 +1644,7 @@ void ql_dump_tx_ring(struct tx_ring *tx_ring)
 	netdev_err(qdev->ndev, "tx_ring->cnsmr_idx_sh_reg, addr = 0x%p, value = %d\n",
 		   tx_ring->cnsmr_idx_sh_reg,
 		   tx_ring->cnsmr_idx_sh_reg
-			? ql_read_sh_reg(tx_ring->cnsmr_idx_sh_reg) : 0);
+		   ? qlge_read_sh_reg(tx_ring->cnsmr_idx_sh_reg) : 0);
 	netdev_err(qdev->ndev, "tx_ring->size = %d\n", tx_ring->wq_size);
 	netdev_err(qdev->ndev, "tx_ring->len = %d\n", tx_ring->wq_len);
 	netdev_err(qdev->ndev, "tx_ring->prod_idx_db_reg = %p\n", tx_ring->prod_idx_db_reg);
@@ -1657,11 +1656,11 @@ void ql_dump_tx_ring(struct tx_ring *tx_ring)
 	netdev_err(qdev->ndev, "tx_ring->tx_count = %d\n", atomic_read(&tx_ring->tx_count));
 }
 
-void ql_dump_ricb(struct ricb *ricb)
+void qlge_dump_ricb(struct ricb *ricb)
 {
 	int i;
-	struct ql_adapter *qdev =
-		container_of(ricb, struct ql_adapter, ricb);
+	struct qlge_adapter *qdev =
+		container_of(ricb, struct qlge_adapter, ricb);
 
 	netdev_err(qdev->ndev, "===================== Dumping ricb ===============\n");
 	netdev_err(qdev->ndev, "Dumping ricb stuff...\n");
@@ -1689,10 +1688,10 @@ void ql_dump_ricb(struct ricb *ricb)
 			   le32_to_cpu(ricb->ipv4_hash_key[i]));
 }
 
-void ql_dump_cqicb(struct cqicb *cqicb)
+void qlge_dump_cqicb(struct cqicb *cqicb)
 {
 	struct rx_ring *rx_ring = container_of(cqicb, struct rx_ring, cqicb);
-	struct ql_adapter *qdev = rx_ring->qdev;
+	struct qlge_adapter *qdev = rx_ring->qdev;
 
 	netdev_err(qdev->ndev, "Dumping cqicb stuff...\n");
 
@@ -1723,7 +1722,7 @@ void ql_dump_cqicb(struct cqicb *cqicb)
 
 static const char *qlge_rx_ring_type_name(struct rx_ring *rx_ring)
 {
-	struct ql_adapter *qdev = rx_ring->qdev;
+	struct qlge_adapter *qdev = rx_ring->qdev;
 
 	if (rx_ring->cq_id < qdev->rss_ring_count)
 		return "RX COMPLETION";
@@ -1731,9 +1730,9 @@ static const char *qlge_rx_ring_type_name(struct rx_ring *rx_ring)
 		return "TX COMPLETION";
 };
 
-void ql_dump_rx_ring(struct rx_ring *rx_ring)
+void qlge_dump_rx_ring(struct rx_ring *rx_ring)
 {
-	struct ql_adapter *qdev = rx_ring->qdev;
+	struct qlge_adapter *qdev = rx_ring->qdev;
 
 	netdev_err(qdev->ndev,
 		   "===================== Dumping rx_ring %d ===============\n",
@@ -1750,7 +1749,7 @@ void ql_dump_rx_ring(struct rx_ring *rx_ring)
 	netdev_err(qdev->ndev,
 		   "rx_ring->prod_idx_sh_reg, addr = 0x%p, value = %d\n",
 		   rx_ring->prod_idx_sh_reg,
-		   rx_ring->prod_idx_sh_reg ? ql_read_sh_reg(rx_ring->prod_idx_sh_reg) : 0);
+		   rx_ring->prod_idx_sh_reg ? qlge_read_sh_reg(rx_ring->prod_idx_sh_reg) : 0);
 	netdev_err(qdev->ndev, "rx_ring->prod_idx_sh_reg_dma = %llx\n",
 		   (unsigned long long)rx_ring->prod_idx_sh_reg_dma);
 	netdev_err(qdev->ndev, "rx_ring->cnsmr_idx_db_reg = %p\n",
@@ -1790,7 +1789,7 @@ void ql_dump_rx_ring(struct rx_ring *rx_ring)
 	netdev_err(qdev->ndev, "rx_ring->qdev = %p\n", rx_ring->qdev);
 }
 
-void ql_dump_hw_cb(struct ql_adapter *qdev, int size, u32 bit, u16 q_id)
+void qlge_dump_hw_cb(struct qlge_adapter *qdev, int size, u32 bit, u16 q_id)
 {
 	void *ptr;
 
@@ -1800,19 +1799,19 @@ void ql_dump_hw_cb(struct ql_adapter *qdev, int size, u32 bit, u16 q_id)
 	if (!ptr)
 		return;
 
-	if (ql_write_cfg(qdev, ptr, size, bit, q_id)) {
+	if (qlge_write_cfg(qdev, ptr, size, bit, q_id)) {
 		netdev_err(qdev->ndev, "%s: Failed to upload control block!\n", __func__);
 		goto fail_it;
 	}
 	switch (bit) {
 	case CFG_DRQ:
-		ql_dump_wqicb((struct wqicb *)ptr);
+		qlge_dump_wqicb((struct wqicb *)ptr);
 		break;
 	case CFG_DCQ:
-		ql_dump_cqicb((struct cqicb *)ptr);
+		qlge_dump_cqicb((struct cqicb *)ptr);
 		break;
 	case CFG_DR:
-		ql_dump_ricb((struct ricb *)ptr);
+		qlge_dump_ricb((struct ricb *)ptr);
 		break;
 	default:
 		netdev_err(qdev->ndev, "%s: Invalid bit value = %x\n", __func__, bit);
@@ -1824,7 +1823,7 @@ void ql_dump_hw_cb(struct ql_adapter *qdev, int size, u32 bit, u16 q_id)
 #endif
 
 #ifdef QL_OB_DUMP
-void ql_dump_tx_desc(struct ql_adapter *qdev, struct tx_buf_desc *tbd)
+void qlge_dump_tx_desc(struct qlge_adapter *qdev, struct tx_buf_desc *tbd)
 {
 	netdev_err(qdev->ndev, "tbd->addr  = 0x%llx\n",
 		   le64_to_cpu((u64)tbd->addr));
@@ -1851,10 +1850,10 @@ void ql_dump_tx_desc(struct ql_adapter *qdev, struct tx_buf_desc *tbd)
 		   tbd->len & TX_DESC_E ? "E" : ".");
 }
 
-void ql_dump_ob_mac_iocb(struct ql_adapter *qdev, struct ob_mac_iocb_req *ob_mac_iocb)
+void qlge_dump_ob_mac_iocb(struct qlge_adapter *qdev, struct qlge_ob_mac_iocb_req *ob_mac_iocb)
 {
-	struct ob_mac_tso_iocb_req *ob_mac_tso_iocb =
-	    (struct ob_mac_tso_iocb_req *)ob_mac_iocb;
+	struct qlge_ob_mac_tso_iocb_req *ob_mac_tso_iocb =
+		(struct qlge_ob_mac_tso_iocb_req *)ob_mac_iocb;
 	struct tx_buf_desc *tbd;
 	u16 frame_len;
 
@@ -1894,16 +1893,16 @@ void ql_dump_ob_mac_iocb(struct ql_adapter *qdev, struct ob_mac_iocb_req *ob_mac
 		frame_len = le16_to_cpu(ob_mac_iocb->frame_len);
 	}
 	tbd = &ob_mac_iocb->tbd[0];
-	ql_dump_tx_desc(qdev, tbd);
+	qlge_dump_tx_desc(qdev, tbd);
 }
 
-void ql_dump_ob_mac_rsp(struct ql_adapter *qdev, struct ob_mac_iocb_rsp *ob_mac_rsp)
+void qlge_dump_ob_mac_rsp(struct qlge_adapter *qdev, struct qlge_ob_mac_iocb_rsp *ob_mac_rsp)
 {
 	netdev_err(qdev->ndev, "%s\n", __func__);
 	netdev_err(qdev->ndev, "opcode         = %d\n", ob_mac_rsp->opcode);
 	netdev_err(qdev->ndev, "flags          = %s %s %s %s %s %s %s\n",
 		   ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_OI ?
-			"OI" : ".", ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_I ? "I" : ".",
+		   "OI" : ".", ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_I ? "I" : ".",
 		   ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_E ? "E" : ".",
 		   ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_S ? "S" : ".",
 		   ob_mac_rsp->flags1 & OB_MAC_IOCB_RSP_L ? "L" : ".",
@@ -1914,7 +1913,7 @@ void ql_dump_ob_mac_rsp(struct ql_adapter *qdev, struct ob_mac_iocb_rsp *ob_mac_
 #endif
 
 #ifdef QL_IB_DUMP
-void ql_dump_ib_mac_rsp(struct ql_adapter *qdev, struct ib_mac_iocb_rsp *ib_mac_rsp)
+void qlge_dump_ib_mac_rsp(struct qlge_adapter *qdev, struct qlge_ib_mac_iocb_rsp *ib_mac_rsp)
 {
 	netdev_err(qdev->ndev, "%s\n", __func__);
 	netdev_err(qdev->ndev, "opcode         = 0x%x\n", ib_mac_rsp->opcode);
@@ -1996,7 +1995,7 @@ void ql_dump_ib_mac_rsp(struct ql_adapter *qdev, struct ib_mac_iocb_rsp *ib_mac_
 #endif
 
 #ifdef QL_ALL_DUMP
-void ql_dump_all(struct ql_adapter *qdev)
+void qlge_dump_all(struct qlge_adapter *qdev)
 {
 	int i;
 
diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index a28f0254cf60..3e577e1bc27c 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -34,16 +34,16 @@
 
 #include "qlge.h"
 
-struct ql_stats {
+struct qlge_stats {
 	char stat_string[ETH_GSTRING_LEN];
 	int sizeof_stat;
 	int stat_offset;
 };
 
-#define QL_SIZEOF(m) sizeof_field(struct ql_adapter, m)
-#define QL_OFF(m) offsetof(struct ql_adapter, m)
+#define QL_SIZEOF(m) sizeof_field(struct qlge_adapter, m)
+#define QL_OFF(m) offsetof(struct qlge_adapter, m)
 
-static const struct ql_stats ql_gstrings_stats[] = {
+static const struct qlge_stats qlge_gstrings_stats[] = {
 	{"tx_pkts", QL_SIZEOF(nic_stats.tx_pkts), QL_OFF(nic_stats.tx_pkts)},
 	{"tx_bytes", QL_SIZEOF(nic_stats.tx_bytes), QL_OFF(nic_stats.tx_bytes)},
 	{"tx_mcast_pkts", QL_SIZEOF(nic_stats.tx_mcast_pkts),
@@ -175,15 +175,15 @@ static const struct ql_stats ql_gstrings_stats[] = {
 					QL_OFF(nic_stats.rx_nic_fifo_drop)},
 };
 
-static const char ql_gstrings_test[][ETH_GSTRING_LEN] = {
+static const char qlge_gstrings_test[][ETH_GSTRING_LEN] = {
 	"Loopback test  (offline)"
 };
 
-#define QLGE_TEST_LEN (sizeof(ql_gstrings_test) / ETH_GSTRING_LEN)
-#define QLGE_STATS_LEN ARRAY_SIZE(ql_gstrings_stats)
+#define QLGE_TEST_LEN (sizeof(qlge_gstrings_test) / ETH_GSTRING_LEN)
+#define QLGE_STATS_LEN ARRAY_SIZE(qlge_gstrings_stats)
 #define QLGE_RCV_MAC_ERR_STATS	7
 
-static int ql_update_ring_coalescing(struct ql_adapter *qdev)
+static int qlge_update_ring_coalescing(struct qlge_adapter *qdev)
 {
 	int i, status = 0;
 	struct rx_ring *rx_ring;
@@ -203,10 +203,10 @@ static int ql_update_ring_coalescing(struct ql_adapter *qdev)
 			cqicb = (struct cqicb *)rx_ring;
 			cqicb->irq_delay = cpu_to_le16(qdev->tx_coalesce_usecs);
 			cqicb->pkt_delay =
-			    cpu_to_le16(qdev->tx_max_coalesced_frames);
+				cpu_to_le16(qdev->tx_max_coalesced_frames);
 			cqicb->flags = FLAGS_LI;
-			status = ql_write_cfg(qdev, cqicb, sizeof(*cqicb),
-					      CFG_LCQ, rx_ring->cq_id);
+			status = qlge_write_cfg(qdev, cqicb, sizeof(*cqicb),
+						CFG_LCQ, rx_ring->cq_id);
 			if (status) {
 				netif_err(qdev, ifup, qdev->ndev,
 					  "Failed to load CQICB.\n");
@@ -224,10 +224,10 @@ static int ql_update_ring_coalescing(struct ql_adapter *qdev)
 			cqicb = (struct cqicb *)rx_ring;
 			cqicb->irq_delay = cpu_to_le16(qdev->rx_coalesce_usecs);
 			cqicb->pkt_delay =
-			    cpu_to_le16(qdev->rx_max_coalesced_frames);
+				cpu_to_le16(qdev->rx_max_coalesced_frames);
 			cqicb->flags = FLAGS_LI;
-			status = ql_write_cfg(qdev, cqicb, sizeof(*cqicb),
-					      CFG_LCQ, rx_ring->cq_id);
+			status = qlge_write_cfg(qdev, cqicb, sizeof(*cqicb),
+						CFG_LCQ, rx_ring->cq_id);
 			if (status) {
 				netif_err(qdev, ifup, qdev->ndev,
 					  "Failed to load CQICB.\n");
@@ -239,14 +239,14 @@ static int ql_update_ring_coalescing(struct ql_adapter *qdev)
 	return status;
 }
 
-static void ql_update_stats(struct ql_adapter *qdev)
+static void qlge_update_stats(struct qlge_adapter *qdev)
 {
 	u32 i;
 	u64 data;
 	u64 *iter = &qdev->nic_stats.tx_pkts;
 
 	spin_lock(&qdev->stats_lock);
-	if (ql_sem_spinlock(qdev, qdev->xg_sem_mask)) {
+	if (qlge_sem_spinlock(qdev, qdev->xg_sem_mask)) {
 		netif_err(qdev, drv, qdev->ndev,
 			  "Couldn't get xgmac sem.\n");
 		goto quit;
@@ -255,7 +255,7 @@ static void ql_update_stats(struct ql_adapter *qdev)
 	 * Get TX statistics.
 	 */
 	for (i = 0x200; i < 0x280; i += 8) {
-		if (ql_read_xgmac_reg64(qdev, i, &data)) {
+		if (qlge_read_xgmac_reg64(qdev, i, &data)) {
 			netif_err(qdev, drv, qdev->ndev,
 				  "Error reading status register 0x%.04x.\n",
 				  i);
@@ -270,7 +270,7 @@ static void ql_update_stats(struct ql_adapter *qdev)
 	 * Get RX statistics.
 	 */
 	for (i = 0x300; i < 0x3d0; i += 8) {
-		if (ql_read_xgmac_reg64(qdev, i, &data)) {
+		if (qlge_read_xgmac_reg64(qdev, i, &data)) {
 			netif_err(qdev, drv, qdev->ndev,
 				  "Error reading status register 0x%.04x.\n",
 				  i);
@@ -288,7 +288,7 @@ static void ql_update_stats(struct ql_adapter *qdev)
 	 * Get Per-priority TX pause frame counter statistics.
 	 */
 	for (i = 0x500; i < 0x540; i += 8) {
-		if (ql_read_xgmac_reg64(qdev, i, &data)) {
+		if (qlge_read_xgmac_reg64(qdev, i, &data)) {
 			netif_err(qdev, drv, qdev->ndev,
 				  "Error reading status register 0x%.04x.\n",
 				  i);
@@ -303,7 +303,7 @@ static void ql_update_stats(struct ql_adapter *qdev)
 	 * Get Per-priority RX pause frame counter statistics.
 	 */
 	for (i = 0x568; i < 0x5a8; i += 8) {
-		if (ql_read_xgmac_reg64(qdev, i, &data)) {
+		if (qlge_read_xgmac_reg64(qdev, i, &data)) {
 			netif_err(qdev, drv, qdev->ndev,
 				  "Error reading status register 0x%.04x.\n",
 				  i);
@@ -317,7 +317,7 @@ static void ql_update_stats(struct ql_adapter *qdev)
 	/*
 	 * Get RX NIC FIFO DROP statistics.
 	 */
-	if (ql_read_xgmac_reg64(qdev, 0x5b8, &data)) {
+	if (qlge_read_xgmac_reg64(qdev, 0x5b8, &data)) {
 		netif_err(qdev, drv, qdev->ndev,
 			  "Error reading status register 0x%.04x.\n", i);
 		goto end;
@@ -325,32 +325,32 @@ static void ql_update_stats(struct ql_adapter *qdev)
 		*iter = data;
 	}
 end:
-	ql_sem_unlock(qdev, qdev->xg_sem_mask);
+	qlge_sem_unlock(qdev, qdev->xg_sem_mask);
 quit:
 	spin_unlock(&qdev->stats_lock);
 
 	QL_DUMP_STAT(qdev);
 }
 
-static void ql_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
+static void qlge_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
 {
 	int index;
 
 	switch (stringset) {
 	case ETH_SS_TEST:
-		memcpy(buf, *ql_gstrings_test, QLGE_TEST_LEN * ETH_GSTRING_LEN);
+		memcpy(buf, *qlge_gstrings_test, QLGE_TEST_LEN * ETH_GSTRING_LEN);
 		break;
 	case ETH_SS_STATS:
 		for (index = 0; index < QLGE_STATS_LEN; index++) {
 			memcpy(buf + index * ETH_GSTRING_LEN,
-			       ql_gstrings_stats[index].stat_string,
+			       qlge_gstrings_stats[index].stat_string,
 			       ETH_GSTRING_LEN);
 		}
 		break;
 	}
 }
 
-static int ql_get_sset_count(struct net_device *dev, int sset)
+static int qlge_get_sset_count(struct net_device *dev, int sset)
 {
 	switch (sset) {
 	case ETH_SS_TEST:
@@ -363,34 +363,34 @@ static int ql_get_sset_count(struct net_device *dev, int sset)
 }
 
 static void
-ql_get_ethtool_stats(struct net_device *ndev,
-		     struct ethtool_stats *stats, u64 *data)
+qlge_get_ethtool_stats(struct net_device *ndev,
+		       struct ethtool_stats *stats, u64 *data)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 	int index, length;
 
 	length = QLGE_STATS_LEN;
-	ql_update_stats(qdev);
+	qlge_update_stats(qdev);
 
 	for (index = 0; index < length; index++) {
 		char *p = (char *)qdev +
-			ql_gstrings_stats[index].stat_offset;
-		*data++ = (ql_gstrings_stats[index].sizeof_stat ==
-			sizeof(u64)) ? *(u64 *)p : (*(u32 *)p);
+			qlge_gstrings_stats[index].stat_offset;
+		*data++ = (qlge_gstrings_stats[index].sizeof_stat ==
+			   sizeof(u64)) ? *(u64 *)p : (*(u32 *)p);
 	}
 }
 
-static int ql_get_link_ksettings(struct net_device *ndev,
-				 struct ethtool_link_ksettings *ecmd)
+static int qlge_get_link_ksettings(struct net_device *ndev,
+				   struct ethtool_link_ksettings *ecmd)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 	u32 supported, advertising;
 
 	supported = SUPPORTED_10000baseT_Full;
 	advertising = ADVERTISED_10000baseT_Full;
 
 	if ((qdev->link_status & STS_LINK_TYPE_MASK) ==
-				STS_LINK_TYPE_10GBASET) {
+	    STS_LINK_TYPE_10GBASET) {
 		supported |= (SUPPORTED_TP | SUPPORTED_Autoneg);
 		advertising |= (ADVERTISED_TP | ADVERTISED_Autoneg);
 		ecmd->base.port = PORT_TP;
@@ -412,10 +412,10 @@ static int ql_get_link_ksettings(struct net_device *ndev,
 	return 0;
 }
 
-static void ql_get_drvinfo(struct net_device *ndev,
-			   struct ethtool_drvinfo *drvinfo)
+static void qlge_get_drvinfo(struct net_device *ndev,
+			     struct ethtool_drvinfo *drvinfo)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 
 	strlcpy(drvinfo->driver, qlge_driver_name, sizeof(drvinfo->driver));
 	strlcpy(drvinfo->version, qlge_driver_version,
@@ -429,9 +429,9 @@ static void ql_get_drvinfo(struct net_device *ndev,
 		sizeof(drvinfo->bus_info));
 }
 
-static void ql_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
+static void qlge_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 	unsigned short ssys_dev = qdev->pdev->subsystem_device;
 
 	/* WOL is only supported for mezz card. */
@@ -442,9 +442,9 @@ static void ql_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 	}
 }
 
-static int ql_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
+static int qlge_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 	unsigned short ssys_dev = qdev->pdev->subsystem_device;
 
 	/* WOL is only supported for mezz card. */
@@ -462,25 +462,25 @@ static int ql_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 	return 0;
 }
 
-static int ql_set_phys_id(struct net_device *ndev,
-			  enum ethtool_phys_id_state state)
+static int qlge_set_phys_id(struct net_device *ndev,
+			    enum ethtool_phys_id_state state)
 
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 
 	switch (state) {
 	case ETHTOOL_ID_ACTIVE:
 		/* Save the current LED settings */
-		if (ql_mb_get_led_cfg(qdev))
+		if (qlge_mb_get_led_cfg(qdev))
 			return -EIO;
 
 		/* Start blinking */
-		ql_mb_set_led_cfg(qdev, QL_LED_BLINK);
+		qlge_mb_set_led_cfg(qdev, QL_LED_BLINK);
 		return 0;
 
 	case ETHTOOL_ID_INACTIVE:
 		/* Restore LED settings */
-		if (ql_mb_set_led_cfg(qdev, qdev->led_config))
+		if (qlge_mb_set_led_cfg(qdev, qdev->led_config))
 			return -EIO;
 		return 0;
 
@@ -489,7 +489,7 @@ static int ql_set_phys_id(struct net_device *ndev,
 	}
 }
 
-static int ql_start_loopback(struct ql_adapter *qdev)
+static int qlge_start_loopback(struct qlge_adapter *qdev)
 {
 	if (netif_carrier_ok(qdev->ndev)) {
 		set_bit(QL_LB_LINK_UP, &qdev->flags);
@@ -498,21 +498,21 @@ static int ql_start_loopback(struct ql_adapter *qdev)
 		clear_bit(QL_LB_LINK_UP, &qdev->flags);
 	}
 	qdev->link_config |= CFG_LOOPBACK_PCS;
-	return ql_mb_set_port_cfg(qdev);
+	return qlge_mb_set_port_cfg(qdev);
 }
 
-static void ql_stop_loopback(struct ql_adapter *qdev)
+static void qlge_stop_loopback(struct qlge_adapter *qdev)
 {
 	qdev->link_config &= ~CFG_LOOPBACK_PCS;
-	ql_mb_set_port_cfg(qdev);
+	qlge_mb_set_port_cfg(qdev);
 	if (test_bit(QL_LB_LINK_UP, &qdev->flags)) {
 		netif_carrier_on(qdev->ndev);
 		clear_bit(QL_LB_LINK_UP, &qdev->flags);
 	}
 }
 
-static void ql_create_lb_frame(struct sk_buff *skb,
-			       unsigned int frame_size)
+static void qlge_create_lb_frame(struct sk_buff *skb,
+				 unsigned int frame_size)
 {
 	memset(skb->data, 0xFF, frame_size);
 	frame_size &= ~1;
@@ -521,8 +521,8 @@ static void ql_create_lb_frame(struct sk_buff *skb,
 	skb->data[frame_size / 2 + 12] = (unsigned char)0xAF;
 }
 
-void ql_check_lb_frame(struct ql_adapter *qdev,
-		       struct sk_buff *skb)
+void qlge_check_lb_frame(struct qlge_adapter *qdev,
+			 struct sk_buff *skb)
 {
 	unsigned int frame_size = skb->len;
 
@@ -534,7 +534,7 @@ void ql_check_lb_frame(struct ql_adapter *qdev,
 	}
 }
 
-static int ql_run_loopback_test(struct ql_adapter *qdev)
+static int qlge_run_loopback_test(struct qlge_adapter *qdev)
 {
 	int i;
 	netdev_tx_t rc;
@@ -548,33 +548,33 @@ static int ql_run_loopback_test(struct ql_adapter *qdev)
 
 		skb->queue_mapping = 0;
 		skb_put(skb, size);
-		ql_create_lb_frame(skb, size);
-		rc = ql_lb_send(skb, qdev->ndev);
+		qlge_create_lb_frame(skb, size);
+		rc = qlge_lb_send(skb, qdev->ndev);
 		if (rc != NETDEV_TX_OK)
 			return -EPIPE;
 		atomic_inc(&qdev->lb_count);
 	}
 	/* Give queue time to settle before testing results. */
 	msleep(2);
-	ql_clean_lb_rx_ring(&qdev->rx_ring[0], 128);
+	qlge_clean_lb_rx_ring(&qdev->rx_ring[0], 128);
 	return atomic_read(&qdev->lb_count) ? -EIO : 0;
 }
 
-static int ql_loopback_test(struct ql_adapter *qdev, u64 *data)
+static int qlge_loopback_test(struct qlge_adapter *qdev, u64 *data)
 {
-	*data = ql_start_loopback(qdev);
+	*data = qlge_start_loopback(qdev);
 	if (*data)
 		goto out;
-	*data = ql_run_loopback_test(qdev);
+	*data = qlge_run_loopback_test(qdev);
 out:
-	ql_stop_loopback(qdev);
+	qlge_stop_loopback(qdev);
 	return *data;
 }
 
-static void ql_self_test(struct net_device *ndev,
-			 struct ethtool_test *eth_test, u64 *data)
+static void qlge_self_test(struct net_device *ndev,
+			   struct ethtool_test *eth_test, u64 *data)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 
 	memset(data, 0, sizeof(u64) * QLGE_TEST_LEN);
 
@@ -582,7 +582,7 @@ static void ql_self_test(struct net_device *ndev,
 		set_bit(QL_SELFTEST, &qdev->flags);
 		if (eth_test->flags == ETH_TEST_FL_OFFLINE) {
 			/* Offline tests */
-			if (ql_loopback_test(qdev, &data[0]))
+			if (qlge_loopback_test(qdev, &data[0]))
 				eth_test->flags |= ETH_TEST_FL_FAILED;
 
 		} else {
@@ -601,32 +601,32 @@ static void ql_self_test(struct net_device *ndev,
 	}
 }
 
-static int ql_get_regs_len(struct net_device *ndev)
+static int qlge_get_regs_len(struct net_device *ndev)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 
 	if (!test_bit(QL_FRC_COREDUMP, &qdev->flags))
-		return sizeof(struct ql_mpi_coredump);
+		return sizeof(struct qlge_mpi_coredump);
 	else
-		return sizeof(struct ql_reg_dump);
+		return sizeof(struct qlge_reg_dump);
 }
 
-static void ql_get_regs(struct net_device *ndev,
-			struct ethtool_regs *regs, void *p)
+static void qlge_get_regs(struct net_device *ndev,
+			  struct ethtool_regs *regs, void *p)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 
-	ql_get_dump(qdev, p);
+	qlge_get_dump(qdev, p);
 	qdev->core_is_dumped = 0;
 	if (!test_bit(QL_FRC_COREDUMP, &qdev->flags))
-		regs->len = sizeof(struct ql_mpi_coredump);
+		regs->len = sizeof(struct qlge_mpi_coredump);
 	else
-		regs->len = sizeof(struct ql_reg_dump);
+		regs->len = sizeof(struct qlge_reg_dump);
 }
 
-static int ql_get_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
+static int qlge_get_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
 {
-	struct ql_adapter *qdev = netdev_priv(dev);
+	struct qlge_adapter *qdev = netdev_priv(dev);
 
 	c->rx_coalesce_usecs = qdev->rx_coalesce_usecs;
 	c->tx_coalesce_usecs = qdev->tx_coalesce_usecs;
@@ -647,14 +647,14 @@ static int ql_get_coalesce(struct net_device *dev, struct ethtool_coalesce *c)
 	return 0;
 }
 
-static int ql_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *c)
+static int qlge_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *c)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 
 	/* Validate user parameters. */
 	if (c->rx_coalesce_usecs > qdev->rx_ring_size / 2)
 		return -EINVAL;
-       /* Don't wait more than 10 usec. */
+	/* Don't wait more than 10 usec. */
 	if (c->rx_max_coalesced_frames > MAX_INTER_FRAME_WAIT)
 		return -EINVAL;
 	if (c->tx_coalesce_usecs > qdev->tx_ring_size / 2)
@@ -674,25 +674,25 @@ static int ql_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *c)
 	qdev->rx_max_coalesced_frames = c->rx_max_coalesced_frames;
 	qdev->tx_max_coalesced_frames = c->tx_max_coalesced_frames;
 
-	return ql_update_ring_coalescing(qdev);
+	return qlge_update_ring_coalescing(qdev);
 }
 
-static void ql_get_pauseparam(struct net_device *netdev,
-			      struct ethtool_pauseparam *pause)
+static void qlge_get_pauseparam(struct net_device *netdev,
+				struct ethtool_pauseparam *pause)
 {
-	struct ql_adapter *qdev = netdev_priv(netdev);
+	struct qlge_adapter *qdev = netdev_priv(netdev);
 
-	ql_mb_get_port_cfg(qdev);
+	qlge_mb_get_port_cfg(qdev);
 	if (qdev->link_config & CFG_PAUSE_STD) {
 		pause->rx_pause = 1;
 		pause->tx_pause = 1;
 	}
 }
 
-static int ql_set_pauseparam(struct net_device *netdev,
-			     struct ethtool_pauseparam *pause)
+static int qlge_set_pauseparam(struct net_device *netdev,
+			       struct ethtool_pauseparam *pause)
 {
-	struct ql_adapter *qdev = netdev_priv(netdev);
+	struct qlge_adapter *qdev = netdev_priv(netdev);
 
 	if ((pause->rx_pause) && (pause->tx_pause))
 		qdev->link_config |= CFG_PAUSE_STD;
@@ -701,19 +701,19 @@ static int ql_set_pauseparam(struct net_device *netdev,
 	else
 		return -EINVAL;
 
-	return ql_mb_set_port_cfg(qdev);
+	return qlge_mb_set_port_cfg(qdev);
 }
 
-static u32 ql_get_msglevel(struct net_device *ndev)
+static u32 qlge_get_msglevel(struct net_device *ndev)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 
 	return qdev->msg_enable;
 }
 
-static void ql_set_msglevel(struct net_device *ndev, u32 value)
+static void qlge_set_msglevel(struct net_device *ndev, u32 value)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 
 	qdev->msg_enable = value;
 }
@@ -721,23 +721,23 @@ static void ql_set_msglevel(struct net_device *ndev, u32 value)
 const struct ethtool_ops qlge_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
-	.get_drvinfo = ql_get_drvinfo,
-	.get_wol = ql_get_wol,
-	.set_wol = ql_set_wol,
-	.get_regs_len	= ql_get_regs_len,
-	.get_regs = ql_get_regs,
-	.get_msglevel = ql_get_msglevel,
-	.set_msglevel = ql_set_msglevel,
+	.get_drvinfo = qlge_get_drvinfo,
+	.get_wol = qlge_get_wol,
+	.set_wol = qlge_set_wol,
+	.get_regs_len	= qlge_get_regs_len,
+	.get_regs = qlge_get_regs,
+	.get_msglevel = qlge_get_msglevel,
+	.set_msglevel = qlge_set_msglevel,
 	.get_link = ethtool_op_get_link,
-	.set_phys_id		 = ql_set_phys_id,
-	.self_test		 = ql_self_test,
-	.get_pauseparam		 = ql_get_pauseparam,
-	.set_pauseparam		 = ql_set_pauseparam,
-	.get_coalesce = ql_get_coalesce,
-	.set_coalesce = ql_set_coalesce,
-	.get_sset_count = ql_get_sset_count,
-	.get_strings = ql_get_strings,
-	.get_ethtool_stats = ql_get_ethtool_stats,
-	.get_link_ksettings = ql_get_link_ksettings,
+	.set_phys_id		 = qlge_set_phys_id,
+	.self_test		 = qlge_self_test,
+	.get_pauseparam		 = qlge_get_pauseparam,
+	.set_pauseparam		 = qlge_set_pauseparam,
+	.get_coalesce = qlge_get_coalesce,
+	.set_coalesce = qlge_set_coalesce,
+	.get_sset_count = qlge_get_sset_count,
+	.get_strings = qlge_get_strings,
+	.get_ethtool_stats = qlge_get_ethtool_stats,
+	.get_link_ksettings = qlge_get_link_ksettings,
 };
 
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index e6b7baa12cd6..4042ea8d36a5 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -89,16 +89,16 @@ static const struct pci_device_id qlge_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, qlge_pci_tbl);
 
-static int ql_wol(struct ql_adapter *);
+static int qlge_wol(struct qlge_adapter *);
 static void qlge_set_multicast_list(struct net_device *);
-static int ql_adapter_down(struct ql_adapter *);
-static int ql_adapter_up(struct ql_adapter *);
+static int qlge_adapter_down(struct qlge_adapter *);
+static int qlge_adapter_up(struct qlge_adapter *);
 
 /* This hardware semaphore causes exclusive access to
  * resources shared between the NIC driver, MPI firmware,
  * FCOE firmware and the FC driver.
  */
-static int ql_sem_trylock(struct ql_adapter *qdev, u32 sem_mask)
+static int qlge_sem_trylock(struct qlge_adapter *qdev, u32 sem_mask)
 {
 	u32 sem_bits = 0;
 
@@ -132,26 +132,26 @@ static int ql_sem_trylock(struct ql_adapter *qdev, u32 sem_mask)
 		return -EINVAL;
 	}
 
-	ql_write32(qdev, SEM, sem_bits | sem_mask);
-	return !(ql_read32(qdev, SEM) & sem_bits);
+	qlge_write32(qdev, SEM, sem_bits | sem_mask);
+	return !(qlge_read32(qdev, SEM) & sem_bits);
 }
 
-int ql_sem_spinlock(struct ql_adapter *qdev, u32 sem_mask)
+int qlge_sem_spinlock(struct qlge_adapter *qdev, u32 sem_mask)
 {
 	unsigned int wait_count = 30;
 
 	do {
-		if (!ql_sem_trylock(qdev, sem_mask))
+		if (!qlge_sem_trylock(qdev, sem_mask))
 			return 0;
 		udelay(100);
 	} while (--wait_count);
 	return -ETIMEDOUT;
 }
 
-void ql_sem_unlock(struct ql_adapter *qdev, u32 sem_mask)
+void qlge_sem_unlock(struct qlge_adapter *qdev, u32 sem_mask)
 {
-	ql_write32(qdev, SEM, sem_mask);
-	ql_read32(qdev, SEM);	/* flush */
+	qlge_write32(qdev, SEM, sem_mask);
+	qlge_read32(qdev, SEM);	/* flush */
 }
 
 /* This function waits for a specific bit to come ready
@@ -159,13 +159,13 @@ void ql_sem_unlock(struct ql_adapter *qdev, u32 sem_mask)
  * process, but is also used in kernel thread API such as
  * netdev->set_multi, netdev->set_mac_address, netdev->vlan_rx_add_vid.
  */
-int ql_wait_reg_rdy(struct ql_adapter *qdev, u32 reg, u32 bit, u32 err_bit)
+int qlge_wait_reg_rdy(struct qlge_adapter *qdev, u32 reg, u32 bit, u32 err_bit)
 {
 	u32 temp;
 	int count;
 
 	for (count = 0; count < UDELAY_COUNT; count++) {
-		temp = ql_read32(qdev, reg);
+		temp = qlge_read32(qdev, reg);
 
 		/* check for errors */
 		if (temp & err_bit) {
@@ -186,13 +186,13 @@ int ql_wait_reg_rdy(struct ql_adapter *qdev, u32 reg, u32 bit, u32 err_bit)
 /* The CFG register is used to download TX and RX control blocks
  * to the chip. This function waits for an operation to complete.
  */
-static int ql_wait_cfg(struct ql_adapter *qdev, u32 bit)
+static int qlge_wait_cfg(struct qlge_adapter *qdev, u32 bit)
 {
 	int count;
 	u32 temp;
 
 	for (count = 0; count < UDELAY_COUNT; count++) {
-		temp = ql_read32(qdev, CFG);
+		temp = qlge_read32(qdev, CFG);
 		if (temp & CFG_LE)
 			return -EIO;
 		if (!(temp & bit))
@@ -205,8 +205,8 @@ static int ql_wait_cfg(struct ql_adapter *qdev, u32 bit)
 /* Used to issue init control blocks to hw. Maps control block,
  * sets address, triggers download, waits for completion.
  */
-int ql_write_cfg(struct ql_adapter *qdev, void *ptr, int size, u32 bit,
-		 u16 q_id)
+int qlge_write_cfg(struct qlge_adapter *qdev, void *ptr, int size, u32 bit,
+		   u16 q_id)
 {
 	u64 map;
 	int status = 0;
@@ -225,38 +225,38 @@ int ql_write_cfg(struct ql_adapter *qdev, void *ptr, int size, u32 bit,
 		return -ENOMEM;
 	}
 
-	status = ql_sem_spinlock(qdev, SEM_ICB_MASK);
+	status = qlge_sem_spinlock(qdev, SEM_ICB_MASK);
 	if (status)
 		goto lock_failed;
 
-	status = ql_wait_cfg(qdev, bit);
+	status = qlge_wait_cfg(qdev, bit);
 	if (status) {
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Timed out waiting for CFG to come ready.\n");
 		goto exit;
 	}
 
-	ql_write32(qdev, ICB_L, (u32)map);
-	ql_write32(qdev, ICB_H, (u32)(map >> 32));
+	qlge_write32(qdev, ICB_L, (u32)map);
+	qlge_write32(qdev, ICB_H, (u32)(map >> 32));
 
 	mask = CFG_Q_MASK | (bit << 16);
 	value = bit | (q_id << CFG_Q_SHIFT);
-	ql_write32(qdev, CFG, (mask | value));
+	qlge_write32(qdev, CFG, (mask | value));
 
 	/*
 	 * Wait for the bit to clear after signaling hw.
 	 */
-	status = ql_wait_cfg(qdev, bit);
+	status = qlge_wait_cfg(qdev, bit);
 exit:
-	ql_sem_unlock(qdev, SEM_ICB_MASK);	/* does flush too */
+	qlge_sem_unlock(qdev, SEM_ICB_MASK);	/* does flush too */
 lock_failed:
 	dma_unmap_single(&qdev->pdev->dev, map, size, direction);
 	return status;
 }
 
 /* Get a specific MAC address from the CAM.  Used for debug and reg dump. */
-int ql_get_mac_addr_reg(struct ql_adapter *qdev, u32 type, u16 index,
-			u32 *value)
+int qlge_get_mac_addr_reg(struct qlge_adapter *qdev, u32 type, u16 index,
+			  u32 *value)
 {
 	u32 offset = 0;
 	int status;
@@ -264,46 +264,46 @@ int ql_get_mac_addr_reg(struct ql_adapter *qdev, u32 type, u16 index,
 	switch (type) {
 	case MAC_ADDR_TYPE_MULTI_MAC:
 	case MAC_ADDR_TYPE_CAM_MAC: {
-		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+		status = qlge_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 		if (status)
 			break;
-		ql_write32(qdev, MAC_ADDR_IDX,
-			   (offset++) | /* offset */
+		qlge_write32(qdev, MAC_ADDR_IDX,
+			     (offset++) | /* offset */
 				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
 				   MAC_ADDR_ADR | MAC_ADDR_RS |
 				   type); /* type */
-		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MR, 0);
+		status = qlge_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MR, 0);
 		if (status)
 			break;
-		*value++ = ql_read32(qdev, MAC_ADDR_DATA);
-		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+		*value++ = qlge_read32(qdev, MAC_ADDR_DATA);
+		status = qlge_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 		if (status)
 			break;
-		ql_write32(qdev, MAC_ADDR_IDX,
-			   (offset++) | /* offset */
+		qlge_write32(qdev, MAC_ADDR_IDX,
+			     (offset++) | /* offset */
 				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
 				   MAC_ADDR_ADR | MAC_ADDR_RS |
 				   type); /* type */
-		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MR, 0);
+		status = qlge_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MR, 0);
 		if (status)
 			break;
-		*value++ = ql_read32(qdev, MAC_ADDR_DATA);
+		*value++ = qlge_read32(qdev, MAC_ADDR_DATA);
 		if (type == MAC_ADDR_TYPE_CAM_MAC) {
-			status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX,
-						 MAC_ADDR_MW, 0);
+			status = qlge_wait_reg_rdy(qdev, MAC_ADDR_IDX,
+						   MAC_ADDR_MW, 0);
 			if (status)
 				break;
-			ql_write32(qdev, MAC_ADDR_IDX,
-				   (offset++) | /* offset */
+			qlge_write32(qdev, MAC_ADDR_IDX,
+				     (offset++) | /* offset */
 					   (index
 					    << MAC_ADDR_IDX_SHIFT) | /* index */
 					   MAC_ADDR_ADR |
 					   MAC_ADDR_RS | type); /* type */
-			status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX,
-						 MAC_ADDR_MR, 0);
+			status = qlge_wait_reg_rdy(qdev, MAC_ADDR_IDX,
+						   MAC_ADDR_MR, 0);
 			if (status)
 				break;
-			*value++ = ql_read32(qdev, MAC_ADDR_DATA);
+			*value++ = qlge_read32(qdev, MAC_ADDR_DATA);
 		}
 		break;
 	}
@@ -320,8 +320,8 @@ int ql_get_mac_addr_reg(struct ql_adapter *qdev, u32 type, u16 index,
 /* Set up a MAC, multicast or VLAN address for the
  * inbound frame matching.
  */
-static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
-			       u16 index)
+static int qlge_set_mac_addr_reg(struct qlge_adapter *qdev, u8 *addr, u32 type,
+				 u16 index)
 {
 	u32 offset = 0;
 	int status = 0;
@@ -332,22 +332,22 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 		u32 lower = (addr[2] << 24) | (addr[3] << 16) | (addr[4] << 8) |
 			    (addr[5]);
 
-		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+		status = qlge_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 		if (status)
 			break;
-		ql_write32(qdev, MAC_ADDR_IDX,
-			   (offset++) | (index << MAC_ADDR_IDX_SHIFT) | type |
+		qlge_write32(qdev, MAC_ADDR_IDX,
+			     (offset++) | (index << MAC_ADDR_IDX_SHIFT) | type |
 				   MAC_ADDR_E);
-		ql_write32(qdev, MAC_ADDR_DATA, lower);
-		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+		qlge_write32(qdev, MAC_ADDR_DATA, lower);
+		status = qlge_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 		if (status)
 			break;
-		ql_write32(qdev, MAC_ADDR_IDX,
-			   (offset++) | (index << MAC_ADDR_IDX_SHIFT) | type |
+		qlge_write32(qdev, MAC_ADDR_IDX,
+			     (offset++) | (index << MAC_ADDR_IDX_SHIFT) | type |
 				   MAC_ADDR_E);
 
-		ql_write32(qdev, MAC_ADDR_DATA, upper);
-		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+		qlge_write32(qdev, MAC_ADDR_DATA, upper);
+		status = qlge_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 		break;
 	}
 	case MAC_ADDR_TYPE_CAM_MAC: {
@@ -355,27 +355,27 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 		u32 upper = (addr[0] << 8) | addr[1];
 		u32 lower = (addr[2] << 24) | (addr[3] << 16) | (addr[4] << 8) |
 			    (addr[5]);
-		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+		status = qlge_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 		if (status)
 			break;
-		ql_write32(qdev, MAC_ADDR_IDX,
-			   (offset++) | /* offset */
+		qlge_write32(qdev, MAC_ADDR_IDX,
+			     (offset++) | /* offset */
 				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
 				   type); /* type */
-		ql_write32(qdev, MAC_ADDR_DATA, lower);
-		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+		qlge_write32(qdev, MAC_ADDR_DATA, lower);
+		status = qlge_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 		if (status)
 			break;
-		ql_write32(qdev, MAC_ADDR_IDX,
-			   (offset++) | /* offset */
+		qlge_write32(qdev, MAC_ADDR_IDX,
+			     (offset++) | /* offset */
 				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
 				   type); /* type */
-		ql_write32(qdev, MAC_ADDR_DATA, upper);
-		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+		qlge_write32(qdev, MAC_ADDR_DATA, upper);
+		status = qlge_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 		if (status)
 			break;
-		ql_write32(qdev, MAC_ADDR_IDX,
-			   (offset) | /* offset */
+		qlge_write32(qdev, MAC_ADDR_IDX,
+			     (offset) | /* offset */
 				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
 				   type); /* type */
 		/* This field should also include the queue id
@@ -388,7 +388,7 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 		if (qdev->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)
 			cam_output |= CAM_OUT_RV;
 		/* route to NIC core */
-		ql_write32(qdev, MAC_ADDR_DATA, cam_output);
+		qlge_write32(qdev, MAC_ADDR_DATA, cam_output);
 		break;
 	}
 	case MAC_ADDR_TYPE_VLAN: {
@@ -398,11 +398,11 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
 		 * addressing. It's either MAC_ADDR_E on or off.
 		 * That's bit-27 we're talking about.
 		 */
-		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
+		status = qlge_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
 		if (status)
 			break;
-		ql_write32(qdev, MAC_ADDR_IDX,
-			   offset | /* offset */
+		qlge_write32(qdev, MAC_ADDR_IDX,
+			     offset | /* offset */
 				   (index << MAC_ADDR_IDX_SHIFT) | /* index */
 				   type | /* type */
 				   enable_bit); /* enable/disable */
@@ -421,7 +421,7 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
  * have to clear it to prevent wrong frame routing
  * especially in a bonding environment.
  */
-static int ql_set_mac_addr(struct ql_adapter *qdev, int set)
+static int qlge_set_mac_addr(struct qlge_adapter *qdev, int set)
 {
 	int status;
 	char zero_mac_addr[ETH_ALEN];
@@ -437,50 +437,50 @@ static int ql_set_mac_addr(struct ql_adapter *qdev, int set)
 		netif_printk(qdev, ifup, KERN_DEBUG, qdev->ndev,
 			     "Clearing MAC address\n");
 	}
-	status = ql_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
+	status = qlge_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
 	if (status)
 		return status;
-	status = ql_set_mac_addr_reg(qdev, (u8 *)addr,
-				     MAC_ADDR_TYPE_CAM_MAC,
-				     qdev->func * MAX_CQ);
-	ql_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
+	status = qlge_set_mac_addr_reg(qdev, (u8 *)addr,
+				       MAC_ADDR_TYPE_CAM_MAC,
+				       qdev->func * MAX_CQ);
+	qlge_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
 	if (status)
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Failed to init mac address.\n");
 	return status;
 }
 
-void ql_link_on(struct ql_adapter *qdev)
+void qlge_link_on(struct qlge_adapter *qdev)
 {
 	netif_err(qdev, link, qdev->ndev, "Link is up.\n");
 	netif_carrier_on(qdev->ndev);
-	ql_set_mac_addr(qdev, 1);
+	qlge_set_mac_addr(qdev, 1);
 }
 
-void ql_link_off(struct ql_adapter *qdev)
+void qlge_link_off(struct qlge_adapter *qdev)
 {
 	netif_err(qdev, link, qdev->ndev, "Link is down.\n");
 	netif_carrier_off(qdev->ndev);
-	ql_set_mac_addr(qdev, 0);
+	qlge_set_mac_addr(qdev, 0);
 }
 
 /* Get a specific frame routing value from the CAM.
  * Used for debug and reg dump.
  */
-int ql_get_routing_reg(struct ql_adapter *qdev, u32 index, u32 *value)
+int qlge_get_routing_reg(struct qlge_adapter *qdev, u32 index, u32 *value)
 {
 	int status = 0;
 
-	status = ql_wait_reg_rdy(qdev, RT_IDX, RT_IDX_MW, 0);
+	status = qlge_wait_reg_rdy(qdev, RT_IDX, RT_IDX_MW, 0);
 	if (status)
 		goto exit;
 
-	ql_write32(qdev, RT_IDX,
-		   RT_IDX_TYPE_NICQ | RT_IDX_RS | (index << RT_IDX_IDX_SHIFT));
-	status = ql_wait_reg_rdy(qdev, RT_IDX, RT_IDX_MR, 0);
+	qlge_write32(qdev, RT_IDX,
+		     RT_IDX_TYPE_NICQ | RT_IDX_RS | (index << RT_IDX_IDX_SHIFT));
+	status = qlge_wait_reg_rdy(qdev, RT_IDX, RT_IDX_MR, 0);
 	if (status)
 		goto exit;
-	*value = ql_read32(qdev, RT_DATA);
+	*value = qlge_read32(qdev, RT_DATA);
 exit:
 	return status;
 }
@@ -490,8 +490,8 @@ int ql_get_routing_reg(struct ql_adapter *qdev, u32 index, u32 *value)
  * multicast/error frames to the default queue for slow handling,
  * and CAM hit/RSS frames to the fast handling queues.
  */
-static int ql_set_routing_reg(struct ql_adapter *qdev, u32 index, u32 mask,
-			      int enable)
+static int qlge_set_routing_reg(struct qlge_adapter *qdev, u32 index, u32 mask,
+				int enable)
 {
 	int status = -EINVAL; /* Return error if no mask match. */
 	u32 value = 0;
@@ -577,50 +577,50 @@ static int ql_set_routing_reg(struct ql_adapter *qdev, u32 index, u32 mask,
 	}
 
 	if (value) {
-		status = ql_wait_reg_rdy(qdev, RT_IDX, RT_IDX_MW, 0);
+		status = qlge_wait_reg_rdy(qdev, RT_IDX, RT_IDX_MW, 0);
 		if (status)
 			goto exit;
 		value |= (enable ? RT_IDX_E : 0);
-		ql_write32(qdev, RT_IDX, value);
-		ql_write32(qdev, RT_DATA, enable ? mask : 0);
+		qlge_write32(qdev, RT_IDX, value);
+		qlge_write32(qdev, RT_DATA, enable ? mask : 0);
 	}
 exit:
 	return status;
 }
 
-static void ql_enable_interrupts(struct ql_adapter *qdev)
+static void qlge_enable_interrupts(struct qlge_adapter *qdev)
 {
-	ql_write32(qdev, INTR_EN, (INTR_EN_EI << 16) | INTR_EN_EI);
+	qlge_write32(qdev, INTR_EN, (INTR_EN_EI << 16) | INTR_EN_EI);
 }
 
-static void ql_disable_interrupts(struct ql_adapter *qdev)
+static void qlge_disable_interrupts(struct qlge_adapter *qdev)
 {
-	ql_write32(qdev, INTR_EN, (INTR_EN_EI << 16));
+	qlge_write32(qdev, INTR_EN, (INTR_EN_EI << 16));
 }
 
-static void ql_enable_completion_interrupt(struct ql_adapter *qdev, u32 intr)
+static void qlge_enable_completion_interrupt(struct qlge_adapter *qdev, u32 intr)
 {
 	struct intr_context *ctx = &qdev->intr_context[intr];
 
-	ql_write32(qdev, INTR_EN, ctx->intr_en_mask);
+	qlge_write32(qdev, INTR_EN, ctx->intr_en_mask);
 }
 
-static void ql_disable_completion_interrupt(struct ql_adapter *qdev, u32 intr)
+static void qlge_disable_completion_interrupt(struct qlge_adapter *qdev, u32 intr)
 {
 	struct intr_context *ctx = &qdev->intr_context[intr];
 
-	ql_write32(qdev, INTR_EN, ctx->intr_dis_mask);
+	qlge_write32(qdev, INTR_EN, ctx->intr_dis_mask);
 }
 
-static void ql_enable_all_completion_interrupts(struct ql_adapter *qdev)
+static void qlge_enable_all_completion_interrupts(struct qlge_adapter *qdev)
 {
 	int i;
 
 	for (i = 0; i < qdev->intr_count; i++)
-		ql_enable_completion_interrupt(qdev, i);
+		qlge_enable_completion_interrupt(qdev, i);
 }
 
-static int ql_validate_flash(struct ql_adapter *qdev, u32 size, const char *str)
+static int qlge_validate_flash(struct qlge_adapter *qdev, u32 size, const char *str)
 {
 	int status, i;
 	u16 csum = 0;
@@ -642,31 +642,31 @@ static int ql_validate_flash(struct ql_adapter *qdev, u32 size, const char *str)
 	return csum;
 }
 
-static int ql_read_flash_word(struct ql_adapter *qdev, int offset, __le32 *data)
+static int qlge_read_flash_word(struct qlge_adapter *qdev, int offset, __le32 *data)
 {
 	int status = 0;
 	/* wait for reg to come ready */
-	status = ql_wait_reg_rdy(qdev,
-				 FLASH_ADDR, FLASH_ADDR_RDY, FLASH_ADDR_ERR);
+	status = qlge_wait_reg_rdy(qdev,
+				   FLASH_ADDR, FLASH_ADDR_RDY, FLASH_ADDR_ERR);
 	if (status)
 		goto exit;
 	/* set up for reg read */
-	ql_write32(qdev, FLASH_ADDR, FLASH_ADDR_R | offset);
+	qlge_write32(qdev, FLASH_ADDR, FLASH_ADDR_R | offset);
 	/* wait for reg to come ready */
-	status = ql_wait_reg_rdy(qdev,
-				 FLASH_ADDR, FLASH_ADDR_RDY, FLASH_ADDR_ERR);
+	status = qlge_wait_reg_rdy(qdev,
+				   FLASH_ADDR, FLASH_ADDR_RDY, FLASH_ADDR_ERR);
 	if (status)
 		goto exit;
 	/* This data is stored on flash as an array of
-	 * __le32.  Since ql_read32() returns cpu endian
+	 * __le32.  Since qlge_read32() returns cpu endian
 	 * we need to swap it back.
 	 */
-	*data = cpu_to_le32(ql_read32(qdev, FLASH_DATA));
+	*data = cpu_to_le32(qlge_read32(qdev, FLASH_DATA));
 exit:
 	return status;
 }
 
-static int ql_get_8000_flash_params(struct ql_adapter *qdev)
+static int qlge_get_8000_flash_params(struct qlge_adapter *qdev)
 {
 	u32 i, size;
 	int status;
@@ -682,12 +682,12 @@ static int ql_get_8000_flash_params(struct ql_adapter *qdev)
 	else
 		offset = FUNC1_FLASH_OFFSET / sizeof(u32);
 
-	if (ql_sem_spinlock(qdev, SEM_FLASH_MASK))
+	if (qlge_sem_spinlock(qdev, SEM_FLASH_MASK))
 		return -ETIMEDOUT;
 
 	size = sizeof(struct flash_params_8000) / sizeof(u32);
 	for (i = 0; i < size; i++, p++) {
-		status = ql_read_flash_word(qdev, i + offset, p);
+		status = qlge_read_flash_word(qdev, i + offset, p);
 		if (status) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Error reading flash.\n");
@@ -695,8 +695,8 @@ static int ql_get_8000_flash_params(struct ql_adapter *qdev)
 		}
 	}
 
-	status = ql_validate_flash(qdev,
-				   sizeof(struct flash_params_8000) /
+	status = qlge_validate_flash(qdev,
+				     sizeof(struct flash_params_8000) /
 				   sizeof(u16),
 				   "8000");
 	if (status) {
@@ -728,11 +728,11 @@ static int ql_get_8000_flash_params(struct ql_adapter *qdev)
 	       qdev->ndev->addr_len);
 
 exit:
-	ql_sem_unlock(qdev, SEM_FLASH_MASK);
+	qlge_sem_unlock(qdev, SEM_FLASH_MASK);
 	return status;
 }
 
-static int ql_get_8012_flash_params(struct ql_adapter *qdev)
+static int qlge_get_8012_flash_params(struct qlge_adapter *qdev)
 {
 	int i;
 	int status;
@@ -746,11 +746,11 @@ static int ql_get_8012_flash_params(struct ql_adapter *qdev)
 	if (qdev->port)
 		offset = size;
 
-	if (ql_sem_spinlock(qdev, SEM_FLASH_MASK))
+	if (qlge_sem_spinlock(qdev, SEM_FLASH_MASK))
 		return -ETIMEDOUT;
 
 	for (i = 0; i < size; i++, p++) {
-		status = ql_read_flash_word(qdev, i + offset, p);
+		status = qlge_read_flash_word(qdev, i + offset, p);
 		if (status) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Error reading flash.\n");
@@ -758,10 +758,10 @@ static int ql_get_8012_flash_params(struct ql_adapter *qdev)
 		}
 	}
 
-	status = ql_validate_flash(qdev,
-				   sizeof(struct flash_params_8012) /
-				   sizeof(u16),
-				   "8012");
+	status = qlge_validate_flash(qdev,
+				     sizeof(struct flash_params_8012) /
+				       sizeof(u16),
+				     "8012");
 	if (status) {
 		netif_err(qdev, ifup, qdev->ndev, "Invalid flash.\n");
 		status = -EINVAL;
@@ -778,7 +778,7 @@ static int ql_get_8012_flash_params(struct ql_adapter *qdev)
 	       qdev->ndev->addr_len);
 
 exit:
-	ql_sem_unlock(qdev, SEM_FLASH_MASK);
+	qlge_sem_unlock(qdev, SEM_FLASH_MASK);
 	return status;
 }
 
@@ -786,18 +786,18 @@ static int ql_get_8012_flash_params(struct ql_adapter *qdev)
  * register pair.  Each read/write requires us to wait for the ready
  * bit before reading/writing the data.
  */
-static int ql_write_xgmac_reg(struct ql_adapter *qdev, u32 reg, u32 data)
+static int qlge_write_xgmac_reg(struct qlge_adapter *qdev, u32 reg, u32 data)
 {
 	int status;
 	/* wait for reg to come ready */
-	status = ql_wait_reg_rdy(qdev,
-				 XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
+	status = qlge_wait_reg_rdy(qdev,
+				   XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
 	if (status)
 		return status;
 	/* write the data to the data reg */
-	ql_write32(qdev, XGMAC_DATA, data);
+	qlge_write32(qdev, XGMAC_DATA, data);
 	/* trigger the write */
-	ql_write32(qdev, XGMAC_ADDR, reg);
+	qlge_write32(qdev, XGMAC_ADDR, reg);
 	return status;
 }
 
@@ -805,39 +805,39 @@ static int ql_write_xgmac_reg(struct ql_adapter *qdev, u32 reg, u32 data)
  * register pair.  Each read/write requires us to wait for the ready
  * bit before reading/writing the data.
  */
-int ql_read_xgmac_reg(struct ql_adapter *qdev, u32 reg, u32 *data)
+int qlge_read_xgmac_reg(struct qlge_adapter *qdev, u32 reg, u32 *data)
 {
 	int status = 0;
 	/* wait for reg to come ready */
-	status = ql_wait_reg_rdy(qdev,
-				 XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
+	status = qlge_wait_reg_rdy(qdev,
+				   XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
 	if (status)
 		goto exit;
 	/* set up for reg read */
-	ql_write32(qdev, XGMAC_ADDR, reg | XGMAC_ADDR_R);
+	qlge_write32(qdev, XGMAC_ADDR, reg | XGMAC_ADDR_R);
 	/* wait for reg to come ready */
-	status = ql_wait_reg_rdy(qdev,
-				 XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
+	status = qlge_wait_reg_rdy(qdev,
+				   XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
 	if (status)
 		goto exit;
 	/* get the data */
-	*data = ql_read32(qdev, XGMAC_DATA);
+	*data = qlge_read32(qdev, XGMAC_DATA);
 exit:
 	return status;
 }
 
 /* This is used for reading the 64-bit statistics regs. */
-int ql_read_xgmac_reg64(struct ql_adapter *qdev, u32 reg, u64 *data)
+int qlge_read_xgmac_reg64(struct qlge_adapter *qdev, u32 reg, u64 *data)
 {
 	int status = 0;
 	u32 hi = 0;
 	u32 lo = 0;
 
-	status = ql_read_xgmac_reg(qdev, reg, &lo);
+	status = qlge_read_xgmac_reg(qdev, reg, &lo);
 	if (status)
 		goto exit;
 
-	status = ql_read_xgmac_reg(qdev, reg + 4, &hi);
+	status = qlge_read_xgmac_reg(qdev, reg + 4, &hi);
 	if (status)
 		goto exit;
 
@@ -847,17 +847,17 @@ int ql_read_xgmac_reg64(struct ql_adapter *qdev, u32 reg, u64 *data)
 	return status;
 }
 
-static int ql_8000_port_initialize(struct ql_adapter *qdev)
+static int qlge_8000_port_initialize(struct qlge_adapter *qdev)
 {
 	int status;
 	/*
 	 * Get MPI firmware version for driver banner
 	 * and ethool info.
 	 */
-	status = ql_mb_about_fw(qdev);
+	status = qlge_mb_about_fw(qdev);
 	if (status)
 		goto exit;
-	status = ql_mb_get_fw_state(qdev);
+	status = qlge_mb_get_fw_state(qdev);
 	if (status)
 		goto exit;
 	/* Wake up a worker to get/set the TX/RX frame sizes. */
@@ -872,18 +872,18 @@ static int ql_8000_port_initialize(struct ql_adapter *qdev)
  * This functionality may be done in the MPI firmware at a
  * later date.
  */
-static int ql_8012_port_initialize(struct ql_adapter *qdev)
+static int qlge_8012_port_initialize(struct qlge_adapter *qdev)
 {
 	int status = 0;
 	u32 data;
 
-	if (ql_sem_trylock(qdev, qdev->xg_sem_mask)) {
+	if (qlge_sem_trylock(qdev, qdev->xg_sem_mask)) {
 		/* Another function has the semaphore, so
 		 * wait for the port init bit to come ready.
 		 */
 		netif_info(qdev, link, qdev->ndev,
 			   "Another function has the semaphore, so wait for the port init bit to come ready.\n");
-		status = ql_wait_reg_rdy(qdev, STS, qdev->port_init, 0);
+		status = qlge_wait_reg_rdy(qdev, STS, qdev->port_init, 0);
 		if (status) {
 			netif_crit(qdev, link, qdev->ndev,
 				   "Port initialize timed out.\n");
@@ -893,11 +893,11 @@ static int ql_8012_port_initialize(struct ql_adapter *qdev)
 
 	netif_info(qdev, link, qdev->ndev, "Got xgmac semaphore!.\n");
 	/* Set the core reset. */
-	status = ql_read_xgmac_reg(qdev, GLOBAL_CFG, &data);
+	status = qlge_read_xgmac_reg(qdev, GLOBAL_CFG, &data);
 	if (status)
 		goto end;
 	data |= GLOBAL_CFG_RESET;
-	status = ql_write_xgmac_reg(qdev, GLOBAL_CFG, data);
+	status = qlge_write_xgmac_reg(qdev, GLOBAL_CFG, data);
 	if (status)
 		goto end;
 
@@ -906,48 +906,48 @@ static int ql_8012_port_initialize(struct ql_adapter *qdev)
 	data |= GLOBAL_CFG_JUMBO;	/* Turn on jumbo. */
 	data |= GLOBAL_CFG_TX_STAT_EN;
 	data |= GLOBAL_CFG_RX_STAT_EN;
-	status = ql_write_xgmac_reg(qdev, GLOBAL_CFG, data);
+	status = qlge_write_xgmac_reg(qdev, GLOBAL_CFG, data);
 	if (status)
 		goto end;
 
 	/* Enable transmitter, and clear it's reset. */
-	status = ql_read_xgmac_reg(qdev, TX_CFG, &data);
+	status = qlge_read_xgmac_reg(qdev, TX_CFG, &data);
 	if (status)
 		goto end;
 	data &= ~TX_CFG_RESET;	/* Clear the TX MAC reset. */
 	data |= TX_CFG_EN;	/* Enable the transmitter. */
-	status = ql_write_xgmac_reg(qdev, TX_CFG, data);
+	status = qlge_write_xgmac_reg(qdev, TX_CFG, data);
 	if (status)
 		goto end;
 
 	/* Enable receiver and clear it's reset. */
-	status = ql_read_xgmac_reg(qdev, RX_CFG, &data);
+	status = qlge_read_xgmac_reg(qdev, RX_CFG, &data);
 	if (status)
 		goto end;
 	data &= ~RX_CFG_RESET;	/* Clear the RX MAC reset. */
 	data |= RX_CFG_EN;	/* Enable the receiver. */
-	status = ql_write_xgmac_reg(qdev, RX_CFG, data);
+	status = qlge_write_xgmac_reg(qdev, RX_CFG, data);
 	if (status)
 		goto end;
 
 	/* Turn on jumbo. */
 	status =
-	    ql_write_xgmac_reg(qdev, MAC_TX_PARAMS, MAC_TX_PARAMS_JUMBO | (0x2580 << 16));
+	    qlge_write_xgmac_reg(qdev, MAC_TX_PARAMS, MAC_TX_PARAMS_JUMBO | (0x2580 << 16));
 	if (status)
 		goto end;
 	status =
-	    ql_write_xgmac_reg(qdev, MAC_RX_PARAMS, 0x2580);
+	    qlge_write_xgmac_reg(qdev, MAC_RX_PARAMS, 0x2580);
 	if (status)
 		goto end;
 
 	/* Signal to the world that the port is enabled.        */
-	ql_write32(qdev, STS, ((qdev->port_init << 16) | qdev->port_init));
+	qlge_write32(qdev, STS, ((qdev->port_init << 16) | qdev->port_init));
 end:
-	ql_sem_unlock(qdev, qdev->xg_sem_mask);
+	qlge_sem_unlock(qdev, qdev->xg_sem_mask);
 	return status;
 }
 
-static inline unsigned int ql_lbq_block_size(struct ql_adapter *qdev)
+static inline unsigned int qlge_lbq_block_size(struct qlge_adapter *qdev)
 {
 	return PAGE_SIZE << qdev->lbq_buf_order;
 }
@@ -962,8 +962,8 @@ static struct qlge_bq_desc *qlge_get_curr_buf(struct qlge_bq *bq)
 	return bq_desc;
 }
 
-static struct qlge_bq_desc *ql_get_curr_lchunk(struct ql_adapter *qdev,
-					       struct rx_ring *rx_ring)
+static struct qlge_bq_desc *qlge_get_curr_lchunk(struct qlge_adapter *qdev,
+						 struct rx_ring *rx_ring)
 {
 	struct qlge_bq_desc *lbq_desc = qlge_get_curr_buf(&rx_ring->lbq);
 
@@ -971,17 +971,17 @@ static struct qlge_bq_desc *ql_get_curr_lchunk(struct ql_adapter *qdev,
 				qdev->lbq_buf_size, DMA_FROM_DEVICE);
 
 	if ((lbq_desc->p.pg_chunk.offset + qdev->lbq_buf_size) ==
-	    ql_lbq_block_size(qdev)) {
+	    qlge_lbq_block_size(qdev)) {
 		/* last chunk of the master page */
 		dma_unmap_page(&qdev->pdev->dev, lbq_desc->dma_addr,
-			       ql_lbq_block_size(qdev), DMA_FROM_DEVICE);
+			       qlge_lbq_block_size(qdev), DMA_FROM_DEVICE);
 	}
 
 	return lbq_desc;
 }
 
 /* Update an rx ring index. */
-static void ql_update_cq(struct rx_ring *rx_ring)
+static void qlge_update_cq(struct rx_ring *rx_ring)
 {
 	rx_ring->cnsmr_idx++;
 	rx_ring->curr_entry++;
@@ -991,9 +991,9 @@ static void ql_update_cq(struct rx_ring *rx_ring)
 	}
 }
 
-static void ql_write_cq_idx(struct rx_ring *rx_ring)
+static void qlge_write_cq_idx(struct rx_ring *rx_ring)
 {
-	ql_write_db_reg(rx_ring->cnsmr_idx, rx_ring->cnsmr_idx_db_reg);
+	qlge_write_db_reg(rx_ring->cnsmr_idx, rx_ring->cnsmr_idx_db_reg);
 }
 
 static const char * const bq_type_name[] = {
@@ -1005,7 +1005,7 @@ static const char * const bq_type_name[] = {
 static int qlge_refill_sb(struct rx_ring *rx_ring,
 			  struct qlge_bq_desc *sbq_desc, gfp_t gfp)
 {
-	struct ql_adapter *qdev = rx_ring->qdev;
+	struct qlge_adapter *qdev = rx_ring->qdev;
 	struct sk_buff *skb;
 
 	if (sbq_desc->p.skb)
@@ -1038,7 +1038,7 @@ static int qlge_refill_sb(struct rx_ring *rx_ring,
 static int qlge_refill_lb(struct rx_ring *rx_ring,
 			  struct qlge_bq_desc *lbq_desc, gfp_t gfp)
 {
-	struct ql_adapter *qdev = rx_ring->qdev;
+	struct qlge_adapter *qdev = rx_ring->qdev;
 	struct qlge_page_chunk *master_chunk = &rx_ring->master_chunk;
 
 	if (!master_chunk->page) {
@@ -1049,7 +1049,7 @@ static int qlge_refill_lb(struct rx_ring *rx_ring,
 		if (unlikely(!page))
 			return -ENOMEM;
 		dma_addr = dma_map_page(&qdev->pdev->dev, page, 0,
-					ql_lbq_block_size(qdev),
+					qlge_lbq_block_size(qdev),
 					DMA_FROM_DEVICE);
 		if (dma_mapping_error(&qdev->pdev->dev, dma_addr)) {
 			__free_pages(page, qdev->lbq_buf_order);
@@ -1072,7 +1072,7 @@ static int qlge_refill_lb(struct rx_ring *rx_ring,
 	 * buffer get.
 	 */
 	master_chunk->offset += qdev->lbq_buf_size;
-	if (master_chunk->offset == ql_lbq_block_size(qdev)) {
+	if (master_chunk->offset == qlge_lbq_block_size(qdev)) {
 		master_chunk->page = NULL;
 	} else {
 		master_chunk->va += qdev->lbq_buf_size;
@@ -1086,7 +1086,7 @@ static int qlge_refill_lb(struct rx_ring *rx_ring,
 static int qlge_refill_bq(struct qlge_bq *bq, gfp_t gfp)
 {
 	struct rx_ring *rx_ring = QLGE_BQ_CONTAINER(bq);
-	struct ql_adapter *qdev = rx_ring->qdev;
+	struct qlge_adapter *qdev = rx_ring->qdev;
 	struct qlge_bq_desc *bq_desc;
 	int refill_count;
 	int retval;
@@ -1132,7 +1132,7 @@ static int qlge_refill_bq(struct qlge_bq *bq, gfp_t gfp)
 				     "ring %u %s: updating prod idx = %d.\n",
 				     rx_ring->cq_id, bq_type_name[bq->type],
 				     i);
-			ql_write_db_reg(i, bq->prod_idx_db_reg);
+			qlge_write_db_reg(i, bq->prod_idx_db_reg);
 		}
 		bq->next_to_use = i;
 	}
@@ -1140,8 +1140,8 @@ static int qlge_refill_bq(struct qlge_bq *bq, gfp_t gfp)
 	return retval;
 }
 
-static void ql_update_buffer_queues(struct rx_ring *rx_ring, gfp_t gfp,
-				    unsigned long delay)
+static void qlge_update_buffer_queues(struct rx_ring *rx_ring, gfp_t gfp,
+				      unsigned long delay)
 {
 	bool sbq_fail, lbq_fail;
 
@@ -1172,7 +1172,7 @@ static void qlge_slow_refill(struct work_struct *work)
 	struct napi_struct *napi = &rx_ring->napi;
 
 	napi_disable(napi);
-	ql_update_buffer_queues(rx_ring, GFP_KERNEL, HZ / 2);
+	qlge_update_buffer_queues(rx_ring, GFP_KERNEL, HZ / 2);
 	napi_enable(napi);
 
 	local_bh_disable();
@@ -1187,8 +1187,8 @@ static void qlge_slow_refill(struct work_struct *work)
 /* Unmaps tx buffers.  Can be called from send() if a pci mapping
  * fails at some stage, or from the interrupt when a tx completes.
  */
-static void ql_unmap_send(struct ql_adapter *qdev,
-			  struct tx_ring_desc *tx_ring_desc, int mapped)
+static void qlge_unmap_send(struct qlge_adapter *qdev,
+			    struct tx_ring_desc *tx_ring_desc, int mapped)
 {
 	int i;
 
@@ -1229,9 +1229,9 @@ static void ql_unmap_send(struct ql_adapter *qdev,
 /* Map the buffers for this transmit.  This will return
  * NETDEV_TX_BUSY or NETDEV_TX_OK based on success.
  */
-static int ql_map_send(struct ql_adapter *qdev,
-		       struct ob_mac_iocb_req *mac_iocb_ptr,
-		       struct sk_buff *skb, struct tx_ring_desc *tx_ring_desc)
+static int qlge_map_send(struct qlge_adapter *qdev,
+			 struct qlge_ob_mac_iocb_req *mac_iocb_ptr,
+			 struct sk_buff *skb, struct tx_ring_desc *tx_ring_desc)
 {
 	int len = skb_headlen(skb);
 	dma_addr_t map;
@@ -1294,7 +1294,7 @@ static int ql_map_send(struct ql_adapter *qdev,
 			 */
 			/* Tack on the OAL in the eighth segment of IOCB. */
 			map = dma_map_single(&qdev->pdev->dev, &tx_ring_desc->oal,
-					     sizeof(struct oal),
+					     sizeof(struct qlge_oal),
 					     DMA_TO_DEVICE);
 			err = dma_mapping_error(&qdev->pdev->dev, map);
 			if (err) {
@@ -1316,7 +1316,7 @@ static int ql_map_send(struct ql_adapter *qdev,
 			dma_unmap_addr_set(&tx_ring_desc->map[map_idx], mapaddr,
 					   map);
 			dma_unmap_len_set(&tx_ring_desc->map[map_idx], maplen,
-					  sizeof(struct oal));
+					  sizeof(struct qlge_oal));
 			tbd = (struct tx_buf_desc *)&tx_ring_desc->oal;
 			map_idx++;
 		}
@@ -1351,13 +1351,13 @@ static int ql_map_send(struct ql_adapter *qdev,
 	 * we pass in the number of frags that mapped successfully
 	 * so they can be umapped.
 	 */
-	ql_unmap_send(qdev, tx_ring_desc, map_idx);
+	qlge_unmap_send(qdev, tx_ring_desc, map_idx);
 	return NETDEV_TX_BUSY;
 }
 
 /* Categorizing receive firmware frame errors */
-static void ql_categorize_rx_err(struct ql_adapter *qdev, u8 rx_err,
-				 struct rx_ring *rx_ring)
+static void qlge_categorize_rx_err(struct qlge_adapter *qdev, u8 rx_err,
+				   struct rx_ring *rx_ring)
 {
 	struct nic_stats *stats = &qdev->nic_stats;
 
@@ -1389,12 +1389,12 @@ static void ql_categorize_rx_err(struct ql_adapter *qdev, u8 rx_err,
 }
 
 /**
- * ql_update_mac_hdr_len - helper routine to update the mac header length
+ * qlge_update_mac_hdr_len - helper routine to update the mac header length
  * based on vlan tags if present
  */
-static void ql_update_mac_hdr_len(struct ql_adapter *qdev,
-				  struct ib_mac_iocb_rsp *ib_mac_rsp,
-				  void *page, size_t *len)
+static void qlge_update_mac_hdr_len(struct qlge_adapter *qdev,
+				    struct qlge_ib_mac_iocb_rsp *ib_mac_rsp,
+				    void *page, size_t *len)
 {
 	u16 *tags;
 
@@ -1412,18 +1412,18 @@ static void ql_update_mac_hdr_len(struct ql_adapter *qdev,
 }
 
 /* Process an inbound completion from an rx ring. */
-static void ql_process_mac_rx_gro_page(struct ql_adapter *qdev,
-				       struct rx_ring *rx_ring,
-				       struct ib_mac_iocb_rsp *ib_mac_rsp,
-				       u32 length, u16 vlan_id)
+static void qlge_process_mac_rx_gro_page(struct qlge_adapter *qdev,
+					 struct rx_ring *rx_ring,
+					 struct qlge_ib_mac_iocb_rsp *ib_mac_rsp,
+					 u32 length, u16 vlan_id)
 {
 	struct sk_buff *skb;
-	struct qlge_bq_desc *lbq_desc = ql_get_curr_lchunk(qdev, rx_ring);
+	struct qlge_bq_desc *lbq_desc = qlge_get_curr_lchunk(qdev, rx_ring);
 	struct napi_struct *napi = &rx_ring->napi;
 
 	/* Frame error, so drop the packet. */
 	if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) {
-		ql_categorize_rx_err(qdev, ib_mac_rsp->flags2, rx_ring);
+		qlge_categorize_rx_err(qdev, ib_mac_rsp->flags2, rx_ring);
 		put_page(lbq_desc->p.pg_chunk.page);
 		return;
 	}
@@ -1458,15 +1458,15 @@ static void ql_process_mac_rx_gro_page(struct ql_adapter *qdev,
 }
 
 /* Process an inbound completion from an rx ring. */
-static void ql_process_mac_rx_page(struct ql_adapter *qdev,
-				   struct rx_ring *rx_ring,
-				   struct ib_mac_iocb_rsp *ib_mac_rsp,
-				   u32 length, u16 vlan_id)
+static void qlge_process_mac_rx_page(struct qlge_adapter *qdev,
+				     struct rx_ring *rx_ring,
+				     struct qlge_ib_mac_iocb_rsp *ib_mac_rsp,
+				     u32 length, u16 vlan_id)
 {
 	struct net_device *ndev = qdev->ndev;
 	struct sk_buff *skb = NULL;
 	void *addr;
-	struct qlge_bq_desc *lbq_desc = ql_get_curr_lchunk(qdev, rx_ring);
+	struct qlge_bq_desc *lbq_desc = qlge_get_curr_lchunk(qdev, rx_ring);
 	struct napi_struct *napi = &rx_ring->napi;
 	size_t hlen = ETH_HLEN;
 
@@ -1482,12 +1482,12 @@ static void ql_process_mac_rx_page(struct ql_adapter *qdev,
 
 	/* Frame error, so drop the packet. */
 	if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) {
-		ql_categorize_rx_err(qdev, ib_mac_rsp->flags2, rx_ring);
+		qlge_categorize_rx_err(qdev, ib_mac_rsp->flags2, rx_ring);
 		goto err_out;
 	}
 
 	/* Update the MAC header length*/
-	ql_update_mac_hdr_len(qdev, ib_mac_rsp, addr, &hlen);
+	qlge_update_mac_hdr_len(qdev, ib_mac_rsp, addr, &hlen);
 
 	/* The max framesize filter on this chip is set higher than
 	 * MTU since FCoE uses 2k frames.
@@ -1521,12 +1521,12 @@ static void ql_process_mac_rx_page(struct ql_adapter *qdev,
 				     "TCP checksum done!\n");
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 		} else if ((ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_U) &&
-				(ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_V4)) {
+			   (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_V4)) {
 			/* Unfragmented ipv4 UDP frame. */
 			struct iphdr *iph =
 				(struct iphdr *)((u8 *)addr + hlen);
 			if (!(iph->frag_off &
-				htons(IP_MF | IP_OFFSET))) {
+			      htons(IP_MF | IP_OFFSET))) {
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 				netif_printk(qdev, rx_status, KERN_DEBUG,
 					     qdev->ndev,
@@ -1549,10 +1549,10 @@ static void ql_process_mac_rx_page(struct ql_adapter *qdev,
 }
 
 /* Process an inbound completion from an rx ring. */
-static void ql_process_mac_rx_skb(struct ql_adapter *qdev,
-				  struct rx_ring *rx_ring,
-				  struct ib_mac_iocb_rsp *ib_mac_rsp,
-				  u32 length, u16 vlan_id)
+static void qlge_process_mac_rx_skb(struct qlge_adapter *qdev,
+				    struct rx_ring *rx_ring,
+				    struct qlge_ib_mac_iocb_rsp *ib_mac_rsp,
+				    u32 length, u16 vlan_id)
 {
 	struct qlge_bq_desc *sbq_desc = qlge_get_curr_buf(&rx_ring->sbq);
 	struct net_device *ndev = qdev->ndev;
@@ -1576,14 +1576,14 @@ static void ql_process_mac_rx_skb(struct ql_adapter *qdev,
 
 	/* Frame error, so drop the packet. */
 	if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) {
-		ql_categorize_rx_err(qdev, ib_mac_rsp->flags2, rx_ring);
+		qlge_categorize_rx_err(qdev, ib_mac_rsp->flags2, rx_ring);
 		dev_kfree_skb_any(skb);
 		return;
 	}
 
 	/* loopback self test for ethtool */
 	if (test_bit(QL_SELFTEST, &qdev->flags)) {
-		ql_check_lb_frame(qdev, skb);
+		qlge_check_lb_frame(qdev, skb);
 		dev_kfree_skb_any(skb);
 		return;
 	}
@@ -1628,12 +1628,12 @@ static void ql_process_mac_rx_skb(struct ql_adapter *qdev,
 				     "TCP checksum done!\n");
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 		} else if ((ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_U) &&
-				(ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_V4)) {
+			   (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_V4)) {
 			/* Unfragmented ipv4 UDP frame. */
 			struct iphdr *iph = (struct iphdr *)skb->data;
 
 			if (!(iph->frag_off &
-				htons(IP_MF | IP_OFFSET))) {
+			      htons(IP_MF | IP_OFFSET))) {
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 				netif_printk(qdev, rx_status, KERN_DEBUG,
 					     qdev->ndev,
@@ -1651,7 +1651,7 @@ static void ql_process_mac_rx_skb(struct ql_adapter *qdev,
 		netif_receive_skb(skb);
 }
 
-static void ql_realign_skb(struct sk_buff *skb, int len)
+static void qlge_realign_skb(struct sk_buff *skb, int len)
 {
 	void *temp_addr = skb->data;
 
@@ -1669,9 +1669,9 @@ static void ql_realign_skb(struct sk_buff *skb, int len)
  * completion.  It will be rewritten for readability in the near
  * future, but for not it works well.
  */
-static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
-				       struct rx_ring *rx_ring,
-				       struct ib_mac_iocb_rsp *ib_mac_rsp)
+static struct sk_buff *qlge_build_rx_skb(struct qlge_adapter *qdev,
+					 struct rx_ring *rx_ring,
+					 struct qlge_ib_mac_iocb_rsp *ib_mac_rsp)
 {
 	u32 length = le32_to_cpu(ib_mac_rsp->data_len);
 	u32 hdr_len = le32_to_cpu(ib_mac_rsp->hdr_len);
@@ -1693,7 +1693,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 		dma_unmap_single(&qdev->pdev->dev, sbq_desc->dma_addr,
 				 SMALL_BUF_MAP_SIZE, DMA_FROM_DEVICE);
 		skb = sbq_desc->p.skb;
-		ql_realign_skb(skb, hdr_len);
+		qlge_realign_skb(skb, hdr_len);
 		skb_put(skb, hdr_len);
 		sbq_desc->p.skb = NULL;
 	}
@@ -1731,7 +1731,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 				     length);
 			sbq_desc = qlge_get_curr_buf(&rx_ring->sbq);
 			skb = sbq_desc->p.skb;
-			ql_realign_skb(skb, length);
+			qlge_realign_skb(skb, length);
 			skb_put(skb, length);
 			dma_unmap_single(&qdev->pdev->dev, sbq_desc->dma_addr,
 					 SMALL_BUF_MAP_SIZE,
@@ -1748,7 +1748,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 			 * chain it to the header buffer's skb and let
 			 * it rip.
 			 */
-			lbq_desc = ql_get_curr_lchunk(qdev, rx_ring);
+			lbq_desc = qlge_get_curr_lchunk(qdev, rx_ring);
 			netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 				     "Chaining page at offset = %d, for %d bytes  to skb.\n",
 				     lbq_desc->p.pg_chunk.offset, length);
@@ -1763,7 +1763,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 			 * copy it to a new skb and let it go. This can happen with
 			 * jumbo mtu on a non-TCP/UDP frame.
 			 */
-			lbq_desc = ql_get_curr_lchunk(qdev, rx_ring);
+			lbq_desc = qlge_get_curr_lchunk(qdev, rx_ring);
 			skb = netdev_alloc_skb(qdev->ndev, length);
 			if (!skb) {
 				netif_printk(qdev, probe, KERN_DEBUG, qdev->ndev,
@@ -1783,9 +1783,9 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 			skb->len += length;
 			skb->data_len += length;
 			skb->truesize += length;
-			ql_update_mac_hdr_len(qdev, ib_mac_rsp,
-					      lbq_desc->p.pg_chunk.va,
-					      &hlen);
+			qlge_update_mac_hdr_len(qdev, ib_mac_rsp,
+						lbq_desc->p.pg_chunk.va,
+						&hlen);
 			__pskb_pull_tail(skb, hlen);
 		}
 	} else {
@@ -1823,7 +1823,7 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 			skb_reserve(skb, NET_IP_ALIGN);
 		}
 		do {
-			lbq_desc = ql_get_curr_lchunk(qdev, rx_ring);
+			lbq_desc = qlge_get_curr_lchunk(qdev, rx_ring);
 			size = min(length, qdev->lbq_buf_size);
 
 			netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
@@ -1838,25 +1838,25 @@ static struct sk_buff *ql_build_rx_skb(struct ql_adapter *qdev,
 			length -= size;
 			i++;
 		} while (length > 0);
-		ql_update_mac_hdr_len(qdev, ib_mac_rsp, lbq_desc->p.pg_chunk.va,
-				      &hlen);
+		qlge_update_mac_hdr_len(qdev, ib_mac_rsp, lbq_desc->p.pg_chunk.va,
+					&hlen);
 		__pskb_pull_tail(skb, hlen);
 	}
 	return skb;
 }
 
 /* Process an inbound completion from an rx ring. */
-static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
-					 struct rx_ring *rx_ring,
-					 struct ib_mac_iocb_rsp *ib_mac_rsp,
-					 u16 vlan_id)
+static void qlge_process_mac_split_rx_intr(struct qlge_adapter *qdev,
+					   struct rx_ring *rx_ring,
+					   struct qlge_ib_mac_iocb_rsp *ib_mac_rsp,
+					   u16 vlan_id)
 {
 	struct net_device *ndev = qdev->ndev;
 	struct sk_buff *skb = NULL;
 
 	QL_DUMP_IB_MAC_RSP(qdev, ib_mac_rsp);
 
-	skb = ql_build_rx_skb(qdev, rx_ring, ib_mac_rsp);
+	skb = qlge_build_rx_skb(qdev, rx_ring, ib_mac_rsp);
 	if (unlikely(!skb)) {
 		netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 			     "No skb available, drop packet.\n");
@@ -1866,7 +1866,7 @@ static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
 
 	/* Frame error, so drop the packet. */
 	if (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_ERR_MASK) {
-		ql_categorize_rx_err(qdev, ib_mac_rsp->flags2, rx_ring);
+		qlge_categorize_rx_err(qdev, ib_mac_rsp->flags2, rx_ring);
 		dev_kfree_skb_any(skb);
 		return;
 	}
@@ -1882,7 +1882,7 @@ static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
 
 	/* loopback self test for ethtool */
 	if (test_bit(QL_SELFTEST, &qdev->flags)) {
-		ql_check_lb_frame(qdev, skb);
+		qlge_check_lb_frame(qdev, skb);
 		dev_kfree_skb_any(skb);
 		return;
 	}
@@ -1917,12 +1917,12 @@ static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
 				     "TCP checksum done!\n");
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 		} else if ((ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_U) &&
-				(ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_V4)) {
-		/* Unfragmented ipv4 UDP frame. */
+			   (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_V4)) {
+			/* Unfragmented ipv4 UDP frame. */
 			struct iphdr *iph = (struct iphdr *)skb->data;
 
 			if (!(iph->frag_off &
-				htons(IP_MF | IP_OFFSET))) {
+			      htons(IP_MF | IP_OFFSET))) {
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 				netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
 					     "TCP checksum done!\n");
@@ -1942,15 +1942,15 @@ static void ql_process_mac_split_rx_intr(struct ql_adapter *qdev,
 }
 
 /* Process an inbound completion from an rx ring. */
-static unsigned long ql_process_mac_rx_intr(struct ql_adapter *qdev,
-					    struct rx_ring *rx_ring,
-					    struct ib_mac_iocb_rsp *ib_mac_rsp)
+static unsigned long qlge_process_mac_rx_intr(struct qlge_adapter *qdev,
+					      struct rx_ring *rx_ring,
+					      struct qlge_ib_mac_iocb_rsp *ib_mac_rsp)
 {
 	u32 length = le32_to_cpu(ib_mac_rsp->data_len);
 	u16 vlan_id = ((ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_V) &&
-			(qdev->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)) ?
-			((le16_to_cpu(ib_mac_rsp->vlan_id) &
-			IB_MAC_IOCB_RSP_VLAN_MASK)) : 0xffff;
+		       (qdev->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)) ?
+		((le16_to_cpu(ib_mac_rsp->vlan_id) &
+		  IB_MAC_IOCB_RSP_VLAN_MASK)) : 0xffff;
 
 	QL_DUMP_IB_MAC_RSP(qdev, ib_mac_rsp);
 
@@ -1958,43 +1958,43 @@ static unsigned long ql_process_mac_rx_intr(struct ql_adapter *qdev,
 		/* The data and headers are split into
 		 * separate buffers.
 		 */
-		ql_process_mac_split_rx_intr(qdev, rx_ring, ib_mac_rsp,
-					     vlan_id);
+		qlge_process_mac_split_rx_intr(qdev, rx_ring, ib_mac_rsp,
+					       vlan_id);
 	} else if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DS) {
 		/* The data fit in a single small buffer.
 		 * Allocate a new skb, copy the data and
 		 * return the buffer to the free pool.
 		 */
-		ql_process_mac_rx_skb(qdev, rx_ring, ib_mac_rsp, length,
-				      vlan_id);
+		qlge_process_mac_rx_skb(qdev, rx_ring, ib_mac_rsp, length,
+					vlan_id);
 	} else if ((ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL) &&
-		!(ib_mac_rsp->flags1 & IB_MAC_CSUM_ERR_MASK) &&
-		(ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_T)) {
+		   !(ib_mac_rsp->flags1 & IB_MAC_CSUM_ERR_MASK) &&
+		   (ib_mac_rsp->flags2 & IB_MAC_IOCB_RSP_T)) {
 		/* TCP packet in a page chunk that's been checksummed.
 		 * Tack it on to our GRO skb and let it go.
 		 */
-		ql_process_mac_rx_gro_page(qdev, rx_ring, ib_mac_rsp, length,
-					   vlan_id);
+		qlge_process_mac_rx_gro_page(qdev, rx_ring, ib_mac_rsp, length,
+					     vlan_id);
 	} else if (ib_mac_rsp->flags3 & IB_MAC_IOCB_RSP_DL) {
 		/* Non-TCP packet in a page chunk. Allocate an
 		 * skb, tack it on frags, and send it up.
 		 */
-		ql_process_mac_rx_page(qdev, rx_ring, ib_mac_rsp, length,
-				       vlan_id);
+		qlge_process_mac_rx_page(qdev, rx_ring, ib_mac_rsp, length,
+					 vlan_id);
 	} else {
 		/* Non-TCP/UDP large frames that span multiple buffers
 		 * can be processed corrrectly by the split frame logic.
 		 */
-		ql_process_mac_split_rx_intr(qdev, rx_ring, ib_mac_rsp,
-					     vlan_id);
+		qlge_process_mac_split_rx_intr(qdev, rx_ring, ib_mac_rsp,
+					       vlan_id);
 	}
 
 	return (unsigned long)length;
 }
 
 /* Process an outbound completion from an rx ring. */
-static void ql_process_mac_tx_intr(struct ql_adapter *qdev,
-				   struct ob_mac_iocb_rsp *mac_rsp)
+static void qlge_process_mac_tx_intr(struct qlge_adapter *qdev,
+				     struct qlge_ob_mac_iocb_rsp *mac_rsp)
 {
 	struct tx_ring *tx_ring;
 	struct tx_ring_desc *tx_ring_desc;
@@ -2002,7 +2002,7 @@ static void ql_process_mac_tx_intr(struct ql_adapter *qdev,
 	QL_DUMP_OB_MAC_RSP(qdev, mac_rsp);
 	tx_ring = &qdev->tx_ring[mac_rsp->txq_idx];
 	tx_ring_desc = &tx_ring->q[mac_rsp->tid];
-	ql_unmap_send(qdev, tx_ring_desc, tx_ring_desc->map_cnt);
+	qlge_unmap_send(qdev, tx_ring_desc, tx_ring_desc->map_cnt);
 	tx_ring->tx_bytes += (tx_ring_desc->skb)->len;
 	tx_ring->tx_packets++;
 	dev_kfree_skb(tx_ring_desc->skb);
@@ -2033,16 +2033,16 @@ static void ql_process_mac_tx_intr(struct ql_adapter *qdev,
 }
 
 /* Fire up a handler to reset the MPI processor. */
-void ql_queue_fw_error(struct ql_adapter *qdev)
+void qlge_queue_fw_error(struct qlge_adapter *qdev)
 {
-	ql_link_off(qdev);
+	qlge_link_off(qdev);
 	queue_delayed_work(qdev->workqueue, &qdev->mpi_reset_work, 0);
 }
 
-void ql_queue_asic_error(struct ql_adapter *qdev)
+void qlge_queue_asic_error(struct qlge_adapter *qdev)
 {
-	ql_link_off(qdev);
-	ql_disable_interrupts(qdev);
+	qlge_link_off(qdev);
+	qlge_disable_interrupts(qdev);
 	/* Clear adapter up bit to signal the recovery
 	 * process that it shouldn't kill the reset worker
 	 * thread
@@ -2055,47 +2055,47 @@ void ql_queue_asic_error(struct ql_adapter *qdev)
 	queue_delayed_work(qdev->workqueue, &qdev->asic_reset_work, 0);
 }
 
-static void ql_process_chip_ae_intr(struct ql_adapter *qdev,
-				    struct ib_ae_iocb_rsp *ib_ae_rsp)
+static void qlge_process_chip_ae_intr(struct qlge_adapter *qdev,
+				      struct qlge_ib_ae_iocb_rsp *ib_ae_rsp)
 {
 	switch (ib_ae_rsp->event) {
 	case MGMT_ERR_EVENT:
 		netif_err(qdev, rx_err, qdev->ndev,
 			  "Management Processor Fatal Error.\n");
-		ql_queue_fw_error(qdev);
+		qlge_queue_fw_error(qdev);
 		return;
 
 	case CAM_LOOKUP_ERR_EVENT:
 		netdev_err(qdev->ndev, "Multiple CAM hits lookup occurred.\n");
 		netdev_err(qdev->ndev, "This event shouldn't occur.\n");
-		ql_queue_asic_error(qdev);
+		qlge_queue_asic_error(qdev);
 		return;
 
 	case SOFT_ECC_ERROR_EVENT:
 		netdev_err(qdev->ndev, "Soft ECC error detected.\n");
-		ql_queue_asic_error(qdev);
+		qlge_queue_asic_error(qdev);
 		break;
 
 	case PCI_ERR_ANON_BUF_RD:
 		netdev_err(qdev->ndev,
 			   "PCI error occurred when reading anonymous buffers from rx_ring %d.\n",
 			   ib_ae_rsp->q_id);
-		ql_queue_asic_error(qdev);
+		qlge_queue_asic_error(qdev);
 		break;
 
 	default:
 		netif_err(qdev, drv, qdev->ndev, "Unexpected event %d.\n",
 			  ib_ae_rsp->event);
-		ql_queue_asic_error(qdev);
+		qlge_queue_asic_error(qdev);
 		break;
 	}
 }
 
-static int ql_clean_outbound_rx_ring(struct rx_ring *rx_ring)
+static int qlge_clean_outbound_rx_ring(struct rx_ring *rx_ring)
 {
-	struct ql_adapter *qdev = rx_ring->qdev;
-	u32 prod = ql_read_sh_reg(rx_ring->prod_idx_sh_reg);
-	struct ob_mac_iocb_rsp *net_rsp = NULL;
+	struct qlge_adapter *qdev = rx_ring->qdev;
+	u32 prod = qlge_read_sh_reg(rx_ring->prod_idx_sh_reg);
+	struct qlge_ob_mac_iocb_rsp *net_rsp = NULL;
 	int count = 0;
 
 	struct tx_ring *tx_ring;
@@ -2105,12 +2105,12 @@ static int ql_clean_outbound_rx_ring(struct rx_ring *rx_ring)
 			     "cq_id = %d, prod = %d, cnsmr = %d\n",
 			     rx_ring->cq_id, prod, rx_ring->cnsmr_idx);
 
-		net_rsp = (struct ob_mac_iocb_rsp *)rx_ring->curr_entry;
+		net_rsp = (struct qlge_ob_mac_iocb_rsp *)rx_ring->curr_entry;
 		rmb();
 		switch (net_rsp->opcode) {
 		case OPCODE_OB_MAC_TSO_IOCB:
 		case OPCODE_OB_MAC_IOCB:
-			ql_process_mac_tx_intr(qdev, net_rsp);
+			qlge_process_mac_tx_intr(qdev, net_rsp);
 			break;
 		default:
 			netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
@@ -2118,12 +2118,12 @@ static int ql_clean_outbound_rx_ring(struct rx_ring *rx_ring)
 				     net_rsp->opcode);
 		}
 		count++;
-		ql_update_cq(rx_ring);
-		prod = ql_read_sh_reg(rx_ring->prod_idx_sh_reg);
+		qlge_update_cq(rx_ring);
+		prod = qlge_read_sh_reg(rx_ring->prod_idx_sh_reg);
 	}
 	if (!net_rsp)
 		return 0;
-	ql_write_cq_idx(rx_ring);
+	qlge_write_cq_idx(rx_ring);
 	tx_ring = &qdev->tx_ring[net_rsp->txq_idx];
 	if (__netif_subqueue_stopped(qdev->ndev, tx_ring->wq_id)) {
 		if ((atomic_read(&tx_ring->tx_count) > (tx_ring->wq_len / 4)))
@@ -2137,11 +2137,11 @@ static int ql_clean_outbound_rx_ring(struct rx_ring *rx_ring)
 	return count;
 }
 
-static int ql_clean_inbound_rx_ring(struct rx_ring *rx_ring, int budget)
+static int qlge_clean_inbound_rx_ring(struct rx_ring *rx_ring, int budget)
 {
-	struct ql_adapter *qdev = rx_ring->qdev;
-	u32 prod = ql_read_sh_reg(rx_ring->prod_idx_sh_reg);
-	struct ql_net_rsp_iocb *net_rsp;
+	struct qlge_adapter *qdev = rx_ring->qdev;
+	u32 prod = qlge_read_sh_reg(rx_ring->prod_idx_sh_reg);
+	struct qlge_net_rsp_iocb *net_rsp;
 	int count = 0;
 
 	/* While there are entries in the completion queue. */
@@ -2154,14 +2154,14 @@ static int ql_clean_inbound_rx_ring(struct rx_ring *rx_ring, int budget)
 		rmb();
 		switch (net_rsp->opcode) {
 		case OPCODE_IB_MAC_IOCB:
-			ql_process_mac_rx_intr(qdev, rx_ring,
-					       (struct ib_mac_iocb_rsp *)
-					       net_rsp);
+			qlge_process_mac_rx_intr(qdev, rx_ring,
+						 (struct qlge_ib_mac_iocb_rsp *)
+						 net_rsp);
 			break;
 
 		case OPCODE_IB_AE_IOCB:
-			ql_process_chip_ae_intr(qdev, (struct ib_ae_iocb_rsp *)
-						net_rsp);
+			qlge_process_chip_ae_intr(qdev, (struct qlge_ib_ae_iocb_rsp *)
+						  net_rsp);
 			break;
 		default:
 			netif_printk(qdev, rx_status, KERN_DEBUG, qdev->ndev,
@@ -2170,20 +2170,20 @@ static int ql_clean_inbound_rx_ring(struct rx_ring *rx_ring, int budget)
 			break;
 		}
 		count++;
-		ql_update_cq(rx_ring);
-		prod = ql_read_sh_reg(rx_ring->prod_idx_sh_reg);
+		qlge_update_cq(rx_ring);
+		prod = qlge_read_sh_reg(rx_ring->prod_idx_sh_reg);
 		if (count == budget)
 			break;
 	}
-	ql_update_buffer_queues(rx_ring, GFP_ATOMIC, 0);
-	ql_write_cq_idx(rx_ring);
+	qlge_update_buffer_queues(rx_ring, GFP_ATOMIC, 0);
+	qlge_write_cq_idx(rx_ring);
 	return count;
 }
 
-static int ql_napi_poll_msix(struct napi_struct *napi, int budget)
+static int qlge_napi_poll_msix(struct napi_struct *napi, int budget)
 {
 	struct rx_ring *rx_ring = container_of(napi, struct rx_ring, napi);
-	struct ql_adapter *qdev = rx_ring->qdev;
+	struct qlge_adapter *qdev = rx_ring->qdev;
 	struct rx_ring *trx_ring;
 	int i, work_done = 0;
 	struct intr_context *ctx = &qdev->intr_context[rx_ring->cq_id];
@@ -2200,42 +2200,42 @@ static int ql_napi_poll_msix(struct napi_struct *napi, int budget)
 		 * it's not empty then service it.
 		 */
 		if ((ctx->irq_mask & (1 << trx_ring->cq_id)) &&
-		    (ql_read_sh_reg(trx_ring->prod_idx_sh_reg) !=
+		    (qlge_read_sh_reg(trx_ring->prod_idx_sh_reg) !=
 		     trx_ring->cnsmr_idx)) {
 			netif_printk(qdev, intr, KERN_DEBUG, qdev->ndev,
 				     "%s: Servicing TX completion ring %d.\n",
 				     __func__, trx_ring->cq_id);
-			ql_clean_outbound_rx_ring(trx_ring);
+			qlge_clean_outbound_rx_ring(trx_ring);
 		}
 	}
 
 	/*
 	 * Now service the RSS ring if it's active.
 	 */
-	if (ql_read_sh_reg(rx_ring->prod_idx_sh_reg) !=
-					rx_ring->cnsmr_idx) {
+	if (qlge_read_sh_reg(rx_ring->prod_idx_sh_reg) !=
+	    rx_ring->cnsmr_idx) {
 		netif_printk(qdev, intr, KERN_DEBUG, qdev->ndev,
 			     "%s: Servicing RX completion ring %d.\n",
 			     __func__, rx_ring->cq_id);
-		work_done = ql_clean_inbound_rx_ring(rx_ring, budget);
+		work_done = qlge_clean_inbound_rx_ring(rx_ring, budget);
 	}
 
 	if (work_done < budget) {
 		napi_complete_done(napi, work_done);
-		ql_enable_completion_interrupt(qdev, rx_ring->irq);
+		qlge_enable_completion_interrupt(qdev, rx_ring->irq);
 	}
 	return work_done;
 }
 
 static void qlge_vlan_mode(struct net_device *ndev, netdev_features_t features)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 
 	if (features & NETIF_F_HW_VLAN_CTAG_RX) {
-		ql_write32(qdev, NIC_RCV_CFG, NIC_RCV_CFG_VLAN_MASK |
-				 NIC_RCV_CFG_VLAN_MATCH_AND_NON);
+		qlge_write32(qdev, NIC_RCV_CFG, NIC_RCV_CFG_VLAN_MASK |
+			     NIC_RCV_CFG_VLAN_MATCH_AND_NON);
 	} else {
-		ql_write32(qdev, NIC_RCV_CFG, NIC_RCV_CFG_VLAN_MASK);
+		qlge_write32(qdev, NIC_RCV_CFG, NIC_RCV_CFG_VLAN_MASK);
 	}
 }
 
@@ -2246,12 +2246,12 @@ static void qlge_vlan_mode(struct net_device *ndev, netdev_features_t features)
 static int qlge_update_hw_vlan_features(struct net_device *ndev,
 					netdev_features_t features)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 	int status = 0;
 	bool need_restart = netif_running(ndev);
 
 	if (need_restart) {
-		status = ql_adapter_down(qdev);
+		status = qlge_adapter_down(qdev);
 		if (status) {
 			netif_err(qdev, link, qdev->ndev,
 				  "Failed to bring down the adapter\n");
@@ -2263,7 +2263,7 @@ static int qlge_update_hw_vlan_features(struct net_device *ndev,
 	ndev->features = features;
 
 	if (need_restart) {
-		status = ql_adapter_up(qdev);
+		status = qlge_adapter_up(qdev);
 		if (status) {
 			netif_err(qdev, link, qdev->ndev,
 				  "Failed to bring up the adapter\n");
@@ -2292,13 +2292,13 @@ static int qlge_set_features(struct net_device *ndev,
 	return 0;
 }
 
-static int __qlge_vlan_rx_add_vid(struct ql_adapter *qdev, u16 vid)
+static int __qlge_vlan_rx_add_vid(struct qlge_adapter *qdev, u16 vid)
 {
 	u32 enable_bit = MAC_ADDR_E;
 	int err;
 
-	err = ql_set_mac_addr_reg(qdev, (u8 *)&enable_bit,
-				  MAC_ADDR_TYPE_VLAN, vid);
+	err = qlge_set_mac_addr_reg(qdev, (u8 *)&enable_bit,
+				    MAC_ADDR_TYPE_VLAN, vid);
 	if (err)
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Failed to init vlan address.\n");
@@ -2307,29 +2307,29 @@ static int __qlge_vlan_rx_add_vid(struct ql_adapter *qdev, u16 vid)
 
 static int qlge_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 	int status;
 	int err;
 
-	status = ql_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
+	status = qlge_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
 	if (status)
 		return status;
 
 	err = __qlge_vlan_rx_add_vid(qdev, vid);
 	set_bit(vid, qdev->active_vlans);
 
-	ql_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
+	qlge_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
 
 	return err;
 }
 
-static int __qlge_vlan_rx_kill_vid(struct ql_adapter *qdev, u16 vid)
+static int __qlge_vlan_rx_kill_vid(struct qlge_adapter *qdev, u16 vid)
 {
 	u32 enable_bit = 0;
 	int err;
 
-	err = ql_set_mac_addr_reg(qdev, (u8 *)&enable_bit,
-				  MAC_ADDR_TYPE_VLAN, vid);
+	err = qlge_set_mac_addr_reg(qdev, (u8 *)&enable_bit,
+				    MAC_ADDR_TYPE_VLAN, vid);
 	if (err)
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Failed to clear vlan address.\n");
@@ -2338,35 +2338,35 @@ static int __qlge_vlan_rx_kill_vid(struct ql_adapter *qdev, u16 vid)
 
 static int qlge_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vid)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 	int status;
 	int err;
 
-	status = ql_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
+	status = qlge_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
 	if (status)
 		return status;
 
 	err = __qlge_vlan_rx_kill_vid(qdev, vid);
 	clear_bit(vid, qdev->active_vlans);
 
-	ql_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
+	qlge_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
 
 	return err;
 }
 
-static void qlge_restore_vlan(struct ql_adapter *qdev)
+static void qlge_restore_vlan(struct qlge_adapter *qdev)
 {
 	int status;
 	u16 vid;
 
-	status = ql_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
+	status = qlge_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
 	if (status)
 		return;
 
 	for_each_set_bit(vid, qdev->active_vlans, VLAN_N_VID)
 		__qlge_vlan_rx_add_vid(qdev, vid);
 
-	ql_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
+	qlge_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
 }
 
 /* MSI-X Multiple Vector Interrupt Handler for inbound completions. */
@@ -2386,7 +2386,7 @@ static irqreturn_t qlge_msix_rx_isr(int irq, void *dev_id)
 static irqreturn_t qlge_isr(int irq, void *dev_id)
 {
 	struct rx_ring *rx_ring = dev_id;
-	struct ql_adapter *qdev = rx_ring->qdev;
+	struct qlge_adapter *qdev = rx_ring->qdev;
 	struct intr_context *intr_context = &qdev->intr_context[0];
 	u32 var;
 	int work_done = 0;
@@ -2398,18 +2398,18 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
 	 * enable it is not effective.
 	 */
 	if (!test_bit(QL_MSIX_ENABLED, &qdev->flags))
-		ql_disable_completion_interrupt(qdev, 0);
+		qlge_disable_completion_interrupt(qdev, 0);
 
-	var = ql_read32(qdev, STS);
+	var = qlge_read32(qdev, STS);
 
 	/*
 	 * Check for fatal error.
 	 */
 	if (var & STS_FE) {
-		ql_disable_completion_interrupt(qdev, 0);
-		ql_queue_asic_error(qdev);
+		qlge_disable_completion_interrupt(qdev, 0);
+		qlge_queue_asic_error(qdev);
 		netdev_err(qdev->ndev, "Got fatal error, STS = %x.\n", var);
-		var = ql_read32(qdev, ERR_STS);
+		var = qlge_read32(qdev, ERR_STS);
 		netdev_err(qdev->ndev, "Resetting chip. Error Status Register = 0x%x\n", var);
 		return IRQ_HANDLED;
 	}
@@ -2418,14 +2418,14 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
 	 * Check MPI processor activity.
 	 */
 	if ((var & STS_PI) &&
-	    (ql_read32(qdev, INTR_MASK) & INTR_MASK_PI)) {
+	    (qlge_read32(qdev, INTR_MASK) & INTR_MASK_PI)) {
 		/*
 		 * We've got an async event or mailbox completion.
 		 * Handle it and clear the source of the interrupt.
 		 */
 		netif_err(qdev, intr, qdev->ndev,
 			  "Got MPI processor interrupt.\n");
-		ql_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16));
+		qlge_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16));
 		queue_delayed_work_on(smp_processor_id(),
 				      qdev->workqueue, &qdev->mpi_work, 0);
 		work_done++;
@@ -2436,7 +2436,7 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
 	 * pass.  Compare it to the queues that this irq services
 	 * and call napi if there's a match.
 	 */
-	var = ql_read32(qdev, ISR1);
+	var = qlge_read32(qdev, ISR1);
 	if (var & intr_context->irq_mask) {
 		netif_info(qdev, intr, qdev->ndev,
 			   "Waking handler for rx_ring[0].\n");
@@ -2449,13 +2449,13 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
 		 * systematically re-enable the interrupt if we didn't
 		 * schedule napi.
 		 */
-		ql_enable_completion_interrupt(qdev, 0);
+		qlge_enable_completion_interrupt(qdev, 0);
 	}
 
 	return work_done ? IRQ_HANDLED : IRQ_NONE;
 }
 
-static int ql_tso(struct sk_buff *skb, struct ob_mac_tso_iocb_req *mac_iocb_ptr)
+static int qlge_tso(struct sk_buff *skb, struct qlge_ob_mac_tso_iocb_req *mac_iocb_ptr)
 {
 	if (skb_is_gso(skb)) {
 		int err;
@@ -2469,11 +2469,11 @@ static int ql_tso(struct sk_buff *skb, struct ob_mac_tso_iocb_req *mac_iocb_ptr)
 		mac_iocb_ptr->flags3 |= OB_MAC_TSO_IOCB_IC;
 		mac_iocb_ptr->frame_len = cpu_to_le32((u32)skb->len);
 		mac_iocb_ptr->total_hdrs_len =
-		    cpu_to_le16(skb_transport_offset(skb) + tcp_hdrlen(skb));
+			cpu_to_le16(skb_transport_offset(skb) + tcp_hdrlen(skb));
 		mac_iocb_ptr->net_trans_offset =
-		    cpu_to_le16(skb_network_offset(skb) |
-				skb_transport_offset(skb)
-				<< OB_MAC_TRANSPORT_HDR_SHIFT);
+			cpu_to_le16(skb_network_offset(skb) |
+				    skb_transport_offset(skb)
+				    << OB_MAC_TRANSPORT_HDR_SHIFT);
 		mac_iocb_ptr->mss = cpu_to_le16(skb_shinfo(skb)->gso_size);
 		mac_iocb_ptr->flags2 |= OB_MAC_TSO_IOCB_LSO;
 		if (likely(l3_proto == htons(ETH_P_IP))) {
@@ -2488,17 +2488,17 @@ static int ql_tso(struct sk_buff *skb, struct ob_mac_tso_iocb_req *mac_iocb_ptr)
 		} else if (l3_proto == htons(ETH_P_IPV6)) {
 			mac_iocb_ptr->flags1 |= OB_MAC_TSO_IOCB_IP6;
 			tcp_hdr(skb)->check =
-			    ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-					     &ipv6_hdr(skb)->daddr,
-					     0, IPPROTO_TCP, 0);
+				~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
+						 &ipv6_hdr(skb)->daddr,
+						 0, IPPROTO_TCP, 0);
 		}
 		return 1;
 	}
 	return 0;
 }
 
-static void ql_hw_csum_setup(struct sk_buff *skb,
-			     struct ob_mac_tso_iocb_req *mac_iocb_ptr)
+static void qlge_hw_csum_setup(struct sk_buff *skb,
+			       struct qlge_ob_mac_tso_iocb_req *mac_iocb_ptr)
 {
 	int len;
 	struct iphdr *iph = ip_hdr(skb);
@@ -2508,7 +2508,7 @@ static void ql_hw_csum_setup(struct sk_buff *skb,
 	mac_iocb_ptr->frame_len = cpu_to_le32((u32)skb->len);
 	mac_iocb_ptr->net_trans_offset =
 		cpu_to_le16(skb_network_offset(skb) |
-		skb_transport_offset(skb) << OB_MAC_TRANSPORT_HDR_SHIFT);
+			    skb_transport_offset(skb) << OB_MAC_TRANSPORT_HDR_SHIFT);
 
 	mac_iocb_ptr->flags1 |= OB_MAC_TSO_IOCB_IP4;
 	len = (ntohs(iph->tot_len) - (iph->ihl << 2));
@@ -2516,14 +2516,14 @@ static void ql_hw_csum_setup(struct sk_buff *skb,
 		check = &(tcp_hdr(skb)->check);
 		mac_iocb_ptr->flags2 |= OB_MAC_TSO_IOCB_TC;
 		mac_iocb_ptr->total_hdrs_len =
-		    cpu_to_le16(skb_transport_offset(skb) +
-				(tcp_hdr(skb)->doff << 2));
+			cpu_to_le16(skb_transport_offset(skb) +
+				    (tcp_hdr(skb)->doff << 2));
 	} else {
 		check = &(udp_hdr(skb)->check);
 		mac_iocb_ptr->flags2 |= OB_MAC_TSO_IOCB_UC;
 		mac_iocb_ptr->total_hdrs_len =
-		    cpu_to_le16(skb_transport_offset(skb) +
-				sizeof(struct udphdr));
+			cpu_to_le16(skb_transport_offset(skb) +
+				    sizeof(struct udphdr));
 	}
 	*check = ~csum_tcpudp_magic(iph->saddr,
 				    iph->daddr, len, iph->protocol, 0);
@@ -2532,8 +2532,8 @@ static void ql_hw_csum_setup(struct sk_buff *skb,
 static netdev_tx_t qlge_send(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct tx_ring_desc *tx_ring_desc;
-	struct ob_mac_iocb_req *mac_iocb_ptr;
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_ob_mac_iocb_req *mac_iocb_ptr;
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 	int tso;
 	struct tx_ring *tx_ring;
 	u32 tx_ring_idx = (u32)skb->queue_mapping;
@@ -2571,16 +2571,16 @@ static netdev_tx_t qlge_send(struct sk_buff *skb, struct net_device *ndev)
 		mac_iocb_ptr->flags3 |= OB_MAC_IOCB_V;
 		mac_iocb_ptr->vlan_tci = cpu_to_le16(skb_vlan_tag_get(skb));
 	}
-	tso = ql_tso(skb, (struct ob_mac_tso_iocb_req *)mac_iocb_ptr);
+	tso = qlge_tso(skb, (struct qlge_ob_mac_tso_iocb_req *)mac_iocb_ptr);
 	if (tso < 0) {
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	} else if (unlikely(!tso) && (skb->ip_summed == CHECKSUM_PARTIAL)) {
-		ql_hw_csum_setup(skb,
-				 (struct ob_mac_tso_iocb_req *)mac_iocb_ptr);
+		qlge_hw_csum_setup(skb,
+				   (struct qlge_ob_mac_tso_iocb_req *)mac_iocb_ptr);
 	}
-	if (ql_map_send(qdev, mac_iocb_ptr, skb, tx_ring_desc) !=
-			NETDEV_TX_OK) {
+	if (qlge_map_send(qdev, mac_iocb_ptr, skb, tx_ring_desc) !=
+	    NETDEV_TX_OK) {
 		netif_err(qdev, tx_queued, qdev->ndev,
 			  "Could not map the segments.\n");
 		tx_ring->tx_errors++;
@@ -2592,7 +2592,7 @@ static netdev_tx_t qlge_send(struct sk_buff *skb, struct net_device *ndev)
 		tx_ring->prod_idx = 0;
 	wmb();
 
-	ql_write_db_reg_relaxed(tx_ring->prod_idx, tx_ring->prod_idx_db_reg);
+	qlge_write_db_reg_relaxed(tx_ring->prod_idx, tx_ring->prod_idx_db_reg);
 	netif_printk(qdev, tx_queued, KERN_DEBUG, qdev->ndev,
 		     "tx queued, slot %d, len %d\n",
 		     tx_ring->prod_idx, skb->len);
@@ -2611,7 +2611,7 @@ static netdev_tx_t qlge_send(struct sk_buff *skb, struct net_device *ndev)
 	return NETDEV_TX_OK;
 }
 
-static void ql_free_shadow_space(struct ql_adapter *qdev)
+static void qlge_free_shadow_space(struct qlge_adapter *qdev)
 {
 	if (qdev->rx_ring_shadow_reg_area) {
 		dma_free_coherent(&qdev->pdev->dev,
@@ -2629,7 +2629,7 @@ static void ql_free_shadow_space(struct ql_adapter *qdev)
 	}
 }
 
-static int ql_alloc_shadow_space(struct ql_adapter *qdev)
+static int qlge_alloc_shadow_space(struct qlge_adapter *qdev)
 {
 	qdev->rx_ring_shadow_reg_area =
 		dma_alloc_coherent(&qdev->pdev->dev, PAGE_SIZE,
@@ -2658,11 +2658,11 @@ static int ql_alloc_shadow_space(struct ql_adapter *qdev)
 	return -ENOMEM;
 }
 
-static void ql_init_tx_ring(struct ql_adapter *qdev, struct tx_ring *tx_ring)
+static void qlge_init_tx_ring(struct qlge_adapter *qdev, struct tx_ring *tx_ring)
 {
 	struct tx_ring_desc *tx_ring_desc;
 	int i;
-	struct ob_mac_iocb_req *mac_iocb_ptr;
+	struct qlge_ob_mac_iocb_req *mac_iocb_ptr;
 
 	mac_iocb_ptr = tx_ring->wq_base;
 	tx_ring_desc = tx_ring->q;
@@ -2676,8 +2676,8 @@ static void ql_init_tx_ring(struct ql_adapter *qdev, struct tx_ring *tx_ring)
 	atomic_set(&tx_ring->tx_count, tx_ring->wq_len);
 }
 
-static void ql_free_tx_resources(struct ql_adapter *qdev,
-				 struct tx_ring *tx_ring)
+static void qlge_free_tx_resources(struct qlge_adapter *qdev,
+				   struct tx_ring *tx_ring)
 {
 	if (tx_ring->wq_base) {
 		dma_free_coherent(&qdev->pdev->dev, tx_ring->wq_size,
@@ -2688,20 +2688,20 @@ static void ql_free_tx_resources(struct ql_adapter *qdev,
 	tx_ring->q = NULL;
 }
 
-static int ql_alloc_tx_resources(struct ql_adapter *qdev,
-				 struct tx_ring *tx_ring)
+static int qlge_alloc_tx_resources(struct qlge_adapter *qdev,
+				   struct tx_ring *tx_ring)
 {
 	tx_ring->wq_base =
-	    dma_alloc_coherent(&qdev->pdev->dev, tx_ring->wq_size,
-			       &tx_ring->wq_base_dma, GFP_ATOMIC);
+		dma_alloc_coherent(&qdev->pdev->dev, tx_ring->wq_size,
+				   &tx_ring->wq_base_dma, GFP_ATOMIC);
 
 	if (!tx_ring->wq_base ||
 	    tx_ring->wq_base_dma & WQ_ADDR_ALIGN)
 		goto pci_alloc_err;
 
 	tx_ring->q =
-	    kmalloc_array(tx_ring->wq_len, sizeof(struct tx_ring_desc),
-			  GFP_KERNEL);
+		kmalloc_array(tx_ring->wq_len, sizeof(struct tx_ring_desc),
+			      GFP_KERNEL);
 	if (!tx_ring->q)
 		goto err;
 
@@ -2715,19 +2715,19 @@ static int ql_alloc_tx_resources(struct ql_adapter *qdev,
 	return -ENOMEM;
 }
 
-static void ql_free_lbq_buffers(struct ql_adapter *qdev, struct rx_ring *rx_ring)
+static void qlge_free_lbq_buffers(struct qlge_adapter *qdev, struct rx_ring *rx_ring)
 {
 	struct qlge_bq *lbq = &rx_ring->lbq;
 	unsigned int last_offset;
 
-	last_offset = ql_lbq_block_size(qdev) - qdev->lbq_buf_size;
+	last_offset = qlge_lbq_block_size(qdev) - qdev->lbq_buf_size;
 	while (lbq->next_to_clean != lbq->next_to_use) {
 		struct qlge_bq_desc *lbq_desc =
 			&lbq->queue[lbq->next_to_clean];
 
 		if (lbq_desc->p.pg_chunk.offset == last_offset)
 			dma_unmap_page(&qdev->pdev->dev, lbq_desc->dma_addr,
-				       ql_lbq_block_size(qdev),
+				       qlge_lbq_block_size(qdev),
 				       DMA_FROM_DEVICE);
 		put_page(lbq_desc->p.pg_chunk.page);
 
@@ -2736,13 +2736,13 @@ static void ql_free_lbq_buffers(struct ql_adapter *qdev, struct rx_ring *rx_ring
 
 	if (rx_ring->master_chunk.page) {
 		dma_unmap_page(&qdev->pdev->dev, rx_ring->chunk_dma_addr,
-			       ql_lbq_block_size(qdev), DMA_FROM_DEVICE);
+			       qlge_lbq_block_size(qdev), DMA_FROM_DEVICE);
 		put_page(rx_ring->master_chunk.page);
 		rx_ring->master_chunk.page = NULL;
 	}
 }
 
-static void ql_free_sbq_buffers(struct ql_adapter *qdev, struct rx_ring *rx_ring)
+static void qlge_free_sbq_buffers(struct qlge_adapter *qdev, struct rx_ring *rx_ring)
 {
 	int i;
 
@@ -2767,7 +2767,7 @@ static void ql_free_sbq_buffers(struct ql_adapter *qdev, struct rx_ring *rx_ring
 /* Free all large and small rx buffers associated
  * with the completion queues for this device.
  */
-static void ql_free_rx_buffers(struct ql_adapter *qdev)
+static void qlge_free_rx_buffers(struct qlge_adapter *qdev)
 {
 	int i;
 
@@ -2775,25 +2775,25 @@ static void ql_free_rx_buffers(struct ql_adapter *qdev)
 		struct rx_ring *rx_ring = &qdev->rx_ring[i];
 
 		if (rx_ring->lbq.queue)
-			ql_free_lbq_buffers(qdev, rx_ring);
+			qlge_free_lbq_buffers(qdev, rx_ring);
 		if (rx_ring->sbq.queue)
-			ql_free_sbq_buffers(qdev, rx_ring);
+			qlge_free_sbq_buffers(qdev, rx_ring);
 	}
 }
 
-static void ql_alloc_rx_buffers(struct ql_adapter *qdev)
+static void qlge_alloc_rx_buffers(struct qlge_adapter *qdev)
 {
 	int i;
 
 	for (i = 0; i < qdev->rss_ring_count; i++)
-		ql_update_buffer_queues(&qdev->rx_ring[i], GFP_KERNEL,
-					HZ / 2);
+		qlge_update_buffer_queues(&qdev->rx_ring[i], GFP_KERNEL,
+					  HZ / 2);
 }
 
 static int qlge_init_bq(struct qlge_bq *bq)
 {
 	struct rx_ring *rx_ring = QLGE_BQ_CONTAINER(bq);
-	struct ql_adapter *qdev = rx_ring->qdev;
+	struct qlge_adapter *qdev = rx_ring->qdev;
 	struct qlge_bq_desc *bq_desc;
 	__le64 *buf_ptr;
 	int i;
@@ -2823,8 +2823,8 @@ static int qlge_init_bq(struct qlge_bq *bq)
 	return 0;
 }
 
-static void ql_free_rx_resources(struct ql_adapter *qdev,
-				 struct rx_ring *rx_ring)
+static void qlge_free_rx_resources(struct qlge_adapter *qdev,
+				   struct rx_ring *rx_ring)
 {
 	/* Free the small buffer queue. */
 	if (rx_ring->sbq.base) {
@@ -2860,15 +2860,15 @@ static void ql_free_rx_resources(struct ql_adapter *qdev,
 /* Allocate queues and buffers for this completions queue based
  * on the values in the parameter structure.
  */
-static int ql_alloc_rx_resources(struct ql_adapter *qdev,
-				 struct rx_ring *rx_ring)
+static int qlge_alloc_rx_resources(struct qlge_adapter *qdev,
+				   struct rx_ring *rx_ring)
 {
 	/*
 	 * Allocate the completion queue for this rx_ring.
 	 */
 	rx_ring->cq_base =
-	    dma_alloc_coherent(&qdev->pdev->dev, rx_ring->cq_size,
-			       &rx_ring->cq_base_dma, GFP_ATOMIC);
+		dma_alloc_coherent(&qdev->pdev->dev, rx_ring->cq_size,
+				   &rx_ring->cq_base_dma, GFP_ATOMIC);
 
 	if (!rx_ring->cq_base) {
 		netif_err(qdev, ifup, qdev->ndev, "rx_ring alloc failed.\n");
@@ -2877,14 +2877,14 @@ static int ql_alloc_rx_resources(struct ql_adapter *qdev,
 
 	if (rx_ring->cq_id < qdev->rss_ring_count &&
 	    (qlge_init_bq(&rx_ring->sbq) || qlge_init_bq(&rx_ring->lbq))) {
-		ql_free_rx_resources(qdev, rx_ring);
+		qlge_free_rx_resources(qdev, rx_ring);
 		return -ENOMEM;
 	}
 
 	return 0;
 }
 
-static void ql_tx_ring_clean(struct ql_adapter *qdev)
+static void qlge_tx_ring_clean(struct qlge_adapter *qdev)
 {
 	struct tx_ring *tx_ring;
 	struct tx_ring_desc *tx_ring_desc;
@@ -2903,8 +2903,8 @@ static void ql_tx_ring_clean(struct ql_adapter *qdev)
 					  "Freeing lost SKB %p, from queue %d, index %d.\n",
 					  tx_ring_desc->skb, j,
 					  tx_ring_desc->index);
-				ql_unmap_send(qdev, tx_ring_desc,
-					      tx_ring_desc->map_cnt);
+				qlge_unmap_send(qdev, tx_ring_desc,
+						tx_ring_desc->map_cnt);
 				dev_kfree_skb(tx_ring_desc->skb);
 				tx_ring_desc->skb = NULL;
 			}
@@ -2912,27 +2912,27 @@ static void ql_tx_ring_clean(struct ql_adapter *qdev)
 	}
 }
 
-static void ql_free_mem_resources(struct ql_adapter *qdev)
+static void qlge_free_mem_resources(struct qlge_adapter *qdev)
 {
 	int i;
 
 	for (i = 0; i < qdev->tx_ring_count; i++)
-		ql_free_tx_resources(qdev, &qdev->tx_ring[i]);
+		qlge_free_tx_resources(qdev, &qdev->tx_ring[i]);
 	for (i = 0; i < qdev->rx_ring_count; i++)
-		ql_free_rx_resources(qdev, &qdev->rx_ring[i]);
-	ql_free_shadow_space(qdev);
+		qlge_free_rx_resources(qdev, &qdev->rx_ring[i]);
+	qlge_free_shadow_space(qdev);
 }
 
-static int ql_alloc_mem_resources(struct ql_adapter *qdev)
+static int qlge_alloc_mem_resources(struct qlge_adapter *qdev)
 {
 	int i;
 
 	/* Allocate space for our shadow registers and such. */
-	if (ql_alloc_shadow_space(qdev))
+	if (qlge_alloc_shadow_space(qdev))
 		return -ENOMEM;
 
 	for (i = 0; i < qdev->rx_ring_count; i++) {
-		if (ql_alloc_rx_resources(qdev, &qdev->rx_ring[i]) != 0) {
+		if (qlge_alloc_rx_resources(qdev, &qdev->rx_ring[i]) != 0) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "RX resource allocation failed.\n");
 			goto err_mem;
@@ -2940,7 +2940,7 @@ static int ql_alloc_mem_resources(struct ql_adapter *qdev)
 	}
 	/* Allocate tx queue resources */
 	for (i = 0; i < qdev->tx_ring_count; i++) {
-		if (ql_alloc_tx_resources(qdev, &qdev->tx_ring[i]) != 0) {
+		if (qlge_alloc_tx_resources(qdev, &qdev->tx_ring[i]) != 0) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "TX resource allocation failed.\n");
 			goto err_mem;
@@ -2949,7 +2949,7 @@ static int ql_alloc_mem_resources(struct ql_adapter *qdev)
 	return 0;
 
 err_mem:
-	ql_free_mem_resources(qdev);
+	qlge_free_mem_resources(qdev);
 	return -ENOMEM;
 }
 
@@ -2957,7 +2957,7 @@ static int ql_alloc_mem_resources(struct ql_adapter *qdev)
  * The control block is defined as
  * "Completion Queue Initialization Control Block", or cqicb.
  */
-static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
+static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring)
 {
 	struct cqicb *cqicb = &rx_ring->cqicb;
 	void *shadow_reg = qdev->rx_ring_shadow_reg_area +
@@ -2965,7 +2965,7 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 	u64 shadow_reg_dma = qdev->rx_ring_shadow_reg_dma +
 		(rx_ring->cq_id * RX_RING_SHADOW_SPACE);
 	void __iomem *doorbell_area =
-	    qdev->doorbell_area + (DB_PAGE_SIZE * (128 + rx_ring->cq_id));
+		qdev->doorbell_area + (DB_PAGE_SIZE * (128 + rx_ring->cq_id));
 	int err = 0;
 	u64 tmp;
 	__le64 *base_indirect_ptr;
@@ -3012,8 +3012,8 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 	 * Set up the control block load flags.
 	 */
 	cqicb->flags = FLAGS_LC |	/* Load queue base address */
-	    FLAGS_LV |		/* Load MSI-X vector */
-	    FLAGS_LI;		/* Load irq delay values */
+		FLAGS_LV |		/* Load MSI-X vector */
+		FLAGS_LI;		/* Load irq delay values */
 	if (rx_ring->cq_id < qdev->rss_ring_count) {
 		cqicb->flags |= FLAGS_LL;	/* Load lbq values */
 		tmp = (u64)rx_ring->lbq.base_dma;
@@ -3043,7 +3043,7 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 			page_entries++;
 		} while (page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN));
 		cqicb->sbq_addr =
-		    cpu_to_le64(rx_ring->sbq.base_indirect_dma);
+			cpu_to_le64(rx_ring->sbq.base_indirect_dma);
 		cqicb->sbq_buf_size = cpu_to_le16(SMALL_BUFFER_SIZE);
 		cqicb->sbq_len = cpu_to_le16(QLGE_FIT16(QLGE_BQ_LEN));
 		rx_ring->sbq.next_to_use = 0;
@@ -3053,7 +3053,7 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 		/* Inbound completion handling rx_rings run in
 		 * separate NAPI contexts.
 		 */
-		netif_napi_add(qdev->ndev, &rx_ring->napi, ql_napi_poll_msix,
+		netif_napi_add(qdev->ndev, &rx_ring->napi, qlge_napi_poll_msix,
 			       64);
 		cqicb->irq_delay = cpu_to_le16(qdev->rx_coalesce_usecs);
 		cqicb->pkt_delay = cpu_to_le16(qdev->rx_max_coalesced_frames);
@@ -3061,8 +3061,8 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 		cqicb->irq_delay = cpu_to_le16(qdev->tx_coalesce_usecs);
 		cqicb->pkt_delay = cpu_to_le16(qdev->tx_max_coalesced_frames);
 	}
-	err = ql_write_cfg(qdev, cqicb, sizeof(struct cqicb),
-			   CFG_LCQ, rx_ring->cq_id);
+	err = qlge_write_cfg(qdev, cqicb, sizeof(struct cqicb),
+			     CFG_LCQ, rx_ring->cq_id);
 	if (err) {
 		netif_err(qdev, ifup, qdev->ndev, "Failed to load CQICB.\n");
 		return err;
@@ -3070,15 +3070,15 @@ static int ql_start_rx_ring(struct ql_adapter *qdev, struct rx_ring *rx_ring)
 	return err;
 }
 
-static int ql_start_tx_ring(struct ql_adapter *qdev, struct tx_ring *tx_ring)
+static int qlge_start_tx_ring(struct qlge_adapter *qdev, struct tx_ring *tx_ring)
 {
 	struct wqicb *wqicb = (struct wqicb *)tx_ring;
 	void __iomem *doorbell_area =
-	    qdev->doorbell_area + (DB_PAGE_SIZE * tx_ring->wq_id);
+		qdev->doorbell_area + (DB_PAGE_SIZE * tx_ring->wq_id);
 	void *shadow_reg = qdev->tx_ring_shadow_reg_area +
-	    (tx_ring->wq_id * sizeof(u64));
+		(tx_ring->wq_id * sizeof(u64));
 	u64 shadow_reg_dma = qdev->tx_ring_shadow_reg_dma +
-	    (tx_ring->wq_id * sizeof(u64));
+		(tx_ring->wq_id * sizeof(u64));
 	int err = 0;
 
 	/*
@@ -3105,10 +3105,10 @@ static int ql_start_tx_ring(struct ql_adapter *qdev, struct tx_ring *tx_ring)
 
 	wqicb->cnsmr_idx_addr = cpu_to_le64(tx_ring->cnsmr_idx_sh_reg_dma);
 
-	ql_init_tx_ring(qdev, tx_ring);
+	qlge_init_tx_ring(qdev, tx_ring);
 
-	err = ql_write_cfg(qdev, wqicb, sizeof(*wqicb), CFG_LRQ,
-			   (u16)tx_ring->wq_id);
+	err = qlge_write_cfg(qdev, wqicb, sizeof(*wqicb), CFG_LRQ,
+			     (u16)tx_ring->wq_id);
 	if (err) {
 		netif_err(qdev, ifup, qdev->ndev, "Failed to load tx_ring.\n");
 		return err;
@@ -3116,7 +3116,7 @@ static int ql_start_tx_ring(struct ql_adapter *qdev, struct tx_ring *tx_ring)
 	return err;
 }
 
-static void ql_disable_msix(struct ql_adapter *qdev)
+static void qlge_disable_msix(struct qlge_adapter *qdev)
 {
 	if (test_bit(QL_MSIX_ENABLED, &qdev->flags)) {
 		pci_disable_msix(qdev->pdev);
@@ -3133,7 +3133,7 @@ static void ql_disable_msix(struct ql_adapter *qdev)
  * stored in qdev->intr_count. If we don't get that
  * many then we reduce the count and try again.
  */
-static void ql_enable_msix(struct ql_adapter *qdev)
+static void qlge_enable_msix(struct qlge_adapter *qdev)
 {
 	int i, err;
 
@@ -3195,7 +3195,7 @@ static void ql_enable_msix(struct ql_adapter *qdev)
  * and TX completion rings 0,1,2 and 3.  Vector 1 would
  * service RSS ring 1 and TX completion rings 4,5,6 and 7.
  */
-static void ql_set_tx_vect(struct ql_adapter *qdev)
+static void qlge_set_tx_vect(struct qlge_adapter *qdev)
 {
 	int i, j, vect;
 	u32 tx_rings_per_vector = qdev->tx_ring_count / qdev->intr_count;
@@ -3203,7 +3203,7 @@ static void ql_set_tx_vect(struct ql_adapter *qdev)
 	if (likely(test_bit(QL_MSIX_ENABLED, &qdev->flags))) {
 		/* Assign irq vectors to TX rx_rings.*/
 		for (vect = 0, j = 0, i = qdev->rss_ring_count;
-					 i < qdev->rx_ring_count; i++) {
+		     i < qdev->rx_ring_count; i++) {
 			if (j == tx_rings_per_vector) {
 				vect++;
 				j = 0;
@@ -3225,7 +3225,7 @@ static void ql_set_tx_vect(struct ql_adapter *qdev)
  * rings.  This function sets up a bit mask per vector
  * that indicates which rings it services.
  */
-static void ql_set_irq_mask(struct ql_adapter *qdev, struct intr_context *ctx)
+static void qlge_set_irq_mask(struct qlge_adapter *qdev, struct intr_context *ctx)
 {
 	int j, vect = ctx->intr;
 	u32 tx_rings_per_vector = qdev->tx_ring_count / qdev->intr_count;
@@ -3240,8 +3240,8 @@ static void ql_set_irq_mask(struct ql_adapter *qdev, struct intr_context *ctx)
 		 */
 		for (j = 0; j < tx_rings_per_vector; j++) {
 			ctx->irq_mask |=
-			(1 << qdev->rx_ring[qdev->rss_ring_count +
-			(vect * tx_rings_per_vector) + j].cq_id);
+				(1 << qdev->rx_ring[qdev->rss_ring_count +
+				 (vect * tx_rings_per_vector) + j].cq_id);
 		}
 	} else {
 		/* For single vector we just shift each queue's
@@ -3258,7 +3258,7 @@ static void ql_set_irq_mask(struct ql_adapter *qdev, struct intr_context *ctx)
  * The intr_context structure is used to hook each vector
  * to possibly different handlers.
  */
-static void ql_resolve_queues_to_irqs(struct ql_adapter *qdev)
+static void qlge_resolve_queues_to_irqs(struct qlge_adapter *qdev)
 {
 	int i = 0;
 	struct intr_context *intr_context = &qdev->intr_context[0];
@@ -3275,23 +3275,23 @@ static void ql_resolve_queues_to_irqs(struct ql_adapter *qdev)
 			/* Set up this vector's bit-mask that indicates
 			 * which queues it services.
 			 */
-			ql_set_irq_mask(qdev, intr_context);
+			qlge_set_irq_mask(qdev, intr_context);
 			/*
 			 * We set up each vectors enable/disable/read bits so
 			 * there's no bit/mask calculations in the critical path.
 			 */
 			intr_context->intr_en_mask =
-			    INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK |
-			    INTR_EN_TYPE_ENABLE | INTR_EN_IHD_MASK | INTR_EN_IHD
-			    | i;
+				INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK |
+				INTR_EN_TYPE_ENABLE | INTR_EN_IHD_MASK | INTR_EN_IHD
+				| i;
 			intr_context->intr_dis_mask =
-			    INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK |
-			    INTR_EN_TYPE_DISABLE | INTR_EN_IHD_MASK |
-			    INTR_EN_IHD | i;
+				INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK |
+				INTR_EN_TYPE_DISABLE | INTR_EN_IHD_MASK |
+				INTR_EN_IHD | i;
 			intr_context->intr_read_mask =
-			    INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK |
-			    INTR_EN_TYPE_READ | INTR_EN_IHD_MASK | INTR_EN_IHD |
-			    i;
+				INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK |
+				INTR_EN_TYPE_READ | INTR_EN_IHD_MASK | INTR_EN_IHD |
+				i;
 			if (i == 0) {
 				/* The first vector/queue handles
 				 * broadcast/multicast, fatal errors,
@@ -3322,10 +3322,10 @@ static void ql_resolve_queues_to_irqs(struct ql_adapter *qdev)
 		 * there's no bit/mask calculations in the critical path.
 		 */
 		intr_context->intr_en_mask =
-		    INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK | INTR_EN_TYPE_ENABLE;
+			INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK | INTR_EN_TYPE_ENABLE;
 		intr_context->intr_dis_mask =
-		    INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK |
-		    INTR_EN_TYPE_DISABLE;
+			INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK |
+			INTR_EN_TYPE_DISABLE;
 		if (test_bit(QL_LEGACY_ENABLED, &qdev->flags)) {
 			/* Experience shows that when using INTx interrupts,
 			 * the device does not always auto-mask INTR_EN_EN.
@@ -3337,7 +3337,7 @@ static void ql_resolve_queues_to_irqs(struct ql_adapter *qdev)
 			intr_context->intr_dis_mask |= INTR_EN_EI << 16;
 		}
 		intr_context->intr_read_mask =
-		    INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK | INTR_EN_TYPE_READ;
+			INTR_EN_TYPE_MASK | INTR_EN_INTR_MASK | INTR_EN_TYPE_READ;
 		/*
 		 * Single interrupt means one handler for all rings.
 		 */
@@ -3348,15 +3348,15 @@ static void ql_resolve_queues_to_irqs(struct ql_adapter *qdev)
 		 * a single vector so it will service all RSS and
 		 * TX completion rings.
 		 */
-		ql_set_irq_mask(qdev, intr_context);
+		qlge_set_irq_mask(qdev, intr_context);
 	}
 	/* Tell the TX completion rings which MSIx vector
 	 * they will be using.
 	 */
-	ql_set_tx_vect(qdev);
+	qlge_set_tx_vect(qdev);
 }
 
-static void ql_free_irq(struct ql_adapter *qdev)
+static void qlge_free_irq(struct qlge_adapter *qdev)
 {
 	int i;
 	struct intr_context *intr_context = &qdev->intr_context[0];
@@ -3371,17 +3371,17 @@ static void ql_free_irq(struct ql_adapter *qdev)
 			}
 		}
 	}
-	ql_disable_msix(qdev);
+	qlge_disable_msix(qdev);
 }
 
-static int ql_request_irq(struct ql_adapter *qdev)
+static int qlge_request_irq(struct qlge_adapter *qdev)
 {
 	int i;
 	int status = 0;
 	struct pci_dev *pdev = qdev->pdev;
 	struct intr_context *intr_context = &qdev->intr_context[0];
 
-	ql_resolve_queues_to_irqs(qdev);
+	qlge_resolve_queues_to_irqs(qdev);
 
 	for (i = 0; i < qdev->intr_count; i++, intr_context++) {
 		if (test_bit(QL_MSIX_ENABLED, &qdev->flags)) {
@@ -3408,11 +3408,11 @@ static int ql_request_irq(struct ql_adapter *qdev)
 				     "%s: dev_id = 0x%p.\n", __func__,
 				     &qdev->rx_ring[0]);
 			status =
-			    request_irq(pdev->irq, qlge_isr,
-					test_bit(QL_MSI_ENABLED, &qdev->flags)
-						? 0
-						: IRQF_SHARED,
-					intr_context->name, &qdev->rx_ring[0]);
+				request_irq(pdev->irq, qlge_isr,
+					    test_bit(QL_MSI_ENABLED, &qdev->flags)
+					    ? 0
+					    : IRQF_SHARED,
+					    intr_context->name, &qdev->rx_ring[0]);
 			if (status)
 				goto err_irq;
 
@@ -3425,11 +3425,11 @@ static int ql_request_irq(struct ql_adapter *qdev)
 	return status;
 err_irq:
 	netif_err(qdev, ifup, qdev->ndev, "Failed to get the interrupts!!!\n");
-	ql_free_irq(qdev);
+	qlge_free_irq(qdev);
 	return status;
 }
 
-static int ql_start_rss(struct ql_adapter *qdev)
+static int qlge_start_rss(struct qlge_adapter *qdev)
 {
 	static const u8 init_hash_seed[] = {
 		0x6d, 0x5a, 0x56, 0xda, 0x25, 0x5b, 0x0e, 0xc2,
@@ -3459,7 +3459,7 @@ static int ql_start_rss(struct ql_adapter *qdev)
 	memcpy((void *)&ricb->ipv6_hash_key[0], init_hash_seed, 40);
 	memcpy((void *)&ricb->ipv4_hash_key[0], init_hash_seed, 16);
 
-	status = ql_write_cfg(qdev, ricb, sizeof(*ricb), CFG_LR, 0);
+	status = qlge_write_cfg(qdev, ricb, sizeof(*ricb), CFG_LR, 0);
 	if (status) {
 		netif_err(qdev, ifup, qdev->ndev, "Failed to load RICB.\n");
 		return status;
@@ -3467,55 +3467,55 @@ static int ql_start_rss(struct ql_adapter *qdev)
 	return status;
 }
 
-static int ql_clear_routing_entries(struct ql_adapter *qdev)
+static int qlge_clear_routing_entries(struct qlge_adapter *qdev)
 {
 	int i, status = 0;
 
-	status = ql_sem_spinlock(qdev, SEM_RT_IDX_MASK);
+	status = qlge_sem_spinlock(qdev, SEM_RT_IDX_MASK);
 	if (status)
 		return status;
 	/* Clear all the entries in the routing table. */
 	for (i = 0; i < 16; i++) {
-		status = ql_set_routing_reg(qdev, i, 0, 0);
+		status = qlge_set_routing_reg(qdev, i, 0, 0);
 		if (status) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Failed to init routing register for CAM packets.\n");
 			break;
 		}
 	}
-	ql_sem_unlock(qdev, SEM_RT_IDX_MASK);
+	qlge_sem_unlock(qdev, SEM_RT_IDX_MASK);
 	return status;
 }
 
 /* Initialize the frame-to-queue routing. */
-static int ql_route_initialize(struct ql_adapter *qdev)
+static int qlge_route_initialize(struct qlge_adapter *qdev)
 {
 	int status = 0;
 
 	/* Clear all the entries in the routing table. */
-	status = ql_clear_routing_entries(qdev);
+	status = qlge_clear_routing_entries(qdev);
 	if (status)
 		return status;
 
-	status = ql_sem_spinlock(qdev, SEM_RT_IDX_MASK);
+	status = qlge_sem_spinlock(qdev, SEM_RT_IDX_MASK);
 	if (status)
 		return status;
 
-	status = ql_set_routing_reg(qdev, RT_IDX_IP_CSUM_ERR_SLOT,
-				    RT_IDX_IP_CSUM_ERR, 1);
+	status = qlge_set_routing_reg(qdev, RT_IDX_IP_CSUM_ERR_SLOT,
+				      RT_IDX_IP_CSUM_ERR, 1);
 	if (status) {
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Failed to init routing register for IP CSUM error packets.\n");
 		goto exit;
 	}
-	status = ql_set_routing_reg(qdev, RT_IDX_TCP_UDP_CSUM_ERR_SLOT,
-				    RT_IDX_TU_CSUM_ERR, 1);
+	status = qlge_set_routing_reg(qdev, RT_IDX_TCP_UDP_CSUM_ERR_SLOT,
+				      RT_IDX_TU_CSUM_ERR, 1);
 	if (status) {
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Failed to init routing register for TCP/UDP CSUM error packets.\n");
 		goto exit;
 	}
-	status = ql_set_routing_reg(qdev, RT_IDX_BCAST_SLOT, RT_IDX_BCAST, 1);
+	status = qlge_set_routing_reg(qdev, RT_IDX_BCAST_SLOT, RT_IDX_BCAST, 1);
 	if (status) {
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Failed to init routing register for broadcast packets.\n");
@@ -3525,8 +3525,8 @@ static int ql_route_initialize(struct ql_adapter *qdev)
 	 * routing block.
 	 */
 	if (qdev->rss_ring_count > 1) {
-		status = ql_set_routing_reg(qdev, RT_IDX_RSS_MATCH_SLOT,
-					    RT_IDX_RSS_MATCH, 1);
+		status = qlge_set_routing_reg(qdev, RT_IDX_RSS_MATCH_SLOT,
+					      RT_IDX_RSS_MATCH, 1);
 		if (status) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Failed to init routing register for MATCH RSS packets.\n");
@@ -3534,17 +3534,17 @@ static int ql_route_initialize(struct ql_adapter *qdev)
 		}
 	}
 
-	status = ql_set_routing_reg(qdev, RT_IDX_CAM_HIT_SLOT,
-				    RT_IDX_CAM_HIT, 1);
+	status = qlge_set_routing_reg(qdev, RT_IDX_CAM_HIT_SLOT,
+				      RT_IDX_CAM_HIT, 1);
 	if (status)
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Failed to init routing register for CAM packets.\n");
 exit:
-	ql_sem_unlock(qdev, SEM_RT_IDX_MASK);
+	qlge_sem_unlock(qdev, SEM_RT_IDX_MASK);
 	return status;
 }
 
-int ql_cam_route_initialize(struct ql_adapter *qdev)
+int qlge_cam_route_initialize(struct qlge_adapter *qdev)
 {
 	int status, set;
 
@@ -3552,22 +3552,22 @@ int ql_cam_route_initialize(struct ql_adapter *qdev)
 	 * determine if we are setting or clearing
 	 * the MAC address in the CAM.
 	 */
-	set = ql_read32(qdev, STS);
+	set = qlge_read32(qdev, STS);
 	set &= qdev->port_link_up;
-	status = ql_set_mac_addr(qdev, set);
+	status = qlge_set_mac_addr(qdev, set);
 	if (status) {
 		netif_err(qdev, ifup, qdev->ndev, "Failed to init mac address.\n");
 		return status;
 	}
 
-	status = ql_route_initialize(qdev);
+	status = qlge_route_initialize(qdev);
 	if (status)
 		netif_err(qdev, ifup, qdev->ndev, "Failed to init routing table.\n");
 
 	return status;
 }
 
-static int ql_adapter_initialize(struct ql_adapter *qdev)
+static int qlge_adapter_initialize(struct qlge_adapter *qdev)
 {
 	u32 value, mask;
 	int i;
@@ -3578,7 +3578,7 @@ static int ql_adapter_initialize(struct ql_adapter *qdev)
 	 */
 	value = SYS_EFE | SYS_FAE;
 	mask = value << 16;
-	ql_write32(qdev, SYS, mask | value);
+	qlge_write32(qdev, SYS, mask | value);
 
 	/* Set the default queue, and VLAN behavior. */
 	value = NIC_RCV_CFG_DFQ;
@@ -3587,40 +3587,40 @@ static int ql_adapter_initialize(struct ql_adapter *qdev)
 		value |= NIC_RCV_CFG_RV;
 		mask |= (NIC_RCV_CFG_RV << 16);
 	}
-	ql_write32(qdev, NIC_RCV_CFG, (mask | value));
+	qlge_write32(qdev, NIC_RCV_CFG, (mask | value));
 
 	/* Set the MPI interrupt to enabled. */
-	ql_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16) | INTR_MASK_PI);
+	qlge_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16) | INTR_MASK_PI);
 
 	/* Enable the function, set pagesize, enable error checking. */
 	value = FSC_FE | FSC_EPC_INBOUND | FSC_EPC_OUTBOUND |
-	    FSC_EC | FSC_VM_PAGE_4K;
+		FSC_EC | FSC_VM_PAGE_4K;
 	value |= SPLT_SETTING;
 
 	/* Set/clear header splitting. */
 	mask = FSC_VM_PAGESIZE_MASK |
-	    FSC_DBL_MASK | FSC_DBRST_MASK | (value << 16);
-	ql_write32(qdev, FSC, mask | value);
+		FSC_DBL_MASK | FSC_DBRST_MASK | (value << 16);
+	qlge_write32(qdev, FSC, mask | value);
 
-	ql_write32(qdev, SPLT_HDR, SPLT_LEN);
+	qlge_write32(qdev, SPLT_HDR, SPLT_LEN);
 
 	/* Set RX packet routing to use port/pci function on which the
 	 * packet arrived on in addition to usual frame routing.
 	 * This is helpful on bonding where both interfaces can have
 	 * the same MAC address.
 	 */
-	ql_write32(qdev, RST_FO, RST_FO_RR_MASK | RST_FO_RR_RCV_FUNC_CQ);
+	qlge_write32(qdev, RST_FO, RST_FO_RR_MASK | RST_FO_RR_RCV_FUNC_CQ);
 	/* Reroute all packets to our Interface.
 	 * They may have been routed to MPI firmware
 	 * due to WOL.
 	 */
-	value = ql_read32(qdev, MGMT_RCV_CFG);
+	value = qlge_read32(qdev, MGMT_RCV_CFG);
 	value &= ~MGMT_RCV_CFG_RM;
 	mask = 0xffff0000;
 
 	/* Sticky reg needs clearing due to WOL. */
-	ql_write32(qdev, MGMT_RCV_CFG, mask);
-	ql_write32(qdev, MGMT_RCV_CFG, mask | value);
+	qlge_write32(qdev, MGMT_RCV_CFG, mask);
+	qlge_write32(qdev, MGMT_RCV_CFG, mask | value);
 
 	/* Default WOL is enable on Mezz cards */
 	if (qdev->pdev->subsystem_device == 0x0068 ||
@@ -3629,7 +3629,7 @@ static int ql_adapter_initialize(struct ql_adapter *qdev)
 
 	/* Start up the rx queues. */
 	for (i = 0; i < qdev->rx_ring_count; i++) {
-		status = ql_start_rx_ring(qdev, &qdev->rx_ring[i]);
+		status = qlge_start_rx_ring(qdev, &qdev->rx_ring[i]);
 		if (status) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Failed to start rx ring[%d].\n", i);
@@ -3641,7 +3641,7 @@ static int ql_adapter_initialize(struct ql_adapter *qdev)
 	 * then download a RICB to configure RSS.
 	 */
 	if (qdev->rss_ring_count > 1) {
-		status = ql_start_rss(qdev);
+		status = qlge_start_rss(qdev);
 		if (status) {
 			netif_err(qdev, ifup, qdev->ndev, "Failed to start RSS.\n");
 			return status;
@@ -3650,7 +3650,7 @@ static int ql_adapter_initialize(struct ql_adapter *qdev)
 
 	/* Start up the tx queues. */
 	for (i = 0; i < qdev->tx_ring_count; i++) {
-		status = ql_start_tx_ring(qdev, &qdev->tx_ring[i]);
+		status = qlge_start_tx_ring(qdev, &qdev->tx_ring[i]);
 		if (status) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Failed to start tx ring[%d].\n", i);
@@ -3664,7 +3664,7 @@ static int ql_adapter_initialize(struct ql_adapter *qdev)
 		netif_err(qdev, ifup, qdev->ndev, "Failed to start port.\n");
 
 	/* Set up the MAC address and frame routing filter. */
-	status = ql_cam_route_initialize(qdev);
+	status = qlge_cam_route_initialize(qdev);
 	if (status) {
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Failed to init CAM/Routing tables.\n");
@@ -3679,14 +3679,14 @@ static int ql_adapter_initialize(struct ql_adapter *qdev)
 }
 
 /* Issue soft reset to chip. */
-static int ql_adapter_reset(struct ql_adapter *qdev)
+static int qlge_adapter_reset(struct qlge_adapter *qdev)
 {
 	u32 value;
 	int status = 0;
 	unsigned long end_jiffies;
 
 	/* Clear all the entries in the routing table. */
-	status = ql_clear_routing_entries(qdev);
+	status = qlge_clear_routing_entries(qdev);
 	if (status) {
 		netif_err(qdev, ifup, qdev->ndev, "Failed to clear routing bits.\n");
 		return status;
@@ -3697,19 +3697,19 @@ static int ql_adapter_reset(struct ql_adapter *qdev)
 	 */
 	if (!test_bit(QL_ASIC_RECOVERY, &qdev->flags)) {
 		/* Stop management traffic. */
-		ql_mb_set_mgmnt_traffic_ctl(qdev, MB_SET_MPI_TFK_STOP);
+		qlge_mb_set_mgmnt_traffic_ctl(qdev, MB_SET_MPI_TFK_STOP);
 
 		/* Wait for the NIC and MGMNT FIFOs to empty. */
-		ql_wait_fifo_empty(qdev);
+		qlge_wait_fifo_empty(qdev);
 	} else {
 		clear_bit(QL_ASIC_RECOVERY, &qdev->flags);
 	}
 
-	ql_write32(qdev, RST_FO, (RST_FO_FR << 16) | RST_FO_FR);
+	qlge_write32(qdev, RST_FO, (RST_FO_FR << 16) | RST_FO_FR);
 
 	end_jiffies = jiffies + usecs_to_jiffies(30);
 	do {
-		value = ql_read32(qdev, RST_FO);
+		value = qlge_read32(qdev, RST_FO);
 		if ((value & RST_FO_FR) == 0)
 			break;
 		cpu_relax();
@@ -3722,13 +3722,13 @@ static int ql_adapter_reset(struct ql_adapter *qdev)
 	}
 
 	/* Resume management traffic. */
-	ql_mb_set_mgmnt_traffic_ctl(qdev, MB_SET_MPI_TFK_RESUME);
+	qlge_mb_set_mgmnt_traffic_ctl(qdev, MB_SET_MPI_TFK_RESUME);
 	return status;
 }
 
-static void ql_display_dev_info(struct net_device *ndev)
+static void qlge_display_dev_info(struct net_device *ndev)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 
 	netif_info(qdev, probe, qdev->ndev,
 		   "Function #%d, Port %d, NIC Roll %d, NIC Rev = %d, XG Roll = %d, XG Rev = %d.\n",
@@ -3742,7 +3742,7 @@ static void ql_display_dev_info(struct net_device *ndev)
 		   "MAC address %pM\n", ndev->dev_addr);
 }
 
-static int ql_wol(struct ql_adapter *qdev)
+static int qlge_wol(struct qlge_adapter *qdev)
 {
 	int status = 0;
 	u32 wol = MB_WOL_DISABLE;
@@ -3755,7 +3755,7 @@ static int ql_wol(struct ql_adapter *qdev)
 	 */
 
 	if (qdev->wol & (WAKE_ARP | WAKE_MAGICSECURE | WAKE_PHY | WAKE_UCAST |
-			WAKE_MCAST | WAKE_BCAST)) {
+			 WAKE_MCAST | WAKE_BCAST)) {
 		netif_err(qdev, ifdown, qdev->ndev,
 			  "Unsupported WOL parameter. qdev->wol = 0x%x.\n",
 			  qdev->wol);
@@ -3763,7 +3763,7 @@ static int ql_wol(struct ql_adapter *qdev)
 	}
 
 	if (qdev->wol & WAKE_MAGIC) {
-		status = ql_mb_wol_set_magic(qdev, 1);
+		status = qlge_mb_wol_set_magic(qdev, 1);
 		if (status) {
 			netif_err(qdev, ifdown, qdev->ndev,
 				  "Failed to set magic packet on %s.\n",
@@ -3779,7 +3779,7 @@ static int ql_wol(struct ql_adapter *qdev)
 
 	if (qdev->wol) {
 		wol |= MB_WOL_MODE_ON;
-		status = ql_mb_wol_mode(qdev, wol);
+		status = qlge_mb_wol_mode(qdev, wol);
 		netif_err(qdev, drv, qdev->ndev,
 			  "WOL %s (wol code 0x%x) on %s\n",
 			  (status == 0) ? "Successfully set" : "Failed",
@@ -3789,7 +3789,7 @@ static int ql_wol(struct ql_adapter *qdev)
 	return status;
 }
 
-static void ql_cancel_all_work_sync(struct ql_adapter *qdev)
+static void qlge_cancel_all_work_sync(struct qlge_adapter *qdev)
 {
 	/* Don't kill the reset worker thread if we
 	 * are in the process of recovery.
@@ -3803,54 +3803,54 @@ static void ql_cancel_all_work_sync(struct ql_adapter *qdev)
 	cancel_delayed_work_sync(&qdev->mpi_port_cfg_work);
 }
 
-static int ql_adapter_down(struct ql_adapter *qdev)
+static int qlge_adapter_down(struct qlge_adapter *qdev)
 {
 	int i, status = 0;
 
-	ql_link_off(qdev);
+	qlge_link_off(qdev);
 
-	ql_cancel_all_work_sync(qdev);
+	qlge_cancel_all_work_sync(qdev);
 
 	for (i = 0; i < qdev->rss_ring_count; i++)
 		napi_disable(&qdev->rx_ring[i].napi);
 
 	clear_bit(QL_ADAPTER_UP, &qdev->flags);
 
-	ql_disable_interrupts(qdev);
+	qlge_disable_interrupts(qdev);
 
-	ql_tx_ring_clean(qdev);
+	qlge_tx_ring_clean(qdev);
 
 	/* Call netif_napi_del() from common point.
-	 */
+	*/
 	for (i = 0; i < qdev->rss_ring_count; i++)
 		netif_napi_del(&qdev->rx_ring[i].napi);
 
-	status = ql_adapter_reset(qdev);
+	status = qlge_adapter_reset(qdev);
 	if (status)
 		netif_err(qdev, ifdown, qdev->ndev, "reset(func #%d) FAILED!\n",
 			  qdev->func);
-	ql_free_rx_buffers(qdev);
+	qlge_free_rx_buffers(qdev);
 
 	return status;
 }
 
-static int ql_adapter_up(struct ql_adapter *qdev)
+static int qlge_adapter_up(struct qlge_adapter *qdev)
 {
 	int err = 0;
 
-	err = ql_adapter_initialize(qdev);
+	err = qlge_adapter_initialize(qdev);
 	if (err) {
 		netif_info(qdev, ifup, qdev->ndev, "Unable to initialize adapter.\n");
 		goto err_init;
 	}
 	set_bit(QL_ADAPTER_UP, &qdev->flags);
-	ql_alloc_rx_buffers(qdev);
+	qlge_alloc_rx_buffers(qdev);
 	/* If the port is initialized and the
 	 * link is up the turn on the carrier.
 	 */
-	if ((ql_read32(qdev, STS) & qdev->port_init) &&
-	    (ql_read32(qdev, STS) & qdev->port_link_up))
-		ql_link_on(qdev);
+	if ((qlge_read32(qdev, STS) & qdev->port_init) &&
+	    (qlge_read32(qdev, STS) & qdev->port_link_up))
+		qlge_link_on(qdev);
 	/* Restore rx mode. */
 	clear_bit(QL_ALLMULTI, &qdev->flags);
 	clear_bit(QL_PROMISCUOUS, &qdev->flags);
@@ -3859,34 +3859,34 @@ static int ql_adapter_up(struct ql_adapter *qdev)
 	/* Restore vlan setting. */
 	qlge_restore_vlan(qdev);
 
-	ql_enable_interrupts(qdev);
-	ql_enable_all_completion_interrupts(qdev);
+	qlge_enable_interrupts(qdev);
+	qlge_enable_all_completion_interrupts(qdev);
 	netif_tx_start_all_queues(qdev->ndev);
 
 	return 0;
 err_init:
-	ql_adapter_reset(qdev);
+	qlge_adapter_reset(qdev);
 	return err;
 }
 
-static void ql_release_adapter_resources(struct ql_adapter *qdev)
+static void qlge_release_adapter_resources(struct qlge_adapter *qdev)
 {
-	ql_free_mem_resources(qdev);
-	ql_free_irq(qdev);
+	qlge_free_mem_resources(qdev);
+	qlge_free_irq(qdev);
 }
 
-static int ql_get_adapter_resources(struct ql_adapter *qdev)
+static int qlge_get_adapter_resources(struct qlge_adapter *qdev)
 {
-	if (ql_alloc_mem_resources(qdev)) {
+	if (qlge_alloc_mem_resources(qdev)) {
 		netif_err(qdev, ifup, qdev->ndev, "Unable to  allocate memory.\n");
 		return -ENOMEM;
 	}
-	return ql_request_irq(qdev);
+	return qlge_request_irq(qdev);
 }
 
 static int qlge_close(struct net_device *ndev)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 	int i;
 
 	/* If we hit pci_channel_io_perm_failure
@@ -3910,12 +3910,12 @@ static int qlge_close(struct net_device *ndev)
 	for (i = 0; i < qdev->rss_ring_count; i++)
 		cancel_delayed_work_sync(&qdev->rx_ring[i].refill_work);
 
-	ql_adapter_down(qdev);
-	ql_release_adapter_resources(qdev);
+	qlge_adapter_down(qdev);
+	qlge_release_adapter_resources(qdev);
 	return 0;
 }
 
-static void qlge_set_lb_size(struct ql_adapter *qdev)
+static void qlge_set_lb_size(struct qlge_adapter *qdev)
 {
 	if (qdev->ndev->mtu <= 1500)
 		qdev->lbq_buf_size = LARGE_BUFFER_MIN_SIZE;
@@ -3924,7 +3924,7 @@ static void qlge_set_lb_size(struct ql_adapter *qdev)
 	qdev->lbq_buf_order = get_order(qdev->lbq_buf_size);
 }
 
-static int ql_configure_rings(struct ql_adapter *qdev)
+static int qlge_configure_rings(struct qlge_adapter *qdev)
 {
 	int i;
 	struct rx_ring *rx_ring;
@@ -3933,13 +3933,13 @@ static int ql_configure_rings(struct ql_adapter *qdev)
 
 	/* In a perfect world we have one RSS ring for each CPU
 	 * and each has it's own vector.  To do that we ask for
-	 * cpu_cnt vectors.  ql_enable_msix() will adjust the
+	 * cpu_cnt vectors.  qlge_enable_msix() will adjust the
 	 * vector count to what we actually get.  We then
 	 * allocate an RSS ring for each.
 	 * Essentially, we are doing min(cpu_count, msix_vector_count).
 	 */
 	qdev->intr_count = cpu_cnt;
-	ql_enable_msix(qdev);
+	qlge_enable_msix(qdev);
 	/* Adjust the RSS ring count to the actual vector count. */
 	qdev->rss_ring_count = qdev->intr_count;
 	qdev->tx_ring_count = cpu_cnt;
@@ -3952,7 +3952,7 @@ static int ql_configure_rings(struct ql_adapter *qdev)
 		tx_ring->wq_id = i;
 		tx_ring->wq_len = qdev->tx_ring_size;
 		tx_ring->wq_size =
-		    tx_ring->wq_len * sizeof(struct ob_mac_iocb_req);
+			tx_ring->wq_len * sizeof(struct qlge_ob_mac_iocb_req);
 
 		/*
 		 * The completion queue ID for the tx rings start
@@ -3973,7 +3973,7 @@ static int ql_configure_rings(struct ql_adapter *qdev)
 			 */
 			rx_ring->cq_len = qdev->rx_ring_size;
 			rx_ring->cq_size =
-			    rx_ring->cq_len * sizeof(struct ql_net_rsp_iocb);
+				rx_ring->cq_len * sizeof(struct qlge_net_rsp_iocb);
 			rx_ring->lbq.type = QLGE_LB;
 			rx_ring->sbq.type = QLGE_SB;
 			INIT_DELAYED_WORK(&rx_ring->refill_work,
@@ -3985,7 +3985,7 @@ static int ql_configure_rings(struct ql_adapter *qdev)
 			/* outbound cq is same size as tx_ring it services. */
 			rx_ring->cq_len = qdev->tx_ring_size;
 			rx_ring->cq_size =
-			    rx_ring->cq_len * sizeof(struct ql_net_rsp_iocb);
+				rx_ring->cq_len * sizeof(struct qlge_net_rsp_iocb);
 		}
 	}
 	return 0;
@@ -3994,33 +3994,33 @@ static int ql_configure_rings(struct ql_adapter *qdev)
 static int qlge_open(struct net_device *ndev)
 {
 	int err = 0;
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 
-	err = ql_adapter_reset(qdev);
+	err = qlge_adapter_reset(qdev);
 	if (err)
 		return err;
 
 	qlge_set_lb_size(qdev);
-	err = ql_configure_rings(qdev);
+	err = qlge_configure_rings(qdev);
 	if (err)
 		return err;
 
-	err = ql_get_adapter_resources(qdev);
+	err = qlge_get_adapter_resources(qdev);
 	if (err)
 		goto error_up;
 
-	err = ql_adapter_up(qdev);
+	err = qlge_adapter_up(qdev);
 	if (err)
 		goto error_up;
 
 	return err;
 
 error_up:
-	ql_release_adapter_resources(qdev);
+	qlge_release_adapter_resources(qdev);
 	return err;
 }
 
-static int ql_change_rx_buffers(struct ql_adapter *qdev)
+static int qlge_change_rx_buffers(struct qlge_adapter *qdev)
 {
 	int status;
 
@@ -4041,13 +4041,13 @@ static int ql_change_rx_buffers(struct ql_adapter *qdev)
 		}
 	}
 
-	status = ql_adapter_down(qdev);
+	status = qlge_adapter_down(qdev);
 	if (status)
 		goto error;
 
 	qlge_set_lb_size(qdev);
 
-	status = ql_adapter_up(qdev);
+	status = qlge_adapter_up(qdev);
 	if (status)
 		goto error;
 
@@ -4062,7 +4062,7 @@ static int ql_change_rx_buffers(struct ql_adapter *qdev)
 
 static int qlge_change_mtu(struct net_device *ndev, int new_mtu)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 	int status;
 
 	if (ndev->mtu == 1500 && new_mtu == 9000)
@@ -4080,7 +4080,7 @@ static int qlge_change_mtu(struct net_device *ndev, int new_mtu)
 	if (!netif_running(qdev->ndev))
 		return 0;
 
-	status = ql_change_rx_buffers(qdev);
+	status = qlge_change_rx_buffers(qdev);
 	if (status) {
 		netif_err(qdev, ifup, qdev->ndev,
 			  "Changing MTU failed.\n");
@@ -4092,7 +4092,7 @@ static int qlge_change_mtu(struct net_device *ndev, int new_mtu)
 static struct net_device_stats *qlge_get_stats(struct net_device
 					       *ndev)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 	struct rx_ring *rx_ring = &qdev->rx_ring[0];
 	struct tx_ring *tx_ring = &qdev->tx_ring[0];
 	unsigned long pkts, mcast, dropped, errors, bytes;
@@ -4128,11 +4128,11 @@ static struct net_device_stats *qlge_get_stats(struct net_device
 
 static void qlge_set_multicast_list(struct net_device *ndev)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 	struct netdev_hw_addr *ha;
 	int i, status;
 
-	status = ql_sem_spinlock(qdev, SEM_RT_IDX_MASK);
+	status = qlge_sem_spinlock(qdev, SEM_RT_IDX_MASK);
 	if (status)
 		return;
 	/*
@@ -4141,7 +4141,7 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 	 */
 	if (ndev->flags & IFF_PROMISC) {
 		if (!test_bit(QL_PROMISCUOUS, &qdev->flags)) {
-			if (ql_set_routing_reg
+			if (qlge_set_routing_reg
 			    (qdev, RT_IDX_PROMISCUOUS_SLOT, RT_IDX_VALID, 1)) {
 				netif_err(qdev, hw, qdev->ndev,
 					  "Failed to set promiscuous mode.\n");
@@ -4151,7 +4151,7 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 		}
 	} else {
 		if (test_bit(QL_PROMISCUOUS, &qdev->flags)) {
-			if (ql_set_routing_reg
+			if (qlge_set_routing_reg
 			    (qdev, RT_IDX_PROMISCUOUS_SLOT, RT_IDX_VALID, 0)) {
 				netif_err(qdev, hw, qdev->ndev,
 					  "Failed to clear promiscuous mode.\n");
@@ -4168,7 +4168,7 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 	if ((ndev->flags & IFF_ALLMULTI) ||
 	    (netdev_mc_count(ndev) > MAX_MULTICAST_ENTRIES)) {
 		if (!test_bit(QL_ALLMULTI, &qdev->flags)) {
-			if (ql_set_routing_reg
+			if (qlge_set_routing_reg
 			    (qdev, RT_IDX_ALLMULTI_SLOT, RT_IDX_MCAST, 1)) {
 				netif_err(qdev, hw, qdev->ndev,
 					  "Failed to set all-multi mode.\n");
@@ -4178,7 +4178,7 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 		}
 	} else {
 		if (test_bit(QL_ALLMULTI, &qdev->flags)) {
-			if (ql_set_routing_reg
+			if (qlge_set_routing_reg
 			    (qdev, RT_IDX_ALLMULTI_SLOT, RT_IDX_MCAST, 0)) {
 				netif_err(qdev, hw, qdev->ndev,
 					  "Failed to clear all-multi mode.\n");
@@ -4189,22 +4189,22 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 	}
 
 	if (!netdev_mc_empty(ndev)) {
-		status = ql_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
+		status = qlge_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
 		if (status)
 			goto exit;
 		i = 0;
 		netdev_for_each_mc_addr(ha, ndev) {
-			if (ql_set_mac_addr_reg(qdev, (u8 *)ha->addr,
-						MAC_ADDR_TYPE_MULTI_MAC, i)) {
+			if (qlge_set_mac_addr_reg(qdev, (u8 *)ha->addr,
+						  MAC_ADDR_TYPE_MULTI_MAC, i)) {
 				netif_err(qdev, hw, qdev->ndev,
 					  "Failed to loadmulticast address.\n");
-				ql_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
+				qlge_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
 				goto exit;
 			}
 			i++;
 		}
-		ql_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
-		if (ql_set_routing_reg
+		qlge_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
+		if (qlge_set_routing_reg
 		    (qdev, RT_IDX_MCAST_MATCH_SLOT, RT_IDX_MCAST_MATCH, 1)) {
 			netif_err(qdev, hw, qdev->ndev,
 				  "Failed to set multicast match mode.\n");
@@ -4213,12 +4213,12 @@ static void qlge_set_multicast_list(struct net_device *ndev)
 		}
 	}
 exit:
-	ql_sem_unlock(qdev, SEM_RT_IDX_MASK);
+	qlge_sem_unlock(qdev, SEM_RT_IDX_MASK);
 }
 
 static int qlge_set_mac_address(struct net_device *ndev, void *p)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 	struct sockaddr *addr = p;
 	int status;
 
@@ -4228,37 +4228,37 @@ static int qlge_set_mac_address(struct net_device *ndev, void *p)
 	/* Update local copy of current mac address. */
 	memcpy(qdev->current_mac_addr, ndev->dev_addr, ndev->addr_len);
 
-	status = ql_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
+	status = qlge_sem_spinlock(qdev, SEM_MAC_ADDR_MASK);
 	if (status)
 		return status;
-	status = ql_set_mac_addr_reg(qdev, (u8 *)ndev->dev_addr,
-				     MAC_ADDR_TYPE_CAM_MAC,
-				     qdev->func * MAX_CQ);
+	status = qlge_set_mac_addr_reg(qdev, (u8 *)ndev->dev_addr,
+				       MAC_ADDR_TYPE_CAM_MAC,
+				       qdev->func * MAX_CQ);
 	if (status)
 		netif_err(qdev, hw, qdev->ndev, "Failed to load MAC address.\n");
-	ql_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
+	qlge_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
 	return status;
 }
 
 static void qlge_tx_timeout(struct net_device *ndev, unsigned int txqueue)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 
-	ql_queue_asic_error(qdev);
+	qlge_queue_asic_error(qdev);
 }
 
-static void ql_asic_reset_work(struct work_struct *work)
+static void qlge_asic_reset_work(struct work_struct *work)
 {
-	struct ql_adapter *qdev =
-	    container_of(work, struct ql_adapter, asic_reset_work.work);
+	struct qlge_adapter *qdev =
+		container_of(work, struct qlge_adapter, asic_reset_work.work);
 	int status;
 
 	rtnl_lock();
-	status = ql_adapter_down(qdev);
+	status = qlge_adapter_down(qdev);
 	if (status)
 		goto error;
 
-	status = ql_adapter_up(qdev);
+	status = qlge_adapter_up(qdev);
 	if (status)
 		goto error;
 
@@ -4279,13 +4279,13 @@ static void ql_asic_reset_work(struct work_struct *work)
 }
 
 static const struct nic_operations qla8012_nic_ops = {
-	.get_flash		= ql_get_8012_flash_params,
-	.port_initialize	= ql_8012_port_initialize,
+	.get_flash		= qlge_get_8012_flash_params,
+	.port_initialize	= qlge_8012_port_initialize,
 };
 
 static const struct nic_operations qla8000_nic_ops = {
-	.get_flash		= ql_get_8000_flash_params,
-	.port_initialize	= ql_8000_port_initialize,
+	.get_flash		= qlge_get_8000_flash_params,
+	.port_initialize	= qlge_8000_port_initialize,
 };
 
 /* Find the pcie function number for the other NIC
@@ -4295,21 +4295,21 @@ static const struct nic_operations qla8000_nic_ops = {
  * after a fatal firmware error, or doing a firmware
  * coredump.
  */
-static int ql_get_alt_pcie_func(struct ql_adapter *qdev)
+static int qlge_get_alt_pcie_func(struct qlge_adapter *qdev)
 {
 	int status = 0;
 	u32 temp;
 	u32 nic_func1, nic_func2;
 
-	status = ql_read_mpi_reg(qdev, MPI_TEST_FUNC_PORT_CFG,
-				 &temp);
+	status = qlge_read_mpi_reg(qdev, MPI_TEST_FUNC_PORT_CFG,
+				   &temp);
 	if (status)
 		return status;
 
 	nic_func1 = ((temp >> MPI_TEST_NIC1_FUNC_SHIFT) &
-			MPI_TEST_NIC_FUNC_MASK);
+		     MPI_TEST_NIC_FUNC_MASK);
 	nic_func2 = ((temp >> MPI_TEST_NIC2_FUNC_SHIFT) &
-			MPI_TEST_NIC_FUNC_MASK);
+		     MPI_TEST_NIC_FUNC_MASK);
 
 	if (qdev->func == nic_func1)
 		qdev->alt_func = nic_func2;
@@ -4321,16 +4321,16 @@ static int ql_get_alt_pcie_func(struct ql_adapter *qdev)
 	return status;
 }
 
-static int ql_get_board_info(struct ql_adapter *qdev)
+static int qlge_get_board_info(struct qlge_adapter *qdev)
 {
 	int status;
 
 	qdev->func =
-	    (ql_read32(qdev, STS) & STS_FUNC_ID_MASK) >> STS_FUNC_ID_SHIFT;
+		(qlge_read32(qdev, STS) & STS_FUNC_ID_MASK) >> STS_FUNC_ID_SHIFT;
 	if (qdev->func > 3)
 		return -EIO;
 
-	status = ql_get_alt_pcie_func(qdev);
+	status = qlge_get_alt_pcie_func(qdev);
 	if (status)
 		return status;
 
@@ -4348,7 +4348,7 @@ static int ql_get_board_info(struct ql_adapter *qdev)
 		qdev->mailbox_in = PROC_ADDR_MPI_RISC | PROC_ADDR_FUNC0_MBI;
 		qdev->mailbox_out = PROC_ADDR_MPI_RISC | PROC_ADDR_FUNC0_MBO;
 	}
-	qdev->chip_rev_id = ql_read32(qdev, REV_ID);
+	qdev->chip_rev_id = qlge_read32(qdev, REV_ID);
 	qdev->device_id = qdev->pdev->device;
 	if (qdev->device_id == QLGE_DEVICE_ID_8012)
 		qdev->nic_ops = &qla8012_nic_ops;
@@ -4357,10 +4357,10 @@ static int ql_get_board_info(struct ql_adapter *qdev)
 	return status;
 }
 
-static void ql_release_all(struct pci_dev *pdev)
+static void qlge_release_all(struct pci_dev *pdev)
 {
 	struct net_device *ndev = pci_get_drvdata(pdev);
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 
 	if (qdev->workqueue) {
 		destroy_workqueue(qdev->workqueue);
@@ -4375,10 +4375,10 @@ static void ql_release_all(struct pci_dev *pdev)
 	pci_release_regions(pdev);
 }
 
-static int ql_init_device(struct pci_dev *pdev, struct net_device *ndev,
-			  int cards_found)
+static int qlge_init_device(struct pci_dev *pdev, struct net_device *ndev,
+			    int cards_found)
 {
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 	int err = 0;
 
 	memset((void *)qdev, 0, sizeof(*qdev));
@@ -4441,7 +4441,7 @@ static int ql_init_device(struct pci_dev *pdev, struct net_device *ndev,
 		goto err_out2;
 	}
 
-	err = ql_get_board_info(qdev);
+	err = qlge_get_board_info(qdev);
 	if (err) {
 		dev_err(&pdev->dev, "Register access failed.\n");
 		err = -EIO;
@@ -4452,7 +4452,7 @@ static int ql_init_device(struct pci_dev *pdev, struct net_device *ndev,
 
 	if (qlge_mpi_coredump) {
 		qdev->mpi_coredump =
-			vmalloc(sizeof(struct ql_mpi_coredump));
+			vmalloc(sizeof(struct qlge_mpi_coredump));
 		if (!qdev->mpi_coredump) {
 			err = -ENOMEM;
 			goto err_out2;
@@ -4490,12 +4490,12 @@ static int ql_init_device(struct pci_dev *pdev, struct net_device *ndev,
 		goto err_out2;
 	}
 
-	INIT_DELAYED_WORK(&qdev->asic_reset_work, ql_asic_reset_work);
-	INIT_DELAYED_WORK(&qdev->mpi_reset_work, ql_mpi_reset_work);
-	INIT_DELAYED_WORK(&qdev->mpi_work, ql_mpi_work);
-	INIT_DELAYED_WORK(&qdev->mpi_port_cfg_work, ql_mpi_port_cfg_work);
-	INIT_DELAYED_WORK(&qdev->mpi_idc_work, ql_mpi_idc_work);
-	INIT_DELAYED_WORK(&qdev->mpi_core_to_log, ql_mpi_core_to_log);
+	INIT_DELAYED_WORK(&qdev->asic_reset_work, qlge_asic_reset_work);
+	INIT_DELAYED_WORK(&qdev->mpi_reset_work, qlge_mpi_reset_work);
+	INIT_DELAYED_WORK(&qdev->mpi_work, qlge_mpi_work);
+	INIT_DELAYED_WORK(&qdev->mpi_port_cfg_work, qlge_mpi_port_cfg_work);
+	INIT_DELAYED_WORK(&qdev->mpi_idc_work, qlge_mpi_idc_work);
+	INIT_DELAYED_WORK(&qdev->mpi_core_to_log, qlge_mpi_core_to_log);
 	init_completion(&qdev->ide_completion);
 	mutex_init(&qdev->mpi_mutex);
 
@@ -4506,7 +4506,7 @@ static int ql_init_device(struct pci_dev *pdev, struct net_device *ndev,
 	}
 	return 0;
 err_out2:
-	ql_release_all(pdev);
+	qlge_release_all(pdev);
 err_out1:
 	pci_disable_device(pdev);
 	return err;
@@ -4527,12 +4527,12 @@ static const struct net_device_ops qlge_netdev_ops = {
 	.ndo_vlan_rx_kill_vid	= qlge_vlan_rx_kill_vid,
 };
 
-static void ql_timer(struct timer_list *t)
+static void qlge_timer(struct timer_list *t)
 {
-	struct ql_adapter *qdev = from_timer(qdev, t, timer);
+	struct qlge_adapter *qdev = from_timer(qdev, t, timer);
 	u32 var = 0;
 
-	var = ql_read32(qdev, STS);
+	var = qlge_read32(qdev, STS);
 	if (pci_channel_offline(qdev->pdev)) {
 		netif_err(qdev, ifup, qdev->ndev, "EEH STS = 0x%.08x.\n", var);
 		return;
@@ -4545,17 +4545,17 @@ static int qlge_probe(struct pci_dev *pdev,
 		      const struct pci_device_id *pci_entry)
 {
 	struct net_device *ndev = NULL;
-	struct ql_adapter *qdev = NULL;
+	struct qlge_adapter *qdev = NULL;
 	static int cards_found;
 	int err = 0;
 
-	ndev = alloc_etherdev_mq(sizeof(struct ql_adapter),
+	ndev = alloc_etherdev_mq(sizeof(struct qlge_adapter),
 				 min(MAX_CPUS,
 				     netif_get_num_default_rss_queues()));
 	if (!ndev)
 		return -ENOMEM;
 
-	err = ql_init_device(pdev, ndev, cards_found);
+	err = qlge_init_device(pdev, ndev, cards_found);
 	if (err < 0) {
 		free_netdev(ndev);
 		return err;
@@ -4564,13 +4564,13 @@ static int qlge_probe(struct pci_dev *pdev,
 	qdev = netdev_priv(ndev);
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 	ndev->hw_features = NETIF_F_SG |
-			    NETIF_F_IP_CSUM |
-			    NETIF_F_TSO |
-			    NETIF_F_TSO_ECN |
-			    NETIF_F_HW_VLAN_CTAG_TX |
-			    NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_FILTER |
-			    NETIF_F_RXCSUM;
+		NETIF_F_IP_CSUM |
+		NETIF_F_TSO |
+		NETIF_F_TSO_ECN |
+		NETIF_F_HW_VLAN_CTAG_TX |
+		NETIF_F_HW_VLAN_CTAG_RX |
+		NETIF_F_HW_VLAN_CTAG_FILTER |
+		NETIF_F_RXCSUM;
 	ndev->features = ndev->hw_features;
 	ndev->vlan_features = ndev->hw_features;
 	/* vlan gets same features (except vlan filter) */
@@ -4601,7 +4601,7 @@ static int qlge_probe(struct pci_dev *pdev,
 	err = register_netdev(ndev);
 	if (err) {
 		dev_err(&pdev->dev, "net device registration failed.\n");
-		ql_release_all(pdev);
+		qlge_release_all(pdev);
 		pci_disable_device(pdev);
 		free_netdev(ndev);
 		return err;
@@ -4609,43 +4609,43 @@ static int qlge_probe(struct pci_dev *pdev,
 	/* Start up the timer to trigger EEH if
 	 * the bus goes dead
 	 */
-	timer_setup(&qdev->timer, ql_timer, TIMER_DEFERRABLE);
+	timer_setup(&qdev->timer, qlge_timer, TIMER_DEFERRABLE);
 	mod_timer(&qdev->timer, jiffies + (5 * HZ));
-	ql_link_off(qdev);
-	ql_display_dev_info(ndev);
+	qlge_link_off(qdev);
+	qlge_display_dev_info(ndev);
 	atomic_set(&qdev->lb_count, 0);
 	cards_found++;
 	return 0;
 }
 
-netdev_tx_t ql_lb_send(struct sk_buff *skb, struct net_device *ndev)
+netdev_tx_t qlge_lb_send(struct sk_buff *skb, struct net_device *ndev)
 {
 	return qlge_send(skb, ndev);
 }
 
-int ql_clean_lb_rx_ring(struct rx_ring *rx_ring, int budget)
+int qlge_clean_lb_rx_ring(struct rx_ring *rx_ring, int budget)
 {
-	return ql_clean_inbound_rx_ring(rx_ring, budget);
+	return qlge_clean_inbound_rx_ring(rx_ring, budget);
 }
 
 static void qlge_remove(struct pci_dev *pdev)
 {
 	struct net_device *ndev = pci_get_drvdata(pdev);
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 
 	del_timer_sync(&qdev->timer);
-	ql_cancel_all_work_sync(qdev);
+	qlge_cancel_all_work_sync(qdev);
 	unregister_netdev(ndev);
-	ql_release_all(pdev);
+	qlge_release_all(pdev);
 	pci_disable_device(pdev);
 	free_netdev(ndev);
 }
 
 /* Clean up resources without touching hardware. */
-static void ql_eeh_close(struct net_device *ndev)
+static void qlge_eeh_close(struct net_device *ndev)
 {
 	int i;
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 
 	if (netif_carrier_ok(ndev)) {
 		netif_carrier_off(ndev);
@@ -4653,15 +4653,15 @@ static void ql_eeh_close(struct net_device *ndev)
 	}
 
 	/* Disabling the timer */
-	ql_cancel_all_work_sync(qdev);
+	qlge_cancel_all_work_sync(qdev);
 
 	for (i = 0; i < qdev->rss_ring_count; i++)
 		netif_napi_del(&qdev->rx_ring[i].napi);
 
 	clear_bit(QL_ADAPTER_UP, &qdev->flags);
-	ql_tx_ring_clean(qdev);
-	ql_free_rx_buffers(qdev);
-	ql_release_adapter_resources(qdev);
+	qlge_tx_ring_clean(qdev);
+	qlge_free_rx_buffers(qdev);
+	qlge_release_adapter_resources(qdev);
 }
 
 /*
@@ -4672,7 +4672,7 @@ static pci_ers_result_t qlge_io_error_detected(struct pci_dev *pdev,
 					       pci_channel_state_t state)
 {
 	struct net_device *ndev = pci_get_drvdata(pdev);
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 
 	switch (state) {
 	case pci_channel_io_normal:
@@ -4681,14 +4681,14 @@ static pci_ers_result_t qlge_io_error_detected(struct pci_dev *pdev,
 		netif_device_detach(ndev);
 		del_timer_sync(&qdev->timer);
 		if (netif_running(ndev))
-			ql_eeh_close(ndev);
+			qlge_eeh_close(ndev);
 		pci_disable_device(pdev);
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
 		dev_err(&pdev->dev,
 			"%s: pci_channel_io_perm_failure.\n", __func__);
 		del_timer_sync(&qdev->timer);
-		ql_eeh_close(ndev);
+		qlge_eeh_close(ndev);
 		set_bit(QL_EEH_FATAL, &qdev->flags);
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
@@ -4706,7 +4706,7 @@ static pci_ers_result_t qlge_io_error_detected(struct pci_dev *pdev,
 static pci_ers_result_t qlge_io_slot_reset(struct pci_dev *pdev)
 {
 	struct net_device *ndev = pci_get_drvdata(pdev);
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 
 	pdev->error_state = pci_channel_io_normal;
 
@@ -4718,7 +4718,7 @@ static pci_ers_result_t qlge_io_slot_reset(struct pci_dev *pdev)
 	}
 	pci_set_master(pdev);
 
-	if (ql_adapter_reset(qdev)) {
+	if (qlge_adapter_reset(qdev)) {
 		netif_err(qdev, drv, qdev->ndev, "reset FAILED!\n");
 		set_bit(QL_EEH_FATAL, &qdev->flags);
 		return PCI_ERS_RESULT_DISCONNECT;
@@ -4730,7 +4730,7 @@ static pci_ers_result_t qlge_io_slot_reset(struct pci_dev *pdev)
 static void qlge_io_resume(struct pci_dev *pdev)
 {
 	struct net_device *ndev = pci_get_drvdata(pdev);
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 	int err = 0;
 
 	if (netif_running(ndev)) {
@@ -4757,19 +4757,19 @@ static const struct pci_error_handlers qlge_err_handler = {
 static int __maybe_unused qlge_suspend(struct device *dev_d)
 {
 	struct net_device *ndev = dev_get_drvdata(dev_d);
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 	int err;
 
 	netif_device_detach(ndev);
 	del_timer_sync(&qdev->timer);
 
 	if (netif_running(ndev)) {
-		err = ql_adapter_down(qdev);
+		err = qlge_adapter_down(qdev);
 		if (!err)
 			return err;
 	}
 
-	ql_wol(qdev);
+	qlge_wol(qdev);
 
 	return 0;
 }
@@ -4777,7 +4777,7 @@ static int __maybe_unused qlge_suspend(struct device *dev_d)
 static int __maybe_unused qlge_resume(struct device *dev_d)
 {
 	struct net_device *ndev = dev_get_drvdata(dev_d);
-	struct ql_adapter *qdev = netdev_priv(ndev);
+	struct qlge_adapter *qdev = netdev_priv(ndev);
 	int err;
 
 	pci_set_master(to_pci_dev(dev_d));
@@ -4785,7 +4785,7 @@ static int __maybe_unused qlge_resume(struct device *dev_d)
 	device_wakeup_disable(dev_d);
 
 	if (netif_running(ndev)) {
-		err = ql_adapter_up(qdev);
+		err = qlge_adapter_up(qdev);
 		if (err)
 			return err;
 	}
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index 2ff3db2661a9..2b77995ec76c 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -1,28 +1,28 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "qlge.h"
 
-int ql_unpause_mpi_risc(struct ql_adapter *qdev)
+int qlge_unpause_mpi_risc(struct qlge_adapter *qdev)
 {
 	u32 tmp;
 
 	/* Un-pause the RISC */
-	tmp = ql_read32(qdev, CSR);
+	tmp = qlge_read32(qdev, CSR);
 	if (!(tmp & CSR_RP))
 		return -EIO;
 
-	ql_write32(qdev, CSR, CSR_CMD_CLR_PAUSE);
+	qlge_write32(qdev, CSR, CSR_CMD_CLR_PAUSE);
 	return 0;
 }
 
-int ql_pause_mpi_risc(struct ql_adapter *qdev)
+int qlge_pause_mpi_risc(struct qlge_adapter *qdev)
 {
 	u32 tmp;
 	int count;
 
 	/* Pause the RISC */
-	ql_write32(qdev, CSR, CSR_CMD_SET_PAUSE);
+	qlge_write32(qdev, CSR, CSR_CMD_SET_PAUSE);
 	for (count = UDELAY_COUNT; count; count--) {
-		tmp = ql_read32(qdev, CSR);
+		tmp = qlge_read32(qdev, CSR);
 		if (tmp & CSR_RP)
 			break;
 		mdelay(UDELAY_DELAY);
@@ -30,17 +30,17 @@ int ql_pause_mpi_risc(struct ql_adapter *qdev)
 	return (count == 0) ? -ETIMEDOUT : 0;
 }
 
-int ql_hard_reset_mpi_risc(struct ql_adapter *qdev)
+int qlge_hard_reset_mpi_risc(struct qlge_adapter *qdev)
 {
 	u32 tmp;
 	int count;
 
 	/* Reset the RISC */
-	ql_write32(qdev, CSR, CSR_CMD_SET_RST);
+	qlge_write32(qdev, CSR, CSR_CMD_SET_RST);
 	for (count = UDELAY_COUNT; count; count--) {
-		tmp = ql_read32(qdev, CSR);
+		tmp = qlge_read32(qdev, CSR);
 		if (tmp & CSR_RR) {
-			ql_write32(qdev, CSR, CSR_CMD_CLR_RST);
+			qlge_write32(qdev, CSR, CSR_CMD_CLR_RST);
 			break;
 		}
 		mdelay(UDELAY_DELAY);
@@ -48,47 +48,47 @@ int ql_hard_reset_mpi_risc(struct ql_adapter *qdev)
 	return (count == 0) ? -ETIMEDOUT : 0;
 }
 
-int ql_read_mpi_reg(struct ql_adapter *qdev, u32 reg, u32 *data)
+int qlge_read_mpi_reg(struct qlge_adapter *qdev, u32 reg, u32 *data)
 {
 	int status;
 	/* wait for reg to come ready */
-	status = ql_wait_reg_rdy(qdev, PROC_ADDR, PROC_ADDR_RDY, PROC_ADDR_ERR);
+	status = qlge_wait_reg_rdy(qdev, PROC_ADDR, PROC_ADDR_RDY, PROC_ADDR_ERR);
 	if (status)
 		goto exit;
 	/* set up for reg read */
-	ql_write32(qdev, PROC_ADDR, reg | PROC_ADDR_R);
+	qlge_write32(qdev, PROC_ADDR, reg | PROC_ADDR_R);
 	/* wait for reg to come ready */
-	status = ql_wait_reg_rdy(qdev, PROC_ADDR, PROC_ADDR_RDY, PROC_ADDR_ERR);
+	status = qlge_wait_reg_rdy(qdev, PROC_ADDR, PROC_ADDR_RDY, PROC_ADDR_ERR);
 	if (status)
 		goto exit;
 	/* get the data */
-	*data = ql_read32(qdev, PROC_DATA);
+	*data = qlge_read32(qdev, PROC_DATA);
 exit:
 	return status;
 }
 
-int ql_write_mpi_reg(struct ql_adapter *qdev, u32 reg, u32 data)
+int qlge_write_mpi_reg(struct qlge_adapter *qdev, u32 reg, u32 data)
 {
 	int status = 0;
 	/* wait for reg to come ready */
-	status = ql_wait_reg_rdy(qdev, PROC_ADDR, PROC_ADDR_RDY, PROC_ADDR_ERR);
+	status = qlge_wait_reg_rdy(qdev, PROC_ADDR, PROC_ADDR_RDY, PROC_ADDR_ERR);
 	if (status)
 		goto exit;
 	/* write the data to the data reg */
-	ql_write32(qdev, PROC_DATA, data);
+	qlge_write32(qdev, PROC_DATA, data);
 	/* trigger the write */
-	ql_write32(qdev, PROC_ADDR, reg);
+	qlge_write32(qdev, PROC_ADDR, reg);
 	/* wait for reg to come ready */
-	status = ql_wait_reg_rdy(qdev, PROC_ADDR, PROC_ADDR_RDY, PROC_ADDR_ERR);
+	status = qlge_wait_reg_rdy(qdev, PROC_ADDR, PROC_ADDR_RDY, PROC_ADDR_ERR);
 	if (status)
 		goto exit;
 exit:
 	return status;
 }
 
-int ql_soft_reset_mpi_risc(struct ql_adapter *qdev)
+int qlge_soft_reset_mpi_risc(struct qlge_adapter *qdev)
 {
-	return ql_write_mpi_reg(qdev, 0x00001010, 1);
+	return qlge_write_mpi_reg(qdev, 0x00001010, 1);
 }
 
 /* Determine if we are in charge of the firmware. If
@@ -96,7 +96,7 @@ int ql_soft_reset_mpi_risc(struct ql_adapter *qdev)
  * we are the higher function and the lower function
  * is not enabled.
  */
-int ql_own_firmware(struct ql_adapter *qdev)
+int qlge_own_firmware(struct qlge_adapter *qdev)
 {
 	u32 temp;
 
@@ -112,43 +112,43 @@ int ql_own_firmware(struct ql_adapter *qdev)
 	 * enabled, then we are responsible for
 	 * core dump and firmware reset after an error.
 	 */
-	temp =  ql_read32(qdev, STS);
+	temp =  qlge_read32(qdev, STS);
 	if (!(temp & (1 << (8 + qdev->alt_func))))
 		return 1;
 
 	return 0;
 }
 
-static int ql_get_mb_sts(struct ql_adapter *qdev, struct mbox_params *mbcp)
+static int qlge_get_mb_sts(struct qlge_adapter *qdev, struct mbox_params *mbcp)
 {
 	int i, status;
 
-	status = ql_sem_spinlock(qdev, SEM_PROC_REG_MASK);
+	status = qlge_sem_spinlock(qdev, SEM_PROC_REG_MASK);
 	if (status)
 		return -EBUSY;
 	for (i = 0; i < mbcp->out_count; i++) {
 		status =
-		    ql_read_mpi_reg(qdev, qdev->mailbox_out + i,
-				    &mbcp->mbox_out[i]);
+		    qlge_read_mpi_reg(qdev, qdev->mailbox_out + i,
+				      &mbcp->mbox_out[i]);
 		if (status) {
 			netif_err(qdev, drv, qdev->ndev, "Failed mailbox read.\n");
 			break;
 		}
 	}
-	ql_sem_unlock(qdev, SEM_PROC_REG_MASK);	/* does flush too */
+	qlge_sem_unlock(qdev, SEM_PROC_REG_MASK);	/* does flush too */
 	return status;
 }
 
 /* Wait for a single mailbox command to complete.
  * Returns zero on success.
  */
-static int ql_wait_mbx_cmd_cmplt(struct ql_adapter *qdev)
+static int qlge_wait_mbx_cmd_cmplt(struct qlge_adapter *qdev)
 {
 	int count;
 	u32 value;
 
 	for (count = 100; count; count--) {
-		value = ql_read32(qdev, STS);
+		value = qlge_read32(qdev, STS);
 		if (value & STS_PI)
 			return 0;
 		mdelay(UDELAY_DELAY); /* 100ms */
@@ -159,7 +159,7 @@ static int ql_wait_mbx_cmd_cmplt(struct ql_adapter *qdev)
 /* Execute a single mailbox command.
  * Caller must hold PROC_ADDR semaphore.
  */
-static int ql_exec_mb_cmd(struct ql_adapter *qdev, struct mbox_params *mbcp)
+static int qlge_exec_mb_cmd(struct qlge_adapter *qdev, struct mbox_params *mbcp)
 {
 	int i, status;
 
@@ -167,10 +167,10 @@ static int ql_exec_mb_cmd(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	 * Make sure there's nothing pending.
 	 * This shouldn't happen.
 	 */
-	if (ql_read32(qdev, CSR) & CSR_HRI)
+	if (qlge_read32(qdev, CSR) & CSR_HRI)
 		return -EIO;
 
-	status = ql_sem_spinlock(qdev, SEM_PROC_REG_MASK);
+	status = qlge_sem_spinlock(qdev, SEM_PROC_REG_MASK);
 	if (status)
 		return status;
 
@@ -178,17 +178,17 @@ static int ql_exec_mb_cmd(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	 * Fill the outbound mailboxes.
 	 */
 	for (i = 0; i < mbcp->in_count; i++) {
-		status = ql_write_mpi_reg(qdev, qdev->mailbox_in + i,
-					  mbcp->mbox_in[i]);
+		status = qlge_write_mpi_reg(qdev, qdev->mailbox_in + i,
+					    mbcp->mbox_in[i]);
 		if (status)
 			goto end;
 	}
 	/*
 	 * Wake up the MPI firmware.
 	 */
-	ql_write32(qdev, CSR, CSR_CMD_SET_H2R_INT);
+	qlge_write32(qdev, CSR, CSR_CMD_SET_H2R_INT);
 end:
-	ql_sem_unlock(qdev, SEM_PROC_REG_MASK);
+	qlge_sem_unlock(qdev, SEM_PROC_REG_MASK);
 	return status;
 }
 
@@ -199,7 +199,7 @@ static int ql_exec_mb_cmd(struct ql_adapter *qdev, struct mbox_params *mbcp)
  * to handler processing this since a mailbox command
  * will need to be sent to ACK the request.
  */
-static int ql_idc_req_aen(struct ql_adapter *qdev)
+static int qlge_idc_req_aen(struct qlge_adapter *qdev)
 {
 	int status;
 	struct mbox_params *mbcp = &qdev->idc_mbc;
@@ -209,17 +209,17 @@ static int ql_idc_req_aen(struct ql_adapter *qdev)
 	 * handle the request.
 	 */
 	mbcp->out_count = 4;
-	status = ql_get_mb_sts(qdev, mbcp);
+	status = qlge_get_mb_sts(qdev, mbcp);
 	if (status) {
 		netif_err(qdev, drv, qdev->ndev,
 			  "Could not read MPI, resetting ASIC!\n");
-		ql_queue_asic_error(qdev);
+		qlge_queue_asic_error(qdev);
 	} else	{
 		/* Begin polled mode early so
 		 * we don't get another interrupt
 		 * when we leave mpi_worker.
 		 */
-		ql_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16));
+		qlge_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16));
 		queue_delayed_work(qdev->workqueue, &qdev->mpi_idc_work, 0);
 	}
 	return status;
@@ -228,17 +228,17 @@ static int ql_idc_req_aen(struct ql_adapter *qdev)
 /* Process an inter-device event completion.
  * If good, signal the caller's completion.
  */
-static int ql_idc_cmplt_aen(struct ql_adapter *qdev)
+static int qlge_idc_cmplt_aen(struct qlge_adapter *qdev)
 {
 	int status;
 	struct mbox_params *mbcp = &qdev->idc_mbc;
 
 	mbcp->out_count = 4;
-	status = ql_get_mb_sts(qdev, mbcp);
+	status = qlge_get_mb_sts(qdev, mbcp);
 	if (status) {
 		netif_err(qdev, drv, qdev->ndev,
 			  "Could not read MPI, resetting RISC!\n");
-		ql_queue_fw_error(qdev);
+		qlge_queue_fw_error(qdev);
 	} else {
 		/* Wake up the sleeping mpi_idc_work thread that is
 		 * waiting for this event.
@@ -248,13 +248,13 @@ static int ql_idc_cmplt_aen(struct ql_adapter *qdev)
 	return status;
 }
 
-static void ql_link_up(struct ql_adapter *qdev, struct mbox_params *mbcp)
+static void qlge_link_up(struct qlge_adapter *qdev, struct mbox_params *mbcp)
 {
 	int status;
 
 	mbcp->out_count = 2;
 
-	status = ql_get_mb_sts(qdev, mbcp);
+	status = qlge_get_mb_sts(qdev, mbcp);
 	if (status) {
 		netif_err(qdev, drv, qdev->ndev,
 			  "%s: Could not get mailbox status.\n", __func__);
@@ -268,7 +268,7 @@ static void ql_link_up(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	 * then set up the CAM and frame routing.
 	 */
 	if (test_bit(QL_CAM_RT_SET, &qdev->flags)) {
-		status = ql_cam_route_initialize(qdev);
+		status = qlge_cam_route_initialize(qdev);
 		if (status) {
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Failed to init CAM/Routing tables.\n");
@@ -288,34 +288,34 @@ static void ql_link_up(struct ql_adapter *qdev, struct mbox_params *mbcp)
 		 * we don't get another interrupt
 		 * when we leave mpi_worker dpc.
 		 */
-		ql_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16));
+		qlge_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16));
 		queue_delayed_work(qdev->workqueue,
 				   &qdev->mpi_port_cfg_work, 0);
 	}
 
-	ql_link_on(qdev);
+	qlge_link_on(qdev);
 }
 
-static void ql_link_down(struct ql_adapter *qdev, struct mbox_params *mbcp)
+static void qlge_link_down(struct qlge_adapter *qdev, struct mbox_params *mbcp)
 {
 	int status;
 
 	mbcp->out_count = 3;
 
-	status = ql_get_mb_sts(qdev, mbcp);
+	status = qlge_get_mb_sts(qdev, mbcp);
 	if (status)
 		netif_err(qdev, drv, qdev->ndev, "Link down AEN broken!\n");
 
-	ql_link_off(qdev);
+	qlge_link_off(qdev);
 }
 
-static int ql_sfp_in(struct ql_adapter *qdev, struct mbox_params *mbcp)
+static int qlge_sfp_in(struct qlge_adapter *qdev, struct mbox_params *mbcp)
 {
 	int status;
 
 	mbcp->out_count = 5;
 
-	status = ql_get_mb_sts(qdev, mbcp);
+	status = qlge_get_mb_sts(qdev, mbcp);
 	if (status)
 		netif_err(qdev, drv, qdev->ndev, "SFP in AEN broken!\n");
 	else
@@ -324,13 +324,13 @@ static int ql_sfp_in(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	return status;
 }
 
-static int ql_sfp_out(struct ql_adapter *qdev, struct mbox_params *mbcp)
+static int qlge_sfp_out(struct qlge_adapter *qdev, struct mbox_params *mbcp)
 {
 	int status;
 
 	mbcp->out_count = 1;
 
-	status = ql_get_mb_sts(qdev, mbcp);
+	status = qlge_get_mb_sts(qdev, mbcp);
 	if (status)
 		netif_err(qdev, drv, qdev->ndev, "SFP out AEN broken!\n");
 	else
@@ -339,13 +339,13 @@ static int ql_sfp_out(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	return status;
 }
 
-static int ql_aen_lost(struct ql_adapter *qdev, struct mbox_params *mbcp)
+static int qlge_aen_lost(struct qlge_adapter *qdev, struct mbox_params *mbcp)
 {
 	int status;
 
 	mbcp->out_count = 6;
 
-	status = ql_get_mb_sts(qdev, mbcp);
+	status = qlge_get_mb_sts(qdev, mbcp);
 	if (status) {
 		netif_err(qdev, drv, qdev->ndev, "Lost AEN broken!\n");
 	} else {
@@ -360,20 +360,20 @@ static int ql_aen_lost(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	return status;
 }
 
-static void ql_init_fw_done(struct ql_adapter *qdev, struct mbox_params *mbcp)
+static void qlge_init_fw_done(struct qlge_adapter *qdev, struct mbox_params *mbcp)
 {
 	int status;
 
 	mbcp->out_count = 2;
 
-	status = ql_get_mb_sts(qdev, mbcp);
+	status = qlge_get_mb_sts(qdev, mbcp);
 	if (status) {
 		netif_err(qdev, drv, qdev->ndev, "Firmware did not initialize!\n");
 	} else {
 		netif_err(qdev, drv, qdev->ndev, "Firmware Revision  = 0x%.08x.\n",
 			  mbcp->mbox_out[1]);
 		qdev->fw_rev_id = mbcp->mbox_out[1];
-		status = ql_cam_route_initialize(qdev);
+		status = qlge_cam_route_initialize(qdev);
 		if (status)
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Failed to init CAM/Routing tables.\n");
@@ -387,26 +387,26 @@ static void ql_init_fw_done(struct ql_adapter *qdev, struct mbox_params *mbcp)
  *  It also gets called when a mailbox command is polling for
  *  it's completion.
  */
-static int ql_mpi_handler(struct ql_adapter *qdev, struct mbox_params *mbcp)
+static int qlge_mpi_handler(struct qlge_adapter *qdev, struct mbox_params *mbcp)
 {
 	int status;
 	int orig_count = mbcp->out_count;
 
 	/* Just get mailbox zero for now. */
 	mbcp->out_count = 1;
-	status = ql_get_mb_sts(qdev, mbcp);
+	status = qlge_get_mb_sts(qdev, mbcp);
 	if (status) {
 		netif_err(qdev, drv, qdev->ndev,
 			  "Could not read MPI, resetting ASIC!\n");
-		ql_queue_asic_error(qdev);
+		qlge_queue_asic_error(qdev);
 		goto end;
 	}
 
 	switch (mbcp->mbox_out[0]) {
-	/* This case is only active when we arrive here
-	 * as a result of issuing a mailbox command to
-	 * the firmware.
-	 */
+		/* This case is only active when we arrive here
+		 * as a result of issuing a mailbox command to
+		 * the firmware.
+		 */
 	case MB_CMD_STS_INTRMDT:
 	case MB_CMD_STS_GOOD:
 	case MB_CMD_STS_INVLD_CMD:
@@ -421,34 +421,34 @@ static int ql_mpi_handler(struct ql_adapter *qdev, struct mbox_params *mbcp)
 		 * command completion.
 		 */
 		mbcp->out_count = orig_count;
-		status = ql_get_mb_sts(qdev, mbcp);
+		status = qlge_get_mb_sts(qdev, mbcp);
 		return status;
 
-	/* We are being asked by firmware to accept
-	 * a change to the port.  This is only
-	 * a change to max frame sizes (Tx/Rx), pause
-	 * parameters, or loopback mode.
-	 */
+		/* We are being asked by firmware to accept
+		 * a change to the port.  This is only
+		 * a change to max frame sizes (Tx/Rx), pause
+		 * parameters, or loopback mode.
+		 */
 	case AEN_IDC_REQ:
-		status = ql_idc_req_aen(qdev);
+		status = qlge_idc_req_aen(qdev);
 		break;
 
-	/* Process and inbound IDC event.
-	 * This will happen when we're trying to
-	 * change tx/rx max frame size, change pause
-	 * parameters or loopback mode.
-	 */
+		/* Process and inbound IDC event.
+		 * This will happen when we're trying to
+		 * change tx/rx max frame size, change pause
+		 * parameters or loopback mode.
+		 */
 	case AEN_IDC_CMPLT:
 	case AEN_IDC_EXT:
-		status = ql_idc_cmplt_aen(qdev);
+		status = qlge_idc_cmplt_aen(qdev);
 		break;
 
 	case AEN_LINK_UP:
-		ql_link_up(qdev, mbcp);
+		qlge_link_up(qdev, mbcp);
 		break;
 
 	case AEN_LINK_DOWN:
-		ql_link_down(qdev, mbcp);
+		qlge_link_down(qdev, mbcp);
 		break;
 
 	case AEN_FW_INIT_DONE:
@@ -457,48 +457,48 @@ static int ql_mpi_handler(struct ql_adapter *qdev, struct mbox_params *mbcp)
 		 */
 		if (mbcp->mbox_in[0] == MB_CMD_EX_FW) {
 			mbcp->out_count = orig_count;
-			status = ql_get_mb_sts(qdev, mbcp);
+			status = qlge_get_mb_sts(qdev, mbcp);
 			mbcp->mbox_out[0] = MB_CMD_STS_GOOD;
 			return status;
 		}
-		ql_init_fw_done(qdev, mbcp);
+		qlge_init_fw_done(qdev, mbcp);
 		break;
 
 	case AEN_AEN_SFP_IN:
-		ql_sfp_in(qdev, mbcp);
+		qlge_sfp_in(qdev, mbcp);
 		break;
 
 	case AEN_AEN_SFP_OUT:
-		ql_sfp_out(qdev, mbcp);
+		qlge_sfp_out(qdev, mbcp);
 		break;
 
-	/* This event can arrive at boot time or after an
-	 * MPI reset if the firmware failed to initialize.
-	 */
+		/* This event can arrive at boot time or after an
+		 * MPI reset if the firmware failed to initialize.
+		 */
 	case AEN_FW_INIT_FAIL:
 		/* If we're in process on executing the firmware,
 		 * then convert the status to normal mailbox status.
 		 */
 		if (mbcp->mbox_in[0] == MB_CMD_EX_FW) {
 			mbcp->out_count = orig_count;
-			status = ql_get_mb_sts(qdev, mbcp);
+			status = qlge_get_mb_sts(qdev, mbcp);
 			mbcp->mbox_out[0] = MB_CMD_STS_ERR;
 			return status;
 		}
 		netif_err(qdev, drv, qdev->ndev,
 			  "Firmware initialization failed.\n");
 		status = -EIO;
-		ql_queue_fw_error(qdev);
+		qlge_queue_fw_error(qdev);
 		break;
 
 	case AEN_SYS_ERR:
 		netif_err(qdev, drv, qdev->ndev, "System Error.\n");
-		ql_queue_fw_error(qdev);
+		qlge_queue_fw_error(qdev);
 		status = -EIO;
 		break;
 
 	case AEN_AEN_LOST:
-		ql_aen_lost(qdev, mbcp);
+		qlge_aen_lost(qdev, mbcp);
 		break;
 
 	case AEN_DCBX_CHG:
@@ -510,7 +510,7 @@ static int ql_mpi_handler(struct ql_adapter *qdev, struct mbox_params *mbcp)
 		/* Clear the MPI firmware status. */
 	}
 end:
-	ql_write32(qdev, CSR, CSR_CMD_CLR_R2PCI_INT);
+	qlge_write32(qdev, CSR, CSR_CMD_CLR_R2PCI_INT);
 	/* Restore the original mailbox count to
 	 * what the caller asked for.  This can get
 	 * changed when a mailbox command is waiting
@@ -526,7 +526,7 @@ static int ql_mpi_handler(struct ql_adapter *qdev, struct mbox_params *mbcp)
  * element in the array contains the value for it's
  * respective mailbox register.
  */
-static int ql_mailbox_command(struct ql_adapter *qdev, struct mbox_params *mbcp)
+static int qlge_mailbox_command(struct qlge_adapter *qdev, struct mbox_params *mbcp)
 {
 	int status;
 	unsigned long count;
@@ -534,10 +534,10 @@ static int ql_mailbox_command(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	mutex_lock(&qdev->mpi_mutex);
 
 	/* Begin polled mode for MPI */
-	ql_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16));
+	qlge_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16));
 
 	/* Load the mailbox registers and wake up MPI RISC. */
-	status = ql_exec_mb_cmd(qdev, mbcp);
+	status = qlge_exec_mb_cmd(qdev, mbcp);
 	if (status)
 		goto end;
 
@@ -556,7 +556,7 @@ static int ql_mailbox_command(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	count = jiffies + HZ * MAILBOX_TIMEOUT;
 	do {
 		/* Wait for the interrupt to come in. */
-		status = ql_wait_mbx_cmd_cmplt(qdev);
+		status = qlge_wait_mbx_cmd_cmplt(qdev);
 		if (status)
 			continue;
 
@@ -565,7 +565,7 @@ static int ql_mailbox_command(struct ql_adapter *qdev, struct mbox_params *mbcp)
 		 * will be spawned. If it's our completion
 		 * we will catch it below.
 		 */
-		status = ql_mpi_handler(qdev, mbcp);
+		status = qlge_mpi_handler(qdev, mbcp);
 		if (status)
 			goto end;
 
@@ -574,9 +574,9 @@ static int ql_mailbox_command(struct ql_adapter *qdev, struct mbox_params *mbcp)
 		 * completion then get out.
 		 */
 		if (((mbcp->mbox_out[0] & 0x0000f000) ==
-					MB_CMD_STS_GOOD) ||
-			((mbcp->mbox_out[0] & 0x0000f000) ==
-					MB_CMD_STS_INTRMDT))
+		     MB_CMD_STS_GOOD) ||
+		    ((mbcp->mbox_out[0] & 0x0000f000) ==
+		     MB_CMD_STS_INTRMDT))
 			goto done;
 	} while (time_before(jiffies, count));
 
@@ -590,17 +590,17 @@ static int ql_mailbox_command(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	/* Now we can clear the interrupt condition
 	 * and look at our status.
 	 */
-	ql_write32(qdev, CSR, CSR_CMD_CLR_R2PCI_INT);
+	qlge_write32(qdev, CSR, CSR_CMD_CLR_R2PCI_INT);
 
 	if (((mbcp->mbox_out[0] & 0x0000f000) !=
-					MB_CMD_STS_GOOD) &&
-		((mbcp->mbox_out[0] & 0x0000f000) !=
-					MB_CMD_STS_INTRMDT)) {
+	     MB_CMD_STS_GOOD) &&
+	    ((mbcp->mbox_out[0] & 0x0000f000) !=
+	     MB_CMD_STS_INTRMDT)) {
 		status = -EIO;
 	}
 end:
 	/* End polled mode for MPI */
-	ql_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16) | INTR_MASK_PI);
+	qlge_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16) | INTR_MASK_PI);
 	mutex_unlock(&qdev->mpi_mutex);
 	return status;
 }
@@ -609,7 +609,7 @@ static int ql_mailbox_command(struct ql_adapter *qdev, struct mbox_params *mbcp)
  * driver banner and for ethtool info.
  * Returns zero on success.
  */
-int ql_mb_about_fw(struct ql_adapter *qdev)
+int qlge_mb_about_fw(struct qlge_adapter *qdev)
 {
 	struct mbox_params mbc;
 	struct mbox_params *mbcp = &mbc;
@@ -622,7 +622,7 @@ int ql_mb_about_fw(struct ql_adapter *qdev)
 
 	mbcp->mbox_in[0] = MB_CMD_ABOUT_FW;
 
-	status = ql_mailbox_command(qdev, mbcp);
+	status = qlge_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
 
@@ -641,7 +641,7 @@ int ql_mb_about_fw(struct ql_adapter *qdev)
 /* Get functional state for MPI firmware.
  * Returns zero on success.
  */
-int ql_mb_get_fw_state(struct ql_adapter *qdev)
+int qlge_mb_get_fw_state(struct qlge_adapter *qdev)
 {
 	struct mbox_params mbc;
 	struct mbox_params *mbcp = &mbc;
@@ -654,7 +654,7 @@ int ql_mb_get_fw_state(struct ql_adapter *qdev)
 
 	mbcp->mbox_in[0] = MB_CMD_GET_FW_STATE;
 
-	status = ql_mailbox_command(qdev, mbcp);
+	status = qlge_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
 
@@ -680,7 +680,7 @@ int ql_mb_get_fw_state(struct ql_adapter *qdev)
 /* Send and ACK mailbox command to the firmware to
  * let it continue with the change.
  */
-static int ql_mb_idc_ack(struct ql_adapter *qdev)
+static int qlge_mb_idc_ack(struct qlge_adapter *qdev)
 {
 	struct mbox_params mbc;
 	struct mbox_params *mbcp = &mbc;
@@ -697,7 +697,7 @@ static int ql_mb_idc_ack(struct ql_adapter *qdev)
 	mbcp->mbox_in[3] = qdev->idc_mbc.mbox_out[3];
 	mbcp->mbox_in[4] = qdev->idc_mbc.mbox_out[4];
 
-	status = ql_mailbox_command(qdev, mbcp);
+	status = qlge_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
 
@@ -712,7 +712,7 @@ static int ql_mb_idc_ack(struct ql_adapter *qdev)
  * for the current port.
  * Most likely will block.
  */
-int ql_mb_set_port_cfg(struct ql_adapter *qdev)
+int qlge_mb_set_port_cfg(struct qlge_adapter *qdev)
 {
 	struct mbox_params mbc;
 	struct mbox_params *mbcp = &mbc;
@@ -727,7 +727,7 @@ int ql_mb_set_port_cfg(struct ql_adapter *qdev)
 	mbcp->mbox_in[1] = qdev->link_config;
 	mbcp->mbox_in[2] = qdev->max_frame_size;
 
-	status = ql_mailbox_command(qdev, mbcp);
+	status = qlge_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
 
@@ -742,8 +742,8 @@ int ql_mb_set_port_cfg(struct ql_adapter *qdev)
 	return status;
 }
 
-static int ql_mb_dump_ram(struct ql_adapter *qdev, u64 req_dma, u32 addr,
-			  u32 size)
+static int qlge_mb_dump_ram(struct qlge_adapter *qdev, u64 req_dma, u32 addr,
+			    u32 size)
 {
 	int status = 0;
 	struct mbox_params mbc;
@@ -764,7 +764,7 @@ static int ql_mb_dump_ram(struct ql_adapter *qdev, u64 req_dma, u32 addr,
 	mbcp->mbox_in[7] = LSW(MSD(req_dma));
 	mbcp->mbox_in[8] = MSW(addr);
 
-	status = ql_mailbox_command(qdev, mbcp);
+	status = qlge_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
 
@@ -776,8 +776,8 @@ static int ql_mb_dump_ram(struct ql_adapter *qdev, u64 req_dma, u32 addr,
 }
 
 /* Issue a mailbox command to dump RISC RAM. */
-int ql_dump_risc_ram_area(struct ql_adapter *qdev, void *buf,
-			  u32 ram_addr, int word_count)
+int qlge_dump_risc_ram_area(struct qlge_adapter *qdev, void *buf,
+			    u32 ram_addr, int word_count)
 {
 	int status;
 	char *my_buf;
@@ -789,7 +789,7 @@ int ql_dump_risc_ram_area(struct ql_adapter *qdev, void *buf,
 	if (!my_buf)
 		return -EIO;
 
-	status = ql_mb_dump_ram(qdev, buf_dma, ram_addr, word_count);
+	status = qlge_mb_dump_ram(qdev, buf_dma, ram_addr, word_count);
 	if (!status)
 		memcpy(buf, my_buf, word_count * sizeof(u32));
 
@@ -802,7 +802,7 @@ int ql_dump_risc_ram_area(struct ql_adapter *qdev, void *buf,
  * for the current port.
  * Most likely will block.
  */
-int ql_mb_get_port_cfg(struct ql_adapter *qdev)
+int qlge_mb_get_port_cfg(struct qlge_adapter *qdev)
 {
 	struct mbox_params mbc;
 	struct mbox_params *mbcp = &mbc;
@@ -815,7 +815,7 @@ int ql_mb_get_port_cfg(struct ql_adapter *qdev)
 
 	mbcp->mbox_in[0] = MB_CMD_GET_PORT_CFG;
 
-	status = ql_mailbox_command(qdev, mbcp);
+	status = qlge_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
 
@@ -832,7 +832,7 @@ int ql_mb_get_port_cfg(struct ql_adapter *qdev)
 	return status;
 }
 
-int ql_mb_wol_mode(struct ql_adapter *qdev, u32 wol)
+int qlge_mb_wol_mode(struct qlge_adapter *qdev, u32 wol)
 {
 	struct mbox_params mbc;
 	struct mbox_params *mbcp = &mbc;
@@ -846,7 +846,7 @@ int ql_mb_wol_mode(struct ql_adapter *qdev, u32 wol)
 	mbcp->mbox_in[0] = MB_CMD_SET_WOL_MODE;
 	mbcp->mbox_in[1] = wol;
 
-	status = ql_mailbox_command(qdev, mbcp);
+	status = qlge_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
 
@@ -857,7 +857,7 @@ int ql_mb_wol_mode(struct ql_adapter *qdev, u32 wol)
 	return status;
 }
 
-int ql_mb_wol_set_magic(struct ql_adapter *qdev, u32 enable_wol)
+int qlge_mb_wol_set_magic(struct qlge_adapter *qdev, u32 enable_wol)
 {
 	struct mbox_params mbc;
 	struct mbox_params *mbcp = &mbc;
@@ -888,7 +888,7 @@ int ql_mb_wol_set_magic(struct ql_adapter *qdev, u32 enable_wol)
 		mbcp->mbox_in[7] = 0;
 	}
 
-	status = ql_mailbox_command(qdev, mbcp);
+	status = qlge_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
 
@@ -906,7 +906,7 @@ int ql_mb_wol_set_magic(struct ql_adapter *qdev, u32 enable_wol)
  * The firmware will complete the request if the other
  * function doesn't respond.
  */
-static int ql_idc_wait(struct ql_adapter *qdev)
+static int qlge_idc_wait(struct qlge_adapter *qdev)
 {
 	int status = -ETIMEDOUT;
 	struct mbox_params *mbcp = &qdev->idc_mbc;
@@ -947,7 +947,7 @@ static int ql_idc_wait(struct ql_adapter *qdev)
 	return status;
 }
 
-int ql_mb_set_led_cfg(struct ql_adapter *qdev, u32 led_config)
+int qlge_mb_set_led_cfg(struct qlge_adapter *qdev, u32 led_config)
 {
 	struct mbox_params mbc;
 	struct mbox_params *mbcp = &mbc;
@@ -961,7 +961,7 @@ int ql_mb_set_led_cfg(struct ql_adapter *qdev, u32 led_config)
 	mbcp->mbox_in[0] = MB_CMD_SET_LED_CFG;
 	mbcp->mbox_in[1] = led_config;
 
-	status = ql_mailbox_command(qdev, mbcp);
+	status = qlge_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
 
@@ -974,7 +974,7 @@ int ql_mb_set_led_cfg(struct ql_adapter *qdev, u32 led_config)
 	return status;
 }
 
-int ql_mb_get_led_cfg(struct ql_adapter *qdev)
+int qlge_mb_get_led_cfg(struct qlge_adapter *qdev)
 {
 	struct mbox_params mbc;
 	struct mbox_params *mbcp = &mbc;
@@ -987,7 +987,7 @@ int ql_mb_get_led_cfg(struct ql_adapter *qdev)
 
 	mbcp->mbox_in[0] = MB_CMD_GET_LED_CFG;
 
-	status = ql_mailbox_command(qdev, mbcp);
+	status = qlge_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
 
@@ -1001,7 +1001,7 @@ int ql_mb_get_led_cfg(struct ql_adapter *qdev)
 	return status;
 }
 
-int ql_mb_set_mgmnt_traffic_ctl(struct ql_adapter *qdev, u32 control)
+int qlge_mb_set_mgmnt_traffic_ctl(struct qlge_adapter *qdev, u32 control)
 {
 	struct mbox_params mbc;
 	struct mbox_params *mbcp = &mbc;
@@ -1015,7 +1015,7 @@ int ql_mb_set_mgmnt_traffic_ctl(struct ql_adapter *qdev, u32 control)
 	mbcp->mbox_in[0] = MB_CMD_SET_MGMNT_TFK_CTL;
 	mbcp->mbox_in[1] = control;
 
-	status = ql_mailbox_command(qdev, mbcp);
+	status = qlge_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
 
@@ -1038,7 +1038,7 @@ int ql_mb_set_mgmnt_traffic_ctl(struct ql_adapter *qdev, u32 control)
 }
 
 /* Returns a negative error code or the mailbox command status. */
-static int ql_mb_get_mgmnt_traffic_ctl(struct ql_adapter *qdev, u32 *control)
+static int qlge_mb_get_mgmnt_traffic_ctl(struct qlge_adapter *qdev, u32 *control)
 {
 	struct mbox_params mbc;
 	struct mbox_params *mbcp = &mbc;
@@ -1052,7 +1052,7 @@ static int ql_mb_get_mgmnt_traffic_ctl(struct ql_adapter *qdev, u32 *control)
 
 	mbcp->mbox_in[0] = MB_CMD_GET_MGMNT_TFK_CTL;
 
-	status = ql_mailbox_command(qdev, mbcp);
+	status = qlge_mailbox_command(qdev, mbcp);
 	if (status)
 		return status;
 
@@ -1073,15 +1073,15 @@ static int ql_mb_get_mgmnt_traffic_ctl(struct ql_adapter *qdev, u32 *control)
 	return status;
 }
 
-int ql_wait_fifo_empty(struct ql_adapter *qdev)
+int qlge_wait_fifo_empty(struct qlge_adapter *qdev)
 {
 	int count;
 	u32 mgmnt_fifo_empty;
 	u32 nic_fifo_empty;
 
 	for (count = 6; count; count--) {
-		nic_fifo_empty = ql_read32(qdev, STS) & STS_NFE;
-		ql_mb_get_mgmnt_traffic_ctl(qdev, &mgmnt_fifo_empty);
+		nic_fifo_empty = qlge_read32(qdev, STS) & STS_NFE;
+		qlge_mb_get_mgmnt_traffic_ctl(qdev, &mgmnt_fifo_empty);
 		mgmnt_fifo_empty &= MB_GET_MPI_TFK_FIFO_EMPTY;
 		if (nic_fifo_empty && mgmnt_fifo_empty)
 			return 0;
@@ -1093,14 +1093,14 @@ int ql_wait_fifo_empty(struct ql_adapter *qdev)
 /* API called in work thread context to set new TX/RX
  * maximum frame size values to match MTU.
  */
-static int ql_set_port_cfg(struct ql_adapter *qdev)
+static int qlge_set_port_cfg(struct qlge_adapter *qdev)
 {
 	int status;
 
-	status = ql_mb_set_port_cfg(qdev);
+	status = qlge_mb_set_port_cfg(qdev);
 	if (status)
 		return status;
-	status = ql_idc_wait(qdev);
+	status = qlge_idc_wait(qdev);
 	return status;
 }
 
@@ -1112,13 +1112,13 @@ static int ql_set_port_cfg(struct ql_adapter *qdev)
  * from the firmware and, if necessary, changes them to match
  * the MTU setting.
  */
-void ql_mpi_port_cfg_work(struct work_struct *work)
+void qlge_mpi_port_cfg_work(struct work_struct *work)
 {
-	struct ql_adapter *qdev =
-	    container_of(work, struct ql_adapter, mpi_port_cfg_work.work);
+	struct qlge_adapter *qdev =
+		container_of(work, struct qlge_adapter, mpi_port_cfg_work.work);
 	int status;
 
-	status = ql_mb_get_port_cfg(qdev);
+	status = qlge_mb_get_port_cfg(qdev);
 	if (status) {
 		netif_err(qdev, drv, qdev->ndev,
 			  "Bug: Failed to get port config data.\n");
@@ -1131,7 +1131,7 @@ void ql_mpi_port_cfg_work(struct work_struct *work)
 
 	qdev->link_config |=	CFG_JUMBO_FRAME_SIZE;
 	qdev->max_frame_size = CFG_DEFAULT_MAX_FRAME_SIZE;
-	status = ql_set_port_cfg(qdev);
+	status = qlge_set_port_cfg(qdev);
 	if (status) {
 		netif_err(qdev, drv, qdev->ndev,
 			  "Bug: Failed to set port config data.\n");
@@ -1141,7 +1141,7 @@ void ql_mpi_port_cfg_work(struct work_struct *work)
 	clear_bit(QL_PORT_CFG, &qdev->flags);
 	return;
 err:
-	ql_queue_fw_error(qdev);
+	qlge_queue_fw_error(qdev);
 	goto end;
 }
 
@@ -1151,10 +1151,10 @@ void ql_mpi_port_cfg_work(struct work_struct *work)
  * has been made and then send a mailbox command ACKing
  * the change request.
  */
-void ql_mpi_idc_work(struct work_struct *work)
+void qlge_mpi_idc_work(struct work_struct *work)
 {
-	struct ql_adapter *qdev =
-	    container_of(work, struct ql_adapter, mpi_idc_work.work);
+	struct qlge_adapter *qdev =
+		container_of(work, struct qlge_adapter, mpi_idc_work.work);
 	int status;
 	struct mbox_params *mbcp = &qdev->idc_mbc;
 	u32 aen;
@@ -1170,7 +1170,7 @@ void ql_mpi_idc_work(struct work_struct *work)
 		break;
 	case MB_CMD_PORT_RESET:
 	case MB_CMD_STOP_FW:
-		ql_link_off(qdev);
+		qlge_link_off(qdev);
 		fallthrough;
 	case MB_CMD_SET_PORT_CFG:
 		/* Signal the resulting link up AEN
@@ -1180,7 +1180,7 @@ void ql_mpi_idc_work(struct work_struct *work)
 		set_bit(QL_CAM_RT_SET, &qdev->flags);
 		/* Do ACK if required */
 		if (timeout) {
-			status = ql_mb_idc_ack(qdev);
+			status = qlge_mb_idc_ack(qdev);
 			if (status)
 				netif_err(qdev, drv, qdev->ndev,
 					  "Bug: No pending IDC!\n");
@@ -1191,18 +1191,18 @@ void ql_mpi_idc_work(struct work_struct *work)
 		}
 		break;
 
-	/* These sub-commands issued by another (FCoE)
-	 * function are requesting to do an operation
-	 * on the shared resource (MPI environment).
-	 * We currently don't issue these so we just
-	 * ACK the request.
-	 */
+		/* These sub-commands issued by another (FCoE)
+		 * function are requesting to do an operation
+		 * on the shared resource (MPI environment).
+		 * We currently don't issue these so we just
+		 * ACK the request.
+		 */
 	case MB_CMD_IOP_RESTART_MPI:
 	case MB_CMD_IOP_PREP_LINK_DOWN:
 		/* Drop the link, reload the routing
 		 * table when link comes up.
 		 */
-		ql_link_off(qdev);
+		qlge_link_off(qdev);
 		set_bit(QL_CAM_RT_SET, &qdev->flags);
 		fallthrough;
 	case MB_CMD_IOP_DVR_START:
@@ -1213,7 +1213,7 @@ void ql_mpi_idc_work(struct work_struct *work)
 	case MB_CMD_IOP_NONE:	/*  an IDC without params */
 		/* Do ACK if required */
 		if (timeout) {
-			status = ql_mb_idc_ack(qdev);
+			status = qlge_mb_idc_ack(qdev);
 			if (status)
 				netif_err(qdev, drv, qdev->ndev,
 					  "Bug: No pending IDC!\n");
@@ -1226,54 +1226,54 @@ void ql_mpi_idc_work(struct work_struct *work)
 	}
 }
 
-void ql_mpi_work(struct work_struct *work)
+void qlge_mpi_work(struct work_struct *work)
 {
-	struct ql_adapter *qdev =
-	    container_of(work, struct ql_adapter, mpi_work.work);
+	struct qlge_adapter *qdev =
+		container_of(work, struct qlge_adapter, mpi_work.work);
 	struct mbox_params mbc;
 	struct mbox_params *mbcp = &mbc;
 	int err = 0;
 
 	mutex_lock(&qdev->mpi_mutex);
 	/* Begin polled mode for MPI */
-	ql_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16));
+	qlge_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16));
 
-	while (ql_read32(qdev, STS) & STS_PI) {
+	while (qlge_read32(qdev, STS) & STS_PI) {
 		memset(mbcp, 0, sizeof(struct mbox_params));
 		mbcp->out_count = 1;
 		/* Don't continue if an async event
 		 * did not complete properly.
 		 */
-		err = ql_mpi_handler(qdev, mbcp);
+		err = qlge_mpi_handler(qdev, mbcp);
 		if (err)
 			break;
 	}
 
 	/* End polled mode for MPI */
-	ql_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16) | INTR_MASK_PI);
+	qlge_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16) | INTR_MASK_PI);
 	mutex_unlock(&qdev->mpi_mutex);
 }
 
-void ql_mpi_reset_work(struct work_struct *work)
+void qlge_mpi_reset_work(struct work_struct *work)
 {
-	struct ql_adapter *qdev =
-	    container_of(work, struct ql_adapter, mpi_reset_work.work);
+	struct qlge_adapter *qdev =
+		container_of(work, struct qlge_adapter, mpi_reset_work.work);
 	cancel_delayed_work_sync(&qdev->mpi_work);
 	cancel_delayed_work_sync(&qdev->mpi_port_cfg_work);
 	cancel_delayed_work_sync(&qdev->mpi_idc_work);
 	/* If we're not the dominant NIC function,
 	 * then there is nothing to do.
 	 */
-	if (!ql_own_firmware(qdev)) {
+	if (!qlge_own_firmware(qdev)) {
 		netif_err(qdev, drv, qdev->ndev, "Don't own firmware!\n");
 		return;
 	}
 
-	if (qdev->mpi_coredump && !ql_core_dump(qdev, qdev->mpi_coredump)) {
+	if (qdev->mpi_coredump && !qlge_core_dump(qdev, qdev->mpi_coredump)) {
 		netif_err(qdev, drv, qdev->ndev, "Core is dumped!\n");
 		qdev->core_is_dumped = 1;
 		queue_delayed_work(qdev->workqueue,
 				   &qdev->mpi_core_to_log, 5 * HZ);
 	}
-	ql_soft_reset_mpi_risc(qdev);
+	qlge_soft_reset_mpi_risc(qdev);
 }
-- 
2.29.2

