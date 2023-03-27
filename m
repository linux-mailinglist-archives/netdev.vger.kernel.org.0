Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DECCC6C9E12
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbjC0IiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233037AbjC0Ihb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:37:31 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D74BDE7;
        Mon, 27 Mar 2023 01:32:03 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id r11so7756253wrr.12;
        Mon, 27 Mar 2023 01:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679905919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VsN1qM/iNlNKJZHZAqCBrKK2RA/zU2Iy4nTTO5WUc/g=;
        b=RY5nhqKcRUkWtzfIdOvJ3IFZQjZq54zGARvWoCO/DpfrSNQ2v3+7uVtPx/yyylIo9G
         pcUQ/QEYSf9G1fYn8ruseqjqOckMab1j7p4kAuqudoPmNJgsV3lB18o64VqFxf2HTVq8
         FHqESLvZ+4HTTwlEdSiGjvuFXwuGbzajGC8NOW+T/y4a6fVrtWZC4IT0bzxjzj0RtToX
         G1d29NqvDcO8z6GOOVxONPqjpA6cIXQyDWUbUFWynAMZZJC6rCr4bAmLI8aqBxOYC49f
         ZbMUNxN2CZWZbgYHwk7TDqvxM8d0bpIP0LXwivge2q4rY/oWhlrFUVINI7GdQ37k6eQm
         yzrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679905919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VsN1qM/iNlNKJZHZAqCBrKK2RA/zU2Iy4nTTO5WUc/g=;
        b=Btan0MMlJRK5ZzK4zmf7Evv0q2We8XM/+T4wn8C4u7kZQQB7nufWR6vgpnLLHyxPe5
         eo7rvbaDaRMZqYN/XmZq8wIqrDVoC5wVxjWg6lt8pWap2lcx9ecCoCyWFqa1pn9LNeqA
         jQEu2qG1q6EH9xqTZ378mF90lDN5Ggfpubk1L/1jNYdolJq+e4qzEx/m/XE89LjJrVe6
         CNbBYgjC0iVcihLBELu2j1B3400M27mE49Yfbe/L4/P2QkrzgMfmleqf/kBqWHGlr+6h
         zGzkllWSvhQO+kP+9P661FuURG7sZbO28h1+xTtxVeoTe3oJA44zvYGP1yroA1q27VK2
         XLVg==
X-Gm-Message-State: AAQBX9dAWCo2ziXQy3lqf1pJuH+jc/wQuslQf4Mf8/Zpf3jsY5/Nz+Zz
        MdoRkIYVu9he3TfPHLznRl3NjC+IQ8wWnw==
X-Google-Smtp-Source: AKy350Zu5lg5ZzPmlUJq1f7rCFctfxaQ+eRxcBwd2ar8bodr3zszXYHcOCMoD71aDctrVvvwRjjK/w==
X-Received: by 2002:a05:6000:114b:b0:2ce:abea:3de with SMTP id d11-20020a056000114b00b002ceabea03demr8494268wrx.45.1679905919350;
        Mon, 27 Mar 2023 01:31:59 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:7887:5530:69a2:a11f])
        by smtp.gmail.com with ESMTPSA id z6-20020a056000110600b002c557f82e27sm24353249wrw.99.2023.03.27.01.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 01:31:58 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v5 4/7] tools: ynl: Add fixed-header support to ynl
Date:   Mon, 27 Mar 2023 09:31:35 +0100
Message-Id: <20230327083138.96044-5-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230327083138.96044-1-donald.hunter@gmail.com>
References: <20230327083138.96044-1-donald.hunter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for netlink families that add an optional fixed header structure
after the genetlink header and before any attributes. The fixed-header can be
specified on a per op basis, or once for all operations, which serves as a
default value that can be overridden.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 Documentation/netlink/genetlink-legacy.yaml | 11 ++++++++++
 tools/net/ynl/lib/nlspec.py                 | 21 +++++++++++-------
 tools/net/ynl/lib/ynl.py                    | 24 +++++++++++++++++----
 3 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
index d50c78b9f42d..b33541a51d6b 100644
--- a/Documentation/netlink/genetlink-legacy.yaml
+++ b/Documentation/netlink/genetlink-legacy.yaml
@@ -261,6 +261,14 @@ properties:
       async-enum:
         description: Name for the enum type with notifications/events.
         type: string
+      # Start genetlink-legacy
+      fixed-header: &fixed-header
+        description: |
+          Name of the structure defining the optional fixed-length protocol
+          header. This header is placed in a message after the netlink and
+          genetlink headers and before any attributes.
+        type: string
+      # End genetlink-legacy
       list:
         description: List of commands
         type: array
@@ -293,6 +301,9 @@ properties:
               type: array
               items:
                 enum: [ strict, dump ]
+            # Start genetlink-legacy
+            fixed-header: *fixed-header
+            # End genetlink-legacy
             do: &subop-type
               description: Main command handler.
               type: object
diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index d1e5f60af580..06a906d74f0e 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -263,16 +263,17 @@ class SpecOperation(SpecElement):
     Information about a single Netlink operation.
 
     Attributes:
-        value       numerical ID when serialized, None if req/rsp values differ
+        value           numerical ID when serialized, None if req/rsp values differ
 
-        req_value   numerical ID when serialized, user -> kernel
-        rsp_value   numerical ID when serialized, user <- kernel
-        is_call     bool, whether the operation is a call
-        is_async    bool, whether the operation is a notification
-        is_resv     bool, whether the operation does not exist (it's just a reserved ID)
-        attr_set    attribute set name
+        req_value       numerical ID when serialized, user -> kernel
+        rsp_value       numerical ID when serialized, user <- kernel
+        is_call         bool, whether the operation is a call
+        is_async        bool, whether the operation is a notification
+        is_resv         bool, whether the operation does not exist (it's just a reserved ID)
+        attr_set        attribute set name
+        fixed_header    string, optional name of fixed header struct
 
-        yaml        raw spec as loaded from the spec file
+        yaml            raw spec as loaded from the spec file
     """
     def __init__(self, family, yaml, req_value, rsp_value):
         super().__init__(family, yaml)
@@ -284,6 +285,7 @@ class SpecOperation(SpecElement):
         self.is_call = 'do' in yaml or 'dump' in yaml
         self.is_async = 'notify' in yaml or 'event' in yaml
         self.is_resv = not self.is_async and not self.is_call
+        self.fixed_header = self.yaml.get('fixed-header', family.fixed_header)
 
         # Added by resolve:
         self.attr_set = None
@@ -324,6 +326,7 @@ class SpecFamily(SpecElement):
         msgs_by_value  dict of all messages (indexed by name)
         ops        dict of all valid requests / responses
         consts     dict of all constants/enums
+        fixed_header  string, optional name of family default fixed header struct
     """
     def __init__(self, spec_path, schema_path=None):
         with open(spec_path, "r") as stream:
@@ -397,6 +400,7 @@ class SpecFamily(SpecElement):
         self._resolution_list.append(elem)
 
     def _dictify_ops_unified(self):
+        self.fixed_header = self.yaml['operations'].get('fixed-header')
         val = 1
         for elem in self.yaml['operations']['list']:
             if 'value' in elem:
@@ -408,6 +412,7 @@ class SpecFamily(SpecElement):
             self.msgs[op.name] = op
 
     def _dictify_ops_directional(self):
+        self.fixed_header = self.yaml['operations'].get('fixed-header')
         req_val = rsp_val = 1
         for elem in self.yaml['operations']['list']:
             if 'notify' in elem:
diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 63af3bd9787d..ec40918152e1 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -278,14 +278,22 @@ def _genl_load_families():
 
 
 class GenlMsg:
-    def __init__(self, nl_msg):
+    def __init__(self, nl_msg, fixed_header_members=[]):
         self.nl = nl_msg
 
         self.hdr = nl_msg.raw[0:4]
-        self.raw = nl_msg.raw[4:]
+        offset = 4
 
         self.genl_cmd, self.genl_version, _ = struct.unpack("BBH", self.hdr)
 
+        self.fixed_header_attrs = dict()
+        for m in fixed_header_members:
+            format, size = NlAttr.type_formats[m.type]
+            decoded = struct.unpack_from(format, nl_msg.raw, offset)
+            offset += size
+            self.fixed_header_attrs[m.name] = decoded[0]
+
+        self.raw = nl_msg.raw[offset:]
         self.raw_attrs = NlAttrs(self.raw)
 
     def __repr__(self):
@@ -509,6 +517,13 @@ class YnlFamily(SpecFamily):
 
         req_seq = random.randint(1024, 65535)
         msg = _genl_msg(self.family.family_id, nl_flags, op.req_value, 1, req_seq)
+        fixed_header_members = []
+        if op.fixed_header:
+            fixed_header_members = self.consts[op.fixed_header].members
+            for m in fixed_header_members:
+                value = vals.pop(m.name)
+                format, _ = NlAttr.type_formats[m.type]
+                msg += struct.pack(format, value)
         for name, value in vals.items():
             msg += self._add_attr(op.attr_set.name, name, value)
         msg = _genl_msg_finalize(msg)
@@ -535,7 +550,7 @@ class YnlFamily(SpecFamily):
                     done = True
                     break
 
-                gm = GenlMsg(nl_msg)
+                gm = GenlMsg(nl_msg, fixed_header_members)
                 # Check if this is a reply to our request
                 if nl_msg.nl_seq != req_seq or gm.genl_cmd != op.rsp_value:
                     if gm.genl_cmd in self.async_msg_ids:
@@ -545,7 +560,8 @@ class YnlFamily(SpecFamily):
                         print('Unexpected message: ' + repr(gm))
                         continue
 
-                rsp.append(self._decode(gm.raw_attrs, op.attr_set.name))
+                rsp.append(self._decode(gm.raw_attrs, op.attr_set.name)
+                           | gm.fixed_header_attrs)
 
         if not rsp:
             return None
-- 
2.39.0

