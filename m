Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51A92C494B
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 21:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730840AbgKYUpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 15:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730809AbgKYUpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 15:45:49 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFAFC061A4F
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 12:45:30 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id o8so3491383ioh.0
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 12:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iARHdXB4BjlKr8lKVPpRSW/v+HxRAjAiiqqGZKt4F6k=;
        b=b9a6D6l42YwbuuSMR4N6CLITYQo9x+GiWOsttkkklpezEAC7KU021iJPNtvRFqWoGU
         K6s+Ogfjf7bdvG1X0TGZ116EQWNkNPrJ4anG/b9abF4npbzgJNZogjT1JhPIriiGlsc7
         4xPF47Z8gqta3JWI9C8QdLOFwok/I/ImqibVvEfDc20OLJPN4O8CDcItkvWmO14PuY7b
         WgV0qXX7fz48XlZnLpL01Erwo5uprwLp7S2JJNrP5tWSLqIfaiw5E85+X1UR4hDyVzqC
         KqIXrz3038xQ4IPQJaxTlfX/4WIvlxTv5qHYZnRO7xihBNnRZzhX+2/7YCGkvQs2sol1
         IRhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iARHdXB4BjlKr8lKVPpRSW/v+HxRAjAiiqqGZKt4F6k=;
        b=nzsIV0i7Doi+HeYgyybFDLrOhTp+ybDZcaJDEPHppYm+OTx1WaexVNmSpt6imtehtW
         /UvDUBZX9mzLUYV/Bpv44qwj1m2Fsdgj4GA1BiCvoE+S1anaWixjOkt/+TpX1aeCFiZ5
         Cb0swuaZ1oD94CmiMaN0KlkYPIu5KgInslCL5hQw/0c2+hW5BcNmNsenP1e6wWVtgK/i
         E8rxcEwvRMUQceb7AkXr1GZ1GgMR9ono2cBdcedsNAC/E1T1X7sErRNJ1ttPUj0s4ZC8
         V7rzqWNpvOKMgBuz7+u8Up6I2Ivoj5XtHOK+gW7oEltrcNFcXSeIpRNZVuu4HAYSBDPC
         ikeA==
X-Gm-Message-State: AOAM531RciM8Wmh4WOwOn+n3KJcJ55zX5HrMODUPBvEOagzT8w/c0OTG
        aN8W9ZMOA3vyWlsDzu6Ausrmgw==
X-Google-Smtp-Source: ABdhPJyFDzBQ1RLQ/qoQYvQBu4Ei9KetC8KikgrmDbAVP9cTYlMzRy12ns6CZO3N/TxJFaSv1BJhLA==
X-Received: by 2002:a05:6638:15a:: with SMTP id y26mr4986988jao.57.1606337127097;
        Wed, 25 Nov 2020 12:45:27 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n10sm1462225iom.36.2020.11.25.12.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 12:45:26 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/6] net: ipa: start adding IPA v4.5 support
Date:   Wed, 25 Nov 2020 14:45:16 -0600
Message-Id: <20201125204522.5884-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series starts updating the IPA code to support IPA hardware
version 4.5.

The first patch fixes a problem found while preparing these updates.
Testing shows the code works with or without the change, and with
the fix the code matches "downstream" Qualcomm code.

The second patch updates the definitions for IPA register offsets
and field masks to reflect the changes that come with IPA v4.5.  A
few register updates have been deferred until later, because making
use of them involves some nontrivial code updates.

One type of change that IPA v4.5 brings is expanding the range of
certain configuration values.  High-order bits are added in a few
cases, and the third patch implements the code changes necessary to
use those newly available bits.

The fourth patch implements several fairly minor changes to the code
required for IPA v4.5 support.

The last two patches implement changes to the GSI registers used for
IPA.  Almost none of the registers change, but the range of memory
in which most of the GSI registers is located is shifted by a fixed
amount.  The fifth patch updates the GSI register definitions, and
the last patch implements the memory shift for IPA v4.5.

					-Alex

Alex Elder (6):
  net: ipa: reverse logic on escape buffer use
  net: ipa: update IPA registers for IPA v4.5
  net: ipa: add new most-significant bits to registers
  net: ipa: add support to code for IPA v4.5
  net: ipa: update gsi registers for IPA v4.5
  net: ipa: adjust GSI register addresses

 drivers/net/ipa/gsi.c          | 35 ++++++++++++---
 drivers/net/ipa/gsi_reg.h      | 24 ++++++++++
 drivers/net/ipa/ipa_endpoint.c | 49 ++++++++++++++------
 drivers/net/ipa/ipa_main.c     | 76 +++++++++++++++++++++----------
 drivers/net/ipa/ipa_reg.h      | 81 ++++++++++++++++++++++++++++++++--
 drivers/net/ipa/ipa_version.h  |  1 +
 6 files changed, 220 insertions(+), 46 deletions(-)

-- 
2.20.1

