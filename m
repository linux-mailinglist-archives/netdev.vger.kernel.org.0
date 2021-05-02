Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFEE370C92
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 16:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhEBOGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 10:06:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232201AbhEBOGL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 10:06:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C01161446;
        Sun,  2 May 2021 14:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964319;
        bh=i6nxWaGnI13Ya4iWXKJbLda0atge26fqRNEacbktChY=;
        h=From:To:Cc:Subject:Date:From;
        b=A/xaRMqeLnHjUl2OLPT9JQhEWWiSUa0SMLpHropf51WSEdKLKXFZgiz6kQGHmSz+N
         pZJpjs8+CnOc/vPYj/bX4zhY1qzxbSoTBxvZWVB4v1YpIOs1ksZCeoWvs0a1phjwBy
         mVNpTME7bnKJjDdQ55TP7fHtBc21TaAdPc8/Z811TUt7JDP7EaNYsuCxWD03YiPXDt
         UjeUw0dMACGo0EF6EYehEdxYSk9aa5sjcPn7eN9Er+SliugXpanQzURgKzLEgEJ19Q
         qaZi4aDGJ5NnAH/yjq/yP6L/lccp4YBIm9Iss/8xw4PTdla1EOHZUxZqyrKX/1rQWl
         OfyR4BwqPIppQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     karthik alapati <mail@karthek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/21] staging: wimax/i2400m: fix byte-order issue
Date:   Sun,  2 May 2021 10:04:57 -0400
Message-Id: <20210502140517.2719912-1-sashal@kernel.org>
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

