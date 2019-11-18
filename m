Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03DB4FFFC7
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 08:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfKRHui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 02:50:38 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37385 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726317AbfKRHuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 02:50:37 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DD7D422220;
        Mon, 18 Nov 2019 02:50:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 18 Nov 2019 02:50:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=cr3pCcmjyMzyQs1WC+cdUeObtOZy5C4FkYNLUtFOv1I=; b=D3jTOVkz
        a2G+ET/cdZ9PlAcMQyHx2ydJZ1rrDqlDvzT7JVFnRlMf65MX0AwoOH+Xt+QsDq1n
        e6olSc+5CCq9uU8VvPVWB5/c471+aj4po9aPq/MLGyMi9mBR3SpBuAxdk0JicmzV
        ey1dqurLh1n+kUzo3JLukvFFsz7BhCheRZp1yJl6Ruk0H4Q2pJOeJX3FNxe9ibBw
        zpW8Lk3GQh+FXRP+ouhxWF5qGw6b0eMPMK+bduvSmd94iPd/PBCEfqRLy+4Wl6r5
        I0eMb/9XRh7d5UbMjXrs+ww8baAi1NXxYtVlAMwKLwFfbyUQiyuHUZyOTw/0j9eO
        LuU4pTkLrD9NYw==
X-ME-Sender: <xms:TE3SXXQ68_tGEmxgeY9K5Gd-9bqSSVxW-okLuldpivf4_qpX0QpGCw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeggedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:TE3SXU1wsimpkMvkIMVfQCQHbSUXjZNQwu9nqlwrRmU-eAA74qU32A>
    <xmx:TE3SXZhNG5J5_bOUKTDqfiJpK6qklnF3DJ7uu-kxvj--a5Xr8iR3yg>
    <xmx:TE3SXdXHnzbl-VASH0_6VyHMZGtGo3IFXrHU_EEPrg1ST0_gbw4-vA>
    <xmx:TE3SXXDPkBS25_POcHox3V71W91dUT4JVZ5179tiTnr0gL8g31mwVA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 724CB3060061;
        Mon, 18 Nov 2019 02:50:35 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        mlxsw@mellanox.com, Danielle Ratson <danieller@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/5] selftests: mlxsw: Check devlink device before running test
Date:   Mon, 18 Nov 2019 09:49:59 +0200
Message-Id: <20191118075002.1699-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191118075002.1699-1-idosch@idosch.org>
References: <20191118075002.1699-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

The scale test for Spectrum-2 should only be invoked for Spectrum-2.
Skip the test otherwise.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
index 27a712a5ed8e..7b2acba82a49 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
@@ -8,6 +8,11 @@ source $lib_dir/lib.sh
 source $lib_dir/tc_common.sh
 source $lib_dir/devlink_lib.sh
 
+if [ "$DEVLINK_VIDDID" != "15b3:cf6c" ]; then
+	echo "SKIP: test is tailored for Mellanox Spectrum-2"
+	exit 1
+fi
+
 current_test=""
 
 cleanup()
-- 
2.21.0

