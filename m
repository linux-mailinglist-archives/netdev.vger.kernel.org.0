Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D7C6C85B9
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbjCXTTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbjCXTT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:19:28 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00ECB49EE;
        Fri, 24 Mar 2023 12:19:24 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id l7so2315728qvh.5;
        Fri, 24 Mar 2023 12:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679685563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bHqnuX3WU+YARDnObs3l+MTKnKtxe8++rZbFFZTLe6U=;
        b=HPvXhM8QR0gYIpFBflj4vQOC6paEHAoktF/xyautsfrGvNkYCtnxELpPrpsHqb/q39
         XfhYFwVa5pms9ODtRvRh68xRLafmgQ6+/o7v3/QmO7223bfHOaYYCmFGGvawgJGPswac
         3c/0LEzfRr9iqab4rRl1xKMSD77kScpanS6YNnhF3mqii0lyjgyurunPcl3ppDyzQNcF
         VfnbmErSqFXmHXGHhtYVKmR6KE/9Qp7B2FwHWRXbJkw8pXbTF+ea+2W6SxoMC91rL1zs
         dmQa4jqc+wI+/YRYZdWsGIka8DOiWrou3sl9hFlJdw+Ha607+XYdZ+73WeNSA5oMBJQ3
         xq1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679685563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bHqnuX3WU+YARDnObs3l+MTKnKtxe8++rZbFFZTLe6U=;
        b=cwVNKYBdBFOhsNL3aS8kkkMIVs58abu+UTsfNNVyZm9lgszpWZhYM/maQt7ZLnbS1x
         fqGQUuYqHe2pnsQwXkD++FEkZIrVqDzGUpnAWHI1KMPWPjzBqZo6A94DUMaLQm9Gzgme
         ComELhZPZrpSyyAV7nZGca6EUeDAW/eVoF8/OezLlSLMEJZUVBoZccmWhgb1DL+xomui
         JlOmoA0brDT5P3pzcCVSjvn1Tdi3BJYWiBxGNuvJsf+swCVA6eC3oZxp9qHDQpsgaOh5
         fbkwgGbrBGf8k+FK36RrsfY5pGjiPYAax1h25NlApwm23JVSKd9AR/g5SurKYxIeaPIl
         PNow==
X-Gm-Message-State: AAQBX9fNaI9PlJtGWnRQ+PjKhYDKXSFBhDkLzAwqYPsB5aJCHGJPDCWr
        5U/xK8MWobL3rLnY6IyI4/Kw7QKEozOViA==
X-Google-Smtp-Source: AKy350YcAW2LlVWi/AD4kREbhmf9I5m/Hf6wD2vyplr2p393yKhw8aHN1gsizxfI/9yTuAeSshUxow==
X-Received: by 2002:a05:6214:2528:b0:537:6416:fc2b with SMTP id gg8-20020a056214252800b005376416fc2bmr6571553qvb.52.1679685563610;
        Fri, 24 Mar 2023 12:19:23 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id cn5-20020ad44a65000000b005dd8b9345e1sm900141qvb.121.2023.03.24.12.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 12:19:23 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v4 3/7] tools: ynl: Add struct attr decoding to ynl
Date:   Fri, 24 Mar 2023 19:18:56 +0000
Message-Id: <20230324191900.21828-4-donald.hunter@gmail.com>
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
index b635d147175c..af1d6d380035 100644
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
 
@@ -373,8 +383,11 @@ class YnlFamily(SpecFamily):
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

