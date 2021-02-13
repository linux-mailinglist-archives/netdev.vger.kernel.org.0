Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE42931A8A8
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbhBMAPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbhBMAPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:15:10 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C33C0613D6
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:29 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id bl23so2055507ejb.5
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ATT5z3N1EYqURm4hFlhrbwENNtLDdFTojY6mvozSwp0=;
        b=tFfh0hE6latjyyd7bOtVkS0E3VtB0FngIuwhWvarW2UbcbHnHsxitr7OcxoAkSbSE0
         o7Q+aqcehj8UOJbSOgXi1DIrXn9V+mUQFEe/TEZGg5HtgnfwGVwHwBhYxqzwIIVtcxwl
         nzImSVWsFJJeNuSnlh+Cg/FuiAGM3iUiBfZnVM035Tr2Tjo8A22tuD2rG8vxxZN4Ublb
         /VIgo1FYOviixscJrF/DUCAsIXbKDRIsERycqeu+EgDd4q4v7URNvHkdRkrjklrqEj+V
         gsbqz4aTeXKChu8zJCqCYSm698zeoVRy2rSiNSNEWtv5CKbksZvHuN0mIxnj7dgIFwpi
         17zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ATT5z3N1EYqURm4hFlhrbwENNtLDdFTojY6mvozSwp0=;
        b=UaaafLhw4EMxNv0iZLdy+wY6HAxp5cRlIHHkYaEfpzwK/gWQYx7Bh+mKFKTn9LsbrK
         H9R9Qh0SwEkQPm6gdPIKHwMg6Js2j2cQFGS8TUEHppfcjtKxUmne8GS4H+PdUvaqVeW+
         zleuUL0rPP7YgYqfcwkPwmimY0gKoOO8XwaLDTyUFlQRE0k48hi4c6YMC84GiKdiIGRm
         Sdg1yhdGwyJsxsSNm03zt1v+g54yWggcnTrpgAR138eXjvRdPSgo89mzJx30ZZCD7rDA
         0kaxDA/vLkUJOP5QJatUAAdm3Q+AOng0qv64R/ptUWa0fzTQChEsD7f09itET/wjROdx
         JcRw==
X-Gm-Message-State: AOAM530f92paX5vdqpmDgWtj8wpzBJMKFVA3M8WOMH3dti6uqSLHxr2s
        JWLnOKSA5EiWmBm35IXou88=
X-Google-Smtp-Source: ABdhPJxmZ9TAC+nPFQUiD3leuLCwOk0vtnHRihn+WLphB5/W46kzmUbDfPg6u1HS01QZlpXXKOWr6g==
X-Received: by 2002:a17:906:2e0c:: with SMTP id n12mr5394858eji.312.1613175268544;
        Fri, 12 Feb 2021 16:14:28 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id c1sm7015606eja.81.2021.02.12.16.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 16:14:28 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 02/12] net: mscc: ocelot: only drain extraction queue on error
Date:   Sat, 13 Feb 2021 02:14:02 +0200
Message-Id: <20210213001412.4154051-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213001412.4154051-1-olteanv@gmail.com>
References: <20210213001412.4154051-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It appears that the intention of this snippet of code is to not exit
ocelot_xtr_irq_handler() while in the middle of extracting a frame.
The problem in extracting it word by word is that future extraction
attempts are really easy to get desynchronized, since the IRQ handler
assumes that the first 16 bytes are the IFH, which give further
information about the frame, such as frame length.

But during normal operation, "err" will not be 0, but 4, set from here:

		for (i = 0; i < OCELOT_TAG_LEN / 4; i++) {
			err = ocelot_rx_frame_word(ocelot, grp, true, &ifh[i]);
			if (err != 4)
				break;
		}

		if (err != 4)
			break;

In that case, draining the extraction queue is a no-op. So explicitly
make this code execute only on negative err.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 590297d5e144..d19efbe6ffd3 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -701,7 +701,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		dev->stats.rx_packets++;
 	}
 
-	if (err)
+	if (err < 0)
 		while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp))
 			ocelot_read_rix(ocelot, QS_XTR_RD, grp);
 
-- 
2.25.1

