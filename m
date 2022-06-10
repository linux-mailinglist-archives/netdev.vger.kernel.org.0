Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55035546587
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 13:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244645AbiFJL1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 07:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244938AbiFJL1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 07:27:00 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0260422AE54
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 04:26:54 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id k16so36124688wrg.7
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 04:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z6pm2qCe57m4cj/i6Nw8fuyY87mpFyZBWCzSGpujiLA=;
        b=lms9GXo5N9JJ11khW/qYk7zkpRchFwIzIneT5oYb7D1yIp0BYYK5QLRsgQ0j4HiHAI
         BlIuWRGd7f/ZBQqG1gW/Pfha8G+chJZYmXR2h0Cxfbzn2RcVqLoiopS2AULTpvreqQ2m
         qM6bIuXSU+HqcRVTQkwCTlHU3U6MfhhQcq5ZocKMB7oyGEqgJeALKLxRyugMCVDFD5Mc
         BrvRcpD39NB4R3QOPnNmAQCZoR3fB/jjQXSu7jJsqgmWA+zwKOk3yVkyz6yCFEM7SNQ+
         xX4dabswsxc3v6gE2HLwLCCb7L8eJaSUGyy+QlZUWmZvH0HX4Dh8G3hOsPsYCHME7lqw
         tmrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z6pm2qCe57m4cj/i6Nw8fuyY87mpFyZBWCzSGpujiLA=;
        b=6MIexgtLKNnZTGwzwheSzbFMcJvH2CCkMAzeQouLiebscrA9RwBoPizgKfwaXT1IHA
         6YhClpniJF7+hVD8Gt2Z8Udo2lBkPk67VxHmqJiOmE7Feo+jYrqOjHkv7p0o0LugAzaC
         h0ZSfsuTqjMuFUl6ye5iAlG7vZOIlYdP6Dv2AJOtpHm7WD8BoUQgKJZUjyfjb7cx2x4s
         jJnQL88A9IhoGSR23ER3VVNWNGmuqiHrM7GRL/FO+QyXhDZDVhpBLJLkkJ/SCem9YSU1
         2Q8R6uTirGY53obIvt8d6TyxQjTOFR4rBu+8/8faKMEoGL5drKIkH6D4r+OBkAly+OxG
         Hw+w==
X-Gm-Message-State: AOAM532bB/E3sF+gUg9FriBK+tX8SqduGTlkArRKFe2f7DmxteWiUZEZ
        GC8uTM6/ZGnzxamfC8rKyLDqZ3xwdUpT7cSAOiU=
X-Google-Smtp-Source: ABdhPJzSw/2MhXzYSoxgWqS7s/ttSDfOsMI+GVLnDda/7tKR+QcViqT6OquUpH9+OtgviLweWVn8sg==
X-Received: by 2002:a5d:56d2:0:b0:212:9250:e18b with SMTP id m18-20020a5d56d2000000b002129250e18bmr41608173wrw.672.1654860413254;
        Fri, 10 Jun 2022 04:26:53 -0700 (PDT)
Received: from harfang.fritz.box ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id z2-20020adff1c2000000b0020c5253d8dcsm25893202wro.40.2022.06.10.04.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 04:26:52 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>,
        Harsh Modi <harshmodi@google.com>,
        Paul Chaignon <paul@cilium.io>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 1/2] Revert "bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK"
Date:   Fri, 10 Jun 2022 12:26:47 +0100
Message-Id: <20220610112648.29695-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610112648.29695-1-quentin@isovalent.com>
References: <20220610112648.29695-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit a777e18f1bcd32528ff5dfd10a6629b655b05eb8.

In commit a777e18f1bcd ("bpftool: Use libbpf 1.0 API mode instead of
RLIMIT_MEMLOCK"), we removed the rlimit bump in bpftool, because the
kernel has switched to memcg-based memory accounting. Thanks to the
LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK, we attempted to keep compatibility
with other systems and ask libbpf to raise the limit for us if
necessary.

How do we know if memcg-based accounting is supported? There is a probe
in libbpf to check this. But this probe currently relies on the
availability of a given BPF helper, bpf_ktime_get_coarse_ns(), which
landed in the same kernel version as the memory accounting change. This
works in the generic case, but it may fail, for example, if the helper
function has been backported to an older kernel. This has been observed
for Google Cloud's Container-Optimized OS (COS), where the helper is
available but rlimit is still in use. The probe succeeds, the rlimit is
not raised, and probing features with bpftool, for example, fails.

A patch was submitted [0] to update this probe in libbpf, based on what
the cilium/ebpf Go library does [1]. It would lower the soft rlimit to
0, attempt to load a BPF object, and reset the rlimit. But it may induce
some hard-to-debug flakiness if another process starts, or the current
application is killed, while the rlimit is reduced, and the approach was
discarded.

As a workaround to ensure that the rlimit bump does not depend on the
availability of a given helper, we restore the unconditional rlimit bump
in bpftool for now.

[0] https://lore.kernel.org/bpf/20220609143614.97837-1-quentin@isovalent.com/
[1] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39

Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/common.c     | 8 ++++++++
 tools/bpf/bpftool/feature.c    | 2 ++
 tools/bpf/bpftool/main.c       | 6 +++---
 tools/bpf/bpftool/main.h       | 2 ++
 tools/bpf/bpftool/map.c        | 2 ++
 tools/bpf/bpftool/pids.c       | 1 +
 tools/bpf/bpftool/prog.c       | 3 +++
 tools/bpf/bpftool/struct_ops.c | 2 ++
 8 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index a45b42ee8ab0..a0d4acd7c54a 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -17,6 +17,7 @@
 #include <linux/magic.h>
 #include <net/if.h>
 #include <sys/mount.h>
+#include <sys/resource.h>
 #include <sys/stat.h>
 #include <sys/vfs.h>
 
@@ -72,6 +73,13 @@ static bool is_bpffs(char *path)
 	return (unsigned long)st_fs.f_type == BPF_FS_MAGIC;
 }
 
+void set_max_rlimit(void)
+{
+	struct rlimit rinf = { RLIM_INFINITY, RLIM_INFINITY };
+
+	setrlimit(RLIMIT_MEMLOCK, &rinf);
+}
+
 static int
 mnt_fs(const char *target, const char *type, char *buff, size_t bufflen)
 {
diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index cc9e4df8c58e..bac4ef428a02 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -1167,6 +1167,8 @@ static int do_probe(int argc, char **argv)
 	__u32 ifindex = 0;
 	char *ifname;
 
+	set_max_rlimit();
+
 	while (argc) {
 		if (is_prefix(*argv, "kernel")) {
 			if (target != COMPONENT_UNSPEC) {
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 9062ef2b8767..e81227761f5d 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -507,9 +507,9 @@ int main(int argc, char **argv)
 		 * It will still be rejected if users use LIBBPF_STRICT_ALL
 		 * mode for loading generated skeleton.
 		 */
-		libbpf_set_strict_mode(LIBBPF_STRICT_ALL & ~LIBBPF_STRICT_MAP_DEFINITIONS);
-	} else {
-		libbpf_set_strict_mode(LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK);
+		ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL & ~LIBBPF_STRICT_MAP_DEFINITIONS);
+		if (ret)
+			p_err("failed to enable libbpf strict mode: %d", ret);
 	}
 
 	argc -= optind;
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 6c311f47147e..589cb76b227a 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -96,6 +96,8 @@ int detect_common_prefix(const char *arg, ...);
 void fprint_hex(FILE *f, void *arg, unsigned int n, const char *sep);
 void usage(void) __noreturn;
 
+void set_max_rlimit(void);
+
 int mount_tracefs(const char *target);
 
 struct obj_ref {
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 800834be1bcb..38b6bc9c26c3 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -1326,6 +1326,8 @@ static int do_create(int argc, char **argv)
 		goto exit;
 	}
 
+	set_max_rlimit();
+
 	fd = bpf_map_create(map_type, map_name, key_size, value_size, max_entries, &attr);
 	if (fd < 0) {
 		p_err("map create failed: %s", strerror(errno));
diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
index e2d00d3cd868..bb6c969a114a 100644
--- a/tools/bpf/bpftool/pids.c
+++ b/tools/bpf/bpftool/pids.c
@@ -108,6 +108,7 @@ int build_obj_refs_table(struct hashmap **map, enum bpf_obj_type type)
 		p_err("failed to create hashmap for PID references");
 		return -1;
 	}
+	set_max_rlimit();
 
 	skel = pid_iter_bpf__open();
 	if (!skel) {
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index e71f0b2da50b..f081de398b60 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1590,6 +1590,8 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 		}
 	}
 
+	set_max_rlimit();
+
 	if (verifier_logs)
 		/* log_level1 + log_level2 + stats, but not stable UAPI */
 		open_opts.kernel_log_level = 1 + 2 + 4;
@@ -2287,6 +2289,7 @@ static int do_profile(int argc, char **argv)
 		}
 	}
 
+	set_max_rlimit();
 	err = profiler_bpf__load(profile_obj);
 	if (err) {
 		p_err("failed to load profile_obj");
diff --git a/tools/bpf/bpftool/struct_ops.c b/tools/bpf/bpftool/struct_ops.c
index 2535f079ed67..e08a6ff2866c 100644
--- a/tools/bpf/bpftool/struct_ops.c
+++ b/tools/bpf/bpftool/struct_ops.c
@@ -501,6 +501,8 @@ static int do_register(int argc, char **argv)
 	if (libbpf_get_error(obj))
 		return -1;
 
+	set_max_rlimit();
+
 	if (bpf_object__load(obj)) {
 		bpf_object__close(obj);
 		return -1;
-- 
2.34.1

