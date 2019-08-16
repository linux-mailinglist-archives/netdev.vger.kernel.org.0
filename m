Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFF48FF01
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 11:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfHPJ0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 05:26:40 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43193 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbfHPJ0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 05:26:17 -0400
Received: by mail-wr1-f66.google.com with SMTP id y8so889763wrn.10;
        Fri, 16 Aug 2019 02:26:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8wZECesGtaRN/hRYulA3qe8bal21Vcfb+3jseiWhwfY=;
        b=bkPJ9CukYSfviTLfUNvMZxjAt0wpK7fRb62iizYE6pUiXOckclHEiifu+aH2/a3Dco
         FDmQq/sDpoz+zAHBOaipyq86Wo7FmS5Fyu1Rtwgbe0oS5qbSz9Eaq09EYMdNedKJxUt2
         TW8H6E2zxzVZIJkpHKJNYdumAxkUvJCGLMef+zEFk+K4Tk64rQCU+xj9rQC42ZVIkiOE
         Fo/bVhuIo4ODOdAjgYmOK39mJv5fP39Kyz8s4N8Q7s0uJ6nchxhmKOguIJKjFUYkz/Rr
         5KnnLmTE4sLYnlOx0AQBowUveHAafgkAmYQMynEVUmYCn/MfpF79eE2rWCoAlvNf54wh
         5dJw==
X-Gm-Message-State: APjAAAU+k6npsBphoCa4GadmvxVccGAqC+QfWJE04cZvYdWWYE/9hiu5
        cHdScLyQkZK3A554IKmCNKw=
X-Google-Smtp-Source: APXvYqwuxfNSFouvi+v+ALP0jEZo8ZXiE/rQwczcKeo2zAKeyWd11YX4OO/5BLo8ME3TczTKhqp5Mg==
X-Received: by 2002:adf:f28d:: with SMTP id k13mr9032006wro.19.1565947576600;
        Fri, 16 Aug 2019 02:26:16 -0700 (PDT)
Received: from localhost.localdomain (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id q20sm16521138wrc.79.2019.08.16.02.26.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 02:26:16 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Denis Efremov <efremov@linux.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/10] net: dwc-xlgmac: Loop using PCI_STD_NUM_BARS
Date:   Fri, 16 Aug 2019 12:24:32 +0300
Message-Id: <20190816092437.31846-6-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190816092437.31846-1-efremov@linux.com>
References: <20190816092437.31846-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor loops to use 'i < PCI_STD_NUM_BARS' instead of
'i <= PCI_STD_RESOURCE_END'.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c
index 386bafe74c3f..fa8604d7b797 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c
@@ -34,7 +34,7 @@ static int xlgmac_probe(struct pci_dev *pcidev, const struct pci_device_id *id)
 		return ret;
 	}
 
-	for (i = 0; i <= PCI_STD_RESOURCE_END; i++) {
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 		if (pci_resource_len(pcidev, i) == 0)
 			continue;
 		ret = pcim_iomap_regions(pcidev, BIT(i), XLGMAC_DRV_NAME);
-- 
2.21.0

