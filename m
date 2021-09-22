Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2793A4142CF
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbhIVHi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:38:56 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56577 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233059AbhIVHiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:38:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5B44B5C00C2;
        Wed, 22 Sep 2021 03:37:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 22 Sep 2021 03:37:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Z7nichfp0RqNTuBPz
        O0y9b2HXZcvDZJlUtpwa/C4mek=; b=Z+42xpRye4FUcBtRgYPFG9mI/PWvfTTDY
        wU93bIm7mDH2GZtofHskjG6xsPxovO4P/KA3Bsj8PTlUbSRkvGCMCozf7GvygHLD
        2ueRM0U6GwM/wllj1JySgtpuxK0XIOPimkV9znhJ0SiiNktcqjNZpU8Y+Ay2anEA
        sX1iGIAJEAQ/E9RAsUHXgtbdrDSezRfevbgWzeDAt4Ue/r8jw5OVDc+++5D+ewT+
        zVo1dyVMdl50oLuIbbHK/KaH1kqeBZkCx6+jOUg9AP1KwKpmFmwtSRPVv7gWJxlD
        IVMCKyBM5sakphjWOfIdWg+u2XALeitIZhszg6BTcdVp+tcTkRWtg==
X-ME-Sender: <xms:NN1KYepNGuzTTYDEnCtut4czqqmw7xNEAuhTIFSp8HQ9y1kKfpuf9w>
    <xme:NN1KYcqE4TA-p5hb17auiaG6Wh8af2ZsrxmYV1PbIQbDP8Zpt9fDqfdToZJ0ry8da
    -Laf0-lYXcie98>
X-ME-Received: <xmr:NN1KYTNe6_qZEwiXtt8FLkZx__3gmVHu0x1Qoa6mcEK2FZNAJpc2aaNHqCmr0yERRlm0Wx_SU0aF2cBypBoxn6JBbJjpIczW0rao0XL4E9dU9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiiedgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeekkefgteeguedvtdegffeitefgueeiie
    dutefhtdfhkeetteelgfevleetueeigeenucffohhmrghinhepghhithhhuhgsrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:NN1KYd5ZwKL_QPjIrpgHkKc2fSS5CMobW1_de3RtT98f7bVrv9Us7g>
    <xmx:NN1KYd57j7WMZpuIpP8ogOx89JJn314mWV4BgZjFT5B3xo_0K8F6Ag>
    <xmx:NN1KYdjN72wWINiTH9vOndgMj_cPIrP5zUEqCzwDxwtbTb2zj6v5rQ>
    <xmx:NN1KYXkWo8kCDfxtyIADAWnFDAkuaPvSq3fruMOQ8laBRQmkvobDcQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Sep 2021 03:37:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/2] mlxsw: Alter trap adjacency entry allocation scheme
Date:   Wed, 22 Sep 2021 10:36:40 +0300
Message-Id: <20210922073642.796559-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

In commit 0c3cbbf96def ("mlxsw: Add specific trap for packets routed via
invalid nexthops"), mlxsw started allocating a new adjacency entry
during driver initialization, to trap packets routed via invalid
nexthops.

This behavior was later altered in commit 983db6198f0d ("mlxsw:
spectrum_router: Allocate discard adjacency entry when needed") to only
allocate the entry upon the first route that requires it. The motivation
for the change is explained in the commit message.

The problem with the current behavior is that the entry shows up as a
"leak" in a new BPF resource monitoring tool [1]. This is caused by the
asymmetry of the allocation/free scheme. While the entry is allocated
upon the first route that requires it, it is only freed during
de-initialization of the driver.

Instead, this patchset tracks the number of active nexthop groups and
allocates the adjacency entry upon the creation of the first group. The
entry is freed when the number of active groups reaches zero.

Patch #1 adds the new entry.

Patch #2 converts mlxsw to start using the new entry and removes the old
one.

[1] https://github.com/Mellanox/mlxsw/tree/master/Debugging/libbpf-tools/resmon

Ido Schimmel (2):
  mlxsw: spectrum_router: Add trap adjacency entry upon first nexthop
    group
  mlxsw: spectrum_router: Start using new trap adjacency entry

 .../ethernet/mellanox/mlxsw/spectrum_router.c | 129 +++++++++++-------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   4 +-
 2 files changed, 81 insertions(+), 52 deletions(-)

-- 
2.31.1

