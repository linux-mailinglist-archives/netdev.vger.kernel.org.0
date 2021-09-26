Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CD64186CD
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 08:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhIZG5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 02:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbhIZG5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 02:57:15 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09D0C061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 23:55:38 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso10755356pjb.3
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 23:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=u8dwdasDMIbDsJqPa5ttmn9bjefExMCA1hLofRY28s8=;
        b=uNBD+cs0OHhTfWt3inrISgxHjx4FUqyGUUX6ggudTlz4ZgILC2d8Y+tQ95yJfezkOF
         9TZKTKwZ4kVxvCNrcX1QvNtynJBbhkBOREnIr9LmU1dlnbM3jHJ+ufvqg+9nNRFzDOUH
         DFKo+QfABZ0DiQbBGDnBUpC0LlSVS5YUzf5Bpb9yWzhhdAylEWBIkjiGtErsftUdOYgG
         W8Wgdhcq1dj2AqAzBCUHlDqKNrSSvI+CioTnksss93kiHdLInBwZ520l4dLnOCJvNL9E
         0RxhxRkERFk+yGdnfPha8+lk67+/wdS+po8jGjd8wbhGM17EmsugCsir7C6DA/rdZYBx
         SRlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=u8dwdasDMIbDsJqPa5ttmn9bjefExMCA1hLofRY28s8=;
        b=JJukTsRPFDcIhCYM8vpGTfUlSe9O4BC5xkvl5XcacYK8Yc/fFVjlpNq5mkN/nQjpQL
         +BvPmP5RMScbSiavYWF/fBfirlrOOPSd8Id15qoxF3SSAO33fOGCNaHwmul/rRf26Y79
         2j7E3hnQnObzQucvcH8aoP2fPzyp6Ut9MGYMcLgZ7tMbJZzeZ1VKfYosJ9UDjBA6Jq79
         ItP1w6RD6Mh3qD2r/xlsLma3dJOyX4YEXO0WYRQjGSyI00/m+CmLo5Y+v948AK5IhcBI
         kzhS3SPgORdmk5W9taD/8PRaY7tG3GKsQM0Dpm2DsFfaGgLzW8vdl6pd1N/ka6Q573Bs
         uYcg==
X-Gm-Message-State: AOAM531c+iIozI9UXCfjPHczkcrirdLYcqZzsHBLmOoNCsXJo+U4uGfX
        1/fcL7+2HHNmYgwM1o236+PjAA==
X-Google-Smtp-Source: ABdhPJyX97SDoA8dsUAa/TKwy7G+hx3vx6meOkgiUiof2Do7odaJZ+f9Vz108L7rPWB6okRQUZyJDw==
X-Received: by 2002:a17:902:a702:b029:12b:aa0f:d553 with SMTP id w2-20020a170902a702b029012baa0fd553mr16602901plq.3.1632639338516;
        Sat, 25 Sep 2021 23:55:38 -0700 (PDT)
Received: from localhost.localdomain (80.251.214.228.16clouds.com. [80.251.214.228])
        by smtp.gmail.com with ESMTPSA id i19sm13214021pfo.101.2021.09.25.23.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 23:55:38 -0700 (PDT)
From:   Shawn Guo <shawn.guo@linaro.org>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Alex Elder <elder@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Steev Klimaszewski <steev@kali.org>, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] net: ipa: Declare IPA firmware with MODULE_FIRMWARE()
Date:   Sun, 26 Sep 2021 14:55:29 +0800
Message-Id: <20210926065529.25956-1-shawn.guo@linaro.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Declare IPA firmware with MODULE_FIRMWARE(), so that initramfs tools can
build the firmware into initramfs image or warn on missing of the
firmware.

W: Possible missing firmware /lib/firmware/ipa_fws.mdt for module ipa

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index cdfa98a76e1f..264bebc78d1e 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -545,6 +545,8 @@ static int ipa_firmware_load(struct device *dev)
 	return ret;
 }
 
+MODULE_FIRMWARE(IPA_FW_PATH_DEFAULT);
+
 static const struct of_device_id ipa_match[] = {
 	{
 		.compatible	= "qcom,msm8998-ipa",
-- 
2.17.1

