Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384D3524116
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349377AbiEKXiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349372AbiEKXiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:38:03 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F57A6D951
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:02 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c14so3287866pfn.2
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q2BEUsuN7lWwuAwtSb/HPXVIIsz5PGNoh2uZkIjmIL4=;
        b=Jq4AfO/jDB/InVV46vqCHn+MB+32tvZhFbTUWwl+ippF/tpS4AkQRi9zkXZmcn+11E
         6/13MUj2bbeA4Oq9xGBbzRp1/4BJGg9NPrDwwkgs0P/0QKlVKXXQXhkunW4L7lZvNVpM
         qcJOKIk5QeVh+XMZgY9Wa7co5bX5fkt0AFaBntyW8AsJjm/arXxsLoisV0qXqSeh33TU
         cVhKqdOkfP4fz+8sNjH6I1Scwzu11HJx2FHxPxPvQNgf2q/wVv7G+lW7awY7gb5h3U4W
         S2T3CMOYO+khFsVmV5KPdshr05RPLdNsQeoVBvbh27S5u2hEnG/t1OvhpwS43nyeAhDe
         c/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q2BEUsuN7lWwuAwtSb/HPXVIIsz5PGNoh2uZkIjmIL4=;
        b=wU2c8YUC4mIbPDlxK6r6ezMd2UkN6HogOELvpr17o6NHO+qkdH/77K5DIQwc8G+LJb
         ITzRhpAtsUUpg4C4EKPK8onD+dwOoQunDdZhoN2c6TFPRAePQ+YBWarIGlp+WPnvoBAe
         FDn571QH0lFHLd3rJtv5P42BAxepmjT5SQNJW8xy2FrmRThzqqK48AWIE6MQIP3Kn2nu
         YYLu3jSf7218kQZEa4fkG2FDXBYL2msv0hv3b+OSfrIffx0o29E+mNkblnadrmyx0m/S
         oVyEVuUf/cnY3K5WMhxQHMzP8lkDM1coivTMFBLlHPFnqun82xh8U1ycNePeD+yE3Rnr
         SR4w==
X-Gm-Message-State: AOAM531w5pgEs1SrP7lDUfuRALehHP95Tvchb4B1G22eOwdP5nZaM/H3
        0UdJrTW5l6DmwWXqhZpkwdE=
X-Google-Smtp-Source: ABdhPJyoP4VUcV0ug2439Lhv66pUHgYOCn8ny3pTu5H4X22ZlZlnssAj1/sYXGjwF95Aajfb0rp4Og==
X-Received: by 2002:aa7:888c:0:b0:505:7832:98fc with SMTP id z12-20020aa7888c000000b00505783298fcmr26739763pfe.0.1652312281758;
        Wed, 11 May 2022 16:38:01 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4ded:7658:34ff:528e])
        by smtp.gmail.com with ESMTPSA id x6-20020a623106000000b0050dc76281acsm2308668pfx.134.2022.05.11.16.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 16:38:01 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 00/10] net: add annotations for sk->sk_bound_dev_if
Date:   Wed, 11 May 2022 16:37:47 -0700
Message-Id: <20220511233757.2001218-1-eric.dumazet@gmail.com>
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

While writes on sk->sk_bound_dev_if are protected by socket lock,
we have many lockless reads all over the places.

This is based on syzbot report found in the first patch changelog.

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
  inet: add READ_ONCE(sk->sk_bound_dev_if) in INET_MATCH()

 include/net/inet6_hashtables.h  | 25 +++++++++++-----
 include/net/inet_hashtables.h   | 52 ++++++++++++++++++++++++---------
 include/net/inet_sock.h         |  5 ++--
 include/net/ip.h                |  2 +-
 include/net/sock.h              |  5 ++--
 net/core/sock.c                 | 11 ++++---
 net/dccp/ipv4.c                 |  2 +-
 net/dccp/ipv6.c                 |  4 +--
 net/ipv4/inet_connection_sock.c | 12 +++++---
 net/ipv6/datagram.c             |  6 ++--
 net/ipv6/udp.c                  | 11 +++----
 net/l2tp/l2tp_ip.c              |  4 ++-
 net/l2tp/l2tp_ip6.c             |  8 +++--
 net/sched/em_meta.c             |  7 +++--
 net/sctp/input.c                |  4 ++-
 15 files changed, 105 insertions(+), 53 deletions(-)

-- 
2.36.0.512.ge40c2bad7a-goog

