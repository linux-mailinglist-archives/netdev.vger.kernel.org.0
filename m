Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFDA36417E
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 14:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239187AbhDSMTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 08:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238780AbhDSMTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 08:19:01 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D40C061761;
        Mon, 19 Apr 2021 05:18:30 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so20276304pjh.1;
        Mon, 19 Apr 2021 05:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oYCNET7iFKziKZ1Ub0jaHIxttSr8miY2y9P2JjnTAOQ=;
        b=JawARq9HS4xvRHh2KSALyagw3+Ji30EbZnVWlLedMLdYPqxnrj3BCTpC5F5yFcsfI1
         4opMGLSurZNg3hFDSmYQtfmoYlwCd9OjtMeEYolh2mTYq18d79fUoBpuJpZB9Gya1mCz
         NcTzjqpdO3M7w1GpuYUO4kG9RBAS/24D8k1bx+DUMbQJ4w1fX5ivLOnpV6UfxrtHGyFW
         9vhW1Q6UPWfYPCv9IRfrnzlw6ZBzNoexU2Rq5KxgIQsGj6oP1AOp9YBIXX4tsFtS9B9i
         CY7yXNXUf6luRxv+bsoYI7DXhM0gCdbIKAx5Oat4x6oqlrDXrFKRAQiHNNuYyxER/+8s
         53Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oYCNET7iFKziKZ1Ub0jaHIxttSr8miY2y9P2JjnTAOQ=;
        b=oW8M4u8NYoF/01VoFPU9ZaDFNgYKV2NmYBJbm/2uY7eh2uVRwCAZSrP2hMkbG2qgDx
         EMe6d58gbmLqC5aUy/xlaB87DHXaROyFv3tuyorSbAWXQU9ebT5UP65n19Wat8lvMolP
         1b1kWsDAyqnc0klGNajpQ1EfzzM4wEEeAzUJRHfOnjr4+bVG4WxCAb/4y67t2tt7Uobz
         teDNmqztEn+1WXZ//59W4CvHuf22PI2DvrGo1PJWbjKPDlvtKHsPN5RJ3t7HRXtJaAKu
         aBuwlzhhWjH9RkzhG7dwb/vt7qxvfOXATfe96+MHHZiXTen6+wi+fggSmv/+ESUSSJL0
         1yeA==
X-Gm-Message-State: AOAM5325UtvxkLPUBclArfVFsa/QKY7GJwCajMhaU2veQSszlOeJy2+K
        NwBXGutU+2yhBIXeIYG2pS7ZA210/NbbWw==
X-Google-Smtp-Source: ABdhPJwhk56PV2AzNO0GFI2ckguHJlizl2e31FFRtCGxReevhkoIGzf0dz0NFTO6HpeGmI7zTWBhaQ==
X-Received: by 2002:a17:90a:3183:: with SMTP id j3mr24132275pjb.228.1618834709290;
        Mon, 19 Apr 2021 05:18:29 -0700 (PDT)
Received: from localhost ([112.79.253.181])
        by smtp.gmail.com with ESMTPSA id r3sm10445994pfl.159.2021.04.19.05.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 05:18:29 -0700 (PDT)
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
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 2/4] libbpf: add helpers for preparing netlink attributes
Date:   Mon, 19 Apr 2021 17:48:09 +0530
Message-Id: <20210419121811.117400-3-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419121811.117400-1-memxor@gmail.com>
References: <20210419121811.117400-1-memxor@gmail.com>
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

