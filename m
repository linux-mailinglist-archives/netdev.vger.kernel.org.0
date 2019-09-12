Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F09BAB0F91
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 15:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731873AbfILNIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 09:08:20 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:32777 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731283AbfILNIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 09:08:20 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5F1F42203C;
        Thu, 12 Sep 2019 09:08:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 12 Sep 2019 09:08:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=428icVynjX18fd7pc
        dTlPp8XAaL3+PvR9gKY7K6r9qY=; b=YugOCJ7bdapC8f6MPGmQFryIshRXnVdZv
        p9ZxlHtn5UQOfC/Htb+9bk4+GMZtgOJwyxPgWs8cOYL5J/Y8BLtBNkoBZnopddYl
        JvmIGp6UaFRlAdVFb2aJcfespkGROYpuhy0bEgNJkmmAxRRLoEN2zPE08TNisUWB
        UKMSrJMYHLetOWq3i4fVqBAT3Khmw5qB+2SPigTjy92V1tKuJSGSSPXfYzSLbHCA
        T+wCullmu4wYrSLjfllJFX3QotyxnZHxZ5e/oMvMsHbVkiq8rE7EhSuW/V3wi1fk
        H2U/IIC2Y0iwKGPBLUw2Gd3EeEpQjUUTS5kCyIoAku0GF310kb1dQ==
X-ME-Sender: <xms:QkN6XdRtcY7x9CynynFObiWRDXx5IKGQipHjWhIQhUaJ68E-jJQGXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrtdehgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:QkN6XThlzUQaUkWhfrkAqnbJW3DIphpUWKVFBCVuSbWXDxTbQ-3HYQ>
    <xmx:QkN6XSYzJnzoTFqc-ekD_zdWp_dkKx3cy8cUNVaYj2dezowAtgBcCA>
    <xmx:QkN6XdpFpBwHhEWz-3BkaWRYxY9nfafymnsAIxVf6AdLJ84UJhr45A>
    <xmx:Q0N6XQanBaWrfZ5RvbGNjVO04ryJUXKdkKFkq0iYy1n-zUT2trKofg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2B707D6005A;
        Thu, 12 Sep 2019 09:08:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/2] mlxsw: spectrum_buffers: Add the ability to query the CPU port's shared buffer
Date:   Thu, 12 Sep 2019 16:07:38 +0300
Message-Id: <20190912130740.22061-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Shalom says:

While debugging packet loss towards the CPU, it is useful to be able to
query the CPU port's shared buffer quotas and occupancy.

Patch #1 registers the CPU port with devlink.

Patch #2 adds the ability to query the CPU port's shared buffer quotas and
occupancy.

Shalom Toledo (2):
  mlxsw: spectrum: Register CPU port with devlink
  mlxsw: spectrum_buffers: Add the ability to query the CPU port's
    shared buffer

 drivers/net/ethernet/mellanox/mlxsw/core.c    | 33 ++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  5 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 47 +++++++++++++++++
 .../mellanox/mlxsw/spectrum_buffers.c         | 51 ++++++++++++++++---
 4 files changed, 128 insertions(+), 8 deletions(-)

-- 
2.21.0

