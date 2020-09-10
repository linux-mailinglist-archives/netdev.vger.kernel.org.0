Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AC326520F
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgIJVHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731086AbgIJOfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:35:19 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E678C06179A;
        Thu, 10 Sep 2020 07:35:11 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id e23so9078772eja.3;
        Thu, 10 Sep 2020 07:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5XgEkGxv2E2AECNr+4xn15ufLIzEXL6wFg7AGQm6deE=;
        b=m8lLPubCJpHMsQ48XiovlcumnVbXdBf42PYCwXR+nF9UI7WC7XIGLSSRzwevHANLQk
         wi+0wfVGtDuv9VyzBxk5x6VvsrREhkADpJa4OxRgqXz2AsYSfvBcgqB0ToFEWO8u3tWN
         mWOxetMUEYFRa+XpycbBi5i4G605LdbyPmRhVhTNMy5f6leotLr/LGdAlkRL+NLA9BDM
         CELVU0bm48OhKDc6iwUzlOsTrlz9JZSDqsgAmp+hJEf/yqqwkzoy3uqLTvQObrWtpw8s
         wMHtcul6J5cHJystPlmiDiwcamkqhsn68STmLJvwBAFWfyFigrFAFaQ8vDu4yzUXi4wm
         DAQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5XgEkGxv2E2AECNr+4xn15ufLIzEXL6wFg7AGQm6deE=;
        b=O9jhSXk/QKFHBrdbq8XZPfEctxG/yErETsnLIfyXSizPqBYY/FY8cUzGFskNddW7Rq
         6JLv5zQW3waEVU+xNCB0IACGI8Z1Qymi9UGBbIMVVVXOMM0T4j0QR8K5cWpEwDsG6yHq
         9dG4ifNdnTQ6a8j3Yjij96tDNaN3V/7zBXeuGlAJ3HMrxbjVbMyuJzs5varp9hFoO7Jo
         ChdQCqZndN+gltxZDrRkS4U5S/9Cyscyzkph2tuavHaAcykzE3J0vvxssHAzq5+xKT57
         MMD/gjpthmboTffIqI/YErsXHU3ufiAtTIgDT4Cyl3ZvMQOdTOaapmq25zWNBrtAKHIO
         mc1A==
X-Gm-Message-State: AOAM5321KPyknoZ6QYpEq+YWLqWe/0smj3BPyUKS4LNL1rnDjWzcE36L
        CJaSk3TxSCkM7vU5EHHvp1eQOkDelxg=
X-Google-Smtp-Source: ABdhPJwt6EVWdU+oFrWM8ATuZDym8zURbyb9o2FHDvZYxl/IdS63b9usGvYjJ0DU6WKUJgG2KJ7UDA==
X-Received: by 2002:a17:906:15cc:: with SMTP id l12mr9418864ejd.7.1599748509943;
        Thu, 10 Sep 2020 07:35:09 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id h10sm6974601ejt.93.2020.09.10.07.35.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 07:35:08 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 0404A27C00A1;
        Thu, 10 Sep 2020 10:35:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 10 Sep 2020 10:35:04 -0400
X-ME-Sender: <xms:lzlaX0qBehOdtltJ3EQijS5jUabFZfUTwyu4zpMlbNwzSu3wG_wfng>
    <xme:lzlaX6qkf_98am-ZsB9WDDfsoj12QkabX9DPXmvkrvqk6UjUGI5Wnv2ZyN0LQ_Md5
    Swn4g-34fv1r7oMig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehjedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjughrpefhvffufffkofgjfhgggfes
    tdekredtredttdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnh
    hgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeehvdevteefgfeiudettdef
    vedvvdelkeejueffffelgeeuhffhjeetkeeiueeuleenucfkphephedvrdduheehrdduud
    durdejudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtd
    eigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehf
    ihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:lzlaX5MwYqew8UloIKgQBibirw4XhUIAXuiN2ii9fVL74nMYwN_z3w>
    <xmx:lzlaX74s2gLUCxysrIqV4KK-VfUW0_b6XHrrt5smAH4-9v76XYE4yg>
    <xmx:lzlaXz6Fg3oykvCf82FMqpxR-GtwasyfBPR2WWQqTv-foUl_g6S4ww>
    <xmx:mDlaX4oITAQodS8EjouCAMOm9aU81WGh3CiGaijYG7df6EmWmyqRnHU5Ij4>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id E073B328005E;
        Thu, 10 Sep 2020 10:35:02 -0400 (EDT)
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
Subject: [PATCH v3 01/11] Drivers: hv: vmbus: Always use HV_HYP_PAGE_SIZE for gpadl
Date:   Thu, 10 Sep 2020 22:34:45 +0800
Message-Id: <20200910143455.109293-2-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200910143455.109293-1-boqun.feng@gmail.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
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

