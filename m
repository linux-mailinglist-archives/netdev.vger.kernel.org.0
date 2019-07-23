Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE82713C9
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 10:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729919AbfGWITh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 04:19:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45637 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726405AbfGWITh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 04:19:37 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0EC82220CB;
        Tue, 23 Jul 2019 04:19:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 23 Jul 2019 04:19:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DtvSMw0ZSXLmmBYfr
        xjp/o+CXUIsLa2t3rpFVaawb2U=; b=RCY7lg9DsdKvaFk1zmMJGlWmjuynw0hoy
        z2D/LIXZxgvyECfsQqX0G2zRxAl/mMgmn6Jrj9vTTO0xuXAirV8d0G+Rk3wjqcje
        p8/tK75Gq4YSLcx7CFtzF4ObZpWdXIuBfmSumSWlywwp5gRCxyaVSpU7T7f8SH6M
        hFTQO9ebavzE2sn5HAwjAu6BY2jGykStRjlwd6XOC4v7KTPGO7JNLl2ty8p6qGGh
        dXbPd5TnDuy4XYgN0AiIosemUUS1WIR958PxeRQp4dh2tYZwq9Zcvfa3VLgcIqUo
        4tJ7FCd3PYtpwVU4f+zjrPYUFWtRwWWHoSfkfNPI2g3LI8/Culv6A==
X-ME-Sender: <xms:F8M2XXi9fxxld7Tqy_6rJQjkwsPX1qeso0j-riFu5HPuWMMYJpHwqw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:F8M2XeQu_a2_4-aLsR2Nc8rQbenPjF-G5PBDd8iNi4kcG9YR44Ya7A>
    <xmx:F8M2XchqRhwwpqVWBa66pmlwlH0L8gIsGWnc3wRD5Wk-9mWfYBgQ5w>
    <xmx:F8M2XahG6nhervPmpg2Z7uQhjv1tlX38zYnX2JHlF5rg6QKtG6SSAQ>
    <xmx:GMM2XZuDhrmk8gnTAhbFMDJONRJ_MyKSYeFMRaYOvoyu6_Z00dflSw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 95800380084;
        Tue, 23 Jul 2019 04:19:34 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, ssuryaextr@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 0/2] selftests: forwarding: GRE multipath fixes
Date:   Tue, 23 Jul 2019 11:19:24 +0300
Message-Id: <20190723081926.30647-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Patch #1 ensures IPv4 forwarding is enabled during the test.

Patch #2 fixes the flower filters used to measure the distribution of
the traffic between the two nexthops, so that the test will pass
regardless if traffic is offloaded or not.

Ido Schimmel (2):
  selftests: forwarding: gre_multipath: Enable IPv4 forwarding
  selftests: forwarding: gre_multipath: Fix flower filters

 .../selftests/net/forwarding/gre_multipath.sh | 28 +++++++++++--------
 1 file changed, 16 insertions(+), 12 deletions(-)

-- 
2.21.0

