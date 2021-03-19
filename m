Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A834D3420E1
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhCSPY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbhCSPY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:24:27 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EA2C06175F
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:24:26 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id v17so6489087iot.6
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xeyO8ujnhLSKg2G2vTkf8OieiuVk1+Co5vEHfYuss8E=;
        b=CHDNOifZ8tkzQRyRNcZaseJlM/TyTZxtWvBGDNk8/Mt5sSdDQpnAbvkv6cwqD4P1Vu
         tPuzqX7dFTLWdF6sEAGKTj6fpclXpzWdYpn3Ik8OvD/pGe1wClp1UqyuvhOsJeLbwAgO
         +r0O7vkkicWi8OzfJzQRP/bkGYen+jvCwcfiC3ZdxAA4Kh+L9yEnE0c+SZErOCeCBfTA
         zl/YTWWgDkh6uxMHSGiledmerDZxAbsOlbGQ/Ak6zp8agv6my66gkEAb/5bvtck7raHQ
         qPttxTLaTghjwmYtRmDXiScyTTHTT/daE3DUmVS2mdtZI6WUEEotU16i0ERqecHDewTm
         PWVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xeyO8ujnhLSKg2G2vTkf8OieiuVk1+Co5vEHfYuss8E=;
        b=SxBNvN5L8D9nCRcn59H+dZ93daAG4GUyB6CB9Yvq+eT4vWZU7RdYwb/4y1h/CSNpZv
         gt7PiLZnCZ5u5yH4HkamQfBhQTpYH+GLZ/oZgFO7St50pg85eFKBf28IcWVebVI/oq9+
         PneGUrEx/TeymXNO8dAV0vUIR7fehbhQjuRRNbKpP8hAOCtuJCw+MlBrDwNjvOS9EAv1
         c3ArsjHDU2uRXWpgYBHffR7bRnQqlKKscPfeXzgZ2GoZChtyHOmzcQY33RX1Z4AgSpnt
         LCfLNjscuMr0ERQySxzquW3MjgS+O4Q1OUGcP+J1UepmZcfOHNFlfj+iUkbw0qEdwode
         pFew==
X-Gm-Message-State: AOAM533sQL3AFMXLDL03v7DeZDppP29LphOWsvN222XiMuKoMBdyg6Ec
        x7n8omc5bX+VIdCH4kcodS5nwg==
X-Google-Smtp-Source: ABdhPJyVn9TYqxOHgnUHtx1xCuE7iRrmYMdgwMUd05PYidhO6ofoPFqBCyiBiF56rn860iD8QyUoeQ==
X-Received: by 2002:a02:661c:: with SMTP id k28mr1862704jac.78.1616167465540;
        Fri, 19 Mar 2021 08:24:25 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id b5sm2686887ioq.7.2021.03.19.08.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 08:24:25 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/5] net: ipa: update configuration data
Date:   Fri, 19 Mar 2021 10:24:17 -0500
Message-Id: <20210319152422.1803714-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each IPA version has a "data" file defining how various things are
configured.  This series gathers a few updates to this information:
  - The first patch makes all configuration data constant
  - The second fixes an incorrect (but seemingly harmless) value
  - The third simplifies things a bit by using implicit zero
    initialization for memory regions that are empty
  - The fourth adds definitions for memory regions that exist but
    are not yet used
  - The fifth use configuration data rather than conditional code to
    set some bus parameters

					-Alex

Alex Elder (5):
  net: ipa: make all configuration data constant
  net: ipa: fix canary count for SC7180 UC_INFO region
  net: ipa: don't define empty memory regions
  net: ipa: define some new memory regions
  net: ipa: define QSB limits in configuration data

 drivers/net/ipa/ipa_data-sc7180.c | 30 +++++++++++++++---------------
 drivers/net/ipa/ipa_data-sdm845.c | 25 +++++++++++++++++--------
 drivers/net/ipa/ipa_data.h        | 24 ++++++++++++++++++++++--
 drivers/net/ipa/ipa_mem.h         | 10 +++++++++-
 drivers/net/ipa/ipa_qmi.c         |  2 +-
 5 files changed, 64 insertions(+), 27 deletions(-)

-- 
2.27.0

