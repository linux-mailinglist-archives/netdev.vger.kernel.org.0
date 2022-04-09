Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFE54FA7DA
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 15:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241801AbiDINCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 09:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239639AbiDINCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 09:02:22 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FDC9FDF;
        Sat,  9 Apr 2022 06:00:13 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id s10so2674306plg.9;
        Sat, 09 Apr 2022 06:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F7LUFaM7CJwJkSBwyKn6zfFxnpwJ548z4LUqbTmzSaY=;
        b=GJRNkmqIyPrDxT6K87jg0Out6qefkedOIXYNJoTKmDk9YFgr6WLolS666hzOrpxONv
         GEiiPMUA8nCLbaB+5EhXkQx07TvMeEQdhf+E2B2fXuF8JRPEUFSKIY8qQbvNoV5Swalp
         xhNn8o4MJI1GUXsI9Ww3DoDU7X5iNQwkR+9BrUAWQYVCeP0/UMmfmAw+sprOeNIAMmxT
         rsiYAQLxOdSkX2U20OMPFR8r3d4Rq+Cwr4RE0EPBTsiKHVxddA+sr0oIpSPUsv97SC+O
         QmMsk3Y7Io41mlF9hRrwigJHRJYlT5+o9WYvKir8Ow7mgw9V9Mvf/P0muHAoBmlm6YB8
         7dug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F7LUFaM7CJwJkSBwyKn6zfFxnpwJ548z4LUqbTmzSaY=;
        b=wOs/8ApjwTexqhPXbUcD2KXOtBOtgD05vMR1kUhUe2BLK5o028pMFmVgm8gmmBfU/0
         iRHj7EJT64GICJfoJNdGdTKB7dFWywsAtknahR0xhJRiXGt2Z20sgKykzP35KblMP+dt
         ppcFBsPjCGWag5ADvEEoaHVODQvAUM5N2pf/XsTu4brUKCuNjS5kEmzS1F4tdn1gHXvj
         pUmgpjO0J2c7XhvAVUK+GpF5i9ieo+I0n1KhFTu/OjPUrn0Xht6s5sG1VyRBow/NavAq
         PmbBdpp1+UKlZfNmYzuMpiusFpbOXOpWR4cZqkCX9Mmt/f9gfps+/NYzWB6MIR3lOibO
         S/Uw==
X-Gm-Message-State: AOAM533ZajHJ0UaKfHKji4Nvix9AOR6RimexTiVfswWKy6z+MX1ujd5T
        xupPFbSwHkhv/0ZVQVg+KAVaoE8Ud5Zap1dR
X-Google-Smtp-Source: ABdhPJzS87X12xiPKpWO03zJMIG3LjIGsP2RZTod8XaK9yjkTXrZ9m94BrLZRbSjpvG11BuiNqaI0g==
X-Received: by 2002:a17:902:9304:b0:155:eb5a:8dd4 with SMTP id bc4-20020a170902930400b00155eb5a8dd4mr24196345plb.117.1649509212695;
        Sat, 09 Apr 2022 06:00:12 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:5271:5400:3ff:feef:3aee])
        by smtp.gmail.com with ESMTPSA id s10-20020a63a30a000000b003987eaef296sm24671871pge.44.2022.04.09.06.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 06:00:12 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v4 1/4] samples/bpf: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
Date:   Sat,  9 Apr 2022 12:59:55 +0000
Message-Id: <20220409125958.92629-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220409125958.92629-1-laoar.shao@gmail.com>
References: <20220409125958.92629-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have switched to memcg-based memory accouting and thus the rlimit is
not needed any more. LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK was introduced in
libbpf for backward compatibility, so we can use it instead now.

This patch also removes the useless header sys/resource.h from many files
in samples/bpf.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 samples/bpf/cpustat_user.c                | 1 -
 samples/bpf/hbm.c                         | 5 +++--
 samples/bpf/ibumad_user.c                 | 1 -
 samples/bpf/map_perf_test_user.c          | 1 -
 samples/bpf/offwaketime_user.c            | 1 -
 samples/bpf/sockex2_user.c                | 1 -
 samples/bpf/sockex3_user.c                | 1 -
 samples/bpf/spintest_user.c               | 1 -
 samples/bpf/syscall_tp_user.c             | 1 -
 samples/bpf/task_fd_query_user.c          | 1 -
 samples/bpf/test_lru_dist.c               | 1 -
 samples/bpf/test_map_in_map_user.c        | 1 -
 samples/bpf/test_overhead_user.c          | 1 -
 samples/bpf/tracex2_user.c                | 1 -
 samples/bpf/tracex3_user.c                | 1 -
 samples/bpf/tracex4_user.c                | 1 -
 samples/bpf/tracex5_user.c                | 1 -
 samples/bpf/tracex6_user.c                | 1 -
 samples/bpf/xdp1_user.c                   | 1 -
 samples/bpf/xdp_adjust_tail_user.c        | 1 -
 samples/bpf/xdp_monitor_user.c            | 1 -
 samples/bpf/xdp_redirect_cpu_user.c       | 1 -
 samples/bpf/xdp_redirect_map_multi_user.c | 1 -
 samples/bpf/xdp_redirect_user.c           | 1 -
 samples/bpf/xdp_router_ipv4_user.c        | 1 -
 samples/bpf/xdp_rxq_info_user.c           | 1 -
 samples/bpf/xdp_sample_pkts_user.c        | 1 -
 samples/bpf/xdp_sample_user.c             | 1 -
 samples/bpf/xdp_tx_iptunnel_user.c        | 1 -
 samples/bpf/xdpsock_user.c                | 9 ++-------
 samples/bpf/xsk_fwd.c                     | 7 ++-----
 31 files changed, 7 insertions(+), 42 deletions(-)

diff --git a/samples/bpf/cpustat_user.c b/samples/bpf/cpustat_user.c
index 96675985e9e0..ab90bb08a2b4 100644
--- a/samples/bpf/cpustat_user.c
+++ b/samples/bpf/cpustat_user.c
@@ -13,7 +13,6 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/time.h>
-#include <sys/resource.h>
 #include <sys/wait.h>
 
 #include <bpf/bpf.h>
diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
index 1fe5bcafb3bc..516fbac28b71 100644
--- a/samples/bpf/hbm.c
+++ b/samples/bpf/hbm.c
@@ -34,7 +34,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <assert.h>
-#include <sys/resource.h>
 #include <sys/time.h>
 #include <unistd.h>
 #include <errno.h>
@@ -46,7 +45,6 @@
 #include <bpf/bpf.h>
 #include <getopt.h>
 
-#include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
 #include "hbm.h"
 #include "bpf_util.h"
@@ -510,5 +508,8 @@ int main(int argc, char **argv)
 		prog = argv[optind];
 	printf("HBM prog: %s\n", prog != NULL ? prog : "NULL");
 
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
 	return run_bpf_prog(prog, cg_id);
 }
diff --git a/samples/bpf/ibumad_user.c b/samples/bpf/ibumad_user.c
index 0746ca516097..d074c978aac7 100644
--- a/samples/bpf/ibumad_user.c
+++ b/samples/bpf/ibumad_user.c
@@ -19,7 +19,6 @@
 #include <sys/types.h>
 #include <limits.h>
 
-#include <sys/resource.h>
 #include <getopt.h>
 #include <net/if.h>
 
diff --git a/samples/bpf/map_perf_test_user.c b/samples/bpf/map_perf_test_user.c
index e69651a6902f..b6fc174ab1f2 100644
--- a/samples/bpf/map_perf_test_user.c
+++ b/samples/bpf/map_perf_test_user.c
@@ -13,7 +13,6 @@
 #include <signal.h>
 #include <string.h>
 #include <time.h>
-#include <sys/resource.h>
 #include <arpa/inet.h>
 #include <errno.h>
 
diff --git a/samples/bpf/offwaketime_user.c b/samples/bpf/offwaketime_user.c
index 73a986876c1a..b6eedcb98fb9 100644
--- a/samples/bpf/offwaketime_user.c
+++ b/samples/bpf/offwaketime_user.c
@@ -8,7 +8,6 @@
 #include <linux/perf_event.h>
 #include <errno.h>
 #include <stdbool.h>
-#include <sys/resource.h>
 #include <bpf/libbpf.h>
 #include <bpf/bpf.h>
 #include "trace_helpers.h"
diff --git a/samples/bpf/sockex2_user.c b/samples/bpf/sockex2_user.c
index 6a3fd369d3fc..2c18471336f0 100644
--- a/samples/bpf/sockex2_user.c
+++ b/samples/bpf/sockex2_user.c
@@ -7,7 +7,6 @@
 #include "sock_example.h"
 #include <unistd.h>
 #include <arpa/inet.h>
-#include <sys/resource.h>
 
 struct pair {
 	__u64 packets;
diff --git a/samples/bpf/sockex3_user.c b/samples/bpf/sockex3_user.c
index 6ae99ecc766c..cd6fa79df900 100644
--- a/samples/bpf/sockex3_user.c
+++ b/samples/bpf/sockex3_user.c
@@ -6,7 +6,6 @@
 #include "sock_example.h"
 #include <unistd.h>
 #include <arpa/inet.h>
-#include <sys/resource.h>
 
 struct flow_key_record {
 	__be32 src;
diff --git a/samples/bpf/spintest_user.c b/samples/bpf/spintest_user.c
index 0d7e1e5a8658..aadac14f748a 100644
--- a/samples/bpf/spintest_user.c
+++ b/samples/bpf/spintest_user.c
@@ -3,7 +3,6 @@
 #include <unistd.h>
 #include <string.h>
 #include <assert.h>
-#include <sys/resource.h>
 #include <bpf/libbpf.h>
 #include <bpf/bpf.h>
 #include "trace_helpers.h"
diff --git a/samples/bpf/syscall_tp_user.c b/samples/bpf/syscall_tp_user.c
index c55383068384..7a788bb837fc 100644
--- a/samples/bpf/syscall_tp_user.c
+++ b/samples/bpf/syscall_tp_user.c
@@ -8,7 +8,6 @@
 #include <string.h>
 #include <linux/perf_event.h>
 #include <errno.h>
-#include <sys/resource.h>
 #include <bpf/libbpf.h>
 #include <bpf/bpf.h>
 
diff --git a/samples/bpf/task_fd_query_user.c b/samples/bpf/task_fd_query_user.c
index c9a0ca8351fd..424718c0872c 100644
--- a/samples/bpf/task_fd_query_user.c
+++ b/samples/bpf/task_fd_query_user.c
@@ -10,7 +10,6 @@
 #include <fcntl.h>
 #include <linux/bpf.h>
 #include <sys/ioctl.h>
-#include <sys/resource.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <linux/perf_event.h>
diff --git a/samples/bpf/test_lru_dist.c b/samples/bpf/test_lru_dist.c
index 75e877853596..be98ccb4952f 100644
--- a/samples/bpf/test_lru_dist.c
+++ b/samples/bpf/test_lru_dist.c
@@ -13,7 +13,6 @@
 #include <sched.h>
 #include <sys/wait.h>
 #include <sys/stat.h>
-#include <sys/resource.h>
 #include <fcntl.h>
 #include <stdlib.h>
 #include <time.h>
diff --git a/samples/bpf/test_map_in_map_user.c b/samples/bpf/test_map_in_map_user.c
index 472d65c70354..e8b4cc184ac9 100644
--- a/samples/bpf/test_map_in_map_user.c
+++ b/samples/bpf/test_map_in_map_user.c
@@ -2,7 +2,6 @@
 /*
  * Copyright (c) 2017 Facebook
  */
-#include <sys/resource.h>
 #include <sys/socket.h>
 #include <arpa/inet.h>
 #include <stdint.h>
diff --git a/samples/bpf/test_overhead_user.c b/samples/bpf/test_overhead_user.c
index 4821f9d99c1f..88717f8ec6ac 100644
--- a/samples/bpf/test_overhead_user.c
+++ b/samples/bpf/test_overhead_user.c
@@ -16,7 +16,6 @@
 #include <linux/bpf.h>
 #include <string.h>
 #include <time.h>
-#include <sys/resource.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 
diff --git a/samples/bpf/tracex2_user.c b/samples/bpf/tracex2_user.c
index 1626d51dfffd..dd6205c6b6a7 100644
--- a/samples/bpf/tracex2_user.c
+++ b/samples/bpf/tracex2_user.c
@@ -4,7 +4,6 @@
 #include <stdlib.h>
 #include <signal.h>
 #include <string.h>
-#include <sys/resource.h>
 
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
diff --git a/samples/bpf/tracex3_user.c b/samples/bpf/tracex3_user.c
index 33e16ba39f25..d5eebace31e6 100644
--- a/samples/bpf/tracex3_user.c
+++ b/samples/bpf/tracex3_user.c
@@ -7,7 +7,6 @@
 #include <unistd.h>
 #include <stdbool.h>
 #include <string.h>
-#include <sys/resource.h>
 
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
diff --git a/samples/bpf/tracex4_user.c b/samples/bpf/tracex4_user.c
index 566e6440e8c2..227b05a0bc88 100644
--- a/samples/bpf/tracex4_user.c
+++ b/samples/bpf/tracex4_user.c
@@ -8,7 +8,6 @@
 #include <stdbool.h>
 #include <string.h>
 #include <time.h>
-#include <sys/resource.h>
 
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
diff --git a/samples/bpf/tracex5_user.c b/samples/bpf/tracex5_user.c
index 08dfdc77ad2a..e910dc265c31 100644
--- a/samples/bpf/tracex5_user.c
+++ b/samples/bpf/tracex5_user.c
@@ -7,7 +7,6 @@
 #include <sys/prctl.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
-#include <sys/resource.h>
 #include "trace_helpers.h"
 
 #ifdef __mips__
diff --git a/samples/bpf/tracex6_user.c b/samples/bpf/tracex6_user.c
index 28296f40c133..8e83bf2a84a4 100644
--- a/samples/bpf/tracex6_user.c
+++ b/samples/bpf/tracex6_user.c
@@ -8,7 +8,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/ioctl.h>
-#include <sys/resource.h>
 #include <sys/time.h>
 #include <sys/types.h>
 #include <sys/wait.h>
diff --git a/samples/bpf/xdp1_user.c b/samples/bpf/xdp1_user.c
index 631f0cabe139..288db3d3ee5f 100644
--- a/samples/bpf/xdp1_user.c
+++ b/samples/bpf/xdp1_user.c
@@ -11,7 +11,6 @@
 #include <string.h>
 #include <unistd.h>
 #include <libgen.h>
-#include <sys/resource.h>
 #include <net/if.h>
 
 #include "bpf_util.h"
diff --git a/samples/bpf/xdp_adjust_tail_user.c b/samples/bpf/xdp_adjust_tail_user.c
index b3f6e49676ed..167646077c8f 100644
--- a/samples/bpf/xdp_adjust_tail_user.c
+++ b/samples/bpf/xdp_adjust_tail_user.c
@@ -14,7 +14,6 @@
 #include <stdlib.h>
 #include <string.h>
 #include <net/if.h>
-#include <sys/resource.h>
 #include <arpa/inet.h>
 #include <netinet/ether.h>
 #include <unistd.h>
diff --git a/samples/bpf/xdp_monitor_user.c b/samples/bpf/xdp_monitor_user.c
index fb9391a5ec62..58015eb2ffae 100644
--- a/samples/bpf/xdp_monitor_user.c
+++ b/samples/bpf/xdp_monitor_user.c
@@ -17,7 +17,6 @@ static const char *__doc_err_only__=
 #include <ctype.h>
 #include <unistd.h>
 #include <locale.h>
-#include <sys/resource.h>
 #include <getopt.h>
 #include <net/if.h>
 #include <time.h>
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 5f74a70a9021..a12381c37d2b 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -21,7 +21,6 @@ static const char *__doc__ =
 #include <string.h>
 #include <unistd.h>
 #include <locale.h>
-#include <sys/resource.h>
 #include <sys/sysinfo.h>
 #include <getopt.h>
 #include <net/if.h>
diff --git a/samples/bpf/xdp_redirect_map_multi_user.c b/samples/bpf/xdp_redirect_map_multi_user.c
index 315314716121..9e24f2705b67 100644
--- a/samples/bpf/xdp_redirect_map_multi_user.c
+++ b/samples/bpf/xdp_redirect_map_multi_user.c
@@ -15,7 +15,6 @@ static const char *__doc__ =
 #include <net/if.h>
 #include <unistd.h>
 #include <libgen.h>
-#include <sys/resource.h>
 #include <sys/ioctl.h>
 #include <sys/types.h>
 #include <sys/socket.h>
diff --git a/samples/bpf/xdp_redirect_user.c b/samples/bpf/xdp_redirect_user.c
index 7af5b07a7523..8663dd631b6e 100644
--- a/samples/bpf/xdp_redirect_user.c
+++ b/samples/bpf/xdp_redirect_user.c
@@ -18,7 +18,6 @@ static const char *__doc__ =
 #include <unistd.h>
 #include <libgen.h>
 #include <getopt.h>
-#include <sys/resource.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 #include "bpf_util.h"
diff --git a/samples/bpf/xdp_router_ipv4_user.c b/samples/bpf/xdp_router_ipv4_user.c
index f32bbd5c32bf..294fc15ad1cb 100644
--- a/samples/bpf/xdp_router_ipv4_user.c
+++ b/samples/bpf/xdp_router_ipv4_user.c
@@ -22,7 +22,6 @@
 #include <sys/syscall.h>
 #include "bpf_util.h"
 #include <bpf/libbpf.h>
-#include <sys/resource.h>
 #include <libgen.h>
 #include <getopt.h>
 #include <pthread.h>
diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
index f2d90cba5164..05a24a712d7d 100644
--- a/samples/bpf/xdp_rxq_info_user.c
+++ b/samples/bpf/xdp_rxq_info_user.c
@@ -14,7 +14,6 @@ static const char *__doc__ = " XDP RX-queue info extract example\n\n"
 #include <string.h>
 #include <unistd.h>
 #include <locale.h>
-#include <sys/resource.h>
 #include <getopt.h>
 #include <net/if.h>
 #include <time.h>
diff --git a/samples/bpf/xdp_sample_pkts_user.c b/samples/bpf/xdp_sample_pkts_user.c
index 0a2b3e997aed..7df7163239ac 100644
--- a/samples/bpf/xdp_sample_pkts_user.c
+++ b/samples/bpf/xdp_sample_pkts_user.c
@@ -12,7 +12,6 @@
 #include <signal.h>
 #include <bpf/libbpf.h>
 #include <bpf/bpf.h>
-#include <sys/resource.h>
 #include <libgen.h>
 #include <linux/if_link.h>
 
diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
index c4332d068b91..158682852162 100644
--- a/samples/bpf/xdp_sample_user.c
+++ b/samples/bpf/xdp_sample_user.c
@@ -25,7 +25,6 @@
 #include <string.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
-#include <sys/resource.h>
 #include <sys/signalfd.h>
 #include <sys/sysinfo.h>
 #include <sys/timerfd.h>
diff --git a/samples/bpf/xdp_tx_iptunnel_user.c b/samples/bpf/xdp_tx_iptunnel_user.c
index 2e811e4331cc..307baef6861a 100644
--- a/samples/bpf/xdp_tx_iptunnel_user.c
+++ b/samples/bpf/xdp_tx_iptunnel_user.c
@@ -10,7 +10,6 @@
 #include <stdlib.h>
 #include <string.h>
 #include <net/if.h>
-#include <sys/resource.h>
 #include <arpa/inet.h>
 #include <netinet/ether.h>
 #include <unistd.h>
diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 6f3fe30ad283..be7d2572e3e6 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -25,7 +25,6 @@
 #include <string.h>
 #include <sys/capability.h>
 #include <sys/mman.h>
-#include <sys/resource.h>
 #include <sys/socket.h>
 #include <sys/types.h>
 #include <sys/un.h>
@@ -1886,7 +1885,6 @@ int main(int argc, char **argv)
 {
 	struct __user_cap_header_struct hdr = { _LINUX_CAPABILITY_VERSION_3, 0 };
 	struct __user_cap_data_struct data[2] = { { 0 } };
-	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
 	bool rx = false, tx = false;
 	struct sched_param schparam;
 	struct xsk_umem_info *umem;
@@ -1917,11 +1915,8 @@ int main(int argc, char **argv)
 				data[1].effective, data[1].inheritable, data[1].permitted);
 		}
 	} else {
-		if (setrlimit(RLIMIT_MEMLOCK, &r)) {
-			fprintf(stderr, "ERROR: setrlimit(RLIMIT_MEMLOCK) \"%s\"\n",
-				strerror(errno));
-			exit(EXIT_FAILURE);
-		}
+		/* Use libbpf 1.0 API mode */
+		libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
 
 		if (opt_num_xsks > 1)
 			load_xdp_program(argv, &obj);
diff --git a/samples/bpf/xsk_fwd.c b/samples/bpf/xsk_fwd.c
index 2220509588a0..2324e18ccc7e 100644
--- a/samples/bpf/xsk_fwd.c
+++ b/samples/bpf/xsk_fwd.c
@@ -10,7 +10,6 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/mman.h>
-#include <sys/resource.h>
 #include <sys/socket.h>
 #include <sys/types.h>
 #include <time.h>
@@ -131,7 +130,6 @@ static struct bpool *
 bpool_init(struct bpool_params *params,
 	   struct xsk_umem_config *umem_cfg)
 {
-	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
 	u64 n_slabs, n_slabs_reserved, n_buffers, n_buffers_reserved;
 	u64 slabs_size, slabs_reserved_size;
 	u64 buffers_size, buffers_reserved_size;
@@ -140,9 +138,8 @@ bpool_init(struct bpool_params *params,
 	u8 *p;
 	int status;
 
-	/* mmap prep. */
-	if (setrlimit(RLIMIT_MEMLOCK, &r))
-		return NULL;
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
 
 	/* bpool internals dimensioning. */
 	n_slabs = (params->n_buffers + params->n_buffers_per_slab - 1) /
-- 
2.17.1

