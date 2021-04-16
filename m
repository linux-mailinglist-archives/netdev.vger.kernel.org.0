Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FCB3624B7
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 17:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbhDPP4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 11:56:49 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45837 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235192AbhDPP4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 11:56:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 98D385C0085;
        Fri, 16 Apr 2021 11:56:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 16 Apr 2021 11:56:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=IefBsWk7+WdWLUWdX
        tqMT87DnA8WdLHHoUPa0nQlzmo=; b=qzzNhb8cqtQhPvBwxGFg6bSja2SxgiX1k
        KzYGFwcjf/J7boJrpGvM03ydsMgBEkJqBT98tXvnGEfx6aOfIDqNtSDg8dxQZkif
        w8740P3XKBwGWL9obzmorAAz1JwU93nQplOq9OHobyl1bwnwfPTpTXwvwWBc+NRW
        gEVhBwXfbwyx96O+SArcjS1PS1BJfqlplnNO2Rvlc/Xr+cdHkpQxtbtRJxZM/hQ9
        EDbW+ePCsuAuTjkK6MlpRtSUpbU1Y8ydzpKRxfzoDt7R0eZ8fxF/40hScg+pRV8j
        6O5egzwh7n5OOYNbf3joA0wZHEquZiCEKSDj/hbk+wIy1MvuohMNA==
X-ME-Sender: <xms:prN5YPeEsxb1xHHKBrDmW_RHeMFFBXR3T_sydx9V8w3wlI27rKtXIg>
    <xme:prN5YFIIDyKHUY-mFHhcGb2EKLRiAyaGCWXxn1eiqNfW5bEdRJlsF2JQQ1BVLPzW0
    pGMQxPnkL1jyJY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelhedgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrudekjeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:p7N5YFYsnWoz8VLnUX0X2ycQTZQ2OmdDy_zvehUDyIRm5IyoXWXXRQ>
    <xmx:p7N5YIsRtM_Q6MZmUfPDmz8bifv5M9Hq51XipumUQEallu3mAIQ1gw>
    <xmx:p7N5YKtjkfwZoxybvUGfk5VBgM8sdEEzgqW8sFHRxd-h3AaMzJp7yQ>
    <xmx:p7N5YObrowjD0_8DxzRMbYcFaHCwExL_AEykNqxyDhiSVXIOMntaBQ>
Received: from shredder.mellanox.com (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id 56EF2108005B;
        Fri, 16 Apr 2021 11:56:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/2] nexthop: Support large scale nexthop flushing
Date:   Fri, 16 Apr 2021 18:55:33 +0300
Message-Id: <20210416155535.1694714-1-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Patch #1 fixes a day-one bug in the nexthop code and allows "ip nexthop
flush" to work correctly with large number of nexthops that do not fit
in a single-part dump.

Patch #2 adds a test case.

Targeting at net-next since this use case never worked, the flow is
pretty obscure and such a large number of nexthops is unlikely to be
used in any real-world scenario.

Tested with fib_nexthops.sh:

Tests passed: 219
Tests failed:   0

Ido Schimmel (2):
  nexthop: Restart nexthop dump based on last dumped nexthop identifier
  selftests: fib_nexthops: Test large scale nexthop flushing

 net/ipv4/nexthop.c                          | 14 ++++++--------
 tools/testing/selftests/net/fib_nexthops.sh | 15 +++++++++++++++
 2 files changed, 21 insertions(+), 8 deletions(-)

-- 
2.30.2

