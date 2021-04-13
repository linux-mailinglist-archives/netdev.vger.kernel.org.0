Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBFE35DCC3
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 12:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244265AbhDMKsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 06:48:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58262 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343879AbhDMKse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 06:48:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DAjWO0182276;
        Tue, 13 Apr 2021 10:48:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=VHo8rBkqepFbdjOWh9vlGfa/227ekKGAjsHmcxNkLfA=;
 b=kBlra1nzXtrHDY5g71jQ0sv5dJCxpPJL+DzZikE3g6NOgPWnFLSUqoK72UpeAQC4lPBE
 bCE8iFOA/dW5ab8KS27KWztCRnkYM03m7ky/VapcxwGoQPAL5+edm16FWj/srQ8chxds
 y7E91qo67LCSY32HVCOrie/wQvKOSEkA2GVryN5MxWWdtcF/opK0ryPByLi77C6Xat07
 Isu251iavvWE8zzIacMBr8XS6fYrxetdYsOnxIJ9mfyK6JHhBIzh4x9qQL8mn4vJ5HBJ
 dIevxl/VXRx41zTCFJ39qNpnshi4oeHaF/BiwdazXiRCsyB6RaZrYTBp2ZgAabxpH0b0 tA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37u4nnekhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 10:48:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DAkLGe183871;
        Tue, 13 Apr 2021 10:48:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 37unxwp62r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 10:48:07 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 13DAm6if023268;
        Tue, 13 Apr 2021 10:48:06 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Apr 2021 03:48:05 -0700
Date:   Tue, 13 Apr 2021 13:47:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     drivers@pensando.io, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Allen Hubbe <allenbh@pensando.io>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] ionic: return -EFAULT if copy_to_user() fails
Message-ID: <YHV230jUzxBJxlPS@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130074
X-Proofpoint-ORIG-GUID: O5ahKcDz3aSdIcFS_i_6HVNt4EWgN3wu
X-Proofpoint-GUID: O5ahKcDz3aSdIcFS_i_6HVNt4EWgN3wu
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1011 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130074
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The copy_to_user() function returns the number of bytes that it wasn't
able to copy.  We want to return -EFAULT to the user.

Fixes: fee6efce565d ("ionic: add hw timestamp support files")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_phc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
index 86ae5011ac9b..d7d8d5e81ea0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
@@ -225,7 +225,9 @@ int ionic_lif_hwstamp_get(struct ionic_lif *lif, struct ifreq *ifr)
 	memcpy(&config, &lif->phc->ts_config, sizeof(config));
 	mutex_unlock(&lif->phc->config_lock);
 
-	return copy_to_user(ifr->ifr_data, &config, sizeof(config));
+	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
+		return -EFAULT;
+	return 0;
 }
 
 static u64 ionic_hwstamp_read(struct ionic *ionic,
-- 
2.30.2

