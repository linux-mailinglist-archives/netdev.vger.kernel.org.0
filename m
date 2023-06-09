Return-Path: <netdev+bounces-9551-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ABAC729BA4
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:32:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B41AC2818A2
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 13:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCEFC17732;
	Fri,  9 Jun 2023 13:32:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF81747F
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9F5C433EF;
	Fri,  9 Jun 2023 13:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686317530;
	bh=GzVyjaMKsSNVMyIcLo7GRDB/ojwZw/meKMPwZHpibwQ=;
	h=From:Date:Subject:To:Cc:From;
	b=pg21tS0He519d2oJnfWU3lvKGfWYooKUJAKp8DH7fWdjyHAhHiRkNbwLx4tvLvzfq
	 QAlUktSlu7zvyCOw+xZXlODfEoZd8Lz0QFWI3eJYAXngBhLfwuZNBW6lax3R1vy1+B
	 WGhgD9Jh2NvD80pfz7G0avRaYR7C2CNH3031isERLy5rXcJV+b529IS0rm13s6/fVY
	 QRq+PxotEO/bwgKMTpN3e/AH4kwm5a76o5iYNdx6yFsK83sMO8GycMUwV75DiBf5fy
	 S4bQd1QMnuxTcXn5WZkVcCMYhiEGalDU0dtgBc8cKGtOPY1ByurzHLBhr7/YhZcUd3
	 FrilxM+HDupeA==
From: Simon Horman <horms@kernel.org>
Date: Fri, 09 Jun 2023 15:31:57 +0200
Subject: [PATCH net-next v2] nfc: nxp-nci: store __be16 value in __be16
 variable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230608-nxp-nci-be16-v2-1-cd9fa22a41fd@kernel.org>
X-B4-Tracking: v=1; b=H4sIAMwpg2QC/22NQQ6CMBBFr2Jm7RhaENCV9zAs2jrARDKQKRIM4
 e42rF2+//PyNoikTBHupw2UFo48SgJ7PkHonXSE/EoMNrN5VmY1yjqhBEZPpkRT5aG+2bqtCg9
 J8S4SenUS+iTJZxjSOCm1vB6NJwjNKLTO0KSn5ziP+j3iizn+/53FoEFbuNQrrt5W7vEmFRouo
 3bQ7Pv+A1RpBQ7IAAAA
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, 
 Luca Ceresoli <luca.ceresoli@bootlin.com>, Michael Walle <michael@walle.cc>, 
 =?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, 
 Sridhar Samudrala <sridhar.samudrala@intel.com>, 
 Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>, 
 netdev@vger.kernel.org
X-Mailer: b4 0.12.2

Use a __be16 variable to store the big endian value of header in
nxp_nci_i2c_fw_read().

Flagged by Sparse as:

 .../i2c.c:113:22: warning: cast to restricted __be16

No functional changes intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
---
Changes in v2:
- Corrected grammar in patch description (Kalesh Anakkur Purayil)
- Added reviewed-by tag from Sridhar Samudrala
- Link to v1: https://lore.kernel.org/r/20230608-nxp-nci-be16-v1-1-24a17345b27a@kernel.org
---
 drivers/nfc/nxp-nci/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index baddaf242d18..dca25a0c2f33 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -97,8 +97,8 @@ static int nxp_nci_i2c_fw_read(struct nxp_nci_i2c_phy *phy,
 			       struct sk_buff **skb)
 {
 	struct i2c_client *client = phy->i2c_dev;
-	u16 header;
 	size_t frame_len;
+	__be16 header;
 	int r;
 
 	r = i2c_master_recv(client, (u8 *) &header, NXP_NCI_FW_HDR_LEN);


