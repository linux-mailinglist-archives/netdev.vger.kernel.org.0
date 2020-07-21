Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF9F2274B7
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgGUBl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgGUBly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:41:54 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC7FC061794;
        Mon, 20 Jul 2020 18:41:54 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id l23so10009660qkk.0;
        Mon, 20 Jul 2020 18:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DERd1XiiQ1hJZ50JeiQZinchj1o74kAZdZmYC8ZQ8Zk=;
        b=b6ayxuvJvQ/fwzYklty/r1lDrfj/p+90q0IYit9Tw5G260qDr+7RrojTXINlsDvYwu
         UvOma4L5rMrdOt6OltvQ8udaHZUfww2Qx8gMqYVIbh+6VefcXfn01OLu69IGIq8Nhrad
         iAY/ILDJu3mqcCVZ2ngEW3/v5SuXWfrainpdAQf24gq1UALtflzH2MoJ9dXOPursyB2F
         azb780Az11GdtgsBmOoDbqmiTyAgRL0n65fvTnW1SRLzQPcVkRsSo19MkLxJ7iIMEQVS
         H6m2FOP9mtv+AgiCy5MkYA8l7O+acI0rZE7jG13ucWT/WTE4epfVsWjMbrJ1j/toUM9L
         IdyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DERd1XiiQ1hJZ50JeiQZinchj1o74kAZdZmYC8ZQ8Zk=;
        b=Rmfw+hyGhQvbhr26vvEPvzASbKMzBcJjJ/QfWko/zctzznJPR7M2CJ6zovIBAvX5sV
         0ngIoDJcQpsgVepU7cDDf/PH5oTeBPCGVhmXkC1x7RB0Dn7moF9+ih9BozIhwU8IoBB6
         TGZl3oxijRLKae9LFRmFtq1u6pXKOPU/u1wZHkQT2qzG8RLIq6yfWqXDKz0PxO5eW8Bc
         7biV6kvV/je6QDGF3TiTfz08koIb3jla4Z5H/kW9QILQB1ZCx+Fj0Hyq2nMGCRowMS5f
         dVWNWIawojPta7L9UJ6fs8YenWlEvmAgSX9HrzBwYa7mpoKCQENXjCVHctzjw9TzHU3V
         omJg==
X-Gm-Message-State: AOAM530OkTsKSdYQm0ki/C8NBL33IHbMai+4SYRTN6ZSJnYktN92Q/Re
        iGqOq1p4iBvAckjCiM/70xY=
X-Google-Smtp-Source: ABdhPJym/jbGQNmx1SvtqQBRSFf2Qj2m2dXDi4nVQwP+FAv+zQRFXu9Ux6dF6hMUE55+/1NAokC+Pg==
X-Received: by 2002:a37:58c7:: with SMTP id m190mr25495224qkb.265.1595295713290;
        Mon, 20 Jul 2020 18:41:53 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id i66sm907693qke.124.2020.07.20.18.41.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2020 18:41:52 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id D9BF527C0058;
        Mon, 20 Jul 2020 21:41:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 20 Jul 2020 21:41:51 -0400
X-ME-Sender: <xms:30cWX9b_m0BjguJfvZ8ImFxPOf-DrPVLdikDUiyf24NDYvC4T9xQ3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeehgdegjecutefuodetggdotefrodftvf
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
X-ME-Proxy: <xmx:30cWX0ZOhF-ZUchQWaCL_AlTaJDvFfRsHpDF4a89Cn3yk0UxHLHrjw>
    <xmx:30cWX_-PkF3O62FHCIPr_2vuKYfJxEZaOiZpJkYle0d2pqmTC-QJGA>
    <xmx:30cWX7rV490yUE6i-wMByRiwQjutAftJVWBvzQjtY3QfTZiKMMMJaw>
    <xmx:30cWXzCK_wXZWP2UXpCiet23XXfsm4lMO9HRigK9k3xNNYlGfNIncybYbF4>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 557E33280060;
        Mon, 20 Jul 2020 21:41:51 -0400 (EDT)
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
Subject: [RFC 01/11] Drivers: hv: vmbus: Always use HV_HYP_PAGE_SIZE for gpadl
Date:   Tue, 21 Jul 2020 09:41:25 +0800
Message-Id: <20200721014135.84140-2-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200721014135.84140-1-boqun.feng@gmail.com>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the hypervisor always uses 4K as its page size, the size of PFNs
used for gpadl should be HV_HYP_PAGE_SIZE rather than PAGE_SIZE, so
adjust this accordingly as the preparation for supporting 16K/64K page
size guests.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 drivers/hv/channel.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 23f358cb7f49..b4378d9ae6ca 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -21,9 +21,6 @@
 
 #include "hyperv_vmbus.h"
 
-#define NUM_PAGES_SPANNED(addr, len) \
-((PAGE_ALIGN(addr + len) >> PAGE_SHIFT) - (addr >> PAGE_SHIFT))
-
 static unsigned long virt_to_hvpfn(void *addr)
 {
 	phys_addr_t paddr;
@@ -34,7 +31,7 @@ static unsigned long virt_to_hvpfn(void *addr)
 	else
 		paddr = __pa(addr);
 
-	return  paddr >> PAGE_SHIFT;
+	return  paddr >> HV_HYP_PAGE_SHIFT;
 }
 
 /*
@@ -305,7 +302,7 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 
 	int pfnsum, pfncount, pfnleft, pfncurr, pfnsize;
 
-	pagecount = size >> PAGE_SHIFT;
+	pagecount = size >> HV_HYP_PAGE_SHIFT;
 
 	/* do we need a gpadl body msg */
 	pfnsize = MAX_SIZE_CHANNEL_MESSAGE -
@@ -335,7 +332,7 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 		gpadl_header->range[0].byte_count = size;
 		for (i = 0; i < pfncount; i++)
 			gpadl_header->range[0].pfn_array[i] = virt_to_hvpfn(
-				kbuffer + PAGE_SIZE * i);
+				kbuffer + HV_HYP_PAGE_SIZE * i);
 		*msginfo = msgheader;
 
 		pfnsum = pfncount;
@@ -387,7 +384,7 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 			 */
 			for (i = 0; i < pfncurr; i++)
 				gpadl_body->pfn[i] = virt_to_hvpfn(
-					kbuffer + PAGE_SIZE * (pfnsum + i));
+					kbuffer + HV_HYP_PAGE_SIZE * (pfnsum + i));
 
 			/* add to msg header */
 			list_add_tail(&msgbody->msglistentry,
@@ -416,7 +413,7 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 		gpadl_header->range[0].byte_count = size;
 		for (i = 0; i < pagecount; i++)
 			gpadl_header->range[0].pfn_array[i] = virt_to_hvpfn(
-				kbuffer + PAGE_SIZE * i);
+				kbuffer + HV_HYP_PAGE_SIZE * i);
 
 		*msginfo = msgheader;
 	}
-- 
2.27.0

