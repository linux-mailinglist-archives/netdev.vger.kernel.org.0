Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6198617EE72
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgCJCPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgCJCPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 22:15:30 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 806E22467C;
        Tue, 10 Mar 2020 02:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583806529;
        bh=GH/BO2MWQ+OZ5PVmpQhmEuYW6Rf8RLgujj8fZUWiI34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=geR4aYhtDGSmHuRGPHJ0hgPbLEJc2c04UhWM9RNeunDB/N/MHJKfNUolkoPhSu42L
         6QlhUJ+0hMNcg6BJDO5yTBtKt8UnuRM8elXnGJncFn1e1C67kb3U8zGg76x/yDLpkN
         KlHpxg8QOsN7In9c1zL2YM/1gtlzPtQC1s1sOgv8=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, akiyano@amazon.com, netanel@amazon.com,
        gtzalik@amazon.com, irusskikh@marvell.com, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, rmody@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, aelior@marvell.com,
        skalluru@marvell.com, GR-everest-linux-l2@marvell.com,
        opendmb@gmail.com, siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, tariqt@mellanox.com, vishal@chelsio.com,
        leedom@chelsio.com, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 11/15] net: cxgb2: reject unsupported coalescing params
Date:   Mon,  9 Mar 2020 19:15:08 -0700
Message-Id: <20200310021512.1861626-12-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310021512.1861626-1-kuba@kernel.org>
References: <20200310021512.1861626-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->supported_coalesce_params to let
the core reject unsupported coalescing parameters.

This driver did not previously reject unsupported parameters.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 4b8461103dda..99736796e1a0 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -793,6 +793,9 @@ static int get_eeprom(struct net_device *dev, struct ethtool_eeprom *e,
 }
 
 static const struct ethtool_ops t1_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX |
+				     ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL,
 	.get_drvinfo       = get_drvinfo,
 	.get_msglevel      = get_msglevel,
 	.set_msglevel      = set_msglevel,
-- 
2.24.1

