Return-Path: <netdev+bounces-1513-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EAF36FE0F1
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 17:00:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 505A11C20D93
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 15:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F3216408;
	Wed, 10 May 2023 15:00:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6DD111B9
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 15:00:40 +0000 (UTC)
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D60E76BF;
	Wed, 10 May 2023 08:00:37 -0700 (PDT)
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34AEHOm5011536;
	Wed, 10 May 2023 15:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id; s=qcppdkim1;
 bh=BFYBJMaMy8GQvcMMwkfWrTq4ZuvajVJWJE3idYxLT1o=;
 b=bcLRJ1rQ0rxcEhsqROETlxtZtETtHIy0PJBC37m4DVLa5EE1xlP++B4QRtIcI9AqzyC1
 m+pmke4LpUl5NsdjXDnDCpT2vcf5r7wRj86ii1xgp/hpANu4CyW+OuTBsypmQHUPXEKV
 dfgP5FyVCKHOKBJtcVG22ImYIZOQli2s4ECXoqtWEzkDRdUi1l26Ib/7qHZd6SG9ahez
 ne5k/Q8SrmdY6zuR4De6Xx9Awl4z0vepGte0i8v9loI8bKrT6ghhVi220NUdtktEZols
 /4Ucx45YDr+RETrYVEUsdRUr34C+GIHXtaChH1dVkE8AxUzU7enGCSuugKFUuaeWwQl4 qA== 
Received: from apblrppmta01.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qfr50ak1y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 May 2023 15:00:31 +0000
Received: from pps.filterd (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 34AF0Rq1024947;
	Wed, 10 May 2023 15:00:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTP id 3qdy59f6hp-1;
	Wed, 10 May 2023 15:00:27 +0000
Received: from APBLRPPMTA01.qualcomm.com (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34AF0Qwe024940;
	Wed, 10 May 2023 15:00:26 GMT
Received: from hu-sgudaval-hyd.qualcomm.com (hu-rohiagar-hyd.qualcomm.com [10.213.106.138])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTP id 34AF0QVM024939;
	Wed, 10 May 2023 15:00:26 +0000
Received: by hu-sgudaval-hyd.qualcomm.com (Postfix, from userid 3970568)
	id 06F9E5129; Wed, 10 May 2023 20:30:26 +0530 (+0530)
From: Rohit Agarwal <quic_rohiagar@quicinc.com>
To: agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        linus.walleij@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com,
        manivannan.sadhasivam@linaro.org, andy.shevchenko@gmail.com
Cc: linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rohit Agarwal <quic_rohiagar@quicinc.com>
Subject: [PATCH v7 0/4] Add pinctrl support for SDX75
Date: Wed, 10 May 2023 20:30:21 +0530
Message-Id: <1683730825-15668-1-git-send-email-quic_rohiagar@quicinc.com>
X-Mailer: git-send-email 2.7.4
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: j69F6lqNwNuYbVHGNYKvYz28nmIMvcGL
X-Proofpoint-ORIG-GUID: j69F6lqNwNuYbVHGNYKvYz28nmIMvcGL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=754 bulkscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 adultscore=0 phishscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305100121
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

Hi,

Changes in v7:
 - Collected reviewed by tags from Andy and updated the sdx75
   driver with the new macro which was missed in v6 patch.

Changes in v6:
 - Refactoring as per suggestions from Andy to remove msm_function and
   reusing the pinfunction and pingroup struct with macros as well.

Changes in v5:
 - Refactor the pinctrl target files based on the new macro and
   structure defined as suggested by Andy.

Changes in v4:
 - Fixed the bindings check and rebased on linux-next.

Changes in v3:
 - Rebased the bindings on linux-next as suggested by Krzysztof.

Changes in v2:
 - Updated the bindings to clear the bindings check.

This patch series adds pinctrl bindings and tlmm support for SDX75.

Thanks,
Rohit.


Rohit Agarwal (4):
  dt-bindings: pinctrl: qcom: Add SDX75 pinctrl devicetree compatible
  pinctrl: qcom: Remove the msm_function struct
  pinctrl: qcom: Refactor generic qcom pinctrl driver
  pinctrl: qcom: Add SDX75 pincontrol driver

 .../bindings/pinctrl/qcom,sdx75-tlmm.yaml          |  169 +++
 drivers/pinctrl/qcom/Kconfig                       |   30 +-
 drivers/pinctrl/qcom/Makefile                      |    3 +-
 drivers/pinctrl/qcom/pinctrl-apq8064.c             |  104 +-
 drivers/pinctrl/qcom/pinctrl-apq8084.c             |  264 ++--
 drivers/pinctrl/qcom/pinctrl-ipq4019.c             |  104 +-
 drivers/pinctrl/qcom/pinctrl-ipq5332.c             |  206 ++-
 drivers/pinctrl/qcom/pinctrl-ipq6018.c             |  260 ++--
 drivers/pinctrl/qcom/pinctrl-ipq8064.c             |  114 +-
 drivers/pinctrl/qcom/pinctrl-ipq8074.c             |  240 ++-
 drivers/pinctrl/qcom/pinctrl-mdm9607.c             |  276 ++--
 drivers/pinctrl/qcom/pinctrl-mdm9615.c             |   90 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |   13 +-
 drivers/pinctrl/qcom/pinctrl-msm.h                 |   42 +-
 drivers/pinctrl/qcom/pinctrl-msm8226.c             |  156 +-
 drivers/pinctrl/qcom/pinctrl-msm8660.c             |  252 ++--
 drivers/pinctrl/qcom/pinctrl-msm8909.c             |  268 ++--
 drivers/pinctrl/qcom/pinctrl-msm8916.c             |  556 ++++---
 drivers/pinctrl/qcom/pinctrl-msm8953.c             |  424 +++---
 drivers/pinctrl/qcom/pinctrl-msm8960.c             |  464 +++---
 drivers/pinctrl/qcom/pinctrl-msm8976.c             |  212 ++-
 drivers/pinctrl/qcom/pinctrl-msm8994.c             |  564 ++++---
 drivers/pinctrl/qcom/pinctrl-msm8996.c             |  508 +++----
 drivers/pinctrl/qcom/pinctrl-msm8998.c             |  380 +++--
 drivers/pinctrl/qcom/pinctrl-msm8x74.c             |  474 +++---
 drivers/pinctrl/qcom/pinctrl-qcm2290.c             |  230 ++-
 drivers/pinctrl/qcom/pinctrl-qcs404.c              |  388 +++--
 drivers/pinctrl/qcom/pinctrl-qdf2xxx.c             |    6 +-
 drivers/pinctrl/qcom/pinctrl-qdu1000.c             |  249 ++-
 drivers/pinctrl/qcom/pinctrl-sa8775p.c             |  308 ++--
 drivers/pinctrl/qcom/pinctrl-sc7180.c              |  254 ++--
 drivers/pinctrl/qcom/pinctrl-sc7280.c              |  322 ++--
 drivers/pinctrl/qcom/pinctrl-sc8180x.c             |  286 ++--
 drivers/pinctrl/qcom/pinctrl-sc8280xp.c            |  358 +++--
 drivers/pinctrl/qcom/pinctrl-sdm660.c              |  387 +++--
 drivers/pinctrl/qcom/pinctrl-sdm670.c              |  284 ++--
 drivers/pinctrl/qcom/pinctrl-sdm845.c              |  286 ++--
 drivers/pinctrl/qcom/pinctrl-sdx55.c               |  190 ++-
 drivers/pinctrl/qcom/pinctrl-sdx65.c               |  194 ++-
 drivers/pinctrl/qcom/pinctrl-sdx75.c               | 1595 ++++++++++++++++++++
 drivers/pinctrl/qcom/pinctrl-sm6115.c              |  162 +-
 drivers/pinctrl/qcom/pinctrl-sm6125.c              |  282 ++--
 drivers/pinctrl/qcom/pinctrl-sm6350.c              |  296 ++--
 drivers/pinctrl/qcom/pinctrl-sm6375.c              |  358 +++--
 drivers/pinctrl/qcom/pinctrl-sm8150.c              |  286 ++--
 drivers/pinctrl/qcom/pinctrl-sm8250.c              |  258 ++--
 drivers/pinctrl/qcom/pinctrl-sm8350.c              |  298 ++--
 drivers/pinctrl/qcom/pinctrl-sm8450.c              |  300 ++--
 drivers/pinctrl/qcom/pinctrl-sm8550.c              |  320 ++--
 49 files changed, 7757 insertions(+), 6313 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
 create mode 100644 drivers/pinctrl/qcom/pinctrl-sdx75.c

-- 
2.7.4


