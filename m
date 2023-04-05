Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0EFD6D8323
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbjDEQLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbjDEQKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:10:54 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F6B61B2;
        Wed,  5 Apr 2023 09:10:49 -0700 (PDT)
Received: from jupiter.universe (dyndsl-091-248-212-122.ewe-ip-backbone.de [91.248.212.122])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sre)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id B0D6D66030CD;
        Wed,  5 Apr 2023 17:10:47 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1680711048;
        bh=vaK3ER/DHRMHmHM6p/VjtFC8s2jeWdTjbIOxT/q0drA=;
        h=From:To:Cc:Subject:Date:From;
        b=QOp67eKd+vIReR39z2bkovjkQEB1z5PjWxS2UIjbBC5OV2ZOYSM+n25XJFCbguYTv
         QxWYPZ6XviMHktjShUpj9gxwwUrnTflv4iaI+iJsRlbgfmEvV8QGnDf4w6FaKzQBnz
         6WEnJteyc6efl8rjKGnwqCNjIvmGakTj/+TskAd03WHXE8OqjG5X46kI3Bm/j5ouvk
         QKEdCg6VbGqh/sFJZTCQi5tYHSxmYr37yGuMROmS1SbtmXOkJU0z/Gw4KnjmBKn93k
         W4o/fK69CzIDR3ImMJWfOxlKWPFbYBKQ2SJnW9zymXEkacUOagn+cskUR34aecAeWZ
         Zkrx+QCWpz39w==
Received: by jupiter.universe (Postfix, from userid 1000)
        id 403684807E1; Wed,  5 Apr 2023 18:10:45 +0200 (CEST)
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        kernel@collabora.com
Subject: [PATCHv2 0/2] Fix RK3588 error prints
Date:   Wed,  5 Apr 2023 18:10:41 +0200
Message-Id: <20230405161043.46190-1-sebastian.reichel@collabora.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This fixes a couple of false positive error messages printed
by stmmac on RK3588. I expect them to go via net-next since
the fixes are not critical.

Changes since PATCHv1:
 * https://lore.kernel.org/all/20230317174243.61500-1-sebastian.reichel@collabora.com/
 * Add Fixes tags
 * Use loop to request clocks

-- Sebastian

Sebastian Reichel (2):
  net: ethernet: stmmac: dwmac-rk: rework optional clock handling
  net: ethernet: stmmac: dwmac-rk: fix optional phy regulator handling

 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 74 ++++++-------------
 1 file changed, 24 insertions(+), 50 deletions(-)

-- 
2.39.2

