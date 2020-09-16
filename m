Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91EF926BAE3
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 05:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgIPDs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 23:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgIPDsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 23:48:39 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EA0C06178A;
        Tue, 15 Sep 2020 20:48:38 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id w186so6857740qkd.1;
        Tue, 15 Sep 2020 20:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qJmwrh6J6rcv6MUxLlkxyb5Vql7vSYwyh7LH4D3LEqA=;
        b=fb3GcBMEZSWYsUqGLTS3YELiN72LoJZrDv/xB5k5ae8B5Edp+As0kxRPsWkE59ifE0
         T1pXpeuPEcA2BkroyONSPsf7Jqm+18RPcFL7W17TaJoxp8UUo4Nu0SR0Q3IikXHpzPHW
         78VtSUe76C38o3LLkbrfC4+KKOpt1wgKWdomHJWVU++f2x3z3PWdSCWnZGMg1NLKL7zL
         ArPEFqNPHeoUfsJVVQAi+B91J7/4ukvS1ILwpqOy7oKIGzyimC3jycmcl0E/sCjik9pJ
         7HPzqA1VaX8SXIeUdlqPVxOPM50Ou4c4uHTmCyNO5U7CAcW41MMqXi3R+OTKSavYXPma
         OXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qJmwrh6J6rcv6MUxLlkxyb5Vql7vSYwyh7LH4D3LEqA=;
        b=r3xl/1Sjc1VPczl6yQk2XDBViZFf2YWtMnW+c89HUZjG8uq1i4qqh7L31b3p7mI2yW
         2OLVtFhXlHtINgwmxB48bGEUO/4U6u0oCKOohwP+w2WU0FMPPHiRgpkuhrvoWlI1d4aq
         sUHTsrbRVa79hMEEmueBn4TSiYaoH1l0m8ryy7kfIeWmbgVnc0ZYst9gxeu35KKnWnhG
         fSBgzPzO7SL6ksdWBCZc4XBU7qI8c3d9ZAXiGt4Aoxkhg37GFO1KRFMUhL8EHPpjTEPA
         qCPJlyRgIoCJKtoGKp43oOr84p3Huv3kOYmo9zQ910tA0ZEROsZuo6YxmV8tHpKe+P6+
         VFbQ==
X-Gm-Message-State: AOAM530vxgeIafD1zJKAsaYIrysZpcMGtYMP5B/LtOXXzmkE8LOYwfm3
        eHuUvozKqpBrdX7uKlBJJtE=
X-Google-Smtp-Source: ABdhPJycut6cyDGtJLlufHlc1Ibn9u3uJPexpQn/Oghzfa2pp0pOauiHQuvt950r/uE/krCH3GIxYg==
X-Received: by 2002:a05:620a:1098:: with SMTP id g24mr20706113qkk.399.1600228117531;
        Tue, 15 Sep 2020 20:48:37 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id x124sm18735736qkd.72.2020.09.15.20.48.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2020 20:48:36 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id F250F27C0054;
        Tue, 15 Sep 2020 23:48:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 15 Sep 2020 23:48:35 -0400
X-ME-Sender: <xms:E4thX1q39EHukdQWgdetzkZs-cHP8Vpw70nzwfMBgaVjvCQ_IqKtzA>
    <xme:E4thX3oJ20zI_9I-0BFESi_NNYUje3uHbVPMUuil57ivbBUnVMP7WqByJc7hx-or8
    MVkVJ3L1EWuT8HEng>
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
X-ME-Proxy: <xmx:E4thXyP9ngPwai6HX8PumjTgDyiFNmfdoh87EQDgGy_z5855OVjhHA>
    <xmx:E4thXw6mRl2g4EfVKPA32hF-fFeGp9mfHyNQjWCZhT0owhFPPPjo0Q>
    <xmx:E4thX04McaVaLyiJztQwQUvl4SMkOhktmEtvzrGpW5IDBjlP7aSoEA>
    <xmx:E4thX5qG6qgCtS5g8NUTXBClfYmZCS7J1AzmKk4Hi_suiX3T4-qSXKqQqBQ>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3A286306467E;
        Tue, 15 Sep 2020 23:48:35 -0400 (EDT)
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
Subject: [PATCH v4 07/11] hv_netvsc: Use HV_HYP_PAGE_SIZE for Hyper-V communication
Date:   Wed, 16 Sep 2020 11:48:13 +0800
Message-Id: <20200916034817.30282-8-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916034817.30282-1-boqun.feng@gmail.com>
References: <20200916034817.30282-1-boqun.feng@gmail.com>
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
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
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

