Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8D241823D
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 15:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245364AbhIYN0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 09:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245011AbhIYN0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 09:26:50 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F804C061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 06:25:16 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id e15so53041700lfr.10
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 06:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m+aLROpJLQxgxdd1GANsintngJ6m1BasQMHqFKGohPM=;
        b=JhtcIM5qfo4CfxMqrOZeSlndukV49S6NA85R7b3M5QloCG0r/P329MEpqZMLJ5qHG5
         Aew6absBXQpOIF+XBt4Jpvc6dDKW/9n0df4gOlxQIuzLa7ILuVuktqs+wJsmYKWnZK8J
         GR71alLSsUlxaRKkc76xn/oawgTA2Y3NInuochi5Y889TbZBgEA0lHXnz7FkUkbkjufM
         tOO9YHFVDr1lXFkr55HWNeNgxsEj5PPFSab83zCrVQn0oIxKfalN7QzyW5HxkTZY8Yej
         BZ7YPLdtm68Jc/vcsCVL3YzlF8dcGRi/ytZcR342PZkSWA27DzXXlP7EK4QJfBSi7bc+
         rZAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m+aLROpJLQxgxdd1GANsintngJ6m1BasQMHqFKGohPM=;
        b=M+jm6jg924bxsX8iS6uBvF8Rg76CpXtrBMbY+x7ezlVkiq0/ybPQsw1GaU/Y6tUBNP
         nFvZk2De3IVmyWH/I0Vo9mwi6mPVf8t1ym3czg809zren2hBCNihlLrvi62bQXnkVQbu
         iMSLjQ8kLIDj9vJqfm1/wqGlsTA79tNWgGqegI3Mj/pDLfK3JAaIN6pea5qpCaeFaQPN
         noHOA0Z2TT/Jo46TYO+3hJfQV2yPRBjkVyA1s+WQCd3w/0waR7Hczt338YrVS/ONPcc4
         dpCij0YnvySytKgIQUwatSRzB9lNnnCDuyP0kvidCZRHKx7CyI12Znat+iunCnf9jpVc
         5Xrg==
X-Gm-Message-State: AOAM5325UGZRzaHra5VcUXPg/NCmwIEQPpmj7LTOwMPApmpxUuBSqjzQ
        mSZrW4OaDkY4sMiZCxLzo8LnHA==
X-Google-Smtp-Source: ABdhPJyA64sOZE0FQyfMDJ97772xHcXvWv1hkKUAtnuRs8WxRIJfmdKrq6gXtSDCm18isksS/mp8BQ==
X-Received: by 2002:a05:6512:1190:: with SMTP id g16mr5090317lfr.667.1632576314363;
        Sat, 25 Sep 2021 06:25:14 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id y25sm199590ljj.23.2021.09.25.06.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 06:25:13 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 0/6 v6] RTL8366(RB) cleanups part 1
Date:   Sat, 25 Sep 2021 15:23:05 +0200
Message-Id: <20210925132311.2040272-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a first set of patches making the RTL8366RB work out of
the box with a default OpenWrt userspace.

We achieve bridge port isolation with the first patch, and the
next 5 patches removes the very weird VLAN set-up with one
VLAN with PVID per port that has been in this driver in all
vendor trees and in OpenWrt for years.

The switch is now managed the way a modern bridge/DSA switch
shall be managed.

After these patches are merged, I will send the next set which
adds new features, some which have circulated before.

ChangeLog v5->v6:
- Fix a dangling unused "ret" in patch 4.

ChangeLog v4->v5:
- Drop the patch disabling 4K VLAN.
- Drop the patch forcing VLAN0 untagged.
- Fix a semantic bug in the filer enablement code.

DENG Qingfang (1):
  net: dsa: rtl8366rb: Support bridge offloading

Linus Walleij (5):
  net: dsa: rtl8366: Drop custom VLAN set-up
  net: dsa: rtl8366rb: Rewrite weird VLAN filering enablement
  net: dsa: rtl8366rb: Fix off-by-one bug
  net: dsa: rtl8366: Fix a bug in deleting VLANs
  net: dsa: rtl8366: Drop and depromote pointless prints

 drivers/net/dsa/realtek-smi-core.h |   3 -
 drivers/net/dsa/rtl8366.c          |  96 ++---------------------
 drivers/net/dsa/rtl8366rb.c        | 122 ++++++++++++++++++++++++++---
 3 files changed, 117 insertions(+), 104 deletions(-)

-- 
2.31.1

