Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28E7340738
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 14:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhCRNwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 09:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhCRNvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 09:51:45 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8644FC06175F
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 06:51:45 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id t6so4919067ilp.11
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 06:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2srrDw8cn09m+CV2vZOccq9oQbJCbgITCpC7n0jssaM=;
        b=e2JHlDJgWx0zcrRy/z17I7FHWHA7KPi8UnKHAHCM2AVU05M7dsE11gRjLHWtG5S22q
         3pQrzlsAbVANYt1FQ87RzcC3fD9SkISIMvFqHwHXXxPUWjyiCzTLBn4Fz8kC6Nq+VRSE
         0Op/f22pGJ3hQfFIo1c+wrizoMhV7xV/W5RUto4qX1e0xk0pX6ACKh6SqowpXJsSrcqt
         JOVH70LUaeemXOXNrEfwJh4qnP+rejK47GE8zYdCAkj8i/ohiB3IuYGDn6aG/J4QDoYP
         jobb776Lq4lLL7UiD5geDPoRHM/H/hLSljFkBSYknMhbowHMWW3mBVSYn1XPlLB5PI3q
         bOkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2srrDw8cn09m+CV2vZOccq9oQbJCbgITCpC7n0jssaM=;
        b=HmhYIErUTyWEcO5Zie4FLPA1l+4y1sJP5QBBeaNZMI+U+JoQHP2RjuBk/U/6TW+tez
         Pc/lYR1Efw4Zo/szFB1PYadu+crwrbGXoMoK9Yj0/MmYWu9icy3Kot1OBopBm/bDzqtI
         7WFxC5yzp870lhKRyku6NPg0s2/+ROD0PUmTCQDpCUGk9dpBZpGqidamCix3Rg2cezKs
         OzGcIpMROKqvvMnUFHZfI6PlcRkSmMD7ZXIBXLSr90n5vqjpCXpYxoxUseURSCjh14dK
         fOZtmRrnbQUBaanYg/H0Um4cKWHwmkDcRXPB2T0+Z/ggL8wkDv6TWeIWX4Vy5xrzRTH2
         XaIA==
X-Gm-Message-State: AOAM530IHxU+aGtfmSDjXMPtM4qEyUELj6WhIFF0Agm5ezThv8ecRKGt
        mYJEnVvi8icf17Ac9Rkj65Xo5A==
X-Google-Smtp-Source: ABdhPJyIjlzT4FYUwNwJvj3076RJHYILTzos3p5d4DOLPIIAyMmLTEBx0VOjpoQRVQxw8O0jomRcmQ==
X-Received: by 2002:a05:6e02:170c:: with SMTP id u12mr1712382ill.100.1616075504983;
        Thu, 18 Mar 2021 06:51:44 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j20sm1139377ilo.78.2021.03.18.06.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 06:51:44 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     f.fainelli@gmail.com, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/4] net: ipa: support 32-bit targets
Date:   Thu, 18 Mar 2021 08:51:37 -0500
Message-Id: <20210318135141.583977-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is currently a configuration dependency that restricts IPA to
be supported only on 64-bit machines.  There are only a few things
that really require that, and those are fixed in this series.  The
last patch in the series removes the CONFIG_64BIT build dependency
for IPA.

Version 2 of this series uses upper_32_bits() rather than creating
a new function to extract bits out of a DMA address.

					-Alex

Alex Elder (4):
  net: ipa: fix assumptions about DMA address size
  net: ipa: use upper_32_bits()
  net: ipa: fix table alignment requirement
  net: ipa: relax 64-bit build requirement

 drivers/net/ipa/Kconfig     |  2 +-
 drivers/net/ipa/gsi.c       |  4 ++--
 drivers/net/ipa/ipa_main.c  | 10 ++++++++--
 drivers/net/ipa/ipa_table.c | 34 ++++++++++++++++++++--------------
 4 files changed, 31 insertions(+), 19 deletions(-)

-- 
2.27.0

