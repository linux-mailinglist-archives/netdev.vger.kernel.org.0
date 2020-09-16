Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1305026BAEF
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 05:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgIPDsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 23:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIPDse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 23:48:34 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F69C06178B;
        Tue, 15 Sep 2020 20:48:30 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id y11so5091588qtn.9;
        Tue, 15 Sep 2020 20:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=USSwhP09izf+LnpVrE3M0RxVw0+t66PHn4L0u3pS4fg=;
        b=s6J2vMTbEpPu4mSucLu8+qOtzIBZ+7Yjn9Z6S79lWp97w2jmedzB1aDMrrJdECYQKJ
         UHoM+AiefpYOOBINwCzSZU1RnAZmLl3trG4ry3HtnfdDz8C/aXR45CxGmcuXRd9fOH/h
         6RghjczkCs8ojcC18B8tl7qtbF4PVq7sruHBeEVeY+vXUmsBzN8EpSnfVO/AnWDxbTqW
         tdUP572KhYsjqEkkQewr9HMysWDvQqIESkzhHxSnOdhP5+3CDSJelHPSMebbVgsZvpsx
         DVafn54joVtksdZo2kW0lREmE09jc3soo/JwsHTRf9ADc6bf1gOtADhWYBtZxTo03gF8
         41tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=USSwhP09izf+LnpVrE3M0RxVw0+t66PHn4L0u3pS4fg=;
        b=FazYDn4toLu5wGewnrI+p+9qLpxyqRdjVVbqWyGezh3/KyAqAMUuRyHGbIRnjztPlT
         zr/u7gisVmUYKn3NtcmqwSgDa9jS+Ifl8NuzPzWWfQ7aWVcksFDTeNLl8VsnWmdeh3BZ
         XOWDU19v56y8rmjapiQqs8EJMnadUyz2qVYX88+SwsWTq67mv0dT1ap0rZTFdFZ9ysnM
         +eBRSjFaiIFdPwxhAZwIPPYBMoz6xcs6rhNWAcTAp8RBdhhr8G2J6cESGYwLvPuNDzXy
         kKx2tRc6mOuIHLfZ3VJHOAzEyqFFpRAXZLWy0gh/nriLwd/JVGfUdAQpGQNo3SzjFFrE
         4zTQ==
X-Gm-Message-State: AOAM531uBFL5Zbd13xf/0qefZmthBy9nICDIa75uJwfodQvrroeeQ52F
        nFSsiSgvnn0e+2BcV5SfHb4=
X-Google-Smtp-Source: ABdhPJyzejBWQEaC5mH5YVRjTYO3rhGjyzc3WikTI66JgJqlBUWHTc3iFLiPU3cw8FOMUWMmAOcD3A==
X-Received: by 2002:aed:39a1:: with SMTP id m30mr9021636qte.39.1600228109917;
        Tue, 15 Sep 2020 20:48:29 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id c193sm16805471qke.20.2020.09.15.20.48.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2020 20:48:29 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 4A6EF27C0058;
        Tue, 15 Sep 2020 23:48:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 15 Sep 2020 23:48:28 -0400
X-ME-Sender: <xms:DIthX3P0NO5BbehBjUZ2uSkgvGyZthZ8tA1IpuMoc3YlMPdoIJXjRA>
    <xme:DIthXx-DJVxpC_AKJolSUNMyk6jtzbTm1C9cE2TMLj8qrqxnVsiJ11jm6vrmfs8cU
    EWUQo1fTh4VFURNqw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugdeikecutefuodetggdotefrodftvf
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
X-ME-Proxy: <xmx:DIthX2QGu6mi5SrGFJPHO1Eh5QYJuIcvwm-ATsCw4yrdpWdWq_bc2w>
    <xmx:DIthX7v8ci2A72SgFhGWeTkEIqhqvmcWTjXOpA_kLZFjuP2sl1z-Yg>
    <xmx:DIthX_dhrQvi3dp3K60oeiGaHSw7d_7TIXrJngZi1NCSgPNsgVDA6w>
    <xmx:DIthXzNENMT1OAWiYFO_B3Qt7b_rxWKve0HSf_KjBreRPhLFUim5-oeZBNo>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 89B8C3064682;
        Tue, 15 Sep 2020 23:48:27 -0400 (EDT)
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
Subject: [PATCH v4 03/11] Drivers: hv: vmbus: Introduce types of GPADL
Date:   Wed, 16 Sep 2020 11:48:09 +0800
Message-Id: <20200916034817.30282-4-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916034817.30282-1-boqun.feng@gmail.com>
References: <20200916034817.30282-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces two types of GPADL: HV_GPADL_{BUFFER, RING}. The
types of GPADL are purely the concept in the guest, IOW the hypervisor
treat them as the same.

The reason of introducing the types for GPADL is to support guests whose
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
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
---
 drivers/hv/channel.c   | 160 +++++++++++++++++++++++++++++++++++------
 include/linux/hyperv.h |  48 ++++++++++++-
 2 files changed, 187 insertions(+), 21 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 1cbe8fc931fc..45267b6d069e 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -35,6 +35,99 @@ static unsigned long virt_to_hvpfn(void *addr)
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
+ * ringbuffer, the total size for a RING gpadl that Hyper-V uses is the
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
+ * hv_ring_gpadl_send_hvpgoffset - Calculate the send offset (in unit of
+ *                                 HV_HYP_PAGE) in a ring gpadl based on the
+ *                                 offset in the guest
+ *
+ * @offset: the offset (in bytes) where the send ringbuffer starts in the
+ *               virtual address space of the guest
+ */
+static inline u32 hv_ring_gpadl_send_hvpgoffset(u32 offset)
+{
+
+	/*
+	 * For RING gpadl, in each ring, the guest uses one PAGE_SIZE as the
+	 * header (because of the alignment requirement), however, the
+	 * hypervisor only uses the first HV_HYP_PAGE_SIZE as the header,
+	 * therefore leaving a (PAGE_SIZE - HV_HYP_PAGE_SIZE) gap.
+	 *
+	 * And to calculate the effective send offset in gpadl, we need to
+	 * substract this gap.
+	 */
+	return (offset - (PAGE_SIZE - HV_HYP_PAGE_SIZE)) >> HV_HYP_PAGE_SHIFT;
+}
+
+/*
+ * hv_gpadl_hvpfn - Return the Hyper-V page PFN of the @i th Hyper-V page in
+ *                  the gpadl
+ *
+ * @type: the type of the gpadl
+ * @kbuffer: the pointer to the gpadl in the guest
+ * @size: the total size (in bytes) of the gpadl
+ * @send_offset: the offset (in bytes) where the send ringbuffer starts in the
+ *               virtual address space of the guest
+ * @i: the index
+ */
+static inline u64 hv_gpadl_hvpfn(enum hv_gpadl_type type, void *kbuffer,
+				 u32 size, u32 send_offset, int i)
+{
+	int send_idx = hv_ring_gpadl_send_hvpgoffset(send_offset);
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
@@ -160,7 +253,8 @@ EXPORT_SYMBOL_GPL(vmbus_send_modifychannel);
 /*
  * create_gpadl_header - Creates a gpadl for the specified buffer
  */
-static int create_gpadl_header(void *kbuffer, u32 size,
+static int create_gpadl_header(enum hv_gpadl_type type, void *kbuffer,
+			       u32 size, u32 send_offset,
 			       struct vmbus_channel_msginfo **msginfo)
 {
 	int i;
@@ -173,7 +267,7 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 
 	int pfnsum, pfncount, pfnleft, pfncurr, pfnsize;
 
-	pagecount = size >> HV_HYP_PAGE_SHIFT;
+	pagecount = hv_gpadl_size(type, size) >> HV_HYP_PAGE_SHIFT;
 
 	/* do we need a gpadl body msg */
 	pfnsize = MAX_SIZE_CHANNEL_MESSAGE -
@@ -200,10 +294,10 @@ static int create_gpadl_header(void *kbuffer, u32 size,
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
@@ -254,8 +348,8 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 			 * so the hypervisor guarantees that this is ok.
 			 */
 			for (i = 0; i < pfncurr; i++)
-				gpadl_body->pfn[i] = virt_to_hvpfn(
-					kbuffer + HV_HYP_PAGE_SIZE * (pfnsum + i));
+				gpadl_body->pfn[i] = hv_gpadl_hvpfn(type,
+					kbuffer, size, send_offset, pfnsum + i);
 
 			/* add to msg header */
 			list_add_tail(&msgbody->msglistentry,
@@ -281,10 +375,10 @@ static int create_gpadl_header(void *kbuffer, u32 size,
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
@@ -297,15 +391,20 @@ static int create_gpadl_header(void *kbuffer, u32 size,
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
@@ -319,7 +418,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	next_gpadl_handle =
 		(atomic_inc_return(&vmbus_connection.next_gpadl_handle) - 1);
 
-	ret = create_gpadl_header(kbuffer, size, &msginfo);
+	ret = create_gpadl_header(type, kbuffer, size, send_offset, &msginfo);
 	if (ret)
 		return ret;
 
@@ -400,6 +499,21 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
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
@@ -438,10 +552,11 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
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
 
@@ -462,7 +577,13 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 	open_msg->openid = newchannel->offermsg.child_relid;
 	open_msg->child_relid = newchannel->offermsg.child_relid;
 	open_msg->ringbuffer_gpadlhandle = newchannel->ringbuffer_gpadlhandle;
-	open_msg->downstream_ringbuffer_pageoffset = newchannel->ringbuffer_send_offset;
+	/*
+	 * The unit of ->downstream_ringbuffer_pageoffset is HV_HYP_PAGE and
+	 * the unit of ->ringbuffer_send_offset (i.e. send_pages) is PAGE, so
+	 * here we calculate it into HV_HYP_PAGE.
+	 */
+	open_msg->downstream_ringbuffer_pageoffset =
+		hv_ring_gpadl_send_hvpgoffset(send_pages << PAGE_SHIFT);
 	open_msg->target_vp = hv_cpu_number_to_vp_number(newchannel->target_cpu);
 
 	if (userdatalen)
@@ -556,7 +677,6 @@ int vmbus_open(struct vmbus_channel *newchannel,
 }
 EXPORT_SYMBOL_GPL(vmbus_open);
 
-
 /*
  * vmbus_teardown_gpadl -Teardown the specified GPADL handle
  */
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 38100e80360a..9c19149c0e1a 100644
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
@@ -120,6 +162,10 @@ struct hv_ring_buffer {
 	u8 buffer[];
 } __packed;
 
+/* Calculate the proper size of a ringbuffer, it must be page-aligned */
+#define VMBUS_RING_SIZE(payload_sz) PAGE_ALIGN(sizeof(struct hv_ring_buffer) + \
+					       (payload_sz))
+
 struct hv_ring_buffer_info {
 	struct hv_ring_buffer *ring_buffer;
 	u32 ring_size;			/* Include the shared header */
-- 
2.28.0

