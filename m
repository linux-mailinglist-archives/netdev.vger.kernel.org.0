Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB412B69A3
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbgKQQPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:15:39 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36238 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727154AbgKQQPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 11:15:35 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG3huY032503;
        Tue, 17 Nov 2020 11:15:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=wrIwuVJ5ci0v+rnar5Mbw/5CglSRjn+5q1DQqX/WE/Q=;
 b=YQpAgwX/nwLWI67RNVpbUIIldL62MwezKLIqrJgV2zrEiZaQ7Aq4AKbEE+fNtjr8RQNH
 t2Di4sFmjBHtmyqCkAzNbDcjnFGulvF6chLPyXR6m7kxP+iXByfIFHwENJskYOmWVnAu
 gNSBmXZrUoAn0dwJwKlu84d2notbuekBnn5KXtoAY/n0P9CTCRvXaQnXYdaXymKKlXet
 AXHuvfVQs0dBBjDe/Ou+Nl1Frax48kzifEzqUWfnLhn4qJHphYr9LEcLNpz/Rra0X82X
 IHTq8AUOOnTeGuMFqk+mUEFjqIJLe39DHCeSZTZngPWv/pEm7WgWPlet49Naw8Z7feRG cA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vd6hte3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 11:15:33 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHG8VPj001072;
        Tue, 17 Nov 2020 16:15:31 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 34t6v8b3ap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 16:15:31 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHGFSjf9831130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 16:15:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D388A4060;
        Tue, 17 Nov 2020 16:15:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 010D6A406A;
        Tue, 17 Nov 2020 16:15:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 16:15:27 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 7/9] s390/qeth: clean up default cases for ethtool link mode
Date:   Tue, 17 Nov 2020 17:15:18 +0100
Message-Id: <20201117161520.1089-8-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201117161520.1089-1-jwi@linux.ibm.com>
References: <20201117161520.1089-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 suspectscore=0 impostorscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the default case for PORT_* and SPEED_* in our ethtool code.

The only time these could be hit is if qeth_init_link_info() was unable
to determine the port type from an OSA adapter's link_type.
We already throw a message in this case, so reduce the noise and don't
report bad data (ie. it's much more likely that any future link_type
will represent a PORT_FIBRE link ...).

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 drivers/s390/net/qeth_ethtool.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/s390/net/qeth_ethtool.c b/drivers/s390/net/qeth_ethtool.c
index b8e74018b44f..50b0c1810850 100644
--- a/drivers/s390/net/qeth_ethtool.c
+++ b/drivers/s390/net/qeth_ethtool.c
@@ -343,9 +343,7 @@ static void qeth_set_ethtool_link_modes(struct ethtool_link_ksettings *cmd)
 		ethtool_link_ksettings_add_link_mode(cmd, advertising, FIBRE);
 		break;
 	default:
-		ethtool_link_ksettings_add_link_mode(cmd, supported, TP);
-		ethtool_link_ksettings_add_link_mode(cmd, advertising, TP);
-		WARN_ON_ONCE(1);
+		break;
 	}
 
 	/* partially does fall through, to also select lower speeds */
@@ -393,15 +391,7 @@ static void qeth_set_ethtool_link_modes(struct ethtool_link_ksettings *cmd)
 						     10baseT_Half);
 		break;
 	default:
-		ethtool_link_ksettings_add_link_mode(cmd, supported,
-						     10baseT_Full);
-		ethtool_link_ksettings_add_link_mode(cmd, advertising,
-						     10baseT_Full);
-		ethtool_link_ksettings_add_link_mode(cmd, supported,
-						     10baseT_Half);
-		ethtool_link_ksettings_add_link_mode(cmd, advertising,
-						     10baseT_Half);
-		WARN_ON_ONCE(1);
+		break;
 	}
 }
 
-- 
2.17.1

