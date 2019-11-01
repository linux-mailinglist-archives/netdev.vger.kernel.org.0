Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF2CEC369
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 14:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfKANCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 09:02:31 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32816 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfKANCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 09:02:31 -0400
Received: by mail-lj1-f195.google.com with SMTP id t5so10210910ljk.0
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 06:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0egjBdQJtYXLIHxjxzAbtG2G5qRpm+4VtSyDYXCM0wE=;
        b=sT2Jl/yznKqH7pkHjf0QU00oT3ksvH0he2PM/SJVUBigYuatmwmm3PYbPqoTOWhOva
         w3DXLbfqdSe2r+5f8NcHc/YuiyV/cwpUwtjwVvWb2NTXwRum1DOXqZVb8sLaoFnuOWpc
         StDNWN2R0HNjHlbYuKy8FDUUHSvR/jQsuNNb6+xpFrpylB6si20CflcUpeXuyd0lSthB
         KZtHhkfbavuapFU/B8frxSua7pZGqj0gx8ewx33fhvk2hbliZ0x5XME4k9ar/O2ArP+g
         4cstE27dWBTLPCJ9H0i1gfO9H9rHA/0wA6tQ0p7pirM7hK494P4dzhkYatDHnlzNHR+B
         chrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0egjBdQJtYXLIHxjxzAbtG2G5qRpm+4VtSyDYXCM0wE=;
        b=iB1ay84o9to+mZP9kBYwAxtS9P8pDgcy7ISzJtVKsuQ2fHQD+GY/h3UpBmogIHHyF5
         kh3kExPKNm/3KjW4CBKZAF5A4wXpJC9aGeisqZqHIVVfBToyu64aSP2YP4wowoZWNWQz
         uJvcadnPQBvubAHdn1HqWz11J6W2wXEhmR333++RvcdAsrvWT8uOdq/uPa/xQzCjyHBD
         S80b3gSi/gOwzVzSvHxwrvlwKaRo+0Xevv0yNRhw13IEkxIxCHLu3fl98EFfLMxP2sGl
         ig7dhp3hH7ZWJsImRXIDcTiUHMWqQHsNxHh9ohw8OV/oq2WMGXhwsL3+vh2bqFSancTq
         0aDQ==
X-Gm-Message-State: APjAAAV3ezGIbsJYoHseuxbp5WIngPZNASy4LiHv7fZ+ZKGsmfRpTUP1
        2gus+0/5+2QyPypHn5UfVUHQbYohrnDDFg==
X-Google-Smtp-Source: APXvYqylQ+gOHwXrmXYbZqHzDdvAn6StOLP895JkcJwSWjl2/lDpGvn0vbLJUarXVOFegS8IryaW4w==
X-Received: by 2002:a2e:9157:: with SMTP id q23mr3168880ljg.79.1572613348986;
        Fri, 01 Nov 2019 06:02:28 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id c3sm2516749lfi.32.2019.11.01.06.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 06:02:27 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 00/10 v2] IXP4xx networking cleanups
Date:   Fri,  1 Nov 2019 14:02:14 +0100
Message-Id: <20191101130224.7964-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a patch series which jams together Arnds and mine
cleanups for the IXP4xx networking.

I also have patches for device tree support but that
requires more elaborate work, this series is some of
mine and some of Arnds patches that is a good foundation
for his multiplatform work and my device tree work.

These are for application to the networking tree so
that can be taken in one separate sweep.

I have tested the patches for a bit using zeroday builds
and some boots on misc IXP4xx devices and haven't run
into any major problems. We might find some new stuff
as a result from the new compiler coverage.

I had to depromote enabling compiler coverage at one
point in this v2 set because it depended on other patches
making the code more generic.

Arnd Bergmann (4):
  wan: ixp4xx_hss: fix compile-testing on 64-bit
  wan: ixp4xx_hss: prepare compile testing
  ptp: ixp46x: move adjacent to ethernet driver
  ixp4xx_eth: move platform_data definition

Linus Walleij (6):
  net: ethernet: ixp4xx: Standard module init
  net: ethernet: ixp4xx: Use distinct local variable
  net: ehernet: ixp4xx: Use netdev_* messages
  ARM/net: ixp4xx: Pass ethernet physical base as resource
  net: ethernet: ixp4xx: Get port ID from base address
  net: ethernet: ixp4xx: Use parent dev for DMA pool

 arch/arm/mach-ixp4xx/fsg-setup.c              |  20 ++
 arch/arm/mach-ixp4xx/goramo_mlr.c             |  24 ++
 arch/arm/mach-ixp4xx/include/mach/platform.h  |  22 +-
 arch/arm/mach-ixp4xx/ixdp425-setup.c          |  20 ++
 arch/arm/mach-ixp4xx/nas100d-setup.c          |  10 +
 arch/arm/mach-ixp4xx/nslu2-setup.c            |  10 +
 arch/arm/mach-ixp4xx/omixp-setup.c            |  20 ++
 arch/arm/mach-ixp4xx/vulcan-setup.c           |  20 ++
 drivers/net/ethernet/xscale/Kconfig           |  14 ++
 drivers/net/ethernet/xscale/Makefile          |   3 +-
 .../net/ethernet/xscale}/ixp46x_ts.h          |   0
 drivers/net/ethernet/xscale/ixp4xx_eth.c      | 225 +++++++++---------
 .../{ptp => net/ethernet/xscale}/ptp_ixp46x.c |   3 +-
 drivers/net/wan/Kconfig                       |   3 +-
 drivers/net/wan/ixp4xx_hss.c                  |  39 +--
 drivers/ptp/Kconfig                           |  14 --
 drivers/ptp/Makefile                          |   1 -
 include/linux/platform_data/eth_ixp4xx.h      |  19 ++
 include/linux/platform_data/wan_ixp4xx_hss.h  |  17 ++
 19 files changed, 313 insertions(+), 171 deletions(-)
 rename {arch/arm/mach-ixp4xx/include/mach => drivers/net/ethernet/xscale}/ixp46x_ts.h (100%)
 rename drivers/{ptp => net/ethernet/xscale}/ptp_ixp46x.c (99%)
 create mode 100644 include/linux/platform_data/eth_ixp4xx.h
 create mode 100644 include/linux/platform_data/wan_ixp4xx_hss.h

-- 
2.21.0

