Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4670D26BB14
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 05:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgIPDuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 23:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbgIPDsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 23:48:35 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77ADC061788;
        Tue, 15 Sep 2020 20:48:34 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id b13so2880080qvl.2;
        Tue, 15 Sep 2020 20:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gOcmg4IMNFTqYZ01jlTh8L9x9KAkyEuPaP6YqIjNaFU=;
        b=arW+8hn8rURmqWY0fy2K9vdZEbG1Nwh80Prn6jnkmllW7Pd3lh54VMNWULqdbKDy2r
         DxtPZURiUKYTsFLXAM8OT/g5lYVwEkW+rhP9fFjgYijGpvDMPb6+RTJqhtmvDRN5TPl0
         6Oseoc2wKqYIl4VFJVL2/4r8mqo6ax6Byvb5hw9XmwbsdlPHYb9Vr2TaMB2wy9zCVkho
         z2Wvjd8CG6v+JEToEgvZMHKb1udD3XHAXTetP29vDZ6Tt5O1EeJiOAQG5Ob3dS09ibf3
         jieCxJw+3qE8qIdjJPAm06xQrKSvG6P7tlE2KgCSKutTGe9vKCebNLCXn3WQtKPLbwRx
         CYKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gOcmg4IMNFTqYZ01jlTh8L9x9KAkyEuPaP6YqIjNaFU=;
        b=fWh5n+qJztRlUD/IdYWGLPYj5aoCIMVddAqpSzw3ZbQT8JwCsuzwAKoRWZQQNDrE1o
         J/ZpFsg1/8eYwBVXto3ibFj1IvcSTVIOZZ9PGzj5rbWl3P30PzE5Uy/TbRyccyiqQB8G
         QbpN+FuLkm8rWRsh9gt3agmrALaaeYp/cKndmx1FDupMmIvg8eG63oV7ulCejxJCMJb3
         r/rP+blzPcV6ynoXLjArGoPSJ8KVZ/N1FrkL6SFYBg6JG859Yjr2WVRDzD0UcDThyINC
         RD3UBF4FHtLjEaueSKYvV/SChmOcJDSXEvj6ImjIrykJPK27ChRN8oTfAuaIQLAGZmKH
         EGEw==
X-Gm-Message-State: AOAM531E926LeCkww5ydNuO+A7OA+7LkObdGucKp26KQ7gbPSFGMMMdP
        ZTGZjoPRnCQul64oF6o3Lyc=
X-Google-Smtp-Source: ABdhPJwtjuEfJkyjOps9UuDPPFzClrryBMXLsB8cMkbs8w9iSojNXoMavZtS+L/Au9Kq68BOp2D62Q==
X-Received: by 2002:a0c:e188:: with SMTP id p8mr21794857qvl.8.1600228107563;
        Tue, 15 Sep 2020 20:48:27 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id k26sm1168262qtf.35.2020.09.15.20.48.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2020 20:48:26 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 2B27927C0058;
        Tue, 15 Sep 2020 23:48:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 15 Sep 2020 23:48:24 -0400
X-ME-Sender: <xms:CIthX_2eQ_IkUPI8JgHm8Lo_Ida_jKAaYW7bgUWoy_LBsBozpn3kIg>
    <xme:CIthX-Eb1CYQ1dAIyMuVh9S1KYB4bsOlJEotHXGxnk8wVa3xDyK1xZN-tKj9rWNWf
    cR43oNtjePpo1RfWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuohhrthgvugftvggtihhpvdculdegtddmnecujfgurhephffvufffkffojghfggfgsedt
    keertdertddtnecuhfhrohhmpeeuohhquhhnucfhvghnghcuoegsohhquhhnrdhfvghngh
    esghhmrghilhdrtghomheqnecuggftrfgrthhtvghrnhephedvveetfefgiedutedtfeev
    vddvleekjeeuffffleeguefhhfejteekieeuueelnecukfhppeehvddrudehhedrudduud
    drjedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    sghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtie
    egqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhi
    gihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:CIthX_5cKOIThMGN-JFcSHMMqSgq8ocEwAEkXr3l5qPgopBf9KKS2Q>
    <xmx:CIthX004x9GTnxsrorT_cGDDJBJJkG-SfO5iOgsjgUou-OHI5loFaQ>
    <xmx:CIthXyHrpzfnsOSZRu3YaAwM3OItx7lhmlyzk-wyP-fybuLryEVyfQ>
    <xmx:CIthX737rLrGSafpYRuWsoU-LY6kUk_x7VdMrftZZ3OuQt3Evipf128mfQQ>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 783A23280063;
        Tue, 15 Sep 2020 23:48:23 -0400 (EDT)
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
Subject: [PATCH v4 01/11] Drivers: hv: vmbus: Always use HV_HYP_PAGE_SIZE for gpadl
Date:   Wed, 16 Sep 2020 11:48:07 +0800
Message-Id: <20200916034817.30282-2-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916034817.30282-1-boqun.feng@gmail.com>
References: <20200916034817.30282-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the hypervisor always uses 4K as its page size, the size of PFNs
used for gpadl should be HV_HYP_PAGE_SIZE rather than PAGE_SIZE, so
adjust this accordingly as the preparation for supporting 16K/64K page
size guests. No functional changes on x86, since PAGE_SIZE is always 4k
(equals to HV_HYP_PAGE_SIZE).

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
---
 drivers/hv/channel.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 3ebda7707e46..4d0f8e5a88d6 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -22,9 +22,6 @@
 
 #include "hyperv_vmbus.h"
 
-#define NUM_PAGES_SPANNED(addr, len) \
-((PAGE_ALIGN(addr + len) >> PAGE_SHIFT) - (addr >> PAGE_SHIFT))
-
 static unsigned long virt_to_hvpfn(void *addr)
 {
 	phys_addr_t paddr;
@@ -35,7 +32,7 @@ static unsigned long virt_to_hvpfn(void *addr)
 	else
 		paddr = __pa(addr);
 
-	return  paddr >> PAGE_SHIFT;
+	return  paddr >> HV_HYP_PAGE_SHIFT;
 }
 
 /*
@@ -330,7 +327,7 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 
 	int pfnsum, pfncount, pfnleft, pfncurr, pfnsize;
 
-	pagecount = size >> PAGE_SHIFT;
+	pagecount = size >> HV_HYP_PAGE_SHIFT;
 
 	/* do we need a gpadl body msg */
 	pfnsize = MAX_SIZE_CHANNEL_MESSAGE -
@@ -360,7 +357,7 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 		gpadl_header->range[0].byte_count = size;
 		for (i = 0; i < pfncount; i++)
 			gpadl_header->range[0].pfn_array[i] = virt_to_hvpfn(
-				kbuffer + PAGE_SIZE * i);
+				kbuffer + HV_HYP_PAGE_SIZE * i);
 		*msginfo = msgheader;
 
 		pfnsum = pfncount;
@@ -412,7 +409,7 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 			 */
 			for (i = 0; i < pfncurr; i++)
 				gpadl_body->pfn[i] = virt_to_hvpfn(
-					kbuffer + PAGE_SIZE * (pfnsum + i));
+					kbuffer + HV_HYP_PAGE_SIZE * (pfnsum + i));
 
 			/* add to msg header */
 			list_add_tail(&msgbody->msglistentry,
@@ -441,7 +438,7 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 		gpadl_header->range[0].byte_count = size;
 		for (i = 0; i < pagecount; i++)
 			gpadl_header->range[0].pfn_array[i] = virt_to_hvpfn(
-				kbuffer + PAGE_SIZE * i);
+				kbuffer + HV_HYP_PAGE_SIZE * i);
 
 		*msginfo = msgheader;
 	}
-- 
2.28.0

