Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7807D8C075
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbfHMSVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:21:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35438 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728378AbfHMSVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:21:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DI9CVr107726;
        Tue, 13 Aug 2019 18:21:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=8TOfSB0rA7UsrdDYKPE0TPuHhb9xNeXuj3zrkBzRLOI=;
 b=KwoCtI/tflUGRJ32Cpb89lr061nZm9UyNNKNMjfo/mnWt+4Zoapv2EbhyxzA0LJ2JMUp
 f1eSuf+5PZLi6YItFutTjJwBO1BcKRH1O2Cb5JqIbdrfhCNrdFWk8/IQ88RX0T9BXhb2
 dilXos3+mSWPzd6YcVMPk9i0bQCmZAwJJTu87dBr3pHaUsk8Ml75CiWP6/iL8ANSIjkF
 ytvO4eKqqTHZWPlAe+Fz/S39lj3xLj/2MDuulSIjco5br2NDjsKgVc1vnrSL/VWVGgDW
 RlOdCzetSxIlRYGCn/hzkhf/XaLBucUwNGdHK4VM/ZmP/FwAlhYXwFe6TMuXzzv2kzkj hA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u9nvp83pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 18:21:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DICk0l189770;
        Tue, 13 Aug 2019 18:21:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2ubwcx345q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Aug 2019 18:21:00 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7DIKxBm017521;
        Tue, 13 Aug 2019 18:20:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ubwcx3459-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 18:20:59 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7DIKwIg010500;
        Tue, 13 Aug 2019 18:20:58 GMT
Received: from [10.211.54.53] (/10.211.54.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Aug 2019 11:20:58 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next 1/5] RDS: Re-add pf/sol access via sysctl
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
Message-ID: <e0397d30-7405-a7af-286c-fe76887caf0a@oracle.com>
Date:   Tue, 13 Aug 2019 11:20:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9348 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130171
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Grover <andy.grover@oracle.com>
Date: Tue, 24 Nov 2009 15:35:51 -0800

Although RDS has an official PF_RDS value now, existing software
expects to look for rds sysctls to determine it. We need to maintain
these for now, for backwards compatibility.

Signed-off-by: Andy Grover <andy.grover@oracle.com>
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
---
 net/rds/sysctl.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/rds/sysctl.c b/net/rds/sysctl.c
index e381bbcd9cc1..9760292a0af4 100644
--- a/net/rds/sysctl.c
+++ b/net/rds/sysctl.c
@@ -49,6 +49,13 @@ unsigned int  rds_sysctl_max_unacked_bytes = (16 << 20);
 
 unsigned int rds_sysctl_ping_enable = 1;
 
+/*
+ * We have official values, but must maintain the sysctl interface for existing
+ * software that expects to find these values here.
+ */
+static int rds_sysctl_pf_rds = PF_RDS;
+static int rds_sysctl_sol_rds = SOL_RDS;
+
 static struct ctl_table rds_sysctl_rds_table[] = {
 	{
 		.procname       = "reconnect_min_delay_ms",
@@ -68,6 +75,20 @@ static struct ctl_table rds_sysctl_rds_table[] = {
 		.extra1		= &rds_sysctl_reconnect_min_jiffies,
 		.extra2		= &rds_sysctl_reconnect_max,
 	},
+	{
+		.procname       = "pf_rds",
+		.data		= &rds_sysctl_pf_rds,
+		.maxlen         = sizeof(int),
+		.mode           = 0444,
+		.proc_handler   = &proc_dointvec,
+	},
+	{
+		.procname       = "sol_rds",
+		.data		= &rds_sysctl_sol_rds,
+		.maxlen         = sizeof(int),
+		.mode           = 0444,
+		.proc_handler   = &proc_dointvec,
+	},
 	{
 		.procname	= "max_unacked_packets",
 		.data		= &rds_sysctl_max_unacked_packets,
-- 
2.22.0


