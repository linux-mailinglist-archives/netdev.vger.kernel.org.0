Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7916C9E10
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233072AbjC0IiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbjC0Iha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:37:30 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D05A24B;
        Mon, 27 Mar 2023 01:32:03 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id l27so7783434wrb.2;
        Mon, 27 Mar 2023 01:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679905922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=71KoEvNw1a5K58EQ9MffE/8r5VSXHU8fzu2wgupbboU=;
        b=J4RsoRpBnwN1MqbboCHaHWoIINzGdRVo7e+jhZ+2JH7+YVu8z/mUJO5beVgJZmmx5y
         O3EArjWy5A7cubyHbMv5vYaMLQs67VBGcKnT8jJGrdSAhENwCQzvndRIWkFt0ZT4wQN0
         PV48JFRZiYwKl+OYU68DnCUyphLMngKVp6Afu6U+aykBAOd5y2OMThul+JrmmpyD79yL
         +WuGb1YBKG5Se3RtW6vLB4kkMl7YUr4OdflJFaDr8fCtoqJNyB5ZfKXEnLJMgbBWSe2d
         sy2/MFmGJzYZcvRxdO2AmQzwX44/pcTirBe4a6iGMIlAPW9QqOcf943M97m/xEZGE1G1
         7G8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679905922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=71KoEvNw1a5K58EQ9MffE/8r5VSXHU8fzu2wgupbboU=;
        b=xnd2FCzGrZDNNsIDK8gXlOZIAjGOIdDV+bVn7BTG2FPgpmT9GxzXU1eugNCFk8wfoN
         ilILH1HvMRXSgtByUimzh4z1X9zKtZSbjv+bsfce0Y7V4hymIt6AekkTvyItwuzrSFa7
         DKpbuHARzPExta4ZBAbXOSHYYY/idbt6HGiP3acRRVL9e7wVwOVz5m+4/haFAzsCfO0z
         jEE5PSFtUdHgYd0yRiKgCEInDusXih6yban3Xwv9qhCvNcAiZ/RrkCoWHv5zbGl4H5i3
         P4rOaIXX/uDV0rWILRmZCGB6TWDoJcYOiIkQHs+Jf/W2yOSQfq+xmBgs/Sz+Syw97Zpz
         Sf5g==
X-Gm-Message-State: AAQBX9eE+zP91xlG/qk0YXt1Wz2eMW5E05PqekHCx/sXJDWHYebD20QP
        us0qLOfYDjo5oxUSzgcdwotLtCmwJPmyLg==
X-Google-Smtp-Source: AKy350aM6lYL21FU3RM1r+IrDmd1X4g5iCKGkf8lGXaX/M48js6Bgm8kyAD4RinWQiSktmBRSQh2vA==
X-Received: by 2002:a5d:5343:0:b0:2ce:ada5:325d with SMTP id t3-20020a5d5343000000b002ceada5325dmr9156319wrv.37.1679905921856;
        Mon, 27 Mar 2023 01:32:01 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:7887:5530:69a2:a11f])
        by smtp.gmail.com with ESMTPSA id z6-20020a056000110600b002c557f82e27sm24353249wrw.99.2023.03.27.01.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 01:32:01 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v5 6/7] docs: netlink: document struct support for genetlink-legacy
Date:   Mon, 27 Mar 2023 09:31:37 +0100
Message-Id: <20230327083138.96044-7-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230327083138.96044-1-donald.hunter@gmail.com>
References: <20230327083138.96044-1-donald.hunter@gmail.com>
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
 .../netlink/genetlink-legacy.rst              | 74 ++++++++++++++++++-
 1 file changed, 71 insertions(+), 3 deletions(-)

diff --git a/Documentation/userspace-api/netlink/genetlink-legacy.rst b/Documentation/userspace-api/netlink/genetlink-legacy.rst
index 3bf0bcdf21d8..b8fdcf7f6615 100644
--- a/Documentation/userspace-api/netlink/genetlink-legacy.rst
+++ b/Documentation/userspace-api/netlink/genetlink-legacy.rst
@@ -162,9 +162,77 @@ Other quirks (todo)
 Structures
 ----------
 
-Legacy families can define C structures both to be used as the contents
-of an attribute and as a fixed message header. The plan is to define
-the structs in ``definitions`` and link the appropriate attrs.
+Legacy families can define C structures both to be used as the contents of
+an attribute and as a fixed message header. Structures are defined in
+``definitions``  and referenced in operations or attributes. Note that
+structures defined in YAML are implicitly packed according to C
+conventions. For example, the following struct is 4 bytes, not 6 bytes:
+
+.. code-block:: c
+
+  struct {
+          u8 a;
+          u16 b;
+          u8 c;
+  }
+
+Any padding must be explicitly added and C-like languages should infer the
+need for explicit padding from whether the members are naturally aligned.
+
+Here is the struct definition from above, declared in YAML:
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
+          type: u8
+        -
+          name: b
+          type: u16
+        -
+          name: c
+          type: u8
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

