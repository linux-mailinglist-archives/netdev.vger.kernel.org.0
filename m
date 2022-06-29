Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2532560B23
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 22:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiF2Ugs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 16:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiF2Ugp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 16:36:45 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A053F3B28C
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 13:36:44 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v14so24154954wra.5
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 13:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uh25l/IFco/FD8J+cYVy+J2iIOHc7T8pp9VdIsWpzAg=;
        b=ien+f4LFgCja40NSqLyHWhVOv/7Wdfcavz4tlywtklkmXPhi34avqTB6f6ktZ0vPLj
         eCHxrOOZUkuLIF6Uok85efNCTlpaJ98azX6Qqxw2g8ZB7DI4LD27dAazuGsTqYZsZ6WK
         bnvRI5O9nlLZUN+KRlLegudtXPVNm5GwpL2k9ot8bMhqpc2cHeP6HOl7/InlN7jkutTF
         WK6Dkerk6pTneLMdyLRsGNBAG6LT2Y5fC/+ja0+rDva8xshsA1U9cPOp445kfly7lsZq
         sYFuGZcX1xmWWgSWepsTaTBTxh17ldY0nocaokRsg+/7lLzuVS1OPEdf/4hVnhYR03Ud
         ofEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uh25l/IFco/FD8J+cYVy+J2iIOHc7T8pp9VdIsWpzAg=;
        b=4fRcZ6u0zkm2KcID+Dt5a3APdUiUOGa/Ap3GABk3sdCFQDNwj/Ig01dcRqZ+JJW/wX
         9wlkph8r5Rkkwii0+6YmgyGkUGZxzH5hCmR02f3VLUwKyJvAYuBcJab9f+KNXMtQGDDH
         w9BL9FQ5SSekYIAuAMOR0DcaMlsI0MdEJdLZaRZlveA+Y21Co/lRaL4neApakefht5rf
         /cHOLK7b22a8bibMSDERpeBnlWIXzzB5JgyaaiqYOXVgcY1qtqoCGc9xsP+N4sl6oZZ1
         TMLTZdIczrxen92xyZCSVahrcIXjwULOFbTamjvfyvapPKQmxv+HXPd9U1mT+quMjyr2
         y7jA==
X-Gm-Message-State: AJIora+uH7VHrrzJs1GA6Fysl+R59j5n5F57z3INGhJIFP8DCozk1fYf
        mV6MV3wYJ72q0wjcU53s3pcfwQ==
X-Google-Smtp-Source: AGRyM1vVpwA30xKGQ6CowZhwLEKAGwXKAoHykqSixE3UeBRk1EDhTloDp+DL0Xg+fM1NzLODki8Y1g==
X-Received: by 2002:a5d:4102:0:b0:21b:8a6f:ff64 with SMTP id l2-20020a5d4102000000b0021b8a6fff64mr4954665wrp.186.1656535003108;
        Wed, 29 Jun 2022 13:36:43 -0700 (PDT)
Received: from harfang.fritz.box ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id l21-20020a05600c4f1500b003a02b9c47e4sm246986wmq.27.2022.06.29.13.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 13:36:42 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        =?UTF-8?q?Daniel=20M=C3=BCller?= <deso@posteo.net>
Subject: [PATCH bpf-next v2 2/2] bpftool: Use feature list in bash completion
Date:   Wed, 29 Jun 2022 21:36:37 +0100
Message-Id: <20220629203637.138944-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629203637.138944-1-quentin@isovalent.com>
References: <20220629203637.138944-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that bpftool is able to produce a list of known program, map, attach
types, let's use as much of this as we can in the bash completion file,
so that we don't have to expand the list each time a new type is added
to the kernel.

Also update the relevant test script to remove some checks that are no
longer needed.

Acked-by: Daniel Müller <deso@posteo.net>
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/bash-completion/bpftool     | 21 ++++---------------
 .../selftests/bpf/test_bpftool_synctypes.py   | 20 +++---------------
 2 files changed, 7 insertions(+), 34 deletions(-)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 9cef6516320b..ee177f83b179 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -703,15 +703,8 @@ _bpftool()
                             return 0
                             ;;
                         type)
-                            local BPFTOOL_MAP_CREATE_TYPES='hash array \
-                                prog_array perf_event_array percpu_hash \
-                                percpu_array stack_trace cgroup_array lru_hash \
-                                lru_percpu_hash lpm_trie array_of_maps \
-                                hash_of_maps devmap devmap_hash sockmap cpumap \
-                                xskmap sockhash cgroup_storage reuseport_sockarray \
-                                percpu_cgroup_storage queue stack sk_storage \
-                                struct_ops ringbuf inode_storage task_storage \
-                                bloom_filter'
+                            local BPFTOOL_MAP_CREATE_TYPES="$(bpftool feature list map_types | \
+                                grep -v '^unspec$')"
                             COMPREPLY=( $( compgen -W "$BPFTOOL_MAP_CREATE_TYPES" -- "$cur" ) )
                             return 0
                             ;;
@@ -1039,14 +1032,8 @@ _bpftool()
                     return 0
                     ;;
                 attach|detach)
-                    local BPFTOOL_CGROUP_ATTACH_TYPES='cgroup_inet_ingress cgroup_inet_egress \
-                        cgroup_inet_sock_create cgroup_sock_ops cgroup_device cgroup_inet4_bind \
-                        cgroup_inet6_bind cgroup_inet4_post_bind cgroup_inet6_post_bind \
-                        cgroup_inet4_connect cgroup_inet6_connect cgroup_inet4_getpeername \
-                        cgroup_inet6_getpeername cgroup_inet4_getsockname cgroup_inet6_getsockname \
-                        cgroup_udp4_sendmsg cgroup_udp6_sendmsg cgroup_udp4_recvmsg \
-                        cgroup_udp6_recvmsg cgroup_sysctl cgroup_getsockopt cgroup_setsockopt \
-                        cgroup_inet_sock_release'
+                    local BPFTOOL_CGROUP_ATTACH_TYPES="$(bpftool feature list attach_types | \
+                        grep '^cgroup_')"
                     local ATTACH_FLAGS='multi override'
                     local PROG_TYPE='id pinned tag name'
                     # Check for $prev = $command first
diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
index e443e6542cb9..a6410bebe603 100755
--- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
+++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
@@ -471,12 +471,6 @@ class BashcompExtractor(FileExtractor):
     def get_prog_attach_types(self):
         return self.get_bashcomp_list('BPFTOOL_PROG_ATTACH_TYPES')
 
-    def get_map_types(self):
-        return self.get_bashcomp_list('BPFTOOL_MAP_CREATE_TYPES')
-
-    def get_cgroup_attach_types(self):
-        return self.get_bashcomp_list('BPFTOOL_CGROUP_ATTACH_TYPES')
-
 def verify(first_set, second_set, message):
     """
     Print all values that differ between two sets.
@@ -516,17 +510,12 @@ def main():
     man_map_types = man_map_info.get_map_types()
     man_map_info.close()
 
-    bashcomp_info = BashcompExtractor()
-    bashcomp_map_types = bashcomp_info.get_map_types()
-
     verify(source_map_types, help_map_types,
             f'Comparing {BpfHeaderExtractor.filename} (bpf_map_type) and {MapFileExtractor.filename} (do_help() TYPE):')
     verify(source_map_types, man_map_types,
             f'Comparing {BpfHeaderExtractor.filename} (bpf_map_type) and {ManMapExtractor.filename} (TYPE):')
     verify(help_map_options, man_map_options,
             f'Comparing {MapFileExtractor.filename} (do_help() OPTIONS) and {ManMapExtractor.filename} (OPTIONS):')
-    verify(source_map_types, bashcomp_map_types,
-            f'Comparing {BpfHeaderExtractor.filename} (bpf_map_type) and {BashcompExtractor.filename} (BPFTOOL_MAP_CREATE_TYPES):')
 
     # Attach types (names)
 
@@ -542,8 +531,10 @@ def main():
     man_prog_attach_types = man_prog_info.get_attach_types()
     man_prog_info.close()
 
-    bashcomp_info.reset_read() # We stopped at map types, rewind
+
+    bashcomp_info = BashcompExtractor()
     bashcomp_prog_attach_types = bashcomp_info.get_prog_attach_types()
+    bashcomp_info.close()
 
     verify(source_prog_attach_types, help_prog_attach_types,
             f'Comparing {ProgFileExtractor.filename} (bpf_attach_type) and {ProgFileExtractor.filename} (do_help() ATTACH_TYPE):')
@@ -568,17 +559,12 @@ def main():
     man_cgroup_attach_types = man_cgroup_info.get_attach_types()
     man_cgroup_info.close()
 
-    bashcomp_cgroup_attach_types = bashcomp_info.get_cgroup_attach_types()
-    bashcomp_info.close()
-
     verify(source_cgroup_attach_types, help_cgroup_attach_types,
             f'Comparing {BpfHeaderExtractor.filename} (bpf_attach_type) and {CgroupFileExtractor.filename} (do_help() ATTACH_TYPE):')
     verify(source_cgroup_attach_types, man_cgroup_attach_types,
             f'Comparing {BpfHeaderExtractor.filename} (bpf_attach_type) and {ManCgroupExtractor.filename} (ATTACH_TYPE):')
     verify(help_cgroup_options, man_cgroup_options,
             f'Comparing {CgroupFileExtractor.filename} (do_help() OPTIONS) and {ManCgroupExtractor.filename} (OPTIONS):')
-    verify(source_cgroup_attach_types, bashcomp_cgroup_attach_types,
-            f'Comparing {BpfHeaderExtractor.filename} (bpf_attach_type) and {BashcompExtractor.filename} (BPFTOOL_CGROUP_ATTACH_TYPES):')
 
     # Options for remaining commands
 
-- 
2.34.1

