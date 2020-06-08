Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBA81F10E8
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 02:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgFHA66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 20:58:58 -0400
Received: from mout.gmx.net ([212.227.15.19]:58795 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729019AbgFHA6y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 20:58:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1591577918;
        bh=MuS8uek9XC84kDSjvlmb2pFbspDYI7yaLOzH753AIqA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=HkcNyvwbQer0H6h7SltND/pSmq7S1BwbMhMK3C+vUXGxf6wwg6WhzVNngU/HCgrLq
         mOq4NqDn54/KCBfY06k93aIfkitG46eCJel3ZRwfogB+kUqzwN2lotz6ge1lmUDdUc
         znCd69wUWicC7SAGIVAdr57M5UAT52elfPNUyAJU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from LT02.fritz.box ([88.152.145.75]) by mail.gmx.com (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N33Il-1iwThb0ggP-013M9f; Mon, 08
 Jun 2020 02:58:38 +0200
From:   Heinrich Schuchardt <xypron.glpk@gmx.de>
To:     Vishal Kulkarni <vishal@chelsio.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] cxgb4: fix cxgb4_uld_in_use() not used error
Date:   Mon,  8 Jun 2020 02:58:23 +0200
Message-Id: <20200608005823.911290-1-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:AKk9fwKJB810n5qOHCpvFi7CA2srjaobrfmnlcdouwAnjFU+Ykf
 xiKvZh9ul573o9cl+RcQT3Cv0e7t52bF+yOzYdY3waIKtZWYRK7RAnG+57tH9BdFAdvSygP
 1YlGm+msycsLJtHUn4I/K/5MdngWzchmIrk6ROmRl+QkqD4YfIYzoU35wkAAqkWi18F+mfY
 Rics72LoeBimza0VzSuAA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:fIA9CwzOi6Y=:L8t+SXJSj1BYp5AnGanTQj
 Px6207eUhyDjeODrHVcVkdViutWuk+c2nTfPaFbQXmbdais2jyjTPCGEeSJ9mZbPOXcxKhQ5U
 FPt3yEwKXyUTeUvE77Q5F7ossvHbeRnPj+OS58lYjAE6GNV4rZrmwgbznyk5qAwDcNOnggDQS
 nCJaccSf6UTBR5jYGTUnh25RtE8Vmz3exOytdNJ7HGrCRFF9cH66qBWeXoOYB1WdWPkwzyP7I
 UPBmcEbZ9bHEUvwm+M6Y5tGIdK41ugVbOgpo6yZRq6v6A6n679uaL1VPU9gSiHaRKzTMiFZuI
 bpFrHEt+AF4MEpwaOtbG7R8LWGLZT74QlkMPJlqKqPBI09KpK4va8M9pfSQWv+rTiQUy/h7yz
 zpGx6hMlO3yeSSAWtxLbKtxRd6u4zRyfebQRfeey42rfvyp+pwIMdzNLpZeRIHQLQ/dtHc33z
 btA0b6yUQW1AdNBfDNKvA/1SVBmW6Cnx5Bp+DeuFymJ7ocT+vxQ2QAdPoqXG38hw9+ZqLcJ9d
 i2tIbmcDAX2a/yMmYtc/b4y2KtgyKR2fEovMigREL7y6Gbub2Alwl6cSHutvfwE+nIGXBQG0L
 qi5fl92lXx782X9C3Jv4MzAGl0MyumreZcVDvIW7EQCpjJ1VJ5r+vbxzVgleOyWsP9bKMb7+1
 nprOg8kbfAROJy55fYMSIWTQ3lRw9GwEGXPd7LXCsxgTbo5gn1jxK+1gf3ujAwzvf2zLToRug
 ya9K3yDngyAJqvkAe7+HRGDI9Yk2QIiS6co4e3uTXChlvHsWOnXWB/jtBledrpQb3igG+uoDc
 xMllzVe2DGpT1eZSe4VSsR+O+1KrwJ7mixGX9aLNDqZ2+P4z4knl8cp0x15Uuyna9uVgNur8e
 JkONAQEdQjFG8cRpRdqEHBRfApFMyQy+lFfl2/eYsNlOtm/3PwoQy/JfLWPL+kRcnoZk0ZSuG
 r4uD9AhTQLkjOiNw8eXGL9lVyhW9fO/edhjHU6S8kfVfGnknBc0/U1KP5zMZCH1kJqFIIQPeV
 /iDcgWqg5uPsMAPA3cKMzNRkDD8kfMiJFeijXKrv1cMBFBBdIi9b/dFo+QcJ3RvRdSPPC9gWs
 UQvnFhRZKBc41uoJorpeZcRhrpBeneUXFGOu+HnoivCy577HECNaIDr0dpJcovh3i6VtNHXO5
 Uyr5ABi7cBGEIxMlQ7thxA4iRb9HI5OYMkFizpFx3qWbsUZ60nI4u8HkbEsRtVbFV/Esbx16q
 RMICc17mFpqrda+mA
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building without CONFIG_CHELSIO_TLS_DEVICE a build error occurs:

drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c:666:13: error:
=E2=80=98cxgb4_uld_in_use=E2=80=99 defined but not used [-Werror=3Dunused-=
function]
  666 | static bool cxgb4_uld_in_use(struct adapter *adap)
      |             ^~~~~~~~~~~~~~~~

Guard cxgb4_uld_in_use() with #ifdef CONFIG_CHELSIO_TLS_DEVICE.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
=2D--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/=
ethernet/chelsio/cxgb4/cxgb4_uld.c
index 0307e9c69a47..f08f860b4983 100644
=2D-- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -663,6 +663,8 @@ static int uld_attach(struct adapter *adap, unsigned i=
nt uld)
 	return 0;
 }

+#ifdef CONFIG_CHELSIO_TLS_DEVICE
+
 static bool cxgb4_uld_in_use(struct adapter *adap)
 {
 	const struct tid_info *t =3D &adap->tids;
@@ -670,7 +672,6 @@ static bool cxgb4_uld_in_use(struct adapter *adap)
 	return (atomic_read(&t->conns_in_use) || t->stids_in_use);
 }

-#ifdef CONFIG_CHELSIO_TLS_DEVICE
 /* cxgb4_set_ktls_feature: request FW to enable/disable ktls settings.
  * @adap: adapter info
  * @enable: 1 to enable / 0 to disable ktls settings.
=2D-
2.26.2

