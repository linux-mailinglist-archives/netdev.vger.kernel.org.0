Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DFA2274EF
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725862AbgGUBnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727887AbgGUBl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:41:58 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB022C061794;
        Mon, 20 Jul 2020 18:41:57 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id k18so17845609qke.4;
        Mon, 20 Jul 2020 18:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HY+E+TM7TjxW7ncYvIrO2nDEmMyZmCVQH76K+JFM838=;
        b=AZKEGCFubzLlWatrtSLoe+smcNOMNDK2G4lpi5T6P70OthCQ/GQhfHElNhWfXBlRvV
         /K9gx0fTGkzjJS5OOmIheO1/VPNU5//HpxRL1qhQqwtVVpP/jQ/PhirFlFe7AmiXSG3i
         iimWDYR2XdhLfa4v2zzAT4WqOqjGXp8NI35Vtx94nqTMYB5J+VDznQtmhqI+Bjodm/95
         SqJYKHk/NPNw83JwsULM3y/Ar7tmTgt4DYyhy6ti5MzrgJZythH3ng2+Od7y4IpvfuCu
         w3KsBtfps/pu7zj6O9ogNKkbQ5mhAeGvM137Y3PT3K33BA7kDRbrwGKr4Vck8B4lgv8z
         RBIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HY+E+TM7TjxW7ncYvIrO2nDEmMyZmCVQH76K+JFM838=;
        b=mzQ12+zGzbxxcBez+j1Z2I1dNHQjTP78h9O92LlIVIBk9kCFx6VF55+kAUTRhE58fR
         0GHFNLmG/RQ/IfY1ZJ8H7n40tjFnC4nBTVVVzLgya8PUd0BU9E5tJix/SgkR4nDZeqDf
         hdZGcRhhYHUpbCmX4qdlNk+1KOI+xIucKyRNwoPsOAP+FqwBgqwb4fdohWQd68DtaNK6
         AeC/edZKdNM29KeS7b9RuMSIoT5r5/g3FMCxfyK9DEtxJrDLJDZyvgIb+n4Ln0OrCxt0
         5WLx/QpXFrU6ObueNcqsMLwvk9dn7vQq/MewOheyDa5paRflhPBah16Dy03eKDVv3mY3
         nZoA==
X-Gm-Message-State: AOAM533tj6m/owRfVZ+4vXuxRlx3JYS6FktCff7Vc0+9IlpRp/nUNVRV
        mpjv4yWurzMsFdarbE84cYY=
X-Google-Smtp-Source: ABdhPJwhDWyJ+Asl8C8b7YramHl94ycYaLBEzmfViq3FZT/VPI3j4LjbByT8sxVl3H6uw145u0kENQ==
X-Received: by 2002:a37:8286:: with SMTP id e128mr24655894qkd.101.1595295717068;
        Mon, 20 Jul 2020 18:41:57 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id x23sm1139923qki.6.2020.07.20.18.41.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2020 18:41:56 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 9366127C0054;
        Mon, 20 Jul 2020 21:41:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 20 Jul 2020 21:41:55 -0400
X-ME-Sender: <xms:40cWX9hQkVSjkPGqP8jpFHq0Uh05DElZ_KNqoxuIqv7TLFXvkpTvaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeehgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuohhrthgvugftvggtihhpvdculdegtddmnecujfgurhephffvufffkffojghfggfgsedt
    keertdertddtnecuhfhrohhmpeeuohhquhhnucfhvghnghcuoegsohhquhhnrdhfvghngh
    esghhmrghilhdrtghomheqnecuggftrfgrthhtvghrnhephedvveetfefgiedutedtfeev
    vddvleekjeeuffffleeguefhhfejteekieeuueelnecukfhppeehvddrudehhedrudduud
    drjedunecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhep
    sghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtie
    egqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhi
    gihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:40cWXyCYl6_M_P6h3IBem34cWu6OKOwVErBUUM1ae3oQBKMJ0LJHSg>
    <xmx:40cWX9HdGOvYzZI2oZeqI7OoVjTOdFmMHRyZU_0o4MDK6Tqd3Cn6KA>
    <xmx:40cWXySkb3DwLOVK34R1wwYUYIAsfy4Q6wEXl86MB_rHokskq39lZw>
    <xmx:40cWX_KN61TJ8Gd8AkCeviPxt8kl4Nbqa53JoNK3CqiqsDrU_1WdF2-s2M8>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0ED243280065;
        Mon, 20 Jul 2020 21:41:54 -0400 (EDT)
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
Subject: [RFC 03/11] Drivers: hv: vmbus: Introduce types of GPADL
Date:   Tue, 21 Jul 2020 09:41:27 +0800
Message-Id: <20200721014135.84140-4-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200721014135.84140-1-boqun.feng@gmail.com>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces two types of GPADL: HV_GPADL_{BUFFER, RING}. The
types of GPADL are purely the concept in the guest, IOW the hypervisor
treat them as the same.

The reason of introducing the types of GPADL is to support guests whose
page size is not 4k (the page size of Hyper-V hypervisor). In these
guests, both the headers and the data parts of the ringbuffers need to
be aligned to the PAGE_SIZE, because 1) some of the ringbuffers will be
mapped into userspace and 2) we use "double mapping" mechanism to
support fast wrap-around, and "double mapping" relies on ringbuffers
being page-aligned. However, the Hyper-V hypervisor only uses 4k
(HV_HYP_PAGE_SIZE) headers. Our solution to this is that we always make
the headers of ringbuffers take one guest page and when GPADL is
established between the guest and hypervisor, the only first 4k of
header is used. To handle this special case, we need the types of GPADL
to differ different guest memory usage for GPADL.

Type enum is introduced along with several general interfaces to
describe the differences between normal buffer GPADL and ringbuffer
GPADL.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 drivers/hv/channel.c   | 140 +++++++++++++++++++++++++++++++++++------
 include/linux/hyperv.h |  44 ++++++++++++-
 2 files changed, 164 insertions(+), 20 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 3d9d5d2c7fd1..13e98ac2a00f 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -34,6 +34,75 @@ static unsigned long virt_to_hvpfn(void *addr)
 	return  paddr >> HV_HYP_PAGE_SHIFT;
 }
 
+/*
+ * hv_gpadl_size - Return the real size of a gpadl, the size that Hyper-V uses
+ *
+ * For BUFFER gpadl, Hyper-V uses the exact same size as the guest does.
+ *
+ * For RING gpadl, in each ring, the guest uses one PAGE_SIZE as the header
+ * (because of the alignment requirement), however, the hypervisor only
+ * uses the first HV_HYP_PAGE_SIZE as the header, therefore leaving a
+ * (PAGE_SIZE - HV_HYP_PAGE_SIZE) gap. And since there are two rings in a
+ * ringbuffer, So the total size for a RING gpadl that Hyper-V uses is the
+ * total size that the guest uses minus twice of the gap size.
+ */
+static inline u32 hv_gpadl_size(enum hv_gpadl_type type, u32 size)
+{
+	switch (type) {
+	case HV_GPADL_BUFFER:
+		return size;
+	case HV_GPADL_RING:
+		/* The size of a ringbuffer must be page-aligned */
+		BUG_ON(size % PAGE_SIZE);
+		/*
+		 * Two things to notice here:
+		 * 1) We're processing two ring buffers as a unit
+		 * 2) We're skipping any space larger than HV_HYP_PAGE_SIZE in
+		 * the first guest-size page of each of the two ring buffers.
+		 * So we effectively subtract out two guest-size pages, and add
+		 * back two Hyper-V size pages.
+		 */
+		return size - 2 * (PAGE_SIZE - HV_HYP_PAGE_SIZE);
+	}
+	BUG();
+	return 0;
+}
+
+/*
+ * hv_gpadl_hvpfn - Return the Hyper-V page PFN of the @i th Hyper-V page in
+ *                  the gpadl
+ *
+ * @type: the type of the gpadl
+ * @kbuffer: the pointer to the gpadl in the guest
+ * @size: the total size (in bytes) of the gpadl
+ * @send_offset: the offset (in bytes) where the send ringbuffer starts
+ * @i: the index
+ */
+static inline u64 hv_gpadl_hvpfn(enum hv_gpadl_type type, void *kbuffer,
+				 u32 size, u32 send_offset, int i)
+{
+	int send_idx = (send_offset - (PAGE_SIZE - HV_HYP_PAGE_SIZE)) >> HV_HYP_PAGE_SHIFT;
+	unsigned long delta = 0UL;
+
+	switch (type) {
+	case HV_GPADL_BUFFER:
+		break;
+	case HV_GPADL_RING:
+		if (i == 0)
+			delta = 0;
+		else if (i <= send_idx)
+			delta = PAGE_SIZE - HV_HYP_PAGE_SIZE;
+		else
+			delta = 2 * (PAGE_SIZE - HV_HYP_PAGE_SIZE);
+		break;
+	default:
+		BUG();
+		break;
+	}
+
+	return virt_to_hvpfn(kbuffer + delta + (HV_HYP_PAGE_SIZE * i));
+}
+
 /*
  * vmbus_setevent- Trigger an event notification on the specified
  * channel.
@@ -131,7 +200,8 @@ EXPORT_SYMBOL_GPL(vmbus_send_tl_connect_request);
 /*
  * create_gpadl_header - Creates a gpadl for the specified buffer
  */
-static int create_gpadl_header(void *kbuffer, u32 size,
+static int create_gpadl_header(enum hv_gpadl_type type, void *kbuffer,
+			       u32 size, u32 send_offset,
 			       struct vmbus_channel_msginfo **msginfo)
 {
 	int i;
@@ -144,7 +214,7 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 
 	int pfnsum, pfncount, pfnleft, pfncurr, pfnsize;
 
-	pagecount = size >> HV_HYP_PAGE_SHIFT;
+	pagecount = hv_gpadl_size(type, size) >> HV_HYP_PAGE_SHIFT;
 
 	/* do we need a gpadl body msg */
 	pfnsize = MAX_SIZE_CHANNEL_MESSAGE -
@@ -171,10 +241,10 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 		gpadl_header->range_buflen = sizeof(struct gpa_range) +
 					 pagecount * sizeof(u64);
 		gpadl_header->range[0].byte_offset = 0;
-		gpadl_header->range[0].byte_count = size;
+		gpadl_header->range[0].byte_count = hv_gpadl_size(type, size);
 		for (i = 0; i < pfncount; i++)
-			gpadl_header->range[0].pfn_array[i] = virt_to_hvpfn(
-				kbuffer + HV_HYP_PAGE_SIZE * i);
+			gpadl_header->range[0].pfn_array[i] = hv_gpadl_hvpfn(
+				type, kbuffer, size, send_offset, i);
 		*msginfo = msgheader;
 
 		pfnsum = pfncount;
@@ -225,8 +295,8 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 			 * so the hypervisor guarantees that this is ok.
 			 */
 			for (i = 0; i < pfncurr; i++)
-				gpadl_body->pfn[i] = virt_to_hvpfn(
-					kbuffer + HV_HYP_PAGE_SIZE * (pfnsum + i));
+				gpadl_body->pfn[i] = hv_gpadl_hvpfn(type,
+					kbuffer, size, send_offset, pfnsum + i);
 
 			/* add to msg header */
 			list_add_tail(&msgbody->msglistentry,
@@ -252,10 +322,10 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 		gpadl_header->range_buflen = sizeof(struct gpa_range) +
 					 pagecount * sizeof(u64);
 		gpadl_header->range[0].byte_offset = 0;
-		gpadl_header->range[0].byte_count = size;
+		gpadl_header->range[0].byte_count = hv_gpadl_size(type, size);
 		for (i = 0; i < pagecount; i++)
-			gpadl_header->range[0].pfn_array[i] = virt_to_hvpfn(
-				kbuffer + HV_HYP_PAGE_SIZE * i);
+			gpadl_header->range[0].pfn_array[i] = hv_gpadl_hvpfn(
+				type, kbuffer, size, send_offset, i);
 
 		*msginfo = msgheader;
 	}
@@ -268,15 +338,20 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 }
 
 /*
- * vmbus_establish_gpadl - Establish a GPADL for the specified buffer
+ * __vmbus_establish_gpadl - Establish a GPADL for a buffer or ringbuffer
  *
  * @channel: a channel
+ * @type: the type of the corresponding GPADL, only meaningful for the guest.
  * @kbuffer: from kmalloc or vmalloc
  * @size: page-size multiple
+ * @send_offset: the offset (in bytes) where the send ring buffer starts,
+ * 		 should be 0 for BUFFER type gpadl
  * @gpadl_handle: some funky thing
  */
-int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
-			       u32 size, u32 *gpadl_handle)
+static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
+				   enum hv_gpadl_type type, void *kbuffer,
+				   u32 size, u32 send_offset,
+				   u32 *gpadl_handle)
 {
 	struct vmbus_channel_gpadl_header *gpadlmsg;
 	struct vmbus_channel_gpadl_body *gpadl_body;
@@ -290,7 +365,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	next_gpadl_handle =
 		(atomic_inc_return(&vmbus_connection.next_gpadl_handle) - 1);
 
-	ret = create_gpadl_header(kbuffer, size, &msginfo);
+	ret = create_gpadl_header(type, kbuffer, size, send_offset, &msginfo);
 	if (ret)
 		return ret;
 
@@ -371,6 +446,21 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	kfree(msginfo);
 	return ret;
 }
+
+/*
+ * vmbus_establish_gpadl - Establish a GPADL for the specified buffer
+ *
+ * @channel: a channel
+ * @kbuffer: from kmalloc or vmalloc
+ * @size: page-size multiple
+ * @gpadl_handle: some funky thing
+ */
+int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
+			  u32 size, u32 *gpadl_handle)
+{
+	return __vmbus_establish_gpadl(channel, HV_GPADL_BUFFER, kbuffer, size,
+				       0U, gpadl_handle);
+}
 EXPORT_SYMBOL_GPL(vmbus_establish_gpadl);
 
 static int __vmbus_open(struct vmbus_channel *newchannel,
@@ -413,10 +503,11 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 	/* Establish the gpadl for the ring buffer */
 	newchannel->ringbuffer_gpadlhandle = 0;
 
-	err = vmbus_establish_gpadl(newchannel,
-				    page_address(newchannel->ringbuffer_page),
-				    (send_pages + recv_pages) << PAGE_SHIFT,
-				    &newchannel->ringbuffer_gpadlhandle);
+	err = __vmbus_establish_gpadl(newchannel, HV_GPADL_RING,
+				      page_address(newchannel->ringbuffer_page),
+				      (send_pages + recv_pages) << PAGE_SHIFT,
+				      newchannel->ringbuffer_send_offset << PAGE_SHIFT,
+				      &newchannel->ringbuffer_gpadlhandle);
 	if (err)
 		goto error_clean_ring;
 
@@ -437,7 +528,17 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 	open_msg->openid = newchannel->offermsg.child_relid;
 	open_msg->child_relid = newchannel->offermsg.child_relid;
 	open_msg->ringbuffer_gpadlhandle = newchannel->ringbuffer_gpadlhandle;
-	open_msg->downstream_ringbuffer_pageoffset = newchannel->ringbuffer_send_offset;
+	/*
+	 * The unit of ->downstream_ringbuffer_pageoffset is HV_HYP_PAGE and
+	 * the unit of ->ringbuffer_send_offset is PAGE, so here we first
+	 * calculate it into bytes and then convert into HV_HYP_PAGE. Also
+	 * ->ringbuffer_send_offset is the offset in guest, while
+	 * ->downstream_ringbuffer_pageoffset is the offset in gpadl (i.e. in
+	 * hypervisor), so a (PAGE_SIZE - HV_HYP_PAGE_SIZE) gap need to be
+	 * skipped.
+	 */
+	open_msg->downstream_ringbuffer_pageoffset =
+		((newchannel->ringbuffer_send_offset << PAGE_SHIFT) - (PAGE_SIZE - HV_HYP_PAGE_SIZE)) >> HV_HYP_PAGE_SHIFT;
 	open_msg->target_vp = newchannel->target_vp;
 
 	if (userdatalen)
@@ -497,6 +598,7 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 	return err;
 }
 
+
 /*
  * vmbus_connect_ring - Open the channel but reuse ring buffer
  */
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 692c89ccf5df..663f0a016237 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -29,6 +29,48 @@
 
 #pragma pack(push, 1)
 
+/*
+ * Types for GPADL, decides is how GPADL header is created.
+ *
+ * It doesn't make much difference between BUFFER and RING if PAGE_SIZE is the
+ * same as HV_HYP_PAGE_SIZE.
+ *
+ * If PAGE_SIZE is bigger than HV_HYP_PAGE_SIZE, the headers of ring buffers
+ * will be of PAGE_SIZE, however, only the first HV_HYP_PAGE will be put
+ * into gpadl, therefore the number for HV_HYP_PAGE and the indexes of each
+ * HV_HYP_PAGE will be different between different types of GPADL, for example
+ * if PAGE_SIZE is 64K:
+ *
+ * BUFFER:
+ *
+ * gva:    |--       64k      --|--       64k      --| ... |
+ * gpa:    | 4k | 4k | ... | 4k | 4k | 4k | ... | 4k |
+ * index:  0    1    2     15   16   17   18 .. 31   32 ...
+ *         |    |    ...   |    |    |   ...    |   ...
+ *         v    V          V    V    V          V
+ * gpadl:  | 4k | 4k | ... | 4k | 4k | 4k | ... | 4k | ... |
+ * index:  0    1    2 ... 15   16   17   18 .. 31   32 ...
+ *
+ * RING:
+ *
+ *         | header  |           data           | header  |     data      |
+ * gva:    |-- 64k --|--       64k      --| ... |-- 64k --|-- 64k --| ... |
+ * gpa:    | 4k | .. | 4k | 4k | ... | 4k | ... | 4k | .. | 4k | .. | ... |
+ * index:  0    1    16   17   18    31   ...   n   n+1  n+16 ...         2n
+ *         |         /    /          /          |         /               /
+ *         |        /    /          /           |        /               /
+ *         |       /    /   ...    /    ...     |       /      ...      /
+ *         |      /    /          /             |      /               /
+ *         |     /    /          /              |     /               /
+ *         V    V    V          V               V    V               v
+ * gpadl:  | 4k | 4k |   ...    |    ...        | 4k | 4k |  ...     |
+ * index:  0    1    2   ...    16   ...       n-15 n-14 n-13  ...  2n-30
+ */
+enum hv_gpadl_type {
+	HV_GPADL_BUFFER,
+	HV_GPADL_RING
+};
+
 /* Single-page buffer */
 struct hv_page_buffer {
 	u32 len;
@@ -111,7 +153,7 @@ struct hv_ring_buffer {
 	} feature_bits;
 
 	/* Pad it to PAGE_SIZE so that data starts on page boundary */
-	u8	reserved2[4028];
+	u8	reserved2[PAGE_SIZE - 68];
 
 	/*
 	 * Ring data starts here + RingDataStartOffset
-- 
2.27.0

