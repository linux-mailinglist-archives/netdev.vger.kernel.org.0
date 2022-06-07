Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A17F540498
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 19:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345488AbiFGRRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 13:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344627AbiFGRRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 13:17:38 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B714D26A
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 10:17:37 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 15so16093911pfy.3
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 10:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=10cxczHKBZ+4DvEoUdvi+p/5cLvVVYIjyKUpFH0W394=;
        b=Exp1KP7zwqiJgEcBMbtEDz+b0GlbVAiC6+wF3NXn5oFZzkXfaXwUEwdf4zPN0AH6wS
         GI0LmLAPS7R09kqSraYu/wjTXcRGgstQYj2eytlR7J06lE/MqEv5heELH5M1/pc2lIF8
         gQEMxMaRHffCu8+UABGMEmYAxrKX6VZs/9WvYo22+tZSOJJ5gVafWDdIUPwVRsd5sg9R
         QW651NiQKmlkMf10ETYuhetYhG/BexyecFmuz0qd9P2htH7zScdktTyKeak3rtwjHp9t
         shPSO4Sv0F2/2dORSJJ2zqCPeX1FJChoqKh6Ce77QkMhqy9lkpGr6On/o640ia/Ljoda
         idQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=10cxczHKBZ+4DvEoUdvi+p/5cLvVVYIjyKUpFH0W394=;
        b=XgAiifO2YEaNc41FBK+4L4uWYuPfjL5qRkwFhfeRj5KRx9E93lcHwNc3n4lDEH8ip9
         T6SaP7ENBvN1H3SbJdAHQMkVJ0Y1zREPmaGAuhKZNPn6Mhe3EaGLNX6+Lo73ICG4eZ8n
         DqZwYTitbX728tgI9VXqxLakZ/bc+OjYLmArU/g69AYMEm+cBnaDHyEn/XEAOUMEKJFj
         jLoh6R67/TuXdkk6z/JY7o/X8kehJr4euSAEM9QnvyyV6KZUqXJ1UvC74KsjmlN1AqLV
         t27qlOqfmxthtgTL5B3A2HME/zviF/z2kK9b1ZHbFgO4pCZRNc177Hab1oXWZkvSHDSS
         UO4w==
X-Gm-Message-State: AOAM531Mddv9cs1tHQg3fR4KSEyqph1JdloOHlOfAxdmHfgOY99G//El
        5D4QVwOAPnBU8z3mzdxJ3t4=
X-Google-Smtp-Source: ABdhPJxrHK5xL+cD1RV0WO2CQis2FDSnSH5+Ouii0gV1aMMG4Gic4ARfnxoX04bpWCgytscif1izUQ==
X-Received: by 2002:a63:2154:0:b0:3fe:2814:bd74 with SMTP id s20-20020a632154000000b003fe2814bd74mr187627pgm.148.1654622256639;
        Tue, 07 Jun 2022 10:17:36 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:191a:13a7:b80a:f36e])
        by smtp.gmail.com with ESMTPSA id d4-20020a621d04000000b0051b930b7bbesm13001616pfd.135.2022.06.07.10.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 10:17:36 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/8] net: few debug refinements
Date:   Tue,  7 Jun 2022 10:17:24 -0700
Message-Id: <20220607171732.21191-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
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

Adopt DEBUG_NET_WARN_ON_ONCE() in some places where it makes sense.

Add checks in napi_consume_skb() and __napi_alloc_skb()

Make sure napi_get_frags() does not use page fragments
for skb->head.

Eric Dumazet (8):
  net: use DEBUG_NET_WARN_ON_ONCE() in __release_sock()
  net: use DEBUG_NET_WARN_ON_ONCE() in dev_loopback_xmit()
  net: use DEBUG_NET_WARN_ON_ONCE() in inet_sock_destruct()
  net: use DEBUG_NET_WARN_ON_ONCE() in sk_stream_kill_queues()
  af_unix: use DEBUG_NET_WARN_ON_ONCE()
  net: use DEBUG_NET_WARN_ON_ONCE() in skb_release_head_state()
  net: add debug checks in napi_consume_skb and __napi_alloc_skb()
  net: add napi_get_frags_check() helper

 net/core/dev.c     | 20 +++++++++++++++++++-
 net/core/skbuff.c  |  5 +++--
 net/core/sock.c    |  2 +-
 net/core/stream.c  |  6 +++---
 net/ipv4/af_inet.c |  8 ++++----
 net/unix/af_unix.c |  8 ++++----
 6 files changed, 34 insertions(+), 15 deletions(-)

-- 
2.36.1.255.ge46751e96f-goog

