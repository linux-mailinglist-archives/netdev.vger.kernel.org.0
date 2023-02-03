Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0609268A456
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 22:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbjBCVL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 16:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbjBCVLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 16:11:23 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5FC71BF5;
        Fri,  3 Feb 2023 13:11:10 -0800 (PST)
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 313KenUI024989;
        Fri, 3 Feb 2023 21:10:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=ZrXUH0Omg6RzsJR3syi23SBibtjJaDRCIYaiu1onFk0=;
 b=TsbV0n6AKPZDBX9pHKYLr9Madn8vG3vbMLbAm4A+gQ8v/KOg1ZnO7/TQahQjVPOcHgYY
 z/fE29YA0YqUmTv68hyF7t4bTKi4+omTtvdjOjoYeoyzd5yVU1S8TSM0iu8vrtT5KDuR
 2QQ1mM+JDM8SsHmr8poKHTRRGTfdxXd2vxlW/rfzTF0upDrUM3WIj83wbQLMdwIQdE9h
 xPwMJ1w68OJx2Jkc2izXQGhqwNO96KekmCMSysTZqXQpT6Ri7W16PTw8N1cLax5+1rfh
 z1JZzaaXVJBvx89jutvc2jFYPgMmimgCwXUAIKPuu69EQBWR+t8Y1o28dsJOb43KA9ZN tQ== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ngns2jha8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Feb 2023 21:10:17 +0000
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 313LAGUp006424
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 3 Feb 2023 21:10:16 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 3 Feb 2023 13:10:15 -0800
From:   Elliot Berman <quic_eberman@quicinc.com>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        "Abhinav Kumar" <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
        "Vikash Garodia" <quic_vgarodia@quicinc.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Amol Maheshwari <amahesh@qti.qualcomm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Elliot Berman <quic_eberman@quicinc.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <freedreno@lists.freedesktop.org>, <iommu@lists.linux.dev>,
        <linux-media@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: [PATCH] firmware: qcom_scm: Move qcom_scm.h to include/linux/firmware/qcom/
Date:   Fri, 3 Feb 2023 13:09:52 -0800
Message-ID: <20230203210956.3580811-1-quic_eberman@quicinc.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: ZlK216WrMbhK0f96yjsuQBwOakhKfBhG
X-Proofpoint-ORIG-GUID: ZlK216WrMbhK0f96yjsuQBwOakhKfBhG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-03_19,2023-02-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1011
 spamscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302030190
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move include/linux/qcom_scm.h to include/linux/firmware/qcom/qcom_scm.h.
This removes 1 of a few remaining Qualcomm-specific headers into a more
approciate subdirectory under include/.

Suggested-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
---
 arch/arm/mach-qcom/platsmp.c                     | 2 +-
 drivers/cpuidle/cpuidle-qcom-spm.c               | 2 +-
 drivers/firmware/qcom_scm-legacy.c               | 2 +-
 drivers/firmware/qcom_scm-smc.c                  | 2 +-
 drivers/firmware/qcom_scm.c                      | 2 +-
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c            | 2 +-
 drivers/gpu/drm/msm/adreno/adreno_gpu.c          | 2 +-
 drivers/gpu/drm/msm/hdmi/hdmi_hdcp.c             | 2 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom-debug.c | 2 +-
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c       | 2 +-
 drivers/iommu/arm/arm-smmu/qcom_iommu.c          | 2 +-
 drivers/media/platform/qcom/venus/firmware.c     | 2 +-
 drivers/misc/fastrpc.c                           | 2 +-
 drivers/mmc/host/sdhci-msm.c                     | 2 +-
 drivers/net/ipa/ipa_main.c                       | 2 +-
 drivers/net/wireless/ath/ath10k/qmi.c            | 2 +-
 drivers/pinctrl/qcom/pinctrl-msm.c               | 2 +-
 drivers/remoteproc/qcom_q6v5_mss.c               | 2 +-
 drivers/remoteproc/qcom_q6v5_pas.c               | 2 +-
 drivers/remoteproc/qcom_wcnss.c                  | 2 +-
 drivers/soc/qcom/mdt_loader.c                    | 2 +-
 drivers/soc/qcom/ocmem.c                         | 2 +-
 drivers/soc/qcom/rmtfs_mem.c                     | 2 +-
 drivers/thermal/qcom/lmh.c                       | 2 +-
 drivers/ufs/host/ufs-qcom-ice.c                  | 2 +-
 include/linux/{ => firmware/qcom}/qcom_scm.h     | 0
 26 files changed, 25 insertions(+), 25 deletions(-)
 rename include/linux/{ => firmware/qcom}/qcom_scm.h (100%)

diff --git a/arch/arm/mach-qcom/platsmp.c b/arch/arm/mach-qcom/platsmp.c
index 5d2f386a46d8..eca2fe0f4314 100644
--- a/arch/arm/mach-qcom/platsmp.c
+++ b/arch/arm/mach-qcom/platsmp.c
@@ -14,7 +14,7 @@
 #include <linux/of_address.h>
 #include <linux/smp.h>
 #include <linux/io.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 
 #include <asm/smp_plat.h>
 
diff --git a/drivers/cpuidle/cpuidle-qcom-spm.c b/drivers/cpuidle/cpuidle-qcom-spm.c
index beedf22cbe78..4ac83918edf2 100644
--- a/drivers/cpuidle/cpuidle-qcom-spm.c
+++ b/drivers/cpuidle/cpuidle-qcom-spm.c
@@ -17,7 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/cpuidle.h>
 #include <linux/cpu_pm.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <soc/qcom/spm.h>
 
 #include <asm/proc-fns.h>
diff --git a/drivers/firmware/qcom_scm-legacy.c b/drivers/firmware/qcom_scm-legacy.c
index 9f918b9e6f8f..029e6d117cb8 100644
--- a/drivers/firmware/qcom_scm-legacy.c
+++ b/drivers/firmware/qcom_scm-legacy.c
@@ -9,7 +9,7 @@
 #include <linux/mutex.h>
 #include <linux/errno.h>
 #include <linux/err.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/arm-smccc.h>
 #include <linux/dma-mapping.h>
 
diff --git a/drivers/firmware/qcom_scm-smc.c b/drivers/firmware/qcom_scm-smc.c
index bb3235a64b8f..16cf88acfa8e 100644
--- a/drivers/firmware/qcom_scm-smc.c
+++ b/drivers/firmware/qcom_scm-smc.c
@@ -8,7 +8,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/types.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/arm-smccc.h>
 #include <linux/dma-mapping.h>
 
diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index 2000323722bf..468d4d5ab550 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -12,7 +12,7 @@
 #include <linux/interconnect.h>
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index 660ba0db8900..d09221f97f71 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -5,7 +5,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/cpumask.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/pm_opp.h>
 #include <linux/nvmem-consumer.h>
 #include <linux/slab.h>
diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 57586c794b84..89ff978b81bb 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -8,7 +8,7 @@
 
 #include <linux/ascii85.h>
 #include <linux/interconnect.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/kernel.h>
 #include <linux/of_address.h>
 #include <linux/pm_opp.h>
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_hdcp.c b/drivers/gpu/drm/msm/hdmi/hdmi_hdcp.c
index e7748461cffc..0752fe373351 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_hdcp.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_hdcp.c
@@ -3,7 +3,7 @@
  */
 
 #include "hdmi.h"
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 
 #define HDCP_REG_ENABLE 0x01
 #define HDCP_REG_DISABLE 0x00
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom-debug.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom-debug.c
index 74e9ef2fd580..b5b14108e086 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom-debug.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom-debug.c
@@ -4,7 +4,7 @@
  */
 
 #include <linux/of_device.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/ratelimit.h>
 
 #include "arm-smmu.h"
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index 91d404deb115..ef42329e82ce 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -7,7 +7,7 @@
 #include <linux/adreno-smmu-priv.h>
 #include <linux/delay.h>
 #include <linux/of_device.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 
 #include "arm-smmu.h"
 #include "arm-smmu-qcom.h"
diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index 270c3d9128ba..1e0b7b2e9fbd 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -27,7 +27,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 
diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index 142d4c74017c..e5759d7e9ede 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -12,7 +12,7 @@
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
 #include <linux/of_device.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/sizes.h>
 #include <linux/soc/qcom/mdt_loader.h>
 
diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index c9902a1dcf5d..04f80e754477 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -18,7 +18,7 @@
 #include <linux/rpmsg.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <uapi/misc/fastrpc.h>
 #include <linux/of_reserved_mem.h>
 
diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 4ac8651d0b29..8ac81d57a3df 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -13,7 +13,7 @@
 #include <linux/pm_opp.h>
 #include <linux/slab.h>
 #include <linux/iopoll.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/regulator/consumer.h>
 #include <linux/interconnect.h>
 #include <linux/pinctrl/consumer.h>
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 4fb92f771974..90baf7a54d9a 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -16,7 +16,7 @@
 #include <linux/of_device.h>
 #include <linux/of_address.h>
 #include <linux/pm_runtime.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/soc/qcom/mdt_loader.h>
 
 #include "ipa.h"
diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index 3f94fbf83702..90f457b8e1fe 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -13,7 +13,7 @@
 #include <linux/module.h>
 #include <linux/net.h>
 #include <linux/platform_device.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/soc/qcom/smem.h>
 #include <linux/string.h>
 #include <net/sock.h>
diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 47e9a8b0d474..e0128c69bfbf 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -14,7 +14,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/reboot.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index fddb63cffee0..da2513bb6387 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -34,7 +34,7 @@
 #include "qcom_pil_info.h"
 #include "qcom_q6v5.h"
 
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 
 #define MPSS_CRASH_REASON_SMEM		421
 
diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index dc6f07ca8341..d5a049669616 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -18,7 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/regulator/consumer.h>
 #include <linux/remoteproc.h>
 #include <linux/soc/qcom/mdt_loader.h>
diff --git a/drivers/remoteproc/qcom_wcnss.c b/drivers/remoteproc/qcom_wcnss.c
index 68f37296b151..9881443cb8df 100644
--- a/drivers/remoteproc/qcom_wcnss.c
+++ b/drivers/remoteproc/qcom_wcnss.c
@@ -19,7 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/regulator/consumer.h>
 #include <linux/remoteproc.h>
 #include <linux/soc/qcom/mdt_loader.h>
diff --git a/drivers/soc/qcom/mdt_loader.c b/drivers/soc/qcom/mdt_loader.c
index 3f11554df2f3..33dd8c315eb7 100644
--- a/drivers/soc/qcom/mdt_loader.c
+++ b/drivers/soc/qcom/mdt_loader.c
@@ -12,7 +12,7 @@
 #include <linux/firmware.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/soc/qcom/mdt_loader.h>
diff --git a/drivers/soc/qcom/ocmem.c b/drivers/soc/qcom/ocmem.c
index c92d26b73e6f..199fe9872035 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -16,7 +16,7 @@
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/types.h>
diff --git a/drivers/soc/qcom/rmtfs_mem.c b/drivers/soc/qcom/rmtfs_mem.c
index 9d59ad509a5c..2d3ee22b9249 100644
--- a/drivers/soc/qcom/rmtfs_mem.c
+++ b/drivers/soc/qcom/rmtfs_mem.c
@@ -14,7 +14,7 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 
 #define QCOM_RMTFS_MEM_DEV_MAX	(MINORMASK + 1)
 #define NUM_MAX_VMIDS		2
diff --git a/drivers/thermal/qcom/lmh.c b/drivers/thermal/qcom/lmh.c
index 4122a51e9874..f6edb12ec004 100644
--- a/drivers/thermal/qcom/lmh.c
+++ b/drivers/thermal/qcom/lmh.c
@@ -10,7 +10,7 @@
 #include <linux/platform_device.h>
 #include <linux/of_platform.h>
 #include <linux/slab.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 
 #define LMH_NODE_DCVS			0x44435653
 #define LMH_CLUSTER0_NODE_ID		0x6370302D
diff --git a/drivers/ufs/host/ufs-qcom-ice.c b/drivers/ufs/host/ufs-qcom-ice.c
index 62387ccd5b30..453978877ae9 100644
--- a/drivers/ufs/host/ufs-qcom-ice.c
+++ b/drivers/ufs/host/ufs-qcom-ice.c
@@ -8,7 +8,7 @@
 
 #include <linux/delay.h>
 #include <linux/platform_device.h>
-#include <linux/qcom_scm.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 
 #include "ufs-qcom.h"
 
diff --git a/include/linux/qcom_scm.h b/include/linux/firmware/qcom/qcom_scm.h
similarity index 100%
rename from include/linux/qcom_scm.h
rename to include/linux/firmware/qcom/qcom_scm.h

base-commit: 3866989ec2c319341e2cf69ec6116269b634a271
-- 
2.39.1

