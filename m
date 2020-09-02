Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1015C25A38F
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 05:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgIBDB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 23:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbgIBDBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 23:01:35 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA041C061245;
        Tue,  1 Sep 2020 20:01:33 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id w186so3115295qkd.1;
        Tue, 01 Sep 2020 20:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xtjU5XT/jYJgv6uirBliL97PLE7EMPgM1E8fOJ4UGbQ=;
        b=ocoSIb4AHC/atxnaHoL1ld5dv+avh64gar0skQjppbtM0UumeX/OD6DxTC1EwEbtc2
         cO4k/VS3IT0EdHCEzN6Zaobkuz+nsAL894oqSFQxmFCwqEXSRV9R1xbngJZlZqQg8WNV
         56/cd0IzVDNKIbCsruQccVaOkTvzOaZZJqTh4ZVhofiQNh4gwepOrG9lbl7QVZ8TZL+6
         TP2a0J2XmXTcTxJBDXPpHzQQs6xc609P+CsTkVroqjPiIXVEvYY7RVG7vh1uynjQ8o+q
         KSTlnENObk3zff6SNTyqSY4GiEZEDcndqElAhA1alfIUDPVqqSjYz2mE1SQRBPmDdS5U
         mpCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xtjU5XT/jYJgv6uirBliL97PLE7EMPgM1E8fOJ4UGbQ=;
        b=PCjE3L5p19ux+3KlWWzeobMiwKxZtTx+b9XOYF9UmS4do5AKFGLD8ZBRZqrVmzY32o
         khz0+mZGsrbmG52xe9h2PAFgNX52VFl5eSslOWI3A7nYJrUwP46akLLJoFfZZ/Uu8TPc
         pqoExeoflai25Z1aKm8ZzpPjqLhlcH1oaTchHczRttHk8e7NnodtKeRMnnqV0q9WN6Ae
         jk1u8yV60G0idNTbZTreCozyf2Ft/UsUOXx0Mtp/0zVPollGCzGixuzlpi4Eing0nh4s
         ojUQv4m/E7Z1ve1A2jHMJNpGjUhZEOBKGftfIfzduiNCDt0txA192DdDV6duidAsbWpj
         VEEQ==
X-Gm-Message-State: AOAM531rYlHEhIaGVki9OuM5cBacZK4HX5th1mhE4t71SB53QKUrrrAK
        IJnwJSHrQdOn4/uLD8QqcNY=
X-Google-Smtp-Source: ABdhPJxZyl0Q6j+q14Se51TKCFowAOZwzLZjtnPlq9fRVzkgtiJv2F2p4KHPt862iPIcdakLTS5SDg==
X-Received: by 2002:a37:4e8a:: with SMTP id c132mr4935124qkb.472.1599015693191;
        Tue, 01 Sep 2020 20:01:33 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id 192sm3377664qkm.110.2020.09.01.20.01.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 20:01:32 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 73E4A27C005A;
        Tue,  1 Sep 2020 23:01:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 01 Sep 2020 23:01:31 -0400
X-ME-Sender: <xms:CwtPX-ZwvseEVNAJsd28zIclmAThDWv9UrnD-mIW2QG8aRDg7cN8eA>
    <xme:CwtPXxbSgvV7dILVRikiTfWRcYC-VCrTTFz2kHJ2ulHleyXDXFueCPn_f7lpNbIr4
    US6YmHCzqTUwgmYeg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefkedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjughrpefhvffufffkofgjfhgggfes
    tdekredtredttdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnh
    hgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeehvdevteefgfeiudettdef
    vedvvdelkeejueffffelgeeuhffhjeetkeeiueeuleenucfkphephedvrdduheehrdduud
    durdejudenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhm
    pegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtd
    eigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehf
    ihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:CwtPX4-PG8n5DjEbCPGiXrLik2VCq-Jj3tDTh15cN_pfub2bZ1OEBg>
    <xmx:CwtPXwoGbgJmCBpoaepwEO5sKwojcKiU0EzZ3go-L8_C8tFk204oCA>
    <xmx:CwtPX5pSwVvdwZ17EUiJg9K2Xyg7krVrRFEJjp2qTYChpTJ4f8Tjzw>
    <xmx:CwtPXxZCrChMT_aKzewrGF-j7ImPOyKsfTB1egmbphKLEchQScp4shFOsJQ>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id E18503280059;
        Tue,  1 Sep 2020 23:01:30 -0400 (EDT)
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
Subject: [RFC v2 07/11] hv_netvsc: Use HV_HYP_PAGE_SIZE for Hyper-V communication
Date:   Wed,  2 Sep 2020 11:01:03 +0800
Message-Id: <20200902030107.33380-8-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200902030107.33380-1-boqun.feng@gmail.com>
References: <20200902030107.33380-1-boqun.feng@gmail.com>
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
 drivers/net/hyperv/rndis_filter.c | 12 ++++----
 3 files changed, 30 insertions(+), 30 deletions(-)

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
index b81ceba38218..acc8d957bbfc 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -25,7 +25,7 @@
 
 static void rndis_set_multicast(struct work_struct *w);
 
-#define RNDIS_EXT_LEN PAGE_SIZE
+#define RNDIS_EXT_LEN HV_HYP_PAGE_SIZE
 struct rndis_request {
 	struct list_head list_ent;
 	struct completion  wait_event;
@@ -215,18 +215,18 @@ static int rndis_filter_send_request(struct rndis_device *dev,
 	packet->page_buf_cnt = 1;
 
 	pb[0].pfn = virt_to_phys(&req->request_msg) >>
-					PAGE_SHIFT;
+					HV_HYP_PAGE_SHIFT;
 	pb[0].len = req->request_msg.msg_len;
 	pb[0].offset =
-		(unsigned long)&req->request_msg & (PAGE_SIZE - 1);
+		(unsigned long)&req->request_msg & (HV_HYP_PAGE_SIZE - 1);
 
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

