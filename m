Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A823DA14C
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 12:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbhG2Kkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 06:40:55 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:47826
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236411AbhG2Kkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 06:40:46 -0400
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id D16343F23A
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 10:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627555242;
        bh=KXmULC4yNLbjXfZilnwZUymI+qeRnrLMQ/vMczDuSm8=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=YigS+8QfeZ9cIu40lqUKLt714vfWNx0XN68/ZNwZHyXW6+mXRoRsRjJIYZJubXgCG
         f0e1Ydt0P3HwUr8Fxj53zNmxgww9onUIY6VDUi5plo5tA2Rxq8WKDR7/QXjsjXxQeF
         DDAk38FYvBrbFwdVBdfY138E9QFtLb9aOOAXCy/+io48aKs5e+lQcPwe5cyi+gfcLX
         /8q7tEhRYfy643SeQ5PTL24b11mVeT9cQrzmuxIR86Zj6yuaOPfzbSTZmn74JexdPs
         7rbv7PiD1YskV2VwevqvwKYhVqFLMgYiGeXTUsg8gdtrD1/eqGAtJxDVGpF+byWEUT
         CU1mRDRzhJHfQ==
Received: by mail-ej1-f71.google.com with SMTP id n9-20020a1709063789b02905854bda39fcso1847596ejc.1
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 03:40:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KXmULC4yNLbjXfZilnwZUymI+qeRnrLMQ/vMczDuSm8=;
        b=QYh6Z8FI0WHxI1F5mP+8X8kLu7uHuwSwRhAw9xtbGSThsmm/T2VBAijZgDW263sRMq
         VXF8GsqXhhPQJAiw/tiavMc0+FniQGSs9G0rAlvK8Z8UMrwi763zhVcOYZHt9EVBNdQq
         IHOBoQKOPTue1vkfe6Yv0Qep6VbTiT6PcdV0rW64jQDx7AEaGlI/Rfr+ffkSFYekXu7x
         wrdF/UgozM05PnqYkxxq5dAfKyBdGmLS1DAmio/5Ep7hDR/TshC7IJwaBtrb0XXmH4Mg
         R9eRj8ThE778o7mdf2f8CAzcilHL1xi1HEYcg81zkgMS2PiGuTSI70al+kxyJ/IwgJNE
         wwrg==
X-Gm-Message-State: AOAM533qeFpigxMJ6lZDZtfXpIL3uETmDCpYRcakHWbH3UZkAUuNC2Nl
        TVdx8OC5DUAXfjEcPoz0LV1SWh1A8zEX08r+SwVEjiMOa5VYw/cn02tqFOQF+4EdnfohcMnAAy3
        hwC1NOWgjIeSGul3ysWVlul2BE+3NjT29ww==
X-Received: by 2002:a05:6402:1cb6:: with SMTP id cz22mr5180755edb.148.1627555242546;
        Thu, 29 Jul 2021 03:40:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjW5Qyti3uGsJQhjyg9e0Vg9hnF5ajD1dE9uX/LfyH7AIvIxTCmpWZpCLut6Hz/YpkiUBGxg==
X-Received: by 2002:a05:6402:1cb6:: with SMTP id cz22mr5180746edb.148.1627555242430;
        Thu, 29 Jul 2021 03:40:42 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id c14sm824475ejb.78.2021.07.29.03.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 03:40:42 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 07/12] nfc: fdp: drop unneeded cast for printing firmware size in dev_dbg()
Date:   Thu, 29 Jul 2021 12:40:17 +0200
Message-Id: <20210729104022.47761-8-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
References: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Size of firmware is a type of size_t, so print it directly instead of
casting to int.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/fdp/fdp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index 3e542b7389cb..650a140bea46 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -276,8 +276,8 @@ static int fdp_nci_request_firmware(struct nci_dev *ndev)
 		(data[FDP_FW_HEADER_SIZE + 2] << 16) |
 		(data[FDP_FW_HEADER_SIZE + 3] << 24);
 
-	dev_dbg(dev, "RAM patch version: %d, size: %d\n",
-		  info->ram_patch_version, (int) info->ram_patch->size);
+	dev_dbg(dev, "RAM patch version: %d, size: %zu\n",
+		  info->ram_patch_version, info->ram_patch->size);
 
 
 	r = request_firmware(&info->otp_patch, FDP_OTP_PATCH_NAME, dev);
@@ -293,8 +293,8 @@ static int fdp_nci_request_firmware(struct nci_dev *ndev)
 		(data[FDP_FW_HEADER_SIZE+2] << 16) |
 		(data[FDP_FW_HEADER_SIZE+3] << 24);
 
-	dev_dbg(dev, "OTP patch version: %d, size: %d\n",
-		 info->otp_patch_version, (int) info->otp_patch->size);
+	dev_dbg(dev, "OTP patch version: %d, size: %zu\n",
+		 info->otp_patch_version, info->otp_patch->size);
 	return 0;
 }
 
-- 
2.27.0

