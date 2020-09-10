Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1052F26520E
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgIJVHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731113AbgIJOfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:35:19 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143E3C06179F;
        Thu, 10 Sep 2020 07:35:13 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id z22so9051642ejl.7;
        Thu, 10 Sep 2020 07:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rv+IdoUkAEBqoHBWMCn0IzZT/rDL6zhCou8PWvAWWEM=;
        b=dKqwbaXmCPyyCmlsvIO5mGMqRyDyPp/ww5q1IjJrHG8/gJ2XPhcLEdzfjMV+e6w+g1
         bqRdxIvsywXvnfnIX5q+WlriOHHar8YfLGcOojW9O/VvOWm5cFjpseHKfxVTNZJzX8oX
         45RupwX83QKyU99/K/QnKDwc+34kuxIP+IAoHdOl+gYvIdMe6DMMrhH239wCSrsvn+pY
         r01Qt42kIXi04tihn4H0ZKXf74bqv7pPO9IAzZM8+nOmRE7sKvp1mc8P3yAlZEMvvQ83
         itINNSaDtvccKCdSHdXLlvfwmymR9RBMWOmJ5d8ovXk5l/O31IOqFXcxG81gkn/W3doT
         Vwbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rv+IdoUkAEBqoHBWMCn0IzZT/rDL6zhCou8PWvAWWEM=;
        b=HdnHxNj4LlMEoF4FValpkD+9MK/SA5gMFof9Ene5QoYs50AWL6e6mdo7Iwng47MAdZ
         T/tHQ2MnbrpSCSghGbY5+PgH8z+fOq7a7wPEXFDbNhQY5o0ytxXe2NT8EmX6JwrdKs6R
         qMOR8GmWCfGG3cIX0oXlwU0BohcemZ7UGYJN1ddtMGjs1pxCm54N9Px1knIt132m5aCE
         NumAbD6zQmFkVcHR2s/G+ljOBBfi/tlr2FrF+m4eZAAXGt7bNiqHKKUlj5b0EIU6ouH3
         YVLc0JVg0az4XtzFKwm7V4e/dX/f2xvplAg5Dw/CGS+BJgDvJDTG1l88ITyA7gkwxpv2
         +RlQ==
X-Gm-Message-State: AOAM533n55hR+mKE5kU3l6U7gZP/F9XkaCqoQ7rWHfekhGVyxSaocvHN
        7YjBCSzBy0diIFt+s9ommao=
X-Google-Smtp-Source: ABdhPJwlDmIm2gVNI6Egk8haxzqGydPuKKWSNBUxjI30JmIeIeHb4TZUsg76bBOqNsFly0fzFdxq0g==
X-Received: by 2002:a17:906:abc5:: with SMTP id kq5mr8910184ejb.284.1599748511754;
        Thu, 10 Sep 2020 07:35:11 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id p17sm7124669ejw.125.2020.09.10.07.35.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 07:35:10 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id BD2DA27C00A2;
        Thu, 10 Sep 2020 10:35:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 10 Sep 2020 10:35:05 -0400
X-ME-Sender: <xms:mTlaX5kA2p0smO3-WuAjvP8qO6TgfQJvxpK8cUVgHMe52vYoOwjEGw>
    <xme:mTlaX03TXZWeFYh5uMhEk9I8IgT0OinDRfOyCQJTarnZVIxgCRONkH-pHuNFU5y7-
    tq55wJD7ScWn-Mlbg>
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
X-ME-Proxy: <xmx:mTlaX_p9Jm2aw0do70b-FDaOHWn5YEIyUW8O75nPPz12RK0NIZUrFQ>
    <xmx:mTlaX5mr7UEUdMh367LjStFx2_cgENfjAZDt3EKrlF7h93dre9gdzg>
    <xmx:mTlaX31KrbXDfsz1-T3hAT66Jn_00f0CkEJNNMw7dLIyHM37ckft8w>
    <xmx:mTlaX1lbgGZS3_aqCoENwChK1VAAwMQ_TtIDxelzGIoMtiSTuGN9BQhRMBg>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 02320328005D;
        Thu, 10 Sep 2020 10:35:05 -0400 (EDT)
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
Subject: [PATCH v3 02/11] Drivers: hv: vmbus: Move __vmbus_open()
Date:   Thu, 10 Sep 2020 22:34:46 +0800
Message-Id: <20200910143455.109293-3-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200910143455.109293-1-boqun.feng@gmail.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pure function movement, no functional changes. The move is made, because
in a later change, __vmbus_open() will rely on some static functions
afterwards, so we separate the move and the modification of
__vmbus_open() in two patches to make it easy to review.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Wei Liu <wei.liu@kernel.org>
---
 drivers/hv/channel.c | 309 ++++++++++++++++++++++---------------------
 1 file changed, 155 insertions(+), 154 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 4d0f8e5a88d6..1cbe8fc931fc 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -109,160 +109,6 @@ int vmbus_alloc_ring(struct vmbus_channel *newchannel,
 }
 EXPORT_SYMBOL_GPL(vmbus_alloc_ring);
 
-static int __vmbus_open(struct vmbus_channel *newchannel,
-		       void *userdata, u32 userdatalen,
-		       void (*onchannelcallback)(void *context), void *context)
-{
-	struct vmbus_channel_open_channel *open_msg;
-	struct vmbus_channel_msginfo *open_info = NULL;
-	struct page *page = newchannel->ringbuffer_page;
-	u32 send_pages, recv_pages;
-	unsigned long flags;
-	int err;
-
-	if (userdatalen > MAX_USER_DEFINED_BYTES)
-		return -EINVAL;
-
-	send_pages = newchannel->ringbuffer_send_offset;
-	recv_pages = newchannel->ringbuffer_pagecount - send_pages;
-
-	if (newchannel->state != CHANNEL_OPEN_STATE)
-		return -EINVAL;
-
-	newchannel->state = CHANNEL_OPENING_STATE;
-	newchannel->onchannel_callback = onchannelcallback;
-	newchannel->channel_callback_context = context;
-
-	err = hv_ringbuffer_init(&newchannel->outbound, page, send_pages);
-	if (err)
-		goto error_clean_ring;
-
-	err = hv_ringbuffer_init(&newchannel->inbound,
-				 &page[send_pages], recv_pages);
-	if (err)
-		goto error_clean_ring;
-
-	/* Establish the gpadl for the ring buffer */
-	newchannel->ringbuffer_gpadlhandle = 0;
-
-	err = vmbus_establish_gpadl(newchannel,
-				    page_address(newchannel->ringbuffer_page),
-				    (send_pages + recv_pages) << PAGE_SHIFT,
-				    &newchannel->ringbuffer_gpadlhandle);
-	if (err)
-		goto error_clean_ring;
-
-	/* Create and init the channel open message */
-	open_info = kmalloc(sizeof(*open_info) +
-			   sizeof(struct vmbus_channel_open_channel),
-			   GFP_KERNEL);
-	if (!open_info) {
-		err = -ENOMEM;
-		goto error_free_gpadl;
-	}
-
-	init_completion(&open_info->waitevent);
-	open_info->waiting_channel = newchannel;
-
-	open_msg = (struct vmbus_channel_open_channel *)open_info->msg;
-	open_msg->header.msgtype = CHANNELMSG_OPENCHANNEL;
-	open_msg->openid = newchannel->offermsg.child_relid;
-	open_msg->child_relid = newchannel->offermsg.child_relid;
-	open_msg->ringbuffer_gpadlhandle = newchannel->ringbuffer_gpadlhandle;
-	open_msg->downstream_ringbuffer_pageoffset = newchannel->ringbuffer_send_offset;
-	open_msg->target_vp = hv_cpu_number_to_vp_number(newchannel->target_cpu);
-
-	if (userdatalen)
-		memcpy(open_msg->userdata, userdata, userdatalen);
-
-	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
-	list_add_tail(&open_info->msglistentry,
-		      &vmbus_connection.chn_msg_list);
-	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
-
-	if (newchannel->rescind) {
-		err = -ENODEV;
-		goto error_free_info;
-	}
-
-	err = vmbus_post_msg(open_msg,
-			     sizeof(struct vmbus_channel_open_channel), true);
-
-	trace_vmbus_open(open_msg, err);
-
-	if (err != 0)
-		goto error_clean_msglist;
-
-	wait_for_completion(&open_info->waitevent);
-
-	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
-	list_del(&open_info->msglistentry);
-	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
-
-	if (newchannel->rescind) {
-		err = -ENODEV;
-		goto error_free_info;
-	}
-
-	if (open_info->response.open_result.status) {
-		err = -EAGAIN;
-		goto error_free_info;
-	}
-
-	newchannel->state = CHANNEL_OPENED_STATE;
-	kfree(open_info);
-	return 0;
-
-error_clean_msglist:
-	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
-	list_del(&open_info->msglistentry);
-	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
-error_free_info:
-	kfree(open_info);
-error_free_gpadl:
-	vmbus_teardown_gpadl(newchannel, newchannel->ringbuffer_gpadlhandle);
-	newchannel->ringbuffer_gpadlhandle = 0;
-error_clean_ring:
-	hv_ringbuffer_cleanup(&newchannel->outbound);
-	hv_ringbuffer_cleanup(&newchannel->inbound);
-	newchannel->state = CHANNEL_OPEN_STATE;
-	return err;
-}
-
-/*
- * vmbus_connect_ring - Open the channel but reuse ring buffer
- */
-int vmbus_connect_ring(struct vmbus_channel *newchannel,
-		       void (*onchannelcallback)(void *context), void *context)
-{
-	return  __vmbus_open(newchannel, NULL, 0, onchannelcallback, context);
-}
-EXPORT_SYMBOL_GPL(vmbus_connect_ring);
-
-/*
- * vmbus_open - Open the specified channel.
- */
-int vmbus_open(struct vmbus_channel *newchannel,
-	       u32 send_ringbuffer_size, u32 recv_ringbuffer_size,
-	       void *userdata, u32 userdatalen,
-	       void (*onchannelcallback)(void *context), void *context)
-{
-	int err;
-
-	err = vmbus_alloc_ring(newchannel, send_ringbuffer_size,
-			       recv_ringbuffer_size);
-	if (err)
-		return err;
-
-	err = __vmbus_open(newchannel, userdata, userdatalen,
-			   onchannelcallback, context);
-	if (err)
-		vmbus_free_ring(newchannel);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(vmbus_open);
-
 /* Used for Hyper-V Socket: a guest client's connect() to the host */
 int vmbus_send_tl_connect_request(const guid_t *shv_guest_servie_id,
 				  const guid_t *shv_host_servie_id)
@@ -556,6 +402,161 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 }
 EXPORT_SYMBOL_GPL(vmbus_establish_gpadl);
 
+static int __vmbus_open(struct vmbus_channel *newchannel,
+		       void *userdata, u32 userdatalen,
+		       void (*onchannelcallback)(void *context), void *context)
+{
+	struct vmbus_channel_open_channel *open_msg;
+	struct vmbus_channel_msginfo *open_info = NULL;
+	struct page *page = newchannel->ringbuffer_page;
+	u32 send_pages, recv_pages;
+	unsigned long flags;
+	int err;
+
+	if (userdatalen > MAX_USER_DEFINED_BYTES)
+		return -EINVAL;
+
+	send_pages = newchannel->ringbuffer_send_offset;
+	recv_pages = newchannel->ringbuffer_pagecount - send_pages;
+
+	if (newchannel->state != CHANNEL_OPEN_STATE)
+		return -EINVAL;
+
+	newchannel->state = CHANNEL_OPENING_STATE;
+	newchannel->onchannel_callback = onchannelcallback;
+	newchannel->channel_callback_context = context;
+
+	err = hv_ringbuffer_init(&newchannel->outbound, page, send_pages);
+	if (err)
+		goto error_clean_ring;
+
+	err = hv_ringbuffer_init(&newchannel->inbound,
+				 &page[send_pages], recv_pages);
+	if (err)
+		goto error_clean_ring;
+
+	/* Establish the gpadl for the ring buffer */
+	newchannel->ringbuffer_gpadlhandle = 0;
+
+	err = vmbus_establish_gpadl(newchannel,
+				    page_address(newchannel->ringbuffer_page),
+				    (send_pages + recv_pages) << PAGE_SHIFT,
+				    &newchannel->ringbuffer_gpadlhandle);
+	if (err)
+		goto error_clean_ring;
+
+	/* Create and init the channel open message */
+	open_info = kmalloc(sizeof(*open_info) +
+			   sizeof(struct vmbus_channel_open_channel),
+			   GFP_KERNEL);
+	if (!open_info) {
+		err = -ENOMEM;
+		goto error_free_gpadl;
+	}
+
+	init_completion(&open_info->waitevent);
+	open_info->waiting_channel = newchannel;
+
+	open_msg = (struct vmbus_channel_open_channel *)open_info->msg;
+	open_msg->header.msgtype = CHANNELMSG_OPENCHANNEL;
+	open_msg->openid = newchannel->offermsg.child_relid;
+	open_msg->child_relid = newchannel->offermsg.child_relid;
+	open_msg->ringbuffer_gpadlhandle = newchannel->ringbuffer_gpadlhandle;
+	open_msg->downstream_ringbuffer_pageoffset = newchannel->ringbuffer_send_offset;
+	open_msg->target_vp = hv_cpu_number_to_vp_number(newchannel->target_cpu);
+
+	if (userdatalen)
+		memcpy(open_msg->userdata, userdata, userdatalen);
+
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
+	list_add_tail(&open_info->msglistentry,
+		      &vmbus_connection.chn_msg_list);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
+
+	if (newchannel->rescind) {
+		err = -ENODEV;
+		goto error_free_info;
+	}
+
+	err = vmbus_post_msg(open_msg,
+			     sizeof(struct vmbus_channel_open_channel), true);
+
+	trace_vmbus_open(open_msg, err);
+
+	if (err != 0)
+		goto error_clean_msglist;
+
+	wait_for_completion(&open_info->waitevent);
+
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
+	list_del(&open_info->msglistentry);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
+
+	if (newchannel->rescind) {
+		err = -ENODEV;
+		goto error_free_info;
+	}
+
+	if (open_info->response.open_result.status) {
+		err = -EAGAIN;
+		goto error_free_info;
+	}
+
+	newchannel->state = CHANNEL_OPENED_STATE;
+	kfree(open_info);
+	return 0;
+
+error_clean_msglist:
+	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
+	list_del(&open_info->msglistentry);
+	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
+error_free_info:
+	kfree(open_info);
+error_free_gpadl:
+	vmbus_teardown_gpadl(newchannel, newchannel->ringbuffer_gpadlhandle);
+	newchannel->ringbuffer_gpadlhandle = 0;
+error_clean_ring:
+	hv_ringbuffer_cleanup(&newchannel->outbound);
+	hv_ringbuffer_cleanup(&newchannel->inbound);
+	newchannel->state = CHANNEL_OPEN_STATE;
+	return err;
+}
+
+/*
+ * vmbus_connect_ring - Open the channel but reuse ring buffer
+ */
+int vmbus_connect_ring(struct vmbus_channel *newchannel,
+		       void (*onchannelcallback)(void *context), void *context)
+{
+	return  __vmbus_open(newchannel, NULL, 0, onchannelcallback, context);
+}
+EXPORT_SYMBOL_GPL(vmbus_connect_ring);
+
+/*
+ * vmbus_open - Open the specified channel.
+ */
+int vmbus_open(struct vmbus_channel *newchannel,
+	       u32 send_ringbuffer_size, u32 recv_ringbuffer_size,
+	       void *userdata, u32 userdatalen,
+	       void (*onchannelcallback)(void *context), void *context)
+{
+	int err;
+
+	err = vmbus_alloc_ring(newchannel, send_ringbuffer_size,
+			       recv_ringbuffer_size);
+	if (err)
+		return err;
+
+	err = __vmbus_open(newchannel, userdata, userdatalen,
+			   onchannelcallback, context);
+	if (err)
+		vmbus_free_ring(newchannel);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(vmbus_open);
+
+
 /*
  * vmbus_teardown_gpadl -Teardown the specified GPADL handle
  */
-- 
2.28.0

