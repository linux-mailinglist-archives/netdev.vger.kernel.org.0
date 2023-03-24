Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1316C88A3
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbjCXW5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjCXW5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:57:03 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7012D1B2D0
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:57:01 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5425c04765dso32527547b3.0
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679698620;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e63C8BnJCw24cBdak0cb3MRmM4qZxjKI2a7vi0fwNeE=;
        b=pZgpdoJjxoWNrgZkkNmbtuP8hfY9EzZEG+fthAC/FoLeGpJ0NlTpRU3gv/KPzF3B6D
         xK9hjhnobkMTHGJEkhhC3vEdh00tB91c4qCogebb30e7hRq0i7yCupsXltUUiwahA7cu
         gu5exDLvc/tkl4DnAfPOyafosxOZ3EVPDuENYHfRcLrxGqXdWvj+mkbhPfdG8i3O3J7m
         W48D99BA0QbRUbjeG8MUrhGTOPbotGUEmLIrxQcbYHFP6n6noJz64uTl+PWo4vb69WDq
         6pct9d3rHVXUfZVeE01+dTSzWVYpu/SnSyXUYLLiBK5uvPPJvsdxWQyBBDytx6WoEg9L
         FxQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679698620;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e63C8BnJCw24cBdak0cb3MRmM4qZxjKI2a7vi0fwNeE=;
        b=nQJIGhDssE/IbwWARhFXjCvVeJfJJZS/BODTYqr0lepf8kMhyZlhNR87qmVnBaGDeC
         muLzKpoMvqcrQhmU/m0Eiwcon5bX64XtJ/3cMZBrk8t6ND0Tyc2VCoaQEs1lTUS2b6S5
         B04jKjKR1F50HzNKdM3QfogwV+Lr7Afuk9YvG5ub/k6pCV4bahnq2ADwtNXHq5dVx/J1
         zS5VDJsAC69QEM4jYcfCesvrIxLFCJGe9C5QiKdv6mV0FXQvd8sYij8EK2ncrtwMr1TD
         ihw6R4R6ifSjjA+MaQXfSPbn947i8byCLbgWo+YqZiskmRdj0cNPRLh1Ic2WOAAVjQXb
         iKmA==
X-Gm-Message-State: AAQBX9cBY7LLQZRtRLRn74ZWhG3INRMJraa3+fMFIqLL3emxtgpGlXmu
        hB0Zs0OClBPzrYqi6Auf6vC0HqTxEwSXVyKOPdhaOtciDM/rEGVooZTwrsMwmtKEk0ZNM08Hp0L
        eJC5jbIZzSpCNPOivtulbR5nKMjPetSxE7yVj3LTcE+StxYapvcjdhA==
X-Google-Smtp-Source: AKy350YqeSkpmpqEDJX39dk0+kcgwE71nXORUdjBacKlYz1f2D+haio+GIs2d4TT7pzlLLw5LhaFIj0=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6902:102a:b0:b4c:9333:293 with SMTP id
 x10-20020a056902102a00b00b4c93330293mr2038952ybt.11.1679698620643; Fri, 24
 Mar 2023 15:57:00 -0700 (PDT)
Date:   Fri, 24 Mar 2023 15:56:53 -0700
In-Reply-To: <20230324225656.3999785-1-sdf@google.com>
Mime-Version: 1.0
References: <20230324225656.3999785-1-sdf@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230324225656.3999785-2-sdf@google.com>
Subject: [PATCH net-next v2 1/4] tools: ynl: support byte-order in cli
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
 tools/net/ynl/lib/ynl.py | 47 +++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 788f130a7cc3..1220314d3303 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -75,17 +75,25 @@ from .nlspec import SpecFamily
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
+    def as_u16(self, byte_order):
+        endian = NlAttr.format_byte_order(byte_order)
+        return struct.unpack(f"{endian}H", self.raw)[0]
 
-    def as_u32(self):
-        return struct.unpack("I", self.raw)[0]
+    def as_u32(self, byte_order):
+        endian = NlAttr.format_byte_order(byte_order)
+        return struct.unpack(f"{endian}I", self.raw)[0]
 
-    def as_u64(self):
-        return struct.unpack("Q", self.raw)[0]
+    def as_u64(self, byte_order):
+        endian = NlAttr.format_byte_order(byte_order)
+        return struct.unpack(f"{endian}Q", self.raw)[0]
 
     def as_strz(self):
         return self.raw.decode('ascii')[:-1]
@@ -148,11 +156,11 @@ from .nlspec import SpecFamily
                 if extack.type == Netlink.NLMSGERR_ATTR_MSG:
                     self.extack['msg'] = extack.as_strz()
                 elif extack.type == Netlink.NLMSGERR_ATTR_MISS_TYPE:
-                    self.extack['miss-type'] = extack.as_u32()
+                    self.extack['miss-type'] = extack.as_u32(None)
                 elif extack.type == Netlink.NLMSGERR_ATTR_MISS_NEST:
-                    self.extack['miss-nest'] = extack.as_u32()
+                    self.extack['miss-nest'] = extack.as_u32(None)
                 elif extack.type == Netlink.NLMSGERR_ATTR_OFFS:
-                    self.extack['bad-attr-offs'] = extack.as_u32()
+                    self.extack['bad-attr-offs'] = extack.as_u32(None)
                 else:
                     if 'unknown' not in self.extack:
                         self.extack['unknown'] = []
@@ -236,11 +244,11 @@ genl_family_name_to_id = None
                 fam = dict()
                 for attr in gm.raw_attrs:
                     if attr.type == Netlink.CTRL_ATTR_FAMILY_ID:
-                        fam['id'] = attr.as_u16()
+                        fam['id'] = attr.as_u16(None)
                     elif attr.type == Netlink.CTRL_ATTR_FAMILY_NAME:
                         fam['name'] = attr.as_strz()
                     elif attr.type == Netlink.CTRL_ATTR_MAXATTR:
-                        fam['maxattr'] = attr.as_u32()
+                        fam['maxattr'] = attr.as_u32(None)
                     elif attr.type == Netlink.CTRL_ATTR_MCAST_GROUPS:
                         fam['mcast'] = dict()
                         for entry in NlAttrs(attr.raw):
@@ -250,7 +258,7 @@ genl_family_name_to_id = None
                                 if entry_attr.type == Netlink.CTRL_ATTR_MCAST_GRP_NAME:
                                     mcast_name = entry_attr.as_strz()
                                 elif entry_attr.type == Netlink.CTRL_ATTR_MCAST_GRP_ID:
-                                    mcast_id = entry_attr.as_u32()
+                                    mcast_id = entry_attr.as_u32(None)
                             if mcast_name and mcast_id is not None:
                                 fam['mcast'][mcast_name] = mcast_id
                 if 'name' in fam and 'id' in fam:
@@ -337,11 +345,14 @@ genl_family_name_to_id = None
         elif attr["type"] == 'u8':
             attr_payload = struct.pack("B", int(value))
         elif attr["type"] == 'u16':
-            attr_payload = struct.pack("H", int(value))
+            endian = NlAttr.format_byte_order(attr.get('byte-order'))
+            attr_payload = struct.pack(f"{endian}H", int(value))
         elif attr["type"] == 'u32':
-            attr_payload = struct.pack("I", int(value))
+            endian = NlAttr.format_byte_order(attr.get('byte-order'))
+            attr_payload = struct.pack(f"{endian}I", int(value))
         elif attr["type"] == 'u64':
-            attr_payload = struct.pack("Q", int(value))
+            endian = NlAttr.format_byte_order(attr.get('byte-order'))
+            attr_payload = struct.pack(f"{endian}Q", int(value))
         elif attr["type"] == 'string':
             attr_payload = str(value).encode('ascii') + b'\x00'
         elif attr["type"] == 'binary':
@@ -378,11 +389,11 @@ genl_family_name_to_id = None
             elif attr_spec['type'] == 'u8':
                 decoded = attr.as_u8()
             elif attr_spec['type'] == 'u16':
-                decoded = attr.as_u16()
+                decoded = attr.as_u16(attr_spec.get('byte-order'))
             elif attr_spec['type'] == 'u32':
-                decoded = attr.as_u32()
+                decoded = attr.as_u32(attr_spec.get('byte-order'))
             elif attr_spec['type'] == 'u64':
-                decoded = attr.as_u64()
+                decoded = attr.as_u64(attr_spec.get('byte-order'))
             elif attr_spec["type"] == 'string':
                 decoded = attr.as_strz()
             elif attr_spec["type"] == 'binary':
-- 
2.40.0.348.gf938b09366-goog

