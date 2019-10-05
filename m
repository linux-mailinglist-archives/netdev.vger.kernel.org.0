Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13EE1CC857
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 08:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfJEGKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 02:10:37 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36244 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfJEGKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 02:10:37 -0400
Received: by mail-wm1-f66.google.com with SMTP id m18so7724840wmc.1
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 23:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S+d4Sch2NHCbJQULit4vXAoDLZ36M6vGI/12sLLyd5w=;
        b=bQhlYjQvllDbfeAeqt8C9/hyCGHgXUNuTcYr19HG4GfqcGVL1Z6Y/fBKgUzhlBftFy
         Bn8gtxrUw/xFx3RjmBXJC8gx7Tzzif1fh69rfZvJYAjnCB3yPRLJ9Z06K/OUCB07zdTX
         6N9wQ/2URp3VQ6XJOtRYTKUiK5R5geJ5BQ0lAn13qHLaUe5QLwS0+NvpNV2scBO9mCqm
         uXrF1rRrlni85q07ZPWIDhwW1E5PMlmN/79x3FAfjcx+2wOD0B7WZuNMoMHDugxWJ9lP
         UHAH2btaELHIrZG8G5sk9FTx0SAF6IowNl12rZf3ekS5p12oXe4f4E1wGtYZWbutWC30
         WAfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S+d4Sch2NHCbJQULit4vXAoDLZ36M6vGI/12sLLyd5w=;
        b=HHN17U6ZYfRqrq6TZr9pdjGYidzNkwugvtJmRkn6HJG3AuFeQWYH5wYVQ8ZratLwGI
         DZ681dqd6ZTLyJFbKK8QpWrUKzSlTvuvcq6aBa6koGZ5gUOS0xnGiCOS4/FYM1pQ8BMV
         hXviPZpRbUTXLloaGR0mgJB7WUdCAhjH11FqPV9ZMo6gBQK6sraHltRdtQtqyxEkFySA
         V9oViJJ5F9Vx8HTU4NH/m3Ptt/dd3QHe7jlpkXYTbkwyrEsxevKWS34T2sTW5/K5wTyp
         9AgXg3ncZf//C99XdREqgTR9zX/AqhYiQQzlUgMi5c99OcwaLXMhJimmzCx5tS1062Px
         vUaQ==
X-Gm-Message-State: APjAAAXEiAF7nHmNEafxwmP0MeSjsaWQjN97shLOIEPiZVrul930iCXC
        5+BV3qcFwxOZDo15b7z2BIHdQF7GPbI=
X-Google-Smtp-Source: APXvYqwI3OBTtoOSI1BaOVT5iMf6jWOem34yTSZ/L/AvXUQPffNA21GDXhniX4DiKXZzNWi7+y8Rhw==
X-Received: by 2002:a1c:2501:: with SMTP id l1mr12314121wml.74.1570255834452;
        Fri, 04 Oct 2019 23:10:34 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l13sm6343510wmj.25.2019.10.04.23.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 23:10:33 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com,
        jakub.kicinski@netronome.com, petrm@mellanox.com,
        tariqt@mellanox.com, saeedm@mellanox.com, shuah@kernel.org,
        mlxsw@mellanox.com
Subject: [patch net-next 0/3] create netdevsim instances in namespace
Date:   Sat,  5 Oct 2019 08:10:30 +0200
Message-Id: <20191005061033.24235-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Allow user to create netdevsim devlink and netdevice instances in a
network namespace according to the namespace where the user resides in.
Add a selftest to test this.

Jiri Pirko (3):
  net: devlink: export devlink net setter
  netdevsim: create devlink and netdev instances in namespace
  selftests: test creating netdevsim inside network namespace

 drivers/net/netdevsim/bus.c                   |  1 +
 drivers/net/netdevsim/dev.c                   |  1 +
 drivers/net/netdevsim/netdevsim.h             |  3 +
 include/net/devlink.h                         |  2 +
 net/core/devlink.c                            | 15 +++-
 .../drivers/net/netdevsim/devlink_in_netns.sh | 72 +++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |  7 +-
 7 files changed, 97 insertions(+), 4 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/devlink_in_netns.sh

-- 
2.21.0

