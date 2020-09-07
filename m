Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1F825FF91
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730757AbgIGQee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:34:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730744AbgIGQeR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:34:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF28D21D80;
        Mon,  7 Sep 2020 16:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496450;
        bh=aL8L4JPV6nAQVF+hiDzhbM35OeSZuT8Epx32RXWWXkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qIegqkdXRUNIzgsdqt9GXFL9yfIuMK/n4mqKWXt0DaTkU91Sj1ygcoG8Xgmrx5MG9
         Vnb4dCxbmbAcTasKVnSNumSfu0Xzdg2cPd4NavthsL/NpNa7l10G+WRKPH4a7H2c3S
         AfW9erpDhoecCFW40Olal3rHlO1tJO0tGRbT1GGc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>, Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 32/43] drivers/net/wan/hdlc_cisco: Add hard_header_len
Date:   Mon,  7 Sep 2020 12:33:18 -0400
Message-Id: <20200907163329.1280888-32-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163329.1280888-1-sashal@kernel.org>
References: <20200907163329.1280888-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 1a545ebe380bf4c1433e3c136e35a77764fda5ad ]

This driver didn't set hard_header_len. This patch sets hard_header_len
for it according to its header_ops->create function.

This driver's header_ops->create function (cisco_hard_header) creates
a header of (struct hdlc_header), so hard_header_len should be set to
sizeof(struct hdlc_header).

Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Acked-by: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc_cisco.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/hdlc_cisco.c b/drivers/net/wan/hdlc_cisco.c
index a030f5aa6b951..cc33441af4691 100644
--- a/drivers/net/wan/hdlc_cisco.c
+++ b/drivers/net/wan/hdlc_cisco.c
@@ -370,6 +370,7 @@ static int cisco_ioctl(struct net_device *dev, struct ifreq *ifr)
 		memcpy(&state(hdlc)->settings, &new_settings, size);
 		spin_lock_init(&state(hdlc)->lock);
 		dev->header_ops = &cisco_header_ops;
+		dev->hard_header_len = sizeof(struct hdlc_header);
 		dev->type = ARPHRD_CISCO;
 		call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE, dev);
 		netif_dormant_on(dev);
-- 
2.25.1

