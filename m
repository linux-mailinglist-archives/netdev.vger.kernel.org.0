Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A653CBDC9
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 22:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhGPUcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 16:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbhGPUcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 16:32:06 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE31C06175F
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 13:29:10 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id y66so2925940oie.7
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 13:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RwzRqmMVs83P7rbI58217tVlUlaXFgFfHAAgk5vq3qY=;
        b=lMO+Bsd1L8p4HYAfngtw3CO3dY1Oz9NAygqEDu7e/JPAF8ZZwR/gHP8PUbRSQZjD6g
         4U5xrvaB7naAc4iJfNNl5Go3bjy1QhCfDT6y84cofGMtqD+EtIEsOMizofsHO34VgyLW
         oUr3oukNtaUTc3uG0H0vHNByY1RcNVZbHxdr4UVgUXxjo7/epXdGYKAEy/Ykl4cQ2gq9
         dTuQ4JFtIFURiAp2OO+7o8IBrO8kOOkBw0CvgcwamMxV9+CqH8+/lsqSqYFxFLtd0LHJ
         THa+Y0c8cECuevM0VkBp2bU1jXMmh+rtuZdjesePpX5JVNKXlt6Jx8vJShJWT34FWGEj
         lhoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=RwzRqmMVs83P7rbI58217tVlUlaXFgFfHAAgk5vq3qY=;
        b=chFwDK9t3wZANflEpgD0Lqeh5HexI0ViTQ1Bh5dKpAGQk2NY/tli+CTOZGkJ/UxvQ5
         y6jE0xzqpCsOUzWr5W0ZO2CgCNEeDndwPNe7q6STkwuiYURsh7t0A0Gd9eTMy8+KGJv1
         u4LvArrgyq1umPYj1LCWxl2mAzMcsVcXB3I60X10jrVcPR14Vn7wUprsrW+FxDcedUQt
         4raRpHr0h0/vuxkyN8rlny3eK22DPDdvYBPrX5/x+D9a4K5j1sjmEdY+BzuS+9WSuPEa
         ENX3Nkhn5+TqQn/zp+MyHy2ATB1qceN7KRaIZnFCMdEezclXjXauScuro5xFe8iFn1dP
         9Agg==
X-Gm-Message-State: AOAM532taH4cwv4SzzOtsjqOgkgU8e7qEnFLLq/YLSdrT8WS8P0CjU39
        jUzD+7zuUKBvhD1axYL0hrJWGNXHOg==
X-Google-Smtp-Source: ABdhPJxa1RtpqFwsghir/20HluNoWZoMGoGQtjlj7mtaxRtDkKg238mSEkvxrQj8ztsu0DMZyvKl1A==
X-Received: by 2002:aca:31ca:: with SMTP id x193mr9171457oix.84.1626467349579;
        Fri, 16 Jul 2021 13:29:09 -0700 (PDT)
Received: from serve.minyard.net ([47.184.156.158])
        by smtp.gmail.com with ESMTPSA id w19sm2172664ooj.39.2021.07.16.13.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jul 2021 13:29:09 -0700 (PDT)
Sender: Corey Minyard <tcminyard@gmail.com>
Received: from t560.minyard.net (unknown [IPv6:2001:470:b8f6:1b:6dd4:8f1:f5bf:7fdf])
        by serve.minyard.net (Postfix) with ESMTPA id F10E21800E8;
        Fri, 16 Jul 2021 20:29:07 +0000 (UTC)
From:   minyard@acm.org
To:     netdev@vger.kernel.org
Cc:     Corey Minyard <cminyard@mvista.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] ipsec: Remove unneeded extra variable in esp4 esp_ssg_unref()
Date:   Fri, 16 Jul 2021 15:28:46 -0500
Message-Id: <20210716202846.257656-1-minyard@acm.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

It's assigned twice, but only used to calculate the size of the
structure it points to.  Just remove it and take a sizeof the
actual structure.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 net/ipv4/esp4.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index a09e36c4a413..851f542928a3 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -97,7 +97,6 @@ static inline struct scatterlist *esp_req_sg(struct crypto_aead *aead,
 
 static void esp_ssg_unref(struct xfrm_state *x, void *tmp)
 {
-	struct esp_output_extra *extra = esp_tmp_extra(tmp);
 	struct crypto_aead *aead = x->data;
 	int extralen = 0;
 	u8 *iv;
@@ -105,9 +104,8 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp)
 	struct scatterlist *sg;
 
 	if (x->props.flags & XFRM_STATE_ESN)
-		extralen += sizeof(*extra);
+		extralen += sizeof(struct esp_output_extra);
 
-	extra = esp_tmp_extra(tmp);
 	iv = esp_tmp_iv(aead, tmp, extralen);
 	req = esp_tmp_req(aead, iv);
 
-- 
2.25.1

