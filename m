Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18E2461D50
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 12:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730249AbfGHK4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 06:56:00 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:43055 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730231AbfGHKzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 06:55:54 -0400
Received: by mail-ed1-f66.google.com with SMTP id e3so14117905edr.10
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 03:55:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=pYK/cSR/paK9aJBfuEv538yo/J01fWBVfiBWc+2kCDE=;
        b=TABEBmISZF+3ASgTYr0MNJL3PuRfxWudTZyF9j1ZL8Oii+TEDVmDEoE2YKZnWbdBvI
         w6y39VDW0DwU3ya4IYDImoeJcHkEpSNaEc3fbyojBI3megj6JgJV0od1hyTuWeon+ezJ
         ygb02BDg7z3OAUkr2zZM9VP/Mi1pYbyVYpCI6TC4q1CwJNOTryaYjW9wJYbixT1ZFwYR
         iAQkuMCpS4mEDzdNl6rAR5m4747MkSiCcYSqkQ9/fz5aulL9mjmWEEm+3oZzzKwDxiR7
         4N8R7q8JS2GscK/fsfQyJPTrIhbZPDrqDbB1JxHCItP6oBkF8aPkJLaGylda1aX0yPkq
         HQVQ==
X-Gm-Message-State: APjAAAWj/Viqpx58Z9G1MiEabv3dIWtft5SFuD51n0u3eGXWTitaGnF2
        gl61bRursucDSWYyYXRIDhAClg==
X-Google-Smtp-Source: APXvYqzRmvDwq9P70oBhK0psujsaSQzXSVV9gB1Ku24UAdfvmaQgbyYdXZIk33TeWLpu9SyTXGyeug==
X-Received: by 2002:a17:906:19cc:: with SMTP id h12mr13340385ejd.304.1562583352127;
        Mon, 08 Jul 2019 03:55:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id s27sm525517ejb.74.2019.07.08.03.55.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 03:55:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8C567181CEF; Mon,  8 Jul 2019 12:55:47 +0200 (CEST)
Subject: [PATCH bpf-next v3 6/6] tools: Add definitions for devmap_hash map
 type
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>
Date:   Mon, 08 Jul 2019 12:55:47 +0200
Message-ID: <156258334751.1664.9165590129307902073.stgit@alrua-x1>
In-Reply-To: <156258334704.1664.15289699152225647059.stgit@alrua-x1>
References: <156258334704.1664.15289699152225647059.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds selftest and bpftool updates for the devmap_hash map type.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/bpf/bpftool/Documentation/bpftool-map.rst |    2 +-
 tools/bpf/bpftool/bash-completion/bpftool       |    4 ++--
 tools/bpf/bpftool/map.c                         |    3 ++-
 tools/testing/selftests/bpf/test_maps.c         |   16 ++++++++++++++++
 4 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index 490b4501cb6e..61d1d270eb5e 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -46,7 +46,7 @@ MAP COMMANDS
 |	*TYPE* := { **hash** | **array** | **prog_array** | **perf_event_array** | **percpu_hash**
 |		| **percpu_array** | **stack_trace** | **cgroup_array** | **lru_hash**
 |		| **lru_percpu_hash** | **lpm_trie** | **array_of_maps** | **hash_of_maps**
-|		| **devmap** | **sockmap** | **cpumap** | **xskmap** | **sockhash**
+|		| **devmap** | **devmap_hash** | **sockmap** | **cpumap** | **xskmap** | **sockhash**
 |		| **cgroup_storage** | **reuseport_sockarray** | **percpu_cgroup_storage**
 |		| **queue** | **stack** }
 
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index ba37095e1f62..411d810bfd10 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -458,8 +458,8 @@ _bpftool()
                                 perf_event_array percpu_hash percpu_array \
                                 stack_trace cgroup_array lru_hash \
                                 lru_percpu_hash lpm_trie array_of_maps \
-                                hash_of_maps devmap sockmap cpumap xskmap \
-                                sockhash cgroup_storage reuseport_sockarray \
+                                hash_of_maps devmap devmap_hash sockmap cpumap \
+                                xskmap sockhash cgroup_storage reuseport_sockarray \
                                 percpu_cgroup_storage queue stack' -- \
                                                    "$cur" ) )
                             return 0
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 5da5a7311f13..bfbbc6b4cb83 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -37,6 +37,7 @@ const char * const map_type_name[] = {
 	[BPF_MAP_TYPE_ARRAY_OF_MAPS]		= "array_of_maps",
 	[BPF_MAP_TYPE_HASH_OF_MAPS]		= "hash_of_maps",
 	[BPF_MAP_TYPE_DEVMAP]			= "devmap",
+	[BPF_MAP_TYPE_DEVMAP_HASH]		= "devmap_hash",
 	[BPF_MAP_TYPE_SOCKMAP]			= "sockmap",
 	[BPF_MAP_TYPE_CPUMAP]			= "cpumap",
 	[BPF_MAP_TYPE_XSKMAP]			= "xskmap",
@@ -1271,7 +1272,7 @@ static int do_help(int argc, char **argv)
 		"       TYPE := { hash | array | prog_array | perf_event_array | percpu_hash |\n"
 		"                 percpu_array | stack_trace | cgroup_array | lru_hash |\n"
 		"                 lru_percpu_hash | lpm_trie | array_of_maps | hash_of_maps |\n"
-		"                 devmap | sockmap | cpumap | xskmap | sockhash |\n"
+		"                 devmap | devmap_hash | sockmap | cpumap | xskmap | sockhash |\n"
 		"                 cgroup_storage | reuseport_sockarray | percpu_cgroup_storage }\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index a3fbc571280a..086319caf2d9 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -508,6 +508,21 @@ static void test_devmap(unsigned int task, void *data)
 	close(fd);
 }
 
+static void test_devmap_hash(unsigned int task, void *data)
+{
+	int fd;
+	__u32 key, value;
+
+	fd = bpf_create_map(BPF_MAP_TYPE_DEVMAP_HASH, sizeof(key), sizeof(value),
+			    2, 0);
+	if (fd < 0) {
+		printf("Failed to create devmap_hash '%s'!\n", strerror(errno));
+		exit(1);
+	}
+
+	close(fd);
+}
+
 static void test_queuemap(unsigned int task, void *data)
 {
 	const int MAP_SIZE = 32;
@@ -1675,6 +1690,7 @@ static void run_all_tests(void)
 	test_arraymap_percpu_many_keys();
 
 	test_devmap(0, NULL);
+	test_devmap_hash(0, NULL);
 	test_sockmap(0, NULL);
 
 	test_map_large();

