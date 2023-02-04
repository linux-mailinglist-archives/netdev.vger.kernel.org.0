Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999DD68AA4C
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbjBDNhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbjBDNgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:36:52 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F832125;
        Sat,  4 Feb 2023 05:36:51 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso10084125pju.0;
        Sat, 04 Feb 2023 05:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MWIPEpOQO7SVE2HbqMg/0fsvjNdObXiPOV4KlQDmpz8=;
        b=I6V6IuATguSQYK8Wpo+KJN/1xC0HuTYd+ZzuFWLnuV4E8BhVjKMaY9wDcMReQvVdPx
         KSmHl8UvkMvGKdbIBk60XhlHnBhyQivq0OANQaqUxAyXP5ISENVQvyivxC1oizmqtH3Z
         gJytAN5CWmQmZdJ6Soi74HDr7Blu6EzpYJnSRhNHIaFAZkDCOAE8vyAo1q7ncKpRlmoy
         PMNZffCmFzrGYLbY+BMcQstNoEo4glmuj9taR1FcpM+KPVw95CNn7zEPW76v+yFGJsK/
         6izCjdalZtSlwYUDd3PEpo++wcNqN4oO/GEzcma4qmtU68jzRF6axeRZqjEKTvCBL19P
         3JVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MWIPEpOQO7SVE2HbqMg/0fsvjNdObXiPOV4KlQDmpz8=;
        b=LLzmnrEP4CCS2VBfT8El5oDQB2yrxggWaPhcu5lghas2zVFLNlijwL9dQ8DZ3Beb0w
         s52C8sjoJxUbkSIEnruK0hDG5Q8WlWkU6CGsB+Wo1e/Wztpq57eoXCr+58MiQ5GI0MeU
         99ues0e6R0QYNFugKb8DrFlmnALcUtAkdz8UaaAlXeyBbiHuLwVmYbdBI54HKSoB9Zk+
         yUWzZ5BNRYPkOVocYoGpPt0ewgYwb9wCm4nRduigG639H7SQytV7sK0h6Rh0NO4XzJPX
         2MDfr5Kbisj9+m3Ig2QpAf2jPSnPBmNXpJP6p7KUaDwRxjFlWrsrP5AvwxrmK58vvRSO
         K6NA==
X-Gm-Message-State: AO0yUKUiWtBDR0sKaZnlfBwq07g+ZHdzyfmnbdsE9wpV2J9T6K0+6j05
        T5IRvu4+BcSAPIlfHWLZYLc=
X-Google-Smtp-Source: AK7set83rrYjrPS1zC57yRLaN6psKEuRjO2Mo7XwSJhF+t4WbJU3RY4J1yPg2LrRpxOooQPhnuXBNw==
X-Received: by 2002:a17:902:dcc5:b0:199:29:4d54 with SMTP id t5-20020a170902dcc500b0019900294d54mr165161pll.59.1675517810989;
        Sat, 04 Feb 2023 05:36:50 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([114.253.32.172])
        by smtp.gmail.com with ESMTPSA id 21-20020a170902c25500b0019605a51d50sm3463575plg.61.2023.02.04.05.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 05:36:50 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com, maciej.fijalkowski@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net 3/3] ixgbe: add double of VLAN header when computing the max MTU
Date:   Sat,  4 Feb 2023 21:35:35 +0800
Message-Id: <20230204133535.99921-4-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230204133535.99921-1-kerneljasonxing@gmail.com>
References: <20230204133535.99921-1-kerneljasonxing@gmail.com>
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

From: Jason Xing <kernelxing@tencent.com>

Include the second VLAN HLEN into account when computing the maximum
MTU size as other drivers do.

Fixes: fabf1bce103a ("ixgbe: Prevent unsupported configurations with XDP")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      | 2 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 +--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index bc68b8f2176d..8736ca4b2628 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -73,6 +73,8 @@
 #define IXGBE_RXBUFFER_4K    4096
 #define IXGBE_MAX_RXBUFFER  16384  /* largest size for a single descriptor */
 
+#define IXGBE_PKT_HDR_PAD   (ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2))
+
 /* Attempt to maximize the headroom available for incoming frames.  We
  * use a 2K buffer for receives and need 1536/1534 to store the data for
  * the frame.  This leaves us with 512 bytes of room.  From that we need
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 2c1b6eb60436..149f7baf40fe 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6801,8 +6801,7 @@ static int ixgbe_change_mtu(struct net_device *netdev, int new_mtu)
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
 	if (ixgbe_enabled_xdp_adapter(adapter)) {
-		int new_frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN +
-				     VLAN_HLEN;
+		int new_frame_size = new_mtu + IXGBE_PKT_HDR_PAD;
 
 		if (new_frame_size > ixgbe_max_xdp_frame_size(adapter)) {
 			e_warn(probe, "Requested MTU size is not supported with XDP\n");
-- 
2.37.3

