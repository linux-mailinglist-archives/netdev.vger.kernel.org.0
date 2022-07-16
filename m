Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28FE6577226
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 01:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbiGPXIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 19:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiGPXIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 19:08:11 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54F7186D4;
        Sat, 16 Jul 2022 16:08:10 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o8so4977219wms.2;
        Sat, 16 Jul 2022 16:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zH/D31uMSDW0xhMnNPteLenGrNsKNhRXe32KFuNIx54=;
        b=iZCU+4efLqXnq7Fn8jro1X0cVxj0VBLooeeeXriBNAUQRJ5KyBA2M97X91wmiG/oaL
         6Ut21qKdcF3a0p5Uqc/UVkYgeS84GcfXye5rZeyGzGjuWg+wVDoXmyI4Meotz/12EfN8
         GzJRq8QRMMDyKmALey0oX7mGQO9SMu7tXjAKYhrF8mms5VwoKIQv2DjxGzJ7nIS/veSX
         m3QDvSsBYTncKjN0+v4DFsUW87Wds72GcdkSnDxH5+/EPVj+smJYjvecznd+ogMch6fQ
         Zfro105mmvsVXvpD9sVKJ9dMJvydQ4Prar2hUcpy6PL4PGgwpuyCN2FEPEqinp0I0lQy
         iRpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zH/D31uMSDW0xhMnNPteLenGrNsKNhRXe32KFuNIx54=;
        b=CsHdrKJVIfPOfZlgaFn4FAaojjDtnd9rS3QBxz/ZcwtXzMIlXo2Ya3nExdPKj3d/f8
         EdZzsMpksFP8B8FTGunWUNMBu/usdSbb5TTFzrPQ7j1Kf0f0QiPvTC7l5QS9WOM/k4z5
         MyTjS4x/bbCVuvG0B1Aa5IzSYfi2pX0hSTcgnhCvCHV/gEZzQaQosPTyccNjYUYKC8F8
         iTSxIi4j9deAkpA8krHYnHX1nexxLXCp31rdrgE9x4IdRGhjr9va1c+Qyk55oX963/f7
         cpVAaQPs+/bKNORSStFgytZUMZediXWIOxagbnjgoFIW91uG/9WEpXkh6bC8RAg6f4PF
         mYwA==
X-Gm-Message-State: AJIora+xlsPUeik6bVRNg4At2Lf9h/n6T+fpZUhFaDlOg9A8fxnxssgk
        eJNff3F6ykjmbIgcwzK/j6fjFsmZUMk=
X-Google-Smtp-Source: AGRyM1tX5E+vmOz3erLPVIca2091fu8LsjFwOgXT2gVUO09ywIM7eSr9s3eFBZFtgcMVYQtNmeF5UA==
X-Received: by 2002:a1c:4b09:0:b0:3a2:ff2a:e543 with SMTP id y9-20020a1c4b09000000b003a2ff2ae543mr16170708wma.93.1658012889078;
        Sat, 16 Jul 2022 16:08:09 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id l13-20020a05600c2ccd00b003a2f2bb72d5sm15150755wmc.45.2022.07.16.16.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 16:08:08 -0700 (PDT)
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
Subject: [net-next PATCH v3 0/5] Add MTU change with stmmac interface running
Date:   Sun, 17 Jul 2022 01:07:57 +0200
Message-Id: <20220716230802.20788-1-ansuelsmth@gmail.com>
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

v3:
- Fix compilation error reported by kernel test bot
  (missing dma_confg changes to tc and selftest source)
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
 .../stmicro/stmmac/stmmac_selftests.c         |   8 +-
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   |   6 +-
 7 files changed, 457 insertions(+), 314 deletions(-)

-- 
2.36.1

