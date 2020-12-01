Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C17D2CACE3
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 21:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404411AbgLAT7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404393AbgLAT7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 14:59:49 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B010C0613D4
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 11:59:03 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id t8so2914290iov.8
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 11:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T/kUmZerIKMIo3G0Zg7dzOfj7yPRKwMEiqeAhWfpzbI=;
        b=ZG11Ti5rGFFD7LKyI1SjbcVJ6b/VJCcMu6PebA6MhY3vvMIxuei1hAKszHkUMX36jo
         d4OSmeSrI4A5o4Y34FKP5JBTmte4JXGYw2AuOlFVpkPOXj1FrnjA3/sQ+KrnyFd0MRLp
         ZYUXK2zylpW6hodPknh1OGItya6H7zNTys4COZgfZnGExV1RjmzAwFJBSBUftgp04Vck
         /6gTDazXjidKRDI6+yWSITEiNFyLrOi3q4byayB9q8vQhs2GnRVzPCGXnf5FjkxkuLXJ
         2SCbDoo+qFQOJSc1qAbXcJ5oY9Ry165SeyJCI9HpgZgWFAzLD2nzlFer9+e9bL1JAklq
         KeyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T/kUmZerIKMIo3G0Zg7dzOfj7yPRKwMEiqeAhWfpzbI=;
        b=T5omL30myqMYjs/Ukg37cTqYVH8gPp2AyHXka+Sj6MiTWattbaYeOBwQ86pQrSRDgJ
         KSrlegAR12qBj5vUBCeHHXJpUbee3y63x4+jOAIjApEljGtiJnxiC9bI5Zh7OA4ohdA8
         dEEAMQf3/zVj3q0N1MsYULmiQiBvIaWXQ9rrESq9T2r+g/6PTCAA8nYDRUyu7rPbI/R6
         LuXAlUQcut7GWsYhWHzw/tIM4y4iea/sYhyXfAxs4+6B/QULA4qsntFVodzbbnFcYBuR
         n3IjuO26OOTt1NHl4ZiPF4nIUuoRjGg3QxMYDl9zT4z7IEqyWC4j3brhgUzgq/+JEVfw
         xDgQ==
X-Gm-Message-State: AOAM531zpMZmO/t+AyeD+itQ3VHBKDfzgPaD0Wx9AlNrRHSdX+tuv4SH
        MBtwfbrd1yzWlOM2M1t8quLq1g==
X-Google-Smtp-Source: ABdhPJxJNVyMixOSMaBw7Zt7fdNHM/ZdKZha1GVdaRq/mZjsv/bB1QGQQMb29t1ve06fib9H/mY5qQ==
X-Received: by 2002:a05:6602:6c9:: with SMTP id n9mr3731666iox.112.1606852742976;
        Tue, 01 Dec 2020 11:59:02 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j12sm318041ioq.24.2020.12.01.11.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 11:59:02 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     jonathanh@nvidia.com, evgreen@chromium.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: ipa: fix build-time bug in ipa_hardware_config_qsb()
Date:   Tue,  1 Dec 2020 13:58:55 -0600
Message-Id: <20201201195855.30735-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jon Hunter reported observing a build bug in the IPA driver:
  https://lore.kernel.org/netdev/5b5d9d40-94d5-5dad-b861-fd9bef8260e2@nvidia.com

The problem is that the QMB0 max read value set for IPA v4.5 (16) is
too large to fit in the 4-bit field.

This is a quick fix to resolve the build bug; this might change
again in the future if I learn there is a better value to use.

Reported-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index f25bcfe51dd4b..192f9d6bccf19 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -280,7 +280,7 @@ static void ipa_hardware_config_qsb(struct ipa *ipa)
 		max1 = 0;		/* PCIe not present */
 		break;
 	case IPA_VERSION_4_5:
-		max0 = 16;
+		max0 = 15;
 		break;
 	}
 	val = u32_encode_bits(max0, GEN_QMB_0_MAX_READS_FMASK);
-- 
2.20.1

