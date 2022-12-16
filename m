Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204A564E8D5
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 10:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiLPJs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 04:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiLPJs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 04:48:56 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2B945EE1;
        Fri, 16 Dec 2022 01:48:50 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so5525928pjj.2;
        Fri, 16 Dec 2022 01:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pWK2GC8WOqDUc4ujFDuW5xeRVN4Nn4R6EQKNL2+edWE=;
        b=iREzM/4nbb68b2JckamDLPmAtCye7/XLgw/CMHB39DzTd0LTDH87ULaCvD0BGVi0Qt
         WaPXGi0Ty65bYMMD6tlvXFaOKkQsL8s5VrFyiguCsON1lARNhoIYE52rIiM/iYAo5fgd
         olB0RHU5fKgIN/zzdH4t4Yuh/S7UEonNu/8FAtXHY7X3dCB869j/WhkktLArznH47peM
         SCpdJz9R0ynXGiL9rM5ql1TLAjn6A1sGPau91onq7qnzX74UzQy7f7nNumK8AJUPxptH
         HzKbklcTbNQYca7NbaTIHbDMO5y+8YnU9ruJySn/B3/xapD6XnZ1XG+ZmsykFkGC3BcJ
         IfiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pWK2GC8WOqDUc4ujFDuW5xeRVN4Nn4R6EQKNL2+edWE=;
        b=YZD0SA7TzITL9kKn09ygkqsm6aEgrUC2+tvwV4BiChco9yT6JfRZm5r7UTtxmCj9Mm
         QlBJDxNI9IXB2fwZ21K5nThOwOPZw6DY9INnVSR6AT0LhbfAfwR6vyhVqOgbM8GTxFUp
         a8/43uYfTmt9zzs+WGrZnGxgfvnGQx0M5iFheDS0yzUDO11X26gHf1h9JhrE83519IIn
         /soeLXFb+wp2Azd8NISEI7tMHnUAukdew+ya6qZUMUOiN7MXk79JK11IDFG0NUdwjrNt
         wB6w+b0bgvHzSucKjMdnNWlGe0R8BzcX1Oo1eNAr+B/pbC8/MAMQpk1sDxWJ0SNcqsN1
         rbIA==
X-Gm-Message-State: AFqh2kpI/JJzOkVphURkH2IfJ/r+2DMeh4mzv1d0WdjS7O/EkFVXJegj
        yMfkrFTI/kIZJFmEbuI+7vOlbW1M0i/STwIL
X-Google-Smtp-Source: AMrXdXugmLPxcnAFk6TwxkqVZAsVfz/EkBbk4ioy3eR8ezJf0LC8xlJZt718Wmz6dsnXsyNmTvzTPA==
X-Received: by 2002:a17:902:e5cb:b0:190:e63a:ea91 with SMTP id u11-20020a170902e5cb00b00190e63aea91mr15808109plf.0.1671184129976;
        Fri, 16 Dec 2022 01:48:49 -0800 (PST)
Received: from localhost.localdomain ([202.120.234.246])
        by smtp.googlemail.com with ESMTPSA id s11-20020a170902ea0b00b00178143a728esm1141246plg.275.2022.12.16.01.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 01:48:49 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH v2] net: Fix documentation for unregister_netdevice_notifier_net
Date:   Fri, 16 Dec 2022 13:48:35 +0400
Message-Id: <20221216094838.683379-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

unregister_netdevice_notifier_net() is used for unregister a notifier
registered by register_netdevice_notifier_net(). Also s/into/from/.

Fixes: a30c7b429f2d ("net: introduce per-netns netdevice notifiers")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
changes in v2:
- s/into/from/ as pointed out by Petr Machata.
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b76fb37b381e..cf78f35bc0b9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1840,7 +1840,7 @@ EXPORT_SYMBOL(register_netdevice_notifier_net);
  * @nb: notifier
  *
  * Unregister a notifier previously registered by
- * register_netdevice_notifier(). The notifier is unlinked into the
+ * register_netdevice_notifier_net(). The notifier is unlinked from the
  * kernel structures and may then be reused. A negative errno code
  * is returned on a failure.
  *
-- 
2.25.1

