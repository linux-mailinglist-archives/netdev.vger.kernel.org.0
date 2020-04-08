Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46ABB1A2A5B
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 22:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730546AbgDHU16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 16:27:58 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:37833 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728472AbgDHU1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 16:27:51 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MnaY1-1ivA0D1Xk5-00jcjI; Wed, 08 Apr 2020 22:27:20 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [RFC 2/6] net/mlx5e: fix VXLAN dependency
Date:   Wed,  8 Apr 2020 22:27:07 +0200
Message-Id: <20200408202711.1198966-3-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200408202711.1198966-1-arnd@arndb.de>
References: <20200408202711.1198966-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:uksvWMPl7e6M4tD/Jwdoi/VMWCKlsBX2f2Iv1OdecI6D9qke0UX
 H8JDHSq9tH9gdAImB1WlOCwGw2juxksbW0T1qPC/P8/TcGZb/MCvO8DynkYcvjJ8nPSRDqN
 MW7IsSzrNXsuHRWtvMtvasLD+JPJGabCH2cqP5roVa2BQ766CRRiBekpQVNwmRgvG8cSVNn
 FzXdiP8/Lanh60jj+f2Ng==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+pcOhHlaitk=:zKS80sKudtNtQuZ1iQybEO
 wR9woHPAZHzLc5HwPQBHERiTXNsHPvLlSFLLPyYLD2rLxRtJ0Mpr/58sYHIITmcsY/Kr9k1Vu
 cCbVLzrbl1zD3+n4O6enNKSBMWBevs2J2Y9MamrLlYrEiBuZOQGPOJM0XzBzb/PyzBYhhU5+c
 xIcDV3bkFc+wLZ1vC9/XsK5CBpa5pS64Z6ytzN0yJ3VF5KTFDZsz6466WnD89PacJbtMug/bL
 8C8lnesNMro0k1UiKregFx5o6f3U6HY73wqmcGVdS00G2Iknb7Nslx3Bj96wqAWJjejMJR7xI
 H6HgOx0glLxanJ4WykB8tpm2yWxYqBMIFL8qxiS9hUx50qs7TJChcneGGt+2OZ45AKT3cn5Om
 UTu8AbTDWLWYnAApETQg38+ImM4r2Hws7U1FkqDsQi5Lz/Hsowg36urTW+kMe1+aJ55GPypXI
 zpQOgvlpPFO0fBWrauV4iQ8F6SjCNu/Q+zsV8SpAVvp+ESoYLma6GR2oTAJ1eJzV0IjKzU4iD
 GRDz0VvNwL3JtpjdesDHUS95Hdd4dS1r4bkxKdrS1KKXiLNciMj8OyY6+PEHTK4+d7LDBkJuF
 6YgMtsw5FfLzm7UviRd1IkV5Dbd8L2DrU7pgp2uibPI9gJg5A4BTBMAkX3exImlErl+no4RVa
 t9sWJy2+yCx6SL6BGHCCPQD0fnNfQK2JcqnaEHTVOxZsnSwxdv/pyfgMIADONeZVilF6AEd7W
 72LP2HuNDtWiGd56e8YlUH+iqDjcDEUW0ZbmQUJatHpliCkuFgCvZzgnDf/mtvTMKe9CiFIYH
 AmuXQn2RKNyCix3iwEGv808kO+9zjt/UKc1O4W2x3YXfaKSx8E=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'imply' statement does not prevent MLX5 to be built-in and fail
when VXLAN=m:

aarch64-linux-ld: drivers/net/ethernet/mellanox/mlx5/core/main.o: in function `mlx5_init_once':
main.c:(.text+0x7cc): undefined reference to `mlx5_vxlan_create'
main.c:(.text+0x958): undefined reference to `mlx5_vxlan_destroy'

Use a normal dependency instead.

Fixes: c5791ab0abec ("net/mlx5e: vxlan.c depends on CONFIG_VXLAN")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 312e0a1ad43d..849b0be0ca9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -8,7 +8,7 @@ config MLX5_CORE
 	depends on PCI
 	select NET_DEVLINK
 	imply PTP_1588_CLOCK
-	imply VXLAN
+	depends on VXLAN || !VXLAN
 	imply MLXFW
 	imply PCI_HYPERV_INTERFACE
 	default n
-- 
2.26.0

