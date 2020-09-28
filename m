Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF08827B7BA
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgI1XNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbgI1XNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 19:13:41 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E338DC05BD0B
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:51 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id q4so3007639ils.4
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 16:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4TxaMa6inpZ7uMAndoFZ5+P5V8+D5W2ogRawnm+mnrw=;
        b=BPcyw3RouFEeIYSfoGTnzTWR8xIeOLQKB1SaKv/ej7EVr35nbGNbxexqylu4rf19ky
         nFYS9ETsJ4iMHo6iY01f0g9p74z0hpHzlQCj+HE/UUsnrF6n/hbzoM+tfJk3rAqo6mQR
         XcDn58DRckHzTaqKF2FA4QY9+B8VB/UwL/MAUu/vXiC10j0+Xiyv/0K6paeMlS6qGo5Q
         /jDZTO1UeEdNbQ2ZCWnIuk5oHhgvDav460Rvnxd7iBOPpefyJTr8qD8UhDeIz42LLa2n
         OunK8fY4POd7wc7j6KK0yAeP6Oybg69PpzLThmlMaVVDPUNmzi2rOo5P61997S1rVrCp
         fmyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4TxaMa6inpZ7uMAndoFZ5+P5V8+D5W2ogRawnm+mnrw=;
        b=Gs57m9Y/RP4WVHYOaqA+C7t2iIFPfpx0KPTyNnYr8Rz/eSwENk/8bJvFcvgBUSpw/O
         PAGw38g02WcDh+6Fpu7RZTSQmQ0FM4FSXcnxSRqyYdY0BsSpsPlzbG7KX4zwFw3PZXp0
         ++qSP+jJloMuJgZ3KpklLb+JbJ3KwdUsPzG70ZarPu2la/fUD17SH0pS3BCFqFkKloW4
         xHzHb9UuO0kvkPJ/b3E1rfPBTfndoRCChROxxrjerz/IVyklHtdMZkRLkh5zXalT1q7S
         y2/PqX6IDqnX9zRY/Rm3vAVnmbLTwb+tjD4M7eA3bIoLlxEGyn/vbFVTmUaL1jO6EtJ6
         YIDA==
X-Gm-Message-State: AOAM533feBBHDn9Z5GKp1iaEJdAF9jOYioVWYGoWXO1vg/FrmHGTTpen
        9PSftQmH18T0pUbxgDCKsMsv9w==
X-Google-Smtp-Source: ABdhPJzYgbfl2gRKfvh0JI7qgLfUaS3kg/2rEtEn1KZRQklmXs/0Dy9g/+zvEanEEUgW/4zYBfWqeA==
X-Received: by 2002:a92:7611:: with SMTP id r17mr599930ilc.88.1601334291290;
        Mon, 28 Sep 2020 16:04:51 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id 137sm1009039ioc.20.2020.09.28.16.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 16:04:50 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 01/10] net: ipa: kill definition of TRE_FLAGS_IEOB_FMASK
Date:   Mon, 28 Sep 2020 18:04:37 -0500
Message-Id: <20200928230446.20561-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200928230446.20561-1-elder@linaro.org>
References: <20200928230446.20561-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In "gsi_trans.c", the field mask TRE_FLAGS_IEOB_FMASK is defined but
never used.  Although there's no harm in defining this, remove it
for now and redefine it at some future date if it becomes needed.
This is warned about if "W=2" is added to the build command.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_trans.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index bdbfeed359db3..43f5f5d93cb06 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -81,7 +81,6 @@ struct gsi_tre {
 
 /* gsi_tre->flags mask values (in CPU byte order) */
 #define TRE_FLAGS_CHAIN_FMASK	GENMASK(0, 0)
-#define TRE_FLAGS_IEOB_FMASK	GENMASK(8, 8)
 #define TRE_FLAGS_IEOT_FMASK	GENMASK(9, 9)
 #define TRE_FLAGS_BEI_FMASK	GENMASK(10, 10)
 #define TRE_FLAGS_TYPE_FMASK	GENMASK(23, 16)
-- 
2.20.1

