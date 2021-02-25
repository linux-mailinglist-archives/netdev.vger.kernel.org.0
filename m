Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A7F32542A
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 17:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbhBYQ7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 11:59:04 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:58799 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233132AbhBYQ6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 11:58:55 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id CDE63B00;
        Thu, 25 Feb 2021 11:58:07 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 25 Feb 2021 11:58:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LPnXkzVUwC2Wy6Is7
        nrue9wg5FBoBVBuva/rM+jSeic=; b=KQUSZpb5ZhpBeWIWHNa0HQKXAnUiK8d5R
        DoPhaTEJGcnvVwzoQGeavcW9bi9BSSOfZAb6mrScycE4hRYHvVLNLAORW2mPRmp4
        5j8DW9tQpC4KmTWumU8SqZb1GQEZkleRVhXIE9gPEWBHi28vBygceoYIdVxooaeL
        91+mkpSlgVQdPEDrSzWvxZk1T2xZUWE9oFgT+29+3MvVksVzEdbEAiwMlmiNGmBs
        Etk41iTf1w0UterjLKRlgnuWhpL6nb4tPgpiNfKyDmOy5oJXmwTx+GUgZ8GNQiUu
        CCTXkZVBWUosxL1Y5SenXZYg46ww66KKPSbDg2gQvAypnKwVmT7KA==
X-ME-Sender: <xms:Htc3YI2xdiEZ1yOySjBgTQ9myx78CxnRAOnTQuhsziU7PjNbH3DeMw>
    <xme:Htc3YDFjAB8VO3tz0O0MmNWG-i28G0n4U-YcEBrBjfgl5JdqTsiYORiMUhiljAsjj
    44xTnOltT1jnfg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeelgdeljecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheefrdeggeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Htc3YA6a1HLM3VVAFVvvVmvXUz0eNhBLSvsoexJG4gPq3ulkm_CTww>
    <xmx:Htc3YB2YuVRFPxl7M_eOGOnt3jR8SmweWHPPeTtz_h0uguTkbTc9jQ>
    <xmx:Htc3YLGWr26wREbQH0ddIkkCBidXpDM6dAXp7JLl9BUQVvPC9yk0BQ>
    <xmx:H9c3YPhL71JXQ24uF3_tSU41icmkoqv8xde5gX6R5XF1XI_MKjxLZA>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id A7FF624005B;
        Thu, 25 Feb 2021 11:58:04 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 0/3] mlxsw: Various fixes
Date:   Thu, 25 Feb 2021 18:57:18 +0200
Message-Id: <20210225165721.1322424-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset contains various fixes for mlxsw.

Patch #1 fixes a race condition in a selftest. The race and fix are
explained in detail in the changelog.

Patch #2 re-adds a link mode that was wrongly removed, resulting in a
regression in some setups.

Patch #3 fixes a race condition in route installation with nexthop
objects.

Please consider patches #2 and #3 for stable.

Danielle Ratson (2):
  selftests: forwarding: Fix race condition in mirror installation
  mlxsw: spectrum_ethtool: Add an external speed to PTYS register

Ido Schimmel (1):
  mlxsw: spectrum_router: Ignore routes using a deleted nexthop object

 drivers/net/ethernet/mellanox/mlxsw/reg.h                | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c   | 5 +++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c    | 7 +++++++
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c           | 3 ++-
 .../net/forwarding/mirror_gre_bridge_1d_vlan.sh          | 9 +++++++++
 5 files changed, 24 insertions(+), 1 deletion(-)

-- 
2.29.2

