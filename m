Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD442D1691
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgLGQjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:39:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50546 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgLGQjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 11:39:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7GZjhp156507;
        Mon, 7 Dec 2020 16:38:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Zl7wnLsAuQMDXPBpikmS7ojclWYVd0LHdaJgI9tl6mA=;
 b=DSNSGgi0rPon65KwqMFnVFbj+t4zv8YnhBWYIAt2A79QwhZbBa1lpanMx1fpl6SGE1LI
 7mVRzY8XarjGUCbbmBsIQr7Pgr8j/rYu27noiSaCKeoYSsX7xmoygkPLwOmqrT0A22ga
 pfN7Tfsia4is5eEQUPgnoHdTqkbUmpZLnT6peySkCKtvJtDoef5GuaQSESH7q37pOJNt
 Ls/wfKh+Bm+1DkyscXMLXKx7K88eXusViOobdFjy+UgoFYU4i9RkAfKIlQJAejRIgnQK
 tGI0Dxp9QBX081r4LWLDK/wT9gusNoXqPwDEP7MygJud4M2ewupCqcKJYMxMkNolVwqU Zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35825kx9kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 07 Dec 2020 16:38:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B7GYjd4066131;
        Mon, 7 Dec 2020 16:38:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 358ksmdecv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Dec 2020 16:38:37 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B7GcaYO011997;
        Mon, 7 Dec 2020 16:38:36 GMT
Received: from dhcp-10-175-205-133.vpn.oracle.com (/10.175.205.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Dec 2020 08:38:35 -0800
Date:   Mon, 7 Dec 2020 16:38:16 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Andrii Nakryiko <andrii@kernel.org>
cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com,
        Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCH bpf-next] libbpf: support module BTF for BPF_TYPE_ID_TARGET
 CO-RE relocation
In-Reply-To: <20201205025140.443115-1-andrii@kernel.org>
Message-ID: <alpine.LRH.2.23.451.2012071623080.3652@localhost>
References: <20201205025140.443115-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=10
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=10 adultscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 mlxscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012070106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020, Andrii Nakryiko wrote:

> When Clang emits ldimm64 instruction for BPF_TYPE_ID_TARGET CO-RE relocation,
> put module BTF FD, containing target type, into upper 32 bits of imm64.
> 
> Because this FD is internal to libbpf, it's very cumbersome to test this in
> selftests. Manual testing was performed with debug log messages sprinkled
> across selftests and libbpf, confirming expected values are substituted.
> Better testing will be performed as part of the work adding module BTF types
> support to  bpf_snprintf_btf() helpers.
> 
> Cc: Alan Maguire <alan.maguire@oracle.com>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 9be88a90a4aa..539956f7920a 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4795,6 +4795,7 @@ static int load_module_btfs(struct bpf_object *obj)
>  
>  		mod_btf = &obj->btf_modules[obj->btf_module_cnt++];
>  
> +		btf__set_fd(btf, fd);
>  		mod_btf->btf = btf;
>  		mod_btf->id = id;
>  		mod_btf->fd = fd;
> @@ -5445,6 +5446,10 @@ struct bpf_core_relo_res
>  	__u32 orig_type_id;
>  	__u32 new_sz;
>  	__u32 new_type_id;
> +	/* FD of the module BTF containing the target candidate, or 0 for
> +	 * vmlinux BTF
> +	 */
> +	int btf_obj_fd;
>  };
>  
>  /* Calculate original and target relocation values, given local and target
> @@ -5469,6 +5474,7 @@ static int bpf_core_calc_relo(const struct bpf_program *prog,
>  	res->fail_memsz_adjust = false;
>  	res->orig_sz = res->new_sz = 0;
>  	res->orig_type_id = res->new_type_id = 0;
> +	res->btf_obj_fd = 0;
>  
>  	if (core_relo_is_field_based(relo->kind)) {
>  		err = bpf_core_calc_field_relo(prog, relo, local_spec,
> @@ -5519,6 +5525,9 @@ static int bpf_core_calc_relo(const struct bpf_program *prog,
>  	} else if (core_relo_is_type_based(relo->kind)) {
>  		err = bpf_core_calc_type_relo(relo, local_spec, &res->orig_val);
>  		err = err ?: bpf_core_calc_type_relo(relo, targ_spec, &res->new_val);
> +		if (!err && relo->kind == BPF_TYPE_ID_TARGET &&
> +		    targ_spec->btf != prog->obj->btf_vmlinux) 
> +			res->btf_obj_fd = btf__fd(targ_spec->btf);

Sorry about this Andrii, but I'm a bit stuck here.

I'm struggling to get tests working where the obj fd is used to designate
the module BTF. Unless I'm missing something there are a few problems:

- the fd association is removed by libbpf when the BPF program has loaded; 
the module fds are closed and the module BTF is discarded.  However even if 
that isn't done (and as you mentioned, we could hold onto BTF that is in 
use, and I commented out the code that does that to test) - there's 
another problem:
- I can't see a way to use the object fd value we set here later in BPF 
program context; btf_get_by_fd() returns -EBADF as the fd is associated 
with the module BTF in the test's process context, not necessarily in 
the context that the BPF program is running.  Would it be possible in this 
case to use object id? Or is there another way to handle the fd->module 
BTF association that we need to make in BPF program context that I'm 
missing?
- A more long-term issue; if we use fds to specify module BTFs and write 
the object fd into the program, we can pin the BPF program such that it 
outlives fds that refer to its associated BTF.  So unless we pinned the 
BTF too, any code that assumed the BTF fd-> module mapping was valid would 
start to break once the user-space side went away and the pinned program 
persisted. 

Maybe there are solutions to these problems that I'm missing of course, 
but for now I'm not sure how to get things working.

Thanks again for your help with this!

Alan
