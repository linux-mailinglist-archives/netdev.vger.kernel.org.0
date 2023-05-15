Return-Path: <netdev+bounces-2559-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27BD870281C
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:17:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2D4B2811CE
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BFD5BE7C;
	Mon, 15 May 2023 09:17:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CB7BE68
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:17:19 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEBC35B3;
	Mon, 15 May 2023 02:17:18 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34F97bmd000806;
	Mon, 15 May 2023 09:16:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : subject : date :
 message-id : content-type : to : cc : content-transfer-encoding :
 mime-version; s=pp1; bh=ka0qjy6unHncNjzpsf8Pyt9B+1j1Jy6uYBWZb2IJP/U=;
 b=rHO3MFrHkG5ppeOiy4+KHZgKHwvvqmf3OwBAlh25wnbwnW0TBizDizdjYbc4uFd6x3kh
 jZo6q5bTBZAc9o+K0nEBxwRivBxnwxx7ufjwao4ixyIQBGfiQGF6pVWF+bjZwNPIjyAK
 yWcjxWDGA2qbaR+LZXmxKkStx/h2EXloAnzK9pw96wpgDOGf+BJ6LQoUqlDFprPfWgPZ
 UE8RG1u02XkGS1Dxbc3oqyFc0HoIdHgfnGKJcP1q8GqoSBN3wv6JhMDGG1o7Vn0yT3xM
 F2Bi7e4norUTRZA8FOZvDuEKk4oUOnf4a6HkK+aFKwl6yxmsHYDrPxnkaBBOzV1d2H+c lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qkd3mrpv3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 May 2023 09:16:23 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34F97tad002590;
	Mon, 15 May 2023 09:16:22 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qkd3mrps4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 May 2023 09:16:22 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
	by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34F40vhA024749;
	Mon, 15 May 2023 09:16:17 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qj1tdryam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 May 2023 09:16:17 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34F9GEeN27460148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 May 2023 09:16:14 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 10EF820043;
	Mon, 15 May 2023 09:16:14 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 215B720040;
	Mon, 15 May 2023 09:16:13 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 May 2023 09:16:13 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH v9 0/6] iommu/dma: s390 DMA API conversion and optimized
 IOTLB flushing
Date: Mon, 15 May 2023 11:15:50 +0200
Message-Id: <20230310-dma_iommu-v9-0-65bb8edd2beb@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
X-B4-Tracking: v=1; b=H4sIAEb4YWQC/22Oy2rDMBBFfyVonTF6uVay6n+UUGR5XA3oESTbp
 AT/e5RsAqWzO8PMuffOKhbCys6HOyu4UaWcGpyOB+a8TT8INDVmkkvFleAwRftNOcYVeuTauF6
 ZDz2wdj/aijAWm5xvH2kNoS2vBWe6vQK+Lo3nkiMsvqB9a6XkopdtOmGEUVqDgOp8whDwM1Bab
 x2NsXM5PmM81SWX31fjzTy9/5XbDHCQSg/TPOI02PmP6LLv+wNyj3CL/QAAAA==
To: Joerg Roedel <joro@8bytes.org>, Matthew Rosato <mjrosato@linux.ibm.com>,
        Will Deacon <will@kernel.org>, Wenjia Zhang <wenjia@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Gerd Bayer <gbayer@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Yong Wu <yong.wu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>, Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux.dev, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-tegra@vger.kernel.org, linux-doc@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5841;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=wR8vKH9qzWb5+M2sVnSQXIDDqBuHODWYlv/cdDQr+oY=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGFISf0T8jV8/cWugurCKfBPHqoteMmysdem3fGdIpwbfD
 bnz7cGmjlIWBjEOBlkxRZZFXc5+6wqmmO4J6u+AmcPKBDKEgYtTACZipcvwmyV23c/nmVkLbjXs
 NzndkrHF9FTL1hvH/3j/1g9LbWa785bhf6Ss1SUJJvf27aL6D7+809DbfiSGNzbjxM0AVfXpohN
 f8AEA
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: R5kdhGb_6k2meXm9AjMLBJogm9_V8b81
X-Proofpoint-ORIG-GUID: J80AmfSVEo9tob-DBy4iTRwQJAGNiujj
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-15_06,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 clxscore=1011
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305150078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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

To this end patches 5-6 add a new, single queue, IOTLB flushing scheme as
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

This code is also available in the b4/dma_iommu topic branch of my
git.kernel.org repository[3] with tags the version sent.

NOTE: Due to the large drop in performance I think we should not merge the DMA
API conversion (patch 4) until we have a more suited IOVA flushing scheme
with similar improvements as the proposed changes.

Best regards,
Niklas

[0] https://lore.kernel.org/linux-iommu/20221109142903.4080275-1-schnelle@linux.ibm.com/
[1] https://lore.kernel.org/linux-iommu/3e402947-61f9-b7e8-1414-fde006257b6f@arm.com/
[2] https://lore.kernel.org/linux-iommu/a8e778da-7b41-a6ba-83c3-c366a426c3da@arm.com/
[3] https://git.kernel.org/pub/scm/linux/kernel/git/niks/linux.git/

---
Changes in v9:
- Rebased on v6.4-rc2
- Re-ordered iommu_group_store_type() to allow passing the device to
  iommu_dma_init_fq()
- Link to v8: https://lore.kernel.org/r/20230310-dma_iommu-v8-0-2347dfbed7af@linux.ibm.com

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
 arch/s390/include/asm/pci_dma.h                 | 119 +---
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
 drivers/iommu/dma-iommu.c                       | 191 ++++--
 drivers/iommu/dma-iommu.h                       |   4 +-
 drivers/iommu/intel/iommu.c                     |   5 +-
 drivers/iommu/iommu.c                           |  38 +-
 drivers/iommu/msm_iommu.c                       |   5 +-
 drivers/iommu/mtk_iommu.c                       |   5 +-
 drivers/iommu/s390-iommu.c                      | 435 +++++++++++++-
 drivers/iommu/sprd-iommu.c                      |   5 +-
 drivers/iommu/sun50i-iommu.c                    |   4 +-
 drivers/iommu/tegra-gart.c                      |   5 +-
 drivers/s390/net/ism_drv.c                      |   2 +-
 include/linux/iommu.h                           |  29 +-
 26 files changed, 682 insertions(+), 1010 deletions(-)
---
base-commit: f1fcbaa18b28dec10281551dfe6ed3a3ed80e3d6
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


