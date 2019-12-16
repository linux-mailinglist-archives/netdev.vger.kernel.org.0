Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C242712168D
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 19:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731036AbfLPSM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 13:12:58 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50613 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731020AbfLPSMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 13:12:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576519972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gG9VGGPZ6c4OJ26G78LddjiW5k2zffvrFpUIDfVi4Vk=;
        b=Y6TgoFJgie0z9PfGfxZLFAEXdLzmj6aet1YGS2ujJjAOyh72JNWG8XaFMMRfrw1AMLLa80
        +KBcvZ/syPDgE9fslnbVfgmEGq8VVS6k4dFWktQje+oSW8FhxKwRBMWLmriWG587zre8o3
        ck8/mfYeS2arf6FiZALjAKeuZs7pMs8=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-8RK8CSu0P9-6k1zFwvIl5Q-1; Mon, 16 Dec 2019 13:12:49 -0500
X-MC-Unique: 8RK8CSu0P9-6k1zFwvIl5Q-1
Received: by mail-lf1-f69.google.com with SMTP id v10so677324lfa.14
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 10:12:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gG9VGGPZ6c4OJ26G78LddjiW5k2zffvrFpUIDfVi4Vk=;
        b=g1p3XpSUksEuTOktgYOKlMLIK+Rl8Zl1R4ua5VntFoi9eEmPFfHQeaJ4ro6OuWTTIS
         5UBgbfJZ8Ez2PlxNYR4pcORGsrgI95HP4O8L+T5Bg8WkhgBa9t2SFfIkFmF0+y00LuJ3
         rM3zX72bAviHRnyOb6ZdAaHPNjRt1B0KS9KeynDJexjSbBwyr5abY0QQPdIhbIg3HbYJ
         eZF+IT0ibRGEFOgHeZEU64eI78yzv/yaOBf8Mb+BRu6SBquBdyyc3Qfle8sQ4oOaW0sr
         rEhKavitSQgvRuAbt/QeEBzGBLU5S+W/jJ55R5sD8wszOt8khO9EibIJkANvKvEMCSzK
         p70Q==
X-Gm-Message-State: APjAAAXOJZdO4Hd1DkEm4ovx2CNss/7h2X1y27dLbTnuXxZyhSlpn/2a
        yuUFyOUO5TnAm8wvbf94hAQNyPfOZbd0QpfTbo3EcqnH3U2BicRGlHrMvjWN70huvjYfbw+1G2V
        lNn7a+bPbZaQ0inD7
X-Received: by 2002:a2e:8797:: with SMTP id n23mr298315lji.176.1576519967825;
        Mon, 16 Dec 2019 10:12:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqzib2wPbukcLs24+rc6P5JH52a4OsCYyY8YkGjR2Epph9CQfUt9aPxH1qqr+PIhM8j16xM9cw==
X-Received: by 2002:a2e:8797:: with SMTP id n23mr298286lji.176.1576519967369;
        Mon, 16 Dec 2019 10:12:47 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q25sm11160992lji.7.2019.12.16.10.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 10:12:46 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CDDF7180960; Mon, 16 Dec 2019 19:12:45 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next v2] libbpf: Print hint about ulimit when getting permission denied error
Date:   Mon, 16 Dec 2019 19:12:04 +0100
Message-Id: <20191216181204.724953-1-toke@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Probably the single most common error newcomers to XDP are stumped by is
the 'permission denied' error they get when trying to load their program
and 'ulimit -l' is set too low. For examples, see [0], [1].

Since the error code is UAPI, we can't change that. Instead, this patch
adds a few heuristics in libbpf and outputs an additional hint if they are
met: If an EPERM is returned on map create or program load, and geteuid()
shows we are root, and the current RLIMIT_MEMLOCK is not infinity, we
output a hint about raising 'ulimit -l' as an additional log line.

[0] https://marc.info/?l=xdp-newbies&m=157043612505624&w=2
[1] https://github.com/xdp-project/xdp-tutorial/issues/86

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
v2:
  - Format current output as KiB/MiB
  - It's ulimit -l, not ulimit -r
  
 tools/lib/bpf/libbpf.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a2cc7313763a..3fe42d6b0c2f 100644
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
@@ -100,6 +101,32 @@ void libbpf_print(enum libbpf_print_level level, const char *format, ...)
 	va_end(args);
 }
 
+static void pr_perm_msg(int err)
+{
+	struct rlimit limit;
+	char buf[100];
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
+	if (limit.rlim_cur < 1024)
+		snprintf(buf, sizeof(buf), "%lu bytes", limit.rlim_cur);
+	else if (limit.rlim_cur < 1024*1024)
+		snprintf(buf, sizeof(buf), "%.1f KiB", (double)limit.rlim_cur / 1024);
+	else
+		snprintf(buf, sizeof(buf), "%.1f MiB", (double)limit.rlim_cur / (1024*1024));
+
+	pr_warn("permission error while running as root; try raising 'ulimit -l'? current value: %s\n",
+		buf);
+}
+
 #define STRERR_BUFSIZE  128
 
 /* Copied from tools/perf/util/util.h */
@@ -2983,6 +3010,7 @@ bpf_object__create_maps(struct bpf_object *obj)
 			cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
 			pr_warn("failed to create map (name: '%s'): %s(%d)\n",
 				map->name, cp, err);
+			pr_perm_msg(err);
 			for (j = 0; j < i; j++)
 				zclose(obj->maps[j].fd);
 			return err;
@@ -4381,6 +4409,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	ret = -errno;
 	cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
 	pr_warn("load bpf program failed: %s\n", cp);
+	pr_perm_msg(ret);
 
 	if (log_buf && log_buf[0] != '\0') {
 		ret = -LIBBPF_ERRNO__VERIFY;
-- 
2.24.1

