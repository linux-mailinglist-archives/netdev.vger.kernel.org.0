Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C4625A38A
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 05:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgIBDBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 23:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbgIBDBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 23:01:31 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6D6C061244;
        Tue,  1 Sep 2020 20:01:30 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id w16so617149qkj.7;
        Tue, 01 Sep 2020 20:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3x1QWVcgV+kCL2v3rjpXLpxxpmca/bBAk4cfuphyefA=;
        b=YJS28xmm9bZJaXn1I6nWYR7R0sIXxeGpEHgC5eSnY3ry0NH5tSpW16+9oyh9fMuquo
         lQpu/Mwii80WiPoaUlcmEfB6eGzA07Sqq3+Xhg8TXkNa9B+tv1dUWKRIAtFJfzG+NA4P
         bbjwdRYCHqfL++pNH5bH/E8GMN2P7vhwbROsU9+dkyhhFOQFqSgFELd67uRU/gcsh1Uk
         UN6v5FOdDuBO3i1OQg1s0TO1RdzEwk0c0gp/0JE8TC8DrYzLWHtCn/XyNvykThZYqSrU
         oao9nXruQZIaJ9mr6R9g1M1zdHRDmlJz4gaBGSAcV0OT9RP26NEaCc323USLDq4KZOc/
         OGAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3x1QWVcgV+kCL2v3rjpXLpxxpmca/bBAk4cfuphyefA=;
        b=poGzZCwLQYUPTMhY7WJd2y90RhhYQoo+qkhsKpMvLrhZmRB72PQ5d5UbS8G6COoJUD
         a2vbplv0IDv0MWyhm/9Dwcuom4Kf3riU+PH1BBtl+x9/D7vVZdlsc/5vc+ysEWG2/L5i
         NVg2QiGmh1cdVotDC7cJ/Ie6MeY3MiFGKFCGZIjLMzoFOTSEXvmIT4/ONUQ3ydaX93JX
         8qInQ6fr3e/jqpoLUOJjuoLKa+uuvimHiBFMRvhdCeGKrF36gJ8HnoxILWN0UGP4xesh
         +AVB4fgH2Y0WIemJSRkS6omNwe9iruPMqgxnyk6Ft1JITa8fROFw7UfQh01exodPHbjW
         3qIw==
X-Gm-Message-State: AOAM530LvuPk9n/jxnaPAyIAwem+jSXCpPPTfOZROVniGbmeCH/uUGtO
        I9Ae588shit7xLpRQKTL5Bg=
X-Google-Smtp-Source: ABdhPJyb0FqQ3u1qH/En3jl4UttQiZyk5y3+Ac7g5mkBqnfhzww0mjsSKWhujFxvb7PFMOytajBYMw==
X-Received: by 2002:a05:620a:1125:: with SMTP id p5mr5124774qkk.328.1599015689710;
        Tue, 01 Sep 2020 20:01:29 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id f4sm3588682qtp.38.2020.09.01.20.01.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 20:01:28 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 9E1A927C005B;
        Tue,  1 Sep 2020 23:01:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 01 Sep 2020 23:01:27 -0400
X-ME-Sender: <xms:BwtPXyvx0DNJ5FayvhFN-qnAunBfYTL62OMG4HM--TZymHnQNP8q5Q>
    <xme:BwtPX3dtPa7NEcSiL3JS1uEuM9hZ063RB36RJKYD6EYTApdBw7W0b6dK7Jk6-0tGb
    IUzS4rxuW9c5u6PgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefkedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjughrpefhvffufffkofgjfhgggfes
    tdekredtredttdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnh
    hgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeehvdevteefgfeiudettdef
    vedvvdelkeejueffffelgeeuhffhjeetkeeiueeuleenucfkphephedvrdduheehrdduud
    durdejudenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtd
    eigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehf
    ihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:BwtPX9zdlHPyvbfiLj_l2JpEf-_NVk41Z7I6aHg3-L4elr2ei23c0w>
    <xmx:BwtPX9OKaYkY-FssRMjTcmBCQR_wq_bPEqlhriV3oXle4zEKnU3mQQ>
    <xmx:BwtPXy9ycYV50bUceMK7eu1jaQnEcUQGLPSrFRFreDF5jo47E71T6Q>
    <xmx:BwtPX9cqU7OaIpwxZmi5zWQ8WQIxoTgUsEfaNZ8G7VbNfAzuJ2rsK0DPjmU>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1C43D3060067;
        Tue,  1 Sep 2020 23:01:26 -0400 (EDT)
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
Subject: [RFC v2 05/11] Drivers: hv: vmbus: Move virt_to_hvpfn() to hyperv header
Date:   Wed,  2 Sep 2020 11:01:01 +0800
Message-Id: <20200902030107.33380-6-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200902030107.33380-1-boqun.feng@gmail.com>
References: <20200902030107.33380-1-boqun.feng@gmail.com>
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
index 7c443fd567e4..74a8f49ab76a 100644
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

