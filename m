Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D598117CF2
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 02:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfLJBO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 20:14:57 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65498 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727492AbfLJBO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 20:14:56 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBA1EqH7025869
        for <netdev@vger.kernel.org>; Mon, 9 Dec 2019 17:14:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=TICdj9MqdEBx5LXW2itojFdnMMVGOHbIG551LLsKUlA=;
 b=rXe6/jjvisdD5d9EdCqCpjhLJz4fKcUCrLKM4UlJx6TErUKCoMR8IIFH239qU+/lu2Lk
 6PlbLks5o/HIP9lhmor1U9pLiT2esyxGY9Csq3ebu/7dORYFbd/3F4qTzdjmg3fIes8C
 YQjML2aT6tz7j4Skr+9O9ZINdYbNarMYdJU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wrvp0r54y-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 17:14:55 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 9 Dec 2019 17:14:54 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AAAEE2EC16B5; Mon,  9 Dec 2019 17:14:53 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 03/15] libbpf: move non-public APIs from libbpf.h to libbpf_internal.h
Date:   Mon, 9 Dec 2019 17:14:26 -0800
Message-ID: <20191210011438.4182911-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191210011438.4182911-1-andriin@fb.com>
References: <20191210011438.4182911-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_05:2019-12-09,2019-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 suspectscore=8 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912100009
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

