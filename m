Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7504341B24B
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 16:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241376AbhI1Opp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 10:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241152AbhI1Opo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 10:45:44 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B5FC06161C
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 07:44:04 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id b15so92086402lfe.7
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 07:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fU97reShB9fGHn2jTKQX3rdQzaCG4O5OGr/DmkqBnu0=;
        b=DEDNI6hlF0RjvgmAhajWy0lhJrda655o1MNUs3b/30KvS5jMCkYPCwfRC784PWgraM
         N+JoQVAmqhMYqxTDZAhCj/SGwLVxiwYpFrOHloF0sODWtLOzBGZL9yB4ysleRkO0S7VO
         0yt0kAcjbTcr8RzV3fVlmFG86TTpQpJuk1NGlHkP58poyvkZ1nsS65Rbge+foqELG9km
         A9RAMUPZBelwGx/ahzLUExKkhhI95aaSHJeyTMn4Yikao9mTnBGCTJoMRDBLdskUfCw5
         xbCKXHmu47FZp22yexR50OYuAm/YCmOHVZXvFFvwcobDPZnNQSGAvOcnsIUNpgt2BczB
         wU4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fU97reShB9fGHn2jTKQX3rdQzaCG4O5OGr/DmkqBnu0=;
        b=a4c6JAty4ncH0OsNfz/AbKscOcQqBnELr6IkD9HgIqB1ZyPhtkdFXfwjwS1gILyVaH
         d4QbMXSVIZYzNmosg/lQCzBIakeNQEvSH56T+buBeBK6IPBuznoaMzycJTRz4U0rt1Pt
         yJINQC2v9kvx9b9zN7Zn50AYxQqlkVk5WFxPE3jSnbqwRTukMjTufHfI3BL+raytLYL1
         LRV84fqqpUwJJwF8FFLK8kmHeztlLnpuGtcnhf5H2FadRKXtSzKFwrVFr+7mjbDKU0Aw
         OVt48HCffg8wywupsBZNjSK/UNu7VE461us0h3RUP3llb3tPFVgaWS7LobAB+n13/yls
         0GSA==
X-Gm-Message-State: AOAM532bs7IJtBr6bcwMudV+wVKP8KOwAqXOk5Fs3sduRaszqsos73KK
        q6DZFHFUU2+pmN8siVQABoJvWQ==
X-Google-Smtp-Source: ABdhPJx3+9ec6+h4ATKQUicKCZJl706Im5Gxr+22Q23Fqmw5WFiLclAJLdWLnUuh6KoVnztyMF+bzA==
X-Received: by 2002:a2e:b6cf:: with SMTP id m15mr362655ljo.224.1632840233067;
        Tue, 28 Sep 2021 07:43:53 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id x23sm1933462lfd.136.2021.09.28.07.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 07:43:52 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 0/6 v8] RTL8366(RB) cleanups part 1
Date:   Tue, 28 Sep 2021 16:41:43 +0200
Message-Id: <20210928144149.84612-1-linus.walleij@linaro.org>
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

ChangeLog v7->v8:
- Keep track of filtering state using the core instead of
  tracking it in the driver.
- Minor spelling etc.

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
 drivers/net/dsa/rtl8366.c          |  96 +--------------
 drivers/net/dsa/rtl8366rb.c        | 189 +++++++++++++++++++++++++++--
 3 files changed, 183 insertions(+), 105 deletions(-)

-- 
2.31.1

