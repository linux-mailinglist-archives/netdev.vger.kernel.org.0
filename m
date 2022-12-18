Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B2264FEF2
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 14:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiLRNKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 08:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiLRNKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 08:10:10 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEB0614A;
        Sun, 18 Dec 2022 05:10:08 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id b12so4562989pgj.6;
        Sun, 18 Dec 2022 05:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DsnD2zHO0XxXzNS2OYj+d4VGf5i5WG75eUX+c8ORAqo=;
        b=qAQdiFwQwEzL+SzojUPljCxZrH4BH62djkub82mcn2fWRHX8zLY9jfEPl0jmDzHAoi
         gAbnXtmxip9moOXI0qH6IrNTS54bVfLDt3ms4oPaDL33UzXnQ16Uw/CR4Nb8PfMunQn3
         R4UtS4C6B5qiET3GpvTQHJMaaBDt7OfWeXbizV9+O9KPkdj1eXkelzZ3xT8P7aIOq0l5
         bUzLV1vvZYJ/62/EkGLqvOhNF8XYBaKcDJBkovLgIA+6/IIrvlai7IXTDAeAtF6ahc95
         nVT3YwdsF9CKBPdS9hB3npDAat0lpBz+olxE4vuSZdiEeIxPR4JKu1AcouLvq4QTvqed
         1jhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DsnD2zHO0XxXzNS2OYj+d4VGf5i5WG75eUX+c8ORAqo=;
        b=MAiksnQKULOKL/Ca0NTF8JWnP68aggDYyrgZIuyBtsVHAZeawRLkE3nqq34K8JvgYO
         rrGzLZ1hjzA2vGFyrIX3a2hT/yO1EiDx3flRhqeLACHw0MAcu4BZbaW7WtSfi5M1E6z4
         aVM4UFDcrna7Dbve60k5uauslWKE88dLKAvvZIkfVdMv1zxV4ulqiBVfXx6xbhEuMruw
         iQ0nfPHlAXjcKlJ1Mf8wxebtMpmmiqkZJ2GkKKj9e5RF24fa43DOaCND4PPXOAa6CeMj
         Y5R+OzJmuk0ALn0DmmK702keZZ4L982iYI6iDQs7KQWZG3T0OoPhyL8naesaxvXvpAK8
         wVWA==
X-Gm-Message-State: AFqh2krT5ltNTxGnTDdF5pnWNCwIa9ICBUCNxDVk5A8yhuiIAVxka0UZ
        67ZB6nQ+qSFf6t6hZW3ihq4=
X-Google-Smtp-Source: AMrXdXsEkQ3iPijbloxVGB6sOINXp02kw/vqCA//5Fm6o7/URrh2P6+pl/KCj9MCmeCMR9Ml3TWpcw==
X-Received: by 2002:aa7:93cd:0:b0:57f:c170:dc6 with SMTP id y13-20020aa793cd000000b0057fc1700dc6mr1231625pff.14.1671369007572;
        Sun, 18 Dec 2022 05:10:07 -0800 (PST)
Received: from localhost.localdomain ([202.120.234.246])
        by smtp.googlemail.com with ESMTPSA id k195-20020a6284cc000000b00576ce9ed31csm4589175pfd.56.2022.12.18.05.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Dec 2022 05:10:06 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH net-next v3] net: Fix documentation for unregister_netdevice_notifier_net
Date:   Sun, 18 Dec 2022 17:09:54 +0400
Message-Id: <20221218130957.3584727-1-linmq006@gmail.com>
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

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
changes in v2:
- s/into/from/ as pointed out by Petr Machata.
changes in v3:
- remove fixes tag as pointed out by Jiri Pirko.
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

