Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D3F5B9129
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 01:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiINXst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 19:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiINXsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 19:48:22 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7188990A;
        Wed, 14 Sep 2022 16:48:06 -0700 (PDT)
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28ENMMnK031977;
        Wed, 14 Sep 2022 23:47:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=iqLzBmzE5BTockw4Tp6odyPOa+19hELeK9FqxRjRgxc=;
 b=gzYq7UrDtsYVNJXHvQKuzqKmBR51ViQODhcB36JPDvdR3vC5dPmXr+mJEnO49JalqgSc
 ZfR7DPnagVhQh/Zqxr87W9hIotDoAohh5rDQebv+r0Vu4/xczZayK+hK1qKQ6R2yASxu
 IQ2kSNugyXR17cnQLFc1BhX/ZOltvWUQBiiATzpRuDgkzB/G9Wkz8JMo1l/yIZFo5vVp
 Ap+ovt3uSOi+8k+AMXCC7D53T0x6lXLg/uecDj8BqtJKn3oeZlj7dSnpiVIl382lzGW/
 k8qZt9v8AGjUfPXoop4SA9cXlD31Kaj7vukxB0xFSKkGC8It+QPs/OAyQUc8lL4On4DJ UQ== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3jjxys4ayq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 23:47:25 +0000
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
        by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 28ENlOar030181;
        Wed, 14 Sep 2022 23:47:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 3jjqbt76e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 23:47:24 +0000
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28ENlOjG030176;
        Wed, 14 Sep 2022 23:47:24 GMT
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 28ENlOE1030175
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 23:47:24 +0000
Received: from quicinc.com (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 16:47:24 -0700
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
To:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kalle Valo <kvalo@kernel.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
CC:     <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: [PATCH v2 0/4] Make QMI message rules const
Date:   Wed, 14 Sep 2022 16:47:01 -0700
Message-ID: <20220914234705.28405-1-quic_jjohnson@quicinc.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220912232526.27427-1-quic_jjohnson@quicinc.com>
References: <20220912232526.27427-1-quic_jjohnson@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: arZCbROUhuHu0e98sanOCBuW30PwvKB4
X-Proofpoint-GUID: arZCbROUhuHu0e98sanOCBuW30PwvKB4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-14_09,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 impostorscore=0
 adultscore=0 mlxlogscore=716 spamscore=0 clxscore=1015 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209140113
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ff6d365898d4 ("soc: qcom: qmi: use const for struct
qmi_elem_info") allows QMI message encoding/decoding rules to be
const. So now update the definitions in the various clients to take
advantage of this. Patches for ath10k and ath11k were previously sent
separately.

This series depends upon:
https://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git/commit/?h=for-next&id=ff6d365898d4d31bd557954c7fc53f38977b491c

This is in the for-next branch of:
git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git

Hence this series is also based upon that tree/branch.

Changes in v2 (applied to all 4 patches in the series):
- Fixed the truncated hash ff6d365898d ==> ff6d365898d4
- Added RB tags

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

