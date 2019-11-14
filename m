Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2036FC5DC
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 13:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKNMDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 07:03:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56566 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726949AbfKNMDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 07:03:03 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEBv8La138393
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:03:01 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w9571km3q-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:03:01 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <kgraul@linux.ibm.com>;
        Thu, 14 Nov 2019 12:02:58 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 12:02:56 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEC2tit57278472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 12:02:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F29A4C04A;
        Thu, 14 Nov 2019 12:02:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F9F74C058;
        Thu, 14 Nov 2019 12:02:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 12:02:55 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: [PATCH net-next 6/8] net/smc: abnormal termination without orderly flag
Date:   Thu, 14 Nov 2019 13:02:45 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114120247.68889-1-kgraul@linux.ibm.com>
References: <20191114120247.68889-1-kgraul@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19111412-0012-0000-0000-0000036393AB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111412-0013-0000-0000-0000219F0CCB
Message-Id: <20191114120247.68889-7-kgraul@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140113
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

For abnormal termination issue an LLC DELETE_LINK without the
orderly flag.

Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index 30854acb846c..ee44e8244d0c 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -161,10 +161,10 @@ static void smc_lgr_unregister_conn(struct smc_connection *conn)
  * of the DELETE LINK sequence from server; or as server to
  * initiate the delete processing. See smc_llc_rx_delete_link().
  */
-static int smc_link_send_delete(struct smc_link *lnk)
+static int smc_link_send_delete(struct smc_link *lnk, bool orderly)
 {
 	if (lnk->state == SMC_LNK_ACTIVE &&
-	    !smc_llc_send_delete_link(lnk, SMC_LLC_REQ, true)) {
+	    !smc_llc_send_delete_link(lnk, SMC_LLC_REQ, orderly)) {
 		smc_llc_link_deleting(lnk);
 		return 0;
 	}
@@ -201,7 +201,7 @@ static void smc_lgr_free_work(struct work_struct *work)
 	if (!lgr->is_smcd && !lgr->terminating)	{
 		/* try to send del link msg, on error free lgr immediately */
 		if (lnk->state == SMC_LNK_ACTIVE &&
-		    !smc_link_send_delete(lnk)) {
+		    !smc_link_send_delete(lnk, true)) {
 			/* reschedule in case we never receive a response */
 			smc_lgr_schedule_free_work(lgr);
 			spin_unlock_bh(lgr_lock);
@@ -1233,9 +1233,7 @@ static void smc_lgrs_shutdown(void)
 		if (!lgr->is_smcd) {
 			struct smc_link *lnk = &lgr->lnk[SMC_SINGLE_LINK];
 
-			if (lnk->state == SMC_LNK_ACTIVE)
-				smc_llc_send_delete_link(lnk, SMC_LLC_REQ,
-							 false);
+			smc_link_send_delete(&lgr->lnk[SMC_SINGLE_LINK], false);
 			smc_llc_link_inactive(lnk);
 		}
 		cancel_delayed_work_sync(&lgr->free_work);
-- 
2.17.1

