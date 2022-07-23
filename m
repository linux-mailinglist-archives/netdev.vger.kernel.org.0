Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7101857EFAB
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbiGWO3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbiGWO3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:29:46 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6281707B;
        Sat, 23 Jul 2022 07:29:45 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id c22so4287769wmr.2;
        Sat, 23 Jul 2022 07:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hq2Xmgn0Ku0O4P6lR7XqOtoy//jBBsNeMteoMXkSOuo=;
        b=ZQ0PygAPKX+uCMzBYmJaijuE63twVe6pps9Q7Pt1jSbgr5VpXB3hJbQi33bzn6ffzl
         uCBxkdqy5GXx2giRXlaulRet2o7+rJsUrOXKjI59svNrCxyjMUuHWY/of3k7zOJED7Pe
         MNZepcvce+2EOf5GukLYf/8ukEJJVjKC2iQ10OvQzXAIFrS0LlOJUvy9g4HG7UMV9zJX
         1O2AVBT+25HZEE5B3qtdJWSjJPEUWtk+wVsiaHo0L3podgeWJ2nNZisx4dIvQK6iO1wN
         uKpxV0Lr/ojI16CSMo5ywKEm0OFpf2jHVu7BOgjpNrDSeJ0qRVvSSr2zV0DzsOaTYeRz
         2G0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hq2Xmgn0Ku0O4P6lR7XqOtoy//jBBsNeMteoMXkSOuo=;
        b=745CahQhXV+5hwjAH7IRqKct87/3Qo4SCQo7QgHjEsafzTRWxHDshdYNvG4yKTJh5p
         6DlxatE6c8N4SXut9FuiVaNcOZCDrlbf6+DV6nvD19PulyimLd8013H7T1aUQciOxw6r
         79fOCBECt0YondZU7WNUI2NnmqsN211U49zh9R0r2qfcXuZwoQnqlyzBoXUC4rcY0zgl
         DMWFSz3sgkikvbPl9pCs0hh+grAWGKixdxk1Ms24aO6O+tnoYVj4nqpMO+ITJEf0J3Wb
         oY6ok+VHsX9kp5cLa8dxNys+TWQBB56q7Y4Y0nRs7k7VkLTQsd294r/kj028o6Fitdhe
         RsWg==
X-Gm-Message-State: AJIora/QT0mrgRGwTgh+bOGVV7uwa9hwtyJM3qD9LO4u5FvAi+9Khe0o
        dj+bXPGSuCAF3EF/oiiKDbI=
X-Google-Smtp-Source: AGRyM1tuX7ru0+QSDMniQaKgrPs1+GeHcWREL15bd1ePhphCSjTo1hPxx8fZqMepm6C4Y99CzIGwGg==
X-Received: by 2002:a05:600c:1f0a:b0:3a3:15a8:a8e1 with SMTP id bd10-20020a05600c1f0a00b003a315a8a8e1mr3091269wmb.167.1658586584285;
        Sat, 23 Jul 2022 07:29:44 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id q6-20020a1cf306000000b0039c5ab7167dsm11689717wmq.48.2022.07.23.07.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:29:43 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Christian Marangi <ansuelsmth@gmail.com>
Subject: [net-next PATCH v5 0/5] *Add MTU change with stmmac interface running
Date:   Sat, 23 Jul 2022 16:29:28 +0200
Message-Id: <20220723142933.16030-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is to permit MTU change while the interface is running.
Major rework are needed to permit to allocate a new dma conf based on
the new MTU before applying it. This is to make sure there is enough
space to allocate all the DMA queue before releasing the stmmac driver.

This was tested with a simple way to stress the network while the
interface is running.

2 ssh connection to the device:
- One generating simple traffic with while true; do free; done
- The other making the mtu change with a delay of 1 second

The connection is correctly stopped and recovered after the MTU is changed.

The first 2 patch of this series are minor fixup that fix problems
presented while testing this. One fix a problem when we renable a queue
while we are generating a new dma conf. The other is a corner case that
was notice while stressing the driver and turning down the interface while
there was some traffic.

(this is a follow-up of a simpler patch that wanted to add the same
feature. It was suggested to first try to check if it was possible to
apply the new configuration. Posting as RFC as it does major rework for
the new concept of DMA conf)

v5:
- Fix double space for kdoc
- Fix missing kdoc for dma_conf in __init_dma_tx_desc_rings
v4:
- Add additional stmmac_set_rx_mode after stmmac_open
- Disconnect phylink first on stmmac release
v3:
- Fix compilation error reported by kernel test bot
  (missing dma_confg changes to tc and selftest source)
v2:
- Put it out of RFC

Christian Marangi (5):
  net: ethernet: stmicro: stmmac: move queue reset to dedicated
    functions
  net: ethernet: stmicro: stmmac: first disable all queues and
    disconnect in release
  net: ethernet: stmicro: stmmac: move dma conf to dedicated struct
  net: ethernet: stmicro: stmmac: generate stmmac dma conf before open
  net: ethernet: stmicro: stmmac: permit MTU change with interface up

 .../net/ethernet/stmicro/stmmac/chain_mode.c  |   6 +-
 .../net/ethernet/stmicro/stmmac/ring_mode.c   |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  21 +-
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |   4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 723 +++++++++++-------
 .../stmicro/stmmac/stmmac_selftests.c         |   8 +-
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   |   6 +-
 7 files changed, 459 insertions(+), 313 deletions(-)

-- 
2.36.1

