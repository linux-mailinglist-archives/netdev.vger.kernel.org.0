Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E322140C0
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 23:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgGCVXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 17:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbgGCVXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 17:23:39 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBEBC08C5DD
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 14:23:39 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q3so17577485ilt.8
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 14:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gx3ro+7hYW73BWz9veCWu8rMHewSiF/ZuzOQ8imNba4=;
        b=elRomxe6h/jBmzyLMRms1Eo1Wmjjplls52Em3UQshvd5ZV7fwFe5+QzTScbvFQJWaU
         TD5tUxrFaRikuu4NUaX4/K/vcq/caScUom3pqtTdhfmvc/PbjhnWsnI4vPCWdP0ZN1eE
         49wom30XEmZgkJGkDiO0wdRXhX8T1E0jsu/MvtRFALXQ7fgp3iBN6OnutICOIceOI/IF
         ubQW6iog4YqwzZo7SBTH80l44owqsmQzU16t2BS22OAS9HzcPDWSsNZeRkEU+wXWISyi
         gGVZIh5FDMLS7k3EGp9tD4xDr5gLo50RgGI4YMEBd8o9bkwQ1BeKp/626JCPCE966O2p
         8z0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gx3ro+7hYW73BWz9veCWu8rMHewSiF/ZuzOQ8imNba4=;
        b=cDizwXM2ebUY5sn6zXuBQcN48WLfKbQHPRsWlT9RMZNsKNhaE9wWNpFnJFBKE54459
         D9qxOX3o1AddVwFUM12E584/BQD0RGDozjq9gCkZSO6MEskcNABGFoRm3WVuvzfeCL20
         J5DKrodvheair/epCehDndrSAwTFkY/HynIj39a16bRjoAZFoDzND3zgvGsDFgohYYrj
         r8dp6Qv3q5m25nqHN0Joz1T7Xv8/qyLrIYyMtHrerNyU8r2TwKfPCSGG8kiqSBu38wKD
         FQNBkvOyiAKvJNKzVamzA+PlwAgMXx5h+1kOOqHc494x0k8cRFNXZBSm3DifvNnwuXTH
         dEpA==
X-Gm-Message-State: AOAM533HfmTZVV9D5/crmKWC0Ixxu+IKzBbUu/ALd1lS8cicBDNVpy9e
        1MmDsKZF2iHXk3ngG53z1tF1sQ==
X-Google-Smtp-Source: ABdhPJwcM+deFPGS0PFDYtDoLUKkJy5L2HHjjmyFwapVXGkF6ri+O5PSIi3EReCFe9Av4KUldXtlxA==
X-Received: by 2002:a92:50f:: with SMTP id q15mr20125796ile.38.1593811418307;
        Fri, 03 Jul 2020 14:23:38 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m6sm7485292ilb.39.2020.07.03.14.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 14:23:37 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] net: ipa: fix HOLB timer register use
Date:   Fri,  3 Jul 2020 16:23:33 -0500
Message-Id: <20200703212335.465355-1-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function ipa_reg_init_hol_block_timer_val() generates the value
to write into the HOL_BLOCK_TIMER endpoint configuration register,
to represent a given timeout value (in microseconds).  It only
supports a timer value of 0 though, in part because that's
sufficient, but mainly because there was some confusion about
how the register is formatted in newer hardware.

I got clarification about the register format, so this series fixes 
ipa_reg_init_hol_block_timer_val() to work for any supported delay
value.

The delay is based on the IPA core clock, so determining the value
to write for a given period requires access to the current core
clock rate.  So the first patch just creates a new function to
provide that.

					-Alex

Alex Elder (2):
  net: ipa: introduce ipa_clock_rate()
  net: ipa: fix HOLB timer calculation

 drivers/net/ipa/ipa_clock.c    |  6 +++
 drivers/net/ipa/ipa_clock.h    |  8 ++++
 drivers/net/ipa/ipa_endpoint.c | 78 +++++++++++++++++++---------------
 3 files changed, 57 insertions(+), 35 deletions(-)

-- 
2.25.1

