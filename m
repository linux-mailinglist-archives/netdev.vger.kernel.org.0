Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16D7520C7B
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiEJEBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 00:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235308AbiEJEBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 00:01:46 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5D42A9CD8
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 20:57:49 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id fv2so14812852pjb.4
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 20:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TMfX5GLFh57pG2QX7283Ze9GK6r5LOYCLbe0PSu2BLw=;
        b=HcmAKU85ARqCeDN0Qul1H3gJrtJhxNA6un3sKMdyuqXt6P8D3yeBC6xXfOM8c22DCu
         qDPQbR6bLLUwzk3meg6bzlmN8xvShrA7gMvYLxxnam9KusoE+6CgqwMZIC2Z6k9RGg7A
         Wt77YqzT8IyzNjfKeXMpJ0G5/TP/wJmo6HHy0iOo9jFyc2+Dfsiv8zBkNAOQknyIMvJH
         5ZrHEFf6ew7g8elsCGJ/MZaMZ5wDrYFsWgkhbDNVgLOyrfNREN+IXc/7F2QjBDcKyEPv
         U0jka2Qt8VZTPczI/4U9Szde6Ur2jGzXLnwTGohZVJIkzWhvDJJqmVA4L2FkT4ut6YWo
         2Fog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TMfX5GLFh57pG2QX7283Ze9GK6r5LOYCLbe0PSu2BLw=;
        b=6NPe5cQS15/Ky9lut6uoQMdUXtV5MWX1NnsJa/yvGfz5wVQNIJ8lo6BNxgPJqgdWsC
         ILFlzheHOeZJ7Hnt3tHNO5Z65WwZ5zUCI/X/iM7O0YqOiXwzDVbm3do+4gaBMJaYQFUJ
         GdBywe0Jl3kfRqqbCYHXfDlQ0oYiyBAcbuB51etvt9rwPwlyi/2IkPJoEpHXTkIkpnNn
         AV+GpHJaKSnDX5nXv0WLiOK6TaFoo0CUTeytikaKXy0eY5zCXOOIsFNWwCuoc5KotonG
         movIAsWJEOVaBdcMp1hN+Ltxde02pTLvf/SgfiF3Ikl2p4Q+GQqTp6rNu3j6cEZMYEfB
         0EpA==
X-Gm-Message-State: AOAM533pCmsbuGV9yri8Q6IFSbbrsxGcsbmqEBDEj8u6n13/EkQqluZD
        RJNbPmcdYhEoAlUxQh4nIaFv7CysoKM=
X-Google-Smtp-Source: ABdhPJyJiHY+va3NJMm30jASkVrolPiBPj4rE7ytgkBjAVfcPmZDkDb5LV9BuiEyQskkaHhwXwvgJg==
X-Received: by 2002:a17:903:32c9:b0:15e:a1b8:c1ef with SMTP id i9-20020a17090332c900b0015ea1b8c1efmr19148178plr.173.1652155069147;
        Mon, 09 May 2022 20:57:49 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id d12-20020a17090ad3cc00b001d81a30c437sm568193pjw.50.2022.05.09.20.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 20:57:48 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 2/5] net: add CONFIG_DEBUG_NET
Date:   Mon,  9 May 2022 20:57:38 -0700
Message-Id: <20220510035741.2807829-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220510035741.2807829-1-eric.dumazet@gmail.com>
References: <20220510035741.2807829-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This config option enables network debugging checks.

This patch adds DEBUG_NET_WARN_ON_ONCE(cond)
Note that this is not a replacement for WARN_ON_ONCE(cond)
as (cond) is not evaluated if CONFIG_DEBUG_NET is not set.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/net_debug.h | 6 ++++++
 net/Kconfig.debug       | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/net_debug.h b/include/net/net_debug.h
index 19cd2700c20ea9945ae7662bacfa50f5d2bed398..1e74684cbbdbcd5ba304b935e76376a72d6ba3f2 100644
--- a/include/net/net_debug.h
+++ b/include/net/net_debug.h
@@ -148,4 +148,10 @@ do {								\
 #endif
 
 
+#if defined(CONFIG_DEBUG_NET)
+#define DEBUG_NET_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)
+#else
+#define DEBUG_NET_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
+#endif
+
 #endif	/* _LINUX_NET_DEBUG_H */
diff --git a/net/Kconfig.debug b/net/Kconfig.debug
index 2f50611df858911cf5190a361e4e9316e543ed3a..a5781cf63b16b32e5360df1ca26a753b6505d81f 100644
--- a/net/Kconfig.debug
+++ b/net/Kconfig.debug
@@ -17,3 +17,10 @@ config NET_NS_REFCNT_TRACKER
 	help
 	  Enable debugging feature to track netns references.
 	  This adds memory and cpu costs.
+
+config DEBUG_NET
+	bool "Add generic networking debug"
+	depends on DEBUG_KERNEL
+	help
+	  Enable extra sanity checks in networking.
+	  This is mostly used by fuzzers, but is safe to select.
-- 
2.36.0.512.ge40c2bad7a-goog

