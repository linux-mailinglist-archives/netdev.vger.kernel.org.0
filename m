Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38ACA1DCC57
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 13:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729089AbgEULrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 07:47:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60509 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729064AbgEULrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 07:47:00 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D151C5C00DD;
        Thu, 21 May 2020 07:46:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 21 May 2020 07:46:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yBtlBBX4zLIbGMbXk
        MglHqiOlOwCymjIyS17IU49kDE=; b=S/X0GJ39iLMOaah26Hbem+h9TbQxKo2Q0
        EIGRnn5ymfUkzH8jmQbCrZdSZ0K1wq2FgM0pA2YeJwU1MQDL2R77yKLkI0Ub0sjD
        ap1zZaVGDJlhKfXZNQ4YxePTVUCKjdbD+xapgJu4iU5nVm07aQuC7rPR6ML4U+a5
        3eEo1Kzm7ZbI1wWq7Mh8VDmmuQVdihBhEfzSINRAjlyBosLQ/YtseLVeZHj30ZX0
        Z8HUJDABzx/aMCwC40hcHxGkLhtjMGrzt/Y8rjfEHT1WCAlRRn4Bdm9HLvn5jWig
        ltR8baPUjvfa8iOS5Tihyq4DochzcWWAiWbEmOnOpsC9EU7CYddYQ==
X-ME-Sender: <xms:MmrGXhStpW8a5fvEfuFvSOzkQm7K7z0DXfV8Jh3SlzxF_WFzfbJkBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduuddggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeejledrudejiedrvdegrddutdejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:MmrGXqzFcJGS5grl3pauwANBF6SykeZ4PzSTjJtD-VLqvjcDbt_dHw>
    <xmx:MmrGXm0KjZg5biuiIpvT_rBYdRqDfmGlu7xznYQg62qqxMtEx0OO2Q>
    <xmx:MmrGXpDKyhJRZnWDMnMJtMkwf0KkmQCP9RRIGVP-pbGfJRIvTB3dOQ>
    <xmx:MmrGXuaXGjIFCTVtbPrxtgO9YnQyI7NZCtE-E0Z2pfyy_caXboDXVA>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D3E8306647A;
        Thu, 21 May 2020 07:46:57 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 0/2] netdevsim: Two small fixes
Date:   Thu, 21 May 2020 14:46:15 +0300
Message-Id: <20200521114617.1074379-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Fix two bugs observed while analyzing regression failures.

Patch #1 fixes a bug where sometimes the drop counter of a packet trap
policer would not increase.

Patch #2 adds a missing initialization of a variable in a related
selftest.

Ido Schimmel (2):
  netdevsim: Ensure policer drop counter always increases
  selftests: netdevsim: Always initialize 'RET' variable

 drivers/net/netdevsim/dev.c                                   | 3 +--
 tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh | 4 ++++
 2 files changed, 5 insertions(+), 2 deletions(-)

-- 
2.26.2

