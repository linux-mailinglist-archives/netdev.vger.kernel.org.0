Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F24A3FA53D
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbhH1LJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbhH1LJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:06 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30766C061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:16 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g22so13808189edy.12
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b7u9LLGm2J5o0p61JK0IC82IxoSdlmhTufcLMmB24TI=;
        b=MchGSamS9Z8lkKyp/mENL7aX4OmPsXDKvnP7V1Tv+gCg8N1WsYRzc3nUF+KwIqPdqk
         age8mvRRusRPBVCs5yiZ+KLGJ+rOgTzWCNwledKQxcBD50cBP9D0uVj27tho8Ll9WX6t
         YLrA8rXLSF0pkzr7wpHf4HM4sBYPGagnqfF1C8DcUoqDbGhLWKdMOI64DYsrDMBmOti1
         SmTCnXK9hXkLNGeli07GdQkCmRT8QmtQkn/gBKbPCHvH1feGOJDoEVMnXI83dEckDk6J
         /+rrYbjfxz8BN9mqRfAtzFKyUaTu6JghOMhOoOzAtKSA9VoZyeQCGCbQnjbEIuKaVhpj
         EuvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b7u9LLGm2J5o0p61JK0IC82IxoSdlmhTufcLMmB24TI=;
        b=T3pGjtNLeV73YS/A7R3OsBWLYqnhHx3Ya84DhjhsvIn3GdRkNeeX4Pv6o3to0PYpv0
         7UzXUmuOmhwp/N7YVGw4k+glpRAa2vpDgL/UL0ojZGsAO0dHlMy47XQaAMP6/JWtN6qa
         azxCF/qidKAEThM7t5XK+MN0FXNmbVME6K4hxcx4M6vMF63xW/Fkhbt2eXapNtH2dGiI
         akJyu9G3AmZ7aEEz6XGdBODwzM0qTG8I9RuSSDYiVErAT/DCa/H1j2UvANO5z55++UgP
         Yo+sIMN2sPB0Rtan6XMEuJRn1TDfcn1vC/1GJ/5FlVJv8YoB6ei6ngU6UquTVuzFChpy
         HR9g==
X-Gm-Message-State: AOAM532BPQ6TfUQaYmggb7dJNqm0PQ9fSin8XzXuHGtudA7w6ADQqTv4
        6nb9h1N9+oUSCbccnnGpmucVW7p8xidYQcBv
X-Google-Smtp-Source: ABdhPJwmIl2jZ80ZYwGzgkokeaDj2AzmYdQVVXWcmYtcpJzAsYKXHQIn9D47DIvlUj6IIpui83koNg==
X-Received: by 2002:a05:6402:2317:: with SMTP id l23mr14577098eda.265.1630148894377;
        Sat, 28 Aug 2021 04:08:14 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:13 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 00/19] bridge: vlan: add global multicast options
Date:   Sat, 28 Aug 2021 14:07:46 +0300
Message-Id: <20210828110805.463429-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi all,
This set adds support for vlan multicast options. The feature is
globally controlled by a new bridge option called mcast_vlan_snooping
which is added by patch 01. Then patches 2-5 add support for dumping
global vlan options and filtering on vlan id. Patch 06 adds support for
setting global vlan options and then patches 07-18 add all the new
global vlan options, finally patch 19 adds support for dumping vlan
multicast router ports. These options are identical in meaning, names and
functionality as the bridge-wide ones.

All the new vlan global commands are under the global keyword:
 $ bridge vlan global show [ vid VID dev DEVICE ]
 $ bridge vlan global set vid VID dev DEVICE ...

I've added command examples in each commit message. The patch-set is a
bit bigger but the global options follow the same pattern so I don't see
a point in breaking them. All man page descriptions have been taken from
the same current bridge-wide mcast options. The only additional iproute2
change which is left to do is the per-vlan mcast router control which
I'll send separately. Note to properly use this set you'll need the
updated kernel headers where mcast router was moved from a global option
to per-vlan/per-device one (changed uapi enum which was in net-next).

Example:
 # enable vlan mcast snooping globally
 $ ip link set dev bridge type bridge mcast_vlan_snooping 1
 # enable mcast querier on vlan 100
 $ bridge vlan global set dev bridge vid 100 mcast_querier 1
 # show vlan 100's global options
 $ bridge -s vlan global show vid 100
port              vlan-id
bridge            100
                    mcast_snooping 1 mcast_querier 1 mcast_igmp_version 2 mcast_mld_version 1 mcast_last_member_count 2 mcast_last_member_interval 100 mcast_startup_query_count 2 mcast_startup_query_interval 3125 mcast_membership_interval 26000 mcast_querier_interval 25500 mcast_query_interval 12500 mcast_query_response_interval 1000

A following kernel patch-set will add selftests which use these commands.

v2: all patches use strcmp instead of matches
    patches 02, 03 which prepare print_vlan_rtm for global show are new
    previous patch 02 is split in patches 02, 03 and 04
    patches 07-18 have their help msg alignment adjusted to fit in 100
    characters

Thanks,
 Nik


Nikolay Aleksandrov (19):
  ip: bridge: add support for mcast_vlan_snooping
  bridge: vlan: factor out vlan option printing
  bridge: vlan: skip unknown attributes when printing options
  bridge: vlan: add support to show global vlan options
  bridge: vlan: add support for vlan filtering when dumping options
  bridge: vlan: add support to set global vlan options
  bridge: vlan: add global mcast_snooping option
  bridge: vlan: add global mcast_igmp_version option
  bridge: vlan: add global mcast_mld_version option
  bridge: vlan: add global mcast_last_member_count option
  bridge: vlan: add global mcast_startup_query_count option
  bridge: vlan: add global mcast_last_member_interval option
  bridge: vlan: add global mcast_membership_interval option
  bridge: vlan: add global mcast_querier_interval option
  bridge: vlan: add global mcast_query_interval option
  bridge: vlan: add global mcast_query_response_interval option
  bridge: vlan: add global mcast_startup_query_interval option
  bridge: vlan: add global mcast_querier option
  bridge: vlan: add support for dumping router ports

 bridge/br_common.h    |   4 +-
 bridge/mdb.c          |   6 +-
 bridge/monitor.c      |   2 +-
 bridge/vlan.c         | 547 +++++++++++++++++++++++++++++++++++++-----
 ip/iplink_bridge.c    |  29 +++
 man/man8/bridge.8     | 130 ++++++++++
 man/man8/ip-link.8.in |   8 +
 7 files changed, 660 insertions(+), 66 deletions(-)

-- 
2.31.1

