Return-Path: <netdev+bounces-11152-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BCEA731C39
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:14:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BD7F280F33
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9745213AFF;
	Thu, 15 Jun 2023 15:14:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F8812B94
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 15:14:01 +0000 (UTC)
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC01626A2
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:13:58 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 3f1490d57ef6-bc43a73ab22so1423272276.0
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686842037; x=1689434037;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aqYKtvw3GEG0idWvefq3MdvWilVH8efKLWRHwyyttpg=;
        b=UE/Q+xHsvEosbtLg+KcbAlvQWmsLu9y5WLBqEfNLapw71amUOCZ3FR0hMMyp92YVFb
         L6qzo9Vkr2fn+uG4ekBByf0vCKiBiG4Mw7EpwOQcDrJ4/+3Z0WrOX0EDFlyH0rO4yM8k
         0fAnENrXVjBYGseKrIcNtyBxIa/4SyeKdoUkLH+yJgwJ2cBY319QQHTr7a6NPLZ/80zu
         uVma+uVBd65R8uh5nlcvGqm2RnST6Fy1envqXxhLDUihMwKi+1mAo1m9TBYyK5OlXYvl
         ZZfBay9AMZq2RImIMofYSW/TBPc7JWOauB9GhM1cVupkc5QH+GwVfwDObNYRxURgmNZH
         9gbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686842037; x=1689434037;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aqYKtvw3GEG0idWvefq3MdvWilVH8efKLWRHwyyttpg=;
        b=kYHJY3C7BsN6LdQF3iNFZtHKcfcZ9OYzB74FRWU7ZIp8G0QRyU5dFu0hwHxevKefUM
         PaTPnExoj07+dufpem46u8hxgvW8gOsOwIArq+4O7fvAbbRLhHn+dAkVNKxaJZsB3eY0
         zJuEoyVducAy0t92Tvz20KkrnIXzC9djGjWUmU2C5GgiFrVtR+Ontup1PN7DJSde+HbY
         cXcyDo832XznnNyDsrTexXt1vLbzV7owXhtcXGch/veczyeRg/nTOsbzOBx/eu7iWCsl
         jx10Tc5NjAFO5C4klRZPYCR7LGEGo/oPQPY1OvJUjzmFhlpk3NG9xJRnnqcVVSkJlJze
         CqEg==
X-Gm-Message-State: AC+VfDw6RcUFJqtmaLEpS8WOipYRbZJwyZWXrDjCJnZt0sDYuZKbhVkm
	UbqWUDJHzYojn64a+yQ5I1l8LrbNF+eZpg==
X-Google-Smtp-Source: ACHHUZ585oA1OF7dPHEwX33FVkNZE7lEyizbo9kz2ha9Kus3mD1CT/KV96DsjhqyySQ/NofmeVsekQ==
X-Received: by 2002:a25:c749:0:b0:bb1:76ca:d1f9 with SMTP id w70-20020a25c749000000b00bb176cad1f9mr6395821ybe.20.1686842037237;
        Thu, 15 Jun 2023 08:13:57 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:e5ff:b5f:79c3:16ef])
        by smtp.gmail.com with ESMTPSA id e195-20020a25d3cc000000b00bc49e4ce08csm2934694ybf.62.2023.06.15.08.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 08:13:55 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [RFC net-next v1] tools: ynl: Add an strace rendering mode to ynl-gen
Date: Thu, 15 Jun 2023 16:13:36 +0100
Message-Id: <20230615151336.77589-1-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add --mode strace to ynl-gen-c.py to generate source files for strace
that teach it to understand how to decode genetlink messages defined
in the spec. I successfully used this to add openvswitch message
decoding to strace as I described in:

https://donaldh.wtf/2023/06/teaching-strace-new-tricks/

It successfully generated ovs_datapath and ovs_vport but ovs_flow
needed manual fixes to fix code ordering and forward declarations.

Limitations:

- Uses a crude mechanism to try and emit functions in the right order
  which fails for ovs_flow
- Outputs all strace sources to stdout or a single file
- Does not use the right semantic strace decoders for e.g. IP or MAC
  addresses because there is no schema information to say what the
  domain type is.

This seems like a useful tool to have as part of the ynl suite since
it lowers the cost of getting good strace support for new netlink
families. But I realise that the generated format is dependent on an
out of tree project. If there is interest in having this in-tree then
I can clean it up and address some of the limitations before
submission.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 tools/net/ynl/ynl-gen-c.py | 286 +++++++++++++++++++++++++++++++++++++
 1 file changed, 286 insertions(+)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 71c5e79e877f..efd87d8463ed 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -2268,6 +2268,288 @@ def render_user_family(family, cw, prototype):
     cw.block_end(line=';')
 
 
+def render_strace(family, cw):
+
+    xlat_headers = []
+
+    # xlat for definitions
+
+    defines = []
+    for const in family['definitions']:
+        if const['type'] != 'const':
+            cw.writes_defines(defines)
+            defines = []
+            cw.nl()
+
+        if const['type'] == 'enum' or const['type'] == 'flags':
+            enum = family.consts[const['name']]
+
+            xlat_name = f"{family.name}_{c_lower(const['name'])}"
+            xlat_headers.append(xlat_name)
+
+            cw.p(f"// For src/xlat/{xlat_name}.in")
+            cw.p('#unconditional')
+            if const['type'] == 'enum':
+                cw.p('#value_indexed')
+
+            name_pfx = const.get('name-prefix', f"{family.name}-{const['name']}-")
+            for entry in enum.entries.values():
+                cw.p(entry.c_name)
+
+            cw.nl()
+        elif const['type'] == 'const':
+            defines.append([c_upper(family.get('c-define-name',
+                                               f"{family.name}-{const['name']}")),
+                            const['value']])
+
+    if defines:
+        cw.writes_defines(defines)
+        cw.nl()
+
+    # xlat for attrs
+
+    for _, attr_set in family.attr_sets.items():
+        if attr_set.subset_of:
+            continue
+
+        xlat_name = c_lower(attr_set.yaml['enum-name'])
+        xlat_headers.append(xlat_name)
+
+        cw.p(f"// For src/xlat/{xlat_name}.in")
+        cw.p('#unconditional')
+        cw.p('#value_indexed')
+
+        for _, attr in attr_set.items():
+            cw.p(attr.enum_name)
+        cw.nl()
+
+    # xlat for commands
+
+    separate_ntf = 'async-prefix' in family['operations']
+
+    xlat_name = f"{family.name}_cmds"
+    xlat_headers.append(xlat_name)
+
+    cw.p(f"// For src/xlat/{xlat_name}.in")
+    cw.p('#unconditional')
+    cw.p('#value_indexed')
+
+    for op in family.msgs.values():
+        if separate_ntf and ('notify' in op or 'event' in op):
+            continue
+
+        cw.p(op.enum_name)
+    cw.nl()
+
+    if separate_ntf:
+        uapi_enum_start(family, cw, family['operations'], enum_name='async-enum')
+        for op in family.msgs.values():
+            if separate_ntf and not ('notify' in op or 'event' in op):
+                continue
+
+            suffix = ','
+            if 'value' in op:
+                suffix = f" = {op['value']},"
+            cw.p(op.enum_name + suffix)
+        cw.block_end(line=';')
+        cw.nl()
+
+    cw.nl()
+    if defines:
+        cw.writes_defines(defines)
+        cw.nl()
+
+    # Bind into netlink_generic.(c|h)
+
+    cw.p('// Add to src/netlink_generic.h')
+    cw.p(f"extern DECL_NETLINK_GENERIC_DECODER(decode_{family.name}_msg);")
+    cw.nl()
+
+    cw.p('// Add to src/netlink_generic.c in genl_decoders[]')
+    cw.p(f"""\t{{ "{family.name}", decode_{family.name}_msg }},""")
+    cw.nl()
+
+    # strace Makefile
+
+    cw.p('// Add to src/Makefile.am in libstrace_a_SOURCES')
+    cw.p(f"\t{family.name}.c \\")
+    cw.nl()
+
+    # Start of C source file
+
+    cw.p(f"// For src/{family.name}.c")
+    cw.nl()
+
+    cw.p('#include "defs.h"')
+    cw.p('#include "netlink.h"')
+    cw.p('#include "nlattr.h"')
+    cw.p('#include <linux/genetlink.h>')
+    cw.p(f"#include <{family['uapi-header']}>")
+    cw.p('#include "netlink_generic.h"')
+    for h in xlat_headers:
+        cw.p(f"#include \"xlat/{h}.h\"")
+    cw.nl()
+
+    # C code for flags, enum and struct decoders
+
+    for defn in family['definitions']:
+        if defn['type'] in [ 'flags', 'enum' ]:
+            prefix = defn.get('name-prefix', f"{family.name}-{defn['name']}-")
+
+            cw.p('static bool')
+            cw.p(f"decode_{c_lower(defn['name'])}(struct tcb *const tcp,")
+            cw.p("\t\tconst kernel_ulong_t addr,")
+            cw.p("\t\tconst unsigned int len,")
+            cw.p("\t\tconst void *const opaque_data)")
+            cw.block_start()
+            cw.block_start("static const struct decode_nla_xlat_opts opts =")
+            cw.p(f"""{family.name}_{c_lower(defn['name'])}, "{c_upper(prefix)}???", .size = 4""")
+            cw.block_end(';')
+            decoder = 'xval' if defn['type'] == 'enum' else 'flags'
+            cw.p(f"return decode_nla_{decoder}(tcp, addr, len, &opts);")
+            cw.block_end()
+
+        elif defn['type'] == 'struct':
+            struct_name = c_lower(defn['enum-name'] if 'enum-name' in defn else defn['name'])
+            var_name = c_lower(defn['name'])
+
+            cw.p('static bool')
+            cw.p(f"decode_{struct_name}(struct tcb *const tcp,")
+            cw.p("\t\tconst kernel_ulong_t addr,")
+            cw.p("\t\tconst unsigned int len,")
+            cw.p("\t\tconst void *const opaque_data)")
+            cw.block_start()
+
+            cw.p(f"struct {struct_name} {var_name};")
+            cw.p(f"umove_or_printaddr(tcp, addr, &{var_name});")
+            cw.nl()
+
+            for m in defn['members']:
+                if m['name'].startswith('pad'):
+                    continue
+                cw.p(f"PRINT_FIELD_U({var_name}, {c_lower(m['name'])});")
+                cw.p('tprint_struct_next();')
+
+            cw.p('return true;')
+            cw.block_end()
+
+        cw.nl()
+
+    # C code for attibute set decoders
+
+    for _, attr_set in family.attr_sets.items():
+        if attr_set.subset_of:
+            continue
+
+        # Emit nested attr decoders before referencing them
+
+        for _, attr in attr_set.items():
+            if type(attr) in [ TypeNest, TypeArrayNest ]:
+                decoder = f"decode_{c_lower(attr.enum_name)}"
+                nested_set = family.attr_sets[attr['nested-attributes']]
+                nested_attrs = f"{c_lower(nested_set.yaml['enum-name'])}"
+                name_prefix = nested_set.yaml.get('name-prefix',
+                                                  f"{family.name}-{nested_set.name}-")
+                attr_prefix = f"{c_upper(name_prefix)}"
+                decoder_array = f"{c_lower(nested_set.name)}_attr_decoders"
+                array_nest = "_item" if type(attr) == TypeArrayNest else ""
+
+                cw.p('static bool')
+                cw.p(f"{decoder}{array_nest}(struct tcb *const tcp,")
+                cw.p("\tconst kernel_ulong_t addr,")
+                cw.p("\tconst unsigned int len,")
+                cw.p("\tconst void *const opaque_data)")
+                cw.block_start()
+                cw.p(f"decode_nlattr(tcp, addr, len, {nested_attrs},")
+                cw.p(f"\t\"{attr_prefix}???\",")
+                cw.p(f"\tARRSZ_PAIR({decoder_array}),")
+                cw.p("\tNULL);")
+                cw.p('return true;')
+                cw.block_end()
+                cw.nl()
+
+            if type(attr) == TypeArrayNest:
+                cw.p('static bool')
+                cw.p(f"{decoder}(struct tcb *const tcp,")
+                cw.p("\tconst kernel_ulong_t addr,")
+                cw.p("\tconst unsigned int len,")
+                cw.p("\tconst void *const opaque_data)")
+                cw.block_start()
+                cw.p(f"nla_decoder_t decoder = &{decoder}_item;")
+                cw.p('decode_nlattr(tcp, addr, len, NULL, NULL, &decoder, 0, NULL);')
+                cw.p('return true;')
+                cw.block_end()
+                cw.nl()
+
+        # Then emit the decoders array
+
+        cw.block_start(f"static const nla_decoder_t {c_lower(attr_set.name)}_attr_decoders[] =")
+        for _, attr in attr_set.items():
+            if type(attr) in [ TypeUnused, TypeFlag ]:
+                decoder = 'NULL'
+            elif type(attr) == TypeString:
+                decoder = 'decode_nla_str'
+            elif type(attr) == TypeBinary:
+                decoder = 'NULL'
+                if 'struct' in attr.yaml:
+                    defn = family.consts[attr.yaml['struct']]
+                    enum_name = c_lower(defn.get('enum-name', defn.name))
+                    decoder = f"decode_{enum_name}"
+            elif type(attr) == TypeNest:
+                decoder = f"decode_{c_lower(attr.enum_name)}"
+            elif type(attr) == TypeScalar and 'enum' in attr:
+                decoder = f"decode_{c_lower(attr['enum'])}"
+            else:
+                decoder = f"decode_nla_{attr.type}"
+
+            cw.p(f"[{attr.enum_name}] = {decoder},")
+        cw.block_end(';')
+        cw.nl()
+
+    # C code for top-level decoder
+
+    for op in family.msgs.values():
+        cmd_prefix = c_upper(family.yaml['operations']['name-prefix'])
+        attr_set_name = op.yaml['attribute-set']
+        attr_set = family.attr_sets[attr_set_name]
+        name_prefix = c_upper(attr_set.yaml.get('name-prefix', attr_set_name))
+        enum_name = c_lower(attr_set.yaml['enum-name'])
+
+        cw.block_start(f"DECL_NETLINK_GENERIC_DECODER(decode_{family.name}_msg)")
+
+        if op.fixed_header:
+            defn = family.consts[op.fixed_header]
+            header_name = c_lower(defn['name'])
+            cw.p(f"struct {header_name} header;")
+            cw.p(f"size_t offset = sizeof(struct {header_name});")
+            cw.nl()
+
+        cw.p('tprint_struct_begin();')
+        cw.p(f"""PRINT_FIELD_XVAL(*genl, cmd, {family.name}_cmds, "{cmd_prefix}???");""");
+        cw.p('tprint_struct_next();')
+        cw.p('PRINT_FIELD_U(*genl, version);')
+        cw.p('tprint_struct_next();')
+
+        if op.fixed_header:
+            cw.p('if (umove_or_printaddr(tcp, addr, &header))')
+            cw.p('return;')
+            for m in defn.members:
+                cw.p(f"PRINT_FIELD_U(header, {c_lower(m.name)});")
+                cw.p('tprint_struct_next();')
+            cw.nl()
+            cw.p(f"decode_nlattr(tcp, addr + offset, len - offset,");
+        else:
+            cw.p(f"decode_nlattr(tcp, addr, len,");
+
+        cw.p(f"\t{enum_name},");
+        cw.p(f"\t\"{name_prefix}???\",");
+        cw.p(f"\tARRSZ_PAIR({c_lower(attr_set_name)}_attr_decoders),");
+        cw.p("\tNULL);")
+        cw.p('tprint_struct_end();')
+        cw.block_end()
+        break
+
+
 def find_kernel_root(full_path):
     sub_path = ''
     while True:
@@ -2335,6 +2617,10 @@ def main():
         render_uapi(parsed, cw)
         return
 
+    if args.mode == 'strace':
+        render_strace(parsed, cw)
+        return
+
     hdr_prot = f"_LINUX_{parsed.name.upper()}_GEN_H"
     if args.header:
         cw.p('#ifndef ' + hdr_prot)
-- 
2.39.0


