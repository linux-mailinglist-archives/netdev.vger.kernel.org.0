Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D6F1C4385
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730703AbgEDR7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730692AbgEDR7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:59:08 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBE0C061A10
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 10:59:07 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id 23so507365qkf.0
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 10:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vqdw6T961NjpBgRT/XhyOu+dO0BOx3bSC8VPzWsBaf8=;
        b=XPPT51l7YVLzCOVDR8nXFLo0ll/gEhC+LGvA/j0yhs3ZktWvl0sAm3ZbfhvqTH3C/D
         ob0L3coYcB9BRxc3fZvibyxEE6yc6am6tRF7VR6G/N80RmcfUkKm+Dd3eVNcBoKTMkYj
         /Hq0E1m9fqBgPbBFdnr9j8qfc7mSf2egge2V/mVAOykoiw9QwObUn4IH9jPEYLFjSs+F
         TupT1A+dCMnVbX7hmJwpGXfzxkIaHlq8cT/EMPi48gSWtAUo8RDuh1Gq1v1dNMDgmiMv
         gUKFA1YpWXOqPL9yC3HmH5uy8dWiuR3v0/g78gPbreQidnKadkgNDdii6O0dTF8GoWXW
         e/lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vqdw6T961NjpBgRT/XhyOu+dO0BOx3bSC8VPzWsBaf8=;
        b=Hi1EnO8aF/vGYhIU1wPK2wUmJD7J2zcnlMi/UP21GgLYwaMmcTlBgAd1T86wAepv72
         XMglNPa2kI/Gq+aaSSM2wtKKOZoeX8ZDcC67utA9Xs/NhVDndWrE5qPQimW3jK2damUC
         bc89LitOj8P1ljCq8mvCwOr8DWOYG3kiXeGARXCCzugL9UO/mQjYipJY2NcT2AlRyGiD
         Bj+loPXkB/Bj/vqWQxG8o0T7m5PBCLp4Fu5rdHt9SHcsXqEqGVM91PTtNvnacrx2uivx
         RocMg0bT0oICSCfFjlZqQQ4QjG0jrqATAMc3Ier0fyzYfX9lIMoCzm3yxmnjLdgSe83k
         T4ZA==
X-Gm-Message-State: AGi0PuaqSFP4qiFVEjIaryeoUmN4B05paBpHWNJmtGpWZWexHRiUDwmw
        WlrpymXTD5NBZ/GXhh/f+7FUyQ==
X-Google-Smtp-Source: APiQypJJ+e8/no9p4zo1oA/7S8B1GlIpY1L/RkCv9O30uXiNL1i8dlLjNyWlL/9UZ7G1xUcxb/aAwA==
X-Received: by 2002:a37:8346:: with SMTP id f67mr367493qkd.283.1588615146701;
        Mon, 04 May 2020 10:59:06 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h19sm11271088qtk.78.2020.05.04.10.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 10:59:05 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        agross@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/4] net: ipa: I/O map SMEM and IMEM
Date:   Mon,  4 May 2020 12:58:55 -0500
Message-Id: <20200504175859.22606-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds the definition of two memory regions that must be
mapped for IPA to access through an SMMU.  It requires the SMMU to
be defined in the IPA node in the SoC's Device Tree file.

There is no change since version 1 to the content of the code in
these patches, *however* this time the first patch is an update to
the binding definition rather than an update to a DTS file.

					-Alex

Alex Elder (4):
  dt-bindings: net: add IPA iommus property
  net: ipa: redefine struct ipa_mem_data
  net: ipa: define IMEM memory region for IPA
  net: ipa: define SMEM memory region for IPA

 .../devicetree/bindings/net/qcom,ipa.yaml     |  10 +-
 drivers/net/ipa/ipa.h                         |  10 +
 drivers/net/ipa/ipa_data-sc7180.c             |  14 +-
 drivers/net/ipa/ipa_data-sdm845.c             |  14 +-
 drivers/net/ipa/ipa_data.h                    |  23 +-
 drivers/net/ipa/ipa_main.c                    |   2 +-
 drivers/net/ipa/ipa_mem.c                     | 209 +++++++++++++++++-
 drivers/net/ipa/ipa_mem.h                     |   3 +-
 8 files changed, 263 insertions(+), 22 deletions(-)

-- 
2.20.1

