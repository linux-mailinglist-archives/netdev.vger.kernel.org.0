Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A983216098
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgGFUw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgGFUw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:52:56 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A251DC08C5DF
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 13:52:55 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id f5so31366406ljj.10
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 13:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U2JMb1soWoZ8CNnH03zKY66F2Es/mXYrtq4AzAcz7DA=;
        b=z2C+2R7vzhwX7E7jZtVV2alCPFmVXaExwtJ29Fm944SDtTbFq4SKhttAHXq7s94PXq
         M7766r2UrEBjhHnwd8vVKvSXqe+1gZUGEWUJfWbzgZOtpaQF2KoS71rHjBr9gFFVqGKK
         SiYdMQByAAUoFMhWIo5IyglI7U5jP1X1f2lRv/5QdGz+tawGklV9TFkqlIyVeHj8CZIp
         7uaB4oT32QC1cMFvodebODYpfxGYPUmwGxu0ODKkB9VWgl3G2Xz/umjfuInimFDGYepV
         s088WMrOFRKV/DWwHw8Ss4gszNUUtZ7qobOMiFMJIGRv7tb8BImGCq8uW6vnQnAMlfbP
         5ayA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U2JMb1soWoZ8CNnH03zKY66F2Es/mXYrtq4AzAcz7DA=;
        b=AITziu61n6vzyEeMpVqdncnOKK5o+0x0N/tHssOvpvxNDVbM+1SBiSAeEs6FU47Hzk
         77tBXMw5TFpnOKdEowB362lYjLE9Fka6f/CN6g+VC4tKvdEyibRU/0A72HRFxCMmlRyT
         k48AWom/oNcbsl8cDH0h9sraRsp2gMml+TE/lXr4EzOfSRtTJ4cinJLrPD+movlZa3MB
         +fhjQPBDkDv1uDpsIJokQwPBV3+KvraINatHgB7TZcpXJjnRq58YtSncWKUuSEjVQrfG
         F8iTho0mv0cWwl+BCVBHYWXBpXPm1j6SJir7cPP6JvNd8rejKA+IvuqyI6tYa9/DW/wC
         FddQ==
X-Gm-Message-State: AOAM530659psxz9Nc0Jtc7gzh0C0pj6mXjeMk1vu+A404JG94rqVzO+I
        QK6zRixuTLeptVS9sHeen0VErfp8r4Ting==
X-Google-Smtp-Source: ABdhPJyeDzTig+YN4GHiCG7SpKPlh8ws0vghFYOr0VBRnlVKAglXI6aNv3HO5PPZjrYx77KeTV/Myg==
X-Received: by 2002:a05:651c:231:: with SMTP id z17mr6846195ljn.163.1594068773976;
        Mon, 06 Jul 2020 13:52:53 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id t10sm624714ljg.60.2020.07.06.13.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 13:52:53 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH 0/5 v4] RTL8366RB DSA tagging and fixes
Date:   Mon,  6 Jul 2020 22:52:40 +0200
Message-Id: <20200706205245.937091-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds rudimentary DSA tagging and fixes up some VLAN
issues in the RTL8366RB driver and in the RTL8366 core
in general.

This v4 fixes a single unused variable in patch 1/5.

Linus Walleij (5):
  net: dsa: tag_rtl4_a: Implement Realtek 4 byte A tag
  net: dsa: rtl8366rb: Support the CPU DSA tag
  net: dsa: rtl8366: Split out default VLAN config
  net: dsa: rtl8366: VLAN 0 as disable tagging
  net: dsa: rtl8366: Use top VLANs for default

 drivers/net/dsa/Kconfig     |   1 +
 drivers/net/dsa/rtl8366.c   | 135 +++++++++++++++++++++++----------
 drivers/net/dsa/rtl8366rb.c |  33 +++------
 include/net/dsa.h           |   2 +
 net/dsa/Kconfig             |   7 ++
 net/dsa/Makefile            |   1 +
 net/dsa/tag_rtl4_a.c        | 144 ++++++++++++++++++++++++++++++++++++
 7 files changed, 259 insertions(+), 64 deletions(-)
 create mode 100644 net/dsa/tag_rtl4_a.c

-- 
2.26.2

