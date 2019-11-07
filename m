Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDE3FF3514
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389598AbfKGQwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:52:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38230 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389491AbfKGQw1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 11:52:27 -0500
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E94164E8B8
        for <netdev@vger.kernel.org>; Thu,  7 Nov 2019 16:52:26 +0000 (UTC)
Received: by mail-lj1-f199.google.com with SMTP id l12so622355lji.10
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 08:52:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=1aN7+canHIMKlQtTU6Zr3n89sOIvMiA7D4T8NMUJuPY=;
        b=s5aQ0ob0A/Si5nMXz7BF0zWv+wOudlcNPMQkbWEUfYcauRcaO8adsF18CorpuOgu5+
         ILRB9O4uOxG4IDYg9HZtj5JVEjEdGFutNn3EuAj3DTwfjEs0xILIu+gmRNPBZZ9xF1re
         PEOiRcc0QILH7x/HqFtggzh+GXocqRikTemXtKvx4Qo5K6xte7dZYkv/ruZfOUmSdiEB
         JRiJYt/lDsLEnsBYvjULTXxHJ3yk5vG6yh/BHhcF8eJ2kECtnhWCgUDNkyZIRjtCs241
         sXgmF7WyCliXP8g/7waQbRvWQtGYk0DMOGhkdcfGAasdlAHRT89l2xsiFCIPdusgZezR
         gFYA==
X-Gm-Message-State: APjAAAWwGC4apdcUntVBH9lH7l9xIGfw+K7cnhCU8CuwHY5/Ei0dCiMG
        lKqzOX2wkkITLCj0bIlBjOvaLXbR2d1xecCvZM8KU2BBU+WpGuz3WwLmJ5V/DiyBYtVCoYJSS24
        Ba/hGCzM0aXSxKRAR
X-Received: by 2002:ac2:5c05:: with SMTP id r5mr2855674lfp.72.1573145545476;
        Thu, 07 Nov 2019 08:52:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqx87t+C4CqUWfHKznc3WlZIECyyqqK8WSPT2pQm/MhJkLiPac1dQsK4McuH6B8fqMItdMTNww==
X-Received: by 2002:ac2:5c05:: with SMTP id r5mr2855664lfp.72.1573145545250;
        Thu, 07 Nov 2019 08:52:25 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id y3sm3799509ljn.81.2019.11.07.08.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 08:52:24 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C789A1818B5; Thu,  7 Nov 2019 17:52:23 +0100 (CET)
Subject: [PATCH bpf-next 5/6] libbpf: Add bpf_get_link_xdp_info() function to
 get more XDP information
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Thu, 07 Nov 2019 17:52:23 +0100
Message-ID: <157314554370.693412.2312326138964108684.stgit@toke.dk>
In-Reply-To: <157314553801.693412.15522462897300280861.stgit@toke.dk>
References: <157314553801.693412.15522462897300280861.stgit@toke.dk>
User-Agent: StGit/0.20
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
index 86173cbb159d..45f229af2766 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -202,4 +202,5 @@ LIBBPF_0.0.6 {
 		bpf_program__get_type;
 		bpf_program__is_tracing;
 		bpf_program__set_tracing;
+		bpf_get_link_xdp_info;
 } LIBBPF_0.0.5;
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

