Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E87411231A
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 08:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfLDHA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 02:00:29 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45426 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbfLDHA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 02:00:29 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB46xk2D025820
        for <netdev@vger.kernel.org>; Tue, 3 Dec 2019 23:00:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=JC71UaOuUEYWvsktSZdFoK9vx9wnmj/YgDK2Peh+FSk=;
 b=JyH1WpJhKQthpEpwXBv0oLs+uuI0lgTgeye/uIaUT/8Q+XUT8+5SlTVlwbw3jxngbeUv
 kUMSBi9yIElld2vrEwrNe7ks8hw9otp1Rke6oNLTAfcYxRf1g7wwHyHOk1lo75wpIIwB
 qU8ODs9Eki7Rw2zb+z+jNpdWEz08f9kPHsc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wp7kar4qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 23:00:27 -0800
Received: from 2401:db00:2120:80d4:face:0:39:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 3 Dec 2019 23:00:26 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CD6972EC1853; Tue,  3 Dec 2019 23:00:24 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 03/16] libbpf: move non-public APIs from libbpf.h to libbpf_internal.h
Date:   Tue, 3 Dec 2019 23:00:02 -0800
Message-ID: <20191204070015.3523523-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191204070015.3523523-1-andriin@fb.com>
References: <20191204070015.3523523-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-04_01:2019-12-04,2019-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 suspectscore=8 adultscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912040051
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few libbpf APIs are not public but currently exposed through libbpf.h to be
used by bpftool. Move them to libbpf_internal.h, where intent of being
non-stable and non-public is much more obvious.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/net.c         |  1 +
 tools/lib/bpf/libbpf.h          | 17 -----------------
 tools/lib/bpf/libbpf.map        |  1 -
 tools/lib/bpf/libbpf_internal.h | 17 +++++++++++++++++
 4 files changed, 18 insertions(+), 18 deletions(-)

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
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 88dded011a84..757a88f64b5a 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -203,7 +203,6 @@ LIBBPF_0.0.6 {
 		bpf_program__get_expected_attach_type;
 		bpf_program__get_type;
 		bpf_program__is_tracing;
-		bpf_program__name;
 		bpf_program__set_tracing;
 		bpf_program__size;
 		btf__find_by_name_kind;
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 97ac17a64a58..7ee0c8691835 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -98,6 +98,23 @@ static inline bool libbpf_validate_opts(const char *opts,
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

