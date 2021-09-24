Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B4B417E56
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 01:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238886AbhIXXkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 19:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhIXXkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 19:40:15 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2766C061571
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:38:41 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id z24so47582173lfu.13
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k63O/QRHI/ki5XM7WE51igG+Sjtl20yBS/wZDy1yzu4=;
        b=GpJwWK2QOL+Ad7QhatOG2J9lgJgz+aULDSApGKJnpJPFQF1ZigTsV3KddOTrie917X
         xoX3GJlEriIZZr/iFxdDFmLpqhL0Bc819WJ6/vdjvHkyV5seLd1MLqRsNU2zI5R7qRFw
         XYCY/JyDU0dRILT810WkF81lDJI/OKUrEYjDwqP4GvWiSlMZ+BMMew2b7rFMp8dXILyf
         rU57P8IzobBxG9LF0zKIN3vg0a/BAzJlZUwGaU7nAD0A3NqEq3AtFjKFffV6swlvtwNB
         5X5qOU8NljarxS9pLzrorlX25BhJBgV/0+3Ai+pUyQGAA4QNBW7TBvxnLqhTZLzXidJ6
         daEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k63O/QRHI/ki5XM7WE51igG+Sjtl20yBS/wZDy1yzu4=;
        b=7OC98d9KaBlp+avuopBbgrkutIV5GDLX/nHwEa5CZi0q7jno8p4pyOkNEvg3m7RU7s
         MPC/A5lUglvuhVs4W4eui93oxr6sOOGNYguBDyaAF+YhFCvhofxTWNoikj+s95we6zDo
         2K+l4uDBLDihQ+spA72WsxQzxhxOBIjc/hOekspux8qB+0prINOyxZe7CGC7pq9Z/svZ
         3OF4AJZOFzvlluy8w0cU2d0jGV9D17b+oO/pTemePzoreus3XFZizSPgsN83Sxs10UIZ
         b4STwrrr5+wH8+fTz4X7QINeHbmBQl9CYw5H+9mCtfz7qygfPWY7AdWWts6X9X/OhKqb
         C0vw==
X-Gm-Message-State: AOAM531r+GGsvL3gw+rvQtVl1rU/6EYzl1U2KgtDjLayBEwdX0KQOxTe
        JWTS6klHDJPqqEaiOGmvYQfvxw==
X-Google-Smtp-Source: ABdhPJxYZsuiB3cU4fJJ8rPQs1f2iIbtTl7zoBwi1iy1UeyKJHUM6EqGNMLvybK24S1MSzrw8bCjmw==
X-Received: by 2002:a2e:530d:: with SMTP id h13mr13873349ljb.215.1632526720026;
        Fri, 24 Sep 2021 16:38:40 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id k21sm1176652lji.81.2021.09.24.16.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 16:38:39 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 0/6 v5]  RTL8366(RB) cleanups part 1
Date:   Sat, 25 Sep 2021 01:36:22 +0200
Message-Id: <20210924233628.2016227-1-linus.walleij@linaro.org>
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
 drivers/net/dsa/rtl8366.c          |  96 ++--------------------
 drivers/net/dsa/rtl8366rb.c        | 123 ++++++++++++++++++++++++++---
 3 files changed, 118 insertions(+), 104 deletions(-)

-- 
2.31.1

