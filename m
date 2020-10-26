Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBDBE29A009
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442563AbgJ0A0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410029AbgJZXxS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:53:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05F5521655;
        Mon, 26 Oct 2020 23:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756397;
        bh=OJovw4+EE6T2tMZzZ9+KnmyKFUOqNYdMeRbOvfdLj0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x2ylyT3xcPLHzsj/mWOnSM9k7ix4PfJLWJgT/c4VRpxIdo9JkV5TtyRf51832p83l
         batII8eJ7BcGmt1sKLpB9ZiGw9ZRCpvo8thyEGsYdvqAMJzBWzI+a94/B5w9CmzxYx
         JUjU9F3TWu0uQWLTuYlMAKWNFdehggSFFaX0fa/k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 058/132] nfc: s3fwrn5: Add missing CRYPTO_HASH dependency
Date:   Mon, 26 Oct 2020 19:50:50 -0400
Message-Id: <20201026235205.1023962-58-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 4aa62c62d4c41d71b2bda5ed01b78961829ee93c ]

The driver uses crypto hash functions so it needs to select CRYPTO_HASH.
This fixes build errors:

  arc-linux-ld: drivers/nfc/s3fwrn5/firmware.o: in function `s3fwrn5_fw_download':
  firmware.c:(.text+0x152): undefined reference to `crypto_alloc_shash'

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/s3fwrn5/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/s3fwrn5/Kconfig b/drivers/nfc/s3fwrn5/Kconfig
index af9d18690afeb..3f8b6da582803 100644
--- a/drivers/nfc/s3fwrn5/Kconfig
+++ b/drivers/nfc/s3fwrn5/Kconfig
@@ -2,6 +2,7 @@
 config NFC_S3FWRN5
 	tristate
 	select CRYPTO
+	select CRYPTO_HASH
 	help
 	  Core driver for Samsung S3FWRN5 NFC chip. Contains core utilities
 	  of chip. It's intended to be used by PHYs to avoid duplicating lots
-- 
2.25.1

