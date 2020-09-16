Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE37126BAF3
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 05:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgIPDst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 23:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgIPDse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 23:48:34 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C9CC06174A;
        Tue, 15 Sep 2020 20:48:29 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id k25so5135286qtu.4;
        Tue, 15 Sep 2020 20:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PJ9e6Lnx2tmGYFTXB18lW6Q/T2L4hGhgFpf65EdTl/E=;
        b=SyPh8HCfJQSDOnywtJxJmO6NaYLkNy6C55k2YGYIOxVGCi4s6BlgzE5jxpkNGR+LAk
         d3jeVlWLpdjG9e9YsHUdXSmlq4W9Xd+kyMeIF4R52efTr9n1Z3YFnQhvsQaCd6jfCgsr
         iQBPS915XsMh5D4SNTt7W/vWMOszkbjtd6nzLoQXECjLMuzh1ftv290OiuyQ2zfWglrL
         Ni/XAu34n1dJnLz2GDm9CdXREFCPQKudb81FEnxxYaAs7LE8lcKnNHFUVkPjrcvdc3Un
         KS77FNtkTWf96dvDvxrZ4zL33+i/F3eVBHye/FMRSkc9JXBNRUEXT1mwM51p5z7uzjAp
         JrcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PJ9e6Lnx2tmGYFTXB18lW6Q/T2L4hGhgFpf65EdTl/E=;
        b=j7RUEZSqLErpJy0wqDCZkx9GfHAorSQyk/jfqqgw5NVgBV5Z4z/vDb8wXqj4svqwt8
         JsWS+c1qNyoL/fmiutZC99V+i2kOzBqPvZqzJYowJs+ztyfkdI1bB0Vn+rLqjRhrDiQV
         EAP/lNmhJKohYuB3BcJIS+ZGdU8gSPIDCKCAA5BrcEp3dEn1vACtDANo6ybmNiPLgpWz
         uUYD7Qs6BK1KdEQKyaIEh32yQ2MsnOg+1jxndQG9aUq7QZtoNzqYG10BZAs0EKrNMXPE
         A3nkBcPR+P/Bvh+tKtQkEaM37OhC7+7EMWZq75PlVGOCmz9eKnHuYpVkWREiuKjp9H3a
         iisA==
X-Gm-Message-State: AOAM532I+3DlLd33SABB5C69dcfs0a3PuJLfmKNpSX+ZdWffWCyKnVp2
        EnREy3zvTg+97UJNKfu/3Zs=
X-Google-Smtp-Source: ABdhPJz819QUoub5h3GLv9XmGiNmrHIu5QktlrV3HvLFkdNq29L/DfxrUWUPIvMtSrPUxdTyO2/HPQ==
X-Received: by 2002:ac8:157:: with SMTP id f23mr21159633qtg.273.1600228108647;
        Tue, 15 Sep 2020 20:48:28 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id t43sm19160580qtc.54.2020.09.15.20.48.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2020 20:48:27 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 4E8A527C005A;
        Tue, 15 Sep 2020 23:48:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 15 Sep 2020 23:48:26 -0400
X-ME-Sender: <xms:CothX-PX1W2vpaHZP_bl5wz5929pVhgZSF7Zl8X6kYfbKxzDeNwrzw>
    <xme:CothX8_5PAs_4Dt_pN6px8o7kYGve0WyJqQBUovRIAM55FbuSPL-v4UgXHBsYVZtT
    4gkQYOpY6FkZcLNEA>
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
X-ME-Proxy: <xmx:CothX1SvmlVPwcP5uc_Gj673yFTLizZvlWrwlCtShI-cT4IibxOEWA>
    <xmx:CothX-uKtSoraeG15n3ajAqH0thovE0RBx4Pr8C2bebBfwXmKNHIxg>
    <xmx:CothX2cMA2F_cGjMkvA9nAvpR3_L3AFc7QRlxlpyXinwWHaqH5BxjQ>
    <xmx:CothX6Ofu5TcbttYtcp0KvsL5Bd4rFO0OJT1uA-rl16V3IMZx9bXuuZxXh8>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8D0AA3280059;
        Tue, 15 Sep 2020 23:48:25 -0400 (EDT)
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
Subject: [PATCH v4 02/11] Drivers: hv: vmbus: Move __vmbus_open()
Date:   Wed, 16 Sep 2020 11:48:08 +0800
Message-Id: <20200916034817.30282-3-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916034817.30282-1-boqun.feng@gmail.com>
References: <20200916034817.30282-1-boqun.feng@gmail.com>
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
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
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

