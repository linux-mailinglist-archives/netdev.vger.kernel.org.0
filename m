Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204B06C85B6
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbjCXTTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjCXTTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:19:22 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B3646B6;
        Fri, 24 Mar 2023 12:19:21 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id o44so2331330qvo.4;
        Fri, 24 Mar 2023 12:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679685560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3QaKKaAV5uskNotm4xfaVm8rl+bvQRGyp7RvzE6EVzE=;
        b=Q0fJDaQeW5wvSe+fFziVQHt66kLEB3eUMJmm3rMpxvYPtNmTUpFRtbDQBO+5ElSARJ
         64fTwS+OK0heENwMHAyUzSpu6FIWoiMfTZiZlre47MK5v3AIhHom1URq1/perGThaF66
         TZLoFHS6TMuSYtjVb1qvPSrAIWaF/sQx4WxEDQljo0RzyvDDt34LuCise97NPXztNzks
         lhaDwnD4LIl4v87tJwZ21ArBH6sUnYbD75+hCQVwTC0UlacMED+Fpg05sOAj/nyR1Q9H
         sYPFGZBeAIFjelLl0BPWDufzPhJegiKmdvhEjHR/rTuodhCl3wbHyAYCbrsI68cKyBf/
         JE1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679685560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3QaKKaAV5uskNotm4xfaVm8rl+bvQRGyp7RvzE6EVzE=;
        b=Yrq2no1x/YrTThFgdXgSb9MDYKc5LEPDJwt8X2qJrQfiZiYwfRswFQq6ebQpVWm4FA
         6G0fMTVUqtGDc2Dk6OY4YF3KTpesn9lkSxfmqffRx19H1oeHn0ELRfySlFg0L0MJW5U9
         GuqUOdYtdQglZtW3J2axz59lYCwjFkWB2+4JxUBjizOAfkVtZamzNLMBXYosBWOelG8c
         pu5TPRZbYmoZUZqqIgj7UD//4mBLMlXtLmhhRJco9bDKSPsGZbQyhyksMLOngnjUk8HC
         76sobwR4epf2G++tu4swm9TJJmEiBDg8/6Q0Z7LdoGHzZhgDamUgHb9Ifp82JOmGlc/M
         hXTA==
X-Gm-Message-State: AAQBX9cfl5jYu49/c2KoJ8IBj3K1vG/wTQd0mRZ0W2uJbt9EZkUMnxlE
        FRFfOX6Dtwx/4+mp2vurEtWL7jEawg0BsQ==
X-Google-Smtp-Source: AKy350bo8Hgs7Rh3tiaqRdDPHiCMZq8VxVZ8Kf3j8Pp3qZloNsfj2g+PvtQtJ7HHiotz2aJVArznlQ==
X-Received: by 2002:a05:6214:2604:b0:5ab:e259:b2a9 with SMTP id gu4-20020a056214260400b005abe259b2a9mr7661224qvb.14.1679685559848;
        Fri, 24 Mar 2023 12:19:19 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id cn5-20020ad44a65000000b005dd8b9345e1sm900141qvb.121.2023.03.24.12.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 12:19:19 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v4 1/7] tools: ynl: Add struct parsing to nlspec
Date:   Fri, 24 Mar 2023 19:18:54 +0000
Message-Id: <20230324191900.21828-2-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230324191900.21828-1-donald.hunter@gmail.com>
References: <20230324191900.21828-1-donald.hunter@gmail.com>
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

