Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 216011613CB
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 14:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgBQNpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 08:45:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727132AbgBQNpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 08:45:14 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HDi5Tb097469
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 08:45:13 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y6e2e5x42-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 08:45:13 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Mon, 17 Feb 2020 13:45:11 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Feb 2020 13:45:08 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01HDiCat50790664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 13:44:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88A7D11C066;
        Mon, 17 Feb 2020 13:45:07 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CB1D11C04C;
        Mon, 17 Feb 2020 13:45:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Feb 2020 13:45:07 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next] net: bridge: teach ndo_dflt_bridge_getlink() more brport flags
Date:   Mon, 17 Feb 2020 14:45:01 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20021713-0020-0000-0000-000003AAF0CE
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021713-0021-0000-0000-00002202E80E
Message-Id: <20200217134501.97044-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_08:2020-02-17,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1011 lowpriorityscore=0
 impostorscore=0 phishscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002170114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This enables ndo_dflt_bridge_getlink() to report a bridge port's
offload settings for multicast and broadcast flooding.

CC: Roopa Prabhu <roopa@cumulusnetworks.com>
CC: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 net/core/rtnetlink.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 09c44bf2e1d2..9b4f8a254a15 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4555,7 +4555,11 @@ int ndo_dflt_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 	    brport_nla_put_flag(skb, flags, mask,
 				IFLA_BRPORT_UNICAST_FLOOD, BR_FLOOD) ||
 	    brport_nla_put_flag(skb, flags, mask,
-				IFLA_BRPORT_PROXYARP, BR_PROXYARP)) {
+				IFLA_BRPORT_PROXYARP, BR_PROXYARP) ||
+	    brport_nla_put_flag(skb, flags, mask,
+				IFLA_BRPORT_MCAST_FLOOD, BR_MCAST_FLOOD) ||
+	    brport_nla_put_flag(skb, flags, mask,
+				IFLA_BRPORT_BCAST_FLOOD, BR_BCAST_FLOOD)) {
 		nla_nest_cancel(skb, protinfo);
 		goto nla_put_failure;
 	}
-- 
2.17.1

