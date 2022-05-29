Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7A6537193
	for <lists+netdev@lfdr.de>; Sun, 29 May 2022 17:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbiE2PjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 11:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbiE2PjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 11:39:12 -0400
Received: from sender2-op-o12.zoho.com.cn (sender2-op-o12.zoho.com.cn [163.53.93.243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A3062CF6;
        Sun, 29 May 2022 08:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1653838739;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:From:To:To:Cc:Cc:Message-ID:Subject:Subject:Date:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
        bh=flOcGigG3FIhki9qeUJuXud/Jj5FC8Aqn+kS5ocOzLs=;
        b=X4RH1B7ofe8dHWlERs3xxOmDu+/sW1EEAwStAQN53r5SnJGMtxh74ympVLOMKv7x
        oI3VWb6X/J6NMTl41V372KRFn/38NmGBUjwh+MpbpqtE8NfXMcWHVi91nfkec/3uyE3
        TQjOh4CwX4n/YR7fYiL0tK5cRdY5vno4I9xvVe18=
Received: from localhost.localdomain (81.71.33.115 [81.71.33.115]) by mx.zoho.com.cn
        with SMTPS id 1653838736850922.0717547158011; Sun, 29 May 2022 23:38:56 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-media@vger.kernel.org
Cc:     Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20220529153456.4183738-3-cgxu519@mykernel.net>
Subject: [PATCH 2/6] staging: vt6655: fix missing resource cleanup in error cases
Date:   Sun, 29 May 2022 23:34:52 +0800
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220529153456.4183738-1-cgxu519@mykernel.net>
References: <20220529153456.4183738-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix missing resource cleanup(when '(--i) =3D=3D 0') for error cases

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 drivers/staging/vt6655/device_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/=
device_main.c
index 897d70cf32b8..cf8d92e785e6 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -565,7 +565,7 @@ static int device_init_rd0_ring(struct vnt_private *pri=
v)
 =09kfree(desc->rd_info);
=20
 err_free_desc:
-=09while (--i) {
+=09while (--i >=3D 0) {
 =09=09desc =3D &priv->aRD0Ring[i];
 =09=09device_free_rx_buf(priv, desc);
 =09=09kfree(desc->rd_info);
@@ -611,7 +611,7 @@ static int device_init_rd1_ring(struct vnt_private *pri=
v)
 =09kfree(desc->rd_info);
=20
 err_free_desc:
-=09while (--i) {
+=09while (--i >=3D 0) {
 =09=09desc =3D &priv->aRD1Ring[i];
 =09=09device_free_rx_buf(priv, desc);
 =09=09kfree(desc->rd_info);
@@ -676,7 +676,7 @@ static int device_init_td0_ring(struct vnt_private *pri=
v)
 =09return 0;
=20
 err_free_desc:
-=09while (--i) {
+=09while (--i >=3D 0) {
 =09=09desc =3D &priv->apTD0Rings[i];
 =09=09kfree(desc->td_info);
 =09}
@@ -716,7 +716,7 @@ static int device_init_td1_ring(struct vnt_private *pri=
v)
 =09return 0;
=20
 err_free_desc:
-=09while (--i) {
+=09while (--i >=3D 0) {
 =09=09desc =3D &priv->apTD1Rings[i];
 =09=09kfree(desc->td_info);
 =09}
--=20
2.27.0


