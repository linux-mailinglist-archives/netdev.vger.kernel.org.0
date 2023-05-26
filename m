Return-Path: <netdev+bounces-5679-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DF837126BE
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:34:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 424261C21074
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0888A848B;
	Fri, 26 May 2023 12:34:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09AE18B04
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 12:34:08 +0000 (UTC)
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5010BE6D
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:33:32 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id af79cd13be357-75b0df81142so97076385a.2
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 05:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685104363; x=1687696363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yAyHtJVwXJMpvnPctLliEG4edo4ZofNChat7/lTPSBg=;
        b=W5XISFMSa/WriKEn2ET684XEOdFP8PNY1pDIl0dr5NPQEfGNHtROiOuTM59YwjJh0m
         WVPF9KPaXqz724Lb5+ClFnGvdfIh76ONAPtxrjgM1RLjWU6vJ4l1CB/iw/65r/2+5kno
         FLM+TDzyJHv5/+MHEhf5yMtScCgrLAifw48msFhWGYGAAB+Gc8qSmZ3iZX4+ov418Jfr
         v4/06xlOtzqgV6BxFl2jK2iRkUknru4LqVpFJJW5qDcRjMJnrQqnkcZmoSis5YvyO0Tp
         R2eSzMD9U6zwGzqmfaAGqdv4qK40P/kvfqnVllsllDpOjn2BhZVBlhXNXBN5K9qr/CRw
         sWCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685104363; x=1687696363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yAyHtJVwXJMpvnPctLliEG4edo4ZofNChat7/lTPSBg=;
        b=c5KHDDSDIoqbRmun66A9MFTDfjftN4Wgv2eJZ0kcYKXGH5/xxBKR7ghbWfxjgRzwa2
         2SE0ad14BbgA/OiKEQeg0l+SkAXpxwZ7yBnfsy7UP7Nl2p5CWk+0GDGen6DHu31lbLir
         oCjzL7BhzbTff8lwL8eXVZiI+6YTqjLSeqFN9ttDiNOC3ofb2lR4lVKoBGq5pWYJNzDW
         2Q4AHcsZtHjZyv1Nn3SxOEbWxPl3UlmDEekeobMAXHCcAzHx7DDEmLjAoRNujFe+ihDI
         TG5c3cRAJiVSL1UnoJJxBkoqv/AZQIeAMbk8rPWCKuGADc8mnT3N1XSWaeRlgRVc73Wh
         LwjQ==
X-Gm-Message-State: AC+VfDyKeNA03rgjZAHIRc691JVWR9Zfpq2Vnc+088IVTVQol4K2RJwS
	HsvQjE92a07p2gUJeHhREpqHMSWLzz04D8dd
X-Google-Smtp-Source: ACHHUZ5E9U0kRBqDi9K9EDxxtXqSdHvUiccVCmATlx74D7gTLWzeJo2sk8rbevNeQeSAJJACmwM1EQ==
X-Received: by 2002:a05:620a:27d1:b0:75b:23a0:de96 with SMTP id i17-20020a05620a27d100b0075b23a0de96mr1781563qkp.20.1685104363140;
        Fri, 26 May 2023 05:32:43 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id d13-20020a05620a166d00b007595614c17bsm1121026qko.57.2023.05.26.05.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 05:32:42 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v1 3/4] tools: ynl: Support enums in struct members in genetlink-legacy
Date: Fri, 26 May 2023 13:32:22 +0100
Message-Id: <20230526123223.35755-4-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230526123223.35755-1-donald.hunter@gmail.com>
References: <20230526123223.35755-1-donald.hunter@gmail.com>
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
index 4e0811ec5a8d..3b343d6cbbc0 100644
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
2.40.0


