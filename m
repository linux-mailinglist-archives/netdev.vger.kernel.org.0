Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E4928A42D
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388143AbgJJWyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731321AbgJJTJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:09:53 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416A2C05BD3D
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 09:41:29 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id o18so12608070edq.4
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 09:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=easyb-ch.20150623.gappssmtp.com; s=20150623;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=dLRX4IIXiBRj515P9pAQIyNuTdZNHRn/zXUxSNKK+qU=;
        b=deNRhVSYAuTRIy8ptl5Be+KRzmTVVRYh0tNwzWVVtrFU9FRJcAjXUSfZ2gBz4T9vYb
         bbwVL+R3yJ6j8LQuvih5WZQJIYCNOcs+NQunlRb9VfpeSa3nOACcOce7EjO25zI9C4+L
         53j8qpNqApa6Y5IGrTlyOaWB1VSsq+mW3y33PNg127P6vq3CNZJWie4XQBmSF0RDE5tu
         tzeZO2brLsGTet5SRtlQDj+09BIfa2sSXgFQ674PYnyd4UaTUc6ARoOs+WbJ/AQ7+/HY
         H3QyFASwtv5X06nOk/YifH7p3VSC6oodgcSz8Hyjta4QzyFK1k4gpNmZL6X6Qm3g6yjl
         rncQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=dLRX4IIXiBRj515P9pAQIyNuTdZNHRn/zXUxSNKK+qU=;
        b=a/3mzwuTOTuHMSLV13oYBVOdUN6R4lF4O7uQ1C5pobToakZdirTXSvVBphC+wapxI2
         dqSLYo9epoWqFwxZSxXuruX0JOVqp7l6mXXs1Ro33+2nntYw9vE/NKo7WIOif2MTmN9k
         twoV5MEdLQfybsy5Cl3HxNGs3aVpp8ClZv3QfMHSfGHXt7PvOQj7kimdEqZPgMFtX0lo
         Y6fzpKKOBfvl2UBAa37+erd07jXtilN+kBXpuNl7Q6+MWnQWfqCEYH+ppzr7eFaK53u1
         hhrjrjGAKTBBaQbgt/4LBE3Taye2xmwl2rU45jCVnNgtfgL9NYoUGoC5Y1EbfRblbHEG
         AzDA==
X-Gm-Message-State: AOAM5302Z2pBnXGRhJ/CtPNjmZr9XCI5sP94ShRKdttecxyjbfbZoFM6
        XUiKI8OnOP6HWjGO+wT+yOq+PWyGS6kJm5Nj
X-Google-Smtp-Source: ABdhPJzK3E+cxQct6ieBhY8ZxsthfILs1OKoCSfTGo280g0Oa9YYh0XZBS3vtEhVfUsxqyFnZYlwWg==
X-Received: by 2002:aa7:ce91:: with SMTP id y17mr5277115edv.329.1602348086914;
        Sat, 10 Oct 2020 09:41:26 -0700 (PDT)
Received: from ?IPv6:2001:171b:2265:9620:e09b:b59b:1ad2:e94a? ([2001:171b:2265:9620:e09b:b59b:1ad2:e94a])
        by smtp.gmail.com with ESMTPSA id w4sm7938136edr.72.2020.10.10.09.41.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Oct 2020 09:41:26 -0700 (PDT)
From:   Ezra Buehler <ezra@easyb.ch>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Linux mvneta driver unable to read MAC address from HW
Message-Id: <4E00AED7-28FD-4583-B319-FFF5C96CCE73@easyb.ch>
Date:   Sat, 10 Oct 2020 18:41:24 +0200
Cc:     thomas.petazzoni@bootlin.com, Stefan Roese <sr@denx.de>,
        linux-arm-kernel@lists.infradead.org, u-boot@lists.denx.de
To:     netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

sorry for bothering you, but I am kinda stuck here.

I am running Debian buster (Linux 4.19.146) on a Synology DS214+ NAS
(Marvell ARMADA XP). Unfortunately, I end up with random MAC addresses
for the two Ethernet interfaces after boot. (Also with Debian sid, Linux
5.4.0.)

Since commit 8cc3e439ab92 ("net: mvneta: read MAC address from hardware
when available") the mvneta Linux driver reads the MVNETA_MAC_ADDR_*
registers when no MAC address is provided by the DT. In my case, only
zeros are read, causing the driver to fall back to a random address. I
was able to verify that the registers are correctly written by the
bootloader by reading out the registers in the U-Boot prompt.

As a workaround, I now specify the MAC addresses in the DT. However, I
would prefer not to do that. Also, it would be nice to get to the bottom
of this.

Could it be, that for some reason, the clock of the MAC is removed
either by U-Boot or Linux during boot?

Any hints that could help me investigate this further would be highly
appreciated.

Cheers,
Ezra.

