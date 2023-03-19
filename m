Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB736C0474
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjCSTip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjCSTif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:38:35 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9FD7DA9
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 12:38:31 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id l27so224374wrb.2
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 12:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679254709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z5iBtY8KDPyw7Vjzd2GhmY5pBsVMT2mvsTw3P8c+LMM=;
        b=mI4wf8jmRoFDyhkf8cXxGsR8fdIjH8vldcCNH7ZvrGzFCqw273wdRlG273IkSoW4sX
         yO1MiLksWwjCFjMNS13HA3800m96du9dKaPiqVQqpkxjPWEFf9a76NOk9wM8R3SZzNNQ
         1UkP76CuX3iHw2eEjY7amME56E8JESKFZc/PQrHbx++jbPVVE5AVeVKIIGt4lrFeQPFr
         m1L+bfQ11jWix8UySl4WVnlrdQvuB+aVw0w9HCicXyh8jadeAG6Z2JzIwJLB7PH4qHkA
         pA54AIPNsqD3ahRhFNQYEuz86S5L8of4Q0aP/woLOYnNrNEe+kQ75niqrcxJNXk0E+Km
         wXhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679254709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z5iBtY8KDPyw7Vjzd2GhmY5pBsVMT2mvsTw3P8c+LMM=;
        b=Qtuo6dJmYU3aJq721ZzzJGShzuRCB/GqJ7kvTx1672ql+ZisMfOXwTT06LpoD0Il+z
         w6Trbghd0ZxJ5ef3aKTne7GvyUkVgHkAfitI38PdiUiDyql826qbgnljlwJhekHHmXE5
         kRmIAB9fID/oXJAScnAM0xISiyNTk3AV5soNSUvRO/bHtIf9GTfVYsFxdgGZt0KbGV+Z
         HpoqH44pRasNq/TO0SaS/kUXOk7tWVjcIOu77l0BUYNAVaF0sF483tS64lAehpxSIyR7
         6MC/9CZmZHwN8LqqDLvaiVBEDTfo7NVWDg2SyFiJ/K5xuJjcp7ODVUplLY1i4oonGH6p
         Aqsg==
X-Gm-Message-State: AO0yUKWup+qHUp+SlWxBoTQYJ9Rqzb5t3A+zOug9Z4O25Sw8VJA9olsj
        o8hBLBJtB2pucczmP4dlqDZd+CFwDCbczg==
X-Google-Smtp-Source: AK7set/JVq4y1ylySMw/Y6xMK26KaeiL2ifRt/2yJz5P57Rw8pmtz4dQztBUxnskKWkCtJL6cNhRKw==
X-Received: by 2002:adf:ffc5:0:b0:2ce:a8ee:173a with SMTP id x5-20020adfffc5000000b002cea8ee173amr12139886wrs.68.1679254709444;
        Sun, 19 Mar 2023 12:38:29 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id d5-20020adfef85000000b002cfed482e9asm7204190wro.61.2023.03.19.12.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:38:28 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v2 5/6] tools: ynl: Add fixed-header support to ynl
Date:   Sun, 19 Mar 2023 19:38:02 +0000
Message-Id: <20230319193803.97453-6-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230319193803.97453-1-donald.hunter@gmail.com>
References: <20230319193803.97453-1-donald.hunter@gmail.com>
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

Add support for netlink families that add an optional fixed header structure
after the genetlink header and before any attributes. The fixed-header can be
specified on a per op basis, or once for all operations.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 Documentation/netlink/genetlink-legacy.yaml | 10 +++++++
 tools/net/ynl/lib/nlspec.py                 | 30 ++++++++++++---------
 tools/net/ynl/lib/ynl.py                    | 23 +++++++++++++---
 3 files changed, 46 insertions(+), 17 deletions(-)

diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
index 654f40b26beb..30a8051c1d8f 100644
--- a/Documentation/netlink/genetlink-legacy.yaml
+++ b/Documentation/netlink/genetlink-legacy.yaml
@@ -261,6 +261,13 @@ properties:
       async-enum:
         description: Name for the enum type with notifications/events.
         type: string
+      # Start genetlink-legacy
+      fixed-header: &fixed-header
+        description: |
+          Name of the structure defininig the optional fixed-length protocol header. This header is
+          placed in a message after the netlink and genetlink headers and before any attributes.
+        type: string
+      # End genetlink-legacy
       list:
         description: List of commands
         type: array
@@ -293,6 +300,9 @@ properties:
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
index 5ac2dfd415c5..69ee9f940e0e 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -257,18 +257,19 @@ class SpecOperation(SpecElement):
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
+        fixed_header    string, optional fixed header structure name
 
-        yaml        raw spec as loaded from the spec file
+        yaml            raw spec as loaded from the spec file
     """
-    def __init__(self, family, yaml, req_value, rsp_value):
+    def __init__(self, family, yaml, req_value, rsp_value, default_fixed_header):
         super().__init__(family, yaml)
 
         self.value = req_value if req_value == rsp_value else None
@@ -278,6 +279,7 @@ class SpecOperation(SpecElement):
         self.is_call = 'do' in yaml or 'dump' in yaml
         self.is_async = 'notify' in yaml or 'event' in yaml
         self.is_resv = not self.is_async and not self.is_call
+        self.fixed_header = self.yaml.get('fixed-header', default_fixed_header)
 
         # Added by resolve:
         self.attr_set = None
@@ -384,24 +386,26 @@ class SpecFamily(SpecElement):
     def new_struct(self, elem):
         return SpecStruct(self, elem)
 
-    def new_operation(self, elem, req_val, rsp_val):
-        return SpecOperation(self, elem, req_val, rsp_val)
+    def new_operation(self, elem, req_val, rsp_val, default_fixed_header):
+        return SpecOperation(self, elem, req_val, rsp_val, default_fixed_header)
 
     def add_unresolved(self, elem):
         self._resolution_list.append(elem)
 
     def _dictify_ops_unified(self):
+        default_fixed_header = self.yaml['operations'].get('fixed-header')
         val = 1
         for elem in self.yaml['operations']['list']:
             if 'value' in elem:
                 val = elem['value']
 
-            op = self.new_operation(elem, val, val)
+            op = self.new_operation(elem, val, val, default_fixed_header)
             val += 1
 
             self.msgs[op.name] = op
 
     def _dictify_ops_directional(self):
+        default_fixed_header = self.yaml['operations'].get('fixed-header')
         req_val = rsp_val = 1
         for elem in self.yaml['operations']['list']:
             if 'notify' in elem:
@@ -426,7 +430,7 @@ class SpecFamily(SpecElement):
             else:
                 raise Exception("Can't parse directional ops")
 
-            op = self.new_operation(elem, req_val, rsp_val)
+            op = self.new_operation(elem, req_val, rsp_val, default_fixed_header)
             req_val = req_val_next
             rsp_val = rsp_val_next
 
diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 24f8af3c2b38..736a637ecb2b 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -277,14 +277,22 @@ def _genl_load_families():
 
 
 class GenlMsg:
-    def __init__(self, nl_msg):
+    def __init__(self, nl_msg, fixed_header_members = []):
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
@@ -496,6 +504,13 @@ class YnlFamily(SpecFamily):
 
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
@@ -522,7 +537,7 @@ class YnlFamily(SpecFamily):
                     done = True
                     break
 
-                gm = GenlMsg(nl_msg)
+                gm = GenlMsg(nl_msg, fixed_header_members)
                 # Check if this is a reply to our request
                 if nl_msg.nl_seq != req_seq or gm.genl_cmd != op.rsp_value:
                     if gm.genl_cmd in self.async_msg_ids:
@@ -532,7 +547,7 @@ class YnlFamily(SpecFamily):
                         print('Unexpected message: ' + repr(gm))
                         continue
 
-                rsp.append(self._decode(gm.raw_attrs, op.attr_set.name))
+                rsp.append(self._decode(gm.raw_attrs, op.attr_set.name) | gm.fixed_header_attrs)
 
         if not rsp:
             return None
-- 
2.39.0

