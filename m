Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B0620E6A9
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404388AbgF2Vt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403992AbgF2VtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 17:49:23 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C970FC03E979
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:49:23 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k23so18796467iom.10
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=91uJCPWY40yp080C9abV8AzFhMu53zA/aJ8F5wWOkuU=;
        b=RUhcgaSJSs/MfSkSg9rU4uV7OcZSsmoBIDKyQHsQyzwX9fkvrynDdCasV10oHIdg6L
         6f+8u4GsclYo//VBlf2OzS0lZEMNJ2LJhlUheTxr+OR+nyLn/ZAPDlPwH98bX+AXWKoN
         bZkWLSrYo8vyfBwJOqv/lST2vDRbExuiLr2iH+De2515oZxVtqkY7YX+yLTRWVkaq88J
         idYpIUARPbxP/wjx3amjqpaBva43Y+IjVfuJ6coMla55Rnvn6eqQrKO9c7xKjvIdncfP
         kh56OYtieMeAlLeyiASQQF/otZQYsAL3N5NG98oe7RFGBBKfGgHALf9QN/cWt+6Ms9fS
         ZH9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=91uJCPWY40yp080C9abV8AzFhMu53zA/aJ8F5wWOkuU=;
        b=jc9ThkKAJ2rd5z9y2Qjcpod69DOwHI29rW8lIyyswtbNkApEZt/02m7n+dK0ZFB6jr
         DEPhx6f9o6fl2Naw1aCDaz3wi1hjq3JcXrve+fL5dqzIrP+dmN+Cz7GFGZurT4scx1IT
         +KnzuF+865sHhzB2FJA1sMixtKNu8CGWZ08SYmkueo/3wrkqA78ut6hBSzbYebNFq0Z7
         dxG2jpUBr29Y3cchobR0sSYV2El7ZAkNZXxx6k/m/DtcSj8IruXqNOSF1hYPiZ4xaYwU
         o1ZmHwQ61UhJvZuhzA+DsZsIfkxvYMM6b3uRlgr1mvsMUfnzN2CPsnotQsPmpd6zKVcz
         Okyw==
X-Gm-Message-State: AOAM533XJuZePhc6PRkAjK6ePSQj4oEaHHAzwKtJFjJxYMuWPRM+G2Jh
        QOZ2boZtvqjJnqKTbA9SBUjcsg==
X-Google-Smtp-Source: ABdhPJwQNFdv4C1BIHtucuzE+rmHeTny9QSofm/AZpFWTr8jo8WQDXgEAytHA2c0lUx0t+lNSQ8p4w==
X-Received: by 2002:a5d:8510:: with SMTP id q16mr2574310ion.81.1593467362912;
        Mon, 29 Jun 2020 14:49:22 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u10sm555500iow.38.2020.06.29.14.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 14:49:22 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/5] net: ipa: endpoint configuration updates
Date:   Mon, 29 Jun 2020 16:49:14 -0500
Message-Id: <20200629214919.1196017-1-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series updates code that configures IPA endpoints.  The changes
made mainly affect access to registers that are valid only for RX, or
only for TX endpoints.

The first three patches avoid writing endpoint registers if they are
not defined to be valid.  The fourth patch slightly modifies the
parameters for the offset macros used for these endpoint registers,
to make it explicit when only some endpoints are valid.

The last patch just tweaks one line of code so it uses a convention
used everywhere else in the driver.

					-Alex

Alex Elder (5):
  net: ipa: head-of-line block registers are RX only
  net: ipa: metadata_mask register is RX only
  net: ipa: mode register is TX only
  net: ipa: clarify endpoint register macro constraints
  net: ipa: HOL_BLOCK_EN_FMASK is a 1-bit mask

 drivers/net/ipa/ipa_endpoint.c | 26 ++++++++++++++------
 drivers/net/ipa/ipa_reg.h      | 43 ++++++++++++++++++++--------------
 2 files changed, 44 insertions(+), 25 deletions(-)

-- 
2.25.1

