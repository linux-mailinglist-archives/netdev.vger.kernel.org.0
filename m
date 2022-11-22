Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36CFE633D38
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbiKVNM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbiKVNMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:12:25 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC9D623A4
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:12:23 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id s196so14064268pgs.3
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oqwHzAInlPVGD6Tj99gfuhNqltvuUaoQbnrjs4tthqQ=;
        b=iqFptG7/uCjX/WZys0RvEFs1QNIHoCzPFv1fNAzqAMu+zJYLIAIlTk5xbXKdx+huTA
         903beUgNqdUyJbtx+1indJKeCxTl6PcQCU9vqOpDLb83FX0WK23+ILBpy9ly3TpIZDCC
         xgjqsPh29pWWGt+2eiT8p/uT708pvtye0mpxMZQl+7KXngPg5fYjUKzILGUff0EBmGWG
         OWN1ybOPMEoD14w22QOUMf0rMMUS/XViBDGXZgvtTtSzOJdrHzoq31K9eGKmHbbI91Gb
         UUo/9UggJh/iYOMPpOGdHM+AU2ZIRy4cGxaeLE55UWyAkPBxF36Rdhb8iB+puBt7zvDM
         ub8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oqwHzAInlPVGD6Tj99gfuhNqltvuUaoQbnrjs4tthqQ=;
        b=grGSpNeeziELrY+jmSN7tUaBgwNClsVdJXJtPGzEJPbtxjIRiAz257ZxHQpqZRn6vO
         Ff+QujZrE5qULAxjpZ69RVmDlXLhOKNF6dVp7ehZTL/jP2zMM94/A7ITu/VDcdn8IDMU
         z2IQGKai2n9hlilNM9wqopAPfKK0q2alFLStvgTIePFFIibeTmiLE6btKUNFb1J8irJm
         5Kj5IgvA3El3E+GR91X+wqv+NpT5EfRfGkkNAyErqB3mkpNDJkZ5oHSiQyxcmUZB2V9L
         sWomfI2Ys4XJF81oR8fQUirw25ErxIx0fJoBuPoKg2CAqbkvvMRC3pj0tn4k5NBkkdEc
         81uA==
X-Gm-Message-State: ANoB5pkj9Q4f4fzXIwT60nOi3M4hTazuw2Kj/U3HZGCVR/v/GLVyzG0b
        q/izFIDF27hZhoJZdnjHYchWKQ==
X-Google-Smtp-Source: AA0mqf5OK6x93CXuy3MfVmeRxV/APyqC08Eof6VVqXzHXz44JzeRwY1jefa62wpRCQH0dU2x4RqDtw==
X-Received: by 2002:a63:5819:0:b0:476:8ce9:be5d with SMTP id m25-20020a635819000000b004768ce9be5dmr5324378pgb.15.1669122743413;
        Tue, 22 Nov 2022 05:12:23 -0800 (PST)
Received: from fedora.flets-east.jp ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id w18-20020a170902e89200b00183e2a96414sm11948992plg.121.2022.11.22.05.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 05:12:22 -0800 (PST)
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
Subject: [PATCH v2] igb: Allocate MSI-X vector when testing
Date:   Tue, 22 Nov 2022 22:11:45 +0900
Message-Id: <20221122131145.68107-1-akihiko.odaki@daynix.com>
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

This change routes interrupts correctly to the first MSI-X vector, and
fixes the test:

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

