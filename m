Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E0C500037
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 22:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238710AbiDMUuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 16:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236542AbiDMUu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 16:50:27 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF0F6BDFD;
        Wed, 13 Apr 2022 13:48:05 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id c6so3878660edn.8;
        Wed, 13 Apr 2022 13:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uX50zrEMcunrp6nLIwZJ5dpGlndEZgBupE5oS9UHVBw=;
        b=TWL9gpNoJEn+V3lGRa+0fR4At7GciihC0gb78RaA0RoWmfVHi1tXmtW7DcBqBe9yqq
         2SPKbI4tntfHK1tyGMLHSLJ9NUROyqCAqhElxEB0yaPxLgIIFiX2wYSau4QvlQ6RONXB
         ak8Z3+Wzuh7XnctzCH/+a8XI9SnGfTbXK9Y7KLZ5sgw7MNRQnq6Gnqag8Y3vkGajf39r
         PG6QavaDM9GuvYU583HpozI7yM9CRr9/bobeXKdnzs8cS/v0PB9XjDZ3lVa45VCIkj8j
         NQoKQrDYbxhldh7E016l71JTlH4p1VVvvARJMcxDniOFRu9t1ojZnrL2TWEI3asYszM7
         DJdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uX50zrEMcunrp6nLIwZJ5dpGlndEZgBupE5oS9UHVBw=;
        b=JDpIXmdvklZaqpLJsTSKxZ561cx1mRhqUiwT2yaRgFIbUpLOAIRmGIvLMbZKhiZCoH
         lCPVdKcaaAimdFQjkTbohtDmyDIa/XcOLaWMr9aLfVgc8rZnSLMPvr9bJGRDwuEyNL3z
         CU42YO5aZhQVgviXLd09UX7+YVH9LZ/tX3L0i5WqIf7PcGhlxZafN+iXF1OVdJCeGkQr
         cH/wJe6TCNhjjQzW/iGbJT6AYkZLEtd1ibbpTZl6QjxPZFxgdpIp9sKNE14sFcShup9H
         oLeGlPSkJLTcN4fhgyF0CoxaBM9cUzp2WOIHUqs9pt6GXG6PaaevFPfZUduKV3FGfwCp
         FGdA==
X-Gm-Message-State: AOAM531WduXZzYFVTaQoIrovyKiRKb2C08MVZL9OSYsL/ZQOBIOGVDRS
        eXM7xYU1ZL+vplZGhS9FXnQ=
X-Google-Smtp-Source: ABdhPJySzy/JUA65EoxoFNi6q8hH2CXbLx6rEKSP9cs/VZa0h3yJrQW+MvpCp6+9if/E6dpx2eMtCg==
X-Received: by 2002:a05:6402:d62:b0:41d:79e6:1617 with SMTP id ec34-20020a0564020d6200b0041d79e61617mr18485763edb.378.1649882883512;
        Wed, 13 Apr 2022 13:48:03 -0700 (PDT)
Received: from anparri.mshome.net (host-79-52-64-69.retail.telecomitalia.it. [79.52.64.69])
        by smtp.gmail.com with ESMTPSA id u6-20020a170906408600b006e87d654270sm5021ejj.44.2022.04.13.13.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 13:48:02 -0700 (PDT)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
Subject: [RFC PATCH 3/6] hv_sock: Add validation for untrusted Hyper-V values
Date:   Wed, 13 Apr 2022 22:47:39 +0200
Message-Id: <20220413204742.5539-4-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413204742.5539-1-parri.andrea@gmail.com>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For additional robustness in the face of Hyper-V errors or malicious
behavior, validate all values that originate from packets that Hyper-V
has sent to the guest in the host-to-guest ring buffer.  Ensure that
invalid values cannot cause data being copied out of the bounds of the
source buffer in hvs_stream_dequeue().

Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
---
 include/linux/hyperv.h           |  5 +++++
 net/vmw_vsock/hyperv_transport.c | 11 +++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index fe2e0179ed51e..55478a6810b60 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1663,6 +1663,11 @@ static inline u32 hv_pkt_datalen(const struct vmpacket_descriptor *desc)
 	return (desc->len8 << 3) - (desc->offset8 << 3);
 }
 
+/* Get packet length associated with descriptor */
+static inline u32 hv_pkt_len(const struct vmpacket_descriptor *desc)
+{
+	return desc->len8 << 3;
+}
 
 struct vmpacket_descriptor *
 hv_pkt_iter_first_raw(struct vmbus_channel *channel);
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 8c37d07017fc4..092cadc2c866d 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -577,12 +577,19 @@ static bool hvs_dgram_allow(u32 cid, u32 port)
 static int hvs_update_recv_data(struct hvsock *hvs)
 {
 	struct hvs_recv_buf *recv_buf;
-	u32 payload_len;
+	u32 pkt_len, payload_len;
+
+	pkt_len = hv_pkt_len(hvs->recv_desc);
+
+	/* Ensure the packet is big enough to read its header */
+	if (pkt_len < HVS_HEADER_LEN)
+		return -EIO;
 
 	recv_buf = (struct hvs_recv_buf *)(hvs->recv_desc + 1);
 	payload_len = recv_buf->hdr.data_size;
 
-	if (payload_len > HVS_MTU_SIZE)
+	/* Ensure the packet is big enough to read its payload */
+	if (payload_len > pkt_len - HVS_HEADER_LEN || payload_len > HVS_MTU_SIZE)
 		return -EIO;
 
 	if (payload_len == 0)
-- 
2.25.1

