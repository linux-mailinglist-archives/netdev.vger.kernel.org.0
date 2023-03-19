Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B0B6C0472
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjCSTik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCSTib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:38:31 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D17BD306
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 12:38:30 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id o7so8552442wrg.5
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 12:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679254708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=458WZKE7Wv1WdZP9AIvsjyYap+pFspsLQh0MCtVsk8M=;
        b=aGaJiGtkVy9LIA24cvbq5itc/SasiUSWRaVLBIyIZ5zikZQI8CU1Vsi4d4Fck+/oQE
         YRcCEl2JQ81Z1YlAHlRxYeQDzKHy541XrfolkVFGQXNff3dT2+R/3ONmH6uFj6dv2Mpm
         wlES+WsY12BuE5z4XZsBUnBLwfZGBV4caVS/gCYoXxikMtEJf0VYPJzMqaDgwni9I48h
         TWR5YKp3X5u8h+nj41SFekdMXPCzT3J6FWRI0cxnD+k7xb1KSCS6gIseoJLLA2dWV7Cj
         4Tzfa5M9oNn28OCOWsNGurtCJ2MaT7bsWZ02eIGOyG3GyIDBMp+0UzQoYaz8gsLX5J8e
         IJsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679254708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=458WZKE7Wv1WdZP9AIvsjyYap+pFspsLQh0MCtVsk8M=;
        b=MKUHXTMS7RNJTnbk4i7hHrRH3/QTR+JAKDVw55LnIblAwrK7ny4VUc/ve9D/suYYfe
         uI5i05SlKfDNq3jqtJ8M5ZzcmzxkuNp8qKHo5G7SIWRGdMx5tSekL1i4BM7oihM7TW8c
         DcpAdu4wLnindpCQ0zp/dX/Dg3commUYX1rJxvZpdU63+l/1zx1jMN1cBW1Jcq86PbMq
         i4DRSGNUg0ADwD4yhOV8nRKg0xVh6KMZ/vDIWw7KRnASfdJGf1mc9f+sirBcXYGZSaqa
         K/sHg9Jhi8WZEq9fMuCHmAE7NxPsQ6yAfHj4mLpcLyrFLgllhpY9uM3POP4SP9uqKSN3
         m2RQ==
X-Gm-Message-State: AO0yUKW9fuSMWPihsEM6YefOle4rAkCkl2rPgMN1WcpM4FJDtCFFyKRF
        PDog0z0U0arMTKODQ9a+LB1GiMqRrZ0Vqg==
X-Google-Smtp-Source: AK7set/i+CtBcnibwTgiRHt91Lk15RGls96Bns45sg/kdQXZq3y19bof1WuIyMgyTGxZbmNKICLipg==
X-Received: by 2002:adf:eb0e:0:b0:2d7:1ec1:9e46 with SMTP id s14-20020adfeb0e000000b002d71ec19e46mr572703wrn.47.1679254708467;
        Sun, 19 Mar 2023 12:38:28 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id d5-20020adfef85000000b002cfed482e9asm7204190wro.61.2023.03.19.12.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:38:27 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v2 4/6] tools: ynl: Add struct attr decoding to ynl
Date:   Sun, 19 Mar 2023 19:38:01 +0000
Message-Id: <20230319193803.97453-5-donald.hunter@gmail.com>
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

Add support for decoding attributes that contain C structs.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 Documentation/netlink/genetlink-legacy.yaml |  7 ++++++-
 tools/net/ynl/lib/ynl.py                    | 18 ++++++++++++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
index 5dc6f1c07a97..654f40b26beb 100644
--- a/Documentation/netlink/genetlink-legacy.yaml
+++ b/Documentation/netlink/genetlink-legacy.yaml
@@ -172,7 +172,7 @@ properties:
                 type: string
               type: &attr-type
                 enum: [ unused, pad, flag, binary, u8, u16, u32, u64, s32, s64,
-                        string, nest, array-nest, nest-type-value ]
+                        string, nest, array-nest, nest-type-value, struct ]
               doc:
                 description: Documentation of the attribute.
                 type: string
@@ -218,6 +218,11 @@ properties:
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
index 077ba9e8dc98..24f8af3c2b38 100644
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
@@ -97,6 +102,16 @@ class NlAttr:
         format, _ = self.type_formats[type]
         return list({ x[0] for x in struct.iter_unpack(format, self.raw) })
 
+    def as_struct(self, members):
+        value = dict()
+        offset = 0
+        for m in members:
+            format, size = self.type_formats[m.type]
+            decoded = struct.unpack_from(format, self.raw, offset)
+            offset += size
+            value[m.name] = decoded[0]
+        return value
+
     def __repr__(self):
         return f"[type:{self.type} len:{self._len}] {self.raw}"
 
@@ -385,6 +400,9 @@ class YnlFamily(SpecFamily):
                 decoded = attr.as_bin()
             elif attr_spec["type"] == 'flag':
                 decoded = True
+            elif attr_spec["type"] == 'struct':
+                s = attr_spec['struct']
+                decoded = attr.as_struct(self.consts[s])
             elif attr_spec["type"] == 'array-nest':
                 decoded = attr.as_array(attr_spec["sub-type"])
             else:
-- 
2.39.0

