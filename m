Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B5D23AA40
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgHCQMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:12:39 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49623 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725945AbgHCQMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:12:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D3ED15C00D2;
        Mon,  3 Aug 2020 12:12:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 03 Aug 2020 12:12:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=oEFBo/RxyxHMqrnMYzOSetTAPE6J4C91sM0u5KcwlKg=; b=pEqr5gVA
        Rg263uLYl0rF/o0580XAnrvq7zlwlkYGUTz5j5ct4cd4pVpl9zWAwXf9kxNuGe49
        mBzIiIup2j5eIP3G/aKSInGiFxqy6DyQ9KNtmuktBmziL54NCNub/BAwATv09kw+
        WAqOXA1B5RyDKZlM/KaBoYRnhIJliq+fILuhvNOE1shRytpomQfcpK/XjfnVM4GN
        ZaxbIOYAgh4dzPV9T/j2Gr8hJDLM5w8pSh/gigSWUuI/84sIb5S4jXXyUu2qPSUT
        SydcwpBcF1cAwpNZIbhbwehLsW9ymFD8iJtEArjHMhywwyMmYlDsYGsI6i8Dj0Su
        7GlyshqFI6R0Pg==
X-ME-Sender: <xms:dTcoXxzx81bWsXE-Iw3YZuiQsDXbDwtQ4a1uktItlgEKlzMJaxXjiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeeggdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddukedurdeirddvudelnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:dTcoXxTtQgYw8tgL2xhPzEIe2OtfRHtmC50Gm8r8T8akBkIlivHRgQ>
    <xmx:dTcoX7VBT6nIKkePwE8PZs-d5RyRDW6sEYeeJUkpv_sqtbS-Vv7wPg>
    <xmx:dTcoXzgEhxn26K9KeU4W3yoqhht17k1H3p4oQJR1QZTKdyiskG4EaQ>
    <xmx:dTcoX6MsNMaAHppIPw_lnufGxjAAevyc5EDE8RuPuCObXd-ojQgaJw>
Received: from shredder.mtl.com (bzq-79-181-6-219.red.bezeqint.net [79.181.6.219])
        by mail.messagingengine.com (Postfix) with ESMTPA id CDEFD3060067;
        Mon,  3 Aug 2020 12:12:35 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/9] mlxsw: spectrum_trap: Use 'size_t' for array sizes
Date:   Mon,  3 Aug 2020 19:11:35 +0300
Message-Id: <20200803161141.2523857-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803161141.2523857-1-idosch@idosch.org>
References: <20200803161141.2523857-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Use 'size_t' instead of 'u64' for array sizes, as this this is correct
type to use for expressions involving sizeof().

Suggested-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 00b6cb9d2306..47bc11a861cc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -1063,10 +1063,10 @@ static int mlxsw_sp_trap_dummy_group_init(struct mlxsw_sp *mlxsw_sp)
 
 static int mlxsw_sp_trap_policer_items_arr_init(struct mlxsw_sp *mlxsw_sp)
 {
+	size_t arr_size = ARRAY_SIZE(mlxsw_sp_trap_policer_items_arr);
 	size_t elem_size = sizeof(struct mlxsw_sp_trap_policer_item);
-	u64 arr_size = ARRAY_SIZE(mlxsw_sp_trap_policer_items_arr);
 	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
-	u64 free_policers = 0;
+	size_t free_policers = 0;
 	u32 last_id;
 	int i;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
index 13ac412f4d53..a0560fb030ee 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
@@ -9,13 +9,13 @@
 
 struct mlxsw_sp_trap {
 	struct mlxsw_sp_trap_policer_item *policer_items_arr;
-	u64 policers_count; /* Number of registered policers */
+	size_t policers_count; /* Number of registered policers */
 
 	struct mlxsw_sp_trap_group_item *group_items_arr;
-	u64 groups_count; /* Number of registered groups */
+	size_t groups_count; /* Number of registered groups */
 
 	struct mlxsw_sp_trap_item *trap_items_arr;
-	u64 traps_count; /* Number of registered traps */
+	size_t traps_count; /* Number of registered traps */
 
 	u16 thin_policer_hw_id;
 
-- 
2.26.2

