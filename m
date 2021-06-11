Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858223A3D43
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhFKHgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:36:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49618 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230035AbhFKHf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 03:35:56 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B7WoXo151285;
        Fri, 11 Jun 2021 03:33:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dc/8tHGg//0/TYtrt6XIXy9/rgkbUNg4kJ+e5t9dtfE=;
 b=Xxx2ACvdd5hp0cOheyRVcNLzUbQTkKs9tsTsGqi9/k6wmfUkP8SQVAf8Y3PKrw69vGqX
 FJLewEcoR4bWmQdaXua3cDW8fN1eRueqiIkdCUB9gdHK7VTvY3CAeTUrAGja22zD/JM3
 z6l10cHzD09ToVDhxNr3P1fj3f+4RUGMD/ZlgsEulXQTfaqVjBcUbRvQnXFCYr+d6E9L
 Dm4RzD9aoh5lKTrMatPe8WLV7MTrGi8nwiGzfBQJnV0Gt5897FxG5W8yIF6hV2pLLTIf
 QMCBLpwpqNK0jlGxPTpq94Q4uFS3LfBX8ZeXOwJrY/dY9131lNOm5mdvnpmmw8xBeCnv xA== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39439g0dh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 03:33:56 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15B7WjOM029212;
        Fri, 11 Jun 2021 07:33:54 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3900w89ts1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 07:33:54 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15B7Xo5L14877086
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 07:33:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D85A6A4064;
        Fri, 11 Jun 2021 07:33:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95AD9A4071;
        Fri, 11 Jun 2021 07:33:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Jun 2021 07:33:50 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH net-next 9/9] s390/qeth: Consider dependency on SWITCHDEV module
Date:   Fri, 11 Jun 2021 09:33:41 +0200
Message-Id: <20210611073341.1634501-10-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611073341.1634501-1-jwi@linux.ibm.com>
References: <20210611073341.1634501-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4kwxm2bb59i4Ql39kHC4Yi8L6H9H3uLl
X-Proofpoint-GUID: 4kwxm2bb59i4Ql39kHC4Yi8L6H9H3uLl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_01:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

Without the SWITCHDEV module, the bridgeport attribute LEARNING_SYNC
of the physical device (self) does not provide any functionality.
Instead of calling the no-op stub version of the switchdev functions,
fail the setting of the attribute with an appropriate message.

While at it, also add an error message for the 'not supported by HW'
case.

Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_l2_main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index ca44421a6d6e..2abf86c104d5 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -805,8 +805,6 @@ static int qeth_l2_bridge_setlink(struct net_device *dev, struct nlmsghdr *nlh,
 
 	if (!netif_device_present(dev))
 		return -ENODEV;
-	if (!(priv->brport_hw_features))
-		return -EOPNOTSUPP;
 
 	nlmsg_for_each_attr(attr, nlh, sizeof(struct ifinfomsg), rem1) {
 		if (nla_type(attr) == IFLA_PROTINFO) {
@@ -832,6 +830,16 @@ static int qeth_l2_bridge_setlink(struct net_device *dev, struct nlmsghdr *nlh,
 		return 0;
 	if (!bp_tb[IFLA_BRPORT_LEARNING_SYNC])
 		return -EINVAL;
+	if (!(priv->brport_hw_features & BR_LEARNING_SYNC)) {
+		NL_SET_ERR_MSG_ATTR(extack, bp_tb[IFLA_BRPORT_LEARNING_SYNC],
+				    "Operation not supported by HW");
+		return -EOPNOTSUPP;
+	}
+	if (!IS_ENABLED(CONFIG_NET_SWITCHDEV)) {
+		NL_SET_ERR_MSG_ATTR(extack, bp_tb[IFLA_BRPORT_LEARNING_SYNC],
+				    "Requires NET_SWITCHDEV");
+		return -EOPNOTSUPP;
+	}
 	enable = !!nla_get_u8(bp_tb[IFLA_BRPORT_LEARNING_SYNC]);
 
 	if (enable == !!(priv->brport_features & BR_LEARNING_SYNC))
-- 
2.25.1

