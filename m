Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E91250AB9E
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 00:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242506AbiDUWqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 18:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbiDUWqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 18:46:48 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECB4433B9;
        Thu, 21 Apr 2022 15:43:57 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id hf18so4389949qtb.0;
        Thu, 21 Apr 2022 15:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LKbOn0YJ4vJqmUSVPvssmzjdrWGZSY2aXU7cKreyOHk=;
        b=I5uSKy0NaXPwn+W2xZrk5fXTafC6PQQ7J/x1gkP/NgZvDWmrehyVXuhOrdkiHYx7OO
         8hCySmwQSmjCOdNwlfGRyVW2TeNHPM9xMzdbI7JoeJJsfYGD1P2mq0UNWi7xKCCjXCZZ
         DHeVV8wwKuN6oyl8r8XWBOsShFcmJsefMKCs/nFJFwOpCZ/Yzpi9ux2ApoXzp33S+S/A
         90c/Zt44QZMeJ01AIQZ6HZJ743eVHfIhffi7PVCs0/uHNhnl8kuCGS7ioday3nzEiisl
         c3lr3SOYQIJmz6epva4tToRmwwuepbZ/itNo4/DbQG7U7u09DGgJ+/Ym52RUprl1SMPd
         /mZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LKbOn0YJ4vJqmUSVPvssmzjdrWGZSY2aXU7cKreyOHk=;
        b=cvMX258Aewq2ocO5X37uUma75crg+Zt00jJUbiZTPSwhFL2yP04nu7MYFwNmVvywLv
         V8/CfUg0sUWZnH6KerFN3KBCaAR7jBWlZzYbmxY7BXxnQ6++CSgpPLN0mW8+8fWzj2No
         gpyFMbEarXxm9Q+4KxB8QLDW+dRLxb4uK1cYU/gh73e0sKzxr/Vfx3TdLwem7rA0HnjA
         YQwzsqrstUvBfBGvMdYuwOpphTWgsHlKDgdjdoUBhJbPYjHKPxM/IIBIjFycuN6OqF49
         jLiVJgEADIoQg+95uMa3EU/DjwpgGUIO7JECYtN/7IBEEX4GGagYVgZlGKAQV+4mBLc9
         YdZg==
X-Gm-Message-State: AOAM532bZn/e5F5+c8G1IH96saDxy7sMk4xYRPbXQqHf5SVtYxr8Ufs3
        IckEkj+BS2+Ll17HkxFQqaHlmiKtoQ==
X-Google-Smtp-Source: ABdhPJyL1uZHcx5KVkP2cl8HZUZe+b5c79e/DtJGD4neNhid5cnnOl5VllvTFkIrKJ95h2NieUi4DQ==
X-Received: by 2002:a05:622a:15cb:b0:2f2:681:7d06 with SMTP id d11-20020a05622a15cb00b002f206817d06mr1276679qty.386.1650581036685;
        Thu, 21 Apr 2022 15:43:56 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id j188-20020a3755c5000000b0067d1c76a09fsm150069qkb.74.2022.04.21.15.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 15:43:55 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net-next 0/2] Make [IP6]GRE[TAP] devices always NETIF_F_LLTX
Date:   Thu, 21 Apr 2022 15:43:42 -0700
Message-Id: <cover.1650580763.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Hi all,

This patchset depends on these fixes [1].  Since o_seqno is now atomic_t,
we can always turn on NETIF_F_LLTX for [IP6]GRE[TAP] devices, since we no
longer need the TX lock (&txq->_xmit_lock).

We could probably do the same thing to [IP6]ERSPAN devices as well, but
I'm not familiar with them yet.  For example, ERSPAN devices are
initialized as |= GRE_FEATURES in erspan_tunnel_init(), but I don't see
IP6ERSPAN devices being initialized as |= GRE6_FEATURES.  Please suggest
if I'm missing something, thanks!

[1] https://lore.kernel.org/netdev/cover.1650575919.git.peilin.ye@bytedance.com/

Thanks,
Peilin Ye (2):
  ip_gre: Make GRE and GRETAP devices always NETIF_F_LLTX
  ip6_gre: Make IP6GRE and IP6GRETAP devices always NETIF_F_LLTX

 net/ipv4/ip_gre.c  | 50 ++++++++++++++++++++--------------------------
 net/ipv6/ip6_gre.c | 34 ++++++++++++-------------------
 2 files changed, 35 insertions(+), 49 deletions(-)

-- 
2.20.1

