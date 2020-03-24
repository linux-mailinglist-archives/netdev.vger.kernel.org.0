Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A94FE190593
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 07:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbgCXGLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 02:11:41 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41757 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727470AbgCXGLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 02:11:41 -0400
Received: by mail-pf1-f193.google.com with SMTP id z65so8765676pfz.8
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 23:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kEUOtzoCcyxMGagaGiuW85PJFCulYHpDp09UxNca9Ic=;
        b=LWqoC+ijN07fTREV37khZvwLxEKrJVJ8dLjconoL52HWgkoIMQm5u5V6zJr9faWwEu
         EiA/axtbMM5pm8LWqafW1QlKlEgyLlNkpnn5PzPmvp7OgOUW9zJe6xndMfqJHTNnrIzK
         AXTT8LKoIkT7rh6tOmvgfjXwOm60cpNWCUyzRRR5uej42sH7YgyQ/NCMOgfVGWy+3KYT
         eNU8rhn+hJo4VZs3+fpLLjYQ3KVZr1paMqH2EXtgM5bHm1KXAH+ALJXMLGuE9iAYGwaS
         BrPs4wfnYuLkezc3ZNF/j4sFUFrM2RPfeyWibQ7RhrPjPUvZxUiRirfzkdbZJtIckmY5
         Z0Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kEUOtzoCcyxMGagaGiuW85PJFCulYHpDp09UxNca9Ic=;
        b=dej7rbgmyzzxtCh6h2VKUaJ22taBw74dONYoYIDsNIz/sh7ZzT4E3Nkua5sbNU6aEq
         pLx9r4nf4Ob8Eqjg5gO/MW5czZgSczq/8uR7Y1ZCT1GiAuoCjSBlWMITkyfNczE6ACTg
         66D8/TYHXEfv3sIUfdxibo4MK1TCo3aj4KvCtEULA/0+MH7ifaVmss2D0KFhAc+kYdRK
         u35r4U+ZRalJtACDXWOtsxEU7moDiIWSLCMvRtl9xnLFLjU4KF/B17DzxPv/OWhzu7L1
         DusHPqv1lVI4n14+kaObudbjOHYVCRhVTaG78G3KKpU6fQR8rETVMV3MFNU7x09aFqGE
         TgZw==
X-Gm-Message-State: ANhLgQ2q2aAKVrpzSAZyKFfKM/3K5RddGlNPyjrHl3bNGF9sh0z3hCFp
        0flVDM4XolrRAjORjdylC5to
X-Google-Smtp-Source: ADFU+vsE1loIykImw3+EDdk0dvEYpS7hbzKWOjzd6Nt2/voPeuQ9B8H8HvVt9opVTI845JEihChDeg==
X-Received: by 2002:a63:844a:: with SMTP id k71mr25767936pgd.79.1585030300253;
        Mon, 23 Mar 2020 23:11:40 -0700 (PDT)
Received: from localhost.localdomain ([2409:4072:59b:91e:2dd6:dffe:3569:b473])
        by smtp.gmail.com with ESMTPSA id d3sm1198230pjc.42.2020.03.23.23.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 23:11:39 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org, davem@davemloft.net
Cc:     smohanad@codeaurora.org, jhugo@codeaurora.org,
        kvalo@codeaurora.org, bjorn.andersson@linaro.org,
        hemantk@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        netdev@vger.kernel.org
Subject: [PATCH v3 7/7] net: qrtr: Do not depend on ARCH_QCOM
Date:   Tue, 24 Mar 2020 11:40:50 +0530
Message-Id: <20200324061050.14845-8-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324061050.14845-1-manivannan.sadhasivam@linaro.org>
References: <20200324061050.14845-1-manivannan.sadhasivam@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPC Router protocol is also used by external modems for exchanging the QMI
messages. Hence, it doesn't always depend on Qualcomm platforms. One such
instance is the QCA6390 WLAN device connected to x86 machine.

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

