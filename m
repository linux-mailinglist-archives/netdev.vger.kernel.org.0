Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD38F1205FA
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 13:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfLPMk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 07:40:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35590 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727512AbfLPMk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 07:40:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576500055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ga25dRd639NpZwMHra87nl2NBkSSmC+ikkph5ObqM3A=;
        b=TipOKZQpdr89QcwvBmJCoTQzljKUYf1RkItRZTSSLjfwRMEa7PR1htIfQDTmsCqv+2YUQL
        X0Sb5M8Xt9YRnLQAq0AEwdJDfASE3FkfoGuBJ9LlDl755X8OPo7eIRL9uz7zWe0kZMusdT
        A7AMAaKWVDVwj4lwh79H+cfFilermwY=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-SQWfP_kSNcGnJPuTaRFjrA-1; Mon, 16 Dec 2019 07:40:50 -0500
X-MC-Unique: SQWfP_kSNcGnJPuTaRFjrA-1
Received: by mail-lj1-f199.google.com with SMTP id g16so2087626ljj.12
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 04:40:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ga25dRd639NpZwMHra87nl2NBkSSmC+ikkph5ObqM3A=;
        b=LfYGoH4YY/9OeGsh81wdM/GQS+Rdrtum9mi5OP2jcQxeE2927KAlFBDZ+NdRjLhwv4
         yHjCb7JKiN+8WvZVQs9GerayaPMbPN3dOJJybN6HPtzzahz8KtL7J0e0xLx21AnKVAYF
         e4s9O75foXvsiH8xnBosfSqwJWobYIL3y+mROOzDJeYG+MEjptX9mly590YPkEhemOa8
         ySa4ykKnX12kiGmdMwOpb1CUn8fUmI0Yc/SwBo+3eh/ZbWBOVeUH3KMyIfzbYYaIjwP6
         tgq8tpkF2/nXrW9V0O9IUTinY5Yy4nQR/o4Gq1eGbmqoTNvvqfIDMBcaAToAqiPq9GPu
         A+0Q==
X-Gm-Message-State: APjAAAUxtm63t2UJytVBBKCHtNr9acaKGKo9Sbf3is8/Qdmqh9hLJwtw
        ixXY+jmbu53GL3P2fP2q1UmSnxLPeXfpmTO59frob7pSpsXimcqjedXSXaz7CSmmpf1haPLJvRJ
        83ve9x2TpZtJ1j/BT
X-Received: by 2002:a19:4208:: with SMTP id p8mr16045227lfa.160.1576500048043;
        Mon, 16 Dec 2019 04:40:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqyRG7zZhx/Z8Qe2lgFK3QowY1/YYgxsIUndMH11wegrireBYpr4pLUe9RKZYXJOgXBEjJEi5w==
X-Received: by 2002:a19:4208:: with SMTP id p8mr16045214lfa.160.1576500047842;
        Mon, 16 Dec 2019 04:40:47 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id u13sm8839046lfq.19.2019.12.16.04.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 04:40:46 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2436D1819EB; Mon, 16 Dec 2019 13:40:46 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH bpf-next] libbpf: Print hint about ulimit when getting permission denied error
Date:   Mon, 16 Dec 2019 13:40:31 +0100
Message-Id: <20191216124031.371482-1-toke@redhat.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Probably the single most common error newcomers to XDP are stumped by is
the 'permission denied' error they get when trying to load their program
and 'ulimit -r' is set too low. For examples, see [0], [1].

Since the error code is UAPI, we can't change that. Instead, this patch
adds a few heuristics in libbpf and outputs an additional hint if they are
met: If an EPERM is returned on map create or program load, and geteuid()
shows we are root, and the current RLIMIT_MEMLOCK is not infinity, we
output a hint about raising 'ulimit -r' as an additional log line.

[0] https://marc.info/?l=xdp-newbies&m=157043612505624&w=2
[1] https://github.com/xdp-project/xdp-tutorial/issues/86

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a2cc7313763a..aec7995674d2 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -41,6 +41,7 @@
 #include <sys/types.h>
 #include <sys/vfs.h>
 #include <sys/utsname.h>
+#include <sys/resource.h>
 #include <tools/libc_compat.h>
 #include <libelf.h>
 #include <gelf.h>
@@ -100,6 +101,24 @@ void libbpf_print(enum libbpf_print_level level, const char *format, ...)
 	va_end(args);
 }
 
+static void pr_perm_msg(int err)
+{
+	struct rlimit limit;
+
+	if (err != -EPERM || geteuid() != 0)
+		return;
+
+	err = getrlimit(RLIMIT_MEMLOCK, &limit);
+	if (err)
+		return;
+
+	if (limit.rlim_cur == RLIM_INFINITY)
+		return;
+
+	pr_warn("permission error while running as root; try raising 'ulimit -r'? current value: %lu\n",
+		limit.rlim_cur);
+}
+
 #define STRERR_BUFSIZE  128
 
 /* Copied from tools/perf/util/util.h */
@@ -2983,6 +3002,7 @@ bpf_object__create_maps(struct bpf_object *obj)
 			cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
 			pr_warn("failed to create map (name: '%s'): %s(%d)\n",
 				map->name, cp, err);
+			pr_perm_msg(err);
 			for (j = 0; j < i; j++)
 				zclose(obj->maps[j].fd);
 			return err;
@@ -4381,6 +4401,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	ret = -errno;
 	cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
 	pr_warn("load bpf program failed: %s\n", cp);
+	pr_perm_msg(ret);
 
 	if (log_buf && log_buf[0] != '\0') {
 		ret = -LIBBPF_ERRNO__VERIFY;
-- 
2.24.0

