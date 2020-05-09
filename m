Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3431CBE2A
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 08:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgEIGsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 02:48:21 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52078 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725940AbgEIGsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 02:48:21 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0496jnXT032383;
        Fri, 8 May 2020 23:48:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=syHoqBmNqOh4cZN7nFTgToX+h5xlAwPXz3MznaXFQ48=;
 b=SDO7LR8ZSZL6fKcF2SZ1rujr8sOozKiwcA6mZtQwN/LL97XzgCOu69XlSoWNvy0Njvcz
 z5LNejN3xlSbGCdDyTC8wcyD5sZ6Gj0Jy8Txnc1dipita9WrggZ3pFLLZu5NFB3kERWZ
 Y9KYnfBtf5IkX6XODHapv2EYtNDEI7JZ631Wr4g97yJdeiT3nj+HongbTsxfLszj8XMf
 YP2BKVLBoBhGhyXurWma086G7GdQMtVzh8+6zWUK5RJFNJmsZDPOZgqzh9ltyGsfAzSs
 c9Vs9+uIXsmQMAaXGV3H+3vjRodkVwPrHil/hwdtVbf2g7YOZxXbx36i+l/gCpFMhT0v yw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 30wjj7gvda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 May 2020 23:48:19 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 8 May
 2020 23:48:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 8 May 2020 23:48:17 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.46.2])
        by maili.marvell.com (Postfix) with ESMTP id 71DA53F704D;
        Fri,  8 May 2020 23:48:08 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 6/7] net: atlantic: remove check for boot code survivability before reset request
Date:   Sat, 9 May 2020 09:46:59 +0300
Message-ID: <20200509064700.202-7-irusskikh@marvell.com>
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

This patch removes unnecessary check for boot code survivability before
reset request.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c    | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c
index 85ccc9a011a0..f3766780e975 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils.c
@@ -75,14 +75,6 @@ int hw_atl2_utils_soft_reset(struct aq_hw_s *self)
 	u32 rbl_request;
 	int err;
 
-	err = readx_poll_timeout_atomic(hw_atl2_mif_mcp_boot_reg_get, self,
-				rbl_status,
-				((rbl_status & AQ_A2_BOOT_STARTED) &&
-				 (rbl_status != 0xFFFFFFFFu)),
-				10, 500000);
-	if (err)
-		aq_pr_trace("Boot code probably hanged, reboot anyway");
-
 	hw_atl2_mif_host_req_int_clr(self, 0x01);
 	rbl_request = AQ_A2_FW_BOOT_REQ_REBOOT;
 #ifdef AQ_CFG_FAST_START
-- 
2.20.1

