Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A848C264C02
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgIJR5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 13:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726216AbgIJQPN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 12:15:13 -0400
Received: from localhost.localdomain (unknown [194.230.155.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C81E20BED;
        Thu, 10 Sep 2020 16:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599754367;
        bh=q4PfSN/iGfvSKBF5OqA0xnoo0M75rGDiILB3JNyi3Sc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=DZLIVNDF3f/+Zb8igN7FHQTHTiyncQABGWe6n7i8pQ0p8yF5+sEd6nVCPwBng9eUX
         qK9fkl2lh5OsLE75J0gWVdfHa1jteXtCVZ417b83Qw+CFXF9C5dvRC74HfLtSs0OhT
         FYDhSgoGTQZrDE56CAThmMnbqWSjhbEPZUQoyUg4=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Kukjin Kim <kgene@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-nfc@lists.01.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v3 5/8] nfc: s3fwrn5: Add missing CRYPTO_HASH dependency
Date:   Thu, 10 Sep 2020 18:12:16 +0200
Message-Id: <20200910161219.6237-6-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910161219.6237-1-krzk@kernel.org>
References: <20200910161219.6237-1-krzk@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver uses crypto hash functions so it needs to select CRYPTO_HASH.
This fixes build errors:

  arc-linux-ld: drivers/nfc/s3fwrn5/firmware.o: in function `s3fwrn5_fw_download':
  firmware.c:(.text+0x152): undefined reference to `crypto_alloc_shash'

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/nfc/s3fwrn5/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/s3fwrn5/Kconfig b/drivers/nfc/s3fwrn5/Kconfig
index af9d18690afe..3f8b6da58280 100644
--- a/drivers/nfc/s3fwrn5/Kconfig
+++ b/drivers/nfc/s3fwrn5/Kconfig
@@ -2,6 +2,7 @@
 config NFC_S3FWRN5
 	tristate
 	select CRYPTO
+	select CRYPTO_HASH
 	help
 	  Core driver for Samsung S3FWRN5 NFC chip. Contains core utilities
 	  of chip. It's intended to be used by PHYs to avoid duplicating lots
-- 
2.17.1

