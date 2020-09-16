Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0433C26BB1C
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 05:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgIPDvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 23:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbgIPDse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 23:48:34 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58671C06178C;
        Tue, 15 Sep 2020 20:48:34 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id di5so2833533qvb.13;
        Tue, 15 Sep 2020 20:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LLfWd/DL19TaMGLzlv+saDu0DmdhCKi6JBFDyV46Z4U=;
        b=QxvWBZUWRGZUC0l/CHUVQEAlbrS/NPQVFXHgWKwr7wM7p50e4ovtKUhCLX61aNsKcf
         FFWpm2OReF/5Avg/lsKKayKuDV6tIboK0nTuNtUIHnUiT2+v5T8SkRwnty0xbjS5G7G/
         iLGRJoMWSzPl3TAhuHRPMmsmTDWaLndjlL8gpzGeqwbhaENWV5mxtKBH9OYbww/UIdEV
         oxZBhehFPDDVY/jnLB1qzGWN7AQrEbjPKTMKZLxKBrxZUBLtk+BDenVflmywi1199hhg
         fNRsDTGQdjYy4FmFgXdAAw3vX5QT29ZV8v9XZruUliDaXiAsauJHCuz4QnEUiMynPyK5
         MF1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LLfWd/DL19TaMGLzlv+saDu0DmdhCKi6JBFDyV46Z4U=;
        b=EZVTZcS/8KU5v5bNOzd3qheiBfrslGB4pGaPKcPjhR5IlWDG4b0mZE3h5J5t7i1RSd
         K6PGIVwLR87k3tku+BiJ6i972R/FltuRWVjVVPBs8e5LCRHPX6BS5/wc1GBLqSIyZGcx
         7aUOuVfrOPhfrrr6vrQDgc8+Q8P4NmWCggofapkJuS3kbfcPh8NH6nt8IBNhIiXCj88W
         3/DvdG0D+b5dOoK5RRIcK1/E2osNnX6ZLprpDoTYQzhqwyCJj3ZlTbu1g01Ykuw3HhjB
         3wh+bMdBraDKI/eBJ7jxhzmHAFoCOK7MBPddkfwAxR9eL9UWCL08VgSzQTByccDwQ1Hy
         G+KQ==
X-Gm-Message-State: AOAM533xWO2ibU3/h+e8Z+EdObqLxU7aasnNHlRa/jDOSTPdwbJo77iu
        0pDGiTf1yTO9EleF617hbW4=
X-Google-Smtp-Source: ABdhPJzJQHG3X//D7JwlwujItinTq++iLAYXDD8WfKbl+aAgbTthqjfrC3eAy+2+bR0FGgrH002qrA==
X-Received: by 2002:ad4:5a0e:: with SMTP id ei14mr6514536qvb.15.1600228113592;
        Tue, 15 Sep 2020 20:48:33 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id j6sm17570163qtn.97.2020.09.15.20.48.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2020 20:48:32 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 2164727C0054;
        Tue, 15 Sep 2020 23:48:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 15 Sep 2020 23:48:32 -0400
X-ME-Sender: <xms:D4thX0MHO-of8HMXJSGNQ-SmfESBTREk9Qo-40UBn-g1AV0AXhaOQA>
    <xme:D4thX69lYte7WLjnTXac7fRFoZuz_RVVYCB1X2PvkwWdeOrRsLsUtkGZe4RUU83jH
    J3F-lCsehSPpGecqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugdeikecutefuodetggdotefrodftvf
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
X-ME-Proxy: <xmx:EIthX7Td9JJZohS94NNSyW5zmxZFQLtbXudjVBBHjFILrHSmM7enMA>
    <xmx:EIthX8uJRVCXM7mJlg8vzHkg4jZnqO5XcIGCZ0umYYAimxcLaZVr-Q>
    <xmx:EIthX8fRz_Se2ElsDQ_x-PEyydZ1wB0LBIh6sEfMj0lfGbMpkKzUuQ>
    <xmx:EIthXwP_S8c1u9cbVVkBE_M9UG-lY0N8xubf5rtaExQzNiuDTpbgwhRDp4k>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5D90F306467E;
        Tue, 15 Sep 2020 23:48:31 -0400 (EDT)
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
Subject: [PATCH v4 05/11] Drivers: hv: vmbus: Move virt_to_hvpfn() to hyperv header
Date:   Wed, 16 Sep 2020 11:48:11 +0800
Message-Id: <20200916034817.30282-6-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916034817.30282-1-boqun.feng@gmail.com>
References: <20200916034817.30282-1-boqun.feng@gmail.com>
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
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
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
index 9c19149c0e1a..83456dc181a8 100644
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
@@ -1676,4 +1678,17 @@ struct hyperv_pci_block_ops {
 
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

