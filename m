Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD656C0471
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjCSTij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjCSTia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:38:30 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76526BDCD
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 12:38:29 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v1so2441392wrv.1
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 12:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679254707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oPkE8wIr05geZ5cnisxHcZNbN3HQvV0w+URKtwTfy6g=;
        b=BD4qm3I0VHFpJvJ8tL+T0bO6RXyD5xg4cifcIEEHF1083Ibk/y1QCK7i8arT7DvHIP
         njXE/8BfAvFE3O3Rf4D0nLMp2vNZkzV7pW/Ns30CZE6jFOk5lU4Q3tjU0UEay29+GLrG
         xLKH7tggKcZq/FADIkhVvaQKc+0W2sCeHEsKuMKjk0R2hfL4fFvuTa5mp6mhbEjn8JYO
         MpxWqPllx9d1egomgLwYUHaoOY3lpbgZ4tL7Y9dBv9YNwUEZ5DPqi1iW08zIzxKnjYCk
         aOFgcSk+DtnwgnsjcvVoG5tgoz4i4vQRb5bYWUsDkepdcm/2+RPuzKwdDMaIV/zQcPPa
         bPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679254707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oPkE8wIr05geZ5cnisxHcZNbN3HQvV0w+URKtwTfy6g=;
        b=fxo29xpA/1WZW/KzLQ5Ytc+YWPoF4zoJSahp1JZKdkGv/oVe3pOmi9sPPOw/Xx1cHF
         rjhOSLz7+pmfXvRrLvUAjTGt/EXv4PhBHTAJTCzMAhdxFnl0ycF5Pb/qoWxkLMCn9DNR
         z0NWCPHJj9Qd9sMGyfiG13foJI6lLTskBj7oLZoVDLc+3syEP+auz47Th2Wxv+m+IJ4b
         WhH390vYyXKUA0FHF6z74nr3lJY8TIA4uDtro4Vzgz5XVHwsobec31wYsmQbNvaaeL6j
         ogxe8PookJzy35xGEUCeJ3/lUe1BciLf/8JbqML7AqgIvd8vi5jTk0l7v0SRB/+vmm04
         rvHQ==
X-Gm-Message-State: AO0yUKW5uZ/YCBcSohfaeRqFf0si2S+OWUwHMMRHAdffm7ddv31MtXyz
        gWvaTjUqJr+wmIXi2PYwRUYxxyjw9wC2og==
X-Google-Smtp-Source: AK7set9tFJu4aOII/oC+qsB8eyf3addFyRA5Xoe4x75yhlqSh8sC0/uEEuTkV8WCIoS+KbVA247zTA==
X-Received: by 2002:a5d:6848:0:b0:2cf:e496:93d9 with SMTP id o8-20020a5d6848000000b002cfe49693d9mr11393421wrw.52.1679254707454;
        Sun, 19 Mar 2023 12:38:27 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id d5-20020adfef85000000b002cfed482e9asm7204190wro.61.2023.03.19.12.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:38:26 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v2 3/6] tools: ynl: Add array-nest attr decoding to ynl
Date:   Sun, 19 Mar 2023 19:38:00 +0000
Message-Id: <20230319193803.97453-4-donald.hunter@gmail.com>
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

Add support for decoding nested arrays of scalars in netlink messages.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 tools/net/ynl/lib/ynl.py | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 32536e1f9064..077ba9e8dc98 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -93,6 +93,10 @@ class NlAttr:
     def as_bin(self):
         return self.raw
 
+    def as_array(self, type):
+        format, _ = self.type_formats[type]
+        return list({ x[0] for x in struct.iter_unpack(format, self.raw) })
+
     def __repr__(self):
         return f"[type:{self.type} len:{self._len}] {self.raw}"
 
@@ -381,6 +385,8 @@ class YnlFamily(SpecFamily):
                 decoded = attr.as_bin()
             elif attr_spec["type"] == 'flag':
                 decoded = True
+            elif attr_spec["type"] == 'array-nest':
+                decoded = attr.as_array(attr_spec["sub-type"])
             else:
                 raise Exception(f'Unknown {attr.type} {attr_spec["name"]} {attr_spec["type"]}')
 
-- 
2.39.0

