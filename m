Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F1016AEEC
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 19:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgBXSY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 13:24:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728033AbgBXSYz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 13:24:55 -0500
Received: from localhost.localdomain (unknown [194.230.155.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E3842084E;
        Mon, 24 Feb 2020 18:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582568694;
        bh=Tez6VX6xj5AysVwOY/ouD5bKxQQHd3DxSyG5pRnK4MM=;
        h=From:To:Cc:Subject:Date:From;
        b=FMc+w+gf7P1GiCySSc4erFIiTujZ4kop3vcHYUX2gFuUS170V31br0JigVd3d2RER
         gpwMOJYYXJc+Wx26QDuxVUWkyHqE1diK/dAw51lHwsz9HOjPF1uuJeSIIcumBtKlJO
         Z+Cib+3BU7Vvofl1MkoVIt67u9WQVNTs9mlNNNe0=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH] ath5k: Add proper dependency for ATH5K_AHB
Date:   Mon, 24 Feb 2020 19:24:47 +0100
Message-Id: <20200224182447.4054-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CONFIG_ATH5K_AHB could be enabled on ATH25 system without enabling
ATH5K driver itself.  This does not make sense because CONFIG_ATH5K_AHB
controls object build within drivers/net/wireless/ath/ath5k/ so enabling
it without CONFIG_ATH5K brings nothing.

Add proper dependency to CONFIG_ATH5K_AHB.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/net/wireless/ath/ath5k/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
index 802f8f87773a..96010d4b00e7 100644
--- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -54,7 +54,7 @@ config ATH5K_TRACER
 
 config ATH5K_AHB
 	bool "Atheros 5xxx AHB bus support"
-	depends on ATH25
+	depends on ATH25 && ATH5K
 	---help---
 	  This adds support for WiSoC type chipsets of the 5xxx Atheros
 	  family.
-- 
2.17.1

