Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C70264B2C
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgIJR0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 13:26:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2650 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727024AbgIJRYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 13:24:10 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AHMixd147228;
        Thu, 10 Sep 2020 13:24:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=qync3x/KE1ITR3EM00IcVa+Yr2S6GgKAcCoHtPMNtYY=;
 b=Ulo52Fj7I21Jg5JHHVc58zf+sNFVlkZMmS6iT0wWKEqtxuxJrp0EuHCPujEr7RltnG1g
 o7/uex/SJytw1z8/mabvWVbM12s7rtNPrqPMD+U6rJkRd7lb27QxHtxKqlZJoZ6bG4KX
 NIBFYfW1Wq71udn+mfyabzvRUJahjurMXbfCVu10b5S2LDbn5rO29+eWivqRNI5OLRIf
 jUML4tddSddhLwsCtb/TZwAb+0VoNUcPt095R8AFUD+Tp8NcMEBCp++Ktrevm7s8qJBm
 eYuK+rr3fFOWSY4kL3rrobrsOxzjZIq4hDpXFd2WMtJ8TtgUbVicEOreFBKswG2CIydp mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33frg8812t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 13:24:03 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08AHNK4V149097;
        Thu, 10 Sep 2020 13:24:02 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33frg88121-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 13:24:02 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08AHInRG004636;
        Thu, 10 Sep 2020 17:24:00 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 33e5gmsp68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Sep 2020 17:24:00 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08AHNvKm20185490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 17:23:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9867A42047;
        Thu, 10 Sep 2020 17:23:57 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D48D42042;
        Thu, 10 Sep 2020 17:23:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Sep 2020 17:23:57 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH net-next 5/8] bridge: Add SWITCHDEV_FDB_FLUSH_TO_BRIDGE notifier
Date:   Thu, 10 Sep 2020 19:23:48 +0200
Message-Id: <20200910172351.5622-6-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910172351.5622-1-jwi@linux.ibm.com>
References: <20200910172351.5622-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_05:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

so the switchdev can notifiy the bridge to flush non-permanent fdb entries
for this port. This is useful whenever the hardware fdb of the switchdev
is reset, but the netdev and the bridgeport are not deleted.

Note that this has the same effect as the IFLA_BRPORT_FLUSH attribute.

CC: Jiri Pirko <jiri@resnulli.us>
CC: Ivan Vecera <ivecera@redhat.com>
CC: Roopa Prabhu <roopa@nvidia.com>
CC: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 include/net/switchdev.h | 1 +
 net/bridge/br.c         | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index ff2246914301..53e8b4994296 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -203,6 +203,7 @@ enum switchdev_notifier_type {
 	SWITCHDEV_FDB_ADD_TO_DEVICE,
 	SWITCHDEV_FDB_DEL_TO_DEVICE,
 	SWITCHDEV_FDB_OFFLOADED,
+	SWITCHDEV_FDB_FLUSH_TO_BRIDGE,
 
 	SWITCHDEV_PORT_OBJ_ADD, /* Blocking. */
 	SWITCHDEV_PORT_OBJ_DEL, /* Blocking. */
diff --git a/net/bridge/br.c b/net/bridge/br.c
index b6fe30e3768f..401eeb9142eb 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -183,6 +183,11 @@ static int br_switchdev_event(struct notifier_block *unused,
 		br_fdb_offloaded_set(br, p, fdb_info->addr,
 				     fdb_info->vid, fdb_info->offloaded);
 		break;
+	case SWITCHDEV_FDB_FLUSH_TO_BRIDGE:
+		fdb_info = ptr;
+		/* Don't delete static entries */
+		br_fdb_delete_by_port(br, p, fdb_info->vid, 0);
+		break;
 	}
 
 out:
-- 
2.17.1

