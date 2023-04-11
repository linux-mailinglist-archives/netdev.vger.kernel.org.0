Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD1B6DE55F
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjDKUGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjDKUGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:06:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A05F5585
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681243503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZWIvLHTbsZUrfZPZ+ixSWYku7exrmBkFXk3jbX419Vo=;
        b=IJgFgjs0IQ+hDKluqPisLKYLzbxO29r8wYgb0O64DUtifJv4iYZZl9rtivHvoVXi/Zf6++
        Whc6IGeEDTyuuYs8Nayzp5TA/DFLMULTHrxm4j3Paeu9N6Jhcwxve8/0YVX67szjrg7ykY
        XLrsgOmQC9zjdqshdzidnOVllPAUybc=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-dfCU8iXlNmqOprkzIk5Cyw-1; Tue, 11 Apr 2023 16:05:02 -0400
X-MC-Unique: dfCU8iXlNmqOprkzIk5Cyw-1
Received: by mail-oi1-f199.google.com with SMTP id bb17-20020a056808169100b003846654dd65so2751074oib.19
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:05:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681243501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZWIvLHTbsZUrfZPZ+ixSWYku7exrmBkFXk3jbX419Vo=;
        b=npvJpGg2dYC84Jgpbya38LPWc2FkpdvcQzUCrEehQuBBhhpBcIFvgmFmNuPURatijw
         wFRU15OAFdzL6OtZau19SNcF5R/w+bgLJpeMmd0k+2TbW+HTFWr6cjTnMy9eCOudbD2n
         6uaSr+fXxuqQkuBMr1K14nQPs7YccKcZWpw6q7SI5K/ThJAHTYkDBo+/ZubYnuLjsNfD
         a3iu4ImojT1ljoBlZKc+tfmPlhKW/abtAi0KfQMKEmhlRyFWC7wZW9o19kHgHjwsrobQ
         sLmZggnSX47dYwo7eybFhVa0GTXwTHny9YWO0X0ZztVnW9eoSsYM32Y9zily1nVjz45s
         hKGQ==
X-Gm-Message-State: AAQBX9cLlvi5+I1gJ1Druyikx/9c/R9D0kBSQluI2/Y/Gxy9vJ+UR7oT
        KuH//Rtni0rFOGAUSsuwMUFXBaPu0y06+gbDaYGlyZs2yPijBnakDALsZVWIddgErp1WXwtgIDk
        ttY1+smrH3BKPIbFY
X-Received: by 2002:a05:6808:1823:b0:38b:973a:fe71 with SMTP id bh35-20020a056808182300b0038b973afe71mr6409940oib.40.1681243501183;
        Tue, 11 Apr 2023 13:05:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350b0cAvz42Qlls8WIYBkHt9iLwhpGWw1ZoYTxtNtior36S9BhWlnFImaPqwchjhbT2TqrxZ8rg==
X-Received: by 2002:a05:6808:1823:b0:38b:973a:fe71 with SMTP id bh35-20020a056808182300b0038b973afe71mr6409904oib.40.1681243500915;
        Tue, 11 Apr 2023 13:05:00 -0700 (PDT)
Received: from halaney-x13s.attlocal.net (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id e20-20020a056808149400b00387764759a3sm5868545oiw.24.2023.04.11.13.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 13:05:00 -0700 (PDT)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, wens@csie.org, jernej.skrabec@gmail.com,
        samuel@sholland.org, mturquette@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH net-next v4 06/12] net: stmmac: Fix DMA typo
Date:   Tue, 11 Apr 2023 15:04:03 -0500
Message-Id: <20230411200409.455355-7-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411200409.455355-1-ahalaney@redhat.com>
References: <20230411200409.455355-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DAM is supposed to be DMA. Fix it to improve readability.

Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

Changes since v3:
    * None

Changes since v2:
    * New patch, stumbled into this typo when refactoring

 drivers/net/ethernet/stmicro/stmmac/common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 54bb072aeb2d..4ad692c4116c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -242,7 +242,7 @@ struct stmmac_safety_stats {
 
 #define SF_DMA_MODE 1		/* DMA STORE-AND-FORWARD Operation Mode */
 
-/* DAM HW feature register fields */
+/* DMA HW feature register fields */
 #define DMA_HW_FEAT_MIISEL	0x00000001	/* 10/100 Mbps Support */
 #define DMA_HW_FEAT_GMIISEL	0x00000002	/* 1000 Mbps Support */
 #define DMA_HW_FEAT_HDSEL	0x00000004	/* Half-Duplex Support */
-- 
2.39.2

