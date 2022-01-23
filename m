Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE79F49749C
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 19:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiAWSmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 13:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239623AbiAWSl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 13:41:26 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17F2C06173D;
        Sun, 23 Jan 2022 10:41:25 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id x11so7707399plg.6;
        Sun, 23 Jan 2022 10:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0F414qr4KcwROxp4P4//QuZXhV1PvM+EIvGUM77ZnYw=;
        b=qPUDOzVrFgRR0ZojdlGaeaiqiXmK1Fu7gnq6Kpjzn0e7w+PMTD2rzLEY8hZ14TTY23
         4uLU94junvHCzOpoqV1nqyFTW7bW5WJ8MgQ3l0T7cIVcpjhLRMaQMwidSTAEeMc7wt5B
         mVdwcYCTxWItcClOk4Zb1ar8U1kfFa/IA6Lr/AXWP3N7L2IA2kJFPnunibOS9tsFcpmc
         MChfOb+HBpNfCcx0obaVEgTnIWGgoow/wT1sQcndztEU/Zs4BKOT2XPqAkVgErnwmNNG
         5eSnp6wZHkDMC25WBNoSmDV9Yy0bcHKDPTZE5N2I/Wy5EjHfW+m/LVbYton0nC1MmJP6
         rWwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0F414qr4KcwROxp4P4//QuZXhV1PvM+EIvGUM77ZnYw=;
        b=UcfbjXFrYEC5VJzBPi2LJeH7qTGq+16AIndxwXz/OkUtXdeBYD6h38tj0Dh3C1TjJi
         FbkpkfTVrRf4JFUyYG/IbbHTaQHV4UJ93K1Te0gY1MH6M6e1valCZCRZ+fVXwAGCzj/s
         EG3YTi+ZIxHk0QVOONVho0Cn8Xcfn6a7C7ZsPzB0Wltnp6Msh3XKbadPAX2Z8VHY2Avm
         q/990nUgjGAbsjjgzWoAY4HyhvVrr1BfqmvS91EEmEXo0B5Uzh8ePkYGvdH6MbgKmni4
         uYgUIMgzGuVNWk1PtdUIveqvkNcpnS4uWgpMVMaRSwOtfXkuuVtSw8OjFf8+Yw0Xh1ex
         Q/kA==
X-Gm-Message-State: AOAM531rRSaWpF1ln5BK5pEZL3HzA0AEzM5G40Bu5SgvAN5V9YpNxyHQ
        SSsxygJ8FUXfcX6+HxWxx9A=
X-Google-Smtp-Source: ABdhPJxKtLbZ+fS2qLQ72Hx4NHY5QVMT/SLF2EGamemsOG+fTKuUk8ZzUBc47pVyDM8deb3IguBF+w==
X-Received: by 2002:a17:90b:1b0d:: with SMTP id nu13mr7887564pjb.24.1642963285131;
        Sun, 23 Jan 2022 10:41:25 -0800 (PST)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id s13sm13234564pfu.0.2022.01.23.10.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 10:41:24 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH 31/54] net: ethernet: replace bitmap_weight with bitmap_weight_eq for intel
Date:   Sun, 23 Jan 2022 10:39:02 -0800
Message-Id: <20220123183925.1052919-32-yury.norov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220123183925.1052919-1-yury.norov@gmail.com>
References: <20220123183925.1052919-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ixgbe_disable_sriov calls bitmap_weight() to compare the weight of bitmap
with a given number. We can do it more efficiently with bitmap_weight_eq
because conditional bitmap_weight may stop traversing the bitmap earlier,
as soon as condition is met.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 214a38de3f41..35297d8a488b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -246,7 +246,7 @@ int ixgbe_disable_sriov(struct ixgbe_adapter *adapter)
 #endif
 
 	/* Disable VMDq flag so device will be set in VM mode */
-	if (bitmap_weight(adapter->fwd_bitmask, adapter->num_rx_pools) == 1) {
+	if (bitmap_weight_eq(adapter->fwd_bitmask, adapter->num_rx_pools, 1)) {
 		adapter->flags &= ~IXGBE_FLAG_VMDQ_ENABLED;
 		adapter->flags &= ~IXGBE_FLAG_SRIOV_ENABLED;
 		rss = min_t(int, ixgbe_max_rss_indices(adapter),
-- 
2.30.2

