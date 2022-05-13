Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6AF5269AD
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358179AbiEMSz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383410AbiEMSz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:55:56 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764596B7E3
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:55:54 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c11so8766429plg.13
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tEuZsgSRshMQtLN+z4ykP1BXKoTmBknr+4Ny2VY7rPs=;
        b=o36VeKXKHrCxmPz8JaIF2zEe0SNFF4AO7hdjrh41t/OpGmudCEeZdN7DifxRoP8Yof
         UvDq2RBGZ3Y694UlV4f9PgYCJgWgnM6Nem6028NkR8ewjjKzi4LcUSPoxea5eeyq6S6F
         SQzumGC1xSjHjoJyznlDSLP+LNjc8qFMyqiROeyuV/BvWSUBD3PO0lsSkwJjA8wHpDD9
         cLqz+daoIusj84cP1wjieVulrfGl9x+H2sN4MS/YV3lXAgNTnVYtYqfxoAubuzRihdV+
         SARIpJz/5suL93cYucBNgyZ3LTbak1MOZMonO3A3NdqhllzVgLME11qwLNjtCW7U/qMc
         nQsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tEuZsgSRshMQtLN+z4ykP1BXKoTmBknr+4Ny2VY7rPs=;
        b=DCmHDQ3U9ZZJaDCDnkFbFO4JCSrrDpk8KXDzxl2HXFiNZyLuHHcGjHxIHPP+umBeIG
         vjbtTce5bWUK039ESKRg0ANqmBmrgDUfL4NoYUyTjwBiozo2L57UeimNi9wwnTVw/RQM
         Enoaqfyl4InJEnrlzhbcLwrHt8CFW6EzGBjzBRKnJtyJY3mm60gphHPFeqdG4iZTd9XU
         ak4sz+zGbnDgI9v53d8w+RF3B+0CTQrWvPODGrFnQiCu2FFcT0Etvtkvm3MoI8snEuPd
         4T2m16j4A9dKShEiul7Wqc0GQwIu9okJJ9h3vcbpazPgF0H9751a4sMMtzIfvCqzdJ3o
         YceA==
X-Gm-Message-State: AOAM530NF1paTkvSWkevGXvZrCF8rL2kf2+mhiEE+EcZeXb4A/8tGlJq
        XgwqIe6v8pqDUSii0UQ7jtBdscSMphU=
X-Google-Smtp-Source: ABdhPJz096YJVmRTgdlm3dnlPFpgaA+8jZNsHLNvT9hWDuL7TpW+nQaL2cYfzRAeR2Q6vTeI/lYnHA==
X-Received: by 2002:a17:902:b703:b0:158:2667:7447 with SMTP id d3-20020a170902b70300b0015826677447mr5950794pls.92.1652468154028;
        Fri, 13 May 2022 11:55:54 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c10200b0015e8d4eb2absm2159537pli.245.2022.05.13.11.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:55:53 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 00/10]
Date:   Fri, 13 May 2022 11:55:40 -0700
Message-Id: <20220513185550.844558-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
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

net: add annotations for sk->sk_bound_dev_if

While writes on sk->sk_bound_dev_if are protected by socket lock,
we have many lockless reads all over the places.

This is based on syzbot report found in the first patch changelog.

v2: inline ipv6 function only defined if IS_ENABLED(CONFIG_IPV6) (kernel bots)
    Change the INET6_MATCH() to inet6_match(), this is no longer a macro.
    Change INET_MATCH() to inet_match() (Olivier Hartkopp & Jakub Kicinski)

Eric Dumazet (10):
  net: annotate races around sk->sk_bound_dev_if
  sctp: read sk->sk_bound_dev_if once in sctp_rcv()
  tcp: sk->sk_bound_dev_if once in inet_request_bound_dev_if()
  net: core: add READ_ONCE/WRITE_ONCE annotations for
    sk->sk_bound_dev_if
  dccp: use READ_ONCE() to read sk->sk_bound_dev_if
  inet: add READ_ONCE(sk->sk_bound_dev_if) in inet_csk_bind_conflict()
  net_sched: em_meta: add READ_ONCE() in var_sk_bound_if()
  l2tp: use add READ_ONCE() to fetch sk->sk_bound_dev_if
  ipv6: add READ_ONCE(sk->sk_bound_dev_if) in INET6_MATCH()
  inet: rename INET_MATCH()

 include/net/inet6_hashtables.h  | 28 +++++++++++++++++++---------
 include/net/inet_hashtables.h   |  2 +-
 include/net/inet_sock.h         |  5 +++--
 include/net/ip.h                |  2 +-
 include/net/sock.h              |  5 +++--
 net/core/sock.c                 | 11 +++++++----
 net/dccp/ipv4.c                 |  2 +-
 net/dccp/ipv6.c                 |  4 ++--
 net/ipv4/inet_connection_sock.c | 12 ++++++++----
 net/ipv4/inet_hashtables.c      | 10 +++++-----
 net/ipv4/udp.c                  |  2 +-
 net/ipv6/datagram.c             |  6 +++---
 net/ipv6/inet6_hashtables.c     |  6 +++---
 net/ipv6/udp.c                  | 13 +++++++------
 net/l2tp/l2tp_ip.c              |  4 +++-
 net/l2tp/l2tp_ip6.c             |  8 +++++---
 net/sched/em_meta.c             |  7 +++++--
 net/sctp/input.c                |  4 +++-
 18 files changed, 80 insertions(+), 51 deletions(-)

-- 
2.36.0.550.gb090851708-goog

