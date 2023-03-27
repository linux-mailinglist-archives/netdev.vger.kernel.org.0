Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0922D6C9E13
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbjC0IiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbjC0Ihc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:37:32 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501C25279;
        Mon, 27 Mar 2023 01:32:05 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id l12so7748766wrm.10;
        Mon, 27 Mar 2023 01:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679905923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W3Pnhk6WXCTvMYshsQQxsvUwuf8HT7xMnse1nDPGhPo=;
        b=qacayhcU8j7TjHpxJKF4fFiwSBWH52U1tTZBx/KPUwncWUUqrrFGQMkFuA5Hk3Uqm7
         mFfUzbbEetwcvaFCOeY+7jfynuUBn6PdLE0mny2ODwdpJgLy66XIydwt53hiHmGXec+J
         jZm7gYy5OYlTyfndam8Pg8p9DVVeLoGdqXI7SXVNcgzjLU5xoNaJ2t+5nXqflkhWDjbl
         GokbCOO2dpT8bxo7rQCszJftp4KCqULc1DffKMpOveo6BDWg7NVGu1Z8eVZZDhgBxjAh
         KESM+RlJjyiCNwm+LM8e5rU5T/os4lTPWHnFuFnok3MByxnFZZUUJ3rKAraZLCU40mqj
         ECNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679905923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W3Pnhk6WXCTvMYshsQQxsvUwuf8HT7xMnse1nDPGhPo=;
        b=zvnM8730el/i3J2SovR2EXlxhtRHPfyrGZOpohdHThzIEQWMe8I1AsWpjhIh/Ux9j9
         N4qb4Uj4LDpTfTmmqQWOV6EuRu8Sbb7YXDXv6T8oXW3KSW4xyTUcKveETnqsD+ow2MSu
         wDOo+sWFNxAqRiEbby3KOv9KF0kRt4vHSktdsOYl7+whcdzXmQtsNY+nQmXEcRfo+4xg
         heP2rzob7y2EzbR2JO+ovdLj2Q7NoIyPeCBpEJihN+xg5inksJEz+SkVo5tdSAdUur/n
         8B9/hFsOMRj3MHTefkLIAjNiM0CN7wXdQD2FMnW3H+X+pAA2MY6zeZahHaDyiR4HLVvS
         Zg/w==
X-Gm-Message-State: AAQBX9eFAPOAjp3qJNUkrRwjqT7tDF3ODub61mGTJZwWW2DlncmFdQYK
        79GiFiwS5kO+JcVAZd8NcVAURJdWqMK4Cg==
X-Google-Smtp-Source: AKy350ZHmJPagplwUBfqVwiTe6cpM9txTphF28audlh2ksHNQLFtkVRLoXCntUyVg96Tigwx4+FMAw==
X-Received: by 2002:adf:ef83:0:b0:2d4:b9fc:90c1 with SMTP id d3-20020adfef83000000b002d4b9fc90c1mr9282039wro.42.1679905923043;
        Mon, 27 Mar 2023 01:32:03 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:7887:5530:69a2:a11f])
        by smtp.gmail.com with ESMTPSA id z6-20020a056000110600b002c557f82e27sm24353249wrw.99.2023.03.27.01.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 01:32:02 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     donald.hunter@redhat.com, Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH net-next v5 7/7] docs: netlink: document the sub-type attribute property
Date:   Mon, 27 Mar 2023 09:31:38 +0100
Message-Id: <20230327083138.96044-8-donald.hunter@gmail.com>
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

Add a definition for sub-type to the protocol spec doc and a description of
its usage for C arrays in genetlink-legacy.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 .../userspace-api/netlink/genetlink-legacy.rst     | 14 ++++++++++++++
 Documentation/userspace-api/netlink/specs.rst      | 10 ++++++++++
 2 files changed, 24 insertions(+)

diff --git a/Documentation/userspace-api/netlink/genetlink-legacy.rst b/Documentation/userspace-api/netlink/genetlink-legacy.rst
index b8fdcf7f6615..802875a37a27 100644
--- a/Documentation/userspace-api/netlink/genetlink-legacy.rst
+++ b/Documentation/userspace-api/netlink/genetlink-legacy.rst
@@ -234,6 +234,20 @@ specify a sub-type.
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
index a22442ba1d30..2e4acde890b7 100644
--- a/Documentation/userspace-api/netlink/specs.rst
+++ b/Documentation/userspace-api/netlink/specs.rst
@@ -254,6 +254,16 @@ rather than depend on what is specified in the spec file.
 The validation policy in the kernel is formed by combining the type
 definition (``type`` and ``nested-attributes``) and the ``checks``.
 
+sub-type
+~~~~~~~~
+
+Legacy families have special ways of expressing arrays. ``sub-type`` can be
+used to define the type of array members in case array members are not
+fully defined as attributes (in a bona fide attribute space). For instance
+a C array of u32 values can be specified with ``type: binary`` and
+``sub-type: u32``. Binary types and legacy array formats are described in
+more detail in :doc:`genetlink-legacy`.
+
 operations
 ----------
 
-- 
2.39.0

