Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BFF1A880E
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 19:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503114AbgDNR5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 13:57:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7636 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729303AbgDNR47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 13:56:59 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03EGxpQM022874;
        Tue, 14 Apr 2020 10:56:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=l6Baa8+Ah03FbqIImvhqNxfGWs6cBCO3ioiKgUD6Mcc=;
 b=Y1TQxJocCvdU/JHgkowY/TPBYuOlyLCQzfVORmh9+saj+ufnzN3AyrcE7KtdjaCfaJpn
 +4dQ5IcuduIrzvRaSwoKkFvl/VUSr32Xa5rJWObj9IHoJQE1Up8Y5IEVDHxbelPLHfpi
 h8MMrEqnrVOP879FzyrwmKzdXV6a43wXqgU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30bxnk39th-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Apr 2020 10:56:15 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 14 Apr 2020 10:56:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1I+nP6j8vRBG/h20aeKw4GSS5HX7FYfIYU/Qbu1o7w3O4ZIQ735tAElLUKQWiCfu2fRDQOWW9sAtryeodgWm4MuQbsWvSWRCh1sJQjs+5OupTGz6T4EXlvVhBjD6JsJ3LmqhrTBHNRNze91iw7Mbj23OKcK1MULXzz1nNCZ6fOnL0liXaw8jeDZxS5zorFVDvM2Du8MsSAi3btv5CrGuXVpJBE5BvNMfKex50bDMQsLRZmVBc7kqcj8viiNAVdL1qGf/JgSYMrOs//EBG6LSPykWsyDkZ25gKcxDjuNdQiD48CgM2sc0nLnbh7LMiWwDO/Fqd4YCGW+9bbEwSWJbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6Baa8+Ah03FbqIImvhqNxfGWs6cBCO3ioiKgUD6Mcc=;
 b=AgSvgbJUjZPwZPGM2MVfEzsjjV/QiNKoXKiFL3GuFmpZvI5T5Zl+X2tnToN0RPTBUpHodDF5oFDptk+RlX1YblkEQC5+Erntjs0Sasy41rp34g3Vxi3sN/cs6FKjZDJcnGYkrjmE6lnY9zX48n7K7MTCHM3zgm2+xniyYzZhygOmgNwbWwcGr3V7TVTLRpLDv8O9bqp/l9rYjKHqYLxCVN1cnHufhIpl/EGAP+C9MgBRd0Uc7tCQ1Jj7qaEQ4fMQVAo+kgRsib5RLhOZh9/2s5S3QjAqgqaGwhEvM08h/R8kZA6pTcfMngGQsRBiR1lVmLSL6SOZRGIl+FtK4k53jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6Baa8+Ah03FbqIImvhqNxfGWs6cBCO3ioiKgUD6Mcc=;
 b=KFowMwA08T7pjHWfn+cgJbJH6dgni1rU4wWhA8nlVu53j8REo8S7SMFpwb9GZhG98fOZmzqiPaI8YhB2SN+yzjobPi3RpnzJSxOqIHjT9g3mrVFRs1vOXLnkDKiDNItLB68gXi803FCrrv+lOU8pYDubuoIdOEtzqq13GmRZePM=
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2375.namprd15.prod.outlook.com (2603:10b6:a02:91::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Tue, 14 Apr
 2020 17:56:12 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 17:56:12 +0000
Date:   Tue, 14 Apr 2020 10:56:08 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: always specify expected_attach_type
 on program load if supported
Message-ID: <20200414175608.GB54710@rdna-mbp>
References: <20200414045613.2104756-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200414045613.2104756-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: MWHPR1201CA0013.namprd12.prod.outlook.com
 (2603:10b6:301:4a::23) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:895e) by MWHPR1201CA0013.namprd12.prod.outlook.com (2603:10b6:301:4a::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.20 via Frontend Transport; Tue, 14 Apr 2020 17:56:10 +0000
X-Originating-IP: [2620:10d:c090:400::5:895e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95925cec-fd1a-4dad-2321-08d7e09d1dbe
X-MS-TrafficTypeDiagnostic: BYAPR15MB2375:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB237533D73E24C4BD65A9F401A8DA0@BYAPR15MB2375.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(7916004)(366004)(346002)(376002)(396003)(39860400002)(136003)(316002)(16526019)(186003)(4326008)(6636002)(9686003)(6496006)(66946007)(33716001)(6862004)(66556008)(66476007)(52116002)(6486002)(5660300002)(478600001)(1076003)(33656002)(81156014)(8936002)(30864003)(86362001)(966005)(8676002)(2906002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vAIhtPupTzZEvvMPUkCGOD2DOUpAgYE+vfzmEGT8A90dzymzbwWeNE4U9a5yeSV3dBW6nypUaH/FTlloK9tioghDmQ0s0I7UIUNSUlZcvnJoheIBPOpCfjnYjyv9NGLCo4jKoNS4PbWsQKMoqQCQVpnPdu2z4f6q9CUGIr7fb1zROYJgK6Ob3nLd66rZPQ0vm6d47aLl13m3M96hBxYB8yxOKjXinaZujY+Yl5fJ6AMIceqLYjbucLxttWymhF+jQvtep05MC5i8TVcZ4fiS/mJcYxs1i9mxXBc2LyO+Z+28Nps141UItT9GyvRQTfAG7+HseeEGgGzBAY6VMtCh/WvGqu56E1ocOrnwCwx7dGH8AlnHxXusZcVLR2vjfEF6i9hHH74NrABuIZZACIRmhTa4OFnSUAQaPg4DAqPEKvLak2Hd1zbnZhFfRFCof6msTXJ8MATWT51anQJh3ZNViIvVaTKojJc4QPk51Qj2gkiyo585i6xdUHnZ64uaI27rcBCTIQjMIIyzQH6JfNoNfw==
X-MS-Exchange-AntiSpam-MessageData: 9fK4gHry+EkR/2FlAQWPjIWSW4oQfsbg0uQ7p/pTb7TQWj/ea/OGT9gkvV8BL93Z66kP4APqCUaGfFf9osaDU8rscMR+0njRHhryLubsi2wGsVAEpmV+EShPbc0JIbfHnKJK8VVOUgcGqTPg5ThQbrH0ivOLjHZA4lAGQ6VrqZEFAq8iewvYYacKv3DYYUn2
X-MS-Exchange-CrossTenant-Network-Message-Id: 95925cec-fd1a-4dad-2321-08d7e09d1dbe
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2020 17:56:11.8886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gTG3s68RenzXikLeMKUni2vqNKCmD02rDgOuKiwN8xZGiVdqp4/GAEcPlcDtROgB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2375
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-14_08:2020-04-14,2020-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004140131
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> [Mon, 2020-04-13 21:56 -0700]:
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
> v1->v2:
> - fixed prog_type/expected_attach_type combo (Andrey);
> - added comment explaining what we are doing in probe_exp_attach_type (Andrey).

Thanks for changes.

I built the patch (removing the double .sec Song mentioned since it
breaks compilation) and tested it: it fixes the problem with NET_XMIT_CN
on old kernels and works for me with cgroup skb on old kernels.

Thank you!

Acked-by: Andrey Ignatov <rdna@fb.com>

I guess we can deal with selftest separately in the original thread.

Also a question about bpf vs bpf-next: since this fixes real problem
with loading cgroup skb programs, should it go to bpf tree instead?


>  tools/lib/bpf/libbpf.c                        | 127 ++++++++++++------
>  .../selftests/bpf/prog_tests/section_names.c  |  42 +++---
>  2 files changed, 110 insertions(+), 59 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ff9174282a8c..c7393182e2ae 100644
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
> @@ -3315,6 +3334,37 @@ static int bpf_object__probe_array_mmap(struct bpf_object *obj)
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
> +	/* use any valid combination of program type and (optional)
> +	 * non-zero expected attach type (i.e., not a BPF_CGROUP_INET_INGRESS)
> +	 * to see if kernel supports expected_attach_type field for
> +	 * BPF_PROG_LOAD command
> +	 */
> +	attr.prog_type = BPF_PROG_TYPE_CGROUP_SOCK;
> +	attr.expected_attach_type = BPF_CGROUP_INET_SOCK_CREATE;
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
> @@ -3325,6 +3375,7 @@ bpf_object__probe_caps(struct bpf_object *obj)
>  		bpf_object__probe_btf_func_global,
>  		bpf_object__probe_btf_datasec,
>  		bpf_object__probe_array_mmap,
> +		bpf_object__probe_exp_attach_type,
>  	};
>  	int i, ret;
>  
> @@ -4861,7 +4912,12 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
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
>  	if (prog->caps->name)
>  		load_attr.name = prog->name;
>  	load_attr.insns = insns;
> @@ -5062,6 +5118,8 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
>  	return 0;
>  }
>  
> +static const struct bpf_sec_def *find_sec_def(const char *sec_name);
> +
>  static struct bpf_object *
>  __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
>  		   const struct bpf_object_open_opts *opts)
> @@ -5117,24 +5175,17 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
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
> @@ -6223,23 +6274,33 @@ void bpf_program__set_expected_attach_type(struct bpf_program *prog,
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
> @@ -6253,11 +6314,6 @@ void bpf_program__set_expected_attach_type(struct bpf_program *prog,
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
> @@ -6269,17 +6325,6 @@ static struct bpf_link *attach_trace(const struct bpf_sec_def *sec,
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
> @@ -6713,7 +6758,7 @@ int libbpf_attach_type_by_name(const char *name,
>  			continue;
>  		if (!section_defs[i].is_attachable)
>  			return -EINVAL;
> -		*attach_type = section_defs[i].attach_type;
> +		*attach_type = section_defs[i].expected_attach_type;
>  		return 0;
>  	}
>  	pr_debug("failed to guess attach type based on ELF section name '%s'\n", name);
> @@ -7542,7 +7587,6 @@ static struct bpf_link *attach_lsm(const struct bpf_sec_def *sec,
>  struct bpf_link *
>  bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
>  {
> -	const struct bpf_sec_def *sec_def;
>  	enum bpf_attach_type attach_type;
>  	char errmsg[STRERR_BUFSIZE];
>  	struct bpf_link *link;
> @@ -7561,11 +7605,6 @@ bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
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
