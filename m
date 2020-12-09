Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0E22D4E8B
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 00:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731731AbgLIXLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:11:16 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54560 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731632AbgLIXLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 18:11:06 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9N9MjF063309;
        Wed, 9 Dec 2020 23:10:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=HxUibRgEQchXyhuP7PtCuYUewCMkcKjkitD+LecbcUE=;
 b=MiopLcx0z4ZeFSfEa4DqEu3nfhaJqkB3oGYVkN3h+w0+wMQHbOv+2GYTecLoR74sYd2b
 V2NR8eaHMOnNPY5cXoWW/uupNQKglSK1nHr1Cw8ZZhtnRgXHch3bUYdFgHa1WZDMZwPT
 pm+vl9P3jTstB1NQJnLWmvOcw0HkUoKPlMvkLithV9vOox8R7a0hTF/IFtGt8V2G6ky3
 OEE9Vj8QjKJmQ1dwb3u2epB8od/vhXDdMbv+mxITBQipqbHfsRlzm+CnvS6Mr8hjzUsJ
 s+JxtqYRr5Yu6Y6j+qo3sIsT3NqD/W9PWS1syEEs0zT3JH3QkMZ1fRSdYnpp1F4wfMY/ vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 357yqc2wn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 23:10:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9N0Z20170796;
        Wed, 9 Dec 2020 23:08:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 358m40y9f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 23:08:10 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B9N8AEl031768;
        Wed, 9 Dec 2020 23:08:10 GMT
Received: from dhcp-10-175-171-125.vpn.oracle.com (/10.175.171.125)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 15:08:09 -0800
Date:   Wed, 9 Dec 2020 23:08:02 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Andrii Nakryiko <andrii@kernel.org>
cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com,
        Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: support module BTF for BPF_TYPE_ID_TARGET
 CO-RE relocation
In-Reply-To: <20201208235332.354826-1-andrii@kernel.org>
Message-ID: <alpine.LRH.2.23.451.2012092249520.26400@localhost>
References: <20201208235332.354826-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9830 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=30 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9830 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=30 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090159
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020, Andrii Nakryiko wrote:

> When Clang emits ldimm64 instruction for BPF_TYPE_ID_TARGET CO-RE relocation,
> put module BTF FD, containing target type, into upper 32 bits of imm64.
> 
> Because this FD is internal to libbpf, it's very cumbersome to test this in
> selftests. Manual testing was performed with debug log messages sprinkled
> across selftests and libbpf, confirming expected values are substituted.
> Better testing will be performed as part of the work adding module BTF types
> support to  bpf_snprintf_btf() helpers.
> 
> v1->v2:
>   - fix crash on failing to resolve target spec (Alan).
> 
> Cc: Alan Maguire <alan.maguire@oracle.com>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Thanks for this!

Can confirm the segmentation fault has gone away. I tested with the
veth_stats_rx program (though will switch to btf_test module later),
and I still see the issue with a local kind of fwd for veth_stats
leading to an inability to find the target kind in the module BTF:

libbpf: sec 'kprobe/veth_stats_rx': found 5 CO-RE relocations
libbpf: prog 'veth_stats_rx': relo #0: kind <target_type_id> (7), spec is 
[20] fwd veth_stats
libbpf: prog 'veth_stats_rx': relo #0: no matching targets found
libbpf: prog 'veth_stats_rx': relo #0: patched insn #3 (LDIMM64) imm64 20 
-> 0
libbpf: prog 'veth_stats_rx': relo #1: kind <target_type_id> (7), spec is 
[20] fwd veth_stats
libbpf: prog 'veth_stats_rx': relo #1: no matching targets found
libbpf: prog 'veth_stats_rx': relo #1: patched insn #5 (LDIMM64) imm64 20 
-> 0

Here's the same debug info with a patch on top of yours that loosens the 
constraints on kind matching such that a fwd local type will match a struct 
target type:

libbpf: prog 'veth_stats_rx': relo #0: kind <target_type_id> (7), spec is 
[20] fwd veth_stats
libbpf: CO-RE relocating [0] fwd veth_stats: found target candidate 
[91516] struct veth_stats in [veth]
libbpf: prog 'veth_stats_rx': relo #0: matching candidate #0 [91516] 
struct veth_stats
libbpf: prog 'veth_stats_rx': relo #0: patched insn #3 (LDIMM64) imm64 20 
-> 450971657596
libbpf: prog 'veth_stats_rx': relo #1: kind <target_type_id> (7), spec is 
[20] fwd veth_stats
libbpf: prog 'veth_stats_rx': relo #1: matching candidate #0 [91516] 
struct veth_stats
libbpf: prog 'veth_stats_rx': relo #1: patched insn #5 (LDIMM64) imm64 20 
-> 450971657596

Patch is below; if it makes sense to support loosening constraints on kind 
matching like this feel free to roll it into your patch or I can send a 
follow-up, whatever's easiest. Thanks!

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2fb9824..9ead5b3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4673,6 +4673,23 @@ static void bpf_core_free_cands(struct 
core_cand_list *ca
        free(cands);
 }
 
+/* module-specific structs may have relo kind set to fwd, so as
+ * well as handling exact matches, a fwd kind has to match
+ * a target struct kind.
+ */
+static bool kind_matches_target(const struct btf_type *local,
+                               const struct btf_type *target)
+{
+       __u8 local_kind = btf_kind(local);
+       __u8 target_kind = btf_kind(target);
+
+       if (local_kind == target_kind)
+               return true;
+       if (local_kind == BTF_KIND_FWD && target_kind == BTF_KIND_STRUCT)
+               return true;
+       return false;
+}
+
 static int bpf_core_add_cands(struct core_cand *local_cand,
                              size_t local_essent_len,
                              const struct btf *targ_btf,
@@ -4689,7 +4706,7 @@ static int bpf_core_add_cands(struct core_cand 
*local_cand
        n = btf__get_nr_types(targ_btf);
        for (i = targ_start_id; i <= n; i++) {
                t = btf__type_by_id(targ_btf, i);
-               if (btf_kind(t) != btf_kind(local_cand->t))
+               if (!kind_matches_target(local_cand->t, t))
                        continue;
 
                targ_name = btf__name_by_offset(targ_btf, t->name_off);
@@ -5057,7 +5074,7 @@ static int bpf_core_types_are_compat(const struct 
btf *loc
        /* caller made sure that names match (ignoring flavor suffix) */
        local_type = btf__type_by_id(local_btf, local_id);
        targ_type = btf__type_by_id(targ_btf, targ_id);
-       if (btf_kind(local_type) != btf_kind(targ_type))
+       if (!kind_matches_target(local_type, targ_type))
                return 0;
 
 recur:
@@ -5070,7 +5087,7 @@ static int bpf_core_types_are_compat(const struct 
btf *loc
        if (!local_type || !targ_type)
                return -EINVAL;
 
-       if (btf_kind(local_type) != btf_kind(targ_type))
+       if (!kind_matches_target(local_type, targ_type))
                return 0;
 
        switch (btf_kind(local_type)) {


