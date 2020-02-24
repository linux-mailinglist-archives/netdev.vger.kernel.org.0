Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C75516A082
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbgBXIxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:53:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727655AbgBXIxt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 03:53:49 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 937492187F;
        Mon, 24 Feb 2020 08:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582534428;
        bh=LUxYTwwdwf6SHIjajoLDNPMJKCyZMEOBchMPulk8V+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xf6bxCQVjrbPD1yNAqNMJxDdwz23WBF6fa9g7Ckp6zWe+GxeC0iSpZYdMccNPNm7E
         M4Xq4O3XW/jHdWxMaXt+dXlhJ4MlVsDUlntN4Kvc0eD5Fo/E5bDY4Lx3fOUBb4gIX+
         WsPc+pfW9mph/3bgGuTnd6NS8B3GDoYjYYxZoZ1A=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Don Fry <pcnet32@frontier.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>, linux-acenic@sunsite.dk,
        Maxime Ripard <mripard@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Mark Einon <mark.einon@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        linux-rockchip@lists.infradead.org,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        David Dillow <dave@thedillows.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        linux-arm-kernel@lists.infradead.org,
        Andreas Larsson <andreas@gaisler.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        Thor Thayer <thor.thayer@linux.intel.com>,
        linux-kernel@vger.kernel.org, Ion Badulescu <ionut@badula.org>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        nios2-dev@lists.rocketboards.org, Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH net-next v1 10/18] net/alteon: Properly report FW version
Date:   Mon, 24 Feb 2020 10:53:03 +0200
Message-Id: <20200224085311.460338-11-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200224085311.460338-1-leon@kernel.org>
References: <20200224085311.460338-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The acenic driver assigns FW version in driver version field,
as part of cleanup driver version, set FW version properly.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/alteon/acenic.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index f366faf88eee..5d192d551623 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -2699,9 +2699,8 @@ static void ace_get_drvinfo(struct net_device *dev,
 	struct ace_private *ap = netdev_priv(dev);

 	strlcpy(info->driver, "acenic", sizeof(info->driver));
-	snprintf(info->version, sizeof(info->version), "%i.%i.%i",
-		 ap->firmware_major, ap->firmware_minor,
-		 ap->firmware_fix);
+	snprintf(info->fw_version, sizeof(info->version), "%i.%i.%i",
+		 ap->firmware_major, ap->firmware_minor, ap->firmware_fix);

 	if (ap->pdev)
 		strlcpy(info->bus_info, pci_name(ap->pdev),
--
2.24.1

