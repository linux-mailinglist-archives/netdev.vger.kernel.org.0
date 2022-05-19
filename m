Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E6F52D71E
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240530AbiESPMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240540AbiESPM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:12:27 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBE7D809B
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 08:12:26 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id a10so6071387ioe.9
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 08:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nxAxEwpYxRir5k7Jix50x061l0SV3yP8iku6r8UOnSA=;
        b=GyyvoV+ytXOA2P3NDeGlTeLxNHXyVMiiYsn1E0p9TKjM0y/A7rGysu5MzWAXgrv+pI
         bjwi0hYOxRIQLw3rrLghEtc5k/k1nE/DL+tOVB7Bc/OIg1Wys+0dci+S11biuhuzVFi6
         0IoIP6Q14G0KH2gUM8a8d5+olWg195t5bK/3TUDA4tApBgaNS+4OH1JK/hoxUlAmsZmU
         E7ie1HplfnGNAb+O6kiKT2xYSa/x+ymbV97h6OF134q++epAPCgtdpA3eY8urg5ci1cW
         gB6ODaaTqf9dgZC5syipKoJz8c3BIdI886kVNi9SExCCm8XF8KWbBKMeLffdc+GEy8+Y
         hNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nxAxEwpYxRir5k7Jix50x061l0SV3yP8iku6r8UOnSA=;
        b=60kqSJFIwiSZCAy0LyrhxFDa/AMQMA4Gva55qo95fLduU+MWs8PE1InXKSOFZyySJ3
         D0xrIfLyBtwN3LOHIcefTDw0kUC12gfO5t7ckWR0n0RI/jNdM5WPdQ7ZIoSFnsmAjd7m
         +uTZu3XVuFGhY6nsgzEXOU/kK5zOahVXXbjEWDG42uXBboD9IYYEQSasxLdJfo/V7y/r
         kYbcbfHPCA9wwxdfo/u/E3SKSKOQPOUm/Pe47/CNN+3NXMY5yQ0JEuVsr0vhrINtQCLA
         GTsx8DNSCpT1hpRm15IyU6A0ql0OdAODwGNYlA6GmtvXoJ7LKm3QIpDoIaEmnVge1N9+
         fd7g==
X-Gm-Message-State: AOAM5302ugZvrCtnrdYx64Gvnv2iJh80Rfd2zQ+tZW/VRfKlfSLwYCLi
        7K8a6Ykg/qUE160FVgVPp50dMQ==
X-Google-Smtp-Source: ABdhPJyyOlkq7X/Nwk1VOwKXMx7MI5/Mg1ETxQfe2iRM/hPc6uGSFVFek5Obl/7c1xpP8f37E7Ogtg==
X-Received: by 2002:a5d:9bd9:0:b0:65e:1a97:fa70 with SMTP id d25-20020a5d9bd9000000b0065e1a97fa70mr2738456ion.48.1652973145598;
        Thu, 19 May 2022 08:12:25 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g6-20020a025b06000000b0032e271a558csm683887jab.168.2022.05.19.08.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 08:12:24 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/7] net: ipa: open-code ether_setup()
Date:   Thu, 19 May 2022 10:12:14 -0500
Message-Id: <20220519151217.654890-5-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220519151217.654890-1-elder@linaro.org>
References: <20220519151217.654890-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

About half of the fields set by the call in ipa_modem_netdev_setup()
are overwritten after the call.  Instead, just skip the call, and
open-code the (other) assignments it makes to the net_device
structure fields.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_modem.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index 27d87097433f0..dd6464ced2546 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -9,6 +9,8 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/if_rmnet.h>
+#include <linux/etherdevice.h>
+#include <net/pkt_sched.h>
 #include <linux/pm_runtime.h>
 #include <linux/remoteproc/qcom_rproc.h>
 
@@ -203,15 +205,20 @@ static const struct net_device_ops ipa_modem_ops = {
 static void ipa_modem_netdev_setup(struct net_device *netdev)
 {
 	netdev->netdev_ops = &ipa_modem_ops;
-	ether_setup(netdev);
-	/* No header ops (override value set by ether_setup()) */
+
 	netdev->header_ops = NULL;
 	netdev->type = ARPHRD_RAWIP;
 	netdev->hard_header_len = 0;
+	netdev->min_header_len = ETH_HLEN;
+	netdev->min_mtu = ETH_MIN_MTU;
 	netdev->max_mtu = IPA_MTU;
 	netdev->mtu = netdev->max_mtu;
 	netdev->addr_len = 0;
+	netdev->tx_queue_len = DEFAULT_TX_QUEUE_LEN;
 	netdev->flags &= ~(IFF_BROADCAST | IFF_MULTICAST);
+	netdev->priv_flags |= IFF_TX_SKB_SHARING;
+	eth_broadcast_addr(netdev->broadcast);
+
 	/* The endpoint is configured for QMAP */
 	netdev->needed_headroom = sizeof(struct rmnet_map_header);
 	netdev->needed_tailroom = IPA_NETDEV_TAILROOM;
-- 
2.32.0

