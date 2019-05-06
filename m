Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43FA115106
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 18:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfEFQSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 12:18:54 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:41564 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfEFQSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 12:18:53 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x46GIdpd168069
        for <netdev@vger.kernel.org>; Mon, 6 May 2019 16:18:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=aZrdCUUbPcSP1zNJrr5/7DEYJpSSb1INz/UC+43p1ws=;
 b=nJa4cx5R0LkJsGmmnUcz2cV1i9n98Rh6hoyAFT7Mw1ygnWlgKWIQYWTHRLT3ebCzsq4+
 RayChLWbMsuUwG34mV4ewfIFzfHdYnTUFZ2pvfsp6SiwX5yw3h3SpRP3icun/JOZ62Tq
 s53C9ku4Kaguljwnj2RrQJbOWFt3Iepw9aHO+Q6YKD/MXdLjET5wjc1qfjGAK9gfc2IB
 QtBhwwqDLBNCHazHGHbt5dTTxdkFDdONiEzquegzVcvMqZcVS14xTPTpIXkrDsLBL8eL
 4da+Gg6lrKLtk9MAitQDa8oHBsZIdCbk3qVRFzszDDnJIpc/85hZPbhHqEgg3Ffb3pjy 8Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2s94b5qq3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 16:18:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x46GIQF2079416
        for <netdev@vger.kernel.org>; Mon, 6 May 2019 16:18:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2s9ayed268-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 16:18:51 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x46GIpx5029624
        for <netdev@vger.kernel.org>; Mon, 6 May 2019 16:18:51 GMT
Received: from nir-ThinkPad-T470.oracle.com (/10.74.127.120)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 May 2019 09:18:50 -0700
From:   Nir Weiner <nir.weiner@oracle.com>
To:     netdev@vger.kernel.org
Cc:     liran.alon@oracle.com, nir.weiner@oracle.com
Subject: [iproute2 2/3] tc: jsonify tbf qdisc parameters
Date:   Mon,  6 May 2019 19:18:39 +0300
Message-Id: <20190506161840.30919-3-nir.weiner@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190506161840.30919-1-nir.weiner@oracle.com>
References: <20190506161840.30919-1-nir.weiner@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=933
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905060139
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1031
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=963 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905060139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add json output to tbf qdisc parameters.

Acked-by: John Haxby <john.haxby@oracle.com>
Signed-off-by: Nir Weiner <nir.weiner@oracle.com>
Suggested-by: Liran Alon <liran.alon@oracle.com>
---
 tc/q_tbf.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tc/q_tbf.c b/tc/q_tbf.c
index b9465b20d2be..fd824e67e4f2 100644
--- a/tc/q_tbf.c
+++ b/tc/q_tbf.c
@@ -285,32 +285,32 @@ static int tbf_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (tb[TCA_TBF_RATE64] &&
 	    RTA_PAYLOAD(tb[TCA_TBF_RATE64]) >= sizeof(rate64))
 		rate64 = rta_getattr_u64(tb[TCA_TBF_RATE64]);
-	fprintf(f, "rate %s ", sprint_rate(rate64, b1));
+	print_string(PRINT_ANY, "rate", "rate %s ", sprint_rate(rate64, b1));
 	buffer = tc_calc_xmitsize(rate64, qopt->buffer);
 	if (show_details) {
 		fprintf(f, "burst %s/%u mpu %s ", sprint_size(buffer, b1),
 			1<<qopt->rate.cell_log, sprint_size(qopt->rate.mpu, b2));
 	} else {
-		fprintf(f, "burst %s ", sprint_size(buffer, b1));
+		print_string(PRINT_ANY, "burst", "burst %s ", sprint_size(buffer, b1));
 	}
 	if (show_raw)
-		fprintf(f, "[%08x] ", qopt->buffer);
+		print_0xhex(PRINT_ANY, "buffer", "[%08x] ", qopt->buffer);
 	prate64 = qopt->peakrate.rate;
 	if (tb[TCA_TBF_PRATE64] &&
 	    RTA_PAYLOAD(tb[TCA_TBF_PRATE64]) >= sizeof(prate64))
 		prate64 = rta_getattr_u64(tb[TCA_TBF_PRATE64]);
 	if (prate64) {
-		fprintf(f, "peakrate %s ", sprint_rate(prate64, b1));
+		print_string(PRINT_ANY, "peakrate", "peakrate %s ", sprint_rate(prate64, b1));
 		if (qopt->mtu || qopt->peakrate.mpu) {
 			mtu = tc_calc_xmitsize(prate64, qopt->mtu);
 			if (show_details) {
 				fprintf(f, "mtu %s/%u mpu %s ", sprint_size(mtu, b1),
 					1<<qopt->peakrate.cell_log, sprint_size(qopt->peakrate.mpu, b2));
 			} else {
-				fprintf(f, "minburst %s ", sprint_size(mtu, b1));
+				print_string(PRINT_ANY, "minburst", "minburst %s ", sprint_size(mtu, b1));
 			}
 			if (show_raw)
-				fprintf(f, "[%08x] ", qopt->mtu);
+				print_0xhex(PRINT_ANY, "mtu", "[%08x] ", qopt->mtu);
 		}
 	}
 
@@ -322,16 +322,16 @@ static int tbf_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 			latency = lat2;
 	}
 	if (latency >= 0.0)
-		fprintf(f, "lat %s ", sprint_time(latency, b1));
+		print_string(PRINT_ANY, "lat", "lat %s ", sprint_time(latency, b1));
 	if (show_raw || latency < 0.0)
-		fprintf(f, "limit %s ", sprint_size(qopt->limit, b1));
+		print_string(PRINT_ANY, "limit", "limit %s ", sprint_size(qopt->limit, b1));
 
 	if (qopt->rate.overhead) {
-		fprintf(f, "overhead %d", qopt->rate.overhead);
+		print_int(PRINT_ANY, "overhead", "overhead %d", qopt->rate.overhead);
 	}
 	linklayer = (qopt->rate.linklayer & TC_LINKLAYER_MASK);
 	if (linklayer > TC_LINKLAYER_ETHERNET || show_details)
-		fprintf(f, "linklayer %s ", sprint_linklayer(linklayer, b3));
+		print_string(PRINT_ANY, "linklayer", "linklayer %s ", sprint_linklayer(linklayer, b3));
 
 	return 0;
 }
-- 
2.17.1

