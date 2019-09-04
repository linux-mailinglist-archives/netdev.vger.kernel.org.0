Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E240A8AEF
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732906AbfIDQBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732887AbfIDQBF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 12:01:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6948523400;
        Wed,  4 Sep 2019 16:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612865;
        bh=klpVdtEgbv3eGiHfTAl0evw55doOwNY6qnhkyJYVt7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1xCM5uErdhgh3KkCnHuTjspnyUe8M/476sr18hA09JXCGYVoxh+60l8wAjqXQaHwU
         pHH6oH5vfscuT7usi1JIdMeYc7LUx9YWkf3ZdCZKGUqa1umDU9ih9evCHodVfvvrDV
         iZWluAvdjVJSxBb6rbShRYvgLALN5hlGodq3bcek=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, SteveM <swm@swm1.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 42/52] sky2: Disable MSI on yet another ASUS boards (P6Xxxx)
Date:   Wed,  4 Sep 2019 11:59:54 -0400
Message-Id: <20190904160004.3671-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160004.3671-1-sashal@kernel.org>
References: <20190904160004.3671-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 189308d5823a089b56e2299cd96589507dac7319 ]

A similar workaround for the suspend/resume problem is needed for yet
another ASUS machines, P6X models.  Like the previous fix, the BIOS
doesn't provide the standard DMI_SYS_* entry, so again DMI_BOARD_*
entries are used instead.

Reported-and-tested-by: SteveM <swm@swm1.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/sky2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 4ade864c8d531..d013f30019b69 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4954,6 +4954,13 @@ static const struct dmi_system_id msi_blacklist[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "P6T"),
 		},
 	},
+	{
+		.ident = "ASUS P6X",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "P6X"),
+		},
+	},
 	{}
 };
 
-- 
2.20.1

