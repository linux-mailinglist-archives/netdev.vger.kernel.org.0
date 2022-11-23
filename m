Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E98634C31
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 02:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbiKWBJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 20:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235486AbiKWBJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 20:09:37 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140D2C4C14
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 17:09:36 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id w15-20020a17090a380f00b0021873113cb4so525673pjb.0
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 17:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/V51eYi8kNH703uTKmSzNllQwio3tsi/yeJV9VYuXpc=;
        b=lrW4Id5THbQtufiIuhTDV12fIXnXs2AY/a0DuVmYeuisSZPyJkQi00phxQ4u4SNwFY
         6R3pReduNo28T/sy/smgfVHCqcHl4JSEJOC6W4cZEkShcPFuRBhYKdZXjmihnAUcyXRe
         rYOZzWbE6Bx+MCZXs18h0fTfmCv3DmV6ZUutx9wvEAamr0NW0ypkfE2Q+tgG3jJuzJQX
         +YKniqqZ114B1cPCpBeqd5R+oa9KPX1uy9zgrZC+KewsW9OstAzfASiEsXi+N9+p+2Sq
         fMM75XqGe/mEwAck8azYhQWm/VuxpOeBdT8gfmkKlmjPsf8WJhFyPxLCGZaf7fQOxvxG
         9YAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/V51eYi8kNH703uTKmSzNllQwio3tsi/yeJV9VYuXpc=;
        b=7HOb85gpcela7IZBKX2k1ISUgotHCAVJIZvWWBgf8RQMqNFxXOG5RXN59pqz6rvLX/
         5ZkEOZ0FviEvAtCo5AIxbwg/2qvWyk2qdN8nRdFMHYrk8qWTYdGT4TXDbEdwuR1c/y2T
         jwv7UHrBYtSEbDxcf87kALHVOLTEuSMe2EEJqBUi2SG/UpiYZSxj3VFVTLHsv7WpXjoC
         2W1PO1FgrrUypIEGah8GZbT0eQjozjskNVOJtemdQ6kHQw2MtPwPEVWqRDjN1mF07kwI
         By+yj32GTlvhbc/3Iy+c8NuvD+2ZCeufGjy6YqNJfR/GtpYfHn5fiDvY3RjJIOrVRj0U
         1o0w==
X-Gm-Message-State: ANoB5pmpEjco2lMV3vgKVqQj1tLcovFttxb2jBhWVZIPy2DcMQ2/wnbs
        OeljKXCoa6sitHszVexO9JJewQ==
X-Google-Smtp-Source: AA0mqf4SsVTVf9E0AAbXr3UbIt92zS4EddB+5oBu/PqBwKXyvwW6uycy40IZ1nU20bQoKPpELPwMVA==
X-Received: by 2002:a17:902:ed94:b0:186:748f:e8c5 with SMTP id e20-20020a170902ed9400b00186748fe8c5mr6375972plj.73.1669165776461;
        Tue, 22 Nov 2022 17:09:36 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id x15-20020aa78f0f000000b0056be4dbd4besm11309911pfr.111.2022.11.22.17.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 17:09:36 -0800 (PST)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v3] igb: Allocate MSI-X vector when testing
Date:   Wed, 23 Nov 2022 10:09:26 +0900
Message-Id: <20221123010926.7924-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without this change, the interrupt test fail with MSI-X environment:

$ sudo ethtool -t enp0s2 offline
[   43.921783] igb 0000:00:02.0: offline testing starting
[   44.855824] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Down
[   44.961249] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   51.272202] igb 0000:00:02.0: testing shared interrupt
[   56.996975] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
The test result is FAIL
The test extra info:
Register test  (offline)	 0
Eeprom test    (offline)	 0
Interrupt test (offline)	 4
Loopback test  (offline)	 0
Link test   (on/offline)	 0

Here, "4" means an expected interrupt was not delivered.

To fix this, route IRQs correctly to the first MSI-X vector by setting
IVAR_MISC. Also, set bit 0 of EIMS so that the vector will not be
masked. The interrupt test now runs properly with this change:

$ sudo ethtool -t enp0s2 offline
[   42.762985] igb 0000:00:02.0: offline testing starting
[   50.141967] igb 0000:00:02.0: testing shared interrupt
[   56.163957] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
The test result is PASS
The test extra info:
Register test  (offline)	 0
Eeprom test    (offline)	 0
Interrupt test (offline)	 0
Loopback test  (offline)	 0
Link test   (on/offline)	 0

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index e5f3e7680dc6..ff911af16a4b 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -1413,6 +1413,8 @@ static int igb_intr_test(struct igb_adapter *adapter, u64 *data)
 			*data = 1;
 			return -1;
 		}
+		wr32(E1000_IVAR_MISC, E1000_IVAR_VALID << 8);
+		wr32(E1000_EIMS, BIT(0));
 	} else if (adapter->flags & IGB_FLAG_HAS_MSI) {
 		shared_int = false;
 		if (request_irq(irq,
-- 
2.38.1

