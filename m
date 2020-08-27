Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CBB253D67
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgH0GGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgH0GGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:06:01 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67E5C061247;
        Wed, 26 Aug 2020 23:06:00 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id i10so5088547ljn.2;
        Wed, 26 Aug 2020 23:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WKk6KWPNkMHUCww/FbErLxUYYQtEUh3n/PTtmJB/IIQ=;
        b=qLQ1i7wDv9Q3Xaxm3HkxgYB7iVc8sv2O42p4VD+k9wlAuWC3GcWW1tNXitXj3Z/Z8J
         LD4FG7R+IhHjNW6ryE+cQg5ynJQa1Ptl3jDD2TGOGmu4TFD7wrDI9SxFi1pN6g42aMtO
         LJKXRFRdeXciiZYHQKqPZxeh8ankvU95AW/bznMKHir8JNe0moVMAK+LWaSP17dxyp7n
         IsJUpueYCn42JrF000SSmEXeXlkO9Yr5A1Y4Jdnq5WgIA7VULEy8fA2IsHcW/qMbqgY/
         7zzLR8JSNoSGXv/p+1Vtiv6mWbynRcPPOY2HfGkX4D1GwFx62b4zp2oLkWUrcvAxokDC
         NLKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WKk6KWPNkMHUCww/FbErLxUYYQtEUh3n/PTtmJB/IIQ=;
        b=V2ahx8Gu879552bFOuxvWm4wrCLeeFte0kQQCjqi3Ft1pZdX3aeW2N7fYYX/h+PABH
         mD6jFg9lfmaZQMIxvnHXbwCOlS/sERxJWeayc7KXP1J8atTlWuLJ7D+Cgiv22GrrG521
         Jf/yZDHRZPQPt4BWF3bxaxaQjcFqVrH1e020NNvLpTl8gz0yabP7kiIqA1+QfnnQ9qwz
         aCHG5zBvkRNqdpRYiZPjAdOaraFDRZ+BTUNcH5tAWEENNzC7jji0ERw+fz8weYjvGsvS
         /BSm68R22E3JJx4C9CwrvNdshD2VJ+aBxcJXj7bYB8zeFNmIXBRqMJ7kib3FhIVPZwHF
         lJEA==
X-Gm-Message-State: AOAM532oDTV2M5VCldaH5MRCVhxUYeteZwygWl4fTj+9qSgHY/jEoXXE
        mkUJ7JObJ2geVcaXeiu3UrY=
X-Google-Smtp-Source: ABdhPJzrTQlLzdl6fvs+KJ8nM6o4Pq1n7ukkS0FV/jYFLwOfmV5xlKCDf2GJF4pBmm4Evv0Fhq0aXQ==
X-Received: by 2002:a2e:98d5:: with SMTP id s21mr8116414ljj.59.1598508359172;
        Wed, 26 Aug 2020 23:05:59 -0700 (PDT)
Received: from localhost.localdomain (109-252-170-211.dynamic.spd-mgts.ru. [109.252.170.211])
        by smtp.gmail.com with ESMTPSA id z7sm255295lfc.59.2020.08.26.23.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 23:05:58 -0700 (PDT)
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
Subject: [PATCH v2 4/4] brcmfmac: set F2 SDIO block size to 128 bytes for BCM4329
Date:   Thu, 27 Aug 2020 09:04:41 +0300
Message-Id: <20200827060441.15487-5-digetx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200827060441.15487-1-digetx@gmail.com>
References: <20200827060441.15487-1-digetx@gmail.com>
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

