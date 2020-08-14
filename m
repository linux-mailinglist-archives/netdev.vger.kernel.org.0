Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B5B244606
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 09:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgHNH7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 03:59:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13456 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726780AbgHNH7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 03:59:31 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07E7YLau141776;
        Fri, 14 Aug 2020 03:59:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eF2repj8uk4z8SpApVRs80sk7oJVPLrPx9HBv4jzkbg=;
 b=FNvkRSo/awvK/RG6lhmmlim32AWQ7g1OvePJ4Q5wdIpvKNloVWKxjHJDsqfjvj/f2g7e
 6RIbi7A1DLh1l5xgAtPUJFyWIZNLmfvkpAjcMpZYojv8BnAcsy7RdQQt4T45cYQi8LJ/
 IvK6u829LNyDggKpeqW0Lx2u0oI+swXwyip3U2bteKtM/A+bbg/YsN4oD5MeJIO0YRla
 ZWSf6e/lcC/U6rBJ9BetHVlvwm5hHWVNYD6RDEWu8jBsSgvDpAiLaUO03I6Zs8X5HRTQ
 FTXFlWlFgPp3IvnRtiXGYe8uQtsCW3gg97KFJXMle9qQCVHK5XlieGkZ3h+uZ2awiFdS Fg== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w5mx4mbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 03:59:25 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07E7uKOV014412;
        Fri, 14 Aug 2020 07:59:24 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma05wdc.us.ibm.com with ESMTP id 32skp9rjvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 07:59:24 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07E7xNWe53871026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Aug 2020 07:59:23 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C197AC05F;
        Fri, 14 Aug 2020 07:59:23 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23170AC059;
        Fri, 14 Aug 2020 07:59:23 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.160.68.30])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 14 Aug 2020 07:59:23 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net 2/5] ibmvnic: compare adapter->init_done_rc with more readable ibmvnic_rc_codes
Date:   Fri, 14 Aug 2020 02:59:18 -0500
Message-Id: <20200814075921.88745-3-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20200814075921.88745-1-ljp@linux.ibm.com>
References: <20200814075921.88745-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-14_04:2020-08-13,2020-08-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 suspectscore=1 clxscore=1015 impostorscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008140058
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of comparing (adapter->init_done_rc == 1), let it
be (adapter->init_done_rc == PARTIALSUCCESS).

Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index aba1cd9862ac..50e86e65961e 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -974,7 +974,7 @@ static int set_link_state(struct ibmvnic_adapter *adapter, u8 link_state)
 			return -1;
 		}
 
-		if (adapter->init_done_rc == 1) {
+		if (adapter->init_done_rc == PARTIALSUCCESS) {
 			/* Partuial success, delay and re-send */
 			mdelay(1000);
 			resend = true;
-- 
2.23.0

