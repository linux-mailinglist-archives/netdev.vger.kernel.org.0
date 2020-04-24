Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E9E1B6F05
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgDXH2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:28:16 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53932 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726743AbgDXH2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 03:28:15 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O7PjVd021054;
        Fri, 24 Apr 2020 00:28:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=RoURctvjuIeRcmUYqI+EDNrKfajdAqw01HCe6NMHYRc=;
 b=GqCAO+yyEaGZBsgXODsmEQe3VziHnt1+v79k2OcBO3fpVOWVhvk+osP7TohkIsR7iG4m
 3H43OIvaZvmeyYSIUTGVl5g0TBKvIXXJ0NVFCpR93KyXupixKq0Hjwl3EszyjiXG5ZJV
 CGBoI9DTrnKd+pbM7UgmzkJ2O+LR3y1XMZbbkbE3UAJSwf19MfuC+nbWtHxuHs2oYgfd
 rC5wY1W5YBy/2SN0ZKyRiAmYTEyX4fnvuCkXAG6p731dryXBEm/4EjkRmlvmRYPSzG8/
 rxiZnbWCB7+sin3iE504LkHWUe3AJ7meBd4ROe+3xCQi5Qsk+ds5MwkcM+uyLAkPu57s Zg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 30kfdsb48h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 00:28:11 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Apr
 2020 00:28:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Apr 2020 00:28:09 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 44D503F7040;
        Fri, 24 Apr 2020 00:28:06 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "Dmitry Bogdanov" <dbogdanov@marvell.com>
Subject: [PATCH net-next 12/17] net: atlantic: HW bindings for A2 RFP
Date:   Fri, 24 Apr 2020 10:27:24 +0300
Message-ID: <20200424072729.953-13-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200424072729.953-1-irusskikh@marvell.com>
References: <20200424072729.953-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_02:2020-04-23,2020-04-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RPF is one of the modules which has been significantly
changed/extended on A2.

This patch adds the necessary A2 register definitions
for RPF, which are used in follow-up patches.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Co-developed-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
---
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     |  14 ++
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     |   6 +
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.c   |  74 ++++++++
 .../aquantia/atlantic/hw_atl2/hw_atl2_llh.h   |  26 +++
 .../atlantic/hw_atl2/hw_atl2_llh_internal.h   | 164 ++++++++++++++++++
 5 files changed, 284 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
index d1f68fc16291..8dd3232d72c4 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
@@ -693,6 +693,13 @@ void hw_atl_rpfl2multicast_flr_en_set(struct aq_hw_s *aq_hw,
 			    HW_ATL_RPFL2MC_ENF_SHIFT, l2multicast_flr_en);
 }
 
+u32 hw_atl_rpfl2promiscuous_mode_en_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg_bit(aq_hw, HW_ATL_RPFL2PROMIS_MODE_ADR,
+				  HW_ATL_RPFL2PROMIS_MODE_MSK,
+				  HW_ATL_RPFL2PROMIS_MODE_SHIFT);
+}
+
 void hw_atl_rpfl2promiscuous_mode_en_set(struct aq_hw_s *aq_hw,
 					 u32 l2promiscuous_mode_en)
 {
@@ -867,6 +874,13 @@ void hw_atl_rpf_vlan_prom_mode_en_set(struct aq_hw_s *aq_hw,
 			    vlan_prom_mode_en);
 }
 
+u32 hw_atl_rpf_vlan_prom_mode_en_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg_bit(aq_hw, HW_ATL_RPF_VL_PROMIS_MODE_ADR,
+				  HW_ATL_RPF_VL_PROMIS_MODE_MSK,
+				  HW_ATL_RPF_VL_PROMIS_MODE_SHIFT);
+}
+
 void hw_atl_rpf_vlan_accept_untagged_packets_set(struct aq_hw_s *aq_hw,
 						 u32 vlan_acc_untagged_packets)
 {
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
index 62992b23c0e8..a4699a682973 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
@@ -349,6 +349,9 @@ void hw_atl_rpfl2multicast_flr_en_set(struct aq_hw_s *aq_hw,
 				      u32 l2multicast_flr_en,
 				      u32 filter);
 
+/* get l2 promiscuous mode enable */
+u32 hw_atl_rpfl2promiscuous_mode_en_get(struct aq_hw_s *aq_hw);
+
 /* set l2 promiscuous mode enable */
 void hw_atl_rpfl2promiscuous_mode_en_set(struct aq_hw_s *aq_hw,
 					 u32 l2promiscuous_mode_en);
@@ -420,6 +423,9 @@ void hw_atl_rpf_vlan_outer_etht_set(struct aq_hw_s *aq_hw, u32 vlan_outer_etht);
 void hw_atl_rpf_vlan_prom_mode_en_set(struct aq_hw_s *aq_hw,
 				      u32 vlan_prom_mode_en);
 
+/* Get VLAN promiscuous mode enable */
+u32 hw_atl_rpf_vlan_prom_mode_en_get(struct aq_hw_s *aq_hw);
+
 /* Set VLAN untagged action */
 void hw_atl_rpf_vlan_untagged_act_set(struct aq_hw_s *aq_hw,
 				      u32 vlan_untagged_act);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
index b6164bc5fffd..67f46a7bdcda 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.c
@@ -7,6 +7,80 @@
 #include "hw_atl2_llh_internal.h"
 #include "aq_hw_utils.h"
 
+void hw_atl2_rpf_rss_hash_type_set(struct aq_hw_s *aq_hw, u32 rss_hash_type)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL2_RPF_PIF_RPF_RSS_HASH_TYPEI_ADR,
+			    HW_ATL2_RPF_PIF_RPF_RSS_HASH_TYPEI_MSK,
+			    HW_ATL2_RPF_PIF_RPF_RSS_HASH_TYPEI_SHIFT,
+			    rss_hash_type);
+}
+
+/* rpf */
+
+void hw_atl2_rpf_new_enable_set(struct aq_hw_s *aq_hw, u32 enable)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL2_RPF_NEW_EN_ADR,
+			    HW_ATL2_RPF_NEW_EN_MSK,
+			    HW_ATL2_RPF_NEW_EN_SHIFT,
+			    enable);
+}
+
+void hw_atl2_rpfl2_uc_flr_tag_set(struct aq_hw_s *aq_hw, u32 tag, u32 filter)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL2_RPFL2UC_TAG_ADR(filter),
+			    HW_ATL2_RPFL2UC_TAG_MSK,
+			    HW_ATL2_RPFL2UC_TAG_SHIFT,
+			    tag);
+}
+
+void hw_atl2_rpfl2_bc_flr_tag_set(struct aq_hw_s *aq_hw, u32 tag)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL2_RPF_L2_BC_TAG_ADR,
+			    HW_ATL2_RPF_L2_BC_TAG_MSK,
+			    HW_ATL2_RPF_L2_BC_TAG_SHIFT,
+			    tag);
+}
+
+void hw_atl2_new_rpf_rss_redir_set(struct aq_hw_s *aq_hw, u32 tc, u32 index,
+				   u32 queue)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL2_RPF_RSS_REDIR_ADR(tc, index),
+			    HW_ATL2_RPF_RSS_REDIR_MSK(tc),
+			    HW_ATL2_RPF_RSS_REDIR_SHIFT(tc),
+			    queue);
+}
+
+void hw_atl2_rpf_vlan_flr_tag_set(struct aq_hw_s *aq_hw, u32 tag, u32 filter)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL2_RPF_VL_TAG_ADR(filter),
+			    HW_ATL2_RPF_VL_TAG_MSK,
+			    HW_ATL2_RPF_VL_TAG_SHIFT,
+			    tag);
+}
+
+/* set action resolver record */
+void hw_atl2_rpf_act_rslvr_record_set(struct aq_hw_s *aq_hw, u8 location,
+				      u32 tag, u32 mask, u32 action)
+{
+	aq_hw_write_reg(aq_hw,
+			HW_ATL2_RPF_ACT_RSLVR_REQ_TAG_ADR(location),
+			tag);
+	aq_hw_write_reg(aq_hw,
+			HW_ATL2_RPF_ACT_RSLVR_TAG_MASK_ADR(location),
+			mask);
+	aq_hw_write_reg(aq_hw,
+			HW_ATL2_RPF_ACT_RSLVR_ACTN_ADR(location),
+			action);
+}
+
+void hw_atl2_rpf_act_rslvr_section_en_set(struct aq_hw_s *aq_hw, u32 sections)
+{
+	aq_hw_write_reg_bit(aq_hw, HW_ATL2_RPF_REC_TAB_EN_ADR,
+			    HW_ATL2_RPF_REC_TAB_EN_MSK,
+			    HW_ATL2_RPF_REC_TAB_EN_SHIFT,
+			    sections);
+}
+
 void hw_atl2_mif_shared_buf_get(struct aq_hw_s *aq_hw, int offset, u32 *data,
 				int len)
 {
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
index 8ef8bd6b2534..bd5b0d5a8084 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh.h
@@ -10,6 +10,32 @@
 
 struct aq_hw_s;
 
+/** Set RSS HASH type */
+void hw_atl2_rpf_rss_hash_type_set(struct aq_hw_s *aq_hw, u32 rss_hash_type);
+
+/* set new RPF enable */
+void hw_atl2_rpf_new_enable_set(struct aq_hw_s *aq_hw, u32 enable);
+
+/* set l2 unicast filter tag */
+void hw_atl2_rpfl2_uc_flr_tag_set(struct aq_hw_s *aq_hw, u32 tag, u32 filter);
+
+/* set l2 broadcast filter tag */
+void hw_atl2_rpfl2_bc_flr_tag_set(struct aq_hw_s *aq_hw, u32 tag);
+
+/* set new rss redirection table */
+void hw_atl2_new_rpf_rss_redir_set(struct aq_hw_s *aq_hw, u32 tc, u32 index,
+				   u32 queue);
+
+/* Set VLAN filter tag */
+void hw_atl2_rpf_vlan_flr_tag_set(struct aq_hw_s *aq_hw, u32 tag, u32 filter);
+
+/* set action resolver record */
+void hw_atl2_rpf_act_rslvr_record_set(struct aq_hw_s *aq_hw, u8 location,
+				      u32 tag, u32 mask, u32 action);
+
+/* set enable action resolver section */
+void hw_atl2_rpf_act_rslvr_section_en_set(struct aq_hw_s *aq_hw, u32 sections);
+
 /* get data from firmware shared input buffer */
 void hw_atl2_mif_shared_buf_get(struct aq_hw_s *aq_hw, int offset, u32 *data,
 				int len);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
index 835deb2d1950..886491b6ab73 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_llh_internal.h
@@ -6,6 +6,170 @@
 #ifndef HW_ATL2_LLH_INTERNAL_H
 #define HW_ATL2_LLH_INTERNAL_H
 
+/* RX pif_rpf_rss_hash_type_i Bitfield Definitions
+ */
+#define HW_ATL2_RPF_PIF_RPF_RSS_HASH_TYPEI_ADR 0x000054C8
+#define HW_ATL2_RPF_PIF_RPF_RSS_HASH_TYPEI_MSK 0x000001FF
+#define HW_ATL2_RPF_PIF_RPF_RSS_HASH_TYPEI_MSKN 0xFFFFFE00
+#define HW_ATL2_RPF_PIF_RPF_RSS_HASH_TYPEI_SHIFT 0
+#define HW_ATL2_RPF_PIF_RPF_RSS_HASH_TYPEI_WIDTH 9
+
+/* rx rpf_new_rpf_en bitfield definitions
+ * preprocessor definitions for the bitfield "rpf_new_rpf_en_i".
+ * port="pif_rpf_new_rpf_en_i
+ */
+
+/* register address for bitfield rpf_new_rpf_en */
+#define HW_ATL2_RPF_NEW_EN_ADR 0x00005104
+/* bitmask for bitfield rpf_new_rpf_en */
+#define HW_ATL2_RPF_NEW_EN_MSK 0x00000800
+/* inverted bitmask for bitfield rpf_new_rpf_en */
+#define HW_ATL2_RPF_NEW_EN_MSKN 0xfffff7ff
+/* lower bit position of bitfield rpf_new_rpf_en */
+#define HW_ATL2_RPF_NEW_EN_SHIFT 11
+/* width of bitfield rpf_new_rpf_en */
+#define HW_ATL2_RPF_NEW_EN_WIDTH 1
+/* default value of bitfield rpf_new_rpf_en */
+#define HW_ATL2_RPF_NEW_EN_DEFAULT 0x0
+
+/* rx l2_uc_req_tag0{f}[5:0] bitfield definitions
+ * preprocessor definitions for the bitfield "l2_uc_req_tag0{f}[7:0]".
+ * parameter: filter {f} | stride size 0x8 | range [0, 37]
+ * port="pif_rpf_l2_uc_req_tag0[5:0]"
+ */
+
+/* register address for bitfield l2_uc_req_tag0{f}[2:0] */
+#define HW_ATL2_RPFL2UC_TAG_ADR(filter) (0x00005114 + (filter) * 0x8)
+/* bitmask for bitfield l2_uc_req_tag0{f}[2:0] */
+#define HW_ATL2_RPFL2UC_TAG_MSK 0x0FC00000
+/* inverted bitmask for bitfield l2_uc_req_tag0{f}[2:0] */
+#define HW_ATL2_RPFL2UC_TAG_MSKN 0xF03FFFFF
+/* lower bit position of bitfield l2_uc_req_tag0{f}[2:0] */
+#define HW_ATL2_RPFL2UC_TAG_SHIFT 22
+/* width of bitfield l2_uc_req_tag0{f}[2:0] */
+#define HW_ATL2_RPFL2UC_TAG_WIDTH 6
+/* default value of bitfield l2_uc_req_tag0{f}[2:0] */
+#define HW_ATL2_RPFL2UC_TAG_DEFAULT 0x0
+
+/* rpf_l2_bc_req_tag[5:0] bitfield definitions
+ * preprocessor definitions for the bitfield "rpf_l2_bc_req_tag[5:0]".
+ * port="pifrpf_l2_bc_req_tag_i[5:0]"
+ */
+
+/* register address for bitfield rpf_l2_bc_req_tag */
+#define HW_ATL2_RPF_L2_BC_TAG_ADR 0x000050F0
+/* bitmask for bitfield rpf_l2_bc_req_tag */
+#define HW_ATL2_RPF_L2_BC_TAG_MSK 0x0000003F
+/* inverted bitmask for bitfield rpf_l2_bc_req_tag */
+#define HW_ATL2_RPF_L2_BC_TAG_MSKN 0xffffffc0
+/* lower bit position of bitfield rpf_l2_bc_req_tag */
+#define HW_ATL2_RPF_L2_BC_TAG_SHIFT 0
+/* width of bitfield rpf_l2_bc_req_tag */
+#define HW_ATL2_RPF_L2_BC_TAG_WIDTH 6
+/* default value of bitfield rpf_l2_bc_req_tag */
+#define HW_ATL2_RPF_L2_BC_TAG_DEFAULT 0x0
+
+/* rx rpf_rss_red1_data_[4:0] bitfield definitions
+ * preprocessor definitions for the bitfield "rpf_rss_red1_data[4:0]".
+ * port="pif_rpf_rss_red1_data_i[4:0]"
+ */
+
+/* register address for bitfield rpf_rss_red1_data[4:0] */
+#define HW_ATL2_RPF_RSS_REDIR_ADR(TC, INDEX) (0x00006200 + \
+					(0x100 * !!((TC) > 3)) + (INDEX) * 4)
+/* bitmask for bitfield rpf_rss_red1_data[4:0] */
+#define HW_ATL2_RPF_RSS_REDIR_MSK(TC)  (0x00000001F << (5 * ((TC) % 4)))
+/* lower bit position of bitfield rpf_rss_red1_data[4:0] */
+#define HW_ATL2_RPF_RSS_REDIR_SHIFT(TC) (5 * ((TC) % 4))
+/* width of bitfield rpf_rss_red1_data[4:0] */
+#define HW_ATL2_RPF_RSS_REDIR_WIDTH 5
+/* default value of bitfield rpf_rss_red1_data[4:0] */
+#define HW_ATL2_RPF_RSS_REDIR_DEFAULT 0x0
+
+/* rx vlan_req_tag0{f}[3:0] bitfield definitions
+ * preprocessor definitions for the bitfield "vlan_req_tag0{f}[3:0]".
+ * parameter: filter {f} | stride size 0x4 | range [0, 15]
+ * port="pif_rpf_vlan_req_tag0[3:0]"
+ */
+
+/* register address for bitfield vlan_req_tag0{f}[3:0] */
+#define HW_ATL2_RPF_VL_TAG_ADR(filter) (0x00005290 + (filter) * 0x4)
+/* bitmask for bitfield vlan_req_tag0{f}[3:0] */
+#define HW_ATL2_RPF_VL_TAG_MSK 0x0000F000
+/* inverted bitmask for bitfield vlan_req_tag0{f}[3:0] */
+#define HW_ATL2_RPF_VL_TAG_MSKN 0xFFFF0FFF
+/* lower bit position of bitfield vlan_req_tag0{f}[3:0] */
+#define HW_ATL2_RPF_VL_TAG_SHIFT 12
+/* width of bitfield vlan_req_tag0{f}[3:0] */
+#define HW_ATL2_RPF_VL_TAG_WIDTH 4
+/* default value of bitfield vlan_req_tag0{f}[3:0] */
+#define HW_ATL2_RPF_VL_TAG_DEFAULT 0x0
+
+/* ahb_mem_addr{f}[31:0] Bitfield Definitions
+ * Preprocessor definitions for the bitfield "ahb_mem_addr{f}[31:0]".
+ * Parameter: filter {f} | stride size 0x10 | range [0, 127]
+ * PORT="ahb_mem_addr{f}[31:0]"
+ */
+
+/* Register address for bitfield ahb_mem_addr{f}[31:0] */
+#define HW_ATL2_RPF_ACT_RSLVR_REQ_TAG_ADR(filter) \
+	(0x00014000u + (filter) * 0x10)
+/* Bitmask for bitfield ahb_mem_addr{f}[31:0] */
+#define HW_ATL2_RPF_ACT_RSLVR_REQ_TAG_MSK 0xFFFFFFFFu
+/* Inverted bitmask for bitfield ahb_mem_addr{f}[31:0] */
+#define HW_ATL2_RPF_ACT_RSLVR_REQ_TAG_MSKN 0x00000000u
+/* Lower bit position of bitfield ahb_mem_addr{f}[31:0] */
+#define HW_ATL2_RPF_ACT_RSLVR_REQ_TAG_SHIFT 0
+/* Width of bitfield ahb_mem_addr{f}[31:0] */
+#define HW_ATL2_RPF_ACT_RSLVR_REQ_TAG_WIDTH 31
+/* Default value of bitfield ahb_mem_addr{f}[31:0] */
+#define HW_ATL2_RPF_ACT_RSLVR_REQ_TAG_DEFAULT 0x0
+
+/* Register address for bitfield ahb_mem_addr{f}[31:0] */
+#define HW_ATL2_RPF_ACT_RSLVR_TAG_MASK_ADR(filter) \
+	(0x00014004u + (filter) * 0x10)
+/* Bitmask for bitfield ahb_mem_addr{f}[31:0] */
+#define HW_ATL2_RPF_ACT_RSLVR_TAG_MASK_MSK 0xFFFFFFFFu
+/* Inverted bitmask for bitfield ahb_mem_addr{f}[31:0] */
+#define HW_ATL2_RPF_ACT_RSLVR_TAG_MASK_MSKN 0x00000000u
+/* Lower bit position of bitfield ahb_mem_addr{f}[31:0] */
+#define HW_ATL2_RPF_ACT_RSLVR_TAG_MASK_SHIFT 0
+/* Width of bitfield ahb_mem_addr{f}[31:0] */
+#define HW_ATL2_RPF_ACT_RSLVR_TAG_MASK_WIDTH 31
+/* Default value of bitfield ahb_mem_addr{f}[31:0] */
+#define HW_ATL2_RPF_ACT_RSLVR_TAG_MASK_DEFAULT 0x0
+
+/* Register address for bitfield ahb_mem_addr{f}[31:0] */
+#define HW_ATL2_RPF_ACT_RSLVR_ACTN_ADR(filter) \
+	(0x00014008u + (filter) * 0x10)
+/* Bitmask for bitfield ahb_mem_addr{f}[31:0] */
+#define HW_ATL2_RPF_ACT_RSLVR_ACTN_MSK 0x000007FFu
+/* Inverted bitmask for bitfield ahb_mem_addr{f}[31:0] */
+#define HW_ATL2_RPF_ACT_RSLVR_ACTN_MSKN 0xFFFFF800u
+/* Lower bit position of bitfield ahb_mem_addr{f}[31:0] */
+#define HW_ATL2_RPF_ACT_RSLVR_ACTN_SHIFT 0
+/* Width of bitfield ahb_mem_addr{f}[31:0] */
+#define HW_ATL2_RPF_ACT_RSLVR_ACTN_WIDTH 10
+/* Default value of bitfield ahb_mem_addr{f}[31:0] */
+#define HW_ATL2_RPF_ACT_RSLVR_ACTN_DEFAULT 0x0
+
+/* rpf_rec_tab_en[15:0] Bitfield Definitions
+ * Preprocessor definitions for the bitfield "rpf_rec_tab_en[15:0]".
+ * PORT="pif_rpf_rec_tab_en[15:0]"
+ */
+/* Register address for bitfield rpf_rec_tab_en[15:0] */
+#define HW_ATL2_RPF_REC_TAB_EN_ADR 0x00006ff0u
+/* Bitmask for bitfield rpf_rec_tab_en[15:0] */
+#define HW_ATL2_RPF_REC_TAB_EN_MSK 0x0000FFFFu
+/* Inverted bitmask for bitfield rpf_rec_tab_en[15:0] */
+#define HW_ATL2_RPF_REC_TAB_EN_MSKN 0xFFFF0000u
+/* Lower bit position of bitfield rpf_rec_tab_en[15:0] */
+#define HW_ATL2_RPF_REC_TAB_EN_SHIFT 0
+/* Width of bitfield rpf_rec_tab_en[15:0] */
+#define HW_ATL2_RPF_REC_TAB_EN_WIDTH 16
+/* Default value of bitfield rpf_rec_tab_en[15:0] */
+#define HW_ATL2_RPF_REC_TAB_EN_DEFAULT 0x0
+
 /* Register address for firmware shared input buffer */
 #define HW_ATL2_MIF_SHARED_BUFFER_IN_ADR(dword) (0x00012000U + (dword) * 0x4U)
 /* Register address for firmware shared output buffer */
-- 
2.17.1

