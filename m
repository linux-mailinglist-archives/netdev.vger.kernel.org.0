Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8548A53718F
	for <lists+netdev@lfdr.de>; Sun, 29 May 2022 17:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbiE2PjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 11:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiE2PjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 11:39:12 -0400
Received: from sender2-op-o12.zoho.com.cn (sender2-op-o12.zoho.com.cn [163.53.93.243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD12862CF2;
        Sun, 29 May 2022 08:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1653838734;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:From:To:To:Cc:Cc:Message-ID:Subject:Subject:Date:Date:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
        bh=H/7tQvtUiqi0ZJQmTxMoDoDs/okaMbJa/iz0nsWrZos=;
        b=XqgBJ5yCJqSPQ/aDKSeP8W34gSaSsT2m5ylRPK9XOjRSVSAjln1QDS3FGL5zmWVH
        a63vXBYuOriHpDzDdpNFldOQDXIVl+CSxnCpWRbJUu3i5iKnbA24zkEvg2vkTP84D0F
        Vg2ehgeM1Wq/+cyK5bmeXw5ljhbq1CSS67jqMsek=
Received: from localhost.localdomain (81.71.33.115 [81.71.33.115]) by mx.zoho.com.cn
        with SMTPS id 1653838730991907.8340407713124; Sun, 29 May 2022 23:38:50 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-media@vger.kernel.org
Cc:     Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20220529153456.4183738-1-cgxu519@mykernel.net>
Subject: [PATCH 0/6] fix a common error of while loop condition in error path
Date:   Sun, 29 May 2022 23:34:50 +0800
X-Mailer: git-send-email 2.27.0
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

There is a common error of while loop condition which misses
the case '(--i) =3D=3D 0' in error path. This patch series just
tries to fix it in several driver's code.

Note: I'm not specialist of specific drivers so just compile tested
for the fixes.

Chengguang Xu (6):
  netlink: fix missing destruction of rhash table in error case
  staging: vt6655: fix missing resource cleanup in error cases
  scsi: ipr: fix missing/incorrect resource cleanup in error case
  drm/exynos: fix missing resource cleanup in error case
  scsi: pmcraid: fix missing resource cleanup in error case
  media: platform: fix missing/incorrect resource cleanup in error case

 drivers/gpu/drm/exynos/exynos_drm_gsc.c             | 2 +-
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc_pm.c | 3 +--
 drivers/scsi/ipr.c                                  | 4 ++--
 drivers/scsi/pmcraid.c                              | 2 +-
 drivers/staging/vt6655/device_main.c                | 8 ++++----
 net/netlink/af_netlink.c                            | 2 +-
 6 files changed, 10 insertions(+), 11 deletions(-)

--=20
2.27.0


