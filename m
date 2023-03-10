Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4766B4C83
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbjCJQQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbjCJQOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:14:37 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA431204BD;
        Fri, 10 Mar 2023 08:10:23 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32AF0wZI020552;
        Fri, 10 Mar 2023 16:08:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : date : subject :
 content-type : message-id : references : in-reply-to : to : cc :
 content-transfer-encoding : mime-version; s=pp1;
 bh=AaAObrbm4EBKRfJda0O3pJUASkY2vicuQ13a5jf0XU4=;
 b=ofKkh5qnlajMXOHCeuGphjpjcpuub6EhmmQKtfUdYLZsV54ueMVgMBO+oXNAbzuUsDBz
 6aDLw85c0zH0eMwQph9E2YaY4SMC8lyrdJToLQZktmGCeQZ/K3tXLMDPWKaI9pBChdV3
 vZ4gL36iSqneHbvBXqGh71UMMAqyf4/AeRn5laCQPjAZAVlDi4Vf1aQ2su5aIBlqgg5E
 xe+xVDWbO4apfh7PFvtCAYgWA1XpG6zUKirsr5MQUX3oy/iP0klznQHh5qXT3vYiwPtB
 dwYXFQOiLPrEtMBD6vqgSqiu0Ds41o1S2X8YAvMO/AMTkjz/sg7lH3Ep0fh0/MJ9Qpbh Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p86tshqcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 16:08:32 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32AFhtEe025976;
        Fri, 10 Mar 2023 16:08:31 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p86tshqac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 16:08:31 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32A90r90015599;
        Fri, 10 Mar 2023 16:08:26 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3p6gdqb1kw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 16:08:26 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32AG8MCx44958118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 16:08:22 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 718D62004D;
        Fri, 10 Mar 2023 16:08:22 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFDFB2004B;
        Fri, 10 Mar 2023 16:08:20 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 10 Mar 2023 16:08:20 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Date:   Fri, 10 Mar 2023 17:07:50 +0100
Subject: [PATCH v8 5/6] iommu/dma: Allow a single FQ in addition to per-CPU
 FQs
Content-Type: text/plain; charset="utf-8"
Message-Id: <20230310-dma_iommu-v8-5-2347dfbed7af@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=13183;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=JAstifVbluVdWhCehVO60V7Fl2xmys/DKEcXsVnxf8s=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGFK4Q197dZoH+7i4WD177SIwv2xW7paswEser2w1Ov49D
 g189LCwo5SFQYyDQVZMkWVRl7PfuoIppnuC+jtg5rAygQxh4OIUgIlwrmP4K62W5NVwYN0eXsuF
 26z3mnxoTj33ztFNbW5iu/2cjI2VEowMJ9sPiddt0vz9OGj6W0Edg2N/mjO+RfLYTOBlrNMJFdd
 jBQA=
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6yYApsGmwgQ7PqAgHw9Co9i25sHtAVtK
X-Proofpoint-GUID: gkbNqMxh_14xMZ-eDg8Yk25k3TIQQJ9M
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_06,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 clxscore=1015 spamscore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=968 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some virtualized environments, including s390 paged memory guests,
IOTLB flushes are used to update IOMMU shadow tables. Due to this, they
are much more expensive than in typical bare metal environments or
non-paged s390 guests. In addition they may parallelize more poorly in
virtualized environments. This changes the trade off for flushing IOVAs
such that minimizing the number of IOTLB flushes trumps any benefit of
cheaper queuing operations or increased paralellism.

In this scenario per-CPU flush queues pose several problems. Firstly
per-CPU memory is often quite limited prohibiting larger queues.
Secondly collecting IOVAs per-CPU but flushing via a global timeout
reduces the number of IOVAs flushed for each timeout especially on s390
where PCI interrupts may not be bound to a specific CPU.

Let's introduce a single flush queue mode that reuses the same queue
logic but only allocates a single global queue. This mode can be
selected as a flag bit in a new dma_iommu_options struct which can be
modified from its defaults by IOMMU drivers implementing a new
ops.tune_dma_iommu() callback. As a first user the s390 IOMMU driver
selects the single queue mode if IOTLB flushes are needed on map which
indicates shadow table use. With the unchanged small FQ size and
timeouts this setting is worse than per-CPU queues but a follow up patch
will make the FQ size and timeout variable. Together this allows the
common IOVA flushing code to more closely resemble the global flush
behavior used on s390's previous internal DMA API implementation.

Link: https://lore.kernel.org/linux-iommu/3e402947-61f9-b7e8-1414-fde006257b6f@arm.com/
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com> #s390
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 drivers/iommu/dma-iommu.c  | 161 ++++++++++++++++++++++++++++++++++-----------
 drivers/iommu/dma-iommu.h  |   4 +-
 drivers/iommu/iommu.c      |   4 +-
 drivers/iommu/s390-iommu.c |  10 +++
 include/linux/iommu.h      |  21 ++++++
 5 files changed, 157 insertions(+), 43 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 99b2646cb5c7..6f5fd110e0e0 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -49,8 +49,11 @@ struct iommu_dma_cookie {
 		/* Full allocator for IOMMU_DMA_IOVA_COOKIE */
 		struct {
 			struct iova_domain	iovad;
-
-			struct iova_fq __percpu *fq;	/* Flush queue */
+			/* Flush queue */
+			union {
+				struct iova_fq	*single_fq;
+				struct iova_fq	__percpu *percpu_fq;
+			};
 			/* Number of TLB flushes that have been started */
 			atomic64_t		fq_flush_start_cnt;
 			/* Number of TLB flushes that have been finished */
@@ -67,6 +70,8 @@ struct iommu_dma_cookie {
 
 	/* Domain for flush queue callback; NULL if flush queue not in use */
 	struct iommu_domain		*fq_domain;
+	/* Options for dma-iommu use */
+	struct dma_iommu_options	options;
 	struct mutex			mutex;
 };
 
@@ -152,25 +157,44 @@ static void fq_flush_iotlb(struct iommu_dma_cookie *cookie)
 	atomic64_inc(&cookie->fq_flush_finish_cnt);
 }
 
-static void fq_flush_timeout(struct timer_list *t)
+static void fq_flush_percpu(struct iommu_dma_cookie *cookie)
 {
-	struct iommu_dma_cookie *cookie = from_timer(cookie, t, fq_timer);
 	int cpu;
 
-	atomic_set(&cookie->fq_timer_on, 0);
-	fq_flush_iotlb(cookie);
-
 	for_each_possible_cpu(cpu) {
 		unsigned long flags;
 		struct iova_fq *fq;
 
-		fq = per_cpu_ptr(cookie->fq, cpu);
+		fq = per_cpu_ptr(cookie->percpu_fq, cpu);
 		spin_lock_irqsave(&fq->lock, flags);
 		fq_ring_free(cookie, fq);
 		spin_unlock_irqrestore(&fq->lock, flags);
 	}
 }
 
+static void fq_flush_single(struct iommu_dma_cookie *cookie)
+{
+	struct iova_fq *fq = cookie->single_fq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fq->lock, flags);
+	fq_ring_free(cookie, fq);
+	spin_unlock_irqrestore(&fq->lock, flags);
+}
+
+static void fq_flush_timeout(struct timer_list *t)
+{
+	struct iommu_dma_cookie *cookie = from_timer(cookie, t, fq_timer);
+
+	atomic_set(&cookie->fq_timer_on, 0);
+	fq_flush_iotlb(cookie);
+
+	if (cookie->options.flags & IOMMU_DMA_OPTS_SINGLE_QUEUE)
+		fq_flush_single(cookie);
+	else
+		fq_flush_percpu(cookie);
+}
+
 static void queue_iova(struct iommu_dma_cookie *cookie,
 		unsigned long pfn, unsigned long pages,
 		struct list_head *freelist)
@@ -188,7 +212,11 @@ static void queue_iova(struct iommu_dma_cookie *cookie,
 	 */
 	smp_mb();
 
-	fq = raw_cpu_ptr(cookie->fq);
+	if (cookie->options.flags & IOMMU_DMA_OPTS_SINGLE_QUEUE)
+		fq = cookie->single_fq;
+	else
+		fq = raw_cpu_ptr(cookie->percpu_fq);
+
 	spin_lock_irqsave(&fq->lock, flags);
 
 	/*
@@ -219,58 +247,114 @@ static void queue_iova(struct iommu_dma_cookie *cookie,
 			  jiffies + msecs_to_jiffies(IOVA_FQ_TIMEOUT));
 }
 
-static void iommu_dma_free_fq(struct iommu_dma_cookie *cookie)
+static void iommu_dma_free_fq_single(struct iova_fq *fq)
 {
-	int cpu, idx;
+	int idx;
 
-	if (!cookie->fq)
+	if (!fq)
 		return;
+	fq_ring_for_each(idx, fq)
+		put_pages_list(&fq->entries[idx].freelist);
+	vfree(fq);
+}
+
+static void iommu_dma_free_fq_percpu(struct iova_fq __percpu *percpu_fq)
+{
+	int cpu, idx;
 
-	del_timer_sync(&cookie->fq_timer);
 	/* The IOVAs will be torn down separately, so just free our queued pages */
 	for_each_possible_cpu(cpu) {
-		struct iova_fq *fq = per_cpu_ptr(cookie->fq, cpu);
+		struct iova_fq *fq = per_cpu_ptr(percpu_fq, cpu);
 
 		fq_ring_for_each(idx, fq)
 			put_pages_list(&fq->entries[idx].freelist);
 	}
 
-	free_percpu(cookie->fq);
+	free_percpu(percpu_fq);
+}
+
+static void iommu_dma_free_fq(struct iommu_dma_cookie *cookie)
+{
+	if (!cookie->fq_domain)
+		return;
+
+	del_timer_sync(&cookie->fq_timer);
+	if (cookie->options.flags & IOMMU_DMA_OPTS_SINGLE_QUEUE)
+		iommu_dma_free_fq_single(cookie->single_fq);
+	else
+		iommu_dma_free_fq_percpu(cookie->percpu_fq);
+}
+
+
+static void iommu_dma_init_one_fq(struct iova_fq *fq)
+{
+	int i;
+
+	fq->head = 0;
+	fq->tail = 0;
+
+	spin_lock_init(&fq->lock);
+
+	for (i = 0; i < IOVA_FQ_SIZE; i++)
+		INIT_LIST_HEAD(&fq->entries[i].freelist);
+}
+
+static int iommu_dma_init_fq_single(struct iommu_dma_cookie *cookie)
+{
+	struct iova_fq *queue;
+
+	queue = vzalloc(sizeof(*queue));
+	if (!queue)
+		return -ENOMEM;
+	iommu_dma_init_one_fq(queue);
+	cookie->single_fq = queue;
+
+	return 0;
+}
+
+static int iommu_dma_init_fq_percpu(struct iommu_dma_cookie *cookie)
+{
+	struct iova_fq __percpu *queue;
+	int cpu;
+
+	queue = alloc_percpu(struct iova_fq);
+	if (!queue)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu)
+		iommu_dma_init_one_fq(per_cpu_ptr(queue, cpu));
+	cookie->percpu_fq = queue;
+	return 0;
 }
 
 /* sysfs updates are serialised by the mutex of the group owning @domain */
-int iommu_dma_init_fq(struct iommu_domain *domain)
+int iommu_dma_init_fq(struct device *dev, struct iommu_domain *domain)
 {
 	struct iommu_dma_cookie *cookie = domain->iova_cookie;
-	struct iova_fq __percpu *queue;
-	int i, cpu;
+	const struct iommu_ops *ops = dev_iommu_ops(dev);
+	int rc;
 
 	if (cookie->fq_domain)
 		return 0;
 
+	if (ops->tune_dma_iommu)
+		ops->tune_dma_iommu(dev, &cookie->options);
+
 	atomic64_set(&cookie->fq_flush_start_cnt,  0);
 	atomic64_set(&cookie->fq_flush_finish_cnt, 0);
 
-	queue = alloc_percpu(struct iova_fq);
-	if (!queue) {
-		pr_warn("iova flush queue initialization failed\n");
-		return -ENOMEM;
-	}
-
-	for_each_possible_cpu(cpu) {
-		struct iova_fq *fq = per_cpu_ptr(queue, cpu);
-
-		fq->head = 0;
-		fq->tail = 0;
-
-		spin_lock_init(&fq->lock);
+	if (cookie->options.flags & IOMMU_DMA_OPTS_SINGLE_QUEUE)
+		rc = iommu_dma_init_fq_single(cookie);
+	else
+		rc = iommu_dma_init_fq_percpu(cookie);
 
-		for (i = 0; i < IOVA_FQ_SIZE; i++)
-			INIT_LIST_HEAD(&fq->entries[i].freelist);
+	if (rc) {
+		pr_warn("iova flush queue initialization failed\n");
+		/* fall back to strict mode */
+		domain->type = IOMMU_DOMAIN_DMA;
+		return rc;
 	}
 
-	cookie->fq = queue;
-
 	timer_setup(&cookie->fq_timer, fq_flush_timeout, 0);
 	atomic_set(&cookie->fq_timer_on, 0);
 	/*
@@ -297,6 +381,7 @@ static struct iommu_dma_cookie *cookie_alloc(enum iommu_dma_cookie_type type)
 	if (cookie) {
 		INIT_LIST_HEAD(&cookie->msi_page_list);
 		cookie->type = type;
+		cookie->options.flags = IOMMU_DMA_OPTS_PER_CPU_QUEUE;
 	}
 	return cookie;
 }
@@ -585,9 +670,9 @@ static int iommu_dma_init_domain(struct iommu_domain *domain, dma_addr_t base,
 	if (ret)
 		goto done_unlock;
 
-	/* If the FQ fails we can simply fall back to strict mode */
-	if (domain->type == IOMMU_DOMAIN_DMA_FQ && iommu_dma_init_fq(domain))
-		domain->type = IOMMU_DOMAIN_DMA;
+	/* If the FQ fails we fall back to strict mode */
+	if (domain->type == IOMMU_DOMAIN_DMA_FQ)
+		iommu_dma_init_fq(dev, domain);
 
 	ret = iova_reserve_iommu_regions(dev, domain);
 
diff --git a/drivers/iommu/dma-iommu.h b/drivers/iommu/dma-iommu.h
index 942790009292..4f727ab56d3c 100644
--- a/drivers/iommu/dma-iommu.h
+++ b/drivers/iommu/dma-iommu.h
@@ -12,7 +12,7 @@
 int iommu_get_dma_cookie(struct iommu_domain *domain);
 void iommu_put_dma_cookie(struct iommu_domain *domain);
 
-int iommu_dma_init_fq(struct iommu_domain *domain);
+int iommu_dma_init_fq(struct device *dev, struct iommu_domain *domain);
 
 void iommu_dma_get_resv_regions(struct device *dev, struct list_head *list);
 
@@ -20,7 +20,7 @@ extern bool iommu_dma_forcedac;
 
 #else /* CONFIG_IOMMU_DMA */
 
-static inline int iommu_dma_init_fq(struct iommu_domain *domain)
+static inline int iommu_dma_init_fq(struct device *dev, struct iommu_domain *domain)
 {
 	return -EINVAL;
 }
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ae549b032a16..869dd0b6e1f3 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2920,9 +2920,7 @@ static int iommu_change_dev_def_domain(struct iommu_group *group,
 
 	/* We can bring up a flush queue without tearing down the domain */
 	if (type == IOMMU_DOMAIN_DMA_FQ && prev_dom->type == IOMMU_DOMAIN_DMA) {
-		ret = iommu_dma_init_fq(prev_dom);
-		if (!ret)
-			prev_dom->type = IOMMU_DOMAIN_DMA_FQ;
+		ret = iommu_dma_init_fq(dev, prev_dom);
 		goto out;
 	}
 
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index 161b0be5aba6..65dd469ad524 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -451,6 +451,15 @@ static void s390_iommu_get_resv_regions(struct device *dev,
 	}
 }
 
+static void s390_iommu_tune_dma_iommu(struct device *dev,
+					     struct dma_iommu_options *options)
+{
+	struct zpci_dev *zdev = to_zpci_dev(dev);
+
+	if (zdev->tlb_refresh)
+		options->flags |= IOMMU_DMA_OPTS_SINGLE_QUEUE;
+}
+
 static struct iommu_device *s390_iommu_probe_device(struct device *dev)
 {
 	struct zpci_dev *zdev;
@@ -793,6 +802,7 @@ static const struct iommu_ops s390_iommu_ops = {
 	.device_group = generic_device_group,
 	.pgsize_bitmap = SZ_4K,
 	.get_resv_regions = s390_iommu_get_resv_regions,
+	.tune_dma_iommu = s390_iommu_tune_dma_iommu,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev	= s390_iommu_attach_device,
 		.map_pages	= s390_iommu_map_pages,
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 932e5532ee33..2b43a3de2c4f 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -219,6 +219,21 @@ struct iommu_iotlb_gather {
 	bool			queued;
 };
 
+/**
+ * struct dma_iommu_options - Options for dma-iommu
+ *
+ * @flags: Flag bits for enabling/disabling dma-iommu settings
+ *
+ * This structure is intended to provide IOMMU drivers a way to influence the
+ * behavior of the dma-iommu DMA API implementation. This allows optimizing for
+ * example for a virtualized environment with slow IOTLB flushes.
+ */
+struct dma_iommu_options {
+#define IOMMU_DMA_OPTS_PER_CPU_QUEUE	(0L << 0)
+#define IOMMU_DMA_OPTS_SINGLE_QUEUE	(1L << 0)
+	u64	flags;
+};
+
 /**
  * struct iommu_ops - iommu ops and capabilities
  * @capable: check capability
@@ -242,6 +257,9 @@ struct iommu_iotlb_gather {
  *		- IOMMU_DOMAIN_IDENTITY: must use an identity domain
  *		- IOMMU_DOMAIN_DMA: must use a dma domain
  *		- 0: use the default setting
+ * @tune_dma_iommu: Allows the IOMMU driver to modify the default
+ *		    options of the dma-iommu layer for a specific
+ *		    device.
  * @default_domain_ops: the default ops for domains
  * @remove_dev_pasid: Remove any translation configurations of a specific
  *                    pasid, so that any DMA transactions with this pasid
@@ -278,6 +296,9 @@ struct iommu_ops {
 	int (*def_domain_type)(struct device *dev);
 	void (*remove_dev_pasid)(struct device *dev, ioasid_t pasid);
 
+	void (*tune_dma_iommu)(struct device *dev,
+			       struct dma_iommu_options *options);
+
 	const struct iommu_domain_ops *default_domain_ops;
 	unsigned long pgsize_bitmap;
 	struct module *owner;

-- 
2.37.2

