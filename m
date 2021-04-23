Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF5B369595
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 17:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhDWPGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 11:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242800AbhDWPGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 11:06:45 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3079FC061574;
        Fri, 23 Apr 2021 08:06:09 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id y32so35375503pga.11;
        Fri, 23 Apr 2021 08:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6PxbFNy4TwwhW0qk6KdqKgL8X0j6sxwiVkZ7z1Vo1yE=;
        b=rjNR0dJJSbzYynHDQeXZdsrn5PkuW3du6Hj3FjJ59Tg1tDHRbifZZ1fo44SSDEJtI2
         sZXCbudVO1QoKi9YOKbDbQPGJqavL3HdbuSO5OucefiplySkzqPYSsctiqHHZQAZE5Vr
         Z+RGyQzzkErQ/bAgEThu/MATwGA5SRyBAogg1IF2BjTJoEJA1VBf1Z5OwDNYy73+B3tI
         EbYSX5xq79HQJcfv61mm2HmOuEagnFwPctpPcGCZyN49+mZTyzklrRE6TpSmHCqX7WVA
         WZwI1eIjeO/QCdQ3152S15qJav8OrilEcYpcz2//0pVQEM230YZfwI0pzQfcbSNCBRN2
         coqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6PxbFNy4TwwhW0qk6KdqKgL8X0j6sxwiVkZ7z1Vo1yE=;
        b=uBCBGEUiwHVP9v5ASfK8lLmpt8UwGQJEob2tDQz456nENj+j0+ciFONGZp+LZj31XP
         8mlxfC/TNy+WCuxjf/LJkcHbHtjElO950EjN0UMxGhupcK1QzEaeksL79fgQaQKW9FH1
         +FhiDPIfeqa50dLteinVb4leqwdK2ZZZVnPehjV1UkZ6l2NgoFFzSteqrrEvF1McQWwN
         Vt20z6uIv0NhEKama7NxEp5zt6Q+or9yJ1/mbXeBUGILdTOa3TLZ+L40FjnhmPbC0HDW
         ZFFVZlRN8fFyq72tO2kyRqAF6IChpOMPUEivOzzAd5qV4y4Cm2b7f57uJuoiw03t6ybb
         ywRA==
X-Gm-Message-State: AOAM532GpXSV4H7sBp8OGmyZqLGHDG6sMuWmIshIJ2nbdzMuVJ0VriQ+
        lSRoiD+QUF+hmhqREl6g3l6rgpTu8+GCdw==
X-Google-Smtp-Source: ABdhPJwjfDJnS5pl+yGG6e8e5EVy9S91Lqm3eArA508QoEmctZBH1cEoEUE+712BjWVSIa9vJtI2SQ==
X-Received: by 2002:aa7:8c0e:0:b029:258:672e:9f86 with SMTP id c14-20020aa78c0e0000b0290258672e9f86mr4489346pfd.50.1619190368497;
        Fri, 23 Apr 2021 08:06:08 -0700 (PDT)
Received: from localhost ([112.79.255.145])
        by smtp.gmail.com with ESMTPSA id l1sm5460930pgt.29.2021.04.23.08.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 08:06:08 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 1/3] libbpf: add helpers for preparing netlink attributes
Date:   Fri, 23 Apr 2021 20:35:58 +0530
Message-Id: <20210423150600.498490-2-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423150600.498490-1-memxor@gmail.com>
References: <20210423150600.498490-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change introduces a few helpers to wrap open coded attribute
preparation in netlink.c.

Every nested attribute's closure must happen using the helper
nlattr_end_nested, which sets its length properly. NLA_F_NESTED is
enforced using nlattr_begin_nested helper. Other simple attributes
can be added directly.

The maxsz parameter corresponds to the size of the request structure
which is being filled in, so for instance with req being:

struct {
	struct nlmsghdr nh;
	struct tcmsg t;
	char buf[4096];
} req;

Then, maxsz should be sizeof(req).

This change also converts the open coded attribute preparation with the
helpers. Note that the only failure the internal call to nlattr_add
could result in the nested helper would be -EMSGSIZE, hence that is what
we return to our caller.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/netlink.c | 37 ++++++++++++++-----------------
 tools/lib/bpf/nlattr.h  | 48 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 21 deletions(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index d2cb28e9ef52..c79e30484e81 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -135,7 +135,7 @@ static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
 					 __u32 flags)
 {
 	int sock, seq = 0, ret;
-	struct nlattr *nla, *nla_xdp;
+	struct nlattr *nla;
 	struct {
 		struct nlmsghdr  nh;
 		struct ifinfomsg ifinfo;
@@ -157,36 +157,31 @@ static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
 	req.ifinfo.ifi_index = ifindex;
 
 	/* started nested attribute for XDP */
-	nla = (struct nlattr *)(((char *)&req)
-				+ NLMSG_ALIGN(req.nh.nlmsg_len));
-	nla->nla_type = NLA_F_NESTED | IFLA_XDP;
-	nla->nla_len = NLA_HDRLEN;
+	nla = nlattr_begin_nested(&req.nh, sizeof(req), IFLA_XDP);
+	if (!nla) {
+		ret = -EMSGSIZE;
+		goto cleanup;
+	}
 
 	/* add XDP fd */
-	nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
-	nla_xdp->nla_type = IFLA_XDP_FD;
-	nla_xdp->nla_len = NLA_HDRLEN + sizeof(int);
-	memcpy((char *)nla_xdp + NLA_HDRLEN, &fd, sizeof(fd));
-	nla->nla_len += nla_xdp->nla_len;
+	ret = nlattr_add(&req.nh, sizeof(req), IFLA_XDP_FD, &fd, sizeof(fd));
+	if (ret < 0)
+		goto cleanup;
 
 	/* if user passed in any flags, add those too */
 	if (flags) {
-		nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
-		nla_xdp->nla_type = IFLA_XDP_FLAGS;
-		nla_xdp->nla_len = NLA_HDRLEN + sizeof(flags);
-		memcpy((char *)nla_xdp + NLA_HDRLEN, &flags, sizeof(flags));
-		nla->nla_len += nla_xdp->nla_len;
+		ret = nlattr_add(&req.nh, sizeof(req), IFLA_XDP_FLAGS, &flags, sizeof(flags));
+		if (ret < 0)
+			goto cleanup;
 	}
 
 	if (flags & XDP_FLAGS_REPLACE) {
-		nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
-		nla_xdp->nla_type = IFLA_XDP_EXPECTED_FD;
-		nla_xdp->nla_len = NLA_HDRLEN + sizeof(old_fd);
-		memcpy((char *)nla_xdp + NLA_HDRLEN, &old_fd, sizeof(old_fd));
-		nla->nla_len += nla_xdp->nla_len;
+		ret = nlattr_add(&req.nh, sizeof(req), IFLA_XDP_EXPECTED_FD, &flags, sizeof(flags));
+		if (ret < 0)
+			goto cleanup;
 	}
 
-	req.nh.nlmsg_len += NLA_ALIGN(nla->nla_len);
+	nlattr_end_nested(&req.nh, nla);
 
 	if (send(sock, &req, req.nh.nlmsg_len, 0) < 0) {
 		ret = -errno;
diff --git a/tools/lib/bpf/nlattr.h b/tools/lib/bpf/nlattr.h
index 6cc3ac91690f..1c94cdb6e89d 100644
--- a/tools/lib/bpf/nlattr.h
+++ b/tools/lib/bpf/nlattr.h
@@ -10,7 +10,10 @@
 #define __LIBBPF_NLATTR_H
 
 #include <stdint.h>
+#include <string.h>
+#include <errno.h>
 #include <linux/netlink.h>
+
 /* avoid multiple definition of netlink features */
 #define __LINUX_NETLINK_H
 
@@ -103,4 +106,49 @@ int libbpf_nla_parse_nested(struct nlattr *tb[], int maxtype,
 
 int libbpf_nla_dump_errormsg(struct nlmsghdr *nlh);
 
+static inline struct nlattr *nla_data(struct nlattr *nla)
+{
+	return (struct nlattr *)((char *)nla + NLA_HDRLEN);
+}
+
+static inline struct nlattr *nh_tail(struct nlmsghdr *nh)
+{
+	return (struct nlattr *)((char *)nh + NLMSG_ALIGN(nh->nlmsg_len));
+}
+
+static inline int nlattr_add(struct nlmsghdr *nh, size_t maxsz, int type,
+			     const void *data, int len)
+{
+	struct nlattr *nla;
+
+	if (NLMSG_ALIGN(nh->nlmsg_len) + NLA_ALIGN(NLA_HDRLEN + len) > maxsz)
+		return -EMSGSIZE;
+	if ((!data && len) || (data && !len))
+		return -EINVAL;
+
+	nla = nh_tail(nh);
+	nla->nla_type = type;
+	nla->nla_len = NLA_HDRLEN + len;
+	if (data)
+		memcpy(nla_data(nla), data, len);
+	nh->nlmsg_len = NLMSG_ALIGN(nh->nlmsg_len) + NLA_ALIGN(nla->nla_len);
+	return 0;
+}
+
+static inline struct nlattr *nlattr_begin_nested(struct nlmsghdr *nh,
+						 size_t maxsz, int type)
+{
+	struct nlattr *tail;
+
+	tail = nh_tail(nh);
+	if (nlattr_add(nh, maxsz, type | NLA_F_NESTED, NULL, 0))
+		return NULL;
+	return tail;
+}
+
+static inline void nlattr_end_nested(struct nlmsghdr *nh, struct nlattr *tail)
+{
+	tail->nla_len = (char *)nh_tail(nh) - (char *)tail;
+}
+
 #endif /* __LIBBPF_NLATTR_H */
-- 
2.30.2

