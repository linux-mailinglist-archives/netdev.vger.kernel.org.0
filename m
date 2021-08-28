Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71DD3FA6F4
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 19:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhH1RSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 13:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbhH1RSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 13:18:44 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474C5C061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 10:17:53 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id m28so21457565lfj.6
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 10:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=05j2l6Hyki8LMLklwiWUO0QmhsP9+wJVLQtHgOjN+sw=;
        b=l6M4OnxZZnGyvHpe5cjzx0MXrHoqwceEiP7K5jgU4a8GO43rdOmmLNtJ+cFHm5yG4V
         btn4zoqAxQWtI/9t/BrG+hvxXYSDSvbaRjhhfmX19a6wkRjGDnxFUMKwwov5881ltNTS
         mv6zaGiO5XRaEAKHR3UEYo4hBd4YX9XaRbotrKTNGaDZavEDNda5HYqNz9i47GnUQmK9
         UBxWlMRnaPNlLtunfkwtvAQcZS24qUD5KsRFfarpIuN+Q9Z4SyiuN8LzHz5DL0Q7bGiS
         fE8UZTeS5qVz0hM5IFXVUXEF3ofVSgAaM89hhSbfZT4b9K5SC5jtlcKMFYvJMZ3pZ8hd
         J+lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=05j2l6Hyki8LMLklwiWUO0QmhsP9+wJVLQtHgOjN+sw=;
        b=gXzFvK7ukb13qa/Qy4js2H6jZCweJzmpYmpo7oHpLflc6sHLLBm6yFRAUtMqjWz9J3
         gSA+moh+NAMbVDDNL64O44L/j858TOf4RrhdtXn5eD/Maag8IziWmdOfLFcBgIvOKu5s
         LQSPzDPbLtxMAEYC4QUAdWAWZ0xbxkKkEG+DPyNQIQ9QK4KrnWfi/ioSbQ/Hg5RxLQ72
         Ia20vB5wfffiPReENY8+1yAaf9XSxrpdelnqY6klnUuywnts6d+5H2uvjTHVCct7E8uG
         zo0kIx0xZv/sJAOhBIo8lub0c/zbeZ54HTNxZNyiITV9FFhHxDH4ewlID2CdlI7NzgpI
         +Dsw==
X-Gm-Message-State: AOAM533qncFogoMv114Z2x6ixwuzKM1jJUJ5osTJsRPYfStbu5X0Q54P
        iFsR9X6Uk+oB1UanFBv414vHQYj/JchpMQ==
X-Google-Smtp-Source: ABdhPJzRFAo442wZ2JzOTwicKoCsl5r0HbgiU/HMzd3T6jFgucMdvzfz8j0bmJ93F4b0gcvzHX+VHQ==
X-Received: by 2002:a05:6512:132a:: with SMTP id x42mr10735390lfu.210.1630171071503;
        Sat, 28 Aug 2021 10:17:51 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id p1sm202195lfo.255.2021.08.28.10.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 10:17:51 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 0/5 v3] IXP46x PTP Timer clean-up and DT
Date:   Sat, 28 Aug 2021 19:15:43 +0200
Message-Id: <20210828171548.143057-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ChangeLog v2->v3:

- Dropped the patch enabling compile tests: we are still dependent
  on some machine-specific headers. The plan is to get rid of this
  after device tree conversion. We include one of the compile testing
  fixes anyway, because it is nice to have fixed.

- Rebased on the latest net-next

Arnd Bergmann (2):
  ixp4xx_eth: make ptp support a platform driver
  ixp4xx_eth: fix compile-testing

Linus Walleij (3):
  ixp4xx_eth: Stop referring to GPIOs
  ixp4xx_eth: Add devicetree bindings
  ixp4xx_eth: Probe the PTP module from the device tree

 .../bindings/net/intel,ixp46x-ptp-timer.yaml  |  54 ++++++++
 arch/arm/mach-ixp4xx/common.c                 |  14 ++
 drivers/net/ethernet/xscale/Kconfig           |   4 +-
 drivers/net/ethernet/xscale/Makefile          |   6 +-
 drivers/net/ethernet/xscale/ixp46x_ts.h       |  13 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c      |  35 +++--
 drivers/net/ethernet/xscale/ptp_ixp46x.c      | 122 +++++++++---------
 7 files changed, 171 insertions(+), 77 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/intel,ixp46x-ptp-timer.yaml

-- 
2.31.1

