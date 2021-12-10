Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36856470DE4
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 23:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243705AbhLJWfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 17:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243502AbhLJWfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 17:35:06 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35419C0617A2
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 14:31:31 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id b187so11995265iof.11
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 14:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CgSHoGMd3MZ0+RwfUhTHIWklywVMelQpZkd8mqp/LWA=;
        b=e/JZEyXrKeEX9SR7YbajTX+JIlRKoyFcw5w6VW20SGiQT9UomhQ4hygaYNTaU4Bn01
         8jkk0VcLBji3os506FJaVgwZgwj1N5OTLELoMWFtOCmdV1p/3vIWe9StYftFRvleNBVR
         JgOtgzxPgk06gSQijatDKzxM2Z1y9E0wL1MwVw/IYiEeBdmpl8sZWi4fTEZzIp33r3MQ
         0aXJHS/klf7yMjqp6LONi1tpQuxmjiq9OKWEKeFgLJqWIZllL2VvUP+ortPwC8KV2RYa
         Pr6OJVg0oMChDBpG1wJ9T4l74ObuanDiExVOjlNC/9UeVZXYVSFBO5ZIqQM1yc3WbCXX
         rdzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CgSHoGMd3MZ0+RwfUhTHIWklywVMelQpZkd8mqp/LWA=;
        b=DubtkSRVcgusJyOWFS2mjP9hvwWALtLceET1IbXpwmS0hCeO+41XCGcCIqRO7v5/k9
         k6JwvR8ptqM4gQXjpj8vxuOsyLGeA3evAPgiL87bNDr10shKSGeHVPNbQI0+TeNqSXt+
         eY5DIAobxr9d6xirWmWGhXmtKOKuxxpDpD1yhjx0vxm5lEj6Xc9SkAEQN6EVEMxdzVdM
         zi+isnVxgQxBTigcOZNwU/lXWCnk/DHMu5Xru5fZsdiYi+dS8IcFfjWD70dFmeBYlMXc
         eiT+/6fW0lzleUN8jSr/aJGgRcgMSLPyxtBOOPp6mAPa1RRHWG6dt6qgjoPEbnYPpfi5
         fk8Q==
X-Gm-Message-State: AOAM530iuA71QlF/WZOwZIsgGVKHQR2wQqP7J93zpZuHljn15qL/J3u6
        Wi6x00+IRvGWVB/w9RNqPZcqmw==
X-Google-Smtp-Source: ABdhPJxJ2HPs8UlogyZ2Gs+icjZDUujFP0Gufzb4kOzlxXhOdNOSdtIYeCNaL34gHEkxdg3928jdGQ==
X-Received: by 2002:a05:6638:130f:: with SMTP id r15mr20409986jad.19.1639175490311;
        Fri, 10 Dec 2021 14:31:30 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id q4sm1279879ilv.56.2021.12.10.14.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 14:31:29 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     david@ixit.cz, manivannan.sadhasivam@linaro.org,
        jponduru@codeaurora.org, avuyyuru@codeaurora.org,
        bjorn.andersson@linaro.org, agross@kernel.org, robh+dt@kernel.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, mka@chromium.org,
        evgreen@chromium.org, elder@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/2] net: ipa: fix IPA v4.5 interconnect data
Date:   Fri, 10 Dec 2021 16:31:23 -0600
Message-Id: <20211210223123.98586-3-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211210223123.98586-1-elder@linaro.org>
References: <20211210223123.98586-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the definition of the IPA interconnects for IPA v4.5 so
the path between IPA and system memory is represented by a single
"memory" interconnect.

Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-v4.5.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-v4.5.c b/drivers/net/ipa/ipa_data-v4.5.c
index e62ab9c3ac672..2da2c4194f2e6 100644
--- a/drivers/net/ipa/ipa_data-v4.5.c
+++ b/drivers/net/ipa/ipa_data-v4.5.c
@@ -420,15 +420,10 @@ static const struct ipa_mem_data ipa_mem_data = {
 /* Interconnect rates are in 1000 byte/second units */
 static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 	{
-		.name			= "memory-a",
+		.name			= "memory",
 		.peak_bandwidth		= 600000,	/* 600 MBps */
 		.average_bandwidth	= 150000,	/* 150 MBps */
 	},
-	{
-		.name			= "memory-b",
-		.peak_bandwidth		= 1804000,	/* 1.804 GBps */
-		.average_bandwidth	= 150000,	/* 150 MBps */
-	},
 	/* Average rate is unused for the next two interconnects */
 	{
 		.name			= "imem",
-- 
2.32.0

