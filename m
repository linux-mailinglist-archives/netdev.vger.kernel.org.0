Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C25E650EB8B
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 00:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbiDYWYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 18:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343612AbiDYVph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 17:45:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2FC10C88A;
        Mon, 25 Apr 2022 14:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1614A61480;
        Mon, 25 Apr 2022 21:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440C0C385A7;
        Mon, 25 Apr 2022 21:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650922951;
        bh=VWIdJNxWRCfgar7Ib519tgDolGkr3hghcxrk47Iv2bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCSlFBhzffcdhcGYF80E592JT4Vy3+6VdVEPq/PczkwHKG8P7RqVakcZPxqd4lHXG
         qZNPEwrFzs6Tme1DPl68z/svMz1LwtGg+snbuw3WLDDcpzPCO5AVNItJxnhrjeOKU7
         HnDysQkUW12U+Av8FM2pFn5UN2+uWsllmoqtalc8OmwmEjtqJAYnrs7ndKltQmd1hC
         0FJHcjKYcNmbxdl4YgTrgVliBx521EifMChH74OWoU5Eeqi3Ua8TjYMDnbCtx3UnyL
         5qyn7+oekX737GRyF6B7hvIg2JM3AnpJnmQNwYZUKQA+Scdjcn+jhoUyXhhgi+rMDH
         1VfQcIyAYWRog==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Chas Williams <3chas3@gmail.com>
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 2/2] net: remove comments that mention obsolete __SLOW_DOWN_IO
Date:   Mon, 25 Apr 2022 16:26:44 -0500
Message-Id: <20220425212644.1659070-3-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220425212644.1659070-1-helgaas@kernel.org>
References: <20220425212644.1659070-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

The only remaining definitions of __SLOW_DOWN_IO (for alpha and ia64) do
nothing, and the only mentions in networking are in comments.  Remove these
mentions.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/atm/nicstarmac.c                     | 5 -----
 drivers/net/ethernet/dec/tulip/winbond-840.c | 2 --
 drivers/net/ethernet/natsemi/natsemi.c       | 2 --
 3 files changed, 9 deletions(-)

diff --git a/drivers/atm/nicstarmac.c b/drivers/atm/nicstarmac.c
index e0dda9062e6b..791f69a07ddf 100644
--- a/drivers/atm/nicstarmac.c
+++ b/drivers/atm/nicstarmac.c
@@ -14,11 +14,6 @@ typedef void __iomem *virt_addr_t;
 
 #define CYCLE_DELAY 5
 
-/*
-   This was the original definition
-#define osp_MicroDelay(microsec) \
-    do { int _i = 4*microsec; while (--_i > 0) { __SLOW_DOWN_IO; }} while (0)
-*/
 #define osp_MicroDelay(microsec) {unsigned long useconds = (microsec); \
                                   udelay((useconds));}
 /*
diff --git a/drivers/net/ethernet/dec/tulip/winbond-840.c b/drivers/net/ethernet/dec/tulip/winbond-840.c
index 86b1d23eba83..1db19463fd46 100644
--- a/drivers/net/ethernet/dec/tulip/winbond-840.c
+++ b/drivers/net/ethernet/dec/tulip/winbond-840.c
@@ -474,8 +474,6 @@ static int w840_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
    No extra delay is needed with 33Mhz PCI, but future 66Mhz access may need
    a delay.  Note that pre-2.0.34 kernels had a cache-alignment bug that
    made udelay() unreliable.
-   The old method of using an ISA access as a delay, __SLOW_DOWN_IO__, is
-   deprecated.
 */
 #define eeprom_delay(ee_addr)	ioread32(ee_addr)
 
diff --git a/drivers/net/ethernet/natsemi/natsemi.c b/drivers/net/ethernet/natsemi/natsemi.c
index 82a22711ce45..50bca486a244 100644
--- a/drivers/net/ethernet/natsemi/natsemi.c
+++ b/drivers/net/ethernet/natsemi/natsemi.c
@@ -989,8 +989,6 @@ static int natsemi_probe1(struct pci_dev *pdev, const struct pci_device_id *ent)
    No extra delay is needed with 33Mhz PCI, but future 66Mhz access may need
    a delay.  Note that pre-2.0.34 kernels had a cache-alignment bug that
    made udelay() unreliable.
-   The old method of using an ISA access as a delay, __SLOW_DOWN_IO__, is
-   deprecated.
 */
 #define eeprom_delay(ee_addr)	readl(ee_addr)
 
-- 
2.25.1

