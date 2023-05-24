Return-Path: <netdev+bounces-5071-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3127770F971
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:56:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAE5E1C20C9F
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 828CA18C33;
	Wed, 24 May 2023 14:55:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB8319526
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:55:50 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7116419C;
	Wed, 24 May 2023 07:55:20 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34OEmEOA022580;
	Wed, 24 May 2023 14:53:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : subject : date :
 message-id : content-type : to : cc : content-transfer-encoding :
 mime-version; s=pp1; bh=o3/MWFRFefepIFkX0g5w51Xxyjj/76WvtrHm4xglf9g=;
 b=aYPWfWE37yj8XuGNdoSNI2aPYJuy/b/rs/7vZovJRz1LIRHBif/b6GyXX8f1+QGeyJi0
 6FjwjG53co9bP145Sc2QavIhdyDQo2QOqD/rhw8aQ9FI9occvVu3tUUzEGiMP19TkdZk
 anihJEkkfmpjcPhlsdBIEune6tC09BcneeeWEyVnH5FbYF4c6andvcY8X1NUSyu0ewfm
 KTO1/zHJqrrRqH8arLBGQas2pUdqT7mhav/NLoel1kyMnvQPpaQJoooLAX+Yn5PDCCZd
 Rp8t0xy1bRqk/e74MrJVGK0/h1+JFutMm0Esb/RMCR+oIsx256jcwigKsQzFoBy4zkCJ RA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qsmca0t9c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 May 2023 14:53:27 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34OErHsx007982;
	Wed, 24 May 2023 14:53:26 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qsmca0t7y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 May 2023 14:53:26 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34O3dxPY018742;
	Wed, 24 May 2023 14:53:23 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qppdk20xy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 May 2023 14:53:23 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34OErJW710617398
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 May 2023 14:53:19 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5623B20043;
	Wed, 24 May 2023 14:53:19 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 785D320040;
	Wed, 24 May 2023 14:53:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 May 2023 14:53:18 +0000 (GMT)
From: Niklas Schnelle <schnelle@linux.ibm.com>
Subject: [PATCH v10 0/6] iommu/dma: s390 DMA API conversion and optimized
 IOTLB flushing
Date: Wed, 24 May 2023 16:53:03 +0200
Message-Id: <20230310-dma_iommu-v10-0-f1fbd8310854@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
X-B4-Tracking: v=1; b=H4sIAM8kbmQC/3WO22rDMBBEfyXouTK6OVby1P8oJeiyrhZ0KVJsE
 oL/vXJeCqHdtxn2zMyDNKgIjZwPD1JhxYYld8HZ24G4YPIXUPTdIIIJySRn1CdzwZLSQkdgSrt
 R6qOaSP+3pgG11WQXOpGXGLv5XWHG27Ph47PruZZEr6GC+Y0VgvFR9Bu45loqRTltLmSIEd4j5
 uU2oE2DK2mvCdiupd6fk1e95/41btWUUSHV5GcLfjLzS9C+ZT39S586fRyt1eC9sGBf6W3bfgB
 Bc7HIPAEAAA==
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6238;
 i=schnelle@linux.ibm.com; h=from:subject:message-id;
 bh=yIKSQ6WeGhOEOKXK+OeLJIk/5KGQmPZUegiZ8Nq1Vqo=;
 b=owGbwMvMwCH2Wz534YHOJ2GMp9WSGFLyVO7uVmdicuzb6JOkL9wzWSf28U21Vu4VzDvSsnisp
 b7z+5l1lLIwiHEwyIopsizqcvZbVzDFdE9QfwfMHFYmkCEMXJwCMBG+Bwz/fVa2v7M1SnrcuXhT
 e/V2ZRFVh5/SVlofl31h+KtzOTn3B8M/nctb7H++n+f0xE+zyNM13XSywx2OzI/tNxT3H5BqKPV
 kBQA=
X-Developer-Key: i=schnelle@linux.ibm.com; a=openpgp;
 fpr=9DB000B2D2752030A5F72DDCAFE43F15E8C26090
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4dXD_vuqQGAYNM67ugSbsuRGVKBdvinp
X-Proofpoint-ORIG-GUID: S1Mx_-7pcxtj60EHxtM_4KJFHf524BaH
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
 definitions=2023-05-24_09,2023-05-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 clxscore=1015 adultscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305240119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
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
5 together with a new .shadow_on_flush flag bit in struct dev_iommu
which allows IOMMU drivers to indicate that thier IOTLB flushes do the
extra work of shadowing and triggering the dma-iommu code to use single
queue mode.

Then patch 6 enables variable queue sizes using power of 2 queue sizes
and shift/mask to keep performance as close to the existing code as
possible. A larger queue size and timeout is then also used by dma-iommu
when shadow_on_flush is set. This same scheme may also be used by other
IOMMU drivers with similar requirements. Particularly virtio-iommu may be
a candidate.

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
Changes in v10:
- Rebased on v6.4-rc3
- Removed the .tune_dma_iommu() op in favor of a .shadow_on_flush flag
  in struct dev_iommu which then let's the dma-iommu choose a single
  queue and larger timeouts and IOVA counts. This leaves the dma-iommu
  with full responsibility for the settings.
- The above change affects patches 5 and 6 and lead to a new subject for
  patch 6 since the flush queue size and timeout is no longer driver
  controlled
- Link to v9: https://lore.kernel.org/r/20230310-dma_iommu-v9-0-65bb8edd2beb@linux.ibm.com

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
      iommu/dma: Use a large flush queue and timeout for shadow_on_flush

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
 drivers/iommu/dma-iommu.c                       | 212 +++++--
 drivers/iommu/intel/iommu.c                     |   5 +-
 drivers/iommu/msm_iommu.c                       |   5 +-
 drivers/iommu/mtk_iommu.c                       |   5 +-
 drivers/iommu/s390-iommu.c                      | 422 ++++++++++++--
 drivers/iommu/sprd-iommu.c                      |   5 +-
 drivers/iommu/sun50i-iommu.c                    |   6 +-
 drivers/iommu/tegra-gart.c                      |   5 +-
 drivers/s390/net/ism_drv.c                      |   2 +-
 include/linux/iommu.h                           |   6 +-
 24 files changed, 632 insertions(+), 1005 deletions(-)
---
base-commit: 44c026a73be8038f03dbdeef028b642880cf1511
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


