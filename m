Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0EA1FA61A
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbfKMBvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:51:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:38426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727678AbfKMBvH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:51:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FC32222CE;
        Wed, 13 Nov 2019 01:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609867;
        bh=QSLuD+YpzU6b8rUYnHY1H1u65Kcdamyi0w+ofodb1vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2gr41mHLYu+9KCgqf+rjKeEBQvJACogYZBJTf7imp+V4JnIfORmHA/Xq7f03gSkb
         GNHP6OG7qYjxtAn8ugqFNzpvqlO/YcAPunJ0dXyi2c5KuV5Ai7PHS/44ai+4fdcZBV
         bHuxvUK96hos8UU5B+edYYXB3U8i7QTtP7W7OsSQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Simon Wunderlich <sw@simonwunderlich.de>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 032/209] ath9k: fix reporting calculated new FFT upper max
Date:   Tue, 12 Nov 2019 20:47:28 -0500
Message-Id: <20191113015025.9685-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
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
index 440e16e641e4a..f75eb068e6cfc 100644
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

