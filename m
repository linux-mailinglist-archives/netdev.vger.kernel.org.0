Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3CA3F03B8
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbhHRMaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236552AbhHRMaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 08:30:04 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF025C0613CF
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 05:29:29 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q6so3255280wrv.6
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 05:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iI3L8EBOoJDYtVKe1PR50h7lO3aXxGfOfUrzTD91vss=;
        b=Cywe5nzK+TDaRmpC4zkauz6rbEMOHT1VFzU5fKtwwx/YHInatc0G+q1QT4HsPozqCY
         uymIODwryMEsEjoO4qIF4mEjevc702/O9Hvs3mzswpObZ17317c06I3uC1nZJnaMb1Hy
         o2CmGivAv6o2lVCpCpTtprUrkDnWVBqeWri8skjauVo89wuXAf9Pv4OwWybkSwrBwQgT
         SZF8YihE6L7R5HSsZSHu8WsaF1YKLzPn+dbWUpHG5IO6eob8Diwm0XNeS8fMRa9GBeQJ
         xtvJZsPOkM6Ax6VnzfDAyVJF0WpRzo51RCRa04Fwq/vj/kwn3MWM2nO3DSdAbUjobGSH
         d/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iI3L8EBOoJDYtVKe1PR50h7lO3aXxGfOfUrzTD91vss=;
        b=BDHpp9rNDW1TLJWqk6gv8Kp6JLRDcP7jHvEDtQERVTs60MlP3y5War35CcWHnCRTpa
         qo5pRqZDnr82/EJHPs/b/yG6hOcBxXbXvle3ohio0/autnSL8A6JjfffIsRC8Mbe+vV5
         Hpe+6kihnTeW359nthrajFZo7lOx5/uHlwFPC60foXjunFEncTjV6zjlilmS3tYfWRJT
         eNdoVYE3dzHWjL7dLid1+2Gz5SBSy+wFEKg3+wj4FviCM3wAGiq4utpeCvShcuq1S85B
         WpT5MdwNj8F9lIMm2vfTHQ3wvU+fsHsnUBgXwWSbpMpbC/esERaEZcx3x0YFteBnOqWw
         0h6A==
X-Gm-Message-State: AOAM531zXEs66FJIC7QVFSA2ErHvEC8tCJQHnIpNbcToUL1VLBcGZkda
        OouydGuTJla7aIgYUzQwmQdBFg==
X-Google-Smtp-Source: ABdhPJxvNwaGnbRf8RwTAngU+Uvf3zDf1HlVQn5HoMDzPiIwxkIYdpAwOAtbkXcZyIAQCEZVce3KmQ==
X-Received: by 2002:a5d:6045:: with SMTP id j5mr5650950wrt.0.1629289768399;
        Wed, 18 Aug 2021 05:29:28 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2el0lv6sxxeorz8a81-pd01.res.v6.highway.a1.net. [2001:871:23a:b9:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id u16sm5554869wmc.41.2021.08.18.05.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 05:29:27 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 0/2] Add Xilinx GMII2RGMII loopback support
Date:   Wed, 18 Aug 2021 14:27:34 +0200
Message-Id: <20210818122736.4877-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Xilinx GMII2RGMII driver overrides PHY driver functions in order to
configure the device according to the link speed of the PHY attached to it.
This is implemented for a normal link but not for loopback.

Andrew told me to use phy_loopback and this changes make phy_loopback work
in combination with Xilinx GMII2RGMII.

Gerhard Engleder (2):
  net: phy: Support set_loopback override
  net: phy: gmii2rgmii: Support PHY loopback

 drivers/net/phy/phy_device.c        |  9 +++---
 drivers/net/phy/xilinx_gmii2rgmii.c | 46 ++++++++++++++++++++++-------
 2 files changed, 39 insertions(+), 16 deletions(-)

-- 
2.20.1

