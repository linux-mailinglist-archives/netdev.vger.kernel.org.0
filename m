Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0423238E2
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 15:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390553AbfETNy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 09:54:28 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43868 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390302AbfETNyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 09:54:08 -0400
Received: by mail-io1-f68.google.com with SMTP id v7so11038962iob.10
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 06:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8sgAB/AGyzpe5i8kq4OdwdrKx4EqLUnBgzPsX6Zqbyw=;
        b=rDEMXB3Un6MgiWh4ksumjEEVa9RIeGcQ/D2s4tFLbqN9nlrSYnXOr0yEDoAaR6V1vM
         ATjGLvuaFBu76A2xSWr5+ppw+kVHhrHlJzKuxeKCLTWMT34QA972duz6cj+vLBUWrMmJ
         2LeR+I+G4795y9S5c68S3ARzybp2HwFrCYHI+HOBjCoUiL4JBuYU55F45fA684s4D5HO
         /H0qJ9zEqZzr4I1ekSrP/P0cnZ9y6L/stZ7RJ5F5KDqlEeK+TIQYwl8dTfHFAD3WBp3V
         219aMx8wPPLNjFsSMEM8sP2adx7BDPZu9YQYcAs0qgJU3ZB8Al+zCS0GB2VHxf6hiSLX
         3dfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8sgAB/AGyzpe5i8kq4OdwdrKx4EqLUnBgzPsX6Zqbyw=;
        b=gVX3GOyj+qAdR162Uzo/1lvTqxYzRQ6NOpnf7jTXiBxJEaZqQ+75t7J6TlFWFIKLom
         dg/WlUtlQ8gspvMD+rPKYYJXYCMuFWexCewXW8TpVWjE6F3lHNqHlelgTHWTJ5bSYfY3
         esFdo97Aecm8788YoMg+Rktl1DBydQhapLh3e36+zE1400OGG1iwMAiGdrOcIJ7U6eaw
         IaLGfY5sS36b5lWo1hLIE8Qx+uRQwTrpTHVHJVvdNmnz8N1wk7f2KIbgbdzJi4wMzVbU
         gR62cqlJ0qmdPjTZarFhhO968Lr9/8rJofHl+Ha4mcuDFo0XLd1pNMu3F7i/qwDluWcf
         rv0Q==
X-Gm-Message-State: APjAAAXtQVBPXPVflBNIatDmpgc8y4DZpkB/OL9464bHSq1/nwwIicXX
        zxxNI6csjbVXGG/FMozkpcmgGg==
X-Google-Smtp-Source: APXvYqzKN0iv4h6jWKvTTCl0uadYJCIgkU2OoTryl4K5KV0aAamgJ1/b6G2rx2mupUMzWjojbh7wxA==
X-Received: by 2002:a6b:c411:: with SMTP id y17mr8433515ioa.265.1558360447762;
        Mon, 20 May 2019 06:54:07 -0700 (PDT)
Received: from localhost.localdomain (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.gmail.com with ESMTPSA id n17sm6581185ioa.0.2019.05.20.06.54.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 06:54:07 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     arnd@arndb.de, subashab@codeaurora.org, david.brown@linaro.org,
        agross@kernel.org, davem@davemloft.net
Cc:     bjorn.andersson@linaro.org, ilias.apalodimas@linaro.org,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] net: qualcomm: rmnet: get rid of a variable in rmnet_map_ipv4_ul_csum_header()
Date:   Mon, 20 May 2019 08:53:52 -0500
Message-Id: <20190520135354.18628-7-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190520135354.18628-1-elder@linaro.org>
References: <20190520135354.18628-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value passed as an argument to rmnet_map_ipv4_ul_csum_header()
is always an IPv4 header.  Just have the type of the argument
reflect that rather than obscuring that with a void pointer.  Rename
it to be consistent with rmnet_map_ipv6_ul_csum_header().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index a95111cdcd29..61b7dbab2056 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -203,26 +203,25 @@ static void rmnet_map_complement_ipv4_txporthdr_csum_field(void *iphdr)
 }
 
 static void
-rmnet_map_ipv4_ul_csum_header(void *iphdr,
+rmnet_map_ipv4_ul_csum_header(struct iphdr *ip4hdr,
 			      struct rmnet_map_ul_csum_header *ul_header,
 			      struct sk_buff *skb)
 {
-	struct iphdr *ip4h = iphdr;
 	u16 offset;
 	u16 val;
 
-	offset = skb_transport_header(skb) - (unsigned char *)iphdr;
+	offset = skb_transport_header(skb) - (unsigned char *)ip4hdr;
 	ul_header->csum_start_offset = htons(offset);
 
 	val = u16_encode_bits(skb->csum_offset, RMNET_MAP_UL_CSUM_INSERT_FMASK);
 	val |= RMNET_MAP_UL_CSUM_ENABLED_FMASK;
-	if (ip4h->protocol == IPPROTO_UDP)
+	if (ip4hdr->protocol == IPPROTO_UDP)
 		val |= RMNET_MAP_UL_CSUM_UDP_FMASK;
 	ul_header->csum_info = htons(val);
 
 	skb->ip_summed = CHECKSUM_NONE;
 
-	rmnet_map_complement_ipv4_txporthdr_csum_field(iphdr);
+	rmnet_map_complement_ipv4_txporthdr_csum_field(ip4hdr);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
-- 
2.20.1

