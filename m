Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B846B4C71
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbjCJQO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjCJQMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:12:34 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D188064B3D;
        Fri, 10 Mar 2023 08:10:02 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32AEjp3h006693;
        Fri, 10 Mar 2023 16:08:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : date : subject :
 mime-version : content-type : content-transfer-encoding : message-id :
 references : in-reply-to : to : cc; s=pp1;
 bh=Dd2kQUfWFnszmG6DMe7M8gc7pNGIxWX8KgLmEs5ksjg=;
 b=Eaj+jmq+oIHL16VjyLLQw75DoHqchWoBhaAmmHKARcsHprgAz+9RQdaYZbme17CRFOPH
 XMPdo1iPjRqiWynixqVZb0Tu3cQy3rz0yJuIa3IVMvIbXYVEoyhCLj1sWdOd2233MlTK
 hk7wY+y7u00VIZKXLVWxkHPkKETNF0TGjXs+n1UnKcTOJYoicyHBBOzkcIWC7RpwF/+o
 y6ZE1m70l6xHoHYt9tjq6Q/wLMDrckNRbzHWzHqcJerp1GAHsNAad1JWWs4zLDu0ipkd
 BJPsdZ04fsNmT3l11EeG6sZcBy+cykUxnAwJnGiY3ZLxYWE1FcGKLL9BJSL1sX3bKIAp ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p86kk265e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 16:08:31 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32AFOICj002913;
        Fri, 10 Mar 2023 16:08:30 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p86kk263w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 16:08:30 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32A90r91015599;
        Fri, 10 Mar 2023 16:08:27 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3p6gdqb1kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 16:08:27 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32AG8OjV33948248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 16:08:24 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 079BA20040;
        Fri, 10 Mar 2023 16:08:24 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F41420043;
        Fri, 10 Mar 2023 16:08:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 10 Mar 2023 16:08:22 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Date:   Fri, 10 Mar 2023 17:07:51 +0100
Subject: [PATCH v8 6/6] iommu/dma: Make flush queue sizes and timeout
 driver configurable
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230310-dma_iommu-v8-6-2347dfbed7af@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7688;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=0Viu4dgW+izma7wepNli41t/vT/hiq+KY4uTxoszdeg=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGFK4Q9/M5oppabrFGTkzXENo3T3Fktst5+azf5lyb5L4t
 l/f+jvOdJSyMIhxMMiKKbIs6nL2W1cwxXRPUH8HzBxWJpAhDFycAjCRimSGP9xXc1zjFB68+2Mr
 G249f+FEpS/LjjJY5h89NteDT+eqUAcjw8JTDFGvnutphRvIii55tenUqaMmAst3TF3C32q4uDH
 0ExMA
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _pCrP-dVeHtLF3A9yTr9RRZSvhhClx6E
X-Proofpoint-GUID: zsQlPL_sqHL1mcFU6sO_hVdfl-MWdl8Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_07,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303100124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flush queues currently use a fixed compile time size of 256 entries.
This being a power of 2 allows the compiler to use shift and mask
instead of more expensive modulo operations. With per-CPU flush queues
larger queue sizes would hit per-CPU allocation limits, with a single
flush queue these limits do not apply however. Also with single queues
being particularly suitable for virtualized environments with expensive
IOTLB flushes these benefit especially from larger queues and thus fewer
flushes.

To this end re-order struct iova_fq so we can use a dynamic array and
introduce the flush queue size and timeouts as new options in the
dma_iommu_options struct. So as not to lose the shift and mask
optimization, check that the variable length is a power of 2 and use
explicit shift and mask instead of letting the compiler optimize this.

In the s390 IOMMU driver a large fixed queue size and timeout is then
set together with single queue mode bringing its performance on s390
paged memory guests on par with the previous s390 specific DMA API
implementation.

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com> #s390
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 drivers/iommu/dma-iommu.c  | 40 +++++++++++++++++++++++++---------------
 drivers/iommu/s390-iommu.c |  8 +++++++-
 include/linux/iommu.h      |  6 +++++-
 3 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 6f5fd110e0e0..ec71dda87521 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -89,10 +89,10 @@ static int __init iommu_dma_forcedac_setup(char *str)
 early_param("iommu.forcedac", iommu_dma_forcedac_setup);
 
 /* Number of entries per flush queue */
-#define IOVA_FQ_SIZE	256
+#define IOVA_DEFAULT_FQ_SIZE	256
 
 /* Timeout (in ms) after which entries are flushed from the queue */
-#define IOVA_FQ_TIMEOUT	10
+#define IOVA_DEFAULT_FQ_TIMEOUT	10
 
 /* Flush queue entry for deferred flushing */
 struct iova_fq_entry {
@@ -104,18 +104,19 @@ struct iova_fq_entry {
 
 /* Per-CPU flush queue structure */
 struct iova_fq {
-	struct iova_fq_entry entries[IOVA_FQ_SIZE];
-	unsigned int head, tail;
 	spinlock_t lock;
+	unsigned int head, tail;
+	unsigned int mod_mask;
+	struct iova_fq_entry entries[];
 };
 
 #define fq_ring_for_each(i, fq) \
-	for ((i) = (fq)->head; (i) != (fq)->tail; (i) = ((i) + 1) % IOVA_FQ_SIZE)
+	for ((i) = (fq)->head; (i) != (fq)->tail; (i) = ((i) + 1) & (fq)->mod_mask)
 
 static inline bool fq_full(struct iova_fq *fq)
 {
 	assert_spin_locked(&fq->lock);
-	return (((fq->tail + 1) % IOVA_FQ_SIZE) == fq->head);
+	return (((fq->tail + 1) & fq->mod_mask) == fq->head);
 }
 
 static inline unsigned int fq_ring_add(struct iova_fq *fq)
@@ -124,7 +125,7 @@ static inline unsigned int fq_ring_add(struct iova_fq *fq)
 
 	assert_spin_locked(&fq->lock);
 
-	fq->tail = (idx + 1) % IOVA_FQ_SIZE;
+	fq->tail = (idx + 1) & fq->mod_mask;
 
 	return idx;
 }
@@ -146,7 +147,7 @@ static void fq_ring_free(struct iommu_dma_cookie *cookie, struct iova_fq *fq)
 			       fq->entries[idx].iova_pfn,
 			       fq->entries[idx].pages);
 
-		fq->head = (fq->head + 1) % IOVA_FQ_SIZE;
+		fq->head = (fq->head + 1) & fq->mod_mask;
 	}
 }
 
@@ -244,7 +245,7 @@ static void queue_iova(struct iommu_dma_cookie *cookie,
 	if (!atomic_read(&cookie->fq_timer_on) &&
 	    !atomic_xchg(&cookie->fq_timer_on, 1))
 		mod_timer(&cookie->fq_timer,
-			  jiffies + msecs_to_jiffies(IOVA_FQ_TIMEOUT));
+			  jiffies + msecs_to_jiffies(cookie->options.fq_timeout));
 }
 
 static void iommu_dma_free_fq_single(struct iova_fq *fq)
@@ -286,27 +287,29 @@ static void iommu_dma_free_fq(struct iommu_dma_cookie *cookie)
 }
 
 
-static void iommu_dma_init_one_fq(struct iova_fq *fq)
+static void iommu_dma_init_one_fq(struct iova_fq *fq, size_t fq_size)
 {
 	int i;
 
 	fq->head = 0;
 	fq->tail = 0;
+	fq->mod_mask = fq_size - 1;
 
 	spin_lock_init(&fq->lock);
 
-	for (i = 0; i < IOVA_FQ_SIZE; i++)
+	for (i = 0; i < fq_size; i++)
 		INIT_LIST_HEAD(&fq->entries[i].freelist);
 }
 
 static int iommu_dma_init_fq_single(struct iommu_dma_cookie *cookie)
 {
+	size_t fq_size = cookie->options.fq_size;
 	struct iova_fq *queue;
 
-	queue = vzalloc(sizeof(*queue));
+	queue = vzalloc(struct_size(queue, entries, fq_size));
 	if (!queue)
 		return -ENOMEM;
-	iommu_dma_init_one_fq(queue);
+	iommu_dma_init_one_fq(queue, fq_size);
 	cookie->single_fq = queue;
 
 	return 0;
@@ -314,15 +317,17 @@ static int iommu_dma_init_fq_single(struct iommu_dma_cookie *cookie)
 
 static int iommu_dma_init_fq_percpu(struct iommu_dma_cookie *cookie)
 {
+	size_t fq_size = cookie->options.fq_size;
 	struct iova_fq __percpu *queue;
 	int cpu;
 
-	queue = alloc_percpu(struct iova_fq);
+	queue = __alloc_percpu(struct_size(queue, entries, fq_size),
+			       __alignof__(*queue));
 	if (!queue)
 		return -ENOMEM;
 
 	for_each_possible_cpu(cpu)
-		iommu_dma_init_one_fq(per_cpu_ptr(queue, cpu));
+		iommu_dma_init_one_fq(per_cpu_ptr(queue, cpu), fq_size);
 	cookie->percpu_fq = queue;
 	return 0;
 }
@@ -340,6 +345,9 @@ int iommu_dma_init_fq(struct device *dev, struct iommu_domain *domain)
 	if (ops->tune_dma_iommu)
 		ops->tune_dma_iommu(dev, &cookie->options);
 
+	if (WARN_ON_ONCE(!is_power_of_2(cookie->options.fq_size)))
+		cookie->options.fq_size = IOVA_DEFAULT_FQ_SIZE;
+
 	atomic64_set(&cookie->fq_flush_start_cnt,  0);
 	atomic64_set(&cookie->fq_flush_finish_cnt, 0);
 
@@ -382,6 +390,8 @@ static struct iommu_dma_cookie *cookie_alloc(enum iommu_dma_cookie_type type)
 		INIT_LIST_HEAD(&cookie->msi_page_list);
 		cookie->type = type;
 		cookie->options.flags = IOMMU_DMA_OPTS_PER_CPU_QUEUE;
+		cookie->options.fq_size = IOVA_DEFAULT_FQ_SIZE;
+		cookie->options.fq_timeout = IOVA_DEFAULT_FQ_TIMEOUT;
 	}
 	return cookie;
 }
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index 65dd469ad524..77d204232646 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -451,13 +451,19 @@ static void s390_iommu_get_resv_regions(struct device *dev,
 	}
 }
 
+#define S390_IOMMU_SINGLE_FQ_SIZE      32768
+#define S390_IOMMU_SINGLE_FQ_TIMEOUT   1000
+
 static void s390_iommu_tune_dma_iommu(struct device *dev,
 					     struct dma_iommu_options *options)
 {
 	struct zpci_dev *zdev = to_zpci_dev(dev);
 
-	if (zdev->tlb_refresh)
+	if (zdev->tlb_refresh) {
 		options->flags |= IOMMU_DMA_OPTS_SINGLE_QUEUE;
+		options->fq_size = S390_IOMMU_SINGLE_FQ_SIZE;
+		options->fq_timeout = S390_IOMMU_SINGLE_FQ_TIMEOUT;
+	}
 }
 
 static struct iommu_device *s390_iommu_probe_device(struct device *dev)
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 2b43a3de2c4f..1675755b7f7d 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -223,6 +223,8 @@ struct iommu_iotlb_gather {
  * struct dma_iommu_options - Options for dma-iommu
  *
  * @flags: Flag bits for enabling/disabling dma-iommu settings
+ * @fq_size: Size of the IOTLB flush queue(s), must be a power of two
+ * @fq_timeout: Timeout used for queued IOTLB flushes
  *
  * This structure is intended to provide IOMMU drivers a way to influence the
  * behavior of the dma-iommu DMA API implementation. This allows optimizing for
@@ -231,7 +233,9 @@ struct iommu_iotlb_gather {
 struct dma_iommu_options {
 #define IOMMU_DMA_OPTS_PER_CPU_QUEUE	(0L << 0)
 #define IOMMU_DMA_OPTS_SINGLE_QUEUE	(1L << 0)
-	u64	flags;
+	u64		flags;
+	size_t		fq_size;
+	unsigned int	fq_timeout;
 };
 
 /**

-- 
2.37.2

