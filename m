Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2358C328294
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 16:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237210AbhCAPez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 10:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237261AbhCAPeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 10:34:20 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8939AC06178B
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 07:33:39 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id d11so16597625wrj.7
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 07:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Na2VZYrK81PcvSfN9T4jEkBcLTcy9RcjMORhpmSECxo=;
        b=Mmzi47qaICNtWQImClhIsBIS7Mq/KICeTd3QRAdTRzC1ZJEhw/LB4XDvqZVXAKrtPh
         mKVYD3FlBFSbVIsRHe8ShdRBv4gBSFqmHU8gSmoyAzKvKSrbqtrWCEsOWvHBI/vdvBw8
         519sEqDJlUCAQW/MJLQb9/n3dmKIc6QebaOU+CVeZMw5Flf2CZTcJaylicANbclO7qJH
         Sf9YVnOwT0rT4iVkvLSEg0KIyiOKAhHlD+lYOHHjOGs4v62ceJ64IC+X8BsWb3wF9vOt
         QY60feMOZPl+SdSrjgO+zzsP9oxT2R070u2UQEtPc3aDd6gtdmwU4JVRYsxRi6oaRT73
         MvQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Na2VZYrK81PcvSfN9T4jEkBcLTcy9RcjMORhpmSECxo=;
        b=Pvy5IyJu7FsMuIJPiiBudnKE9m0bNHkr76IvabW4x7DkoC4a9yZ7mB3IQwGB36JFnE
         u2aIrJxc1QQwcaN3Y7H8Z9FMFdBfNJsSSKnTm4pWDvniCq+Ky0gQv2HX+EDbBxapn3nV
         QY+r2CAyN9cRWVVZ04p8UbaCpysMuNACtO1i5x58RjZ6i85B6ClDCm5cPsDEnGolZHEa
         1/j2DuprEPIiJtXsz6Uo5fRV9g+LQ5y046D/sX1MhSff/28xae4qpZhQfVL42nDj6ZyI
         rClzKDmfgOdQ0lXyDS4Kqp3ZMw92a/LN9ZG5u8zVG5diQSRMih3SY0yK/KHXzjH8MQ7a
         uPEA==
X-Gm-Message-State: AOAM533xuEGv9v7F6N0ZhBIVcFSAa1kXl6sy8UGIMju+ZDc4AuaJiZV8
        FN46pEseEwvVJdCLOUA0+Hk50A==
X-Google-Smtp-Source: ABdhPJwzGpNxRmoYDwszVOhivJ1VV4QQzZHMYYHv5vT1Skw1uudj1E+WWBnrfai1Y1MGiNAh1etxFw==
X-Received: by 2002:a05:6000:1542:: with SMTP id 2mr17625236wry.356.1614612818300;
        Mon, 01 Mar 2021 07:33:38 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:5a20:c00c:6ec3:cc84])
        by smtp.gmail.com with ESMTPSA id x8sm3667855wru.46.2021.03.01.07.33.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Mar 2021 07:33:37 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next 2/2] net: mhi: proto_mbim: Adjust MTU and MRU
Date:   Mon,  1 Mar 2021 16:41:52 +0100
Message-Id: <1614613312-24642-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614613312-24642-1-git-send-email-loic.poulain@linaro.org>
References: <1614613312-24642-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MBIM protocol makes the interface asymmetric, ingress data received
from MHI is MBIM protocol, that can contain multiple aggregated IP
packets, while egress data received from network stack is IP protocol.

Set a default MTU to 1500 (usual network MTU for WWAN), and MRU to 32K
which is the default size of MBIM-over-MHI packets.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/mhi/proto_mbim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/mhi/proto_mbim.c b/drivers/net/mhi/proto_mbim.c
index 75b5484..29d8577 100644
--- a/drivers/net/mhi/proto_mbim.c
+++ b/drivers/net/mhi/proto_mbim.c
@@ -26,6 +26,9 @@
 
 #define MBIM_NDP16_SIGN_MASK 0x00ffffff
 
+#define MHI_MBIM_DEFAULT_MRU 32768
+#define MHI_MBIM_DEFAULT_MTU 1500
+
 struct mbim_context {
 	u16 rx_seq;
 	u16 tx_seq;
@@ -282,6 +285,8 @@ static int mbim_init(struct mhi_net_dev *mhi_netdev)
 		return -ENOMEM;
 
 	ndev->needed_headroom = sizeof(struct mbim_tx_hdr);
+	ndev->mtu = MHI_MBIM_DEFAULT_MTU;
+	mhi_netdev->mru = MHI_MBIM_DEFAULT_MRU;
 
 	return 0;
 }
-- 
2.7.4

