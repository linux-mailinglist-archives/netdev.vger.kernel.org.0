Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4AE72274BE
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgGUBmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgGUBmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:42:06 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B82C061794;
        Mon, 20 Jul 2020 18:42:05 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id a32so15027035qtb.5;
        Mon, 20 Jul 2020 18:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KeE6N42QVOFflOibpcdDK1ou1/XdkhybFgLqpKwjDd8=;
        b=PPbP9c7hmlSFSLnZMcCyTFidcd0UdOXZjrw8YWQgHyxzSrKli9sWk1PNpHm8AoAfda
         lGBOObE9XWbDE8FvR/SYhJTm37j59JQeAWvGAY02MiRYkvfklcp4FqOwu3lWY+69cbi0
         uuww8kQum4Uo3OKRdWyqeKbQ18nF1HTQ1I4Gb1Z4nGdbWfs6NKllZVnMufOEkq1lYbhS
         K5yY/nvFiA8EgnUiUxUnP0CSEPFVJNONgNjJQu/kFyyeiiZ3mrDLQ9r4LwX64M+4pjyb
         7m8oF7N1k2Ei8tdf+p3L6+eqWxJQBCJbDzBE9e7tjbCjPfG7OBf6r/2aJ+E2K69p+i41
         NKVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KeE6N42QVOFflOibpcdDK1ou1/XdkhybFgLqpKwjDd8=;
        b=MIrZ9BOr4bwaExDZaIez0vPw7+qG6NmU9Rr6kXUtiHiSr0UpChPk8n/1Z5Py7lCwaa
         UWX9skvJHjyhS6s4daTroYfidUUoBnVvGVUg5ZVJ5I1T2kCglnQV0UWYU1bC39q8wqbt
         94ocnS2HyaVE7GDowy4UkzOWuFYK6bN+eyCGg4HrBNV6xS2OejB1svZUpobXgVW+tkfA
         SQqsB+gZWmg1G3u0sKtjDBwnjWYk85kcZue/ak71AT5TjhfsPEMMzR0cyMeybZNICoue
         YJNm6pFePA2OEXMlsEcFcCE/MA4GWTYkF1q2t33j/boG9QGRrOF6nb7a7PwBXbzPu6Yx
         o3Zw==
X-Gm-Message-State: AOAM532lFiSeY36KQ4PZ+XRrVCYy5jqnx+MXI3sjF6di90Ch6CJ8E5SX
        Jb4NKN/696mpkmSLNZu+DQM=
X-Google-Smtp-Source: ABdhPJzfxlQ0NYJSu6FFJjMde6nsM3ePyeT9/Wfk1YXgmDWrI0l5TVAoxbipuRO1AWWaRuQInTxn7g==
X-Received: by 2002:ac8:6b04:: with SMTP id w4mr3439914qts.364.1595295725194;
        Mon, 20 Jul 2020 18:42:05 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id u20sm22307315qtj.39.2020.07.20.18.42.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2020 18:42:03 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 5A27427C0054;
        Mon, 20 Jul 2020 21:42:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 20 Jul 2020 21:42:03 -0400
X-ME-Sender: <xms:60cWXybedEyLYs3LOxTwHreW7mdo8bvIx4B2bWjEZOC8D2AuIUUvwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeehgdegjecutefuodetggdotefrodftvf
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
X-ME-Proxy: <xmx:60cWX1bWVpSsWAqO7jHn9cPS9kWhillnF0E6Y-mE9SOZzMS9Ypr9LA>
    <xmx:60cWX8_eMlAvonDln_CXKOkKthBDjSV91DB7yIrBFQvFKgW9tqFlBg>
    <xmx:60cWX0pEjgeuKsW6n6tRwYIdK_lzFLPr7DFav39fUTT9jzs5cGqWLA>
    <xmx:60cWX4CWnuvX9cDs4Uk6kVgA86JevxKjcjBswcBfB4BzBEwe4e8n9Bq66hM>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id C8B8430600A6;
        Mon, 20 Jul 2020 21:42:02 -0400 (EDT)
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
Subject: [RFC 07/11] hv_netvsc: Use HV_HYP_PAGE_SIZE for Hyper-V communication
Date:   Tue, 21 Jul 2020 09:41:31 +0800
Message-Id: <20200721014135.84140-8-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200721014135.84140-1-boqun.feng@gmail.com>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
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
index ca68aa1df801..02877b560e4d 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -791,7 +791,7 @@ static void netvsc_copy_to_send_buf(struct netvsc_device *net_device,
 	}
 
 	for (i = 0; i < page_count; i++) {
-		char *src = phys_to_virt(pb[i].pfn << PAGE_SHIFT);
+		char *src = phys_to_virt(pb[i].pfn << HV_HYP_PAGE_SHIFT);
 		u32 offset = pb[i].offset;
 		u32 len = pb[i].len;
 
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index ebcfbae05690..9d9cbaed5441 100644
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
2.27.0

