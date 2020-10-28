Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FEC29D38D
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgJ1VoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgJ1VoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:44:15 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EA1C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 14:44:15 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id l2so481202qkf.0
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 14:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qYJByRHMFm7d3rnuGtDQ0bsC4ppOIDZCGwtSE2xp/Zg=;
        b=zoADobpW0XteTjyGN+dbeom+s+0NSVnJIq35xkFBIEy2WWd07G2MJoiJfDcc8EccgU
         /K4jmD8dUhslurWwExe/gmM/1ixn6e3VHfhAdw2hc/ekN6G4ha66Eim6lNhv0pTO31D1
         qU2hYtXmCfvVXIx2NacpIuVfJUue0zYL1OGloEFCR4qfQiiO0d10NmRDpzOoaxuJw3nF
         DeOJNpVwDwQjMjp+ZgeeIFLOrgDsySY6PCTV6IMsYICCkX0Vc4yJQjZ2/vKQ4KHrc6qX
         XODGnY45tIEVynLiSlN9Pc7RgyDKD8BmCb2mkUlzPEn2mFwSFfrIGmgBM1eRWsWxnIS6
         8DLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qYJByRHMFm7d3rnuGtDQ0bsC4ppOIDZCGwtSE2xp/Zg=;
        b=YEDFb6V7pdqVXSrQss2qGtzgQHbkLHq9Xvtyu8WlNBaHaWmqxTxm+rcZzpqJXIgUdT
         XwqW+N/4Qtewr7U+gvh1Cxg9RKNxqLIrboN8VBYIHQtgNW0Z95YY1vKGcieexQjI6y1J
         Pm3D4BvEyvvLmpR0lHi1ccBkmpSAUrVyMq3nlU3L15BMU2XWXWRm8YFItyen8A4RfC6m
         bkftRJbXkMr4VByOPmSrCDemnvZaSGBtwjVGJ/4tnMnWbCFHX2OsNhEcRD5n/6+QxE7t
         crEzTqVJur4AllqKO8vfkpJHfLn96fr+CJ5o0KJqUtNMDafc435ymlg4Yws9IW+yjuJx
         eE1Q==
X-Gm-Message-State: AOAM53042q+a9QiCSz835tURhqJdyIp77pKhl8VkMsNCSc1FOBPTUFKW
        JoagUcLODZaUiIgtKyY1BwhNiR2sff1diTy/
X-Google-Smtp-Source: ABdhPJwRJf1fbzux1MxHDO4rL3dpJNipUdVsNYXh03Kn2EO+GzRfePD8gOzoRgQMRnKGKW580mrGSQ==
X-Received: by 2002:a02:3f59:: with SMTP id c25mr699137jaf.17.1603914113353;
        Wed, 28 Oct 2020 12:41:53 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m66sm359828ill.69.2020.10.28.12.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 12:41:51 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        sujitka@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 0/5] net: ipa: minor bug fixes
Date:   Wed, 28 Oct 2020 14:41:43 -0500
Message-Id: <20201028194148.6659-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes several bugs.  They are minor, in that the code
currently works on supported platforms even without these patches
applied, but they're bugs nevertheless and should be fixed.

Version 2 improves the commit message for the fourth patch.  It also
fixes a bug in two spots in the last patch.  Both of these changes
were suggested by Willem de Bruijn.

					-Alex

Alex Elder (5):
  net: ipa: assign proper packet context base
  net: ipa: fix resource group field mask definition
  net: ipa: assign endpoint to a resource group
  net: ipa: distinguish between resource group types
  net: ipa: avoid going past end of resource group array

 drivers/net/ipa/ipa_data-sc7180.c |   4 +
 drivers/net/ipa/ipa_data-sdm845.c |   4 +
 drivers/net/ipa/ipa_data.h        |  12 +--
 drivers/net/ipa/ipa_endpoint.c    |  11 +++
 drivers/net/ipa/ipa_main.c        | 121 +++++++++++++++---------------
 drivers/net/ipa/ipa_mem.c         |   2 +-
 drivers/net/ipa/ipa_reg.h         |  48 +++++++++++-
 7 files changed, 136 insertions(+), 66 deletions(-)

-- 
2.20.1

