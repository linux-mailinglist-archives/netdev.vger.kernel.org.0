Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB27353719E
	for <lists+netdev@lfdr.de>; Sun, 29 May 2022 17:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiE2PjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 11:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiE2PjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 11:39:15 -0400
Received: from sender2-op-o12.zoho.com.cn (sender2-op-o12.zoho.com.cn [163.53.93.243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C5762CF4;
        Sun, 29 May 2022 08:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1653838741;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:From:To:To:Cc:Cc:Message-ID:Subject:Subject:Date:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
        bh=daX12GWew3IwCy2KNmUXjEytC9BpO3UdZ4OA9NkkNJQ=;
        b=VkNQu0/8lYhufkUBrHbwvdLG1P4OU7QAocD+n+MvS9sCVDVAuHtVUDl0e+JILLhQ
        3khGf4mMAU9jpkWQhePNdXUyU0f0XQz7RJoSWaZvOHoost6JFTXR8x8pI4zWfLvWy09
        2c88LvaRZAvqQCA0KziiAk1HDoWXNzSmrGai4Wp0=
Received: from localhost.localdomain (81.71.33.115 [81.71.33.115]) by mx.zoho.com.cn
        with SMTPS id 1653838739745377.08340585932433; Sun, 29 May 2022 23:38:59 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-media@vger.kernel.org
Cc:     Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20220529153456.4183738-5-cgxu519@mykernel.net>
Subject: [PATCH 4/6] drm/exynos: fix missing resource cleanup in error case
Date:   Sun, 29 May 2022 23:34:54 +0800
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

Fix missing resource cleanup(when '(--i) =3D=3D 0') for error case
in gsc_runtime_resume().

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 drivers/gpu/drm/exynos/exynos_drm_gsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exyn=
os/exynos_drm_gsc.c
index 964dceb28c1e..68ea92742b06 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1342,7 +1342,7 @@ static int __maybe_unused gsc_runtime_resume(struct d=
evice *dev)
 =09for (i =3D 0; i < ctx->num_clocks; i++) {
 =09=09ret =3D clk_prepare_enable(ctx->clocks[i]);
 =09=09if (ret) {
-=09=09=09while (--i > 0)
+=09=09=09while (--i >=3D 0)
 =09=09=09=09clk_disable_unprepare(ctx->clocks[i]);
 =09=09=09return ret;
 =09=09}
--=20
2.27.0


