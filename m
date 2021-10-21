Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C72E436D12
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 23:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhJUVul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 17:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbhJUVuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 17:50:39 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2010FC061220
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 14:48:23 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id e22-20020a05620a209600b0045f81b8f89cso1553955qka.5
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 14:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cW6HnFPnxVttXYlllvO2YbONJSMhxty7Sc5+0SAjPIg=;
        b=Uf8N2xtiUTTxj5elT9l+huFFWdFpHJbgNJ0EDLkB0K7T/+lycEBdM2LktxKNA+vzzx
         /4bDUagGAO4WIgaL+Eb0cwKVE+CS12mNlslfZWfBYRCw0JjBc/Ps7YYmC5Sl+TtFnLSU
         CH5noujpIVXmTSeVDwxw7sKm4LDuLFsmVBtMK+EjvQLXQTlvmWOUUdMMgibm7YWb607U
         K179n8DPTh/M6VQkyA6OftRTXLgLz+e5merPtTMj8zkql10sDhIu/tPV5nTKfeyG6IiV
         8vhtd1Z/tNHwKqPSOCauK/IK6f5iipjmlO+DGJCZy7dIHEK4p7G+Ag7KT4eA9M99+eov
         arig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cW6HnFPnxVttXYlllvO2YbONJSMhxty7Sc5+0SAjPIg=;
        b=kxuCX2FEbvpwyaDLpKlrgpR3PNHzZ3mYXClNXwXucjtDSK+wy0euadPg6u0VeOXcbo
         HQqOauMoaw+7yxWGhG8NwcHMz25gFsbaoDSPOWYcppM6qff8s+3yy0+Oiy55GWa9nlR8
         GdMuK4PB/GVnSXo8mvnaRdsqSZ8WQexouPMsIYBfNeo4BIP00UqIY1f1jIZ3HpuAY+qp
         SoR353/yPjIe/omDFgC68ucR5QdpHoyorSB/dC1IXBMQAMqbLqwklg5Gc1q7A44wwQbx
         AZDMDHAckszUvDnlQQ59KahK3Nw+f9sjgPo7MdA/sj05Cn3tL6LXIXH9O+XxMNVSOhy8
         DdPw==
X-Gm-Message-State: AOAM530b7aazv7OtIxJyiVPusH3bG+ksV9PyX89NCvFn+r5o7C8oO65D
        WBYK8mkFTzfN4TA3jgmmcsuJtY3ioij4Hx14CMzLgxKQi8oWE8E+suDgjWXjbwsgcneiOBeJ1qK
        v9+myADZg7ZBNo32Zb4UA5N7/SuOeS7Z1YBUtBY0h86BTFC2Iz/Q/Kg==
X-Google-Smtp-Source: ABdhPJygZ++tBIeQt/qbDGPj5eCCyYRFRgt5CgblMeV3PeIympJX7Z+QDcqzu6+okqyvpjQ+Qh/7Xro=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:5d22:afc4:e329:550e])
 (user=sdf job=sendgmr) by 2002:ac8:5dc6:: with SMTP id e6mr9027978qtx.174.1634852902202;
 Thu, 21 Oct 2021 14:48:22 -0700 (PDT)
Date:   Thu, 21 Oct 2021 14:48:14 -0700
In-Reply-To: <20211021214814.1236114-1-sdf@google.com>
Message-Id: <20211021214814.1236114-4-sdf@google.com>
Mime-Version: 1.0
References: <20211021214814.1236114-1-sdf@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH bpf-next v5 3/3] selftests/bpf: fix flow dissector tests
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- update custom loader to search by name, not section name
- update bpftool commands to use proper pin path

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/flow_dissector_load.c        | 18 +++++++++++-------
 .../selftests/bpf/flow_dissector_load.h        | 10 ++--------
 .../selftests/bpf/test_flow_dissector.sh       | 10 +++++-----
 3 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/bpf/flow_dissector_load.c b/tools/testing/selftests/bpf/flow_dissector_load.c
index 3fd83b9dc1bf..87fd1aa323a9 100644
--- a/tools/testing/selftests/bpf/flow_dissector_load.c
+++ b/tools/testing/selftests/bpf/flow_dissector_load.c
@@ -17,7 +17,7 @@
 const char *cfg_pin_path = "/sys/fs/bpf/flow_dissector";
 const char *cfg_map_name = "jmp_table";
 bool cfg_attach = true;
-char *cfg_section_name;
+char *cfg_prog_name;
 char *cfg_path_name;
 
 static void load_and_attach_program(void)
@@ -25,7 +25,11 @@ static void load_and_attach_program(void)
 	int prog_fd, ret;
 	struct bpf_object *obj;
 
-	ret = bpf_flow_load(&obj, cfg_path_name, cfg_section_name,
+	ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+	if (ret)
+		error(1, 0, "failed to enable libbpf strict mode: %d", ret);
+
+	ret = bpf_flow_load(&obj, cfg_path_name, cfg_prog_name,
 			    cfg_map_name, NULL, &prog_fd, NULL);
 	if (ret)
 		error(1, 0, "bpf_flow_load %s", cfg_path_name);
@@ -75,15 +79,15 @@ static void parse_opts(int argc, char **argv)
 			break;
 		case 'p':
 			if (cfg_path_name)
-				error(1, 0, "only one prog name can be given");
+				error(1, 0, "only one path can be given");
 
 			cfg_path_name = optarg;
 			break;
 		case 's':
-			if (cfg_section_name)
-				error(1, 0, "only one section can be given");
+			if (cfg_prog_name)
+				error(1, 0, "only one prog can be given");
 
-			cfg_section_name = optarg;
+			cfg_prog_name = optarg;
 			break;
 		}
 	}
@@ -94,7 +98,7 @@ static void parse_opts(int argc, char **argv)
 	if (cfg_attach && !cfg_path_name)
 		error(1, 0, "must provide a path to the BPF program");
 
-	if (cfg_attach && !cfg_section_name)
+	if (cfg_attach && !cfg_prog_name)
 		error(1, 0, "must provide a section name");
 }
 
diff --git a/tools/testing/selftests/bpf/flow_dissector_load.h b/tools/testing/selftests/bpf/flow_dissector_load.h
index 7290401ec172..9d0acc2fc6cc 100644
--- a/tools/testing/selftests/bpf/flow_dissector_load.h
+++ b/tools/testing/selftests/bpf/flow_dissector_load.h
@@ -7,7 +7,7 @@
 
 static inline int bpf_flow_load(struct bpf_object **obj,
 				const char *path,
-				const char *section_name,
+				const char *prog_name,
 				const char *map_name,
 				const char *keys_map_name,
 				int *prog_fd,
@@ -23,13 +23,7 @@ static inline int bpf_flow_load(struct bpf_object **obj,
 	if (ret)
 		return ret;
 
-	main_prog = NULL;
-	bpf_object__for_each_program(prog, *obj) {
-		if (strcmp(section_name, bpf_program__section_name(prog)) == 0) {
-			main_prog = prog;
-			break;
-		}
-	}
+	main_prog = bpf_object__find_program_by_name(*obj, prog_name);
 	if (!main_prog)
 		return -1;
 
diff --git a/tools/testing/selftests/bpf/test_flow_dissector.sh b/tools/testing/selftests/bpf/test_flow_dissector.sh
index 174b72a64a4c..dbd91221727d 100755
--- a/tools/testing/selftests/bpf/test_flow_dissector.sh
+++ b/tools/testing/selftests/bpf/test_flow_dissector.sh
@@ -26,22 +26,22 @@ if [[ -z $(ip netns identify $$) ]]; then
 			type flow_dissector
 
 		if ! unshare --net $bpftool prog attach pinned \
-			/sys/fs/bpf/flow/flow_dissector flow_dissector; then
+			/sys/fs/bpf/flow/_dissect flow_dissector; then
 			echo "Unexpected unsuccessful attach in namespace" >&2
 			err=1
 		fi
 
-		$bpftool prog attach pinned /sys/fs/bpf/flow/flow_dissector \
+		$bpftool prog attach pinned /sys/fs/bpf/flow/_dissect \
 			flow_dissector
 
 		if unshare --net $bpftool prog attach pinned \
-			/sys/fs/bpf/flow/flow_dissector flow_dissector; then
+			/sys/fs/bpf/flow/_dissect flow_dissector; then
 			echo "Unexpected successful attach in namespace" >&2
 			err=1
 		fi
 
 		if ! $bpftool prog detach pinned \
-			/sys/fs/bpf/flow/flow_dissector flow_dissector; then
+			/sys/fs/bpf/flow/_dissect flow_dissector; then
 			echo "Failed to detach flow dissector" >&2
 			err=1
 		fi
@@ -95,7 +95,7 @@ else
 fi
 
 # Attach BPF program
-./flow_dissector_load -p bpf_flow.o -s flow_dissector
+./flow_dissector_load -p bpf_flow.o -s _dissect
 
 # Setup
 tc qdisc add dev lo ingress
-- 
2.33.0.1079.g6e70778dc9-goog

