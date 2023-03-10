Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BC46B4C69
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbjCJQOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbjCJQMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:12:33 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B27E7E7AF;
        Fri, 10 Mar 2023 08:09:59 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32AFm2I6033912;
        Fri, 10 Mar 2023 16:08:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : subject : date :
 message-id : content-type : to : cc : content-transfer-encoding :
 mime-version; s=pp1; bh=ZR06JSdEyIC2f6QZ14lanfJf0Kl1ogE9u/otyqeldFQ=;
 b=OTe6m8sd/4fLFsug1R7Vh+Nk9orGcd1FJnPVcJ77+I+p6rPZBB70QUq50lxPrsJRHhiA
 wjEBtK3Yki0xtLLytObctJHoTBbkIrVW/rBQ+xiVKDquH4B+FGMRmIWaWfkfomfleIhr
 CgRrMZn9uVaH22a/FZcqEZoHcsdNXoxgt2MFtDZPee0pfqkyuCioAJvcnxOUPYRvj3wJ
 tLQwuQTYxDoQ0yrRjWYtJmM1wCtMmznPs4ijEfyx7EIFwQu/pp/HAJI6DQ+vEmIn5zNR
 2KokRJ3GMRgGcKYugBoy7vRh/lp7rHeHaauZ0aitiwVgXS/We6z9I+SgFFjg4hInO1NO 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p87gtrh7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 16:08:22 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32AFmY3V035953;
        Fri, 10 Mar 2023 16:08:21 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3p87gtrh76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 16:08:21 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32A8LYMi019977;
        Fri, 10 Mar 2023 16:08:18 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3p6ftvm40d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Mar 2023 16:08:18 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32AG8EeX5112492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 16:08:14 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92BD520040;
        Fri, 10 Mar 2023 16:08:14 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BF6220043;
        Fri, 10 Mar 2023 16:08:13 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 10 Mar 2023 16:08:12 +0000 (GMT)
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH v8 0/6] iommu/dma: s390 DMA API conversion and optimized
 IOTLB flushing
Date:   Fri, 10 Mar 2023 17:07:45 +0100
Message-Id: <20230310-dma_iommu-v8-0-2347dfbed7af@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
X-B4-Tracking: v=1; b=H4sIANFVC2QC/0WNyQrCMBRFf6VkbUqmanDlf4hImr6aBxlKYqVQ+
 u8+3Hh353KHnTWoCI1du51V+GDDkgnsqWM+uPwCjhMxU0JpoaXgU3JPLCmtfABhrB+0PZsLo/z
 oGvCxuuwDNfIaI5lLhRm338H9QTzXkvg7VHD/WaWEHBSpl1ZabQyXvPmQIUa4Rczr1uOYel8SO
 44v818SqrIAAAA=
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8086;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=5ugqHRtwa175iTk6uy6ZO/L17cynkBtaxZWfDk2PN10=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGFK4Q59F+sq9atpx+4tStaPFJusZm113nIx7xGt2QmZJy
 J07P2Q/d5SyMIhxMMiKKbIs6nL2W1cwxXRPUH8HzBxWJpAhDFycAjCRMAGG/+4lKWpMdz+vVciM
 6rGt/nCxb1b9wuNrOe96Hr36S/GabAvDX/HEc1GfdlWalofP3xTsKV96XfhP2OSNVXP2P7FI/zV
 pLQ8A
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5gBCNF1yrkWkoVesy1HWWpBtBYNdB07q
X-Proofpoint-GUID: oPCmQHgrqyQNSADUd1pVxHqkNty6kKxt
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-10_07,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0 spamscore=0
 clxscore=1011 priorityscore=1501 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303100128
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

This patch series converts s390's PCI support from its platform specific DMA
API implementation in arch/s390/pci/pci_dma.c to the common DMA IOMMU layer.
The conversion itself is done in patches 3-4 with patch 2 providing the final
necessary IOMMU driver improvement to handle s390's special IOTLB flush
out-of-resource indication in virtualized environments. Patches 1-2 may be
applied independently. The conversion itself only touches the s390 IOMMU driver
and s390 arch code moving over remaining functions from the s390 DMA API
implementation. No changes to common code are necessary.

After patch 4 the basic conversion is done and on our partitioning machine
hypervisor LPAR performance matches or exceeds the existing code. When running
under z/VM or KVM however, performance plummets to about half of the existing
code due to a much higher rate of IOTLB flushes for unmapped pages. Due to the
hypervisors use of IOTLB flushes to synchronize their shadow tables these are
very expensive and minimizing them is key for regaining the performance loss.

To this end patches 5-6 propose a new, single queue, IOTLB flushing scheme as
an alternative to the existing per-CPU flush queues. Introducing an alternative
scheme was also suggested by Robin Murphy[1]. In the previous RFC of this
conversion Robin suggested reusing more of the existing queuing logic which
I incorporated since v2. The single queue mode is introduced in patch
5 together with a new dma_iommu_options struct and tune_dma_iommu callback in
IOMMU ops which allows IOMMU drivers to switch to a single flush queue.

Then patch 6 enables variable queue sizes using power of 2 queue sizes and
shift/mask to keep performance as close to the existing code as possible. The
variable queue size and a variable timeout are added to the dma_iommu_options
struct and utilized by s390 in the z/VM and KVM guest cases. As it is
implemented in common code the single queue IOTLB flushing scheme can of course
be used by other platforms with expensive IOTLB flushes. Particularly
virtio-iommu may be a candidate.

In a previous version I verified that the new scheme does work on my x86_64
Ryzen workstation by locally modifying iommu_subsys_init() to default to the
single queue mode and verifying its use via "/sys/.../iommu_group/type". I did
not find problems with an AMD GPU, Intel NIC (with SR-IOV and KVM
pass-through), NVMes or any on board peripherals.

For this version I switched to b4 prep/b4 send so this is now available
with b4 generated tags in the b4/dma_iommu topic branch of my
git.kernel.org repository[3]. And we also get base-commit, and change-id
tags as well as PGP signed mails.

NOTE: Due to the large drop in performance I think we should not merge the DMA
API conversion (patch 4) until we have a more suited IOVA flushing scheme
with similar improvements as the proposed changes.

Best regards,
Niklas

[0] https://lore.kernel.org/linux-iommu/20221109142903.4080275-1-schnelle@linux.ibm.com/
[1] https://lore.kernel.org/linux-iommu/3e402947-61f9-b7e8-1414-fde006257b6f@arm.com/
[2] https://lore.kernel.org/linux-iommu/a8e778da-7b41-a6ba-83c3-c366a426c3da@arm.com/
[3] https://git.kernel.org/pub/scm/linux/kernel/git/niks/linux.git/

Changes sinve v7:
- Add R-b from Matt
- Rebase on v6.3-rc1
- Switched to b4 prep / b4 send adding base-commit, change-id, PGP signatures.
  For the cost of no per-patch change lists.

Changes since v6:
- Rebased on iommu-next branch (Matt)
  - No need for ops->set_platform_dma() anymore
  - Add gfp_t gfp parameters for page allocations
- In patch 4 removed a superflous s390_domain->dma_table assignment
- Added R-bs from Matt

Changes since v5:
- Instead of introducing a new IOMMU domain type utilize a new options
  mechanism that allows IOMMU drivers to tune the DMA IOMMU flushing (Jason,
  Robin)
- The above reworks patches 5 and 6
- Dropped patch 7 as its functionality is no longer needed

Changes since v4:
- Picked up R-b's for patch 1, 2 and 3
- In patch 5 fixed iommu_group_store_type() mistakenly initializing DMA-SQ
  instead of DMA-FQ. This was caused by iommu_dma_init_fq() being called before
  domain->type is set, instead pass the type as paramater. This also closes
  a window where domain->type is still DMA while the FQ is already used. (Gerd)
- Replaced a missed check for IOMMU_DOMAIN_DMA_FQ with the new generic
  __IOMMU_DOMAIN_DMA_LAZY in patch 5
- Made the ISM PCI Function Type a define (Matt)
- Removed stale TODO comment (Matt)

Changes since v3:
- Reword commit message of patch 2 for more clarity
- Correct typo in comment added by patch 2 (Alexandra)
- Adapted signature of .iommu_tlb_sync mapo for sun50i IOMMU driver added in
  v6.2-rc1 (kernel test robot)
- Add R-b from Alexandra for patch 1

Changes since v2:
- Move the IOTLB out-of-resource handling into the IOMMU enabling it also for
  the IOMMU API (patch 2). This also makes this independent from the DMA API
  conversion (Robin, Jason).
- Rename __IOMMU_DOMAIN_DMA_FQ to __IOMMU_DOMAIN_DMA_LAZY when introducing
  single queue flushing mode.
- Make selecting between single and per-CPU flush queues an explicit IOMMU op
  (patch 7)

Changes since RFC v1:
- Patch 1 uses dma_set_mask_and_coherent() (Christoph)
- Patch 3 now documents and allows the use of iommu.strict=0|1 on s390 and
  deprecates s390_iommu=strict while making it an alias.
- Patches 5-7 completely reworked to reuse existing queue logic (Robin)
- Added patch 4 to allow using iommu.strict=0|1 to override
  ops->def_domain_type.

---
Niklas Schnelle (6):
      s390/ism: Set DMA coherent mask
      iommu: Allow .iotlb_sync_map to fail and handle s390's -ENOMEM return
      s390/pci: prepare is_passed_through() for dma-iommu
      s390/pci: Use dma-iommu layer
      iommu/dma: Allow a single FQ in addition to per-CPU FQs
      iommu/dma: Make flush queue sizes and timeout driver configurable

 Documentation/admin-guide/kernel-parameters.txt |   9 +-
 arch/s390/include/asm/pci.h                     |   7 -
 arch/s390/include/asm/pci_clp.h                 |   3 +
 arch/s390/include/asm/pci_dma.h                 | 121 +---
 arch/s390/pci/Makefile                          |   2 +-
 arch/s390/pci/pci.c                             |  22 +-
 arch/s390/pci/pci_bus.c                         |   5 -
 arch/s390/pci/pci_debug.c                       |  12 +-
 arch/s390/pci/pci_dma.c                         | 735 ------------------------
 arch/s390/pci/pci_event.c                       |  17 +-
 arch/s390/pci/pci_sysfs.c                       |  19 +-
 drivers/iommu/Kconfig                           |   4 +-
 drivers/iommu/amd/iommu.c                       |   5 +-
 drivers/iommu/apple-dart.c                      |   5 +-
 drivers/iommu/dma-iommu.c                       | 189 ++++--
 drivers/iommu/dma-iommu.h                       |   4 +-
 drivers/iommu/intel/iommu.c                     |   5 +-
 drivers/iommu/iommu.c                           |  24 +-
 drivers/iommu/msm_iommu.c                       |   5 +-
 drivers/iommu/mtk_iommu.c                       |   5 +-
 drivers/iommu/s390-iommu.c                      | 435 +++++++++++++-
 drivers/iommu/sprd-iommu.c                      |   5 +-
 drivers/iommu/sun50i-iommu.c                    |   4 +-
 drivers/iommu/tegra-gart.c                      |   5 +-
 drivers/s390/net/ism_drv.c                      |   2 +-
 include/linux/iommu.h                           |  29 +-
 26 files changed, 671 insertions(+), 1007 deletions(-)
---
base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6
change-id: 20230310-dma_iommu-5e048c538647

Best regards,
-- 
Niklas Schnelle
Linux on Z Development

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement - https://www.ibm.com/privacy 

