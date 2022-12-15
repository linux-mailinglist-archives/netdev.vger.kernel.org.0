Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7846C64D723
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 08:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiLOHQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 02:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiLOHQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 02:16:05 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083CE32B8B;
        Wed, 14 Dec 2022 23:16:03 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so1821064pjo.3;
        Wed, 14 Dec 2022 23:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hoxgf87k7oGSQfRPP7qLhzJhwylhRbiW8KymAGd+A14=;
        b=IYh5Sm/czZpi1R4mT+Otvt+OGW809SPf9AyY6EEHpdCiIhOg/DuGffBGsUc4xa8G4f
         VaJZkYPTtMu4RPblzWsdEYi/pwv5YiTrWqBUqI6LpKhnqVNnRRkYprzzo5h7rYR/xfuO
         pVHS2QJLRjv/jIO6okYrkiWRlHAD10RPQ6zv9Wn5XYVmR0ZMHsXFnCc6ytc22etUs9Q9
         SYHwS3f0yt/0PqOFUXT42awssR+aX4jzRTY1MTTmAkV58SnSEtejOnvKHLGziqFpIjgz
         iPCG5EIiD2BfZLhJMEtURHoTqbfu+ZVJSWSEoI/1hK6BFdHp32qL5Hz1ZkgjZ1p4msJv
         tDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hoxgf87k7oGSQfRPP7qLhzJhwylhRbiW8KymAGd+A14=;
        b=Bs88Z7XUx5koYhwIGQBKsOg7tDei7Gk+b/xVwOvTPUxh5zJPuK8mF0B4A5+AXvCA3e
         KZGWpFebL/RaFOqEmsSJthJ1NFe0irvt+35btHbRqhNmZxUJ1b4xiYD1ijConmw9NkIY
         Oe65Pc/0/pVjQFTqml/5fyz1tOXTb/hcHkSr2V1W6ya1lIYT8btWoOZaIECJkGTqAdN1
         jfWC0Bb8KVynfVNx/kVFbje927KQDnbd+9cp+0HDC44B5GFBzQVSsxUlRP3i2k53r5gL
         PiBPWyMITnrUniVMbioX4fjvu/qV4SSR9Dg8pZ3QBhHnGQJVcRLZSzbuVu0htZBAqjbn
         b0+Q==
X-Gm-Message-State: ANoB5plRTFtuWbPVJ9z/MnX99RdufCIn2GXUrNuj1yFJcfSGA1CdsBbi
        Jqf0Pp0guKh6l5YWEBJ3/z0=
X-Google-Smtp-Source: AA0mqf5wf+l9IHlVkaliyQmToRixFaNwiYY+zHzpGKjnnYqmhaQAQtVsSQKMtqCxTXHWbOLm5et2Xg==
X-Received: by 2002:a05:6a20:102a:b0:a4:7077:5a01 with SMTP id a42-20020a056a20102a00b000a470775a01mr43710095pzd.13.1671088562411;
        Wed, 14 Dec 2022 23:16:02 -0800 (PST)
Received: from localhost.localdomain ([202.120.234.246])
        by smtp.googlemail.com with ESMTPSA id e8-20020aa798c8000000b005769b244c2fsm992170pfm.40.2022.12.14.23.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 23:16:01 -0800 (PST)
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
Subject: [PATCH] net: Fix documentation for unregister_netdevice_notifier_net
Date:   Thu, 15 Dec 2022 11:15:49 +0400
Message-Id: <20221215071551.421451-1-linmq006@gmail.com>
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
registered by register_netdevice_notifier_net().

Fixes: a30c7b429f2d ("net: introduce per-netns netdevice notifiers")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b76fb37b381e..85c6c095a1b6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1840,7 +1840,7 @@ EXPORT_SYMBOL(register_netdevice_notifier_net);
  * @nb: notifier
  *
  * Unregister a notifier previously registered by
- * register_netdevice_notifier(). The notifier is unlinked into the
+ * register_netdevice_notifier_net(). The notifier is unlinked into the
  * kernel structures and may then be reused. A negative errno code
  * is returned on a failure.
  *
-- 
2.25.1

