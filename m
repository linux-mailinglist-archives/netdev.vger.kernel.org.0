Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F3B65EEA3
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 15:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbjAEOVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 09:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbjAEOVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 09:21:05 -0500
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D84044C76
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 06:21:03 -0800 (PST)
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305CVYgn029425;
        Thu, 5 Jan 2023 14:21:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=jan2016.eng;
 bh=sVKEq6eiSIn98z29YIRPsjQWoGQlmS1oiUq/AJDSXm8=;
 b=V3ZfuQGMu5hP1uUu7JBasPtfmMaPviU/FS16Z8fgUOMlJz56S12mPe4JZAP7uVOTQiXa
 +fm7HV0Ji0pxMHf8d7efj7mpOAJ2kmA2oQ8mW75WSVMDacpBdZ+f0AL10+SHH/5IaiCd
 s1kPZ49XbFZbYeBZAkUtyxd8FzSl+f9Jl3OFxsORLtw7swo2ICmFSzmqXChUsauBe0Z1
 l5rSdC3NHfX7cTQzRHnbLGXK1e3B/OorvAOLPUhfu40jB3YphLMrfxAJ0Bf0oNwRZj5K
 vwVZNbhHCdDB4F218UgInE0DOgt4YPyTKOf9847qCFsEB3W/PgFmXiu7XeKgCcDje2Z0 zw== 
Received: from prod-mail-ppoint6 (prod-mail-ppoint6.akamai.com [184.51.33.61] (may be forged))
        by mx0a-00190b01.pphosted.com (PPS) with ESMTPS id 3mvndv1p77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 14:21:01 +0000
Received: from pps.filterd (prod-mail-ppoint6.akamai.com [127.0.0.1])
        by prod-mail-ppoint6.akamai.com (8.17.1.19/8.17.1.19) with ESMTP id 305BE4Oh012360;
        Thu, 5 Jan 2023 09:21:00 -0500
Received: from email.msg.corp.akamai.com ([172.27.91.24])
        by prod-mail-ppoint6.akamai.com (PPS) with ESMTPS id 3mwwgarkxr-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 09:21:00 -0500
Received: from bos-lhv018.bos01.corp.akamai.com (172.28.221.201) by
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.20; Thu, 5 Jan 2023 09:20:44 -0500
From:   Max Tottenham <mtottenh@akamai.com>
To:     <netdev@vger.kernel.org>
CC:     <johunt@akamai.com>, <stephen@networkplumber.org>,
        Max Tottenham <mtottenh@akamai.com>
Subject: [PATCH iproute2-next] tc: Add JSON output to tc-class
Date:   Thu, 5 Jan 2023 09:20:13 -0500
Message-ID: <20230105142013.243810-2-mtottenh@akamai.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230105142013.243810-1-mtottenh@akamai.com>
References: <20230105142013.243810-1-mtottenh@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.28.221.201]
X-ClientProxiedBy: usma1ex-dag4mb6.msg.corp.akamai.com (172.27.91.25) To
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_05,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301050113
X-Proofpoint-ORIG-GUID: I9imnXwdqevkb8Z4c612PjCgRvD-GH5N
X-Proofpoint-GUID: I9imnXwdqevkb8Z4c612PjCgRvD-GH5N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_04,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 phishscore=0 malwarescore=0 clxscore=1031 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301050111
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
 tc/q_htb.c    | 43 +++++++++++++++++++++++++++----------------
 tc/tc_class.c | 29 ++++++++++++++++++-----------
 2 files changed, 45 insertions(+), 27 deletions(-)

diff --git a/tc/q_htb.c b/tc/q_htb.c
index b5f95f67..c4e36f27 100644
--- a/tc/q_htb.c
+++ b/tc/q_htb.c
@@ -307,27 +307,36 @@ static int htb_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		    RTA_PAYLOAD(tb[TCA_HTB_CEIL64]) >= sizeof(ceil64))
 			ceil64 = rta_getattr_u64(tb[TCA_HTB_CEIL64]);
 
-		tc_print_rate(PRINT_FP, NULL, "rate %s ", rate64);
+		tc_print_rate(PRINT_ANY, "rate", "rate %s ", rate64);
 		if (hopt->rate.overhead)
-			fprintf(f, "overhead %u ", hopt->rate.overhead);
+			print_int(PRINT_ANY, "overhead", "overhead %u ", hopt->rate.overhead);
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
+			open_json_object("details");
+			char burst_buff[64] = {0};
+			char rate_string[64] = {0};
+			sprint_size(buffer, burst_buff);
+			snprintf(rate_string,  64, "%s/%u", burst_buff, 1<<hopt->rate.cell_log);
+
+			print_string(PRINT_ANY, "burst", "burst %s ", rate_string);
+			print_size(PRINT_ANY, "mpu_rate", "mpu %s ", hopt->rate.mpu);
+
+			sprint_size(cbuffer, burst_buff);
+			snprintf(rate_string,  64, "%s/%u", burst_buff, 1<<hopt->ceil.cell_log);
+			print_string(PRINT_ANY, "cburst", "cburst %s ", rate_string);
+
+			print_size(PRINT_ANY, "mpu_ceil", "mpu %s ", hopt->ceil.mpu);
+			print_int(PRINT_ANY, "level", "level %d ", (int)hopt->level);
+			close_json_object();
 		} else {
-			print_size(PRINT_FP, NULL, "burst %s ", buffer);
-			print_size(PRINT_FP, NULL, "cburst %s ", cbuffer);
+			print_size(PRINT_ANY, "burst", "burst %s ", buffer);
+			print_size(PRINT_ANY, "cburst", "cburst %s", cbuffer);
 		}
 		if (show_raw)
 			fprintf(f, "buffer [%08x] cbuffer [%08x] ",
@@ -369,9 +378,11 @@ static int htb_print_xstats(struct qdisc_util *qu, FILE *f, struct rtattr *xstat
 		return -1;
 
 	st = RTA_DATA(xstats);
-	fprintf(f, " lended: %u borrowed: %u giants: %u\n",
-		st->lends, st->borrows, st->giants);
-	fprintf(f, " tokens: %d ctokens: %d\n", st->tokens, st->ctokens);
+	print_uint(PRINT_ANY, "lended", " lended: %u ", st->lends);
+	print_uint(PRINT_ANY, "borrowed", "borrowed: %u ", st->borrows);
+	print_uint(PRINT_ANY, "giants", "giants: %u\n", st->giants);
+	print_int(PRINT_ANY, "tokens", " tokens: %d ", st->tokens);
+	print_int(PRINT_ANY, "ctokens", "ctokens: %d\n", st->ctokens);
 	return 0;
 }
 
diff --git a/tc/tc_class.c b/tc/tc_class.c
index 1297d152..7788a667 100644
--- a/tc/tc_class.c
+++ b/tc/tc_class.c
@@ -316,6 +316,8 @@ int print_class(struct nlmsghdr *n, void *arg)
 		return -1;
 	}
 
+	open_json_object(NULL);
+
 	if (show_graph) {
 		graph_node_add(t->tcm_parent, t->tcm_handle, TCA_RTA(t), len);
 		return 0;
@@ -335,7 +337,7 @@ int print_class(struct nlmsghdr *n, void *arg)
 	}
 
 	if (n->nlmsg_type == RTM_DELTCLASS)
-		fprintf(fp, "deleted ");
+		print_bool(PRINT_ANY, "deleted", "deleted ", true);
 
 	abuf[0] = 0;
 	if (t->tcm_handle) {
@@ -344,22 +346,24 @@ int print_class(struct nlmsghdr *n, void *arg)
 		else
 			print_tc_classid(abuf, sizeof(abuf), t->tcm_handle);
 	}
-	fprintf(fp, "class %s %s ", rta_getattr_str(tb[TCA_KIND]), abuf);
+	print_string(PRINT_ANY, "class", "class %s ",  rta_getattr_str(tb[TCA_KIND]));
+	print_string(PRINT_ANY, "handle", "%s ", abuf);
 
 	if (filter_ifindex == 0)
-		fprintf(fp, "dev %s ", ll_index_to_name(t->tcm_ifindex));
+		print_string(PRINT_ANY, "dev", "dev %s ", ll_index_to_name(t->tcm_ifindex));
 
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
@@ -367,19 +371,21 @@ int print_class(struct nlmsghdr *n, void *arg)
 		else
 			fprintf(stderr, "[cannot parse class parameters]");
 	}
-	fprintf(fp, "\n");
+	print_string(PRINT_FP, NULL, "\n", NULL);
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
@@ -450,11 +456,12 @@ static int tc_class_list(int argc, char **argv)
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

