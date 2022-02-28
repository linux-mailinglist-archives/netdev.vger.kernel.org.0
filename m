Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCDA4C6BDA
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 13:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbiB1MKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 07:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiB1MKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 07:10:48 -0500
Received: from mx.tkos.co.il (guitar.tcltek.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5241A65D06
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 04:10:09 -0800 (PST)
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 7CEAD440F8D;
        Mon, 28 Feb 2022 14:09:27 +0200 (IST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1646050167;
        bh=E2MMN69dcGNxkn8xHGLbTClfgrl4qAPiGO37ixK9Q6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTiV1r7U/P9tI02xs6RZ39oYFw/XkVbUC3NU5Q5bbWKTyfx51xmpDthbEjTyiUgXb
         PxXVgKgA1mxkcKMjVccVA89kNLgL0uTrI2g6p8N1MVk2luS9WWtu8mrVxNtAIQQpRz
         71bkTeC9w6L7vIoMR1QJQStY7iB07ig+0PG+kUNx4GJVZobVN2uP8w0iynUTDp+YsB
         hAKtnZ7GAzBGrLEnGtHwPYt2vcZrtTkc9tc7ETyN7ja1f2wjRWuxT3l6CAR5bdW+Xl
         331HkYgTWLhW4/SiL1hjPHOZpfa1PvffLNvcRhGyWIFRfgwC4nqktQnkdnIue0ZrB4
         vhGuGY36WvwRg==
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Baruch Siach <baruch.siach@siklu.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next 2/2] net: dsa: mv88e6xxx: support RMII cmode
Date:   Mon, 28 Feb 2022 14:10:03 +0200
Message-Id: <a962d1ccbeec42daa10dd8aff0e66e31f0faf1eb.1646050203.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cd95cf3422ae8daf297a01fa9ec3931b203cdf45.1646050203.git.baruch@tkos.co.il>
References: <cd95cf3422ae8daf297a01fa9ec3931b203cdf45.1646050203.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baruch Siach <baruch.siach@siklu.com>

Add support for direct RMII MAC mode. This allows hardware with CPU port
connected in direct 100M fixed link to work properly.

Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
---
 drivers/net/dsa/mv88e6xxx/port.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index a58997f1fd69..795b3128768f 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -550,6 +550,9 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		mode = PHY_INTERFACE_MODE_1000BASEX;
 
 	switch (mode) {
+	case PHY_INTERFACE_MODE_RMII:
+		cmode = MV88E6XXX_PORT_STS_CMODE_RMII;
+		break;
 	case PHY_INTERFACE_MODE_1000BASEX:
 		cmode = MV88E6XXX_PORT_STS_CMODE_1000BASEX;
 		break;
-- 
2.34.1

