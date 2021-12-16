Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F46C477CF4
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhLPUCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhLPUCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:02:12 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD1DC061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:02:11 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id e5so75955wrc.5
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 12:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5HwYYDqWp19oe5YE+gZCP+0KWTalav7swe7XzuBrU/o=;
        b=Wx1oPH2UeRn/jIE4IcyIJ7IrHSSXtacyHeBygvupNB7Wx6ro04UHPuKrGw7EHjjpwA
         ugj3XXH0Adtw96axsdULht1t0urLG5FSRsrbB/RPclcBNooPHiwxbsQ6elgFntZONKhY
         JXzkWI1arTiGbB9wkDswyyigfp0YesPL/t2fPUSTIImV8GDl0MWeIN6kUe5y5UVG2ImD
         jyZgyfmpNDvzcJHIcYCWXiCA6fUgEC9Avn5jUzmfcjLVf8pq4o4a+be/VbahkKpXa7Ta
         nI6BGyh7jrS9AVBwDGy3vEHuadDgwrcJfz+P3+eL2tFt/c8HqK5sscaTw1j18EKj1qKx
         tZzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5HwYYDqWp19oe5YE+gZCP+0KWTalav7swe7XzuBrU/o=;
        b=a57Dgg1FsuaLRtc5MIj5cD2T2Fga5U+btVzxxhXOTeBDrzDX95LqLY7VYuY5HSYLpc
         /lLrMstaj2hk9UYfwNmLwNi7kNbLvBHz5ceatypGZ2Kod5nAv17EWumqQRdCvXZc3+N4
         DFnmwaRf53Fwqd7d0oUZooQvtW4SdNNkZUYem0UMC8PmrcQy0TF+Ea9yIZ21/QwwwCmE
         iyOzX406MifNravIREDc02aFozuxQy1gANUgYzgwdTSqw9adEHJ2iPqL6NPqHX59OBMu
         fV9lfvKcDwxyArTqJG4wWSslYJWASxrh1gb6tv7Cqf0DEaYHKMQ9rd08l9YbSt9FIHuV
         6N8g==
X-Gm-Message-State: AOAM532VY0vZF34OtL+g5fJ2oIZ8GhYSLx5PtIrBPQK3dkR6Mu+y36d7
        +vHHwfa0zZPjWb9HRsYnR9EsGFbp9icyOTk2NN8=
X-Google-Smtp-Source: ABdhPJzKZVAgV28Lzaq8qCuRRuk1VJAIOugwoG7a+fmM2wmOA7Bqo1JlkGNCySDO3UFjlE5y90z86A==
X-Received: by 2002:a5d:4acb:: with SMTP id y11mr10533612wrs.64.1639684929835;
        Thu, 16 Dec 2021 12:02:09 -0800 (PST)
Received: from hornet.engleder.at (dynamic-2ent3hb60johxrmi81-pd01.res.v6.highway.a1.net. [2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id s8sm6495466wra.9.2021.12.16.12.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 12:02:09 -0800 (PST)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] tsnep: Fix s390 devm_ioremap_resource warning
Date:   Thu, 16 Dec 2021 21:01:54 +0100
Message-Id: <20211216200154.1520-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerhard Engleder <gerhard@engleder-embedded.com>

The following warning is fixed with additional config dependencies:

s390-linux-ld: drivers/net/ethernet/engleder/tsnep_main.o: in function `tsnep_probe':
tsnep_main.c:(.text+0x1de6): undefined reference to `devm_ioremap_resource'

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/engleder/Kconfig b/drivers/net/ethernet/engleder/Kconfig
index 614dcc65c634..f4e2b1102d8f 100644
--- a/drivers/net/ethernet/engleder/Kconfig
+++ b/drivers/net/ethernet/engleder/Kconfig
@@ -18,6 +18,7 @@ if NET_VENDOR_ENGLEDER
 
 config TSNEP
 	tristate "TSN endpoint support"
+	depends on HAS_IOMEM && HAS_DMA
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select PHYLIB
 	help
-- 
2.20.1

