Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F110657A1E4
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239071AbiGSOk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239021AbiGSOkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:40:01 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0984454ADD
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 07:36:02 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id c16so6479849ils.7
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 07:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g+HjSH1OT4ZSTM+eXDsDJSu3gPtVsd7iXr5tehMDAHk=;
        b=UVl5ZgQLGmxFULFa7NUHhaeZ2fz4c8pq9g4BFufL+0iUBbmDyK9e3n6HQWUumFARad
         5ZltrdcLyVRosi7dx1A1pI6FIklKe0PkVClF53+JouXSsUQR0FKnCWKS5Q4YVp489Cow
         FXt7Z/GrVqyUwWVLuTS6jb+k88Z/BtYCtvuc5kz3ASHUOV4S1B4HGBjCVac5ieHhrKQG
         Cc3xpeH42FvQOpFYnKn5bqXCCv7ozEsRqNOHmxkjAhqKzoEsKXK9h9Xny3FFOENcjrB6
         x31ANOLdamX9/DaJ0RfZ1D3lUcqhzbDML0y0r09Vmyt0liAzinGoU0evtmXS6Ik5Bryf
         moDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g+HjSH1OT4ZSTM+eXDsDJSu3gPtVsd7iXr5tehMDAHk=;
        b=sJV2xubBv0HQkL15fzpllh7G+9p47xiC1mreRQcw3rMx1FSLnmshnz2A8EtrILcjoq
         bLuB3C/kX4pHTGW0rQ2ONmLSVEQ6PQx8tCg8a1VHvwSlxy22VL1bgmYSWkvIJNeN2uOj
         pztD/LfdzKovOeUuchI9UPAXbDswcnJbmEb2c0e1Lf5iiumQAWb9LTnAfeb6M+3AHGns
         VhKYasNoAIFeZbe8A5r8F8hn9PUjHjL2dobHQ7KypyP0ITQ16rsTNc3kp10qbqm9DzLz
         ZjtTSQIik9Oj4IihlM6PxCNYu5kJo67V+qtYkUfMjcd/4ScKbjDFAdIQVlLeHODg7PHL
         q0yA==
X-Gm-Message-State: AJIora+AlbdlO2bWxfAdFKy/qLGh22d9jHMCRMLKlcU8UzHBWg5rtQkq
        hoRfYd2coixXAdF7nb5bWg/aKQ==
X-Google-Smtp-Source: AGRyM1sj0ex0FAXdt3pBqnlnyH9HM6+drp7gvBcpR7wLH5QwVYV6EWHcF0uQEucv+yluBk4Sc4VnAw==
X-Received: by 2002:a92:6603:0:b0:2da:82b6:34a3 with SMTP id a3-20020a926603000000b002da82b634a3mr16275124ilc.250.1658241361376;
        Tue, 19 Jul 2022 07:36:01 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id t16-20020a056602141000b00675a83bc1e3sm7286559iov.13.2022.07.19.07.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 07:36:01 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/5] net: ipa: report when the driver has been removed
Date:   Tue, 19 Jul 2022 09:35:52 -0500
Message-Id: <20220719143553.280908-5-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220719143553.280908-1-elder@linaro.org>
References: <20220719143553.280908-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the IPA driver has completed its initialization and setup
stages, it emits a brief message to the log.  Add a small message
that reports when it has been removed.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 3757ce3de2c59..96c649d889a7c 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -836,6 +836,8 @@ static int ipa_remove(struct platform_device *pdev)
 	kfree(ipa);
 	ipa_power_exit(power);
 
+	dev_info(dev, "IPA driver removed");
+
 	return 0;
 }
 
-- 
2.34.1

