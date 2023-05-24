Return-Path: <netdev+bounces-4890-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5436770EFF4
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:54:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E21AA1C20BA4
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0528DC143;
	Wed, 24 May 2023 07:54:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9AE8473
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:54:23 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036CB93;
	Wed, 24 May 2023 00:54:22 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34O7j72e000529;
	Wed, 24 May 2023 07:54:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=d5QAF16BJKDuMg4CE8wCgJ8dMnnIFqFme5RRke6iDFA=;
 b=XEyL8zw10tjh/hvNzSk2aRRknxFC/Jzx7CglgwPl+o4F9J6gXLd0FkldvvZ+QF5DBplU
 MkzdWKohEv94lBW583NzTdIRTXq7dmRJTLbjPf+VlsVF9GKKmW7WY1BBu+BkU+RVie55
 LiSuJdSFklzWazs1ffSK2IfUFv0bTAxPns0TnQu8MTbaeYuawud/yxbmewcxdKAinfkH
 z3jRK3Ng8c78ySGIGdPUrIrUHaEZmyotydXsnl437ht/90XmwjCO6IPhSRiWSUAeXoJg
 r0Xe2RiO/cGsH7RJ2DRnKs00YP7+qDz0MO6nrsOmw8qCaqyk0jQEl/OAndDazXLOTvEf zQ== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qse4kgmmv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 May 2023 07:54:18 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
	by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34O2v3Le000965;
	Wed, 24 May 2023 07:54:15 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3qppcf1hc6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 May 2023 07:54:15 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34O7sCjo30802350
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 May 2023 07:54:12 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E66F020043;
	Wed, 24 May 2023 07:54:11 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7B53020040;
	Wed, 24 May 2023 07:54:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 May 2023 07:54:11 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Jakub Kicinski <kuba@kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-pci@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH net-next] s390/ism: Set DMA coherent mask
Date: Wed, 24 May 2023 09:54:10 +0200
Message-Id: <20230524075411.3734141-1-schnelle@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IP9jPuNTbIrXKI-7-cVVuXaYW72dL7NF
X-Proofpoint-ORIG-GUID: IP9jPuNTbIrXKI-7-cVVuXaYW72dL7NF
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-24_03,2023-05-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=955
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 impostorscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305240064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

A future change will convert the DMA API implementation from the
architecture specific arch/s390/pci/pci_dma.c to using the common code
drivers/iommu/dma-iommu.c which the utilizes the same IOMMU hardware
through the s390-iommu driver. Unlike the s390 specific DMA API this
requires devices to correctly set the coherent mask to be allowed to use
IOVAs >2^32 in dma_alloc_coherent(). This was however not done for ISM
devices. ISM requires such addresses since currently the DMA aperture
for PCI devices starts at 2^32 and all calls to dma_alloc_coherent()
would thus fail.

Link: https://lore.kernel.org/all/20230310-dma_iommu-v9-1-65bb8edd2beb@linux.ibm.com/
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
Note: This was previously sent and reviewed as part of multiple versions of the
s390 DMA API conversion series which requires this change as a pre-requisite
with the latest version at the Link. Sending separately to add the net-next
prefix so this can be integrated.

 drivers/s390/net/ism_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 8acb9eba691b..1399b5dc646c 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -660,7 +660,7 @@ static int ism_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		goto err_disable;
 
-	ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (ret)
 		goto err_resource;
 
-- 
2.39.2


