Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C40F2274BB
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgGUBmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgGUBmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:42:01 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9122AC0619D5;
        Mon, 20 Jul 2020 18:42:01 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id d27so15034702qtg.4;
        Mon, 20 Jul 2020 18:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Szv0wbeilFX0kuaH3VpGL3Z7ZcoQ0OQkpBfV51CLwOE=;
        b=Hrpb8Ar+JZA0aFF7EImncibVuhP9bbLehF62vZQUHiTvetSwTiXNmgKnXap5chhNdL
         FQ5GQiiq10nzMkIn3lqJ6XMs97NziwblfT7Drr6yATSoyDQKHgi+LIIyPBeZfof7PQJk
         LCfsKaK9Kgr9bN39gRePMo/V0DgGzBhSZFU78kFuSIEK6P0V3uX60GfPmJRmcSoaiV6Y
         u0JRzGtYT6xnV2ZNRx7/lWwxXp7gcpu4YF4epFbGj9O0o7tgrjhFUFx+v35BAJdd34xW
         imFqaPNc89ONPjIZcX9zfPCjq/D3GECb10nFW61AXhKcSsLW/YTbEYGAwZj1uk1Lv2RQ
         VXmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Szv0wbeilFX0kuaH3VpGL3Z7ZcoQ0OQkpBfV51CLwOE=;
        b=hwt3wsQdlcHFIp05j9F9jgqrmxVHoDYggIulF0YwgzaXHM8ss+k/o/TyujdiuQks7y
         iUo88PjihOklQ0J7bwqtlMwr0eNYBM/XHkQyoMcO6yzAuJAo3NaXb2DnJRe7fljxHXVO
         Gmv0AnO5aE4jQJVMP2q9K/rCbNjsCFYKmAtPkXcWQfstfDsEMpb8it4f0asxT01DkgqR
         Q27FRQsNBtqk797WaRMB7Y0tNgPdBj1DLIjwrjhgVPtwEPw0TSsmxYBRpQA7oYHD7yse
         JPnsHGDZECKIWWCzws5mbi0jEw0QLo452EiBsWjiHX4PiSieNU8VoJgKf9q0VDpvr01o
         srBQ==
X-Gm-Message-State: AOAM533plpHEVsy37n7zraTYL2zEIhzcpDZXs9HRaGdmDu+tbfR7t+E2
        HWMU15Rf2hCEqn15Q203UFA=
X-Google-Smtp-Source: ABdhPJzxuxAsLaIVcnzKtCP8RazeXqyj/osxNRSctJGVpCrqC4dNoDucRpAb/UxZIAxPbj0+4CYSxQ==
X-Received: by 2002:aed:2942:: with SMTP id s60mr26674342qtd.139.1595295720851;
        Mon, 20 Jul 2020 18:42:00 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id o15sm1265646qko.67.2020.07.20.18.41.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2020 18:42:00 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 99DED27C0054;
        Mon, 20 Jul 2020 21:41:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 20 Jul 2020 21:41:59 -0400
X-ME-Sender: <xms:50cWX7jc7PXnAowf0h7v6fFnx0nEXiLRN9Z9iFRBPpAja9D51HcLjA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeehgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuohhrthgvugftvggtihhpvdculdegtddmnecujfgurhephffvufffkffojghfggfgsedt
    keertdertddtnecuhfhrohhmpeeuohhquhhnucfhvghnghcuoegsohhquhhnrdhfvghngh
    esghhmrghilhdrtghomheqnecuggftrfgrthhtvghrnhephedvveetfefgiedutedtfeev
    vddvleekjeeuffffleeguefhhfejteekieeuueelnecukfhppeehvddrudehhedrudduud
    drjedunecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhep
    sghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtie
    egqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhi
    gihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:50cWX4BmvdVnzbvSCr6rPFrsOcwQOzkLKTZBNsBp_I9QlnS7poEzdg>
    <xmx:50cWX7H8G6Fm0YCG2s-P8DawomGurFMceS-6vzLYeZDiBrao2hSvHA>
    <xmx:50cWX4QJAXRUvrBCWqi0sGQ0Vz4wwMDI2qWGv2WyDUwcRqtKe99jUA>
    <xmx:50cWX9JtEoTkgDyXJH2czWHlt9Yh5sIr0tJT6_zmS2KKbo3f_mnItnR--U0>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 184E83060067;
        Mon, 20 Jul 2020 21:41:58 -0400 (EDT)
From:   Boqun Feng <boqun.feng@gmail.com>
To:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
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
        Michael Kelley <mikelley@microsoft.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [RFC 05/11] Drivers: hv: vmbus: Move virt_to_hvpfn() to hyperv header
Date:   Tue, 21 Jul 2020 09:41:29 +0800
Message-Id: <20200721014135.84140-6-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200721014135.84140-1-boqun.feng@gmail.com>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
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
index 13e98ac2a00f..ac7039fe2f29 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -21,19 +21,6 @@
 
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
index 663f0a016237..eda8e5f9a49d 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -23,6 +23,8 @@
 #include <linux/mod_devicetable.h>
 #include <linux/interrupt.h>
 #include <linux/reciprocal_div.h>
+#include <asm/memory.h>
+#include <asm/hyperv-tlfs.h>
 
 #define MAX_PAGE_BUFFER_COUNT				32
 #define MAX_MULTIPAGE_BUFFER_COUNT			32 /* 128K */
@@ -1688,4 +1690,17 @@ struct hyperv_pci_block_ops {
 
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
2.27.0

