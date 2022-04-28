Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255985135E6
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347846AbiD1OCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347841AbiD1OCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:02:02 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A602AAFB24;
        Thu, 28 Apr 2022 06:58:47 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id j6so9707321ejc.13;
        Thu, 28 Apr 2022 06:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mPRYPDXAZuw5D7+ekHvT1vGnzy2EHk8rMdCszNSHcAQ=;
        b=jH2vOcrLBFhjoWGKAaXeJzRqbQvfiJe6hKq/lT/TIgA2UAw6gSAxz+fH3z4Wj+nHeZ
         lfsD25NYRLi5oHPyCHd8gf5gA51kpZJgQJBLw0zut3s4MmL0FHQEj8nTPANCpobeaO+M
         EOuVHY5c4lVKbjy9C27Zsx3dTWTIN51ZBxCk2j+shL74AiYyg5RhLTwbvddVfjVrtu2L
         bN02OGUFKqoDGxpcUyfx8LYyE7eIaOBCb7KcGqGXJxVmZrPtWx/PWIABcRJ4stCk1bQp
         BwGI26oQizJkxFvTb0nvzUy1EdOAAh8AorGytgG5EiPzIGDIxQpaveLM6faNEF0nzH1U
         0Hlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mPRYPDXAZuw5D7+ekHvT1vGnzy2EHk8rMdCszNSHcAQ=;
        b=1TM4IUXwiM6WYAATDr0YwSxJRpSadkuCj+yN/WCOUUPgHcpk5G25iAGIcaZ5nZobMz
         EXY0cSsyIDZfkBDMyFm4IX5wfvcn157GU2N4MqB3KkNeyMtQYO25IdELKkghyWUlOauB
         CRLcpcp0lvJl7kCj9WGD+oGXCXl3eHDQiynUlTRwGfNxyd/rlTkTSpZWZG4XajXYiLoV
         WrBkfj1PUZ6ytpsv0b5skudf/c9+rG6dnxd1mHZhY/KUa8rETwKFOd8QeTKmq+U+WTs/
         04jN8WFjir9TVw59n6NLgldOLuWn/eR9a1d2SRMdOTVuiVDl6FMPMMr6ZOWCN4zaU94o
         i4UQ==
X-Gm-Message-State: AOAM531o8wbG1u0mOpZJ1hpzFek8kD0/iQZ4ECLAzqDgiY/S7Y5fAaCy
        Uace8b+vShbChPFNBbPCqUTr59KW/yk=
X-Google-Smtp-Source: ABdhPJx2BQeYk9nAGrvmZ3uvd8WwEp5vq3xVW4vNweqxTfcjDOCs5g6QX4AQVr3s0QKKauO+KVJORA==
X-Received: by 2002:a17:906:8982:b0:6f3:95f4:4adf with SMTP id gg2-20020a170906898200b006f395f44adfmr19873768ejc.524.1651154325998;
        Thu, 28 Apr 2022 06:58:45 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.145])
        by smtp.gmail.com with ESMTPSA id t19-20020aa7d4d3000000b0042617ba63c2sm1652568edr.76.2022.04.28.06.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:58:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 net-next 00/11] UDP/IPv6 refactoring
Date:   Thu, 28 Apr 2022 14:57:55 +0100
Message-Id: <cover.1651153920.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
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

Refactor UDP/IPv6 and especially udpv6_sendmsg() paths. The end result looks
cleaner than it was before and the series also removes a bunch of instructions
and other overhead from the hot path positively affecting performance.

It was a part of a larger series, there were some perf numbers for it, see
https://lore.kernel.org/netdev/cover.1648981570.git.asml.silence@gmail.com/

v2: no code changes, just resending properly

Pavel Begunkov (11):
  ipv6: optimise ipcm6 cookie init
  udp/ipv6: refactor udpv6_sendmsg udplite checks
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
 net/ipv6/exthdrs.c    |  15 ++--
 net/ipv6/ip6_output.c |  53 +++++++-------
 net/ipv6/raw.c        |   8 +--
 net/ipv6/udp.c        | 158 ++++++++++++++++++++----------------------
 net/l2tp/l2tp_ip6.c   |   8 +--
 7 files changed, 122 insertions(+), 148 deletions(-)

-- 
2.36.0

