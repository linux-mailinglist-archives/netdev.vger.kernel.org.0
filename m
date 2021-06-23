Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174243B156A
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 10:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhFWILP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 04:11:15 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:52051 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229920AbhFWILO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 04:11:14 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 320245805A2;
        Wed, 23 Jun 2021 04:08:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 23 Jun 2021 04:08:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=m98Jzuc367jxXvbeE
        hg9koiEhwLhRzYcHLurko353sg=; b=JRo/7vCUsUiIezXzVmgIH4QikiBU6KeDh
        NOmD5ac7EfbdgTmlnMKkV0TjbzcPVN7n5Wyx8ok+aWKo5Nr/XVPKkLTMItwB3yjk
        /Any05X9eFs0yDjY2dJnDVeWHXqGxV/lv6Zzmy7hJdDhF6f/adqk87ekQQroAWaH
        VV4dMODaES433CcBS2v9h0ouUdzqpovfTUX6PDDhrhs6iQRRli+/nCgKPRxTHYKP
        RCJZmHJkPAu0F4NiZruBPAmhCUId+HhX9suOVAlXhWaT7KFrwdwib4N/oI/A9tTb
        O1faYd5YI2NUhOSDsgATvIa8ssRz3mWtJdDfmONsmN5hS5GX1k3gg==
X-ME-Sender: <xms:GOzSYPr_l-8mOTZxuPB6Xonz7KHtB-fHTK96kbKozL_HNr-2TAwUrw>
    <xme:GOzSYJq1IKK0V2OTT7mCGCOYaT-1LQwzP3JY8Jicj4LgeNn5fs73lT87sRWId3_M2
    0Aro_iL3e8usJY>
X-ME-Received: <xmr:GOzSYMMGblgx2s_kgrvT-602Pg5xK3yUN9q-YsrnWh0WpK26-3zgWvEfyu-crJt0GJz4j15th8AMY0d6l24N1mDcLCmXI-EbnpI3a05HXknZMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegfedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepleeuffeukeejteeugfdvgfdtheefgfejud
    ethfdtveeujedvkefguddvudfhjeefnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:GOzSYC5_kxtpx9Bvgrm9wFYZu4en5OO8nS9yp6VVG1o6WHGrnybHVQ>
    <xmx:GOzSYO4-vKAcW1WHfR-W9uf3Op1M2Z5-DGd9wIE2JgVkRPuVYbvKyA>
    <xmx:GOzSYKg7_3hj8fZGivX3GEDH5ffbEXZSHOX6XScENE3EKIlTYmbk6A>
    <xmx:GezSYAsmCLjUR8o-XqDRt7NKvAqSR2JZ7D3rz9JvScohMVz8Hft3og>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Jun 2021 04:08:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, vladyslavt@nvidia.com, moshe@nvidia.com,
        vadimp@nvidia.com, mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next 0/2] ethtool: Add ability to write to transceiver module EEPROMs
Date:   Wed, 23 Jun 2021 11:08:23 +0300
Message-Id: <20210623080825.2612270-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Patch #1 updates the UAPI headers.

Patch #2 adds the actual implementation. See the commit message for
example output.

Patches are on top of [1] which are currently under review.

Refer to [2] for more background information.

[1] https://patchwork.kernel.org/project/netdevbpf/cover/1623949504-51291-1-git-send-email-moshe@nvidia.com/
[2] https://patchwork.kernel.org/project/netdevbpf/cover/20210623075925.2610908-1-idosch@idosch.org/

Ido Schimmel (2):
  Update UAPI header copies
  ethtool: Add ability to write to transceiver module EEPROM

 ethtool.8.in                 |  29 ++++++++
 ethtool.c                    |  10 +++
 netlink/desc-ethtool.c       |   2 +
 netlink/extapi.h             |   2 +
 netlink/module-eeprom.c      | 125 ++++++++++++++++++++++++++++++++++-
 netlink/monitor.c            |   4 ++
 netlink/netlink.h            |   1 +
 uapi/linux/ethtool.h         |   4 +-
 uapi/linux/ethtool_netlink.h |   4 +-
 uapi/linux/if_link.h         |   9 +++
 uapi/linux/netlink.h         |   5 +-
 11 files changed, 188 insertions(+), 7 deletions(-)

-- 
2.31.1

