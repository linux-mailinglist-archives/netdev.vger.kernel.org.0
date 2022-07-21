Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3FFC57C421
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 08:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbiGUGHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 02:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiGUGHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 02:07:09 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE76C7AC22;
        Wed, 20 Jul 2022 23:07:08 -0700 (PDT)
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26L4IRsu012154;
        Thu, 21 Jul 2022 06:04:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=qcppdkim1;
 bh=SQNfcNEbrZIlU5RmLbPrl2rpv4bjceec877Ap7GBD5M=;
 b=MSVLMoGvOF7rWOI8uhcI9jsLucu6BGidEJkhCAj814h+dFQQLL9uwT9gyVk9v5eo6Jr9
 GUq/eBqB8dfPPA8Vntt7mlGS3pNXrXmu+r0CwDy79WLHuaT/DhE1nn+jQnUVvW7rRY11
 lTVs97ddj2XzZH4UPEYHROUW1I7eGRCSnQFzIogNMDValOrjB6dBeDt5v0FnXsaKId25
 HOtqKktCzWl7ufNxU28fZAwYy/9zNYZeD7bSVPMKHxYadhhjGiGcr0crV6tEQcmOVqGo
 dquMpLscvN2ZTKohBLDcOQeRcT69dTktOVM04alrWcskKc7ubtTHIG/LXrMxpDqYlHPt jg== 
Received: from nasanppmta04.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3hef6sthj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 06:04:52 +0000
Received: from pps.filterd (NASANPPMTA04.qualcomm.com [127.0.0.1])
        by NASANPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 26L64pVB017305;
        Thu, 21 Jul 2022 06:04:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by NASANPPMTA04.qualcomm.com (PPS) with ESMTPS id 3hc6s4j7cx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 06:04:51 +0000
Received: from NASANPPMTA04.qualcomm.com (NASANPPMTA04.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26L64pPK017295;
        Thu, 21 Jul 2022 06:04:51 GMT
Received: from nasanex01a.na.qualcomm.com ([10.52.223.231])
        by NASANPPMTA04.qualcomm.com (PPS) with ESMTPS id 26L64pLb017293
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 06:04:51 +0000
Received: from zijuhu-gv.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 20 Jul 2022 23:04:48 -0700
From:   Zijun Hu <quic_zijuhu@quicinc.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <luiz.von.dentz@intel.com>, <swyterzone@gmail.com>,
        <quic_zijuhu@quicinc.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 2/4] Bluetooth: btusb: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for QCA
Date:   Thu, 21 Jul 2022 14:04:31 +0800
Message-ID: <1658383473-32188-3-git-send-email-quic_zijuhu@quicinc.com>
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
X-Proofpoint-ORIG-GUID: D5z0Z3Z5Xoz8OQXcNFjzEQU_QMiZjh6W
X-Proofpoint-GUID: D5z0Z3Z5Xoz8OQXcNFjzEQU_QMiZjh6W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-20_12,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 malwarescore=0 spamscore=0 clxscore=1011
 adultscore=0 impostorscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210023
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Core driver addtionally checks LMP feature bit "Erroneous Data Reporting"
instead of quirk HCI_QUIRK_BROKEN_ERR_DATA_REPORTING to decide if HCI
commands HCI_Read|Write_Default_Erroneous_Data_Reporting are broken, so
remove this unnecessary quirk for QCA controllers.

The reason why these two HCI commands are broken for QCA controllers is
that feature "Erroneous Data Reporting" is not enabled by their firmware
as shown by below log:

@ RAW Open: hcitool (privileged) version 2.22
< HCI Command: Read Local Supported Commands (0x04|0x0002) plen 0
> HCI Event: Command Complete (0x0e) plen 68
  Read Local Supported Commands (0x04|0x0002) ncmd 1
    Status: Success (0x00)
    Commands: 288 entries
......
      Read Default Erroneous Data Reporting (Octet 18 - Bit 2)
      Write Default Erroneous Data Reporting (Octet 18 - Bit 3)
......

< HCI Command: Read Default Erroneous Data Reporting (0x03|0x005a) plen 0
> HCI Event: Command Complete (0x0e) plen 4
  Read Default Erroneous Data Reporting (0x03|0x005a) ncmd 1
    Status: Unknown HCI Command (0x01)

< HCI Command: Read Local Supported Features (0x04|0x0003) plen 0
> HCI Event: Command Complete (0x0e) plen 12
  Read Local Supported Features (0x04|0x0003) ncmd 1
    Status: Success (0x00)
    Features: 0xff 0xfe 0x0f 0xfe 0xd8 0x3f 0x5b 0x87
      3 slot packets
......

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Tested-by: Zijun Hu <quic_zijuhu@quicinc.com>
---
 drivers/bluetooth/btusb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 21135a419bcc..6b7e721bd57c 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3370,7 +3370,6 @@ static int btusb_setup_qca(struct hci_dev *hdev)
 	 * work with the likes of HSP/HFP mSBC.
 	 */
 	set_bit(HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN, &hdev->quirks);
-	set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
 
 	return 0;
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

