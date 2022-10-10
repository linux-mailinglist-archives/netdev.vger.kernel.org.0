Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57C05F969B
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 03:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiJJB3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 21:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiJJB3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 21:29:51 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB466FD2D
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 18:29:42 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id D0359504AE0;
        Mon, 10 Oct 2022 04:26:14 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru D0359504AE0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1665365175; bh=PWwRId+yde+GfxkveeLZJEWRmwtTwOkpSUTt+ioN15I=;
        h=From:To:Cc:Subject:Date:From;
        b=sfT3j2DR4XNIowmicyROqcMokv5Ekv/ri68av2/gitz+16TnRntpYztzTwtSlumiV
         UkoP1QUnwt1tYKEdQhti4nh8CFG9zPrfDkgDDfrZQDMuJLV0DXJLhMa0baxs6FDNLc
         YtxcmVhxjGo5NQ4t3z+ic+cCSxMVEjzayHt5zh8c=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        Vadim Fedorenko <vadfed@fb.com>
Subject: [[PATCH net]] ptp: ocp: remove symlink for second GNSS
Date:   Mon, 10 Oct 2022 04:29:34 +0300
Message-Id: <20221010012934.25639-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Destroy code doesn't remove symlink for ttyGNSS2 device introduced
earlier. Add cleanup code.

Fixes: 71d7e0850476 ("ptp: ocp: Add second GNSS device")
Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
---
 drivers/ptp/ptp_ocp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index d36c3f597f77..a48d9b7d2921 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -3657,6 +3657,7 @@ ptp_ocp_detach_sysfs(struct ptp_ocp *bp)
 	struct device *dev = &bp->dev;
 
 	sysfs_remove_link(&dev->kobj, "ttyGNSS");
+	sysfs_remove_link(&dev->kobj, "ttyGNSS2");
 	sysfs_remove_link(&dev->kobj, "ttyMAC");
 	sysfs_remove_link(&dev->kobj, "ptp");
 	sysfs_remove_link(&dev->kobj, "pps");
-- 
2.27.0

