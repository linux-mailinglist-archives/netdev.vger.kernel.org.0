Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F53F59F5
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732540AbfKHVdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:33:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34522 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732345AbfKHVdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 16:33:14 -0500
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EFB21859FB
        for <netdev@vger.kernel.org>; Fri,  8 Nov 2019 21:33:13 +0000 (UTC)
Received: by mail-lf1-f72.google.com with SMTP id t27so1539925lfk.21
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 13:33:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=KEdhLwAVsGhVj4PsFhQaEcqZ2zyRG2qSObaUs/ic3uA=;
        b=OtFJfNKgluijUDJr9h+aBLkBozPPXumGFBqHsPJAduxqDu5cISuhaPuNCUXD7WADky
         akngq1vrq0002lSZAt2LEPVfjPQ4K3UYMnctl57FAvVFTVWD5BWU78o8Lp8FbVOxd8PP
         0gGQHWuvrzdRWRj25INOL21ljvwUseVAAz56DkR0zbnvsISdxFkGDhxyvLK54q2Q1aYo
         reNWYepyWP0q6ygaQv7oPeJx6fTan/0Yjn8Qwwzpa0iPb5BJZE8uu2YbJ5Pv/7A5Ni8+
         wFM1cABhEh0Wr76V9znbjG+egKfYM9JxOs/TVUoWJEK1/ryqEpe/yx6ldhaXGQCIcIub
         au/w==
X-Gm-Message-State: APjAAAVWpZKETda1zeBKWZ3QempO/5G1hzDZQpbIwRccaI3jdN17Ytcn
        Q68vLG2avv5plYOuptJ35S4gzFLm6Tdr+l4YoHkAHrL6vk4lFqoIlJVsuThgAW869OP4cxlss+n
        /H/yNx4f134CwczUJ
X-Received: by 2002:a2e:63c9:: with SMTP id s70mr8403803lje.73.1573248792500;
        Fri, 08 Nov 2019 13:33:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqyS6jlFLaQ/wWOHXm+iMwCf6HM6CzZpNoK9U+lNJyMBXfl83W5eK3Lezbd51vcYpdiOxO1ZXQ==
X-Received: by 2002:a2e:63c9:: with SMTP id s70mr8403786lje.73.1573248792293;
        Fri, 08 Nov 2019 13:33:12 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id c22sm3629499lfj.28.2019.11.08.13.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 13:33:11 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BE6FF1800CB; Fri,  8 Nov 2019 22:33:10 +0100 (CET)
Subject: [PATCH bpf-next v2 5/6] libbpf: Add bpf_get_link_xdp_info() function
 to get more XDP information
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 08 Nov 2019 22:33:10 +0100
Message-ID: <157324879070.910124.16900285171727920636.stgit@toke.dk>
In-Reply-To: <157324878503.910124.12936814523952521484.stgit@toke.dk>
References: <157324878503.910124.12936814523952521484.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

Currently, libbpf only provides a function to get a single ID for the XDP
program attached to the interface. However, it can be useful to get the
full set of program IDs attached, along with the attachment mode, in one
go. Add a new getter function to support this, using an extendible
structure to carry the information. Express the old bpf_get_link_id()
function in terms of the new function.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.h   |   10 ++++++
 tools/lib/bpf/libbpf.map |    1 +
 tools/lib/bpf/netlink.c  |   78 ++++++++++++++++++++++++++++++----------------
 3 files changed, 62 insertions(+), 27 deletions(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 6ddc0419337b..f0947cc949d2 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -427,8 +427,18 @@ LIBBPF_API int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 LIBBPF_API int bpf_prog_load(const char *file, enum bpf_prog_type type,
 			     struct bpf_object **pobj, int *prog_fd);
 
+struct xdp_link_info {
+	__u32 prog_id;
+	__u32 drv_prog_id;
+	__u32 hw_prog_id;
+	__u32 skb_prog_id;
+	__u8 attach_mode;
+};
+
 LIBBPF_API int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags);
 LIBBPF_API int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags);
+LIBBPF_API int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
+				     size_t info_size, __u32 flags);
 
 struct perf_buffer;
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 86173cbb159d..d1a782a3a58d 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -193,6 +193,7 @@ LIBBPF_0.0.5 {
 
 LIBBPF_0.0.6 {
 	global:
+		bpf_get_link_xdp_info;
 		bpf_map__get_pin_path;
 		bpf_map__is_pinned;
 		bpf_map__set_pin_path;
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index a261df9cb488..85019da01d3b 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -25,7 +25,7 @@ typedef int (*__dump_nlmsg_t)(struct nlmsghdr *nlmsg, libbpf_dump_nlmsg_t,
 struct xdp_id_md {
 	int ifindex;
 	__u32 flags;
-	__u32 id;
+	struct xdp_link_info info;
 };
 
 int libbpf_netlink_open(__u32 *nl_pid)
@@ -203,26 +203,11 @@ static int __dump_link_nlmsg(struct nlmsghdr *nlh,
 	return dump_link_nlmsg(cookie, ifi, tb);
 }
 
-static unsigned char get_xdp_id_attr(unsigned char mode, __u32 flags)
-{
-	if (mode != XDP_ATTACHED_MULTI)
-		return IFLA_XDP_PROG_ID;
-	if (flags & XDP_FLAGS_DRV_MODE)
-		return IFLA_XDP_DRV_PROG_ID;
-	if (flags & XDP_FLAGS_HW_MODE)
-		return IFLA_XDP_HW_PROG_ID;
-	if (flags & XDP_FLAGS_SKB_MODE)
-		return IFLA_XDP_SKB_PROG_ID;
-
-	return IFLA_XDP_UNSPEC;
-}
-
-static int get_xdp_id(void *cookie, void *msg, struct nlattr **tb)
+static int get_xdp_info(void *cookie, void *msg, struct nlattr **tb)
 {
 	struct nlattr *xdp_tb[IFLA_XDP_MAX + 1];
 	struct xdp_id_md *xdp_id = cookie;
 	struct ifinfomsg *ifinfo = msg;
-	unsigned char mode, xdp_attr;
 	int ret;
 
 	if (xdp_id->ifindex && xdp_id->ifindex != ifinfo->ifi_index)
@@ -238,27 +223,40 @@ static int get_xdp_id(void *cookie, void *msg, struct nlattr **tb)
 	if (!xdp_tb[IFLA_XDP_ATTACHED])
 		return 0;
 
-	mode = libbpf_nla_getattr_u8(xdp_tb[IFLA_XDP_ATTACHED]);
-	if (mode == XDP_ATTACHED_NONE)
-		return 0;
+	xdp_id->info.attach_mode = libbpf_nla_getattr_u8(
+		xdp_tb[IFLA_XDP_ATTACHED]);
 
-	xdp_attr = get_xdp_id_attr(mode, xdp_id->flags);
-	if (!xdp_attr || !xdp_tb[xdp_attr])
+	if (xdp_id->info.attach_mode == XDP_ATTACHED_NONE)
 		return 0;
 
-	xdp_id->id = libbpf_nla_getattr_u32(xdp_tb[xdp_attr]);
+	if (xdp_tb[IFLA_XDP_PROG_ID])
+		xdp_id->info.prog_id = libbpf_nla_getattr_u32(
+			xdp_tb[IFLA_XDP_PROG_ID]);
+
+	if (xdp_tb[IFLA_XDP_SKB_PROG_ID])
+		xdp_id->info.skb_prog_id = libbpf_nla_getattr_u32(
+			xdp_tb[IFLA_XDP_SKB_PROG_ID]);
+
+	if (xdp_tb[IFLA_XDP_DRV_PROG_ID])
+		xdp_id->info.drv_prog_id = libbpf_nla_getattr_u32(
+			xdp_tb[IFLA_XDP_DRV_PROG_ID]);
+
+	if (xdp_tb[IFLA_XDP_HW_PROG_ID])
+		xdp_id->info.hw_prog_id = libbpf_nla_getattr_u32(
+			xdp_tb[IFLA_XDP_HW_PROG_ID]);
 
 	return 0;
 }
 
-int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
+int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
+			  size_t info_size, __u32 flags)
 {
 	struct xdp_id_md xdp_id = {};
 	int sock, ret;
 	__u32 nl_pid;
 	__u32 mask;
 
-	if (flags & ~XDP_FLAGS_MASK)
+	if (flags & ~XDP_FLAGS_MASK || info_size != sizeof(*info))
 		return -EINVAL;
 
 	/* Check whether the single {HW,DRV,SKB} mode is set */
@@ -274,14 +272,40 @@ int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
 	xdp_id.ifindex = ifindex;
 	xdp_id.flags = flags;
 
-	ret = libbpf_nl_get_link(sock, nl_pid, get_xdp_id, &xdp_id);
+	ret = libbpf_nl_get_link(sock, nl_pid, get_xdp_info, &xdp_id);
 	if (!ret)
-		*prog_id = xdp_id.id;
+		memcpy(info, &xdp_id.info, sizeof(*info));
 
 	close(sock);
 	return ret;
 }
 
+static __u32 get_xdp_id(struct xdp_link_info *info, __u32 flags)
+{
+	if (info->attach_mode != XDP_ATTACHED_MULTI)
+		return info->prog_id;
+	if (flags & XDP_FLAGS_DRV_MODE)
+		return info->drv_prog_id;
+	if (flags & XDP_FLAGS_HW_MODE)
+		return info->hw_prog_id;
+	if (flags & XDP_FLAGS_SKB_MODE)
+		return info->skb_prog_id;
+
+	return 0;
+}
+
+int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
+{
+	struct xdp_link_info info = {};
+	int ret;
+
+	ret = bpf_get_link_xdp_info(ifindex, &info, sizeof(info), flags);
+	if (!ret)
+		*prog_id = get_xdp_id(&info, flags);
+
+	return ret;
+}
+
 int libbpf_nl_get_link(int sock, unsigned int nl_pid,
 		       libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie)
 {

