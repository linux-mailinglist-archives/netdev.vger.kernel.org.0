Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E79E7196713
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 16:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgC1Phr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 11:37:47 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33410 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgC1Phr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 11:37:47 -0400
Received: by mail-wm1-f67.google.com with SMTP id w25so9542967wmi.0
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 08:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OSD6Z/3ucVJ57g+QGYUZ+Lqzh+BiAaU+SL9Mpvd3ALk=;
        b=1ac9d7TVb0jtnDYGKcfNvZ9/Ke8nK1U+92uMSjdS7f6fRkgx4hgGL9cUmcTghZwvmr
         nr4/UPFe2BYAQmTiC17hkQ7ZnPY6miRlLIQEV7juVFn5A9ZcAm66olIzIZ7zGCt8phEW
         jXbOslYULzQUDjpmcARc+FbdbGVAGXDX2T3p5pFz2zMEn6b1FGsHPr5B5eKkmkkxQSDL
         NBdidhPAD9tWmpqG1gUdySJsXU3LSMs3WegfKlFkelha5E012wqMMFlkQ7srrWs4teHw
         Oq0oF3KymzaMsJclgkAUiCy/yrZip5AHu9fIO8Yvc5Amv+DF76fn4iYAH7SBArlNSltH
         RpvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OSD6Z/3ucVJ57g+QGYUZ+Lqzh+BiAaU+SL9Mpvd3ALk=;
        b=r8IcwykR60Nm7QNqVboPTJB3v+8kwJRbayEB1goM96v3NUxc2n2p2F96ldgF0jhl0f
         Wr13x+r6WvPeGkakFLiTySiEAudiJ9U66BQOZnuq06yH9ZzL+FHo0FjNihBRUZgCRN0O
         GDuqG2M8jm2aVHcLIB3fUoKDCe2Sl3W416fiz6MClRTjV5yh5mieCxw0iF4MXAX8i742
         zPnYRadjYBj/JsiQHUHaiRjV6R7wpU4bpuKF8b/KX3nk5YwZK16gi50epDHjx241tdvS
         bci9lRbucJWeA0CKsyA/lhf6MfZwvUW/KSPuBnn9ekL6W9WFk+vF49OgpShNvO42p/Hg
         1Xbw==
X-Gm-Message-State: ANhLgQ06L+ooUk+Ivy+eOhsfzSymntSO5hVLOx90JWsTS8vyfMEQwAez
        O04W7TnF2lN7o5jk3vPaCDSK/hqmLOA=
X-Google-Smtp-Source: ADFU+vtXbw4sJUuQZaSPUFGeyJWuzS5xkVtjdI6//kXbFgVoJwCKKe/Iv/p25uAq766BnqZmLn9EmQ==
X-Received: by 2002:a1c:51:: with SMTP id 78mr4096790wma.157.1585409864566;
        Sat, 28 Mar 2020 08:37:44 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id s2sm12813358wru.68.2020.03.28.08.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 08:37:43 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        saeedm@mellanox.com, leon@kernel.org, michael.chan@broadcom.com,
        vishal@chelsio.com, pablo@netfilter.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, paulb@mellanox.com,
        alexandre.belloni@bootlin.com, ozsh@mellanox.com,
        roid@mellanox.com, john.hurley@netronome.com,
        simon.horman@netronome.com, pieter.jansenvanvuuren@netronome.com
Subject: [patch net-next 0/2] net: sched: expose HW stats types per action used by drivers             
Date:   Sat, 28 Mar 2020 16:37:41 +0100
Message-Id: <20200328153743.6363-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The first patch is just adding a helper used by the second patch too.
The second patch is exposing HW stats types that are used by drivers.

Example:

$ tc filter add dev enp3s0np1 ingress proto ip handle 1 pref 1 flower dst_ip 192.168.1.1 action drop
$ tc -s filter show dev enp3s0np1 ingress
filter protocol ip pref 1 flower chain 0
filter protocol ip pref 1 flower chain 0 handle 0x1
  eth_type ipv4
  dst_ip 192.168.1.1
  in_hw in_hw_count 2
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1 installed 10 sec used 10 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0
        used_hw_stats immediate     <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Jiri Pirko (2):
  net: introduce nla_put_bitfield32() helper and use it
  net: sched: expose HW stats types per action used by drivers

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  2 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  3 ++-
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         |  3 ++-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  6 +++--
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  3 ++-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |  4 ++-
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |  5 ++--
 drivers/net/ethernet/mscc/ocelot_flower.c     |  3 ++-
 .../ethernet/netronome/nfp/flower/offload.c   |  3 ++-
 .../ethernet/netronome/nfp/flower/qos_conf.c  |  3 ++-
 include/net/act_api.h                         |  2 ++
 include/net/flow_offload.h                    | 12 ++++++++-
 include/net/netlink.h                         | 15 +++++++++++
 include/net/pkt_cls.h                         |  5 +++-
 include/uapi/linux/pkt_cls.h                  |  1 +
 net/sched/act_api.c                           | 27 +++++++++----------
 net/sched/cls_flower.c                        |  4 ++-
 net/sched/cls_matchall.c                      |  4 ++-
 net/sched/sch_red.c                           |  7 ++---
 20 files changed, 78 insertions(+), 37 deletions(-)

-- 
2.21.1

