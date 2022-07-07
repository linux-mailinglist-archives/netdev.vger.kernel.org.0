Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEE05696F0
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 02:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbiGGAcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 20:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234795AbiGGAcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 20:32:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA4C26AC9
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 17:32:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 733ECB81F7C
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 00:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84879C3411C;
        Thu,  7 Jul 2022 00:32:37 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="fySDBV6D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657153956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GDttHAdFndHYT4w09m8GNJhx46FiVDOnWXVYVqd+3UY=;
        b=fySDBV6DB3MxyndjP6YegIcdHKO9N2EDo7t53uVdehyUve3p5LJ6gge0IgLcBOkhYf+SVg
        GyJFcVr6RPvrXbQ5RPeIGFCgyd5v8zOgdA1e1tgN1zzdDEwizxXzdVGDsv+XlxT3403g4o
        lLvKWPBYvPvTCBa1H735gyemgjuDIDM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b598b3b0 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 7 Jul 2022 00:32:36 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net
Cc:     Vladis Dronov <vdronov@redhat.com>,
        kernel test robot <lkp@intel.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 6/6] wireguard: Kconfig: select CRYPTO_CHACHA_S390
Date:   Thu,  7 Jul 2022 02:31:57 +0200
Message-Id: <20220707003157.526645-7-Jason@zx2c4.com>
In-Reply-To: <20220707003157.526645-1-Jason@zx2c4.com>
References: <20220707003157.526645-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladis Dronov <vdronov@redhat.com>

Select the new implementation of CHACHA20 for S390 when available.
It is faster than the generic software implementation, but also prevents
some linker errors in certain situations.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/linux-kernel/202207030630.6SZVkrWf-lkp@intel.com/
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index b2a4f998c180..8c1eeb5a8db8 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -94,6 +94,7 @@ config WIREGUARD
 	select CRYPTO_CURVE25519_NEON if ARM && KERNEL_MODE_NEON
 	select CRYPTO_CHACHA_MIPS if CPU_MIPS32_R2
 	select CRYPTO_POLY1305_MIPS if MIPS
+	select CRYPTO_CHACHA_S390 if S390
 	help
 	  WireGuard is a secure, fast, and easy to use replacement for IPSec
 	  that uses modern cryptography and clever networking tricks. It's
-- 
2.35.1

