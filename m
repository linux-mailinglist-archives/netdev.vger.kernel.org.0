Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C8C1C6719
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 06:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgEFEuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 00:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgEFEut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 00:50:49 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15F6C061A10
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 21:50:49 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id p25so391612pfn.11
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 21:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FSudHAT4wzxoYvh1XMNs5f+xHdE9nw3XTPAzmG768CM=;
        b=U3aDzcawg82HoyJF4XsjEECEGMvShr3jwEb08q/y3Gp5KJ+A3SFFYbESzXQpGxuCsd
         zACdWKMqVeq0+JZChcq/Dedbf8ZWMoE0WJucb2veZ59NC8vm1DJH2xTm0/Ua6ewnL/1f
         rU3Ur6HaT4HXlf/+xuubUBeWjsOGpYKr3JjLVJZ9419XaxgVNACzR6YpAXP2ZcreWRYT
         6jpduQWONW5u40Rkh+SLKyLnRXEIyxom2Wq7OAVnyUpmDk3TYRx1Py8ZacO5QVW/O/DB
         9iSGlaZthKfyUGXTH+4wCIpTPZd8MunSTBr45HNfxwdI+IeGPklbqUO8K+JU3UZpGoEs
         SkGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FSudHAT4wzxoYvh1XMNs5f+xHdE9nw3XTPAzmG768CM=;
        b=XMOlZaceqN9p/eoIxMAX2EDbzUOwOwOCUNEOcTB5uxQ1R1hZFAn+501hWqbmCDZw0v
         eHT9TwnNxGNIk1jtyPBNun+mRf5bD4U5N7iu49puw0QY8AsyOomfHK/4e3QNpRnP8Huf
         V1Xl9OWNpE50Gm2QJqsJXm45jO1VoCV7eEC+5RxaJ/WIajTqjMuhGgmonae2R2J2epWk
         U616Bu1E9spSeAZSkUzc27xkwkDRdcNa0NSRBhMTlKw7YTEGwqfRCdmHIAtz2WxlYRfD
         3RvQEkZgXyodvxr7S2cdJlNvqKJ4UcgsCwqtBUbNdwO+v9COfkUO69CyvEbtaxI8nK9K
         eb3w==
X-Gm-Message-State: AGi0Pua+NeS4DlTlLMS/Xc9zs8vvftXPMWxr/SOVSqsdPYREFQmdfecU
        bHJbTdxwzM+Fbgy7gc7Dikiv
X-Google-Smtp-Source: APiQypLjtuvE/fbjYHCJaAnW9hNPEbhOvT1KeTnwHy+YbHtcJlY6KdWyWjT2sssutPY0psBUFA480Q==
X-Received: by 2002:a65:5947:: with SMTP id g7mr5550370pgu.258.1588740649191;
        Tue, 05 May 2020 21:50:49 -0700 (PDT)
Received: from localhost.localdomain ([2409:4072:6e88:ac9a:a18c:3139:9aa9:bb73])
        by smtp.gmail.com with ESMTPSA id n69sm3491840pjc.8.2020.05.05.21.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 21:50:48 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     davem@davemloft.net
Cc:     kvalo@codeaurora.org, bjorn.andersson@linaro.org,
        hemantk@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, clew@codeaurora.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 2/2] net: qrtr: Do not depend on ARCH_QCOM
Date:   Wed,  6 May 2020 10:20:15 +0530
Message-Id: <20200506045015.13421-2-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506045015.13421-1-manivannan.sadhasivam@linaro.org>
References: <20200506045015.13421-1-manivannan.sadhasivam@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPC Router protocol is also used by external modems for exchanging the QMI
messages. Hence, it doesn't always depend on Qualcomm platforms. One such
instance is the QCA6390 WLAN device connected to x86 machine.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 net/qrtr/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/qrtr/Kconfig b/net/qrtr/Kconfig
index 8eb876471564..f362ca316015 100644
--- a/net/qrtr/Kconfig
+++ b/net/qrtr/Kconfig
@@ -4,7 +4,6 @@
 
 config QRTR
 	tristate "Qualcomm IPC Router support"
-	depends on ARCH_QCOM || COMPILE_TEST
 	---help---
 	  Say Y if you intend to use Qualcomm IPC router protocol.  The
 	  protocol is used to communicate with services provided by other
-- 
2.17.1

