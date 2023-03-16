Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8786BD448
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjCPPrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbjCPPrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:47:09 -0400
Received: from mail-vs1-xe4a.google.com (mail-vs1-xe4a.google.com [IPv6:2607:f8b0:4864:20::e4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC36623A52
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:46:53 -0700 (PDT)
Received: by mail-vs1-xe4a.google.com with SMTP id bk15-20020a056102548f00b0042582cf3630so665456vsb.20
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678981554;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=chRdeqHyXU5YFMYZWgdvkCZMkN/JAohGd8zCRF2LBKo=;
        b=J26W6YXbJfWGAChrHaejtzwZM4i6ee4ZvHT6wwzhISmazAZh73ltYTvPNfXr6L/G6c
         GjRCphZVHdSWtYuig0TXu3aXV9SOGd6HXjOu+cwE1Cz7RkxoKZSaFbtXWmEX9AGJSQ29
         tByjYlTaC61PcW6Xi7uPSrg8CcbfSY4QFOnKx6rWfN3wzCKDh208az/WDcTUvcylWj5f
         p71Xow06oZ3K/cyE86EhfrMYil6qn8h8gz2OWjL15mYeM2zN463fsZl3Hk88M3LZib6H
         NlM/0q7Zx8H5ovhTEmSkQf3HsMMdg0vk+4Ob4CNX/cMRmBUrYfzluOkqYYM0pjnfDKFU
         GquQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678981554;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=chRdeqHyXU5YFMYZWgdvkCZMkN/JAohGd8zCRF2LBKo=;
        b=4eEYPjEeA5+LZ5i4B89c7DJbT+FqvWkjBsOGO/9K7UQ7D5jtuyl7t3xGeeuUVxrIcy
         BwDnUCgxzofTrp5KUufd2n8QeXYkNS2lhhpWy7F4mcj73pnEBSh1VKVjDGL3S2PwBBgF
         7wNjN0IdBelIKcdAzKqw/mzZq+kepOHsMrcuwdCVfvqPBTs935uco8IZj9VhESbWJByE
         dbJxcH2NnuhlKLze7qN4ST01UyLIIUflzLj7pirwCoeZas6GSQznMKkixJgLUdz2YjQR
         2kgMr3f4/aXx5A70YUztplMXBkakV2scK8ROTiCUrKF5/bVG88Y/pcoCNp19CrBFZ5+P
         4PvA==
X-Gm-Message-State: AO0yUKWa6C2OJt1WN6mSntHEf3k/Nni6k/CyQ9SlLplcyRmb+Ru6zzxS
        R/9sgV+VTXFDWnJjrntxElAyOJVPgSW7VQ==
X-Google-Smtp-Source: AK7set99aHMmxmfn8EUFAFA6Ah4D9NOit0RFLxE55CpGcvv7zPbhmFTPwKIS60lBW/MSZLSWBHUM4nIDSm323A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:6c8:0:b0:b36:32f8:852d with SMTP id
 r8-20020a5b06c8000000b00b3632f8852dmr6933593ybq.4.1678980724093; Thu, 16 Mar
 2023 08:32:04 -0700 (PDT)
Date:   Thu, 16 Mar 2023 15:31:54 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316153202.1354692-1-edumazet@google.com>
Subject: [PATCH v2 net-next 0/8] inet: better const qualifier awareness
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
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

inet_sk() can be changed to propagate const qualifier,
thanks to container_of_const()

Following patches in this series add more const qualifiers.

Other helpers like tcp_sk(), udp_sk(), raw_sk(), ... will be handled
in following series.

Eric Dumazet (8):
  inet: preserve const qualifier in inet_sk()
  ipv4: constify ip_mc_sf_allow() socket argument
  udp: constify __udp_is_mcast_sock() socket argument
  ipv6: constify inet6_mc_check()
  udp6: constify __udp_v6_is_mcast_sock() socket argument
  ipv6: raw: constify raw_v6_match() socket argument
  ipv4: raw: constify raw_v4_match() socket argument
  inet_diag: constify raw_lookup() socket argument

 include/linux/igmp.h        | 2 +-
 include/net/addrconf.h      | 2 +-
 include/net/inet_sock.h     | 5 +----
 include/net/raw.h           | 2 +-
 include/net/rawv6.h         | 2 +-
 include/trace/events/sock.h | 4 ++--
 include/trace/events/tcp.h  | 2 +-
 net/ipv4/igmp.c             | 4 ++--
 net/ipv4/ip_output.c        | 5 +++--
 net/ipv4/raw.c              | 4 ++--
 net/ipv4/raw_diag.c         | 2 +-
 net/ipv4/udp.c              | 4 ++--
 net/ipv6/mcast.c            | 8 ++++----
 net/ipv6/ping.c             | 2 +-
 net/ipv6/raw.c              | 2 +-
 net/ipv6/udp.c              | 6 +++---
 net/mptcp/sockopt.c         | 2 +-
 security/lsm_audit.c        | 4 ++--
 18 files changed, 30 insertions(+), 32 deletions(-)

-- 
2.40.0.rc2.332.ga46443480c-goog

