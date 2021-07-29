Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47083DA90C
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 18:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhG2Q3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 12:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhG2Q3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 12:29:46 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058E8C0613D3
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:29:43 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id n28-20020a05600c3b9cb02902552e60df56so4431364wms.0
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t/R2YLxpdxnzBZrT7zmDXAv9DbBPdfFs4oFm0SG/fGI=;
        b=ycr3D/lygF2sJGF3Ge5j/0SWmNN6SpuzE60n1L4F2WqDuiCut95Z3PqMPh1Mk7H6Jv
         zp5GuMhw87Q0oiDMmQLF6HwxLRJkK0JBFwmaNEXS6layg1zqE/nGbDOmrmb06LDsHWbt
         Pzo1MkUCL47cNHA1hWgvGMbFPHIDXbHcXr8LO8zOOJ30AIBMmot++HvfgYv6NWrhIB0h
         n/thmlkw8LIwQlw/8giwRFB0VK3Y2hs4bK2xC6bQ0d5hNXkOCiBx5XupqUspAL8SBk03
         CliscOHjGD7g9iegdCYlRaWYEdbFnW9fKm0YF0dYV4JKnL2Ez+oN9bYUijSE3ciOqLFo
         jiDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t/R2YLxpdxnzBZrT7zmDXAv9DbBPdfFs4oFm0SG/fGI=;
        b=Fd/h/uTgNmf+hzzVtnFnVb9iAP4ySr00AWW/M41qI2NRdiDEAySwdSOrAzdLcIL2r8
         tKZOKi18OD10y02uHm5FcEscWhx4yrsB2dAGkwt1J9OSTP0ynOtuzgBmJCSBejqTp6OV
         nc7OoSpziT5h+IBNCLYKrRKoi/Ro9ExwZQLrbyOmXqwULJ8HIRlz1mC1bZsK1LfXtqRZ
         z2Gzl33JI+IxoqiQ9JTmRATMaxP3FnscGr8BiQ6mrvhk7dMUlKtxEsPOZwnKv7xNQNI7
         1TyvqTI1whgbuAlDupViow2HA+g3VWnVH/e+Xve0qGm4/9BvxFuGxnKFUtmb4xY9xKJB
         QrEw==
X-Gm-Message-State: AOAM531XehtCEBP4TfebNZRcVulgRYSK2zWjNNz5jnA5bnOjyvk6/9nV
        /VNFPDLi/wslyNfnOUy6WY37994Rts4652XjyoM=
X-Google-Smtp-Source: ABdhPJxlpv+xMfPxNkLlve6HGtywi48amdeHcikMnmrPZKjXBEqdXIl5PrxWC/kWUnq5nVAy66/tfg==
X-Received: by 2002:a05:600c:2f1a:: with SMTP id r26mr15265438wmn.41.1627576181433;
        Thu, 29 Jul 2021 09:29:41 -0700 (PDT)
Received: from localhost.localdomain ([149.86.75.13])
        by smtp.gmail.com with ESMTPSA id 140sm3859331wmb.43.2021.07.29.09.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 09:29:40 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 2/7] selftests/bpf: check consistency between bpftool source, doc, completion
Date:   Thu, 29 Jul 2021 17:29:27 +0100
Message-Id: <20210729162932.30365-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729162932.30365-1-quentin@isovalent.com>
References: <20210729162932.30365-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever the eBPF subsystem gains new elements, such as new program or
map types, it is necessary to update bpftool if we want it able to
handle the new items.

In addition to the main arrays containing the names of these elements in
the source code, there are also multiple locations to update:

- The help message in the do_help() functions in bpftool's source code.
- The RST documentation files.
- The bash completion file.

This has led to omissions multiple times in the past. This patch
attempts to address this issue by adding consistency checks for all
these different locations. It also verifies that the bpf_prog_type,
bpf_map_type and bpf_attach_type enums from the UAPI BPF header have all
their members present in bpftool.

The script requires no argument to run, it reads and parses the
different files to check, and prints the mismatches, if any. It
currently reports a number of missing elements, which will be fixed in a
later patch:

  $ ./test_bpftool_synctypes.py
  Comparing [...]/linux/tools/bpf/bpftool/map.c (map_type_name) and [...]/linux/tools/bpf/bpftool/bash-completion/bpftool (BPFTOOL_MAP_CREATE_TYPES): {'ringbuf'}
  Comparing BPF header (enum bpf_attach_type) and [...]/linux/tools/bpf/bpftool/common.c (attach_type_name): {'BPF_TRACE_ITER', 'BPF_XDP_DEVMAP', 'BPF_XDP', 'BPF_SK_REUSEPORT_SELECT', 'BPF_XDP_CPUMAP', 'BPF_SK_REUSEPORT_SELECT_OR_MIGRATE'}
  Comparing [...]/linux/tools/bpf/bpftool/prog.c (attach_type_strings) and [...]/linux/tools/bpf/bpftool/prog.c (do_help() ATTACH_TYPE): {'skb_verdict'}
  Comparing [...]/linux/tools/bpf/bpftool/prog.c (attach_type_strings) and [...]/linux/tools/bpf/bpftool/Documentation/bpftool-prog.rst (ATTACH_TYPE): {'skb_verdict'}
  Comparing [...]/linux/tools/bpf/bpftool/prog.c (attach_type_strings) and [...]/linux/tools/bpf/bpftool/bash-completion/bpftool (BPFTOOL_PROG_ATTACH_TYPES): {'skb_verdict'}

Note that the script does NOT check for consistency between the list of
program types that bpftool claims it accepts and the actual list of
keywords that can be used. This is because bpftool does not "see" them,
they are ELF section names parsed by libbpf. It is not hard to parse the
section_defs[] array in libbpf, but some section names are associated
with program types that bpftool cannot load at the moment. For example,
some programs require a BTF target and an attach target that bpftool
cannot handle. The script may be extended to parse the array and check
only relevant values in the future.

In order to help maintain a good level of consistency for bpftool, the
script is added to the selftest suite for BPF.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/testing/selftests/bpf/Makefile          |   1 +
 .../selftests/bpf/test_bpftool_synctypes.py   | 486 ++++++++++++++++++
 2 files changed, 487 insertions(+)
 create mode 100755 tools/testing/selftests/bpf/test_bpftool_synctypes.py

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index f405b20c1e6c..d4955d056d19 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -72,6 +72,7 @@ TEST_PROGS := test_kmod.sh \
 	test_tc_edt.sh \
 	test_xdping.sh \
 	test_bpftool_build.sh \
+	test_bpftool_synctypes.py \
 	test_bpftool.sh \
 	test_bpftool_metadata.sh \
 	test_doc_build.sh \
diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
new file mode 100755
index 000000000000..b41464f46b3b
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
@@ -0,0 +1,486 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+#
+# Copyright (C) 2021 Isovalent, Inc.
+
+import argparse
+import re
+import os, sys
+
+LINUX_ROOT = os.path.abspath(os.path.join(__file__,
+    os.pardir, os.pardir, os.pardir, os.pardir, os.pardir))
+BPFTOOL_DIR = os.path.join(LINUX_ROOT, 'tools/bpf/bpftool')
+retval = 0
+
+class BlockParser(object):
+    """
+    A parser for extracting set of values from blocks such as enums.
+    @reader: a pointer to the open file to parse
+    """
+    def __init__(self, reader):
+        self.reader = reader
+
+    def search_block(self, start_marker):
+        """
+        Search for a given structure in a file.
+        @start_marker: regex marking the beginning of a structure to parse
+        """
+        offset = self.reader.tell()
+        array_start = re.search(start_marker, self.reader.read())
+        if array_start is None:
+            raise Exception('Failed to find start of block')
+        self.reader.seek(offset + array_start.start())
+
+    def parse(self, pattern, end_marker):
+        """
+        Parse a block and return a set of values. Values to extract must be
+        on separate lines in the file.
+        @pattern: pattern used to identify the values to extract
+        @end_marker: regex marking the end of the block to parse
+        """
+        entries = set()
+        while True:
+            line = self.reader.readline()
+            if not line or re.match(end_marker, line):
+                break
+            capture = pattern.search(line)
+            if capture and pattern.groups >= 1:
+                entries.add(capture.group(1))
+        return entries
+
+class ArrayParser(BlockParser):
+    """
+    A parser for extracting dicionaries of values from some BPF-related arrays.
+    @reader: a pointer to the open file to parse
+    @array_name: name of the array to parse
+    """
+    end_marker = re.compile('^};')
+
+    def __init__(self, reader, array_name):
+        self.array_name = array_name
+        self.start_marker = re.compile(f'(static )?const char \* const {self.array_name}\[.*\] = {{\n')
+        super().__init__(reader)
+
+    def search_block(self):
+        """
+        Search for the given array in a file.
+        """
+        super().search_block(self.start_marker);
+
+    def parse(self):
+        """
+        Parse a block and return data as a dictionary. Items to extract must be
+        on separate lines in the file.
+        """
+        pattern = re.compile('\[(BPF_\w*)\]\s*= "(.*)",?$')
+        entries = {}
+        while True:
+            line = self.reader.readline()
+            if line == '' or re.match(self.end_marker, line):
+                break
+            capture = pattern.search(line)
+            if capture:
+                entries[capture.group(1)] = capture.group(2)
+        return entries
+
+class InlineListParser(BlockParser):
+    """
+    A parser for extracting set of values from inline lists.
+    """
+    def parse(self, pattern, end_marker):
+        """
+        Parse a block and return a set of values. Multiple values to extract
+        can be on a same line in the file.
+        @pattern: pattern used to identify the values to extract
+        @end_marker: regex marking the end of the block to parse
+        """
+        entries = set()
+        while True:
+            line = self.reader.readline()
+            if not line:
+                break
+            entries.update(pattern.findall(line))
+            if re.search(end_marker, line):
+                break
+        return entries
+
+class FileExtractor(object):
+    """
+    A generic reader for extracting data from a given file. This class contains
+    several helper methods that wrap arround parser objects to extract values
+    from different structures.
+    This class does not offer a way to set a filename, which is expected to be
+    defined in children classes.
+    """
+    def __init__(self):
+        self.reader = open(self.filename, 'r')
+
+    def close(self):
+        """
+        Close the file used by the parser.
+        """
+        self.reader.close()
+
+    def reset_read(self):
+        """
+        Reset the file position indicator for this parser. This is useful when
+        parsing several structures in the file without respecting the order in
+        which those structures appear in the file.
+        """
+        self.reader.seek(0)
+
+    def get_types_from_array(self, array_name):
+        """
+        Search for and parse an array associating names to BPF_* enum members,
+        for example:
+
+            const char * const prog_type_name[] = {
+                    [BPF_PROG_TYPE_UNSPEC]                  = "unspec",
+                    [BPF_PROG_TYPE_SOCKET_FILTER]           = "socket_filter",
+                    [BPF_PROG_TYPE_KPROBE]                  = "kprobe",
+            };
+
+        Return a dictionary with the enum member names as keys and the
+        associated names as values, for example:
+
+            {'BPF_PROG_TYPE_UNSPEC': 'unspec',
+             'BPF_PROG_TYPE_SOCKET_FILTER': 'socket_filter',
+             'BPF_PROG_TYPE_KPROBE': 'kprobe'}
+
+        @array_name: name of the array to parse
+        """
+        array_parser = ArrayParser(self.reader, array_name)
+        array_parser.search_block()
+        return array_parser.parse()
+
+    def get_enum(self, enum_name):
+        """
+        Search for and parse an enum containing BPF_* members, for example:
+
+            enum bpf_prog_type {
+                    BPF_PROG_TYPE_UNSPEC,
+                    BPF_PROG_TYPE_SOCKET_FILTER,
+                    BPF_PROG_TYPE_KPROBE,
+            };
+
+        Return a set containing all member names, for example:
+
+            {'BPF_PROG_TYPE_UNSPEC',
+             'BPF_PROG_TYPE_SOCKET_FILTER',
+             'BPF_PROG_TYPE_KPROBE'}
+
+        @enum_name: name of the enum to parse
+        """
+        start_marker = re.compile(f'enum {enum_name} {{\n')
+        pattern = re.compile('^\s*(BPF_\w+),?$')
+        end_marker = re.compile('^};')
+        parser = BlockParser(self.reader)
+        parser.search_block(start_marker)
+        return parser.parse(pattern, end_marker)
+
+    def __get_description_list(self, start_marker, pattern, end_marker):
+        parser = InlineListParser(self.reader)
+        parser.search_block(start_marker)
+        return parser.parse(pattern, end_marker)
+
+    def get_rst_list(self, block_name):
+        """
+        Search for and parse a list of type names from RST documentation, for
+        example:
+
+             |       *TYPE* := {
+             |               **socket** | **kprobe** |
+             |               **kretprobe**
+             |       }
+
+        Return a set containing all type names, for example:
+
+            {'socket', 'kprobe', 'kretprobe'}
+
+        @block_name: name of the blog to parse, 'TYPE' in the example
+        """
+        start_marker = re.compile(f'\*{block_name}\* := {{')
+        pattern = re.compile('\*\*([\w/]+)\*\*')
+        end_marker = re.compile('}\n')
+        return self.__get_description_list(start_marker, pattern, end_marker)
+
+    def get_help_list(self, block_name):
+        """
+        Search for and parse a list of type names from a help message in
+        bpftool, for example:
+
+            "       TYPE := { socket | kprobe |\\n"
+            "               kretprobe }\\n"
+
+        Return a set containing all type names, for example:
+
+            {'socket', 'kprobe', 'kretprobe'}
+
+        @block_name: name of the blog to parse, 'TYPE' in the example
+        """
+        start_marker = re.compile(f'"\s*{block_name} := {{')
+        pattern = re.compile('([\w/]+) [|}]')
+        end_marker = re.compile('}')
+        return self.__get_description_list(start_marker, pattern, end_marker)
+
+    def get_bashcomp_list(self, block_name):
+        """
+        Search for and parse a list of type names from a variable in bash
+        completion file, for example:
+
+            local BPFTOOL_PROG_LOAD_TYPES='socket kprobe \\
+                kretprobe'
+
+        Return a set containing all type names, for example:
+
+            {'socket', 'kprobe', 'kretprobe'}
+
+        @block_name: name of the blog to parse, 'TYPE' in the example
+        """
+        start_marker = re.compile(f'local {block_name}=\'')
+        pattern = re.compile('(?:.*=\')?([\w/]+)')
+        end_marker = re.compile('\'$')
+        return self.__get_description_list(start_marker, pattern, end_marker)
+
+class ProgFileExtractor(FileExtractor):
+    """
+    An extractor for bpftool's prog.c.
+    """
+    filename = os.path.join(BPFTOOL_DIR, 'prog.c')
+
+    def get_prog_types(self):
+        return self.get_types_from_array('prog_type_name')
+
+    def get_attach_types(self):
+        return self.get_types_from_array('attach_type_strings')
+
+    def get_prog_attach_help(self):
+        return self.get_help_list('ATTACH_TYPE')
+
+class MapFileExtractor(FileExtractor):
+    """
+    An extractor for bpftool's map.c.
+    """
+    filename = os.path.join(BPFTOOL_DIR, 'map.c')
+
+    def get_map_types(self):
+        return self.get_types_from_array('map_type_name')
+
+    def get_map_help(self):
+        return self.get_help_list('TYPE')
+
+class CgroupFileExtractor(FileExtractor):
+    """
+    An extractor for bpftool's cgroup.c.
+    """
+    filename = os.path.join(BPFTOOL_DIR, 'cgroup.c')
+
+    def get_prog_attach_help(self):
+        return self.get_help_list('ATTACH_TYPE')
+
+class CommonFileExtractor(FileExtractor):
+    """
+    An extractor for bpftool's common.c.
+    """
+    filename = os.path.join(BPFTOOL_DIR, 'common.c')
+
+    def __init__(self):
+        super().__init__()
+        self.attach_types = {}
+
+    def get_attach_types(self):
+        if not self.attach_types:
+            self.attach_types = self.get_types_from_array('attach_type_name')
+        return self.attach_types
+
+    def get_cgroup_attach_types(self):
+        if not self.attach_types:
+            self.get_attach_types()
+        cgroup_types = {}
+        for (key, value) in self.attach_types.items():
+            if key.find('BPF_CGROUP') != -1:
+                cgroup_types[key] = value
+        return cgroup_types
+
+class BpfHeaderExtractor(FileExtractor):
+    """
+    An extractor for the UAPI BPF header.
+    """
+    filename = os.path.join(LINUX_ROOT, 'tools/include/uapi/linux/bpf.h')
+
+    def get_prog_types(self):
+        return self.get_enum('bpf_prog_type')
+
+    def get_map_types(self):
+        return self.get_enum('bpf_map_type')
+
+    def get_attach_types(self):
+        return self.get_enum('bpf_attach_type')
+
+class ManProgExtractor(FileExtractor):
+    """
+    An extractor for bpftool-prog.rst.
+    """
+    filename = os.path.join(BPFTOOL_DIR, 'Documentation/bpftool-prog.rst')
+
+    def get_attach_types(self):
+        return self.get_rst_list('ATTACH_TYPE')
+
+class ManMapExtractor(FileExtractor):
+    """
+    An extractor for bpftool-map.rst.
+    """
+    filename = os.path.join(BPFTOOL_DIR, 'Documentation/bpftool-map.rst')
+
+    def get_map_types(self):
+        return self.get_rst_list('TYPE')
+
+class ManCgroupExtractor(FileExtractor):
+    """
+    An extractor for bpftool-cgroup.rst.
+    """
+    filename = os.path.join(BPFTOOL_DIR, 'Documentation/bpftool-cgroup.rst')
+
+    def get_attach_types(self):
+        return self.get_rst_list('ATTACH_TYPE')
+
+class BashcompExtractor(FileExtractor):
+    """
+    An extractor for bpftool's bash completion file.
+    """
+    filename = os.path.join(BPFTOOL_DIR, 'bash-completion/bpftool')
+
+    def get_prog_attach_types(self):
+        return self.get_bashcomp_list('BPFTOOL_PROG_ATTACH_TYPES')
+
+    def get_map_types(self):
+        return self.get_bashcomp_list('BPFTOOL_MAP_CREATE_TYPES')
+
+    def get_cgroup_attach_types(self):
+        return self.get_bashcomp_list('BPFTOOL_CGROUP_ATTACH_TYPES')
+
+def verify(first_set, second_set, message):
+    """
+    Print all values that differ between two sets.
+    @first_set: one set to compare
+    @second_set: another set to compare
+    @message: message to print for values belonging to only one of the sets
+    """
+    global retval
+    diff = first_set.symmetric_difference(second_set)
+    if diff:
+        print(message, diff)
+        retval = 1
+
+def main():
+    # No arguments supported at this time, but print usage for -h|--help
+    argParser = argparse.ArgumentParser(description="""
+    Verify that bpftool's code, help messages, documentation and bash completion
+    are all in sync on program types, map types and attach types. Also check that
+    bpftool is in sync with the UAPI BPF header.
+    """)
+    args = argParser.parse_args()
+
+    # Map types (enum)
+
+    bpf_info = BpfHeaderExtractor()
+    ref = bpf_info.get_map_types()
+
+    map_info = MapFileExtractor()
+    source_map_items = map_info.get_map_types()
+    map_types_enum = set(source_map_items.keys())
+
+    verify(ref, map_types_enum,
+            f'Comparing BPF header (enum bpf_map_type) and {MapFileExtractor.filename} (map_type_name):')
+
+    # Map types (names)
+
+    source_map_types = set(source_map_items.values())
+    source_map_types.discard('unspec')
+
+    help_map_types = map_info.get_map_help()
+    map_info.close()
+
+    man_map_info = ManMapExtractor()
+    man_map_types = man_map_info.get_map_types()
+    man_map_info.close()
+
+    bashcomp_info = BashcompExtractor()
+    bashcomp_map_types = bashcomp_info.get_map_types()
+
+    verify(source_map_types, help_map_types,
+            f'Comparing {MapFileExtractor.filename} (map_type_name) and {MapFileExtractor.filename} (do_help() TYPE):')
+    verify(source_map_types, man_map_types,
+            f'Comparing {MapFileExtractor.filename} (map_type_name) and {ManMapExtractor.filename} (TYPE):')
+    verify(source_map_types, bashcomp_map_types,
+            f'Comparing {MapFileExtractor.filename} (map_type_name) and {BashcompExtractor.filename} (BPFTOOL_MAP_CREATE_TYPES):')
+
+    # Program types (enum)
+
+    ref = bpf_info.get_prog_types()
+
+    prog_info = ProgFileExtractor()
+    prog_types = set(prog_info.get_prog_types().keys())
+
+    verify(ref, prog_types,
+            f'Comparing BPF header (enum bpf_prog_type) and {ProgFileExtractor.filename} (prog_type_name):')
+
+    # Attach types (enum)
+
+    ref = bpf_info.get_attach_types()
+    bpf_info.close()
+
+    common_info = CommonFileExtractor()
+    attach_types = common_info.get_attach_types()
+
+    verify(ref, attach_types,
+            f'Comparing BPF header (enum bpf_attach_type) and {CommonFileExtractor.filename} (attach_type_name):')
+
+    # Attach types (names)
+
+    source_prog_attach_types = set(prog_info.get_attach_types().values())
+
+    help_prog_attach_types = prog_info.get_prog_attach_help()
+    prog_info.close()
+
+    man_prog_info = ManProgExtractor()
+    man_prog_attach_types = man_prog_info.get_attach_types()
+    man_prog_info.close()
+
+    bashcomp_info.reset_read() # We stopped at map types, rewind
+    bashcomp_prog_attach_types = bashcomp_info.get_prog_attach_types()
+
+    verify(source_prog_attach_types, help_prog_attach_types,
+            f'Comparing {ProgFileExtractor.filename} (attach_type_strings) and {ProgFileExtractor.filename} (do_help() ATTACH_TYPE):')
+    verify(source_prog_attach_types, man_prog_attach_types,
+            f'Comparing {ProgFileExtractor.filename} (attach_type_strings) and {ManProgExtractor.filename} (ATTACH_TYPE):')
+    verify(source_prog_attach_types, bashcomp_prog_attach_types,
+            f'Comparing {ProgFileExtractor.filename} (attach_type_strings) and {BashcompExtractor.filename} (BPFTOOL_PROG_ATTACH_TYPES):')
+
+    # Cgroup attach types
+
+    source_cgroup_attach_types = set(common_info.get_cgroup_attach_types().values())
+    common_info.close()
+
+    cgroup_info = CgroupFileExtractor()
+    help_cgroup_attach_types = cgroup_info.get_prog_attach_help()
+    cgroup_info.close()
+
+    man_cgroup_info = ManCgroupExtractor()
+    man_cgroup_attach_types = man_cgroup_info.get_attach_types()
+    man_cgroup_info.close()
+
+    bashcomp_cgroup_attach_types = bashcomp_info.get_cgroup_attach_types()
+    bashcomp_info.close()
+
+    verify(source_cgroup_attach_types, help_cgroup_attach_types,
+            f'Comparing {CommonFileExtractor.filename} (attach_type_strings) and {CgroupFileExtractor.filename} (do_help() ATTACH_TYPE):')
+    verify(source_cgroup_attach_types, man_cgroup_attach_types,
+            f'Comparing {CommonFileExtractor.filename} (attach_type_strings) and {ManCgroupExtractor.filename} (ATTACH_TYPE):')
+    verify(source_cgroup_attach_types, bashcomp_cgroup_attach_types,
+            f'Comparing {CommonFileExtractor.filename} (attach_type_strings) and {BashcompExtractor.filename} (BPFTOOL_CGROUP_ATTACH_TYPES):')
+
+    sys.exit(retval)
+
+if __name__ == "__main__":
+    main()
-- 
2.30.2

