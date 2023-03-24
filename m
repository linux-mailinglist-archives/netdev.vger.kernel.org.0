Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440076C7D59
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 12:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbjCXLin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 07:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbjCXLij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 07:38:39 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1191F1DB88;
        Fri, 24 Mar 2023 04:38:33 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id e18so1471065wra.9;
        Fri, 24 Mar 2023 04:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679657911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LCkEokrsCzjIkMKxFdvX1hlK9J/wGQW+qxp7NgekMCc=;
        b=O5N+yaWDPZJ/teIwRzgmImfUqBlW/UYf3DzpmpmzyqND/4lLN8sX1FOJf7Qe8JXICK
         FctjckiNWkqXZrhwtv1eS2zBk4BD/P/B/GG0kJWQvOiofIP69tVrKnmtD6oVgZHdZSn6
         cj+mq/lFci7FBTAU5sA/8cxWf7UPBhuk+Vk2doTNPFi7526kHx4aOeOqARINfk+JIkr1
         YgfXYFR6fshKeaYAeH2JKFtglX8RXzqUvj6aZRAJU/2cIUw73FN6ylsVUWek7BcIzwsN
         lsvneZJPpl28hXkLQDQyPc3yAqgYJWeKN+7bLfcdBNRQLRDrxqejPV7QLnZCx2m0wTeW
         YEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679657911;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LCkEokrsCzjIkMKxFdvX1hlK9J/wGQW+qxp7NgekMCc=;
        b=lQW0iQayGDECautxh6iTPoAUGTPECtntruOEL1/NjzHDW9OIQL+YHT+xkeuHbhhguw
         ghLddm4Uy6mLgByfVXWsDdiYFTgfKDVr9n0P4GrB83ZYGNT4dUPdw5GID+BIPJpA0VfM
         gCaAMbXYXzG4JmYncaZk9AjlV+YmqfhDQEZVLHKnVRv8fqJLJlBjihuhpRJIA3PzCsRK
         rWk5Fixb6nts12qdkzQno9qLvJfwgN5TnftEew1kUwPzn7+1ATcXoBF6HjnIFweDI/1g
         J6Oa9d2QfF+pD9o1SAYVVv1oBko2w8RlhQahWIi8/6U1Fm1y3VWEF6vKmhn2T94ZT5T6
         MjyA==
X-Gm-Message-State: AAQBX9d31wTdfvMzFYh1r/xQy0/KU6gvDa60JYuCQ46eIFrvnlT53Pv2
        qXJz2NacuNOLni3BzI95Zcf4RKw7oI+x3w==
X-Google-Smtp-Source: AKy350aLL4oUxZocKs58TZu0oNwOYK/HJjw3NvU7ScUBc8b74WcMwn4n0cn9JVZHIfEgcMPhma8VpA==
X-Received: by 2002:adf:ffc9:0:b0:2d3:b49c:23d5 with SMTP id x9-20020adfffc9000000b002d3b49c23d5mr1783302wrs.29.1679657911031;
        Fri, 24 Mar 2023 04:38:31 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:cd72:bbb4:8d1:483a])
        by smtp.gmail.com with ESMTPSA id t6-20020adff606000000b002d828a9f9ddsm10150954wrp.115.2023.03.24.04.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 04:38:30 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v3 6/7] docs: netlink: document struct support for genetlink-legacy
Date:   Fri, 24 Mar 2023 11:37:33 +0000
Message-Id: <20230324113734.1473-7-donald.hunter@gmail.com>
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

