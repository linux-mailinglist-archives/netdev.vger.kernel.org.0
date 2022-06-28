Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C88B55E20C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243074AbiF1BeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 21:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234765AbiF1BeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 21:34:08 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D4B167FE;
        Mon, 27 Jun 2022 18:34:07 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id c65so15461936edf.4;
        Mon, 27 Jun 2022 18:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y+PHCtYFQjlFqTy7xiF2BYO3NjlRKVCp7efVO+mj96g=;
        b=aF8Gc0nBYIqf+kRIRnA4wyxA7nSyQDUbC2F9DsBhQhe93Arz8CmKm9qj/XvtRX10jJ
         1jwHvjBc/b0ATfNMt84xwCHJCfOwazM3TZ4Gy1Db94WbS8M+EHAItGJ1x7Ievvv9VyOf
         WpAUKHJjBZNvYMCmTYjrYUKUxLp42i4pUnz27/MEuccDg6kX8VFDy+HexwlKT+0AekIt
         VTs6ndF3+D8fEIa+1uwRMX0KmR+Dkxf+e2gAjz9QfhV2RmzVVatX769GU8lajXSrx4D/
         NL7i4G2amGuxKpyDLdg7LzlkCQYe29gfbDYDdAmZWKUGxgOcls7/rFUM2iNtIPT/HjvV
         F+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y+PHCtYFQjlFqTy7xiF2BYO3NjlRKVCp7efVO+mj96g=;
        b=Mb5HT64MyrTVURLApJ9qTeb1tv1RL0BHBIj5HlWFF9qO2Wk5cxxC1ASqLmFDQ/fOIQ
         SHp0a4V/KM//dopNooz+U/ATegbrJC67ycDNPjpOeZpoleK6AvaHQMfUQ5mshVt278mB
         BLE52yG/qUxvl0Vj1MoLl5xI2bNzJXAC3A6xfB9m4vJdkkPtLhh3R9aeXwBASYsl+WHh
         SPTMxeeN5uzvT8TjW5BgSNk5ClVjANWwAIgzcF2fZnhym7KQB7aQ6yBThhcEDt0u7+Lb
         sm3udNsVhsF+/SUVmJ5Jrwv5M0Zm1b//eClgDMo15UzOr0X6HrxOIEK0UHNLVBnC1zD+
         i0Dw==
X-Gm-Message-State: AJIora/S/70agOxptnzPZwNCuwC6NhSB6Be7zLNf6PLoLPkHEKgpcEVl
        LcFQCerBW6skhOH7PrHMPKE=
X-Google-Smtp-Source: AGRyM1sCM+8fBV9YLUq2tUBXlkuFyobvH2oa3NoRsTecMQqItiGnuJdbUwnCH3hGeHYNXPr62e/mdw==
X-Received: by 2002:a05:6402:50d2:b0:435:8c44:8715 with SMTP id h18-20020a05640250d200b004358c448715mr20239193edb.49.1656380045367;
        Mon, 27 Jun 2022 18:34:05 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id x13-20020a170906b08d00b00724261b592esm5693492ejy.186.2022.06.27.18.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 18:34:04 -0700 (PDT)
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
Subject: [net-next PATCH RFC 0/5] Add MTU change with stmmac interface running
Date:   Tue, 28 Jun 2022 03:33:37 +0200
Message-Id: <20220628013342.13581-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

The first 2 patch of this series are minor fixup that fix problems presented
while testing this. One fix a problem when we renable a queue while we are
generating a new dma conf. The other is a corner case that was notice while
stressing the driver and turning down the interface while there was some
traffic.

(this is a follow-up of a simpler patch that wanted to add the same feature.
It was suggested to first try to check if it was possible to apply the new
configuration. Posting as RFC as it does major rework for the new concept of
DMA conf)

Christian Marangi (5):
  net: ethernet: stmicro: stmmac: move queue reset to dedicated
    functions
  net: ethernet: stmicro: stmmac: first disable all queues in release
  net: ethernet: stmicro: stmmac: move dma conf to dedicated struct
  net: ethernet: stmicro: stmmac: generate stmmac dma conf before open
  net: ethernet: stmicro: stmmac: permit MTU change with interface up

 .../net/ethernet/stmicro/stmmac/chain_mode.c  |   6 +-
 .../net/ethernet/stmicro/stmmac/ring_mode.c   |   4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  21 +-
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |   4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 722 +++++++++++-------
 5 files changed, 450 insertions(+), 307 deletions(-)

-- 
2.36.1

