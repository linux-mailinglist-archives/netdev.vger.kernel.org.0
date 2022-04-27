Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2CD51198F
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235448AbiD0NRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 09:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235419AbiD0NQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 09:16:53 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6151D0DC;
        Wed, 27 Apr 2022 06:13:03 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id gh6so3400328ejb.0;
        Wed, 27 Apr 2022 06:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BV46+vQdHjUsPKBuNlWyRW17/ky0cjIb28v45CzS+RE=;
        b=S9r+JxfQLC/J5UHIjWr24bDkmSFNP8zqkbNyTe1LV0XUGOjGVY1tLcg2a73DQEArKX
         o0GM7vKILd+lp3XWBB5m8YDYcIFeNOQMvuvfeQtKUQXkHFaDX0ELGVlIjnZ+XLV8VjFk
         SXGpUZTepdmZJtA4cT3wshsSShnJ4jI4jzHYL/ZolCNgdzHUy0VAsC2UQym3mmCpmS/r
         6VFu/Wl9uejWAYBFmF6AOAxg0ItrH/EoQqJh3u3040ckFA03amkP8YtRgwuVgpnm0N2i
         rvAYwU66fhsSaoS6oYWgZ/kkLvnEAdqqITi8jkVg3Aa884NdX4vJAPWZ4dxqCqIKpsa9
         nZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BV46+vQdHjUsPKBuNlWyRW17/ky0cjIb28v45CzS+RE=;
        b=s7SPRhldyamumpWGOQ5xA6TFkgUJJjq2rFNeaqzf+/lHEO3Fll+LJSqBZfqaWOMWRq
         6azaOTFXk/AU47QnOAU1HK4G2PIjWAfdQB40wpenNckMa4JRq6DanlgnyFB4ky0FioIS
         TN/PkyLH4MZwPtgSG2SwgEOlhkauSTrB/SFOs2aViOh2YD+bZr37bkTkhozbSk/1hSB6
         z1cBT1gMZmY2RC//n8V69PTZLrgyPvwZgEviikBknboll4grZjIc7L9Pfh7/nf7Rh7u1
         ygVgUeJah6KCfSAcPoRVdNEX8cZ1MSUVLS7A+2iUveZBhNd4e24UPVZKejqGF4OE+t1E
         ulwQ==
X-Gm-Message-State: AOAM533IIgbXjiwTe1gJ2hm+TGSUkAvETHBw+5P5PzBmUUJ20CuXPyLR
        fISz+nneg56ofGJqLzp4r9k=
X-Google-Smtp-Source: ABdhPJxFpqAbncfZ86T6BX1e8L9MWWFtyrt5mJFyXpjpe2CTLC5MxXV4R2lNbC3xsbigdEiY6cPD6g==
X-Received: by 2002:a17:906:4fd5:b0:6f3:d23f:9ac6 with SMTP id i21-20020a1709064fd500b006f3d23f9ac6mr1059161ejw.281.1651065181965;
        Wed, 27 Apr 2022 06:13:01 -0700 (PDT)
Received: from anparri.mshome.net (host-79-49-65-106.retail.telecomitalia.it. [79.49.65.106])
        by smtp.gmail.com with ESMTPSA id u6-20020a170906124600b006e843964f9asm6668987eja.55.2022.04.27.06.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 06:13:01 -0700 (PDT)
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
Subject: [PATCH v2 3/5] hv_sock: Add validation for untrusted Hyper-V values
Date:   Wed, 27 Apr 2022 15:12:23 +0200
Message-Id: <20220427131225.3785-4-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220427131225.3785-1-parri.andrea@gmail.com>
References: <20220427131225.3785-1-parri.andrea@gmail.com>
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
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
---
 include/linux/hyperv.h           |  5 +++++
 net/vmw_vsock/hyperv_transport.c | 10 ++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

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
index 8c37d07017fc4..fd98229e3db30 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -577,12 +577,18 @@ static bool hvs_dgram_allow(u32 cid, u32 port)
 static int hvs_update_recv_data(struct hvsock *hvs)
 {
 	struct hvs_recv_buf *recv_buf;
-	u32 payload_len;
+	u32 pkt_len, payload_len;
+
+	pkt_len = hv_pkt_len(hvs->recv_desc);
+
+	if (pkt_len < HVS_HEADER_LEN)
+		return -EIO;
 
 	recv_buf = (struct hvs_recv_buf *)(hvs->recv_desc + 1);
 	payload_len = recv_buf->hdr.data_size;
 
-	if (payload_len > HVS_MTU_SIZE)
+	if (payload_len > pkt_len - HVS_HEADER_LEN ||
+	    payload_len > HVS_MTU_SIZE)
 		return -EIO;
 
 	if (payload_len == 0)
-- 
2.25.1

