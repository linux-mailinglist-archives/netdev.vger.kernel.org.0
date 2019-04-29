Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 226ACED5B
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 01:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbfD2Xhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 19:37:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58930 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728748AbfD2Xhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 19:37:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3TNZB9K189983;
        Mon, 29 Apr 2019 23:37:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=6hGEu2HZD/8YP3WoOCHTAZ2nyJdSrukF5yTJrl/RG7M=;
 b=tWXB5CfyM3dhTDNHDRLT0QeQJvUwNZDzpfPnkBqh/byAmNNxZGW5qBYPVptDxubPpJzD
 taJiUB07nU8hhQRmagcmykLj8PLkzerNkTntJKE/FfR6xBPzoLPGTuABAhmExPRNJm7j
 2mqutg3oSL7ndQTbZyZUA6CGSuyNjRxwTmYbbne8qyT0WM0UknFkZgswYHJVXpyveEK0
 r7xRbzH0OTKEHwxPImUy81YG4O27U7Hn2b5XwXMmpzUflp4Su0sdwHjKtJ6U+diBBnmP
 m3XdmC6P8ZfTAvQ/0gMxuKjD75GJFjesRFOy37Bh0wNHFZ/nyw8jLyvCzNTZgWPFbW1z aQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2s4fqq1aud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 23:37:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3TNbTFe116698;
        Mon, 29 Apr 2019 23:37:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2s5u50nwjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 23:37:29 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3TNbQTF032565;
        Mon, 29 Apr 2019 23:37:26 GMT
Received: from userv0022.oracle.com (/10.11.38.116)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 29 Apr 2019 16:37:26 -0700
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     santosh.shilimkar@oracle.com
Subject: [net-next][PATCH v2 2/2] rds: add sysctl for rds support of On-Demand-Paging
Date:   Mon, 29 Apr 2019 16:37:20 -0700
Message-Id: <1556581040-4812-3-git-send-email-santosh.shilimkar@oracle.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9242 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904290153
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9242 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904290153
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RDS doesn't support RDMA on memory apertures that require On Demand
Paging (ODP), such as FS DAX memory. A sysctl is added to indicate
whether RDMA requiring ODP is supported.

Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
---
 net/rds/ib.h        | 1 +
 net/rds/ib_sysctl.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/net/rds/ib.h b/net/rds/ib.h
index 67a715b..80e11ef 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -457,5 +457,6 @@ unsigned int rds_ib_stats_info_copy(struct rds_info_iterator *iter,
 extern unsigned long rds_ib_sysctl_max_unsig_bytes;
 extern unsigned long rds_ib_sysctl_max_recv_allocation;
 extern unsigned int rds_ib_sysctl_flow_control;
+extern unsigned int rds_ib_sysctl_odp_support;
 
 #endif
diff --git a/net/rds/ib_sysctl.c b/net/rds/ib_sysctl.c
index e4e41b3..7cc02cd 100644
--- a/net/rds/ib_sysctl.c
+++ b/net/rds/ib_sysctl.c
@@ -60,6 +60,7 @@
  * will cause credits to be added before protocol negotiation.
  */
 unsigned int rds_ib_sysctl_flow_control = 0;
+unsigned int rds_ib_sysctl_odp_support;
 
 static struct ctl_table rds_ib_sysctl_table[] = {
 	{
@@ -103,6 +104,13 @@
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname       = "odp_support",
+		.data           = &rds_ib_sysctl_odp_support,
+		.maxlen         = sizeof(rds_ib_sysctl_odp_support),
+		.mode           = 0444,
+		.proc_handler   = proc_dointvec,
+	},
 	{ }
 };
 
-- 
1.9.1

