Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0073B2F7A96
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 13:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732003AbhAOMvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 07:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387689AbhAOMve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 07:51:34 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADB3C0613C1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:50:54 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id w18so17884302iot.0
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fDHUO4MEuX+tZMwIcw55R/Dlc8/Cyt45IHiITIJj9Qo=;
        b=EL+jOdl5+XC0YfgY+/uV0wfn2boaD2cdnHfolEevx29xnLOIIBR2IsEQ/D9DeZtHTW
         SIowklpDYcevXbN9uQga4G1ZajzhtyRrMW1q41S05otkZZZADUKfxqcotw24cf+OBm9T
         +9plfL0ULuOyZ8LDhqsT6u5Ma1w38A/eI2jif5dLo2fYwW3BbMs71tPN3608qfGuj2jS
         w9CkwOrHmLZCy7Q/T4u7ojc0zTQY9qdflbHYmECOQwJauul+z4uhZ1XjMzN/9uyLK1t/
         CRxwD4Z4LA5ULSlON0fiMI6tQrXx/viNFhFJuJ2bXxY7WGKGnjHo12ObCUNhJG3rBdYA
         xURQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fDHUO4MEuX+tZMwIcw55R/Dlc8/Cyt45IHiITIJj9Qo=;
        b=LAng4aLwPKZGrHL0YJYviGpljkQLyqjQkPxbDXZ86gm+Ybo5vqf6OB7/R0Cw/gZfkE
         DaXC97y9bOTiBRzUm9baD4xLgB/++a//BHF6vts2MDCk22ioW9u0h+Kt4jlGjcxxTBwm
         we7SWSB+Qxx45Ig6ic8RhLlL6PiimZ8SuPlHQG+3Bi6zA5WKSfEDB8ACZRg018g9adYz
         jHSzs/tMIP8c51ThUvpExcZ18EIa63PzwN0c0BUK+h2JZWFnyvqPHZNDx/VDga+mIyfV
         LRFLUZm2q7pv7U5TPolJ5hqaaZWELdLmRJEaf7QnCLGwFAc7d5oyej2XuLQxJhQ0R3ng
         RZQQ==
X-Gm-Message-State: AOAM532bt37LxVj7PaPmLq6g1rjF9K7bEbWwiHVHlLP9Ha/iuHs3QZ7n
        YMVwlxrywgK+Ou5E3w9XN4BjGQ==
X-Google-Smtp-Source: ABdhPJy0qanQnkgMlp7j6BgexRzdZFlT16rf/RMegopbSjS972qvzEa3nEEwI45A0xhEmU36tD1guQ==
X-Received: by 2002:a05:6638:14d5:: with SMTP id l21mr10154007jak.54.1610715053724;
        Fri, 15 Jan 2021 04:50:53 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f13sm3952450iog.18.2021.01.15.04.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 04:50:53 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/7] net: ipa: interconnect improvements
Date:   Fri, 15 Jan 2021 06:50:43 -0600
Message-Id: <20210115125050.20555-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main outcome of this series is to allow the number of
interconnects used by the IPA to differ from the three that
are implemented now.  With this series in place, any number
of interconnects can now be used, all specified in the
configuration data for a specific platform.

A few minor interconnect-related cleanups are implemented as well.

					-Alex

Alex Elder (7):
  net: ipa: rename interconnect settings
  net: ipa: don't return an error from ipa_interconnect_disable()
  net: ipa: introduce an IPA interconnect structure
  net: ipa: store average and peak interconnect bandwidth
  net: ipa: add interconnect name to configuration data
  net: ipa: clean up interconnect initialization
  net: ipa: allow arbitrary number of interconnects

 drivers/net/ipa/ipa_clock.c       | 192 ++++++++++++++++--------------
 drivers/net/ipa/ipa_data-sc7180.c |  38 +++---
 drivers/net/ipa/ipa_data-sdm845.c |  38 +++---
 drivers/net/ipa/ipa_data.h        |  26 ++--
 4 files changed, 157 insertions(+), 137 deletions(-)

-- 
2.20.1

