Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3031B26B8AC
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgIPAsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:48:33 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50679 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726140AbgIOLm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 07:42:26 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D380C5C015B;
        Tue, 15 Sep 2020 07:41:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 15 Sep 2020 07:41:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=UIEIk0xcoyFWY889d
        L+w1yRGzVyjzLPZ8YLO16chzhk=; b=oCWuFhqHemyB0Pt2aX4o4JiWwxfmtyOmq
        LiwXwQ8SX75KFkJirDw8xJX3fogPIno9/fBdsBEOEsGcdFGicXW6K5l4HHkSI8u3
        tVoWrJRGOlLsB4JId3V1W2LRddpi3CdaY0gzWO0S5biAu8ao7aLF3ne6YOxsaHsL
        SzB4luaF4JXqoARN04PFkx3HwEyJEPV78zxw6ThfKsVPw0o5xyh+lwpbde3RTqRE
        +OAHLYQgqA1BoPi0Efp8zuIa+Qy3A7e07sEPh8cFajPAbZ3GKdd0UxdZWQW+cJAj
        fet7Zs5oGuJ3K4+iA5rISP1x07fsDO7+5b0uYU3e3OSAx8v02Y2VA==
X-ME-Sender: <xms:fahgX6LQ_izIpzg3ncEHmxnzTSehz_0i44zipo3K8C0l8pE8HukERg>
    <xme:fahgXyJ9PjGkznnimqVwbT1S3cN10ijczyfZiOshN358RVL-Op96ZWHqPsQ2u1ONZ
    an_sp-Ea5gmdYE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddtgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeelueffueekjeetuefgvdfgtdehfefgjedute
    fhtdevueejvdekgfduvdduhfejfeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecu
    kfhppeekgedrvddvledrfeeirdekvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:fahgX6srwOrx0owhTgsZ4JqPV77ExzJ7G7zu3emAFozSoCQbWErL_w>
    <xmx:fahgX_allWtsOp6vETahQBsisR1qY7TWEyXuWppEaUoU8L6sfN6mGw>
    <xmx:fahgXxZy3tBM_Gx8IFc81CElcULPpTs60YvXXPKwlDftL3SWrwFfEQ>
    <xmx:fahgXwlsgfkdjS7zJzpx4ukcXJARy6gRCc3SSsvN4EuVCwEQcvjEWg>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id EEBEF3064685;
        Tue, 15 Sep 2020 07:41:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/5] nexthop: Small changes
Date:   Tue, 15 Sep 2020 14:40:58 +0300
Message-Id: <20200915114103.88883-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patch set contains a few small changes that I split out of the RFC
I sent last week [1]. Main change is the conversion of the nexthop
notification chain to a blocking chain so that it could be reused by
device drivers for nexthop objects programming in the future.

Tested with fib_nexthops.sh:

Tests passed: 164
Tests failed:   0

[1] https://lore.kernel.org/netdev/20200908091037.2709823-1-idosch@idosch.org/

Ido Schimmel (5):
  nexthop: Remove unused function declaration from header file
  nexthop: Remove NEXTHOP_EVENT_ADD
  nexthop: Convert to blocking notification chain
  nexthop: Only emit a notification when nexthop is actually deleted
  selftests: fib_nexthops: Test cleanup of FDB entries following nexthop
    deletion

 include/net/netns/nexthop.h                 |  2 +-
 include/net/nexthop.h                       |  4 ----
 net/ipv4/nexthop.c                          | 17 +++++++++--------
 tools/testing/selftests/net/fib_nexthops.sh | 14 ++++++++++++++
 4 files changed, 24 insertions(+), 13 deletions(-)

-- 
2.26.2

