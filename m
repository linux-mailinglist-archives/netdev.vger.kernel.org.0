Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB195141B4
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 07:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238232AbiD2F1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 01:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237794AbiD2F1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 01:27:53 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4348567C;
        Thu, 28 Apr 2022 22:24:35 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id f186so5148405qke.8;
        Thu, 28 Apr 2022 22:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m/mHAyDFFPxLTzZUm97TawyOqrnU8/aqHX81y1GzXYQ=;
        b=Pg0zNYviAG3236gyFoaUd5qRotRWUCA7tZVGNRlfZ4j3l591BPmkt+EOMciKhUPi7v
         a0EozWE6jDmg7H2DzZVK/uee313oPd1oKQnge7V4SjwW98/khfjeB5X+ZOfzp4vdMg4C
         wYz01Urxsr2/alHWaXXSGwpc9vhGqZImGEfXHWVepCxIF0sZQscauGHn9fQEQDyGOrAn
         gjpBfEBcmiiBclQrkzH2iPnEV+EsmKm1r0bWXWnONI5ikokcZe/ksGTUBRFhVbGwIeb8
         qeT4oJU1KeCMDfDl64Dx2PKxDyNjIoZZ/X0Emguj+BpcL9rO6EoqPa2SliefQdq1sBTP
         VWSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m/mHAyDFFPxLTzZUm97TawyOqrnU8/aqHX81y1GzXYQ=;
        b=MPYSYSOs2/F8+zs7C1HksdcT/kgvCju5b+/52bfXrB1DAOjViIjcTM3O7TtqLM6KHQ
         AAYgyh/F9Us9u6efXLffK8y/E000390n8XmtVGT5xYsswKEPTsemdLZxEXtnecRjJqPk
         FHRYeNNnf4E0rP+35YFRMSsKyz2uUOqrcRN3khKPJQy1qybdRKyfm6Ozk2kOXTdJ5Qnc
         PmdmDb7YmXXJZ1Ie3jZbDGdkSXpM/DNz0unwxpycegibAudkA4IJnSEcVEt7GaVBXdd4
         hqwVeGGs4ARaq2VnYFCUbIqmBF6jPdVh/+PVR0uoE9q0Z6GSG51bqkplfD4j+l/mJXPa
         IR6g==
X-Gm-Message-State: AOAM533llYlLLX5b9PxYPlpx8JTU89IXqlbuZZNtKelt2R3XbRTPRuh5
        x/FT5tBfvKJ20MCRs5RG3Q==
X-Google-Smtp-Source: ABdhPJw/BxPr5Ltp0nnuo/eoYCI2UfEwuJRaNUfiYZOgPbx2cRRrg0a39FKWxCYmUhVXxmEEKWOhmQ==
X-Received: by 2002:a37:8d43:0:b0:699:b613:be6 with SMTP id p64-20020a378d43000000b00699b6130be6mr21846929qkd.484.1651209874904;
        Thu, 28 Apr 2022 22:24:34 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id az14-20020a05620a170e00b0069fb6140d2fsm541384qkb.45.2022.04.28.22.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 22:24:34 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        William Tu <u9012063@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH v2 net-next 0/2] ip_gre, ip6_gre: Make [IP6]GRE[TAP] devices always NETIF_F_LLTX
Date:   Thu, 28 Apr 2022 22:24:17 -0700
Message-Id: <cover.1651207788.git.peilin.ye@bytedance.com>
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

v1: https://lore.kernel.org/netdev/cover.1650580763.git.peilin.ye@bytedance.com/

change since v1:
  - deleted "depends on patch..." in [1/2]'s commit message

Hi all,

This patchset depends on these fixes [1], which has been merged into
net-next.  Since o_seqno is now atomic_t, we can always turn on
NETIF_F_LLTX for [IP6]GRE[TAP] devices, since we no longer need the TX
lock (&txq->_xmit_lock).

We could probably do the same thing to [IP6]ERSPAN devices as well, but
I'm not familiar with them yet.  For example, ERSPAN devices are
initialized as |= GRE_FEATURES in erspan_tunnel_init(), but I don't see
IP6ERSPAN devices being initialized as |= GRE6_FEATURES.  Where should we
initialize IP6ERSPAN devices' ->features?  Please suggest if I'm missing
something, thanks!

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

