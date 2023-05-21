Return-Path: <netdev+bounces-4118-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFDD870AF1D
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 19:08:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E7391C2092F
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 17:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 920AC6FDB;
	Sun, 21 May 2023 17:08:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854CB7483
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 17:08:11 +0000 (UTC)
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AA5E64;
	Sun, 21 May 2023 10:08:10 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-565014fc2faso2236357b3.1;
        Sun, 21 May 2023 10:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684688889; x=1687280889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KtXLZKAl6xwhZGxiyJdAxrie9KH+GUGPmi8zHuui3WU=;
        b=gZge9XNNDFGvbQaI/93rBmnyjmlOOzchzn0TcnKxClPXB/9a8+HFiRu44JOPLYux2h
         9MgopPq2JfpCFFVnHAvIjOEWhNkmazbLuAdj6/nGVpRTCWdxPBagtUgrKWDxZfzU03Ga
         9X2pP106CZlaJQMd4sIi3urTQpUiBwpILjCWSGkBRkjWmq57ev3gRkpqYcjdEksX1odS
         2cIjTpohpvI3rVhoCyPoBPX0u9cctN/j6J2U29Mz94o2nFN+FWn3pcl3mXSqFmQRHJd7
         rlLFNf6uOLW4albaVvf+BNw0dkCr38Vpj3kHIKOrPFQlZk3XXZR8Pca/QXFFi1vAkthw
         IxFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684688889; x=1687280889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KtXLZKAl6xwhZGxiyJdAxrie9KH+GUGPmi8zHuui3WU=;
        b=HAtqJRpyc6Ogv10YJ7qZq1j6DMXCMTNMuGQQ5a5m2jEIttdl3PAyT21VmnjtmYuYkh
         rZEJV96+lEOdN+iCYh4H0H14El0HuDnZcxLQbIE8WzdeCX+X9xNQIWT98rLRTykHOZDl
         G2qS3g2wmqrJsyGDjhLAGk8v/RVxbe4eSB9QV9xgjF9gKXw/dXgdyvXKS6Md3ZnUj6aZ
         HHm0A/lPESbHeGjhkL3OgsfHkqz1Bqe9yUnfKV7P1VAaJE5EoA3Cv8yFHCYSvA0FicbB
         rmcietDc0q1AWHPuQ8a81W8eGREA13NCkBHXj2IOlwF4BnWEYMMnC/tRxnrBrtqeoMhS
         Iwcw==
X-Gm-Message-State: AC+VfDwYv2q2c9eSm4kfnFfqma0KpvfaoD2kuUc5XIuq0bvuybuup+yt
	2ni30yNddJjqpWNMmSyROTK+lvUg/zX3ziS1
X-Google-Smtp-Source: ACHHUZ4kmfkL+nmznztBYYqmXh44SqJXtSDyQqbFoa+yBmX9koYgMWGcz1kXqBsYTJ/Z2KqWYTmsVA==
X-Received: by 2002:a81:6585:0:b0:559:de1d:3253 with SMTP id z127-20020a816585000000b00559de1d3253mr8959189ywb.21.1684688888910;
        Sun, 21 May 2023 10:08:08 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:7d01:949c:686a:2dea])
        by smtp.gmail.com with ESMTPSA id y185-20020a817dc2000000b00545a08184fdsm1420062ywc.141.2023.05.21.10.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 May 2023 10:08:08 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [patch net-next v1 2/2] tools: ynl: Handle byte-order in struct members
Date: Sun, 21 May 2023 18:07:33 +0100
Message-Id: <20230521170733.13151-3-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230521170733.13151-1-donald.hunter@gmail.com>
References: <20230521170733.13151-1-donald.hunter@gmail.com>
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

Add support for byte-order in struct members in the genetlink-legacy
spec.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
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
index 62e31db07c1f..41a4f8de7e17 100644
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
@@ -544,7 +544,7 @@ class YnlFamily(SpecFamily):
             fixed_header_members = self.consts[op.fixed_header].members
             for m in fixed_header_members:
                 value = vals.pop(m.name)
-                format = NlAttr.get_format(m.type)
+                format = NlAttr.get_format(m.type, m.byte_order)
                 msg += format.pack(value)
         for name, value in vals.items():
             msg += self._add_attr(op.attr_set.name, name, value)
-- 
2.39.0


