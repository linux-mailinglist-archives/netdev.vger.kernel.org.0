Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301A56BF6E1
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 01:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjCRAXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 20:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjCRAXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 20:23:44 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2066DCF6D
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 17:23:43 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id i7-20020a626d07000000b005d29737db06so3389533pfc.15
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 17:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679099023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zc4RhVmVpU1pXWFLdUvbx968KFQg4fwNWqu5jwdXsws=;
        b=eRHkh6Na26C1NimSM4I09lHWFLe2KPqePy9k8F89aIHeJ66dm0w925X7wNdPFjgi7k
         1Jn6pzJCD4RK13WkmgLOHsu/X/OoI5BoHsMrgbHY9hV5jusAvtaAXRkvrk65prIWahKX
         UHhdzxFzhE9kYHY6Glgf9IY3rk3nVwK7vltuP7JjZUofGVJjuzuMuvD6x5Q6FtcK73ZA
         q7uCqz5nsftNs5it5VnSfPkeWzxsB+Ki1p1kpbK/dkaekt/BcKUdiDXjzmxyJYgHxXim
         YjYK9gwqZcAwaLJ/yrSVS8/OTr4I++jOv+DHlNjADTlaFLva+YCbnq5EfnX3iK2aV4S1
         LQ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679099023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zc4RhVmVpU1pXWFLdUvbx968KFQg4fwNWqu5jwdXsws=;
        b=mqbL1YtHSCzNXGPruRCSpSJQXfMKXVmJzNoaF7Q/d7iaLBnx88wmKlVcGyydTvESiL
         yJR5wdGy3o1UIkPMp3eU/fDrG8k8Zm7+gvabo8cG7LuJ+ydhzMI11xqA6xJtNevzgy4t
         bSasXSoXrRC02Z+/JjI0wxvtK9X3Klc1B/6ByizeNmwTHhw952/96lqgWgVwxIVBTdbk
         8uha4OlNzLkcXm50rWPjfVEl/tiLjVpC92EBwYkUtGiFW8Rr+DyDFPClCJ8zNS7V37nZ
         PxSDnEyv0wrpuB31Ebe352S/KM0wfPsFGgvrFkhMzxbu5r8XmZjoWEm/1TYPKUVh6fYM
         fx2g==
X-Gm-Message-State: AO0yUKXpjUj92yizDofgo2dBGoHfpIrINQ6wKZ/2ViV6QNP0/zZoVy/X
        0I0IQKhIu0tFWcT4UDIYclS4sVpSoUtm2VNsPhseYjGB6lH1H9OzNAyeC1XB46XltCL4MR6TYfj
        whcFet9JfPnoKfxPj0aFbhs3HWTIRfql8WO89I2KrgO4svRyTPOdEgQ==
X-Google-Smtp-Source: AK7set94sqXkq+v7Fogh8NjA0NGPkoaIu1pcAYTNyvu71b+cH1nDpUljWUyedif862ShAsVEzr/ORoQ=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a65:5248:0:b0:503:72c5:dd77 with SMTP id
 q8-20020a655248000000b0050372c5dd77mr37540pgp.6.1679099023315; Fri, 17 Mar
 2023 17:23:43 -0700 (PDT)
Date:   Fri, 17 Mar 2023 17:23:37 -0700
In-Reply-To: <20230318002340.1306356-1-sdf@google.com>
Mime-Version: 1.0
References: <20230318002340.1306356-1-sdf@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230318002340.1306356-2-sdf@google.com>
Subject: [PATCH net-next 1/4] ynl: support be16 in schemas
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Used by ethtool spec.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 Documentation/netlink/genetlink-c.yaml      | 2 +-
 Documentation/netlink/genetlink-legacy.yaml | 4 ++--
 Documentation/netlink/genetlink.yaml        | 2 +-
 tools/net/ynl/lib/ynl.py                    | 7 +++++++
 4 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/Documentation/netlink/genetlink-c.yaml b/Documentation/netlink/genetlink-c.yaml
index 8e8c17b0a6c6..1b057fc9326c 100644
--- a/Documentation/netlink/genetlink-c.yaml
+++ b/Documentation/netlink/genetlink-c.yaml
@@ -148,7 +148,7 @@ additionalProperties: False
               name:
                 type: string
               type: &attr-type
-                enum: [ unused, pad, flag, binary, u8, u16, u32, u64, s32, s64,
+                enum: [ unused, pad, flag, binary, u8, u16, be16, u32, u64, s32, s64,
                         string, nest, array-nest, nest-type-value ]
               doc:
                 description: Documentation of the attribute.
diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
index 5dc6f1c07a97..3796d8be9045 100644
--- a/Documentation/netlink/genetlink-legacy.yaml
+++ b/Documentation/netlink/genetlink-legacy.yaml
@@ -119,7 +119,7 @@ additionalProperties: False
               name:
                 type: string
               type:
-                enum: [ u8, u16, u32, u64, s8, s16, s32, s64, string ]
+                enum: [ u8, u16, be16, u32, u64, s8, s16, s32, s64, string ]
               len:
                 $ref: '#/$defs/len-or-define'
         # End genetlink-legacy
@@ -171,7 +171,7 @@ additionalProperties: False
               name:
                 type: string
               type: &attr-type
-                enum: [ unused, pad, flag, binary, u8, u16, u32, u64, s32, s64,
+                enum: [ unused, pad, flag, binary, u8, u16, be16, u32, u64, s32, s64,
                         string, nest, array-nest, nest-type-value ]
               doc:
                 description: Documentation of the attribute.
diff --git a/Documentation/netlink/genetlink.yaml b/Documentation/netlink/genetlink.yaml
index d8b2cdeba058..a143221c3d2e 100644
--- a/Documentation/netlink/genetlink.yaml
+++ b/Documentation/netlink/genetlink.yaml
@@ -121,7 +121,7 @@ additionalProperties: False
               name:
                 type: string
               type: &attr-type
-                enum: [ unused, pad, flag, binary, u8, u16, u32, u64, s32, s64,
+                enum: [ unused, pad, flag, binary, u8, u16, be16, u32, u64, s32, s64,
                         string, nest, array-nest, nest-type-value ]
               doc:
                 description: Documentation of the attribute.
diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 90764a83c646..21c015911803 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -81,6 +81,9 @@ from .nlspec import SpecFamily
     def as_u16(self):
         return struct.unpack("H", self.raw)[0]
 
+    def as_be16(self):
+        return struct.unpack(">H", self.raw)[0]
+
     def as_u32(self):
         return struct.unpack("I", self.raw)[0]
 
@@ -334,6 +337,8 @@ genl_family_name_to_id = None
                 attr_payload += self._add_attr(attr['nested-attributes'], subname, subvalue)
         elif attr["type"] == 'flag':
             attr_payload = b''
+        elif attr["type"] == 'be16':
+            attr_payload = struct.pack(">H", int(value))
         elif attr["type"] == 'u32':
             attr_payload = struct.pack("I", int(value))
         elif attr["type"] == 'string':
@@ -371,6 +376,8 @@ genl_family_name_to_id = None
                 decoded = subdict
             elif attr_spec['type'] == 'u8':
                 decoded = attr.as_u8()
+            elif attr_spec['type'] == 'be16':
+                decoded = attr.as_be16()
             elif attr_spec['type'] == 'u32':
                 decoded = attr.as_u32()
             elif attr_spec['type'] == 'u64':
-- 
2.40.0.rc1.284.g88254d51c5-goog

