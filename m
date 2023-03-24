Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29FD06C85C1
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbjCXTTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjCXTTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:19:37 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15808469B;
        Fri, 24 Mar 2023 12:19:32 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id cu4so2341289qvb.3;
        Fri, 24 Mar 2023 12:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679685571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lIMBsyNwngYJxJCZuFxAXyNmrXqE9/jxWeXYfc5T+pA=;
        b=o/fCI8eCvJdWx6N61FxJQjh6ePqXk/lipAykGvNhEQD7vn8DnHKMB6rVMZhgrLjrPT
         NNRzBkLM0EWWZfz2DClbcVsr3E21OHiH4Sum/PP7Zgbv8XvNXLj4pEsO6/f1f0XxShqF
         GHgvR7xGHJOM6PCCWyDC1+oXKDBCuIujFTI4wmMKfTaBQs03uyOfdGOv4K482DxE5ZfF
         2QQVBLSR8VW2Dl5j3NmYzGhASjrNyJYza62/zQszPxTOvszX63PcpenQ2kx5APMTcZwW
         VQs7IRrCovydbX+yhR4pIKRbSovJjDPiW5OBmc4Qj5FAcll5FWphpgb6mcYclJC8vqLa
         BKSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679685571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lIMBsyNwngYJxJCZuFxAXyNmrXqE9/jxWeXYfc5T+pA=;
        b=AYRlV1X2hwCOPRe6SoTlPjveTv9aJNu4XdiG7N1SgSfD94MfUPr1SONE0ZaqaeHYAo
         619ox+dJk6lJxqlrrL+joAWBwGpMFZ6k3WLaGLRRV2+TmDuIVcWL4MW8j9apEcb7fIUS
         DwTWToTUli6MY3CxFpDLcXWLmrv7i5M5DCCoHZagkHqEIL8OJzS+b9qqxefYfZ8TcGMg
         Oqf8+h0m/HAnPPW7L3+rPGdUY5GV0Idu/QhPGYl4jrr3OpI7Roe/ep0JYxCiYmedDJQT
         P8+kQNgjO3FOBx9zDFzLfjoWmUK2Pf/i1eeWaMBrGJP1/s9P8w22PTXNpCtnrJ6lKmZ6
         I8KA==
X-Gm-Message-State: AAQBX9eodTCySYEVjXmiGB4XRKr/VvHBFgXlPEDcUXY8zrH6DY90O6vV
        704o0r3mQL3L0JUO3Siu9ztEpR/BLfUxIA==
X-Google-Smtp-Source: AKy350agtxz524VV6sAsirgR2yGtrM/IlrRCFHyPR9Tne7xD8XWCTIyI/caAvhgeIAg34y5/Y0ye+g==
X-Received: by 2002:a05:6214:d05:b0:56e:9c11:651e with SMTP id 5-20020a0562140d0500b0056e9c11651emr6501444qvh.27.1679685570861;
        Fri, 24 Mar 2023 12:19:30 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id cn5-20020ad44a65000000b005dd8b9345e1sm900141qvb.121.2023.03.24.12.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 12:19:30 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v4 7/7] docs: netlink: document the sub-type attribute property
Date:   Fri, 24 Mar 2023 19:19:00 +0000
Message-Id: <20230324191900.21828-8-donald.hunter@gmail.com>
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

