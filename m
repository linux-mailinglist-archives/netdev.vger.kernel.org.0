Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788681C8B6E
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 14:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgEGMxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 08:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726807AbgEGMxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 08:53:33 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C061BC05BD0A
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 05:53:33 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id b8so1892148plm.11
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 05:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FSudHAT4wzxoYvh1XMNs5f+xHdE9nw3XTPAzmG768CM=;
        b=zChQe1n/nYoXG2eQ59wLEmilwuApvr+My7WLtpOewR9iHv45bxbDRms3EXufL6YTKH
         OWT6btfmZBYj/3gY4jwWB06BhQHo19rgsuBU8TQ42IJOHTrUYeeJHmXJkk4WmQdQkno9
         EtUhJWDvi1p98wOTB6cz0Mmk3s0uV9P2flRg7sm4+UwVpkT4lD4qkxlEHJFfkfsWFA73
         BQfk7Sj0DicAZahZsbZ0fhd6uYDxOzDvyL90PHcNwewKQ+Pe6EwZn7x4Gx3v0WQYlvM3
         uGLy8r+HwhFF2+IJToTexSLo1YvvMYp6eu0L6PG5m7E6v3hJqevRDrNcIeu//qBm9Y0S
         mtfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FSudHAT4wzxoYvh1XMNs5f+xHdE9nw3XTPAzmG768CM=;
        b=OsOUDeIPGC5B3te+GXfrXa7YquUKY+G2BsJUuHRjCYafg91m1ASS7Vj3RqCFgOQOqv
         RZVecxsDgTjqUkyc5ebuAvb7DAHgER+vCF7n9GoliNzLjiBiQK+KlEn973yNOErjCPAp
         ovqQ3fYtAwMrnWnn6yKxBXcX5oSIhmEMJKu47ctcxf5XKkSVFQZcF6X6VvHXVckBvjON
         ap3YRyIUNMmoC7YiO7nDIUa/WheTHtx8a0h0yA/pr5sXqyQX3+n/3kXMwy8Jwl19n7ha
         3HxANZz7BRWeyzAZDvwPoqCswFW3O1XJo/Ktoa0dZmjCTeIo1nrE6PDieOAGqivso43K
         1Ekw==
X-Gm-Message-State: AGi0PuaNgugCNOrcBt+c7riqQ9ViRFvvKJyjW5tkOJjaQD3y4jJ66v0y
        9GMUFIdoeXTju6CpGA7NriIq
X-Google-Smtp-Source: APiQypKDKJnGRlEts2i6LAyypooHfFRBkYmJIK2URw0VjzGQDoaEJsoASFZHaKeRs2QmQb3GKl6pzQ==
X-Received: by 2002:a17:90a:284e:: with SMTP id p14mr15941533pjf.10.1588856013204;
        Thu, 07 May 2020 05:53:33 -0700 (PDT)
Received: from localhost.localdomain ([2409:4072:6093:7a3f:4ddc:efce:d298:c431])
        by smtp.gmail.com with ESMTPSA id q21sm4926190pfg.131.2020.05.07.05.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 05:53:32 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     davem@davemloft.net
Cc:     kvalo@codeaurora.org, bjorn.andersson@linaro.org,
        hemantk@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, clew@codeaurora.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2 2/2] net: qrtr: Do not depend on ARCH_QCOM
Date:   Thu,  7 May 2020 18:23:06 +0530
Message-Id: <20200507125306.32157-3-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200507125306.32157-1-manivannan.sadhasivam@linaro.org>
References: <20200507125306.32157-1-manivannan.sadhasivam@linaro.org>
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

