Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6364F63BC
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236372AbiDFPqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236584AbiDFPqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:46:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D656D4B0634;
        Wed,  6 Apr 2022 06:07:34 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 236BYAJv012570;
        Wed, 6 Apr 2022 11:44:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=AL/NSXeYLGcWzJzn0/AMrJAmZUBTyAc9EUli+hPhTJE=;
 b=FvqI/aBDO9ZYjQH03CSru+A34OXBP6QAYGKrcLUS5hf/Ab3AWaPuBsUTyRk/ASOO9fI6
 ZYSTSLN0vi5SKsb2Edpzrb1gjRzuHzlwQESWfiqJ2QdzdLde1sG21QcsWQ5N7QjwE+H8
 o86ABJ58ImfzBL0lyFlJEYyhSnmeSVS8iO4dr3shdDlS2/mTbMeJLmlTu2hITcSNJjIM
 2nvq9tGLlMJE1Bw+DLuUlPDjTiz0PHgDc6UFgHleABwH1sVccP+Xrx923YXHJ0prsQw+
 G6mrn0CraMmlB8+lqF2hcDi2I+V28jgbp7nCxdGE2jDbr6wbuzXgn76wEZbjy10yuxMT dw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6cwcgfag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 11:44:05 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 236BgNkh033516;
        Wed, 6 Apr 2022 11:44:04 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f97wpvq9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 11:44:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JdA9/9qX0dOmorIkn77fBBs7BbsUhnKzVB3Tj5I5jSOf7oJtKGgklEx77SVLoSj/Zrtqr/ETj7GiVuvxNvb1UrYsUHz6yTPurggPTHujkJYOiG4YJS6XT8V7qA3gKqnvIYgnq1D4pgFZ+rbSYAemqXc9Sd8CvSaqolCuTcXg7YsgNsYRDnA5M+zxrgRPogIFaa32acGErtoXYjCOcsy1+UFOwX5jar77mJgrnX8IqOSSFq90QOQ7QN8MJTqpD/FgMn5YlArJ+zvS5/vBf4HbXKN6VzMFhaZdevsJ7RL7yMRtD9bM+2SyHD/xhvbAEaa9q5sdvjrBq+9bybakG20Lrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AL/NSXeYLGcWzJzn0/AMrJAmZUBTyAc9EUli+hPhTJE=;
 b=T3Nn0OWaHcMpus19XQjAyi6Af+HlZRKGqtQPYJfXXKHqZTRE2AkEPMU1f7X+lqf6+p52PaF8rCtoGJ+13PpJezX1mrhL8Uv+ewaIH3nDkaMfwO+5q4TccdDaF/EWFQMENjLNFZWwUgEwrCD9nc0tFf/i7AXT0Rfy1WiT+iBR9C/I3kuD1YmVQtoqRmLjZbCk7c3QEJWoIOj5aH5yVx++fokP3RnHq5kVLq+p0JuKd5KbMwdyHLMwFmUPnWogX9blBxwzJ7RAucK7RuOGHzSdiSin9t5FvAfAXxNh7QfVew9APP1rCzIKmNZUMVXX0ryuSgkq5eiTcZUbJ4eXsmaZ0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AL/NSXeYLGcWzJzn0/AMrJAmZUBTyAc9EUli+hPhTJE=;
 b=Iq3zL1wOYxTtQA5DT7K0wgsH8cFvyPbug33yo5I/D2k1pOKpH+hkv0hxiTePcovUBLYpTYQS0o8kAjlpNkozeDZx6+dwmiCkMs7v2DLgStN1gFuIuQPshx7sw0BjCpjrr2/TW1N4UOAa8l0RX0iNhjkXfqWSRUv/l9mCfOlczN4=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by DM5PR1001MB2409.namprd10.prod.outlook.com (2603:10b6:4:33::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 11:44:02 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52%3]) with mapi id 15.20.5144.019; Wed, 6 Apr 2022
 11:44:02 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 3/3] selftests/bpf: uprobe tests should verify param/return values
Date:   Wed,  6 Apr 2022 12:43:51 +0100
Message-Id: <1649245431-29956-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1649245431-29956-1-git-send-email-alan.maguire@oracle.com>
References: <1649245431-29956-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0073.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::14) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ccf2e3e-387d-4a48-bd18-08da17c2bf06
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2409:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2409B0E341DBD7FE6930D64EEFE79@DM5PR1001MB2409.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gVtb2AYoeaMbogN+ymK1PXY3F2NI6MQQ7c/xBpWoJbSaczKlHXMenB+6fEBpplFiPl57mhUTvxy7rALJfLygmaapI4FzF/Hn5q17keUf2Z9LngSL1DCRpvhu/Rm06eVnJVOapBBsYMjWyuDDlbQy7oUkqg5zcPjSeWUN3XbiSQ8VyrId3DZsJZeeKzXa99DNT3ZZ9CGSsgNn7h3kuR5dWsLjCSkEV7Tf8Y7aOIswcLP0T/olkldTT0KZI5Vjn9E2w0JB/WLGcs2u8VDLHx12Ox4J0LMmaPo2eFt8WxG8evYgjbKQTRKj5rD2bovP5af/GV8A/hQSBjxmWZEUhz8koolaZ8nK5JboGowN4hySNGC9emQg56m4Y8nRe9ikCahCZlzUOkvozd5lAw91Vj/iFaB4KKIKLcIS62lAGprsx98H6qb9XQXfImKkjWuA0Xe0GOAyRUVO0rMQvVJ3A08e238eQenb5UfRCi6yUCNj1vuXvoBxHXwrLzcSpwYZB6G4eQmwDssgKlO0WvJUNovj1eip2PH04/3W6RwjQZQJDCXunIcx4Yfj1GwmX2seEdP9iE1jg6T8y+CDa/Hum3pV50oGKIxE0u5BvhZ6thTxahsVrdHVqapVBvGPzH0+kIJhLv5/RewsSxuiEz/nwKZb+StnuWJhOSsvotDLUHeDfpTkEYcyjlGpIPqpqw8pV8lP7hUwHW+tJz1bRhJvAwQMzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(86362001)(8676002)(15650500001)(4326008)(66476007)(66556008)(316002)(2906002)(66946007)(186003)(5660300002)(8936002)(7416002)(44832011)(2616005)(107886003)(26005)(83380400001)(508600001)(6486002)(6666004)(6506007)(6512007)(52116002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jj93vgjvDBiOHztBFqFcp2fm5Ra8H7qmXjY/vQuNWOOtd9d/WHQzEkf1Bq4M?=
 =?us-ascii?Q?9v9iKJMuN1pioR0DJrYGqN64vFGEBvnmRqujcWx2bmJoE2CiFiA0vIUYNlTU?=
 =?us-ascii?Q?NIu5E6j1ZLLCbM/CNfhI1c7x4nEDuxJ03Dqvt8irQ6TYmqKiC0MVYv+ZpBRB?=
 =?us-ascii?Q?It7XRPk/LwPcVOlr8TtLSm0nM814VQqi7jcYWd1ZAoHWWq7Om+QgMmY6NUDf?=
 =?us-ascii?Q?FdHHcko5VO0WZvJXRwET+vUieHLUtEzuzsp0iTPdeERDXC2OsRtdQxEjfW6C?=
 =?us-ascii?Q?GnJvpKpLUPPIs633zxDTN6rr2Xp/Edv1gekbD1Dl5KwESoRksXOx3wcoWJO0?=
 =?us-ascii?Q?Fy9yx8cb4qOVNIdL9YbQgILWxzbYyvfvVN6tN0lplnk6A5CwTcQnGfvN/ZFA?=
 =?us-ascii?Q?E5SbZiQLquLbgco64QIXLSZ6BlrAV36bZi4JSYdd3B9AwNeDc4ciMbfoAIA8?=
 =?us-ascii?Q?cLKYNpPw8O1vgdaxhwvbT2/SDGgN5KwkgtDjKjfiMoDX0zFxmSfbdJKJV+q5?=
 =?us-ascii?Q?aM1Hw8PPV0qynEAzVgGqkLLZL1FIeQDRK+lcxeXBmClW/idJZF/oEwTTdEVU?=
 =?us-ascii?Q?9wJr4Xef5tWJkGbsc38V+1/+X1I3BBDpJhc1KWenulzxnv6naCHLlzqGLHyM?=
 =?us-ascii?Q?OB/4d1sFTrVjyjtchR5tep39llvQlwyUWrSY/WpiwAkyV9uPAh65Fh3l1xM4?=
 =?us-ascii?Q?rbvTjVQ8txpJe6CCHqGVDaWUJXqjQGAi9JeUVYveoztunbha6EQvjmWpP5FH?=
 =?us-ascii?Q?80bLhZM6CahWr0tRu1dgc8yPDKwZg+5Afl5nOOJ8XmWtPEOOtoHEJBUAJiPG?=
 =?us-ascii?Q?cLGrTCAI3qGUeewuEmnNu64myR11H10HoJqstcRjktSYS1+HZDa6u1F4YrGD?=
 =?us-ascii?Q?oLJKEt33euskmZn+nzHJ3/OKb091KbYJYp0zi+vvYnsKYz/WmA2D/TH7kHlI?=
 =?us-ascii?Q?pjDCD+ucjeP2OlR9u4AAcTBIbyJcUJAt7X22yKL3c8hePhGjnhjCZwYoAluH?=
 =?us-ascii?Q?7kBQIPA7u9//qyUWhfeYnsCPHgbEJEHGNdcE89vwfKfva9VzDq6m56SOOSaO?=
 =?us-ascii?Q?B0j9KQIr3zm7eqZo33os+u//yk+jKSvxrYvyQd61gT3rGz67p61HA2bd3B9z?=
 =?us-ascii?Q?qxQjSGJ9WwSV1C6+hgxNnplRnKeAw1EtFgiU2SzlbsekZIoKzvxKDaJsp8GT?=
 =?us-ascii?Q?ZR9L/6QO0wVE16lUNM2gDFC22nq6j6Wp+UtusfrqAILwA1mdzuapGfqGup3l?=
 =?us-ascii?Q?D4oJvuDYblwyDry3zpdVqGljR+10LKaALibdv2sRi/pnCbhFv/VLxjAPVOTw?=
 =?us-ascii?Q?CCgKhWLB3pLvsqFIZBJN547wUI6eRP7Ogbpou2RCA0qfWSEZxS2TNNGu7DaT?=
 =?us-ascii?Q?Jw0ejOMhyttWPh10XLj5KTLwwNlJFV7CY0jQvrkvEStYW/AIBxnCCwNFTW87?=
 =?us-ascii?Q?V4/Yg9D/OyJZgapWzXlEQ34h7Rqf7Y9S/Zd8v9+bYa2J8Ba7ahinQE/Q+rO2?=
 =?us-ascii?Q?3nFJ+E1TgyC/xQ2KEkhfw5VulVv8g5L6j0VirYed12M5ybdZEIHDOcUIrkPD?=
 =?us-ascii?Q?wShDSts46PSqwX9y6EWyRt8irpIy8IINacn51IbHBORGPGf/DeXm1N8uhtmb?=
 =?us-ascii?Q?HZQmTCXgLoy4sCwg7/yg/EdRhnKdrClglbj7iCMmCxLSE8Zuq0xbjkUenT+z?=
 =?us-ascii?Q?I71N+ZzJvgT8bvJfjJ4ZpFfPNKWYwXbWNleahTo7O1v0oAj0VSx8MTkd8Xcx?=
 =?us-ascii?Q?6IWePYUub8kncQDuoZfJROX4MY3cDmo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ccf2e3e-387d-4a48-bd18-08da17c2bf06
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 11:44:02.4361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +k9s6pw77yXWvKXflK04H1G0iUcVt2in/XMmMwEjXQqoptUT+jxsKLC+ohhFi/JkWKjGQWQf4tEtHy8XhB38kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2409
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_04:2022-04-06,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060054
X-Proofpoint-ORIG-GUID: iZofSm_IF_DyJ2shVcFcx1AverfAsca3
X-Proofpoint-GUID: iZofSm_IF_DyJ2shVcFcx1AverfAsca3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

uprobe/uretprobe tests don't do any validation of arguments/return values,
and without this we can't be sure we are attached to the right function,
or that we are indeed attached to a uprobe or uretprobe.  To fix this
record argument and return value for auto-attached functions and ensure
these match expectations.  Also need to filter by pid to ensure we do
not pick up stray malloc()s since auto-attach traces libc system-wide.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 .../selftests/bpf/prog_tests/uprobe_autoattach.c   | 25 +++++++++----
 .../selftests/bpf/progs/test_uprobe_autoattach.c   | 43 ++++++++++++++++------
 2 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
index 03b15d6..d6003dc 100644
--- a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
+++ b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
@@ -5,14 +5,17 @@
 #include "test_uprobe_autoattach.skel.h"
 
 /* uprobe attach point */
-static void autoattach_trigger_func(void)
+static noinline int autoattach_trigger_func(int arg)
 {
 	asm volatile ("");
+	return arg + 1;
 }
 
 void test_uprobe_autoattach(void)
 {
 	struct test_uprobe_autoattach *skel;
+	int trigger_val = 100, trigger_ret;
+	size_t malloc_sz = 1;
 	char *mem;
 
 	skel = test_uprobe_autoattach__open_and_load();
@@ -22,17 +25,25 @@ void test_uprobe_autoattach(void)
 	if (!ASSERT_OK(test_uprobe_autoattach__attach(skel), "skel_attach"))
 		goto cleanup;
 
+	skel->bss->test_pid = getpid();
+
 	/* trigger & validate uprobe & uretprobe */
-	autoattach_trigger_func();
+	trigger_ret = autoattach_trigger_func(trigger_val);
+
+	skel->bss->test_pid = getpid();
 
 	/* trigger & validate shared library u[ret]probes attached by name */
-	mem = malloc(1);
+	mem = malloc(malloc_sz);
 	free(mem);
 
-	ASSERT_EQ(skel->bss->uprobe_byname_res, 1, "check_uprobe_byname_res");
-	ASSERT_EQ(skel->bss->uretprobe_byname_res, 2, "check_uretprobe_byname_res");
-	ASSERT_EQ(skel->bss->uprobe_byname2_res, 3, "check_uprobe_byname2_res");
-	ASSERT_EQ(skel->bss->uretprobe_byname2_res, 4, "check_uretprobe_byname2_res");
+	ASSERT_EQ(skel->bss->uprobe_byname_parm1, trigger_val, "check_uprobe_byname_parm1");
+	ASSERT_EQ(skel->bss->uprobe_byname_ran, 1, "check_uprobe_byname_ran");
+	ASSERT_EQ(skel->bss->uretprobe_byname_rc, trigger_ret, "check_uretprobe_byname_rc");
+	ASSERT_EQ(skel->bss->uretprobe_byname_ran, 2, "check_uretprobe_byname_ran");
+	ASSERT_EQ(skel->bss->uprobe_byname2_parm1, malloc_sz, "check_uprobe_byname2_parm1");
+	ASSERT_EQ(skel->bss->uprobe_byname2_ran, 3, "check_uprobe_byname2_ran");
+	ASSERT_EQ(skel->bss->uretprobe_byname2_rc, mem, "check_uretprobe_byname2_rc");
+	ASSERT_EQ(skel->bss->uretprobe_byname2_ran, 4, "check_uretprobe_byname2_ran");
 cleanup:
 	test_uprobe_autoattach__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c b/tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c
index b442fb5..ab75522 100644
--- a/tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c
+++ b/tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c
@@ -1,15 +1,22 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2022, Oracle and/or its affiliates. */
 
-#include <linux/ptrace.h>
-#include <linux/bpf.h>
+#include "vmlinux.h"
+
+#include <bpf/bpf_core_read.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
 
-int uprobe_byname_res = 0;
-int uretprobe_byname_res = 0;
-int uprobe_byname2_res = 0;
-int uretprobe_byname2_res = 0;
+int uprobe_byname_parm1 = 0;
+int uprobe_byname_ran = 0;
+int uretprobe_byname_rc = 0;
+int uretprobe_byname_ran = 0;
+size_t uprobe_byname2_parm1 = 0;
+int uprobe_byname2_ran = 0;
+char *uretprobe_byname2_rc = NULL;
+int uretprobe_byname2_ran = 0;
+
+int test_pid;
 
 /* This program cannot auto-attach, but that should not stop other
  * programs from attaching.
@@ -23,14 +30,16 @@ int handle_uprobe_noautoattach(struct pt_regs *ctx)
 SEC("uprobe//proc/self/exe:autoattach_trigger_func")
 int handle_uprobe_byname(struct pt_regs *ctx)
 {
-	uprobe_byname_res = 1;
+	uprobe_byname_parm1 = PT_REGS_PARM1_CORE(ctx);
+	uprobe_byname_ran = 1;
 	return 0;
 }
 
 SEC("uretprobe//proc/self/exe:autoattach_trigger_func")
 int handle_uretprobe_byname(struct pt_regs *ctx)
 {
-	uretprobe_byname_res = 2;
+	uretprobe_byname_rc = PT_REGS_RC_CORE(ctx);
+	uretprobe_byname_ran = 2;
 	return 0;
 }
 
@@ -38,14 +47,26 @@ int handle_uretprobe_byname(struct pt_regs *ctx)
 SEC("uprobe/libc.so.6:malloc")
 int handle_uprobe_byname2(struct pt_regs *ctx)
 {
-	uprobe_byname2_res = 3;
+	int pid = bpf_get_current_pid_tgid() >> 32;
+
+	/* ignore irrelevant invocations */
+	if (test_pid != pid)
+		return 0;
+	uprobe_byname2_parm1 = PT_REGS_PARM1_CORE(ctx);
+	uprobe_byname2_ran = 3;
 	return 0;
 }
 
-SEC("uretprobe/libc.so.6:free")
+SEC("uretprobe/libc.so.6:malloc")
 int handle_uretprobe_byname2(struct pt_regs *ctx)
 {
-	uretprobe_byname2_res = 4;
+	int pid = bpf_get_current_pid_tgid() >> 32;
+
+	/* ignore irrelevant invocations */
+	if (test_pid != pid)
+		return 0;
+	uretprobe_byname2_rc = (char *)PT_REGS_RC_CORE(ctx);
+	uretprobe_byname2_ran = 4;
 	return 0;
 }
 
-- 
1.8.3.1

