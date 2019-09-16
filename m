Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEA4B3D3A
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 17:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388182AbfIPPEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 11:04:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50543 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730609AbfIPPEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 11:04:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8BA5C220CF;
        Mon, 16 Sep 2019 11:04:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 16 Sep 2019 11:04:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=YHeNcJRjjh4mxdnPn
        pgCbxVZTNyl8O/raQqVebpYTbY=; b=I7mMmjXoym25dXowPzoRg9ccRB3YDfqAV
        q5akjKFl3mtl4YHZ7r0oMoo5okhyn0cbqICQ1BGtdTdpNqoOKKDhbHF1+0M/Fo1V
        oIeCb9Fp67UvwI1pFkuRXnTrQqwNHq6QGTQqrB2qzBUFdEnnKP4CrhwicMt5lU/a
        SmdifEGsQ1wb8GSdEuFXYZG7WXzU1fPqnCg/3E4qwXmGJGgpMNv2VaW7ufLPNBgZ
        +Cs8c0fAhLnhypWNWJWkWKlbWO3gsND/PapGdp4IEWtPDBHe0/5ErjyvNzI9QPMf
        lM8j+qrFwLLnvguPAmIHDHMIFahVEZ+8nB6mYvWl/k6D/lWtsoLRA==
X-ME-Sender: <xms:jaR_XSFBoWA1Dez8ZqD-JfF9Swz1462y2ykY4nskShv59UTNOokT6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudefgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:jaR_XSu4zG6I_DH0q6i5PyW7oDRUPt7Q5a-ujaPT_ajlFB4Fua_OHg>
    <xmx:jaR_Xet4Hu7ekSNntgTBfqWa3KiPQ0vlcQAd_MfJcvLiIftBZdcjCQ>
    <xmx:jaR_XdRioDLPJSWn6zXhtq11tinyPsqNwWNjFRrzBIOlBst-bwFu7A>
    <xmx:jaR_XdBpt5vpWHpfZMt9QD6pLsmMxrk5jbpwz2xosmsW_9V25AKQew>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4FCCD8005B;
        Mon, 16 Sep 2019 11:04:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 0/3] mlxsw: spectrum_buffers: Add the ability to query the CPU port's shared buffer
Date:   Mon, 16 Sep 2019 18:04:19 +0300
Message-Id: <20190916150422.28947-1-idosch@idosch.org>
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

Patch #1 prevents changing the CPU port's threshold and binding.

Patch #2 registers the CPU port with devlink.

Patch #3 adds the ability to query the CPU port's shared buffer quotas and
occupancy.

v3:

Patch #2:
* Remove unnecessary wrapping

v2:

Patch #1:
* s/0/MLXSW_PORT_CPU_PORT/
* Assign "mlxsw_sp->ports[MLXSW_PORT_CPU_PORT]" at the end of
  mlxsw_sp_cpu_port_create() to avoid NULL assignment on error path
* Add common functions for mlxsw_core_port_init/fini()

Patch #2:
* Move "changing CPU port's threshold and binding" check to a separate
  patch

Shalom Toledo (3):
  mlxsw: spectrum_buffers: Prevent changing CPU port's configuration
  mlxsw: spectrum: Register CPU port with devlink
  mlxsw: spectrum_buffers: Add the ability to query the CPU port's
    shared buffer

 drivers/net/ethernet/mellanox/mlxsw/core.c    | 63 ++++++++++++++++---
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  5 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 46 ++++++++++++++
 .../mellanox/mlxsw/spectrum_buffers.c         | 51 ++++++++++++---
 4 files changed, 148 insertions(+), 17 deletions(-)

-- 
2.21.0

