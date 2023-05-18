Return-Path: <netdev+bounces-3620-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1B21708183
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 14:41:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BFAF28188F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6685823C6C;
	Thu, 18 May 2023 12:41:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51ABE23C64
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 12:41:22 +0000 (UTC)
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBD210D0;
	Thu, 18 May 2023 05:41:20 -0700 (PDT)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ICIjkE013750;
	Thu, 18 May 2023 12:41:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id; s=qcppdkim1;
 bh=KpbdIVY+Eyw1nBwyubjGYOmLcLh5y69C4bam9uWLNvg=;
 b=Cd73iwDp7jQo6zPP0dXxt7gjVvkLMlXObNpmUcD+3WoN7GQDt8Ot00rg7DNALj2p/YBc
 fNcNoesmUPPcbhMjvSCoHkc3dTyg8TJFSpx8VQXt1et5yChxIdbU9KBuRVTdE2WHsEg/
 jSidTqFMXitFAt6FZXLKl2X+Q+WiHHG+iQgPWJvW5lJIVuUqs53QAkcL1zumR6ahwooL
 +HZ8wbvUbE1wQvnvJlXlrXeiXbQEHITEaZ3XefqzULN1lVowzZi/11FWlOUP8C8jy+Mp
 v4G9n8CqJx4lGIxCujc7BVKs5HB7qVbVW+5Q+Xizy4TZjpRb8HZJvcyQTnPFNWH61LM8 RA== 
Received: from apblrppmta01.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qncbhrxdj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 May 2023 12:41:16 +0000
Received: from pps.filterd (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 34ICfDhH019476;
	Thu, 18 May 2023 12:41:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTP id 3qj3mkyxcy-1;
	Thu, 18 May 2023 12:41:13 +0000
Received: from APBLRPPMTA01.qualcomm.com (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34ICfDwP019466;
	Thu, 18 May 2023 12:41:13 GMT
Received: from hu-sgudaval-hyd.qualcomm.com (hu-rohiagar-hyd.qualcomm.com [10.213.106.138])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTP id 34ICfCn5019464;
	Thu, 18 May 2023 12:41:13 +0000
Received: by hu-sgudaval-hyd.qualcomm.com (Postfix, from userid 3970568)
	id 217635EB5; Thu, 18 May 2023 18:11:12 +0530 (+0530)
From: Rohit Agarwal <quic_rohiagar@quicinc.com>
To: agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        linus.walleij@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        richardcochran@gmail.com, manivannan.sadhasivam@linaro.org
Cc: linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rohit Agarwal <quic_rohiagar@quicinc.com>
Subject: [PATCH v2 0/3] Add pinctrl support for SDX75
Date: Thu, 18 May 2023 18:11:07 +0530
Message-Id: <1684413670-12901-1-git-send-email-quic_rohiagar@quicinc.com>
X-Mailer: git-send-email 2.7.4
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: HSE3rSczfwDrUHPY0EydK6whxBsymmDH
X-Proofpoint-ORIG-GUID: HSE3rSczfwDrUHPY0EydK6whxBsymmDH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_09,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=698 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305180100
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

Changes in v2:
 - Added a patch for updating the maintainers entry for pinctrl bindings.
 - Some formatting issue at the end of the driver change.

This patch series adds pinctrl bindings and tlmm support for SDX75.

The series is rebased on linux-next and based on all the review and
comments from different versions of [1].

[1] https://lore.kernel.org/linux-arm-msm/1681966915-15720-1-git-send-email-quic_rohiagar@quicinc.com/

Thanks,
Rohit.


Rohit Agarwal (3):
  dt-bindings: pinctrl: qcom: Add SDX75 pinctrl devicetree compatible
  MAINTAINERS: Update the entry for pinctrl maintainers
  pinctrl: qcom: Add SDX75 pincontrol driver

 .../bindings/pinctrl/qcom,sdx75-tlmm.yaml          |  137 +++
 MAINTAINERS                                        |    2 +-
 drivers/pinctrl/qcom/Kconfig                       |   30 +-
 drivers/pinctrl/qcom/Makefile                      |    3 +-
 drivers/pinctrl/qcom/pinctrl-sdx75.c               | 1145 ++++++++++++++++++++
 5 files changed, 1305 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
 create mode 100644 drivers/pinctrl/qcom/pinctrl-sdx75.c

-- 
2.7.4


