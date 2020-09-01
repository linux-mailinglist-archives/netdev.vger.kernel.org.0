Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8211925A12D
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 00:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgIAWKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 18:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgIAWKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 18:10:02 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED89C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 15:10:01 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id v23so3457961ljd.1
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 15:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PNpdeAvyvBomkivi8B72RvY59fH03ofyy2JIKXAxA4c=;
        b=wUwgUtlP+KC44b6YeXKP7KygjzJUEdy6/ZTK37OFr89lyx341bIiOdNNykIAjE6SEy
         JO5IdPpd6N0x0uojgoG352Lii79ywKV88dzXtV2iXyKLjAR+VH2hThodIpNrvScdxJ81
         8GtsjDO02n7n4hGPlAHocwXnfSF1tfdGJMeRaKSJ1fP62ja0fB6VSFs3NA01Y709faAd
         KvxaYU01wms8zReIh5aUs+Y570N2oALQWkcOOSmyBcIFxpsC5qn01oTp30PdoSaDD378
         pat3IUStgR8WXvJecy41Wcwkp1HkUlr9PrUs9MypkQ33cKWfVs+Xqu4rXFw4U7N6aXML
         1aTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PNpdeAvyvBomkivi8B72RvY59fH03ofyy2JIKXAxA4c=;
        b=PAqkS4B8W2UbqBsQa39HBwCvVU9NyGby/8cuyDDp4guxZq8RlhL+qpjaY5wQua31Ha
         S0tuq1VdPo3CDlFIgxD76Ch7GZJh3nFWKtG/mMX9GK1EyeSqjq9Zd6Y+IPnOst35Au5o
         F9ntiiwerLaVvKGb0A1fmrhoRvIv/CtRSPKJ8S0CtprdRayb/uJe4ozayzII9RjPlBdJ
         miADhe3BJX2k3XZE6Sreo2qzsTgiR+DHv3jhgFDTnkg9S1dV0far880E8ThArLOFQfwv
         OVIgOBHJoIbAHk8YS0Bla5oM2ECrQTsAG37qlJPYMAtB1g5fyiBX8sqV6sZWJod3RmyA
         kCvA==
X-Gm-Message-State: AOAM5327VWjW8e2/A1V6SpknQV8sj3L7WXRVvwPF0E7w0e4kKt5qHvEl
        9yT/G39rv1TCjxPtfw1q8RJOxg==
X-Google-Smtp-Source: ABdhPJyGmY7MAkuTTF4sSIcDJ63LzdUsPeCZ7vCo3btpIVk7gAfZSy6FSck9+n9266gHWNMNKl3zyQ==
X-Received: by 2002:a2e:8193:: with SMTP id e19mr1820099ljg.80.1598998199613;
        Tue, 01 Sep 2020 15:09:59 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id z7sm568979lfc.59.2020.09.01.15.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 15:09:58 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>
Subject: [net-next PATCH 0/2 v3] RTL8366 stabilization
Date:   Wed,  2 Sep 2020 00:09:33 +0200
Message-Id: <20200901220935.45524-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This stabilizes the RTL8366 driver by checking validity
of the passed VLANs and refactoring the member config
(MC) code so we do not require strict call order and
de-duplicate some code.

Changes from v1: incorporate review comments on patch
2.

Changes from v2: a oneline bug fix in patch 2.

Linus Walleij (2):
  net: dsa: rtl8366: Check validity of passed VLANs
  net: dsa: rtl8366: Refactor VLAN/PVID init

 drivers/net/dsa/realtek-smi-core.h |   4 +-
 drivers/net/dsa/rtl8366.c          | 277 +++++++++++++++--------------
 2 files changed, 151 insertions(+), 130 deletions(-)

-- 
2.26.2

