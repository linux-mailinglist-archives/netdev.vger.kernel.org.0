Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8175A3ADA3B
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 15:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbhFSNxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 09:53:51 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:16422 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233286AbhFSNxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 09:53:50 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15JDfrAv015157;
        Sat, 19 Jun 2021 13:51:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=7L3SUuW8knrskZfsmxaaDYNgoTBEp3bdW7j9tdEJgg4=;
 b=cX61KGSRCgoCr7X+p+DNgWVdaJ8E7plv/ITh1l6EaLyDmpcofRIg5658CXFz8AF2ToVN
 fqybU1iTmU9kNjTgpb1aqS2jancYdZTJGtIiuD3yl3XtX6eUJyIWOpK29GieE0mwUahz
 axje6VncgdDG/llbSl9zJCpoMuyf8q8da0NyuU1HlcSnULMJDlVf7BpqzUFLT3df3BLp
 xS6WWE0cHnNBn4LD/p7pNyCtlnpXeKEBv/LVTUgELLXByODUTUdPwoBDYGTC4nPZNsuo
 TFglkOArotuBNU9rRKNZGjlXTkLPuCTXDsjaHhtYfcy+emSUOXmNBKvSSJDTUPAQYORL oQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3997c18g7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:51:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15JDp1an125330;
        Sat, 19 Jun 2021 13:51:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3995psqpsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:51:35 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15JDpYea125710;
        Sat, 19 Jun 2021 13:51:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3995psqpsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 13:51:34 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15JDpXIA021589;
        Sat, 19 Jun 2021 13:51:34 GMT
Received: from mwanda (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 19 Jun 2021 13:51:33 +0000
Date:   Sat, 19 Jun 2021 16:51:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     Intel Corporation <linuxwwan@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: iosm: remove an unnecessary NULL check
Message-ID: <YM32XksFPUbN2Oyi@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-ORIG-GUID: r_ZCTpiYkGwAiMhTk0qfg4qJddfxP_C4
X-Proofpoint-GUID: r_ZCTpiYkGwAiMhTk0qfg4qJddfxP_C4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The address of &ipc_mux->ul_adb can't be NULL because it points to the
middle of a non-NULL struct.

Fixes: 9413491e20e1 ("net: iosm: encode or decode datagram")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
index fbf3cab3394c..e634ffc6ec08 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
@@ -477,7 +477,7 @@ static void ipc_mux_ul_adgh_finish(struct iosm_mux *ipc_mux)
 	long long bytes;
 	char *str;
 
-	if (!ul_adb || !ul_adb->dest_skb) {
+	if (!ul_adb->dest_skb) {
 		dev_err(ipc_mux->dev, "no dest skb");
 		return;
 	}
-- 
2.30.2

