Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87A96C7D4F
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 12:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbjCXLi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 07:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCXLiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 07:38:25 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AE41D931;
        Fri, 24 Mar 2023 04:38:24 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id y14so1486714wrq.4;
        Fri, 24 Mar 2023 04:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679657902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3QaKKaAV5uskNotm4xfaVm8rl+bvQRGyp7RvzE6EVzE=;
        b=M7ZD+jbhHHlBY7CNybvO9TRZe6Q7640MqfVOOATyKqFyc86/nvTJ0ZWX8l1Ih3lHhH
         cK689vY14xDcnJkp+3ACFmJkF27K5G1nPum5CR/7YkezN60VRLSX3zwXCJCqGtsC7ct2
         bw5SUGsFM2jInNHv95RZIlGsLWMC9ctF+gCCKWkjM2kTO1jfFGIVmMesylBMI92r74Kn
         RzwR3dh5RsAi/LUKNqK6F2LygFW4O0BVT/34gB5wotKygzAktJCSLXUzh1ZAUByaPk//
         AjeDgJDi+ibTUPfQCv/N8VbXBhCwlENYF57mOelBmTQUqwpB8wbuzLWjnKQHqp+bbNVR
         XifQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679657902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3QaKKaAV5uskNotm4xfaVm8rl+bvQRGyp7RvzE6EVzE=;
        b=f4hIm9Ix3I/xhpPkzR2zsv3YKDlH9vaVEikWWrjhNs58A0D1QEZkKNQf4XsaYTFoaQ
         Yo/uZ04h3m0Z/fGG0UigGDzxylaGEcrM8IHfoO1PnXRkjJzRdxhi+k9fDRhkhbaxJBUt
         qkJ+KHQrRNx3XNIWUSKXmpYf6QzyVF2whO2JEG6vidizBvjsA1z/uvPMUZLyqVP9ZuOP
         08Yiw30/d+EF9zIRqe9ZH0TqzInsERX3DUAZqkSsL8F8Y8v8u3zu6b8mGhqgR+bF2cBb
         AQz9fZHAL9NCw36BL8Ys21e0FIpxiv5DYoKzwRXPrAAhr9oyU63jLqm+oLyNcoa9zHDm
         1bqQ==
X-Gm-Message-State: AAQBX9cyLfM85ZWLqc6J8eNXtFt8CcX/g7BnKSTspBfPpuSFeQEEMDbn
        CHWjqLR1pqQR9WM0jnWhskKL+0mLx/O3lQ==
X-Google-Smtp-Source: AKy350a9Ky3sT70E9GhO1ppy3WVijz2YPeV3jqBVf/FOuOjmbckYUQmT9s0N2ZlvrGoqULvK+c9Hgg==
X-Received: by 2002:a5d:428c:0:b0:2d3:3cda:b3c6 with SMTP id k12-20020a5d428c000000b002d33cdab3c6mr1892991wrq.40.1679657902449;
        Fri, 24 Mar 2023 04:38:22 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:cd72:bbb4:8d1:483a])
        by smtp.gmail.com with ESMTPSA id t6-20020adff606000000b002d828a9f9ddsm10150954wrp.115.2023.03.24.04.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 04:38:22 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v3 1/7] tools: ynl: Add struct parsing to nlspec
Date:   Fri, 24 Mar 2023 11:37:28 +0000
Message-Id: <20230324113734.1473-2-donald.hunter@gmail.com>
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

Add python classes for struct definitions to nlspec

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 tools/net/ynl/lib/nlspec.py | 43 +++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index d04450c2a44a..a08f6dda5b79 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -214,6 +214,44 @@ class SpecAttrSet(SpecElement):
         return self.attrs.items()
 
 
+class SpecStructMember(SpecElement):
+    """Struct member attribute
+
+    Represents a single struct member attribute.
+
+    Attributes:
+        type    string, type of the member attribute
+    """
+    def __init__(self, family, yaml):
+        super().__init__(family, yaml)
+        self.type = yaml['type']
+
+
+class SpecStruct(SpecElement):
+    """Netlink struct type
+
+    Represents a C struct definition.
+
+    Attributes:
+        members   ordered list of struct members
+    """
+    def __init__(self, family, yaml):
+        super().__init__(family, yaml)
+
+        self.members = []
+        for member in yaml.get('members', []):
+            self.members.append(self.new_member(family, member))
+
+    def new_member(self, family, elem):
+        return SpecStructMember(family, elem)
+
+    def __iter__(self):
+        yield from self.members
+
+    def items(self):
+        return self.members.items()
+
+
 class SpecOperation(SpecElement):
     """Netlink Operation
 
@@ -344,6 +382,9 @@ class SpecFamily(SpecElement):
     def new_attr_set(self, elem):
         return SpecAttrSet(self, elem)
 
+    def new_struct(self, elem):
+        return SpecStruct(self, elem)
+
     def new_operation(self, elem, req_val, rsp_val):
         return SpecOperation(self, elem, req_val, rsp_val)
 
@@ -399,6 +440,8 @@ class SpecFamily(SpecElement):
         for elem in definitions:
             if elem['type'] == 'enum' or elem['type'] == 'flags':
                 self.consts[elem['name']] = self.new_enum(elem)
+            elif elem['type'] == 'struct':
+                self.consts[elem['name']] = self.new_struct(elem)
             else:
                 self.consts[elem['name']] = elem
 
-- 
2.39.0

