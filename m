Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D06B3A4F2B
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 15:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbhFLN7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 09:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhFLN7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 09:59:51 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D564C061574
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 06:57:42 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id d9so34605314ioo.2
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 06:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=himBjQKtq4rWlc/v9yNLPdlT7s2MvK1OSVhcMGgSEBU=;
        b=ZxVsBil9YsJlisWXXU9+tXyw9zjxbqVO58KRicpvNsRFXG40lqnvNHOFOxqrMBcfzH
         iNmTEeVMSg/FJvewUt5Txdpd+fok5jKQo21sYt+wEN8Kr2wiN1dM3DYPggk5JBrlhjOr
         0yyxNtVKeOWpAQuvhQVFrKiyXavuy6OXBVzNAYsKqFfWgzn3OD2XC9dJgI/xSovfI+g2
         ADzydnqU+UvyR0BMCPG0fCEmkp0dHv70HnmFq9C1HzyKgbdyWd+zR2/1uhVQ8R0vhfy+
         q0mjDgbErJgkkZo8oZjC5eXqFgvEDfkAuzYd+J6x3kCrwW/8fSGpOnmIo1vV6aZRatT7
         uLMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=himBjQKtq4rWlc/v9yNLPdlT7s2MvK1OSVhcMGgSEBU=;
        b=CRRqkDM4L2tpQ1PW3hMwXmmmVFFdQon3Q6TuNGUHgJU+pa5hNGHmBZIIhGZtWPed2z
         rFaOu0LPGbdw2Nh3pvFWRNgI1DyZkMsnyh/chU+XBxSdoFmrf8fuy+gxgu/KHrgz3u4B
         3vHXmfQd/K0JtDmUIBk7IC3GijN62geSPGkDQVJCXAVji4AN0Gw58BuOJ53B1kHQi4FT
         lrXsuB7q5HePh5nKq2mZ2vc3LhIjw+1RHjsu/y5duqhW9E132va8dvZMAd44KJuckV9w
         HilvsIgaxNrKjWMh+NOcKI94NcWan7CikaEk2FraGRsZ96MWtA9o4M6jfvWWEtCSMQyX
         OxhQ==
X-Gm-Message-State: AOAM5328k2ynQhM9B8ABw55H+Hh7i4rLe4SLbQNvudlDpZsCp4Dfrrs/
        JpB9aKVF+bpAyKx++Hv1rSnfIA==
X-Google-Smtp-Source: ABdhPJzE0mf0zYYusr1qAKAcVGd97Ng2OSvQTtraMUG7rE+MYv0LAt6XAlBsWfH767pEF80H8rIs+Q==
X-Received: by 2002:a5e:8e03:: with SMTP id a3mr7205454ion.116.1623506259839;
        Sat, 12 Jun 2021 06:57:39 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id r11sm5021172ilm.23.2021.06.12.06.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Jun 2021 06:57:39 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     lkp@intel.com, bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/1] net: qualcomm: rmnet: always expose a few functions
Date:   Sat, 12 Jun 2021 08:57:36 -0500
Message-Id: <20210612135736.3414477-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent change tidied up some conditional code, avoiding the use of
some #ifdefs.  Unfortunately, if CONFIG_IPV6 was not enabled, it
meant that two functions were referenced but never defined.

The easiest fix is to just define stubs for these functions if
CONFIG_IPV6 is not defined.  This will soon be simplified further
by some other development in the works...

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 75db5b07f8c39 ("net: qualcomm: rmnet: eliminate some ifdefs")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c  | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index d4d23ab446ef5..8922324159164 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -188,6 +188,14 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 		return -EINVAL;
 	}
 }
+#else
+static int
+rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
+			       struct rmnet_map_dl_csum_trailer *csum_trailer,
+			       struct rmnet_priv *priv)
+{
+	return 0;
+}
 #endif
 
 static void rmnet_map_complement_ipv4_txporthdr_csum_field(void *iphdr)
@@ -258,6 +266,13 @@ rmnet_map_ipv6_ul_csum_header(struct ipv6hdr *ipv6hdr,
 
 	rmnet_map_complement_ipv6_txporthdr_csum_field(ipv6hdr);
 }
+#else
+static void
+rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
+			      struct rmnet_map_ul_csum_header *ul_header,
+			      struct sk_buff *skb)
+{
+}
 #endif
 
 static void rmnet_map_v5_checksum_uplink_packet(struct sk_buff *skb,
-- 
2.27.0

