Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98034409762
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 17:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244798AbhIMPfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 11:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245524AbhIMPfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 11:35:06 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A70C1259C0
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 07:45:07 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id x27so21627391lfu.5
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 07:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PkJwHZP7oqCVg/74lYBt3k1cFYX9NNjRUfJMYks/UKk=;
        b=rVOXVepXRTT+ZABzC6fLd+u3N9uW+l/SAjp6OhOEfT51YbBRzcDkriXOAqYhHWq9vM
         DAfUoCrGZ3rlVhtfvzx2GtHtgWZPUPdU9gabpEIDbN++JGQOybWwpyk7PdguSY9iGljE
         573RZgdI+3/qEO85anYnFMPgidxY2esFKw5ZhIGkXz2X5R6OEGtDA0hhQU2CIzry6nh8
         3Szx21QhLrvN0VaB5dIyMXqbt69QJasYRrdGaC6E1J5WVmOEfG6/NAN1xWX79mzu3iY0
         umoUbbnl/OxWE4aUoLdok20hGDIPPy1phfFeyuW3e9kriGXGICHaiy4HnU3P+JCpgby8
         puTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PkJwHZP7oqCVg/74lYBt3k1cFYX9NNjRUfJMYks/UKk=;
        b=TWHqGetXnZdSUy5TtAWClvoAhMR17auvwP7b9pHj8mZF/nswz5rOzBNhyRTQjHaXZf
         qJpJeKJ/xYQTrZWbVo1OOA7fOewWI9IQ2pcFwlI2u1VWFBrYooRkgQYR1qGcg5Hp8R8p
         14IjdWIKSwv4MLasDtFZBxXg80sorPwBI+ydgtjoo8A1RNvSdgOdUiCHDvbeAVuD+d8t
         HK2sCNROn55CFGg5JpUOKckXkbWRXTqNPIrkBjZeikOeIxXOxSWTmAsqlKwWeCc+2ZNN
         0c4bvVYWHIhqSiog6NDL17TeNC0pGilUxnXOqEuvqrswz+ozExaS/TXCn2mrYZbNU9Ud
         hotw==
X-Gm-Message-State: AOAM531qRhx0lP6elDYeAAiL8VwMkrrJWRoNMFsFp08Vf8F3yisAUPRw
        BY4ReSvLSO6JdSp+U9OftdDf7g==
X-Google-Smtp-Source: ABdhPJxx6NyvG2fsYdmN2zSirxs9gy0pIsJfL6Og6f5DJJChFW6X5Rz1foSYclfTyBq1keYCPPbIhg==
X-Received: by 2002:ac2:43b1:: with SMTP id t17mr6013322lfl.373.1631544304232;
        Mon, 13 Sep 2021 07:45:04 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id i12sm849825lfb.301.2021.09.13.07.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 07:45:03 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 0/8] RTL8366(RB) cleanups part 1
Date:   Mon, 13 Sep 2021 16:42:52 +0200
Message-Id: <20210913144300.1265143-1-linus.walleij@linaro.org>
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
next 7 patches removes the very weird VLAN set-up with one
VLAN with PVID per port that has been in this driver in all
vendor trees and in OpenWrt for years.

The switch is now managed the way a modern bridge/DSA switch
shall be managed.

After these patches are merged, I will send the next set which
adds new features, some which have circulated before.

DENG Qingfang (1):
  net: dsa: rtl8366rb: Support bridge offloading

Linus Walleij (7):
  net: dsa: rtl8366: Drop custom VLAN set-up
  net: dsa: rtl8366rb: Rewrite weird VLAN filering enablement
  net: dsa: rtl8366rb: Always treat VLAN 0 as untagged
  net: dsa: rtl8366: Disable "4K" VLANs
  net: dsa: rtl8366rb: Fix off-by-one bug
  net: dsa: rtl8366: Fix a bug in deleting VLANs
  net: dsa: rtl8366: Drop and depromote pointless prints

 drivers/net/dsa/realtek-smi-core.h |   3 -
 drivers/net/dsa/rtl8366.c          | 113 ++++---------------------
 drivers/net/dsa/rtl8366rb.c        | 128 ++++++++++++++++++++++++++---
 3 files changed, 135 insertions(+), 109 deletions(-)

-- 
2.31.1

