Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCFB53AD7A6
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 06:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhFSESm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 00:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbhFSESl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 00:18:41 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2840C061574;
        Fri, 18 Jun 2021 21:16:30 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id h12so5695333plf.4;
        Fri, 18 Jun 2021 21:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WmdWVzUm/J9xuwe+NGxrSPuLF8TCRL8+mXZhaNlPwOs=;
        b=NuCh6EMgDKDJnOXm3thkw4Pgv6aVu2rGuqs9NVUOZ4Fj2CP8jTFcWmPe0tRomYLL8l
         gowbPB1dyvVANgAt5lmnjyOBigdCpmrpxZZ+k3Tsvpc8iJdBNhXITa+J0bud9iZ+fWeX
         rPv+dF6Ec/44s5xgU1WJs1R8jmp5JAJKsFrdHqfI76Kx0vcJ08I7kIUldkIUaAA1wOJD
         Om2axzkh5n2kMcSFiahNjrhZeQ+5Vz9EdbzYSbVqVPXK2HZi84yPGXj27D/Gq+z3Yify
         vel+RKVQVpTW237u7vySRSHhV2cYZAj34SedyXjEhMDYPWO0JQOd/Vr16ZMfvSrQjIXA
         f7iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WmdWVzUm/J9xuwe+NGxrSPuLF8TCRL8+mXZhaNlPwOs=;
        b=PyrfMOXfiGVp2J55+3CvNp3EEI0e1KtLUWklIIjCPGzLO0McmHYMi8RLN5CMiQqLEB
         vyB0so7OP8H4OX7P3IkVapvQx4WzE6jYK2Vo1vdQ+J4yB+aQ5B3cB6AnokbB3nMEgq8Q
         dliCxt/He3FG4RX83e7ebKie2pfXrud0om9r8EtXUoGGRHbfnkGIuSJoEv3GkmrjDI6M
         BI58eU1pEsEdPmeoEt4YWn6cmhY+2FJ6k/4eP2ILJb9SQM7+pZblNp/ub5dy+3cYP3z+
         /tCreMoaOflYSauXBX6Oo3lLclADa1as9sXtts3gDp1zNH1rxEgf4Guc0m6SRp/kO8HL
         B7uw==
X-Gm-Message-State: AOAM530aAyBjtbHI8N7XxYpae9aZ9BoQCnxkAyW6VOqn/Qhl71ln5GJO
        kdecz1zVADBpfJL2Ci9MUnPxvlIqDlY=
X-Google-Smtp-Source: ABdhPJyD7xKTHuxXx38tPfBKRJRC9X8cqBkikkL7gkm6UdFx7eL6NW+xqZhWpf5o0YTR46VmIsBMcA==
X-Received: by 2002:a17:903:228e:b029:112:5e2f:bbf5 with SMTP id b14-20020a170903228eb02901125e2fbbf5mr7836638plh.30.1624076190353;
        Fri, 18 Jun 2021 21:16:30 -0700 (PDT)
Received: from localhost ([2402:3a80:11d2:e222:9de7:3308:6c84:b170])
        by smtp.gmail.com with ESMTPSA id p45sm2708742pfw.19.2021.06.18.21.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 21:16:30 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 2/2] libbpf: netlink: switch to void * casting
Date:   Sat, 19 Jun 2021 09:44:54 +0530
Message-Id: <20210619041454.417577-2-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210619041454.417577-1-memxor@gmail.com>
References: <20210619041454.417577-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netlink helpers I added in 8bbb77b7c7a2 ("libbpf: Add various netlink
helpers") used char * casts everywhere, and there were a few more that
existed from before.

Convert all of them to void * cast, as it is treated equivalently by
clang/gcc for the purposes of pointer arithmetic and to follow the
convention elsewhere in the kernel/libbpf.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/netlink.c | 2 +-
 tools/lib/bpf/nlattr.c  | 2 +-
 tools/lib/bpf/nlattr.h  | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index a17470045455..7b9821d0d70a 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -524,7 +524,7 @@ static int get_tc_info(struct nlmsghdr *nh, libbpf_dump_nlmsg_t fn,
 	struct nlattr *tb[TCA_MAX + 1];
 
 	libbpf_nla_parse(tb, TCA_MAX,
-			 (struct nlattr *)((char *)tc + NLMSG_ALIGN(sizeof(*tc))),
+			 (struct nlattr *)((void *)tc + NLMSG_ALIGN(sizeof(*tc))),
 			 NLMSG_PAYLOAD(nh, sizeof(*tc)), NULL);
 	if (!tb[TCA_KIND])
 		return NL_CONT;
diff --git a/tools/lib/bpf/nlattr.c b/tools/lib/bpf/nlattr.c
index b607fa9852b1..f57e77a6e40f 100644
--- a/tools/lib/bpf/nlattr.c
+++ b/tools/lib/bpf/nlattr.c
@@ -27,7 +27,7 @@ static struct nlattr *nla_next(const struct nlattr *nla, int *remaining)
 	int totlen = NLA_ALIGN(nla->nla_len);
 
 	*remaining -= totlen;
-	return (struct nlattr *) ((char *) nla + totlen);
+	return (struct nlattr *)((void *)nla + totlen);
 }
 
 static int nla_ok(const struct nlattr *nla, int remaining)
diff --git a/tools/lib/bpf/nlattr.h b/tools/lib/bpf/nlattr.h
index 76cbfeb21955..4d15ae2ff812 100644
--- a/tools/lib/bpf/nlattr.h
+++ b/tools/lib/bpf/nlattr.h
@@ -81,7 +81,7 @@ struct libbpf_nla_req {
  */
 static inline void *libbpf_nla_data(const struct nlattr *nla)
 {
-	return (char *) nla + NLA_HDRLEN;
+	return (void *)nla + NLA_HDRLEN;
 }
 
 static inline uint8_t libbpf_nla_getattr_u8(const struct nlattr *nla)
@@ -118,12 +118,12 @@ int libbpf_nla_dump_errormsg(struct nlmsghdr *nlh);
 
 static inline struct nlattr *nla_data(struct nlattr *nla)
 {
-	return (struct nlattr *)((char *)nla + NLA_HDRLEN);
+	return (struct nlattr *)((void *)nla + NLA_HDRLEN);
 }
 
 static inline struct nlattr *req_tail(struct libbpf_nla_req *req)
 {
-	return (struct nlattr *)((char *)req + NLMSG_ALIGN(req->nh.nlmsg_len));
+	return (struct nlattr *)((void *)req + NLMSG_ALIGN(req->nh.nlmsg_len));
 }
 
 static inline int nlattr_add(struct libbpf_nla_req *req, int type,
@@ -158,7 +158,7 @@ static inline struct nlattr *nlattr_begin_nested(struct libbpf_nla_req *req, int
 static inline void nlattr_end_nested(struct libbpf_nla_req *req,
 				     struct nlattr *tail)
 {
-	tail->nla_len = (char *)req_tail(req) - (char *)tail;
+	tail->nla_len = (void *)req_tail(req) - (void *)tail;
 }
 
 #endif /* __LIBBPF_NLATTR_H */
-- 
2.31.1

