Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9B11F1DF2
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 18:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730698AbgFHQ7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 12:59:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7662 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730236AbgFHQ7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 12:59:08 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 058GvjwN029466;
        Mon, 8 Jun 2020 09:58:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=NcRyU/UyqppTVtCaM8ZClsmy7SBJfUVPwcrFJd+Djr8=;
 b=JP1T7vvkP9xSDjwExXxkm1KiZvyI6C8f4ymzl8rKvaspN4HGplpFQRFXNv4RxntUuzJF
 I4hFVGkHmf1ELPSIvSSD642NwIYh7HmaUjG7VAlvz0adLHbmdV0H2fPkzIat2jHYwpAn
 c5Qcj4BBIZQ6FUjwnYNK12NyqkJ1zprNwfE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 31g6tkghc0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 08 Jun 2020 09:58:50 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 8 Jun 2020 09:58:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oind7q8+j5cCbZLWfqOESfgY1xpKNhViO+H8XnWkCX+Sx1Gdz7M8PoQDcToYAOEV6xQPxHWL0GJLBlv1uTuuLkOk/U+cTkImv+r70vOxg2S0dXYvTMnoVyZURGyEkkcuvlCDt5GDjzlCOUAIkkttUVsmG4uoEOyLjIOwQ0IX/IssaGjN8uJsKrmlkuLr7ridO8b1KMNk9I7i8YqAogNBv+A16o5T3vc0jxgfXcZvUbBa/7etF/mMbt1xGGkgGR4aAVN7d5zgEjcK0Hh+JyPj3nMCfk6OEAngsl3K1g/WeaGMXDCvfsjXMGfpUcLlva1x8cTIObXvqT7cgxNkniZ08A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NcRyU/UyqppTVtCaM8ZClsmy7SBJfUVPwcrFJd+Djr8=;
 b=TtyKGdg7a8+KWAunKghZWXC90HMJPOoYSOFaVpr4SofZNEyhslqd4X35iYjOvy2VvrdMXpYelEgXrG8sELCFOPLeFlURuPKoFGGb2xiJa9HqmD75YQlUTdUyHoEeyao97VYXaKRjaIiBhUsXNOysHqxzaa1a8bz+IVGzgabzlc5eRPPO6gIsCrby8jCkOqkiB6fPl15aVGBygPy7NM5EoHAqsUeLEiVZXzWAUfRfYfArrsI6qEN3XxpS1pfOcYI/+nO0IJtvvkcOWmoyPBj8Oy6IP+kspSIwTZ8xYlS/hbltumrJYzY9mlh/r75UtON1vFLO7fo4+NHsxhudbuBSzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NcRyU/UyqppTVtCaM8ZClsmy7SBJfUVPwcrFJd+Djr8=;
 b=D6e3JL9oIxQEu2RYlvHWRrpblaoc4WanRReEWUmj/A9I/EHA1HRMMRP3lfVX6RE7mCg5Q9xgCbAddvCcn1BboDiaM/QLdf2EIWkeJo/44A2zBwPNH0moaUR8wP1DKdGHNJRJayCofu5+GVgQpvD2f/oTtC7C9G1tuA3V0dpCohM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2280.namprd15.prod.outlook.com (2603:10b6:a02:8a::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.20; Mon, 8 Jun
 2020 16:58:48 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3066.023; Mon, 8 Jun 2020
 16:58:48 +0000
Subject: Re: fentry/fexit attach to EXT type XDP program does not work
To:     Eelco Chaudron <echaudro@redhat.com>, <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kafai@fb.com>, <songliubraving@fb.com>, <andriin@fb.com>,
        <toke@redhat.com>
References: <159162546868.10791.12432342618156330247.stgit@ebuild>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <42b0c8d3-e855-7531-b01c-a05414360aff@fb.com>
Date:   Mon, 8 Jun 2020 09:58:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <159162546868.10791.12432342618156330247.stgit@ebuild>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: BYAPR11CA0070.namprd11.prod.outlook.com
 (2603:10b6:a03:80::47) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::1093] (2620:10d:c090:400::5:4e11) by BYAPR11CA0070.namprd11.prod.outlook.com (2603:10b6:a03:80::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.19 via Frontend Transport; Mon, 8 Jun 2020 16:58:47 +0000
X-Originating-IP: [2620:10d:c090:400::5:4e11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 066eef20-26c4-4ae6-79bf-08d80bcd3664
X-MS-TrafficTypeDiagnostic: BYAPR15MB2280:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB228043F22DDE2867BCCC4379D3850@BYAPR15MB2280.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 042857DBB5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IaFzCjcwrplKRT+HNqaZjn0bl0FsjZXSxgq20Dg4FL1qOTBZdlupFkFpB8kYa2IEFZEOv4EkUT8yLDfdccvPIYZDEDpwhLTpyP9JmjYyQYSTimNC7wu2PHP3AaqILq1EwIK00dIPnI1xJ8C/MbHdMFKD+5a3BhuKcud5kAp2Fq79JYnojpUJ1AjRlPjH1H9ehDGfae/cRJSOfHZtuKhesnwqPkxICIxve6XO8v/bUMagZfGUEbf0M7NIiwfvnJVPskzGJ1gXXF/lmmca6WMERc5LBb7UrNfa3331pFuNkBdUvqUs8KBp64Kz0YW9heN1IMk8uTNN+LZu7Fl6JVShxU3yXd6bAHh3ecac5WcoM24lPP0oOwyeZsB5m9mjC6Yq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(39860400002)(346002)(396003)(376002)(136003)(478600001)(66556008)(86362001)(6486002)(66476007)(31686004)(66946007)(16526019)(8936002)(2616005)(36756003)(316002)(52116002)(53546011)(2906002)(31696002)(83380400001)(4326008)(8676002)(5660300002)(186003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: j2gC0ygJ7Y+7wOk9fkkiBjrwDMM6QSdd09bmIutjPogP0HqwtNPdQ83bAU1fdxl97ea5bWkf3NiEG7vaG0lgwnokVL0TEsST/ZrTNWJtR2pRzL+9O2K1OyxbdU/18D/T/XiVY4K79v8jrmMgvIcZY18z03SJs8exgGq2ssig8h/IgyB5FSJ54vFKCDj5thFy5leV+R+nhi1SSzeJDoYB3GWvoGvEx1Du4N/JzFjXwCKg+npLWxrD1J1aLA6dg3PQ0coFLAeSNGgwETdY1clLICMdi9lNQI6nfsULcIDwJfPTJld+unu2e+oRE3Y/6k4Atd0ilheqjx8Ir1AS45FszVC7Cc6S3J5Xt6Tg6vSf3jSU6q4UTD1e0Pa2j7m7izHIYq+LIcGMt/+06hIuE6/BWt0cM532bgz6bvqInuyBk2NPAmIjFpu1eGTp2+i52Ui4cGfHEZfymMjZCGgoL2VCsIsfBN5AETGjUo7RCyOIO0555RLVZBnXOd/Ux2V0m5ZeUA8reDN9kZ+jQ2wWuNnVnw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 066eef20-26c4-4ae6-79bf-08d80bcd3664
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2020 16:58:48.4898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: avTeeX46/nJF3+xlBDA5vAxaGjLxNbOhCDtkJ5RKNrcXU5wVunps1UsH4VXJjT/C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2280
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-08_14:2020-06-08,2020-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 impostorscore=0 bulkscore=0 clxscore=1015 cotscore=-2147483648
 adultscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080121
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/8/20 7:11 AM, Eelco Chaudron wrote:
> I'm trying for a while to do a fentry/fexit trace an EXT program
> attached to an XDP program. To make it easier to explain I've
> created a test case (see patch below) to show the issue.
>
> Without the changes to test_xdp_bpf2bpf.c I'll get the following error:
>
>    libbpf: -- BEGIN DUMP LOG ---
>    libbpf:
>    arg#0 type is not a struct
>    Unrecognized arg#0 type PTR
>    ; int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
>    0: (79) r6 = *(u64 *)(r1 +0)
>    invalid bpf_context access off=0 size=8
>    processed 1 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
>
>    libbpf: -- END LOG --
>    libbpf: failed to load program 'fentry/FUNC'
>    libbpf: failed to load object 'test_xdp_bpf2bpf'
>    libbpf: failed to load BPF skeleton 'test_xdp_bpf2bpf': -4007
>    test_xdp_fentry_ext:FAIL:__load ftrace skeleton failed
>    #91 xdp_fentry_ext:FAIL
>    Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
>
> With the change I get the following (but I do feel this change
> should not be needed):
>
>    libbpf: -- BEGIN DUMP LOG ---
>    libbpf:
>    Unrecognized arg#0 type PTR
>    ; int trace_on_entry(struct xdp_buff *xdp)
>    0: (bf) r6 = r1
>    ; void *data = (void *)(long)xdp->data;
>    1: (79) r1 = *(u64 *)(r6 +0)
>    invalid bpf_context access off=0 size=8
>    processed 2 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
>
>    libbpf: -- END LOG --
>    libbpf: failed to load program 'fentry/FUNC'
>    libbpf: failed to load object 'test_xdp_bpf2bpf'
>    libbpf: failed to load BPF skeleton 'test_xdp_bpf2bpf': -4007
>    test_xdp_fentry_ext:FAIL:__load ftrace skeleton failed
>    #91 xdp_fentry_ext:FAIL
>    Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
>
> Any idea what could be the case here? The same fentry/fexit attach
> code works fine in the xdp_bpf2bpf.c tests case.
>
>
> Cheers,
>
>
> Eelco
> ---
>   .../selftests/bpf/prog_tests/xdp_fentry_ext.c      |   95 ++++++++++++++++++++
>   1 file changed, 95 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_fentry_ext.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_fentry_ext.c b/tools/testing/selftests/bpf/prog_tests/xdp_fentry_ext.c
> new file mode 100644
> index 000000000000..68cd83fad632
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_fentry_ext.c
> @@ -0,0 +1,95 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +
> +#include "test_xdp_ext.skel.h"
> +#include "test_xdp_bpf2bpf.skel.h"
> +#include "xdp_dummy.skel.h"
> +
> +void test_xdp_fentry_ext(void)
> +{
> +        /* Using the skeleton framework does not work, as it does not like
> +         * like the prog_replace() function to be noinline
> +         */
> +
> +	__u32 duration = 0, retval, size;
> +        const char *file = "./test_xdp_ext.o";
> +        const char *ext_file = "./xdp_dummy.o";
> +        struct bpf_program *prog;
> +        struct bpf_program *ext_prog;
> +	struct bpf_object *xdp_obj, *ext_obj = NULL;
> +        struct test_xdp_bpf2bpf *ftrace_skel = NULL;
> +        int err, xdp_fd, ext_fd;
> +	char buf[128];
> +
> +        err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &xdp_obj, &xdp_fd);
> +	if (CHECK_FAIL(err))
> +		return;
> +
> +        /* Load the EXT program to attach to replace existing function */
> +        ext_obj = bpf_object__open_file(ext_file, NULL);
> +        if (CHECK(IS_ERR_OR_NULL(ext_obj), "obj_open",
> +                  "failed to open %s: %ld\n",
> +                  ext_file, PTR_ERR(ext_obj)))
> +                goto out;
> +
> +        ext_prog = bpf_object__find_program_by_title(ext_obj, "xdp_dummy");
> +        if (CHECK(!ext_prog, "find_prog", "xdp_dummy_prog not found\n"))
> +                goto out;
> +
> +        err = bpf_program__set_attach_target(ext_prog, xdp_fd, "prog_replace");
> +	if (CHECK(err, "set_attach", "err %d, errno %d\n", err, errno))
> +                goto out;
> +
> +        bpf_program__set_type(ext_prog, BPF_PROG_TYPE_EXT);
> +
> +        err = bpf_object__load(ext_obj);
> +	if (CHECK(err, "obj_load", "err %d\n", err))
> +		goto out;
> +
> +        bpf_program__attach_trace(ext_prog);
> +
> +        ext_fd = bpf_program__fd(ext_prog);
> +
> +        /* Now try to attach an fentry trace to the EXT program above */
> +
> +	ftrace_skel = test_xdp_bpf2bpf__open();
> +	if (CHECK(!ftrace_skel, "__open", "ftrace skeleton failed\n"))
> +		goto out;

I think this is not supported now. That is, you cannot attach a fentry trace

to the EXT program. The current implementation for fentry program simply

trying to find and match the signature of freplace program which by default

is a pointer to void.


It is doable in that in kernel we could recognize to-be-attached program is

a freplace and further trace down to find the real signature. The related

kernel function is btf_get_prog_ctx_type(). You can try to implement by 
yourself

or I can have a patch for this once bpf-next opens.


> +
> +        prog = ftrace_skel->progs.trace_on_entry;
> +	bpf_program__set_expected_attach_type(prog, BPF_TRACE_FENTRY);
> +	bpf_program__set_attach_target(prog, ext_fd, "xdp_dummy_prog");
> +
> +	prog = ftrace_skel->progs.trace_on_exit;
> +	bpf_program__set_expected_attach_type(prog, BPF_TRACE_FEXIT);
> +	bpf_program__set_attach_target(prog, ext_fd, "xdp_dummy_prog");
> +
> +	err = test_xdp_bpf2bpf__load(ftrace_skel);
> +	if (CHECK(err, "__load", "ftrace skeleton failed\n"))
> +		goto out;
> +
> +	err = test_xdp_bpf2bpf__attach(ftrace_skel);
> +	if (CHECK(err, "ftrace_attach", "ftrace attach failed: %d\n", err))
> +		goto out;
> +
> +
> +	/* Execute the xdp program by sending a dummy packet */
> +	err = bpf_prog_test_run(xdp_fd, 1, &pkt_v4, sizeof(pkt_v4),
> +				buf, &size, &retval, &duration);
> +
> +	if (CHECK(err || retval != XDP_PASS , "packet",
> +		  "err %d, errno %d, retval %d %c= %d\n",
> +                  err, errno, retval, retval != XDP_PASS ? '!' : '=', XDP_PASS))
> +		goto out;
> +
> +out:
> +	bpf_object__close(xdp_obj);
> +        if (ext_obj)
> +                bpf_object__close(ext_obj);
> +        if (ftrace_skel)
> +                test_xdp_bpf2bpf__destroy(ftrace_skel);
> +
> +}
> +
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> index a038e827f850..41b2a103c7ca 100644
> --- a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> @@ -42,7 +42,8 @@ struct {
>   
>   __u64 test_result_fentry = 0;
>   SEC("fentry/FUNC")
> -int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
> +//int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
> +int trace_on_entry(struct xdp_buff *xdp)
>   {
>   	struct meta meta;
>   	void *data_end = (void *)(long)xdp->data_end;
> @@ -61,7 +62,8 @@ int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
>   
>   __u64 test_result_fexit = 0;
>   SEC("fexit/FUNC")
> -int BPF_PROG(trace_on_exit, struct xdp_buff *xdp, int ret)
> +//int BPF_PROG(trace_on_exit, struct xdp_buff *xdp, int ret)
> +int trace_on_exit(struct xdp_buff *xdp, int ret)
>   {
>   	test_result_fexit = ret;
>   	return 0;
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_ext.c b/tools/testing/selftests/bpf/progs/test_xdp_ext.c
> new file mode 100644
> index 000000000000..37bd16c95b36
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_ext.c
> @@ -0,0 +1,21 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +__u64 xdp_ext_called = 0;
> +
> +__attribute__ ((noinline))
> +int prog_replace(struct xdp_md *ctx) {
> +        volatile int ret = XDP_ABORTED;
> +
> +        return ret;
> +}
> +
> +SEC("xdp_ext_call")
> +int xdp_ext_call_func(struct xdp_md *ctx)
> +{
> +
> +        return prog_replace(ctx);
> +}
> +
> +char _license[] SEC("license") = "GPL";
>
