Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53A4B17BE67
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCFN3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:29:01 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:55331 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgCFN3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 08:29:01 -0500
Received: by mail-wm1-f45.google.com with SMTP id 6so2409584wmi.5
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 05:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dd0L2we/1/kHfw5nKL1a01Zv4R7GevH5IPYmNN4s4L0=;
        b=tzxSRfOKhCeghX6fLB+MTFwY7lgn6BLNj1XIgCy92vMQbKk4OsmbhqcPBLN+QQ4uOG
         +UMJ4U8jmAEh6/R+9elNBABuwHAwZZpTxLCSnHIomaztd16hGy8WL/4SzmTJu1/zLLlO
         3tPTVfIcPgHPHtidGXa1tSUoBdDqBRamUYxJWGy8D+yIJBchs2ymkGOoaqAb2gJaME/O
         TI1aSGuztFFMRaDO2Mq5DSGxqPkUZ1wlsIYNVNIseZHM6JoTqodkTcKJfD1+K71zxN6q
         ItQWJTx7fux1t9gwxg3cvs+bkHTTwx4LzmrTQp5RsMlGxMh9K0tzElJodSvitLEKSaee
         mbFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dd0L2we/1/kHfw5nKL1a01Zv4R7GevH5IPYmNN4s4L0=;
        b=e3lnJbz95du2cy70iro4EJJyeyziZltLT/oEsJUAGOaMVxWQ9a3G+4D5EuXqk8kkdq
         yPWiV5YrNgNhg/tVsQ/ArNfZRR1HpcxoAfl67EmjO1pys7s1gLJJv/vdiX9DLgFhnljl
         6qJQUdzAfr7UIuttmlK8Duk7EbKnVrYRf0tr+ySfIuWVKjYuaze7r/rQGMweud/olHck
         38WwF5DUMWYQUgCSAr4pCUEK1ZakraIbxaTTcQ2ZG3fkKvG4QraNr/tdqzX0iq169T6w
         OyBAgNcFDYkAzagzUBdw6Xq3MriZuGtnXegI0CceZd69mbdeLa/RIF4anadMGnJJwEMz
         daSA==
X-Gm-Message-State: ANhLgQ1jokmqzQAVZLj8JY+YERCB0caIRVJESi+FNp6oSb4fVTNJqcvj
        2Sc1khEd8LH0jrHM4IuOT7QGXDFCGsM=
X-Google-Smtp-Source: ADFU+vtQk/zdlWLkV2iPRf0eyu/eWqopMjwmzQBxQfFvpeG6lRQ66qGQfXo8bypnvoJPl+SYYc5A9w==
X-Received: by 2002:a1c:8090:: with SMTP id b138mr4209582wmd.55.1583501338263;
        Fri, 06 Mar 2020 05:28:58 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h17sm50138268wro.52.2020.03.06.05.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 05:28:57 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v3 00/10] net: allow user specify TC action HW stats type
Date:   Fri,  6 Mar 2020 14:28:46 +0100
Message-Id: <20200306132856.6041-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when user adds a TC action and the action gets offloaded,
the user expects the HW stats to be counted and included in stats dump.
However, since drivers may implement different types of counting, there
is no way to specify which one the user is interested in.

For example for mlx5, only delayed counters are available as the driver
periodically polls for updated stats.

In case of mlxsw, the counters are queried on dump time. However, the
HW resources for this type of counters is quite limited (couple of
thousands). This limits the amount of supported offloaded filters
significantly. Without counter assigned, the HW is capable to carry
millions of those.

On top of that, mlxsw HW is able to support delayed counters as well in
greater numbers. That is going to be added in a follow-up patch.

This patchset allows user to specify one of the following types of HW
stats for added action:
immediate - queried during dump time
delayed - polled from HW periodically or sent by HW in async manner
disabled - no stats needed

Note that if "hw_stats" option is not passed, user does not care about
the type, just expects any type of stats.

Examples:
$ tc filter add dev enp0s16np28 ingress proto ip handle 1 pref 1 flower skip_sw dst_ip 192.168.1.1 action drop hw_stats disabled
$ tc -s filter show dev enp0s16np28 ingress
filter protocol ip pref 1 flower chain 0 
filter protocol ip pref 1 flower chain 0 handle 0x1 
  eth_type ipv4
  dst_ip 192.168.1.1
  skip_sw
  in_hw in_hw_count 2
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1 installed 7 sec used 2 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0) 
        backlog 0b 0p requeues 0
        hw_stats disabled

$ tc filter add dev enp0s16np28 ingress proto ip handle 1 pref 1 flower skip_sw dst_ip 192.168.1.1 action drop hw_stats immediate
$ tc -s filter show dev enp0s16np28 ingress
filter protocol ip pref 1 flower chain 0
filter protocol ip pref 1 flower chain 0 handle 0x1
  eth_type ipv4
  dst_ip 192.168.1.1
  skip_sw
  in_hw in_hw_count 2
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1 installed 11 sec used 4 sec
        Action statistics:
        Sent 102 bytes 1 pkt (dropped 1, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 102 bytes 1 pkt
        backlog 0b 0p requeues 0
        hw_stats immediate

Jiri Pirko (10):
  flow_offload: Introduce offload of HW stats type
  ocelot_flower: use flow_offload_has_one_action() helper
  flow_offload: check for basic action hw stats type
  mlxsw: spectrum_flower: Do not allow mixing HW stats types for actions
  mlxsw: restrict supported HW stats type to "any"
  flow_offload: introduce "immediate" HW stats type and allow it in
    mlxsw
  flow_offload: introduce "delayed" HW stats type and allow it in mlx5
  mlxsw: spectrum_acl: Ask device for rule stats only if counter was
    created
  flow_offload: introduce "disabled" HW stats type and allow it in mlxsw
  sched: act: allow user to specify type of HW stats for a filter

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  9 ++-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  8 ++-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.h  |  3 +-
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         |  3 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.c    |  6 ++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 11 +++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  3 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 26 ++++---
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 17 +++--
 drivers/net/ethernet/mscc/ocelot_flower.c     |  6 +-
 .../ethernet/netronome/nfp/flower/action.c    |  4 ++
 .../net/ethernet/qlogic/qede/qede_filter.c    | 10 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   |  9 ++-
 include/net/act_api.h                         |  4 ++
 include/net/flow_offload.h                    | 68 +++++++++++++++++++
 include/uapi/linux/pkt_cls.h                  | 22 ++++++
 net/dsa/slave.c                               |  4 ++
 net/sched/act_api.c                           | 36 ++++++++++
 net/sched/cls_api.c                           |  7 ++
 19 files changed, 230 insertions(+), 26 deletions(-)

-- 
2.21.1

