Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8705B640E
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 01:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiILX0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 19:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiILX0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 19:26:02 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8E450044;
        Mon, 12 Sep 2022 16:26:01 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CMSTSu018171;
        Mon, 12 Sep 2022 23:25:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=oqJb4HvqB63x63dwxRguLQ+5LdFWrd/HME6lfEYDy5E=;
 b=KD6/fjMApRroMqm2lKRELDlB6HqNOm0Vpk19HUpCVwUzIJecuaUbAor+lrFI6T9Rb+8M
 UDT3TuAXqKfyWxI5xK9ltkBeDVTRoBr+765HpZDJBISBbSjBTMuv5jX0ykQPvSqKW7aR
 1+4fLDaCmkxbeRcMRwPSsFcftdEpi0rSLETbQ+A7re+x8I4z4oo7quHuSFzkkOxLHBXa
 PzG4Xxa382QGxphO9dChoZ5n6IU/gFxoqxkME/Qb8IXAgctdwdjGnT1VEFOIufIoVYkx
 PART4EzhQ9GD75Gq+TpzKnOz5C25+br7Kx4Cog08WcVydxxTK4EB2AK+mN4QkJ5tKMe8 1w== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jgkve6j79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 23:25:41 +0000
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
        by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 28CNPeKW001491;
        Mon, 12 Sep 2022 23:25:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 3jj1t3jps2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 23:25:40 +0000
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28CNPe73001485;
        Mon, 12 Sep 2022 23:25:40 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 28CNPem9001484
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 23:25:40 +0000
Received: from quicinc.com (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 12 Sep
 2022 16:25:40 -0700
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
To:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kalle Valo <kvalo@kernel.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
CC:     <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: [PATCH 0/4] Make QMI message rules const
Date:   Mon, 12 Sep 2022 16:25:22 -0700
Message-ID: <20220912232526.27427-1-quic_jjohnson@quicinc.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: l38WDwIujt3VUH1JMRMjEk2U9wCsrn1z
X-Proofpoint-GUID: l38WDwIujt3VUH1JMRMjEk2U9wCsrn1z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_14,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 adultscore=0 mlxlogscore=704 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209120082
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change ff6d365898d ("soc: qcom: qmi: use const for struct
qmi_elem_info") allows QMI message encoding/decoding rules to be
const. So now update the definitions in the various client to take
advantage of this. Patches for ath10k and ath11k were perviously sent
separately.

This series depends upon:
https://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git/commit/?h=for-next&id=ff6d365898d4d31bd557954c7fc53f38977b491c

This is in the for-next banch of:
git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git

Hence this series is also based upon that tree/branch.

Jeff Johnson (4):
  net: ipa: Make QMI message rules const
  remoteproc: sysmon: Make QMI message rules const
  slimbus: qcom-ngd-ctrl: Make QMI message rules const
  soc: qcom: pdr: Make QMI message rules const

 drivers/net/ipa/ipa_qmi_msg.c    | 20 ++++++++++----------
 drivers/net/ipa/ipa_qmi_msg.h    | 20 ++++++++++----------
 drivers/remoteproc/qcom_sysmon.c |  8 ++++----
 drivers/slimbus/qcom-ngd-ctrl.c  |  8 ++++----
 drivers/soc/qcom/pdr_internal.h  | 20 ++++++++++----------
 5 files changed, 38 insertions(+), 38 deletions(-)

-- 
2.37.0

