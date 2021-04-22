Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C36367D75
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 11:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbhDVJNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 05:13:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58368 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhDVJM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 05:12:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13M98vRd179706;
        Thu, 22 Apr 2021 09:10:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=yMvGDxuBCHmaYIODgZ2Gjc4XWpSEGvxViHuFEN9vEIA=;
 b=YTzYlSF8sRZMuNZtrLGwwfV85kzixFnMkz19KP+d8nAh7r6R42jjGE7NgBhBD9iMe9G/
 pzFXVsJkyFEBI7w9z3zJkPBpVd6jwdMV4qPNaiFoMR4kFftbQI0MQb4nFZrprsvqF/4y
 R69Fz/mS3vPX2FdRXeQUKmkfXjV97sYyciNjwhof3vGezRWT2wTz33cpxeEl1r3f7caf
 72wzvih4ACvklAfAJkwz4Dz45f5oWYAJR/1UlK8cULhJSfA0GXzFWiC4wbCeFo4sR0u8
 PJQ1UEHHPR/x5O+U1cd894X/N2LtTpG9bmyElnIXOeHe7f2AgeEZap3Amzxyj+SBpcnO Zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38022y454m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 09:10:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13M9AEqm076479;
        Thu, 22 Apr 2021 09:10:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3809k36nky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 09:10:38 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 13M9Ab2Z078564;
        Thu, 22 Apr 2021 09:10:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3809k36nkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 09:10:37 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 13M9AZVR024776;
        Thu, 22 Apr 2021 09:10:36 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Apr 2021 02:10:35 -0700
Date:   Thu, 22 Apr 2021 12:10:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Michael Chan <michael.chan@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] bnxt_en: fix ternary sign extension bug in
 bnxt_show_temp()
Message-ID: <YIE9hEhXpdfffKg1@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-ORIG-GUID: HY-fF0bX4yRn8f2SUIYfb9stiHq-O93L
X-Proofpoint-GUID: HY-fF0bX4yRn8f2SUIYfb9stiHq-O93L
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1011 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220077
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The problem is that bnxt_show_temp() returns long but "rc" is an int
and "len" is a u32.  With ternary operations the type promotion is quite
tricky.  The negative "rc" is first promoted to u32 and then to long so
it ends up being a high positive value instead of a a negative as we
intended.

Fix this by removing the ternary.

Fixes: d69753fa1ecb ("bnxt_en: return proper error codes in bnxt_show_temp")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e15d454e33f0..f582d51e25ed 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9736,7 +9736,9 @@ static ssize_t bnxt_show_temp(struct device *dev,
 	if (!rc)
 		len = sprintf(buf, "%u\n", resp->temp * 1000); /* display millidegree */
 	mutex_unlock(&bp->hwrm_cmd_lock);
-	return rc ?: len;
+	if (rc)
+		return rc;
+	return len;
 }
 static SENSOR_DEVICE_ATTR(temp1_input, 0444, bnxt_show_temp, NULL, 0);
 
-- 
2.30.2

