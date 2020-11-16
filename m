Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4446A2B5530
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbgKPXiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729107AbgKPXiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 18:38:16 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEFAC0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:15 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id r9so19254090ioo.7
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aQxQuevMo4XJOrxy0MtHEby0bvtPkeA5dCIN/rQ7vi0=;
        b=iqnKIiCC8V4ANxUz7Bi0u1CYsqj+RtigJhWNL2dIqOyzHyy2yRLs9O1yitlf1Wa9Vr
         UjLjyfhk1CJB1yyoiq8ti9Zf33q4pO2DejSTshhwLBmdOQBaCNLG3Eewk5gBZgTcmd3p
         IOvC2pRgCT7F1HmskAFMZnvrD+ZgwObLYTo7gMK+Rg3GwnGEBwHjCJd1q0vLCixWvFXB
         5uCZZNM8H1V3EIYzQL3GLoHj2+zxvdUlZV9jMgUGj0FyhHtznV8fqqiKnuyUBPHZHePr
         D4RkP7/mgbIwkbtB+gCIeOggIdJ8dy+PT3xmdup0xRrFuXPK3A4QTy+1Zsnh81KcJubU
         TRTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aQxQuevMo4XJOrxy0MtHEby0bvtPkeA5dCIN/rQ7vi0=;
        b=h0GijfjvdVeBqmPUB82MHDKFBxuPa3JbjxKk7C9Jdh+t3YL0C126ZuFOzmOEhgPrIA
         xeoAPfjkhxDmo1R6tvWbSfz3txlH1KmBo0sHBVJ3ltinEyevSCGyLAXWBzY/miGnPKJ5
         h0mvfPOzBbzHH2woi756RbUKilrfrHs+wjX68C/VF5RoEh+ePZuGXXMS1iY5dlELALtL
         Zj2Opl0J9RuLscNCiUkeRQs97L7WD12gMS14trYXo409zlWLtZ0T30B5og4VHKAvwP0Y
         XaT5cR8SVWB3vRCiwWbY15hcUEFebQtrZ6honC+RTdB9HQ4uI79VusR2FD3+EjJse0vd
         cKiw==
X-Gm-Message-State: AOAM532UckJwRB3wCSrtVT3GfmWZO/NXVe20jdNZqRcE3jFMpkXqVIyf
        tW3WgRXeJYq1tk3Iw3i3dZnq7g==
X-Google-Smtp-Source: ABdhPJzTKZgfXbK7nhtHTtqS0yoseuKz5+XP6D3U7VO49YNMZH1CU8nmQF/TZxwod4403GdmGRqZLw==
X-Received: by 2002:a02:d85:: with SMTP id 127mr1520890jax.13.1605569895232;
        Mon, 16 Nov 2020 15:38:15 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f18sm10180099ill.22.2020.11.16.15.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 15:38:14 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 00/11] net: ipa: IPA register cleanup
Date:   Mon, 16 Nov 2020 17:37:54 -0600
Message-Id: <20201116233805.13775-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series consists of cleanup patches, almost entirely related to
the definitions for IPA registers.  Some comments are updated or
added to provide better information about defined IPA registers.
Other cleanups ensure symbol names and their assigned values are
defined consistently.  Some essentially duplicate definitions get
consolidated for simplicity.  In a few cases some minor bugs
(missing definitions) are fixed.  With these changes, all IPA
register offsets and associated field masks should be correct for
IPA versions 3.5.1, 4.0, 4.1, and 4.2.

					-Alex

Alex Elder (11):
  net: ipa: share field mask values for IPA hash registers
  net: ipa: make filter/routing hash enable register variable
  net: ipa: support more versions for HOLB timer
  net: ipa: fix two inconsistent IPA register names
  net: ipa: use _FMASK consistently
  net: ipa: fix BCR register field definitions
  net: ipa: define enumerated types consistently
  net: ipa: fix up IPA register comments
  net: ipa: rearrange a few IPA register definitions
  net: ipa: move definition of enum ipa_irq_id
  net: ipa: a few last IPA register cleanups

 drivers/net/ipa/gsi.h           |  20 +--
 drivers/net/ipa/gsi_reg.h       |  25 ++-
 drivers/net/ipa/ipa_cmd.c       |   6 +-
 drivers/net/ipa/ipa_cmd.h       |  21 ++-
 drivers/net/ipa/ipa_endpoint.c  |  10 +-
 drivers/net/ipa/ipa_endpoint.h  |   2 +-
 drivers/net/ipa/ipa_interrupt.c |   6 +-
 drivers/net/ipa/ipa_interrupt.h |  16 --
 drivers/net/ipa/ipa_main.c      |  15 +-
 drivers/net/ipa/ipa_qmi_msg.h   |  12 +-
 drivers/net/ipa/ipa_reg.h       | 297 +++++++++++++++++++-------------
 drivers/net/ipa/ipa_table.c     |   4 +-
 drivers/net/ipa/ipa_uc.c        |  43 +++--
 13 files changed, 266 insertions(+), 211 deletions(-)

-- 
2.20.1

