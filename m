Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E253D6B4C49
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjCJQMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjCJQML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:12:11 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE1C11CD58;
        Fri, 10 Mar 2023 08:09:47 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32AFIlWj009172;
        Fri, 10 Mar 2023 16:08:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : date : subject :
 mime-version : content-type : content-transfer-encoding : message-id :
 references : in-reply-to : to : cc; s=pp1;
 bh=CPjiaxkDrxOhM80KIjTs4JVtVyYlieaiFF9qFB3yuTs=;
 b=tXavVzjnWXnUWxo/+5gRNAvh+SrSRHn8w7I5IyuwiGH7B/7vhSDBzr8X+SOjp4La5Ofi
 E8yWW7ATRkL3vyOkkVhvOJuih5cAwAqjwOZNB7TLZtc8R4PrbH0ETKkNlQANATXjPZu7
 r9zreoSN0NRl592tbnyqE1ixnXvv32rk7kh1QC5Fez8klPSXWb3F69+4DO4JLZ1MYNev
 SgjY9jPPWVQs/0bAwqDBknyQ6wVkehaMYZQHebz02lw3slEHZeMZYUilAg9OzjwPBh82
 LrPxVNYRJjF124LC4pgAjm9Ew/iY+2kmrRDybvLWh7fRcABbfoUFY/TsKcczEFnHlSle gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p873597vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 16:08:23 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32AFJhvL012093;
        Fri, 10 Mar 2023 16:08:22 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p873597uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 16:08:22 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32A7uOH3030374;
        Fri, 10 Mar 2023 16:08:19 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3p6g8642fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 16:08:19 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32AG8G1F43712872
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 16:08:16 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23A5720040;
        Fri, 10 Mar 2023 16:08:16 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A02E52004B;
        Fri, 10 Mar 2023 16:08:14 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 10 Mar 2023 16:08:14 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Date:   Fri, 10 Mar 2023 17:07:46 +0100
Subject: [PATCH v8 1/6] s390/ism: Set DMA coherent mask
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230310-dma_iommu-v8-1-2347dfbed7af@linux.ibm.com>
References: <20230310-dma_iommu-v8-0-2347dfbed7af@linux.ibm.com>
In-Reply-To: <20230310-dma_iommu-v8-0-2347dfbed7af@linux.ibm.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Gerd Bayer <gbayer@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Hector Martin <marcan@marcan.st>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Yong Wu <yong.wu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux.dev, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-tegra@vger.kernel.org,
        linux-doc@vger.kernel.org
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1331;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=QP466Tmuhke9ZpYBaps9u7QPQnPFsiOIACaxA8oBroY=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGFK4Q5+vllZav+rNo0U7la52x0cImVZcN1RS98zw3P39X
 dcKy9xDHaUsDGIcDLJiiiyLupz91hVMMd0T1N8BM4eVCWQIAxenAEyk5BAjw1fbxSKbZiyYNOfX
 i9e+U6NU79z3+X/DQu1J5mrDsK1bQmIZGaZefqL26+xhvtRDD/vNeD1lsyY9V5Rb46KxIP5eF2/
 uLW4A
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: t6DB5i8vhkARvWYCiBWLQXRiiRuyxhWc
X-Proofpoint-GUID: CyMGare_uRiBCY_5gvYk6zMLo51yZXdw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_06,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 bulkscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A future change will convert the DMA API implementation from the
architecture specific arch/s390/pci/pci_dma.c to using the common code
drivers/iommu/dma-iommu.c which the utilizes the same IOMMU hardware
through the s390-iommu driver. Unlike the s390 specific DMA API this
requires devices to correctly call set the coherent mask to be allowed
to use IOVAs >2^32 in dma_alloc_coherent(). This was however not done
for ISM devices. ISM requires such addresses since currently the DMA
aperture for PCI devices starts at 2^32 and all calls to
dma_alloc_coherent() would thus fail.

Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 drivers/s390/net/ism_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index eb7e13486087..a40e3afeaaa8 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -661,7 +661,7 @@ static int ism_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		goto err_disable;
 
-	ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (ret)
 		goto err_resource;
 

-- 
2.37.2

