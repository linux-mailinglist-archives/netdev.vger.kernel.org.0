Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE272CFFFD
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 01:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgLFAi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 19:38:56 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38406 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgLFAiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 19:38:55 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B60TvrW028436;
        Sun, 6 Dec 2020 00:37:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=LqBKQkLNKs4imPGUtdOUEhFW+pH2I13+BviODiy3QWs=;
 b=R/HfatUUSuy/CbshJVKoCicRazSFAPfrh2ayRzHj+y+QmjQ7idX9hOLaX9RFNBtYC5me
 DfJbJgf5tbsEEHqiqM62rjw8l+/n5lPnnOKfhkg1Wq1+5ny3X7trgSCYtJPxHJL7l0PD
 frYLKhyKB21Z8aZ9KUWMrZcE9Z/ldRJv1oqUNEufOBOFNi/w4TUB2r32WfVpEj9brhn6
 I3AyNhy9lrLqt0vHBCe4r83dlONO3wQuv+NWKidC4T4OdVX0PcfhZrLjf0JyoyEh5Zo8
 l3rRb+Zr8j9nCTwyGb+JoxFAIxyeppYBRzMuRTj7btb+IBeaDqW9qTmpu/zPxK+bQEiE FA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3581mqhgrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 00:37:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B60aTjh068039;
        Sun, 6 Dec 2020 00:37:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 358kyp1a9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 00:37:59 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B60bvh3025883;
        Sun, 6 Dec 2020 00:37:57 GMT
Received: from dhcp-10-175-160-212.vpn.oracle.com (/10.175.160.212)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 05 Dec 2020 16:37:56 -0800
Date:   Sun, 6 Dec 2020 00:37:49 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Andrii Nakryiko <andrii@kernel.org>
cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com,
        Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCH bpf-next] libbpf: support module BTF for BPF_TYPE_ID_TARGET
 CO-RE relocation
In-Reply-To: <20201205025140.443115-1-andrii@kernel.org>
Message-ID: <alpine.LRH.2.23.451.2012060025520.1505@localhost>
References: <20201205025140.443115-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9826 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=30 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9826 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=30 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060002
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

Thanks so much for doing this Andrii! When I tested, I ran into a problem;
it turns out when a module struct such as "veth_stats" is used, it's
classified as BTF_KIND_FWD, and as a result when we iterate over
the modules and look in the veth module, "struct veth_stats" does not
match since its module kind (BTF_KIND_STRUCT) does not match the candidate
kind (BTF_KIND_FWD). I'm kind of out of my depth here, but the below
patch (on top of your patch) worked.  However without it - when we find
0  candidate matches - as well as not substituting the module object 
id/type id - we hit a segfault:

Program terminated with signal 11, Segmentation fault.
#0  0x0000000000480bf9 in bpf_core_calc_relo (prog=0x4d6ba40, 
relo=0x4d70e7c, 
    relo_idx=0, local_spec=0x7ffe2cf17b00, targ_spec=0x0, 
res=0x7ffe2cf17ae0)
    at libbpf.c:4408
4408		switch (kind) {
Missing separate debuginfos, use: debuginfo-install 
elfutils-libelf-0.172-2.el7.x86_64 glibc-2.17-196.el7.x86_64 
libattr-2.4.46-13.el7.x86_64 libcap-2.22-9.el7.x86_64 
libgcc-4.8.5-36.0.1.el7_6.2.x86_64 zlib-1.2.7-18.el7.x86_64
(gdb) bt
#0  0x0000000000480bf9 in bpf_core_calc_relo (prog=0x4d6ba40, 
relo=0x4d70e7c, 
    relo_idx=0, local_spec=0x7ffe2cf17b00, targ_spec=0x0, 
res=0x7ffe2cf17ae0)
    at libbpf.c:4408
 

The dereferences of targ_spec in bpf_core_recalc_relo() seem
to be the cause; that function is called with a NULL targ_spec
when 0 candidates are found, so it's possible we'd need to
guard those accesses for cases where a bogus type was passed
in and no candidates were found.  If the below looks good would
it make sense to roll it into your patch or will I add it to my
v3 patch series?

Thanks again for your help with this!

Alan

From 08040730dbff6c5d7636927777ac85a71c10827f Mon Sep 17 00:00:00 2001
From: Alan Maguire <alan.maguire@oracle.com>
Date: Sun, 6 Dec 2020 01:10:28 +0100
Subject: [PATCH] libbpf: handle fwd kinds when checking candidate relocations
 for modules

when a struct belonging to a module is being assessed, it will be
designated a fwd kind (BTF_KIND_FWD); when matching candidate
types constraints on exact type matching need to be relaxed to
ensure that such structures are found successfully.  Introduce
kinds_match() function to handle this comparison.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/libbpf.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 539956f..00fdb30 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4673,6 +4673,24 @@ static void bpf_core_free_cands(struct core_cand_list *cands)
 	free(cands);
 }
 
+/* module-specific structs will have relo kind set to fwd, so as
+ * well as handling exact matches, struct has to match fwd kind.
+ */
+static bool kinds_match(const struct btf_type *type1,
+			const struct btf_type *type2)
+{
+	__u8 kind1 = btf_kind(type1);
+	__u8 kind2 = btf_kind(type2);
+
+	if (kind1 == kind2)
+		return true;
+	if (kind1 == BTF_KIND_STRUCT && kind2 == BTF_KIND_FWD)
+		return true;
+	if (kind1 == BTF_KIND_FWD && kind2 == BTF_KIND_STRUCT)
+		return true;
+	return false;
+}
+
 static int bpf_core_add_cands(struct core_cand *local_cand,
 			      size_t local_essent_len,
 			      const struct btf *targ_btf,
@@ -4689,7 +4707,7 @@ static int bpf_core_add_cands(struct core_cand *local_cand,
 	n = btf__get_nr_types(targ_btf);
 	for (i = targ_start_id; i <= n; i++) {
 		t = btf__type_by_id(targ_btf, i);
-		if (btf_kind(t) != btf_kind(local_cand->t))
+		if (!kinds_match(t, local_cand->t))
 			continue;
 
 		targ_name = btf__name_by_offset(targ_btf, t->name_off);
@@ -5057,7 +5075,7 @@ static int bpf_core_types_are_compat(const struct btf *local_btf, __u32 local_id
 	/* caller made sure that names match (ignoring flavor suffix) */
 	local_type = btf__type_by_id(local_btf, local_id);
 	targ_type = btf__type_by_id(targ_btf, targ_id);
-	if (btf_kind(local_type) != btf_kind(targ_type))
+	if (!kinds_match(local_type, targ_type))
 		return 0;
 
 recur:
@@ -5070,7 +5088,7 @@ static int bpf_core_types_are_compat(const struct btf *local_btf, __u32 local_id
 	if (!local_type || !targ_type)
 		return -EINVAL;
 
-	if (btf_kind(local_type) != btf_kind(targ_type))
+	if (!kinds_match(local_type, targ_type))
 		return 0;
 
 	switch (btf_kind(local_type)) {
-- 
1.8.3.1


