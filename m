Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF72218D70
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 18:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730670AbgGHQrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 12:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgGHQrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 12:47:09 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B08C061A0B;
        Wed,  8 Jul 2020 09:47:09 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id cv18so2264759pjb.1;
        Wed, 08 Jul 2020 09:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uXQd+xPlC0w29OXkc5Scwo6N7OCfZD/kPE81YCzezg0=;
        b=E96cv1bOUuk6EioIt4IwxkX6LrHUBuhZBZJcL1F0d+jyMWttLvp3BHsvah7LRyxS06
         FEvE0ExeT0kJN/aRfvVQFb4FRzcYmYN4yKmjEWdgRqvYZ2sTQIR08HGGgx0zSWZ1rK6N
         bHw3kQqf393oo8mAHPu+pnHFoyLJ4xBY1U6PrgpKSjYzhFb9rUO/Sd6FHKyxgzJ+Al3b
         IEK01LeP3ok18H3aO67Ll1LLjJoIEChFjNYu1NyOzR9mlRpk5nZ7AKV8s6f6gEq3+DeZ
         cpg8envEOcei3pXJgLi3W952ewjMiPfzPrqO/SGDi3SgO5StSTfVlokeW0UzC+sZA5hI
         WwbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uXQd+xPlC0w29OXkc5Scwo6N7OCfZD/kPE81YCzezg0=;
        b=LCkzZYdf/yxZWcvEMY1/2QzRY5F0pidNMlqExRW13BDs9Q91WAZoan6abynWyDa3ZS
         CObbGK/U6cIp2s8lhxJcG3ptWxjiQdZocIiH+DUHaI78bRLNtBKEi+tWrCFT9nUNiq76
         Rrwb5ZChtbRTQpoylluh0n3QLXp4xnWNPyUSpRZqZUJYAbkbFIFN0h/3/sOp6Ea+ZajW
         6Ggq9+2katiC2kDrUl3mlr3JrTG7FnqLOFd8WLmZr89w96wOqF5XozeEAQ42Xj1kMMb9
         Mv3cRzFotHlWRxhPdQ9EOhJpTkMLvqoTQ5EwawD/p1LbMEx11ALVfOdAz1Odi9QzUbbf
         cBUw==
X-Gm-Message-State: AOAM531qnNb2AcjetpnvOoIaLntzUgXiuOeCsliJ8wnCr/7gRr9nYB9N
        7nCjRQJsWwIV1LwA/w5uDEO1mqUu
X-Google-Smtp-Source: ABdhPJx2Ecsb8S8CvkOz7d9SLzlCRiC+j+yDmO4FY0Jg5QOLo60d7Y1K71Ihz3tTJuxQdJSIyosuWA==
X-Received: by 2002:a17:902:40a:: with SMTP id 10mr28991858ple.260.1594226828905;
        Wed, 08 Jul 2020 09:47:08 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id x22sm356247pfr.11.2020.07.08.09.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 09:47:08 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 0/2] net: phy: Uninline PHY ethtool statistics
Date:   Wed,  8 Jul 2020 09:46:23 -0700
Message-Id: <20200708164625.40180-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Now that we have introduced ethtool_phy_ops we can uninline those
operations and move them back into phy.c where they belong. Since those
functions are used by DSA, we need to continue exporting those symbols.

It might be possible to remove ndo_get_ethtool_phy_stats in a subsequent
patch since we could have DSA register its own ethtool_phy_ops instance
instead of overloading the ethtool_ops.

Florian Fainelli (2):
  net: phy: Define PHY statistics ethtool_phy_ops
  net: phy: Uninline PHY ethtool statistics operations

 drivers/net/phy/phy.c        | 48 +++++++++++++++++++++++++++++++++++
 drivers/net/phy/phy_device.c |  3 +++
 include/linux/ethtool.h      |  7 ++++++
 include/linux/phy.h          | 49 +++---------------------------------
 net/ethtool/ioctl.c          | 23 +++++++++++------
 net/ethtool/strset.c         | 11 +++++---
 6 files changed, 84 insertions(+), 57 deletions(-)

-- 
2.25.1

