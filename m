Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9757D662385
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 11:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbjAIKyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 05:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234441AbjAIKyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 05:54:18 -0500
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05D1B4A5
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 02:54:16 -0800 (PST)
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3095P3OH013057;
        Mon, 9 Jan 2023 10:54:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=jan2016.eng;
 bh=pW4MSRjC/4MMiEXGkJyXw9HcQqeRF8OjZjsa7+XEyZM=;
 b=m/Dit8c0A24rJJKSvGQe+D94MnfxdUqYs86uOXiEIWro7cvMpkpxneJPPMR84pNeK51S
 gJkMbgVQhCCeRbMCHNnaj2nQg313bi+BRx63qCmTGQNSMwwBkDog48Afsgm8iWn2awiB
 KGeRxcGdXZSB3p1vWYrKNMqbN5wo2k6rbYnCA3kkCpdYNYPLfyX3RZ/t34xlUaEn4gbm
 FXZEsXzByL2Xf9IiFmMR4/2N4lAdI7Y3/D4pEwlxQcx9/z6keMVqf5innnXzck5/P/+A
 ED2XO96RkT0URkEO/+EbEFNSH14tXvAQPxBLjvNL4cODZL3ZTBSlCyA554c8Izig9zpt BQ== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by mx0a-00190b01.pphosted.com (PPS) with ESMTPS id 3my0vgkp1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 10:54:15 +0000
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.17.1.19/8.17.1.19) with ESMTP id 30920PCa011591;
        Mon, 9 Jan 2023 02:54:14 -0800
Received: from email.msg.corp.akamai.com ([172.27.91.26])
        by prod-mail-ppoint5.akamai.com (PPS) with ESMTPS id 3my7m1wk51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Jan 2023 02:54:14 -0800
Received: from bos-lhv018.bos01.corp.akamai.com (172.28.221.201) by
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.20; Mon, 9 Jan 2023 05:54:14 -0500
From:   Max Tottenham <mtottenh@akamai.com>
To:     <netdev@vger.kernel.org>
CC:     <johunt@akamai.com>, <stephen@networkplumber.org>,
        Max Tottenham <mtottenh@akamai.com>
Subject: [PATCH v2 iproute2 1/1] tc: Add JSON output to tc-class
Date:   Mon, 9 Jan 2023 05:53:16 -0500
Message-ID: <20230109105316.204902-2-mtottenh@akamai.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230109105316.204902-1-mtottenh@akamai.com>
References: <20230109105316.204902-1-mtottenh@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.28.221.201]
X-ClientProxiedBy: usma1ex-dag4mb3.msg.corp.akamai.com (172.27.91.22) To
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_04,2023-01-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090077
X-Proofpoint-GUID: fTJAmH6AgynzayZzS7o0gffOA26NnyDj
X-Proofpoint-ORIG-GUID: fTJAmH6AgynzayZzS7o0gffOA26NnyDj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_04,2023-01-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 impostorscore=0 bulkscore=0 spamscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 phishscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090077
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  * Add JSON formatted output to the `tc class show ...` command.
  * Add JSON formatted output for the htb qdisc classes.

Signed-off-by: Max Tottenham <mtottenh@akamai.com>
---
 tc/q_htb.c    | 36 ++++++++++++++++++++----------------
 tc/tc_class.c | 28 +++++++++++++++++-----------
 2 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/tc/q_htb.c b/tc/q_htb.c
index b5f95f67..7e3d505a 100644
--- a/tc/q_htb.c
+++ b/tc/q_htb.c
@@ -307,27 +307,27 @@ static int htb_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		    RTA_PAYLOAD(tb[TCA_HTB_CEIL64]) >= sizeof(ceil64))
 			ceil64 = rta_getattr_u64(tb[TCA_HTB_CEIL64]);
 
-		tc_print_rate(PRINT_FP, NULL, "rate %s ", rate64);
+		tc_print_rate(PRINT_ANY, "rate", "rate %s ", rate64);
 		if (hopt->rate.overhead)
-			fprintf(f, "overhead %u ", hopt->rate.overhead);
+			print_uint(PRINT_ANY, "overhead", "overhead %u ", hopt->rate.overhead);
 		buffer = tc_calc_xmitsize(rate64, hopt->buffer);
 
-		tc_print_rate(PRINT_FP, NULL, "ceil %s ", ceil64);
+		tc_print_rate(PRINT_ANY, "ceil", "ceil %s ", ceil64);
 		cbuffer = tc_calc_xmitsize(ceil64, hopt->cbuffer);
 		linklayer = (hopt->rate.linklayer & TC_LINKLAYER_MASK);
 		if (linklayer > TC_LINKLAYER_ETHERNET || show_details)
-			fprintf(f, "linklayer %s ", sprint_linklayer(linklayer, b3));
+			print_string(PRINT_ANY, "linklayer", "linklayer %s ", sprint_linklayer(linklayer, b3));
 		if (show_details) {
-			print_size(PRINT_FP, NULL, "burst %s/", buffer);
-			fprintf(f, "%u ", 1<<hopt->rate.cell_log);
-			print_size(PRINT_FP, NULL, "mpu %s ", hopt->rate.mpu);
-			print_size(PRINT_FP, NULL, "cburst %s/", cbuffer);
-			fprintf(f, "%u ", 1<<hopt->ceil.cell_log);
-			print_size(PRINT_FP, NULL, "mpu %s ", hopt->ceil.mpu);
-			fprintf(f, "level %d ", (int)hopt->level);
+			print_size(PRINT_ANY, "burst", "burst %s/", buffer);
+			print_uint(PRINT_ANY, "burst_cell", "%u", 1<<hopt->rate.cell_log);
+			print_size(PRINT_ANY, "mpu_rate", "mpu %s ", hopt->rate.mpu);
+			print_size(PRINT_ANY, "cburst", "cburst %s/", cbuffer);
+			print_uint(PRINT_ANY, "cburst_cell", "%u", 1<<hopt->ceil.cell_log);
+			print_size(PRINT_ANY, "mpu_ceil", "mpu %s ", hopt->ceil.mpu);
+			print_int(PRINT_ANY, "level", "level %d ", (int)hopt->level);
 		} else {
-			print_size(PRINT_FP, NULL, "burst %s ", buffer);
-			print_size(PRINT_FP, NULL, "cburst %s ", cbuffer);
+			print_size(PRINT_ANY, "burst", "burst %s ", buffer);
+			print_size(PRINT_ANY, "cburst", "cburst %s", cbuffer);
 		}
 		if (show_raw)
 			fprintf(f, "buffer [%08x] cbuffer [%08x] ",
@@ -369,9 +369,13 @@ static int htb_print_xstats(struct qdisc_util *qu, FILE *f, struct rtattr *xstat
 		return -1;
 
 	st = RTA_DATA(xstats);
-	fprintf(f, " lended: %u borrowed: %u giants: %u\n",
-		st->lends, st->borrows, st->giants);
-	fprintf(f, " tokens: %d ctokens: %d\n", st->tokens, st->ctokens);
+	print_uint(PRINT_ANY, "lended", " lended: %u ", st->lends);
+	print_uint(PRINT_ANY, "borrowed", "borrowed: %u ", st->borrows);
+	print_uint(PRINT_ANY, "giants", "giants: %u", st->giants);
+	print_nl();
+	print_int(PRINT_ANY, "tokens", " tokens: %d ", st->tokens);
+	print_int(PRINT_ANY, "ctokens", "ctokens: %d", st->ctokens);
+	print_nl();
 	return 0;
 }
 
diff --git a/tc/tc_class.c b/tc/tc_class.c
index 1297d152..409af2db 100644
--- a/tc/tc_class.c
+++ b/tc/tc_class.c
@@ -334,8 +334,9 @@ int print_class(struct nlmsghdr *n, void *arg)
 		return -1;
 	}
 
+	open_json_object(NULL);
 	if (n->nlmsg_type == RTM_DELTCLASS)
-		fprintf(fp, "deleted ");
+		print_null(PRINT_ANY, "deleted", "deleted ", NULL);
 
 	abuf[0] = 0;
 	if (t->tcm_handle) {
@@ -344,22 +345,24 @@ int print_class(struct nlmsghdr *n, void *arg)
 		else
 			print_tc_classid(abuf, sizeof(abuf), t->tcm_handle);
 	}
-	fprintf(fp, "class %s %s ", rta_getattr_str(tb[TCA_KIND]), abuf);
+	print_string(PRINT_ANY, "class", "class %s ",  rta_getattr_str(tb[TCA_KIND]));
+	print_string(PRINT_ANY, "handle", "%s ", abuf);
 
 	if (filter_ifindex == 0)
-		fprintf(fp, "dev %s ", ll_index_to_name(t->tcm_ifindex));
+		print_devname(PRINT_ANY, t->tcm_ifindex);
 
 	if (t->tcm_parent == TC_H_ROOT)
-		fprintf(fp, "root ");
+		print_bool(PRINT_ANY, "root", "root ", true);
 	else {
 		if (filter_qdisc)
 			print_tc_classid(abuf, sizeof(abuf), TC_H_MIN(t->tcm_parent));
 		else
 			print_tc_classid(abuf, sizeof(abuf), t->tcm_parent);
-		fprintf(fp, "parent %s ", abuf);
+		print_string(PRINT_ANY, "parent", "parent %s ", abuf);
 	}
 	if (t->tcm_info)
-		fprintf(fp, "leaf %x: ", t->tcm_info>>16);
+		print_0xhex(PRINT_ANY, "leaf", "leaf %x", t->tcm_info>>16);
+
 	q = get_qdisc_kind(RTA_DATA(tb[TCA_KIND]));
 	if (tb[TCA_OPTIONS]) {
 		if (q && q->print_copt)
@@ -367,19 +370,21 @@ int print_class(struct nlmsghdr *n, void *arg)
 		else
 			fprintf(stderr, "[cannot parse class parameters]");
 	}
-	fprintf(fp, "\n");
+	print_nl();
 	if (show_stats) {
 		struct rtattr *xstats = NULL;
-
+		open_json_object("stats");
 		if (tb[TCA_STATS] || tb[TCA_STATS2]) {
 			print_tcstats_attr(fp, tb, " ", &xstats);
-			fprintf(fp, "\n");
+			print_string(PRINT_FP, NULL, "\n", NULL);
 		}
 		if (q && (xstats || tb[TCA_XSTATS]) && q->print_xstats) {
 			q->print_xstats(q, fp, xstats ? : tb[TCA_XSTATS]);
-			fprintf(fp, "\n");
+			print_string(PRINT_FP, NULL, "\n", NULL);
 		}
+		close_json_object();
 	}
+	close_json_object();
 	fflush(fp);
 	return 0;
 }
@@ -450,11 +455,12 @@ static int tc_class_list(int argc, char **argv)
 		perror("Cannot send dump request");
 		return 1;
 	}
-
+	new_json_obj(json);
 	if (rtnl_dump_filter(&rth, print_class, stdout) < 0) {
 		fprintf(stderr, "Dump terminated\n");
 		return 1;
 	}
+	delete_json_obj();
 
 	if (show_graph)
 		graph_cls_show(stdout, &buf[0], &root_cls_list, 0);
-- 
2.17.1

