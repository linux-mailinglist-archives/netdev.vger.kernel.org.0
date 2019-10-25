Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 452B6E4D3F
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 15:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632897AbfJYN7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 09:59:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731381AbfJYN7F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 09:59:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE21921E6F;
        Fri, 25 Oct 2019 13:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011944;
        bh=luNhTd4Wph/2JoBgh1xl7TIz2ZYbQxAZF6SRn6Jv7ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/VDpWfAZAoYbxSNjCuKoMz8sPp9gTCvESPo4S3bclgPObIESKExTOjJZe+rC4wE5
         ea+1bS3NtGJhhOOFa7ZVgxc5gKP7gcYOR9UflTAgiXnGkk8RcECjeV2vuxlIaCpHBf
         o2EC19yKKe3YI0KUo2XGdfcRHRlfMry2OMsqJQHk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        syzbot+f1842130bbcfb335bac1@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 10/16] net: usb: sr9800: fix uninitialized local variable
Date:   Fri, 25 Oct 2019 09:58:34 -0400
Message-Id: <20191025135842.25977-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135842.25977-1-sashal@kernel.org>
References: <20191025135842.25977-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Valentin Vidic <vvidic@valentin-vidic.from.hr>

[ Upstream commit 77b6d09f4ae66d42cd63b121af67780ae3d1a5e9 ]

Make sure res does not contain random value if the call to
sr_read_cmd fails for some reason.

Reported-by: syzbot+f1842130bbcfb335bac1@syzkaller.appspotmail.com
Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/sr9800.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/sr9800.c b/drivers/net/usb/sr9800.c
index 004c955c1fd1b..da0ae16f5c74c 100644
--- a/drivers/net/usb/sr9800.c
+++ b/drivers/net/usb/sr9800.c
@@ -336,7 +336,7 @@ static void sr_set_multicast(struct net_device *net)
 static int sr_mdio_read(struct net_device *net, int phy_id, int loc)
 {
 	struct usbnet *dev = netdev_priv(net);
-	__le16 res;
+	__le16 res = 0;
 
 	mutex_lock(&dev->phy_mutex);
 	sr_set_sw_mii(dev);
-- 
2.20.1

