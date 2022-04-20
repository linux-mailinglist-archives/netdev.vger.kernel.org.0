Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A0750912C
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 22:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382062AbiDTUKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 16:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382044AbiDTUKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 16:10:40 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1087E4667A;
        Wed, 20 Apr 2022 13:07:47 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id g13so5799403ejb.4;
        Wed, 20 Apr 2022 13:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uX50zrEMcunrp6nLIwZJ5dpGlndEZgBupE5oS9UHVBw=;
        b=aSGzqeRdozxRjHTlADzcwmPwGfL+rDDtfxZI+Tm38J/JsfArG7yiFPH+6TKTf3gYkN
         oEZPjIGwEddLFEzFZ4vWsRdgBwizMZJ/rcLx+3pDsc0udmBBI3/fPc8YL1kQaRQsjIs+
         YfDn+mHsEcJvkz8SZ0PWRCJ9VCgzM0jAR92j0lNOIE3zNVxMPiFlq9brmK8u0b/3gy6o
         XwHWYqpMm/cYBN0Jw25au5dW7V/i1KcyS4ZA8rVRBW+KywG08GyBPCc6hi3+5YZwI1qt
         gyh3f+u0TJMNWJB3vXHCuQhaDweEMPLPmM6OKLf5jr/ttWEEvs10xf/vq/deCJQfXJlW
         8r8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uX50zrEMcunrp6nLIwZJ5dpGlndEZgBupE5oS9UHVBw=;
        b=lXdfy4OBhdjrOtHr7hiTLA3OEbmLGm6IPhmods9wcAe8bHDuNIb2Yo2x3oWKv7baIe
         +Cj7OYfSW8Z6mToftA3buZHJzcCQafU4KXFl4V9YAyEiDfsk7XqRskI9j4bgW9DCl3O/
         WwzRDNHtMwDHAN70BVNgRonpSC9zI7EwwqJasOU9S9xQ1wDedZi5szulDlv5dDQr9beN
         /w6a+M2ucb6o+zCR8f3YKlKpPbE9eVYNeJrahh1a3du1wvGhANbn8YordaabsOo9Detp
         rSxFxSa0AKZKXdR69emMaRkw3xfgadeW2lSPeEg3zQktlOvRHcuEj/Gnuw9weXU2Rq91
         0aEw==
X-Gm-Message-State: AOAM530HDgKrAKVi5aobGaRTs1D3WlPnzfsAUPGs0005sNLSoE7G68mB
        6Y5wYkPqFW7HB+qAGx8HaNM=
X-Google-Smtp-Source: ABdhPJz4tqa3SfnB+LvR0FE25Hb7iOYwxK7ciw+lS7083/dNExCdZYtRlKTqFEgGnFpnXTU5TkV/eg==
X-Received: by 2002:a17:906:b102:b0:6db:1487:e73 with SMTP id u2-20020a170906b10200b006db14870e73mr19190797ejy.474.1650485266406;
        Wed, 20 Apr 2022 13:07:46 -0700 (PDT)
Received: from anparri.mshome.net (host-82-53-3-95.retail.telecomitalia.it. [82.53.3.95])
        by smtp.gmail.com with ESMTPSA id gy10-20020a170906f24a00b006e894144707sm7126853ejb.53.2022.04.20.13.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 13:07:46 -0700 (PDT)
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
Subject: [PATCH 3/5] hv_sock: Add validation for untrusted Hyper-V values
Date:   Wed, 20 Apr 2022 22:07:18 +0200
Message-Id: <20220420200720.434717-4-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220420200720.434717-1-parri.andrea@gmail.com>
References: <20220420200720.434717-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

