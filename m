Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9BB3DA912
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 18:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhG2Q34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 12:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbhG2Q3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 12:29:49 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A717C0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:29:46 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id o5-20020a1c4d050000b02901fc3a62af78so7224536wmh.3
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XGkRAAqTxAjF9EcsI4nugVgwc7oa9GM7ddeJT589FrI=;
        b=UPluvTjfdpP/0OEgGg1VfSxmSxlnDWD7Me/Fi7i2DaJNHH2UsyYbEgye6s4C70ud+J
         YJ9dWHsYZH/r9L6B0XeQ4MvAKr2YXLJlrHi1vOifUr0GCrwwNQmRuQHaQQM0UrczZVi5
         l3bTj0HLU1WB8sBOyoSKz5VaDg/3ghFbhQN5oFiHJ/C5TvdQL3sJWFcZvn5zO3xi3Twi
         DtCnugGfLssn9NV9uI2XbdzljcGjpxzVJKBvvPRIiMa5g2Hnnk+/WQzH0stB/GwM0fxl
         +nYVOZZob2GjSaClYUGGKYGgPvs2XHQVz9CarWkqSHFhYQpQct45e7/Sf9E7ckeXyyja
         a2dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XGkRAAqTxAjF9EcsI4nugVgwc7oa9GM7ddeJT589FrI=;
        b=av+iO2+ftHaCJJYDhI3UmLaqo8xLmEVomih6s6utxTIIEuN902XrDOhHQBMjEO7hdj
         e1xerXJxraYCm3I6WpC5/7DvLfaFZ4j0wZ6dmzbrx21S0r0RjRWr5s9A7X8Wd2llQLIA
         aoQ1bthJCHvEO05xV/1PY3ND01GYrPMSPOZMeiaztRY/XttZEU7hl3ekz4UaBZ3aeq6u
         IcNbFVH/B48AkVG1D//tkxtURathkl0wVDMEVoFU+WcJcoFSwRBadOTyWpkZoeFC8XQh
         e1NEH1E8LXVGvfj441QjBpSPG1N/m447dRGKlC7XSlaL57+RX1gNH7qj+9dWXeXjNQoS
         D2Vw==
X-Gm-Message-State: AOAM531DPTrIgVHl8PskI+TA/D4YZhFSfXrKc43jX1m3OVst5iwCOar4
        PpnEGd0q/QKoUmSSW9fzZTZvkw==
X-Google-Smtp-Source: ABdhPJyMeM6pm+jNW3UDOGv7R2BONjYLhEoGxlI81TiyfeZXzxLynUaymMakX90Tg58L1SaFYcvFvA==
X-Received: by 2002:a05:600c:cc:: with SMTP id u12mr5628175wmm.63.1627576184620;
        Thu, 29 Jul 2021 09:29:44 -0700 (PDT)
Received: from localhost.localdomain ([149.86.75.13])
        by smtp.gmail.com with ESMTPSA id 140sm3859331wmb.43.2021.07.29.09.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 09:29:44 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 5/7] selftests/bpf: update bpftool's consistency script for checking options
Date:   Thu, 29 Jul 2021 17:29:30 +0100
Message-Id: <20210729162932.30365-6-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729162932.30365-1-quentin@isovalent.com>
References: <20210729162932.30365-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the script responsible for checking that the different types used
at various places in bpftool are synchronised, and extend it to check
the consistency of options between the help messages in the source code
and the manual pages.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 .../selftests/bpf/test_bpftool_synctypes.py   | 122 ++++++++++++++++--
 1 file changed, 111 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
index b41464f46b3b..be54b7335a76 100755
--- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
+++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
@@ -200,7 +200,7 @@ class FileExtractor(object):
         @block_name: name of the blog to parse, 'TYPE' in the example
         """
         start_marker = re.compile(f'\*{block_name}\* := {{')
-        pattern = re.compile('\*\*([\w/]+)\*\*')
+        pattern = re.compile('\*\*([\w/-]+)\*\*')
         end_marker = re.compile('}\n')
         return self.__get_description_list(start_marker, pattern, end_marker)
 
@@ -223,6 +223,31 @@ class FileExtractor(object):
         end_marker = re.compile('}')
         return self.__get_description_list(start_marker, pattern, end_marker)
 
+    def get_help_list_macro(self, macro):
+        """
+        Search for and parse a list of values from a help message starting with
+        a macro in bpftool, for example:
+
+            "       " HELP_SPEC_OPTIONS " |\\n"
+            "                    {-f|--bpffs} | {-m|--mapcompat} | {-n|--nomount} }\\n"
+
+        Return a set containing all item names, for example:
+
+            {'-f', '--bpffs', '-m', '--mapcompat', '-n', '--nomount'}
+
+        @macro: macro starting the block, 'HELP_SPEC_OPTIONS' in the example
+        """
+        start_marker = re.compile(f'"\s*{macro}\s*" [|}}]')
+        pattern = re.compile('([\w-]+) ?(?:\||}[ }\]])')
+        end_marker = re.compile('}\\\\n')
+        return self.__get_description_list(start_marker, pattern, end_marker)
+
+    def default_options(self):
+        """
+        Return the default options contained in HELP_SPEC_OPTIONS
+        """
+        return { '-j', '--json', '-p', '--pretty', '-d', '--debug' }
+
     def get_bashcomp_list(self, block_name):
         """
         Search for and parse a list of type names from a variable in bash
@@ -242,7 +267,16 @@ class FileExtractor(object):
         end_marker = re.compile('\'$')
         return self.__get_description_list(start_marker, pattern, end_marker)
 
-class ProgFileExtractor(FileExtractor):
+class SourceFileExtractor(FileExtractor):
+    """
+    An abstract extractor for a source file with usage message.
+    This class does not offer a way to set a filename, which is expected to be
+    defined in children classes.
+    """
+    def get_options(self):
+        return self.default_options().union(self.get_help_list_macro('HELP_SPEC_OPTIONS'))
+
+class ProgFileExtractor(SourceFileExtractor):
     """
     An extractor for bpftool's prog.c.
     """
@@ -257,7 +291,7 @@ class ProgFileExtractor(FileExtractor):
     def get_prog_attach_help(self):
         return self.get_help_list('ATTACH_TYPE')
 
-class MapFileExtractor(FileExtractor):
+class MapFileExtractor(SourceFileExtractor):
     """
     An extractor for bpftool's map.c.
     """
@@ -269,7 +303,7 @@ class MapFileExtractor(FileExtractor):
     def get_map_help(self):
         return self.get_help_list('TYPE')
 
-class CgroupFileExtractor(FileExtractor):
+class CgroupFileExtractor(SourceFileExtractor):
     """
     An extractor for bpftool's cgroup.c.
     """
@@ -278,7 +312,7 @@ class CgroupFileExtractor(FileExtractor):
     def get_prog_attach_help(self):
         return self.get_help_list('ATTACH_TYPE')
 
-class CommonFileExtractor(FileExtractor):
+class CommonFileExtractor(SourceFileExtractor):
     """
     An extractor for bpftool's common.c.
     """
@@ -302,6 +336,16 @@ class CommonFileExtractor(FileExtractor):
                 cgroup_types[key] = value
         return cgroup_types
 
+class GenericSourceExtractor(SourceFileExtractor):
+    """
+    An extractor for generic source code files.
+    """
+    filename = ""
+
+    def __init__(self, filename):
+        self.filename = os.path.join(BPFTOOL_DIR, filename)
+        super().__init__()
+
 class BpfHeaderExtractor(FileExtractor):
     """
     An extractor for the UAPI BPF header.
@@ -317,7 +361,16 @@ class BpfHeaderExtractor(FileExtractor):
     def get_attach_types(self):
         return self.get_enum('bpf_attach_type')
 
-class ManProgExtractor(FileExtractor):
+class ManPageExtractor(FileExtractor):
+    """
+    An abstract extractor for an RST documentation page.
+    This class does not offer a way to set a filename, which is expected to be
+    defined in children classes.
+    """
+    def get_options(self):
+        return self.get_rst_list('OPTIONS')
+
+class ManProgExtractor(ManPageExtractor):
     """
     An extractor for bpftool-prog.rst.
     """
@@ -326,7 +379,7 @@ class ManProgExtractor(FileExtractor):
     def get_attach_types(self):
         return self.get_rst_list('ATTACH_TYPE')
 
-class ManMapExtractor(FileExtractor):
+class ManMapExtractor(ManPageExtractor):
     """
     An extractor for bpftool-map.rst.
     """
@@ -335,7 +388,7 @@ class ManMapExtractor(FileExtractor):
     def get_map_types(self):
         return self.get_rst_list('TYPE')
 
-class ManCgroupExtractor(FileExtractor):
+class ManCgroupExtractor(ManPageExtractor):
     """
     An extractor for bpftool-cgroup.rst.
     """
@@ -344,6 +397,16 @@ class ManCgroupExtractor(FileExtractor):
     def get_attach_types(self):
         return self.get_rst_list('ATTACH_TYPE')
 
+class ManGenericExtractor(ManPageExtractor):
+    """
+    An extractor for generic RST documentation pages.
+    """
+    filename = ""
+
+    def __init__(self, filename):
+        self.filename = os.path.join(BPFTOOL_DIR, filename)
+        super().__init__()
+
 class BashcompExtractor(FileExtractor):
     """
     An extractor for bpftool's bash completion file.
@@ -375,9 +438,9 @@ def verify(first_set, second_set, message):
 def main():
     # No arguments supported at this time, but print usage for -h|--help
     argParser = argparse.ArgumentParser(description="""
-    Verify that bpftool's code, help messages, documentation and bash completion
-    are all in sync on program types, map types and attach types. Also check that
-    bpftool is in sync with the UAPI BPF header.
+    Verify that bpftool's code, help messages, documentation and bash
+    completion are all in sync on program types, map types, attach types, and
+    options. Also check that bpftool is in sync with the UAPI BPF header.
     """)
     args = argParser.parse_args()
 
@@ -399,9 +462,11 @@ def main():
     source_map_types.discard('unspec')
 
     help_map_types = map_info.get_map_help()
+    help_map_options = map_info.get_options()
     map_info.close()
 
     man_map_info = ManMapExtractor()
+    man_map_options = man_map_info.get_options()
     man_map_types = man_map_info.get_map_types()
     man_map_info.close()
 
@@ -412,6 +477,8 @@ def main():
             f'Comparing {MapFileExtractor.filename} (map_type_name) and {MapFileExtractor.filename} (do_help() TYPE):')
     verify(source_map_types, man_map_types,
             f'Comparing {MapFileExtractor.filename} (map_type_name) and {ManMapExtractor.filename} (TYPE):')
+    verify(help_map_options, man_map_options,
+            f'Comparing {MapFileExtractor.filename} (do_help() OPTIONS) and {ManMapExtractor.filename} (OPTIONS):')
     verify(source_map_types, bashcomp_map_types,
             f'Comparing {MapFileExtractor.filename} (map_type_name) and {BashcompExtractor.filename} (BPFTOOL_MAP_CREATE_TYPES):')
 
@@ -441,9 +508,11 @@ def main():
     source_prog_attach_types = set(prog_info.get_attach_types().values())
 
     help_prog_attach_types = prog_info.get_prog_attach_help()
+    help_prog_options = prog_info.get_options()
     prog_info.close()
 
     man_prog_info = ManProgExtractor()
+    man_prog_options = man_prog_info.get_options()
     man_prog_attach_types = man_prog_info.get_attach_types()
     man_prog_info.close()
 
@@ -454,6 +523,8 @@ def main():
             f'Comparing {ProgFileExtractor.filename} (attach_type_strings) and {ProgFileExtractor.filename} (do_help() ATTACH_TYPE):')
     verify(source_prog_attach_types, man_prog_attach_types,
             f'Comparing {ProgFileExtractor.filename} (attach_type_strings) and {ManProgExtractor.filename} (ATTACH_TYPE):')
+    verify(help_prog_options, man_prog_options,
+            f'Comparing {ProgFileExtractor.filename} (do_help() OPTIONS) and {ManProgExtractor.filename} (OPTIONS):')
     verify(source_prog_attach_types, bashcomp_prog_attach_types,
             f'Comparing {ProgFileExtractor.filename} (attach_type_strings) and {BashcompExtractor.filename} (BPFTOOL_PROG_ATTACH_TYPES):')
 
@@ -464,9 +535,11 @@ def main():
 
     cgroup_info = CgroupFileExtractor()
     help_cgroup_attach_types = cgroup_info.get_prog_attach_help()
+    help_cgroup_options = cgroup_info.get_options()
     cgroup_info.close()
 
     man_cgroup_info = ManCgroupExtractor()
+    man_cgroup_options = man_cgroup_info.get_options()
     man_cgroup_attach_types = man_cgroup_info.get_attach_types()
     man_cgroup_info.close()
 
@@ -477,9 +550,36 @@ def main():
             f'Comparing {CommonFileExtractor.filename} (attach_type_strings) and {CgroupFileExtractor.filename} (do_help() ATTACH_TYPE):')
     verify(source_cgroup_attach_types, man_cgroup_attach_types,
             f'Comparing {CommonFileExtractor.filename} (attach_type_strings) and {ManCgroupExtractor.filename} (ATTACH_TYPE):')
+    verify(help_cgroup_options, man_cgroup_options,
+            f'Comparing {CgroupFileExtractor.filename} (do_help() OPTIONS) and {ManCgroupExtractor.filename} (OPTIONS):')
     verify(source_cgroup_attach_types, bashcomp_cgroup_attach_types,
             f'Comparing {CommonFileExtractor.filename} (attach_type_strings) and {BashcompExtractor.filename} (BPFTOOL_CGROUP_ATTACH_TYPES):')
 
+    # Options for remaining commands
+
+    for cmd in [ 'btf', 'feature', 'gen', 'iter', 'link', 'net', 'perf', 'struct_ops', ]:
+        source_info = GenericSourceExtractor(cmd + '.c')
+        help_cmd_options = source_info.get_options()
+        source_info.close()
+
+        man_cmd_info = ManGenericExtractor(os.path.join('Documentation', 'bpftool-' + cmd + '.rst'))
+        man_cmd_options = man_cmd_info.get_options()
+        man_cmd_info.close()
+
+        verify(help_cmd_options, man_cmd_options,
+                f'Comparing {source_info.filename} (do_help() OPTIONS) and {man_cmd_info.filename} (OPTIONS):')
+
+    source_main_info = GenericSourceExtractor('main.c')
+    help_main_options = source_main_info.get_options()
+    source_main_info.close()
+
+    man_main_info = ManGenericExtractor(os.path.join('Documentation', 'bpftool.rst'))
+    man_main_options = man_main_info.get_options()
+    man_main_info.close()
+
+    verify(help_main_options, man_main_options,
+            f'Comparing {source_main_info.filename} (do_help() OPTIONS) and {man_main_info.filename} (OPTIONS):')
+
     sys.exit(retval)
 
 if __name__ == "__main__":
-- 
2.30.2

