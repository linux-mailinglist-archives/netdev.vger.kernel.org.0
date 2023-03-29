Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F4D6CF63F
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 00:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjC2WRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 18:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjC2WQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 18:16:59 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AE34EEA
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 15:16:59 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id ie7-20020a17090b400700b0023f06808981so4591713pjb.8
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 15:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680128218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jBISv61FN093xJ06J7nlRTFrBK3zOfMadg13PK22rwE=;
        b=CPpujeZ+ESlHcyT0xciQOXzvE5gSuhzvjfhxlPmvs5F45WscW5sqryC8GqMJRpXJrC
         2p0RG9BbFRP4WgUO6pd+xeCUtrbZyP9Rqie4eFEvZ7fPWtdU+QxLG57EVVuomnRLA5ux
         O6AYmYVBGmYqB0o1fJqzlQIftmBJta3EngaRg7+3LLvZqD/m0ZesTFhJOZPeJplxJVpz
         J+2l4EH4SK/q5qZiNLvLfYKDDpR10ZcYPjJlYvv5TUkUGvItLpTAhGoHHkUukKR2Z6nb
         vllDtr3fw4zvtbCBamdITME14rEHqnYKA9FZ3l8Q2oghl2+kW5mQmpcHn3mPVPyKl7Mu
         QBTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680128218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jBISv61FN093xJ06J7nlRTFrBK3zOfMadg13PK22rwE=;
        b=Ci14suY76HJejoBZGEKUfmnyU0zJtZUDDfP/BLusOGd8ZMZDi/hjMRWhcHvRKKb3Bd
         bK3OsahZRkPYtIuMP+cttHCBhXCk3c8ySBjXye9oaInaXqdARfqDyvhXBBJyPj+0FNEM
         1CVkqjg9itG0d4JRZ38QgPH86XTDHxw0fO+JMwq0UkAgYBhPa+q/1AJloN5OFvOUYDsD
         mLTQXlzmSF4roXJKSiafYh0qSq7sktxud3h2ZfXWmNPWfH4jgJ9PhzLa7ZgWBz+PkPqQ
         CQ8qPahdHMcGuzH16tqEW1dfR+sGRT4NZrBnt8AgexmmY16JCCENCXk2EQpn/e7pYsW5
         SqZw==
X-Gm-Message-State: AAQBX9c69REinnXzjYGKreapIBbC9WP9YbjMekrjrOwg4YUjrgRnc92f
        7LD/uKCaWD/+pFQy8jsWThi5q76sm1y0+dtSaf5/srJBtFIvVnLSTK48t7ePJgyrdx0lNM5mpTS
        RW1TvSIGdiQZcyHQ4pT7gd9Bnny7jAWeHvzcyBtvaYQvSbVoTWl8eOQ==
X-Google-Smtp-Source: AKy350Z8QLswOC2NqJT4TMYuRhvNh6ZsgkEFtAicAr9I4vffOKXwSjDpedGAczcbi/FD5Vy6CLs2oIQ=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:da8e:b0:19d:1dfe:eac6 with SMTP id
 j14-20020a170902da8e00b0019d1dfeeac6mr7762571plx.1.1680128218407; Wed, 29 Mar
 2023 15:16:58 -0700 (PDT)
Date:   Wed, 29 Mar 2023 15:16:52 -0700
In-Reply-To: <20230329221655.708489-1-sdf@google.com>
Mime-Version: 1.0
References: <20230329221655.708489-1-sdf@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230329221655.708489-2-sdf@google.com>
Subject: [PATCH net-next v3 1/4] tools: ynl: support byte-order in cli
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Used by ethtool spec.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/net/ynl/lib/nlspec.py |  1 +
 tools/net/ynl/lib/ynl.py    | 35 +++++++++++++++++++++++------------
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index 06a906d74f0e..0c43022ff7e6 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -163,6 +163,7 @@ jsonschema = None
         self.is_multi = yaml.get('multi-attr', False)
         self.struct_name = yaml.get('struct')
         self.sub_type = yaml.get('sub-type')
+        self.byte_order = yaml.get('byte-order')
 
 
 class SpecAttrSet(SpecElement):
diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index ec40918152e1..8778994d40c0 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -80,17 +80,25 @@ from .nlspec import SpecFamily
         self.full_len = (self.payload_len + 3) & ~3
         self.raw = raw[offset + 4:offset + self.payload_len]
 
+    def format_byte_order(byte_order):
+        if byte_order:
+            return ">" if byte_order == "big-endian" else "<"
+        return ""
+
     def as_u8(self):
         return struct.unpack("B", self.raw)[0]
 
-    def as_u16(self):
-        return struct.unpack("H", self.raw)[0]
+    def as_u16(self, byte_order=None):
+        endian = NlAttr.format_byte_order(byte_order)
+        return struct.unpack(f"{endian}H", self.raw)[0]
 
-    def as_u32(self):
-        return struct.unpack("I", self.raw)[0]
+    def as_u32(self, byte_order=None):
+        endian = NlAttr.format_byte_order(byte_order)
+        return struct.unpack(f"{endian}I", self.raw)[0]
 
-    def as_u64(self):
-        return struct.unpack("Q", self.raw)[0]
+    def as_u64(self, byte_order=None):
+        endian = NlAttr.format_byte_order(byte_order)
+        return struct.unpack(f"{endian}Q", self.raw)[0]
 
     def as_strz(self):
         return self.raw.decode('ascii')[:-1]
@@ -365,11 +373,14 @@ genl_family_name_to_id = None
         elif attr["type"] == 'u8':
             attr_payload = struct.pack("B", int(value))
         elif attr["type"] == 'u16':
-            attr_payload = struct.pack("H", int(value))
+            endian = NlAttr.format_byte_order(attr.byte_order)
+            attr_payload = struct.pack(f"{endian}H", int(value))
         elif attr["type"] == 'u32':
-            attr_payload = struct.pack("I", int(value))
+            endian = NlAttr.format_byte_order(attr.byte_order)
+            attr_payload = struct.pack(f"{endian}I", int(value))
         elif attr["type"] == 'u64':
-            attr_payload = struct.pack("Q", int(value))
+            endian = NlAttr.format_byte_order(attr.byte_order)
+            attr_payload = struct.pack(f"{endian}Q", int(value))
         elif attr["type"] == 'string':
             attr_payload = str(value).encode('ascii') + b'\x00'
         elif attr["type"] == 'binary':
@@ -415,11 +426,11 @@ genl_family_name_to_id = None
             elif attr_spec['type'] == 'u8':
                 decoded = attr.as_u8()
             elif attr_spec['type'] == 'u16':
-                decoded = attr.as_u16()
+                decoded = attr.as_u16(attr_spec.byte_order)
             elif attr_spec['type'] == 'u32':
-                decoded = attr.as_u32()
+                decoded = attr.as_u32(attr_spec.byte_order)
             elif attr_spec['type'] == 'u64':
-                decoded = attr.as_u64()
+                decoded = attr.as_u64(attr_spec.byte_order)
             elif attr_spec["type"] == 'string':
                 decoded = attr.as_strz()
             elif attr_spec["type"] == 'binary':
-- 
2.40.0.348.gf938b09366-goog

