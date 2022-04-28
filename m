Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E56F513757
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235963AbiD1Oyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235947AbiD1Oyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:54:47 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561775C76D;
        Thu, 28 Apr 2022 07:51:31 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id y3so10016867ejo.12;
        Thu, 28 Apr 2022 07:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xnoykz5SfHywGsuFJryTcQ62jy0T4q8fF6j2ty0MvCU=;
        b=huCiHGgumyOnAt2uMrgxcQyx9XZheJ3jb/h+VzM0kr0EfYqyP4IiiWYnEiFIkzDSeU
         4eAghBKsEp8QPDSD5jC8Uri3YrHM008eG2IyPZtP/r5ZIm/PFB+XCC1m9ONELiAsF/qZ
         df4fCvvtWrDpy+W2+N1dqx6eiuI5L/H//J2rxjvwrF6m5+Sbt+6eomz/oBtjncxRsVJY
         s3ss2Wes+oh4YDihCnCp+T/UaA9f4//CPyeoN1XzFRRLjqn6B+bE1cy6Aqit0MF/gBsV
         p0I1thKEpdOsfar58FA41hzWxkUNt6fsBKZ9hInVSKdlN6N50DPnWF0FJJQCmy7U0E61
         Yhxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xnoykz5SfHywGsuFJryTcQ62jy0T4q8fF6j2ty0MvCU=;
        b=tqGjG+tJIrn/7QRQyiZpUXXeqpiEJ6zSExJSIgu2tZD+jjZfTRIRdauBi+ZPXIC79J
         9bIAge7Vbf+WONGFZ/LP5Qazz1FJayg5WN6JCkhgU0SfI3Zv28h8WpxpIfLZjjYeapTq
         HDMezHXAa06BfviqVhVys+arsjx4Dv4kFuNeV5z/cAr62KlNBv80OQXuUalo+kfvSLPI
         VAASn9N4S1WnY4VXjYM4ioks4RClgpRTe05l6WM1aU73/V6zDe7antG7KchXwSNVqhvy
         J5/jZrZowKzwyzS5QNwQesnCoAG2vXROrtNZYgGiGexeRuSoqDY5E4txkmWIrUscTgBg
         a9+Q==
X-Gm-Message-State: AOAM532ENbFjKUC4ZAHARPszYD5cYANDNYo/kozOEauvBwC+tvmUfwTo
        ckCRbxq/LRaR5tIEXQ8b44k=
X-Google-Smtp-Source: ABdhPJwuEZqtU95uxdJubkh8VZ+ZIfDWFNbLbnFkksVAEGmQd/oiVGp5cHf6ZPaBQEHlR2+beDb5+g==
X-Received: by 2002:a17:907:1c8d:b0:6f2:eb2:1cd6 with SMTP id nb13-20020a1709071c8d00b006f20eb21cd6mr24177811ejc.568.1651157489831;
        Thu, 28 Apr 2022 07:51:29 -0700 (PDT)
Received: from anparri.mshome.net (host-79-49-65-106.retail.telecomitalia.it. [79.49.65.106])
        by smtp.gmail.com with ESMTPSA id x18-20020a170906b09200b006e8baac3a09sm61616ejy.157.2022.04.28.07.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 07:51:29 -0700 (PDT)
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
Subject: [PATCH hyperv-next v2 2/5] hv_sock: Copy packets sent by Hyper-V out of the ring buffer
Date:   Thu, 28 Apr 2022 16:51:04 +0200
Message-Id: <20220428145107.7878-3-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220428145107.7878-1-parri.andrea@gmail.com>
References: <20220428145107.7878-1-parri.andrea@gmail.com>
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

Pointers to VMbus packets sent by Hyper-V are used by the hv_sock driver
within the guest VM.  Hyper-V can send packets with erroneous values or
modify packet fields after they are processed by the guest.  To defend
against these scenarios, copy the incoming packet after validating its
length and offset fields using hv_pkt_iter_{first,next}().  Use
HVS_PKT_LEN(HVS_MTU_SIZE) to initialize the buffer which holds the
copies of the incoming packets.  In this way, the packet can no longer
be modified by the host.

Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/hyperv_transport.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 943352530936e..8c37d07017fc4 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -78,6 +78,9 @@ struct hvs_send_buf {
 					 ALIGN((payload_len), 8) + \
 					 VMBUS_PKT_TRAILER_SIZE)
 
+/* Upper bound on the size of a VMbus packet for hv_sock */
+#define HVS_MAX_PKT_SIZE	HVS_PKT_LEN(HVS_MTU_SIZE)
+
 union hvs_service_id {
 	guid_t	srv_id;
 
@@ -378,6 +381,8 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 		rcvbuf = ALIGN(rcvbuf, HV_HYP_PAGE_SIZE);
 	}
 
+	chan->max_pkt_size = HVS_MAX_PKT_SIZE;
+
 	ret = vmbus_open(chan, sndbuf, rcvbuf, NULL, 0, hvs_channel_cb,
 			 conn_from_host ? new : sk);
 	if (ret != 0) {
@@ -602,7 +607,7 @@ static ssize_t hvs_stream_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
 		return -EOPNOTSUPP;
 
 	if (need_refill) {
-		hvs->recv_desc = hv_pkt_iter_first_raw(hvs->chan);
+		hvs->recv_desc = hv_pkt_iter_first(hvs->chan);
 		if (!hvs->recv_desc)
 			return -ENOBUFS;
 		ret = hvs_update_recv_data(hvs);
@@ -618,7 +623,7 @@ static ssize_t hvs_stream_dequeue(struct vsock_sock *vsk, struct msghdr *msg,
 
 	hvs->recv_data_len -= to_read;
 	if (hvs->recv_data_len == 0) {
-		hvs->recv_desc = hv_pkt_iter_next_raw(hvs->chan, hvs->recv_desc);
+		hvs->recv_desc = hv_pkt_iter_next(hvs->chan, hvs->recv_desc);
 		if (hvs->recv_desc) {
 			ret = hvs_update_recv_data(hvs);
 			if (ret)
-- 
2.25.1

