Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79DD815105
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 18:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfEFQSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 12:18:53 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:41550 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfEFQSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 12:18:52 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x46GIa6X168043
        for <netdev@vger.kernel.org>; Mon, 6 May 2019 16:18:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=3j2uUkooI5ka5/NMDdx5vp2xWavjAbURaihH8qmaRAc=;
 b=nVTxVKaXbBPdgOfnNlEt2v3GXmCYVJPPEcz4tMGbvXpPIOUuk8JaSrgmSTLt0EsV1O9W
 cWntkchZHxxkC7dG/4mmjYFTcvrDWSAIp+NKandm3unZrX+L0AdRIcEKxV88E8EvG+kd
 9PSfrLo0ulPgsoM5DsSrOC+lpAOG9qRubq33A1FdiiGXMLTagzUSGKG55ftlmym7KFLG
 pPubPhJR3bblrJWMMlOc0Mvs3cVXdSJpCsnMJH+1Zflf2Z8jvhMYrZ5dj/gRLMXMFIIL
 1DiXBiPRlWw47QZmiaVrWjzt74ZJuS3EeIYX0xSiwRqWg4brWI4jqL7mHn3MzQgPv0lv Lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2s94b5qq3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 16:18:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x46GIRG5009779
        for <netdev@vger.kernel.org>; Mon, 6 May 2019 16:18:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2s94af06mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 16:18:50 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x46GInJX030784
        for <netdev@vger.kernel.org>; Mon, 6 May 2019 16:18:49 GMT
Received: from nir-ThinkPad-T470.oracle.com (/10.74.127.120)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 May 2019 09:18:49 -0700
From:   Nir Weiner <nir.weiner@oracle.com>
To:     netdev@vger.kernel.org
Cc:     liran.alon@oracle.com, nir.weiner@oracle.com
Subject: [iproute2 1/3] tc: jsonify htb qdisc parameters
Date:   Mon,  6 May 2019 19:18:38 +0300
Message-Id: <20190506161840.30919-2-nir.weiner@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190506161840.30919-1-nir.weiner@oracle.com>
References: <20190506161840.30919-1-nir.weiner@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905060139
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1031
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905060139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add json output to htb qdisc parameters.

Fixes: f354fa6aa5ff05dd214a595e5159ef93a6ab1934
Acked-by: John Haxby <john.haxby@oracle.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Nir Weiner <nir.weiner@oracle.com>
---
 tc/q_htb.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/tc/q_htb.c b/tc/q_htb.c
index 520522266e00..0e0f479d423f 100644
--- a/tc/q_htb.c
+++ b/tc/q_htb.c
@@ -299,16 +299,16 @@ static int htb_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		    RTA_PAYLOAD(tb[TCA_HTB_CEIL64]) >= sizeof(ceil64))
 			ceil64 = rta_getattr_u64(tb[TCA_HTB_CEIL64]);
 
-		fprintf(f, "rate %s ", sprint_rate(rate64, b1));
+		print_string(PRINT_ANY, "rate", "rate %s ", sprint_rate(rate64, b1));
 		if (hopt->rate.overhead)
-			fprintf(f, "overhead %u ", hopt->rate.overhead);
+			print_uint(PRINT_ANY, "overhead", "overhead %u ", hopt->rate.overhead);
 		buffer = tc_calc_xmitsize(rate64, hopt->buffer);
 
-		fprintf(f, "ceil %s ", sprint_rate(ceil64, b1));
+		print_string(PRINT_ANY, "ceil", "ceil %s ", sprint_rate(ceil64, b1));
 		cbuffer = tc_calc_xmitsize(ceil64, hopt->cbuffer);
 		linklayer = (hopt->rate.linklayer & TC_LINKLAYER_MASK);
 		if (linklayer > TC_LINKLAYER_ETHERNET || show_details)
-			fprintf(f, "linklayer %s ", sprint_linklayer(linklayer, b3));
+			print_string(PRINT_ANY, "linklayer", "linklayer %s ", sprint_linklayer(linklayer, b3));
 		if (show_details) {
 			fprintf(f, "burst %s/%u mpu %s ",
 				sprint_size(buffer, b1),
@@ -320,12 +320,13 @@ static int htb_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 				sprint_size(hopt->ceil.mpu, b2));
 			fprintf(f, "level %d ", (int)hopt->level);
 		} else {
-			fprintf(f, "burst %s ", sprint_size(buffer, b1));
-			fprintf(f, "cburst %s ", sprint_size(cbuffer, b1));
+			print_string(PRINT_ANY, "burst", "burst %s ", sprint_size(buffer, b1));
+			print_string(PRINT_ANY, "cburst", "cburst %s ", sprint_size(cbuffer, b1));
+		}
+		if (show_raw) {
+			print_0xhex(PRINT_ANY, "buffer", "buffer [%08x] ", hopt->buffer);
+			print_0xhex(PRINT_ANY, "cbuffer", "cbuffer [%08x] ", hopt->cbuffer);
 		}
-		if (show_raw)
-			fprintf(f, "buffer [%08x] cbuffer [%08x] ",
-				hopt->buffer, hopt->cbuffer);
 	}
 	if (tb[TCA_HTB_INIT]) {
 		gopt = RTA_DATA(tb[TCA_HTB_INIT]);
-- 
2.17.1

