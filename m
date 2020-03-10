Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F38D2180102
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgCJPEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:04:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63400 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727069AbgCJPEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:04:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AEtvrr011722;
        Tue, 10 Mar 2020 08:04:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=OymuE2jcSVf19RVItHryrTrurLbJO2M7B33Lej9Unis=;
 b=lRkM8Wh+7rsU+rbjKmcAR2Vt5iv2+74IXYyLePsalXOsMYCyO2sudq9DwuzQSxMxAld5
 OQiA7BmaNjDkXdqkXg7asaWwpf1EyUZFHwgol+r/Tnq1ic2yh4M2edG6bzqbatideMA1
 Wzbo2Ve+ZYIpZj4WA0Lb+meVvEXlE2Vio4xDXhUDtuz9Hb2We+gapq1ce1ZqnOZMSUg5
 VaDFGrzOkksWERoYO9Fuw0x3jU0iC7aYpm331ez+MZDO+GDO+0kWxGYH5At7QA4SWVib
 4qL7FPQfYr7DJjacay6yr0Ref68NNx+MQWFTZtNUgHzxUgDhc3BcswzlRQgFPgTR8oh1 Bg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2yp04fm0q3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 08:04:03 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Mar
 2020 08:04:01 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Mar
 2020 08:04:01 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Mar 2020 08:04:01 -0700
Received: from NN-LT0019.rdc.aquantia.com (nn-lt0019.marvell.com [10.9.16.69])
        by maili.marvell.com (Postfix) with ESMTP id CC10D3F7043;
        Tue, 10 Mar 2020 08:03:59 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [RFC v2 03/16] net: macsec: allow to reference a netdev from a MACsec context
Date:   Tue, 10 Mar 2020 18:03:29 +0300
Message-ID: <20200310150342.1701-4-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200310150342.1701-1-irusskikh@marvell.com>
References: <20200310150342.1701-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_08:2020-03-10,2020-03-10 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>

This patch allows to reference a net_device from a MACsec context. This
is needed to allow implementing MACsec operations in net device drivers.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 include/net/macsec.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/macsec.h b/include/net/macsec.h
index 92e43db8b566..5ccdb2bc84df 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -178,7 +178,10 @@ struct macsec_secy {
  * struct macsec_context - MACsec context for hardware offloading
  */
 struct macsec_context {
-	struct phy_device *phydev;
+	union {
+		struct net_device *netdev;
+		struct phy_device *phydev;
+	};
 	enum macsec_offload offload;
 
 	struct macsec_secy *secy;
-- 
2.17.1

