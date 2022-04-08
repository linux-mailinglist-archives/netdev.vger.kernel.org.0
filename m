Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C9B4F9917
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 17:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237411AbiDHPNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 11:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237404AbiDHPNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 11:13:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A893FFF73;
        Fri,  8 Apr 2022 08:11:08 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 238DLtNX006308;
        Fri, 8 Apr 2022 15:11:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=W+oPOVUmXRJhShAX+Lg4YZ059mLkaxWPWpmN74i7+P4=;
 b=MDg8FV47s8VAEpWKFjwO5W611mjsbOjcLzLM9vthkqN3bsJsvEgflLuikn1cC35ZhMtu
 wJYMaR2MLByc1Cc5YXyVqXSRmZIKJfbmvC/GYhcn4XbFwyCVRiec8zsmbk1hopjaCZlE
 R7NGkec+QAyEuE4jcg4yK15xL16Ao7+4SVqyYzEvmHRZWMZo/FRVuCjA+6tRm5IPkbsY
 ib0FGvIP8xByJchGS9CzNQl4IBLgyFJW5OScqUJRKtEZg2hgUTVV2YLCSn5bqYC4MOcE
 xQwm6+WF/VzYu4okrzXayyawNDZE65SnjLg1BEBydBYrxby5+YdzGKclThWqEfqrA0+0 EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fa44x73w5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 15:11:03 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 238DVLtG032080;
        Fri, 8 Apr 2022 15:11:02 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fa44x73vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 15:11:02 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 238F3FNo010729;
        Fri, 8 Apr 2022 15:11:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3f6e48swhn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 15:11:00 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 238FAvwV36372742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Apr 2022 15:10:57 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F5D95204F;
        Fri,  8 Apr 2022 15:10:57 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 529BE5204E;
        Fri,  8 Apr 2022 15:10:57 +0000 (GMT)
From:   Karsten Graul <kgraul@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, alibuda@linux.alibaba.com
Subject: [PATCH net 2/3] net/smc: Fix NULL pointer dereference in smc_pnet_find_ib()
Date:   Fri,  8 Apr 2022 17:10:34 +0200
Message-Id: <20220408151035.1044701-3-kgraul@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220408151035.1044701-1-kgraul@linux.ibm.com>
References: <20220408151035.1044701-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tNxBc_FrEpfZiefCSweAlhHTvNTPgZSK
X-Proofpoint-ORIG-GUID: F0ppsp4iYT7SZYicAOQQYZHKvLgaxkcP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-08_05,2022-04-08_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=906
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204080075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_name() was called with dev.parent as argument but without to
NULL-check it before.
Solve this by checking the pointer before the call to dev_name().

Fixes: af5f60c7e3d5 ("net/smc: allow PCI IDs as ib device names in the pnet table")
Reported-by: syzbot+03e3e228510223dabd34@syzkaller.appspotmail.com
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
---
 net/smc/smc_pnet.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 7984f8883472..7055ed10e316 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -311,8 +311,9 @@ static struct smc_ib_device *smc_pnet_find_ib(char *ib_name)
 	list_for_each_entry(ibdev, &smc_ib_devices.list, list) {
 		if (!strncmp(ibdev->ibdev->name, ib_name,
 			     sizeof(ibdev->ibdev->name)) ||
-		    !strncmp(dev_name(ibdev->ibdev->dev.parent), ib_name,
-			     IB_DEVICE_NAME_MAX - 1)) {
+		    (ibdev->ibdev->dev.parent &&
+		     !strncmp(dev_name(ibdev->ibdev->dev.parent), ib_name,
+			     IB_DEVICE_NAME_MAX - 1))) {
 			goto out;
 		}
 	}
-- 
2.32.0

