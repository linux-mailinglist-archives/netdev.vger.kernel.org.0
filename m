Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C486E7AC2
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 15:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbjDSNas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 09:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbjDSNap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 09:30:45 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89FD118DB;
        Wed, 19 Apr 2023 06:30:42 -0700 (PDT)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33J9Vw3f019170;
        Wed, 19 Apr 2023 13:30:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=qcppdkim1;
 bh=3/4LOYP4bcBxN7rBsgeI0mA4SxJDW4dMYl8d7m/+UUI=;
 b=OfVsM3/hKTRnW/IANAANLjYd/RRHlAfEn4Vf3jw7dwoOUDSf0Iga2gYnCaI6Cq5Qcd6T
 KIbT7XzRhPKB4vHxYIwmRz4WrkgESMMDDeOpJRRnaM8zlGYzQCmMOPJ1ZZJHMKbsm6f6
 rmjncLsThA0qmchNvJqaovBx1cp0KqblaaxJczLSV0HtBo5NmlCWPcZYdirGRGlTpxn5
 KuXITKk3wLkrv8EoDzbbBEQEz812+VgTnISMG3A66/kAre9WJPUSAFK/ktphdLDQbmaE
 3nGViY8T98+igFMtC9tmsunzxfMkI+ujTCZniTz9JXwiCVSoXOBncB76WOtj+XbltGRA NQ== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3q234h9ttt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 13:30:36 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 33JDUZAt010546
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 13:30:35 GMT
Received: from hu-tdas-hyd.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Wed, 19 Apr 2023 06:30:29 -0700
From:   Taniya Das <quic_tdas@quicinc.com>
To:     Stephen Boyd <sboyd@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        Andy Gross <agross@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Michael Turquette <mturquette@baylibre.com>
CC:     <quic_skakitap@quicinc.com>,
        Imran Shaik <quic_imrashai@quicinc.com>,
        <linux-arm-msm@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Taniya Das <quic_tdas@quicinc.com>,
        <quic_rohiagar@quicinc.com>, <netdev@vger.kernel.org>
Subject: [PATCH 0/4] Add GCC and RPMHCC support for sdx75
Date:   Wed, 19 Apr 2023 19:00:09 +0530
Message-ID: <20230419133013.2563-1-quic_tdas@quicinc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: jbH2GNoPS2CqrYWOh5a5-Dad0XklO1lu
X-Proofpoint-ORIG-GUID: jbH2GNoPS2CqrYWOh5a5-Dad0XklO1lu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_08,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 clxscore=1011 malwarescore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304190121
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches extends the invert logic for branch2 clocks and adds
GCC, RPMH clocks devicetree bindings and driver support for SDX75 platform.

Imran Shaik (4):
  clk: qcom: branch: Extend the invert logic for branch2 clocks
  dt-bindings: clock: Add GCC bindings support for SDX75
  clk: qcom: rpmh: Add RPMH clocks support for SDX75
  clk: qcom: Add GCC driver support for SDX75

 .../bindings/clock/qcom,gcc-sdx75.yaml        |   69 +
 .../bindings/clock/qcom,rpmhcc.yaml           |    1 +
 drivers/clk/qcom/Kconfig                      |    8 +
 drivers/clk/qcom/Makefile                     |    1 +
 drivers/clk/qcom/clk-branch.c                 |    8 +
 drivers/clk/qcom/clk-rpmh.c                   |   19 +
 drivers/clk/qcom/gcc-sdx75.c                  | 2990 +++++++++++++++++
 include/dt-bindings/clock/qcom,gcc-sdx75.h    |  193 ++
 8 files changed, 3289 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/qcom,gcc-sdx75.yaml
 create mode 100644 drivers/clk/qcom/gcc-sdx75.c
 create mode 100644 include/dt-bindings/clock/qcom,gcc-sdx75.h

--
2.17.1

