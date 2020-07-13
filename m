Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E7021D531
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbgGMLnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:43:12 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41384 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728714AbgGMLnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:43:09 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06DBefjr024231;
        Mon, 13 Jul 2020 04:43:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=JinKktXFkrG9wcWuwNTpXZ2LkVMZppsUZ/GH0CWp+QM=;
 b=dIwJE8NrbNHDoAUcVQ/3yRDMPXwn0CJddxYSddfo3+VvIdF17l7TsMA45CAtHA8yZldw
 QXSJkqqRVzx4TlP0JBluvNDUTZnC/PMhuQ3bE7ohtn7kkhRQR6J3C7PQDuBtnEaYEgzG
 WSLdt7LRN0Z0SYbvFiV/oi1XKAtJ8zAyUBCEkFxaohqtAgwy2jcKOYrxTyN/792Wejzq
 6vnrdcV7gl/tEo5CxDTCEVYMo1aiIQ5Y/Ouo3+5TapeJTiZGXMr9GEFNWyv+Xj49h6iD
 RzcRNvPjfiCS2+RhZinQWOW+QOzYzYBM7o3A2C6D5MBL7EVbRLyeNloK1uw2Xtg8iwae xg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 327asn76nc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Jul 2020 04:43:08 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Jul
 2020 04:43:06 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Jul
 2020 04:43:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 13 Jul 2020 04:43:06 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.6.200.41])
        by maili.marvell.com (Postfix) with ESMTP id D4EFB3F703F;
        Mon, 13 Jul 2020 04:43:03 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 07/10] net: atlantic: use U32_MAX in aq_hw_utils.c
Date:   Mon, 13 Jul 2020 14:42:30 +0300
Message-ID: <20200713114233.436-8-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200713114233.436-1-irusskikh@marvell.com>
References: <20200713114233.436-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_10:2020-07-13,2020-07-13 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch replaces magic constant ~0U usage with U32_MAX in aq_hw_utils.c

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
index 0172d2206685..b9068447fa36 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
@@ -38,9 +38,8 @@ u32 aq_hw_read_reg(struct aq_hw_s *hw, u32 reg)
 {
 	u32 value = readl(hw->mmio + reg);
 
-	if ((~0U) == value &&
-	    (~0U) == readl(hw->mmio +
-			   hw->aq_nic_cfg->aq_hw_caps->hw_alive_check_addr))
+	if (value == U32_MAX &&
+	    readl(hw->mmio + hw->aq_nic_cfg->aq_hw_caps->hw_alive_check_addr) == U32_MAX)
 		aq_utils_obj_set(&hw->flags, AQ_HW_FLAG_ERR_UNPLUG);
 
 	return value;
-- 
2.17.1

