Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9032A29CB
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728685AbgKBLrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgKBLqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:46:01 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C70C0401C6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:57 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id 33so3428599wrl.7
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PCJb8WRZZMprUiDuUrCCgk0qpYM+re9rQeuSrQaWY/Y=;
        b=jzCNUlgPqonybZGC9xi6yfUkXjrLgYS6Y7E0FluwJYKBuaSC55hE9+6HTGWXXasTVQ
         6PYP//yPFBxL+EPmhuVDOP/fLknimjudGTxtWw+b30dXehEq8woplqI6gSJBOyxyCg9w
         nZkMigvlHJkx8zzxPyBRu8YrhRil58NV14HYbifDU+aFIx8P9SG48UcsG7L7CaK4mIK1
         qZ5ABtHzZmBr472oSWyGjL+MVsIVdDaov0mo2ZT6f9ray7ul2k4VUddmDEsYG0rxtcZl
         iRA6D0XmWzuJypSBT28JJKhiVOYKuEzv3oxiBVmOOVL91fipPjncZr8WhC6ShVllZMgq
         fmsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PCJb8WRZZMprUiDuUrCCgk0qpYM+re9rQeuSrQaWY/Y=;
        b=E9JDBbhI70ySmrtqwxfZWLE11nxdz94R5g5JWj/kNgVukZHUk9TMz3HQKhCB+MaATO
         UGXDjtZ1wzK0EHuHuXdLiYTfaRgbbOvgaemDi4RJJ51EU4vnBfHSBESPpCp8QlQE/uOJ
         SHSHrazKggVSlB67Cz7TZk0VlvpGwRGghfcoKyzMMMH3djv+LxBT/xDIWMKXCZomap+v
         ZWo0hKHWn7kQDeoC+ljwLtTYkrS00kZ7soSVX8QLemEnDLW/M9ReBRlVXc05E2dta1Mx
         /3SK4ytHAqHWtSj0ti2ODmCRHEORxYIeQng7FD09wCj7jw6sjZqkO8jGEYxalgZx6lef
         xh/A==
X-Gm-Message-State: AOAM533zl9A44g9XfMhPxeBjorSJ/VRKUWnxu9YFvcWJB/14aB75i+D8
        /4o4rqfEqRwlMz5d0aZDTQNwtg==
X-Google-Smtp-Source: ABdhPJxcxe2k7Y3U2mdQ5lLdFpWzE9sCSbTrnu9RLba5DQPaSQe+9Mm8Lnvu+2wktpZcupxuZRPutw==
X-Received: by 2002:adf:eb4d:: with SMTP id u13mr18862571wrn.146.1604317556383;
        Mon, 02 Nov 2020 03:45:56 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:55 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>, Nicolas Pitre <nico@fluxnic.net>,
        Jakub Kicinski <kuba@kernel.org>, Erik Stahlman <erik@vt.edu>,
        Peter Cammaert <pc@denkart.be>,
        Daris A Nevil <dnevil@snmc.com>,
        Russell King <rmk@arm.linux.org.uk>, netdev@vger.kernel.org
Subject: [PATCH 30/30] net: ethernet: smsc: smc91x: Mark 'pkt_len' as __maybe_unused
Date:   Mon,  2 Nov 2020 11:45:12 +0000
Message-Id: <20201102114512.1062724-31-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'pkt_len' is used to interact with a hardware register.  It might not
be safe to remove it entirely.  Mark it as __maybe_unused instead.

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/smsc/smc91x.c: In function ‘smc_tx’:
 drivers/net/ethernet/smsc/smc91x.c:706:51: warning: variable ‘pkt_len’ set but not used [-Wunused-but-set-variable]

Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Erik Stahlman <erik@vt.edu>
Cc: Peter Cammaert <pc@denkart.be>
Cc: Daris A Nevil <dnevil@snmc.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/smsc/smc91x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index b5d053292e717..a3f37b1f86491 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -703,7 +703,7 @@ static void smc_tx(struct net_device *dev)
 {
 	struct smc_local *lp = netdev_priv(dev);
 	void __iomem *ioaddr = lp->base;
-	unsigned int saved_packet, packet_no, tx_status, pkt_len;
+	unsigned int saved_packet, packet_no, tx_status, __maybe_unused pkt_len;
 
 	DBG(3, dev, "%s\n", __func__);
 
-- 
2.25.1

