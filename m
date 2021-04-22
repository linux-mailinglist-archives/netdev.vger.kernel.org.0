Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04ED368678
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 20:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbhDVSV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 14:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236668AbhDVSVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 14:21:23 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436DAC06174A
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 11:20:47 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id d25so9202982oij.5
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 11:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4P/Z0BjOeHd7Em2QyQWG2wZNocvEtZNBkiauwY2SGp4=;
        b=T2QemxN7ttWSae0PyiMiwtcUsKIi+8bf2p2e6clu7ex0nD0XDo38eaQv5SjyJB4arN
         cucbglVUchz/JTtFxienPnQ52W/KVEjL6yXRHfV/+Je1s/Te32ZGD9LHLuGQolhSoqgk
         iJZ/SzO7lUTHtRbzzP7HLmnUwcmLAv4Gya+G0Pxws88KUP9Mg2h7RNTDdZd6TvSZS0bh
         dXYjqaXnxAP2u2shvNG/jy0Uz8jgw7WbFJh9N5pg5PQn4qACG5MLRTvsNP8CMsTVtmcQ
         sGnWPittx31cy6pwqiA4hmzJRexjQ9cCEChc3BqVRG9zrxQEc9jxJJVTEgknpLLL7rVx
         bRGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4P/Z0BjOeHd7Em2QyQWG2wZNocvEtZNBkiauwY2SGp4=;
        b=B3lKK3abOYUu2Zs+QRqs7z/2FcqIfVMw5lxsN6bHJ2pzlgk+1oUjIuP/lEYNrAVOwK
         45y14ICpkAsfguqnwnERn9XuZYqy3NLRLRJnnu7sgeXznaDwfYzvUF+A5Ot4zghq46lY
         iIampeZV3m9QnKw99pYF+cRyeHuAqAJYVoApiKkbshx0jNAm6ZNAHXBdYmb/LoC12dUA
         jQrBTdiD5nC0sQICHYlw3o85VB4eZD2lNi1GR0xAA27hr7DRswsFxPm45G5sOsZvC6aG
         ZTcugRe4xOfUy2t8fqHKDY7G7gPrzQ+/A0il3XNJE948fM1jkzFYQGyzuZZbgr1KqR7U
         se+A==
X-Gm-Message-State: AOAM5322wEI7m90nMduCN+vV5C7zdPmgJcDDSlC3ZkydGLpfhzsoHCVn
        hn1srcN3CzXQs5QpEI3Kq7IJJg==
X-Google-Smtp-Source: ABdhPJzPhX+RWy30+3QBAcSYLkNC4Tmz7iBG3p4iT3Vvj67kV0JmcwCrTHM35hpXY+gHe0FGNZDhkA==
X-Received: by 2002:aca:fdc7:: with SMTP id b190mr3175938oii.14.1619115646623;
        Thu, 22 Apr 2021 11:20:46 -0700 (PDT)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id r9sm711634ool.3.2021.04.22.11.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 11:20:46 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniele Palmas <dnlplm@gmail.com>,
        Alex Elder <elder@linaro.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] net: qualcomm: rmnet: Allow partial updates of IFLA_FLAGS
Date:   Thu, 22 Apr 2021 13:20:45 -0500
Message-Id: <20210422182045.1040966-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The idiomatic way to handle the changelink flags/mask pair seems to be
allow partial updates of the driver's link flags. In contrast the rmnet
driver masks the incoming flags and then use that as the new flags.

Change the rmnet driver to follow the common scheme, before the
introduction of IFLA_RMNET_FLAGS handling in iproute2 et al.

Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 8d51b0cb545c..2c8db2fcc53d 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -336,7 +336,8 @@ static int rmnet_changelink(struct net_device *dev, struct nlattr *tb[],
 
 		old_data_format = port->data_format;
 		flags = nla_data(data[IFLA_RMNET_FLAGS]);
-		port->data_format = flags->flags & flags->mask;
+		port->data_format &= ~flags->mask;
+		port->data_format |= flags->flags & flags->mask;
 
 		if (rmnet_vnd_update_dev_mtu(port, real_dev)) {
 			port->data_format = old_data_format;
-- 
2.31.0

