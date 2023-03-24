Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2F06C7D51
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 12:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbjCXLic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 07:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjCXLi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 07:38:29 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0250D1D92E;
        Fri, 24 Mar 2023 04:38:27 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id r11so1463120wrr.12;
        Fri, 24 Mar 2023 04:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679657906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UknnM/LyXPl7qqTNocHtWRPHH99DiTOzTPEQbzahRG4=;
        b=Y/a954F+6g6Wx9HSw8yb0eDc5g8uemxWS4+NHlL2SiIKAGZW2s55VUqFVvDV3MICZz
         t83sqgursXuxIRBioA3QwzePsOoPbUI4uY0N6CEAKSq/s945tBA0q4U1ytVcOFyJFR8S
         CXxT+xe4HXxbTnZegXhraQejIwlI3m0uLXKmUx7G7eEo5QUBkpcOmLjfjNSsatb3TENi
         uOAFQ2NbP9jsuwzYPCPDO4rXQXjLjY/GTgFXHWPpqQhdg8NgVzaP9UbJTl/KhhKjtVFD
         HPckdyA4DoZvLa3Fyc0AxPZCvj4TvpQpCyzCh1Wmc8298PYQ+25XrKgXEEoKJtBEznik
         fxgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679657906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UknnM/LyXPl7qqTNocHtWRPHH99DiTOzTPEQbzahRG4=;
        b=rE9Gv2uqtA8w+3MF1O5MG/kDsdpUKCJBX7wQ5dvN2IfhWnglln/rIw79xoU9mQij4O
         sNZ5S0d5GrPE856dL7B+FIwktbBgWg9s9ebetmSkl+ckQgoqd0pD8j8ed2rsNH7nG0+O
         xTU/PtLofuNh8B5lt+fsWJJ9EYqYdHaEK7yNUcmU37Z5aTvd79rzc1G9R2+/kkCawE3j
         EzMbAw0DbxDwGCs/riBrh2+jD0p/tIe3pRtlrtPxJyzlEcT9+lNQFC6Bx1Z2pTMYwgRo
         j8nDmQfGq6r0JDpELU78XrfotZ42KJsjoyotKxnQZ9KvystKMgW7WQz94ETWF+lf8Dyh
         /Hrg==
X-Gm-Message-State: AAQBX9d+aW61cEWlkzs04hLsapLiDIgaHiyMssdmls8OD3xSLKNixixG
        SJwtx/POKdd1da8+/jwCLMgK0MGvvHpRKw==
X-Google-Smtp-Source: AKy350a5dCLtvzt+u0sl0mZrAsMDKTsUTzCsWaeiqODw5LXYgHBrw1XJVDAJmLwWDLN1Czo2+1bp+w==
X-Received: by 2002:adf:f4c7:0:b0:2ce:ac70:5113 with SMTP id h7-20020adff4c7000000b002ceac705113mr2006147wrp.41.1679657906035;
        Fri, 24 Mar 2023 04:38:26 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:cd72:bbb4:8d1:483a])
        by smtp.gmail.com with ESMTPSA id t6-20020adff606000000b002d828a9f9ddsm10150954wrp.115.2023.03.24.04.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 04:38:25 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v3 3/7] tools: ynl: Add struct attr decoding to ynl
Date:   Fri, 24 Mar 2023 11:37:30 +0000
Message-Id: <20230324113734.1473-4-donald.hunter@gmail.com>
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

Add support for decoding attributes that contain C structs.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 Documentation/netlink/genetlink-legacy.yaml |  5 +++++
 tools/net/ynl/lib/ynl.py                    | 15 ++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

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
diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index fbcaca67d571..b2845a63f6af 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -102,6 +102,16 @@ class NlAttr:
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
 
@@ -371,8 +381,11 @@ class YnlFamily(SpecFamily):
         rsp[attr_spec['name']] = value
 
     def _decode_binary(self, attr, attr_spec):
+        struct_name = attr_spec.get('struct')
         sub_type = attr_spec.get('sub-type')
-        if sub_type:
+        if struct_name:
+            decoded = attr.as_struct(self.consts[struct_name])
+        elif sub_type:
             decoded = attr.as_c_array(sub_type)
         else:
             decoded = attr.as_bin()
-- 
2.39.0

