Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAB46C7D50
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 12:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbjCXLi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 07:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCXLi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 07:38:28 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0AD1E1C0;
        Fri, 24 Mar 2023 04:38:26 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id o7so1484580wrg.5;
        Fri, 24 Mar 2023 04:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679657904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=58IwQQkEAhYQMjB39CTS4lZbJRfFOqasTG2I1XON7Dk=;
        b=qp/OhoQhSO48Iq3e+YBN0KILticoZfWqSqhdVlHVQvc5Hw4T3t32FV7YvpotLluF1P
         ZG+cpCB2cQmshJTWzqOPZ/5T0/IHmU16/uKc8JVDckiP+layf8GUGURhx2o6ZWGOSImY
         dmqMKpYHD6QmKvC9yLRMeV1B4P7HM4yHu+3CHdh79LBj1BKHlkzLMotDf9mAPeqIiG29
         1uQicCLS7SqIfeUWHlWqddICQVm8+pjHhuUqNaOa/hhO1BsHSNmBjUKN/rTXQsK43GGv
         Oq77dWGCSx0u9UI/R+l0GVZRDxX4lPSBJlmkf2uM3f6Hse/TE3kk5yZPiz0Zf59Hjlxa
         GXMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679657904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=58IwQQkEAhYQMjB39CTS4lZbJRfFOqasTG2I1XON7Dk=;
        b=O587a/VZpBuAc45kfMPyHNvsnUgJ8IXc67UU1gSkWYtTlJHpgXbC3sdUVzNXroKFWx
         Tbg5ghaWjQrob/WBbr1mkDdybGdVsWEyeBRvkQ2sl6ElH3gGVv8x7lFglRgMCVU4K0Xv
         HC6oVroGr5jjQfda9tHuKguh26Nc82/NFcWtQz7HFrQMW2i8HxrdosULNleAK3p21gcb
         ox2pITuyESxdzy4Y9zvMoZyQ2yJRnQ1P8LtSuMwtQz1boaMEX49xQzW20r519TKtqb7P
         v1KT9D4C2XU/lEcn5ZNIvaaSr/0vcL463h4/UzAGXJjJhDxCXPcg0nj+hpk/9fNfYFrX
         1P/w==
X-Gm-Message-State: AAQBX9d4A1G15wljfRI0IvSKOvfI+d4DuOV84hCmIBFTTIQlh+5LLBNs
        cx0XAlejoedVS4/6xINn0k11dCcg9ZVszQ==
X-Google-Smtp-Source: AKy350Z8QawNVmrN8u3LAyPsai9oDGPxND5vWfS4TV0PhfvMxErB230PGttC7atVstzfk5UIy1bHVA==
X-Received: by 2002:a05:6000:1a47:b0:2d8:4f02:66b6 with SMTP id t7-20020a0560001a4700b002d84f0266b6mr2134647wry.9.1679657904388;
        Fri, 24 Mar 2023 04:38:24 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:cd72:bbb4:8d1:483a])
        by smtp.gmail.com with ESMTPSA id t6-20020adff606000000b002d828a9f9ddsm10150954wrp.115.2023.03.24.04.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 04:38:23 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v3 2/7] tools: ynl: Add C array attribute decoding to ynl
Date:   Fri, 24 Mar 2023 11:37:29 +0000
Message-Id: <20230324113734.1473-3-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230324113734.1473-1-donald.hunter@gmail.com>
References: <20230324113734.1473-1-donald.hunter@gmail.com>
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
---
 tools/net/ynl/lib/ynl.py | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 32536e1f9064..fbcaca67d571 100644
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
 
@@ -361,6 +370,14 @@ class YnlFamily(SpecFamily):
             value = enum.entries_by_val[raw - i].name
         rsp[attr_spec['name']] = value
 
+    def _decode_binary(self, attr, attr_spec):
+        sub_type = attr_spec.get('sub-type')
+        if sub_type:
+            decoded = attr.as_c_array(sub_type)
+        else:
+            decoded = attr.as_bin()
+        return decoded
+
     def _decode(self, attrs, space):
         attr_space = self.attr_sets[space]
         rsp = dict()
@@ -378,7 +395,7 @@ class YnlFamily(SpecFamily):
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

