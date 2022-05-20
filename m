Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF14052F373
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353058AbiETSzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353048AbiETSzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:55:41 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0693C185C9B
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 11:55:40 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id j7so6130660ila.1
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 11:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RDjvNwQr73WDdKShZZtiXObHhvvbcnoL8/p/PaQfpbU=;
        b=XJgdvqahG/NtlK+huXowNp3c2vSH9BIpLhN+BMbtyukS48mNI5ag0vZH+xzrrB03eQ
         mJ0tho8YwZpitBsQ0TAs0hXMTqivWtdG7lfQb+EpGpN1byA26AK432pK+Eayw3OOvucx
         /Oilk00+wLdF0nMe7O/TfbHlSV4XmDiVMQV4GU3noTo0MKjh+PNybwjjYeiKDAHHnZGC
         TicURa+nvAj9Se9sJvDcy9WWUZ3LSIDA2h/RuPnDDa5jJ7GxwQrHp0e1vTZj+eSbFEdb
         D7giS6uFMDL7w/+fvht/gisrK809XtIoR8eQ+DeFgqGtHKCCUSl4HG8V0paUFW0Ykh73
         vDsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RDjvNwQr73WDdKShZZtiXObHhvvbcnoL8/p/PaQfpbU=;
        b=F85QpAFiZcpzAUqNhPzVWvNumq7d3X2c8d5m9VX1lYljh+H3v63jV5TPlg8lTXugH3
         Pwsy2NLD3PYOsqGXFDI+5xPNiqRca9aQaNp9ROPCg38K8Gr4FfRlRWDvdbeLjaeEmdcz
         Em4QXLCMIwPjHuXffCX4oCz5kfI4UoD7ouI5tDHAdhD9jUccHiRfq08rMCxMHMaHVH0Y
         i4XdOyHE/99AVOgAKRH+QDMLlQkiydraH/v/D68a7I40j8oRPhVSYIRQDkQKpwCDn6ci
         MXbZsSCBnWCn+czhcPVZtig8PjFaqKnhKcoNFOrW9ZC3x55tNaLeKB0cloaN/aa/iUmW
         loSQ==
X-Gm-Message-State: AOAM5338jPrFQNtunqus9UaS5leYBDPwcQ+gzGcLHStjcfxz/FHRyRXa
        3OvvAPOuEH8mOB778r6ig0sE/636860LZg==
X-Google-Smtp-Source: ABdhPJyuxgad0OryJ0z+JS8dKsn9mt1Kh1J3lVUgBw154sfSZT21KllAoiLlu7fvWFIX3sxS8iuBxg==
X-Received: by 2002:a05:6e02:1c22:b0:2d1:87b:c6a3 with SMTP id m2-20020a056e021c2200b002d1087bc6a3mr6199227ilh.184.1653072939426;
        Fri, 20 May 2022 11:55:39 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a6-20020a056638058600b0032b3a7817acsm871958jar.112.2022.05.20.11.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 11:55:39 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/8] net: ipa: make endpoint HOLB drop configurable
Date:   Fri, 20 May 2022 13:55:26 -0500
Message-Id: <20220520185533.877920-2-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220520185533.877920-1-elder@linaro.org>
References: <20220520185533.877920-1-elder@linaro.org>
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

Add a new Boolean flag for RX endpoints defining whether HOLB drop
is initially enabled or disabled for the endpoint.  All existing AP
endpoints should have HOLB drop disabled.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 8 ++++++--
 drivers/net/ipa/ipa_endpoint.h | 2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 0f489723689c5..3ad97fbf6884e 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1554,8 +1554,12 @@ static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 	ipa_endpoint_init_hdr_metadata_mask(endpoint);
 	ipa_endpoint_init_mode(endpoint);
 	ipa_endpoint_init_aggr(endpoint);
-	if (!endpoint->toward_ipa)
-		ipa_endpoint_init_hol_block_disable(endpoint);
+	if (!endpoint->toward_ipa) {
+		if (endpoint->config.rx.holb_drop)
+			ipa_endpoint_init_hol_block_enable(endpoint, 0);
+		else
+			ipa_endpoint_init_hol_block_disable(endpoint);
+	}
 	ipa_endpoint_init_deaggr(endpoint);
 	ipa_endpoint_init_rsrc_grp(endpoint);
 	ipa_endpoint_init_seq(endpoint);
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index 39a12c249f66d..3ab62fb892ec6 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -60,6 +60,7 @@ struct ipa_endpoint_tx {
  * @buffer_size:	requested receive buffer size (bytes)
  * @pad_align:		power-of-2 boundary to which packet payload is aligned
  * @aggr_close_eof:	whether aggregation closes on end-of-frame
+ * @holb_drop:		whether to drop packets to avoid head-of-line blocking
  *
  * With each packet it transfers, the IPA hardware can perform certain
  * transformations of its packet data.  One of these is adding pad bytes
@@ -74,6 +75,7 @@ struct ipa_endpoint_rx {
 	u32 buffer_size;
 	u32 pad_align;
 	bool aggr_close_eof;
+	bool holb_drop;
 };
 
 /**
-- 
2.32.0

