Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574C22651FD
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgIJVGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730988AbgIJOgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:36:08 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43774C0617A4;
        Thu, 10 Sep 2020 07:35:21 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id z22so9052275ejl.7;
        Thu, 10 Sep 2020 07:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o1Sl+9uuMxREmM+K2OMqTIchpX8+FnseIjhki4v5+3o=;
        b=JbokN9taeM5HKkcdr7fsWoutM4vC+zxluPBrBb9iiiacQ0WluxJIcr7w6lVfESNMnS
         T7MMEDGivB09ge8fKb5AjQCXw9Ica93xYYjhFRTHmLHmlp9YEgq8ngWJ+XafK0/Qnovl
         ca89DGMgARgqQjtLZYclQuOPfoKzsst/Dly2jAX1Wjcwe7zR7NIyJOR197tQJ/ceXzHr
         VTw6aTxktByygAkfphWQ5hlE/SzP7l3qJ1NIzR5cyM6aS2jeiiBM/D24yk/R1s5wz/c/
         nsWKOTIPOFOYKCHVE8GgDFERi64hdDIVWFqcqns3rrN9x92GSFCy0eGo79MTtQ94wbfx
         DYLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o1Sl+9uuMxREmM+K2OMqTIchpX8+FnseIjhki4v5+3o=;
        b=gaR6yd1ynMh3yVSt1Ihdk7WePBn3byfDtoiZM5BFsMbbJLJs0SGLpX2H5MdnksrwCG
         +ONJPb2/r94tn+w1r3msvMujBf2KxsWsrN+1C1Uwn3RQzLbWJprUo294UFVzlPaQ5Mvp
         Pf0G4PLfKS7SB/XY1hPbHbL6kxcZg3RfmFxcUhq1SgsiR7+aeYBJe4iewyOjunehUYJ1
         JbsauILyWXsZ13kOXJiP7Qxhkv4bkK7B86EMVnc+i5XxPNp23LW3KByb0gPLa0rL/C9n
         zQhwmd4rPc/Cc4sBqTgQhi1nqtC/cgOyaotRjeTKrXoR6Prw0qUOffEtA1ZtE0hWUrw7
         DMug==
X-Gm-Message-State: AOAM5312iWY3L3WMo9fKUkZW4JRa81RWRYV9lqjL+7jBkReAHxHKDMox
        DF2wJxcnvbJNdNv15aUcS7A=
X-Google-Smtp-Source: ABdhPJz2JkjAAY18FQ2QRF0MYrjWvtlWZTCjd8dvAjjvpoVblLdj491Ah77q7XuYVg3wtnWKLEtksg==
X-Received: by 2002:a17:906:2e14:: with SMTP id n20mr9454635eji.214.1599748519915;
        Thu, 10 Sep 2020 07:35:19 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id bn14sm7308235ejb.115.2020.09.10.07.35.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 07:35:18 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id AD50927C00A3;
        Thu, 10 Sep 2020 10:35:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 10 Sep 2020 10:35:15 -0400
X-ME-Sender: <xms:ozlaX7Qudw-MVsT43K5HPtzpbHClaazaO9hfZaySIiaCRU1oazOQSA>
    <xme:ozlaX8y2mhf34OP0opIrFAl0G0SrBMj_YBHoV2h88HjvME7O3FsJdOg5vkOZ6FMJQ
    5J5y51cFOD65vXmdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehjedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjughrpefhvffufffkofgjfhgggfes
    tdekredtredttdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnh
    hgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeehvdevteefgfeiudettdef
    vedvvdelkeejueffffelgeeuhffhjeetkeeiueeuleenucfkphephedvrdduheehrdduud
    durdejudenucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtd
    eigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehf
    ihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:ozlaXw11i3BgAeu_u6aZecAolKrt3ttlKOUhuVsz-ZHFd1ZK7dlhQg>
    <xmx:ozlaX7DwaanEKSVsd8GrIzYHqesmvyvge9ovq2NAgcLhf7rTDLuaRA>
    <xmx:ozlaX0hf3Q5UWSgxvumL5VDSCJEwJdWeoclUvwSDe8WhFGvx90TsIA>
    <xmx:ozlaX_SyTetU5fCoAAG3_4TuGlR2RPNDWSRZdy-BWqYSqt0XhyQuLbh4B3U>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id E91FA3280059;
        Thu, 10 Sep 2020 10:35:14 -0400 (EDT)
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
Subject: [PATCH v3 07/11] hv_netvsc: Use HV_HYP_PAGE_SIZE for Hyper-V communication
Date:   Thu, 10 Sep 2020 22:34:51 +0800
Message-Id: <20200910143455.109293-8-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200910143455.109293-1-boqun.feng@gmail.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When communicating with Hyper-V, HV_HYP_PAGE_SIZE should be used since
that's the page size used by Hyper-V and Hyper-V expects all
page-related data using the unit of HY_HYP_PAGE_SIZE, for example, the
"pfn" in hv_page_buffer is actually the HV_HYP_PAGE (i.e. the Hyper-V
page) number.

In order to support guest whose page size is not 4k, we need to make
hv_netvsc always use HV_HYP_PAGE_SIZE for Hyper-V communication.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 drivers/net/hyperv/netvsc.c       |  2 +-
 drivers/net/hyperv/netvsc_drv.c   | 46 +++++++++++++++----------------
 drivers/net/hyperv/rndis_filter.c | 13 ++++-----
 3 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 41f5cf0bb997..1d6f2256da6b 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -794,7 +794,7 @@ static void netvsc_copy_to_send_buf(struct netvsc_device *net_device,
 	}
 
 	for (i = 0; i < page_count; i++) {
-		char *src = phys_to_virt(pb[i].pfn << PAGE_SHIFT);
+		char *src = phys_to_virt(pb[i].pfn << HV_HYP_PAGE_SHIFT);
 		u32 offset = pb[i].offset;
 		u32 len = pb[i].len;
 
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 64b0a74c1523..61ea568e1ddf 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -373,32 +373,29 @@ static u16 netvsc_select_queue(struct net_device *ndev, struct sk_buff *skb,
 	return txq;
 }
 
-static u32 fill_pg_buf(struct page *page, u32 offset, u32 len,
+static u32 fill_pg_buf(unsigned long hvpfn, u32 offset, u32 len,
 		       struct hv_page_buffer *pb)
 {
 	int j = 0;
 
-	/* Deal with compound pages by ignoring unused part
-	 * of the page.
-	 */
-	page += (offset >> PAGE_SHIFT);
-	offset &= ~PAGE_MASK;
+	hvpfn += offset >> HV_HYP_PAGE_SHIFT;
+	offset = offset & ~HV_HYP_PAGE_MASK;
 
 	while (len > 0) {
 		unsigned long bytes;
 
-		bytes = PAGE_SIZE - offset;
+		bytes = HV_HYP_PAGE_SIZE - offset;
 		if (bytes > len)
 			bytes = len;
-		pb[j].pfn = page_to_pfn(page);
+		pb[j].pfn = hvpfn;
 		pb[j].offset = offset;
 		pb[j].len = bytes;
 
 		offset += bytes;
 		len -= bytes;
 
-		if (offset == PAGE_SIZE && len) {
-			page++;
+		if (offset == HV_HYP_PAGE_SIZE && len) {
+			hvpfn++;
 			offset = 0;
 			j++;
 		}
@@ -421,23 +418,26 @@ static u32 init_page_array(void *hdr, u32 len, struct sk_buff *skb,
 	 * 2. skb linear data
 	 * 3. skb fragment data
 	 */
-	slots_used += fill_pg_buf(virt_to_page(hdr),
-				  offset_in_page(hdr),
-				  len, &pb[slots_used]);
+	slots_used += fill_pg_buf(virt_to_hvpfn(hdr),
+				  offset_in_hvpage(hdr),
+				  len,
+				  &pb[slots_used]);
 
 	packet->rmsg_size = len;
 	packet->rmsg_pgcnt = slots_used;
 
-	slots_used += fill_pg_buf(virt_to_page(data),
-				offset_in_page(data),
-				skb_headlen(skb), &pb[slots_used]);
+	slots_used += fill_pg_buf(virt_to_hvpfn(data),
+				  offset_in_hvpage(data),
+				  skb_headlen(skb),
+				  &pb[slots_used]);
 
 	for (i = 0; i < frags; i++) {
 		skb_frag_t *frag = skb_shinfo(skb)->frags + i;
 
-		slots_used += fill_pg_buf(skb_frag_page(frag),
-					skb_frag_off(frag),
-					skb_frag_size(frag), &pb[slots_used]);
+		slots_used += fill_pg_buf(page_to_hvpfn(skb_frag_page(frag)),
+					  skb_frag_off(frag),
+					  skb_frag_size(frag),
+					  &pb[slots_used]);
 	}
 	return slots_used;
 }
@@ -453,8 +453,8 @@ static int count_skb_frag_slots(struct sk_buff *skb)
 		unsigned long offset = skb_frag_off(frag);
 
 		/* Skip unused frames from start of page */
-		offset &= ~PAGE_MASK;
-		pages += PFN_UP(offset + size);
+		offset &= ~HV_HYP_PAGE_MASK;
+		pages += HVPFN_UP(offset + size);
 	}
 	return pages;
 }
@@ -462,12 +462,12 @@ static int count_skb_frag_slots(struct sk_buff *skb)
 static int netvsc_get_slots(struct sk_buff *skb)
 {
 	char *data = skb->data;
-	unsigned int offset = offset_in_page(data);
+	unsigned int offset = offset_in_hvpage(data);
 	unsigned int len = skb_headlen(skb);
 	int slots;
 	int frag_slots;
 
-	slots = DIV_ROUND_UP(offset + len, PAGE_SIZE);
+	slots = DIV_ROUND_UP(offset + len, HV_HYP_PAGE_SIZE);
 	frag_slots = count_skb_frag_slots(skb);
 	return slots + frag_slots;
 }
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index b81ceba38218..1e2de8fb7fec 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -25,7 +25,7 @@
 
 static void rndis_set_multicast(struct work_struct *w);
 
-#define RNDIS_EXT_LEN PAGE_SIZE
+#define RNDIS_EXT_LEN HV_HYP_PAGE_SIZE
 struct rndis_request {
 	struct list_head list_ent;
 	struct completion  wait_event;
@@ -215,18 +215,17 @@ static int rndis_filter_send_request(struct rndis_device *dev,
 	packet->page_buf_cnt = 1;
 
 	pb[0].pfn = virt_to_phys(&req->request_msg) >>
-					PAGE_SHIFT;
+					HV_HYP_PAGE_SHIFT;
 	pb[0].len = req->request_msg.msg_len;
-	pb[0].offset =
-		(unsigned long)&req->request_msg & (PAGE_SIZE - 1);
+	pb[0].offset = offset_in_hvpage(&req->request_msg);
 
 	/* Add one page_buf when request_msg crossing page boundary */
-	if (pb[0].offset + pb[0].len > PAGE_SIZE) {
+	if (pb[0].offset + pb[0].len > HV_HYP_PAGE_SIZE) {
 		packet->page_buf_cnt++;
-		pb[0].len = PAGE_SIZE -
+		pb[0].len = HV_HYP_PAGE_SIZE -
 			pb[0].offset;
 		pb[1].pfn = virt_to_phys((void *)&req->request_msg
-			+ pb[0].len) >> PAGE_SHIFT;
+			+ pb[0].len) >> HV_HYP_PAGE_SHIFT;
 		pb[1].offset = 0;
 		pb[1].len = req->request_msg.msg_len -
 			pb[0].len;
-- 
2.28.0

