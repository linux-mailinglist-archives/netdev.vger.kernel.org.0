Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528E1543857
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245062AbiFHQEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245061AbiFHQEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:04:48 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8730927CCE1
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:04:42 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id w2-20020a17090ac98200b001e0519fe5a8so18701652pjt.4
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SR4Uu7W3PrgtDdgIa9y5Vx/TlBfDooDGBAnWj1uUFDM=;
        b=Taat/ew2WjFXbMzFFA22q5rluhrwT9/p1DPp7P964EF3t4w1xa7fU9MSloOKFjrlWF
         /lAb9M2iTLrjarxurR5ZWKlIcWW5Fp9yvVMrvf1PZzBZ9+1DF9qFLFv50lRv7qaW6CA4
         FyKCHFrNnPsX9ecdQm3p7BfgMpvScDUEoJu6GYLqGU7Dc0f5VFmlzQ2SkF6bcfpDQxX8
         RCwiE8DS+2cAywSeUmCoJ5NWBlxssFX3hITpRoAbY2x5Pp8m13j4HM3s5O+QVHa/0gFt
         TNMTttyvcI9nl4eaLAa3TEB+eM9ScqbOVP4DCE2tqnHAF47eAPTIKvea5Z/ZTFaLIYWB
         PeOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SR4Uu7W3PrgtDdgIa9y5Vx/TlBfDooDGBAnWj1uUFDM=;
        b=y59t29lAozMhvjvwLiUGB4QL5Be0XSX0Gy5MQkYz+GWhpQmrHykPdsrx4G7MAw7rtJ
         TyvH5ZFbEiOEsCSqgIQQalo9B5hD0m7nE8pIZPjKp3uX1npDkTGSN+mMILD6cznL8xhK
         GRLW8voO++LxIE5eY9ANjLmWQMULcxjnrbip6APFwEJlv9lVssB2T3Z46kl4nluM9OM0
         fdKCKLU6UpkCKv0rfBtDB/1nNDbrZdBWGgQmy17wlKTLlY6jfiiv4ThGA1GeagH3m+Bd
         XHUp+OPRG6bOJSviYimmfe4fz4InUFSSRBJueQfjq18449L1ZyOud7jwoRIkwdG8TZ6D
         XBkQ==
X-Gm-Message-State: AOAM533vyaGoJ6QngdFbqSKOoTPdH+956Rv3gKdK4iik/ryiddTsKJ67
        BRojhgn+qprffs5N5LKPHe25IQyn8r0=
X-Google-Smtp-Source: ABdhPJyhhdnomAYnja0lPAnsYvGn2jCStMad4eNK9kEki5CGTpE6tL9+bn9dGJBR9ZfUgaOpyPnBGA==
X-Received: by 2002:a17:902:8503:b0:168:8fbf:61f7 with SMTP id bj3-20020a170902850300b001688fbf61f7mr5647119plb.87.1654704281433;
        Wed, 08 Jun 2022 09:04:41 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id ju10-20020a17090b20ca00b001df264610c4sm18622019pjb.0.2022.06.08.09.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:04:41 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 0/8] net: few debug refinements
Date:   Wed,  8 Jun 2022 09:04:30 -0700
Message-Id: <20220608160438.1342569-1-eric.dumazet@gmail.com>
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

Adopt DEBUG_NET_WARN_ON_ONCE() or WARN_ON_ONCE()
in some places where it makes sense.

Add checks in napi_consume_skb() and __napi_alloc_skb()

Make sure napi_get_frags() does not use page fragments
for skb->head.

Eric Dumazet (8):
  net: use DEBUG_NET_WARN_ON_ONCE() in __release_sock()
  net: use DEBUG_NET_WARN_ON_ONCE() in dev_loopback_xmit()
  net: use WARN_ON_ONCE() in inet_sock_destruct()
  net: use WARN_ON_ONCE() in sk_stream_kill_queues()
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

