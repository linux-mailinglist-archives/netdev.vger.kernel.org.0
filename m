Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A19D1E1EDC
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 11:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbgEZJlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 05:41:08 -0400
Received: from mail-eopbgr70139.outbound.protection.outlook.com ([40.107.7.139]:6115
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728568AbgEZJlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 05:41:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3Tjp/8m+0T1X8N4yU0mVEkKI3r9UVxdV0aYL3GLUgSsh1588rAUPgf7gW25bNmTAqpeBkGtfP6eoMtNsgxvlSlYbeTxAEtmkO6IxRT9tNK8oj2i37NdBoe4NccI9ENdcw4gkVrvS+IwhTL9KnO/PBzKdW5u1hwpkxvyr05gxM+hgKxKFwHKHAbB3Yf/HB0+XB5+BYw41FYHUu8DtzfOh7nd74XU23d6JEdnUeswMP58uAjbDhXVTjD99yjHN9toyCRpsTE9YOC56LC4c6bxnATYf71crj0EmNyvgIgHJ5MmZtD8J11SLpyL9rK0S3hfflsUnFykSDCteiuBNsPMKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hNr3QO7rC4hoqJ+dsh1HpuPfnO8BgTP/4FB9r/LLJw0=;
 b=eqD0P9rrsCgMm0/hxKspIQLrHDGvlAn6gO4tveWrawz2blGdb5qB8Dgqq2w/gkYQYvTLvZpsgIxQlDqhjoTrDEH49LN9BFpVhHZ5GoY1Baje83Un8Hri1ZFWk3q9BQMdQAkc2UwiQ5Usnn078IwZGA4p7iMCwximRSnVNTfVnVzy5cploh3bajYSTLTg9NgnwaVhrZqJSi/HaL5pJvJ/1iz+PZ9XwZsKzaIZvej5XfxoVZVbo2ngIWy3M24rilMyeqyxvn4KxOzcU24ZjJjlmS0v3wwFF13XsFEoV7fNvFBRGciKw2yQR8udhbB+pYstMk7P1ANZ6bIY5i8aXiZXJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hNr3QO7rC4hoqJ+dsh1HpuPfnO8BgTP/4FB9r/LLJw0=;
 b=KiAYleKcAFPOhmXqpquRRR1NSGAyQvRm3WALIdlLhVylHU0yd2KCb7vdBqSdX0E81lWaWchOqF5SggAktT6KXgN/hOVQsje0plDFaFX9FUb0WMNDDXZf2OpRgAFnSvDwHm2Rz25vUL9deeo/KbUkEQDFDFg+NDJE+9Z59nOQm1I=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=dektech.com.au;
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com (2603:10a6:209:5::28)
 by AM6PR0502MB3830.eurprd05.prod.outlook.com (2603:10a6:209:11::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Tue, 26 May
 2020 09:41:03 +0000
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf]) by AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 09:41:03 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     dsahern@gmail.com, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [iproute2-next] tipc: enable printing of broadcast rcv link stats
Date:   Tue, 26 May 2020 16:40:55 +0700
Message-Id: <20200526094055.17526-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Content-Type: text/plain
X-ClientProxiedBy: HK2PR03CA0059.apcprd03.prod.outlook.com
 (2603:1096:202:17::29) To AM6PR0502MB3925.eurprd05.prod.outlook.com
 (2603:10a6:209:5::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by HK2PR03CA0059.apcprd03.prod.outlook.com (2603:1096:202:17::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3045.8 via Frontend Transport; Tue, 26 May 2020 09:41:00 +0000
X-Mailer: git-send-email 2.13.7
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7921957b-8f90-4f84-a10f-08d80158e77d
X-MS-TrafficTypeDiagnostic: AM6PR0502MB3830:
X-Microsoft-Antispam-PRVS: <AM6PR0502MB383071CA10D81A18235683DDE2B00@AM6PR0502MB3830.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:127;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z2Zwq0Yu3eelAaHenUxAiIwcnu3/Ay6J8oRR1rsLIbmkB4Q05xYGOLuCOm/Y5hR7qTRLrVNKx6H/XnVFhrcvIHFoq62BgiQRjsQzjMLM0ylE+ipshh3gdJoIwFn3JqhbeNK9DABkxSbPoZybkLBMJF17pNSquLC2V0lGLK41i8/Qj2G3PJdcAVdYDz7qADWNUiIqBUftWl7ZEjM2kih0eSYKMvNio3ay6YjnUYilWlA5z3s9wfEXVRehyeyvT4Kbqz6gS+66wEYwTin7eBi5Vh7LmPbcGulK8V5WwPmhrgBbyIzpG6eDJN74FePN/SkE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0502MB3925.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(39850400004)(396003)(136003)(366004)(36756003)(1076003)(6666004)(2906002)(2616005)(478600001)(956004)(66946007)(66556008)(66476007)(26005)(316002)(7696005)(52116002)(4326008)(16526019)(186003)(55016002)(86362001)(8936002)(8676002)(5660300002)(103116003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: aqNv3IDrW8jHGJN+4Z7+4Uwc1mh6jpcA06y/EGx+W+wxw5Uuu7hWP33CC91lNz4AuOPh4BlzNwSV5OR7KeGq35CxWnzULWzNa0LU2BgtqH00DXQk+7RWt/JTHMonRNET8ZdNP5fyI3ZF7c6B03fwux+ZQXPO7AU2yeK/X0vST7tdX6BdqmKAQ580NKDHze1O9hLj6A7aQQAt0No39LmJ52q7JY0beQmR5qMCdFxPV1EpDkoLQFgClhg8T8I99QVbXItE/kjANO26jC65vJ9Hnwpkwk5Q5isP1Fgh3o6qXk3WPbwM8DvA2lA8KINuvnnP2D7vzYSCGLs6KD9hqahNGmZlnWf5s1XU2SObKxHqizqfQ37kBLw7ebhEJVKAN7iSvZ8vhKeFxqR+f6fajm2Zp06W5ADSp+bwLbUCkIdbbANAmE5VS/WzavFT15wwOkIAMnbzf/MIG1o+SyiUcZ5x8o+24LDhe+YinFTboOzHqHs=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 7921957b-8f90-4f84-a10f-08d80158e77d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 09:41:02.9073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S3CB4S6XOm5aN31VRiEf6zbNIu8l+FZfO32dZFGnldlNLvGKXe9O5hSmhfVjZBjYtTpEBmSckPi7ZicYOvTOUqfvkDcDwmkcMPVCihFhLCg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3830
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit allows printing the statistics of a broadcast-receiver link
using the same tipc command, but with additional 'link' options:

$ tipc link stat show --help
Usage: tipc link stat show [ link { LINK | SUBSTRING | all } ]

With:
+ 'LINK'      : print the stats of the specific link 'LINK';
+ 'SUBSTRING' : print the stats of all the links having the 'SUBSTRING'
                in name;
+ 'all'       : print all the links' stats incl. the broadcast-receiver
                ones;

Also, a link stats can be reset in the usual way by specifying the link
name in command.

For example:

$ tipc l st sh l br
Link <broadcast-link>
  Window:50 packets
  RX packets:0 fragments:0/0 bundles:0/0
  TX packets:5011125 fragments:4968774/149643 bundles:38402/307061
  RX naks:781484 defs:0 dups:0
  TX naks:0 acks:0 retrans:330259
  Congestion link:50657  Send queue max:0 avg:0

Link <broadcast-link:1001001>
  Window:50 packets
  RX packets:95146 fragments:95040/1980 bundles:1/2
  TX packets:0 fragments:0/0 bundles:0/0
  RX naks:380938 defs:83962 dups:403
  TX naks:8362 acks:0 retrans:170662
  Congestion link:0  Send queue max:0 avg:0

Link <broadcast-link:1001002>
  Window:50 packets
  RX packets:0 fragments:0/0 bundles:0/0
  TX packets:0 fragments:0/0 bundles:0/0
  RX naks:400546 defs:0 dups:0
  TX naks:0 acks:0 retrans:159597
  Congestion link:0  Send queue max:0 avg:0

$ tipc l st sh l 1001002
Link <1001003:data0-1001002:data0>
  ACTIVE  MTU:1500  Priority:10  Tolerance:1500 ms  Window:50 packets
  RX packets:99546 fragments:0/0 bundles:33/877
  TX packets:629 fragments:0/0 bundles:35/828
  TX profile sample:8 packets average:390 octets
  0-64:75% -256:0% -1024:0% -4096:25% -16384:0% -32768:0% -66000:0%
  RX states:488714 probes:7397 naks:0 defs:4 dups:5
  TX states:27734 probes:18016 naks:5 acks:2305 retrans:0
  Congestion link:0  Send queue max:0 avg:0

Link <broadcast-link:1001002>
  Window:50 packets
  RX packets:0 fragments:0/0 bundles:0/0
  TX packets:0 fragments:0/0 bundles:0/0
  RX naks:400546 defs:0 dups:0
  TX naks:0 acks:0 retrans:159597
  Congestion link:0  Send queue max:0 avg:0

$ tipc l st re l broadcast-link:1001002

$ tipc l st sh l broadcast-link:1001002
Link <broadcast-link:1001002>
  Window:50 packets
  RX packets:0 fragments:0/0 bundles:0/0
  TX packets:0 fragments:0/0 bundles:0/0
  RX naks:0 defs:0 dups:0
  TX naks:0 acks:0 retrans:0
  Congestion link:0  Send queue max:0 avg:0

Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 tipc/link.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/tipc/link.c b/tipc/link.c
index e123c186..ba77a201 100644
--- a/tipc/link.c
+++ b/tipc/link.c
@@ -334,7 +334,7 @@ static int _show_link_stat(const char *name, struct nlattr *attrs[],
 
 	open_json_object(NULL);
 
-	print_string(PRINT_ANY, "link", "\nLink <%s>\n", name);
+	print_string(PRINT_ANY, "link", "Link <%s>\n", name);
 	print_string(PRINT_JSON, "state", "", NULL);
 	open_json_array(PRINT_JSON, NULL);
 	if (attrs[TIPC_NLA_LINK_ACTIVE])
@@ -433,7 +433,7 @@ static int _show_link_stat(const char *name, struct nlattr *attrs[],
 			   mnl_attr_get_u32(stats[TIPC_NLA_STATS_LINK_CONGS]));
 	print_uint(PRINT_ANY, "send queue max", "  Send queue max:%u",
 			   mnl_attr_get_u32(stats[TIPC_NLA_STATS_MAX_QUEUE]));
-	print_uint(PRINT_ANY, "avg", " avg:%u\n",
+	print_uint(PRINT_ANY, "avg", " avg:%u\n\n",
 			   mnl_attr_get_u32(stats[TIPC_NLA_STATS_AVG_QUEUE]));
 
 	close_json_object();
@@ -496,7 +496,7 @@ static int _show_bc_link_stat(const char *name, struct nlattr *prop[],
 			   mnl_attr_get_u32(stats[TIPC_NLA_STATS_LINK_CONGS]));
 	print_uint(PRINT_ANY, "send queue max", "  Send queue max:%u",
 			   mnl_attr_get_u32(stats[TIPC_NLA_STATS_MAX_QUEUE]));
-	print_uint(PRINT_ANY, "avg", " avg:%u\n",
+	print_uint(PRINT_ANY, "avg", " avg:%u\n\n",
 			   mnl_attr_get_u32(stats[TIPC_NLA_STATS_AVG_QUEUE]));
 	close_json_object();
 
@@ -527,8 +527,10 @@ static int link_stat_show_cb(const struct nlmsghdr *nlh, void *data)
 
 	name = mnl_attr_get_str(attrs[TIPC_NLA_LINK_NAME]);
 
-	/* If a link is passed, skip all but that link */
-	if (link && (strcmp(name, link) != 0))
+	/* If a link is passed, skip all but that link.
+	 * Support a substring matching as well.
+	 */
+	if (link && !strstr(name, link))
 		return MNL_CB_OK;
 
 	if (attrs[TIPC_NLA_LINK_BROADCAST]) {
@@ -540,7 +542,7 @@ static int link_stat_show_cb(const struct nlmsghdr *nlh, void *data)
 
 static void cmd_link_stat_show_help(struct cmdl *cmdl)
 {
-	fprintf(stderr, "Usage: %s link stat show [ link LINK ]\n",
+	fprintf(stderr, "Usage: %s link stat show [ link { LINK | SUBSTRING | all } ]\n",
 		cmdl->argv[0]);
 }
 
@@ -554,6 +556,7 @@ static int cmd_link_stat_show(struct nlmsghdr *nlh, const struct cmd *cmd,
 		{ "link",		OPT_KEYVAL,	NULL },
 		{ NULL }
 	};
+	struct nlattr *attrs;
 	int err = 0;
 
 	if (help_flag) {
@@ -571,8 +574,14 @@ static int cmd_link_stat_show(struct nlmsghdr *nlh, const struct cmd *cmd,
 		return -EINVAL;
 
 	opt = get_opt(opts, "link");
-	if (opt)
-		link = opt->val;
+	if (opt) {
+		if (strcmp(opt->val, "all"))
+			link = opt->val;
+		/* Set the flag to dump all bc links */
+		attrs = mnl_attr_nest_start(nlh, TIPC_NLA_LINK);
+		mnl_attr_put(nlh, TIPC_NLA_LINK_BROADCAST, 0, NULL);
+		mnl_attr_nest_end(nlh, attrs);
+	}
 
 	new_json_obj(json);
 	err = msg_dumpit(nlh, link_stat_show_cb, link);
-- 
2.13.7

