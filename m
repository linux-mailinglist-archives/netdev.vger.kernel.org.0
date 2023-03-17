Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC8F6BED65
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbjCQPz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjCQPzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:55:54 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACA2C9279
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:42 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54352648c1eso49929827b3.9
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679068541;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8PNfeLxnU3lkK6OxACd+d3Mrn9buHWfOTzerr0lqtJw=;
        b=U66aN6gep8Om0XP7hDledRR3Vs7EDfgKkGPpFUACG3FQk6rngeVRmjgBZKcXGbXWCt
         V6RNy0Be1pxHP9I5xTIJXe6Z+my+p5sIaxTWlE21/9fOm3fao0+q9n6sDcC9PPgusrnT
         hyEG6W5wUyNbcjkp/ev+RoCs6xWwtS4hvWrbSKlT4bL56UXduYu63NftYKsoIZoqmC4l
         DHQguEGWQIXJpY4zTLJ56zkVnGSXFMC1rnX24cr0Reit0y1/asbb3uvXIn32DLn9hTzZ
         EvSjkEP1r6vcVqRNS9KSMc9VSfH7eOdrbwZbre1kokSe4bExSX62gv+M8BzmjRoCArE3
         pn5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679068541;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8PNfeLxnU3lkK6OxACd+d3Mrn9buHWfOTzerr0lqtJw=;
        b=rquTfsw8vgZmPxq7DY4y7DCE9r8Qid83gfEXCNddHqLNyzhlY1T6SrJOp1uk+sPpSG
         Gdn+6CuKQHFvrHmnParQdzP3uIqiP0kI5+NYUeO8UKxKlcnK2R5fedaqPPc2fZ4HhUoq
         S83HArBdGsKMybDzD19/9bxXnMRP7oz6AVbZxGdj4l2oiLIYtxg2aJ01vazfAJ8CFDJ4
         x90WjhAoQGgzuyvoHXACsJyn7O7rodPzr9rqJ9Z7+MPWgW/z3WCnMJuEjvSNNkwVv+UA
         e1DJv/JlGy8RT8h0YoBUHYR5uACyS/r4isPuV6Zua67nw9zweutAOHoVXkg6bg85BDWn
         Yoag==
X-Gm-Message-State: AO0yUKVYVXuk0m3Ak4Nk9cS07XAr1xbNzJk29ShUbXGvJHNhQSWO6dDe
        /E7r1rwqX3uDU46mrdaSskF9oGMYWWvS0w==
X-Google-Smtp-Source: AK7set8hXmF63xZvHGT29NEtQqtE6gwPpHi+ze4AUQU3JACvCORNmCWwER0en6x9qNtMnifWYGqt+E8SimAgDA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:928c:0:b0:9f5:af8a:3b61 with SMTP id
 y12-20020a25928c000000b009f5af8a3b61mr59943ybl.4.1679068541269; Fri, 17 Mar
 2023 08:55:41 -0700 (PDT)
Date:   Fri, 17 Mar 2023 15:55:29 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230317155539.2552954-1-edumazet@google.com>
Subject: [PATCH net-next 00/10] net: better const qualifier awareness
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow-up of d27d367d3b78 ("inet: better const qualifier awareness")

Adopting container_of_const() to perform (struct sock *)->(protocol sock *)
operation is allowing us to propagate const qualifier and thus detect
misuses at compile time.

Most conversions are trivial, because most protocols did not adopt yet
const sk pointers where it could make sense.

Only mptcp and tcp patches (end of this series) are requiring small
adjustments.

Thanks !

Eric Dumazet (10):
  udp: preserve const qualifier in udp_sk()
  af_packet: preserve const qualifier in pkt_sk()
  raw: preserve const qualifier in raw_sk()
  ipv6: raw: preserve const qualifier in raw6_sk()
  dccp: preserve const qualifier in dccp_sk()
  af_unix: preserve const qualifier in unix_sk()
  smc: preserve const qualifier in smc_sk()
  x25: preserve const qualifier in [a]x25_sk()
  mptcp: preserve const qualifier in mptcp_sk()
  tcp: preserve const qualifier in tcp_sk()

 include/linux/dccp.h     |  6 ++----
 include/linux/ipv6.h     |  5 +----
 include/linux/tcp.h      | 10 ++++++----
 include/linux/udp.h      |  5 +----
 include/net/af_unix.h    |  5 +----
 include/net/ax25.h       |  5 +----
 include/net/raw.h        |  5 +----
 include/net/tcp.h        |  2 +-
 include/net/x25.h        |  5 +----
 net/ipv4/tcp.c           |  2 +-
 net/ipv4/tcp_input.c     |  4 ++--
 net/ipv4/tcp_minisocks.c |  5 +++--
 net/ipv4/tcp_output.c    |  9 +++++++--
 net/ipv4/tcp_recovery.c  |  2 +-
 net/mptcp/protocol.c     |  2 +-
 net/mptcp/protocol.h     |  9 +++------
 net/packet/internal.h    |  5 +----
 net/smc/smc.h            |  5 +----
 security/lsm_audit.c     |  2 +-
 19 files changed, 36 insertions(+), 57 deletions(-)

-- 
2.40.0.rc2.332.ga46443480c-goog

