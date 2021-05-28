Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D05B3942D2
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbhE1MoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:44:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42531 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236253AbhE1Mn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:43:56 -0400
Received: from mail-vs1-f70.google.com ([209.85.217.70])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lmboi-00080e-NH
        for netdev@vger.kernel.org; Fri, 28 May 2021 12:42:20 +0000
Received: by mail-vs1-f70.google.com with SMTP id p14-20020a67e94e0000b029023fa53ce6e9so951419vso.14
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 05:42:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iEB2h4Bn3lCrV1o5tVk2hyJU4Tj+yg0ZQdaMOEhsgd0=;
        b=QdrJdf/7GwCWfkE01/8dOD+HgMweVm9WmSMbdlYamZ9SXT0DvXwdkPL2XyILP7OdcY
         BvBPWOrOYXhgvp+XeSi5NlbkNKKB3SEJoWCW+CkGEI6Y/S5Ic0BCXhWylKetrpYqeN+d
         IZCeSaqKscK96aFkJa+/tE+GJLBd/heARx873fgGYACaM04uevU/CNQ/CfrXThkgNZVC
         F+wwDy4EqC86zZZoy1MQbrNlZrIexH82wymE6sKYIYcdDlkca7h6506vsnU92QydA/XF
         XLiTfH0/hSRzRg/nrRcjm9hbeNE5qHtM+qZ79ekSkef4kQHqWp3PMzSUGYMDzmdjnLlR
         SGWA==
X-Gm-Message-State: AOAM533sHGvDjiGABtspIRGVwk0M48iANt3wuYaIgqYV5t53jXKe4QjT
        mNafawdpVrDaF0MtLBpBu14D7jsKyBh20idDWZp7JmSss2u4P+L+smH4um0kvEDHh2zTHvRC0cp
        UBdM+5B7VDJZ80rPe2mp0JeOpAXleY3yLdg==
X-Received: by 2002:a67:10c1:: with SMTP id 184mr6783944vsq.37.1622205739808;
        Fri, 28 May 2021 05:42:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWllFrdrg6Jbn+aBJ5/GUhoFVyAz32AVwfOxffn/3s94HonEx3zuiiuqroeuZJehFCIblIDA==
X-Received: by 2002:a67:10c1:: with SMTP id 184mr6783923vsq.37.1622205739642;
        Fri, 28 May 2021 05:42:19 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.6])
        by smtp.gmail.com with ESMTPSA id b35sm782328uae.20.2021.05.28.05.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 05:42:19 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] nfc: s3fwrn5: mark OF device ID tables as maybe unused
Date:   Fri, 28 May 2021 08:41:56 -0400
Message-Id: <20210528124200.79655-8-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
References: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver can match either via OF or I2C ID tables.  If OF is disabled,
the table will be unused:

    drivers/nfc/s3fwrn5/i2c.c:265:34: warning:
        ‘of_s3fwrn5_i2c_match’ defined but not used [-Wunused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/s3fwrn5/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index 38b8d6cab593..4d1cf1bb55b0 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -262,7 +262,7 @@ static const struct i2c_device_id s3fwrn5_i2c_id_table[] = {
 };
 MODULE_DEVICE_TABLE(i2c, s3fwrn5_i2c_id_table);
 
-static const struct of_device_id of_s3fwrn5_i2c_match[] = {
+static const struct of_device_id of_s3fwrn5_i2c_match[] __maybe_unused = {
 	{ .compatible = "samsung,s3fwrn5-i2c", },
 	{}
 };
-- 
2.27.0

