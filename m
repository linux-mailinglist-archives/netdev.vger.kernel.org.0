Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5B55770D0
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 20:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiGPSr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 14:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiGPSr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 14:47:57 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CCC15727;
        Sat, 16 Jul 2022 11:47:56 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id a5so11113129wrx.12;
        Sat, 16 Jul 2022 11:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c0H4SZGJGUqTZkEbdcEov2Q3qqoTqkSn+ntdBtnS/KM=;
        b=WTP+PwRdz3/NeNA3azbbdQYgZuEHW+wCcX2zlJdgKdgCavP8KQVX7cgpbz8xbvg9dT
         CVCAjaCCKXsI51eH04MoxFh9pYCNiprUc+6DB/upF+ts+HmJYWsJ8/n4jL6prVfsPgwC
         UJkJQY9TJWWP+85XiJJIV6loYx1w9jSI/8wYw1KIUuZKQMNTMyJO9lVC4e2fA/tMW/Dk
         z6K7wkAKoSw9NJuSGNCJUZdiuzNcYV4WCuuXaJCnotrTC1qX4PsXAtefwndQM9RQNutl
         2iZwuMppDNyTDakxaANhHlHz/33xeYlZtmWYmHPA7uIBBL4cHP1XBjMATBLmrFNX3x19
         4fEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c0H4SZGJGUqTZkEbdcEov2Q3qqoTqkSn+ntdBtnS/KM=;
        b=3cTSjN56d8OiOcmhNEzekkUv+ExWwAoaSC2tR9SSjzHIOYe1IJmHpyv5UByrq1LoZY
         KrelYaw1mi6K6wlsyD3ITLMLLoXYTkx0HC9///vu9u3G62wBCI/oh5wU2zXq1FGAgLgy
         R9JZu3bCOBtItirBsu2QTjazzBcbDLx2+QJT5PMfmm7Ra7R9HuU0q6pn1euWPWBTGV7J
         tvfL6AZDVXW48FCRoVOEyO6qjoigmNrZtTtK5Y5XP6qJ5OP7MbBimE9Eq5rx5mDZrcMG
         W9sICp04Kk3K4qGuBlJujd8Kb9LqoBskckszSRyuQwEw5uP7Pq4/4qtAXJlEoW4zn8VJ
         +q+A==
X-Gm-Message-State: AJIora+DO5QBt1oFRvrXTedgDW0iDEGr5dAUMNFGk4Lgk7aNF9rtrNxP
        NhYDWj6D764tzckGlDkNeprkUVO3yhg=
X-Google-Smtp-Source: AGRyM1vxWmXVZdIyvKjsfCiLfQST70cTYy6Zs18aWyI1GzP13g44mwZBjouRPWLAxAgn0Di1wM0E3g==
X-Received: by 2002:adf:e604:0:b0:21d:6ddb:d0ec with SMTP id p4-20020adfe604000000b0021d6ddbd0ecmr17520358wrm.177.1657997274381;
        Sat, 16 Jul 2022 11:47:54 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id u18-20020a05600c19d200b003973c54bd69sm13649961wmq.1.2022.07.16.11.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 11:47:54 -0700 (PDT)
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
Subject: [net-next PATCH v2 0/5] Add MTU change with stmmac interface running
Date:   Sat, 16 Jul 2022 20:45:28 +0200
Message-Id: <20220716184533.2962-1-ansuelsmth@gmail.com>
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

The first 2 patch of this series are minor fixup that fix problems presented
while testing this. One fix a problem when we renable a queue while we are
generating a new dma conf. The other is a corner case that was notice while
stressing the driver and turning down the interface while there was some
traffic.

(this is a follow-up of a simpler patch that wanted to add the same feature.
It was suggested to first try to check if it was possible to apply the new
configuration. Posting as RFC as it does major rework for the new concept of
DMA conf)

v2:
- Put it out of RFC

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

