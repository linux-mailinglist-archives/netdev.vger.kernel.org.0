Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06AB46C9E04
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbjC0Ihp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbjC0Ih0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:37:26 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B5876A7;
        Mon, 27 Mar 2023 01:32:00 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id l27so7783096wrb.2;
        Mon, 27 Mar 2023 01:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679905916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pBxJwdkasfll4c1P/Ox5qD5BWll0iXc1I1GXZEfyI9I=;
        b=GOTkOo+ieYYB1QkraE93x4xAoMU9d02Ccz7dVFswTesltBL6iaXkfLOf3wO9UkGuws
         j2o+SxFwkRdi+SVB+X2L81edCWB8/QLc+Lldp5Qs6fJ0abgL/QsMWGP9BKw2dPIUZamK
         wH772q3I/23bEv7oYIoSu96NpGFbVsX9ndXeTyMyHiBTuS0SYb9rsujvy82olOoipHf4
         Ga38vECMi7sMvR4iqUCOFGRpDcLdt2PcyjtBP+NeuCtx12T5BnCKq8PHVKVlHdNAcd6b
         CDw3V6IAnuUTY8bGxsg8LGbTF/4koYdNHaF3NKnVzC/iP6wKRe9EGEPaTnPhwJlEyRUc
         YRFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679905916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pBxJwdkasfll4c1P/Ox5qD5BWll0iXc1I1GXZEfyI9I=;
        b=eqtEiJfoF1hq8OyXcCb9IahIPijsh1N+qsA0wI5iRtgYv+oQPMz/KxdSIojqu3Mk3I
         eok4GPjykUUky7Ak++0C/nEizg7iXjR3pTvJ+TtTdCAyEV27N0VRz1804zOvWJ+Dx7/a
         xdGvlD/lyb+caP+2fvm1clx4SFvjPXfXsBGamtOJNNXhocokLlKKcRhxZVfUKTIVabS5
         Mk7+7LQzlQi5PcFEj35qW9Lh21H2a/DUk0jaQ1oWlEl3l+OgPuJcnvXlpQMx9VHcBwBs
         K6VCCQ2W6SufqoARB2LA5IFUnVlaVL76GM32NslgXpC/LAZM3xWxIpUTXY6Xy3HCTM2y
         Qk8Q==
X-Gm-Message-State: AAQBX9dAXlLegMFe3xYUcqp4veWYYELfEGpn+kW570MAt1PrTHot0Y9b
        /DnGLnpRybHkPhAtZWCD7nGLXCCgp/07ZA==
X-Google-Smtp-Source: AKy350bozmdtmug+/7uxDp5TT41mbwZGBZLM+3Xq8dROJoL9V6HxhJ9POKQ9ZJcBNlUAI8r/odjyHQ==
X-Received: by 2002:adf:decf:0:b0:2cf:f30f:cc04 with SMTP id i15-20020adfdecf000000b002cff30fcc04mr7705518wrn.27.1679905915648;
        Mon, 27 Mar 2023 01:31:55 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:7887:5530:69a2:a11f])
        by smtp.gmail.com with ESMTPSA id z6-20020a056000110600b002c557f82e27sm24353249wrw.99.2023.03.27.01.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 01:31:55 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v5 1/7] tools: ynl: Add struct parsing to nlspec
Date:   Mon, 27 Mar 2023 09:31:32 +0100
Message-Id: <20230327083138.96044-2-donald.hunter@gmail.com>
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

Add python classes for struct definitions to nlspec

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/lib/nlspec.py | 43 +++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index dba70100124a..83de2a1a3cc6 100644
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

