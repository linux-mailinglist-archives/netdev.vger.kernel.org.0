Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3923505CE
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 19:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbhCaRwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 13:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234518AbhCaRwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 13:52:17 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC02C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:16 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id il9-20020a17090b1649b0290114bcb0d6c2so1597151pjb.0
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xvw2fMUskUbKwxKrR2zHT+BBqqaK6t7dZgjXigTjlq0=;
        b=GERB9hFsXoPJ5SYz7Grt02iKD0OV158K9iyxrG2HbdfrSj2DPFvyqyNFCnjnjGyyDp
         3aSXC9zqFSUwmdTPGn7xQA53D5cXiQvCMCXcVQm0ZvRDcHZKx+mG3Gl/HfGFED4ow3k0
         rh37LKfjxzhkycISHBxYDlEzaIeU4obJLkNpChcQrqBkjZJz2xiicEXbDvndnwtWdqY+
         VBgPHdsMFWdjps7ajJYmcxR3JwTfWiYD2T5w28eR3BZKLxpKPojfLPqrace1IdslY0JK
         U3qKYDl9GuaGa0b52ZpnspowmLgCOuLHOxt7AXYNZDd7zLsLkh9tgwQ3bUi8SSUkrizP
         4sJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xvw2fMUskUbKwxKrR2zHT+BBqqaK6t7dZgjXigTjlq0=;
        b=JCqKz8wZj/hYUb1eIEvLgdGMilOCvD5bE1UVS42PDw0JLeuHlm+Fi4yeSHdB4Y6Jjc
         Izo3BtTB0xEYwN7qM2eZ5knIF2XxdV7KJFsOVijxQtKDjaIDoXS4Uc6JmMF/QBiPcIDZ
         6qixpYbJ5eDnKd/1NinHLoEVZcgzoF07EgFIvbZ4qL2G7gVOxImGt8xv9uRYFA6E/ABg
         NXvOLPnfoYe1lb0Aig/UTWtvxu74W3m+6jQiOflLUrxNWf2qwl68wYkfUkNN+UFm1XPq
         XMYAsF2LQ1TKs+HEWDi6oy70Fpp/V6sVVHdQzz20mOc635qJ1RBJCYX6wYCSrBRYALBt
         jZLg==
X-Gm-Message-State: AOAM530tHZW4RJ7lbGom13rEmEG91C+ietSqm0xOTsG7cFFiMhGP4PRG
        pA8RgvsSEwtJccJuQrmc4sM=
X-Google-Smtp-Source: ABdhPJyM8JXcU9urtfpVlxXiZFI8Cw107nBovop3knRIAfRftpGmaEfqSWBD9N2m10nyoQ++xCLhNQ==
X-Received: by 2002:a17:90b:2304:: with SMTP id mt4mr4763373pjb.179.1617213136507;
        Wed, 31 Mar 2021 10:52:16 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9107:b184:4a71:45d0])
        by smtp.gmail.com with ESMTPSA id q17sm3319028pfq.171.2021.03.31.10.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 10:52:16 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/9] inet: shrink netns_ipv{4|6}
Date:   Wed, 31 Mar 2021 10:52:04 -0700
Message-Id: <20210331175213.691460-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This patch series work on reducing footprint of netns_ipv4
and netns_ipv6. Some sysctls are converted to bytes,
and some fields are moves to reduce number of holes
and paddings.

Eric Dumazet (9):
  inet: shrink inet_timewait_death_row by 48 bytes
  inet: shrink netns_ipv4 by another cache line
  ipv4: convert fib_notify_on_flag_change sysctl to u8
  ipv4: convert udp_l3mdev_accept sysctl to u8
  ipv4: convert fib_multipath_{use_neigh|hash_policy} sysctls to u8
  ipv4: convert igmp_link_local_mcast_reports sysctl to u8
  tcp: convert tcp_comp_sack_nr sysctl to u8
  ipv6: convert elligible sysctls to u8
  ipv6: move ip6_dst_ops first in netns_ipv6

 include/net/netns/ipv4.h   | 25 ++++++++++++++-----------
 include/net/netns/ipv6.h   | 28 +++++++++++++++-------------
 net/ipv4/sysctl_net_ipv4.c | 26 ++++++++++++--------------
 net/ipv6/icmp.c            | 12 ++++++------
 net/ipv6/sysctl_net_ipv6.c | 38 ++++++++++++++++++--------------------
 5 files changed, 65 insertions(+), 64 deletions(-)

-- 
2.31.0.291.g576ba9dcdaf-goog

