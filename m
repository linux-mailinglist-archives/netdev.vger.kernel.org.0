Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A680239ED47
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 06:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhFHEFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 00:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhFHEE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 00:04:58 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21E2C061574;
        Mon,  7 Jun 2021 21:02:50 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id r14so5938536ljd.10;
        Mon, 07 Jun 2021 21:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cCPDnEM0RZJB/ugzR4s3JTD53m8yJP2I6ehsLgCNNb4=;
        b=FP1N0AY64JKCntLxKvZsUIFsl0Sa5zkda/AJtzEl2JwW0PzmhjJau6phIOQzwM8Vt6
         KeLLF62SL+8ew4+anChrSWvncwo1+G83H7tW/CKyXquPPps6tB1+OQrzco7JqiViHU+L
         3E4TtEhrrLB1X98XuhQ+8ujWJfflPjiqs4Ncg/vUQjHCH377/6CXyB4LYZP2ZAXLL5gP
         BHnX3xBpX4rUu9J3vWn3l8ank3BIL+YQF9VoXKESJUsED1qYyXRPAvKMVxPvX0aImMFW
         IDaVayc1AjSJwYlK6Vpu1hVIdWVcOTX/mtnMo4IvLtw+0v7UBOD1KkNi90+/8nrxderC
         A+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cCPDnEM0RZJB/ugzR4s3JTD53m8yJP2I6ehsLgCNNb4=;
        b=LMCDJP/5zxeDtU6G9KCFNx8U9j6UpkPJRiLGVnWP/Wsm2IGP8GlHmf7JnFjOHrYfMC
         NzO0wcZxpJrR8fEQFRGmEMNELkhylvOaXJjIXhawXm7fYqeXwh+N2qapB66h/s0fYuhe
         Gk1vVo/jvInII7WvlzXIsBkQSjKvzV1nwf6LQ0S0VD88uidlqGBidPS/0hF2Wfusfape
         i40fqqV446qeyEjnNL/MXhkcKNREon5Bfykb7EX0WKlO/com7qKSaZCpH/cfRMr+fNn1
         0Nk+lvFDKr7jhPjt3DRZyySYBJiFndb9xDUAnPeRWbQbySQ9OzEdzq2nxfRlgadjfAXl
         WMSQ==
X-Gm-Message-State: AOAM530gvVS+UKrIisp1cJ4dzcA+H6Yz0kuxy/kOHSykBdaLEUq81TKQ
        WoVWWl8kYXPN6srE3mbw8q1MQjFVJpE=
X-Google-Smtp-Source: ABdhPJw/dATeF9tRJ7okic+GskD4twtTawU9qGwDnY8sYCvToQRZ3GW5Gsha8koidhDa1qBOgVyBgA==
X-Received: by 2002:a2e:9192:: with SMTP id f18mr16663873ljg.77.1623124968959;
        Mon, 07 Jun 2021 21:02:48 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id l23sm1729096lfj.26.2021.06.07.21.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 21:02:48 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 00/10] net: WWAN subsystem improvements
Date:   Tue,  8 Jun 2021 07:02:31 +0300
Message-Id: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While working on WWAN netdev creation support, I notice a few things
that could be done to make the wwan subsystem more developer and user
friendly. This series implements them.

The series begins with a WWAN HW simulator designed simplify testing
and make the WWAN subsystem available for a wider audience. The next two
patches are intended to make the code a bit more clearer. This is
followed by a few patches to make the port device naming more
user-friendly. The series is finishes with a set of changes that allow
the WWAN AT port to be used with terminal emulation software.

All changes were tested with the HW simulator that was introduced in
this series, as well as with a Huawei E3372 LTE modem (a CDC-NCM
device), which I finally found on my desk.

Sergey Ryazanov (10):
  wwan_hwsim: WWAN device simulator
  wwan_hwsim: add debugfs management interface
  net: wwan: make WWAN_PORT_MAX meaning less surprised
  net: wwan: core: init port type string array using enum values
  net: wwan: core: spell port device name in lowercase
  net: wwan: core: make port names more user-friendly
  net: wwan: core: expand ports number limit
  net: wwan: core: implement TIOCINQ ioctl
  net: wwan: core: implement terminal ioctls for AT port
  net: wwan: core: purge rx queue on port close

 drivers/net/wwan/Kconfig      |  10 +
 drivers/net/wwan/Makefile     |   2 +
 drivers/net/wwan/wwan_core.c  | 238 ++++++++++++++--
 drivers/net/wwan/wwan_hwsim.c | 500 ++++++++++++++++++++++++++++++++++
 include/linux/wwan.h          |  12 +-
 5 files changed, 738 insertions(+), 24 deletions(-)
 create mode 100644 drivers/net/wwan/wwan_hwsim.c

-- 
2.26.3

