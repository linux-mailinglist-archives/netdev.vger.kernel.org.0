Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B62A1134399
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 14:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgAHNPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 08:15:49 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:58903 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgAHNPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 08:15:48 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MA7X0-1j0m1Z2aB0-00Bg3r; Wed, 08 Jan 2020 14:15:39 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Jiri Pirko <jiri@mellanox.com>,
        oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [net-next] [v2] netronome: fix ipv6 link error
Date:   Wed,  8 Jan 2020 14:15:15 +0100
Message-Id: <20200108131534.1874078-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:SpGETPyIfycO9sZ78r+DE7z3+PLuGaU6+CnTGR2HBoxCavh3bUe
 Pj8YTdBKSCrQs158706QpszFvboth3TO1B3LEK0artEqoMHBrdbCKKs82khvm4LPKtPfgHl
 cBSOv3fj2NrOS+g5k+KmLEdXklyjbvxQ26Ac9asOXJ1Oc/ileJZDkSzYtiieoDa6Gj5bpIk
 mv0NFnKnGGI6iMVMWzVEg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:KeWPqLVjJKk=:tlMZegCFEnndMuUouPuRYf
 /A3JtqJf2W90Xr/9yVnnwMJ6wTlLOpXFhkDGNm7fWYoOl7jSvVOkAnbmAwqyWq0w12iO/5aBP
 tmFtCZMEsHJ5h5sN444V+7GVOuT+xAXIZDIaceU39aUgBsurltpkdNUqeCXntifg6AhiR0uWn
 0PYQtdSqp4uriQ695RN5zgqhrc4HXPVwlgfZlRe9SmNp33rL5C74Z/KPzI1OmjSUoXm1v9T/j
 wp0UTpMKvDXWcgs24MmR11UKS2nSfWzV+RdgRKojP0ROLthM/wlKhjrj4721ZnOBF7n6gmdDk
 E3GjAWRDM/5tarEN119HK10Gf72oeoLm/IWLDP7+NwpsxscqiI8pGK5LnCHcD9mn1Y+eaZrx3
 WUA7TzsjQWN67RJ8HKDXyr4tU2uOOFGiDmFxdOjA8OCiVigvLCm2Z91j0sWc/YX+IjTxShfCf
 2N4l9M7xhZkSgPtIYjb9dqhDb8yYED9WWc7ENfq/3+ZvKwZGGwop8vZiJDVlwmGXKN5OvXcPG
 7dUXnHy1vqSo8O/EjlZUJeRV1aiy+7FRVkt/IA9SKdLRKH+x9gCqNP1ttCzMMIOen7YhWNyn5
 e/kLChVKG2B+e6Bgj+plTxrd2wdnx5hW9d2GilABDZQAvSaQTCdP/AtDIX/1uk2IhV75tsVLA
 lt7j5NqtE+DzX4oKQ+27l8gD+7myMZze/8TX52SHZmJILE6704zf+1taezHFBfS4PJxTxUKbi
 wFZwJi2WS11U2iS6EHng0kZ2UKBpSnvuTtzSgT/pGOi2lg7SL09KEhBgFTd3U7tXWI/qNuzej
 2Wx90lKe9E94CSG99L8b/8kJiGLwk8hudtT/2W908MNOejqeG7BTqErKn1Rr1k1gN5SjUuyN6
 so9kgKE1IR63OuV3nk0Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the driver is built-in but ipv6 is a module, the flower
support produces a link error:

drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.o: In function `nfp_tunnel_keep_alive_v6':
tunnel_conf.c:(.text+0x2aa8): undefined reference to `nd_tbl'

Add a Kconfig dependency to avoid that configuration.

Fixes: 9ea9bfa12240 ("nfp: flower: support ipv6 tunnel keep-alive messages from fw")
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: whitespace fix
---
 drivers/net/ethernet/netronome/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/netronome/Kconfig b/drivers/net/ethernet/netronome/Kconfig
index bac5be4d4f43..a3f68a718813 100644
--- a/drivers/net/ethernet/netronome/Kconfig
+++ b/drivers/net/ethernet/netronome/Kconfig
@@ -31,6 +31,7 @@ config NFP_APP_FLOWER
 	bool "NFP4000/NFP6000 TC Flower offload support"
 	depends on NFP
 	depends on NET_SWITCHDEV
+	depends on IPV6!=m || NFP=m
 	default y
 	---help---
 	  Enable driver support for TC Flower offload on NFP4000 and NFP6000.
-- 
2.20.0

