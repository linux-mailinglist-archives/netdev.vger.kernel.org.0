Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D583078BB
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhA1OwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:52:21 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:39465 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232432AbhA1OuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 09:50:06 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id E2E85F77;
        Thu, 28 Jan 2021 09:48:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 28 Jan 2021 09:48:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7jlTi9/52sY66VfOJ
        xy11dnj6NtiFrqVyzfAmcPFbr0=; b=HrJrS7f79590w1i6UfkgNAOgQddgPjrYn
        DyJQsHtLRsu7C37QVza4J0JXPhxCP3WjiTbntWMVhBekWHRaX3ncUPCIzPwNkVFP
        UlR59vPOsoY1T2DqqGdpsF6cZcDraiFjEgNjYm0dYYvaDZaMtCAgpuZXjcCsPUjm
        SRvU7aloLiBchBnGb4FLXEIXrWMbMSiCIMBv6ZYWHzQy6Ja97OGDQGNbjpDVk4pI
        k8K56BYOLaW195kF/CB2AqJCXALq1Q1/B+yAJgIYxIruGbUOtsG4ARkw4NvuAYxW
        hc3fneXU28PZHg9rOP1UviJfNA3pxLnTKm2ZCrK4ux52dA/zHqb4w==
X-ME-Sender: <xms:184SYEwrOaMKXosk-SV6XuBjI_ziGM2J1l_NNtYQsXzI6rrKm3HaoQ>
    <xme:184SYITTQ_ageJ4Sh4aICEdD4hLWmRpILQKj4Z2j1hMWYdDrSzOTWg2APq1cjfDop
    3Zt5r5Wbc8ghBU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheefrdeggeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:184SYGX_-TcUOsnrKhTBc7mJgZhQbiA9s1_ngs2Odk7OeJ2OoDLfvQ>
    <xmx:184SYCjo5bwryJ8TvpTVCA2XwNghzTFnnZWdPiasijVhdqRmQoKlBQ>
    <xmx:184SYGCNm-08nY4nSBuTVU37Ap7btfcLBDfm-kDeT3v1v_a4VGnxhA>
    <xmx:184SYBNIG1r6vgaxSDiVTKQR3oIzGNEa0iwWfUnvzVnB_2DLj3keqQ>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5207824005B;
        Thu, 28 Jan 2021 09:48:53 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 0/2] mlxsw: Various fixes
Date:   Thu, 28 Jan 2021 16:48:18 +0200
Message-Id: <20210128144820.3280295-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Patch #1 fixes wrong invocation of mausezahn in a couple of selftests.
The tests started failing after Fedora updated their libnet package from
version 1.1.6 to 1.2.1. With the fix the tests pass regardless of libnet
version.

Patch #2 fixes an issue in the mirroring to CPU code that results in
policer configuration being overwritten.

Danielle Ratson (1):
  selftests: forwarding: Specify interface when invoking mausezahn

Ido Schimmel (1):
  mlxsw: spectrum_span: Do not overwrite policer configuration

 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c        | 6 ++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h        | 1 +
 tools/testing/selftests/net/forwarding/router_mpath_nh.sh  | 2 +-
 tools/testing/selftests/net/forwarding/router_multipath.sh | 2 +-
 4 files changed, 9 insertions(+), 2 deletions(-)

-- 
2.29.2

