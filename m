Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51E4AFA2A6
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730817AbfKMCBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:01:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:57752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730807AbfKMCBj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 21:01:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 779B722490;
        Wed, 13 Nov 2019 02:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610499;
        bh=uxxm2wLEUgiQS5Hy+cXBEGA8D64YhyjFzfss5q81di0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dk5XdHtgSbWNzPlcXK2FB5NA6L35kECo5jMTTgPekgz0EzZ4PtrAuZPVZ9wHjHqbx
         6bo0jVag4tKrfb7teK0mWGdk798sAqKS7/Hc/ga6Td8m9hqwybZqOnGJojo+qlDhaa
         nZcIbsZp6nxIj/xT+QwjVvHQ+QrGQVRk2xDF8erE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Simon Wunderlich <sw@simonwunderlich.de>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 06/48] ath9k: fix reporting calculated new FFT upper max
Date:   Tue, 12 Nov 2019 21:00:49 -0500
Message-Id: <20191113020131.13356-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113020131.13356-1-sashal@kernel.org>
References: <20191113020131.13356-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Wunderlich <sw@simonwunderlich.de>

[ Upstream commit 4fb5837ac2bd46a85620b297002c704e9958f64d ]

Since the debug print code is outside of the loop, it shouldn't use the loop
iterator anymore but instead print the found maximum index.

Cc: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 03945731eb65a..ec805fe6dddbb 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -411,7 +411,7 @@ ath_cmn_process_ht20_40_fft(struct ath_rx_status *rs,
 
 		ath_dbg(common, SPECTRAL_SCAN,
 			"Calculated new upper max 0x%X at %i\n",
-			tmp_mag, i);
+			tmp_mag, fft_sample_40.upper_max_index);
 	} else
 	for (i = dc_pos; i < SPECTRAL_HT20_40_NUM_BINS; i++) {
 		if (fft_sample_40.data[i] == (upper_mag >> max_exp))
-- 
2.20.1

