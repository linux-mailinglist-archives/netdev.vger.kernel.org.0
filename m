Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A320FA1C7E
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 16:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfH2OOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 10:14:53 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:41300 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbfH2OOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 10:14:52 -0400
Received: by mail-io1-f65.google.com with SMTP id j5so7155258ioj.8;
        Thu, 29 Aug 2019 07:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=s9nj00c44ZcrCWQury7LyQ1TrCISIn5HIH3ngd+T6zw=;
        b=dh5LHnRdRd+KpHFl6WXt6JN9LbutGQYdzEXUVYh1xZ5CV8NJa++Fuodd+f9xfS1ZR/
         OiaJdolQPaidwuF7UGYtTASOw7ZnAsGeMGn4FNhvOKVRp0mrDr7XOX2VixIRazQqs6Zd
         BI2lo/5lij3VSTVJpzddsKWotHKl+0aknndag1mFsE7AX8uM/F+LeDGaExSZMtAEdyWE
         f/KGc759QrXhUILvmx2++otFJ6uznTnT/vYrC2zUOxfznuRwfFa1Xs4MtgCF+lrGJ6Kw
         KeWLBs5cnlxvVW+JUx2kBU44FRjxxCWFhw992lFvDqjHHJRZNh1iAyLgrNueYkIL4KZp
         orew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=s9nj00c44ZcrCWQury7LyQ1TrCISIn5HIH3ngd+T6zw=;
        b=ltvAj7z86E1JQDjD2Qu2+PZ0O1W6pjHPuTOng0TcQNm9Lk00ZB01RzcKNrPCZnsvqr
         07pyNgpLAVeEI6lZBAm5/CoYVa0IPSzP+DiJbuS/vVJvJLx8xcImZxyg8622uWsz8WKV
         Mx5OD0NuT+bK4MvoineUjnTDe1VWSn1r58qRdtUvAczvLWCxKVPIRgWM+7EKyVeIYRxP
         7FBdkpMYySrVr2MpGvztREGhA6cx70z2mSbhxuymwJmQTb5qcaC5txVwYZSIHxU92Gc8
         A6AIk+tCAbwRdED146C/M4d6WnibOt43RmSRupL9cfebdHxTCqjuZr/DRDkRF8zR982I
         1yhw==
X-Gm-Message-State: APjAAAVTpsGt1qUg5oDIwy9gutGO+0z5VCTw1mxs4tKtv8ca9xWRG3Z0
        7JJHeCUoGzmPt1j56SeUsj2PMjEzOQ==
X-Google-Smtp-Source: APXvYqyCfY9RoPdnKe4PH/ErhJrmi+udFSF2b81KHRMcknbukvk7M2l1bqdkeaxAAZC6MtHbdaxsSQ==
X-Received: by 2002:a05:6602:25d3:: with SMTP id d19mr11915001iop.206.1567088091713;
        Thu, 29 Aug 2019 07:14:51 -0700 (PDT)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id k3sm2149242ioq.18.2019.08.29.07.14.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 07:14:51 -0700 (PDT)
From:   George McCollister <george.mccollister@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Marek Vasut <marex@denx.de>, linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH] net: dsa: microchip: fill regmap_config name
Date:   Thu, 29 Aug 2019 09:14:41 -0500
Message-Id: <20190829141441.70063-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the register value width as the regmap_config name to prevent the
following error when the second and third regmap_configs are
initialized.
 "debugfs: Directory '${bus-id}' with parent 'regmap' already present!"

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 drivers/net/dsa/microchip/ksz_common.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index ee7096d8af07..72ec250b9540 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -128,6 +128,7 @@ static inline void ksz_pwrite32(struct ksz_device *dev, int port, int offset,
 
 #define KSZ_REGMAP_ENTRY(width, swp, regbits, regpad, regalign)		\
 	{								\
+		.name = #width,						\
 		.val_bits = (width),					\
 		.reg_stride = (width) / 8,				\
 		.reg_bits = (regbits) + (regalign),			\
-- 
2.11.0

