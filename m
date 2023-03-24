Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8466C85BD
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjCXTTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjCXTTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:19:33 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF987DB4;
        Fri, 24 Mar 2023 12:19:30 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id t13so2353119qvn.2;
        Fri, 24 Mar 2023 12:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679685569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LCkEokrsCzjIkMKxFdvX1hlK9J/wGQW+qxp7NgekMCc=;
        b=IdjRrV4huFStxRZVcAWPiu9Pb83m8hqa7lzJr3mNNmIi+I1aNSdpUIJFYE5Jt5f/nC
         5VjcT7jJWlkw5MhmwuQl3jTQJ2vYFEFRMuK5s+ll2sY0YYLc8nVEoiGPgZ2ZVGTkmUGC
         8EWyWBP9fWitUrODpIWTrx9ML1JVBHO05UtRJwbJaLd2QdFzHNg1JYgZLT8DL6TiXeZ5
         Q3JFAsxtzYytsYN1ob/zsH7lo2AuFVo0Kb36ePKEB2WDItXwsDlnwVCkK0DeKPgJwQuY
         F2qXFa7PnSk94XcAVhnPItkVa9Rem2SlzG3Z7JnDniS5RDBOoJJogRXN713I4tbW+nl3
         ikZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679685569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LCkEokrsCzjIkMKxFdvX1hlK9J/wGQW+qxp7NgekMCc=;
        b=rBHhvQAXcfrO90P+p6zdc2kSeifyVi1dpzWiTTFAAQh/X36ylM6qeEPFF61bwubkP6
         Me9GREnsskwL/BP0bK2iBOhvU2S3Kvh4+N6ckUA9v16BTdrQjXGKEg8zknPssIxkabe3
         syBnzvyGVzIfqa4c14c+RZ/xLGfK3YwtLhtaOZBf1OphfPKRQbey0JTpJ889t825WwJ8
         EUETAWlUQUt/4dhFSedsIFOkzX7Jdbx98jtTo9TUvQJN0Uo8PJPfl8Qefpud34xwstoa
         Au6pvdHnhxsoPTQvO4SJh3r/IYAFHMFiEmIS2UR21FtIJ6ze235PLo+03V5zoJZYA0f3
         HaHg==
X-Gm-Message-State: AAQBX9ezxMNbUN0QEvqHOd6IlvEsiVcUkukE0d5vYm+WCKR55Bfs3F57
        s7CDkuZo6p6aejLLfPL8iBHDqIeQPm4cCQ==
X-Google-Smtp-Source: AKy350bjit81gVwWsxutHwcNnU2eP7zuLFpGQcRHmxKDZFZuV/LhRCIjPgwdYKMt5fFhL/JlEzSV/w==
X-Received: by 2002:a05:6214:29e2:b0:5d8:ed66:3098 with SMTP id jv2-20020a05621429e200b005d8ed663098mr5676510qvb.42.1679685569087;
        Fri, 24 Mar 2023 12:19:29 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id cn5-20020ad44a65000000b005dd8b9345e1sm900141qvb.121.2023.03.24.12.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 12:19:28 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v4 6/7] docs: netlink: document struct support for genetlink-legacy
Date:   Fri, 24 Mar 2023 19:18:59 +0000
Message-Id: <20230324191900.21828-7-donald.hunter@gmail.com>
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

Describe the genetlink-legacy support for using struct definitions
for fixed headers and for binary attributes.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 .../netlink/genetlink-legacy.rst              | 54 ++++++++++++++++++-
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/Documentation/userspace-api/netlink/genetlink-legacy.rst b/Documentation/userspace-api/netlink/genetlink-legacy.rst
index 3bf0bcdf21d8..6b385a9e6d0b 100644
--- a/Documentation/userspace-api/netlink/genetlink-legacy.rst
+++ b/Documentation/userspace-api/netlink/genetlink-legacy.rst
@@ -163,8 +163,58 @@ Structures
 ----------
 
 Legacy families can define C structures both to be used as the contents
-of an attribute and as a fixed message header. The plan is to define
-the structs in ``definitions`` and link the appropriate attrs.
+of an attribute and as a fixed message header. Structs are defined
+in ``definitions`` and referenced in operations or attributes.
+
+.. code-block:: yaml
+
+  definitions:
+    -
+      name: message-header
+      type: struct
+      members:
+        -
+          name: a
+          type: u32
+        -
+          name: b
+          type: string
+
+Fixed Headers
+~~~~~~~~~~~~~
+
+Fixed message headers can be added to operations using ``fixed-header``.
+The default ``fixed-header`` can be set in ``operations`` and it can be set
+or overridden for each operation.
+
+.. code-block:: yaml
+
+  operations:
+    fixed-header: message-header
+    list:
+      -
+        name: get
+        fixed-header: custom-header
+        attribute-set: message-attrs
+
+Attributes
+~~~~~~~~~~
+
+A ``binary`` attribute can be interpreted as a C structure using a
+``struct`` property with the name of the structure definition. The
+``struct`` property implies ``sub-type: struct`` so it is not necessary to
+specify a sub-type.
+
+.. code-block:: yaml
+
+  attribute-sets:
+    -
+      name: stats-attrs
+      attributes:
+        -
+          name: stats
+          type: binary
+          struct: vport-stats
 
 Multi-message DO
 ----------------
-- 
2.39.0

