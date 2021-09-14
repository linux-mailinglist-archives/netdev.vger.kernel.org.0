Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB27040A950
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 10:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhINIf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 04:35:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41638 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230416AbhINIfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 04:35:17 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18E85bss023214;
        Tue, 14 Sep 2021 04:33:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=DyUp8rOK4/jZv7mgiOYxr1yFKTTFCb0zSlP/hGPVruk=;
 b=UE7ruEnL8/Z3P19UCr/xELRl7euXUT7bx82jUBLLVXdZu9QL6YTPROnp24dmXRAcH0wU
 wgn0gKqRtVYZP95ppL6bOtNcnYE+UUxxO/017qpohXvBp9FsoP+XGwwISk98aW36nVah
 wKpZqsFtP+5NEOgMawb7eiKUqYlGVYYu0ke+iUpU6AuW97raVhPv7NkqxpxPvBri+25A
 A+Sru14XlxaWABYOnrFaZcPUwtt6/ZaN/oovrU6ESYn5tskKpFb4F9c/D327aup/Bspz
 mPHuQ570O30Qt7iOctXmXKOQ7MljPWFqLx8IdAQDPNV8kY8sx6AWaBT/uKj6dQMcXEVB JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2qx3rh84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 04:33:58 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18E880BM027817;
        Tue, 14 Sep 2021 04:33:58 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b2qx3rh7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 04:33:58 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18E8W9Ga004557;
        Tue, 14 Sep 2021 08:33:56 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3b0m3980eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 08:33:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18E8TK4k52035856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 08:29:20 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E0B44C044;
        Tue, 14 Sep 2021 08:33:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C08304C04E;
        Tue, 14 Sep 2021 08:33:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Sep 2021 08:33:50 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH net-next 4/4] s390/ism: switch from 'pci_' to 'dma_' API
Date:   Tue, 14 Sep 2021 10:33:20 +0200
Message-Id: <20210914083320.508996-5-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210914083320.508996-1-kgraul@linux.ibm.com>
References: <20210914083320.508996-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 24lsStLs8TSHtOVDtjAGVUjcq5dZHrf7
X-Proofpoint-ORIG-GUID: eKQ2_gPc-M0b2AQnvSJNJTrUaeJkcLRO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 suspectscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 clxscore=1015 spamscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109140040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below.

@@
expression e1, e2;
@@
-    pci_set_dma_mask(e1, e2)
+    dma_set_mask(&e1->dev, e2)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 drivers/s390/net/ism_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 26cc943d2034..5f7e28de8b15 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -555,7 +555,7 @@ static int ism_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		goto err_disable;
 
-	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
 	if (ret)
 		goto err_resource;
 
-- 
2.25.1

