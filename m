Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A65325A0ED
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 23:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbgIAVn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 17:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgIAVny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 17:43:54 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D18BC061244;
        Tue,  1 Sep 2020 14:43:52 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k13so1205106plk.13;
        Tue, 01 Sep 2020 14:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hETCVNkUFaz2ei22FHADF5D/531PuX9nxpBpFN0mSX0=;
        b=EDFygNzgwGGqHq2IM2VzM32nO8EqO9S/2K1BVjlsJWm9xaaze7gY9ex06sZmEmgC+B
         QTRy0cRQRzRbTdnGlDJulhvsc0hvtD+NH8CyR7vVsqEJy7w8ChllHEqJymReU2HYPCUo
         KNrlMraJR8dJhx1QB4EhL+bNzv8j4iUt/iOB99VOHTTFX0SIM7wmAyNPyWGkYjUMp9Gf
         gH8c+JWrs4Dz4ZEsIYOl4LaKspgS/ZasRD5kP1O0ljs4g8BiodvZe8A1dvCb871XJQ4P
         4tRP0BjRelBoh42/SKi4mLpJK4zqehstuchXy8ts7553BS2p0+luWFDMmKD5IJYLiKjC
         M8Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hETCVNkUFaz2ei22FHADF5D/531PuX9nxpBpFN0mSX0=;
        b=Drd+CQGoA792w5E2MkNYDABN0Yw2jwjm/cIpGPE5TXfErGBNBkVdYUwByZRirn4cJN
         DaBplML1LJQQo1tC1Ignsr/0xLm9uYwlvEnVmbbV4u9BDcFjkrmUZ2L74Eg9tTWSfpsj
         0vCoHWlLEg1A93VPulkyD5B5dijQKVmcbZeUc62zIhyqIPsuYJ8qNL3Q7DKT4GnjMRYo
         tQL4Ow5V20sidn7+FZ2Yz8IZ0x7knS4072fZ+w7TCztB1zJjAtMCipuY3XTyBaU1VvJ/
         pTIVktL138qfLMFSCwCn3yJgW5hAnIyllbLKYTQxJUU2BEYJ4XUlL01uEga5AV26ypwD
         sxbw==
X-Gm-Message-State: AOAM533nYINWMnvh4IumpWbGIuFdy1MW5OKRCAo3QNOAeiErse14AHZO
        mfLjrchspy7q15CcTYMxVdM2OLRI7Ys=
X-Google-Smtp-Source: ABdhPJxQty9xHS4RTpNNNNe76LF7bg38cBLXP7gJPBEtr2RTZX4BLRb4PjPASRHJFYe7OWjVugi9HA==
X-Received: by 2002:a17:90b:289:: with SMTP id az9mr3537548pjb.31.1598996631863;
        Tue, 01 Sep 2020 14:43:51 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 131sm128663pfy.5.2020.09.01.14.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 14:43:50 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM SYSTEMPORT
        ETHERNET DRIVER)
Subject: [PATCH net-next 0/3] net: systemport: Clock support
Date:   Tue,  1 Sep 2020 14:43:45 -0700
Message-Id: <20200901214348.1523403-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

This patch series makes the SYSTEMPORT driver request and manage its
main and Wake-on-LAN clocks appropriately.

Florian Fainelli (3):
  dt-bindings: net: Document Broadcom SYSTEMPORT clocks
  net: systemport: fetch and use clock resources
  net: systemport: Manage Wake-on-LAN clock

 .../bindings/net/brcm,systemport.txt          |  5 +++
 drivers/net/ethernet/broadcom/bcmsysport.c    | 40 ++++++++++++++++++-
 drivers/net/ethernet/broadcom/bcmsysport.h    |  2 +
 3 files changed, 45 insertions(+), 2 deletions(-)

-- 
2.25.1

