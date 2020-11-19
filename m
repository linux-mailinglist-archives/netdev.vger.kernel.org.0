Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611FD2B9DBE
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgKSWlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgKSWks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:40:48 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0D5C0613D4
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:40:47 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id q1so6868534ilt.6
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zQgreXCJuSuepNrd3doq5Cr/tgHS4kfcVAxx00EmOxk=;
        b=BknQd+FZoXTsgxPssibV2NDRqw59fYbfQzG6T/GtXXS3671AmyLkgcK+tujcTwC/JE
         XkmNn0B5gL6lxy64MQVTUyPQLdwc2SbHbV7n0kTWd0bkKE1YYqBEugLKUG2yoLgfSt/n
         UPgP0drFVbtyclS5O52viYrxefhrkfhnvIews/nOzkm1XSVjGfZhU4VD3xHr/F1gIcIX
         1D1cvfcwT9R9DAjfOC/Y7EBYDqnZLM2KijdMEM5QRH5pqdf8sKf/HWD7MeOaANT+Leyb
         49UcGQXiA5clvZFinLzAvOXMQxgX0IGD3jOyfhjJV3yu+GpJu/4lrVgsXYQ4AxFHn4lN
         s0pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zQgreXCJuSuepNrd3doq5Cr/tgHS4kfcVAxx00EmOxk=;
        b=KZ/y7U/zx7+CbgOdGgaLLuT7gzp3n1KRXJUFC8yAymTTejDwUHwytTAkRdJ/bQZ1ji
         g9lWnDI/eQ+/TuHmcGTTqMeTEqH5ThykiMVfnPqykBINLBl41vfBax8ArwcSkfPQffI+
         vaiOZNHaVX1fIXd6TM0svz7w4UqRxDMQ3zttstGnC3AC1Q9rdmxvVBaFLnL+nJErNpiG
         5l+OH5VHVmaX81FOLCcoUfZm9D6Kc0ydGwq9ywtoavSwlZSlNan2xyieMcJIH1RdIT0z
         WFfQ/4CeLNg5ljfSAyKQx8snoUqWq0ZcznniEbzS5auCV+0Mpmm6+cbZq4Tx5hfQPbcO
         klAg==
X-Gm-Message-State: AOAM532GLegpFVAyI1yPmlv8E9R4VC4PFVNg/ShbC6W1di7ZLsM64SH5
        TUmlyM19g3pSjErlUQVzcYHaTQ==
X-Google-Smtp-Source: ABdhPJxq2fl66mfK0kgsTMTlhRySbGV9R77h2UVWbtfgPFczjWiRpgylI2+eiAKmk9yBzIY7gmF+fg==
X-Received: by 2002:a92:c8c4:: with SMTP id c4mr23958382ilq.161.1605825646224;
        Thu, 19 Nov 2020 14:40:46 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id b4sm587797ile.13.2020.11.19.14.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 14:40:45 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] net: ipa: platform-specific clock and interconnect rates
Date:   Thu, 19 Nov 2020 16:40:38 -0600
Message-Id: <20201119224041.16066-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series changes the way the IPA core clock rate and the
bandwidth parameters for interconnects are specified.  Previously
these were specified with hard-wired constants, with the same values
used for the SDM845 and SC7180 platforms.  Now these parameters are
recorded in platform-specific configuration data.

For the SC7180 this means we use an all-new core clock rate and
interconnect parameters.

Additionally, while developing this I learned that the average
bandwidth setting for two of the interconnects is ignored (on both
platforms).  Zero is now used explicitly as that unused bandwidth
value.  This means the SDM845 bandwidth settings are also changed
by this series.

					-Alex

Alex Elder (3):
  net: ipa: define clock and interconnect data
  net: ipa: populate clock and interconnect data
  net: ipa: use config data for clocking

 drivers/net/ipa/ipa_clock.c       | 47 +++++++++++++++++--------------
 drivers/net/ipa/ipa_clock.h       |  5 +++-
 drivers/net/ipa/ipa_data-sc7180.c | 21 ++++++++++++++
 drivers/net/ipa/ipa_data-sdm845.c | 21 ++++++++++++++
 drivers/net/ipa/ipa_data.h        | 31 +++++++++++++++++++-
 drivers/net/ipa/ipa_main.c        | 21 +++++++-------
 6 files changed, 112 insertions(+), 34 deletions(-)

-- 
2.20.1

