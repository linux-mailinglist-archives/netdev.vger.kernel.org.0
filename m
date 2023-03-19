Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 669026C0470
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjCSTih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjCSTi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:38:29 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6FC7ABA
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 12:38:28 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d17so114959wrb.11
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 12:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679254706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MGoMP5Ydt29FPyCV4lBeSQAeOKjlwuxeDmPc4dpRBBA=;
        b=VGW60GsonB3Hpvq7tgxzfjNk0zeymJKQxMuZ0BtFD7XSO6pKp9lKwtwqpm71grA3IR
         Wis1dRYjz8N0cIvIgWr5u7L81tSgtIgTmHaoY6wN7nUM5W1CwaHUaUUmHydFF/9Z+DwV
         L2PH/u86/cwasJg7CHx/p9c97Ah+rV1Ddt6OjkKp7F9uuL0yNvFdB0MaGIPvOIylddfv
         ZzWVd9P4c6Gq1RkzobGM+6BTZP3SoQBmlNjmh/nRSqDciRVFtqFK7cOcTeR5OYV1x0L8
         KvBJDuDOevJfEMSxw32PayCHalKu89pCdOuEIzUOuIBQvfGr6ju9ekNafG/Mto1G9Mcj
         tnRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679254706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MGoMP5Ydt29FPyCV4lBeSQAeOKjlwuxeDmPc4dpRBBA=;
        b=f//iAkAtOUqP/uZyZMm6HrfR6A7E8F3PKBNfZ2LFM55K2MAD2JpKUEq4FaEX+lin5t
         KlRVXXz22FuALdY4UrbWrahK5xCol5dPhKmcYmejvGG7EtGSDp8EJ01T0/FIct3Sl1su
         uoIJKtDbQDKjPWe7+WDBm+FDcmbaAkP4mzP4zVwTY8p91jtHACZblbGtgeUBPW1UCAuQ
         szJiNAt0oUVyQmkkr94RMhLX245lFj+txS0uYrk9RhlLP773O068ehLC6HS/WWNj4FH7
         R+zVzw+WLhnw4i57LWosh3P3//CqvBeMlPdYzOo9HPxVvdg0aQvHVIzVM+c17ZUUhsd6
         TT3A==
X-Gm-Message-State: AO0yUKX+Q1Gfzx86BfdbDfU801NjrW/HlZyMVNV6WwUuYalr/KvfjZm9
        jLYunkpMNV5/JuUZRy3qf7Vnl1cr6j9wZA==
X-Google-Smtp-Source: AK7set/jd3yfVnDgfkm+kxGZmR2hKhTsoXryJVmGH83HlhVRurwcF/IkGjNkSh+YvCZGRdwB0xO2VQ==
X-Received: by 2002:a5d:5142:0:b0:2d1:53f5:900c with SMTP id u2-20020a5d5142000000b002d153f5900cmr7747300wrt.20.1679254706379;
        Sun, 19 Mar 2023 12:38:26 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id d5-20020adfef85000000b002cfed482e9asm7204190wro.61.2023.03.19.12.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:38:25 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v2 2/6] tools: ynl: Add struct parsing to nlspec
Date:   Sun, 19 Mar 2023 19:37:59 +0000
Message-Id: <20230319193803.97453-3-donald.hunter@gmail.com>
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

Add python classes for struct definitions to nlspec

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 tools/net/ynl/lib/nlspec.py | 42 +++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index d04450c2a44a..5ac2dfd415c5 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -214,6 +214,43 @@ class SpecAttrSet(SpecElement):
         return self.attrs.items()
 
 
+class SpecStructMember(SpecElement):
+    """Struct member attribute
+
+    Represents a single struct member attribute.
+
+    Attributes:
+        type    string, kernel type of the member attribute
+    """
+    def __init__(self, family, yaml):
+        super().__init__(family, yaml)
+        self.type = yaml['type']
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
 
@@ -344,6 +381,9 @@ class SpecFamily(SpecElement):
     def new_attr_set(self, elem):
         return SpecAttrSet(self, elem)
 
+    def new_struct(self, elem):
+        return SpecStruct(self, elem)
+
     def new_operation(self, elem, req_val, rsp_val):
         return SpecOperation(self, elem, req_val, rsp_val)
 
@@ -399,6 +439,8 @@ class SpecFamily(SpecElement):
         for elem in definitions:
             if elem['type'] == 'enum' or elem['type'] == 'flags':
                 self.consts[elem['name']] = self.new_enum(elem)
+            elif elem['type'] == 'struct':
+                self.consts[elem['name']] = self.new_struct(elem)
             else:
                 self.consts[elem['name']] = elem
 
-- 
2.39.0

