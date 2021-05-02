Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F49370C44
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 16:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbhEBOFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 10:05:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232335AbhEBOF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 10:05:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6EDC613C1;
        Sun,  2 May 2021 14:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964277;
        bh=hmda4udHlhfXRGvjMOV2Sxko/NrL1F2an3CsQ1mgtCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kY348sDWK4tWN4+YiNw+oNTXwT63hcrwe4C9ftg/TFULTBZlOdxsJ8C6qQVvwIbQX
         bGbLGQWKTJ7NeOz5X3EJX2RvAPWEppoWLKRNDcXhkmwexZdvfcD67cWB3KTJbh6VK7
         RxKFlHq9d/iSCJDQKUV1oN9Ky9kn0qkcbU7bJ43lVZVxvAN2Extzh7B5qp2BfTJunt
         KNuuR9dVgrsJmqBq6gKRF/GmsbhK/GH+h++XKKRbjL8JPN/tGGu3sQ7ElsO2XzoS3q
         lo8yTuMpgcSgWRlz9D/hKQfumFPM0RX8wiI3ch6NptJj0CpROUBeq7+PWkK3ZVdyHz
         FTaK3xigIYVEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     karthik alapati <mail@karthek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/34] staging: wimax/i2400m: fix byte-order issue
Date:   Sun,  2 May 2021 10:04:02 -0400
Message-Id: <20210502140434.2719553-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140434.2719553-1-sashal@kernel.org>
References: <20210502140434.2719553-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: karthik alapati <mail@karthek.com>

[ Upstream commit 0c37baae130df39b19979bba88bde2ee70a33355 ]

fix sparse byte-order warnings by converting host byte-order
type to __le16 byte-order types before assigning to hdr.length

Signed-off-by: karthik alapati <mail@karthek.com>
Link: https://lore.kernel.org/r/0ae5c5c4c646506d8be871e7be5705542671a1d5.1613921277.git.mail@karthek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wimax/i2400m/op-rfkill.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wimax/i2400m/op-rfkill.c b/drivers/net/wimax/i2400m/op-rfkill.c
index 5c79f052cad2..34f81f16b5a0 100644
--- a/drivers/net/wimax/i2400m/op-rfkill.c
+++ b/drivers/net/wimax/i2400m/op-rfkill.c
@@ -86,7 +86,7 @@ int i2400m_op_rfkill_sw_toggle(struct wimax_dev *wimax_dev,
 	if (cmd == NULL)
 		goto error_alloc;
 	cmd->hdr.type = cpu_to_le16(I2400M_MT_CMD_RF_CONTROL);
-	cmd->hdr.length = sizeof(cmd->sw_rf);
+	cmd->hdr.length = cpu_to_le16(sizeof(cmd->sw_rf));
 	cmd->hdr.version = cpu_to_le16(I2400M_L3L4_VERSION);
 	cmd->sw_rf.hdr.type = cpu_to_le16(I2400M_TLV_RF_OPERATION);
 	cmd->sw_rf.hdr.length = cpu_to_le16(sizeof(cmd->sw_rf.status));
-- 
2.30.2

