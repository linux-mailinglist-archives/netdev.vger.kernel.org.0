Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0A54F95B5
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 14:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbiDHM3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 08:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235659AbiDHM3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 08:29:32 -0400
X-Greylist: delayed 5549 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 08 Apr 2022 05:27:27 PDT
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E178433DCA7
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 05:27:27 -0700 (PDT)
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.16.1.2/8.16.1.2) with ESMTP id 2388jEHk019964
        for <netdev@vger.kernel.org>; Fri, 8 Apr 2022 11:54:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=jan2016.eng;
 bh=EFiTfBG8bfJvuo5N6hpUdZZ/xhfjtetwFTvBLPwQ6bc=;
 b=oZRJjSnB9G6pQd+ppis+VpbWXEQGNGPublZ+Sr92XcJtWTSYnIN03RSDh4J/jkdljRR6
 wiwrw2BeggVCCRu+KpRnXGocPbscpnGKp96rm2gfNKP8Pd5laoclX7ECsOURB5EoUxbV
 0irrEB1aa1no/6LRFrcUONKakqANiwVj/jcbG64kBC+VC6Z8/yYRor6wcq13Pfm40bAN
 8+GKhdpzkuZo6Flj4Tbf1cpnqceewgpAWPcrnf00FJVDBmek1BTECXUwqi1AorbVcmhi
 yL6ZAPVrAJQ5lIhPFqUkpXvFiy866LhlvVqpE4ZegQjQyYXQ+zDcOvJyy1abLP1m6vA6 Kw== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by m0050095.ppops.net-00190b01. (PPS) with ESMTPS id 3fa5x75ct8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 11:54:56 +0100
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.16.1.2/8.16.1.2) with SMTP id 238AZaFt023193
        for <netdev@vger.kernel.org>; Fri, 8 Apr 2022 03:54:55 -0700
Received: from email.msg.corp.akamai.com ([172.27.123.30])
        by prod-mail-ppoint5.akamai.com with ESMTP id 3f7kmjqqf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 03:54:54 -0700
Received: from usma1ex-dag3mb2.msg.corp.akamai.com (172.27.123.59) by
 usma1ex-dag4mb1.msg.corp.akamai.com (172.27.91.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.986.22; Fri, 8 Apr 2022 06:54:51 -0400
Received: from localhost (172.27.164.43) by
 usma1ex-dag3mb2.msg.corp.akamai.com (172.27.123.59) with Microsoft SMTP
 Server (TLS) id 15.0.1497.32; Fri, 8 Apr 2022 06:54:50 -0400
Date:   Fri, 8 Apr 2022 11:54:47 +0100
From:   Max Tottenham <mtottenh@akamai.com>
To:     <netdev@vger.kernel.org>
CC:     <johunt@akamai.com>
Subject: [PATCH iproute2-next] tc: Add JSON output to tc-class
Message-ID: <20220408105447.hk7n4p5m4r6npzyh@lon-mp1s1.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [172.27.164.43]
X-ClientProxiedBy: ustx2ex-dag4mb2.msg.corp.akamai.com (172.27.50.201) To
 usma1ex-dag3mb2.msg.corp.akamai.com (172.27.123.59)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-08_03:2022-04-08,2022-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204080054
X-Proofpoint-GUID: UZpsB9m3Ie0bIe5hynexraSuwvYSZRiC
X-Proofpoint-ORIG-GUID: UZpsB9m3Ie0bIe5hynexraSuwvYSZRiC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-08_03,2022-04-08_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 clxscore=1031 mlxscore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204080055
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index 39bea971..10124198 100644
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
 			fprintf(fp, "[cannot parse class parameters]");
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


-- 
Max Tottenham | Senior Software Engineer
/(* Akamai Technologies
