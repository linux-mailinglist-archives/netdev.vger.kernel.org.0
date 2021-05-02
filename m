Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96636370CF6
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 16:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbhEBOIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 10:08:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232724AbhEBOHT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 10:07:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73751613F0;
        Sun,  2 May 2021 14:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964368;
        bh=i6nxWaGnI13Ya4iWXKJbLda0atge26fqRNEacbktChY=;
        h=From:To:Cc:Subject:Date:From;
        b=qj2103Egyq5iEHEphZvShYxxC2x6xov0VahYi4tBVyW+gjEOdZ+lJ5Dyc6eX2x0qr
         5Q82Nz9Gydya7o2JInAMDuOCPbAwDBMyMyyOs3kxTNtJ6dujlOBLhsxgPE1z8fJzpB
         GHhXurSyRgelw5PT+bZIInLXvcGH6GUAzGbNX4rE3QZCzY3w+2eFVtsxfCT+d5Dc1w
         B8W6hZqs+GPy6jhOVrdKMVDSbE7qgNqkabYDP3mmM3Ap9hLtACY9ehvK1tGH/NO26T
         xjgKK+60ECQdC2o92n5PpJCpvcNIspgVfDUdWfd4RCXgbOlTX6+VowTR7BQNMVeQWr
         gv4noZkXUQ2pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     karthik alapati <mail@karthek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 01/12] staging: wimax/i2400m: fix byte-order issue
Date:   Sun,  2 May 2021 10:05:55 -0400
Message-Id: <20210502140606.2720323-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
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
index dc6fe93ce71f..e8473047b2d1 100644
--- a/drivers/net/wimax/i2400m/op-rfkill.c
+++ b/drivers/net/wimax/i2400m/op-rfkill.c
@@ -101,7 +101,7 @@ int i2400m_op_rfkill_sw_toggle(struct wimax_dev *wimax_dev,
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

