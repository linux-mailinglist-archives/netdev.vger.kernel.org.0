Return-Path: <netdev+bounces-65-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9576A6F4FBF
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 07:40:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A85FE280DAF
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 05:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2475A4A;
	Wed,  3 May 2023 05:39:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB37BA3F
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 05:39:54 +0000 (UTC)
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E7B272A;
	Tue,  2 May 2023 22:39:52 -0700 (PDT)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3434d6T4017150;
	Wed, 3 May 2023 05:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id; s=qcppdkim1;
 bh=ENxw/JCrLtYu8WfwwfaPXAWAiQBbLkeSry/e0BLyOs0=;
 b=kDlaMpTor6HPVXdB8ABW1fYlu8UjAz4SD8MehlOTRwMkoAA6QyrBNJ7y+2t4oN6WRWk2
 bTRdGd9g2OoErgg1LGcSrY1YY6or4mKMsXApjJHauh3wODLPAB1btu2elh8PT+gqZKRF
 cIKlCBRS3vN0eSCUGZ9YL6MF6wPOlgr9tdF39J2UxW2OcaZIoGGDJwuJu2OL3mbfrrLE
 gA/MW5H2TDLPMZRBIkQT6nrf3SvMUL3KAHHYQP2+M7Aby+yty8YznRV9aA/dtep2OTpv
 h7ZAvgl3rNWGHMxWFH6Qrs73+pIt4k8C/u90FEFQtDhbfnJB1/wIIG+e+KWGIX1dlDV/ Zw== 
Received: from apblrppmta02.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qbbsw0k12-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 May 2023 05:39:46 +0000
Received: from pps.filterd (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 3435dgXm012673;
	Wed, 3 May 2023 05:39:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 3q8vakyggx-1;
	Wed, 03 May 2023 05:39:42 +0000
Received: from APBLRPPMTA02.qualcomm.com (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3435dghQ012660;
	Wed, 3 May 2023 05:39:42 GMT
Received: from hu-sgudaval-hyd.qualcomm.com (hu-rohiagar-hyd.qualcomm.com [10.213.106.138])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 3435dglH012657;
	Wed, 03 May 2023 05:39:42 +0000
Received: by hu-sgudaval-hyd.qualcomm.com (Postfix, from userid 3970568)
	id C3C6250F8; Wed,  3 May 2023 11:09:41 +0530 (+0530)
From: Rohit Agarwal <quic_rohiagar@quicinc.com>
To: agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        linus.walleij@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com,
        manivannan.sadhasivam@linaro.org, andy.shevchenko@gmail.com
Cc: linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rohit Agarwal <quic_rohiagar@quicinc.com>
Subject: [PATCH v5 0/3] Add pinctrl support for SDX75
Date: Wed,  3 May 2023 11:09:37 +0530
Message-Id: <1683092380-29551-1-git-send-email-quic_rohiagar@quicinc.com>
X-Mailer: git-send-email 2.7.4
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 3vW9V_HkTxnzXPSA9-RFCx5U_48pvB8R
X-Proofpoint-ORIG-GUID: 3vW9V_HkTxnzXPSA9-RFCx5U_48pvB8R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_02,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=752 impostorscore=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305030044
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

Hi,

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

Rohit Agarwal (3):
  dt-bindings: pinctrl: qcom: Add SDX75 pinctrl devicetree compatible
  pinctrl: qcom: Refactor target specific pinctrl driver
  pinctrl: qcom: Add SDX75 pincontrol driver

 .../bindings/pinctrl/qcom,sdx75-tlmm.yaml          |  169 +++
 drivers/pinctrl/qcom/Kconfig                       |   30 +-
 drivers/pinctrl/qcom/Makefile                      |    3 +-
 drivers/pinctrl/qcom/pinctrl-apq8064.c             |   19 +-
 drivers/pinctrl/qcom/pinctrl-apq8084.c             |   17 +-
 drivers/pinctrl/qcom/pinctrl-ipq4019.c             |   12 +-
 drivers/pinctrl/qcom/pinctrl-ipq5332.c             |   12 +-
 drivers/pinctrl/qcom/pinctrl-ipq6018.c             |   12 +-
 drivers/pinctrl/qcom/pinctrl-ipq8064.c             |   17 +-
 drivers/pinctrl/qcom/pinctrl-ipq8074.c             |   12 +-
 drivers/pinctrl/qcom/pinctrl-mdm9607.c             |   17 +-
 drivers/pinctrl/qcom/pinctrl-mdm9615.c             |   12 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |   18 +-
 drivers/pinctrl/qcom/pinctrl-msm.h                 |   17 +-
 drivers/pinctrl/qcom/pinctrl-msm8226.c             |   17 +-
 drivers/pinctrl/qcom/pinctrl-msm8660.c             |   17 +-
 drivers/pinctrl/qcom/pinctrl-msm8909.c             |   17 +-
 drivers/pinctrl/qcom/pinctrl-msm8916.c             |   17 +-
 drivers/pinctrl/qcom/pinctrl-msm8953.c             |   17 +-
 drivers/pinctrl/qcom/pinctrl-msm8960.c             |   17 +-
 drivers/pinctrl/qcom/pinctrl-msm8976.c             |   17 +-
 drivers/pinctrl/qcom/pinctrl-msm8994.c             |   17 +-
 drivers/pinctrl/qcom/pinctrl-msm8996.c             |   17 +-
 drivers/pinctrl/qcom/pinctrl-msm8998.c             |   21 +-
 drivers/pinctrl/qcom/pinctrl-msm8x74.c             |   22 +-
 drivers/pinctrl/qcom/pinctrl-qcm2290.c             |   22 +-
 drivers/pinctrl/qcom/pinctrl-qcs404.c              |   17 +-
 drivers/pinctrl/qcom/pinctrl-qdf2xxx.c             |    6 +-
 drivers/pinctrl/qcom/pinctrl-qdu1000.c             |   22 +-
 drivers/pinctrl/qcom/pinctrl-sa8775p.c             |   22 +-
 drivers/pinctrl/qcom/pinctrl-sc7180.c              |   22 +-
 drivers/pinctrl/qcom/pinctrl-sc7280.c              |   22 +-
 drivers/pinctrl/qcom/pinctrl-sc8180x.c             |   22 +-
 drivers/pinctrl/qcom/pinctrl-sc8280xp.c            |   22 +-
 drivers/pinctrl/qcom/pinctrl-sdm660.c              |   17 +-
 drivers/pinctrl/qcom/pinctrl-sdm670.c              |   27 +-
 drivers/pinctrl/qcom/pinctrl-sdm845.c              |   22 +-
 drivers/pinctrl/qcom/pinctrl-sdx55.c               |   17 +-
 drivers/pinctrl/qcom/pinctrl-sdx65.c               |   22 +-
 drivers/pinctrl/qcom/pinctrl-sdx75.c               | 1601 ++++++++++++++++++++
 drivers/pinctrl/qcom/pinctrl-sm6115.c              |   22 +-
 drivers/pinctrl/qcom/pinctrl-sm6125.c              |   22 +-
 drivers/pinctrl/qcom/pinctrl-sm6350.c              |   22 +-
 drivers/pinctrl/qcom/pinctrl-sm6375.c              |   21 +-
 drivers/pinctrl/qcom/pinctrl-sm8150.c              |   22 +-
 drivers/pinctrl/qcom/pinctrl-sm8250.c              |   22 +-
 drivers/pinctrl/qcom/pinctrl-sm8350.c              |   22 +-
 drivers/pinctrl/qcom/pinctrl-sm8450.c              |   22 +-
 drivers/pinctrl/qcom/pinctrl-sm8550.c              |   22 +-
 49 files changed, 2138 insertions(+), 505 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
 create mode 100644 drivers/pinctrl/qcom/pinctrl-sdx75.c

-- 
2.7.4


