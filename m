Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2D83D8F06
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 15:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236334AbhG1N3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 09:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbhG1N3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 09:29:10 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E630C061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 06:29:08 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id n12so2578653wrr.2
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 06:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=LQCoZj4nUTe1FLvp5O7rprBx8ufeBQm/FjsSn1lIrsw=;
        b=T/yoo/14jojopC4jJ/+AwUEJFwZDi5O56yoPsF63MR8W5/MzRgfpfvHiZ6FvhUvpPl
         Kg7xZou6j9wOuW/oG4IAgZ7gOtN4pzTRzL+XVWvUk3SyWDVwhLlOpHgkPdho0LEptKlY
         fsvu7ZfM+FzLB0Bw783ByDJQM1RNwn1eVPfyTlwqH7/6G87btGnpWzNnc83Q9aGFkTKX
         Ybc0kMpRwsJgMQeVaGoctrw0ZvuQjp/Xf0aGC3CCJ25/zpCkk7su4+qBs3MZIOSvvZy4
         srk0W0opfJhgwWLQTCk7gjmZInLiEas7LbfbtQ0FQW/DbdQ3AKTapjfruyMmIhyE8vGa
         PT0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LQCoZj4nUTe1FLvp5O7rprBx8ufeBQm/FjsSn1lIrsw=;
        b=MGK+LzFIfc7w6iekbbSVTWcZBDn1nIeLKGWEB1wCsrHNt+NMTGrk6S7PRd6YiqwRYc
         hC/SUvjBzK+AJ+qvvm3AcbI1yTdDEFIi8CbOm26M9RnqpXOiI8wdtqaBCS2i1AnxJ2IR
         mJFaAVCLH2//DN5C03VKTgKox+Coml9IvSMhoxN5V1A1nqntyn/TBa7mFdzIgGkjxqQY
         5Q/tDSYSXmKUYS3HbfsR3R2hbKs0Mm18P9ZIlpzYBGrqqlCKbMJA+QIiiT0g0QwdE6S2
         xeJKMZ1gqYCyaqm5eosbY7Oko1uOimsQzP6WCzblaOADMdrzmtbk3wwZHjuIfSUPMJpi
         Lisg==
X-Gm-Message-State: AOAM530RYDqU5LvaxpeewhUWAwhjx3UQUtbigd+zgJZdRgt0dmQMP1Da
        cC3e8oNvUhhp4N2ZEmN3fsR2t60u0e9Ecjkp
X-Google-Smtp-Source: ABdhPJwZ/NVAH8JYYOfpJA6drA2n1tbvLrs39ghzLXxQXieBUOEhlkfzrVmMxXUQneRWxIjN9HAFpw==
X-Received: by 2002:a5d:64cb:: with SMTP id f11mr8250046wri.310.1627478946534;
        Wed, 28 Jul 2021 06:29:06 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:69b5:b274:5cfc:ef2])
        by smtp.gmail.com with ESMTPSA id f11sm5834152wmb.14.2021.07.28.06.29.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Jul 2021 06:29:05 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, johannes@sipsolutions.net,
        richard.laing@alliedtelesis.co.nz,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next 0/2] net: mhi: move MBIM to WWAN
Date:   Wed, 28 Jul 2021 15:39:23 +0200
Message-Id: <1627479565-28429-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement a proper WWAN driver for MBIM network protocol, with multi link
management supported through the WWAN framework (wwan rtnetlink).

Until now, MBIM over MHI was supported directly in the mhi_net driver, via
some protocol rx/tx fixup callbacks, but with only one session supported
(no multilink muxing). We can then remove that part from mhi_net and restore
the driver to a simpler version for 'raw' ip transfer (or QMAP via rmnet link).

Note that a wwan0 link is created by default for session-id 0. Additional links
can be managed via ip tool:

    $ ip link add dev wwan0mms parentdev wwan0 type wwan linkid 1

Loic Poulain (2):
  net: wwan: Add MHI MBIM network driver
  net: mhi: Remove MBIM protocol

 drivers/net/Kconfig              |   4 +-
 drivers/net/Makefile             |   2 +-
 drivers/net/mhi/Makefile         |   3 -
 drivers/net/mhi/mhi.h            |  41 ---
 drivers/net/mhi/net.c            | 487 -----------------------------
 drivers/net/mhi/proto_mbim.c     | 310 -------------------
 drivers/net/mhi_net.c            | 418 +++++++++++++++++++++++++
 drivers/net/wwan/Kconfig         |  12 +
 drivers/net/wwan/Makefile        |   1 +
 drivers/net/wwan/mhi_wwan_mbim.c | 648 +++++++++++++++++++++++++++++++++++++++
 10 files changed, 1082 insertions(+), 844 deletions(-)
 delete mode 100644 drivers/net/mhi/Makefile
 delete mode 100644 drivers/net/mhi/mhi.h
 delete mode 100644 drivers/net/mhi/net.c
 delete mode 100644 drivers/net/mhi/proto_mbim.c
 create mode 100644 drivers/net/mhi_net.c
 create mode 100644 drivers/net/wwan/mhi_wwan_mbim.c

-- 
2.7.4

