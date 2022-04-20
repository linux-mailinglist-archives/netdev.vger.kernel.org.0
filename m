Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE54509133
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 22:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382060AbiDTUKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 16:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381936AbiDTUKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 16:10:32 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1414615B;
        Wed, 20 Apr 2022 13:07:45 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id z12so3774363edl.2;
        Wed, 20 Apr 2022 13:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U/urPSU6OV2SvWMA9AXFeQZujMJHrY6/s23lqylxLSk=;
        b=fSAfQxUOiGpYIwnO2RX01LmcZYwvxv+GsN73AoQIBLNMoEbgziTYl3qjUbemn0u/+V
         lHofybrqnh5Hu5PyEo+H3xDDAgu05QXclhbAwArt0Ip9RLja86CauCXVDv+X1B6yu6NG
         RHHWLV43YKZNnPfBgAUE0okFjRLhAs78Re5Qv5ooBdAv4XhHUVT+rXVPUDJ6fZK5sXjq
         MX5jObDumj+P2+4+wdfm01UC4NxDeu7nZFDvs/S/PWBr3zQ1RoRLslc8acxKK14aaTkk
         OOuDWkDqoOqnhpkwugmBK/yL6lBtCF+nEQwrvrLbPfhLZFIV5yPqLYhKykbEYKgQK7N2
         OmsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U/urPSU6OV2SvWMA9AXFeQZujMJHrY6/s23lqylxLSk=;
        b=uL0bktjky0axDXyiBpCApLEqsCW58iwZna7ugHd7u8fjo4NB3Se0aq6/p7/CXPtWpK
         G4+MP7PJwxktwKhbYHbPbdVcA4KL+o/WuuZ2wPaxkiWfQlDldV4A7XLK5GenNl3PrSm8
         /+pJPcJ+Xy67OUmX6lVYFgLf6t1ybHH0DwCCK1HWuuMR+9F/axf2UFzKRUKL8Jm1g347
         NdKPuiAgKrZqvh3nJIlBeenhx29fXITUkrU2Dh+kSTvY3Ps7D5b+UXuuOK9iXx5SRleY
         vaG/fskmVqX1L+FNJcStHLJDqUtMNqWXE3efJZ8ESBM62oaK+ASNus0dHEkPf5yz+NiG
         yhuw==
X-Gm-Message-State: AOAM530Z6AGE5TNOatOORtCystZLgfODCrpc4GhmrBGol0KhpRevCPrd
        PJsePSYLRRDmezhyuT/fPa0=
X-Google-Smtp-Source: ABdhPJyYzdti6UzhNDf5r8bN+Q2rloKA6TmD6TBwWrD56I/rfOtkiQjGzM+VeaXJoPsstZXbThRG5A==
X-Received: by 2002:a05:6402:34b:b0:41d:7026:d9e3 with SMTP id r11-20020a056402034b00b0041d7026d9e3mr25405100edw.168.1650485264346;
        Wed, 20 Apr 2022 13:07:44 -0700 (PDT)
Received: from anparri.mshome.net (host-82-53-3-95.retail.telecomitalia.it. [82.53.3.95])
        by smtp.gmail.com with ESMTPSA id gy10-20020a170906f24a00b006e894144707sm7126853ejb.53.2022.04.20.13.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 13:07:43 -0700 (PDT)
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
Subject: [PATCH 2/5] hv_sock: Copy packets sent by Hyper-V out of the ring buffer
Date:   Wed, 20 Apr 2022 22:07:17 +0200
Message-Id: <20220420200720.434717-3-parri.andrea@gmail.com>
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

Pointers to VMbus packets sent by Hyper-V are used by the hv_sock driver
within the guest VM.  Hyper-V can send packets with erroneous values or
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

