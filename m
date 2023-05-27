Return-Path: <netdev+bounces-5908-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B7DC713504
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 15:32:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA1792816F7
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 13:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B3F11CB9;
	Sat, 27 May 2023 13:31:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB9A134A4
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 13:31:27 +0000 (UTC)
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD3FA6
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 06:31:25 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id 6a1803df08f44-6238b15d298so16687276d6.0
        for <netdev@vger.kernel.org>; Sat, 27 May 2023 06:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685194284; x=1687786284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oO+MOoCeaISCIJawKV3hcrba9wOa+mOZkI3JvL+GFfM=;
        b=bewkQSPtpvNQnYbJJYJOt5zcOYD41IGYcJ7WJAnNY2gSl3pFiIjryeZ54KYdsTAFwH
         lJC0C7pfLV+phSHA9bG/07Mo+uymYrMWyK5BcZjtt/dD4FriaTEdyvvn6+vFx+i/li+Q
         HQvdnlQw+H1yqpGP4hdZQK1k5WAK7tTUaUpPaAbLnxWN/acJYqdNLz4oylQrBz9VK94p
         OZKbubOrh0vGcZh6cE3xzXLPWqYnqHrKVl0YS4HmAeQISTq0b/eClM1shkAMqJ+NoSTT
         g29G78cMXZhmIC+DWZ07arRAxac1uD5zqmhZEDofmaXmFlgMj8z7Zw5CdK5W/rNlbPy8
         os2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685194284; x=1687786284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oO+MOoCeaISCIJawKV3hcrba9wOa+mOZkI3JvL+GFfM=;
        b=g7c6XohEUd9RFyrNRNnwcdP29syKABZpFwi1Hwmm/qS30dqFtZr92kYNHJPXFfxL9p
         etIai2FHWGMfn40OAgAVIF+RBTz9A845iJFJn71ilh0iHE7IaJP0WKpKCUBbG1UodKjU
         Tf6+/08GoGS1lsMy2KUXok0JfekJwHwGAE5rvTQ0POHsgM8KyaDFyheaMiSbHT2Hrg6L
         42/SFYaoPwne4qbU2sRPOyX2ArVcECgbCu8FOjrwVmnZDdph7E90cSXRkp+2CNqeOvl+
         mC2WdQ16qNm5ejW00OagZ/aWyc2MH1GlMqgpP/+BRcq6YWhCnP5DBW5jwjMx0qCdNfiV
         /qKw==
X-Gm-Message-State: AC+VfDyStqrZvEL82BbZD9wlxpjfzNVAbXvCNNhJ5A71rMz4SdrnF+EX
	5Ab+BYYmnBQiFaSla2x31yr/oRx649cthU++
X-Google-Smtp-Source: ACHHUZ4DSqJSYUkNuEHJyIC4sNgAvjVqY9Pa4gcZ/uz4/Gayh34dbqRH9kJc5gaIJ7qNiZ1eRna19A==
X-Received: by 2002:a05:6214:2247:b0:5e9:5602:3af0 with SMTP id c7-20020a056214224700b005e956023af0mr6869957qvc.46.1685194283882;
        Sat, 27 May 2023 06:31:23 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id b10-20020a0cbf4a000000b006215f334a18sm2020282qvj.28.2023.05.27.06.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 06:31:23 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v2 3/4] tools: ynl: Support enums in struct members in genetlink-legacy
Date: Sat, 27 May 2023 14:31:06 +0100
Message-Id: <20230527133107.68161-4-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230527133107.68161-1-donald.hunter@gmail.com>
References: <20230527133107.68161-1-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Support decoding scalars as enums in struct members for genetlink-legacy
specs.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 Documentation/netlink/genetlink-legacy.yaml | 3 +++
 tools/net/ynl/lib/nlspec.py                 | 2 ++
 tools/net/ynl/lib/ynl.py                    | 6 +++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
index d8f132114308..ac4350498f5e 100644
--- a/Documentation/netlink/genetlink-legacy.yaml
+++ b/Documentation/netlink/genetlink-legacy.yaml
@@ -127,6 +127,9 @@ properties:
               doc:
                 description: Documentation for the struct member attribute.
                 type: string
+              enum:
+                description: Name of the enum type used for the attribute.
+                type: string
         # End genetlink-legacy
 
   attribute-sets:
diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index c624cdfde223..ada22b073aa2 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -228,11 +228,13 @@ class SpecStructMember(SpecElement):
     Attributes:
         type        string, type of the member attribute
         byte_order  string or None for native byte order
+        enum        string, name of the enum definition
     """
     def __init__(self, family, yaml):
         super().__init__(family, yaml)
         self.type = yaml['type']
         self.byte_order = yaml.get('byte-order')
+        self.enum = yaml.get('enum')
 
 
 class SpecStruct(SpecElement):
diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 85ee6a4bee72..0692293447ad 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -412,7 +412,11 @@ class YnlFamily(SpecFamily):
 
     def _decode_binary(self, attr, attr_spec):
         if attr_spec.struct_name:
-            decoded = attr.as_struct(self.consts[attr_spec.struct_name])
+            members = self.consts[attr_spec.struct_name]
+            decoded = attr.as_struct(members)
+            for m in members:
+                if m.enum:
+                    self._decode_enum(decoded, m)
         elif attr_spec.sub_type:
             decoded = attr.as_c_array(attr_spec.sub_type)
         else:
-- 
2.39.0


