Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54761F5C45
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 21:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730331AbgFJTxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 15:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbgFJTxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 15:53:48 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002E6C03E96F
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 12:53:47 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id m81so3733282ioa.1
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 12:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O7/TXfQZ+QnJiUEUdXBEq+AyXg2ISr3BLixo9khgkNk=;
        b=h8JQPbsbyoHWB2WjYedvvxIu3PJTMuBU2jVyhL4S1VpuhuiyVsHrVa+hkbVVJ2dkCb
         84dUHwmLQ7+Lm2npW9DNjosCPg+h/syEzBmIA3pbXy478Oes03vPm3ylkhvG+vxjTcU2
         Z9sNOJzhP+FHSyndzewU/AhVy0+EnPnO709/Dvk80GSuCZdXaf/VkP8mmt991AKEpCP/
         vlfNJTjQqqzB8ORXCbHgSPN/kwXoP/KqGvvs9rh0IgRgh0TOdiFGujNE15my9X06/PV6
         Z1ZLCpAWbGKLtQweD4e29VFcQQOssH1S2gLtEITECZrkCyu7yQUPmleWbWbql01VahXK
         y0yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O7/TXfQZ+QnJiUEUdXBEq+AyXg2ISr3BLixo9khgkNk=;
        b=DIfYmLsWB8P5W3xnVb4Ox5WJRuWfQ3ab0aepfTLd5G9pvmmVrrtaVygK+1leLUYc50
         JfJMe4OTMZluhSYZlGyOuVZH42nO5gj2z5W1S5SNps1SRXE8PNN1UIu8hvyg+KfKB0jv
         sQbNNfbpM6x7xzu2Grag+49VlEjd4DXcnk+0feZeurTudClpZ2zIRI7bHTrFuVofuk+5
         KoZ2+RhzJDU9HrZ+1D+zK5/FW71XbZCINzH1GQ3X4bWqzqkiJPHQYrvQ4iQbNT+PEigG
         t0/qdH4ubCB8saQ7R3m1EioH7IjVLNBBjDGKK5lrH3jznwiP7iJSJiFsWF1DmyWBga3W
         jcRQ==
X-Gm-Message-State: AOAM530/eiJV9rfTt0xOL/ltTOC1dZD6QXDyTH1/e/UXzcPSas07l2vV
        gf+DdtVxEsHg7Y28i5JpVgpe3Q==
X-Google-Smtp-Source: ABdhPJy6JWIFDBX/oG+bShtNLcHYuInCmW4DpTZXDTg/DHaZKUZGnJyPYPT79FJPZnUuQHFZQogh7A==
X-Received: by 2002:a5e:dd0a:: with SMTP id t10mr5148449iop.9.1591818827078;
        Wed, 10 Jun 2020 12:53:47 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id r10sm408828ile.36.2020.06.10.12.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 12:53:46 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 0/5] net: ipa: endpoint configuration fixes
Date:   Wed, 10 Jun 2020 14:53:27 -0500
Message-Id: <20200610195332.2612233-1-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes four bugs in the configuration of IPA endpoints.
See the description of each for more information.  The last patch
changes a BUILD_BUG_ON() call into a runtime warning, because
violating the checked condition does not consitute a real bug.

					-Alex

Alex Elder (5):
  net: ipa: program metadata mask differently
  net: ipa: fix modem LAN RX endpoint id
  net: ipa: program upper nibbles of sequencer type
  net: ipa: header pad field only valid for AP->modem endpoint
  net: ipa: warn if gsi_trans structure is too big

 drivers/net/ipa/ipa_data-sc7180.c |  2 +-
 drivers/net/ipa/ipa_endpoint.c    | 97 ++++++++++++++++++-------------
 drivers/net/ipa/ipa_main.c        |  7 ++-
 drivers/net/ipa/ipa_reg.h         |  2 +
 4 files changed, 65 insertions(+), 43 deletions(-)

-- 
2.25.1

