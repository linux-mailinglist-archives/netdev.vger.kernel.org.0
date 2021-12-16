Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D565476BA3
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 09:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbhLPINj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 03:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbhLPINh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 03:13:37 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29912C06173F
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 00:13:37 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id y8so18861059plg.1
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 00:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hxZwgNBumLHqXO+2gnKFYa6p15JpU/b4UvoM1L0jYYQ=;
        b=jEMZloFE35t3CKK9Q1XULRGALD0dQREkLaOh7FGrNslUiLggkSo+jnOg3w9HuvbcrZ
         1AHTAwrUGRie+jK3GXWuyBb3P8wSk3rTI4CatI0Lb8ttohSHCE/mtHW5NfQgbJSctVuO
         J1Jvv8Eo8oST1ffnNxcGaoWEciXBWRHhAvRB1pyV/QzhSn+sgXlKqBLQ3SrZT5vnzDPw
         uzE4rZEBFWmk2O17DwJH7QAIOdtVRDkGaO2EJq2TTQ48WHLawG/rjCi+wDdlVXcZgZBF
         LatkyxHKOx7YFGfa8PYIlu+CZHimVvZ/ica+0bDLG5Bg1VNUg9aR9Nfqszfeion8uuMX
         clOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hxZwgNBumLHqXO+2gnKFYa6p15JpU/b4UvoM1L0jYYQ=;
        b=bjAaOsparPj4/EqITUTe73vKNcHwaPBxFm5QOJ28pF83dUxO8H9//SC0Ur5LPXCpcV
         Cm4+uK53hTgmMdTkIlYeZOiZ8AQ6xkcrkGPUhBETal4MO6gtvoEjf6WhBX+PBoOMpy3e
         l+6CpzdXdKiC0CFtOMq9ZZlAV/+2Gv4xmS+U+2xZBa+IBJEm65HcfDS6dkKBvs3g9x3Z
         9tZYwVyAI7Qdpv0CJQ8cJAL3ofvbdt+x081TY8BuQ24AIWTdayq+R4EXYN5G6kkOdejj
         wcYm66aOCvD/ptYXYKrn3ZLbrmsXyP3qgc88RRIo7lBFHEFiPXuHi+8Lx+E05ivKKeoG
         30Wg==
X-Gm-Message-State: AOAM533jRWdbZu0wf+bTR7HKjtVIpxjQWT7VXtow0Q+0vPqyTvnTdB4V
        AYllKpsdN4pmGgMfQodkRSq2
X-Google-Smtp-Source: ABdhPJxMap+dqOqwRpoo82JM7xEAD+1B483j3epvQBrDNW6ieQt84qKgjC3fi4v5xAP5aNs9Md3huA==
X-Received: by 2002:a17:90b:1e04:: with SMTP id pg4mr4654111pjb.38.1639642416629;
        Thu, 16 Dec 2021 00:13:36 -0800 (PST)
Received: from localhost.localdomain ([117.193.208.121])
        by smtp.gmail.com with ESMTPSA id u38sm326835pfg.4.2021.12.16.00.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 00:13:36 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     mhi@lists.linux.dev, hemantk@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, thomas.perrot@bootlin.com,
        aleksander@aleksander.es, slark_xiao@163.com,
        christophe.jaillet@wanadoo.fr, keescook@chromium.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Manivannan Sadhasivam <mani@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 09/10] bus: mhi: core: Use correctly sized arguments for bit field
Date:   Thu, 16 Dec 2021 13:42:26 +0530
Message-Id: <20211216081227.237749-10-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211216081227.237749-1-manivannan.sadhasivam@linaro.org>
References: <20211216081227.237749-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

The find.h APIs are designed to be used only on unsigned long arguments.
This can technically result in a over-read, but it is harmless in this
case. Regardless, fix it to avoid the warning seen under -Warray-bounds,
which we'd like to enable globally:

In file included from ./include/linux/bitmap.h:9,
                 from ./include/linux/cpumask.h:12,
                 from ./arch/x86/include/asm/cpumask.h:5,
                 from ./arch/x86/include/asm/msr.h:11,
                 from ./arch/x86/include/asm/processor.h:22,
                 from ./arch/x86/include/asm/cpufeature.h:5,
                 from ./arch/x86/include/asm/thread_info.h:53,
                 from ./include/linux/thread_info.h:60,
                 from ./arch/x86/include/asm/preempt.h:7,
                 from ./include/linux/preempt.h:78,
                 from ./include/linux/spinlock.h:55,
                 from ./include/linux/wait.h:9,
                 from ./include/linux/wait_bit.h:8,
                 from ./include/linux/fs.h:6,
                 from ./include/linux/debugfs.h:15,
                 from drivers/bus/mhi/core/init.c:7:
drivers/bus/mhi/core/init.c: In function 'to_mhi_pm_state_str':
./include/linux/find.h:187:37: warning: array subscript 'long unsigned int[0]' is partly outside array bounds of 'enum mhi_pm_state[1]' [-Warray-bounds]
  187 |                 unsigned long val = *addr & GENMASK(size - 1, 0);
      |                                     ^~~~~
drivers/bus/mhi/core/init.c:80:51: note: while referencing 'state'
   80 | const char *to_mhi_pm_state_str(enum mhi_pm_state state)
      |                                 ~~~~~~~~~~~~~~~~~~^~~~~

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://lore.kernel.org/r/20211215232446.2069794-1-keescook@chromium.org
[mani: changed the variable name "bits" to "pm_state"]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/bus/mhi/core/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index f1ec34417592..046f407dc5d6 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -79,7 +79,8 @@ static const char * const mhi_pm_state_str[] = {
 
 const char *to_mhi_pm_state_str(enum mhi_pm_state state)
 {
-	int index = find_last_bit((unsigned long *)&state, 32);
+	unsigned long pm_state = state;
+	int index = find_last_bit(&pm_state, 32);
 
 	if (index >= ARRAY_SIZE(mhi_pm_state_str))
 		return "Invalid State";
-- 
2.25.1

