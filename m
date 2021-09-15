Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA0E40CB6C
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 19:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhIORLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 13:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhIORLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 13:11:05 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0536C061574
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 10:09:46 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id e6-20020ac84e46000000b0029baad9aaa0so5117702qtw.11
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 10:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=G2WcbvK+PaXifH/TCT7HXkdAsMKjXqmq2vlholzbmpk=;
        b=WT0fdnsqO6AZfZgkz8NrBSHO5BEL6157yGk8J57NcI7AzVyrtQSvNXpJ4+CTp5Ggse
         aFpAgHabNUc8tnQpk++2h6YvQC+U2AUee8oewZ6MzsxMtJZYbEhMDUT49sC6bYZCgTQD
         NhotxdJXk7LdTEfXU4aFsOz1VBGR9iUR/aH1Lw256rqIiAQIh7yV+RJd4qZdl1IML8Hq
         sDEA2PKem275C8xVQ2B44G0AXAwEiREBCsCgpT8CPA0U+7kH36z7222EedDv0sdyUtm6
         XBiZfkNqh9CUd6aiRWcR97jWP4ma3lrzGZ4FLvJRUdKXb2rdDfl0ZimLjjrtP+fCmXqj
         82gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=G2WcbvK+PaXifH/TCT7HXkdAsMKjXqmq2vlholzbmpk=;
        b=rPDsZT5l+cg/u0hlcsTxfX0m/2vy3joQ9GCysvcvMoxZbW4+/UJyVlTkV0Pe4BcHhj
         Yk0/K+KqEjZzuNcc67WMxqkhJBdiNnlJlElbd67FKY46jlbg7CW8Z6MFUGsrL6aYCrE/
         LiNYTtpH1K+aw+J6/JvWT0BmnakdmgxBqUXMK8o26K3dc1C7DjIuS4m4BITh1vS+iVOV
         GU7zXCWJmofDn6HTtK64iMSGEDqv8RHoFUfnXT1fEu0/DM4lc3FpOFcmiIgIehWNqoBv
         QrbOJYZG4NlNrrcrgvNqOT5PVb6o+KpQI1TUwmcnuzSFlJGgPCe8SzSBJyRfY8TugKTR
         WdwQ==
X-Gm-Message-State: AOAM531St6ilBg8bzme9iHxaK45P2FAOQwsXS+lKiIrc11kuUernn8x+
        39ArC8fK3kAekiMyibNJ0JfxyRikxnD3inQ=
X-Google-Smtp-Source: ABdhPJxcb7UvYj5WzZFkfdnkysuUIWp0Nf5fLRSUqM2gZo1OCWg2hif2EW1CykPzlm1LoQB3AagcAWW8Slx8LXw=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:16d1:ab0e:fc4a:b9b1])
 (user=saravanak job=sendgmr) by 2002:a05:6214:732:: with SMTP id
 c18mr933459qvz.9.1631725785980; Wed, 15 Sep 2021 10:09:45 -0700 (PDT)
Date:   Wed, 15 Sep 2021 10:09:36 -0700
Message-Id: <20210915170940.617415-1-saravanak@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v3 0/3] fw_devlink bug fixes
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Saravana Kannan <saravanak@google.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Intended for 5.15.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vladimir Oltean <olteanv@gmail.com>

v1->v2:
- Added a few Reviewed-by and Tested-by tags
- Addressed Geert's comments in patches 3 and 5
- Dropped the fw_devlink.debug patch
- Added 2 more patches to the series to address other fw_devlink issues

v2->v3:
- Split the logging/debug changes into a separate series

Thanks,
Saravana

Saravana Kannan (3):
  driver core: fw_devlink: Improve handling of cyclic dependencies
  driver core: fw_devlink: Add support for
    FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
  net: mdiobus: Set FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD for mdiobus
    parents

 drivers/base/core.c        | 36 +++++++++++++++++++++++++++++++-----
 drivers/net/phy/mdio_bus.c |  4 ++++
 include/linux/fwnode.h     | 11 ++++++++---
 3 files changed, 43 insertions(+), 8 deletions(-)

-- 
2.33.0.309.g3052b89438-goog

