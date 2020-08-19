Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842A9249480
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 07:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgHSFfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 01:35:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7596 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbgHSFfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 01:35:18 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J5VlC9168553;
        Wed, 19 Aug 2020 01:35:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eF2repj8uk4z8SpApVRs80sk7oJVPLrPx9HBv4jzkbg=;
 b=F1fJz28x5O3fQuaHSiWTXMOU9SPRknWCXEahUc4P0VAimRej3FpaKWsG0yUp3GHg5q6k
 au9WXwQ4Wa4JNP1fcVF4cUFsoJGc3gQKGzaDH88AjUZFYVa+ASyNMBctx2G0TS2P9YZT
 L5VCiYeyxTf7FV1KesyHQEwb8JlPHh/iUlCt9Y4lbSsmfBw5Jpe7laaAlbjmcQ4w/KnP
 ykZHWEzw2sJos89e5BJFD1Osy7snt3W7m1YMqzRC7vF28BI4SxkwZk/aEBH+v+lNNMhB
 XMmSTz52IlXcXOeWZ27FBeDdE+ZZVyzxr7uPhp2/+PzQzwpDvCkpqOQn5KYQPYDE2gWk Bw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304r81vr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 01:35:15 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07J5ZE1J006806;
        Wed, 19 Aug 2020 05:35:14 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 3304uqktn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Aug 2020 05:35:14 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07J5ZEBx54591924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Aug 2020 05:35:14 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8416AC05F;
        Wed, 19 Aug 2020 05:35:13 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87B9CAC05B;
        Wed, 19 Aug 2020 05:35:13 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.160.104.33])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 19 Aug 2020 05:35:13 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, Lijun Pan <ljp@linux.ibm.com>
Subject: [PATCH net-next 2/5] ibmvnic: compare adapter->init_done_rc with more readable ibmvnic_rc_codes
Date:   Wed, 19 Aug 2020 00:35:09 -0500
Message-Id: <20200819053512.3619-3-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20200819053512.3619-1-ljp@linux.ibm.com>
References: <20200819053512.3619-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_02:2020-08-18,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190042
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

