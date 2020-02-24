Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 375AA16A0A2
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbgBXIxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:53:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727553AbgBXIxi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 03:53:38 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 440D520880;
        Mon, 24 Feb 2020 08:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582534418;
        bh=jLtAPhwXKRIYi8hoepp1P4IjkM/yEjLYulzEjNIxRGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zOsEW4IkEySlpKnb+omU7upJ/n3o+YVnJdQAlFCltuNHSYGo24LD6X9lQzg2l2f7+
         9FEIZVW7B7RzvsHVAZp7u7D+k+JQ+9scK+PChBYFZYVRuSQ41KrEDHMqkuWLJwO2SD
         XG4pyBDFae1Zi5ccsI3yazBlOvx7NpMoa9ZWbde4=
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
Subject: [PATCH net-next v1 06/18] net/aeroflex: Don't assign FW if it is not available
Date:   Mon, 24 Feb 2020 10:52:59 +0200
Message-Id: <20200224085311.460338-7-leon@kernel.org>
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

If FW version is not available, it is enough to leave that field as
empty, there is no need to write N/A.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/aeroflex/greth.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 198f1544e271..bf546118dbc6 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1115,7 +1115,6 @@ static void greth_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *in
 	strlcpy(info->driver, dev_driver_string(greth->dev),
 		sizeof(info->driver));
 	strlcpy(info->bus_info, greth->dev->bus->name, sizeof(info->bus_info));
-	strlcpy(info->fw_version, "N/A", sizeof(info->fw_version));
 }

 static void greth_get_regs(struct net_device *dev, struct ethtool_regs *regs, void *p)
--
2.24.1

