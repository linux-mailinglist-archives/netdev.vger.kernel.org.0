Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4281466551
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 15:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358581AbhLBOiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 09:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358562AbhLBOiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 09:38:07 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AB7C061757
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 06:34:45 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id p3-20020a05600c1d8300b003334fab53afso2471840wms.3
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 06:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RkskQLTh7iYk4V4TDl2rLiyYVggOpBc/lET+HjLMIZY=;
        b=lOsaIOUC/wmPS6LA/B8Rg4xnpVAVAwOzB41PeHNg/1QUJgFg3M6e+aEDil58qr7xTg
         UugI/nYZlyyO1S5Ehou7IVJM1pt8J401A7669aTQXxgrNHS3SoKkZrPdm7rjVDHGgRlC
         00woP3PDgV3JxpYgYvHct6B/vj7rBGj/ASJtCt4Lya4htY4PeGjHBwRJpJmqW7A0H3LN
         6uH8cIuTNrhuYvgfM4dHP4rwQCD1YKHMqiTH1rHip1sQ+EBHW6oOV9H8RNzUKneOwPKJ
         oz8FH9SpMUTIdvfu8MCtLR9ZrJ6ace55qCGOA/T9aG2mYaNaeuiL3rJGJnasUlGw9Bus
         q/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RkskQLTh7iYk4V4TDl2rLiyYVggOpBc/lET+HjLMIZY=;
        b=IcuHvQf6DjAP60XU5odpo9+MEDkJF2umwsyQQqf9bP4dqLAniH3qiKnNn8uRw8HSwP
         bay7XA1SOrsxmrkEVwiy9vxOBa/cujaNpx5IpmY7CJWaQ6bPLJCiqyqD9nObqXqjzkFh
         206EBeOUtKoZyNLxBVOf5aCbES3FPSJOmrhKq621TQMuVhbbc9/jcn1tq3RDQWwpQXmQ
         RwOozlaWHFVtXDFVde0QqOpKl1qfnaFsZC/yZu2TM5D5jRAXMUnuwCNBLzS79NyPpVho
         fROEnVufiL9RPD2JdlYeFJCyAksxD1PTHwDxzG5INBpCTY9DS4Nb34TeLSIhskG5tlCA
         YAgw==
X-Gm-Message-State: AOAM531Y833Hgm9O1tWzkXQNS1eDVOkje9wUH3dT9g3j8BKbCCDYte1D
        ZiX5k0Rj/rfC9T/HmIA3BKH4Fg==
X-Google-Smtp-Source: ABdhPJxuPkJBQ2U8Td07UFAjUCcbLfGh1y44Q8X1kQjszdBwllQNEU097MF5MxfFTOkIx1Wx8lWJ8g==
X-Received: by 2002:a1c:540c:: with SMTP id i12mr6869018wmb.33.1638455683801;
        Thu, 02 Dec 2021 06:34:43 -0800 (PST)
Received: from localhost.localdomain ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id s63sm2575048wme.22.2021.12.02.06.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 06:34:43 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/1] net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset or zero
Date:   Thu,  2 Dec 2021 14:34:37 +0000
Message-Id: <20211202143437.1411410-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.34.0.384.gca35af8252-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, due to the sequential use of min_t() and clamp_t() macros,
in cdc_ncm_check_tx_max(), if dwNtbOutMaxSize is not set, the logic
sets tx_max to 0.  This is then used to allocate the data area of the
SKB requested later in cdc_ncm_fill_tx_frame().

This does not cause an issue presently because when memory is
allocated during initialisation phase of SKB creation, more memory
(512b) is allocated than is required for the SKB headers alone (320b),
leaving some space (512b - 320b = 192b) for CDC data (172b).

However, if more elements (for example 3 x u64 = [24b]) were added to
one of the SKB header structs, say 'struct skb_shared_info',
increasing its original size (320b [320b aligned]) to something larger
(344b [384b aligned]), then suddenly the CDC data (172b) no longer
fits in the spare SKB data area (512b - 384b = 128b).

Consequently the SKB bounds checking semantics fails and panics:

  skbuff: skb_over_panic: text:ffffffff830a5b5f len:184 put:172   \
     head:ffff888119227c00 data:ffff888119227c00 tail:0xb8 end:0x80 dev:<NULL>

  ------------[ cut here ]------------
  kernel BUG at net/core/skbuff.c:110!
  RIP: 0010:skb_panic+0x14f/0x160 net/core/skbuff.c:106
  <snip>
  Call Trace:
   <IRQ>
   skb_over_panic+0x2c/0x30 net/core/skbuff.c:115
   skb_put+0x205/0x210 net/core/skbuff.c:1877
   skb_put_zero include/linux/skbuff.h:2270 [inline]
   cdc_ncm_ndp16 drivers/net/usb/cdc_ncm.c:1116 [inline]
   cdc_ncm_fill_tx_frame+0x127f/0x3d50 drivers/net/usb/cdc_ncm.c:1293
   cdc_ncm_tx_fixup+0x98/0xf0 drivers/net/usb/cdc_ncm.c:1514

By overriding the max value with the default CDC_NCM_NTB_MAX_SIZE_TX
when not offered through the system provided params, we ensure enough
data space is allocated to handle the CDC data, meaning no crash will
occur.

Cc: stable@vger.kernel.org
Cc: Oliver Neukum <oliver@neukum.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Fixes: 289507d3364f9 ("net: cdc_ncm: use sysfs for rx/tx aggregation tuning")
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/usb/cdc_ncm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 24753a4da7e60..e303b522efb50 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -181,6 +181,8 @@ static u32 cdc_ncm_check_tx_max(struct usbnet *dev, u32 new_tx)
 		min = ctx->max_datagram_size + ctx->max_ndp_size + sizeof(struct usb_cdc_ncm_nth32);
 
 	max = min_t(u32, CDC_NCM_NTB_MAX_SIZE_TX, le32_to_cpu(ctx->ncm_parm.dwNtbOutMaxSize));
+	if (max == 0)
+		max = CDC_NCM_NTB_MAX_SIZE_TX; /* dwNtbOutMaxSize not set */
 
 	/* some devices set dwNtbOutMaxSize too low for the above default */
 	min = min(min, max);
-- 
2.34.0.384.gca35af8252-goog

