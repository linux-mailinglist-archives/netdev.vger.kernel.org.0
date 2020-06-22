Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0146203A05
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 16:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgFVOxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 10:53:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27752 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728956AbgFVOxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 10:53:21 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MEZGcA003822;
        Mon, 22 Jun 2020 07:53:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=xTfFKamho9cqtc8BbX6hx7VV4gj2Zuz90SYidAohVBc=;
 b=O1VtsflXKD6ejDqFoEuFoib1pJRnRezpsRSLJc2InnA2dV5qvcqGwqicluU9UC3A5aCo
 /UX3p0YKm7ZHZRXZ5/2OnpVZqWhpRqeiMAMlm8Y9Uuz3U7+FBLr+hJPxOXHeBulAjZk9
 +Za0oCvE99udT8Okej8JseVvZwAJDGmqGDz4d0vashrlcZbN6PjnyPEazvAWMHvQCERk
 HfJOT12YrI9pgriv9T0ICPDPyGxSFM5rsBdNfuRYQ2ClQJ93hKjQsFLeeyJRnLVZ9nOi
 fpxG57cmizmG+TR1VSrOaiccM5e4kvl2vV9kq5oDkWWUlf3zll6FsnUxU0NjLeiiTV6Z IQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 31shynrhqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 07:53:19 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 07:53:18 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 07:53:18 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 1355C3F7043;
        Mon, 22 Jun 2020 07:53:15 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next 2/6] net: atlantic: remove baseX usage
Date:   Mon, 22 Jun 2020 17:53:05 +0300
Message-ID: <20200622145309.455-3-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200622145309.455-1-irusskikh@marvell.com>
References: <20200622145309.455-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_08:2020-06-22,2020-06-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikita Danilov <ndanilov@marvell.com>

This patch removes 2.5G baseX wrong usage/reporting, since it shouldn't have
been mixed with baseT.

Signed-off-by: Nikita Danilov <ndanilov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 743d3b13b39d..ffcdda70265b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -618,9 +618,6 @@ static enum hw_atl_fw2x_rate eee_mask_to_ethtool_mask(u32 speed)
 	if (speed & AQ_NIC_RATE_EEE_10G)
 		rate |= SUPPORTED_10000baseT_Full;
 
-	if (speed & AQ_NIC_RATE_EEE_2G5)
-		rate |= SUPPORTED_2500baseX_Full;
-
 	if (speed & AQ_NIC_RATE_EEE_1G)
 		rate |= SUPPORTED_1000baseT_Full;
 
-- 
2.25.1

