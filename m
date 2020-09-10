Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4174926520B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgIJVHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731164AbgIJOfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:35:19 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DE9C0617A2;
        Thu, 10 Sep 2020 07:35:18 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id i26so9016009ejb.12;
        Thu, 10 Sep 2020 07:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WR4JWrGv996OeneE+c3ZZLsHt7Sf8sK78dGUgjv8gw0=;
        b=bunKmthQjY1irGwYfXYtjhpBoZ02Q6GFR0J1xS/txz2ysnXVRbnag1W2zPWtSKdmaV
         RBFOGBbeudEBHV/UkPOzV5VFDOOGdrlAQmjEklpj25Fparz9D6SYrpguzxhj1hsKWGva
         bQRlAUPv4XnmUKoE6hWKFAwCBBWGcFz7xwLIJAIRaPQLjEKGbHhrGtLBAV+2oKcdqYVO
         DNTYTFwQvQwWWhAFWzKSQfLu2hlTPeD3zZ23iv+hy+kW0hG+l+5DY5ZC7VIq8tlkX4Jh
         GiRrHvcA/N1109bE2l1BuqymIFDZA/mp2S+431W2ydkS0ds1fgx3KpTStx9cDNHzKCLe
         ZwjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WR4JWrGv996OeneE+c3ZZLsHt7Sf8sK78dGUgjv8gw0=;
        b=a3LW//f0rO9uX/9uB1gFPVgf7f436BAoHXebYzcSV3hxJSnn1/FKFCS/9/rCJxv5td
         409sYRl+G7jKsugEBPb/Axkh0Xy5sHw9zNNTQWNuCvBecHgp9ZvXyTK1aOnt+u4U8jYB
         CAKxuAOUSBxgJY1b9/pAkD/U/KoZGu5cBVmyXZ4OQ6KX/yFjUteE6MiKsiIr6bPqkXDY
         AEAnBo0nklDM/VaEqY7KSZ6Ye2wDzhlkktQ+qh2M32H7sNJIfJxOeCrAaeRk7+ApGkqf
         X+Q/bwotHanQsOSDbW+PjSxbDc00bozJBlC5eJYc7ec5+C7pFUotdgTqvV8Zg+piAoTl
         WRYA==
X-Gm-Message-State: AOAM532xQff+VYnp/PviiSVpuJcofCydqd0F6EvvAUHqfB/a4935B8TG
        x9LyGzf9JzvZKa7BdjH7/Ww=
X-Google-Smtp-Source: ABdhPJyx94Q8cxj894AhQFJ6+F7LX3XL9vOl4x+f8GGk2eU5cFiTAZOpfT19O7Hv+oTFkuExFVh7cw==
X-Received: by 2002:a17:906:8690:: with SMTP id g16mr8920407ejx.187.1599748516837;
        Thu, 10 Sep 2020 07:35:16 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id v5sm7251507ejv.114.2020.09.10.07.35.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 07:35:15 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id C4EF727C00A1;
        Thu, 10 Sep 2020 10:35:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 10 Sep 2020 10:35:11 -0400
X-ME-Sender: <xms:nzlaX9VW6T-TIfDuAMRpAIqVsI6sNngbWNPbPrK69zRAPGAKjkG1oA>
    <xme:nzlaX9lyr-QJHxKQewCdn-ggInp22js3sUFKiKWrkb7AVJ0alE80T2fvbWF2KhYc-
    UII_ur5wWeXg2_Z0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehjedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjughrpefhvffufffkofgjfhgggfes
    tdekredtredttdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnh
    hgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeehvdevteefgfeiudettdef
    vedvvdelkeejueffffelgeeuhffhjeetkeeiueeuleenucfkphephedvrdduheehrdduud
    durdejudenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtd
    eigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehf
    ihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:nzlaX5Y0TwVbLwHhj4ruqbnULLyvEWTi--OH5G3CXr5DOrS_tvNcfA>
    <xmx:nzlaXwWUIz8BecM-vA_h-pSgLv4G_NA9t28o39z5Xt1VKI1kq1E6JA>
    <xmx:nzlaX3lIAuB4aCJ2VlsTUOvw8H62Mg6zHPBs9WS1TBz6whFQ9tkGJQ>
    <xmx:nzlaX5V_g3A1go8w2V1VlUHy_dEQ8Cih_o_4Er6jzf5l-TEhmn1HIUq1Wz0>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0D5C23280059;
        Thu, 10 Sep 2020 10:35:11 -0400 (EDT)
From:   Boqun Feng <boqun.feng@gmail.com>
To:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Kelley <mikelley@microsoft.com>, will@kernel.org,
        ardb@kernel.org, arnd@arndb.de, catalin.marinas@arm.com,
        mark.rutland@arm.com, maz@kernel.org,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH v3 05/11] Drivers: hv: vmbus: Move virt_to_hvpfn() to hyperv header
Date:   Thu, 10 Sep 2020 22:34:49 +0800
Message-Id: <20200910143455.109293-6-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200910143455.109293-1-boqun.feng@gmail.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There will be more places other than vmbus where we need to calculate
the Hyper-V page PFN from a virtual address, so move virt_to_hvpfn() to
hyperv generic header.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 drivers/hv/channel.c   | 13 -------------
 include/linux/hyperv.h | 15 +++++++++++++++
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 45267b6d069e..fbdda9938039 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -22,19 +22,6 @@
 
 #include "hyperv_vmbus.h"
 
-static unsigned long virt_to_hvpfn(void *addr)
-{
-	phys_addr_t paddr;
-
-	if (is_vmalloc_addr(addr))
-		paddr = page_to_phys(vmalloc_to_page(addr)) +
-					 offset_in_page(addr);
-	else
-		paddr = __pa(addr);
-
-	return  paddr >> HV_HYP_PAGE_SHIFT;
-}
-
 /*
  * hv_gpadl_size - Return the real size of a gpadl, the size that Hyper-V uses
  *
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 7d16dd28aa48..6f4831212979 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -14,6 +14,7 @@
 
 #include <uapi/linux/hyperv.h>
 
+#include <linux/mm.h>
 #include <linux/types.h>
 #include <linux/scatterlist.h>
 #include <linux/list.h>
@@ -23,6 +24,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/interrupt.h>
 #include <linux/reciprocal_div.h>
+#include <asm/hyperv-tlfs.h>
 
 #define MAX_PAGE_BUFFER_COUNT				32
 #define MAX_MULTIPAGE_BUFFER_COUNT			32 /* 128K */
@@ -1672,4 +1674,17 @@ struct hyperv_pci_block_ops {
 
 extern struct hyperv_pci_block_ops hvpci_block_ops;
 
+static inline unsigned long virt_to_hvpfn(void *addr)
+{
+	phys_addr_t paddr;
+
+	if (is_vmalloc_addr(addr))
+		paddr = page_to_phys(vmalloc_to_page(addr)) +
+				     offset_in_page(addr);
+	else
+		paddr = __pa(addr);
+
+	return  paddr >> HV_HYP_PAGE_SHIFT;
+}
+
 #endif /* _HYPERV_H */
-- 
2.28.0

