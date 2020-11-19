Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D462B93FC
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgKSN5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:57:50 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:49105 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727153AbgKSN5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 08:57:50 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 6251BD92;
        Thu, 19 Nov 2020 08:57:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 19 Nov 2020 08:57:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=kK3k/kivX3hPB93hu
        LGDjTpt/V8delhwB0uYB+CUX5c=; b=HOVKyEQ4bUSlgUJrq9Dp+LdgNmmZEsXZI
        Hhrhp481SJdNZQGQwB5Dq+l3bNBBY8P1zjwwrrxl7NxmhMD+SPwomdrUPPqHXGNd
        dQv9e2GWnJ8mP3mDPhaJRywHE/W2n7SAEK2+c0FfLhoQG7F0+W4Zdv57NyO61BM8
        2/icxzWiHkyMElG6AlloaZRbGJxy1rAYkfhTbhmQPflsi131cRbd7lTIEPCxz0FO
        SIm5EF9nQZwb0uZOgJpIODc9BuH/nA63FFiFbTwuH8dB18lAXqaO40B8oCljMa7q
        mhWduujCb7DIXcAJeW6YMQfnOthojv3G4LOeeQsGoOAjc9cHtnJNQ==
X-ME-Sender: <xms:3Hm2X_qkipbRzTtH-mlqLRbYz_YtzbYmSZTiLE9IdDKB04FFyBHqCA>
    <xme:3Hm2X5r2rtOdsj_dqLn2cPI2A6C0C-wIqXEFYD6jvdAe5GJyArqUI0eUZuBKH2RSp
    16Bin_YcW6x2fo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefjedgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehgedrudegjeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:3Hm2X8OzZSyoSmpSBYDZhsA0VPseLipg2wSAkvwHmqrLgbRQToriRQ>
    <xmx:3Hm2Xy4odl2sTNVj-KphmYK-t5lhSZKOo32ERW3xmm1y3F02Q-P1zw>
    <xmx:3Hm2X-4zFB4hUqQdy9TV4dZCs6vhkiwoXMxGfBC55Nks1mpilvrINQ>
    <xmx:3Xm2X0TLLOuwNTM7X2r3JuP6vJGaIrEAHtcm1pDiT-hOL3pEsiizVQ>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5BCD7328005A;
        Thu, 19 Nov 2020 08:57:47 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 0/2] ip: Nexthop flags extensions
Date:   Thu, 19 Nov 2020 15:57:29 +0200
Message-Id: <20201119135731.410986-1-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Patch #1 prints the recently added 'RTNH_F_TRAP' flag.

Patch #2 makes sure that nexthop flags are always printed for nexthop
objects. Even when the nexthop does not have a device, such as a
blackhole nexthop or a group.

Example output with netdevsim:

# ip nexthop
id 1 via 192.0.2.2 dev eth0 scope link trap
id 2 blackhole trap
id 3 group 2 trap

Example output with mlxsw:

# ip nexthop
id 1 via 192.0.2.2 dev swp3 scope link offload
id 2 blackhole offload
id 3 group 2 offload

Tested with fib_nexthops.sh that uses "ip nexthop" output:

Tests passed: 164
Tests failed:   0

Ido Schimmel (2):
  ip route: Print "trap" nexthop indication
  nexthop: Always print nexthop flags

 ip/ipnexthop.c | 3 +--
 ip/iproute.c   | 2 ++
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.28.0

