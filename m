Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D714B7AF0
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 23:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244751AbiBOW7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 17:59:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244721AbiBOW7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 17:59:49 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3EDB91D0
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:59:38 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id m25so190726qka.9
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xbFKcU53Bx8IxhGu5tT7Io5EIpPtArnrR0J3NTHuSn8=;
        b=JTH94c58zi3YNw+9JjT9llW8O6voOOGG3IRnUuEeV8LJPIJXBJjnAhPx7gglMHeI45
         kv6AMM5xdKIq3YxMZEhi7bGybg7KBODJDKdpAsfTmwf0c9t//QpYIIt9K8HID4nKvbyB
         i6xRzPWdCDTS0KhV+XLOFJkMGLnLkRb8W/huU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xbFKcU53Bx8IxhGu5tT7Io5EIpPtArnrR0J3NTHuSn8=;
        b=ONaWbqUsQam5KZ65VcNFXzoIisYld29TshFHd78a7030o81XEF6lGptBU4NvV81E1n
         SOpQs8eEh0ECBuAPT2bp5H7rU7iFCKE1111vRIkueo5EyjWIgONl8uj7ABBrU1lURoVz
         e6kgHRgCYIhoMQzm7P4haKRJaAowDvrIbBJzEW1U6aod89fJM6GabbNzLKKMuSgu3qk1
         UTdDb1gDGySw3rWFj8Fu6lko+vBGaaFsdz/X9z2b+QpTlCSRBvtEwsaVRPyY3QPXSCDx
         DOoS62phkyZNMc8CWQ1NO93gbeGVZqejhYB0do1JfYtnC6RVQP5LJFb6JPiV6NnUL22t
         qu5w==
X-Gm-Message-State: AOAM5306qWRLT4I2P+8wbH41E72xJ5lRl5FeyRJbzivEePQU765m98s6
        BerFwu/kwcio2ihPLBpL7qOTAP+QmqRw6e7joUffzBQ9SOA3GCKYcBT0G1IugRM/LnAz6/2xiDY
        1l+iGyFbDF43TTBvI5v5oMQyXc4qId4ipPSSNtSgZGhFQlyUcg+WW3Nqn8J0v1nnU8ikyBA==
X-Google-Smtp-Source: ABdhPJxJm5ZTRWEdF0NRnlXz1LHPfH33wRWX55r/SXCwXUcppHl25YUReLSXqqiVG+yDSc5BXkjTxw==
X-Received: by 2002:a37:6756:0:b0:508:a180:b2ae with SMTP id b83-20020a376756000000b00508a180b2aemr38395qkc.497.1644965975320;
        Tue, 15 Feb 2022 14:59:35 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id w19sm15520021qkp.6.2022.02.15.14.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 14:59:34 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v7 6/7] bpftool: gen min_core_btf explanation and examples
Date:   Tue, 15 Feb 2022 17:58:55 -0500
Message-Id: <20220215225856.671072-7-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220215225856.671072-1-mauricio@kinvolk.io>
References: <20220215225856.671072-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 .../bpf/bpftool/Documentation/bpftool-gen.rst | 91 +++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
index bc276388f432..4bf8e6447718 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -25,6 +25,7 @@ GEN COMMANDS
 
 |	**bpftool** **gen object** *OUTPUT_FILE* *INPUT_FILE* [*INPUT_FILE*...]
 |	**bpftool** **gen skeleton** *FILE* [**name** *OBJECT_NAME*]
+|	**bpftool** **gen min_core_btf** *INPUT* *OUTPUT* *OBJECT* [*OBJECT*...]
 |	**bpftool** **gen help**
 
 DESCRIPTION
@@ -149,6 +150,26 @@ DESCRIPTION
 		  (non-read-only) data from userspace, with same simplicity
 		  as for BPF side.
 
+	**bpftool** **gen min_core_btf** *INPUT* *OUTPUT* *OBJECT* [*OBJECT*...]
+		  Generate a minimum BTF file as *OUTPUT*, derived from a given
+		  *INPUT* BTF file, containing all needed BTF types so one, or
+		  more, given eBPF objects CO-RE relocations may be satisfied.
+
+		  When kernels aren't compiled with CONFIG_DEBUG_INFO_BTF,
+		  libbpf, when loading an eBPF object, has to rely in external
+		  BTF files to be able to calculate CO-RE relocations.
+
+		  Usually, an external BTF file is built from existing kernel
+		  DWARF data using pahole. It contains all the types used by
+		  its respective kernel image and, because of that, is big.
+
+		  The min_core_btf feature builds smaller BTF files, customized
+		  to one or multiple eBPF objects, so they can be distributed
+		  together with an eBPF CO-RE based application, turning the
+		  application portable to different kernel versions.
+
+		  Check examples bellow for more information how to use it.
+
 	**bpftool gen help**
 		  Print short help message.
 
@@ -215,7 +236,9 @@ This is example BPF application with two BPF programs and a mix of BPF maps
 and global variables. Source code is split across two source code files.
 
 **$ clang -target bpf -g example1.bpf.c -o example1.bpf.o**
+
 **$ clang -target bpf -g example2.bpf.c -o example2.bpf.o**
+
 **$ bpftool gen object example.bpf.o example1.bpf.o example2.bpf.o**
 
 This set of commands compiles *example1.bpf.c* and *example2.bpf.c*
@@ -329,3 +352,71 @@ BPF ELF object file *example.bpf.o*.
   my_static_var: 7
 
 This is a stripped-out version of skeleton generated for above example code.
+
+min_core_btf
+------------
+
+**$ bpftool btf dump file ./5.4.0-example.btf format raw**
+
+::
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
+**$ bpftool btf dump file ./one.bpf.o format raw**
+
+::
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
+**$ bpftool gen min_core_btf ./5.4.0-example.btf ./5.4.0-smaller.btf ./one.bpf.o**
+
+**$ bpftool btf dump file ./5.4.0-smaller.btf format raw**
+
+::
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
+Now, the "5.4.0-smaller.btf" file may be used by libbpf as an external BTF file
+when loading the "one.bpf.o" object into the "5.4.0-example" kernel. Note that
+the generated BTF file won't allow other eBPF objects to be loaded, just the
+ones given to min_core_btf.
+
+::
+
+  struct bpf_object *obj = NULL;
+
+  DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts, .btf_custom_path = "5.4.0-smaller.btf");
+
+  obj = bpf_object__open_file("one.bpf.o", &opts);
+
+  ...
-- 
2.25.1

