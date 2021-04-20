Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD7636604A
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 21:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbhDTTiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 15:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbhDTTiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 15:38:20 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF33BC06174A;
        Tue, 20 Apr 2021 12:37:48 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id q10so27379714pgj.2;
        Tue, 20 Apr 2021 12:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oYCNET7iFKziKZ1Ub0jaHIxttSr8miY2y9P2JjnTAOQ=;
        b=Ux/XVioh+3znSi/ZaBcHUAS9qqZIutHCoG6V0g7a23qgHrTETG+4zVNZ0iSFeOAjpe
         pQpemcvLNw3jqC9XfUT3JktAuqBrR5zVjSz4SlLNy+EbzAe123Io8JwJ0t0dwZFgjt/P
         CH/DNEkCGow2E9f5GTmrkPSZDK+pk0on4lHVMiH7yC0AdpL59gsGPS5rUdSYC6Iam9iA
         s4KoP5C8EB3CuLrSFbwM3Q8htlDo+gOpXz/esSijBYq7xFMNLcZOplBRwEtEnEF+bqPs
         tb7F+/BUSiuMNPSMCjchJIFWBcf2mNvtelTxgxImmcpe6ZPyKjpFz6e0lJ66qTc4LsE2
         W7Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oYCNET7iFKziKZ1Ub0jaHIxttSr8miY2y9P2JjnTAOQ=;
        b=TqkZuZlmQZfoCOZOTpHK/FRzN2laJ9OO12Ldn63X71A3zuSbibSx/gtGTpgSl8gWJS
         eb0Jz1cyX0DSU/uKMQ8b87NmY1AMrp8Kjpm7h6vXcVCWheSOKwZXkzQKvbIw/8br2/as
         DzDToGpXTVnile336lxObIzm9KxAFt1CdOwb1GWdP6l4tQChj5aQ+CY+21XQ1pC+Zo7x
         AdzFkfWzU8hMtA3+O9/IzM6sWUMHbD92xXEHuYmLI6wGH5vcGgJ5sN9MnDTc0s6kDy88
         s7RNjCd+Wrr3dbDJ+Q0KyUpSo62I1Kwb9NoJdsi0KUMESStuqcCa6jSMlTJn+S9ygx2t
         5DWg==
X-Gm-Message-State: AOAM533XERkt3LDWevCQ6cGW7l84xD+2eUkq2quLNjzLCY1XDf/HRpsI
        heFX9SC1R27SFdSd8HnjbbB9izBM7cMczQ==
X-Google-Smtp-Source: ABdhPJwimD4+mYlbc3Jg4kNLHcZTh0AS3jr+Le7MYR1npPbPifXz2TeSq4DCymQ72NhVSplIiA9S2g==
X-Received: by 2002:a17:90b:300f:: with SMTP id hg15mr6790218pjb.92.1618947468163;
        Tue, 20 Apr 2021 12:37:48 -0700 (PDT)
Received: from localhost ([112.79.227.195])
        by smtp.gmail.com with ESMTPSA id p10sm16861329pgn.85.2021.04.20.12.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 12:37:47 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 1/3] libbpf: add helpers for preparing netlink attributes
Date:   Wed, 21 Apr 2021 01:07:38 +0530
Message-Id: <20210420193740.124285-2-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420193740.124285-1-memxor@gmail.com>
References: <20210420193740.124285-1-memxor@gmail.com>
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
enforeced using nlattr_begin_nested helper. Other simple attributes
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

