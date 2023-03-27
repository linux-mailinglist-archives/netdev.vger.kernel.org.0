Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55EA6C9E07
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbjC0Ihr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbjC0Ih1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:37:27 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1411A27D;
        Mon, 27 Mar 2023 01:32:01 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id h17so7758932wrt.8;
        Mon, 27 Mar 2023 01:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679905917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wRmswFiWTDHAdnFgsbs9MdujlDQuLrbap9qquN6025Y=;
        b=HzhRrIeo1C/+XxOhhHieZpFfxfXRpYE0MHWP2Or9LR5tN1X1F6e+Pps07YhADgfk/1
         kYU4fI8d6U0OfGsIf2kIpcxsb8vFnUWqRvcr+D+rFTy/rKuBpGc8qwnzjgdOb0Yg83ch
         RQEy6QDuriwEwEa7LbHYmGhX+jai2hrniIIlNLkD82LwtMIt99ayTAW4FhGLvs72lF1O
         IZGrxIGlVZUf4CMrQjAaQWOfO5VccqbCSdAkleLRAjCO3WZmQcrfPXMakM4mcF/JzAha
         rv8kgREkWEZ88jmn/NlAsTrsm6crD0ZdDKTQwyJOOYtfaiUVzZhVryKaPEPQvrgwa+Xl
         PBQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679905917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wRmswFiWTDHAdnFgsbs9MdujlDQuLrbap9qquN6025Y=;
        b=boyz75mGzx3XI6lBlC9W0o1VTE8AoJ5t/M06JByIQebyAIa8QbB/f1fvLzyLF8D+Xb
         p9cbwbvlO4uFVZ7lls+eHW8BINaAWhl6E2yPj0cvvyGzZG7/LSmdaz2NKLijoX9gVwVb
         qgvDe1ezOsQK3UixKUCP0t1I2OGcms/WKqATHrtMvIiBwJ9Wbvd37xWtRYmEeCeHB5l1
         w3PECipVrytwYD3rqS972LG7JZCm0SuM9fYMxoYIARssR3dybVWsPwCAaA0ncLvMAB+F
         xSG05PgXuLtwpVSkO0EewzRdwl1aRhn0Exruvp3vCrqOUttN/rfHFrmP3+2fL+Svgu5A
         EX1w==
X-Gm-Message-State: AAQBX9d1Yt240jdz2w4XmAHG1QlrLo2mlVEYtvwafPY9U/Muo0oHZ3zM
        mPgLkdtLLzI0NqHTyzmvnXz8FU4aerdRVA==
X-Google-Smtp-Source: AKy350YODumRf9/l2kzuzNxsvYnUVwcWTCGQrhGp5HD53dYdwXUDCs5xpF4jd9WXMPoIU5cEV9XEqg==
X-Received: by 2002:a5d:4b44:0:b0:2d8:47c7:7b50 with SMTP id w4-20020a5d4b44000000b002d847c77b50mr8991866wrs.1.1679905916810;
        Mon, 27 Mar 2023 01:31:56 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:7887:5530:69a2:a11f])
        by smtp.gmail.com with ESMTPSA id z6-20020a056000110600b002c557f82e27sm24353249wrw.99.2023.03.27.01.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 01:31:56 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v5 2/7] tools: ynl: Add C array attribute decoding to ynl
Date:   Mon, 27 Mar 2023 09:31:33 +0100
Message-Id: <20230327083138.96044-3-donald.hunter@gmail.com>
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

Add support for decoding C arrays from binay blobs in genetlink-legacy
messages.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/nlspec.py |  7 +++++--
 tools/net/ynl/lib/ynl.py    | 18 +++++++++++++++++-
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index 83de2a1a3cc6..6cc9b7646ae8 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -149,8 +149,10 @@ class SpecAttr(SpecElement):
     Represents a single attribute type within an attr space.
 
     Attributes:
-        value      numerical ID when serialized
-        attr_set   Attribute Set containing this attr
+        value         numerical ID when serialized
+        attr_set      Attribute Set containing this attr
+        is_multi      bool, attr may repeat multiple times
+        sub_type      string, name of sub type
     """
     def __init__(self, family, attr_set, yaml, value):
         super().__init__(family, yaml)
@@ -158,6 +160,7 @@ class SpecAttr(SpecElement):
         self.value = value
         self.attr_set = attr_set
         self.is_multi = yaml.get('multi-attr', False)
+        self.sub_type = yaml.get('sub-type')
 
 
 class SpecAttrSet(SpecElement):
diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 7eaf066b115e..eada229402fa 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -68,6 +68,11 @@ class Netlink:
 
 
 class NlAttr:
+    type_formats = { 'u8' : ('B', 1), 's8' : ('b', 1),
+                     'u16': ('H', 2), 's16': ('h', 2),
+                     'u32': ('I', 4), 's32': ('i', 4),
+                     'u64': ('Q', 8), 's64': ('q', 8) }
+
     def __init__(self, raw, offset):
         self._len, self._type = struct.unpack("HH", raw[offset:offset + 4])
         self.type = self._type & ~Netlink.NLA_TYPE_MASK
@@ -93,6 +98,10 @@ class NlAttr:
     def as_bin(self):
         return self.raw
 
+    def as_c_array(self, type):
+        format, _ = self.type_formats[type]
+        return list({ x[0] for x in struct.iter_unpack(format, self.raw) })
+
     def __repr__(self):
         return f"[type:{self.type} len:{self._len}] {self.raw}"
 
@@ -367,6 +376,13 @@ class YnlFamily(SpecFamily):
             value = enum.entries_by_val[raw - i].name
         rsp[attr_spec['name']] = value
 
+    def _decode_binary(self, attr, attr_spec):
+        if attr_spec.sub_type:
+            decoded = attr.as_c_array(attr_spec.sub_type)
+        else:
+            decoded = attr.as_bin()
+        return decoded
+
     def _decode(self, attrs, space):
         attr_space = self.attr_sets[space]
         rsp = dict()
@@ -386,7 +402,7 @@ class YnlFamily(SpecFamily):
             elif attr_spec["type"] == 'string':
                 decoded = attr.as_strz()
             elif attr_spec["type"] == 'binary':
-                decoded = attr.as_bin()
+                decoded = self._decode_binary(attr, attr_spec)
             elif attr_spec["type"] == 'flag':
                 decoded = True
             else:
-- 
2.39.0

