Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D124D4705DF
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 17:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243734AbhLJQlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 11:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240002AbhLJQl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 11:41:26 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFB9C061D5E
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 08:37:50 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id x10so11014577ioj.9
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 08:37:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n3CDcI54wXBndnATfaMcGfwDIMzZa57DanUaHDpclF8=;
        b=dsMAFy5prSCCxT2IzDIZiNSdPbgM5oi8w1R3G8KQ4QwfXmYwx/EVGIR5RV+lPoFZcl
         Qt94CzE5UZmng7MfvHRq+bnMemzdYy2G2InDx3SrPwnBnXMvbKIi4/kHJmQrFVEsqZgY
         mml9FRqHGen/TMuZo1tgICRl/dY3Oty7w6s07/CawJqDRl2PFn0WNCh+rcraJxGCMoio
         8hgTBL3D8UDOoP8DMl8TyUxqtEQsP6FuwaOBq2UjQ/UhufaK9OKk4us9Cl+6q9k7JZta
         4JGZf0IJ6fkng8PZLm13+bFU/khGtnOnt8dwk+OUhDTk9u3KxCAg0WP7ZoqBAV5+V3AR
         29Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n3CDcI54wXBndnATfaMcGfwDIMzZa57DanUaHDpclF8=;
        b=lUCYnYtfTucIPlDeRbfrFmrdMglPusurphcyUm2FSL+VF/CbU0rr2UOdcPVLdOk93B
         BVTN5XIJ1k9apGNY/eYgbuJEi3+DYro5Jwas2h/eGqkzRJ3eDR5T52UXSJ1A4DsXJgD5
         lgO3oOO70r2VIkMQZ+8lHv7ekD1up0eXDfU8toSzEgByRvkUyadbIMHMTJdmC1kkrxzK
         zRr7hIsTG+JUVLwDEemqykxamBgnpAcTUSKclo/FCD0a5pkC5syTsJ3LlwWS3tknVc5x
         AQsSqCC/Tg0/DxAHWEB8zWeRnx7bxdC8n6/j6P1Ff3wPpoKEKPM42Bqzz4a+G5u3fjVe
         cqTw==
X-Gm-Message-State: AOAM531l+T9mcs2NHKtl4IadnXOrAYuqR1RjsY7ictA6Rvmm3p+1DenJ
        nffCF2MiJsWXAz6JuPYwEXs8UQ==
X-Google-Smtp-Source: ABdhPJyDjPrJ+8imAtwL8PhNmfvMqc+00VzvlMSpFrD6KD0SLWbNB945FeVUe+D+kI2liCwA8FtErg==
X-Received: by 2002:a05:6602:2a4d:: with SMTP id k13mr19245303iov.133.1639154269726;
        Fri, 10 Dec 2021 08:37:49 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id p14sm2232642iod.38.2021.12.10.08.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 08:37:49 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     david@ixit.cz, manivannan.sadhasivam@linaro.org,
        jponduru@codeaurora.org, avuyyuru@codeaurora.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, evgreen@chromium.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] ARM: dts: qcom: sdx55: fix IPA interconnect definitions
Date:   Fri, 10 Dec 2021 10:37:44 -0600
Message-Id: <20211210163745.34748-2-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211210163745.34748-1-elder@linaro.org>
References: <20211210163745.34748-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first two interconnects defined for IPA on the SDX55 SoC are
really two parts of what should be represented as a single path
between IPA and system memory.

Fix this by combining the "memory-a" and "memory-b" interconnects
into a single "memory" interconnect.

Reported-by: David Heidelberg <david@ixit.cz>
Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 arch/arm/boot/dts/qcom-sdx55.dtsi | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-sdx55.dtsi b/arch/arm/boot/dts/qcom-sdx55.dtsi
index 44526ad9d210b..eee2f63b9bbab 100644
--- a/arch/arm/boot/dts/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx55.dtsi
@@ -333,12 +333,10 @@ ipa: ipa@1e40000 {
 			clocks = <&rpmhcc RPMH_IPA_CLK>;
 			clock-names = "core";
 
-			interconnects = <&system_noc MASTER_IPA &system_noc SLAVE_SNOC_MEM_NOC_GC>,
-					<&mem_noc MASTER_SNOC_GC_MEM_NOC &mc_virt SLAVE_EBI_CH0>,
+			interconnects = <&system_noc MASTER_IPA &mc_virt SLAVE_EBI_CH0>,
 					<&system_noc MASTER_IPA &system_noc SLAVE_OCIMEM>,
 					<&mem_noc MASTER_AMPSS_M0 &system_noc SLAVE_IPA_CFG>;
-			interconnect-names = "memory-a",
-					     "memory-b",
+			interconnect-names = "memory",
 					     "imem",
 					     "config";
 
-- 
2.32.0

