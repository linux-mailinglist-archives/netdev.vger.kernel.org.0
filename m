Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25576C7D58
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 12:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbjCXLiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 07:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbjCXLij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 07:38:39 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B571E5C1;
        Fri, 24 Mar 2023 04:38:34 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id p34so968703wms.3;
        Fri, 24 Mar 2023 04:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679657912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lIMBsyNwngYJxJCZuFxAXyNmrXqE9/jxWeXYfc5T+pA=;
        b=RKnSMcBaLdEWl7IWKSkMboMI7waawAjExOiht+HZkb5Tj9TuhS5LNmaTdIEBGT2mYF
         gkxJ0Y7u1JUzPhJWlFFH6WolZg5e46dmHAji/ToyCceygPbLC7wIRQM445fd0mOmlSvm
         K2m3CB/4caUz1ouVn7MiKqo0qUtFvoDk8IhLai+iLo8u7i3IVRVmnuNwvB/4VjXnGRiK
         wzgnwL/+yNFVA2H1xuIZuDO2WSMBsz9OF149JeX92YdY9iZCMZ6FLS8lx4TGNJxQPcQE
         0k/nnBI603ubwYcZqqHXWIQgv/Vii+XSGzY4ccH8eHKrdDaSwBKGGonU/20FRWFv63y6
         CkbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679657912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lIMBsyNwngYJxJCZuFxAXyNmrXqE9/jxWeXYfc5T+pA=;
        b=fefALNbIoon8p2aEF1KncqsVvaVrKb1y+YeBN7BV6XWhLhsdbrBbsr0o8RJKMQ9o7D
         gOWYy4e6lu/FzZkcoIuvOLWrUjP+G91+hCLfJAM3HntpDnshufKs3YW02jdbuQr+eJP1
         y/rVf7xUG0R6dA82wC5IFbMIwvhB0r2GtCYugOHTBWg//tSePeZ9iZVAFGzm670hVAzM
         3FCo9oXcVxY6YLS7LDJ9VHpPJgzCKaUyX9A18YOnlji02dUsXLFXgm51nSfsXlpc9Dwr
         C2ASwOeHWWT4qJ0lPE+ZQEGp1KRkuJDXPrNWM+wERlH6DN/kSwrQwOGLm69ioCqQgJYA
         wTZw==
X-Gm-Message-State: AO0yUKWfB3aNRW3eyD1WIlx5woHJ43jsCKRDWyr343rK3/VmVlaJ6NLt
        YC2PY3TCtnU2AGfVnz1in47QMUPcmcBhgg==
X-Google-Smtp-Source: AK7set/+Rk5azK5TjcPok3nXqckyj55OghOyXrBUSn94BGFncUB56B3KRodyVm1+TgvDxW3n5K6fKg==
X-Received: by 2002:a7b:c398:0:b0:3ed:da87:3349 with SMTP id s24-20020a7bc398000000b003edda873349mr2119748wmj.1.1679657912712;
        Fri, 24 Mar 2023 04:38:32 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:cd72:bbb4:8d1:483a])
        by smtp.gmail.com with ESMTPSA id t6-20020adff606000000b002d828a9f9ddsm10150954wrp.115.2023.03.24.04.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 04:38:32 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v3 7/7] docs: netlink: document the sub-type attribute property
Date:   Fri, 24 Mar 2023 11:37:34 +0000
Message-Id: <20230324113734.1473-8-donald.hunter@gmail.com>
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

Add a definition for sub-type to the protocol spec doc and a description of
its usage for C arrays in genetlink-legacy.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 .../userspace-api/netlink/genetlink-legacy.rst     | 14 ++++++++++++++
 Documentation/userspace-api/netlink/specs.rst      |  9 +++++++++
 2 files changed, 23 insertions(+)

diff --git a/Documentation/userspace-api/netlink/genetlink-legacy.rst b/Documentation/userspace-api/netlink/genetlink-legacy.rst
index 6b385a9e6d0b..afd9c4947a1c 100644
--- a/Documentation/userspace-api/netlink/genetlink-legacy.rst
+++ b/Documentation/userspace-api/netlink/genetlink-legacy.rst
@@ -216,6 +216,20 @@ specify a sub-type.
           type: binary
           struct: vport-stats
 
+C Arrays
+--------
+
+Legacy families also use ``binary`` attributes to encapsulate C arrays. The
+``sub-type`` is used to identify the type of scalar to extract.
+
+.. code-block:: yaml
+
+  attributes:
+    -
+      name: ports
+      type: binary
+      sub-type: u32
+
 Multi-message DO
 ----------------
 
diff --git a/Documentation/userspace-api/netlink/specs.rst b/Documentation/userspace-api/netlink/specs.rst
index a22442ba1d30..7931322d3238 100644
--- a/Documentation/userspace-api/netlink/specs.rst
+++ b/Documentation/userspace-api/netlink/specs.rst
@@ -254,6 +254,15 @@ rather than depend on what is specified in the spec file.
 The validation policy in the kernel is formed by combining the type
 definition (``type`` and ``nested-attributes``) and the ``checks``.
 
+sub-type
+~~~~~~~~
+
+Attributes can have a ``sub-type`` that is interpreted in a ``type``
+specific way. For example, an attribute with ``type: binary`` can have
+``sub-type: u32`` which says to interpret the binary blob as an array of
+``u32``. Binary types are described in more detail in
+:doc:`genetlink-legacy`.
+
 operations
 ----------
 
-- 
2.39.0

