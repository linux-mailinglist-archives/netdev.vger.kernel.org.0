Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D01234619A
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 15:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhCWOhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 10:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbhCWOgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 10:36:36 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44451C061763
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 07:36:35 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo10967162wmq.4
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 07:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Na2VZYrK81PcvSfN9T4jEkBcLTcy9RcjMORhpmSECxo=;
        b=eVfN89Tnee9VIHCl6M3XQiNffocMqRmf3o1UzoKNYPIqw8pSPwuM9xFFKGHyhepItY
         IOuljWWlf8F+F4DLoOQS5hre4Vu+XUlIpiOKezSmE5t7gmsRDMXsM+uR3SzJA+uuvhF7
         lhKJeV3Z4pSFR3tOKlwL6KliYsYZAY1VUuIJJnxPEXCSGXaJm/SnkCa+GG4nH5goy/ko
         UVak2zq8J4ScuuFsA6zacg/tDXqZuJPy2iPvfB7MOmCV+b/WDFlcp1MocCizyhR6zvaf
         HVYxtWOC+rbsa3UnjSrXPIsMGrny4YjCa8QT5nCVe6UpoWjTA3QsBXKt/BxDqXunUc9Q
         cx3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Na2VZYrK81PcvSfN9T4jEkBcLTcy9RcjMORhpmSECxo=;
        b=HMl/BDPhGo9QSuz59k4gjv9k0iMnnnXalSOIman9docpwKa7DncfWed5iMe1jn/qsd
         WFfKROTklYmghOgVBxfXsow/ZpGSDORfNVE5VIZrzVugD47f5m2EOY+5+bUHALI2qk69
         MUNjHhYLhqHyeVFrIQiWztEF276mNJFa9MdiMjMOJcpU6fIJrCObfk6qBjUPwpedmlNT
         phnbp8w9sgII8xy3VGSfmhQ8xyXrNJXpVre1gj5SnygVnwBcq8MnBi65SqSsNGaxJR3Q
         al99Hn1e3elohkzUUG1o/TjqohAw7R7ddogRrC6edScAC3e5rXtAfY1pnoLRkC+8/wi1
         LvfA==
X-Gm-Message-State: AOAM531C8gOYcf8oHaX6c17P2QwDVAh8Pi2NbVrHpsu3FnoGOhwBsiBG
        A9uO/RVq/hZLCAXSXqbsfzp+AQ==
X-Google-Smtp-Source: ABdhPJx59WCmGz1PEUdkVs0yEmq7gFumgfKsiMxYCXC5BPDzfa6cYPPj6LUPGyRuYo7PRHlbtsI5CQ==
X-Received: by 2002:a05:600c:214d:: with SMTP id v13mr3713899wml.162.1616510193880;
        Tue, 23 Mar 2021 07:36:33 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:f09e:975c:f695:2be8])
        by smtp.gmail.com with ESMTPSA id f2sm23995886wrq.34.2021.03.23.07.36.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Mar 2021 07:36:33 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [RESEND PATCH net-next 2/2] net: mhi: proto_mbim: Adjust MTU and MRU
Date:   Tue, 23 Mar 2021 15:45:07 +0100
Message-Id: <1616510707-27210-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1616510707-27210-1-git-send-email-loic.poulain@linaro.org>
References: <1616510707-27210-1-git-send-email-loic.poulain@linaro.org>
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

