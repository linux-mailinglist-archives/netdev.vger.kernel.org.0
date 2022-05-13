Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3EC7526605
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 17:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381967AbiEMP0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 11:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233504AbiEMP0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 11:26:48 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E2E1658A;
        Fri, 13 May 2022 08:26:47 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id z2so16958770ejj.3;
        Fri, 13 May 2022 08:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vRuutjdRJtG/Bb6H7ojUi4zmCk2FQZReoeZCIJzw81M=;
        b=LkEgXf2w6UMjPRp+EEKOMcgP18cf7ck6G6vrxTCsOWGNrB0CoG9LVg9CJD08Q/YPu7
         Ydg431ZCdjoZN8VdlWcJCD/nyByOpEKWPM8PSiu5CVPEgu4s0d36agUYedtEaQbS/wMq
         oZQgC42ce6hpd0Z1tpVNHwCutdsyZgYgSbJaLOuHxgZwl3t+AVjnBaxRVB4NDTxzdr2b
         lEK8hSVn/qJC6+SsSFOAo+bklvXFoSqzjur1wPqvMrs7F0R0LDPsl099ouNsG3OMQsP5
         kC0id9t3+f4dqzbOsN53xUVSSVDRzm3ihjvNUahjW/t8dw5GxN2UesijyUoXe4KdtFGS
         2fxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vRuutjdRJtG/Bb6H7ojUi4zmCk2FQZReoeZCIJzw81M=;
        b=i9qemb1VtvzoZmXD8ZfEw+S67scD1o1Y9KL3JZ3cwYYecul+VR9X0GphN+ZS/vrEi/
         NQs1wMezmhlKyvfM9dfzEelpAEXeYxiCFqgU2U3CC9YWYz094lKRZnkVUYn2c02sDcj5
         aw4xNoBfQ3x9p0RzVzVBjIAjuluPi8sCBMxRlkrE2IlDNt0QQPKKwAw05OGC7wmGWd1a
         G2vCKnWofm7f/p/4QPfeKFNbAnB0rN9ljh5c7XY7zetombAUEb5vjisc56UXh+QhqR4D
         G1b7wkP8oPlEKKgZTK3S4rQrN3A90PgMJ6HUNaD66BKEWb6aEeCo5whFgBZe4V161jf4
         W93Q==
X-Gm-Message-State: AOAM532TuuTf/nsTtlClE72j2OPNBDzYepfrZR4iXkckUvJtBIryvSrX
        gytlVL9SfvWaGwYWIe0b5qFkDO/+cv0=
X-Google-Smtp-Source: ABdhPJyM/9MZZET5coTyt+GBl5zb4UJ8tl+qeDPYXiJMe64X4i/VKkyKiFHry68DV+r56JbtDco8Rg==
X-Received: by 2002:a17:907:608f:b0:6f6:1155:99ab with SMTP id ht15-20020a170907608f00b006f6115599abmr4580865ejc.306.1652455605710;
        Fri, 13 May 2022 08:26:45 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.161])
        by smtp.gmail.com with ESMTPSA id j13-20020a508a8d000000b0042617ba63cbsm1015351edj.85.2022.05.13.08.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 08:26:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 00/10] UDP/IPv6 refactoring
Date:   Fri, 13 May 2022 16:26:05 +0100
Message-Id: <cover.1652368648.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
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

Refactor UDP/IPv6 and especially udpv6_sendmsg() paths. The end result looks
cleaner than it was before and the series also removes a bunch of instructions
and other overhead from the hot path positively affecting performance.

Testing over dummy netdev with 16 byte packets yields 2240481 tx/s,
comparing to 2203417 tx/s previously, which is around +1.6%

v2: no code changes, just resending properly
v3: remove patch moving getfrag callback assignment
    add benchmark numbers

Pavel Begunkov (10):
  ipv6: optimise ipcm6 cookie init
  udp/ipv6: move pending section of udpv6_sendmsg
  udp/ipv6: prioritise the ip6 path over ip4 checks
  udp/ipv6: optimise udpv6_sendmsg() daddr checks
  udp/ipv6: optimise out daddr reassignment
  udp/ipv6: clean up udpv6_sendmsg's saddr init
  ipv6: partially inline fl6_update_dst()
  ipv6: refactor opts push in __ip6_make_skb()
  ipv6: improve opt-less __ip6_make_skb()
  ipv6: clean up ip6_setup_cork

 include/net/ipv6.h    |  24 +++----
 net/ipv6/datagram.c   |   4 +-
 net/ipv6/exthdrs.c    |  15 ++---
 net/ipv6/ip6_output.c |  53 +++++++--------
 net/ipv6/raw.c        |   8 +--
 net/ipv6/udp.c        | 153 ++++++++++++++++++++----------------------
 net/l2tp/l2tp_ip6.c   |   8 +--
 7 files changed, 120 insertions(+), 145 deletions(-)

-- 
2.36.0

