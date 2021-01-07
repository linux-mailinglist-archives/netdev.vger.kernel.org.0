Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518BD2EE9D1
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 00:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbhAGXf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 18:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbhAGXf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 18:35:28 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A384CC0612FB
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 15:34:09 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id 81so7866324ioc.13
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 15:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e0iOv5ggqZII+dKDj+NHjegZcaspQECMTNLrYHZfeYk=;
        b=JnUWBpOrLOmtLb/KICRaAJ6LMiBPXf0PD40j6zowDLF3ZuzXhUT+YoZaDxtVZKlROq
         3bNQ+UtUM6ggaKJvsv28bs4N2RKNKAkdLnX4cSQduv+EVylUP/0RwQUc/cPJXEw+iJ6i
         hQv2l1ShxUqWvIJfMchAMnWuT0T6g+tV8i8QASN7bDVyYF7oV/HRj0/F/6+L0//rlhyY
         7NTINdLYgGIlZJ/nfvBUqI9zG544KJyInzPPhNmrLAh6FxTSpZC45RRtoJDfexZFeLVI
         qrR6C7pG+478u1TlePpmmM0QYRGJs9r073B0EJbJxJL2pQjuo7kpTD7MNopWoUmP0srZ
         jSXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e0iOv5ggqZII+dKDj+NHjegZcaspQECMTNLrYHZfeYk=;
        b=fxJacHXPYtqwcY4EF0f6H9PkjAgemoXjAc+xZQmoPpao7riBGbFmqV7SWEYLZObQDI
         v6+8lfzcjuID63137ytB4v+vS2DcDzBzrwSxeOsPF+Q59uS2UK9ErCpIv39h6HN1wSwg
         j2dr8fODOECnvj3h2shZh72UV6J27G6ij70pRF0EeRoD64ioVimGaXECdfsXNIa3yLFm
         UEpin98jjjMjo1V2rIgBHrp4jfQIsYWXMNbh02Re+zV2B2rzlmKq0wmbrHha8hH6rCt4
         ODYVjF/g4OBJTGRor4De90DJ5HDdlbdFf3ScIIyN09A2SHSRto9fcyswgW4jucjattf5
         5Rqw==
X-Gm-Message-State: AOAM5306c2aR6epvOBKvSwxRPjCwHCuXZCGj03cDI2QtlD1Iw/7S8JBa
        x/fa5BwOxGeZ6wcG51kJnb54jQ==
X-Google-Smtp-Source: ABdhPJw58jR7K3SfW8anxIJLUX6rBtOKDZO4sTCcsB3/nvG1AjzfHllogwku9ZBZ61FuG/KBZrHW9g==
X-Received: by 2002:a02:c608:: with SMTP id i8mr829900jan.125.1610062449020;
        Thu, 07 Jan 2021 15:34:09 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o195sm5648521ila.38.2021.01.07.15.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 15:34:08 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     bjorn.andersson@linaro.org, agross@kernel.org, ohad@wizery.com
Cc:     davem@davemloft.net, kuba@kernel.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/4] remoteproc: qcom: expose types for COMPILE_TEST
Date:   Thu,  7 Jan 2021 17:34:01 -0600
Message-Id: <20210107233404.17030-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210107233404.17030-1-elder@linaro.org>
References: <20210107233404.17030-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stub functions are defined for SSR notifier registration in case
QCOM_RPROC_COMMON is not configured.  As a result, code that uses
these functions can link successfully even if the common remoteproc
code is not built.

Code that registers an SSR notifier function likely needs the
types defined in "qcom_rproc.h", but those are only exposed if
QCOM_RPROC_COMMON is enabled.

Rearrange the conditional definition so the qcom_ssr_notify_data
structure and qcom_ssr_notify_type enumerated type are defined
whether or not QCOM_RPROC_COMMON is enabled.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 include/linux/remoteproc/qcom_rproc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/remoteproc/qcom_rproc.h b/include/linux/remoteproc/qcom_rproc.h
index 6470516621749..82b211518136e 100644
--- a/include/linux/remoteproc/qcom_rproc.h
+++ b/include/linux/remoteproc/qcom_rproc.h
@@ -3,8 +3,6 @@
 
 struct notifier_block;
 
-#if IS_ENABLED(CONFIG_QCOM_RPROC_COMMON)
-
 /**
  * enum qcom_ssr_notify_type - Startup/Shutdown events related to a remoteproc
  * processor.
@@ -26,6 +24,8 @@ struct qcom_ssr_notify_data {
 	bool crashed;
 };
 
+#if IS_ENABLED(CONFIG_QCOM_RPROC_COMMON)
+
 void *qcom_register_ssr_notifier(const char *name, struct notifier_block *nb);
 int qcom_unregister_ssr_notifier(void *notify, struct notifier_block *nb);
 
-- 
2.20.1

