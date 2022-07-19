Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8BC579007
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbiGSBtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiGSBtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:49:32 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8891F1B7A9;
        Mon, 18 Jul 2022 18:49:31 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r14so19557398wrg.1;
        Mon, 18 Jul 2022 18:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NRlQ3mxg3RzKLJEGPG1n3tE2Reyt0PmZbkS9Sk9bMTs=;
        b=I7xGQX4QrHDZwh9zLKLOg9R55Dz23nFRbAU+JW9KAV99wmpuzTbVctG72+amjQ5Zzw
         tZ4wbHPrtnnViOPfQ7SiQPjReHaBxnVGlTQ7GjKNMVIyx84+AgDRZ4/Nxuk7AimnMNst
         xqkGPM9AiGMpLeBFsacUWDmFPMS+ocjBx9QynIdO/h/30vdeEM9VRh1pyR9n0UPUyV4w
         HOmqAPiDnN8d0eIf4zBEGgMgcFLaZONHiDokMYrhwc/dRqKd2JNfAcjSQVIu4ua0XUvH
         LOVBI3lVHTXrzHx2hcRz4SI1XTO2+T49wm0+XQCuriIebz2Dx7535QYHyhmBdREnE3jr
         rBIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NRlQ3mxg3RzKLJEGPG1n3tE2Reyt0PmZbkS9Sk9bMTs=;
        b=FopFGONG1n7hgxFTE9BW7zCYo4hI8XARjCC9TdTq+SrNfRemD1w6BTUy2mMnZ0eLpt
         RSF413BRXPb//7oAhVZDfWLetr5P/YJeK6ko4vV7Faezr7w38h1RDaQwEb9srm7yBWiv
         Y3RKGWbCT8bKGFdxZTEHHpX+h2KQO9YLmW5znc8O4STEOh1AXtqWE/7m0kSE4Qk35rVD
         ROMb23kc1nW2eCqqDc5arThut2DLABJLtz5s192YgLLFm+inDq0heEzlgsFSIiMdj0t5
         RZpIeAnKxNxAx5+Q5vmwrjp5hc3uJo8zAgEEJoRgkeRLQIKV9z1k8HZTNAOaa1f0qg0l
         4W7w==
X-Gm-Message-State: AJIora+sxIOCeW2qiGneXuH021mlI5T+HXlLYeLOhw6NnpvkYsAYhiXW
        86Z05OtMR0RTlxnvuj9EvJ0=
X-Google-Smtp-Source: AGRyM1sgPFrzN1+aui8l4wS4BVl7j70f+1Uo9TEgTIrEo9LFJKayW9/hAmm/cUeLt51/PEU8QtbbvQ==
X-Received: by 2002:a05:6000:1367:b0:21d:75cd:5ae8 with SMTP id q7-20020a056000136700b0021d75cd5ae8mr24932292wrz.282.1658195370030;
        Mon, 18 Jul 2022 18:49:30 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id v10-20020a05600c428a00b003a2fc754313sm16193600wmc.10.2022.07.18.18.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:49:29 -0700 (PDT)
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
Subject: [net-next PATCH v4 0/5] Add MTU change with stmmac interface running
Date:   Tue, 19 Jul 2022 03:32:14 +0200
Message-Id: <20220719013219.11843-1-ansuelsmth@gmail.com>
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
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 720 +++++++++++-------
 .../stmicro/stmmac/stmmac_selftests.c         |   8 +-
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   |   6 +-
 7 files changed, 457 insertions(+), 312 deletions(-)

-- 
2.36.1

