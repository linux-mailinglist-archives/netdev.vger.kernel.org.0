Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423CA6B4C50
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbjCJQMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjCJQMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:12:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B45011D093;
        Fri, 10 Mar 2023 08:09:47 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32AEkDn7010657;
        Fri, 10 Mar 2023 16:08:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : date : subject :
 mime-version : content-type : content-transfer-encoding : message-id :
 references : in-reply-to : to : cc; s=pp1;
 bh=31eQqFqSBHQBLaAa175f3jOb4c9mAuS5Z08suCpA/cI=;
 b=oesSnZ+WBWCC6tV4CA1nPvEEPUhuU6fg8ijzde0i5cJ/yi6Q+Wq1DuraDgY5Pq5ub64/
 +iCdiZxegrL7kL/M/2ifVNQwmu6LN7aFgXjqhtA8sW2Cn0LQk9U3rUNJ72gdGtqWDdkA
 iyH7aBB1OeiyzKcn5hzxtZpSA38x2ggdfNQesrlJyJynaBsh0k4iqcwYX9uFFyWfPaWh
 34LAi35sSHqtCdS64j/lj0ref0fsDq4IsqYWIv/foq6oi+hzZE00t0+FlgB5sqwSC+eG
 Lcq0zeZEmIyzvbAHG4n4Gl2o9tnkYPraHfNe0q9x+p/oMrzINHv05fhSe0rC9xkhUP/+ 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p86kk2642-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 16:08:29 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32AEl0PU012777;
        Fri, 10 Mar 2023 16:08:28 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p86kk2632-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 16:08:28 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32A8JxVu030496;
        Fri, 10 Mar 2023 16:08:25 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3p6g8642fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 16:08:24 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32AG8KZA656038
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 16:08:21 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2A9220040;
        Fri, 10 Mar 2023 16:08:20 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 478522004D;
        Fri, 10 Mar 2023 16:08:19 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 10 Mar 2023 16:08:19 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Date:   Fri, 10 Mar 2023 17:07:49 +0100
Subject: [PATCH v8 4/6] s390/pci: Use dma-iommu layer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230310-dma_iommu-v8-4-2347dfbed7af@linux.ibm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=48697;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=9nfEB5FShrwfsD4DxSc1Oc1QywIMxAK3Gldw4Q0Q0iM=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGFK4Q199t2Mq2NKwzjdTxdr8zIv7AhGdds+3TM9oqhNPq
 TfmapXqKGVhEONgkBVTZFnU5ey3rmCK6Z6g/g6YOaxMIEMYuDgFYCLblBkZFnvkbdnUHJIZuUyd
 J/9lk8+fDSUWZuZH/s4ROTq5v2yHMSNDT6pB8mH19fW27U/OaR3fd4zxd+sRd/6mLIdVcb//ej5
 jBgA=
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tWftGUbu8CgEnmNUaQiLVtwY7ngAGxjF
X-Proofpoint-GUID: 8xSHAsx7myT7NvnbdX4xGzY0NPhIW06E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_07,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0 suspectscore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303100124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While s390 already has a standard IOMMU driver and previous changes have
added I/O TLB flushing operations this driver is currently only used for
user-space PCI access such as vfio-pci. For the DMA API s390 instead
utilizes its own implementation in arch/s390/pci/pci_dma.c which drives
the same hardware and shares some code but requires a complex and
fragile hand over between DMA API and IOMMU API use of a device and
despite code sharing still leads to significant duplication and
maintenance effort. Let's utilize the common code DMAP API
implementation from drivers/iommu/dma-iommu.c instead allowing us to
get rid of arch/s390/pci/pci_dma.c.

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
---
 Documentation/admin-guide/kernel-parameters.txt |   9 +-
 arch/s390/include/asm/pci.h                     |   7 -
 arch/s390/include/asm/pci_clp.h                 |   3 +
 arch/s390/include/asm/pci_dma.h                 | 121 +---
 arch/s390/pci/Makefile                          |   2 +-
 arch/s390/pci/pci.c                             |  22 +-
 arch/s390/pci/pci_bus.c                         |   5 -
 arch/s390/pci/pci_debug.c                       |  12 +-
 arch/s390/pci/pci_dma.c                         | 735 ------------------------
 arch/s390/pci/pci_event.c                       |   2 -
 arch/s390/pci/pci_sysfs.c                       |  19 +-
 drivers/iommu/Kconfig                           |   4 +-
 drivers/iommu/s390-iommu.c                      | 390 ++++++++++++-
 13 files changed, 407 insertions(+), 924 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6221a1d057dd..dd832f2c9495 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2149,7 +2149,7 @@
 			  forcing Dual Address Cycle for PCI cards supporting
 			  greater than 32-bit addressing.
 
-	iommu.strict=	[ARM64, X86] Configure TLB invalidation behaviour
+	iommu.strict=	[ARM64, X86, S390] Configure TLB invalidation behaviour
 			Format: { "0" | "1" }
 			0 - Lazy mode.
 			  Request that DMA unmap operations use deferred
@@ -5435,9 +5435,10 @@
 	s390_iommu=	[HW,S390]
 			Set s390 IOTLB flushing mode
 		strict
-			With strict flushing every unmap operation will result in
-			an IOTLB flush. Default is lazy flushing before reuse,
-			which is faster.
+			With strict flushing every unmap operation will result
+			in an IOTLB flush. Default is lazy flushing before
+			reuse, which is faster. Deprecated, equivalent to
+			iommu.strict=1.
 
 	s390_iommu_aperture=	[KNL,S390]
 			Specifies the size of the per device DMA address space
diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index b248694e0024..3f74f1cf37df 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -159,13 +159,6 @@ struct zpci_dev {
 	unsigned long	*dma_table;
 	int		tlb_refresh;
 
-	spinlock_t	iommu_bitmap_lock;
-	unsigned long	*iommu_bitmap;
-	unsigned long	*lazy_bitmap;
-	unsigned long	iommu_size;
-	unsigned long	iommu_pages;
-	unsigned int	next_bit;
-
 	struct iommu_device iommu_dev;  /* IOMMU core handle */
 
 	char res_name[16];
diff --git a/arch/s390/include/asm/pci_clp.h b/arch/s390/include/asm/pci_clp.h
index d6189ed14f84..f0c677ddd270 100644
--- a/arch/s390/include/asm/pci_clp.h
+++ b/arch/s390/include/asm/pci_clp.h
@@ -50,6 +50,9 @@ struct clp_fh_list_entry {
 #define CLP_UTIL_STR_LEN	64
 #define CLP_PFIP_NR_SEGMENTS	4
 
+/* PCI function type numbers */
+#define PCI_FUNC_TYPE_ISM	0x5	/* ISM device */
+
 extern bool zpci_unique_uid;
 
 struct clp_rsp_slpc_pci {
diff --git a/arch/s390/include/asm/pci_dma.h b/arch/s390/include/asm/pci_dma.h
index 7119c04c51c5..42d7cc4262ca 100644
--- a/arch/s390/include/asm/pci_dma.h
+++ b/arch/s390/include/asm/pci_dma.h
@@ -82,117 +82,16 @@ enum zpci_ioat_dtype {
 #define ZPCI_TABLE_VALID_MASK		0x20
 #define ZPCI_TABLE_PROT_MASK		0x200
 
-static inline unsigned int calc_rtx(dma_addr_t ptr)
-{
-	return ((unsigned long) ptr >> ZPCI_RT_SHIFT) & ZPCI_INDEX_MASK;
-}
-
-static inline unsigned int calc_sx(dma_addr_t ptr)
-{
-	return ((unsigned long) ptr >> ZPCI_ST_SHIFT) & ZPCI_INDEX_MASK;
-}
-
-static inline unsigned int calc_px(dma_addr_t ptr)
-{
-	return ((unsigned long) ptr >> PAGE_SHIFT) & ZPCI_PT_MASK;
-}
-
-static inline void set_pt_pfaa(unsigned long *entry, phys_addr_t pfaa)
-{
-	*entry &= ZPCI_PTE_FLAG_MASK;
-	*entry |= (pfaa & ZPCI_PTE_ADDR_MASK);
-}
-
-static inline void set_rt_sto(unsigned long *entry, phys_addr_t sto)
-{
-	*entry &= ZPCI_RTE_FLAG_MASK;
-	*entry |= (sto & ZPCI_RTE_ADDR_MASK);
-	*entry |= ZPCI_TABLE_TYPE_RTX;
-}
-
-static inline void set_st_pto(unsigned long *entry, phys_addr_t pto)
-{
-	*entry &= ZPCI_STE_FLAG_MASK;
-	*entry |= (pto & ZPCI_STE_ADDR_MASK);
-	*entry |= ZPCI_TABLE_TYPE_SX;
-}
-
-static inline void validate_rt_entry(unsigned long *entry)
-{
-	*entry &= ~ZPCI_TABLE_VALID_MASK;
-	*entry &= ~ZPCI_TABLE_OFFSET_MASK;
-	*entry |= ZPCI_TABLE_VALID;
-	*entry |= ZPCI_TABLE_LEN_RTX;
-}
-
-static inline void validate_st_entry(unsigned long *entry)
-{
-	*entry &= ~ZPCI_TABLE_VALID_MASK;
-	*entry |= ZPCI_TABLE_VALID;
-}
-
-static inline void invalidate_pt_entry(unsigned long *entry)
-{
-	WARN_ON_ONCE((*entry & ZPCI_PTE_VALID_MASK) == ZPCI_PTE_INVALID);
-	*entry &= ~ZPCI_PTE_VALID_MASK;
-	*entry |= ZPCI_PTE_INVALID;
-}
-
-static inline void validate_pt_entry(unsigned long *entry)
-{
-	WARN_ON_ONCE((*entry & ZPCI_PTE_VALID_MASK) == ZPCI_PTE_VALID);
-	*entry &= ~ZPCI_PTE_VALID_MASK;
-	*entry |= ZPCI_PTE_VALID;
-}
-
-static inline void entry_set_protected(unsigned long *entry)
-{
-	*entry &= ~ZPCI_TABLE_PROT_MASK;
-	*entry |= ZPCI_TABLE_PROTECTED;
-}
-
-static inline void entry_clr_protected(unsigned long *entry)
-{
-	*entry &= ~ZPCI_TABLE_PROT_MASK;
-	*entry |= ZPCI_TABLE_UNPROTECTED;
-}
-
-static inline int reg_entry_isvalid(unsigned long entry)
-{
-	return (entry & ZPCI_TABLE_VALID_MASK) == ZPCI_TABLE_VALID;
-}
-
-static inline int pt_entry_isvalid(unsigned long entry)
-{
-	return (entry & ZPCI_PTE_VALID_MASK) == ZPCI_PTE_VALID;
-}
-
-static inline unsigned long *get_rt_sto(unsigned long entry)
-{
-	if ((entry & ZPCI_TABLE_TYPE_MASK) == ZPCI_TABLE_TYPE_RTX)
-		return phys_to_virt(entry & ZPCI_RTE_ADDR_MASK);
-	else
-		return NULL;
-
-}
-
-static inline unsigned long *get_st_pto(unsigned long entry)
-{
-	if ((entry & ZPCI_TABLE_TYPE_MASK) == ZPCI_TABLE_TYPE_SX)
-		return phys_to_virt(entry & ZPCI_STE_ADDR_MASK);
-	else
-		return NULL;
-}
-
-/* Prototypes */
-void dma_free_seg_table(unsigned long);
-unsigned long *dma_alloc_cpu_table(gfp_t gfp);
-void dma_cleanup_tables(unsigned long *);
-unsigned long *dma_walk_cpu_trans(unsigned long *rto, dma_addr_t dma_addr,
-				  gfp_t gfp);
-void dma_update_cpu_trans(unsigned long *entry, phys_addr_t page_addr, int flags);
-
-extern const struct dma_map_ops s390_pci_dma_ops;
+struct zpci_iommu_ctrs {
+	atomic64_t		mapped_pages;
+	atomic64_t		unmapped_pages;
+	atomic64_t		global_rpcits;
+	atomic64_t		sync_map_rpcits;
+	atomic64_t		sync_rpcits;
+};
+
+struct zpci_dev;
 
+struct zpci_iommu_ctrs *zpci_get_iommu_ctrs(struct zpci_dev *zdev);
 
 #endif
diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
index 5ae31ca9dd44..0547a10406e7 100644
--- a/arch/s390/pci/Makefile
+++ b/arch/s390/pci/Makefile
@@ -3,7 +3,7 @@
 # Makefile for the s390 PCI subsystem.
 #
 
-obj-$(CONFIG_PCI)	+= pci.o pci_irq.o pci_dma.o pci_clp.o pci_sysfs.o \
+obj-$(CONFIG_PCI)	+= pci.o pci_irq.o pci_clp.o pci_sysfs.o \
 			   pci_event.o pci_debug.o pci_insn.o pci_mmio.o \
 			   pci_bus.o pci_kvm_hook.o
 obj-$(CONFIG_PCI_IOV)	+= pci_iov.o
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index ef38b1514c77..ec4b41839c22 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -124,7 +124,11 @@ int zpci_register_ioat(struct zpci_dev *zdev, u8 dmaas,
 
 	WARN_ON_ONCE(iota & 0x3fff);
 	fib.pba = base;
-	fib.pal = limit;
+	/* Work around off by one in ISM virt device */
+	if (zdev->pft == PCI_FUNC_TYPE_ISM && limit > base)
+		fib.pal = limit + (1 << 12);
+	else
+		fib.pal = limit;
 	fib.iota = iota | ZPCI_IOTA_RTTO_FLAG;
 	fib.gd = zdev->gisa;
 	cc = zpci_mod_fc(req, &fib, status);
@@ -615,7 +619,6 @@ int pcibios_device_add(struct pci_dev *pdev)
 		pdev->no_vf_scan = 1;
 
 	pdev->dev.groups = zpci_attr_groups;
-	pdev->dev.dma_ops = &s390_pci_dma_ops;
 	zpci_map_resources(pdev);
 
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
@@ -789,8 +792,6 @@ int zpci_hot_reset_device(struct zpci_dev *zdev)
 	if (zdev->dma_table)
 		rc = zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
 					virt_to_phys(zdev->dma_table), &status);
-	else
-		rc = zpci_dma_init_device(zdev);
 	if (rc) {
 		zpci_disable_device(zdev);
 		return rc;
@@ -915,11 +916,6 @@ int zpci_deconfigure_device(struct zpci_dev *zdev)
 	if (zdev->zbus->bus)
 		zpci_bus_remove_device(zdev, false);
 
-	if (zdev->dma_table) {
-		rc = zpci_dma_exit_device(zdev);
-		if (rc)
-			return rc;
-	}
 	if (zdev_enabled(zdev)) {
 		rc = zpci_disable_device(zdev);
 		if (rc)
@@ -968,8 +964,6 @@ void zpci_release_device(struct kref *kref)
 	if (zdev->zbus->bus)
 		zpci_bus_remove_device(zdev, false);
 
-	if (zdev->dma_table)
-		zpci_dma_exit_device(zdev);
 	if (zdev_enabled(zdev))
 		zpci_disable_device(zdev);
 
@@ -1159,10 +1153,6 @@ static int __init pci_base_init(void)
 	if (rc)
 		goto out_irq;
 
-	rc = zpci_dma_init();
-	if (rc)
-		goto out_dma;
-
 	rc = clp_scan_pci_devices();
 	if (rc)
 		goto out_find;
@@ -1172,8 +1162,6 @@ static int __init pci_base_init(void)
 	return 0;
 
 out_find:
-	zpci_dma_exit();
-out_dma:
 	zpci_irq_exit();
 out_irq:
 	zpci_mem_exit();
diff --git a/arch/s390/pci/pci_bus.c b/arch/s390/pci/pci_bus.c
index 6a8da1b742ae..b15ad15999f8 100644
--- a/arch/s390/pci/pci_bus.c
+++ b/arch/s390/pci/pci_bus.c
@@ -49,11 +49,6 @@ static int zpci_bus_prepare_device(struct zpci_dev *zdev)
 		rc = zpci_enable_device(zdev);
 		if (rc)
 			return rc;
-		rc = zpci_dma_init_device(zdev);
-		if (rc) {
-			zpci_disable_device(zdev);
-			return rc;
-		}
 	}
 
 	if (!zdev->has_resources) {
diff --git a/arch/s390/pci/pci_debug.c b/arch/s390/pci/pci_debug.c
index ca6bd98eec13..6dde2263c79d 100644
--- a/arch/s390/pci/pci_debug.c
+++ b/arch/s390/pci/pci_debug.c
@@ -53,9 +53,11 @@ static char *pci_fmt3_names[] = {
 };
 
 static char *pci_sw_names[] = {
-	"Allocated pages",
 	"Mapped pages",
 	"Unmapped pages",
+	"Global RPCITs",
+	"Sync Map RPCITs",
+	"Sync RPCITs",
 };
 
 static void pci_fmb_show(struct seq_file *m, char *name[], int length,
@@ -69,10 +71,14 @@ static void pci_fmb_show(struct seq_file *m, char *name[], int length,
 
 static void pci_sw_counter_show(struct seq_file *m)
 {
-	struct zpci_dev *zdev = m->private;
-	atomic64_t *counter = &zdev->allocated_pages;
+	struct zpci_iommu_ctrs  *ctrs = zpci_get_iommu_ctrs(m->private);
+	atomic64_t *counter;
 	int i;
 
+	if (!ctrs)
+		return;
+
+	counter = &ctrs->mapped_pages;
 	for (i = 0; i < ARRAY_SIZE(pci_sw_names); i++, counter++)
 		seq_printf(m, "%26s:\t%llu\n", pci_sw_names[i],
 			   atomic64_read(counter));
diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
deleted file mode 100644
index 2d9b01d7ca4c..000000000000
--- a/arch/s390/pci/pci_dma.c
+++ /dev/null
@@ -1,735 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright IBM Corp. 2012
- *
- * Author(s):
- *   Jan Glauber <jang@linux.vnet.ibm.com>
- */
-
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/export.h>
-#include <linux/iommu-helper.h>
-#include <linux/dma-map-ops.h>
-#include <linux/vmalloc.h>
-#include <linux/pci.h>
-#include <asm/pci_dma.h>
-
-static struct kmem_cache *dma_region_table_cache;
-static struct kmem_cache *dma_page_table_cache;
-static int s390_iommu_strict;
-static u64 s390_iommu_aperture;
-static u32 s390_iommu_aperture_factor = 1;
-
-static int zpci_refresh_global(struct zpci_dev *zdev)
-{
-	return zpci_refresh_trans((u64) zdev->fh << 32, zdev->start_dma,
-				  zdev->iommu_pages * PAGE_SIZE);
-}
-
-unsigned long *dma_alloc_cpu_table(gfp_t gfp)
-{
-	unsigned long *table, *entry;
-
-	table = kmem_cache_alloc(dma_region_table_cache, gfp);
-	if (!table)
-		return NULL;
-
-	for (entry = table; entry < table + ZPCI_TABLE_ENTRIES; entry++)
-		*entry = ZPCI_TABLE_INVALID;
-	return table;
-}
-
-static void dma_free_cpu_table(void *table)
-{
-	kmem_cache_free(dma_region_table_cache, table);
-}
-
-static unsigned long *dma_alloc_page_table(gfp_t gfp)
-{
-	unsigned long *table, *entry;
-
-	table = kmem_cache_alloc(dma_page_table_cache, gfp);
-	if (!table)
-		return NULL;
-
-	for (entry = table; entry < table + ZPCI_PT_ENTRIES; entry++)
-		*entry = ZPCI_PTE_INVALID;
-	return table;
-}
-
-static void dma_free_page_table(void *table)
-{
-	kmem_cache_free(dma_page_table_cache, table);
-}
-
-static unsigned long *dma_get_seg_table_origin(unsigned long *rtep, gfp_t gfp)
-{
-	unsigned long old_rte, rte;
-	unsigned long *sto;
-
-	rte = READ_ONCE(*rtep);
-	if (reg_entry_isvalid(rte)) {
-		sto = get_rt_sto(rte);
-	} else {
-		sto = dma_alloc_cpu_table(gfp);
-		if (!sto)
-			return NULL;
-
-		set_rt_sto(&rte, virt_to_phys(sto));
-		validate_rt_entry(&rte);
-		entry_clr_protected(&rte);
-
-		old_rte = cmpxchg(rtep, ZPCI_TABLE_INVALID, rte);
-		if (old_rte != ZPCI_TABLE_INVALID) {
-			/* Somone else was faster, use theirs */
-			dma_free_cpu_table(sto);
-			sto = get_rt_sto(old_rte);
-		}
-	}
-	return sto;
-}
-
-static unsigned long *dma_get_page_table_origin(unsigned long *step, gfp_t gfp)
-{
-	unsigned long old_ste, ste;
-	unsigned long *pto;
-
-	ste = READ_ONCE(*step);
-	if (reg_entry_isvalid(ste)) {
-		pto = get_st_pto(ste);
-	} else {
-		pto = dma_alloc_page_table(gfp);
-		if (!pto)
-			return NULL;
-		set_st_pto(&ste, virt_to_phys(pto));
-		validate_st_entry(&ste);
-		entry_clr_protected(&ste);
-
-		old_ste = cmpxchg(step, ZPCI_TABLE_INVALID, ste);
-		if (old_ste != ZPCI_TABLE_INVALID) {
-			/* Somone else was faster, use theirs */
-			dma_free_page_table(pto);
-			pto = get_st_pto(old_ste);
-		}
-	}
-	return pto;
-}
-
-unsigned long *dma_walk_cpu_trans(unsigned long *rto, dma_addr_t dma_addr,
-				  gfp_t gfp)
-{
-	unsigned long *sto, *pto;
-	unsigned int rtx, sx, px;
-
-	rtx = calc_rtx(dma_addr);
-	sto = dma_get_seg_table_origin(&rto[rtx], gfp);
-	if (!sto)
-		return NULL;
-
-	sx = calc_sx(dma_addr);
-	pto = dma_get_page_table_origin(&sto[sx], gfp);
-	if (!pto)
-		return NULL;
-
-	px = calc_px(dma_addr);
-	return &pto[px];
-}
-
-void dma_update_cpu_trans(unsigned long *ptep, phys_addr_t page_addr, int flags)
-{
-	unsigned long pte;
-
-	pte = READ_ONCE(*ptep);
-	if (flags & ZPCI_PTE_INVALID) {
-		invalidate_pt_entry(&pte);
-	} else {
-		set_pt_pfaa(&pte, page_addr);
-		validate_pt_entry(&pte);
-	}
-
-	if (flags & ZPCI_TABLE_PROTECTED)
-		entry_set_protected(&pte);
-	else
-		entry_clr_protected(&pte);
-
-	xchg(ptep, pte);
-}
-
-static int __dma_update_trans(struct zpci_dev *zdev, phys_addr_t pa,
-			      dma_addr_t dma_addr, size_t size, int flags)
-{
-	unsigned int nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
-	phys_addr_t page_addr = (pa & PAGE_MASK);
-	unsigned long *entry;
-	int i, rc = 0;
-
-	if (!nr_pages)
-		return -EINVAL;
-
-	if (!zdev->dma_table)
-		return -EINVAL;
-
-	for (i = 0; i < nr_pages; i++) {
-		entry = dma_walk_cpu_trans(zdev->dma_table, dma_addr,
-					   GFP_ATOMIC);
-		if (!entry) {
-			rc = -ENOMEM;
-			goto undo_cpu_trans;
-		}
-		dma_update_cpu_trans(entry, page_addr, flags);
-		page_addr += PAGE_SIZE;
-		dma_addr += PAGE_SIZE;
-	}
-
-undo_cpu_trans:
-	if (rc && ((flags & ZPCI_PTE_VALID_MASK) == ZPCI_PTE_VALID)) {
-		flags = ZPCI_PTE_INVALID;
-		while (i-- > 0) {
-			page_addr -= PAGE_SIZE;
-			dma_addr -= PAGE_SIZE;
-			entry = dma_walk_cpu_trans(zdev->dma_table, dma_addr,
-						   GFP_ATOMIC);
-			if (!entry)
-				break;
-			dma_update_cpu_trans(entry, page_addr, flags);
-		}
-	}
-	return rc;
-}
-
-static int __dma_purge_tlb(struct zpci_dev *zdev, dma_addr_t dma_addr,
-			   size_t size, int flags)
-{
-	unsigned long irqflags;
-	int ret;
-
-	/*
-	 * With zdev->tlb_refresh == 0, rpcit is not required to establish new
-	 * translations when previously invalid translation-table entries are
-	 * validated. With lazy unmap, rpcit is skipped for previously valid
-	 * entries, but a global rpcit is then required before any address can
-	 * be re-used, i.e. after each iommu bitmap wrap-around.
-	 */
-	if ((flags & ZPCI_PTE_VALID_MASK) == ZPCI_PTE_VALID) {
-		if (!zdev->tlb_refresh)
-			return 0;
-	} else {
-		if (!s390_iommu_strict)
-			return 0;
-	}
-
-	ret = zpci_refresh_trans((u64) zdev->fh << 32, dma_addr,
-				 PAGE_ALIGN(size));
-	if (ret == -ENOMEM && !s390_iommu_strict) {
-		/* enable the hypervisor to free some resources */
-		if (zpci_refresh_global(zdev))
-			goto out;
-
-		spin_lock_irqsave(&zdev->iommu_bitmap_lock, irqflags);
-		bitmap_andnot(zdev->iommu_bitmap, zdev->iommu_bitmap,
-			      zdev->lazy_bitmap, zdev->iommu_pages);
-		bitmap_zero(zdev->lazy_bitmap, zdev->iommu_pages);
-		spin_unlock_irqrestore(&zdev->iommu_bitmap_lock, irqflags);
-		ret = 0;
-	}
-out:
-	return ret;
-}
-
-static int dma_update_trans(struct zpci_dev *zdev, phys_addr_t pa,
-			    dma_addr_t dma_addr, size_t size, int flags)
-{
-	int rc;
-
-	rc = __dma_update_trans(zdev, pa, dma_addr, size, flags);
-	if (rc)
-		return rc;
-
-	rc = __dma_purge_tlb(zdev, dma_addr, size, flags);
-	if (rc && ((flags & ZPCI_PTE_VALID_MASK) == ZPCI_PTE_VALID))
-		__dma_update_trans(zdev, pa, dma_addr, size, ZPCI_PTE_INVALID);
-
-	return rc;
-}
-
-void dma_free_seg_table(unsigned long entry)
-{
-	unsigned long *sto = get_rt_sto(entry);
-	int sx;
-
-	for (sx = 0; sx < ZPCI_TABLE_ENTRIES; sx++)
-		if (reg_entry_isvalid(sto[sx]))
-			dma_free_page_table(get_st_pto(sto[sx]));
-
-	dma_free_cpu_table(sto);
-}
-
-void dma_cleanup_tables(unsigned long *table)
-{
-	int rtx;
-
-	if (!table)
-		return;
-
-	for (rtx = 0; rtx < ZPCI_TABLE_ENTRIES; rtx++)
-		if (reg_entry_isvalid(table[rtx]))
-			dma_free_seg_table(table[rtx]);
-
-	dma_free_cpu_table(table);
-}
-
-static unsigned long __dma_alloc_iommu(struct device *dev,
-				       unsigned long start, int size)
-{
-	struct zpci_dev *zdev = to_zpci(to_pci_dev(dev));
-
-	return iommu_area_alloc(zdev->iommu_bitmap, zdev->iommu_pages,
-				start, size, zdev->start_dma >> PAGE_SHIFT,
-				dma_get_seg_boundary_nr_pages(dev, PAGE_SHIFT),
-				0);
-}
-
-static dma_addr_t dma_alloc_address(struct device *dev, int size)
-{
-	struct zpci_dev *zdev = to_zpci(to_pci_dev(dev));
-	unsigned long offset, flags;
-
-	spin_lock_irqsave(&zdev->iommu_bitmap_lock, flags);
-	offset = __dma_alloc_iommu(dev, zdev->next_bit, size);
-	if (offset == -1) {
-		if (!s390_iommu_strict) {
-			/* global flush before DMA addresses are reused */
-			if (zpci_refresh_global(zdev))
-				goto out_error;
-
-			bitmap_andnot(zdev->iommu_bitmap, zdev->iommu_bitmap,
-				      zdev->lazy_bitmap, zdev->iommu_pages);
-			bitmap_zero(zdev->lazy_bitmap, zdev->iommu_pages);
-		}
-		/* wrap-around */
-		offset = __dma_alloc_iommu(dev, 0, size);
-		if (offset == -1)
-			goto out_error;
-	}
-	zdev->next_bit = offset + size;
-	spin_unlock_irqrestore(&zdev->iommu_bitmap_lock, flags);
-
-	return zdev->start_dma + offset * PAGE_SIZE;
-
-out_error:
-	spin_unlock_irqrestore(&zdev->iommu_bitmap_lock, flags);
-	return DMA_MAPPING_ERROR;
-}
-
-static void dma_free_address(struct device *dev, dma_addr_t dma_addr, int size)
-{
-	struct zpci_dev *zdev = to_zpci(to_pci_dev(dev));
-	unsigned long flags, offset;
-
-	offset = (dma_addr - zdev->start_dma) >> PAGE_SHIFT;
-
-	spin_lock_irqsave(&zdev->iommu_bitmap_lock, flags);
-	if (!zdev->iommu_bitmap)
-		goto out;
-
-	if (s390_iommu_strict)
-		bitmap_clear(zdev->iommu_bitmap, offset, size);
-	else
-		bitmap_set(zdev->lazy_bitmap, offset, size);
-
-out:
-	spin_unlock_irqrestore(&zdev->iommu_bitmap_lock, flags);
-}
-
-static inline void zpci_err_dma(unsigned long rc, unsigned long addr)
-{
-	struct {
-		unsigned long rc;
-		unsigned long addr;
-	} __packed data = {rc, addr};
-
-	zpci_err_hex(&data, sizeof(data));
-}
-
-static dma_addr_t s390_dma_map_pages(struct device *dev, struct page *page,
-				     unsigned long offset, size_t size,
-				     enum dma_data_direction direction,
-				     unsigned long attrs)
-{
-	struct zpci_dev *zdev = to_zpci(to_pci_dev(dev));
-	unsigned long pa = page_to_phys(page) + offset;
-	int flags = ZPCI_PTE_VALID;
-	unsigned long nr_pages;
-	dma_addr_t dma_addr;
-	int ret;
-
-	/* This rounds up number of pages based on size and offset */
-	nr_pages = iommu_num_pages(pa, size, PAGE_SIZE);
-	dma_addr = dma_alloc_address(dev, nr_pages);
-	if (dma_addr == DMA_MAPPING_ERROR) {
-		ret = -ENOSPC;
-		goto out_err;
-	}
-
-	/* Use rounded up size */
-	size = nr_pages * PAGE_SIZE;
-
-	if (direction == DMA_NONE || direction == DMA_TO_DEVICE)
-		flags |= ZPCI_TABLE_PROTECTED;
-
-	ret = dma_update_trans(zdev, pa, dma_addr, size, flags);
-	if (ret)
-		goto out_free;
-
-	atomic64_add(nr_pages, &zdev->mapped_pages);
-	return dma_addr + (offset & ~PAGE_MASK);
-
-out_free:
-	dma_free_address(dev, dma_addr, nr_pages);
-out_err:
-	zpci_err("map error:\n");
-	zpci_err_dma(ret, pa);
-	return DMA_MAPPING_ERROR;
-}
-
-static void s390_dma_unmap_pages(struct device *dev, dma_addr_t dma_addr,
-				 size_t size, enum dma_data_direction direction,
-				 unsigned long attrs)
-{
-	struct zpci_dev *zdev = to_zpci(to_pci_dev(dev));
-	int npages, ret;
-
-	npages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
-	dma_addr = dma_addr & PAGE_MASK;
-	ret = dma_update_trans(zdev, 0, dma_addr, npages * PAGE_SIZE,
-			       ZPCI_PTE_INVALID);
-	if (ret) {
-		zpci_err("unmap error:\n");
-		zpci_err_dma(ret, dma_addr);
-		return;
-	}
-
-	atomic64_add(npages, &zdev->unmapped_pages);
-	dma_free_address(dev, dma_addr, npages);
-}
-
-static void *s390_dma_alloc(struct device *dev, size_t size,
-			    dma_addr_t *dma_handle, gfp_t flag,
-			    unsigned long attrs)
-{
-	struct zpci_dev *zdev = to_zpci(to_pci_dev(dev));
-	struct page *page;
-	phys_addr_t pa;
-	dma_addr_t map;
-
-	size = PAGE_ALIGN(size);
-	page = alloc_pages(flag | __GFP_ZERO, get_order(size));
-	if (!page)
-		return NULL;
-
-	pa = page_to_phys(page);
-	map = s390_dma_map_pages(dev, page, 0, size, DMA_BIDIRECTIONAL, 0);
-	if (dma_mapping_error(dev, map)) {
-		__free_pages(page, get_order(size));
-		return NULL;
-	}
-
-	atomic64_add(size / PAGE_SIZE, &zdev->allocated_pages);
-	if (dma_handle)
-		*dma_handle = map;
-	return phys_to_virt(pa);
-}
-
-static void s390_dma_free(struct device *dev, size_t size,
-			  void *vaddr, dma_addr_t dma_handle,
-			  unsigned long attrs)
-{
-	struct zpci_dev *zdev = to_zpci(to_pci_dev(dev));
-
-	size = PAGE_ALIGN(size);
-	atomic64_sub(size / PAGE_SIZE, &zdev->allocated_pages);
-	s390_dma_unmap_pages(dev, dma_handle, size, DMA_BIDIRECTIONAL, 0);
-	free_pages((unsigned long)vaddr, get_order(size));
-}
-
-/* Map a segment into a contiguous dma address area */
-static int __s390_dma_map_sg(struct device *dev, struct scatterlist *sg,
-			     size_t size, dma_addr_t *handle,
-			     enum dma_data_direction dir)
-{
-	unsigned long nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
-	struct zpci_dev *zdev = to_zpci(to_pci_dev(dev));
-	dma_addr_t dma_addr_base, dma_addr;
-	int flags = ZPCI_PTE_VALID;
-	struct scatterlist *s;
-	phys_addr_t pa = 0;
-	int ret;
-
-	dma_addr_base = dma_alloc_address(dev, nr_pages);
-	if (dma_addr_base == DMA_MAPPING_ERROR)
-		return -ENOMEM;
-
-	dma_addr = dma_addr_base;
-	if (dir == DMA_NONE || dir == DMA_TO_DEVICE)
-		flags |= ZPCI_TABLE_PROTECTED;
-
-	for (s = sg; dma_addr < dma_addr_base + size; s = sg_next(s)) {
-		pa = page_to_phys(sg_page(s));
-		ret = __dma_update_trans(zdev, pa, dma_addr,
-					 s->offset + s->length, flags);
-		if (ret)
-			goto unmap;
-
-		dma_addr += s->offset + s->length;
-	}
-	ret = __dma_purge_tlb(zdev, dma_addr_base, size, flags);
-	if (ret)
-		goto unmap;
-
-	*handle = dma_addr_base;
-	atomic64_add(nr_pages, &zdev->mapped_pages);
-
-	return ret;
-
-unmap:
-	dma_update_trans(zdev, 0, dma_addr_base, dma_addr - dma_addr_base,
-			 ZPCI_PTE_INVALID);
-	dma_free_address(dev, dma_addr_base, nr_pages);
-	zpci_err("map error:\n");
-	zpci_err_dma(ret, pa);
-	return ret;
-}
-
-static int s390_dma_map_sg(struct device *dev, struct scatterlist *sg,
-			   int nr_elements, enum dma_data_direction dir,
-			   unsigned long attrs)
-{
-	struct scatterlist *s = sg, *start = sg, *dma = sg;
-	unsigned int max = dma_get_max_seg_size(dev);
-	unsigned int size = s->offset + s->length;
-	unsigned int offset = s->offset;
-	int count = 0, i, ret;
-
-	for (i = 1; i < nr_elements; i++) {
-		s = sg_next(s);
-
-		s->dma_length = 0;
-
-		if (s->offset || (size & ~PAGE_MASK) ||
-		    size + s->length > max) {
-			ret = __s390_dma_map_sg(dev, start, size,
-						&dma->dma_address, dir);
-			if (ret)
-				goto unmap;
-
-			dma->dma_address += offset;
-			dma->dma_length = size - offset;
-
-			size = offset = s->offset;
-			start = s;
-			dma = sg_next(dma);
-			count++;
-		}
-		size += s->length;
-	}
-	ret = __s390_dma_map_sg(dev, start, size, &dma->dma_address, dir);
-	if (ret)
-		goto unmap;
-
-	dma->dma_address += offset;
-	dma->dma_length = size - offset;
-
-	return count + 1;
-unmap:
-	for_each_sg(sg, s, count, i)
-		s390_dma_unmap_pages(dev, sg_dma_address(s), sg_dma_len(s),
-				     dir, attrs);
-
-	return ret;
-}
-
-static void s390_dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-			      int nr_elements, enum dma_data_direction dir,
-			      unsigned long attrs)
-{
-	struct scatterlist *s;
-	int i;
-
-	for_each_sg(sg, s, nr_elements, i) {
-		if (s->dma_length)
-			s390_dma_unmap_pages(dev, s->dma_address, s->dma_length,
-					     dir, attrs);
-		s->dma_address = 0;
-		s->dma_length = 0;
-	}
-}
-	
-int zpci_dma_init_device(struct zpci_dev *zdev)
-{
-	u8 status;
-	int rc;
-
-	/*
-	 * At this point, if the device is part of an IOMMU domain, this would
-	 * be a strong hint towards a bug in the IOMMU API (common) code and/or
-	 * simultaneous access via IOMMU and DMA API. So let's issue a warning.
-	 */
-	WARN_ON(zdev->s390_domain);
-
-	spin_lock_init(&zdev->iommu_bitmap_lock);
-
-	zdev->dma_table = dma_alloc_cpu_table(GFP_KERNEL);
-	if (!zdev->dma_table) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	/*
-	 * Restrict the iommu bitmap size to the minimum of the following:
-	 * - s390_iommu_aperture which defaults to high_memory
-	 * - 3-level pagetable address limit minus start_dma offset
-	 * - DMA address range allowed by the hardware (clp query pci fn)
-	 *
-	 * Also set zdev->end_dma to the actual end address of the usable
-	 * range, instead of the theoretical maximum as reported by hardware.
-	 *
-	 * This limits the number of concurrently usable DMA mappings since
-	 * for each DMA mapped memory address we need a DMA address including
-	 * extra DMA addresses for multiple mappings of the same memory address.
-	 */
-	zdev->start_dma = PAGE_ALIGN(zdev->start_dma);
-	zdev->iommu_size = min3(s390_iommu_aperture,
-				ZPCI_TABLE_SIZE_RT - zdev->start_dma,
-				zdev->end_dma - zdev->start_dma + 1);
-	zdev->end_dma = zdev->start_dma + zdev->iommu_size - 1;
-	zdev->iommu_pages = zdev->iommu_size >> PAGE_SHIFT;
-	zdev->iommu_bitmap = vzalloc(zdev->iommu_pages / 8);
-	if (!zdev->iommu_bitmap) {
-		rc = -ENOMEM;
-		goto free_dma_table;
-	}
-	if (!s390_iommu_strict) {
-		zdev->lazy_bitmap = vzalloc(zdev->iommu_pages / 8);
-		if (!zdev->lazy_bitmap) {
-			rc = -ENOMEM;
-			goto free_bitmap;
-		}
-
-	}
-	if (zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
-			       virt_to_phys(zdev->dma_table), &status)) {
-		rc = -EIO;
-		goto free_bitmap;
-	}
-
-	return 0;
-free_bitmap:
-	vfree(zdev->iommu_bitmap);
-	zdev->iommu_bitmap = NULL;
-	vfree(zdev->lazy_bitmap);
-	zdev->lazy_bitmap = NULL;
-free_dma_table:
-	dma_free_cpu_table(zdev->dma_table);
-	zdev->dma_table = NULL;
-out:
-	return rc;
-}
-
-int zpci_dma_exit_device(struct zpci_dev *zdev)
-{
-	int cc = 0;
-
-	/*
-	 * At this point, if the device is part of an IOMMU domain, this would
-	 * be a strong hint towards a bug in the IOMMU API (common) code and/or
-	 * simultaneous access via IOMMU and DMA API. So let's issue a warning.
-	 */
-	WARN_ON(zdev->s390_domain);
-	if (zdev_enabled(zdev))
-		cc = zpci_unregister_ioat(zdev, 0);
-	/*
-	 * cc == 3 indicates the function is gone already. This can happen
-	 * if the function was deconfigured/disabled suddenly and we have not
-	 * received a new handle yet.
-	 */
-	if (cc && cc != 3)
-		return -EIO;
-
-	dma_cleanup_tables(zdev->dma_table);
-	zdev->dma_table = NULL;
-	vfree(zdev->iommu_bitmap);
-	zdev->iommu_bitmap = NULL;
-	vfree(zdev->lazy_bitmap);
-	zdev->lazy_bitmap = NULL;
-	zdev->next_bit = 0;
-	return 0;
-}
-
-static int __init dma_alloc_cpu_table_caches(void)
-{
-	dma_region_table_cache = kmem_cache_create("PCI_DMA_region_tables",
-					ZPCI_TABLE_SIZE, ZPCI_TABLE_ALIGN,
-					0, NULL);
-	if (!dma_region_table_cache)
-		return -ENOMEM;
-
-	dma_page_table_cache = kmem_cache_create("PCI_DMA_page_tables",
-					ZPCI_PT_SIZE, ZPCI_PT_ALIGN,
-					0, NULL);
-	if (!dma_page_table_cache) {
-		kmem_cache_destroy(dma_region_table_cache);
-		return -ENOMEM;
-	}
-	return 0;
-}
-
-int __init zpci_dma_init(void)
-{
-	s390_iommu_aperture = (u64)virt_to_phys(high_memory);
-	if (!s390_iommu_aperture_factor)
-		s390_iommu_aperture = ULONG_MAX;
-	else
-		s390_iommu_aperture *= s390_iommu_aperture_factor;
-
-	return dma_alloc_cpu_table_caches();
-}
-
-void zpci_dma_exit(void)
-{
-	kmem_cache_destroy(dma_page_table_cache);
-	kmem_cache_destroy(dma_region_table_cache);
-}
-
-const struct dma_map_ops s390_pci_dma_ops = {
-	.alloc		= s390_dma_alloc,
-	.free		= s390_dma_free,
-	.map_sg		= s390_dma_map_sg,
-	.unmap_sg	= s390_dma_unmap_sg,
-	.map_page	= s390_dma_map_pages,
-	.unmap_page	= s390_dma_unmap_pages,
-	.mmap		= dma_common_mmap,
-	.get_sgtable	= dma_common_get_sgtable,
-	.alloc_pages	= dma_common_alloc_pages,
-	.free_pages	= dma_common_free_pages,
-	/* dma_supported is unconditionally true without a callback */
-};
-EXPORT_SYMBOL_GPL(s390_pci_dma_ops);
-
-static int __init s390_iommu_setup(char *str)
-{
-	if (!strcmp(str, "strict"))
-		s390_iommu_strict = 1;
-	return 1;
-}
-
-__setup("s390_iommu=", s390_iommu_setup);
-
-static int __init s390_iommu_aperture_setup(char *str)
-{
-	if (kstrtou32(str, 10, &s390_iommu_aperture_factor))
-		s390_iommu_aperture_factor = 1;
-	return 1;
-}
-
-__setup("s390_iommu_aperture=", s390_iommu_aperture_setup);
diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
index 4ef5a6a1d618..4d9773ef9e0a 100644
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -313,8 +313,6 @@ static void zpci_event_hard_deconfigured(struct zpci_dev *zdev, u32 fh)
 	/* Even though the device is already gone we still
 	 * need to free zPCI resources as part of the disable.
 	 */
-	if (zdev->dma_table)
-		zpci_dma_exit_device(zdev);
 	if (zdev_enabled(zdev))
 		zpci_disable_device(zdev);
 	zdev->state = ZPCI_FN_STATE_STANDBY;
diff --git a/arch/s390/pci/pci_sysfs.c b/arch/s390/pci/pci_sysfs.c
index cae280e5c047..8a7abac51816 100644
--- a/arch/s390/pci/pci_sysfs.c
+++ b/arch/s390/pci/pci_sysfs.c
@@ -56,6 +56,7 @@ static ssize_t recover_store(struct device *dev, struct device_attribute *attr,
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct zpci_dev *zdev = to_zpci(pdev);
 	int ret = 0;
+	u8 status;
 
 	/* Can't use device_remove_self() here as that would lead us to lock
 	 * the pci_rescan_remove_lock while holding the device' kernfs lock.
@@ -82,12 +83,6 @@ static ssize_t recover_store(struct device *dev, struct device_attribute *attr,
 	pci_lock_rescan_remove();
 	if (pci_dev_is_added(pdev)) {
 		pci_stop_and_remove_bus_device(pdev);
-		if (zdev->dma_table) {
-			ret = zpci_dma_exit_device(zdev);
-			if (ret)
-				goto out;
-		}
-
 		if (zdev_enabled(zdev)) {
 			ret = zpci_disable_device(zdev);
 			/*
@@ -105,14 +100,16 @@ static ssize_t recover_store(struct device *dev, struct device_attribute *attr,
 		ret = zpci_enable_device(zdev);
 		if (ret)
 			goto out;
-		ret = zpci_dma_init_device(zdev);
-		if (ret) {
-			zpci_disable_device(zdev);
-			goto out;
+
+		if (zdev->dma_table) {
+			ret = zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
+						 virt_to_phys(zdev->dma_table), &status);
+			if (ret)
+				zpci_disable_device(zdev);
 		}
-		pci_rescan_bus(zdev->zbus->bus);
 	}
 out:
+	pci_rescan_bus(zdev->zbus->bus);
 	pci_unlock_rescan_remove();
 	if (kn)
 		sysfs_unbreak_active_protection(kn);
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 889c7efd050b..7fe48b643831 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -95,7 +95,7 @@ config IOMMU_DEBUGFS
 choice
 	prompt "IOMMU default domain type"
 	depends on IOMMU_API
-	default IOMMU_DEFAULT_DMA_LAZY if X86 || IA64
+	default IOMMU_DEFAULT_DMA_LAZY if X86 || IA64 || S390
 	default IOMMU_DEFAULT_DMA_STRICT
 	help
 	  Choose the type of IOMMU domain used to manage DMA API usage by
@@ -150,7 +150,7 @@ config OF_IOMMU
 
 # IOMMU-agnostic DMA-mapping layer
 config IOMMU_DMA
-	def_bool ARM64 || IA64 || X86
+	def_bool ARM64 || IA64 || X86 || S390
 	select DMA_OPS
 	select IOMMU_API
 	select IOMMU_IOVA
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index 17174b35db11..161b0be5aba6 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -14,16 +14,300 @@
 #include <linux/rcupdate.h>
 #include <asm/pci_dma.h>
 
+#include "dma-iommu.h"
+
 static const struct iommu_ops s390_iommu_ops;
 
+static struct kmem_cache *dma_region_table_cache;
+static struct kmem_cache *dma_page_table_cache;
+
+static u64 s390_iommu_aperture;
+static u32 s390_iommu_aperture_factor = 1;
+
 struct s390_domain {
 	struct iommu_domain	domain;
 	struct list_head	devices;
+	struct zpci_iommu_ctrs	ctrs;
 	unsigned long		*dma_table;
 	spinlock_t		list_lock;
 	struct rcu_head		rcu;
 };
 
+static inline unsigned int calc_rtx(dma_addr_t ptr)
+{
+	return ((unsigned long)ptr >> ZPCI_RT_SHIFT) & ZPCI_INDEX_MASK;
+}
+
+static inline unsigned int calc_sx(dma_addr_t ptr)
+{
+	return ((unsigned long)ptr >> ZPCI_ST_SHIFT) & ZPCI_INDEX_MASK;
+}
+
+static inline unsigned int calc_px(dma_addr_t ptr)
+{
+	return ((unsigned long)ptr >> PAGE_SHIFT) & ZPCI_PT_MASK;
+}
+
+static inline void set_pt_pfaa(unsigned long *entry, phys_addr_t pfaa)
+{
+	*entry &= ZPCI_PTE_FLAG_MASK;
+	*entry |= (pfaa & ZPCI_PTE_ADDR_MASK);
+}
+
+static inline void set_rt_sto(unsigned long *entry, phys_addr_t sto)
+{
+	*entry &= ZPCI_RTE_FLAG_MASK;
+	*entry |= (sto & ZPCI_RTE_ADDR_MASK);
+	*entry |= ZPCI_TABLE_TYPE_RTX;
+}
+
+static inline void set_st_pto(unsigned long *entry, phys_addr_t pto)
+{
+	*entry &= ZPCI_STE_FLAG_MASK;
+	*entry |= (pto & ZPCI_STE_ADDR_MASK);
+	*entry |= ZPCI_TABLE_TYPE_SX;
+}
+
+static inline void validate_rt_entry(unsigned long *entry)
+{
+	*entry &= ~ZPCI_TABLE_VALID_MASK;
+	*entry &= ~ZPCI_TABLE_OFFSET_MASK;
+	*entry |= ZPCI_TABLE_VALID;
+	*entry |= ZPCI_TABLE_LEN_RTX;
+}
+
+static inline void validate_st_entry(unsigned long *entry)
+{
+	*entry &= ~ZPCI_TABLE_VALID_MASK;
+	*entry |= ZPCI_TABLE_VALID;
+}
+
+static inline void invalidate_pt_entry(unsigned long *entry)
+{
+	WARN_ON_ONCE((*entry & ZPCI_PTE_VALID_MASK) == ZPCI_PTE_INVALID);
+	*entry &= ~ZPCI_PTE_VALID_MASK;
+	*entry |= ZPCI_PTE_INVALID;
+}
+
+static inline void validate_pt_entry(unsigned long *entry)
+{
+	WARN_ON_ONCE((*entry & ZPCI_PTE_VALID_MASK) == ZPCI_PTE_VALID);
+	*entry &= ~ZPCI_PTE_VALID_MASK;
+	*entry |= ZPCI_PTE_VALID;
+}
+
+static inline void entry_set_protected(unsigned long *entry)
+{
+	*entry &= ~ZPCI_TABLE_PROT_MASK;
+	*entry |= ZPCI_TABLE_PROTECTED;
+}
+
+static inline void entry_clr_protected(unsigned long *entry)
+{
+	*entry &= ~ZPCI_TABLE_PROT_MASK;
+	*entry |= ZPCI_TABLE_UNPROTECTED;
+}
+
+static inline int reg_entry_isvalid(unsigned long entry)
+{
+	return (entry & ZPCI_TABLE_VALID_MASK) == ZPCI_TABLE_VALID;
+}
+
+static inline int pt_entry_isvalid(unsigned long entry)
+{
+	return (entry & ZPCI_PTE_VALID_MASK) == ZPCI_PTE_VALID;
+}
+
+static inline unsigned long *get_rt_sto(unsigned long entry)
+{
+	if ((entry & ZPCI_TABLE_TYPE_MASK) == ZPCI_TABLE_TYPE_RTX)
+		return phys_to_virt(entry & ZPCI_RTE_ADDR_MASK);
+	else
+		return NULL;
+}
+
+static inline unsigned long *get_st_pto(unsigned long entry)
+{
+	if ((entry & ZPCI_TABLE_TYPE_MASK) == ZPCI_TABLE_TYPE_SX)
+		return phys_to_virt(entry & ZPCI_STE_ADDR_MASK);
+	else
+		return NULL;
+}
+
+static int __init dma_alloc_cpu_table_caches(void)
+{
+	dma_region_table_cache = kmem_cache_create("PCI_DMA_region_tables",
+						   ZPCI_TABLE_SIZE,
+						   ZPCI_TABLE_ALIGN,
+						   0, NULL);
+	if (!dma_region_table_cache)
+		return -ENOMEM;
+
+	dma_page_table_cache = kmem_cache_create("PCI_DMA_page_tables",
+						 ZPCI_PT_SIZE,
+						 ZPCI_PT_ALIGN,
+						 0, NULL);
+	if (!dma_page_table_cache) {
+		kmem_cache_destroy(dma_region_table_cache);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static unsigned long *dma_alloc_cpu_table(gfp_t gfp)
+{
+	unsigned long *table, *entry;
+
+	table = kmem_cache_alloc(dma_region_table_cache, gfp);
+	if (!table)
+		return NULL;
+
+	for (entry = table; entry < table + ZPCI_TABLE_ENTRIES; entry++)
+		*entry = ZPCI_TABLE_INVALID;
+	return table;
+}
+
+static void dma_free_cpu_table(void *table)
+{
+	kmem_cache_free(dma_region_table_cache, table);
+}
+
+static void dma_free_page_table(void *table)
+{
+	kmem_cache_free(dma_page_table_cache, table);
+}
+
+static void dma_free_seg_table(unsigned long entry)
+{
+	unsigned long *sto = get_rt_sto(entry);
+	int sx;
+
+	for (sx = 0; sx < ZPCI_TABLE_ENTRIES; sx++)
+		if (reg_entry_isvalid(sto[sx]))
+			dma_free_page_table(get_st_pto(sto[sx]));
+
+	dma_free_cpu_table(sto);
+}
+
+static void dma_cleanup_tables(unsigned long *table)
+{
+	int rtx;
+
+	if (!table)
+		return;
+
+	for (rtx = 0; rtx < ZPCI_TABLE_ENTRIES; rtx++)
+		if (reg_entry_isvalid(table[rtx]))
+			dma_free_seg_table(table[rtx]);
+
+	dma_free_cpu_table(table);
+}
+
+static unsigned long *dma_alloc_page_table(gfp_t gfp)
+{
+	unsigned long *table, *entry;
+
+	table = kmem_cache_alloc(dma_page_table_cache, gfp);
+	if (!table)
+		return NULL;
+
+	for (entry = table; entry < table + ZPCI_PT_ENTRIES; entry++)
+		*entry = ZPCI_PTE_INVALID;
+	return table;
+}
+
+static unsigned long *dma_get_seg_table_origin(unsigned long *rtep, gfp_t gfp)
+{
+	unsigned long old_rte, rte;
+	unsigned long *sto;
+
+	rte = READ_ONCE(*rtep);
+	if (reg_entry_isvalid(rte)) {
+		sto = get_rt_sto(rte);
+	} else {
+		sto = dma_alloc_cpu_table(gfp);
+		if (!sto)
+			return NULL;
+
+		set_rt_sto(&rte, virt_to_phys(sto));
+		validate_rt_entry(&rte);
+		entry_clr_protected(&rte);
+
+		old_rte = cmpxchg(rtep, ZPCI_TABLE_INVALID, rte);
+		if (old_rte != ZPCI_TABLE_INVALID) {
+			/* Somone else was faster, use theirs */
+			dma_free_cpu_table(sto);
+			sto = get_rt_sto(old_rte);
+		}
+	}
+	return sto;
+}
+
+static unsigned long *dma_get_page_table_origin(unsigned long *step, gfp_t gfp)
+{
+	unsigned long old_ste, ste;
+	unsigned long *pto;
+
+	ste = READ_ONCE(*step);
+	if (reg_entry_isvalid(ste)) {
+		pto = get_st_pto(ste);
+	} else {
+		pto = dma_alloc_page_table(gfp);
+		if (!pto)
+			return NULL;
+		set_st_pto(&ste, virt_to_phys(pto));
+		validate_st_entry(&ste);
+		entry_clr_protected(&ste);
+
+		old_ste = cmpxchg(step, ZPCI_TABLE_INVALID, ste);
+		if (old_ste != ZPCI_TABLE_INVALID) {
+			/* Somone else was faster, use theirs */
+			dma_free_page_table(pto);
+			pto = get_st_pto(old_ste);
+		}
+	}
+	return pto;
+}
+
+static unsigned long *dma_walk_cpu_trans(unsigned long *rto, dma_addr_t dma_addr, gfp_t gfp)
+{
+	unsigned long *sto, *pto;
+	unsigned int rtx, sx, px;
+
+	rtx = calc_rtx(dma_addr);
+	sto = dma_get_seg_table_origin(&rto[rtx], gfp);
+	if (!sto)
+		return NULL;
+
+	sx = calc_sx(dma_addr);
+	pto = dma_get_page_table_origin(&sto[sx], gfp);
+	if (!pto)
+		return NULL;
+
+	px = calc_px(dma_addr);
+	return &pto[px];
+}
+
+static void dma_update_cpu_trans(unsigned long *ptep, phys_addr_t page_addr, int flags)
+{
+	unsigned long pte;
+
+	pte = READ_ONCE(*ptep);
+	if (flags & ZPCI_PTE_INVALID) {
+		invalidate_pt_entry(&pte);
+	} else {
+		set_pt_pfaa(&pte, page_addr);
+		validate_pt_entry(&pte);
+	}
+
+	if (flags & ZPCI_TABLE_PROTECTED)
+		entry_set_protected(&pte);
+	else
+		entry_clr_protected(&pte);
+
+	xchg(ptep, pte);
+}
+
 static struct s390_domain *to_s390_domain(struct iommu_domain *dom)
 {
 	return container_of(dom, struct s390_domain, domain);
@@ -43,9 +327,14 @@ static struct iommu_domain *s390_domain_alloc(unsigned domain_type)
 {
 	struct s390_domain *s390_domain;
 
-	if (domain_type != IOMMU_DOMAIN_UNMANAGED)
+	switch (domain_type) {
+	case IOMMU_DOMAIN_DMA:
+	case IOMMU_DOMAIN_DMA_FQ:
+	case IOMMU_DOMAIN_UNMANAGED:
+		break;
+	default:
 		return NULL;
-
+	}
 	s390_domain = kzalloc(sizeof(*s390_domain), GFP_KERNEL);
 	if (!s390_domain)
 		return NULL;
@@ -84,14 +373,13 @@ static void s390_domain_free(struct iommu_domain *domain)
 	call_rcu(&s390_domain->rcu, s390_iommu_rcu_free_domain);
 }
 
-static void __s390_iommu_detach_device(struct zpci_dev *zdev)
+static void s390_iommu_detach_device(struct iommu_domain *domain,
+				     struct device *dev)
 {
-	struct s390_domain *s390_domain = zdev->s390_domain;
+	struct s390_domain *s390_domain = to_s390_domain(domain);
+	struct zpci_dev *zdev = to_zpci_dev(dev);
 	unsigned long flags;
 
-	if (!s390_domain)
-		return;
-
 	spin_lock_irqsave(&s390_domain->list_lock, flags);
 	list_del_rcu(&zdev->iommu_list);
 	spin_unlock_irqrestore(&s390_domain->list_lock, flags);
@@ -118,9 +406,7 @@ static int s390_iommu_attach_device(struct iommu_domain *domain,
 		return -EINVAL;
 
 	if (zdev->s390_domain)
-		__s390_iommu_detach_device(zdev);
-	else if (zdev->dma_table)
-		zpci_dma_exit_device(zdev);
+		s390_iommu_detach_device(&zdev->s390_domain->domain, dev);
 
 	cc = zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
 				virt_to_phys(s390_domain->dma_table), &status);
@@ -130,7 +416,6 @@ static int s390_iommu_attach_device(struct iommu_domain *domain,
 	 */
 	if (cc && status != ZPCI_PCI_ST_FUNC_NOT_AVAIL)
 		return -EIO;
-	zdev->dma_table = s390_domain->dma_table;
 
 	zdev->dma_table = s390_domain->dma_table;
 	zdev->s390_domain = s390_domain;
@@ -142,14 +427,6 @@ static int s390_iommu_attach_device(struct iommu_domain *domain,
 	return 0;
 }
 
-static void s390_iommu_set_platform_dma(struct device *dev)
-{
-	struct zpci_dev *zdev = to_zpci_dev(dev);
-
-	__s390_iommu_detach_device(zdev);
-	zpci_dma_init_device(zdev);
-}
-
 static void s390_iommu_get_resv_regions(struct device *dev,
 					struct list_head *list)
 {
@@ -202,7 +479,7 @@ static void s390_iommu_release_device(struct device *dev)
 	 * to the device, but keep it attached to other devices in the group.
 	 */
 	if (zdev)
-		__s390_iommu_detach_device(zdev);
+		s390_iommu_detach_device(&zdev->s390_domain->domain, dev);
 }
 
 
@@ -220,6 +497,7 @@ static void s390_iommu_flush_iotlb_all(struct iommu_domain *domain)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(zdev, &s390_domain->devices, iommu_list) {
+		atomic64_inc(&s390_domain->ctrs.global_rpcits);
 		zpci_refresh_all(zdev);
 	}
 	rcu_read_unlock();
@@ -238,6 +516,7 @@ static void s390_iommu_iotlb_sync(struct iommu_domain *domain,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(zdev, &s390_domain->devices, iommu_list) {
+		atomic64_inc(&s390_domain->ctrs.sync_rpcits);
 		zpci_refresh_trans((u64)zdev->fh << 32, gather->start,
 				   size);
 	}
@@ -255,6 +534,7 @@ static int s390_iommu_iotlb_sync_map(struct iommu_domain *domain,
 	list_for_each_entry_rcu(zdev, &s390_domain->devices, iommu_list) {
 		if (!zdev->tlb_refresh)
 			continue;
+		atomic64_inc(&s390_domain->ctrs.sync_map_rpcits);
 		ret = zpci_refresh_trans((u64)zdev->fh << 32,
 					 iova, size);
 		/*
@@ -349,16 +629,15 @@ static int s390_iommu_map_pages(struct iommu_domain *domain,
 	if (!IS_ALIGNED(iova | paddr, pgsize))
 		return -EINVAL;
 
-	if (!(prot & IOMMU_READ))
-		return -EINVAL;
-
 	if (!(prot & IOMMU_WRITE))
 		flags |= ZPCI_TABLE_PROTECTED;
 
 	rc = s390_iommu_validate_trans(s390_domain, paddr, iova,
-				       pgcount, flags, gfp);
-	if (!rc)
+				     pgcount, flags, gfp);
+	if (!rc) {
 		*mapped = size;
+		atomic64_add(pgcount, &s390_domain->ctrs.mapped_pages);
+	}
 
 	return rc;
 }
@@ -414,12 +693,27 @@ static size_t s390_iommu_unmap_pages(struct iommu_domain *domain,
 		return 0;
 
 	iommu_iotlb_gather_add_range(gather, iova, size);
+	atomic64_add(pgcount, &s390_domain->ctrs.unmapped_pages);
 
 	return size;
 }
 
+static void s390_iommu_probe_finalize(struct device *dev)
+{
+	iommu_dma_forcedac = true;
+	iommu_setup_dma_ops(dev, 0, U64_MAX);
+}
+
+struct zpci_iommu_ctrs *zpci_get_iommu_ctrs(struct zpci_dev *zdev)
+{
+	if (!zdev || !zdev->s390_domain)
+		return NULL;
+	return &zdev->s390_domain->ctrs;
+}
+
 int zpci_init_iommu(struct zpci_dev *zdev)
 {
+	u64 aperture_size;
 	int rc = 0;
 
 	rc = iommu_device_sysfs_add(&zdev->iommu_dev, NULL, NULL,
@@ -431,6 +725,12 @@ int zpci_init_iommu(struct zpci_dev *zdev)
 	if (rc)
 		goto out_sysfs;
 
+	zdev->start_dma = PAGE_ALIGN(zdev->start_dma);
+	aperture_size = min3(s390_iommu_aperture,
+			     ZPCI_TABLE_SIZE_RT - zdev->start_dma,
+			     zdev->end_dma - zdev->start_dma + 1);
+	zdev->end_dma = zdev->start_dma + aperture_size - 1;
+
 	return 0;
 
 out_sysfs:
@@ -446,13 +746,51 @@ void zpci_destroy_iommu(struct zpci_dev *zdev)
 	iommu_device_sysfs_remove(&zdev->iommu_dev);
 }
 
+static int __init s390_iommu_setup(char *str)
+{
+	if (!strcmp(str, "strict")) {
+		pr_warn("s390_iommu=strict deprecated; use iommu.strict=1 instead\n");
+		iommu_set_dma_strict();
+	}
+	return 1;
+}
+
+__setup("s390_iommu=", s390_iommu_setup);
+
+static int __init s390_iommu_aperture_setup(char *str)
+{
+	if (kstrtou32(str, 10, &s390_iommu_aperture_factor))
+		s390_iommu_aperture_factor = 1;
+	return 1;
+}
+
+__setup("s390_iommu_aperture=", s390_iommu_aperture_setup);
+
+static int __init s390_iommu_init(void)
+{
+	int rc;
+
+	s390_iommu_aperture = (u64)virt_to_phys(high_memory);
+	if (!s390_iommu_aperture_factor)
+		s390_iommu_aperture = ULONG_MAX;
+	else
+		s390_iommu_aperture *= s390_iommu_aperture_factor;
+
+	rc = dma_alloc_cpu_table_caches();
+	if (rc)
+		return rc;
+
+	return rc;
+}
+subsys_initcall(s390_iommu_init);
+
 static const struct iommu_ops s390_iommu_ops = {
 	.capable = s390_iommu_capable,
 	.domain_alloc = s390_domain_alloc,
 	.probe_device = s390_iommu_probe_device,
+	.probe_finalize = s390_iommu_probe_finalize,
 	.release_device = s390_iommu_release_device,
 	.device_group = generic_device_group,
-	.set_platform_dma_ops = s390_iommu_set_platform_dma,
 	.pgsize_bitmap = SZ_4K,
 	.get_resv_regions = s390_iommu_get_resv_regions,
 	.default_domain_ops = &(const struct iommu_domain_ops) {

-- 
2.37.2

