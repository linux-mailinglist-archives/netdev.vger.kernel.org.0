Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC1A3AA3F0
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbhFPTKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbhFPTKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 15:10:42 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5B9C061283
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:08:30 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id v22so6057904lfa.3
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KY/iJP5CpxPVy4NzVmmnCVBH1UfAm8gIg54ojzdUXD8=;
        b=P1zT9Gu1LSZ88LeRKP6sRzDnzJUqE5PCo4PtMgVSVkaDHigpx0KZ5fGaxLLvB4ZWAX
         hTJdsLlfYECLzRvrBREQIyPyWiFo1usLu6xk+S0jc67GN3MCK8qT2B9YpiWaQ6Y/hBBn
         M7U47b+7UAcXsUqTJE3xniO2I9svC7YmleXKMHSTJcparSA0h/KEtm5UvH+QUsflOhRR
         lKlvhRNccFjr4hpFo/mQ9NTTG/WQZaj/HMIR9DKYoKTapJyyuJcWgkUzWkFI58AuCTbG
         HM7yJcR5Va/X5ft3JFw9l0xE49HxFcAN9aVMyATiqCtlm2eTHQpY3SI1GzEYBDikNoXl
         SagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KY/iJP5CpxPVy4NzVmmnCVBH1UfAm8gIg54ojzdUXD8=;
        b=PYaPDVqACrJhvv4W8q/jSxh4mD5kwCfXMb5iiMmK1mvioRSXwLcxBLxkZ3D1e48Lg2
         v8J+6zPf+86364OFeiiM8Rr2wZy3Y9/Y2JTcFR2iHweHRFh5DdDdHg+jKWI126yxYneZ
         G1j+7SPHm3ZuouKDr70O1JPLsQY8+53Syd2bsInSpJxj+Ni3RSXlJhAEepy6i3q+2rUh
         cCAvHoVEEdShkwtliBvEWvMbEeuTKlDeGOIiIsOCJ6KJhUDW6yR071faoAJFtx20LlpT
         htuHgVawJRZfEkrRgQALUcGfNCpKagx7KHZIw5Pwt03RonGEC7KbyHbS/uD+AOIBbI89
         sUBQ==
X-Gm-Message-State: AOAM530ToinvgNrLPAm2aThzNYLMv8PopGF/SkA2SkmqzYBQ6FD8ca7H
        yIQvWDr1Rl6pnDMkb8RRzWjF2Q==
X-Google-Smtp-Source: ABdhPJwdyFEnshUh4uD/8NdkmK2PPYtFF7gDca2r/PyVsV0Qo6ITET4o9SleM/cDqpeQjnHB9ryxaw==
X-Received: by 2002:ac2:4ec1:: with SMTP id p1mr906995lfr.584.1623870508714;
        Wed, 16 Jun 2021 12:08:28 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id h22sm406939ljl.126.2021.06.16.12.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 12:08:28 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org, Marcin Wojtas <mw@semihalf.com>
Subject: [net-next: PATCH v2 7/7] net: mvpp2: remove unused 'has_phy' field
Date:   Wed, 16 Jun 2021 21:07:59 +0200
Message-Id: <20210616190759.2832033-8-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210616190759.2832033-1-mw@semihalf.com>
References: <20210616190759.2832033-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'has_phy' field from struct mvpp2_port is no longer used.
Remove it.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 3 ---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 4a61c90003b5..b9fbc9f000f2 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -1197,9 +1197,6 @@ struct mvpp2_port {
 	/* Firmware node associated to the port */
 	struct fwnode_handle *fwnode;
 
-	/* Is a PHY always connected to the port */
-	bool has_phy;
-
 	/* Per-port registers' base address */
 	void __iomem *base;
 	void __iomem *stats_base;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index a66ed3194015..8362e64a3b28 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6790,7 +6790,6 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	port = netdev_priv(dev);
 	port->dev = dev;
 	port->fwnode = port_fwnode;
-	port->has_phy = !!of_find_property(port_node, "phy", NULL);
 	port->ntxqs = ntxqs;
 	port->nrxqs = nrxqs;
 	port->priv = priv;
-- 
2.29.0

