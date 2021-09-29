Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A1741CDC5
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 23:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345994AbhI2VHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 17:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345930AbhI2VHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 17:07:38 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3807C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:05:56 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id z24so16087978lfu.13
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+6tJhw/rr29jqrzuGqPjz05j1cAdlxDIEkH2kVn9cEI=;
        b=KhxDN53dKkeppF9epJ8K++q7mNPxv7Bz6E7YxyQW2DIxpIP++u2CNmMXEyTeoik9cc
         G/PXq53SLBKDNFuZIdeYHOY7pILnPDbe5OAlaCsMShY1swesevUnP1+OlAmRI+L1K9bv
         RZ7trC0luV5bFxnGC0t7nhQawy2vh+2RDVIDePGcfDL63y1S1TPdj7LtfuHwqc1eNS4Z
         PAZTlJG2CE/39aP9+MQJAn0hpUfUYaaogjaevaVWPnt22xmRU3miG6F/3kCUOVee/0wR
         7Y57RC3hxmu1jOknhIWOHsbDsC5NlhCGcwqNhZ/YZ089Y4/ymhuo2nlkNz1GnyYq5Gul
         HkEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+6tJhw/rr29jqrzuGqPjz05j1cAdlxDIEkH2kVn9cEI=;
        b=hAtLxnVo4nQLTnGtMB+7gmGq5kyHKGsZXz6xZsERu0hjUvrdbuaBfWS6jvr+ceKT2T
         5JT0ZRP1P9oK12P0Y1nTp2mgKJjQfZpvLPbmc3PaSpeqH4vFCJ18qcHKll0XAe8O3xaW
         VMt7vPAxZ4fgdGMV2OSlLlAWkJKr/TaCFSQDCzFhJW3kTZdcTHSsEChTEuLfy2ayTPqU
         xcyi2wpqV7zW3elM8mJG3VYOMRjR0l4QxXiIEO2C3LvOS/zdEt/aU8bN2e7WpwhFm4wy
         SwHGr9SoCkok9RFJ2wMCA+pGJd0KLOMpUdLoZG8kBQyHuoaID8ejobRHRUXHdP0173yY
         1DQg==
X-Gm-Message-State: AOAM532QHACdUr3T9YtJ+3Wgvh0ioIr9DSYPPLaEEytHCsLPBSpxSHNW
        sdz4RNnpUqA7oVkB+fdNlSD62w==
X-Google-Smtp-Source: ABdhPJxpbLMCW2/tEzGvKpcHzaFC7oyYeCmi5FU8Te8VpuzcMkY1qvMo5ljl7bkqQIEHmoRIvinxMg==
X-Received: by 2002:ac2:5606:: with SMTP id v6mr1759823lfd.520.1632949555081;
        Wed, 29 Sep 2021 14:05:55 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id s9sm112613lfp.291.2021.09.29.14.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 14:05:54 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 0/4 v4] RTL8366RB enhancements
Date:   Wed, 29 Sep 2021 23:03:45 +0200
Message-Id: <20210929210349.130099-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is a set of reasonably mature improvements
for the RTL8366RB switch, implemented after Vladimir
challenged me to dig deeper into the switch functions.

ChangeLog -> v4:
- Rebase earlier circulated patches on the now merged
  VLAN set-up cleanups.

Linus Walleij (4):
  net: dsa: rtl8366rb: Support disabling learning
  net: dsa: rtl8366rb: Support flood control
  net: dsa: rtl8366rb: Support fast aging
  net: dsa: rtl8366rb: Support setting STP state

 drivers/net/dsa/rtl8366rb.c | 162 ++++++++++++++++++++++++++++++++++--
 1 file changed, 156 insertions(+), 6 deletions(-)

-- 
2.31.1

