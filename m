Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC166BCEDF
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 13:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjCPMCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 08:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjCPMCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 08:02:10 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD25C4E89
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 05:02:04 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id p93so860439qvp.1
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 05:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678968123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t96NUEm1MW+97uyGSSV7pnfBnH1c8q7yHk0BUPjlRGM=;
        b=XhgGMyq1aHEEgsFf71Lw0jIEgHkugZKih7OU4yT3i52Tl7bpk6m0AYNfkUAq9wmWjy
         XCMCe4xNEIXAxnCJ8YRMl5Up+nCfVyfMm1+Z5ZnRzAtvRsYXqwDDYDSlsE3PAimd4Txw
         Z+S3QdUJK7VSGNL65tBLGR1tpHrFSIEYKiIKbwT3ImsbOdaLDOoCPkeWxUbyxSkUePga
         +XoUCQQPoDq0x8Vy2ZKdqRNGAFrkntnfCQsQ/w3+Zpq40T2fhYaeWD9+8JAaIuh9rjNm
         U3fLlSbhSvbOst4r6DXiLAMwiQTRH8t7/UD2pL73sN1/SH0L4iYTvF7/PoBqEYfuIOPH
         s7uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678968123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t96NUEm1MW+97uyGSSV7pnfBnH1c8q7yHk0BUPjlRGM=;
        b=of7dfOX+Xa0KfViWSizWu/rgX4aH2Awa8/dbCCLm84xOJlzHM5tjbt0tqwcHhYg9MT
         NAP8N8MmiI5iH9w1A6FX9TTlMC3d12X90stcJr1eSh2DU2A7Snw3WLLLsOyjscnt4kDH
         /jX7/D5qWrsPz9zAOthUs4uEFZ+uGAZC6unSRxwNoz9FxPVz3s1sMmK1pXR5Suqu3fWQ
         j/cydUxhaN5JqKF8plhNIL/CwKGWvvh3+j6mIspKlQlH3eHg95wBj1Oz0DiOVqM0Tw/P
         g/IPGKOjfcuxYcit4xnmdrFyYBhsX5o7oLnq9jFuOwQwwNd757Ig1tWb1CGAtz9kbT+z
         e5JQ==
X-Gm-Message-State: AO0yUKV4HyFC4f/3vZjFnqmZu38Ii6FVwxBzZMcCxE3hg4HddkVXIxtf
        SGNiThjOIXHJRbCY8pGDvowHFqN20QraXw==
X-Google-Smtp-Source: AK7set/7eJhv9gZ4AYG4uWNjvgaRjGx2NRekqUs7XGFkVhhE3sqtmbTYBVnjcUQCsBzM4cCboLT0OQ==
X-Received: by 2002:a05:6214:f06:b0:53a:bf63:b053 with SMTP id gw6-20020a0562140f0600b0053abf63b053mr37095350qvb.45.1678968123302;
        Thu, 16 Mar 2023 05:02:03 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:dc26:c93f:e030:938d])
        by smtp.gmail.com with ESMTPSA id g14-20020a05620a218e00b007457bc9a047sm5643743qka.50.2023.03.16.05.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 05:02:02 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v1 1/2] tools: ynl: add user-header and struct attr support
Date:   Thu, 16 Mar 2023 12:01:41 +0000
Message-Id: <20230316120142.94268-2-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230316120142.94268-1-donald.hunter@gmail.com>
References: <20230316120142.94268-1-donald.hunter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 Documentation/netlink/genetlink-legacy.yaml | 10 +++-
 tools/net/ynl/lib/ynl.py                    | 58 ++++++++++++++++++---
 2 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
index c6b8c77f7d12..7f019c0a9762 100644
--- a/Documentation/netlink/genetlink-legacy.yaml
+++ b/Documentation/netlink/genetlink-legacy.yaml
@@ -53,6 +53,9 @@ properties:
       Defines if the input policy in the kernel is global, per-operation, or split per operation type.
       Default is split.
     enum: [ split, per-op, global ]
+  user-header:
+    description: Name of the struct definition for the user header for the family.
+    type: string
   # End genetlink-legacy
 
   definitions:
@@ -172,7 +175,7 @@ properties:
                 type: string
               type: &attr-type
                 enum: [ unused, pad, flag, binary, u8, u16, u32, u64, s32, s64,
-                        string, nest, array-nest, nest-type-value ]
+                        string, nest, array-nest, nest-type-value, struct ]
               doc:
                 description: Documentation of the attribute.
                 type: string
@@ -218,6 +221,11 @@ properties:
                     description: Max length for a string or a binary attribute.
                     $ref: '#/$defs/len-or-define'
               sub-type: *attr-type
+              # Start genetlink-legacy
+              struct:
+                description: Name of the struct type used for the attribute.
+                type: string
+              # End genetlink-legacy
 
       # Make sure name-prefix does not appear in subsets (subsets inherit naming)
       dependencies:
diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 90764a83c646..584b1e0a6b2f 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -68,6 +68,11 @@ class Netlink:
 
 
 class NlAttr:
+    type_formats = { 'u8' : ('B', 1),
+                     'u16': ('H', 2),
+                     'u32': ('I', 4),
+                     'u64': ('Q', 8) }
+
     def __init__(self, raw, offset):
         self._len, self._type = struct.unpack("HH", raw[offset:offset + 4])
         self.type = self._type & ~Netlink.NLA_TYPE_MASK
@@ -93,6 +98,21 @@ class NlAttr:
     def as_bin(self):
         return self.raw
 
+    def as_array(self, type):
+        format, _ = self.type_formats[type]
+        return list({ x[0] for x in struct.iter_unpack(format, self.raw) })
+
+    def as_struct(self, members):
+        value = dict()
+        offset = 0
+        for m in members:
+            type = m['type']
+            format, size = self.type_formats[type]
+            decoded = struct.unpack_from(format, self.raw, offset)
+            offset += size
+            value[m['name']] = decoded[0]
+        return value
+
     def __repr__(self):
         return f"[type:{self.type} len:{self._len}] {self.raw}"
 
@@ -200,7 +220,7 @@ def _genl_msg(nl_type, nl_flags, genl_cmd, genl_version, seq=None):
     if seq is None:
         seq = random.randint(1, 1024)
     nlmsg = struct.pack("HHII", nl_type, nl_flags, seq, 0)
-    genlmsg = struct.pack("bbH", genl_cmd, genl_version, 0)
+    genlmsg = struct.pack("BBH", genl_cmd, genl_version, 0)
     return nlmsg + genlmsg
 
 
@@ -258,14 +278,22 @@ def _genl_load_families():
 
 
 class GenlMsg:
-    def __init__(self, nl_msg):
+    def __init__(self, nl_msg, extra_headers = []):
         self.nl = nl_msg
 
         self.hdr = nl_msg.raw[0:4]
-        self.raw = nl_msg.raw[4:]
+        offset = 4
 
-        self.genl_cmd, self.genl_version, _ = struct.unpack("bbH", self.hdr)
+        self.genl_cmd, self.genl_version, _ = struct.unpack("BBH", self.hdr)
 
+        self.user_attrs = dict()
+        for m in extra_headers:
+            format, size = NlAttr.type_formats[m['type']]
+            decoded = struct.unpack_from(format, nl_msg.raw, offset)
+            offset += size
+            self.user_attrs[m['name']] = decoded[0]
+
+        self.raw = nl_msg.raw[offset:]
         self.raw_attrs = NlAttrs(self.raw)
 
     def __repr__(self):
@@ -315,6 +343,7 @@ class YnlFamily(SpecFamily):
             setattr(self, op.ident_name, bound_f)
 
         self.family = GenlFamily(self.yaml['name'])
+        self._user_header = self.yaml.get('user-header', None)
 
     def ntf_subscribe(self, mcast_name):
         if mcast_name not in self.family.genl_family['mcast']:
@@ -358,7 +387,7 @@ class YnlFamily(SpecFamily):
                 raw >>= 1
                 i += 1
         else:
-            value = enum['entries'][raw - i]
+            value = enum.entries_by_val[raw - i]['name']
         rsp[attr_spec['name']] = value
 
     def _decode(self, attrs, space):
@@ -381,6 +410,14 @@ class YnlFamily(SpecFamily):
                 decoded = attr.as_bin()
             elif attr_spec["type"] == 'flag':
                 decoded = True
+            elif attr_spec["type"] == 'struct':
+                s = attr_spec['struct']
+                decoded = attr.as_struct(self.consts[s]['members'])
+            elif attr_spec["type"] == 'array-nest':
+                decoded = attr.as_array(attr_spec["sub-type"])
+            elif attr_spec["type"] == 'unused':
+                print(f"Warning: skipping unused attribute {attr_spec['name']}")
+                continue
             else:
                 raise Exception(f'Unknown {attr.type} {attr_spec["name"]} {attr_spec["type"]}')
 
@@ -472,6 +509,13 @@ class YnlFamily(SpecFamily):
 
         req_seq = random.randint(1024, 65535)
         msg = _genl_msg(self.family.family_id, nl_flags, op.req_value, 1, req_seq)
+        user_headers = []
+        if self._user_header:
+            user_headers = self.consts[self._user_header]['members']
+            for m in user_headers:
+                value = vals.pop(m['name'])
+                format, _ = NlAttr.type_formats[m['type']]
+                msg += struct.pack(format, value)
         for name, value in vals.items():
             msg += self._add_attr(op.attr_set.name, name, value)
         msg = _genl_msg_finalize(msg)
@@ -498,7 +542,7 @@ class YnlFamily(SpecFamily):
                     done = True
                     break
 
-                gm = GenlMsg(nl_msg)
+                gm = GenlMsg(nl_msg, user_headers)
                 # Check if this is a reply to our request
                 if nl_msg.nl_seq != req_seq or gm.genl_cmd != op.rsp_value:
                     if gm.genl_cmd in self.async_msg_ids:
@@ -508,7 +552,7 @@ class YnlFamily(SpecFamily):
                         print('Unexpected message: ' + repr(gm))
                         continue
 
-                rsp.append(self._decode(gm.raw_attrs, op.attr_set.name))
+                rsp.append(self._decode(gm.raw_attrs, op.attr_set.name) | gm.user_attrs)
 
         if not rsp:
             return None
-- 
2.39.0

