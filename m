Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED83350002B
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 22:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238112AbiDMUu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 16:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237733AbiDMUuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 16:50:25 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FFA6833E;
        Wed, 13 Apr 2022 13:48:02 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id ks6so6396270ejb.1;
        Wed, 13 Apr 2022 13:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0WClfb203Z7+sOEjY+pzv7SOHPdMw2tVtOYL5Bkvekc=;
        b=IXpwKWIHgJ7QrxvwE3OTVk6mKZmgIKBtApsiNbEpR3RrekkTW1Uu+Vy9NX5hFGuJ7H
         Cw4l9L6rKfda1hCdvprZzw1J0zFCHnbM/geMlbpp00GAWCGo8wDTr/saHZpXBKFmm579
         Da6w84pcIc+d3AuwmlApNRdkH6ux6FQA4sCVLlW45UvKe81VB5koovPH190kg3FxW5zw
         9XzAIzbXesRzCmkTc1rNsk2dV3h0+tLNPh/KrGjLX8qQ59vICgaTwf6wy3lj4DawTv3k
         B2bhA7MrFiG6UD3JiRlaroF063j/dXepRPRlg6IFNKV/0B5iAL0Oza2Lpm22zVwA8s94
         VT1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0WClfb203Z7+sOEjY+pzv7SOHPdMw2tVtOYL5Bkvekc=;
        b=uLSQuCJuOKJNxh8Uldp9qrdsC5+d5Wcv65RC8hEXDmnnZGUPhGEzo3NNsJBs8jiAsB
         3NiTRfvLjNuG0LbItweOPH6yhcQpIap4wzXsvpyauAvYacVpHFgVzSgY1Qn8fn1NiMNO
         L9wrS3Sn+RaRDNjgWMNkaOPL1TwZDvMq7xW1grXWKeIcbz8G+/CtVMe5D1J2usc3yqYM
         rvp4qgURPRwR+/hx+RTMgtLnlobXjRkQsMldHexkN1AIAf9X1RF8Kwf3SYk5pqpI5VX2
         KDhWZjuOnOEVmxiMPcg9R6j1o7UbIxdslK+IHmPiplfZnSw+4tMtu8H/AaZoZBZJpxoD
         uN1Q==
X-Gm-Message-State: AOAM531BfTzx3tjalLJ8VB4ne8E7nj84Ud52I8bPYGEzWffDNaFhnHeH
        wqCeNB54k9BkLOEbiXnkzD8=
X-Google-Smtp-Source: ABdhPJzhcXO4zZamZsgKX1Vpx1RWEUhhodALT7jl+k8BMClVpEQmXKtXkB5gsXKkyAz+XCgpjtPEdg==
X-Received: by 2002:a17:906:1604:b0:6e8:7c02:c5a with SMTP id m4-20020a170906160400b006e87c020c5amr17992636ejd.690.1649882881173;
        Wed, 13 Apr 2022 13:48:01 -0700 (PDT)
Received: from anparri.mshome.net (host-79-52-64-69.retail.telecomitalia.it. [79.52.64.69])
        by smtp.gmail.com with ESMTPSA id u6-20020a170906408600b006e87d654270sm5021ejj.44.2022.04.13.13.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 13:48:00 -0700 (PDT)
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
Subject: [RFC PATCH 2/6] hv_sock: Copy packets sent by Hyper-V out of the ring buffer
Date:   Wed, 13 Apr 2022 22:47:38 +0200
Message-Id: <20220413204742.5539-3-parri.andrea@gmail.com>
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

Pointers to VMbus packets sent by Hyper-V are used by the hv_sock driver
within the gues VM.  Hyper-V can send packets with erroneous values or
modify packet fields after they are processed by the guest.  To defend
against these scenarios, copy the incoming packet after validating its
length and offset fields using hv_pkt_iter_{first,next}().  In this way,
the packet can no longer be modified by the host.

Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
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

