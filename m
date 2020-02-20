Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E558C165AE8
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 11:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgBTKA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 05:00:27 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54230 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727525AbgBTKA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 05:00:27 -0500
Received: by mail-pj1-f66.google.com with SMTP id n96so670220pjc.3
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 02:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=15QkUOyqGz6eomBKIwtq/Fp2YhGFsx/KFWnHxF+6NKE=;
        b=hiuCUmCfLCKyVHPPxzjMhumjyrh6B1A16pg0DojQwPUiI964RCzIfqNv+XihK+bp3V
         TUJPE6MYFQKH2Wv4ZwqZPYy8BpZHZUBU4xcxShBEIgECEBYnfvsDq9ZSC5Qpniy7WgvV
         stZSLcQmVbb0yDumCgAnGFWISB9/pc1GKEX1VUHG0suceqKhXrM31B0NT9cq1lSLP2gw
         y1+g8FDEpwz6tKpq2XlttWsN4p15OVSz+BKidJFBy27N6sqVOdWL3fEDr0qZCvLO25j/
         Cc61Q/6tpVvaVMoreeGMuW39HDaz9tuUipKZb4p26vaGF4XvTqrhxmHqHp983fnor+8x
         1MZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=15QkUOyqGz6eomBKIwtq/Fp2YhGFsx/KFWnHxF+6NKE=;
        b=iY+cQfnwcX/fB8JmVpp/MsTiLSW3uxyxX8wHOWeKatih7b6aQ6aeb9xEh+PyxLVlZ2
         xHUv438Xn+bpknwf/4f3bhHf91WakDJ+9tgr4jUaI3eL50M8WW4hRWyttSmESfSLgB7p
         PXkGLBn2EygWggFbc+l+i2mQwpiBfQiG/sosxFkkogasI5DX8SY0VKwJYq1gYIT9d4ID
         bUvQjfYa64UomrsZBktlUlO9Cup8QKrxnb95EdPbn9XPGWklh5+eF9UoRYoj+g4Wj69u
         HoLwRx4vIp7KrGk0azAv/2KKRePOAqvfAj4iyitpQSLBTNsyAnHVr+P/DPc2HZPv/XLF
         XJ/Q==
X-Gm-Message-State: APjAAAXszbfaDonjRa4Vl487IDSk/aqSQ/RUo5zWw5xDrj4f6V2+UTbf
        be631t6ULoZ22hoZNZpfr1c7
X-Google-Smtp-Source: APXvYqwacF6ybkjY5Ij8gFwXOma6aXyq39Ay53DohmoLvDmhDkqUODMNBJth9hqvAnFA5BC1cCbHAg==
X-Received: by 2002:a17:902:ff11:: with SMTP id f17mr29352446plj.273.1582192826397;
        Thu, 20 Feb 2020 02:00:26 -0800 (PST)
Received: from localhost.localdomain ([2409:4072:315:9501:edda:4222:88ae:442f])
        by smtp.gmail.com with ESMTPSA id b3sm2678644pjo.30.2020.02.20.02.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 02:00:25 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org, arnd@arndb.de
Cc:     smohanad@codeaurora.org, jhugo@codeaurora.org,
        kvalo@codeaurora.org, bjorn.andersson@linaro.org,
        hemantk@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v3 15/16] net: qrtr: Do not depend on ARCH_QCOM
Date:   Thu, 20 Feb 2020 15:28:53 +0530
Message-Id: <20200220095854.4804-16-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200220095854.4804-1-manivannan.sadhasivam@linaro.org>
References: <20200220095854.4804-1-manivannan.sadhasivam@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPC Router protocol is also used by external modems for exchanging the QMI
messages. Hence, it doesn't always depend on Qualcomm platforms. As a side
effect of removing the ARCH_QCOM dependency, it is going to miss the
COMPILE_TEST build coverage.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
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

