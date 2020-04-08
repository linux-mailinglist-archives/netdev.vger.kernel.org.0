Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F27621A2A6E
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 22:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730576AbgDHU2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 16:28:13 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:50203 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729431AbgDHU1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 16:27:48 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Ma1kC-1jpzv402E8-00VxbF; Wed, 08 Apr 2020 22:27:22 +0200
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
Subject: [RFC 5/6] drm/rcar-du: fix selection of CMM driver
Date:   Wed,  8 Apr 2020 22:27:10 +0200
Message-Id: <20200408202711.1198966-6-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200408202711.1198966-1-arnd@arndb.de>
References: <20200408202711.1198966-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:BHGsIuVv5ZbKZcE4TjncqtpdBu8WjZS+2Q1lxqyGkiA2mhZOxWk
 P/dnbzJufBgPE0K1DKdoofKWfp0z22YhTz+VuyDG06en1W4KOhovhJrv6BugOwEFXqTaTj2
 288ntMN6bhI9PumD50NA/n3txC43UpJhfmdGrdxosHRyNYVJgDBMQiwxTTn/uWVFTqjSdUU
 fDQQqODpLa+nnX9eremjg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:pp2T8S8fwiY=:YFTKAmm3THs3lkgTu/9cJO
 OlEtbaj4m1Q5rf7W3W0uZLdMofdnYljtx8FY5AetjTPsNapbUFYF/lEmeEIi2ZJ2XntmC8zYC
 EJ8vhWs3nd3PF4ZiisP0ZuphikEQmE6sMD/MqJ4fMBozRB7Y7Q9WYtgy9LYl4pofjT5ITkfj8
 zn1K+ou3M5Zg8obfkcB7h2q53e3Xf0UwPgVqBhex3D/m3VsHxFczoP4Ke5g8FGmAhJCUxAlwL
 2PFHFwGyb6KCkVHbnDkhoOeZxvn0QqXK8+45nCfJIvr2AbPnhixWzgQByM2NXOAZEd4teCAz/
 qxorUPGpDH1S7dbIj3N3ooaHTS3oi4JQacv8a+RLyyJQ9pwxlazye1rH6RI0Z6gK3MiRFnhZ2
 lq9fUUdQg/KctqBHG8a73RVU0VDaP0fy1BjwPBZaFhlWURfyNLxRG/qVhfmA0raUlGneT2iOW
 He+R/86cyk0/B1G6OZZxXsX5ZBaVdYxOT/CYk3yXRB40jdkw/v8ZTle5gBvZ6zySj1Ad0dcs/
 4iMaS5adZbjp1svnyH2qvzvuB4vAmca9l1RJLzwFCdzSwFMdwNpowt/525p3rQ5hPvavQkS8W
 6eOsFHwpp9Kp7ZCoHvnhNwEEvUI7wiYSRg1BO7t3B5OgB19ndMAHUoTgc3lbOxgyhoTXPaX8o
 tI7K8mzkll+T9iyBn99wcIbTYTEiYhRM1BvmfTtCRyn9H7UWD3WTPba8PPrynVA50MrI7uLly
 BS8Jy4fz75apY/KbCLbbT54mmCW1x+HAOJaCCcrHcpdZkjz0fj3tWKOz+LDi0Kvmt0qRb5tKd
 rSVLD4Vzw4UcAzTHMoiBj6bSie1LlISiOrXQ/oOoxrZBCBLNp8=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'imply' statement does not seem to have an effect, as it's
still possible to turn the CMM code into a loadable module
in a randconfig build, leading to a link error:

arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_crtc.o: in function `rcar_du_crtc_atomic_enable':
rcar_du_crtc.c:(.text+0xad4): undefined reference to `rcar_lvds_clk_enable'
arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_crtc.o: in function `rcar_du_crtc_atomic_disable':
rcar_du_crtc.c:(.text+0xd7c): undefined reference to `rcar_lvds_clk_disable'
arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_drv.o: in function `rcar_du_init':
rcar_du_drv.c:(.init.text+0x4): undefined reference to `rcar_du_of_init'
arm-linux-gnueabi-ld: drivers/gpu/drm/rcar-du/rcar_du_encoder.o: in function `rcar_du_encoder_init':

Remove the 'imply', and instead use a silent symbol that defaults
to the correct setting.

Fixes: e08e934d6c28 ("drm: rcar-du: Add support for CMM")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/gpu/drm/rcar-du/Kconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/Kconfig b/drivers/gpu/drm/rcar-du/Kconfig
index 0919f1f159a4..5e35f5934d62 100644
--- a/drivers/gpu/drm/rcar-du/Kconfig
+++ b/drivers/gpu/drm/rcar-du/Kconfig
@@ -4,7 +4,6 @@ config DRM_RCAR_DU
 	depends on DRM && OF
 	depends on ARM || ARM64
 	depends on ARCH_RENESAS || COMPILE_TEST
-	imply DRM_RCAR_CMM
 	imply DRM_RCAR_LVDS
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
@@ -15,9 +14,8 @@ config DRM_RCAR_DU
 	  If M is selected the module will be called rcar-du-drm.
 
 config DRM_RCAR_CMM
-	tristate "R-Car DU Color Management Module (CMM) Support"
+	def_tristate DRM_RCAR_DU
 	depends on DRM && OF
-	depends on DRM_RCAR_DU
 	help
 	  Enable support for R-Car Color Management Module (CMM).
 
-- 
2.26.0

