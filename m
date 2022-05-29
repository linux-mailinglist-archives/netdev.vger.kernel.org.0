Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265055371A5
	for <lists+netdev@lfdr.de>; Sun, 29 May 2022 17:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbiE2Pj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 11:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbiE2PjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 11:39:18 -0400
Received: from sender2-op-o12.zoho.com.cn (sender2-op-o12.zoho.com.cn [163.53.93.243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E43C62CFF;
        Sun, 29 May 2022 08:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1653838743;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:From:To:To:Cc:Cc:Message-ID:Subject:Subject:Date:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
        bh=X/Nq01tIJiL66k1gHdv7dx/ePbQHb3DUAurLiy4DtgY=;
        b=Fxu+1huBl4/KM9ltkTR62MbYdabZL04hTFCByM3kfUr9KQF+biVFQn04SW5kP1Q1
        d5FpcnH+HjpXz3YGGZs8hNGV7vmMhcINJN8I3dyyTu3u5GPC3BA13oZEbKWyod0tHYM
        x4zAoZp93gXnnqBdI3yIffL8VH3rnYxVVye1HRYM=
Received: from localhost.localdomain (81.71.33.115 [81.71.33.115]) by mx.zoho.com.cn
        with SMTPS id 1653838741319791.7650617890589; Sun, 29 May 2022 23:39:01 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-media@vger.kernel.org
Cc:     Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20220529153456.4183738-6-cgxu519@mykernel.net>
Subject: [PATCH 5/6] scsi: pmcraid: fix missing resource cleanup in error case
Date:   Sun, 29 May 2022 23:34:55 +0800
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

Fix missing resource cleanup(when '(--i) =3D=3D 0') for error case in
pmcraid_register_interrupt_handler().

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 drivers/scsi/pmcraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 3d5cd337a2a6..0007a8a993a1 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4031,7 +4031,7 @@ pmcraid_register_interrupt_handler(struct pmcraid_ins=
tance *pinstance)
 =09return 0;
=20
 out_unwind:
-=09while (--i > 0)
+=09while (--i >=3D 0)
 =09=09free_irq(pci_irq_vector(pdev, i), &pinstance->hrrq_vector[i]);
 =09pci_free_irq_vectors(pdev);
 =09return rc;
--=20
2.27.0


