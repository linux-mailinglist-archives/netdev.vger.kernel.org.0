Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9AA1C848B
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 10:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgEGIPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 04:15:40 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49096 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725845AbgEGIPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 04:15:35 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0478AiUt019772;
        Thu, 7 May 2020 01:15:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=7u8s6MlNZAzqeZOchDppHwE2OCWEBkhvhLJ9CEiobx4=;
 b=m+MILtT178u0Rz/nZpnD0cHMebjUStjchvMnOM/zICqFUt5nz/+hURC6IRsmJkRNHWrX
 BAEHvHOgA7cI+5zFI5Oe1gh39lg7KWiKxlAYsMZmkBu1tYMWhIsqOCVqM9sn+Gfw4DEi
 QTCJ1SZPdb2hhD5YJ01/KzDg3IHD9z55WBzjPetwd1L6pj2YhBcNo6rdgzZau0Tjr3n3
 fiS8FHeU/NH9KAb0hf8klzjQzfCQ0/S3Xrn9U4DurRurCI1zwfhvF1a0q3waYWbPJNxV
 Vab6QHDmRUmjbSd89vCUY41WFY7y/mfOd8/r0pm3lj19uFglvu0PEKEwZjldJ4io14z1 jQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 30uaum1ar9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 May 2020 01:15:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 May
 2020 01:15:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 7 May 2020 01:15:33 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 580393F7045;
        Thu,  7 May 2020 01:15:31 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 4/7] net: atlantic: remove TPO2 check from A0 code
Date:   Thu, 7 May 2020 11:15:07 +0300
Message-ID: <20200507081510.2120-5-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200507081510.2120-1-irusskikh@marvell.com>
References: <20200507081510.2120-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_04:2020-05-05,2020-05-07 signatures=0
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

