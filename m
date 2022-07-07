Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280EF569F47
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 12:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235248AbiGGKOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 06:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234443AbiGGKOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 06:14:50 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524AB50705
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 03:14:48 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id s1so25603570wra.9
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 03:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SSgNLLbJ50VCDaH8BIYRHOpcuQy4PBpSnIZTiijPY+s=;
        b=mTlAPtr3tyQGyLNzZ3lqfSOw9kmdd7anPumzfF1AwyqOX9zE52Mq0GMSuMmTsyhb85
         br7YVPkr8y2e+rnVa7QKMXsFSmfacAooylGAOi/U+jZMf5kLPJ6RgqQuymt/+Cs8dslJ
         9Snl19ou0HABvluTo1izSofvxSMYSzLspGb8cTvAmUqPR8+2Lzih9SmFakd5PffVV1EA
         PghirMQt3EeQvBy0YV6MfTHQcuB2vtgz1851PSW9pHvowear4RNUYPsCGTNOvHfLTS/6
         VgRIO3H7l2f0mQyG/dCFlGyRa7X3gVNTcM4vRDSBk2OVxGgVznu8ZQhjFOBIvzupQLKU
         5rsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SSgNLLbJ50VCDaH8BIYRHOpcuQy4PBpSnIZTiijPY+s=;
        b=8HX6Z3Xa5zhvpSplk77/Bd/AvM+WI/xIDClDLUi9PNNv8WwtmEGVjYsDV2QXfFcq6U
         fHW60TAn6C1usQwI9Z/k2nQRsThSaaR/enr+VXbKFqIT93R+Z9OL4GoyFOC05o/T9wzV
         BJ29cky8fGlXqBb9ZtjmDrvfT/6HhsK8LUlqoSzNB0gagDwXt6gv1BPrO7EU48seFG/k
         Q9Z2zgLamrq1tFXnoTb+h6GlVA1RlTz9YpBHhv6DoKSePzyaQlXVQWvs34YtHNXaYS4D
         zAAxLRtsVk7lM8gNdxJHzEM5nCgQV6QX8tlNEfBWfi2v538++0IrsQAYj3BeKSIkWcOg
         Y3sg==
X-Gm-Message-State: AJIora+NzNNJAJmYVba4XPBs9L3v+L+AbBIpH5FIbnYRw+Rj34o3sIjx
        O+WCAgmv2P/uDXPP1grhywJOQw==
X-Google-Smtp-Source: AGRyM1t7A2+WyXOf/CUDW4Xy+uzMrWN9QYBNI+mVq/LrxwYs5i6OKcl4oc5hBVKSq152h68H7xHeMg==
X-Received: by 2002:a5d:6d0a:0:b0:21d:6f28:5ead with SMTP id e10-20020a5d6d0a000000b0021d6f285eadmr14593631wrq.95.1657188886653;
        Thu, 07 Jul 2022 03:14:46 -0700 (PDT)
Received: from jackdaw.lan (82-65-169-74.subs.proxad.net. [82.65.169.74])
        by smtp.googlemail.com with ESMTPSA id z21-20020a1c4c15000000b0039c871d3191sm29370749wmf.3.2022.07.07.03.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 03:14:46 -0700 (PDT)
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Erico Nunes <nunes.erico@gmail.com>
Cc:     Jerome Brunet <jbrunet@baylibre.com>, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Vyacheslav <adeep@lexina.in>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Da Xue <da@lessconfused.com>, Qi Duan <qi.duan@amlogic.com>
Subject: [RFC/RFT PATCH] net: stmmac: do not poke MAC_CTRL_REG twice on link up
Date:   Thu,  7 Jul 2022 12:14:23 +0200
Message-Id: <20220707101423.90106-1-jbrunet@baylibre.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some reason, poking MAC_CTRL_REG a second time, even with the same
value, causes problem on a dwmac 3.70a.

This problem happens on all the Amlogic SoCs, on link up, when the RMII
10/100 internal interface is used. The problem does not happen on boards
using the external RGMII 10/100/1000 interface. Initially we suspected the
PHY to be the problem but after a lot of testing, the problem seems to be
coming from the MAC controller.

> meson8b-dwmac c9410000.ethernet: IRQ eth_wake_irq not found
> meson8b-dwmac c9410000.ethernet: IRQ eth_lpi not found
> meson8b-dwmac c9410000.ethernet: PTP uses main clock
> meson8b-dwmac c9410000.ethernet: User ID: 0x11, Synopsys ID: 0x37
> meson8b-dwmac c9410000.ethernet: 	DWMAC1000
> meson8b-dwmac c9410000.ethernet: DMA HW capability register supported
> meson8b-dwmac c9410000.ethernet: RX Checksum Offload Engine supported
> meson8b-dwmac c9410000.ethernet: COE Type 2
> meson8b-dwmac c9410000.ethernet: TX Checksum insertion supported
> meson8b-dwmac c9410000.ethernet: Wake-Up On Lan supported
> meson8b-dwmac c9410000.ethernet: Normal descriptors
> meson8b-dwmac c9410000.ethernet: Ring mode enabled
> meson8b-dwmac c9410000.ethernet: Enable RX Mitigation via HW Watchdog Timer

The problem is not systematic. Its occurence is very random from 1/50 to
1/2. It is fairly easy to detect by setting the kernel to boot over NFS and
possibly setting it to reboot automatically when reaching the prompt.

When problem happens, the link is reported up by the PHY but no packet are
actually going out. DHCP requests eventually times out and the kernel reset
the interface. It may take several attempts but it will eventually work.

> meson8b-dwmac ff3f0000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
> Sending DHCP requests ...... timed out!
> meson8b-dwmac ff3f0000.ethernet eth0: Link is Down
> IP-Config: Retrying forever (NFS root)...
> meson8b-dwmac ff3f0000.ethernet eth0: PHY [0.1:08] driver [Meson G12A Internal PHY] (irq=POLL)
> meson8b-dwmac ff3f0000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
> meson8b-dwmac ff3f0000.ethernet eth0: No Safety Features support found
> meson8b-dwmac ff3f0000.ethernet eth0: PTP not supported by HW
> meson8b-dwmac ff3f0000.ethernet eth0: configuring for phy/rmii link mode
> meson8b-dwmac ff3f0000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
> Sending DHCP requests ...... timed out!
> meson8b-dwmac ff3f0000.ethernet eth0: Link is Down
> IP-Config: Retrying forever (NFS root)...
> [...] 5 retries ...
> IP-Config: Retrying forever (NFS root)...
> meson8b-dwmac ff3f0000.ethernet eth0: PHY [0.1:08] driver [Meson G12A Internal PHY] (irq=POLL)
> meson8b-dwmac ff3f0000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
> meson8b-dwmac ff3f0000.ethernet eth0: No Safety Features support found
> meson8b-dwmac ff3f0000.ethernet eth0: PTP not supported by HW
> meson8b-dwmac ff3f0000.ethernet eth0: configuring for phy/rmii link mode
> meson8b-dwmac ff3f0000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
> Sending DHCP requests ., OK
> IP-Config: Got DHCP answer from 10.1.1.1, my address is 10.1.3.229

Of course the same problem happens when not using NFS and it fairly
difficult for IoT products to detect this situation and recover.

The call to stmmac_mac_set() should be no-op in our case, the bits it sets
have already been set by an earlier call to stmmac_mac_set(). However
removing this call solves the problem. We have no idea why or what is the
actual problem.

Even weirder, keeping the call to stmmac_mac_set() but inserting a
udelay(1) between writel() and stmmac_mac_set() solves the problem too.

Suggested-by: Qi Duan <qi.duan@amlogic.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
---

 Hi,

 There is no intention to get this patch merged as it is.
 It is sent with the hope to get a better understanding of the issue
 and more testing.

 The discussion on this issue initially started on this thread
 https://lore.kernel.org/all/CAK4VdL3-BEBzgVXTMejrAmDjOorvoGDBZ14UFrDrKxVEMD2Zjg@mail.gmail.com/

 The patches previously proposed in this thread have not solved the
 problem.

 The line removed in this patch should be a no-op when it comes to the
 value of MAC_CTRL_REG. So the change should make not a difference but
 it does. Testing result have been very good so far so there must be an
 unexpected consequence on the HW. I hope that someone with more
 knowledge on this controller will be able to shine some light on this.

 Cheers
 Jerome

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d1a7cf4567bc..3dca3cc61f39 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1072,7 +1072,6 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 
 	writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
 
-	stmmac_mac_set(priv, priv->ioaddr, true);
 	if (phy && priv->dma_cap.eee) {
 		priv->eee_active = phy_init_eee(phy, 1) >= 0;
 		priv->eee_enabled = stmmac_eee_init(priv);
-- 
2.36.1

