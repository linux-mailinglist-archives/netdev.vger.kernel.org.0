Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEDE57C423
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 08:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbiGUGHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 02:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiGUGHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 02:07:24 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89857AC36;
        Wed, 20 Jul 2022 23:07:19 -0700 (PDT)
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26L5Oqjo015031;
        Thu, 21 Jul 2022 06:05:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=qcppdkim1;
 bh=3NABkatQel865jMZ7nnDNww3Y+6BIMJ2G7CQK16L410=;
 b=AaKdaZynDx4RDgu4BJbRPIkzl9F4+3jnQm/AiidXl7wNEaQyx2KyvM6585YoJxqT0q28
 RDaT6VaZxSGSjv+FeToecrA1ikYtevHfAm2z1ND2/lVrg03JMISpRNQSB0aS1jxEWzqc
 d73oN+s9x7P11r1Z05ukCae3vbK0PCARCPXrjdgHc5gm14wg8rHeoGNghh3+qGVD/D3K
 7M1XIEPPb6Ed2COGM/1/WwZMeSKm9IEAwD68u1EY3Jr1MshRG9bgSmO9zwe/hw0JXozC
 LfecrvRgLz3DP6AAwi6t9SEIu0Jm7pRydyubAS3fGB4+mVjyLEyVLHRyf6KOUMCIaP6x 9Q== 
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3heb3x33pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 06:05:03 +0000
Received: from pps.filterd (NASANPPMTA04.qualcomm.com [127.0.0.1])
        by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 26L64pVC017305;
        Thu, 21 Jul 2022 06:05:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NASANPPMTA04.qualcomm.com (PPS) with ESMTPS id 3hc6s4j7e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 06:05:02 +0000
Received: from NASANPPMTA04.qualcomm.com (NASANPPMTA04.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26L6521F017667;
        Thu, 21 Jul 2022 06:05:02 GMT
Received: from nasanex01a.na.qualcomm.com ([10.52.223.231])
        by NASANPPMTA04.qualcomm.com (PPS) with ESMTPS id 26L652oo017665
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 06:05:02 +0000
Received: from zijuhu-gv.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 20 Jul 2022 23:04:58 -0700
From:   Zijun Hu <quic_zijuhu@quicinc.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <luiz.von.dentz@intel.com>, <swyterzone@gmail.com>,
        <quic_zijuhu@quicinc.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 4/4] Bluetooth: hci_sync: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING
Date:   Thu, 21 Jul 2022 14:04:33 +0800
Message-ID: <1658383473-32188-5-git-send-email-quic_zijuhu@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1658383473-32188-1-git-send-email-quic_zijuhu@quicinc.com>
References: <1658383473-32188-1-git-send-email-quic_zijuhu@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: Wop703_cs5VbQ8zYVhQbTgu4AsU-64LD
X-Proofpoint-ORIG-GUID: Wop703_cs5VbQ8zYVhQbTgu4AsU-64LD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-20_12,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 impostorscore=0 spamscore=0 clxscore=1015 suspectscore=0
 bulkscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Core driver addtionally checks LMP feature bit "Erroneous Data Reporting"
instead of quirk HCI_QUIRK_BROKEN_ERR_DATA_REPORTING to decide if HCI
commands HCI_Read|Write_Default_Erroneous_Data_Reporting are broken, so
remove this unnecessary quirk.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Tested-by: Zijun Hu <quic_zijuhu@quicinc.com>
---
 include/net/bluetooth/hci.h | 11 -----------
 net/bluetooth/hci_sync.c    |  3 ---
 2 files changed, 14 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 5cf0fbfb89b4..927f51b92854 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -228,17 +228,6 @@ enum {
 	 */
 	HCI_QUIRK_VALID_LE_STATES,
 
-	/* When this quirk is set, then erroneous data reporting
-	 * is ignored. This is mainly due to the fact that the HCI
-	 * Read Default Erroneous Data Reporting command is advertised,
-	 * but not supported; these controllers often reply with unknown
-	 * command and tend to lock up randomly. Needing a hard reset.
-	 *
-	 * This quirk can be set before hci_register_dev is called or
-	 * during the hdev->setup vendor callback.
-	 */
-	HCI_QUIRK_BROKEN_ERR_DATA_REPORTING,
-
 	/*
 	 * When this quirk is set, then the hci_suspend_notifier is not
 	 * registered. This is intended for devices which drop completely
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 3881c3230643..85d1605d9b07 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3865,9 +3865,6 @@ static const struct {
 	HCI_QUIRK_BROKEN(STORED_LINK_KEY,
 			 "HCI Delete Stored Link Key command is advertised, "
 			 "but not supported."),
-	HCI_QUIRK_BROKEN(ERR_DATA_REPORTING,
-			 "HCI Read Default Erroneous Data Reporting command is "
-			 "advertised, but not supported."),
 	HCI_QUIRK_BROKEN(READ_TRANSMIT_POWER,
 			 "HCI Read Transmit Power Level command is advertised, "
 			 "but not supported."),
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

