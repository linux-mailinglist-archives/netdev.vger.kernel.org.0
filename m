Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20218424A2D
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239824AbhJFWvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239840AbhJFWtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:49:41 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C473C061746;
        Wed,  6 Oct 2021 15:47:48 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id x27so16692914lfu.5;
        Wed, 06 Oct 2021 15:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ccFVCLTaG73CPEDlAiRlOjrK4yiCBtHLRvootfuznAA=;
        b=X4umLHvd+E4nvVp2xBzJSXNeull5RjOdX1oBXWaACdTS1uhBE6Nq1/RkiHsHOOu7+H
         15c1VE8weRKPK+SLZxhlKZJD9SyrSkv0iH+uGyrOLayGp/qkTk/1A3+CI7NzrYSzqzOJ
         xU0d2QQ3FdAG/DQ1+/HDDemU6nzncGi5TgJlB1JDcf/PDFNKpWbgIhohJZvJyDAhgIWB
         bzX7pCqL8NrSiTvZk6PCHMypCuaiU3gfUI2zvIpPc70P8EGu3Wf6o04y7R9amQzm+MHd
         V6HMB3SqJwDuPVnAUhg8KGdS5rUEWk4H7akV2fCSj4Qaea1nkHwi8uAzMK4dDJORlgva
         JlMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ccFVCLTaG73CPEDlAiRlOjrK4yiCBtHLRvootfuznAA=;
        b=xO6h29c4nZTY5BF/UzKfgeKJSZkwcH1F4KnGeteiMa2quHLhITFpmSGoRJj55AKak2
         vkDi56fOXkSRQUNo5QCNukRB5cQkXumxSZfWkceyq81q9ssqzVxP1JVxxpQL3S2Z8fbt
         XAgetFLOZJ6QVvokMJSSF6d8psPAibr7z6h5G1LTrW9+FVcn0Ldwm0dIi/oHkcEGdIvy
         8SXPlQUi5PW00bx2SvTJHGNwWXK+IMF9serGGin0b/40anWdXWizINFnljFbpupAUqgd
         ypdk6RliDA8mL/HFY5kAOnlk6ZUoaNCB66eYPiLPuSaHmFmxW6Z9o7fPwIGCVTkJ6Y8H
         Gz2w==
X-Gm-Message-State: AOAM530aBBICv7rYxjc7CocYqiSR/NO+lVmUIs91zJ2Gl3Opk61BTET6
        BoD+gSPV8SvC1Vw1+WV6VgM=
X-Google-Smtp-Source: ABdhPJzCZuFcSRwZnDZwvi+hZDCmVN34s37qUjqDWDyyPZzskVFV2Xlly6Q+MIFAIj6MJmaqkl6rBw==
X-Received: by 2002:ac2:5d23:: with SMTP id i3mr710331lfb.477.1633560466389;
        Wed, 06 Oct 2021 15:47:46 -0700 (PDT)
Received: from localhost.localdomain (h-155-4-129-96.NA.cust.bahnhof.se. [155.4.129.96])
        by smtp.gmail.com with ESMTPSA id p16sm2432052lji.75.2021.10.06.15.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:47:46 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH 1/2] nfc: pn533: Constify serdev_device_ops
Date:   Thu,  7 Oct 2021 00:47:37 +0200
Message-Id: <20211006224738.51354-2-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006224738.51354-1-rikard.falkeborn@gmail.com>
References: <20211006224738.51354-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only usage of pn532_serdev_ops is to pass its address to
serdev_device_set_client_ops(), which takes a pointer to const
serdev_device_ops as argument. Make it const to allow the compiler to
put it in read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/nfc/pn533/uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
index 7bdaf8263070..77bb073f031a 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -224,7 +224,7 @@ static int pn532_receive_buf(struct serdev_device *serdev,
 	return i;
 }
 
-static struct serdev_device_ops pn532_serdev_ops = {
+static const struct serdev_device_ops pn532_serdev_ops = {
 	.receive_buf = pn532_receive_buf,
 	.write_wakeup = serdev_device_write_wakeup,
 };
-- 
2.33.0

