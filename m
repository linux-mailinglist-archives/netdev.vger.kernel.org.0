Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E2F4A03C7
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 23:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351734AbiA1Wdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 17:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351730AbiA1Wdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 17:33:53 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BD1C061751
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 14:33:51 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id h8so437379qtk.13
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 14:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xf470h++YZYnsItyFBnYFGrvH5jc3SkABdCUDs5CbKA=;
        b=bA05SnUKX0BRLY/BgJXuZgQKSp0wdtzVaSs6EREZH1UMeNIEpHFDPdRW/fMzEazQlW
         yqNvtfPAHXPGnK9+CtqiPylsyW1os/5DjDyVfdPKjFfzizVtfiwphrU/RrCviZdLSIQm
         Eb4gT7czau+/O4K+4fPH5VdFro2iB8Vjaw74U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xf470h++YZYnsItyFBnYFGrvH5jc3SkABdCUDs5CbKA=;
        b=5pHhwXnx5VmLoPHy+HUjS3RzyiX7kpltpVrIkJfpB38c3lZxejF+CGx8FWG/9nTYMF
         IzISgIADPePmpUhATAQwDauv/YwXAqzo9hB0kQOSWRmatgYWPRIJIXQnqWGstunwWkPr
         IQYK5ONk/H2YnwSwFtOMrVgtVOvylSQxCw7wOU8jUgmxugOBxX2QoJFjf1hAlRzAPfG0
         Q5dfvb+SsSTgStopaDWNCehhGSaYEuu/OAfoV9UvVZbG7xEZaaF0UkDU45Rskgo2NgjG
         3cErzi5xCinShfGMV+E87de1ehVXGB8BU0bzCznw8pSGM7w/KQpFlS2mF6s1VMtFsmSK
         Hsyw==
X-Gm-Message-State: AOAM5332GwHcOHptXbt+jYkUx1bJr/Au1DQhrZWxJahO0MiD91QGumad
        0EhMwmbFt5F0faTQnupmPiHrVA5KRwt0froErjdKfd/HhSAPqZKeltdJ2TbD8Tyb+Lu3GPDNOre
        YQeYytffay5KZ7mtni1inp12qt+iwtWjJgLdclyCmL2OPYeYI5qBryYTW5UPh/EDx93MrQA==
X-Google-Smtp-Source: ABdhPJzU8dVtMujQlQAhqasJpQ45yA2L7J6ElX02ux0kYnJQdz6tjzc2O4jS1C2628ZNIEtnxT+Ksg==
X-Received: by 2002:a05:622a:2ce:: with SMTP id a14mr7710719qtx.107.1643409227730;
        Fri, 28 Jan 2022 14:33:47 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id i18sm3723972qka.80.2022.01.28.14.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:33:46 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v5 8/9] bpftool: gen min_core_btf explanation and examples
Date:   Fri, 28 Jan 2022 17:33:11 -0500
Message-Id: <20220128223312.1253169-9-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220128223312.1253169-1-mauricio@kinvolk.io>
References: <20220128223312.1253169-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafael David Tinoco <rafaeldtinoco@gmail.com>

Add "min_core_btf" feature explanation and one example of how to use it
to bpftool-gen man page.

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 .../bpf/bpftool/Documentation/bpftool-gen.rst | 85 +++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
index bc276388f432..7aa3c29c2da0 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -25,6 +25,7 @@ GEN COMMANDS
 
 |	**bpftool** **gen object** *OUTPUT_FILE* *INPUT_FILE* [*INPUT_FILE*...]
 |	**bpftool** **gen skeleton** *FILE* [**name** *OBJECT_NAME*]
+|	**bpftool** **gen min_core_btf** *INPUT* *OUTPUT* *OBJECTS(S)*
 |	**bpftool** **gen help**
 
 DESCRIPTION
@@ -149,6 +150,24 @@ DESCRIPTION
 		  (non-read-only) data from userspace, with same simplicity
 		  as for BPF side.
 
+	**bpftool** **gen min_core_btf** *INPUT* *OUTPUT* *OBJECT(S)*
+		  Given one, or multiple, eBPF *OBJECT* files, generate a
+		  smaller BTF file, in the *OUTPUT* directory, to each existing
+		  BTF files in the *INPUT* directory, using the same name.
+
+		  If *INPUT* is a file, then the result BTF will be saved as a
+		  single file, with the same name, in *OUTPUT* directory.
+
+		  Generated BTF files will only contain the BTF types used by
+		  the given eBPF objects. Idea behind this is simple: Full
+		  external BTF files are big. This allows customized external
+		  BTF files generation and maximizes eBPF portability (CO-RE).
+
+		  This feature allows a particular eBPF project to embed
+		  customized BTF files in order to support older kernels,
+		  allowing code to be portable among kernels that don't support
+		  embedded BTF files but still support eBPF.
+
 	**bpftool gen help**
 		  Print short help message.
 
@@ -215,7 +234,9 @@ This is example BPF application with two BPF programs and a mix of BPF maps
 and global variables. Source code is split across two source code files.
 
 **$ clang -target bpf -g example1.bpf.c -o example1.bpf.o**
+
 **$ clang -target bpf -g example2.bpf.c -o example2.bpf.o**
+
 **$ bpftool gen object example.bpf.o example1.bpf.o example2.bpf.o**
 
 This set of commands compiles *example1.bpf.c* and *example2.bpf.c*
@@ -329,3 +350,67 @@ BPF ELF object file *example.bpf.o*.
   my_static_var: 7
 
 This is a stripped-out version of skeleton generated for above example code.
+
+*MIN_CORE_BTF*
+
+::
+
+  $ bpftool btf dump file ./input/5.4.0-91-generic.btf format raw
+
+  [1] INT 'long unsigned int' size=8 bits_offset=0 nr_bits=64 encoding=(none)
+  [2] CONST '(anon)' type_id=1
+  [3] VOLATILE '(anon)' type_id=1
+  [4] ARRAY '(anon)' type_id=1 index_type_id=21 nr_elems=2
+  [5] PTR '(anon)' type_id=8
+  [6] CONST '(anon)' type_id=5
+  [7] INT 'char' size=1 bits_offset=0 nr_bits=8 encoding=(none)
+  [8] CONST '(anon)' type_id=7
+  [9] INT 'unsigned int' size=4 bits_offset=0 nr_bits=32 encoding=(none)
+  <long output>
+
+  $ bpftool btf dump file ./one.bpf.o format raw
+
+  [1] PTR '(anon)' type_id=2
+  [2] STRUCT 'trace_event_raw_sys_enter' size=64 vlen=4
+        'ent' type_id=3 bits_offset=0
+        'id' type_id=7 bits_offset=64
+        'args' type_id=9 bits_offset=128
+        '__data' type_id=12 bits_offset=512
+  [3] STRUCT 'trace_entry' size=8 vlen=4
+        'type' type_id=4 bits_offset=0
+        'flags' type_id=5 bits_offset=16
+        'preempt_count' type_id=5 bits_offset=24
+  <long output>
+
+  $ bpftool gen min_core_btf ./input/ ./output ./one.bpf.o
+
+  $ bpftool btf dump file ./output/5.4.0-91-generic.btf format raw
+
+  [1] TYPEDEF 'pid_t' type_id=6
+  [2] STRUCT 'trace_event_raw_sys_enter' size=64 vlen=1
+        'args' type_id=4 bits_offset=128
+  [3] STRUCT 'task_struct' size=9216 vlen=2
+        'pid' type_id=1 bits_offset=17920
+        'real_parent' type_id=7 bits_offset=18048
+  [4] ARRAY '(anon)' type_id=5 index_type_id=8 nr_elems=6
+  [5] INT 'long unsigned int' size=8 bits_offset=0 nr_bits=64 encoding=(none)
+  [6] TYPEDEF '__kernel_pid_t' type_id=8
+  [7] PTR '(anon)' type_id=3
+  [8] INT 'int' size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
+  <end>
+
+  Now, one may use ./output/5.4.0-91-generic.btf generated file as an external
+  BTF file fed to libbpf during eBPF object opening:
+
+  struct bpf_object *obj = NULL;
+  struct bpf_object_open_opts openopts = {};
+
+  openopts.sz = sizeof(struct bpf_object_open_opts);
+  openopts.btf_custom_path = strdup("./output/5.4.0-91-generic.btf");
+
+  obj = bpf_object__open_file("./one.bpf.o", &openopts);
+
+  ...
+
+  and allow libbpf to do all needed CO-RE relocations, to "one.bpf.o" object,
+  based on the small external BTF file.
-- 
2.25.1

