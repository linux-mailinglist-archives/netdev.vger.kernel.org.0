Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE951CBE28
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 08:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbgEIGsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 02:48:05 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27034 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725940AbgEIGsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 02:48:04 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0496jnXS032383;
        Fri, 8 May 2020 23:48:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=7u8s6MlNZAzqeZOchDppHwE2OCWEBkhvhLJ9CEiobx4=;
 b=yv1MW0F/0t9qu3Pg3m4EP0lJWd0M0wkj4dkv12wV1p0dZEH6xlN/GPDN7/CM2y+0+Ykb
 +wa1rBa4jEIKG/KGZ9RTSJ69VvWClHGQQkCCgpJNaJyj093F0uN4De+V3L/F8kSJ596r
 VH86VKo2Lv1eldx8+XVRkWMRr4aBMx+TAiwkmF4npPJqewcVY1PPMGMZ4ek5JEWUeerI
 E7r7Ceg7hXne4DZcdKs8CZu7v4ZP0kEl6YlKV6I2CY/7SVAA4po5oYjSPVAm7Sv+t8QF
 ZtQ5co/aQKg8tQHZCS9d3TCG2Yc6JBgXsu3VSi9BAfAoiiDgqu26cXJqSdGZYAIzaQZn yg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 30wjj7gvcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 23:48:01 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 8 May
 2020 23:47:59 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 8 May
 2020 23:47:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 23:47:59 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 67DA63F703F;
        Fri,  8 May 2020 23:47:50 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 4/7] net: atlantic: remove TPO2 check from A0 code
Date:   Sat, 9 May 2020 09:46:57 +0300
Message-ID: <20200509064700.202-5-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200509064700.202-1-irusskikh@marvell.com>
References: <20200509064700.202-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_02:2020-05-08,2020-05-09 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

TPO2 was introduced in B0 only, no reason to check for it in A0 code.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
index 70f06c40bdf2..1b0670a8ae33 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -268,8 +268,7 @@ static int hw_atl_a0_hw_init_tx_path(struct aq_hw_s *self)
 	hw_atl_tdm_tx_desc_wr_wb_irq_en_set(self, 1U);
 
 	/* misc */
-	aq_hw_write_reg(self, 0x00007040U, ATL_HW_IS_CHIP_FEATURE(self, TPO2) ?
-			0x00010000U : 0x00000000U);
+	aq_hw_write_reg(self, 0x00007040U, 0x00000000U);
 	hw_atl_tdm_tx_dca_en_set(self, 0U);
 	hw_atl_tdm_tx_dca_mode_set(self, 0U);
 
-- 
2.20.1

