Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0B23EAB4E
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 21:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbhHLTvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 15:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234057AbhHLTvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 15:51:04 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFF5C061756
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 12:50:39 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id k3so8303501ilu.2
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 12:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A1nWF/SBVlOEtRNj50bqjEm68CLUjY5XY9SL0pkxyOY=;
        b=xL6NK+ycinMutAWQ2Laswxy1kPlT3t6lZqn0gzCl2wdizaPzJlCmjrGM2eQ1rPyAId
         OH3X1+MMj8cIJqnG7DNTkhp45RPX3vMwuJ8f60Aw6YWU6ArYgcFfhtMtpNPG36YS8lYQ
         rDacq/UJ+uyQWmrVGrpcQaqkQDNZQLUk0B+Ob238Gg20aMwV+4b3zDp9B0N1nnEbtAnW
         kGCL6Pkslo4kWUMFIYRSJ15z/1xjFLl5TsvK/TX+0GFAoW9pLvxy+9/Gkg9YT2CZQxuB
         CPY+vVGK11e2asH+J+ogIJlhpKYKOUdBkc++lv+HW9TRKJOhfLXZ/IYafdLuve7TJBav
         qIjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A1nWF/SBVlOEtRNj50bqjEm68CLUjY5XY9SL0pkxyOY=;
        b=CvaYefgbqyw22VGkuUpeNsepv5C9l+e7h1RNrSlOSQ2PtKJevJzCfMpWZZe5IA86Nb
         m+8jmqf9iGD38ZyF7HuyB3D58tppQr4WgdqESl2+JFRe2Kozd0Ckzvqgk24LGmRahUs3
         FBtjjLQHtO9Nu/lMddsWU7+v2drxbcZTI6F7z6J5TsD5AiYEeAoBS5uSEvG34ZwlvJ8T
         uk+4wLbgtUPuYbIKo1PuLsk48+mUMsi3AALEA560TYlAlgIeVB1/Zg5kNF9I/Y75gPkX
         pAyopJfimZIzPHa9sNE3Ljs9f3bdHiqk8lvVF8m3qkAuS4ca1JdV8NXWaaysiSFv52YD
         iPCQ==
X-Gm-Message-State: AOAM533jlpqRKQNXvASjrn3/Df3Am+2z79R9/p3YkP6yT4EEIzphopmq
        eGbhfEhFdLWjDtFDw62rM0qpdg==
X-Google-Smtp-Source: ABdhPJxwXQyb5/bf9Ovl+3zXXZBFD9ceeTmRXa12RxgY3ET1qwI0YkoiImgk3OfggeppSPOCLjNylQ==
X-Received: by 2002:a92:d3cb:: with SMTP id c11mr209351ilh.178.1628797838524;
        Thu, 12 Aug 2021 12:50:38 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s16sm2058821iln.5.2021.08.12.12.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 12:50:37 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/6] net: ipa: last things before PM conversion
Date:   Thu, 12 Aug 2021 14:50:29 -0500
Message-Id: <20210812195035.2816276-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains a few remaining changes needed before fully
switching over to using runtime power management rather than the
previous "IPA clock" mechanism.

The first patch moves the calls to enable and disable the IPA
interrupt as a system wakeup interrupt into "ipa_clock.c" with the
rest of the power-related code.

The second adds a flag to make it possible to distinguish runtime
suspend from system suspend.

The third and fourth patches arrange for the ->start_xmit path to
resume hardware if necessary, to ensure it is powered.  If power is
not active, the TX queue is stopped, and arrangements are made for
the queue to be restarted once hardware power is active again.

The fifth patch keeps the TX queue active during suspend.  This
isn't necessary for system suspend but it's important for runtime
suspend.

And the last patch makes it so we don't hold the hardware active
while the modem network device is open.

					-Alex

Alex Elder (6):
  net: ipa: enable wakeup in ipa_power_setup()
  net: ipa: distinguish system from runtime suspend
  net: ipa: re-enable transmit in PM WQ context
  net: ipa: ensure hardware has power in ipa_start_xmit()
  net: ipa: don't stop TX on suspend
  net: ipa: don't hold clock reference while netdev open

 drivers/net/ipa/ipa_clock.c | 49 ++++++++++++++++++++-----
 drivers/net/ipa/ipa_clock.h |  4 ++-
 drivers/net/ipa/ipa_main.c  |  6 +---
 drivers/net/ipa/ipa_modem.c | 72 +++++++++++++++++++++++++++++++++----
 4 files changed, 111 insertions(+), 20 deletions(-)

-- 
2.27.0

