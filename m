Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 625566697D
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 10:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfGLI6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 04:58:38 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:57965 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfGLI6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 04:58:37 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N0qmr-1iiWJC3sCj-00wj0T; Fri, 12 Jul 2019 10:58:28 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [net-next, netfilter] mlx5: avoid unused variable warning
Date:   Fri, 12 Jul 2019 10:57:11 +0200
Message-Id: <20190712085823.4111911-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:KbtTIUVijtjWb2BGudzBahmvRgrYsk9J81pM88PMcX4hIYF1S8L
 gwuD9vu1/nn6juu36bk9dM41BjnCzdAVdK1XblUpEIspkI+qFHDNupUopxdq+3WLf1KVgv4
 +eqnbxE9wGcbCeUugh7J1Lja5qJJ+Fz8cN/Elk8vdykzSlN6SdCcq+TxeKYaPEj2Qur3Auq
 BDDOpD5PUD3weUNF7oVgw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:FvCGFSTd6E0=:asyyPiZ2WEID0yTUfqlLkO
 yDK9Trl6uOm5d4YOn38xx94BXBWk0eyHyhwG71UAts4NggelRuwSXc0MfaGT5jqdP9CkeuEwN
 wt9V90ChT8C+pLT+3PGVkWwcmmBBTDdHohOGOvIRVoPjMkj9sIHd6zK4pMlh4E9C6C+9D91Cv
 yP3Ky9REc91p0PoVMUib72W9zesKLaQHN+CB7AkG6Yd60RAF6g0XdCEW09LsN4tpvP0Yrsdcj
 oQBwED5oIRUaPH91IPJMaHYGUiBZYdeuAJhXPeqZfHHGeQ3LOnEkK901r3pvLkEclXfIIAXqg
 gRVoZQHm8g3XI6Uwl+yTo5jinQfenLrHn3clvliWJhwSOB3VJrgp1k9VRuX4T/vkCZH4pu4LB
 q0a8HgxA+CiEGuW9srVOozgJMuWwhYo5bSQiNceysbAHwVqfTnCIjAGGB6gYNH/yCnkM2h3hL
 S7bOf1/vTswustC+kCwhLhK0wmZZ8XYdLeUyG4upeGBZCfoh2MKQDkQV6QJZGgeLF78s9S16n
 ESm5pZt93aF60xeNyYLSvbVj6FePTfWI5P3YXy4GW34D6WrqI4dpj3YZzj/LESubYXw4JjvEi
 If4AhulwrRCJtCi/31aPfsyUYJS5HuBRU8nG6IcY15NRLSI4UXFkZlXrF/rqZGvrJpG6srDlO
 +A45Y/isoJWIsK93EgPxm+Iex5Qdj4gnHfT47T4Zj344PWeqeNsSeBiVPq3MrtxMfwKgjVL13
 FxXXpAQVrySO3Ci8uABOfS8yEwOFgfxsFk/S+w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without CONFIG_MLX5_ESWITCH we get a harmless warning:

drivers/net/ethernet/mellanox/mlx5/core/en_main.c:3467:21: error: unused variable 'priv' [-Werror,-Wunused-variable]
        struct mlx5e_priv *priv = netdev_priv(dev);

Hide the declaration in the same #ifdef as its usage.

Fixes: 4e95bc268b91 ("net: flow_offload: add flow_block_cb_setup_simple()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6d0ae87c8ded..b562ba904ea1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3464,7 +3464,9 @@ static LIST_HEAD(mlx5e_block_cb_list);
 static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			  void *type_data)
 {
+#ifdef CONFIG_MLX5_ESWITCH
 	struct mlx5e_priv *priv = netdev_priv(dev);
+#endif
 
 	switch (type) {
 #ifdef CONFIG_MLX5_ESWITCH
-- 
2.20.0

