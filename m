Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B721A6D28
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 22:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388307AbgDMUVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 16:21:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6158 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388255AbgDMUVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 16:21:50 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03DKBIAr021181;
        Mon, 13 Apr 2020 13:21:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=31VrgG47DXjwwxspSAw29AniQiJfH/2zoOk2Ufdx7sY=;
 b=o0tAYz4x62+yMczjczHk6LejXdACisPmYZvWi0g4Oyf9i0R6PaVTzT5QPC5l1NMvDFbJ
 o5CS030HdqPXmGPSWFYnIJKnEWueSDDl1uwqUTQyquczLw3E22zOqh3nzZ1QYTjAz0WY
 Yxg4PT02Ext1E/6CPxB/3B3KyTVDGRfe3kI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30bwwpem5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 13 Apr 2020 13:21:34 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 13 Apr 2020 13:21:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4+9jj4MqaLWQqzttpk7Xpl8PmFIjPwkJVnfizCTsNyvQXWc//YBeo+V++tLs2uHgNGv+75MLp6uXDaxu/S9A+b9k+Mub4RgzQd/iOxaDC5XDGnmCk2HpR+Absc54JZfQtEgFZl3lyoGXhpI6v/0VOGXbpkirRqOCjgkd0ZVvjIEurhYKarPNmBeeB1L34cbQHVB963Wr7+H5V/UUJNS5YKE8GKXy/5d4Ab87AW6eryPtjc6Ux2EKphB6QqjNHKwRn9An4UN2PMcTR8B3VLa3+Y+WJHaXukfNF0ifgVk2A3F7wMGBoOTGxnYz3aITakIcgLwu2eqowfzkAqh1m+O3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31VrgG47DXjwwxspSAw29AniQiJfH/2zoOk2Ufdx7sY=;
 b=EkWWEVYkKm7tSh/2kfwx5gNcbProUX9Oc31uUhgaa2bW/VCjbyMtTIn1T2fJconS8AZK5NIF4RUWIzMOuRs8bphiJv4gtc9hDIf30BDDfQvcMOAVnGFwtmPvzOQ8RccOwYpVSy0sATXvH8iIVwuxHPKJ91PXrmTF5MlZBv9MUX39jmUB/02knfWcWkVD62nP77b1b7dRBLjS2WdnvKZx5Of2sw4pY5bx+DHQt9rKHTnZ8smOVBsa20UkZj3JX1vFW7YdAM9Zqj82ZOhWapgm29mVc+NsDmIfcfsYplsk3P9xJLCTa+ZhK4HG4YAdzXou+LmBzWcEyfARPJHNRPBlLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31VrgG47DXjwwxspSAw29AniQiJfH/2zoOk2Ufdx7sY=;
 b=ZzzOsTU5+UFaIevMb3OlpwrjQOV+mC8HQFxzV5dfWyRtTpfQ/e0KCkEUMAB4ZYDKizyvgndvebqXsT4To0ifOksw+0O5PYkOBOZn0vV2idZfj0Ggl1T8jAVfmEDongGV5EKldZsjBRAgjslKvKb9UahUsDfKQbfNtBuqDGhY1XU=
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2200.namprd15.prod.outlook.com (2603:10b6:a02:89::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Mon, 13 Apr
 2020 20:21:29 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2900.028; Mon, 13 Apr 2020
 20:21:29 +0000
Date:   Mon, 13 Apr 2020 13:21:26 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: always specify expected_attach_type on
 program load if supported
Message-ID: <20200413202126.GA36960@rdna-mbp.dhcp.thefacebook.com>
References: <20200412055837.2883320-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200412055837.2883320-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: CO1PR15CA0095.namprd15.prod.outlook.com
 (2603:10b6:101:21::15) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:f8c7) by CO1PR15CA0095.namprd15.prod.outlook.com (2603:10b6:101:21::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Mon, 13 Apr 2020 20:21:28 +0000
X-Originating-IP: [2620:10d:c090:400::5:f8c7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fadd85e-a673-4c1b-6f9a-08d7dfe83f7d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2200:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2200E48EF88986DE7CF4E1B5A8DD0@BYAPR15MB2200.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 037291602B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(366004)(396003)(376002)(136003)(346002)(39860400002)(2906002)(86362001)(33656002)(30864003)(186003)(16526019)(1076003)(66946007)(66556008)(66476007)(52116002)(6862004)(8936002)(5660300002)(9686003)(8676002)(966005)(4326008)(6496006)(81156014)(6486002)(316002)(478600001)(6636002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ug+i+NkdXRnlLW/mhH3oRcniQVweVkjCw4wnI96f5Dh5/5TLNWd7hqtORSTBlg6EX7ldX4UAIx2WLGnVHo7fBHU52bi66JfgqT/GxqtZnMS8CPTXT5Mbu9kn8PiBFue0obKjc1IzT+AXOCestjDELnMeGkw0kiPhaOggrR8j7OFH/Y/nOMcmfA3WjK7oSSQE2Uyt0nSY0QWj0zWs3mkT2vySUdwmt6wfS07LsTmWGS4JtnTWUKczAu29KaJWGoAbbvGHIZunZtwvGLh9hfXt2eja2ipO8IKPdQsdIJr8PD3LPMLplnDX97bRANnMCzysUbFXXapA/rqCeCchzjbT2LkRHVE1TOCuZ90dyDvbtAYQghZ4mSwJGioG6shxxusBJMo8ectM7c25zjvRtFTRfcuXV0kIw/pct3pmUkO+SJ7yg/Q1a6Q1m9Hbt7qR0IoXcR5ZnL6VD9q+0NVc+uj0dy3b3Bwl1dcEDAzz8e1Aej47Is3sdUOlfldY9rJaJJCa6CNhDC/YIs3iG+Orw2ivAw==
X-MS-Exchange-AntiSpam-MessageData: yAcg6f2AcJJvaeLNNnE07C5akFWYD32iyHu94FIuphaHoq26avEkRkMlWQsvkigBqFyqLtWkhmpW5yc40Ejiy3VeAZUbCPayJzJV0FNY9qJsLxNPhreZ1g4JFauiHHn9+deHqoabXdaobcC2Mw7aPgfErnvKTP0PnKO7mGQQ0lT8AHDUsJH6eNmgPhAB1k3j
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fadd85e-a673-4c1b-6f9a-08d7dfe83f7d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2020 20:21:29.6780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uyfEhZmSvJVcOIlRVn4b58d99/sJbzwqt1ygWGaE0qY8LK9XhtvkEXi6RzeJiYFh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2200
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-13_09:2020-04-13,2020-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 adultscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> [Sat, 2020-04-11 22:58 -0700]:
> For some types of BPF programs that utilize expected_attach_type, libbpf won't
> set load_attr.expected_attach_type, even if expected_attach_type is known from
> section definition. This was done to preserve backwards compatibility with old
> kernels that didn't recognize expected_attach_type attribute yet (which was
> added in 5e43f899b03a ("bpf: Check attach type at prog load time"). But this
> is problematic for some BPF programs that utilize never features that require
> kernel to know specific expected_attach_type (e.g., extended set of return
> codes for cgroup_skb/egress programs).
> 
> This patch makes libbpf specify expected_attach_type by default, but also
> detect support for this field in kernel and not set it during program load.
> This allows to have a good metadata for bpf_program
> (e.g., bpf_program__get_extected_attach_type()), but still work with old
> kernels (for cases where it can work at all).
> 
> Additionally, due to expected_attach_type being always set for recognized
> program types, bpf_program__attach_cgroup doesn't have to do extra checks to
> determine correct attach type, so remove that additional logic.
> 
> Also adjust section_names selftest to account for this change.
> 
> More detailed discussion can be found in [0].
> 
>   [0] https://lore.kernel.org/bpf/20200412003604.GA15986@rdna-mbp.dhcp.thefacebook.com/
> 
> Reported-by: Andrey Ignatov <rdna@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c                        | 123 +++++++++++-------
>  .../selftests/bpf/prog_tests/section_names.c  |  42 +++---
>  2 files changed, 106 insertions(+), 59 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ff9174282a8c..925f720deea0 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -178,6 +178,8 @@ struct bpf_capabilities {
>  	__u32 array_mmap:1;
>  	/* BTF_FUNC_GLOBAL is supported */
>  	__u32 btf_func_global:1;
> +	/* kernel support for expected_attach_type in BPF_PROG_LOAD */
> +	__u32 exp_attach_type:1;
>  };
>  
>  enum reloc_type {
> @@ -194,6 +196,22 @@ struct reloc_desc {
>  	int sym_off;
>  };
>  
> +struct bpf_sec_def;
> +
> +typedef struct bpf_link *(*attach_fn_t)(const struct bpf_sec_def *sec,
> +					struct bpf_program *prog);
> +
> +struct bpf_sec_def {
> +	const char *sec;
> +	size_t len;
> +	enum bpf_prog_type prog_type;
> +	enum bpf_attach_type expected_attach_type;
> +	bool is_exp_attach_type_optional;
> +	bool is_attachable;
> +	bool is_attach_btf;
> +	attach_fn_t attach_fn;
> +};
> +
>  /*
>   * bpf_prog should be a better name but it has been used in
>   * linux/filter.h.
> @@ -204,6 +222,7 @@ struct bpf_program {
>  	char *name;
>  	int prog_ifindex;
>  	char *section_name;
> +	const struct bpf_sec_def *sec_def;
>  	/* section_name with / replaced by _; makes recursive pinning
>  	 * in bpf_object__pin_programs easier
>  	 */
> @@ -3315,6 +3334,32 @@ static int bpf_object__probe_array_mmap(struct bpf_object *obj)
>  	return 0;
>  }
>  
> +static int
> +bpf_object__probe_exp_attach_type(struct bpf_object *obj)
> +{
> +	struct bpf_load_program_attr attr;
> +	struct bpf_insn insns[] = {
> +		BPF_MOV64_IMM(BPF_REG_0, 0),
> +		BPF_EXIT_INSN(),
> +	};
> +	int fd;
> +
> +	memset(&attr, 0, sizeof(attr));
> +	attr.prog_type = BPF_PROG_TYPE_CGROUP_SOCK;
> +	attr.expected_attach_type = BPF_CGROUP_INET_EGRESS;

Could you clarify semantics of this function please?

According to the name it looks like it should check whether
expected_attach_type attribute is supported or not. But
BPF_CGROUP_INET_EGRESS doesn't align with this since
expected_attach_type itself was added long before it was supported for
BPF_CGROUP_INET_EGRESS.

For example 4fbac77d2d09 ("bpf: Hooks for sys_bind") added in Mar 2018 is
the first hook ever that used expected_attach_type.

aac3fc320d94 ("bpf: Post-hooks for sys_bind") added a bit later is the
first hook that made expected_attach_type optional (for
BPF_CGROUP_INET_SOCK_CREATE).

But 5cf1e9145630 ("bpf: cgroup inet skb programs can return 0 to 3") for
BPF_CGROUP_INET_EGRESS was merged more than a year after the previous
two. 

> +	attr.insns = insns;
> +	attr.insns_cnt = ARRAY_SIZE(insns);
> +	attr.license = "GPL";
> +
> +	fd = bpf_load_program_xattr(&attr, NULL, 0);
> +	if (fd >= 0) {
> +		obj->caps.exp_attach_type = 1;
> +		close(fd);
> +		return 1;
> +	}
> +	return 0;
> +}
> +
>  static int
>  bpf_object__probe_caps(struct bpf_object *obj)
>  {
> @@ -3325,6 +3370,7 @@ bpf_object__probe_caps(struct bpf_object *obj)
>  		bpf_object__probe_btf_func_global,
>  		bpf_object__probe_btf_datasec,
>  		bpf_object__probe_array_mmap,
> +		bpf_object__probe_exp_attach_type,
>  	};
>  	int i, ret;
>  
> @@ -4861,7 +4907,13 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
>  
>  	memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
>  	load_attr.prog_type = prog->type;
> -	load_attr.expected_attach_type = prog->expected_attach_type;
> +	/* old kernels might not support specifying expected_attach_type */
> +	if (!prog->caps->exp_attach_type && prog->sec_def &&
> +	    prog->sec_def->is_exp_attach_type_optional)
> +		load_attr.expected_attach_type = 0;
> +	else
> +		load_attr.expected_attach_type = prog->expected_attach_type;

I'm having a hard time checking whether it'll work for all cases or may
not work for some combination of prog/attach type and kernel version
since there are many subtleties.

For example BPF_PROG_TYPE_CGROUP_SOCK has both a hook where
expected_attach_type is optional (BPF_CGROUP_INET_SOCK_CREATE) and hooks
where it's required (BPF_CGROUP_INET{4,6}_POST_BIND), and there
bpf_prog_load_fixup_attach_type() function in always sets
expected_attach_type if it's not yet.

But I don't have context on all hooks that can be affected by this
change and could easily miss something.

Ideally it should be verified by tests. Current section_names.c test
only verifies what will be returned, but AFAIK there is no test that
checks whether provided combination of prog_type/expected_attach_type at
load time and attach_type at attach time would actually work both on
current and old kernels. Do you think it's possible to add such a
selftest? (current libbpf CI supports running on old kernels, doesn't
it?)


> +	pr_warn("prog %s exp_Attach %d\n", prog->name, load_attr.expected_attach_type);
>  	if (prog->caps->name)
>  		load_attr.name = prog->name;
>  	load_attr.insns = insns;
> @@ -5062,6 +5114,8 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
>  	return 0;
>  }
>  
> +static const struct bpf_sec_def *find_sec_def(const char *sec_name);
> +
>  static struct bpf_object *
>  __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
>  		   const struct bpf_object_open_opts *opts)
> @@ -5117,24 +5171,17 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
>  	bpf_object__elf_finish(obj);
>  
>  	bpf_object__for_each_program(prog, obj) {
> -		enum bpf_prog_type prog_type;
> -		enum bpf_attach_type attach_type;
> -
> -		if (prog->type != BPF_PROG_TYPE_UNSPEC)
> -			continue;
> -
> -		err = libbpf_prog_type_by_name(prog->section_name, &prog_type,
> -					       &attach_type);
> -		if (err == -ESRCH)
> +		prog->sec_def = find_sec_def(prog->section_name);
> +		if (!prog->sec_def)
>  			/* couldn't guess, but user might manually specify */
>  			continue;
> -		if (err)
> -			goto out;
>  
> -		bpf_program__set_type(prog, prog_type);
> -		bpf_program__set_expected_attach_type(prog, attach_type);
> -		if (prog_type == BPF_PROG_TYPE_TRACING ||
> -		    prog_type == BPF_PROG_TYPE_EXT)
> +		bpf_program__set_type(prog, prog->sec_def->prog_type);
> +		bpf_program__set_expected_attach_type(prog,
> +				prog->sec_def->expected_attach_type);
> +
> +		if (prog->sec_def->prog_type == BPF_PROG_TYPE_TRACING ||
> +		    prog->sec_def->prog_type == BPF_PROG_TYPE_EXT)
>  			prog->attach_prog_fd = OPTS_GET(opts, attach_prog_fd, 0);
>  	}
>  
> @@ -6223,23 +6270,33 @@ void bpf_program__set_expected_attach_type(struct bpf_program *prog,
>  	prog->expected_attach_type = type;
>  }
>  
> -#define BPF_PROG_SEC_IMPL(string, ptype, eatype, is_attachable, btf, atype) \
> -	{ string, sizeof(string) - 1, ptype, eatype, is_attachable, btf, atype }
> +#define BPF_PROG_SEC_IMPL(string, ptype, eatype, eatype_optional,	    \
> +			  attachable, attach_btf)			    \
> +	{								    \
> +		.sec = string,						    \
> +		.len = sizeof(string) - 1,				    \
> +		.prog_type = ptype,					    \
> +		.sec = string,						    \
> +		.expected_attach_type = eatype,				    \
> +		.is_exp_attach_type_optional = eatype_optional,		    \
> +		.is_attachable = attachable,				    \
> +		.is_attach_btf = attach_btf,				    \
> +	}
>  
>  /* Programs that can NOT be attached. */
>  #define BPF_PROG_SEC(string, ptype) BPF_PROG_SEC_IMPL(string, ptype, 0, 0, 0, 0)
>  
>  /* Programs that can be attached. */
>  #define BPF_APROG_SEC(string, ptype, atype) \
> -	BPF_PROG_SEC_IMPL(string, ptype, 0, 1, 0, atype)
> +	BPF_PROG_SEC_IMPL(string, ptype, atype, true, 1, 0)
>  
>  /* Programs that must specify expected attach type at load time. */
>  #define BPF_EAPROG_SEC(string, ptype, eatype) \
> -	BPF_PROG_SEC_IMPL(string, ptype, eatype, 1, 0, eatype)
> +	BPF_PROG_SEC_IMPL(string, ptype, eatype, false, 1, 0)
>  
>  /* Programs that use BTF to identify attach point */
>  #define BPF_PROG_BTF(string, ptype, eatype) \
> -	BPF_PROG_SEC_IMPL(string, ptype, eatype, 0, 1, 0)
> +	BPF_PROG_SEC_IMPL(string, ptype, eatype, false, 0, 1)
>  
>  /* Programs that can be attached but attach type can't be identified by section
>   * name. Kept for backward compatibility.
> @@ -6253,11 +6310,6 @@ void bpf_program__set_expected_attach_type(struct bpf_program *prog,
>  	__VA_ARGS__							    \
>  }
>  
> -struct bpf_sec_def;
> -
> -typedef struct bpf_link *(*attach_fn_t)(const struct bpf_sec_def *sec,
> -					struct bpf_program *prog);
> -
>  static struct bpf_link *attach_kprobe(const struct bpf_sec_def *sec,
>  				      struct bpf_program *prog);
>  static struct bpf_link *attach_tp(const struct bpf_sec_def *sec,
> @@ -6269,17 +6321,6 @@ static struct bpf_link *attach_trace(const struct bpf_sec_def *sec,
>  static struct bpf_link *attach_lsm(const struct bpf_sec_def *sec,
>  				   struct bpf_program *prog);
>  
> -struct bpf_sec_def {
> -	const char *sec;
> -	size_t len;
> -	enum bpf_prog_type prog_type;
> -	enum bpf_attach_type expected_attach_type;
> -	bool is_attachable;
> -	bool is_attach_btf;
> -	enum bpf_attach_type attach_type;
> -	attach_fn_t attach_fn;
> -};
> -
>  static const struct bpf_sec_def section_defs[] = {
>  	BPF_PROG_SEC("socket",			BPF_PROG_TYPE_SOCKET_FILTER),
>  	BPF_PROG_SEC("sk_reuseport",		BPF_PROG_TYPE_SK_REUSEPORT),
> @@ -6713,7 +6754,7 @@ int libbpf_attach_type_by_name(const char *name,
>  			continue;
>  		if (!section_defs[i].is_attachable)
>  			return -EINVAL;
> -		*attach_type = section_defs[i].attach_type;
> +		*attach_type = section_defs[i].expected_attach_type;
>  		return 0;
>  	}
>  	pr_debug("failed to guess attach type based on ELF section name '%s'\n", name);
> @@ -7542,7 +7583,6 @@ static struct bpf_link *attach_lsm(const struct bpf_sec_def *sec,
>  struct bpf_link *
>  bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
>  {
> -	const struct bpf_sec_def *sec_def;
>  	enum bpf_attach_type attach_type;
>  	char errmsg[STRERR_BUFSIZE];
>  	struct bpf_link *link;
> @@ -7561,11 +7601,6 @@ bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
>  	link->detach = &bpf_link__detach_fd;
>  
>  	attach_type = bpf_program__get_expected_attach_type(prog);
> -	if (!attach_type) {
> -		sec_def = find_sec_def(bpf_program__title(prog, false));
> -		if (sec_def)
> -			attach_type = sec_def->attach_type;
> -	}
>  	link_fd = bpf_link_create(prog_fd, cgroup_fd, attach_type, NULL);
>  	if (link_fd < 0) {
>  		link_fd = -errno;
> diff --git a/tools/testing/selftests/bpf/prog_tests/section_names.c b/tools/testing/selftests/bpf/prog_tests/section_names.c
> index 9d9351dc2ded..713167449c98 100644
> --- a/tools/testing/selftests/bpf/prog_tests/section_names.c
> +++ b/tools/testing/selftests/bpf/prog_tests/section_names.c
> @@ -43,18 +43,18 @@ static struct sec_name_test tests[] = {
>  	{"lwt_seg6local", {0, BPF_PROG_TYPE_LWT_SEG6LOCAL, 0}, {-EINVAL, 0} },
>  	{
>  		"cgroup_skb/ingress",
> -		{0, BPF_PROG_TYPE_CGROUP_SKB, 0},
> +		{0, BPF_PROG_TYPE_CGROUP_SKB, BPF_CGROUP_INET_INGRESS},
>  		{0, BPF_CGROUP_INET_INGRESS},
>  	},
>  	{
>  		"cgroup_skb/egress",
> -		{0, BPF_PROG_TYPE_CGROUP_SKB, 0},
> +		{0, BPF_PROG_TYPE_CGROUP_SKB, BPF_CGROUP_INET_EGRESS},
>  		{0, BPF_CGROUP_INET_EGRESS},
>  	},
>  	{"cgroup/skb", {0, BPF_PROG_TYPE_CGROUP_SKB, 0}, {-EINVAL, 0} },
>  	{
>  		"cgroup/sock",
> -		{0, BPF_PROG_TYPE_CGROUP_SOCK, 0},
> +		{0, BPF_PROG_TYPE_CGROUP_SOCK, BPF_CGROUP_INET_SOCK_CREATE},
>  		{0, BPF_CGROUP_INET_SOCK_CREATE},
>  	},
>  	{
> @@ -69,26 +69,38 @@ static struct sec_name_test tests[] = {
>  	},
>  	{
>  		"cgroup/dev",
> -		{0, BPF_PROG_TYPE_CGROUP_DEVICE, 0},
> +		{0, BPF_PROG_TYPE_CGROUP_DEVICE, BPF_CGROUP_DEVICE},
>  		{0, BPF_CGROUP_DEVICE},
>  	},
> -	{"sockops", {0, BPF_PROG_TYPE_SOCK_OPS, 0}, {0, BPF_CGROUP_SOCK_OPS} },
> +	{
> +		"sockops",
> +		{0, BPF_PROG_TYPE_SOCK_OPS, BPF_CGROUP_SOCK_OPS},
> +		{0, BPF_CGROUP_SOCK_OPS},
> +	},
>  	{
>  		"sk_skb/stream_parser",
> -		{0, BPF_PROG_TYPE_SK_SKB, 0},
> +		{0, BPF_PROG_TYPE_SK_SKB, BPF_SK_SKB_STREAM_PARSER},
>  		{0, BPF_SK_SKB_STREAM_PARSER},
>  	},
>  	{
>  		"sk_skb/stream_verdict",
> -		{0, BPF_PROG_TYPE_SK_SKB, 0},
> +		{0, BPF_PROG_TYPE_SK_SKB, BPF_SK_SKB_STREAM_VERDICT},
>  		{0, BPF_SK_SKB_STREAM_VERDICT},
>  	},
>  	{"sk_skb", {0, BPF_PROG_TYPE_SK_SKB, 0}, {-EINVAL, 0} },
> -	{"sk_msg", {0, BPF_PROG_TYPE_SK_MSG, 0}, {0, BPF_SK_MSG_VERDICT} },
> -	{"lirc_mode2", {0, BPF_PROG_TYPE_LIRC_MODE2, 0}, {0, BPF_LIRC_MODE2} },
> +	{
> +		"sk_msg",
> +		{0, BPF_PROG_TYPE_SK_MSG, BPF_SK_MSG_VERDICT},
> +		{0, BPF_SK_MSG_VERDICT},
> +	},
> +	{
> +		"lirc_mode2",
> +		{0, BPF_PROG_TYPE_LIRC_MODE2, BPF_LIRC_MODE2},
> +		{0, BPF_LIRC_MODE2},
> +	},
>  	{
>  		"flow_dissector",
> -		{0, BPF_PROG_TYPE_FLOW_DISSECTOR, 0},
> +		{0, BPF_PROG_TYPE_FLOW_DISSECTOR, BPF_FLOW_DISSECTOR},
>  		{0, BPF_FLOW_DISSECTOR},
>  	},
>  	{
> @@ -158,17 +170,17 @@ static void test_prog_type_by_name(const struct sec_name_test *test)
>  				      &expected_attach_type);
>  
>  	CHECK(rc != test->expected_load.rc, "check_code",
> -	      "prog: unexpected rc=%d for %s", rc, test->sec_name);
> +	      "prog: unexpected rc=%d for %s\n", rc, test->sec_name);
>  
>  	if (rc)
>  		return;
>  
>  	CHECK(prog_type != test->expected_load.prog_type, "check_prog_type",
> -	      "prog: unexpected prog_type=%d for %s",
> +	      "prog: unexpected prog_type=%d for %s\n",
>  	      prog_type, test->sec_name);
>  
>  	CHECK(expected_attach_type != test->expected_load.expected_attach_type,
> -	      "check_attach_type", "prog: unexpected expected_attach_type=%d for %s",
> +	      "check_attach_type", "prog: unexpected expected_attach_type=%d for %s\n",
>  	      expected_attach_type, test->sec_name);
>  }
>  
> @@ -180,13 +192,13 @@ static void test_attach_type_by_name(const struct sec_name_test *test)
>  	rc = libbpf_attach_type_by_name(test->sec_name, &attach_type);
>  
>  	CHECK(rc != test->expected_attach.rc, "check_ret",
> -	      "attach: unexpected rc=%d for %s", rc, test->sec_name);
> +	      "attach: unexpected rc=%d for %s\n", rc, test->sec_name);
>  
>  	if (rc)
>  		return;
>  
>  	CHECK(attach_type != test->expected_attach.attach_type,
> -	      "check_attach_type", "attach: unexpected attach_type=%d for %s",
> +	      "check_attach_type", "attach: unexpected attach_type=%d for %s\n",
>  	      attach_type, test->sec_name);
>  }
>  
> -- 
> 2.24.1
> 

-- 
Andrey Ignatov
