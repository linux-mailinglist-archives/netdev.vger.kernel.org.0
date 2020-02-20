Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B871F166039
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 15:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgBTO73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 09:59:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbgBTO72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 09:59:28 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FC9B206F4;
        Thu, 20 Feb 2020 14:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582210768;
        bh=LUxYTwwdwf6SHIjajoLDNPMJKCyZMEOBchMPulk8V+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAYPqETvPI3+Z+JGJxL/f/PT0/8bonrQJ7E5/aRkXzpdAh+j8uv3+XLwNtQwQdOsd
         PYqCIanvIS3GQDoimKKhlCm5E5vr+gsRPkBKYesboKxITTSDAeBTDrJlL2gJvqwemN
         yAtXQHzjyqkdkJ7L+HkuO6cWWxgInk4wFHo1Qr/w=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net-next 09/16] net/alteon: Properly report FW version
Date:   Thu, 20 Feb 2020 16:58:48 +0200
Message-Id: <20200220145855.255704-10-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220145855.255704-1-leon@kernel.org>
References: <20200220145855.255704-1-leon@kernel.org>
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

