Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838AC26E43B
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgIQSnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgIQSm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 14:42:58 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91424C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 11:42:56 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t14so1869101pgl.10
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 11:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=dqBn5qZmVyqY8WKamfvAn9/7HsEG0IM69jGAupHfHds=;
        b=H8w5NQnYtwsnNo4KWzdtrIbOxk6v6LI3I2UEtTvHoc/BP0MBVo8XlnKsuwQXc54x8L
         ba1QY9G+IkSNxN6FI62Qp48XNBvmLITQVmy3PFRRm+WWN5+VwmUy59If4qofRpnIZ6+7
         pBQtRN/DKUSiSkeotAGYgdX3cBCtdD0xzQrHeT93lB2hz4oPpUdvEbpumiDjePr+X3m7
         FuLbmQHOHBkgwEHE+/1mJYnizD4N8roXaysreZXNZrKmtq8/JD3BRxSSUVdkgR+EA+dU
         ZZ3S8W+qBeTWmeWkN/yt4rOf+VbViPWSTGPXY1e0UQdoJfwOj2shjGFgkluDNIdxGVAY
         AquA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dqBn5qZmVyqY8WKamfvAn9/7HsEG0IM69jGAupHfHds=;
        b=CvBxh5URUGasPno870wAUSnfVN2sq25M3YirI7UF6RH5zKpFEREKsfcL0tBWy0CZ0j
         0gRnu0OlLKfmUx8Z3jEK7l7fx2Dhu2XBOhXkmi38VcU/lirgEbhASuIYxRPnNzo+kFot
         gjFmE9dnEKJDdViNAbugogHTzBUoAXv3BjlYiYpeoUf0fD0I35K4t4wlXJUZnlS3T3eU
         r1Gzc6p63BU1FfHTOCV3AIHLuTFvlmQSrVh6hG+8m70CvBmbVNvokg8KNPcwaTlWmpf6
         CfwG40n3ZxC5tGvzMlnem8m8DwCwCWsTngc/7phA/rU8MuMgXors5cLPGqN2JnxhMSn/
         tS3Q==
X-Gm-Message-State: AOAM532axvgju0BMQIgBEGN86pR7kaabt1VNctu7YkFp6M9yfIq64bvo
        02Bq7ed/NJvUSUl+BwlhOOi3/vcUbwYRjw==
X-Google-Smtp-Source: ABdhPJxE7WpGwxNLXopBJDjdV5LdVig5w3fhxFFMpd09vgyyiJ7nh7kIGxmgtrYYZe0q6W1aP1pppQ==
X-Received: by 2002:a63:f34b:: with SMTP id t11mr23810378pgj.111.1600368175444;
        Thu, 17 Sep 2020 11:42:55 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id b11sm354887pfo.15.2020.09.17.11.42.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 11:42:54 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next] ionic: add DIMLIB to Kconfig
Date:   Thu, 17 Sep 2020 11:42:43 -0700
Message-Id: <20200917184243.11994-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> ld.lld: error: undefined symbol: net_dim_get_rx_moderation
   >>> referenced by ionic_lif.c:52 (drivers/net/ethernet/pensando/ionic/ionic_lif.c:52)
   >>> net/ethernet/pensando/ionic/ionic_lif.o:(ionic_dim_work) in archive drivers/built-in.a
--
>> ld.lld: error: undefined symbol: net_dim
   >>> referenced by ionic_txrx.c:456 (drivers/net/ethernet/pensando/ionic/ionic_txrx.c:456)
   >>> net/ethernet/pensando/ionic/ionic_txrx.o:(ionic_dim_update) in archive drivers/built-in.a

Fixes: 04a834592bf5 ("ionic: dynamic interrupt moderation")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/Kconfig b/drivers/net/ethernet/pensando/Kconfig
index 76f8cc502bf9..5f8b0bb3af6e 100644
--- a/drivers/net/ethernet/pensando/Kconfig
+++ b/drivers/net/ethernet/pensando/Kconfig
@@ -21,6 +21,7 @@ config IONIC
 	tristate "Pensando Ethernet IONIC Support"
 	depends on 64BIT && PCI
 	select NET_DEVLINK
+	select DIMLIB
 	help
 	  This enables the support for the Pensando family of Ethernet
 	  adapters.  More specific information on this driver can be
-- 
2.17.1

