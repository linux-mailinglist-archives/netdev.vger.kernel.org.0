Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCFF511B71
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbiD0NQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 09:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235403AbiD0NQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 09:16:53 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE0D1B9EC1;
        Wed, 27 Apr 2022 06:13:01 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id y3so3279060ejo.12;
        Wed, 27 Apr 2022 06:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=feRZmTriChk9LBL2CZw68q6Bh30MLfmBC42Qb8yFmjU=;
        b=SYWBoXxi1xLr/KucqHPWangJazRAJ7ET2YauFpCLFlbHvQhMEKCz53MxvKrjLDNnLE
         PufNuUBB4uRPkOQy4Dru8ST9zmn8ySj3Cp8WCjaYm+G/fNMA0e6dVuUUBVmVJtL+yqWJ
         g+YSGfTn6VgxZOj72usDJVXLV8qks5tYTFH3yiFb2GJvsIxUhxNmw68VnAbUPVWv++zV
         t3mkfkZg8ZFqpuuNjNUSTlSl6fI4b9vB0i9E00BX470FjhxzcjevLNLxVZ9Jwyg0GUCt
         ShZMk/U2yGck90+Adc8SpyhDe/uwhjdQuxi9U5+jKdfNjTLYramOXENZQD2HuJHBcsaC
         Aj/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=feRZmTriChk9LBL2CZw68q6Bh30MLfmBC42Qb8yFmjU=;
        b=0cDrLKXTJGe1SGFok31VZnJ0fq00EqHbipk0Q7JdCXIkcDmSfV2ZR6QCJblNewaiaC
         5zIKeDCK33F5gg/ieqxCuYEEtDv1M+/joajxea8A3cYkMKueyycG//u5SL9reNzDZ5sg
         vp1nH5KlaAxsAudXQYqZ8nELla3qSr/MjfBFGhDYS3t08GVKiUJBOibW2HA/GfwNp/ZN
         WW+DejCeLv4zB7+taDR+t9DI1XxkdvrnM6n7V3avIWxmLp0Oq6ooS9/gS+GcHdPN2WHG
         NewzmfUEFJRlj1ljXUdSSVGUIlUucgC62xke2rsLgYtAzGOp3LxMBea54OAFjJUadxlr
         WhFA==
X-Gm-Message-State: AOAM530U63m0ww+BKR1MEkVTRHpUHG2EtVzcDVFFMpPkWtTI0KpxiFkb
        0MrRpizgCq/KHVIDpvjVLqw=
X-Google-Smtp-Source: ABdhPJxx2FmC1Fd2tZZ3AWQOcXVlwnVVKq8Sxd7WcUgj+7DKHqIr61U3ub6YKvSwqaRZvLvwkOexCg==
X-Received: by 2002:a17:907:2d25:b0:6f3:906a:bae3 with SMTP id gs37-20020a1709072d2500b006f3906abae3mr14807400ejc.210.1651065180032;
        Wed, 27 Apr 2022 06:13:00 -0700 (PDT)
Received: from anparri.mshome.net (host-79-49-65-106.retail.telecomitalia.it. [79.49.65.106])
        by smtp.gmail.com with ESMTPSA id u6-20020a170906124600b006e843964f9asm6668987eja.55.2022.04.27.06.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 06:12:59 -0700 (PDT)
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
Subject: [PATCH v2 2/5] hv_sock: Copy packets sent by Hyper-V out of the ring buffer
Date:   Wed, 27 Apr 2022 15:12:22 +0200
Message-Id: <20220427131225.3785-3-parri.andrea@gmail.com>
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

