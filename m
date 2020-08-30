Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50029257020
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 21:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgH3TRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 15:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgH3TPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 15:15:09 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6439FC061239;
        Sun, 30 Aug 2020 12:15:08 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id j15so2315593lfg.7;
        Sun, 30 Aug 2020 12:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WKk6KWPNkMHUCww/FbErLxUYYQtEUh3n/PTtmJB/IIQ=;
        b=ADD6Kq4arZJOO7Z+X6dlbNFUKa2MGhu79OcOljRz3WAcc/N3H23SdadMXUusZl7Re7
         mavcADGOOGjw4YPLh4Bd3AHe3Wf3GrR9xszVDjKeNWBVzpgfPFpbu+G5v/ZCc1IocLez
         Tml2HhWF++QwC8/gg0QSMJMYiVTHYrz7Mfq31KkwcMzdX/uXIwpZBuRtIx3Vf6OfTE4I
         gSfTcZ6mcSbFla2yJur9lviMamt/2uiHZG0/UTLDqfDQ0fXciUFWXW/wU1YYVwLxynkp
         32H0oWWSihfW4LFt7gufNGgSOCh6YMorVxHCY3+a2JagEhMaXuLn853leokAN8VD3nsO
         IjnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WKk6KWPNkMHUCww/FbErLxUYYQtEUh3n/PTtmJB/IIQ=;
        b=P70ZXffe7IiriynRgLFOrgujg3zCp+qiQV2DtraBUnPXzHbxNDRH7MnRX8RyYwJZs7
         MDwZwyOsryxbtpv/1lQfakB0pFKDzMAqpRhxIc4amXyIBz2g4uoZIDStNSODVhXtjG5H
         h4uPuSz9neHI7vO4/7Yp1kvBCS29fbXLIKIFGR4QrwqWxGuaMhNyeXs2Eb3K/jkyfDjn
         1HVDqw+yW5WX2R5Rq7xkjw05AMrqSVvecbX+WV/ksoCgYd3N9bS52B0rBA3Qd6uOADTj
         82vYn1zNANhjSnTRMC0hOTZmzmnqZsyksYdQrpbyEsdpHaKbB6GkX7ylp3TM9XDpD9xK
         +ROQ==
X-Gm-Message-State: AOAM532osjv7Nw1P0/HRBwzPySBJZh+vqXrZj/Ko6Yzt0eyt2qeOFDG3
        JOT89QLhVftNg53aBYKa2p4=
X-Google-Smtp-Source: ABdhPJzL0Cdo7AKGH5FiC2AREv1bSdtUCg+BEl1uu43NLTd1wRmGMfv3vj1BvcduUPeX7jN48VJ+7Q==
X-Received: by 2002:ac2:41cc:: with SMTP id d12mr4018561lfi.20.1598814906867;
        Sun, 30 Aug 2020 12:15:06 -0700 (PDT)
Received: from localhost.localdomain (109-252-170-211.dynamic.spd-mgts.ru. [109.252.170.211])
        by smtp.gmail.com with ESMTPSA id e23sm1409709lfj.80.2020.08.30.12.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 12:15:06 -0700 (PDT)
From:   Dmitry Osipenko <digetx@gmail.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] brcmfmac: set F2 SDIO block size to 128 bytes for BCM4329
Date:   Sun, 30 Aug 2020 22:14:39 +0300
Message-Id: <20200830191439.10017-4-digetx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200830191439.10017-1-digetx@gmail.com>
References: <20200830191439.10017-1-digetx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting F2 block size to 128 bytes for BCM4329 allows to significantly
improve RX throughput on NVIDIA Tegra20. Before this change the throughput
was capped to 30 Mbit/s on Tegra, now throughput is at 40 Mbit/s, which is
a maximum throughput for the BCM4329 chip. The F2 block size is borrowed
from the downstream BCMDHD driver. The comment in the BCMDHD driver says
that 128B improves throughput and turns out that it works for the brcmfmac
as well.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 0dc4de2fa9f6..318bd00bf94f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -45,6 +45,7 @@
 #define SDIO_FUNC2_BLOCKSIZE		512
 #define SDIO_4373_FUNC2_BLOCKSIZE	256
 #define SDIO_435X_FUNC2_BLOCKSIZE	256
+#define SDIO_4329_FUNC2_BLOCKSIZE	128
 /* Maximum milliseconds to wait for F2 to come up */
 #define SDIO_WAIT_F2RDY	3000
 
@@ -920,6 +921,9 @@ int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 	case SDIO_DEVICE_ID_BROADCOM_4356:
 		f2_blksz = SDIO_435X_FUNC2_BLOCKSIZE;
 		break;
+	case SDIO_DEVICE_ID_BROADCOM_4329:
+		f2_blksz = SDIO_4329_FUNC2_BLOCKSIZE;
+		break;
 	default:
 		break;
 	}
-- 
2.27.0

