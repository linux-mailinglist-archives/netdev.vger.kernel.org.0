Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A54213F3C
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 20:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgGCSU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 14:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgGCSUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 14:20:25 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B433C061794;
        Fri,  3 Jul 2020 11:20:25 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id h18so14619419qvl.3;
        Fri, 03 Jul 2020 11:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3mLVVHY7FdkFjkZw2QLlsRjRTvH5SrJupI9xvtEqRIQ=;
        b=Rc6ecpAUZxlKKoyF7vlk0FdslAK6aDcMQ3MGlPztTg2piViAq9JbnxHTSQNLqPJcVi
         VR6cKE+dLgNJhfE12mi1BoV8YAxGOKmBOHrOSf5M/g0Tarw6rlxc0qZ+wrWaI0kRLqFE
         mIiHxR/IjpaItsKqal1jDi+ZEh5vWCIfLF6XdrI2aWx7WNW/OaGHN3lrIrtoYmGandRT
         lmIfoxldipo/TV2Att9Esdq/a7S7PpbfEG696KtQ6IqVzVtatCcJMj0HB5k9U6NtNv4O
         RwuU1/FewhuJfbEu+3n7htRMzLWrMcAJ6+0xxFLpgWTvI/qfzII7D4Hbvh83t5GiZGX1
         JxKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3mLVVHY7FdkFjkZw2QLlsRjRTvH5SrJupI9xvtEqRIQ=;
        b=KYNPXhe0GqcFYpw5UtLWVHcNFvhG9XKeLf1kWQGRzSUGciwq9xdBo/9dO+1j8sxYsJ
         JycJnb7eEibfCaMkrfKhEcmsBqASi7pHLQMH2lwgH4caRE1Tk64/3Iq65EJwU2HT/oIE
         AmswrDvNviJI9dEhEK0lhcDmiNOyjsSwKQXP89s/1lRsEHvgyWHYeF01PoEeruQc5Vma
         mI8gfOfj2dT8tBonRkQtLXGjASNEUREr2VhYRGpxMSF72j9rx1QhCOhL/oby5aadIWZj
         dlTo+PESdELfv/qNzlx2LO/BCESRlsJpr8nqsdc0+CZQbQf9QFbi0DiX84GjaX6yY5fZ
         FFGw==
X-Gm-Message-State: AOAM5304iUFg0BGKBqQJ1GvZQn9rbWSI9bxtFlfUCwfz90FB3k6kpkJl
        WT56Y6lumjERyR3zF8NkOkY=
X-Google-Smtp-Source: ABdhPJw9UJiwE2SHDDqHRxaGHXVcSfg7EtUIy7Kt7D88LEPS+FaXtEink+Ytj4Z6/F6qu2lFIdC0rg==
X-Received: by 2002:a0c:b4da:: with SMTP id h26mr34323663qvf.155.1593800424146;
        Fri, 03 Jul 2020 11:20:24 -0700 (PDT)
Received: from buszk-y710.fios-router.home (pool-108-54-206-188.nycmny.fios.verizon.net. [108.54.206.188])
        by smtp.googlemail.com with ESMTPSA id w28sm10412470qkw.92.2020.07.03.11.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 11:20:23 -0700 (PDT)
From:   Zekun Shen <bruceshenzk@gmail.com>
Cc:     Zekun Shen <bruceshenzk@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: fm10k: check size from dma region
Date:   Fri,  3 Jul 2020 14:20:09 -0400
Message-Id: <20200703182010.1867-1-bruceshenzk@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Size is read from a dma region as input from device. Add sanity
check of size before calling dma_sync_single_range_for_cpu
with it.

This would prevent DMA-API warning: device driver tries to sync DMA
memory it has not allocated.

Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index 17738b0a9..e020b346b 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -304,6 +304,11 @@ static struct sk_buff *fm10k_fetch_rx_buffer(struct fm10k_ring *rx_ring,
 	struct fm10k_rx_buffer *rx_buffer;
 	struct page *page;
 
+	if (unlikely(size > PAGE_SIZE)) {
+		dev_err(rx_ring->dev, "size %d exceeds PAGE_SIZE\n", size);
+		return NULL;
+	}
+
 	rx_buffer = &rx_ring->rx_buffer[rx_ring->next_to_clean];
 	page = rx_buffer->page;
 	prefetchw(page);
-- 
2.17.1

