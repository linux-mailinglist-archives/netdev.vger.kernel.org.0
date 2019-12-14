Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34D9611EF9F
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 02:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfLNBnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 20:43:53 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8698 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726741AbfLNBnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 20:43:53 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBE1hGVw003426
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:43:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=1hn1EI+djU+mG11slgWUsClC+42tvoqhUcinqneecEQ=;
 b=U17JFWjfrzDAkUpJFWooeyQAQuRpwfxYie/O/deSj8oCIVli5ni3+cqyw3ChwZLBR8Gr
 jtYJTDaa6rOhSy5V7vGbeMNWL3aAjHozxO+tY7JpXuW3tJFiMZDSwKKQQFOlsFtb3Xx7
 tJIbQLMLvpVnGfsW6ViOsPVo7zoTy9l81Gc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2wvfg8ss0p-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:43:51 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 17:43:50 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 5D47E2EC1D51; Fri, 13 Dec 2019 17:43:50 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 03/17] libbpf: move non-public APIs from libbpf.h to libbpf_internal.h
Date:   Fri, 13 Dec 2019 17:43:27 -0800
Message-ID: <20191214014341.3442258-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191214014341.3442258-1-andriin@fb.com>
References: <20191214014341.3442258-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 suspectscore=8 mlxscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912140007
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few libbpf APIs are not public but currently exposed through libbpf.h to be
used by bpftool. Move them to libbpf_internal.h, where intent of being
non-stable and non-public is much more obvious.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/net.c         |  1 +
 tools/lib/bpf/libbpf.h          | 17 -----------------
 tools/lib/bpf/libbpf_internal.h | 17 +++++++++++++++++
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 4f52d3151616..d93bee298e54 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -18,6 +18,7 @@
 
 #include <bpf.h>
 #include <nlattr.h>
+#include "libbpf_internal.h"
 #include "main.h"
 #include "netlink_dumper.h"
 
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 804f445c9957..2698fbcb0c79 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -126,11 +126,6 @@ bpf_object__open_buffer(const void *obj_buf, size_t obj_buf_sz,
 LIBBPF_API struct bpf_object *
 bpf_object__open_xattr(struct bpf_object_open_attr *attr);
 
-int bpf_object__section_size(const struct bpf_object *obj, const char *name,
-			     __u32 *size);
-int bpf_object__variable_offset(const struct bpf_object *obj, const char *name,
-				__u32 *off);
-
 enum libbpf_pin_type {
 	LIBBPF_PIN_NONE,
 	/* PIN_BY_NAME: pin maps by name (in /sys/fs/bpf by default) */
@@ -514,18 +509,6 @@ bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
 			   void **copy_mem, size_t *copy_size,
 			   bpf_perf_event_print_t fn, void *private_data);
 
-struct nlattr;
-typedef int (*libbpf_dump_nlmsg_t)(void *cookie, void *msg, struct nlattr **tb);
-int libbpf_netlink_open(unsigned int *nl_pid);
-int libbpf_nl_get_link(int sock, unsigned int nl_pid,
-		       libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie);
-int libbpf_nl_get_class(int sock, unsigned int nl_pid, int ifindex,
-			libbpf_dump_nlmsg_t dump_class_nlmsg, void *cookie);
-int libbpf_nl_get_qdisc(int sock, unsigned int nl_pid, int ifindex,
-			libbpf_dump_nlmsg_t dump_qdisc_nlmsg, void *cookie);
-int libbpf_nl_get_filter(int sock, unsigned int nl_pid, int ifindex, int handle,
-			 libbpf_dump_nlmsg_t dump_filter_nlmsg, void *cookie);
-
 struct bpf_prog_linfo;
 struct bpf_prog_info;
 
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index f4f10715db40..7d71621bb7e8 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -100,6 +100,23 @@ int parse_cpu_mask_file(const char *fcpu, bool **mask, int *mask_sz);
 int libbpf__load_raw_btf(const char *raw_types, size_t types_len,
 			 const char *str_sec, size_t str_len);
 
+int bpf_object__section_size(const struct bpf_object *obj, const char *name,
+			     __u32 *size);
+int bpf_object__variable_offset(const struct bpf_object *obj, const char *name,
+				__u32 *off);
+
+struct nlattr;
+typedef int (*libbpf_dump_nlmsg_t)(void *cookie, void *msg, struct nlattr **tb);
+int libbpf_netlink_open(unsigned int *nl_pid);
+int libbpf_nl_get_link(int sock, unsigned int nl_pid,
+		       libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie);
+int libbpf_nl_get_class(int sock, unsigned int nl_pid, int ifindex,
+			libbpf_dump_nlmsg_t dump_class_nlmsg, void *cookie);
+int libbpf_nl_get_qdisc(int sock, unsigned int nl_pid, int ifindex,
+			libbpf_dump_nlmsg_t dump_qdisc_nlmsg, void *cookie);
+int libbpf_nl_get_filter(int sock, unsigned int nl_pid, int ifindex, int handle,
+			 libbpf_dump_nlmsg_t dump_filter_nlmsg, void *cookie);
+
 struct btf_ext_info {
 	/*
 	 * info points to the individual info section (e.g. func_info and
-- 
2.17.1

