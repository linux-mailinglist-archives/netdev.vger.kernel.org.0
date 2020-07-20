Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B86226E4F
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbgGTSdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:33:00 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42082 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726506AbgGTSdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:33:00 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KIG11L015926;
        Mon, 20 Jul 2020 11:32:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=v94QfBQHgkSyHty03TEdbZh3iO4SLAvSbRqrAnJDFEg=;
 b=RmbDSx0C8LiNiAHvfhbDIkfNQwMAVMiYnPOVEUtUFmblLEt8UtO3E+F3RyHKzjy6RKAI
 ONtLJSFiCpz+ioeTZKuhUgHamfp7hi5oB42vaVOiVkhLuFin8+a6prNxS9XSawdn3ky9
 lNovmEkQ9WjAsYfkMAc6V3BVvRN9yCK1pRACNAcCAphBxJh3cEC3/PLbi4VVCBJ+o/ej
 JZjb0uB++xCuRZaLqtquPwdjPX/f6GIgbpzX8Qf4cEsFVsjl4GzTPDPjNjYXAAmTonXb
 eP6Ov9r8Ipk1RMP3BX9C8gnfUUHgzO1na56S540DG5ThQjNYY8sViY4zejoNfRHDcxkI Xg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 32bxeng0fn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:32:58 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:32:57 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:32:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:32:56 -0700
Received: from NN-LT0044.marvell.com (NN-LT0044.marvell.com [10.193.54.8])
        by maili.marvell.com (Postfix) with ESMTP id C726B3F703F;
        Mon, 20 Jul 2020 11:32:54 -0700 (PDT)
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>, <netdev@vger.kernel.org>,
        "Mark Starovoytov" <mstarovoitov@marvell.com>
Subject: [PATCH v3 net-next 03/13] net: atlantic: make _get_sw_stats return count as return value
Date:   Mon, 20 Jul 2020 21:32:34 +0300
Message-ID: <20200720183244.10029-4-mstarovoitov@marvell.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20200720183244.10029-1-mstarovoitov@marvell.com>
References: <20200720183244.10029-1-mstarovoitov@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes aq_vec_get_sw_stats() to return count as a return
value (which was unused) instead of an out parameter.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c |  4 ++--
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c |  8 ++------
 drivers/net/ethernet/aquantia/atlantic/aq_vec.h | 10 +++++-----
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 43b8914c3ef5..d72f40259715 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -907,13 +907,13 @@ u64 *aq_nic_get_stats(struct aq_nic_s *self, u64 *data)
 		     aq_vec && self->aq_vecs > i;
 		     ++i, aq_vec = self->aq_vec[i]) {
 			data += count;
-			aq_vec_get_sw_stats(aq_vec, tc, data, &count);
+			count = aq_vec_get_sw_stats(aq_vec, tc, data);
 		}
 	}
 
 	data += count;
 
-err_exit:;
+err_exit:
 	return data;
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index 2acdaee18ba0..8f0a0d18e711 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -380,8 +380,7 @@ static void aq_vec_get_stats(struct aq_vec_s *self,
 	}
 }
 
-int aq_vec_get_sw_stats(struct aq_vec_s *self, const unsigned int tc, u64 *data,
-			unsigned int *p_count)
+unsigned int aq_vec_get_sw_stats(struct aq_vec_s *self, const unsigned int tc, u64 *data)
 {
 	struct aq_ring_stats_rx_s stats_rx;
 	struct aq_ring_stats_tx_s stats_tx;
@@ -401,8 +400,5 @@ int aq_vec_get_sw_stats(struct aq_vec_s *self, const unsigned int tc, u64 *data,
 	data[++count] = stats_rx.lro_packets;
 	data[++count] = stats_rx.errors;
 
-	if (p_count)
-		*p_count = ++count;
-
-	return 0;
+	return ++count;
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.h b/drivers/net/ethernet/aquantia/atlantic/aq_vec.h
index 541af85e6510..c079fef80da8 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.h
@@ -1,7 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * aQuantia Corporation Network Driver
- * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File aq_vec.h: Definition of common structures for vector of Rx and Tx rings.
@@ -35,7 +36,6 @@ void aq_vec_ring_free(struct aq_vec_s *self);
 int aq_vec_start(struct aq_vec_s *self);
 void aq_vec_stop(struct aq_vec_s *self);
 cpumask_t *aq_vec_get_affinity_mask(struct aq_vec_s *self);
-int aq_vec_get_sw_stats(struct aq_vec_s *self, const unsigned int tc, u64 *data,
-			unsigned int *p_count);
+unsigned int aq_vec_get_sw_stats(struct aq_vec_s *self, const unsigned int tc, u64 *data);
 
 #endif /* AQ_VEC_H */
-- 
2.25.1

