Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373FC3723F8
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 02:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhEDAv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 20:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhEDAv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 20:51:27 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6799C061574;
        Mon,  3 May 2021 17:50:32 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s22so5163329pgk.6;
        Mon, 03 May 2021 17:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C4tOZkQdf3iqrHHtx0oUE1hjh59b2tIApcygHPgdoIg=;
        b=ZxCrkbc0Tt6AXy4UNiecJjvDQVwgmkZhjrKK3taluj7ar/XizqJnFwL4FpRm0klXP8
         Gd9ftySvEJoeCiW5kYGvSN+qLmFck3DKYgLdbWndJYY+UxwpYL4CY4tuX3L6ZAGXCJ5H
         IDAzVQMZ4ElKvViRiCHyk50uMC0szN8aua2FMqE5qRRShaxvb2d903rGn8D0TtuRq/3j
         7FfRI4WOnoIDPHccV1+4wmqXf62NRpGK6oydicHvoWPgxvfc0dulnJVdgC7ETLiMCNdf
         bNpMxkDeiAv65BfwH/aCk51/NtbknUVG9oedQyTDJifxA+m0IBiEI388jBT14C+8VsYT
         acmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C4tOZkQdf3iqrHHtx0oUE1hjh59b2tIApcygHPgdoIg=;
        b=uPQ5Muv4hPVH4xgULnbE7WQ7K5lekFccWB/SHcbXHaIW04lh4G1FghH5bLieGnMiMe
         MT4s5XygLMPs8CNtQYwir73ddmKu3ljFqoq/A7yc16Rku03oMyKQBLTzt61/w1/WDxFW
         6WGnqX7U0jpYElAGsvjeoS3z382lJWiuQN2aZjWkEuxIqnkCJlwaz2du6tGCg6ULdWD7
         KzYxQQez7uZ7qE50YjfvshjsKcQOxdAoNC4pkb7q0gJTeE1ZIG+xb1dExt4P2i64B6My
         O3eMuil23r9i5S3BsWUo23mnfkEqZ/85f6lOSdXzbc1WawmipE/HHs3mwYAgEE/vnyia
         jcPA==
X-Gm-Message-State: AOAM533DCXTpOXDu7V6IH8BTtmXFt5103Gh0Wik44uBSr+51/SjLp7XH
        SLi4owRI26SB7JTbH8CoIy3K0zhhvgSBbg==
X-Google-Smtp-Source: ABdhPJwYjnvBjj6RH13MTsTLc+PFqPcHy823NVR98xKnvbpNza/ijDxQ/pqqL318wwSfzTj22X7r8Q==
X-Received: by 2002:a05:6a00:ad6:b029:28c:c28d:d3c5 with SMTP id c22-20020a056a000ad6b029028cc28dd3c5mr19669943pfl.54.1620089432104;
        Mon, 03 May 2021 17:50:32 -0700 (PDT)
Received: from localhost ([47.8.22.213])
        by smtp.gmail.com with ESMTPSA id l3sm886605pju.44.2021.05.03.17.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 17:50:31 -0700 (PDT)
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
        Shaun Crampton <shaun@tigera.io>, netdev@vger.kernel.org
Subject: [PATCH bpf-next v6 1/3] libbpf: add netlink helpers
Date:   Tue,  4 May 2021 06:20:21 +0530
Message-Id: <20210504005023.1240974-2-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504005023.1240974-1-memxor@gmail.com>
References: <20210504005023.1240974-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change introduces a few helpers to wrap open coded attribute
preparation in netlink.c. It also adds a libbpf_nl_send_recv that is useful
to wrap send + recv handling in a generic way. Subsequent patch will
also use this function for sending and receiving a netlink response.
The libbpf_nl_get_link helper has been removed instead, moving socket
creation into the newly named libbpf_nl_send_recv.

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

The libbpf_nl_send_recv call takes care of opening the socket, sending the
netlink message, receiving the response, potentially invoking callbacks,
and return errors if any, and then finally close the socket. This allows
users to avoid identical socket setup code in different places. The only
user of libbpf_nl_get_link has been converted to make use of it.

__bpf_set_link_xdp_fd_replace has also been refactored to use it.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/netlink.c | 117 ++++++++++++++++++----------------------
 tools/lib/bpf/nlattr.h  |  48 +++++++++++++++++
 2 files changed, 100 insertions(+), 65 deletions(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index d2cb28e9ef52..8a01d9eed5f9 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -131,72 +131,53 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
 	return ret;
 }
 
+static int libbpf_nl_send_recv(struct nlmsghdr *nh, __dump_nlmsg_t parse_msg,
+			       libbpf_dump_nlmsg_t parse_attr, void *cookie);
+
 static int __bpf_set_link_xdp_fd_replace(int ifindex, int fd, int old_fd,
 					 __u32 flags)
 {
-	int sock, seq = 0, ret;
-	struct nlattr *nla, *nla_xdp;
+	struct nlattr *nla;
+	int ret;
 	struct {
 		struct nlmsghdr  nh;
 		struct ifinfomsg ifinfo;
 		char             attrbuf[64];
 	} req;
-	__u32 nl_pid = 0;
-
-	sock = libbpf_netlink_open(&nl_pid);
-	if (sock < 0)
-		return sock;
 
 	memset(&req, 0, sizeof(req));
 	req.nh.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg));
 	req.nh.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
 	req.nh.nlmsg_type = RTM_SETLINK;
-	req.nh.nlmsg_pid = 0;
-	req.nh.nlmsg_seq = ++seq;
 	req.ifinfo.ifi_family = AF_UNSPEC;
 	req.ifinfo.ifi_index = ifindex;
 
 	/* started nested attribute for XDP */
-	nla = (struct nlattr *)(((char *)&req)
-				+ NLMSG_ALIGN(req.nh.nlmsg_len));
-	nla->nla_type = NLA_F_NESTED | IFLA_XDP;
-	nla->nla_len = NLA_HDRLEN;
+	nla = nlattr_begin_nested(&req.nh, sizeof(req), IFLA_XDP);
+	if (!nla)
+		return -EMSGSIZE;
 
 	/* add XDP fd */
-	nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
-	nla_xdp->nla_type = IFLA_XDP_FD;
-	nla_xdp->nla_len = NLA_HDRLEN + sizeof(int);
-	memcpy((char *)nla_xdp + NLA_HDRLEN, &fd, sizeof(fd));
-	nla->nla_len += nla_xdp->nla_len;
+	ret = nlattr_add(&req.nh, sizeof(req), IFLA_XDP_FD, &fd, sizeof(fd));
+	if (ret < 0)
+		return ret;
 
 	/* if user passed in any flags, add those too */
 	if (flags) {
-		nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
-		nla_xdp->nla_type = IFLA_XDP_FLAGS;
-		nla_xdp->nla_len = NLA_HDRLEN + sizeof(flags);
-		memcpy((char *)nla_xdp + NLA_HDRLEN, &flags, sizeof(flags));
-		nla->nla_len += nla_xdp->nla_len;
+		ret = nlattr_add(&req.nh, sizeof(req), IFLA_XDP_FLAGS, &flags, sizeof(flags));
+		if (ret < 0)
+			return ret;
 	}
 
 	if (flags & XDP_FLAGS_REPLACE) {
-		nla_xdp = (struct nlattr *)((char *)nla + nla->nla_len);
-		nla_xdp->nla_type = IFLA_XDP_EXPECTED_FD;
-		nla_xdp->nla_len = NLA_HDRLEN + sizeof(old_fd);
-		memcpy((char *)nla_xdp + NLA_HDRLEN, &old_fd, sizeof(old_fd));
-		nla->nla_len += nla_xdp->nla_len;
+		ret = nlattr_add(&req.nh, sizeof(req), IFLA_XDP_EXPECTED_FD, &old_fd, sizeof(old_fd));
+		if (ret < 0)
+			return ret;
 	}
 
-	req.nh.nlmsg_len += NLA_ALIGN(nla->nla_len);
+	nlattr_end_nested(&req.nh, nla);
 
-	if (send(sock, &req, req.nh.nlmsg_len, 0) < 0) {
-		ret = -errno;
-		goto cleanup;
-	}
-	ret = bpf_netlink_recv(sock, nl_pid, seq, NULL, NULL, NULL);
-
-cleanup:
-	close(sock);
-	return ret;
+	return libbpf_nl_send_recv(&req.nh, NULL, NULL, NULL);
 }
 
 int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
@@ -282,16 +263,22 @@ static int get_xdp_info(void *cookie, void *msg, struct nlattr **tb)
 	return 0;
 }
 
-static int libbpf_nl_get_link(int sock, unsigned int nl_pid,
-			      libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie);
 
 int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 			  size_t info_size, __u32 flags)
 {
 	struct xdp_id_md xdp_id = {};
-	int sock, ret;
-	__u32 nl_pid = 0;
 	__u32 mask;
+	int ret;
+	struct {
+		struct nlmsghdr nlh;
+		struct ifinfomsg ifm;
+	} req = {
+		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg)),
+		.nlh.nlmsg_type = RTM_GETLINK,
+		.nlh.nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST,
+		.ifm.ifi_family = AF_PACKET,
+	};
 
 	if (flags & ~XDP_FLAGS_MASK || !info_size)
 		return -EINVAL;
@@ -302,14 +289,10 @@ int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 	if (flags && flags & mask)
 		return -EINVAL;
 
-	sock = libbpf_netlink_open(&nl_pid);
-	if (sock < 0)
-		return sock;
-
 	xdp_id.ifindex = ifindex;
 	xdp_id.flags = flags;
 
-	ret = libbpf_nl_get_link(sock, nl_pid, get_xdp_info, &xdp_id);
+	ret = libbpf_nl_send_recv(&req.nlh, __dump_link_nlmsg, get_xdp_info, &xdp_id);
 	if (!ret) {
 		size_t sz = min(info_size, sizeof(xdp_id.info));
 
@@ -317,7 +300,6 @@ int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
 		memset((void *) info + sz, 0, info_size - sz);
 	}
 
-	close(sock);
 	return ret;
 }
 
@@ -349,24 +331,29 @@ int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
 	return ret;
 }
 
-int libbpf_nl_get_link(int sock, unsigned int nl_pid,
-		       libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie)
+static int libbpf_nl_send_recv(struct nlmsghdr *nh, __dump_nlmsg_t parse_msg,
+			       libbpf_dump_nlmsg_t parse_attr, void *cookie)
 {
-	struct {
-		struct nlmsghdr nlh;
-		struct ifinfomsg ifm;
-	} req = {
-		.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg)),
-		.nlh.nlmsg_type = RTM_GETLINK,
-		.nlh.nlmsg_flags = NLM_F_DUMP | NLM_F_REQUEST,
-		.ifm.ifi_family = AF_PACKET,
-	};
-	int seq = time(NULL);
+	__u32 nl_pid = 0;
+	int sock, ret;
 
-	req.nlh.nlmsg_seq = seq;
-	if (send(sock, &req, req.nlh.nlmsg_len, 0) < 0)
-		return -errno;
+	if (!nh)
+		return -EINVAL;
+
+	sock = libbpf_netlink_open(&nl_pid);
+	if (sock < 0)
+		return sock;
 
-	return bpf_netlink_recv(sock, nl_pid, seq, __dump_link_nlmsg,
-				dump_link_nlmsg, cookie);
+	nh->nlmsg_pid = 0;
+	nh->nlmsg_seq = time(NULL);
+	if (send(sock, nh, nh->nlmsg_len, 0) < 0) {
+		ret = -errno;
+		goto end;
+	}
+
+	ret = bpf_netlink_recv(sock, nl_pid, nh->nlmsg_seq, parse_msg, parse_attr, cookie);
+
+end:
+	close(sock);
+	return ret;
 }
diff --git a/tools/lib/bpf/nlattr.h b/tools/lib/bpf/nlattr.h
index 6cc3ac91690f..3c780ab6d022 100644
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
+	if (!!data != !!len)
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

