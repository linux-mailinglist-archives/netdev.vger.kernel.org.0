Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA72520C79
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbiEJEBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 00:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiEJEBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 00:01:42 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513BE2A83F2
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 20:57:46 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id k14so13657095pga.0
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 20:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dk8V3mpF9Jol/2QO8gjhd+cvBgGYgwWafhU0LXkw4aU=;
        b=FsitZTWZFdBnLSnf2Q9/0rlzdgjcyaLwEzAClb9D4H384ppuUG3dqmnDr4Yc0NWzwU
         2DcZk8eMBNivTWYXeFVOOQaCYmjKcdUWcY4AuRn5eInRB66NGV32H4BIvlzEBvGOZyyr
         5HaAkjwEhvMByyFTSAvs6Zljs0DGysZvbGk3KI5CH4SaYx9Gg6kZ2NW+t4EQPdL1y5VW
         Lwq10dqDKV2pGEM1y56RsGkY6ihmG/Svd8OngY1zq7rZ86lhQspwKF41RxIVpGJRR6iE
         DIysS6PhYPdwnTLNIQaCIqVz/SNnStsVNCY7nF6+yBZyp1p+jVV7j9+Jo50CoH2bwnVA
         mCPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dk8V3mpF9Jol/2QO8gjhd+cvBgGYgwWafhU0LXkw4aU=;
        b=VYZCtlfuu1Ww/XfRk6ojW/hMy1PJtSIbu3Q5ISGz2rTDABHzbIIeUe06gqVKPE/SUO
         OflS62lclq1Q5ykyBVIc8hEQSmNe4x9vCmKBT+6EXO4qzPrxTOMfcLqXwquk0YDnytiR
         bohQ9j9RrPoQ9hqEgo+tB2Hnqom+Q78K5+WPu3TFmCrUFAwDsLGVzn6MofBt5DnksT78
         5iKTU2bxhsFHI+cfVVf2e0nHGwYmL+diXtRz4MhlY9jl4TPg8P1PRs+vS2LaOerjt3Ad
         wMOgiZhwOJVB0Wmm2hjPCilQEkBvMF/SqiwKMZ67td8+Wwo/CJwJlwaj6gVo2kfpr2U9
         XHvQ==
X-Gm-Message-State: AOAM5309/7RFoHPlgFBh4ZPTfjY/gEu/pFf29oV243L9lt4kl/4BFQIl
        iNqpvKAuQ1fU9RFg0zNhut4=
X-Google-Smtp-Source: ABdhPJxtzrJ5ekesj3mxfpyaCY/KAniry0+Gi890DOxVUOu4mQs1IVzRJjA2TdDjrpcz9tpkxrtBnw==
X-Received: by 2002:a63:6205:0:b0:3c6:4449:fc69 with SMTP id w5-20020a636205000000b003c64449fc69mr15138156pgb.330.1652155065852;
        Mon, 09 May 2022 20:57:45 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id d12-20020a17090ad3cc00b001d81a30c437sm568193pjw.50.2022.05.09.20.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 20:57:44 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 0/5] net: CONFIG_DEBUG_NET and friends
Date:   Mon,  9 May 2022 20:57:36 -0700
Message-Id: <20220510035741.2807829-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
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

This patch series is inspired by some syzbot reports
hinting that skb transport_header might be not set
in places we expect it being set.

Add a new CONFIG_DEBUG_NET option
and DEBUG_NET_WARN_ON_ONCE() helper, so that we can start
adding more sanity checks in the future.

Replace two BUG() in skb_checksum_help()
with less risky code.

v2: make first patch compile on more arches/compilers
    add the 5th patch to add more debugging in skb_checksum_help()

Eric Dumazet (5):
  net: add include/net/net_debug.h
  net: add CONFIG_DEBUG_NET
  net: warn if transport header was not set
  net: remove two BUG() from skb_checksum_help()
  net: add more debug info in skb_checksum_help()

 include/linux/netdevice.h | 141 +---------------------------------
 include/linux/skbuff.h    |   2 +
 include/net/net_debug.h   | 157 ++++++++++++++++++++++++++++++++++++++
 net/Kconfig.debug         |   7 ++
 net/core/dev.c            |  12 ++-
 5 files changed, 176 insertions(+), 143 deletions(-)
 create mode 100644 include/net/net_debug.h

-- 
2.36.0.512.ge40c2bad7a-goog

