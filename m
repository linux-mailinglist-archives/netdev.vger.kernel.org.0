Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D573987ED
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 13:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhFBLWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 07:22:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52949 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhFBLWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 07:22:07 -0400
Received: from mail-ed1-f69.google.com ([209.85.208.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1loOvA-0005E9-9S
        for netdev@vger.kernel.org; Wed, 02 Jun 2021 11:20:24 +0000
Received: by mail-ed1-f69.google.com with SMTP id c21-20020a0564021015b029038c3f08ce5aso1192895edu.18
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 04:20:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DqpBs4pq4Sjb8nYynK90LyYUsmuWivvDhwxtdT36aGM=;
        b=Tl44GpkMWWy9H0oR/QpH/Z0D5qVJMlIsRF+xHOqYDKWKMl/FTSF2yCuNQebzzZ8ukl
         00Tjz4k+91ESdNetdTlFvWOHqXb4U4t1ky+0ozxmGFuA9PciTE0xIEg7hgkd7FrfUp2z
         a32hMbYLUiy7rsZp6CUQm1ZoDuAvEOLdQXlrIBdZZM9avRX0GF4oFgJRyOA0tG5lkdiG
         O86NP6V2x43mVF+8YWr+39wtqj1HORhRqXB43+e0szOzmFUfo3vt+UQ3ETCBdGLoiNWQ
         +ITsuTBU01GQlJnUG9U1mH/PgziNQCzBJ0dlqFE4hjVF/T+dhZijvkZQ1amb2JPLk5hl
         NfhQ==
X-Gm-Message-State: AOAM531FQo4x4/9Lb5opEiNZ1vFBL6Y0uAP1mw8Z8ShTIGyw/mL6F0SW
        P5N6GdhjkCaaU4tKu9KiSTCdzk20qrhH8tpFz8doHZ1Y1qJAYwxtmaZaP2IP4b2iXINdGESFTIL
        mmtDxqy4UjnRmqFhOYB3NpXwqVac6j4pz0w==
X-Received: by 2002:a17:906:6dd0:: with SMTP id j16mr34042643ejt.208.1622632823958;
        Wed, 02 Jun 2021 04:20:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5uDKKjhvZNChEoO4ybm2CwDwYSd/9CN/DhLa25b0dk8xmRpWdyHyyezW0S/p4r6YRC2Iqiw==
X-Received: by 2002:a17:906:6dd0:: with SMTP id j16mr34042633ejt.208.1622632823790;
        Wed, 02 Jun 2021 04:20:23 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id jp6sm3699705ejb.85.2021.06.02.04.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 04:20:23 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Joe Perches <joe@perches.com>
Subject: [PATCH v2 1/2] nfc: mrvl: remove useless "continue" at end of loop
Date:   Wed,  2 Jun 2021 13:20:10 +0200
Message-Id: <20210602112011.44473-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "continue" statement at the end of a for loop does not have an
effect.  Entire loop contents can be slightly simplified to increase
code readability.  No functional change.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

---

Changes since v1:
1. Make it if-else-if as Joe suggested.
---
 drivers/nfc/nfcmrvl/usb.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
index bcd563cb556c..6fec20abfd1e 100644
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -319,13 +319,9 @@ static int nfcmrvl_probe(struct usb_interface *intf,
 		if (!drv_data->bulk_tx_ep &&
 		    usb_endpoint_is_bulk_out(ep_desc)) {
 			drv_data->bulk_tx_ep = ep_desc;
-			continue;
-		}
-
-		if (!drv_data->bulk_rx_ep &&
-		    usb_endpoint_is_bulk_in(ep_desc)) {
+		} else if (!drv_data->bulk_rx_ep &&
+			   usb_endpoint_is_bulk_in(ep_desc)) {
 			drv_data->bulk_rx_ep = ep_desc;
-			continue;
 		}
 	}
 
-- 
2.27.0

