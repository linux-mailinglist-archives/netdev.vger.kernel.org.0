Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF67418512
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 01:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhIYXDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 19:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbhIYXDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 19:03:18 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C35C061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 16:01:43 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id y26so18088110lfa.11
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 16:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iXyuyTakYEchW9eHjrv+auqm3M0CeBWN78Bioez/ZIo=;
        b=jFJxL+XNG2MXPeyoJnVxjrzpnOJGHQMHKQRLbRzJ2E0ofD8idgOq8WY2i9ljRAyD64
         rzPac8m6vG+LxKCUxaiWfnPNHNFV4ab3spfqRA//XSACc5S6epWcSUvVI56oD8OAdeWh
         ICUP25SFORdiTRKj9pnCVySPbGH6Slmi2vMx+/C4gPaGfpwUUUeA4T2e3gMNgrJZkfCs
         ZQ6jQk5w9F1lc4lFDS34HDHhZhA8MaYIXA9f4CciyKalRcvpVY5jpsxKlMXS+0b5gdeg
         ovW0n4DVgDgySHax7dGvtlEwBr+tKOIUBahohUfH2IcHHGQlDhXxBKkqOl7rI0Q3sQ2d
         MsDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iXyuyTakYEchW9eHjrv+auqm3M0CeBWN78Bioez/ZIo=;
        b=aCyHdHHkkjExTf5nqbk6A3oQ0mhaKzeUknxNbKhriKCJnE0wn5Hb1FqXDyjSWEKTIn
         3zaDVqUX2OnPChWrsYUI59Au6pG1XxuiwAaOioR4ZmGEK5H/W8Avva/S7ctNB9T2K0tu
         N8bKSx60ECotYtLi9csBKjcc0k/0Zr5ehdcp6VgbXVXC9PUGt8gnaL/WQPVnkldeZqkn
         +3itY0S4Evk1F355KjNIUWqQ8nTnucFnf4EkLUV9noNUQIcB4/iYMxvtLl4IEGkm3hZu
         53rtzzKE255gPbo2DNVtb6YXnOBjduWb5pBS/MsJAY1EGBiUD5gBfvsvUSt4JcpFcDPe
         t66w==
X-Gm-Message-State: AOAM530T/oKsrGKg7C+fEC/P8Rnj6WlmkNDghNOnG7j8v8cxxlQyrUGt
        h2hDqVUEPFZ/D6UsCVoqMo0QMg==
X-Google-Smtp-Source: ABdhPJy0PDf6DyjZQK/gnu0jU+Um4Jd4RxyD4VAunqs6rz41/fe06WDpZJxynYmU4O3xQSu9vbKW9w==
X-Received: by 2002:ac2:5f41:: with SMTP id 1mr16864829lfz.79.1632610901413;
        Sat, 25 Sep 2021 16:01:41 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id d27sm1448111ljo.119.2021.09.25.16.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 16:01:40 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 0/6 v7] RTL8366(RB) cleanups part 1
Date:   Sun, 26 Sep 2021 00:59:23 +0200
Message-Id: <20210925225929.2082046-1-linus.walleij@linaro.org>
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

ChangeLog v6->v7:
- Fix up the filter enable/disablement code according to spec.

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
 drivers/net/dsa/rtl8366.c          |  96 +-------------
 drivers/net/dsa/rtl8366rb.c        | 194 +++++++++++++++++++++++++++--
 3 files changed, 188 insertions(+), 105 deletions(-)

-- 
2.31.1

