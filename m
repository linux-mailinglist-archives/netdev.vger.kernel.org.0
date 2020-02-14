Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9AF15DA37
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbgBNPDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:03:54 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10424 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729583AbgBNPDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:03:51 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EF074I019190;
        Fri, 14 Feb 2020 07:03:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=GcRIDJVaCSmGf97fZrLUsHhMly6JkJ2cHKS9T7bIulg=;
 b=QtgqMHY0fzjxdvQCf13EPIhiihoq3qPDbzSkDgDdDyAxR8Nn9wA4oOM9IQVsQvc9wg8I
 ClTlecfQE8/xN8dccqnaZ6Pri8jwS72gTZFBYf09y2uRnsewF7JfWY5dm0+P0FwTtgHY
 U3flM4ISacuyZuVlrj7HvhiUsQDKwlG2Jz6xZc0NRkdSsqZ7q+q7nYXPRe0WYSXlFfC7
 Mxy0OcxnX6QEAPGESDAyoQGcGprToomeQ3vsV+Bpw0yk5P396rdwUyO//EaKh2Su634k
 3JzGDssV1IwmQLF180EDbDx5oGFd/2I1MszbeqykypE980o/9uB2i/a4xO3j0H8VzaxM Ug== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y4be2n5pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:03:47 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:46 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:45 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:03:45 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id 865F03F703F;
        Fri, 14 Feb 2020 07:03:43 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [RFC 17/18] net: atlantic: MACSec offload statistics HW bindings
Date:   Fri, 14 Feb 2020 18:02:57 +0300
Message-ID: <20200214150258.390-18-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200214150258.390-1-irusskikh@marvell.com>
References: <20200214150258.390-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

This patch adds the Atlantic HW-specific bindings for MACSec statistics,
e.g. register addresses / structs, helper function, etc, which will be
used by actual callback implementations.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../aquantia/atlantic/macsec/macsec_api.c     | 545 ++++++++++++++++++
 .../aquantia/atlantic/macsec/macsec_api.h     |  47 ++
 .../aquantia/atlantic/macsec/macsec_struct.h  | 214 +++++++
 3 files changed, 806 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
index 77364fd77f3b..8f7cfdd26205 100644
--- a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
+++ b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
@@ -2282,6 +2282,551 @@ int aq_mss_get_egress_sakey_record(struct aq_hw_s *hw,
 	return AQ_API_CALL_SAFE(get_egress_sakey_record, hw, rec, table_index);
 }
 
+static int get_egress_sc_counters(struct aq_hw_s *hw,
+				  struct aq_mss_egress_sc_counters *counters,
+				  u16 sc_index)
+{
+	u16 packed_record[4];
+	int ret;
+
+	if (sc_index >= NUMROWS_EGRESSSCRECORD)
+		return -EINVAL;
+
+	ret = get_raw_egress_record(hw, packed_record, 4, 3, sc_index * 8 + 4);
+	if (unlikely(ret))
+		return ret;
+	counters->sc_protected_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->sc_protected_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_egress_record(hw, packed_record, 4, 3, sc_index * 8 + 5);
+	if (unlikely(ret))
+		return ret;
+	counters->sc_encrypted_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->sc_encrypted_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_egress_record(hw, packed_record, 4, 3, sc_index * 8 + 6);
+	if (unlikely(ret))
+		return ret;
+	counters->sc_protected_octets[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->sc_protected_octets[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_egress_record(hw, packed_record, 4, 3, sc_index * 8 + 7);
+	if (unlikely(ret))
+		return ret;
+	counters->sc_encrypted_octets[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->sc_encrypted_octets[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	return 0;
+}
+
+int aq_mss_get_egress_sc_counters(struct aq_hw_s *hw,
+				  struct aq_mss_egress_sc_counters *counters,
+				  u16 sc_index)
+{
+	memset(counters, 0, sizeof(*counters));
+
+	return AQ_API_CALL_SAFE(get_egress_sc_counters, hw, counters, sc_index);
+}
+
+static int get_egress_sa_counters(struct aq_hw_s *hw,
+				  struct aq_mss_egress_sa_counters *counters,
+				  u16 sa_index)
+{
+	u16 packed_record[4];
+	int ret;
+
+	if (sa_index >= NUMROWS_EGRESSSARECORD)
+		return -EINVAL;
+
+	ret = get_raw_egress_record(hw, packed_record, 4, 3, sa_index * 8 + 0);
+	if (unlikely(ret))
+		return ret;
+	counters->sa_hit_drop_redirect[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->sa_hit_drop_redirect[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_egress_record(hw, packed_record, 4, 3, sa_index * 8 + 1);
+	if (unlikely(ret))
+		return ret;
+	counters->sa_protected2_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->sa_protected2_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_egress_record(hw, packed_record, 4, 3, sa_index * 8 + 2);
+	if (unlikely(ret))
+		return ret;
+	counters->sa_protected_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->sa_protected_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_egress_record(hw, packed_record, 4, 3, sa_index * 8 + 3);
+	if (unlikely(ret))
+		return ret;
+	counters->sa_encrypted_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->sa_encrypted_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	return 0;
+}
+
+int aq_mss_get_egress_sa_counters(struct aq_hw_s *hw,
+				  struct aq_mss_egress_sa_counters *counters,
+				  u16 sa_index)
+{
+	memset(counters, 0, sizeof(*counters));
+
+	return AQ_API_CALL_SAFE(get_egress_sa_counters, hw, counters, sa_index);
+}
+
+static int
+get_egress_common_counters(struct aq_hw_s *hw,
+			   struct aq_mss_egress_common_counters *counters)
+{
+	u16 packed_record[4];
+	int ret;
+
+	ret = get_raw_egress_record(hw, packed_record, 4, 3, 256 + 0);
+	if (unlikely(ret))
+		return ret;
+	counters->ctl_pkt[0] = packed_record[0] | (packed_record[1] << 16);
+	counters->ctl_pkt[1] = packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_egress_record(hw, packed_record, 4, 3, 256 + 1);
+	if (unlikely(ret))
+		return ret;
+	counters->unknown_sa_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->unknown_sa_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_egress_record(hw, packed_record, 4, 3, 256 + 2);
+	if (unlikely(ret))
+		return ret;
+	counters->untagged_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->untagged_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_egress_record(hw, packed_record, 4, 3, 256 + 3);
+	if (unlikely(ret))
+		return ret;
+	counters->too_long[0] = packed_record[0] | (packed_record[1] << 16);
+	counters->too_long[1] = packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_egress_record(hw, packed_record, 4, 3, 256 + 4);
+	if (unlikely(ret))
+		return ret;
+	counters->ecc_error_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->ecc_error_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_egress_record(hw, packed_record, 4, 3, 256 + 5);
+	if (unlikely(ret))
+		return ret;
+	counters->unctrl_hit_drop_redir[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->unctrl_hit_drop_redir[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	return 0;
+}
+
+int aq_mss_get_egress_common_counters(struct aq_hw_s *hw,
+	struct aq_mss_egress_common_counters *counters)
+{
+	memset(counters, 0, sizeof(*counters));
+
+	return AQ_API_CALL_SAFE(get_egress_common_counters, hw, counters);
+}
+
+static int clear_egress_counters(struct aq_hw_s *hw)
+{
+	struct mss_egress_ctl_register ctl_reg;
+	int ret;
+
+	memset(&ctl_reg, 0, sizeof(ctl_reg));
+
+	ret = aq_mss_mdio_read(hw, MDIO_MMD_VEND1, MSS_EGRESS_CTL_REGISTER_ADDR,
+			       &ctl_reg.word_0);
+	if (unlikely(ret))
+		return ret;
+	ret = aq_mss_mdio_read(hw, MDIO_MMD_VEND1,
+			       MSS_EGRESS_CTL_REGISTER_ADDR + 4,
+			       &ctl_reg.word_1);
+	if (unlikely(ret))
+		return ret;
+
+	/* Toggle the Egress MIB clear bit 0->1->0 */
+	ctl_reg.bits_0.clear_counter = 0;
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				MSS_EGRESS_CTL_REGISTER_ADDR, ctl_reg.word_0);
+	if (unlikely(ret))
+		return ret;
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				MSS_EGRESS_CTL_REGISTER_ADDR + 4,
+				ctl_reg.word_1);
+	if (unlikely(ret))
+		return ret;
+
+	ctl_reg.bits_0.clear_counter = 1;
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				MSS_EGRESS_CTL_REGISTER_ADDR, ctl_reg.word_0);
+	if (unlikely(ret))
+		return ret;
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				MSS_EGRESS_CTL_REGISTER_ADDR + 4,
+				ctl_reg.word_1);
+	if (unlikely(ret))
+		return ret;
+
+	ctl_reg.bits_0.clear_counter = 0;
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				MSS_EGRESS_CTL_REGISTER_ADDR, ctl_reg.word_0);
+	if (unlikely(ret))
+		return ret;
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				MSS_EGRESS_CTL_REGISTER_ADDR + 4,
+				ctl_reg.word_1);
+	if (unlikely(ret))
+		return ret;
+
+	return 0;
+}
+
+int aq_mss_clear_egress_counters(struct aq_hw_s *hw)
+{
+	return AQ_API_CALL_SAFE(clear_egress_counters, hw);
+}
+
+static int get_ingress_sa_counters(struct aq_hw_s *hw,
+				   struct aq_mss_ingress_sa_counters *counters,
+				   u16 sa_index)
+{
+	u16 packed_record[4];
+	int ret;
+
+	if (sa_index >= NUMROWS_INGRESSSARECORD)
+		return -EINVAL;
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6,
+				     sa_index * 12 + 0);
+	if (unlikely(ret))
+		return ret;
+	counters->untagged_hit_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->untagged_hit_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6,
+				     sa_index * 12 + 1);
+	if (unlikely(ret))
+		return ret;
+	counters->ctrl_hit_drop_redir_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->ctrl_hit_drop_redir_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6,
+				     sa_index * 12 + 2);
+	if (unlikely(ret))
+		return ret;
+	counters->not_using_sa[0] = packed_record[0] | (packed_record[1] << 16);
+	counters->not_using_sa[1] = packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6,
+				     sa_index * 12 + 3);
+	if (unlikely(ret))
+		return ret;
+	counters->unused_sa[0] = packed_record[0] | (packed_record[1] << 16);
+	counters->unused_sa[1] = packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6,
+				     sa_index * 12 + 4);
+	if (unlikely(ret))
+		return ret;
+	counters->not_valid_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->not_valid_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6,
+				     sa_index * 12 + 5);
+	if (unlikely(ret))
+		return ret;
+	counters->invalid_pkts[0] = packed_record[0] | (packed_record[1] << 16);
+	counters->invalid_pkts[1] = packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6,
+				     sa_index * 12 + 6);
+	if (unlikely(ret))
+		return ret;
+	counters->ok_pkts[0] = packed_record[0] | (packed_record[1] << 16);
+	counters->ok_pkts[1] = packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6,
+				     sa_index * 12 + 7);
+	if (unlikely(ret))
+		return ret;
+	counters->late_pkts[0] = packed_record[0] | (packed_record[1] << 16);
+	counters->late_pkts[1] = packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6,
+				     sa_index * 12 + 8);
+	if (unlikely(ret))
+		return ret;
+	counters->delayed_pkts[0] = packed_record[0] | (packed_record[1] << 16);
+	counters->delayed_pkts[1] = packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6,
+				     sa_index * 12 + 9);
+	if (unlikely(ret))
+		return ret;
+	counters->unchecked_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->unchecked_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6,
+				     sa_index * 12 + 10);
+	if (unlikely(ret))
+		return ret;
+	counters->validated_octets[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->validated_octets[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6,
+				     sa_index * 12 + 11);
+	if (unlikely(ret))
+		return ret;
+	counters->decrypted_octets[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->decrypted_octets[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	return 0;
+}
+
+int aq_mss_get_ingress_sa_counters(struct aq_hw_s *hw,
+				   struct aq_mss_ingress_sa_counters *counters,
+				   u16 sa_index)
+{
+	memset(counters, 0, sizeof(*counters));
+
+	return AQ_API_CALL_SAFE(get_ingress_sa_counters, hw, counters,
+				sa_index);
+}
+
+static int
+get_ingress_common_counters(struct aq_hw_s *hw,
+			    struct aq_mss_ingress_common_counters *counters)
+{
+	u16 packed_record[4];
+	int ret;
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6, 385 + 0);
+	if (unlikely(ret))
+		return ret;
+	counters->ctl_pkts[0] = packed_record[0] | (packed_record[1] << 16);
+	counters->ctl_pkts[1] = packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6, 385 + 1);
+	if (unlikely(ret))
+		return ret;
+	counters->tagged_miss_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->tagged_miss_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6, 385 + 2);
+	if (unlikely(ret))
+		return ret;
+	counters->untagged_miss_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->untagged_miss_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6, 385 + 3);
+	if (unlikely(ret))
+		return ret;
+	counters->notag_pkts[0] = packed_record[0] | (packed_record[1] << 16);
+	counters->notag_pkts[1] = packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6, 385 + 4);
+	if (unlikely(ret))
+		return ret;
+	counters->untagged_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->untagged_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6, 385 + 5);
+	if (unlikely(ret))
+		return ret;
+	counters->bad_tag_pkts[0] = packed_record[0] | (packed_record[1] << 16);
+	counters->bad_tag_pkts[1] = packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6, 385 + 6);
+	if (unlikely(ret))
+		return ret;
+	counters->no_sci_pkts[0] = packed_record[0] | (packed_record[1] << 16);
+	counters->no_sci_pkts[1] = packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6, 385 + 7);
+	if (unlikely(ret))
+		return ret;
+	counters->unknown_sci_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->unknown_sci_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6, 385 + 8);
+	if (unlikely(ret))
+		return ret;
+	counters->ctrl_prt_pass_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->ctrl_prt_pass_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6, 385 + 9);
+	if (unlikely(ret))
+		return ret;
+	counters->unctrl_prt_pass_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->unctrl_prt_pass_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6, 385 + 10);
+	if (unlikely(ret))
+		return ret;
+	counters->ctrl_prt_fail_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->ctrl_prt_fail_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6, 385 + 11);
+	if (unlikely(ret))
+		return ret;
+	counters->unctrl_prt_fail_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->unctrl_prt_fail_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6, 385 + 12);
+	if (unlikely(ret))
+		return ret;
+	counters->too_long_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->too_long_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6, 385 + 13);
+	if (unlikely(ret))
+		return ret;
+	counters->igpoc_ctl_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->igpoc_ctl_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6, 385 + 14);
+	if (unlikely(ret))
+		return ret;
+	counters->ecc_error_pkts[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->ecc_error_pkts[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	ret = get_raw_ingress_record(hw, packed_record, 4, 6, 385 + 15);
+	if (unlikely(ret))
+		return ret;
+	counters->unctrl_hit_drop_redir[0] =
+		packed_record[0] | (packed_record[1] << 16);
+	counters->unctrl_hit_drop_redir[1] =
+		packed_record[2] | (packed_record[3] << 16);
+
+	return 0;
+}
+
+int aq_mss_get_ingress_common_counters(struct aq_hw_s *hw,
+	struct aq_mss_ingress_common_counters *counters)
+{
+	memset(counters, 0, sizeof(*counters));
+
+	return AQ_API_CALL_SAFE(get_ingress_common_counters, hw, counters);
+}
+
+static int clear_ingress_counters(struct aq_hw_s *hw)
+{
+	struct mss_ingress_ctl_register ctl_reg;
+	int ret;
+
+	memset(&ctl_reg, 0, sizeof(ctl_reg));
+
+	ret = aq_mss_mdio_read(hw, MDIO_MMD_VEND1,
+			       MSS_INGRESS_CTL_REGISTER_ADDR, &ctl_reg.word_0);
+	if (unlikely(ret))
+		return ret;
+	ret = aq_mss_mdio_read(hw, MDIO_MMD_VEND1,
+			       MSS_INGRESS_CTL_REGISTER_ADDR + 4,
+			       &ctl_reg.word_1);
+	if (unlikely(ret))
+		return ret;
+
+	/* Toggle the Ingress MIB clear bit 0->1->0 */
+	ctl_reg.bits_0.clear_count = 0;
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				MSS_INGRESS_CTL_REGISTER_ADDR, ctl_reg.word_0);
+	if (unlikely(ret))
+		return ret;
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				MSS_INGRESS_CTL_REGISTER_ADDR + 4,
+				ctl_reg.word_1);
+	if (unlikely(ret))
+		return ret;
+
+	ctl_reg.bits_0.clear_count = 1;
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				MSS_INGRESS_CTL_REGISTER_ADDR, ctl_reg.word_0);
+	if (unlikely(ret))
+		return ret;
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				MSS_INGRESS_CTL_REGISTER_ADDR + 4,
+				ctl_reg.word_1);
+	if (unlikely(ret))
+		return ret;
+
+	ctl_reg.bits_0.clear_count = 0;
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				MSS_INGRESS_CTL_REGISTER_ADDR, ctl_reg.word_0);
+	if (unlikely(ret))
+		return ret;
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				MSS_INGRESS_CTL_REGISTER_ADDR + 4,
+				ctl_reg.word_1);
+	if (unlikely(ret))
+		return ret;
+
+	return 0;
+}
+
+int aq_mss_clear_ingress_counters(struct aq_hw_s *hw)
+{
+	return AQ_API_CALL_SAFE(clear_ingress_counters, hw);
+}
+
 static int get_egress_sa_expired(struct aq_hw_s *hw, u32 *expired)
 {
 	u16 val;
diff --git a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.h b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.h
index 3d2b630fe019..f9a3e8309ffc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.h
+++ b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.h
@@ -267,6 +267,53 @@ int aq_mss_set_ingress_postctlf_record(struct aq_hw_s *hw,
 	const struct aq_mss_ingress_postctlf_record *rec,
 	u16 table_index);
 
+/*!  Read the counters for the specified SC, and unpack them into the
+ *   fields of counters.
+ *  counters - [OUT] The raw table row data will be unpacked here.
+ *  sc_index - The table row to read (max 31).
+ */
+int aq_mss_get_egress_sc_counters(struct aq_hw_s *hw,
+				  struct aq_mss_egress_sc_counters *counters,
+				  u16 sc_index);
+
+/*!  Read the counters for the specified SA, and unpack them into the
+ *   fields of counters.
+ *  counters - [OUT] The raw table row data will be unpacked here.
+ *  sa_index - The table row to read (max 31).
+ */
+int aq_mss_get_egress_sa_counters(struct aq_hw_s *hw,
+				  struct aq_mss_egress_sa_counters *counters,
+				  u16 sa_index);
+
+/*!  Read the counters for the common egress counters, and unpack them
+ *   into the fields of counters.
+ *  counters - [OUT] The raw table row data will be unpacked here.
+ */
+int aq_mss_get_egress_common_counters(struct aq_hw_s *hw,
+	struct aq_mss_egress_common_counters *counters);
+
+/*!  Clear all Egress counters to 0.*/
+int aq_mss_clear_egress_counters(struct aq_hw_s *hw);
+
+/*!  Read the counters for the specified SA, and unpack them into the
+ *   fields of counters.
+ *  counters - [OUT] The raw table row data will be unpacked here.
+ *  sa_index - The table row to read (max 31).
+ */
+int aq_mss_get_ingress_sa_counters(struct aq_hw_s *hw,
+				   struct aq_mss_ingress_sa_counters *counters,
+				   u16 sa_index);
+
+/*!  Read the counters for the common ingress counters, and unpack them
+ *   into the fields of counters.
+ *  counters - [OUT] The raw table row data will be unpacked here.
+ */
+int aq_mss_get_ingress_common_counters(struct aq_hw_s *hw,
+	struct aq_mss_ingress_common_counters *counters);
+
+/*!  Clear all Ingress counters to 0. */
+int aq_mss_clear_ingress_counters(struct aq_hw_s *hw);
+
 /*!  Get Egress SA expired. */
 int aq_mss_get_egress_sa_expired(struct aq_hw_s *hw, u32 *expired);
 /*!  Get Egress SA threshold expired. */
diff --git a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h
index 4fc2dbd367c2..792a239058e8 100644
--- a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h
+++ b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h
@@ -702,4 +702,218 @@ struct aq_mss_ingress_postctlf_record {
 	u32 action;
 };
 
+/*! Represents the Egress MIB counters for a single SC. Counters are
+ *  64 bits, lower 32 bits in field[0].
+ */
+struct aq_mss_egress_sc_counters {
+	/*! The number of integrity protected but not encrypted packets
+	 *  for this transmitting SC.
+	 */
+	u32 sc_protected_pkts[2];
+	/*! The number of integrity protected and encrypted packets for
+	 *  this transmitting SC.
+	 */
+	u32 sc_encrypted_pkts[2];
+	/*! The number of plain text octets that are integrity protected
+	 *  but not encrypted on the transmitting SC.
+	 */
+	u32 sc_protected_octets[2];
+	/*! The number of plain text octets that are integrity protected
+	 *  and encrypted on the transmitting SC.
+	 */
+	u32 sc_encrypted_octets[2];
+};
+
+/*! Represents the Egress MIB counters for a single SA. Counters are
+ *  64 bits, lower 32 bits in field[0].
+ */
+struct aq_mss_egress_sa_counters {
+	/*! The number of dropped packets for this transmitting SA. */
+	u32 sa_hit_drop_redirect[2];
+	/*! TODO */
+	u32 sa_protected2_pkts[2];
+	/*! The number of integrity protected but not encrypted packets
+	 *  for this transmitting SA.
+	 */
+	u32 sa_protected_pkts[2];
+	/*! The number of integrity protected and encrypted packets for
+	 *  this transmitting SA.
+	 */
+	u32 sa_encrypted_pkts[2];
+};
+
+/*! Represents the common Egress MIB counters; the counter not
+ *  associated with a particular SC/SA. Counters are 64 bits, lower 32
+ *  bits in field[0].
+ */
+struct aq_mss_egress_common_counters {
+	/*! The number of transmitted packets classified as MAC_CTL packets. */
+	u32 ctl_pkt[2];
+	/*! The number of transmitted packets that did not match any rows
+	 *  in the Egress Packet Classifier table.
+	 */
+	u32 unknown_sa_pkts[2];
+	/*! The number of transmitted packets where the SC table entry has
+	 *  protect=0 (so packets are forwarded unchanged).
+	 */
+	u32 untagged_pkts[2];
+	/*! The number of transmitted packets discarded because the packet
+	 *  length is greater than the ifMtu of the Common Port interface.
+	 */
+	u32 too_long[2];
+	/*! The number of transmitted packets for which table memory was
+	 *  affected by an ECC error during processing.
+	 */
+	u32 ecc_error_pkts[2];
+	/*! The number of transmitted packets for where the matched row in
+	 *  the Egress Packet Classifier table has action=drop.
+	 */
+	u32 unctrl_hit_drop_redir[2];
+};
+
+/*! Represents the Ingress MIB counters for a single SA. Counters are
+ *  64 bits, lower 32 bits in field[0].
+ */
+struct aq_mss_ingress_sa_counters {
+	/*! For this SA, the number of received packets without a SecTAG. */
+	u32 untagged_hit_pkts[2];
+	/*! For this SA, the number of received packets that were dropped. */
+	u32 ctrl_hit_drop_redir_pkts[2];
+	/*! For this SA which is not currently in use, the number of
+	 *  received packets that have been discarded, and have either the
+	 *  packets encrypted or the matched row in the Ingress SC Lookup
+	 *  table has validate_frames=Strict.
+	 */
+	u32 not_using_sa[2];
+	/*! For this SA which is not currently in use, the number of
+	 *  received, unencrypted, packets with the matched row in the
+	 *  Ingress SC Lookup table has validate_frames!=Strict.
+	 */
+	u32 unused_sa[2];
+	/*! For this SA, the number discarded packets with the condition
+	 *  that the packets are not valid and one of the following
+	 *  conditions are true: either the matched row in the Ingress SC
+	 *  Lookup table has validate_frames=Strict or the packets
+	 *  encrypted.
+	 */
+	u32 not_valid_pkts[2];
+	/*! For this SA, the number of packets with the condition that the
+	 *  packets are not valid and the matched row in the Ingress SC
+	 *  Lookup table has validate_frames=Check.
+	 */
+	u32 invalid_pkts[2];
+	/*! For this SA, the number of validated packets. */
+	u32 ok_pkts[2];
+	/*! For this SC, the number of received packets that have been
+	 *  discarded with the condition: the matched row in the Ingress
+	 *  SC Lookup table has replay_protect=1 and the PN of the packet
+	 *  is lower than the lower bound replay check PN.
+	 */
+	u32 late_pkts[2];
+	/*! For this SA, the number of packets with the condition that the
+	 *  PN of the packets is lower than the lower bound replay
+	 *  protection PN.
+	 */
+	u32 delayed_pkts[2];
+	/*! For this SC, the number of packets with the following condition:
+	 *  - the matched row in the Ingress SC Lookup table has
+	 *    replay_protect=0 or
+	 *  - the matched row in the Ingress SC Lookup table has
+	 *    replay_protect=1 and the packet is not encrypted and the
+	 *    integrity check has failed or
+	 *  - the matched row in the Ingress SC Lookup table has
+	 *    replay_protect=1 and the packet is encrypted and integrity
+	 *    check has failed.
+	 */
+	u32 unchecked_pkts[2];
+	/*! The number of octets of plaintext recovered from received
+	 *  packets that were integrity protected but not encrypted.
+	 */
+	u32 validated_octets[2];
+	/*! The number of octets of plaintext recovered from received
+	 *  packets that were integrity protected and encrypted.
+	 */
+	u32 decrypted_octets[2];
+};
+
+/*! Represents the common Ingress MIB counters; the counter not
+ *  associated with a particular SA. Counters are 64 bits, lower 32
+ *  bits in field[0].
+ */
+struct aq_mss_ingress_common_counters {
+	/*! The number of received packets classified as MAC_CTL packets. */
+	u32 ctl_pkts[2];
+	/*! The number of received packets with the MAC security tag
+	 *  (SecTAG), not matching any rows in the Ingress Pre-MACSec
+	 *  Packet Classifier table.
+	 */
+	u32 tagged_miss_pkts[2];
+	/*! The number of received packets without the MAC security tag
+	 *  (SecTAG), not matching any rows in the Ingress Pre-MACSec
+	 *  Packet Classifier table.
+	 */
+	u32 untagged_miss_pkts[2];
+	/*! The number of received packets discarded without the MAC
+	 *  security tag (SecTAG) and with the matched row in the Ingress
+	 *  SC Lookup table having validate_frames=Strict.
+	 */
+	u32 notag_pkts[2];
+	/*! The number of received packets without the MAC security tag
+	 *  (SecTAG) and with the matched row in the Ingress SC Lookup
+	 *  table having validate_frames!=Strict.
+	 */
+	u32 untagged_pkts[2];
+	/*! The number of received packets discarded with an invalid
+	 *  SecTAG or a zero value PN or an invalid ICV.
+	 */
+	u32 bad_tag_pkts[2];
+	/*! The number of received packets discarded with unknown SCI
+	 *  information with the condition:
+	 *  the matched row in the Ingress SC Lookup table has
+	 *  validate_frames=Strict or the C bit in the SecTAG is set.
+	 */
+	u32 no_sci_pkts[2];
+	/*! The number of received packets with unknown SCI with the condition:
+	 *  The matched row in the Ingress SC Lookup table has
+	 *  validate_frames!=Strict and the C bit in the SecTAG is not set.
+	 */
+	u32 unknown_sci_pkts[2];
+	/*! The number of received packets by the controlled port service
+	 *  that passed the Ingress Post-MACSec Packet Classifier table
+	 *  check.
+	 */
+	u32 ctrl_prt_pass_pkts[2];
+	/*! The number of received packets by the uncontrolled port
+	 *  service that passed the Ingress Post-MACSec Packet Classifier
+	 *  table check.
+	 */
+	u32 unctrl_prt_pass_pkts[2];
+	/*! The number of received packets by the controlled port service
+	 *  that failed the Ingress Post-MACSec Packet Classifier table
+	 *  check.
+	 */
+	u32 ctrl_prt_fail_pkts[2];
+	/*! The number of received packets by the uncontrolled port
+	 *  service that failed the Ingress Post-MACSec Packet Classifier
+	 *  table check.
+	 */
+	u32 unctrl_prt_fail_pkts[2];
+	/*! The number of received packets discarded because the packet
+	 *  length is greater than the ifMtu of the Common Port interface.
+	 */
+	u32 too_long_pkts[2];
+	/*! The number of received packets classified as MAC_CTL by the
+	 *  Ingress Post-MACSec CTL Filter table.
+	 */
+	u32 igpoc_ctl_pkts[2];
+	/*! The number of received packets for which table memory was
+	 *  affected by an ECC error during processing.
+	 */
+	u32 ecc_error_pkts[2];
+	/*! The number of received packets by the uncontrolled port
+	 *  service that were dropped.
+	 */
+	u32 unctrl_hit_drop_redir[2];
+};
+
 #endif
-- 
2.17.1

