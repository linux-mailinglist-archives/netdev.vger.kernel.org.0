Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492A4565DDE
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 21:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbiGDTQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 15:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234642AbiGDTQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 15:16:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BE6BBE0A
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 12:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656962163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=JzEFy2vBvEJRckAivo/vJ79Li0A+UBYKs7Ka5I1o8Vk=;
        b=C8ku3IbbhVqADEE1qRUdYkjdvwsyLKxmW2J0K9NfcJVk99jgBmZ7Ojv45edSetEbCuwHZn
        GVXUuyO1O9h2XUb99fBUsiAgNw6QgOcKL40CuRd6Py+/m1PT/0gE3/lnqKbWYYHDJ1Kt8s
        g7LYu6jI2t3MEnXTgLFRwEYB8Skk6ds=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-uc6zR04xPLysdmBmr1u7lg-1; Mon, 04 Jul 2022 15:16:00 -0400
X-MC-Unique: uc6zR04xPLysdmBmr1u7lg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1C9729ABA0D;
        Mon,  4 Jul 2022 19:15:59 +0000 (UTC)
Received: from rules.brq.redhat.com (unknown [10.40.208.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C518841617E;
        Mon,  4 Jul 2022 19:15:56 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH] wireguard: Kconfig: select CRYPTO_CHACHA_S390
Date:   Mon,  4 Jul 2022 21:15:35 +0200
Message-Id: <20220704191535.76006-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Select the new implementation of CHACHA20 for S390 when available,
it is faster than the generic software implementation.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/linux-kernel/202207030630.6SZVkrWf-lkp@intel.com/
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
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
2.36.1

