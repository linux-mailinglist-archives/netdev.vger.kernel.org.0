Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3F13942D9
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236913AbhE1Mof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:44:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42551 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236388AbhE1MoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:44:01 -0400
Received: from mail-ua1-f72.google.com ([209.85.222.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lmbon-00082O-DQ
        for netdev@vger.kernel.org; Fri, 28 May 2021 12:42:25 +0000
Received: by mail-ua1-f72.google.com with SMTP id t19-20020ab021530000b029020bc458f62fso1822953ual.20
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 05:42:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fEIoPxNrP5T6kipF7UD+JljPXbq0d6mIipwUTUc2Oss=;
        b=BmNSU2yLA1/Vi3qJhY3u5zMT19KVcsKPZKDVjROHz0i49nwdYrTPPNcYszRtoeBptg
         R/saDO72BTmqBvxkDAaBVE5tkbp5plEdGlXA1Z75kS0Cx0mFr1gUWi6qiWmAM2A+j5zq
         UnuG/yKtZEsreDqeAWsZ6AMHdU2QnRKJN1HdpVeDeVcwsyfD0wobDOd1WMGMjhMGATKD
         5dWFSh/rW4cr/5dzPI9bCLA7hD38Jn1w5Z63rz8CYutT5aM83jGM9e/uG/axgQY5lqHE
         4ENeWEp9BAAir8vTegucdpFgQeBTSioyzM3qYFMjBQQOWAY22jR8wd1AacGuWBwXwcw5
         oPDQ==
X-Gm-Message-State: AOAM533fGQZRwHzmXC6lqRLCXRAC3Ra7VjxVzOF5cXtXoz1XLoJGl1j/
        kWDrLsJI0RubrU89KkOjJxet73JW9ksF1NxIhGzvhTHaah+eKs/RR+vZr+yY4D+99VOuMNJ/lQ3
        HfMissHRSm8MfMIQJlGDQXhwj3lKQoz8i7g==
X-Received: by 2002:a67:eccc:: with SMTP id i12mr6543359vsp.45.1622205744540;
        Fri, 28 May 2021 05:42:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDadRXlslcePxNwoxbVhHp/mJrPYDYLe6dnq3jjs9H35NrGNs3pqvcHUUKSdLjy0Qc0iiMKA==
X-Received: by 2002:a67:eccc:: with SMTP id i12mr6543352vsp.45.1622205744385;
        Fri, 28 May 2021 05:42:24 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.6])
        by smtp.gmail.com with ESMTPSA id b35sm782328uae.20.2021.05.28.05.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 05:42:23 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] nfc: st21nfca: mark ACPI and OF device ID tables as maybe unused
Date:   Fri, 28 May 2021 08:41:59 -0400
Message-Id: <20210528124200.79655-11-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
References: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver can match either via OF or ACPI ID tables.  If one
configuration is disabled, the table will be unused:

    drivers/nfc/st21nfca/i2c.c:593:34: warning:
        ‘of_st21nfca_i2c_match’ defined but not used [-Wunused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/st21nfca/i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 23ed11f91213..cebc6c06a1b6 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -584,13 +584,13 @@ static const struct i2c_device_id st21nfca_hci_i2c_id_table[] = {
 };
 MODULE_DEVICE_TABLE(i2c, st21nfca_hci_i2c_id_table);
 
-static const struct acpi_device_id st21nfca_hci_i2c_acpi_match[] = {
+static const struct acpi_device_id st21nfca_hci_i2c_acpi_match[] __maybe_unused = {
 	{"SMO2100", 0},
 	{}
 };
 MODULE_DEVICE_TABLE(acpi, st21nfca_hci_i2c_acpi_match);
 
-static const struct of_device_id of_st21nfca_i2c_match[] = {
+static const struct of_device_id of_st21nfca_i2c_match[] __maybe_unused = {
 	{ .compatible = "st,st21nfca-i2c", },
 	{ .compatible = "st,st21nfca_i2c", },
 	{}
-- 
2.27.0

