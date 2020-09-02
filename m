Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A2E25A380
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 05:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgIBDB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 23:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbgIBDBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 23:01:24 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A46C061244;
        Tue,  1 Sep 2020 20:01:24 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id e7so2602022qtj.11;
        Tue, 01 Sep 2020 20:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5XgEkGxv2E2AECNr+4xn15ufLIzEXL6wFg7AGQm6deE=;
        b=Vy/4VBTWTL4CbZpFkBNzZThslEGpTpQ6X9DHlQwRPYrSCWqQbavsWxEH/uHdM/sjnK
         2n50pAYN3dQPhSe4c9lz50gJhCQrxAZE54Dv2m0fNbwVSI6FTckZF47I5NjT6vl9c3Iz
         WIX57VPjLUBypzkDQO3/TyXZC1FSsUKbY07Sy3SOYhAooTr7BLujjwCYc+H1Y7hT9B3j
         giKdrwMlcxTdBZbDELXzNjTvyCfRJ0d4Q3OfC3hxlBEhd26evk0o6wxovx+mQGjHORcH
         eJbIl+A448VyatVvni0+dIQmuSZruPlTjQQv/RQjVUkBWhsSS9n+83q4OUoHVFzz5xWD
         i/+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5XgEkGxv2E2AECNr+4xn15ufLIzEXL6wFg7AGQm6deE=;
        b=F4+tIEjz3zTwh1QVqZ9zeK2qZP2s26qIalfDOhdIoFM/0XIkAMLEXP181ttz7vlT83
         7PrQh9apL1VhHspnOcq9O41tLqaQb4Sv39GkmkMw6teQVP24VfD3HPCVCflqLSGbVKJo
         TPiOGofibSgXz7rBdJB2OO327qr+8kLlqH3Ktathb5YXADG4hgx75sJeutfV2OMdLZfK
         O8nL/yUBSz1FeKFg6d9qkwn+JjjxiJsqge7hPxbIF1UFnrvxPgQgRn5ktrFVF58s8D4Q
         VuW2uaqxz38K9wfsr/m2fsPLmXwkVWTW3yADUlc97VBGOwd9mlCtYkIUCiA4x5UCcwKF
         llAQ==
X-Gm-Message-State: AOAM533mTklfLJ5CmV+k6HNtaI7OSANgJu0GYF65asz1PKP0R/EClphq
        SygKmEucun5uZ77/SkUmPNI=
X-Google-Smtp-Source: ABdhPJz5Rb4nRW3wJN+qGPKf3jFe+F0PQAcfMlyqOMq35qb6gRryNubBULlWOuDUf91tdg5vkNfoCw==
X-Received: by 2002:ac8:f86:: with SMTP id b6mr5017904qtk.252.1599015683461;
        Tue, 01 Sep 2020 20:01:23 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id r21sm3470788qtj.80.2020.09.01.20.01.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 20:01:21 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 0D39927C005B;
        Tue,  1 Sep 2020 23:01:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 01 Sep 2020 23:01:20 -0400
X-ME-Sender: <xms:_wpPX6g6-j0-4exZFguTnovkg0O8fI9fpzdlN7pxS5PvbLCLL6ytYA>
    <xme:_wpPX7AFFD_l28yj4gdTW9hr4FeBhA1wdiVrwTCk4eOVrrzFymFWEiabl1z8m8kap
    ZrSg482UEd_xXYpSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefkedgieeiucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:_wpPXyHkQq4MFJcU7GcTivm5IJ_u5Xlyrls2she6mVHYeS1LjufG9Q>
    <xmx:_wpPXzQ0wHx2xGFoV7zDFttoCy93_25lhdE7SWvxlqnLJMtWOGVYxQ>
    <xmx:_wpPX3y28EDpOwq6ZszwjdrGzJ-9rkEl_JVmr4OeX-u6WISL7Py-OA>
    <xmx:AAtPX3B5pw_NyqWI6eHs0q9xmpdlpYk-g2XDImTPMHCU3pXGegPzXCzy3hA>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 78AC23060067;
        Tue,  1 Sep 2020 23:01:19 -0400 (EDT)
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
Subject: [RFC v2 01/11] Drivers: hv: vmbus: Always use HV_HYP_PAGE_SIZE for gpadl
Date:   Wed,  2 Sep 2020 11:00:57 +0800
Message-Id: <20200902030107.33380-2-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200902030107.33380-1-boqun.feng@gmail.com>
References: <20200902030107.33380-1-boqun.feng@gmail.com>
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

