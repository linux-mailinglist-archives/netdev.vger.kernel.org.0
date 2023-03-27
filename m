Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F60A6C9E08
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbjC0Iht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbjC0Ih3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:37:29 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DE0A5D0;
        Mon, 27 Mar 2023 01:32:02 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id l12so7748482wrm.10;
        Mon, 27 Mar 2023 01:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679905918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0IgR10FE6V1U4aJROuVTnUv5RQNS8iilsZvadRjruEI=;
        b=JZHw7DhT7u8gIH0Smm2TUiwFfNVOgRymnTFuntx9+v5kRedthdsF+9oRASwUthWgS9
         TBJZm4MErtdCmrMASYYI8scWmA0n/rgCQvuU3sabPrKAJpgjMWCbptxwzRoPjEMq/0dZ
         cEgyBuBx0+rdAu48b4MqnfTST7L9oG5dWO0jCvrEoSYkA+wMXf3HI4Wo/TERbcGmhUzU
         9qUClW8e5dg2fwxxrzZ5R3tnTUxaNLuq66+/Z/KYevD7sja9PgfzcicVMq4H9BmduCZt
         tamx+N9MpOQWfiq+j4ogYgZDvidRU+IsHkVo6LZ2hy+jriMv3YmFT+rC7w+s10zaAQ2R
         ytXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679905918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0IgR10FE6V1U4aJROuVTnUv5RQNS8iilsZvadRjruEI=;
        b=ymZe5dIiPn6JM6Id2DDMBwdbJHPJJOpv/KNB9slnS3PT76Vybn26KG/xXo0MM1+uXK
         aZY5B/5HL+rCoLrwCsX9UIqm3ACkVeP+g/UF2T2qwh67FMgedCmyXng9C8umsUT9H/GU
         SUVVMq4+2aH7rWwFDdz1dh9TvU06glGiRAZ/a8JKny6a5JPUAG1koWgrOBEXkt/gYBCN
         WKtY9lNc9FcUnjmVrLSLU12knMDOaZCKxH/gO07q0WHepx2bsG53c+F+AbMW8L0303DF
         Tiv//9KgQOMH953GyJM3yKogwancPDC+gOL8ZK1QvsEztRNEX1T4ug46AsDZzPzDxFjX
         mfkQ==
X-Gm-Message-State: AAQBX9dJJh5ozwCJh3I5ZAQ+3CHhMIrIffex2o1LyNmv+GUB4ly5VTVn
        nXsBSbszi93W1XruAIJ9+Hcrrk5pnbbgkw==
X-Google-Smtp-Source: AKy350ZuXvN7xjarwrJag1Vlz0PDcM9x6DyHUanDlKuZ0dRUp12SN3JS8lvPgQ1WXq+j0KMK3I1JDg==
X-Received: by 2002:adf:dc43:0:b0:2d4:e666:cab4 with SMTP id m3-20020adfdc43000000b002d4e666cab4mr9434614wrj.30.1679905918006;
        Mon, 27 Mar 2023 01:31:58 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:7887:5530:69a2:a11f])
        by smtp.gmail.com with ESMTPSA id z6-20020a056000110600b002c557f82e27sm24353249wrw.99.2023.03.27.01.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 01:31:57 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v5 3/7] tools: ynl: Add struct attr decoding to ynl
Date:   Mon, 27 Mar 2023 09:31:34 +0100
Message-Id: <20230327083138.96044-4-donald.hunter@gmail.com>
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

Add support for decoding attributes that contain C structs.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 Documentation/netlink/genetlink-legacy.yaml |  5 +++++
 tools/net/ynl/lib/nlspec.py                 |  2 ++
 tools/net/ynl/lib/ynl.py                    | 15 ++++++++++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
index 5dc6f1c07a97..d50c78b9f42d 100644
--- a/Documentation/netlink/genetlink-legacy.yaml
+++ b/Documentation/netlink/genetlink-legacy.yaml
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
diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index 6cc9b7646ae8..d1e5f60af580 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -152,6 +152,7 @@ class SpecAttr(SpecElement):
         value         numerical ID when serialized
         attr_set      Attribute Set containing this attr
         is_multi      bool, attr may repeat multiple times
+        struct_name   string, name of struct definition
         sub_type      string, name of sub type
     """
     def __init__(self, family, attr_set, yaml, value):
@@ -160,6 +161,7 @@ class SpecAttr(SpecElement):
         self.value = value
         self.attr_set = attr_set
         self.is_multi = yaml.get('multi-attr', False)
+        self.struct_name = yaml.get('struct')
         self.sub_type = yaml.get('sub-type')
 
 
diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index eada229402fa..63af3bd9787d 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -102,6 +102,17 @@ class NlAttr:
         format, _ = self.type_formats[type]
         return list({ x[0] for x in struct.iter_unpack(format, self.raw) })
 
+    def as_struct(self, members):
+        value = dict()
+        offset = 0
+        for m in members:
+            # TODO: handle non-scalar members
+            format, size = self.type_formats[m.type]
+            decoded = struct.unpack_from(format, self.raw, offset)
+            offset += size
+            value[m.name] = decoded[0]
+        return value
+
     def __repr__(self):
         return f"[type:{self.type} len:{self._len}] {self.raw}"
 
@@ -377,7 +388,9 @@ class YnlFamily(SpecFamily):
         rsp[attr_spec['name']] = value
 
     def _decode_binary(self, attr, attr_spec):
-        if attr_spec.sub_type:
+        if attr_spec.struct_name:
+            decoded = attr.as_struct(self.consts[attr_spec.struct_name])
+        elif attr_spec.sub_type:
             decoded = attr.as_c_array(attr_spec.sub_type)
         else:
             decoded = attr.as_bin()
-- 
2.39.0

