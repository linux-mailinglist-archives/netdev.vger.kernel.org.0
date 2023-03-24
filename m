Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E1B6C85B7
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbjCXTTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjCXTTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:19:23 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9648F49EE;
        Fri, 24 Mar 2023 12:19:22 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 59so2241227qva.11;
        Fri, 24 Mar 2023 12:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679685562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qlsDeibRNspBbL1ZNhnut7pdMXrpf1TC9rqstiR62cY=;
        b=QeWSWZLy+ABbDTHhi7d6A1TOkmCB9fxqqp+/D9sGrV/olNZSJWoG3/fa++rx3KywY3
         x7CI1ZAMkxALwtF9cjlu9443l1sLyopR+7JBj5WRO3xtYBvzdfTS4XXvr9tGjeEX4cAH
         pCcT0kntu9crF5tXz2bTgcGhMe1ORQ7FWoRq8JH7pvLOkOKCRIRnR/dY2sL+Yq3VDxxq
         vMDbDfKuhfcak+7s896ZSJbfL/4xLfaZJW7PoEagC95A1GvFf6M1mNmQlbB3qk8T4obZ
         nZw56arIPved2+vJ8PvG33OW9BvHmxTuoUElQvB2WZTW2Qq1WF/6NauYmEIFh07nL5TZ
         cgAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679685562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qlsDeibRNspBbL1ZNhnut7pdMXrpf1TC9rqstiR62cY=;
        b=ldfvzs4zCrnJzwSqco5ysJcY81ji/SejxqFiR9RZeWTaogByEHmzbQUpWsafZFquJS
         qupKXEPTVOUpviDbP0ymZKtWIhU7zE6c8ptu8rtVxwNeFxF6/+rIzSOKimC3y/Qa489I
         jaxmXLGeodN15ojCp8GKl9LDJUkcRS2qFGcF6Wzxw6lgrr7cwHVgWz9aS50fwVpbpPCl
         sbkGQqlHvsj3iMjc9zeCV1Hf4XG6ttMwN61J6ugvMOWkaQl6bFio5yFeHWiohWZthife
         tcTm8e7D6Kkuy40zFkidxGAcqbBb59qAjv5dCIWDI9+nYaONFgfk950H7o//pPs5Siml
         Ro4w==
X-Gm-Message-State: AAQBX9ebZSjeHng7+E1p+/15HVIjPfD+t06X57yK8P/DlHFg33G4g5l4
        vbJlJh917aez1nGv1z+qcOvUrxktzzc39g==
X-Google-Smtp-Source: AKy350ZphiSzn2tLykGsJZ5OnvGLX1c5/c+g55LVtHMdYHjBc7WBN+sVlRyIDqd5IwaPiumbtn2K9w==
X-Received: by 2002:a05:6214:5299:b0:5b4:89b4:1af8 with SMTP id kj25-20020a056214529900b005b489b41af8mr6260209qvb.16.1679685561782;
        Fri, 24 Mar 2023 12:19:21 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id cn5-20020ad44a65000000b005dd8b9345e1sm900141qvb.121.2023.03.24.12.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 12:19:21 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v4 2/7] tools: ynl: Add C array attribute decoding to ynl
Date:   Fri, 24 Mar 2023 19:18:55 +0000
Message-Id: <20230324191900.21828-3-donald.hunter@gmail.com>
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

Add support for decoding C arrays from binay blobs in genetlink-legacy
messages.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 tools/net/ynl/lib/ynl.py | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 98ecfdb44a83..b635d147175c 100644
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
 
@@ -363,6 +372,14 @@ class YnlFamily(SpecFamily):
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
@@ -380,7 +397,7 @@ class YnlFamily(SpecFamily):
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

