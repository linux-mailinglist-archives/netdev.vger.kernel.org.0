Return-Path: <netdev+bounces-2522-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8265D70252E
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:46:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 495DB1C20A7B
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 245526FC1;
	Mon, 15 May 2023 06:46:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AE2539C
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:46:28 +0000 (UTC)
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFB8D3;
	Sun, 14 May 2023 23:46:27 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34F6eXLl011183;
	Mon, 15 May 2023 06:46:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id; s=qcppdkim1;
 bh=+3YRgdCc5OGUZgyve6jYjpoLDxZPaQXG3x9Z0SG9BLY=;
 b=fKYCAQIX0op7k4mpEbax1O2BK1EeZSY8SBhS7E4UChwHvrpZ+zMh+CuHNtiacVL/R7CF
 pKoIsC/TqKLCNJCsb+2fDZiDqvpue67jPokHtSNb4H2P0+KlIg02GCLZm0jMkR+CaL68
 wxG1NjamXQpgiGEwCQBDwYyyXrR6tp2Du2btOvr1YbRTJOY4mXazxh1RIW5uT6t+V4Bw
 kbnSdlOk8URdCM3XcgP4860JGutRvN8UzwscooxO4j9uJVVVgfeEhUxmpSnJJ+D1KXaE
 BUPqD24aRAXdMPL9ITIugwCqsbpZxQA7XbX4jOKSMXM0J26pwURyR6EdycXJPXKwrQXc Ig== 
Received: from apblrppmta01.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qj3udjv2r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 May 2023 06:46:17 +0000
Received: from pps.filterd (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 34F6kDU6012956;
	Mon, 15 May 2023 06:46:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTP id 3qj3mkc3bn-1;
	Mon, 15 May 2023 06:46:13 +0000
Received: from APBLRPPMTA01.qualcomm.com (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34F6kCEP012944;
	Mon, 15 May 2023 06:46:13 GMT
Received: from hu-sgudaval-hyd.qualcomm.com (hu-rohiagar-hyd.qualcomm.com [10.213.106.138])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTP id 34F6kCHh012942;
	Mon, 15 May 2023 06:46:12 +0000
Received: by hu-sgudaval-hyd.qualcomm.com (Postfix, from userid 3970568)
	id F0DCA5102; Mon, 15 May 2023 12:16:11 +0530 (+0530)
From: Rohit Agarwal <quic_rohiagar@quicinc.com>
To: agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        linus.walleij@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com,
        manivannan.sadhasivam@linaro.org, andy.shevchenko@gmail.com
Cc: linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rohit Agarwal <quic_rohiagar@quicinc.com>
Subject: [PATCH v2 0/2] Refactor the pinctrl driver
Date: Mon, 15 May 2023 12:16:08 +0530
Message-Id: <1684133170-18540-1-git-send-email-quic_rohiagar@quicinc.com>
X-Mailer: git-send-email 2.7.4
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: aLuswpEGb6M7OH6GTJ6l2J1KFH5a3m8u
X-Proofpoint-ORIG-GUID: aLuswpEGb6M7OH6GTJ6l2J1KFH5a3m8u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-15_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 clxscore=1015 suspectscore=0 adultscore=0 mlxlogscore=437
 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305150060
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

Hi,

Changes in v2:
 - Added changes for SM7150 as well.

This series refactor the target specific pinctrl driver for qcom
by reusing the generic pinfunction struct, pingroup struct and the defined
macros to avoid code repetition.
The series is rebased on linux-next and based on all the review and
comments from different versions of [1].

[1] https://lore.kernel.org/linux-arm-msm/1681966915-15720-1-git-send-email-quic_rohiagar@quicinc.com/

Thanks,
Rohit.

Rohit Agarwal (2):
  pinctrl: qcom: Remove the msm_function struct
  pinctrl: qcom: Refactor generic qcom pinctrl driver

 drivers/pinctrl/qcom/pinctrl-apq8064.c  | 104 +++---
 drivers/pinctrl/qcom/pinctrl-apq8084.c  | 264 ++++++++-------
 drivers/pinctrl/qcom/pinctrl-ipq4019.c  | 104 +++---
 drivers/pinctrl/qcom/pinctrl-ipq5332.c  | 206 ++++++------
 drivers/pinctrl/qcom/pinctrl-ipq6018.c  | 260 +++++++--------
 drivers/pinctrl/qcom/pinctrl-ipq8064.c  | 114 +++----
 drivers/pinctrl/qcom/pinctrl-ipq8074.c  | 240 +++++++-------
 drivers/pinctrl/qcom/pinctrl-ipq9574.c  | 176 +++++-----
 drivers/pinctrl/qcom/pinctrl-mdm9607.c  | 276 ++++++++--------
 drivers/pinctrl/qcom/pinctrl-mdm9615.c  |  90 +++--
 drivers/pinctrl/qcom/pinctrl-msm.c      |  13 +-
 drivers/pinctrl/qcom/pinctrl-msm.h      |  42 ++-
 drivers/pinctrl/qcom/pinctrl-msm8226.c  | 156 +++++----
 drivers/pinctrl/qcom/pinctrl-msm8660.c  | 252 +++++++-------
 drivers/pinctrl/qcom/pinctrl-msm8909.c  | 268 ++++++++-------
 drivers/pinctrl/qcom/pinctrl-msm8916.c  | 556 ++++++++++++++++---------------
 drivers/pinctrl/qcom/pinctrl-msm8953.c  | 424 ++++++++++++------------
 drivers/pinctrl/qcom/pinctrl-msm8960.c  | 464 +++++++++++++-------------
 drivers/pinctrl/qcom/pinctrl-msm8976.c  | 212 ++++++------
 drivers/pinctrl/qcom/pinctrl-msm8994.c  | 564 ++++++++++++++++----------------
 drivers/pinctrl/qcom/pinctrl-msm8996.c  | 508 ++++++++++++++--------------
 drivers/pinctrl/qcom/pinctrl-msm8998.c  | 380 +++++++++++----------
 drivers/pinctrl/qcom/pinctrl-msm8x74.c  | 474 +++++++++++++--------------
 drivers/pinctrl/qcom/pinctrl-qcm2290.c  | 230 +++++++------
 drivers/pinctrl/qcom/pinctrl-qcs404.c   | 388 +++++++++++-----------
 drivers/pinctrl/qcom/pinctrl-qdf2xxx.c  |   6 +-
 drivers/pinctrl/qcom/pinctrl-qdu1000.c  | 249 +++++++-------
 drivers/pinctrl/qcom/pinctrl-sa8775p.c  | 308 +++++++++--------
 drivers/pinctrl/qcom/pinctrl-sc7180.c   | 254 +++++++-------
 drivers/pinctrl/qcom/pinctrl-sc7280.c   | 322 +++++++++---------
 drivers/pinctrl/qcom/pinctrl-sc8180x.c  | 286 ++++++++--------
 drivers/pinctrl/qcom/pinctrl-sc8280xp.c | 358 ++++++++++----------
 drivers/pinctrl/qcom/pinctrl-sdm660.c   | 387 +++++++++++-----------
 drivers/pinctrl/qcom/pinctrl-sdm670.c   | 284 ++++++++--------
 drivers/pinctrl/qcom/pinctrl-sdm845.c   | 286 ++++++++--------
 drivers/pinctrl/qcom/pinctrl-sdx55.c    | 190 ++++++-----
 drivers/pinctrl/qcom/pinctrl-sdx65.c    | 194 ++++++-----
 drivers/pinctrl/qcom/pinctrl-sm6115.c   | 162 +++++----
 drivers/pinctrl/qcom/pinctrl-sm6125.c   | 282 ++++++++--------
 drivers/pinctrl/qcom/pinctrl-sm6350.c   | 296 ++++++++---------
 drivers/pinctrl/qcom/pinctrl-sm6375.c   | 358 ++++++++++----------
 drivers/pinctrl/qcom/pinctrl-sm7150.c   | 247 +++++++-------
 drivers/pinctrl/qcom/pinctrl-sm8150.c   | 286 ++++++++--------
 drivers/pinctrl/qcom/pinctrl-sm8250.c   | 258 +++++++--------
 drivers/pinctrl/qcom/pinctrl-sm8350.c   | 298 ++++++++---------
 drivers/pinctrl/qcom/pinctrl-sm8450.c   | 300 +++++++++--------
 drivers/pinctrl/qcom/pinctrl-sm8550.c   | 320 +++++++++---------
 47 files changed, 6175 insertions(+), 6521 deletions(-)

-- 
2.7.4


