Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9765437D3
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244765AbiFHPqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244739AbiFHPqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:46:45 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9380B22514
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 08:46:44 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id e11so18670790pfj.5
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 08:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IpeZJkZSSxE3Nfz4pBUIcaCRbxWTK+oDRnfbp+XVyc0=;
        b=bLk/ZjQUmRLl9Zaw01MlY4OUy0QrnOehkOKmwsvnQCFt0SlsyvkdNRwKQMFOOHR14x
         Zbi0YeicKf+kfYjS4YpuqHA9hukOtz3EZp/JMScFcbq4SlwlQVJcCqqpi1ilaU9Zz51r
         U0Kvur8kelqbSSpbmGRy+qVx1A0AHgOXmHcnPk82ZKQ5LbjOKKWA6tOIOCOuVTSKqgMI
         b3RPkk6mMplP244/JFY94aQ6ZmUQI05e3Cu0fqOqN3bwkTuDzuyJ3oQgO8ryflrFyEsv
         utEAeMiB8TAvvArdt3B/U91DDp3bawTDWWaUQiCB9WBKWq1meD6TvAFFOnX+4tZyNyce
         SG1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IpeZJkZSSxE3Nfz4pBUIcaCRbxWTK+oDRnfbp+XVyc0=;
        b=5RUBAZqGxv7uTN85hIaDKe/MjWG8lP45O4FrlFbeMbb0/SKJ94ryNXd3mONo9RdNa+
         xgIBYiXIA4nvXLDSjDCZxnoHl1zfPJLiCVFlFEc/kMOH08fHIx6wjVwjPjkIfyx8t4XX
         oeu5i+PJ/+21JgviklxAlpFSVGLT8IKgN+6bql0/6sroN0Jafid21Ia93JziLCexno1+
         duKPC7hkv8HU6O913ng3JGjoljC6T2RukEimx3uY6MigbMZytXIh9QTW5rx2d7zPQfjW
         gFaBvsPjVB+8E7bfT6NbDZ02/Mjudx5gF1xRLNFSTcAteb1oaXlc/UMkAjICmkyn/DXJ
         EaPw==
X-Gm-Message-State: AOAM531bXOlZrgJvpAJvMW8RI6nesgu76UMC3T8w1to8DAjRTCbZzeIr
        QnOAmO4ziYyrvI3zI+Ru0iA=
X-Google-Smtp-Source: ABdhPJxy++7Al1NWeX4DuiMTByaRpGic52rKounXTsV5NJ3QdWxi/y4bn48mNEdngbRWYeCXk/gh4Q==
X-Received: by 2002:aa7:9475:0:b0:51b:e0c5:401a with SMTP id t21-20020aa79475000000b0051be0c5401amr28467651pfq.39.1654703204000;
        Wed, 08 Jun 2022 08:46:44 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id a10-20020a056a001d0a00b0051be2ae1fb5sm10885973pfx.61.2022.06.08.08.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 08:46:43 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 0/9] net: adopt u64_stats_t type
Date:   Wed,  8 Jun 2022 08:46:31 -0700
Message-Id: <20220608154640.1235958-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
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

While KCSAN has not raised any reports yet, we should address the
potential load/store tearing problem happening with per cpu stats.

This series is not exhaustive, but hopefully a step in the right
direction.

v2: change title in wireguard patch, and fix cover letter title.

Eric Dumazet (9):
  vlan: adopt u64_stats_t
  ipvlan: adopt u64_stats_t
  sit: use dev_sw_netstats_rx_add()
  ip6_tunnel: use dev_sw_netstats_rx_add()
  wireguard: receive: use dev_sw_netstats_rx_add()
  net: adopt u64_stats_t in struct pcpu_sw_netstats
  devlink: adopt u64_stats_t
  drop_monitor: adopt u64_stats_t
  team: adopt u64_stats_t

 drivers/net/ipvlan/ipvlan.h      | 10 ++++-----
 drivers/net/ipvlan/ipvlan_core.c |  6 +++---
 drivers/net/ipvlan/ipvlan_main.c | 18 ++++++++--------
 drivers/net/macsec.c             |  8 +++----
 drivers/net/macvlan.c            | 18 ++++++++--------
 drivers/net/team/team.c          | 26 +++++++++++------------
 drivers/net/usb/usbnet.c         |  8 +++----
 drivers/net/vxlan/vxlan_core.c   |  8 +++----
 drivers/net/wireguard/receive.c  |  9 +-------
 include/linux/if_macvlan.h       |  6 +++---
 include/linux/if_team.h          | 10 ++++-----
 include/linux/if_vlan.h          | 10 ++++-----
 include/linux/netdevice.h        | 16 +++++++-------
 include/net/ip_tunnels.h         |  4 ++--
 net/8021q/vlan_core.c            |  6 +++---
 net/8021q/vlan_dev.c             | 18 ++++++++--------
 net/bridge/br_netlink.c          |  8 +++----
 net/bridge/br_vlan.c             | 36 ++++++++++++++++++--------------
 net/core/dev.c                   | 18 ++++++++--------
 net/core/devlink.c               | 28 ++++++++++++++-----------
 net/core/drop_monitor.c          | 18 ++++++++--------
 net/dsa/slave.c                  |  8 +++----
 net/ipv6/ip6_tunnel.c            |  7 +------
 net/ipv6/sit.c                   |  8 +------
 24 files changed, 151 insertions(+), 161 deletions(-)

-- 
2.36.1.255.ge46751e96f-goog

