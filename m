Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84CB8560354
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbiF2Okg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbiF2Okb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:40:31 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4511137020
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 07:40:30 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id o16so22841094wra.4
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 07:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9FOYmeRqmEoW2/yig11rWwWtWs0HE6T9aKmY5zyVAOM=;
        b=gRWmmR+E7niwB9Tc8IO2UekKW5HrRiKXUnWERFfjYelcUuYoiHkmtHJkt1hpIM1D9M
         AwOi5dd/M2rG2Gm9tiDd31EMILVznEOGWKfrG+areWTvsfsxat5H5eBt70MGXXclxv8/
         HuJalQJIpgaKGQeJ596E90U15iwBAadB15vCMEEoe2jvF2CsdTCQRAnzMIngIiIFmPFR
         9kHBQqDD1MEvSGCgAMt1XT26MTnFMOuWtXbAJEmvL+gB7C7KoCbWq+EF8rU/2wVuW3GP
         g7wwXZvnIDRhqpOtb1Fr8F9Nim+4yRGItOasV5FE3yaT8h082BTa73knICy9IbR/L7r4
         ql4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9FOYmeRqmEoW2/yig11rWwWtWs0HE6T9aKmY5zyVAOM=;
        b=R1NmTEkYei9RERKazY0xPsVKOIlXNn8rxRgQRAQbc5fsPl1PdDYWZMaeOiEEiBk1TF
         yfIm5eaaq+Dhf6VpqFEOqBDLPxLq7A+v2tiyd/3368guAAMdBEKXUcxyxOTbVO1QHW01
         8PfN5px4if+wnqcSRONbY0SN3Fw+a8ZG+gxtBepJO59cZVteQ+tTGKiwb1/w/vH3MLFp
         wpwtX2O5sMywMMV+LA6aAuURZ1bOg6JDEdUlAyb5ujf+vrNiwd7sIE7hRUM8pN5ofqdv
         QRjsdCAKsMT88qKgYil0eiRUWwo5Ow/DTse82NkDbz4ZRIpt+GmH0Mfpsd1tk3ZmX9IP
         zMLg==
X-Gm-Message-State: AJIora8KAWNpX3+aX0lxiZGgxN89YT034mQYALhTf/NxFHW3pjqnzW27
        8Wj+/IC1OPrZB54wylaoUUv2dQ==
X-Google-Smtp-Source: AGRyM1sf1NniE8+WCB9DyNmkAbGZVIplracW3WM2R6hQItH6qhnsPws1rXqweY1l1LpbwqTPXLXy0Q==
X-Received: by 2002:a05:6000:2ab:b0:21d:221c:20e5 with SMTP id l11-20020a05600002ab00b0021d221c20e5mr3420211wry.523.1656513628768;
        Wed, 29 Jun 2022 07:40:28 -0700 (PDT)
Received: from harfang.fritz.box ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id h13-20020adff4cd000000b002103aebe8absm16770518wrp.93.2022.06.29.07.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 07:40:28 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 2/2] bpftool: Use feature list in bash completion
Date:   Wed, 29 Jun 2022 15:40:19 +0100
Message-Id: <20220629144019.75181-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629144019.75181-1-quentin@isovalent.com>
References: <20220629144019.75181-1-quentin@isovalent.com>
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

Now that bpftool is able to produce a list of known program, map, attach
types, let's use as much of this as we can in the bash completion file,
so that we don't have to expand the list each time a new type is added
to the kernel.

Also update the relevant test script to remove some checks that are no
longer needed.

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

