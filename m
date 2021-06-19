Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F353ADA39
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 15:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbhFSNwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 09:52:46 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:49798 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233286AbhFSNwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 09:52:45 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15JDfU9a001476;
        Sat, 19 Jun 2021 13:50:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=fUFibJKIGfvBlh67WobNWiEPQ/LHu5d3Lu+y7hD2fNA=;
 b=h6L4Af7qXCctR1ZXd8Rb3tgtMGTATUEL8eYKKqbyVZEQNHTQa2sHcmbX4yy21AVwCRzd
 kVwBaOdyLAduFD1J3znyMj2wI40QfEYfRKuWOPu/N3WnZ2ysfOoMklqo6cMNRr6d6VOs
 ArUDbNnzrd65cF8kGilw0pZqfmEXZ+jEQ2eMx6U4MnCzgIKqviJ6CVKEfo4YSkKWfjJH
 uUT2cbcrc/74npm/uh3a3FgQKVhuYj8hVwsgt2LqvaKmwsAX4FGDVE5NItvuDtbTHe0E
 k/1idM3D7cJ0d5aBXZEJwiZWYNk4xyA7/o2LSS1/I8y6Hf5HebvNlG5+bd48I+SBHQ/w uQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39994r0dky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:50:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15JDde37184874;
        Sat, 19 Jun 2021 13:50:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3997wkdk0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:50:32 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15JDoVFM007727;
        Sat, 19 Jun 2021 13:50:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3997wkdk0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:50:31 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15JDoTXj021041;
        Sat, 19 Jun 2021 13:50:30 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 19 Jun 2021 06:50:29 -0700
Date:   Sat, 19 Jun 2021 16:50:21 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Guvenc Gulce <guvenc@linux.ibm.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net/smc: Fix ENODATA tests in
 smc_nl_get_fback_stats()
Message-ID: <YM32HV7psa+PrmbV@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-ORIG-GUID: kiXXC2ODaM7vfAZsxU6dD5nASHzANwrr
X-Proofpoint-GUID: kiXXC2ODaM7vfAZsxU6dD5nASHzANwrr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These functions return negative ENODATA but the minus sign was left out
in the tests.

Fixes: f0dd7bf5e330 ("net/smc: Add netlink support for SMC fallback statistics")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/smc/smc_stats.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_stats.c b/net/smc/smc_stats.c
index 614013e3b574..e80e34f7ac15 100644
--- a/net/smc/smc_stats.c
+++ b/net/smc/smc_stats.c
@@ -393,17 +393,17 @@ int smc_nl_get_fback_stats(struct sk_buff *skb, struct netlink_callback *cb)
 			continue;
 		if (!skip_serv) {
 			rc_srv = smc_nl_get_fback_details(skb, cb, k, is_srv);
-			if (rc_srv && rc_srv != ENODATA)
+			if (rc_srv && rc_srv != -ENODATA)
 				break;
 		} else {
 			skip_serv = 0;
 		}
 		rc_clnt = smc_nl_get_fback_details(skb, cb, k, !is_srv);
-		if (rc_clnt && rc_clnt != ENODATA) {
+		if (rc_clnt && rc_clnt != -ENODATA) {
 			skip_serv = 1;
 			break;
 		}
-		if (rc_clnt == ENODATA && rc_srv == ENODATA)
+		if (rc_clnt == -ENODATA && rc_srv == -ENODATA)
 			break;
 	}
 	mutex_unlock(&net->smc.mutex_fback_rsn);
-- 
2.30.2

