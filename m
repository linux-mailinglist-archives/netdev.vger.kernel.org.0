Return-Path: <netdev+bounces-4615-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF0B470D945
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:38:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A68A21C20CF3
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60E0A1E531;
	Tue, 23 May 2023 09:38:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560421E500
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:38:11 +0000 (UTC)
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D47120
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:38:09 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-3f6a3a76665so12784131cf.1
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684834688; x=1687426688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JGqlSrjcDP9z0RjV/6OUxF9TUChHYrSZ7d1FAzFKzFU=;
        b=QKeSCGEExy6U0F48myNihsAVHYvUd10367+93vIvK4FKzaLd40YQzK9yOIS9iL8355
         pZcG0MWpwhwAq8o3CmtiYbotNwj08gejIXrA/iCwNSbf3iL1b6CQTgWOTUq1Hgt66kZW
         obUvGnXxJtR08i68d7pZg4g92eWeRybt8FUs9QqBTR2rtjs50uYiFasDxqu+jBU+teD6
         WhT4MgTZN7g3pJx3ztNsmpy4avENKRb3lXrXxmQH80nxnd2Ip4PWMiDBllS9Nq6WrjY1
         uIh89BC8+2n/psCx87OghYhyyw4D2W8DoPy/lT4VNgszG38Ph+HEgUStGcjMm1LY3225
         bb/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684834688; x=1687426688;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JGqlSrjcDP9z0RjV/6OUxF9TUChHYrSZ7d1FAzFKzFU=;
        b=j0PCuNl213Gt5D94r6rNY30r3xP4By8Xj4ujb42RNKcU3W/e1eK5o1j/6aZtK8oEjd
         nnlnY26DBI73pbeUSRCoA4FLuvUi6bJBHRzzv+eLyrmuQ7P2R05HSjweZwzFjyk1xnhj
         0ScwvgcypYowof9zsMK9INlYU0WTYoMwYoa/0oLoKZtMK0k0cwNaKNuPs6giPH+ykWOD
         2H70r9/tiAfwxPeXSm+ye4UgpqbbK7I54IsqBVlwu72lT5I15NkEn6UXZVVdGDoaOOYK
         4bjyWpOjp+aclta01AhtbTAPonnSWJ894fHGvfnaP0gkWMX7g8LFlhdyV2PdLz/u84KH
         R0qg==
X-Gm-Message-State: AC+VfDwEOIHS2Dk1BNpvMYscX8zAVbMQ6W82BDGfzKva+7XtNk0mTZU/
	a82pD7usk91KtVqvyrlixdgMlDyFll0IemzJ
X-Google-Smtp-Source: ACHHUZ4oBbQh7WLfzcdilZ9SbuYxGa1yNYV7IrUFpeg6cU1EbjvV1Ncs6alsS5P1k2tNro9TsvFhdg==
X-Received: by 2002:a05:622a:138d:b0:3f6:adda:afd6 with SMTP id o13-20020a05622a138d00b003f6addaafd6mr9271079qtk.10.1684834688583;
        Tue, 23 May 2023 02:38:08 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id x7-20020a05622a000700b003bf9f9f1844sm2758128qtw.71.2023.05.23.02.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 02:38:08 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v2 2/2] tools: ynl: Handle byte-order in struct members
Date: Tue, 23 May 2023 10:37:48 +0100
Message-Id: <20230523093748.61518-3-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230523093748.61518-1-donald.hunter@gmail.com>
References: <20230523093748.61518-1-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support for byte-order in struct members in the genetlink-legacy
spec.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/netlink/genetlink-legacy.yaml | 2 ++
 tools/net/ynl/lib/nlspec.py                 | 4 +++-
 tools/net/ynl/lib/ynl.py                    | 6 +++---
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
index b33541a51d6b..b5319cde9e17 100644
--- a/Documentation/netlink/genetlink-legacy.yaml
+++ b/Documentation/netlink/genetlink-legacy.yaml
@@ -122,6 +122,8 @@ properties:
                 enum: [ u8, u16, u32, u64, s8, s16, s32, s64, string ]
               len:
                 $ref: '#/$defs/len-or-define'
+              byte-order:
+                enum: [ little-endian, big-endian ]
         # End genetlink-legacy
 
   attribute-sets:
diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index a0241add3839..c624cdfde223 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -226,11 +226,13 @@ class SpecStructMember(SpecElement):
     Represents a single struct member attribute.
 
     Attributes:
-        type    string, type of the member attribute
+        type        string, type of the member attribute
+        byte_order  string or None for native byte order
     """
     def __init__(self, family, yaml):
         super().__init__(family, yaml)
         self.type = yaml['type']
+        self.byte_order = yaml.get('byte-order')
 
 
 class SpecStruct(SpecElement):
diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 6185ba27f2e7..39a2296c0003 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -124,7 +124,7 @@ class NlAttr:
         offset = 0
         for m in members:
             # TODO: handle non-scalar members
-            format = self.get_format(m.type)
+            format = self.get_format(m.type, m.byte_order)
             decoded = format.unpack_from(self.raw, offset)
             offset += format.size
             value[m.name] = decoded[0]
@@ -305,7 +305,7 @@ class GenlMsg:
 
         self.fixed_header_attrs = dict()
         for m in fixed_header_members:
-            format = NlAttr.get_format(m.type)
+            format = NlAttr.get_format(m.type, m.byte_order)
             decoded = format.unpack_from(nl_msg.raw, offset)
             offset += format.size
             self.fixed_header_attrs[m.name] = decoded[0]
@@ -542,7 +542,7 @@ class YnlFamily(SpecFamily):
             fixed_header_members = self.consts[op.fixed_header].members
             for m in fixed_header_members:
                 value = vals.pop(m.name)
-                format = NlAttr.get_format(m.type)
+                format = NlAttr.get_format(m.type, m.byte_order)
                 msg += format.pack(value)
         for name, value in vals.items():
             msg += self._add_attr(op.attr_set.name, name, value)
-- 
2.40.0


