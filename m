Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4191A2A63
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 22:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730417AbgDHU1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 16:27:48 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:44477 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729333AbgDHU1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 16:27:47 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MfHUx-1ip88a1CpP-00gqlq; Wed, 08 Apr 2020 22:27:19 +0200
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
Subject: [RFC 0/6] Regressions for "imply" behavior change
Date:   Wed,  8 Apr 2020 22:27:05 +0200
Message-Id: <20200408202711.1198966-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:zEzMmRw2UXFx9zU6fPxN+W5wPcFHDncLQsBY9LbEA0w9eEN1eTu
 cnzjMxpU5zxrYcnwqTeAc+Ps/JyboCntYRrUtWKxjMYWqJF44Bf4LOvKsA+DX4gzPI+FQub
 UxxzljbycF32PPMrcW97pI811kKuSvXVrKpXAN9hfhlEgzbQUJJE8q6o5AYNdaJE9WYW8la
 uMsnELmKxIjuKo2Mnf2bQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:TWdcwFoldyI=:NS8I92rXicAb2aGhAXYXT3
 zbu3I6qgkDuIzvNKKVw06vL7+R2l1nBDjNBPVo4DXwjxE1dDTAneGOxdoT5CVDnn4eNCkUou8
 6Az6Tq087nNHF5iiZJ5NolfFLRiBg10jtfZpBPmyUYiiQ9nDM9r0009G8AlF/+gNfRDMdGYmT
 gncDh39Bmz4VBL0nbCXN8K4kbJvwlwcv4Kj4eG9drYgmTiY1vZUyJv/AuXA4XCNCormt00fx5
 9Oq6GtnUnI+129u0nx1Wp1h3HQB9jJZtzBXuT9j2tovNUV+kBiVgSEkj4WDrgXLS1zgwr/Ow2
 WiWNzvjnzFTNkbB5Y9ryeW/LPIPcwGv2dtdp3QAGmfU4PcXa7Dev17vdxjeIUPVCBmi9MsSI5
 xm9PAlIZvzWXRbiKHvHneEsJWxOi+O+qR7xJ7ye+HHpxo2mZ2pR4AMLsUcXYPXjpFdHjLnQTb
 T2uKH3neFx1H+Xhd2dpxj6RNntKe9b8VtYXK7willY8/WWs5Gjm/4BnvoXwNhCGvcRK+G8c2g
 AfNqVvEauy+AtxH7EB4rhNOlTfiiDMzzvsnxXLA/tphh2HzFV7CH+dL3Bmsf+Eil28ld6XI6O
 XkdDmCbVfn6BI9nC3AoP2pgyEWcgyVDIDSQi4GfDGlPEW+161trruvSc7uPKPJPvDs2D1pI/E
 4pJdhI2vcfHaqYkK8JeAaYRQI/S6rwMtUkWtzofxhzqwtFJL7mPA0Dw9wiMHnMp0nThfJ42aC
 Bl32WLzx9ELKvgw6hv0t68fHB9/Xxv9NrCK19O899oeawmWtm8L/3N2BMfWZDVQGBvffLxnm8
 abBAJx3W3JbM74GshlW7uydgO/5lfqdEXGppl/fRbmlNs5hWcI=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

I've just restarted doing randconfig builds on top of mainline Linux and
found a couple of regressions with missing dependency from the recent
change in the "imply" keyword in Kconfig, presumably these two patches:

3a9dd3ecb207 kconfig: make 'imply' obey the direct dependency
def2fbffe62c kconfig: allow symbols implied by y to become m

I have created workarounds for the Kconfig files, which now stop using
imply and do something else in each case. I don't know whether there was
a bug in the kconfig changes that has led to allowing configurations that
were not meant to be legal even with the new semantics, or if the Kconfig
files have simply become incorrect now and the tool works as expected.

Please have a look at the cases I found, and what you think we should
do about them. I assume there are a couple more like these, the six
regressions here are what I found in the first 1000 randconfig builds
on the kernel.

       Arnd

Arnd Bergmann (6):
  thunder: select PTP driver if possible
  net/mlx5e: fix VXLAN dependency
  LiquidIO VF: add dependency for PTP_1588_CLOCK
  drm/bridge/sii8620: fix extcon dependency
  drm/rcar-du: fix selection of CMM driver
  drm/rcar-du: fix lvds dependency

 drivers/gpu/drm/bridge/Kconfig                  | 1 -
 drivers/gpu/drm/bridge/sil-sii8620.c            | 5 +++--
 drivers/gpu/drm/rcar-du/Kconfig                 | 7 ++-----
 drivers/net/ethernet/cavium/Kconfig             | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 2 +-
 5 files changed, 8 insertions(+), 11 deletions(-)


Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Jonas Karlman <jonas@kwiboo.se>
Cc: Jernej Skrabec <jernej.skrabec@siol.net>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org


-- 
2.26.0

