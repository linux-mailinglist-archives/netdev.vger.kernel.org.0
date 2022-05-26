Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A75B535159
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 17:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347909AbiEZPXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 11:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345092AbiEZPXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 11:23:22 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11260B82C0
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 08:23:22 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id y12so1871020ior.7
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 08:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wgV5WDhxmD0Dnlf3qJjYbgrRUn1OQnaRM9u6zB4EPj0=;
        b=IToBwRVLrMfLDIr+YkgYZKo8kZX1EPcQ3otjSZJwsbE2mnnYVVMzCor7Z2y3464Ndv
         uZMezsTJE2h3v16QLMKPwdYP1RuyNXo92U8i0fVWOevhQqqqnjBIwQSDSSYmqabH2vYW
         LLqxri3IE5rLz6/x0vLp/+ymd4p3tpoAIOUIk0ihH0ZiTVNdL2dAfoF7H2EuciTVWZNA
         uwHcGax+n8ofHSnCuYoc4n1M40JC+FMpSbMLzvD5fP7YRX85UtUCT4S0pWL0ZkMZ3Sa3
         g0C7uEfYPQ/i+vKS3hDZknB4x0EJD/FYdUQZ1uZ8fAcpza125jtsnaYtIFmJxGUgRxVr
         b1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wgV5WDhxmD0Dnlf3qJjYbgrRUn1OQnaRM9u6zB4EPj0=;
        b=1707uTpGhOPYv/OitcAemA6chBFxhPWzwLelZgGpg+zCrUuEe0Fog1zNZy01x+um9J
         2ujrf7wK0Nl/E8WlkbUWKitenMYu8qlrN3BbhkXcAzLdGJT5woiWKPGzWXP7rtsQiG8p
         k0sRsg6B+v3QnYAsfQV8p3DGJts3kZsbAtnNl8mjShppji+23M7y4Zu8pSbYOfuriEPO
         nXnC48VNR8lTlOkogU98gj4aYg5VW1YPumYisDc1ndcOZ9ygP9IAFfIyaMEpVii8wxPI
         yhVsRa7joPe/4yTOoxmm3LRXKqZ0EQiQK+GRUMRaRfyg+h7Gymj1gU4keVvrKMahIFCf
         5AZg==
X-Gm-Message-State: AOAM531EPczWFXqFDGr0AXWhhpnRZlp2VM5Muus1zqUMDx1rjunhbyS7
        v5EBAHHdaV4XoVVfq42Wwq4dmw==
X-Google-Smtp-Source: ABdhPJyv86Q+rlXw0biKIV5ICAXAC45XHggZ5ExI5BZTBsIyQSf3VwVvO7o6NzYN3ZcueM3S2dDB/w==
X-Received: by 2002:a5d:9448:0:b0:657:24e0:c0b2 with SMTP id x8-20020a5d9448000000b0065724e0c0b2mr16683401ior.167.1653578601430;
        Thu, 26 May 2022 08:23:21 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id b59-20020a0295c1000000b0032b3a78176fsm466847jai.51.2022.05.26.08.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 08:23:21 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 2/2] net: ipa: fix page free in ipa_endpoint_replenish_one()
Date:   Thu, 26 May 2022 10:23:14 -0500
Message-Id: <20220526152314.1405629-3-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220526152314.1405629-1-elder@linaro.org>
References: <20220526152314.1405629-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the (possibly compound) pages used for receive buffers are
freed using __free_pages().  But according to this comment above the
definition of that function, that's wrong:
    If you want to use the page's reference count to decide
    when to free the allocation, you should allocate a compound
    page, and use put_page() instead of __free_pages().

Convert the call to __free_pages() in ipa_endpoint_replenish_one()
to use put_page() instead.

Fixes: 6a606b90153b8 ("net: ipa: allocate transaction in replenish loop")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index e92aa9447f6e7..d3b3255ac3d12 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1095,7 +1095,7 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint,
 
 	ret = gsi_trans_page_add(trans, page, len, offset);
 	if (ret)
-		__free_pages(page, get_order(buffer_size));
+		put_page(page);
 	else
 		trans->data = page;	/* transaction owns page now */
 
-- 
2.32.0

