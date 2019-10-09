Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4CCD0D5A
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 13:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730629AbfJILEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 07:04:48 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38716 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbfJILEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 07:04:48 -0400
Received: by mail-wr1-f65.google.com with SMTP id w12so2343040wro.5
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 04:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eZOwFYL28GXJeqCgUcPTrZjjlTzWRF+53AwlKnk1vZw=;
        b=VW972ra7vX/PloV5Tp/9032Ck7i2/uFjZ0ukw6viaOXfp81uvIi1QmeNdWJBJmrZwX
         4dGU1cwo5HghRbKuvc5udf7uizqWH+RlTmUMhlxiKiDVmvSozYmn7yf+Zh+RzzM47Ff0
         xV3jmpSPBUpGFlNl+E9yQl+JKK2B0WLpyEPtw3za0CfRZkOBWbOQNJebbV9LuDmrJxEh
         rBCRl16VD24DisAT+dMU3Wuf/d6Ct21nliZzaYmWJ5Gfuo/nsT4DRe898GDyXULMAjNQ
         lwC78ebLubb2k6UcyOBKQYL1LSv2bUgIogPxepvCpctLy2WKoxV8GAmzreMKh7ZEjwSf
         0g8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eZOwFYL28GXJeqCgUcPTrZjjlTzWRF+53AwlKnk1vZw=;
        b=uDANjc7k2Hn3uE3xtf5La4lmpJQB8CA2q7OESI6rilxoEkVTqpW/I8bpwQevIQ08j5
         kfs5JGfhc2YKYqw8fYO0Hroa+P5TlrQ+xeFUgRj0NubGj38ClVExXDl0VhqWm5Zu22n0
         iJWBjBcaBYI8pR2zrU3vYbyuRVHIAQbsTzeNhzCwmw3Sgm5UaKnj3jPrYQd7swyTHDG0
         E2fSManmBVtnuq1LA+CytXkmFV6BCmQNutK+Y/FYINvIMP6/Mq3V6O6P8UqGFxB+kTl2
         aHpaAlUdslf9SOUTWPHFBbhSeoWgbScvdWzMu4x+Gv8CK86TvDxgU0UuU1prcggTb4vp
         h0ig==
X-Gm-Message-State: APjAAAUIRydfX0GKo3E7szTjTxMdvLtluMGC+9mzyfjw99Emm/YbpI13
        8gp8/k0phvG0OO8/Em3WZMR2hgdxzBg=
X-Google-Smtp-Source: APXvYqzyx/TezK6AcVl9Eecq1WIJzoZ9uhYw9hPTmfIlXBWOp6pwTzbiqNZn9cLJFQk1nsPBaDtouw==
X-Received: by 2002:adf:8123:: with SMTP id 32mr2500017wrm.300.1570619086330;
        Wed, 09 Oct 2019 04:04:46 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id j11sm1954548wrw.86.2019.10.09.04.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 04:04:45 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        ayal@mellanox.com, moshe@mellanox.com, eranbe@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 0/4] netdevsim: add devlink health reporters support
Date:   Wed,  9 Oct 2019 13:04:41 +0200
Message-Id: <20191009110445.23237-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

This patchset adds support for devlink health reporter interface
testing. First 2 patches are small dependencies of the last 2.

Jiri Pirko (4):
  devlink: don't do reporter recovery if the state is healthy
  devlink: propagate extack down to health reporter ops
  netdevsim: implement couple of testing devlink health reporters
  selftests: add netdevsim devlink health tests

 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |   9 +-
 .../mellanox/mlx5/core/en/reporter_rx.c       |   6 +-
 .../mellanox/mlx5/core/en/reporter_tx.c       |   6 +-
 .../net/ethernet/mellanox/mlx5/core/health.c  |  12 +-
 drivers/net/netdevsim/Makefile                |   2 +-
 drivers/net/netdevsim/dev.c                   |  17 +-
 drivers/net/netdevsim/health.c                | 315 ++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h             |  14 +
 include/net/devlink.h                         |   9 +-
 net/core/devlink.c                            |  23 +-
 .../drivers/net/netdevsim/devlink.sh          | 124 ++++++-
 11 files changed, 510 insertions(+), 27 deletions(-)
 create mode 100644 drivers/net/netdevsim/health.c

-- 
2.21.0

