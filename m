Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712B44EC83D
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 17:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348192AbiC3P3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 11:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348186AbiC3P27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 11:28:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3B81B30A8;
        Wed, 30 Mar 2022 08:27:13 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UFM0W1027915;
        Wed, 30 Mar 2022 15:26:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=AxgLFuP/tlSx1rsffAT5IXk1Giv2HX5q1I0A5GvUjcM=;
 b=WQcYbbEWPedxvpzlBR8SXA8PbWEl/GH/7XoCmLzvZxIRmQGscDXl9dXPi9Zmfrqf25Uo
 g+rB6UqS0UdA3eB6EpmaTs01bXHHhaRuND6HNY5VN78XDZLrMm9VRptEbrGfO5lP0ew9
 0Y56cpecNP1F71yZvwNNLVlXT9i4+NrqqOQyoz4Qz/iMbk4CxG1meIh3Hn4rSts3pEN+
 HlGCOKNZfzx5kUbFm2qXIp0X9rb+p2NBQksA9DEx4dE89Asfj0zhlpgDLc7JEQNpEvd4
 kb/S/J/hWwcUV4UfgEH6msalhXCiz3dy5Nun7dT+GTZSrIsUtSFoA3fhs5YcDUvLv48/ 9w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1sm2hv7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 15:26:57 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22UFAZqZ023548;
        Wed, 30 Mar 2022 15:26:56 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f1s949chw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 15:26:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YExplzGgTS9jQl3TwHNhGsb8/kQA/cvlZp+ETIzWvNnRF8bhEZYYZZlO6UwEGFnOdFqyYrqn+bSmUAfGhxvsF9b7PUNusKimZpMYoAMmWbwsZ41wxokSPAheL7dae6H6gvJp5S/saccg1eTRgLhNRo4QKR4hOPD6nQBk/RiFJqtg0ijJ+R3kZyqKqD5virpKPdB2i0+0dDcIjWJI0d9qk3Ex1B7QRD17pQ9NYAE9HrFh/2UUq+oDG2/8bNEOU+9JrJl7m0CMWLDBRwKb4opZH8j1fR9jgXYPBLNDPYs0LVAHTjenfQTH1LMkOxUWsnYZoDB4HUtfU1oKZbV0qsu8bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AxgLFuP/tlSx1rsffAT5IXk1Giv2HX5q1I0A5GvUjcM=;
 b=eOGpb5tzxKPF16Z08FRcjU2vyOq8ZJYu6EsP4aPjs0jtEw753rvVPIvOfqnK5gy9myI/ymphSg6TdGjCI4pHIBys2Fn9Ge++sDEcXxD3cP//IPGbGXYFuySpoqNM57JXBAQpREm1qYK9Iq8u2UJ1yVb082FV7VMkWJSMAtjSKFRClcK0/aDTxlaaWQ5WL7S/MR3p7jZMm4m5BA51dou7S9+5AFYSHrbDJByfxtNaBceAO1IDaq4hkMDtsubKwV7s/YYVpjlGHi7rIIK5oX4msXF51LGt1R2ipuH2xTK6ZkYr77qRlZgyG8yxc7bQXj7/H/lvD0ajf282LJG3PJzxHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AxgLFuP/tlSx1rsffAT5IXk1Giv2HX5q1I0A5GvUjcM=;
 b=NlSRHs8CgjjTupSA3Xt3s5d+5eVIWTi80YH4e+pc3h/dKkhY0WN3gGhl1ai9soNaI/DXtrZY9JGAjrvQ3xGiexgTfkJRNvR5B0aZGt16oD+z9MkZ0NKUQcjCy8zy6PJhZ+BxR5uhZc2o6+2iE+d/XoRAo3eu6+HLRb/RJxmrcfE=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by DM5PR10MB1322.namprd10.prod.outlook.com (2603:10b6:3:e::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.19; Wed, 30 Mar 2022 15:26:54 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::1483:5b00:1247:2386]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::1483:5b00:1247:2386%4]) with mapi id 15.20.5123.020; Wed, 30 Mar 2022
 15:26:54 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, toke@redhat.com,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v5 bpf-next 4/5] selftests/bpf: add tests for u[ret]probe attach by name
Date:   Wed, 30 Mar 2022 16:26:39 +0100
Message-Id: <1648654000-21758-5-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
References: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0362.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::7) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a83c3b7-3ac4-41c1-860a-08da1261b863
X-MS-TrafficTypeDiagnostic: DM5PR10MB1322:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1322ACF063281347FD9D3BCBEF1F9@DM5PR10MB1322.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KETD4uJ0J0qQx37aNvTxnNY7edndF8gYyvYVwrGV8aqN0bnMf8P5uCzSYE7kBdfzZA5vN//YoJd+jSDAFhFsQ9qOyiELS4abib2MIaU+U5Ams3hULa5AHcVgnwkY2C3lJtchnrr5JR1ndoGpi7mfMeh1EnoK1mDHceEofZF/4n3nYKEDWkWuKL38GLCp07yOnCo5heozBHdbaNfqaeP9e9rcqhUqrZRVAztkrweBFP5OgG89EZc0/81Nl56s9g+2mxHQoAzzyoCeDsMXI7aZi1U8rH0HZWVUX1TWA+hDpONPvpPSmTaFqy4vAGUoRpy9ZXxjbK5UVtcmrS5pyk5dBxaOLKzjiTX33uWTCMyASnO6YSOmKG5eXrJZ2LIQYF4CAUvzb/WO/fT6K+eWnJvdJkSaRb+t+sga+DN9Cs4UBfvp8p2AaE1/v8J80F7CGA7BaCiMVPvG4Xw+nlxvXLM5R5JLcPH3B9ppoTSI44DFvNKt6Ux4aZ5US6JHlS2qS2RSbRWoCFgto6woj3UNjI7lKHD16i3Cas8EPZ370fddv6oG2e0dHz5riIqEBAW35nvtB77QJjJp+Zi8ImEtrJgwhFldHmqHoxIp0kZoNnILFt1yOgMK2cfRGstQANwY+tZOZW0MEz4VujxauHCa2lZDygq3dG/58uzN/VFyQQgMYVsOk/fGA7a7VeLS3m/JTwVyv9CFF7okO8LozrSEL0S8HQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(6666004)(26005)(38350700002)(186003)(6486002)(5660300002)(316002)(2616005)(38100700002)(44832011)(107886003)(7416002)(2906002)(66556008)(36756003)(66946007)(8936002)(8676002)(4326008)(66476007)(6512007)(52116002)(508600001)(6506007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3XM4UgNC+1rTSf1LheJ8ZXrV8sW4wafX1mSupr7S0fz/Y7ePHJsnsCbdhaC6?=
 =?us-ascii?Q?16nh5SgGEP5d/eJErZL8t5TQoCLrnVIgs/JGrEtlVHfPFTJ7PsVrGnFUCi4w?=
 =?us-ascii?Q?2BPX55U0RSowgiihXWRRFg9gNadGqH5HiJVFe9moO1oHHG25NCJ7Lava8/yS?=
 =?us-ascii?Q?yavCxzMZzlfwzs9R+HzLsfIB1ctGzBt3rzHw2m2HALWT9negb7lX7E4JzJLt?=
 =?us-ascii?Q?QDoozsaKfCJaNB9DHf78rxyLQaFvn26+iLIpHLZKO2q25jIVsjsqu/AV6Uod?=
 =?us-ascii?Q?ICElkIL82pb+6zvnIIJrrw7smiWEPTDwhPCtcbcrTZEFrxHYONEiTfy5ylm1?=
 =?us-ascii?Q?lppCyt7ZgViDgi/MvynZ8u6tIzicfeJ7JqBEmlehkIMGQ3c3UsPeHKDstz8J?=
 =?us-ascii?Q?2rrZebL6n6QLd79ugOpB5WTDZ2s9SBzpe5U+RmhtF4jTasCTUHUbqp38IDnx?=
 =?us-ascii?Q?daaTFFpAzw8fXh2ouZ5ZonxMdTGDJBNVeEe/WqH91KDru72lm/oLxANDR/iT?=
 =?us-ascii?Q?1NLA0mIPxHcK5MJWFlQ23/+vhEdRackV1TaIqGSrZTyHmHi8QI/bWXTSoW80?=
 =?us-ascii?Q?KLoQlAzbhY6njSXuAw2VQ6rZwHavL2KkM+uEkrxB83QSI2DiwCB8Yr/vPv9i?=
 =?us-ascii?Q?Ld5GQxfy2+hufWi1ii7FNmSrIr0wDqMflm5mmQFpPZONbiQz3MfKAJ71msow?=
 =?us-ascii?Q?jczt/nkW1ja1ZOV5ZYy5AlvPyPcW0ZiSrK/5O5Ew34J4251Gb0WpAkF1yaYQ?=
 =?us-ascii?Q?v+aNcEViRYxrYw44JyXT8bK9OQVtUvlIGRlruGWEpboKMoniCBb7vmM4ZPfA?=
 =?us-ascii?Q?OBsOC5s9r2YhYMnf1OlN2RUKwNjVjKicsvJigW5YsxFB9jDvBL6LJhlFcOvX?=
 =?us-ascii?Q?Hczgg2eY/4Z6WH6S0o4br75IUKwXvtDF8gdgR7EX280zyPl3iuPpOvZmUz8y?=
 =?us-ascii?Q?XCd+PwmAKBi1Rbx6/LqIIzNBym8EGbt0QHZo9mOwIbfo3VvQKcaIukP1ASuF?=
 =?us-ascii?Q?Ucrvasixiltpl/khSpJHrhdYj2wiyONlmqbow4H5KTb3OQjjcPjXRi/l4RHx?=
 =?us-ascii?Q?6QbP9KjXrTd2uh3YFSBcF4oHGKsmocrNd10dQz92WNL4TpU509chOFigvjjs?=
 =?us-ascii?Q?C0KnnjgWVDaU2TYiOZxwNvL9bkG/0AB9VolIjwon26L0Uq3IxXhjpDbvJaPB?=
 =?us-ascii?Q?m8vrWSf28hGwX6UczxDoLv+VArXDwyLbeRiBJ3YwpjTeMPNKH6s4LU3/lItX?=
 =?us-ascii?Q?c2ruw3GgBItsxTMeq92omV0VupiNchqY+pVFzTEm0vRN7b3CCBa/XJaEX0B7?=
 =?us-ascii?Q?o9veF306pbpf6ldJ7SU2o7QsOryZ8nEtUccAFmdEpermN76WF8XcHQEIxVmm?=
 =?us-ascii?Q?5FPlp95J/9rcbdWqLTvf0Ey7R1c0PP2UwSKeRF4mwardqYAAJCzqmiEzt/G/?=
 =?us-ascii?Q?1O0ZAjxa3jR4OnweUOwZKsQIXWqnPTdyJ3iOUySGY49H061vhVVSsQqeIKKd?=
 =?us-ascii?Q?SzoUtFhCkxNRd/NgvrRPuJ6W1+CsoALAmWvVx4nLzp4IbZUjCKneyiwwTdAQ?=
 =?us-ascii?Q?seQZFUG/plYy7i4Ty5do+KRnbwIbeZVCitRRPm2jTkslQFjWx0i8KyvZtE7i?=
 =?us-ascii?Q?L1f2LQQMSTewiAX/Fhw/31kSXlg3HdlRyidWVHa+/MtovGiOF2ba4IvMJYHi?=
 =?us-ascii?Q?DzKSU1JInOlH2FmMjIp5/OeYOjQEp6afCqQyxnueUI/ZioJUcJXfdQp3mixD?=
 =?us-ascii?Q?0Zhp268nU4S02hh6OKdAeiXSrkyFj9M=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a83c3b7-3ac4-41c1-860a-08da1261b863
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 15:26:54.2723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ehqalZ37NG/QbiMhOTOOhGGfBaa9xgs6K9REOmMqmGcq4YimBXnJfbe/wXep5Domrg3OXxW9p0/dNPqFLah+pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1322
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-03-30_04:2022-03-29,2022-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203300074
X-Proofpoint-ORIG-GUID: jQUKIRK-uTbE6VWV9C6tNA9IkWCquVb_
X-Proofpoint-GUID: jQUKIRK-uTbE6VWV9C6tNA9IkWCquVb_
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add tests that verify attaching by name for

1. local functions in a program
2. library functions in a shared object

...succeed for uprobe and uretprobes using new "func_name"
option for bpf_program__attach_uprobe_opts().  Also verify
auto-attach works where uprobe, path to binary and function
name are specified, but fails with -EOPNOTSUPP with a SEC
name that does not specify binary path/function.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 .../selftests/bpf/prog_tests/attach_probe.c        | 85 ++++++++++++++++++----
 .../selftests/bpf/progs/test_attach_probe.c        | 41 ++++++++++-
 2 files changed, 109 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
index d48f6e5..c0c6d41 100644
--- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
+++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
@@ -11,15 +11,22 @@ static void trigger_func(void)
 	asm volatile ("");
 }
 
+/* attach point for byname uprobe */
+static void trigger_func2(void)
+{
+	asm volatile ("");
+}
+
 void test_attach_probe(void)
 {
 	DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, uprobe_opts);
-	int duration = 0;
 	struct bpf_link *kprobe_link, *kretprobe_link;
 	struct bpf_link *uprobe_link, *uretprobe_link;
 	struct test_attach_probe* skel;
 	ssize_t uprobe_offset, ref_ctr_offset;
+	struct bpf_link *uprobe_err_link;
 	bool legacy;
+	char *mem;
 
 	/* Check if new-style kprobe/uprobe API is supported.
 	 * Kernels that support new FD-based kprobe and uprobe BPF attachment
@@ -43,9 +50,9 @@ void test_attach_probe(void)
 		return;
 
 	skel = test_attach_probe__open_and_load();
-	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
 		return;
-	if (CHECK(!skel->bss, "check_bss", ".bss wasn't mmap()-ed\n"))
+	if (!ASSERT_OK_PTR(skel->bss, "check_bss"))
 		goto cleanup;
 
 	kprobe_link = bpf_program__attach_kprobe(skel->progs.handle_kprobe,
@@ -90,25 +97,73 @@ void test_attach_probe(void)
 		goto cleanup;
 	skel->links.handle_uretprobe = uretprobe_link;
 
-	/* trigger & validate kprobe && kretprobe */
-	usleep(1);
+	/* verify auto-attach fails for old-style uprobe definition */
+	uprobe_err_link = bpf_program__attach(skel->progs.handle_uprobe_byname);
+	if (!ASSERT_EQ(libbpf_get_error(uprobe_err_link), -EOPNOTSUPP,
+		       "auto-attach should fail for old-style name"))
+		goto cleanup;
+
+	uprobe_opts.func_name = "trigger_func2";
+	uprobe_opts.retprobe = false;
+	uprobe_opts.ref_ctr_offset = 0;
+	skel->links.handle_uprobe_byname =
+			bpf_program__attach_uprobe_opts(skel->progs.handle_uprobe_byname,
+							0 /* this pid */,
+							"/proc/self/exe",
+							0, &uprobe_opts);
+	if (!ASSERT_OK_PTR(skel->links.handle_uprobe_byname, "attach_uprobe_byname"))
+		goto cleanup;
+
+	/* verify auto-attach works */
+	skel->links.handle_uretprobe_byname =
+			bpf_program__attach(skel->progs.handle_uretprobe_byname);
+	if (!ASSERT_OK_PTR(skel->links.handle_uretprobe_byname, "attach_uretprobe_byname"))
+		goto cleanup;
 
-	if (CHECK(skel->bss->kprobe_res != 1, "check_kprobe_res",
-		  "wrong kprobe res: %d\n", skel->bss->kprobe_res))
+	/* test attach by name for a library function, using the library
+	 * as the binary argument. libc.so.6 will be resolved via dlopen()/dlinfo().
+	 */
+	uprobe_opts.func_name = "malloc";
+	uprobe_opts.retprobe = false;
+	skel->links.handle_uprobe_byname2 =
+			bpf_program__attach_uprobe_opts(skel->progs.handle_uprobe_byname2,
+							0 /* this pid */,
+							"libc.so.6",
+							0, &uprobe_opts);
+	if (!ASSERT_OK_PTR(skel->links.handle_uprobe_byname2, "attach_uprobe_byname2"))
 		goto cleanup;
-	if (CHECK(skel->bss->kretprobe_res != 2, "check_kretprobe_res",
-		  "wrong kretprobe res: %d\n", skel->bss->kretprobe_res))
+
+	uprobe_opts.func_name = "free";
+	uprobe_opts.retprobe = true;
+	skel->links.handle_uretprobe_byname2 =
+			bpf_program__attach_uprobe_opts(skel->progs.handle_uretprobe_byname2,
+							-1 /* any pid */,
+							"libc.so.6",
+							0, &uprobe_opts);
+	if (!ASSERT_OK_PTR(skel->links.handle_uretprobe_byname2, "attach_uretprobe_byname2"))
 		goto cleanup;
 
+	/* trigger & validate kprobe && kretprobe */
+	usleep(1);
+
+	/* trigger & validate shared library u[ret]probes attached by name */
+	mem = malloc(1);
+	free(mem);
+
 	/* trigger & validate uprobe & uretprobe */
 	trigger_func();
 
-	if (CHECK(skel->bss->uprobe_res != 3, "check_uprobe_res",
-		  "wrong uprobe res: %d\n", skel->bss->uprobe_res))
-		goto cleanup;
-	if (CHECK(skel->bss->uretprobe_res != 4, "check_uretprobe_res",
-		  "wrong uretprobe res: %d\n", skel->bss->uretprobe_res))
-		goto cleanup;
+	/* trigger & validate uprobe attached by name */
+	trigger_func2();
+
+	ASSERT_EQ(skel->bss->kprobe_res, 1, "check_kprobe_res");
+	ASSERT_EQ(skel->bss->kretprobe_res, 2, "check_kretprobe_res");
+	ASSERT_EQ(skel->bss->uprobe_res, 3, "check_uprobe_res");
+	ASSERT_EQ(skel->bss->uretprobe_res, 4, "check_uretprobe_res");
+	ASSERT_EQ(skel->bss->uprobe_byname_res, 5, "check_uprobe_byname_res");
+	ASSERT_EQ(skel->bss->uretprobe_byname_res, 6, "check_uretprobe_byname_res");
+	ASSERT_EQ(skel->bss->uprobe_byname2_res, 7, "check_uprobe_byname2_res");
+	ASSERT_EQ(skel->bss->uretprobe_byname2_res, 8, "check_uretprobe_byname2_res");
 
 cleanup:
 	test_attach_probe__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/test_attach_probe.c b/tools/testing/selftests/bpf/progs/test_attach_probe.c
index 8056a4c..af994d1 100644
--- a/tools/testing/selftests/bpf/progs/test_attach_probe.c
+++ b/tools/testing/selftests/bpf/progs/test_attach_probe.c
@@ -10,6 +10,10 @@
 int kretprobe_res = 0;
 int uprobe_res = 0;
 int uretprobe_res = 0;
+int uprobe_byname_res = 0;
+int uretprobe_byname_res = 0;
+int uprobe_byname2_res = 0;
+int uretprobe_byname2_res = 0;
 
 SEC("kprobe/sys_nanosleep")
 int handle_kprobe(struct pt_regs *ctx)
@@ -25,18 +29,51 @@ int BPF_KRETPROBE(handle_kretprobe)
 	return 0;
 }
 
-SEC("uprobe/trigger_func")
+SEC("uprobe")
 int handle_uprobe(struct pt_regs *ctx)
 {
 	uprobe_res = 3;
 	return 0;
 }
 
-SEC("uretprobe/trigger_func")
+SEC("uretprobe")
 int handle_uretprobe(struct pt_regs *ctx)
 {
 	uretprobe_res = 4;
 	return 0;
 }
 
+SEC("uprobe")
+int handle_uprobe_byname(struct pt_regs *ctx)
+{
+	uprobe_byname_res = 5;
+	return 0;
+}
+
+/* use auto-attach format for section definition. */
+SEC("uretprobe//proc/self/exe:trigger_func2")
+int handle_uretprobe_byname(struct pt_regs *ctx)
+{
+	uretprobe_byname_res = 6;
+	return 0;
+}
+
+SEC("uprobe")
+int handle_uprobe_byname2(struct pt_regs *ctx)
+{
+	unsigned int size = PT_REGS_PARM1(ctx);
+
+	/* verify malloc size */
+	if (size == 1)
+		uprobe_byname2_res = 7;
+	return 0;
+}
+
+SEC("uretprobe")
+int handle_uretprobe_byname2(struct pt_regs *ctx)
+{
+	uretprobe_byname2_res = 8;
+	return 0;
+}
+
 char _license[] SEC("license") = "GPL";
-- 
1.8.3.1

