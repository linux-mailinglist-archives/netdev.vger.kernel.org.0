Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442455BAF8E
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 16:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiIPOnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 10:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbiIPOnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 10:43:42 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B685F221;
        Fri, 16 Sep 2022 07:43:41 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id go34so49941185ejc.2;
        Fri, 16 Sep 2022 07:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ot7dgyB+KtHLDN7Xyqgw/4QKfFL14qXZyomQmyozivc=;
        b=TBL9jjzQgiXJcDlPnuYA0DP07U23BwTRwfRHAOhLJt/wUIozpDKbBdwxSdYrxtzZNX
         1gwg2rs5lAZnRaTMpYlR/fEVejvKMoY9mplZz5Oux0xqY/sgLqMuPOduMedGkqwJakGU
         Oo0LTT2C2xFS4/rmCaxLU4gplP5/MR0Wj5eIGlJqBYXdzD73OC7aotFdtXdRUlgfJzpW
         l9mstCpFOFw9owE6zxP0Zbptb/WGBbL1ceXt/pENXR1VW/jnQbLlSfd0HJVydM/zhNT+
         om8nkdTPcDxE/J8l171h9JUw2g5M66ZhYC0vkqWbYpH66pKNuxNNPjsylp0mJYOmxPR2
         Gm9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ot7dgyB+KtHLDN7Xyqgw/4QKfFL14qXZyomQmyozivc=;
        b=7RYqLKgGJ7wCvCtAHukE3QMCu8xH6E8TQOiy88m+MjS3smkwvKcydCQA59GHZe6gni
         8LPfZK4Z9X3M0ZA4Aa2V8dbqera8QqjcRDCMv4HTFccTsYhRCskplzjkFtdTwcQ2o1ee
         3K0qWyxEyuOd8dhFe49CSrWKOMpLGkB1yKKBcRaVa0Eije+h5I6bW8+FFoL/Wt0+ou2L
         B6+ohL1ot7HAzbOUlNAcSSAyxy6tL3p0E2zbwjo3ro0dsWVH25FpSEMevAro7IrApQ5W
         WpUFBeObVSi/lSZjtJ1lbAs7qb7EXrUS4xaVBdkOP+xZy0p/0XS0kw1hgmGTbQZj95sT
         1d8A==
X-Gm-Message-State: ACrzQf2aj6bIFvsF7+D5y0aciZyaVFg91n6Wl9f1H41gZiLxfm5/q/SQ
        eJS3HOiq3lGKkcUvPckoDiY=
X-Google-Smtp-Source: AMsMyM4dkscApZ9i0ayoK9S6XBYFSlZGHUE4c8o92NL9XHVxUl7n8gZKN152nsNzzBO6NPSSKDVplQ==
X-Received: by 2002:a17:907:e9e:b0:77f:9688:2714 with SMTP id ho30-20020a1709070e9e00b0077f96882714mr3915614ejc.208.1663339418500;
        Fri, 16 Sep 2022 07:43:38 -0700 (PDT)
Received: from labdl-itc-sw06.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id b15-20020aa7cd0f000000b004527eb874ebsm6273792edw.40.2022.09.16.07.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 07:43:37 -0700 (PDT)
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
To:     mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, mani@kernel.org, loic.poulain@linaro.org,
        ryazanov.s.a@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     dnlplm@gmail.com
Subject: [PATCH 2/2] bus: mhi: host: pci_generic: Add a secondary AT port to Telit FN990
Date:   Fri, 16 Sep 2022 16:43:29 +0200
Message-Id: <20220916144329.243368-3-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916144329.243368-1-fabio.porcedda@gmail.com>
References: <20220916144329.243368-1-fabio.porcedda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a secondary AT port using one of OEM reserved channel.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
---
 drivers/bus/mhi/host/pci_generic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index 51e2b901bae0..caa4ce28cf9e 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -507,6 +507,8 @@ static const struct mhi_channel_config mhi_telit_fn990_channels[] = {
 	MHI_CHANNEL_CONFIG_DL(13, "MBIM", 32, 0),
 	MHI_CHANNEL_CONFIG_UL(32, "DUN", 32, 0),
 	MHI_CHANNEL_CONFIG_DL(33, "DUN", 32, 0),
+	MHI_CHANNEL_CONFIG_UL(92, "DUN2", 32, 1),
+	MHI_CHANNEL_CONFIG_DL(93, "DUN2", 32, 1),
 	MHI_CHANNEL_CONFIG_HW_UL(100, "IP_HW0_MBIM", 128, 2),
 	MHI_CHANNEL_CONFIG_HW_DL(101, "IP_HW0_MBIM", 128, 3),
 };
-- 
2.37.3

